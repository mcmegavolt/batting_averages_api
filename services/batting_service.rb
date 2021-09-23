# frozen_string_literal: true

class BattingService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def initialize(players, filters)
    @players = players
    @filters = filters
    @teams = Team.select_hash_groups(:teamID, :name)
  end

  def call
    merge_team_names
    apply_filters
    generate_stats
  end

  private

  def merge_team_names
    @players.map! do |player|
      player['teamNames'] = @teams[player['teamID']].uniq
      player
    end
  end

  def apply_filters
    @players.select! { |row| row['yearID'] == @filters[:year].to_s } if @filters[:year]
    @players.select! { |row| row['teamNames'].include?(@filters[:team_name]) } if @filters[:team_name]
  end

  def generate_stats
    result = []

    grouped_players = @players.group_by { |row| [row['playerID'], row['yearID']] }

    grouped_players.each do |player_year, attrs|
      player, year = player_year
      team_names = @teams[attrs.first['teamID']].uniq.join(', ')

      result << calculate_player_stats(player, year, attrs, team_names)
    end

    result.sort_by { |hsh| hsh[:batting_average] }
  end

  def calculate_player_stats(player, year, attrs, team_names)
    hits_total = attrs.map { |h| h['H'].to_f }.inject(:+)
    at_bats_total = attrs.map { |h| h['AB'].to_f }.inject(:+)
    batting_average = (hits_total / at_bats_total).round(3)

    {
      player: player,
      year: year,
      team: team_names,
      batting_average: (batting_average.nan? ? 0 : batting_average)
    }
  end
end
