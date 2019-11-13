Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD69DFB4F6
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 17:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfKMQYY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 13 Nov 2019 11:24:24 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2096 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726543AbfKMQYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 11:24:23 -0500
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 133FF8E869263F6F4978;
        Wed, 13 Nov 2019 16:24:22 +0000 (GMT)
Received: from lhreml708-chm.china.huawei.com (10.201.108.57) by
 LHREML712-CAH.china.huawei.com (10.201.108.35) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 13 Nov 2019 16:24:11 +0000
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml708-chm.china.huawei.com (10.201.108.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 13 Nov 2019 16:24:11 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.1713.004; Wed, 13 Nov 2019 16:24:11 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Auger Eric <eric.auger@redhat.com>,
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
CC:     "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "vincent.stehle@arm.com" <vincent.stehle@arm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "tina.zhang@intel.com" <tina.zhang@intel.com>,
        Linuxarm <linuxarm@huawei.com>, "xuwei (O)" <xuwei5@huawei.com>
Subject: RE: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
Thread-Topic: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
Thread-Index: AQHVN/CfwyE8ogH9wk6QxsmMIq08eqeIHQ3QgAALuICAABiYUIAABvsAgAAPlwCAADsPwIAALk4AgAFKABA=
Date:   Wed, 13 Nov 2019 16:24:10 +0000
Message-ID: <76a0589469ff4cfba348f43feba81fe4@huawei.com>
References: <20190711135625.20684-1-eric.auger@redhat.com>
 <f5b4b97b197d4bab8f3703eba2e966c4@huawei.com>
 <ebaded3e-8a5c-73dd-b3f7-7533a6e80146@redhat.com>
 <76d9dc0274414887b04e11b9b6bda257@huawei.com>
 <b0a9f107-2e89-1418-d6f4-3e6f5ac0b330@redhat.com>
 <9f0a9d341b01419eb566731339b3fbd2@huawei.com>
 <6e0faec9-5840-653e-cb43-86545a48e65d@redhat.com>
In-Reply-To: <6e0faec9-5840-653e-cb43-86545a48e65d@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> -----Original Message-----
> From: Auger Eric [mailto:eric.auger@redhat.com]
> Sent: 12 November 2019 20:35
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> eric.auger.pro@gmail.com; iommu@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> kvmarm@lists.cs.columbia.edu; joro@8bytes.org;
> alex.williamson@redhat.com; jacob.jun.pan@linux.intel.com;
> yi.l.liu@intel.com; jean-philippe.brucker@arm.com; will.deacon@arm.com;
> robin.murphy@arm.com
> Cc: kevin.tian@intel.com; vincent.stehle@arm.com; ashok.raj@intel.com;
> marc.zyngier@arm.com; tina.zhang@intel.com; Linuxarm
> <linuxarm@huawei.com>; xuwei (O) <xuwei5@huawei.com>
> Subject: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
> 
> Hi Shameer,
> 

[..]

> >
> > I just noted that CMDQ_OP_TLBI_NH_VA is missing the vmid filed which
> seems
> > to be the cause for single IOVA TLBI not working properly.
> >
> > I had this fix in arm-smmuv3.c,
> >
> > @@ -947,6 +947,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd,
> struct arm_smmu_cmdq_ent *ent)
> > 		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> > 		break;
> > 	case CMDQ_OP_TLBI_NH_VA:
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
> Damn, I did not see that! That's it. ASID invalidation fills this field
> indeed. You may post an independent patch for that.

Sure. Just did that.
" iommu/arm-smmu-v3: Populate VMID field for CMDQ_OP_TLBI_NH_VA"

