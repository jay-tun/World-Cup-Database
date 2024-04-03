#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #INSERT teams table
  # get winner team
  if [[ $WINNER != "winner" ]]
  then
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE ='$WINNER'")

    # if not found
    if [[ -z $TEAM_NAME ]]
    then
      # insert winner team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi

  #get opponent team
  if [[ $OPPONENT != "opponent" ]]
  then
    OPP_TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE ='$OPPONENT'")

    # if not found
    if [[ -z $OPP_TEAM_NAME ]]
    then
      # insert opponent team
      INSERT_OPP_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPP_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi


  #Insert games table
  if [[ YEAR != "year" ]]
  then
    #winner id 
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #fill the rows 
    INSERT_GAME = $($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")
    
    if [[$INSERT_GAME == "Insert 0 1" ]]
    then 
      echo New game added: $YEAR, $ROUND scoring $WINNER_GOALS : $OPPONEN_GOALS between $WINNER_ID and $OPPONENT_ID
    fi
  fi

done
