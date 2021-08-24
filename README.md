[![License](https://img.shields.io/github/license/LiquidGalaxyLAB/image-satellite-visualizer.svg)](https://opensource.org/licenses/Apache-2.0) [![github-languages-image](https://img.shields.io/github/languages/top/LiquidGalaxyLAB/image-satellite-visualizer.svg?color=red)]() [![github-language-count-image](https://img.shields.io/github/languages/count/LiquidGalaxyLAB/image-satellite-visualizer.svg)]() [![Issues](https://img.shields.io/github/issues/LiquidGalaxyLAB/image-satellite-visualizer.svg)](https://github.com/LiquidGalaxyLAB/image-satellite-visualizer/issues) [![forks](https://img.shields.io/github/forks/LiquidGalaxyLAB/image-satellite-visualizer.svg)]() [![github-repo-size-image](https://img.shields.io/github/repo-size/LiquidGalaxyLAB/image-satellite-visualizer.svg?color=yellow)]()

## Image Satellite Visualizer

![Project Logo](/assets/image_satellite_visualizer_logo.png)

Liquid Galaxy as a meaningful presentation tool has a lot of information that can be displayed for diverse purposes like an educational tool, or for a monitoring system. With that in mind, the idea of ​​the project is the real time visualization of satellite images that would be attached as layers of google earth, besides being able to have diverse information of the earth being graphically generated as storms, fires, masses of heat and water vapor, a synchronous earth visualization will allow for more complex interactions. From there, the entire application would be controlled through a script responsible for managing calls made to the satellite's external APIs (e.g. NASA API and Copernicus) that responses with the metadata necessary for the kml creation and a tablet application that would give the user control of which layers or information would like to be displayed and responsible for handling the API calls, manipulate KMLs and sending them to Liquid Galaxy through Bash scripts. The application’s front end will be developed with Flutter and the image selected by the user will be generated based on selected options.

![Project Logo](/assets/lgGifTemplate.png)


### 📖 Tutorial
To use all features avaiable on the app a Liquid Galaxy system is required.

For running the project locally, follow the commands:

```bash
flutter pub get
```

```bash
flutter run --no-sound-null-safety
```

After you install the application, the first screen you get is the dashboard where you can (right now) delete and create new images. To create a new image follow the steps:

 - Click the '+' floating action button

 - Select the API that you want to use (NASA, Copernicus or Sentinel Hub)
 - Set the date and coordinates or click the 'Get Locations' button to open google maps
    - For google maps click the polygon button to activate the coordinates selection




    - Tap on two locations at the map to generate a polygon with the selected area
 - Select the layer that you want to use
 - After the image preview is loaded, set the name and description

 ### 🌐 APIS

NASA: https://wiki.earthdata.nasa.gov/display/GIBS/GIBS+API+for+Developers

Sentinel Hub: https://www.sentinel-hub.com/develop/api/ogc/

Copernicus: https://scihub.copernicus.eu/userguide/OpenSearchAPI

### 📊 APIs Quotas

Sentinel Hub Quotas
* Request
  * 100 000 / month
  * 300 / min
* Processing
  * 30 000 / month
  * 300 / min

Both NASA and Copernicus have open APIs with no request limits

