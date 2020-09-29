import { Visual } from "../../src/visual";
import powerbiVisualsApi from "powerbi-visuals-api"
import IVisualPlugin = powerbiVisualsApi.visuals.plugins.IVisualPlugin
import VisualConstructorOptions = powerbiVisualsApi.extensibility.visual.VisualConstructorOptions
var powerbiKey: any = "powerbi";
var powerbi: any = window[powerbiKey];

var hexchartpercentAB639D1981F8428DA4BEF8F6688AC016: IVisualPlugin = {
    name: 'hexchartpercentAB639D1981F8428DA4BEF8F6688AC016',
    displayName: 'hexchart_percent',
    class: 'Visual',
    apiVersion: '2.6.0',
    create: (options: VisualConstructorOptions) => {
        if (Visual) {
            return new Visual(options);
        }

        throw 'Visual instance not found';
    },
    custom: true
};

if (typeof powerbi !== "undefined") {
    powerbi.visuals = powerbi.visuals || {};
    powerbi.visuals.plugins = powerbi.visuals.plugins || {};
    powerbi.visuals.plugins["hexchartpercentAB639D1981F8428DA4BEF8F6688AC016"] = hexchartpercentAB639D1981F8428DA4BEF8F6688AC016;
}

export default hexchartpercentAB639D1981F8428DA4BEF8F6688AC016;