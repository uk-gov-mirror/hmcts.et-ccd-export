# ET to CCD Exporter

This application is to be used alongside the Employment Tribunals API service.  It shares the same redis connection
for sidekiq.

It works by monitoring a queue called external_system_ccd - whenever a worker called ExternalSystemExportWorker is
queued, it will be executed by this application and the data sent to CCD.

## Configuration

The application must be configured to use the same redis details as the API service.  See the environment variables below

### Environment Variables

1. The redis config can be configured using the following to allow just the port to be overriden (useful for local development)
   REDIS_HOST (defaults to localhost)
   REDIS_PORT (defaults to 6379)
   REDIS_DATABASE (defaults to 1)

   You can change any of these individually or you can ignore these by setting the full
   REDIS_URL in the traditional way - such as :-

   ```

   REDIS_URL=redis://localhost:6379/12

   ```

   If your redis server needs a password, it must be specified using

   ```
   REDIS_PASSWORD=<your password>

   ```

2. Simulation mode - where no data is transferred, but just logged can
   be enabled using :-
   
   ```
   ET_CCD_SIMULATION=true
   ```
   
3. Logging levels can be changed using the following (note that
   this is not a rails app, but I have kept the same naming
   convention as a rails app)
   
   ```
   RAILS_LOG_LEVEL=debug
   ```
   
   values are debug (noisiest) , info, warn, error and fatal (quietist)

4. Disabling 'sidekiq_alive' (provides a http server to sense
   if sidekiq is running or not - used in deployment) can be done
   as follows :-
   
   ```
   DISABLE_SIDEKIQ_ALIVE=true
   ```
   
   To re enable you must completely remove this env var

## Running

First, clone this repository into et-ccd-export

Then

```

cd et-ccd-export

./bin/setup

```

then

```

./bin/sidekiq --config config/sidekiq.yml



```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
