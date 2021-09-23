# Batting Averages API

> This application is designed as a test item, which is described [here](https://github.com/jzajpt/hiring-exercises/blob/master/batting-averages/README.backend.md)

---

### How to use

1. Install bundler gem: `gem install bundler`
2. Install dependencies: `bundle`
3. Run server: `rackup`
4. Make a POST request (`filter_by` params are optional):

```
curl --location --request POST 'http://127.0.0.1:9292/calculate' \
--form 'file=@"/path/to/file/batting.csv"' \
--form 'filter_by[year]="1871"' \
--form 'filter_by[team_name]="Troy Haymakers"'
```

### Warnings

* [batting.csv](support_files/batting.csv) file is 6.6 Mb, please use `filter_by` params to decrease a response time and body size.
