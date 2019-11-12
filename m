Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5814BF9088
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 14:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfKLNVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 08:21:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41268 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbfKLNVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 08:21:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573564913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w7qtAahT2NX818P8PgamLq7wJE9QpHadIlQctugvVwU=;
        b=A434fug95rAeELLKggfux+V3hcSQLgaz2fSPqqkl+bTA/qZv9vkLYBR/amhh/KN0Y8h3CX
        lmmQfH/wyjNvpKY7OcxqdILAHUVBGqIJcS/JvTD0hcDmvYfF4mSTO35RT+I1Pa9v8tf2gi
        nVUDDbIq6b0HdDClW9HaFLL+tUdG+MU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-Fbfba7LqPBCRnq77-ptTmQ-1; Tue, 12 Nov 2019 08:21:49 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06E0B1800D63;
        Tue, 12 Nov 2019 13:21:47 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB24A5E240;
        Tue, 12 Nov 2019 13:21:39 +0000 (UTC)
Subject: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Cc:     "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "vincent.stehle@arm.com" <vincent.stehle@arm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "tina.zhang@intel.com" <tina.zhang@intel.com>,
        Linuxarm <linuxarm@huawei.com>, "xuwei (O)" <xuwei5@huawei.com>
References: <20190711135625.20684-1-eric.auger@redhat.com>
 <f5b4b97b197d4bab8f3703eba2e966c4@huawei.com>
 <ebaded3e-8a5c-73dd-b3f7-7533a6e80146@redhat.com>
 <76d9dc0274414887b04e11b9b6bda257@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b0a9f107-2e89-1418-d6f4-3e6f5ac0b330@redhat.com>
