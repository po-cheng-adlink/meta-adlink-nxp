## Scarthgap

- Kernel version: 6.6.x
- Kernel support by Adlink(continuing).
- Manifest of the Yocto BSP is [here](https://github.com/ADLINK/adlink-manifest).



### 1. Supported Recipes by Adlink

| Resources                      | Description |
| ------------------------------ | ----------- |
| conf                           |  Machine file and configuration files                                        |
| recipes-adlink                 |  Adlink tool recipes                                                         |
| recipes-bsp                    |  Bootloader related recipes                                                  |
| recipes-connectivity           |  Libraries and applications related to communication with other devices      |
| recipes-extended               |  Application which are not essentially but useful for testing and debugging  |
| recipes-fsl                    |  BB append files related to FSL receipe                                      |
| recipes-kernel                 |  Kernel related configuration changes and patches                            |
| recipes-multimedia             |  Codecs and support utilties for audio, images and video                     |
| recipes-nnstreamer/nnshark     |  nnstreamer related append file                                              |
| recipes-tools                  |  Adlink Related tools                                                        |
| wic                            |  Wic file for Image creation                                                 |



### 2. Supported Modules

- LEC-IMX8MP
- LEC-IMX8MM
- LEC-IMX95
- OSM-IMX93
- OSM-IMX95
- SP2-IMX8MP

### 3. Supported Features & Interfaces

<details>
<summary><strong>LEC-IMX8MP</strong> (Based on I-Pi SMARC Plus Carrier + LEC-IMX8MP Dev Kit)</summary>
  
| Interfaces                                 | Support |
| ------------------------------------------ | ------- |
| RAM [LPDDR4(2G)]                           | Y       |
| NPU(Optional)                              | Y       |
| MIPI-DSI [auo-b101uan01v7]                 | Y       |
| LVDS [hydis-hv150ux2]                      | Y       |
| Cameras [OV5640,OV13855]                   | Y       |
| GPU                                        | Y       |
| VPU                                        | Y       |
| HDMI                                       | Y       |
| eMMC                                       | Y       |
| SEMA 4.0                                   | Y       |
| Debug Header                               | Y       |
| Audio [tlv320aic3x]                        | Y       |
| Ethernet - 0 & 1                           | Y       |
| Wi-Fi(optional) [Azurewave AW-CM276NF]     | Y       |
| Bluetooth(optional) [Azurewave AW-CM276NF] | Y       |
| PCIe                                       | Y       |
| USB 2.0                                    | Y       |
| USB 3.0                                    | Y       |
| SER                                        | Y       |
| CAN                                        | Y       |
| SPI                                        | Y       |
| I2S                                        | Y       |
| I2C                                        | Y       |
| GPIO                                       | Y       |
| SDIO                                       | Y       |

</details>

<details>
<summary><strong>LEC-IMX8MM</strong> (Based on I-Pi SMARC Carrier + LEC-IMX8MM Dev Kit)</summary>

| Interfaces                                 | Support |
| ------------------------------------------ | ------- |
| RAM [LPDDR4(1G/2G/4G)]                     | Y       |
| MIPI-DSI [auo-b101uan01v7]]                | Y       |
| LVDS [hydis-hv150ux2]                      | Y       |
| Cameras [OV5647,OV13855]                   | Y       |
| GPU                                        | Y       |
| VPU                                        | Y       |
| HDMI                                       | Y       |
| eMMC                                       | Y       |
| SEMA 4.0                                   | Y       |
| Debug Header                               | Y       |
| Audio [WM8960,tlv320aic3x]                 | Y       |
| Ethernet - 0 & 1                           | Y       |
| Wi-Fi(optional) [Azurewave AW-CM276NF]     | Y       |
| Bluetooth(optional) [Azurewave AW-CM276NF] | Y       |
| PCIe                                       | Y       |
| USB 2.0                                    | Y       |
| SER                                        | Y       |
| CAN                                        | Y       |
| SPI                                        | Y       |
| I2S                                        | Y       |
| I2C                                        | Y       |
| GPIO                                       | Y       |
| SDIO                                       | Y       |

</details>

<details>
<summary><strong>LEC-IMX95</strong> (Based on I-Pi SMARC Plus Carrier + LEC-IMX95 Dev Kit)</summary>

Coming soon...

</details>

<details>
<summary><strong>OSM-IMX93</strong> (Based on SB3 Carrier + OSM-IMX93 Dev Kit)</summary>

Coming soon...

</details>

<details>
<summary><strong>OSM-IMX95</strong> (Based on EB4 Carrier + OSM-IMX93 Dev Kit)</summary>
  
Coming soon...

</details>

<details>
<summary><strong>SP2-IMX8MP</strong>(SBC + LVDS/MIPI-DSI Display Panel)</summary>

| Interfaces                                 | Support |
| ------------------------------------------ | ------- |
| RAM [LPDDR4(2G/4G/8G)]                     | Y       |
| MIPI-DSI [7", 7"RLCD]                      | Y       |
| LVDS [7", 10"]                             | Y       |
| GPU                                        | Y       |
| VPU                                        | Y       |
| HDMI                                       | Y       |
| eMMC                                       | Y       |
| Debug Header                               | Y       |
| Audio [sgtl5000]                           | Y       |
| Ethernet - 0 & 1                           | Y       |
| Wi-Fi(optional) [Azurewave AW-CM276MA]     | Y       |
| Bluetooth(optional) [Azurewave AW-CM276MA] | Y       |
| PCIe                                       | Y       |
| USB 2.0/3.0                                | Y       |
| SER                                        | Y       |
| CAN                                        | Y       |
| SPI                                        | Y       |
| I2S                                        | Y       |
| I2C                                        | Y       |
| GPIO                                       | Y       |
| SDIO                                       | Y       |

</details>

### 4. Documentation

Refer to the [wiki](https://github.com/ADLINK/meta-adlink-nxp/wiki) page for instructions on building the Yocto as well as flashing the image.

