`export HAB_ORIGIN=xxxxx`
`echo $HAB_ORIGIN`
- git clone repository
- update habitat/plan.sh with mbohl as origin
- hab studio enter
- build

Start services directly from the Studio* using the Habitat Supervisor, or
- Export the .hart to a Docker image and use docker run.
    * hab pkg export docker ./results/<path to .hart>
    `hab pkg export docker ./results/mbohl-sample-node-app-1.1.0-20180731171148-x86_64-linux.hart`
exit (studio)

`docker run -it -p 8000:8000 mbohl/sample-node-app`

- Preview the application in your browser
Finally, go to http://localhost:8000 in your browser to see the sample application UI (screenshot below).
http://40.124.40.145:8000