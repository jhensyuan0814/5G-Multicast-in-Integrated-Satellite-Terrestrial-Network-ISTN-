# 5G Multicast in Integrated Satellite-Terrestrial Network (ISTN)
The project develops a resource allocation mech- anism of cooperative multicast under the integrated satellite- terrestrial network (ISTN). In cooperative multicast, base stations (BS) form different single frequency networks (SFN), and BSs within each SFN transmit data to mobile users (MU) with the same frequency, thus increasing signal intensity. Under this system architecture, we leverage the bottleneck user problem to characterize the overall system performance, where the bottleneck user is the MU with the lowest data rate inside each SFN. As the bottleneck user has poor signal strength, an SFN suffers a decrease in its Quality of Experience (QoE) provided to all users. Such an issue is alleviated under the ISTN: Users with poor signal strength can connect to the satellite that transmits with a moderate data rate, while the other users in the terrestrial network are unleashed from being grouped with them. In this regard, we propose an SFN-partitioning mechanism with the user-satellite association. In particular, our algorithm employs concepts from cooperative game theory and ensures Nash stability of the system. Finally, the simulation results validate the ef ciency of the proposed mechanism.

**Please refer to report.pdf for detailed information.**

# How to Execute
There are two main files: 
- main_by_number.m allows you to run the program according to given mobile user numbers
- main_by_side.m allows you to run the program according to given sizes of single frequency networks

## Variables:
- version_collection = [1:3] 1-our alg 2-all SFN 3-all PTM
- debug = you want to print the information about SFNs during our algorithm
- final result = length(side_collection)*length(version_collection)
- scenario: 
  - 0:completely random position 
  - 1:Fixed density with uniform distribution 
  - 2:Fixed density with clustered distribution 
  - 3:Variable density with uniform distribution
  - 4:Variable density with clustered distribution
- ini_BSMU_hex(ISD,BSNum,MUNum,scenario) 
- param
  - 1:side = 60000, MU = 190~950
  - 2:side = 30000, MU = 190~950
  - 3:side = 30000, MU = 1000~5000
  - 4:side = 45000, MU = 1000~5000
  - 5:side = 60000, MU = 1000~5000