Date:   Tue, 12 Nov 2019 14:21:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <76d9dc0274414887b04e11b9b6bda257@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: Fbfba7LqPBCRnq77-ptTmQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 11/12/19 2:06 PM, Shameerali Kolothum Thodi wrote:
> Hi Eric,
>=20
>> -----Original Message-----
>> From: Auger Eric [mailto:eric.auger@redhat.com]
>> Sent: 12 November 2019 11:29
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>> eric.auger.pro@gmail.com; iommu@lists.linux-foundation.org;
>> linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
>> kvmarm@lists.cs.columbia.edu; joro@8bytes.org;
>> alex.williamson@redhat.com; jacob.jun.pan@linux.intel.com;
>> yi.l.liu@intel.com; jean-philippe.brucker@arm.com; will.deacon@arm.com;
>> robin.murphy@arm.com
>> Cc: kevin.tian@intel.com; vincent.stehle@arm.com; ashok.raj@intel.com;
>> marc.zyngier@arm.com; tina.zhang@intel.com; Linuxarm
>> <linuxarm@huawei.com>; xuwei (O) <xuwei5@huawei.com>
>> Subject: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
>>
>> Hi Shameer,
>> On 11/12/19 12:08 PM, Shameerali Kolothum Thodi wrote:
>>> Hi Eric,
>>>
>>>> -----Original Message-----
>>>> From: kvmarm-bounces@lists.cs.columbia.edu
>>>> [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Eric Auger
>>>> Sent: 11 July 2019 14:56
>>>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com;
>>>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>>>> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; joro@8bytes.org;
>>>> alex.williamson@redhat.com; jacob.jun.pan@linux.intel.com;
>>>> yi.l.liu@intel.com; jean-philippe.brucker@arm.com; will.deacon@arm.com=
;
>>>> robin.murphy@arm.com
>>>> Cc: kevin.tian@intel.com; vincent.stehle@arm.com; ashok.raj@intel.com;
>>>> marc.zyngier@arm.com; tina.zhang@intel.com
>>>> Subject: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
>>>>
>>>> This series brings the VFIO part of HW nested paging support
>>>> in the SMMUv3.
>>>>
>>>> The series depends on:
>>>> [PATCH v9 00/14] SMMUv3 Nested Stage Setup (IOMMU part)
>>>> (https://www.spinics.net/lists/kernel/msg3187714.html)
>>>>
>>>> 3 new IOCTLs are introduced that allow the userspace to
>>>> 1) pass the guest stage 1 configuration
>>>> 2) pass stage 1 MSI bindings
>>>> 3) invalidate stage 1 related caches
>>>>
>>>> They map onto the related new IOMMU API functions.
>>>>
>>>> We introduce the capability to register specific interrupt
>>>> indexes (see [1]). A new DMA_FAULT interrupt index allows to register
>>>> an eventfd to be signaled whenever a stage 1 related fault
>>>> is detected at physical level. Also a specific region allows
>>>> to expose the fault records to the user space.
>>>
>>> I am trying to get this running on one of our platform that has smmuv3 =
dual
>>> stage support. I am seeing some issues with this when an ixgbe vf dev i=
s
>>> made pass-through and is behind a vSMMUv3 in Guest.
>>>
>>> Kernel used : https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9
>>> Qemu: https://github.com/eauger/qemu/tree/v4.1.0-rc0-2stage-rfcv5
>>>
>>> And this is my Qemu cmd line,
>>>
>>> ./qemu-system-aarch64
>>> -machine virt,kernel_irqchip=3Don,gic-version=3D3,iommu=3Dsmmuv3 -cpu h=
ost \
>>> -kernel Image \
>>> -drive if=3Dnone,file=3Dubuntu,id=3Dfs \
>>> -device virtio-blk-device,drive=3Dfs \
>>> -device vfio-pci,host=3D0000:01:10.1 \
>>> -bios QEMU_EFI.fd \
>>> -net none \
>>> -m 4G \
>>> -nographic -D -d -enable-kvm \
>>> -append "console=3DttyAMA0 root=3D/dev/vda rw acpi=3Dforce"
>>>
>>> The basic ping from Guest works fine,
>>> root@ubuntu:~# ping 10.202.225.185
>>> PING 10.202.225.185 (10.202.225.185) 56(84) bytes of data.
>>> 64 bytes from 10.202.225.185: icmp_seq=3D2 ttl=3D64 time=3D0.207 ms
>>> 64 bytes from 10.202.225.185: icmp_seq=3D3 ttl=3D64 time=3D0.203 ms
>>> ...
>>>
>>> But if I increase ping packet size,
>>>
>>> root@ubuntu:~# ping -s 1024 10.202.225.185
>>> PING 10.202.225.185 (10.202.225.185) 1024(1052) bytes of data.
>>> 1032 bytes from 10.202.225.185: icmp_seq=3D22 ttl=3D64 time=3D0.292 ms
>>> 1032 bytes from 10.202.225.185: icmp_seq=3D23 ttl=3D64 time=3D0.207 ms
>>> From 10.202.225.169 icmp_seq=3D66 Destination Host Unreachable
>>> From 10.202.225.169 icmp_seq=3D67 Destination Host Unreachable
>>> From 10.202.225.169 icmp_seq=3D68 Destination Host Unreachable
>>> From 10.202.225.169 icmp_seq=3D69 Destination Host Unreachable
>>>
>>> And from Host kernel I get,
>>> [  819.970742] ixgbe 0000:01:00.1 enp1s0f1: 3 Spoofed packets detected
>>> [  824.002707] ixgbe 0000:01:00.1 enp1s0f1: 1 Spoofed packets detected
>>> [  828.034683] ixgbe 0000:01:00.1 enp1s0f1: 1 Spoofed packets detected
>>> [  830.050673] ixgbe 0000:01:00.1 enp1s0f1: 4 Spoofed packets detected
>>> [  832.066659] ixgbe 0000:01:00.1 enp1s0f1: 1 Spoofed packets detected
>>> [  834.082640] ixgbe 0000:01:00.1 enp1s0f1: 3 Spoofed packets detected
>>>
>>> Also noted that iperf cannot work as it fails to establish the connecti=
on with
>> iperf
>>> server.
>>>
>>> Please find attached the trace logs(vfio*, smmuv3*) from Qemu for your
>> reference.
>>> I haven't debugged this further yet and thought of checking with you if=
 this is
