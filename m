Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17CC2EF638
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 18:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbhAHRGT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 8 Jan 2021 12:06:19 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:4135 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbhAHRGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 12:06:19 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4DC8bZ3685zXwW1;
        Sat,  9 Jan 2021 01:04:42 +0800 (CST)
Received: from dggema715-chm.china.huawei.com (10.3.20.79) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Sat, 9 Jan 2021 01:05:33 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggema715-chm.china.huawei.com (10.3.20.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 9 Jan 2021 01:05:32 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.002; Fri, 8 Jan 2021 17:05:30 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Eric Auger <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v13 00/15] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Topic: [PATCH v13 00/15] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Index: AQHWvZ3PFBCcuzrn5UiXiOG2BGlsE6oeOV7w
Date:   Fri, 8 Jan 2021 17:05:30 +0000
Message-ID: <ad88f78cf56f4f7fb69728cbf22a1052@huawei.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
In-Reply-To: <20201118112151.25412-1-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.94.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> -----Original Message-----
> From: Eric Auger [mailto:eric.auger@redhat.com]
> Sent: 18 November 2020 11:22
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com;
> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; will@kernel.org;
> joro@8bytes.org; maz@kernel.org; robin.murphy@arm.com;
> alex.williamson@redhat.com
> Cc: jean-philippe@linaro.org; zhangfei.gao@linaro.org;
> zhangfei.gao@gmail.com; vivek.gautam@arm.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>;
> jacob.jun.pan@linux.intel.com; yi.l.liu@intel.com; tn@semihalf.com;
> nicoleotsuka@gmail.com; yuzenghui <yuzenghui@huawei.com>
> Subject: [PATCH v13 00/15] SMMUv3 Nested Stage Setup (IOMMU part)
> 
> This series brings the IOMMU part of HW nested paging support
> in the SMMUv3. The VFIO part is submitted separately.
> 
> The IOMMU API is extended to support 2 new API functionalities:
> 1) pass the guest stage 1 configuration
> 2) pass stage 1 MSI bindings
> 
> Then those capabilities gets implemented in the SMMUv3 driver.
> 
> The virtualizer passes information through the VFIO user API
> which cascades them to the iommu subsystem. This allows the guest
> to own stage 1 tables and context descriptors (so-called PASID
> table) while the host owns stage 2 tables and main configuration
> structures (STE).

I am seeing an issue with Guest testpmd run with this series.
I have two different setups and testpmd works fine with the
first one but not with the second.

1). Guest doesn't have kernel driver built-in for pass-through dev.

root@ubuntu:/# lspci -v
...
00:02.0 Ethernet controller: Huawei Technologies Co., Ltd. Device a22e (rev 21)
Subsystem: Huawei Technologies Co., Ltd. Device 0000
Flags: fast devsel
Memory at 8000100000 (64-bit, prefetchable) [disabled] [size=64K]
Memory at 8000000000 (64-bit, prefetchable) [disabled] [size=1M]
Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
Capabilities: [a0] MSI-X: Enable- Count=67 Masked-
Capabilities: [b0] Power Management version 3
Capabilities: [100] Access Control Services
Capabilities: [300] Transaction Processing Hints

root@ubuntu:/# echo vfio-pci > /sys/bus/pci/devices/0000:00:02.0/driver_override
root@ubuntu:/# echo 0000:00:02.0 > /sys/bus/pci/drivers_probe

root@ubuntu:/mnt/dpdk/build/app# ./testpmd -w 0000:00:02.0 --file-prefix socket0  -l 0-1 -n 2 -- -i
EAL: Detected 8 lcore(s)
EAL: Detected 1 NUMA nodes
EAL: Multi-process socket /var/run/dpdk/socket0/mp_socket
EAL: Selected IOVA mode 'VA'
EAL: No available hugepages reported in hugepages-32768kB
EAL: No available hugepages reported in hugepages-64kB
EAL: No available hugepages reported in hugepages-1048576kB
EAL: Probing VFIO support...
EAL: VFIO support initialized
EAL:   Invalid NUMA socket, default to 0
EAL:   using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_hns3_vf (19e5:a22e) device: 0000:00:02.0 (socket 0)
EAL: No legacy callbacks, legacy socket not created
Interactive-mode selected
testpmd: create a new mbuf pool <mbuf_pool_socket_0>: n=155456, size=2176, socket=0
testpmd: preferred mempool ops selected: ring_mp_mc

Warning! port-topology=paired and odd forward ports number, the last port will pair with itself.

Configuring Port 0 (socket 0)
Port 0: 8E:A6:8C:43:43:45
Checking link statuses...
Done
testpmd>

2). Guest have kernel driver built-in for pass-through dev.

root@ubuntu:/# lspci -v
...
00:02.0 Ethernet controller: Huawei Technologies Co., Ltd. Device a22e (rev 21)
Subsystem: Huawei Technologies Co., Ltd. Device 0000
Flags: bus master, fast devsel, latency 0
Memory at 8000100000 (64-bit, prefetchable) [size=64K]
Memory at 8000000000 (64-bit, prefetchable) [size=1M]
Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
Capabilities: [a0] MSI-X: Enable+ Count=67 Masked-
Capabilities: [b0] Power Management version 3
Capabilities: [100] Access Control Services
Capabilities: [300] Transaction Processing Hints
Kernel driver in use: hns3

root@ubuntu:/# echo vfio-pci > /sys/bus/pci/devices/0000:00:02.0/driver_override
root@ubuntu:/# echo 0000:00:02.0 > /sys/bus/pci/drivers/hns3/unbind
root@ubuntu:/# echo 0000:00:02.0 > /sys/bus/pci/drivers_probe

