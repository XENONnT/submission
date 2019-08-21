# submission
A simple submission script to wrap your exectuable into a singularity container for Dali/Midway. Standard submission to a batch job at Dali which is executed within a XENONnT singularity container ('latest'). Your submission scripts or executables must be stored at a location which is accessable from a Dali/Midway computing node. Note that path declarations within your scripts and executables must be absolute paths.

All batch submission scripts and the log file to monitor the output to the terminal are stored in your home directory `(~/.tmp_job_submission/)`.

## Where to find it
The submission script is found on the shared dali partition `/dali/lgrandi/xenonnt/submission/`

## How to submit a job
Assume your own python script is located under:

```
/home/USER/select.py --input test --output runner
```

You can submit your script from every node (Midway/Dali) and python environment with:

```
/dali/lgrandi/xenonnt/submission/submit.py --job JOBNAME --command "/home/USER/select.py --input test --output runner"
```

The output is supposed to be:
```
>Your batch submission script:
>-----------------------------
>#!/bin/bash
>#SBATCH --job-name=test1
>#SBATCH --output=/home/USER/.tmp_job_submission/tmpP7TBMD
>#SBATCH --error=/home/USER/.tmp_job_submission/tmpP7TBMD
>#SBATCH --account=pi-lgrandi
>#SBATCH --ntasks=1
>#SBATCH --cpus-per-task=4
>#SBATCH --mem-per-cpu=4480
>#SBATCH --time=02:00:00
>#SBATCH --qos dali
>#SBATCH --partition dali


>echo Starting batch job

>/dali/lgrandi/xenonnt/submission/xnt_environment osgvo-xenon:latest python /home/USER/select.py --input test --output runner
>-----------------------------


>Start job...
>------------
>job_fn_name: /home/USER/.tmp_job_submission/tmp74jfwV
>Job name:  test1
>Job id:  61982108
>Log:  /home/USER/.tmp_job_submission/tmpP7TBMD
```

All you need to do is to remember the job id and the log file to check the output. The output folder for storing the batch submission scripts and the log files are created automatically in your home directory. Explore more option with `--help`. GPU is not tested/supported.

## How to find your job?
The batch submitter allows you to find you jobs again by three simple commands:

### Find by job name or job id
The job id is unique for each job at SLURM. The job name can help you to identify a job but be careful, it is not unique by construction.
```
[~]$ /dali/lgrandi/xenonnt/submission/submit.py --find-id 61982108
Look up jobs by ID 61982108
Your batch submission history:
------------------------------
  <> Name        : test1
  <> ID          : 61982108
  <> Start       : 08/21/2019-06:24:25
  <> Batch script: /home/USER/.tmp_job_submission/tmp74jfwV (467 bytes)
  <> Batch output: /home/USER/.tmp_job_submission/tmpP7TBMD (0 bytes)
     ------------
--Hint:
 - Size in bytes for batch output indicates if job has started already

```

```
[~]$ /dali/lgrandi/xenonnt/submission/submit.py --find-job test1
Look up jobs by name test1
Your batch submission history:
------------------------------
  <> Name        : test1
  <> ID          : 61982108
  <> Start       : 08/21/2019-06:24:25
  <> Batch script: /home/USER/.tmp_job_submission/tmp74jfwV (467 bytes)
  <> Batch output: /home/USER/.tmp_job_submission/tmpP7TBMD (0 bytes)
     ------------
--Hint:
 - Size in bytes for batch output indicates if job has started already

```

### List commands:
You can look at the history of your submitted jobs to identify a batch output file again if you need to look at the output. This opition is done with `--list all`

```
[~]$ /dali/lgrandi/xenonnt/submission/submit.py --list all
Your batch submission history:
------------------------------
  <> Name        : test1
  <> ID          : 61982108
  <> Start       : 08/21/2019-06:24:25
  <> Batch script: /home/USER/.tmp_job_submission/tmp74jfwV (467 bytes)
  <> Batch output: /home/USER/.tmp_job_submission/tmpP7TBMD (0 bytes)
     ------------
  <> Name        : job44
  <> ID          : 61981609
  <> Start       : 08/21/2019-04:43:20
  <> Batch script: /home/USER/.tmp_job_submission/tmpFfH_4l (444 bytes)
  <> Batch output: /home/USER/.tmp_job_submission/tmpE7YzQ7 (7343 bytes)
     ------------
  <> Name        : BtJ-0
  <> ID          : 61981508
  <> Start       : 08/21/2019-04:15:11
  <> Batch script: /home/USER/.tmp_job_submission/tmpIHMMwG (438 bytes)
  <> Batch output: /home/USER/.tmp_job_submission/tmpFIKOPN (605 bytes)
--Hint:
 - Size in bytes for batch output indicates if job has started already
```

The alternative is to look at the SLURM batch queue for submitted jobs. Nevertheless if these jobs have started already or not. The option for this is `--list ongoing`

```
[~]$ /dali/lgrandi/xenonnt/submission/submit.py --list ongoing
Your batch submission history:
------------------------------
  <> Name        : test1
  <> ID          : 61982108
  <> Start       : 08/21/2019-06:24:25
  <> Batch script: /home/USER/.tmp_job_submission/tmp74jfwV (467 bytes)
  <> Batch output: /home/USER/.tmp_job_submission/tmpP7TBMD (0 bytes)
     ------------
--Hint:
 - Size in bytes for batch output indicates if job has started already
```
## Clean up your batch submission history:
You might not like to keep your batch submission history forever. You can clean it up by:

```
[~]$ /dali/lgrandi/xenonnt/submission/submit.py --clean
```
It will delete all batch submission scripts and log file in your `~/.tmp_job_submission/` which are not queued in your SLURM queue. Exception is the file `jobDB.csv`. Delete manually if it becomes to large!