>>> something you have seen already or not. Or maybe I am missing something
>> here?
>>
>> Please can you try to edit and modify hw/vfio/common.c, function
>> vfio_iommu_unmap_notify
>>
>>
>> /*
>>     if (size <=3D 0x10000) {
>>         ustruct.info.cache =3D IOMMU_CACHE_INV_TYPE_IOTLB;
>>         ustruct.info.granularity =3D IOMMU_INV_GRANU_ADDR;
>>         ustruct.info.addr_info.flags =3D IOMMU_INV_ADDR_FLAGS_ARCHID;
>>         if (iotlb->leaf) {
>>             ustruct.info.addr_info.flags |=3D
>> IOMMU_INV_ADDR_FLAGS_LEAF;
>>         }
>>         ustruct.info.addr_info.archid =3D iotlb->arch_id;
>>         ustruct.info.addr_info.addr =3D start;
>>         ustruct.info.addr_info.granule_size =3D size;
>>         ustruct.info.addr_info.nb_granules =3D 1;
>>         trace_vfio_iommu_addr_inv_iotlb(iotlb->arch_id, start, size, 1,
>>                                         iotlb->leaf);
>>     } else {
>> */
>>         ustruct.info.cache =3D IOMMU_CACHE_INV_TYPE_IOTLB;
>>         ustruct.info.granularity =3D IOMMU_INV_GRANU_PASID;
>>         ustruct.info.pasid_info.archid =3D iotlb->arch_id;
>>         ustruct.info.pasid_info.flags =3D IOMMU_INV_PASID_FLAGS_ARCHID;
>>         trace_vfio_iommu_asid_inv_iotlb(iotlb->arch_id);
>> //    }
>>
>> This modification leads to invalidate the whole asid each time we get a
>> guest TLBI instead of invalidating the single IOVA (TLBI). On my end, I
>> saw this was the cause of such kind of issues. Please let me know if it
>> fixes your perf issues
>=20
> Yes, this seems to fix the issue.
>=20
> root@ubuntu:~# iperf -c 10.202.225.185
> ------------------------------------------------------------
> Client connecting to 10.202.225.185, TCP port 5001
> TCP window size: 85.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 10.202.225.169 port 47996 connected with 10.202.225.185 port =
5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  2.27 GBytes  1.95 Gbits/sec
> root@ubuntu:~#
>=20
> But the performance seems to be very poor as this is a 10Gbps interface(O=
f course
> invalidating the whole asid may not be very helpful). It is interesting t=
hat why the
> single iova invalidation is not working.
>=20
>  and then we may discuss further about the test
>> configuration.
>=20
> Sure. Please let me know.

I reported that issue earlier on the ML. I have not been able to find
any integration issue in the kernel/qemu code but maybe I am too blind
now as I wrote it ;-) When I get a guest stage1 TLBI I cascade it down
to the physical IOMMU. I also pass the LEAF flag.

As you are an expert of the SMMUv3 PMU, if your implementation has any
and you have cycles to look at this, it would be helpful to run it and
see if something weird gets highlighted.

Thanks