root@ubuntu:/mnt/dpdk/build/app# ./testpmd -w 0000:00:02.0 --file-prefix socket0 -l 0-1 -n 2 -- -i
EAL: Detected 8 lcore(s)
EAL: Detected 1 NUMA nodes
EAL: Multi-process socket /var/run/dpdk/socket0/mp_socket
EAL: Selected IOVA mode 'VA'
EAL: No available hugepages reported in hugepages-32768kB
EAL: No available hugepages reported in hugepages-64kB
EAL: No available hugepages reported in hugepages-1048576kB
EAL: Probing VFIO support...
EAL: VFIO support initialized
EAL:   Invalid NUMA socket, default to 0
EAL:   using IOMMU type 1 (Type 1)
EAL: Probe PCI driver: net_hns3_vf (19e5:a22e) device: 0000:00:02.0 (socket 0)
0000:00:02.0 hns3_get_mbx_resp(): VF could not get mbx(11,0) head(1) tail(0) lost(1) from PF in_irq:0
hns3vf_get_queue_info(): Failed to get tqp info from PF: -62
hns3vf_init_vf(): Failed to fetch configuration: -62
hns3vf_dev_init(): Failed to init vf: -62
EAL: Releasing pci mapped resource for 0000:00:02.0
EAL: Calling pci_unmap_resource for 0000:00:02.0 at 0x1100800000
EAL: Calling pci_unmap_resource for 0000:00:02.0 at 0x1100810000
EAL: Requested device 0000:00:02.0 cannot be used
EAL: Bus (pci) probe failed.
EAL: No legacy callbacks, legacy socket not created
testpmd: No probed ethernet devices
Interactive-mode selected
testpmd: create a new mbuf pool <mbuf_pool_socket_0>: n=155456, size=2176, socket=0
testpmd: preferred mempool ops selected: ring_mp_mc
Done
testpmd>

And in this case, smmu(host) reports a translation fault,

[ 6542.670624] arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
[ 6542.670630] arm-smmu-v3 arm-smmu-v3.2.auto: 0x00007d1200000010
[ 6542.670631] arm-smmu-v3 arm-smmu-v3.2.auto: 0x000012000000007c
[ 6542.670633] arm-smmu-v3 arm-smmu-v3.2.auto: 0x00000000fffef040
[ 6542.670634] arm-smmu-v3 arm-smmu-v3.2.auto: 0x00000000fffef000

Tested with Intel 82599 card(ixgbevf) as well. but same errror.

Not able to root cause the problem yet. With the hope that, this is 
related to tlb entries not being invlaidated properly, I tried explicitly
issuing CMD_TLBI_NSNH_ALL and CMD_CFGI_CD_ALL just before
the STE update, but no luck yet :(

Please let me know if I am missing something here or has any clue if you
can replicate this on your setup.

Thanks,
Shameer

> 
> Best Regards
> 
> Eric
> 
> This series can be found at:
> https://github.com/eauger/linux/tree/5.10-rc4-2stage-v13
> (including the VFIO part in his last version: v11)
> 
> The series includes a patch from Jean-Philippe. It is better to
> review the original patch:
> [PATCH v8 2/9] iommu/arm-smmu-v3: Maintain a SID->device structure
> 
> The VFIO series is sent separately.
> 
> History:
> 
> v12 -> v13:
> - fixed compilation issue with CONFIG_ARM_SMMU_V3_SVA
>   reported by Shameer. This urged me to revisit patch 4 into
>   iommu/smmuv3: Allow s1 and s2 configs to coexist where
>   s1_cfg and s2_cfg are not dynamically allocated anymore.
>   Instead I use a new set field in existing structs
> - fixed 2 others config checks
> - Updated "iommu/arm-smmu-v3: Maintain a SID->device structure"
>   according to the last version
> 
> v11 -> v12:
> - rebase on top of v5.10-rc4
> 
> Eric Auger (14):
>   iommu: Introduce attach/detach_pasid_table API
>   iommu: Introduce bind/unbind_guest_msi
>   iommu/smmuv3: Allow s1 and s2 configs to coexist
>   iommu/smmuv3: Get prepared for nested stage support
>   iommu/smmuv3: Implement attach/detach_pasid_table
>   iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
>   iommu/smmuv3: Implement cache_invalidate
>   dma-iommu: Implement NESTED_MSI cookie
>   iommu/smmuv3: Nested mode single MSI doorbell per domain enforcement
>   iommu/smmuv3: Enforce incompatibility between nested mode and HW MSI
>     regions
>   iommu/smmuv3: Implement bind/unbind_guest_msi
>   iommu/smmuv3: Report non recoverable faults
>   iommu/smmuv3: Accept configs with more than one context descriptor
>   iommu/smmuv3: Add PASID cache invalidation per PASID
> 
> Jean-Philippe Brucker (1):
>   iommu/arm-smmu-v3: Maintain a SID->device structure
> 
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 659
> ++++++++++++++++++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 103 ++-
>  drivers/iommu/dma-iommu.c                   | 142 ++++-
>  drivers/iommu/iommu.c                       | 105 ++++
>  include/linux/dma-iommu.h                   |  16 +
>  include/linux/iommu.h                       |  41 ++
>  include/uapi/linux/iommu.h                  |  54 ++
>  7 files changed, 1042 insertions(+), 78 deletions(-)
> 
> --
> 2.21.3

