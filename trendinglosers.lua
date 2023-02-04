 
 -- "trendinglosers" Created by Shermhead - original -> https://github.com/shermhead/dicebot-scripts/blob/master/trendinglosers.lua
 -- Modified Version by Viblaxx.
 
target   = balance*2

chance   = 55
div      = 40000 --balance divisor for basebet
basebet	 = balance/div
prebet 	 = 0.00000010--prebet (often minimum bet)

a        = 0
multi    = 0
payout   = 0

nextbet  = basebet
nextbet  = prebet

sens66   = 0.93 --sensitivity
sens50   = 0.94 --sensitivity
sens33   = 0.95 --sensitivity
sens25   = 0.96 --sensitivity
sens10   = 0.97 --sensitivity

lstreak  = 0
ls 		 = 20

mod2     = 2 --sample size multiple

streakcnt = 0

rec10    = {0}
rec10cnt = 0
rec25    = {0}
rec25cnt = 0
rec33    = {0}
rec33cnt = 0
rec50    = {0}
rec50cnt = 0
rec66    = {0}
rec66cnt = 0

initcnt  = 0

-- resetseed()
-- resetstats()

-- sample size
samples = {rec10, rec25, rec33, rec50, rec66}
size 	= 101 -- last 100 bets

--10x function
  function add10 (t)
      local sum = 0
      for i,v in ipairs(rec10) do
        sum = sum + v
      end
      return sum
    end
  --5x function
  function add25 (t)
      local sum = 0
      for i,v in ipairs(rec25) do
        sum = sum + v
      end
      return sum
    end
  --3x function
    function add33 (t)
      local sum = 0
      for i,v in ipairs(rec33) do
        sum = sum + v
      end
      return sum
    end
    --2x function
    function add50 (t)
      local sum = 0
      for i,v in ipairs(rec50) do
        sum = sum + v
      end
      return sum
    end
    --1.5x function
    function add66 (t)
      local sum = 0
      for i,v in ipairs(rec66) do
        sum = sum + v
      end
      return sum
    end

function dobet()
	sleep(0.1)


    basebet = balance/div
	
    if win then 
		chance=55 
		bethigh=false 
	end

    initcnt+=1

  --1.5x routine
    if lastBet.roll>66 then
        table.insert(rec66,1,"1")
    else 
		table.insert(rec66,1,"0")
    end
	
    rec66cnt = ((add66(rec66)/#rec66))   
	
    if math.floor(33*sens66/rec66cnt)>=100 	then 
		chance=66 
		bethigh=true 
	end

 
  --2x routine
    if lastBet.roll>50 then
        table.insert(rec50,1,"1")
    else 
		table.insert(rec50,1,"0")
    end
	
    rec50cnt = ((add50(rec50)/#rec50))
    if math.floor(50*sens50/rec50cnt)>=100 then 
		chance=50 
		bethigh=true 
	end  
				
  --3x routine
    if lastBet.roll>33 then
        table.insert(rec33,1,"1")
    else 
		table.insert(rec33,1,"0")
    end
	
    rec33cnt = ((add33(rec33)/#rec33))
    if math.floor(66*sens33/rec33cnt)>=100 then 
		chance=33 
		bethigh=true 
	end
    
  --5x routine
    if lastBet.roll>25 then
        table.insert(rec25,1,"1")
    else 
		table.insert(rec25,1,"0")
    end
	
    rec25cnt = ((add25(rec25)/#rec25))    
    if math.floor(75*sens25/rec25cnt)>=100 then 
		chance=25 
		bethigh=true 
	end

   --10x routine
    if lastBet.roll>10 then
        table.insert(rec10,1,"1")
    else 
		table.insert(rec10,1,"0")
    end
	
    rec10cnt = ((add10(rec10)/#rec10))    
    if math.floor(90*sens10/rec10cnt)>=100 then 
		chance=10 
		bethigh=true 
	end
    
--bet armount routine

if win then
	a = 0 
	nextbet = basebet  
	lstreak = 0
else
    a = a-currentprofit
	payout  = (100-1)/chance
	multi   = payout/(payout-1)
	nextbet = (a/(payout/multi))/1.5
	
	if(lstreak==ls) then      
      chance  = 60
	  
    end
	
	lstreak = lstreak+1
end 

-- sample size

for _, table_ in pairs(samples) do
   if table_[size] then
      table.remove(table_, size)
   end
end 
    
	
if nextbet < basebet then 
	nextbet = basebet 
end

-- output

	if initcnt>90*mod2 then 
	
		print("\n")
		print("\tTarget 1.5x... %"..math.floor(33*sens66/rec66cnt))
		print("\tTarget 2x..... %"..math.floor(50*sens50/rec50cnt))
		print("\tTarget 3x..... %"..math.floor(66*sens33/rec33cnt))
		print("\tTarget 4x..... %"..math.floor(75*sens25/rec25cnt))
		print("\tTarget 10x.... %"..math.floor(90*sens10/rec10cnt))
		print("\n")
		print("\t######################")
		--print("1.5x #"..#rec66)
		--print("2x #"..#rec50)
		--print("3x #"..#rec33)
		--print("4x #"..#rec25)
		--print("10x #"..#rec10)
	end
	
--init and fixes 

if bets%10000==0 then resetseed() initcnt=0 end

	if initcnt<90*mod2 then 
		print("░▒▓█ Initializing %"..math.floor(initcnt/(90*mod2)*100).." █▓▒░") 
		chance  = 55
		nextbet = prebet
    end
	
if (chance)==55 then nextbet=prebet end

	nextbet = math.floor(nextbet*10^8)/10^8

if nextbet<=prebet then nextbet=prebet end

    if balance>=target then 
		stop() print("You win!") 
    end
   
end
