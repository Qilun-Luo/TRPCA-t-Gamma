# TRPCA-t-Gamma

Matlab Implementation for the Paper:

Cai, S.; Luo, Q.; Yang, M.; Li, W.; Xiao, M. Tensor Robust Principal Component Analysis via Non-Convex Low Rank Approximation. Appl. Sci. 2019, 9, 1411. https://doi.org/10.3390/app9071411

## Folders
- `algs` includes the proposed method
- `data` contains the data:
  - Berkeley Segmentation Dataset (BSD)
  - four color videos: Hall, MovedObject, Escalator and Lobby
  - parts of ChangeDetection.net(CDNet) dataset2014
- `utils` includes some utilities scripts

## Files
- `test_Image_Recovery` is the script for image recovery on BSD;
- `test_BM_Qualitative` is the script for background modeling on four surveillance videos;
- `test_BM_Quantitative` is the script for background segmentation on parts of CDNet dataset2014

## Partial Results 
Here are some results from the proposed method only. 
- #### Image Recovery
  ![Image recovery result](https://github.com/Qilun-Luo/TRPCA-t-Gamma/blob/main/results/result_sample_img_recovery.png)
- #### Background Modeling on CDNet dataset2014
 <!---  [Original](results/in000900.jpg "Original") ![Ground truth](results/gt000900.png "Ground truth") ![t-Gamma](results/bin000900.jpg "t-Gamma") --->
 <table width="20%">
  <tr>
    <td>Original</td>
     <td>Ground truth</td>
     <td>t-Gamma</td>
  </tr>
  <tr>
    <td><img src="results/in000900.jpg"></td>
    <td><img src="results/gt000900.png"></td>
    <td><img src="results/bin000900.jpg" ></td>
  </tr>
 </table>
