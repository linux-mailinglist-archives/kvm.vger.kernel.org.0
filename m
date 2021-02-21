Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA82320C89
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 19:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhBUSW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 13:22:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhBUSWt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 21 Feb 2021 13:22:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613931682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zglb5HPjQwXkwakAytJHCKEB76+JAMUrAbTe4isW8k8=;
        b=MPm5qNVsGEjFSNnefpKLLJQqqG1PQVsroa3PqD+8bgCheFSJisNSXraRfI89NGpIgwRjjT
        VupDn07OnOeVx0mD4biDL9rsJKIgL8rkdY8tV79UQ6U95SYMhCgG1fD1Bx32DVk/S/+i9q
        TBj7JNxeJqs70zl+lvpdeQyx3Ox1VD0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-l2jy31ocMDOPi0f0jf4RdQ-1; Sun, 21 Feb 2021 13:21:17 -0500
X-MC-Unique: l2jy31ocMDOPi0f0jf4RdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 965521E565;
        Sun, 21 Feb 2021 18:21:14 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 816935D9CA;
        Sun, 21 Feb 2021 18:21:04 +0000 (UTC)
Subject: Re: [PATCH v13 00/15] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
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
Cc:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
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
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <ad88f78cf56f4f7fb69728cbf22a1052@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <9554e747-59fe-3bda-8cfc-13f40f74f0ca@redhat.com>
Date:   Sun, 21 Feb 2021 19:21:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ad88f78cf56f4f7fb69728cbf22a1052@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,
On 1/8/21 6:05 PM, Shameerali Kolothum Thodi wrote:
> Hi Eric,
> 
>> -----Original Message-----
>> From: Eric Auger [mailto:eric.auger@redhat.com]
>> Sent: 18 November 2020 11:22
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com;
>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; will@kernel.org;
>> joro@8bytes.org; maz@kernel.org; robin.murphy@arm.com;
>> alex.williamson@redhat.com
>> Cc: jean-philippe@linaro.org; zhangfei.gao@linaro.org;
>> zhangfei.gao@gmail.com; vivek.gautam@arm.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>;
>> jacob.jun.pan@linux.intel.com; yi.l.liu@intel.com; tn@semihalf.com;
>> nicoleotsuka@gmail.com; yuzenghui <yuzenghui@huawei.com>
>> Subject: [PATCH v13 00/15] SMMUv3 Nested Stage Setup (IOMMU part)
>>
>> This series brings the IOMMU part of HW nested paging support
>> in the SMMUv3. The VFIO part is submitted separately.
>>
>> The IOMMU API is extended to support 2 new API functionalities:
>> 1) pass the guest stage 1 configuration
>> 2) pass stage 1 MSI bindings
>>
>> Then those capabilities gets implemented in the SMMUv3 driver.
>>
>> The virtualizer passes information through the VFIO user API
>> which cascades them to the iommu subsystem. This allows the guest
>> to own stage 1 tables and context descriptors (so-called PASID
>> table) while the host owns stage 2 tables and main configuration
>> structures (STE).
> 
> I am seeing an issue with Guest testpmd run with this series.
> I have two different setups and testpmd works fine with the
> first one but not with the second.
> 
> 1). Guest doesn't have kernel driver built-in for pass-through dev.
> 
> root@ubuntu:/# lspci -v
> ...
> 00:02.0 Ethernet controller: Huawei Technologies Co., Ltd. Device a22e (rev 21)
> Subsystem: Huawei Technologies Co., Ltd. Device 0000
> Flags: fast devsel
> Memory at 8000100000 (64-bit, prefetchable) [disabled] [size=64K]
> Memory at 8000000000 (64-bit, prefetchable) [disabled] [size=1M]
> Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
> Capabilities: [a0] MSI-X: Enable- Count=67 Masked-
> Capabilities: [b0] Power Management version 3
> Capabilities: [100] Access Control Services
> Capabilities: [300] Transaction Processing Hints
> 
> root@ubuntu:/# echo vfio-pci > /sys/bus/pci/devices/0000:00:02.0/driver_override
> root@ubuntu:/# echo 0000:00:02.0 > /sys/bus/pci/drivers_probe
> 
> root@ubuntu:/mnt/dpdk/build/app# ./testpmd -w 0000:00:02.0 --file-prefix socket0  -l 0-1 -n 2 -- -i
> EAL: Detected 8 lcore(s)
> EAL: Detected 1 NUMA nodes
> EAL: Multi-process socket /var/run/dpdk/socket0/mp_socket
> EAL: Selected IOVA mode 'VA'
> EAL: No available hugepages reported in hugepages-32768kB
> EAL: No available hugepages reported in hugepages-64kB
> EAL: No available hugepages reported in hugepages-1048576kB
> EAL: Probing VFIO support...
> EAL: VFIO support initialized
> EAL:   Invalid NUMA socket, default to 0
> EAL:   using IOMMU type 1 (Type 1)
> EAL: Probe PCI driver: net_hns3_vf (19e5:a22e) device: 0000:00:02.0 (socket 0)
> EAL: No legacy callbacks, legacy socket not created
> Interactive-mode selected
> testpmd: create a new mbuf pool <mbuf_pool_socket_0>: n=155456, size=2176, socket=0
> testpmd: preferred mempool ops selected: ring_mp_mc
> 
> Warning! port-topology=paired and odd forward ports number, the last port will pair with itself.
> 
> Configuring Port 0 (socket 0)
> Port 0: 8E:A6:8C:43:43:45
> Checking link statuses...
> Done
> testpmd>
> 
> 2). Guest have kernel driver built-in for pass-through dev.
> 
> root@ubuntu:/# lspci -v
> ...
> 00:02.0 Ethernet controller: Huawei Technologies Co., Ltd. Device a22e (rev 21)
> Subsystem: Huawei Technologies Co., Ltd. Device 0000
> Flags: bus master, fast devsel, latency 0
> Memory at 8000100000 (64-bit, prefetchable) [size=64K]
> Memory at 8000000000 (64-bit, prefetchable) [size=1M]
> Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
> Capabilities: [a0] MSI-X: Enable+ Count=67 Masked-
> Capabilities: [b0] Power Management version 3
> Capabilities: [100] Access Control Services
> Capabilities: [300] Transaction Processing Hints
> Kernel driver in use: hns3
> 
> root@ubuntu:/# echo vfio-pci > /sys/bus/pci/devices/0000:00:02.0/driver_override
> root@ubuntu:/# echo 0000:00:02.0 > /sys/bus/pci/drivers/hns3/unbind
> root@ubuntu:/# echo 0000:00:02.0 > /sys/bus/pci/drivers_probe
> 
> root@ubuntu:/mnt/dpdk/build/app# ./testpmd -w 0000:00:02.0 --file-prefix socket0 -l 0-1 -n 2 -- -i
> EAL: Detected 8 lcore(s)
> EAL: Detected 1 NUMA nodes
> EAL: Multi-process socket /var/run/dpdk/socket0/mp_socket
> EAL: Selected IOVA mode 'VA'
> EAL: No available hugepages reported in hugepages-32768kB
> EAL: No available hugepages reported in hugepages-64kB
> EAL: No available hugepages reported in hugepages-1048576kB
> EAL: Probing VFIO support...
> EAL: VFIO support initialized
> EAL:   Invalid NUMA socket, default to 0
> EAL:   using IOMMU type 1 (Type 1)
> EAL: Probe PCI driver: net_hns3_vf (19e5:a22e) device: 0000:00:02.0 (socket 0)
> 0000:00:02.0 hns3_get_mbx_resp(): VF could not get mbx(11,0) head(1) tail(0) lost(1) from PF in_irq:0
> hns3vf_get_queue_info(): Failed to get tqp info from PF: -62
> hns3vf_init_vf(): Failed to fetch configuration: -62
> hns3vf_dev_init(): Failed to init vf: -62
> EAL: Releasing pci mapped resource for 0000:00:02.0
> EAL: Calling pci_unmap_resource for 0000:00:02.0 at 0x1100800000
> EAL: Calling pci_unmap_resource for 0000:00:02.0 at 0x1100810000
> EAL: Requested device 0000:00:02.0 cannot be used
> EAL: Bus (pci) probe failed.
> EAL: No legacy callbacks, legacy socket not created
> testpmd: No probed ethernet devices
> Interactive-mode selected
> testpmd: create a new mbuf pool <mbuf_pool_socket_0>: n=155456, size=2176, socket=0
> testpmd: preferred mempool ops selected: ring_mp_mc
> Done
> testpmd>
> 
> And in this case, smmu(host) reports a translation fault,
> 
> [ 6542.670624] arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
> [ 6542.670630] arm-smmu-v3 arm-smmu-v3.2.auto: 0x00007d1200000010
> [ 6542.670631] arm-smmu-v3 arm-smmu-v3.2.auto: 0x000012000000007c
> [ 6542.670633] arm-smmu-v3 arm-smmu-v3.2.auto: 0x00000000fffef040
> [ 6542.670634] arm-smmu-v3 arm-smmu-v3.2.auto: 0x00000000fffef000
> 
> Tested with Intel 82599 card(ixgbevf) as well. but same errror.