Eric
>=20
> Cheers,
> Shameer=20
>=20
>> Thanks
>>
>> Eric
>>
>>
>>
>>>
>>> Please let me know.
>>>
>>> Thanks,
>>> Shameer
>>>
>>>> Best Regards
>>>>
>>>> Eric
>>>>
>>>> This series can be found at:
>>>> https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9
>>>>
>>>> It series includes Tina's patch steming from
>>>> [1] "[RFC PATCH v2 1/3] vfio: Use capability chains to handle device
>>>> specific irq" plus patches originally contributed by Yi.
>>>>
>>>> History:
>>>>
>>>> v8 -> v9:
>>>> - introduce specific irq framework
>>>> - single fault region
>>>> - iommu_unregister_device_fault_handler failure case not handled
>>>>   yet.
>>>>
>>>> v7 -> v8:
>>>> - rebase on top of v5.2-rc1 and especially
>>>>   8be39a1a04c1  iommu/arm-smmu-v3: Add a master->domain pointer
>>>> - dynamic alloc of s1_cfg/s2_cfg
>>>> - __arm_smmu_tlb_inv_asid/s1_range_nosync
>>>> - check there is no HW MSI regions
>>>> - asid invalidation using pasid extended struct (change in the uapi)
>>>> - add s1_live/s2_live checks
>>>> - move check about support of nested stages in domain finalise
>>>> - fixes in error reporting according to the discussion with Robin
>>>> - reordered the patches to have first iommu/smmuv3 patches and then
>>>>   VFIO patches
>>>>
>>>> v6 -> v7:
>>>> - removed device handle from bind/unbind_guest_msi
>>>> - added "iommu/smmuv3: Nested mode single MSI doorbell per domain
>>>>   enforcement"
>>>> - added few uapi comments as suggested by Jean, Jacop and Alex
>>>>
>>>> v5 -> v6:
>>>> - Fix compilation issue when CONFIG_IOMMU_API is unset
>>>>
>>>> v4 -> v5:
>>>> - fix bug reported by Vincent: fault handler unregistration now happen=
s in
>>>>   vfio_pci_release
>>>> - IOMMU_FAULT_PERM_* moved outside of struct definition + small
>>>>   uapi changes suggested by Kean-Philippe (except fetch_addr)
>>>> - iommu: introduce device fault report API: removed the PRI part.
>>>> - see individual logs for more details
>>>> - reset the ste abort flag on detach
>>>>
>>>> v3 -> v4:
>>>> - took into account Alex, jean-Philippe and Robin's comments on v3
>>>> - rework of the smmuv3 driver integration
>>>> - add tear down ops for msi binding and PASID table binding
>>>> - fix S1 fault propagation
>>>> - put fault reporting patches at the beginning of the series following
>>>>   Jean-Philippe's request
>>>> - update of the cache invalidate and fault API uapis
>>>> - VFIO fault reporting rework with 2 separate regions and one mmappabl=
e
>>>>   segment for the fault queue
>>>> - moved to PATCH
>>>>
>>>> v2 -> v3:
>>>> - When registering the S1 MSI binding we now store the device handle. =
This
>>>>   addresses Robin's comment about discimination of devices beonging to
>>>>   different S1 groups and using different physical MSI doorbells.
>>>> - Change the fault reporting API: use VFIO_PCI_DMA_FAULT_IRQ_INDEX to
>>>>   set the eventfd and expose the faults through an mmappable fault reg=
ion
>>>>
>>>> v1 -> v2:
>>>> - Added the fault reporting capability
>>>> - asid properly passed on invalidation (fix assignment of multiple
>>>>   devices)
>>>> - see individual change logs for more info
>>>>
>>>>
>>>> Eric Auger (8):
>>>>   vfio: VFIO_IOMMU_SET_MSI_BINDING
>>>>   vfio/pci: Add VFIO_REGION_TYPE_NESTED region type
>>>>   vfio/pci: Register an iommu fault handler
>>>>   vfio/pci: Allow to mmap the fault queue
>>>>   vfio: Add new IRQ for DMA fault reporting
>>>>   vfio/pci: Add framework for custom interrupt indices
>>>>   vfio/pci: Register and allow DMA FAULT IRQ signaling
>>>>   vfio: Document nested stage control
>>>>
>>>> Liu, Yi L (2):
>>>>   vfio: VFIO_IOMMU_SET_PASID_TABLE
>>>>   vfio: VFIO_IOMMU_CACHE_INVALIDATE
>>>>
>>>> Tina Zhang (1):
>>>>   vfio: Use capability chains to handle device specific irq
>>>>
>>>>  Documentation/vfio.txt              |  77 ++++++++
>>>>  drivers/vfio/pci/vfio_pci.c         | 283
>> ++++++++++++++++++++++++++--
>>>>  drivers/vfio/pci/vfio_pci_intrs.c   |  62 ++++++
>>>>  drivers/vfio/pci/vfio_pci_private.h |  24 +++
>>>>  drivers/vfio/pci/vfio_pci_rdwr.c    |  45 +++++
>>>>  drivers/vfio/vfio_iommu_type1.c     | 166 ++++++++++++++++
>>>>  include/uapi/linux/vfio.h           | 109 ++++++++++-
>>>>  7 files changed, 747 insertions(+), 19 deletions(-)
>>>>
>>>> --
>>>> 2.20.1
>>>>
>>>> _______________________________________________
>>>> kvmarm mailing list
>>>> kvmarm@lists.cs.columbia.edu
>>>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>=20