> 		cmd[0] |=
> FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
> > 		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
> > 		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_VA_MASK;
> >
> >
> > With this, your original qemu branch is working.
> >
> > root@ubuntu:~# iperf -c 10.202.225.185
> > ------------------------------------------------------------
> > Client connecting to 10.202.225.185, TCP port 5001 TCP window size: 85.0
> KByte (default)
> > ------------------------------------------------------------
> > [  3] local 10.202.225.169 port 44894 connected with 10.202.225.185 port
> 5001
> > [ ID] Interval       Transfer     Bandwidth
> > [  3]  0.0-10.0 sec  3.21 GBytes  2.76 Gbits/sec
> >
> > Could you please check this...
> >
> > I also have a rebase of your patches on top of 5.4-rc5. This has some
> optimizations
> > From Will such as batched TLBI inv. Please find it here,
> >
> > https://github.com/hisilicon/kernel-dev/tree/private-vSMMUv3-v9-v5.4-rc5
> >
> > This gives me a better performance with iperf,
> >
> > root@ubuntu:~# iperf -c 10.202.225.185
> > ------------------------------------------------------------
> > Client connecting to 10.202.225.185, TCP port 5001 TCP window size: 85.0
> KByte (default)
> > ------------------------------------------------------------
> > [  3] local 10.202.225.169 port 55450 connected with 10.202.225.185 port
> 5001
> > [ ID] Interval       Transfer     Bandwidth
> > [  3]  0.0-10.0 sec  4.91 GBytes  4.22 Gbits/sec root@ubuntu:~#
> >
> > If possible please check this branch as well.
> 
> To be honest I don't really know what to do with this work. Despite the
> efforts, this has suffered from a lack of traction in the community. My
> last attempt to explain the use cases, upon Will's request at Plumber,
> has not received any comment (https://lkml.org/lkml/2019/9/20/104).
> 
> I think I will post a rebased version with your fix, as a matter to get
> a clean snapshot.

Thanks. That makes sense.

 If you think this work is useful for your projects,
> please let it know on the ML.

Right. While SVA use case is definitely the one we are very much interested, I will
check within our team the priority for use case 1(native drivers in Guest) you
mentioned in the above link. 

Cheers,
Shameer

> Thank you again!
> 
> Eric
> >
> > Thanks,
> > Shameer
> >
> >> Thanks,
> >> Shameer
> >>
> >>
> >>> Thanks
> >>>
> >>> Eric
> >>>>
> >>>> Cheers,
> >>>> Shameer
> >>>>
> >>>>> Thanks
> >>>>>
> >>>>> Eric
> >>>>>
> >>>>>
> >>>>>
> >>>>>>
> >>>>>> Please let me know.
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Shameer
> >>>>>>
> >>>>>>> Best Regards
> >>>>>>>
> >>>>>>> Eric
> >>>>>>>
> >>>>>>> This series can be found at:
> >>>>>>> https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9
> >>>>>>>
> >>>>>>> It series includes Tina's patch steming from
> >>>>>>> [1] "[RFC PATCH v2 1/3] vfio: Use capability chains to handle device
> >>>>>>> specific irq" plus patches originally contributed by Yi.
> >>>>>>>
> >>>>>>> History:
> >>>>>>>
> >>>>>>> v8 -> v9:
> >>>>>>> - introduce specific irq framework
> >>>>>>> - single fault region
> >>>>>>> - iommu_unregister_device_fault_handler failure case not handled
> >>>>>>>   yet.
> >>>>>>>
> >>>>>>> v7 -> v8:
> >>>>>>> - rebase on top of v5.2-rc1 and especially
> >>>>>>>   8be39a1a04c1  iommu/arm-smmu-v3: Add a master->domain
> >> pointer
> >>>>>>> - dynamic alloc of s1_cfg/s2_cfg
> >>>>>>> - __arm_smmu_tlb_inv_asid/s1_range_nosync
> >>>>>>> - check there is no HW MSI regions
> >>>>>>> - asid invalidation using pasid extended struct (change in the uapi)
> >>>>>>> - add s1_live/s2_live checks
> >>>>>>> - move check about support of nested stages in domain finalise
> >>>>>>> - fixes in error reporting according to the discussion with Robin
> >>>>>>> - reordered the patches to have first iommu/smmuv3 patches and
> then
> >>>>>>>   VFIO patches
> >>>>>>>
> >>>>>>> v6 -> v7:
> >>>>>>> - removed device handle from bind/unbind_guest_msi
> >>>>>>> - added "iommu/smmuv3: Nested mode single MSI doorbell per
> domain
> >>>>>>>   enforcement"
> >>>>>>> - added few uapi comments as suggested by Jean, Jacop and Alex
> >>>>>>>
> >>>>>>> v5 -> v6:
> >>>>>>> - Fix compilation issue when CONFIG_IOMMU_API is unset
> >>>>>>>
> >>>>>>> v4 -> v5:
> >>>>>>> - fix bug reported by Vincent: fault handler unregistration now
> happens
> >> in
> >>>>>>>   vfio_pci_release
> >>>>>>> - IOMMU_FAULT_PERM_* moved outside of struct definition + small
> >>>>>>>   uapi changes suggested by Kean-Philippe (except fetch_addr)
> >>>>>>> - iommu: introduce device fault report API: removed the PRI part.
> >>>>>>> - see individual logs for more details
> >>>>>>> - reset the ste abort flag on detach
> >>>>>>>
> >>>>>>> v3 -> v4:
> >>>>>>> - took into account Alex, jean-Philippe and Robin's comments on v3
> >>>>>>> - rework of the smmuv3 driver integration
> >>>>>>> - add tear down ops for msi binding and PASID table binding
> >>>>>>> - fix S1 fault propagation
> >>>>>>> - put fault reporting patches at the beginning of the series following
> >>>>>>>   Jean-Philippe's request
> >>>>>>> - update of the cache invalidate and fault API uapis
> >>>>>>> - VFIO fault reporting rework with 2 separate regions and one
> >> mmappable
> >>>>>>>   segment for the fault queue
> >>>>>>> - moved to PATCH
> >>>>>>>
> >>>>>>> v2 -> v3:
> >>>>>>> - When registering the S1 MSI binding we now store the device
> handle.
> >>> This
> >>>>>>>   addresses Robin's comment about discimination of devices
> beonging
> >>> to
> >>>>>>>   different S1 groups and using different physical MSI doorbells.
> >>>>>>> - Change the fault reporting API: use
> >> VFIO_PCI_DMA_FAULT_IRQ_INDEX
> >>> to
> >>>>>>>   set the eventfd and expose the faults through an mmappable fault
> >>> region
> >>>>>>>
> >>>>>>> v1 -> v2:
> >>>>>>> - Added the fault reporting capability
> >>>>>>> - asid properly passed on invalidation (fix assignment of multiple
> >>>>>>>   devices)
> >>>>>>> - see individual change logs for more info
> >>>>>>>
> >>>>>>>
> >>>>>>> Eric Auger (8):
> >>>>>>>   vfio: VFIO_IOMMU_SET_MSI_BINDING
> >>>>>>>   vfio/pci: Add VFIO_REGION_TYPE_NESTED region type
> >>>>>>>   vfio/pci: Register an iommu fault handler
> >>>>>>>   vfio/pci: Allow to mmap the fault queue
> >>>>>>>   vfio: Add new IRQ for DMA fault reporting
> >>>>>>>   vfio/pci: Add framework for custom interrupt indices
> >>>>>>>   vfio/pci: Register and allow DMA FAULT IRQ signaling
> >>>>>>>   vfio: Document nested stage control
> >>>>>>>
> >>>>>>> Liu, Yi L (2):
> >>>>>>>   vfio: VFIO_IOMMU_SET_PASID_TABLE
> >>>>>>>   vfio: VFIO_IOMMU_CACHE_INVALIDATE
> >>>>>>>
> >>>>>>> Tina Zhang (1):
> >>>>>>>   vfio: Use capability chains to handle device specific irq
> >>>>>>>
> >>>>>>>  Documentation/vfio.txt              |  77 ++++++++
> >>>>>>>  drivers/vfio/pci/vfio_pci.c         | 283
> >>>>> ++++++++++++++++++++++++++--
> >>>>>>>  drivers/vfio/pci/vfio_pci_intrs.c   |  62 ++++++
> >>>>>>>  drivers/vfio/pci/vfio_pci_private.h |  24 +++
> >>>>>>>  drivers/vfio/pci/vfio_pci_rdwr.c    |  45 +++++
> >>>>>>>  drivers/vfio/vfio_iommu_type1.c     | 166 ++++++++++++++++
> >>>>>>>  include/uapi/linux/vfio.h           | 109 ++++++++++-
> >>>>>>>  7 files changed, 747 insertions(+), 19 deletions(-)
> >>>>>>>
> >>>>>>> --
> >>>>>>> 2.20.1
> >>>>>>>
> >>>>>>> _______________________________________________
> >>>>>>> kvmarm mailing list
> >>>>>>> kvmarm@lists.cs.columbia.edu
> >>>>>>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >>>>
> >