So this should be fixed in the next release. The problem came from the
fact the MSI giova was not duly unregistered. When vfio is not in used
on guest side, the guest kernel allocates giovas for MSIs @fffef000 - 40
is the ITS translater offset ;-) - When passthrough is in use, the iova
is allocated @0x8000000. As fffef000 MSI giova was not properly
unregistered, the host kernel used it - despite it has been unmapped by
the guest kernel -, hence the translation fault. So the fix is to
unregister the MSI in the VFIO QEMU code when msix are disabled. So to
me this is a QEMU integration issue.

Thank you very much for testing and reporting!

Thanks

Eric
> 
> Not able to root cause the problem yet. With the hope that, this is 
> related to tlb entries not being invlaidated properly, I tried explicitly
> issuing CMD_TLBI_NSNH_ALL and CMD_CFGI_CD_ALL just before
> the STE update, but no luck yet :(
> 
> Please let me know if I am missing something here or has any clue if you
> can replicate this on your setup.
> 
> Thanks,
> Shameer
> 
>>
>> Best Regards
>>
>> Eric
>>
>> This series can be found at:
>> https://github.com/eauger/linux/tree/5.10-rc4-2stage-v13
>> (including the VFIO part in his last version: v11)
>>
>> The series includes a patch from Jean-Philippe. It is better to
>> review the original patch:
>> [PATCH v8 2/9] iommu/arm-smmu-v3: Maintain a SID->device structure
>>
>> The VFIO series is sent separately.
>>
>> History:
>>
>> v12 -> v13:
>> - fixed compilation issue with CONFIG_ARM_SMMU_V3_SVA
>>   reported by Shameer. This urged me to revisit patch 4 into
>>   iommu/smmuv3: Allow s1 and s2 configs to coexist where
>>   s1_cfg and s2_cfg are not dynamically allocated anymore.
>>   Instead I use a new set field in existing structs
>> - fixed 2 others config checks
>> - Updated "iommu/arm-smmu-v3: Maintain a SID->device structure"
>>   according to the last version
>>
>> v11 -> v12:
>> - rebase on top of v5.10-rc4
>>
>> Eric Auger (14):
>>   iommu: Introduce attach/detach_pasid_table API
>>   iommu: Introduce bind/unbind_guest_msi
>>   iommu/smmuv3: Allow s1 and s2 configs to coexist
>>   iommu/smmuv3: Get prepared for nested stage support
>>   iommu/smmuv3: Implement attach/detach_pasid_table
>>   iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
>>   iommu/smmuv3: Implement cache_invalidate
>>   dma-iommu: Implement NESTED_MSI cookie
>>   iommu/smmuv3: Nested mode single MSI doorbell per domain enforcement
>>   iommu/smmuv3: Enforce incompatibility between nested mode and HW MSI
>>     regions
>>   iommu/smmuv3: Implement bind/unbind_guest_msi
>>   iommu/smmuv3: Report non recoverable faults
>>   iommu/smmuv3: Accept configs with more than one context descriptor
>>   iommu/smmuv3: Add PASID cache invalidation per PASID
>>
>> Jean-Philippe Brucker (1):
>>   iommu/arm-smmu-v3: Maintain a SID->device structure
>>
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 659
>> ++++++++++++++++++--
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 103 ++-
>>  drivers/iommu/dma-iommu.c                   | 142 ++++-
>>  drivers/iommu/iommu.c                       | 105 ++++
>>  include/linux/dma-iommu.h                   |  16 +
>>  include/linux/iommu.h                       |  41 ++
>>  include/uapi/linux/iommu.h                  |  54 ++
>>  7 files changed, 1042 insertions(+), 78 deletions(-)
>>
>> --
>> 2.21.3
> 

