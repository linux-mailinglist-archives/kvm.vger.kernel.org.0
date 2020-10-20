Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2490D2934B7
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403825AbgJTGSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:18:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403822AbgJTGSo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 02:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603174720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yakA5+o0yqSVDgAhJgMTy9LHcq3IjgvzJY634uMTKYs=;
        b=RCY3DZqFvv2Qa+tDapPElL8ZYVvhGz14kOsb8yftklpvbDhvyat1y6G+LFkN9Hw/vT0Ycq
        KhFU+HEWjnbMZsvhZ2iC9ISKpTztvWyWWXKBa98IhRqNjIcEvzHRQLlPuzofQWDWa0Yt7l
        20EFzogj4NZB7NDMONMhwzU6t3BLTyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-ih3ue7zYNH62EtLZ4U5wcA-1; Tue, 20 Oct 2020 02:18:38 -0400
X-MC-Unique: ih3ue7zYNH62EtLZ4U5wcA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BB7D425DB;
        Tue, 20 Oct 2020 06:18:36 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F55B60BF3;
        Tue, 20 Oct 2020 06:18:13 +0000 (UTC)
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Cc:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <45faf89a-0a40-2a7a-0a76-d7ba76d0813b@redhat.com>
 <MWHPR11MB1645CF252CF3493F4A9487508C050@MWHPR11MB1645.namprd11.prod.outlook.com>
 <9c10b681-dd7e-2e66-d501-7fcc3ff1207a@redhat.com>
 <MWHPR11MB164501E77BDB0D5AABA8487F8C020@MWHPR11MB1645.namprd11.prod.outlook.com>
 <21a66a96-4263-7df2-3bec-320e6f38a9de@redhat.com>
 <DM5PR11MB143531293E4D65028801FDA1C3020@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a43d47f5-320b-ef60-e2be-a797942ea9f2@redhat.com>
Date:   Tue, 20 Oct 2020 14:18:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB143531293E4D65028801FDA1C3020@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/10/15 下午6:14, Liu, Yi L wrote:
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Thursday, October 15, 2020 4:41 PM
>>
>>
>> On 2020/10/15 ??3:58, Tian, Kevin wrote:
>>>> From: Jason Wang <jasowang@redhat.com>
>>>> Sent: Thursday, October 15, 2020 2:52 PM
>>>>
>>>>
>>>> On 2020/10/14 ??11:08, Tian, Kevin wrote:
>>>>>> From: Jason Wang <jasowang@redhat.com>
>>>>>> Sent: Tuesday, October 13, 2020 2:22 PM
>>>>>>
>>>>>>
>>>>>> On 2020/10/12 ??4:38, Tian, Kevin wrote:
>>>>>>>> From: Jason Wang <jasowang@redhat.com>
>>>>>>>> Sent: Monday, September 14, 2020 12:20 PM
>>>>>>>>
>>>>>>> [...]
>>>>>>>      > If it's possible, I would suggest a generic uAPI instead of
>>>>>>> a VFIO
>>>>>>>> specific one.
>>>>>>>>
>>>>>>>> Jason suggest something like /dev/sva. There will be a lot of
>>>>>>>> other subsystems that could benefit from this (e.g vDPA).
>>>>>>>>
>>>>>>>> Have you ever considered this approach?
>>>>>>>>
>>>>>>> Hi, Jason,
>>>>>>>
>>>>>>> We did some study on this approach and below is the output. It's a
>>>>>>> long writing but I didn't find a way to further abstract w/o
>>>>>>> losing necessary context. Sorry about that.
>>>>>>>
>>>>>>> Overall the real purpose of this series is to enable IOMMU nested
>>>>>>> translation capability with vSVA as one major usage, through below
>>>>>>> new uAPIs:
>>>>>>> 	1) Report/enable IOMMU nested translation capability;
>>>>>>> 	2) Allocate/free PASID;
>>>>>>> 	3) Bind/unbind guest page table;
>>>>>>> 	4) Invalidate IOMMU cache;
>>>>>>> 	5) Handle IOMMU page request/response (not in this series);
>>>>>>> 1/3/4) is the minimal set for using IOMMU nested translation, with
>>>>>>> the other two optional. For example, the guest may enable vSVA on
>>>>>>> a device without using PASID. Or, it may bind its gIOVA page table
>>>>>>> which doesn't require page fault support. Finally, all operations
>>>>>>> can be applied to either physical device or subdevice.
>>>>>>>
>>>>>>> Then we evaluated each uAPI whether generalizing it is a good
>>>>>>> thing both in concept and regarding to complexity.
>>>>>>>
>>>>>>> First, unlike other uAPIs which are all backed by iommu_ops, PASID
>>>>>>> allocation/free is through the IOASID sub-system.
>>>>>> A question here, is IOASID expected to be the single management
>>>>>> interface for PASID?
>>>>> yes
>>>>>
>>>>>> (I'm asking since there're already vendor specific IDA based PASID
>>>>>> allocator e.g amdgpu_pasid_alloc())
>>>>> That comes before IOASID core was introduced. I think it should be
>>>>> changed to use the new generic interface. Jacob/Jean can better
>>>>> comment if other reason exists for this exception.
>>>> If there's no exception it should be fixed.
>>>>
>>>>
>>>>>>>      From this angle
>>>>>>> we feel generalizing PASID management does make some sense.
>>>>>>> First, PASID is just a number and not related to any device before
>>>>>>> it's bound to a page table and IOMMU domain. Second, PASID is a
>>>>>>> global resource (at least on Intel VT-d),
>>>>>> I think we need a definition of "global" here. It looks to me for
>>>>>> vt-d the PASID table is per device.
>>>>> PASID table is per device, thus VT-d could support per-device PASIDs
>>>>> in concept.
>>>> I think that's the requirement of PCIE spec which said PASID + RID
>>>> identifies the process address space ID.
>>>>
>>>>
>>>>>     However on Intel platform we require PASIDs to be managed in
>>>>> system-wide (cross host and guest) when combining vSVA, SIOV, SR-IOV
>>>>> and ENQCMD together.
>>>> Any reason for such requirement? (I'm not familiar with ENQCMD, but
>>>> my understanding is that vSVA, SIOV or SR-IOV doesn't have the
>>>> requirement for system-wide PASID).
>>> ENQCMD is a new instruction to allow multiple processes submitting
>>> workload to one shared workqueue. Each process has an unique PASID
>>> saved in a MSR, which is included in the ENQCMD payload to indicate
>>> the address space when the CPU sends to the device. As one process
>>> might issue ENQCMD to multiple devices, OS-wide PASID allocation is
>>> required both in host and guest side.
>>>
>>> When executing ENQCMD in the guest to a SIOV device, the guest
>>> programmed value in the PASID_MSR must be translated to a host PASID
>>> value for proper function/isolation as PASID represents the address
>>> space. The translation is done through a new VMCS PASID translation
>>> structure (per-VM, and 1:1 mapping). From this angle the host PASIDs
>>> must be allocated 'globally' cross all assigned devices otherwise it
>>> may lead to 1:N mapping when a guest process issues ENQCMD to multiple
>>> assigned devices/subdevices.
>>>
>>> There will be a KVM forum session for this topic btw.
>>
>> Thanks for the background. Now I see the restrict comes from ENQCMD.
>>
>>
>>>>> Thus the host creates only one 'global' PASID namespace but do use
>>>>> per-device PASID table to assure isolation between devices on Intel
>>>>> platforms. But ARM does it differently as Jean explained.
>>>>> They have a global namespace for host processes on all host-owned
>>>>> devices (same as Intel), but then per-device namespace when a device
>>>>> (and its PASID table) is assigned to userspace.
>>>>>
>>>>>> Another question, is this possible to have two DMAR hardware
>>>>>> unit(at least I can see two even in my laptop). In this case, is
>>>>>> PASID still a global resource?
>>>>> yes
>>>>>
>>>>>>>      while having separate VFIO/
>>>>>>> VDPA allocation interfaces may easily cause confusion in
>>>>>>> userspace, e.g. which interface to be used if both VFIO/VDPA devices exist.
>>>>>>> Moreover, an unified interface allows centralized control over how
>>>>>>> many PASIDs are allowed per process.
>>>>>> Yes.
>>>>>>
>>>>>>
>>>>>>> One unclear part with this generalization is about the permission.
>>>>>>> Do we open this interface to any process or only to those which
>>>>>>> have assigned devices? If the latter, what would be the mechanism
>>>>>>> to coordinate between this new interface and specific passthrough
>>>>>>> frameworks?
>>>>>> I'm not sure, but if you just want a permission, you probably can
>>>>>> introduce new capability (CAP_XXX) for this.
>>>>>>
>>>>>>
>>>>>>>      A more tricky case, vSVA support on ARM (Eric/Jean please
>>>>>>> correct me) plans to do per-device PASID namespace which is built
>>>>>>> on a bind_pasid_table iommu callback to allow guest fully manage
>>>>>>> its PASIDs on a given passthrough device.
>>>>>> I see, so I think the answer is to prepare for the namespace
>>>>>> support from the start. (btw, I don't see how namespace is handled
>>>>>> in current IOASID module?)
>>>>> The PASID table is based on GPA when nested translation is enabled
>>>>> on ARM SMMU. This design implies that the guest manages PASID table
>>>>> thus PASIDs instead of going through host-side API on assigned
>>>>> device. From this angle we don't need explicit namespace in the host
>>>>> API. Just need a way to control how many PASIDs a process is allowed
>>>>> to allocate in the global namespace. btw IOASID module already has
>>>>> 'set' concept per-process and PASIDs are managed per-set. Then the
>>>>> quota control can be easily introduced in the 'set' level.
>>>>>
>>>>>>>      I'm not sure
>>>>>>> how such requirement can be unified w/o involving passthrough
>>>>>>> frameworks, or whether ARM could also switch to global PASID
>>>>>>> style...
>>>>>>>
>>>>>>> Second, IOMMU nested translation is a per IOMMU domain capability.
>>>>>>> Since IOMMU domains are managed by VFIO/VDPA
>>>>>>>      (alloc/free domain, attach/detach device, set/get domain
>>>>>>> attribute, etc.), reporting/enabling the nesting capability is an
>>>>>>> natural extension to the domain uAPI of existing passthrough frameworks.
>>>>>>> Actually, VFIO already includes a nesting enable interface even
>>>>>>> before this series. So it doesn't make sense to generalize this
>>>>>>> uAPI out.
>>>>>> So my understanding is that VFIO already:
>>>>>>
>>>>>> 1) use multiple fds
>>>>>> 2) separate IOMMU ops to a dedicated container fd (type1 iommu)
>>>>>> 3) provides API to associated devices/group with a container
>>>>>>
>>>>>> And all the proposal in this series is to reuse the container fd.
>>>>>> It should be possible to replace e.g type1 IOMMU with a unified module.
>>>>> yes, this is the alternative option that I raised in the last paragraph.
>>>>>
>>>>>>> Then the tricky part comes with the remaining operations (3/4/5),
>>>>>>> which are all backed by iommu_ops thus effective only within an
>>>>>>> IOMMU domain. To generalize them, the first thing is to find a way
>>>>>>> to associate the sva_FD (opened through generic /dev/sva) with an
>>>>>>> IOMMU domain that is created by VFIO/VDPA. The second thing is to
>>>>>>> replicate {domain<->device/subdevice} association in /dev/sva path
>>>>>>> because some operations (e.g. page fault) is triggered/handled per
>>>>>>> device/subdevice.
>>>>>> Is there any reason that the #PF can not be handled via SVA fd?
>>>>> using per-device FDs or multiplexing all fault info through one
>>>>> sva_FD is just an implementation choice. The key is to mark faults
>>>>> per device/ subdevice thus anyway requires a userspace-visible
>>>>> handle/tag to represent device/subdevice and the domain/device
>>>>> association must be constructed in this new path.
>>>> I don't get why it requires a userspace-visible handle/tag. The
>>>> binding between SVA fd and device fd could be done either explicitly
>>>> or implicitly. So userspace know which (sub)device that this SVA fd is for.
>>>>
>>>>
>>>>>>>      Therefore, /dev/sva must provide both per- domain and
>>>>>>> per-device uAPIs similar to what VFIO/VDPA already does. Moreover,
>>>>>>> mapping page fault to subdevice requires pre- registering
>>>>>>> subdevice fault data to IOMMU layer when binding guest page table,
>>>>>>> while such fault data can be only retrieved from parent driver
>>>>>>> through VFIO/VDPA.
>>>>>>>
>>>>>>> However, we failed to find a good way even at the 1st step about
>>>>>>> domain association. The iommu domains are not exposed to the
>>>>>>> userspace, and there is no 1:1 mapping between domain and device.
>>>>>>> In VFIO, all devices within the same VFIO container share the
>>>>>>> address space but they may be organized in multiple IOMMU domains
>>>>>>> based on their bus type. How (should we let) the userspace know
>>>>>>> the domain information and open an sva_FD for each domain is the
>>>>>>> main problem here.
>>>>>> The SVA fd is not necessarily opened by userspace. It could be get
>>>>>> through subsystem specific uAPIs.
>>>>>>
>>>>>> E.g for vDPA if a vDPA device contains several vSVA-capable
>>>>>> domains, we
>>>> can:
>>>>>> 1) introduce uAPI for userspace to know the number of vSVA-capable
>>>>>> domain
>>>>>> 2) introduce e.g VDPA_GET_SVA_FD to get the fd for each
>>>>>> vSVA-capable domain
>>>>> and also new interface to notify userspace when a domain disappears
>>>>> or a device is detached?
>>>> You need to deal with this case even in VFIO, isn't it?
>>> No. VFIO doesn't expose domain knowledge to userspace.
>>
>> Neither did the above API I think.
>>
>>
>>>>>     Finally looks we are creating a completely set of new subsystem
>>>>> specific uAPIs just for generalizing another set of subsystem
>>>>> specific uAPIs. Remember after separating PASID mgmt.
>>>>> out then most of remaining vSVA uAPIs are simpler wrapper of IOMMU
>>>>> API. Replicating them is much easier logic than developing a new
>>>>> glue mechanism in each subsystem.
>>>> As discussed, the point is more than just simple generalizing. It's
>>>> about the limitation of current uAPI. So I have the following questions:
>>>>
>>>> Do we want a single PASID to be used by more than one devices?
>>> Yes.
>>>
>>>> If yes, do we want those devices to share I/O page tables?
>>> Yes.
>>>
>>>> If yes, which uAPI is  used to program the shared I/O page tables?
>>>>
>>> Page table binding needs to be done per-device, so the userspace will
>>> use VFIO uAPI for VFIO device and vDPA uAPI for vDPA device.
>>
>> Any design considerations for this, I think it should be done per PASID instead
>> (consider PASID is a global resource)?
> per device and per PASID. you may have a look from the below arch. PASID
> table is per device, the binding of page table are set to PASID table
> entry.
>
> "
> In VT-d implementation, PASID table is per device and maintained in the host.
> Guest PASID table is shadowed in VMM where virtual IOMMU is emulated.
>
>      .-------------.  .---------------------------.
>      |   vIOMMU    |  | Guest process CR3, FL only|
>      |             |  '---------------------------'
>      .----------------/
>      | PASID Entry |--- PASID cache flush -
>      '-------------'                       |
>      |             |                       V
>      |             |                CR3 in GPA
>      '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>        v        v                          v
> Host
>      .-------------.  .----------------------.
>      |   pIOMMU    |  | Bind FL for GVA-GPA  |
>      |             |  '----------------------'
>      .----------------/  |
>      | PASID Entry |     V (Nested xlate)
>      '----------------\.------------------------------.
>      |             |   |SL for GPA-HPA, default domain|
>      |             |   '------------------------------'
>      '-------------'
> Where:
>   - FL = First level/stage one page tables
>   - SL = Second level/stage two page tables
> "
> copied from https://lwn.net/Articles/807506/


Yes, but since PASID is a global identifier now, I think kernel should 
track the a device list per PASID? So for such binding, PASID should be 
sufficient for uAPI.


>
>>> The binding request is initiated by the virtual IOMMU, when capturing
>>> guest attempt of binding page table to a virtual PASID entry for a
>>> given device.
>>
>> And for L2 page table programming, if PASID is use by both e.g VFIO and
>> vDPA, user need to choose one of uAPI to build l2 mappings?
> for L2 page table mappings, it's done by VFIO MAP/UNMAP. for vdpa, I guess
> it is tlb flush. so you are right. Keeping L1/L2 page table management in
> a single uAPI set is also a reason for my current series which extends VFIO
> for L1 management.


I'm afraid that would introduce confusing to userspace. E.g:

1) when having only vDPA device, it uses vDPA uAPI to do l2 management
2) when vDPA shares PASID with VFIO, it will use VFIO uAPI to do the l2 
management?

Thanks


>
> Regards,
> Yi Liu
>
>> Thanks
>>
>>
>>> Thanks
>>> Kevin
>>>
>>>>>>> In the end we just realized that doing such generalization doesn't
>>>>>>> really lead to a clear design and instead requires tight coordination
>>>>>>> between /dev/sva and VFIO/VDPA for almost every new uAPI
>>>>>>> (especially about synchronization when the domain/device
>>>>>>> association is changed or when the device/subdevice is being reset/
>>>>>>> drained). Finally it may become a usability burden to the userspace
>>>>>>> on proper use of the two interfaces on the assigned device.
>>>>>>>
>>>>>>> Based on above analysis we feel that just generalizing PASID mgmt.
>>>>>>> might be a good thing to look at while the remaining operations are
>>>>>>> better being VFIO/VDPA specific uAPIs. anyway in concept those are
>>>>>>> just a subset of the page table management capabilities that an
>>>>>>> IOMMU domain affords. Since all other aspects of the IOMMU domain
>>>>>>> is managed by VFIO/VDPA already, continuing this path for new nesting
>>>>>>> capability sounds natural. There is another option by generalizing the
>>>>>>> entire IOMMU domain management (sort of the entire vfio_iommu_
>>>>>>> type1), but it's unclear whether such intrusive change is worthwhile
>>>>>>> (especially when VFIO/VDPA already goes different route even in legacy
>>>>>>> mapping uAPI: map/unmap vs. IOTLB).
>>>>>>>
>>>>>>> Thoughts?
>>>>>> I'm ok with starting with a unified PASID management and consider the
>>>>>> unified vSVA/vIOMMU uAPI later.
>>>>>>
>>>>> Glad to see that we have consensus here. :)
>>>>>
>>>>> Thanks
>>>>> Kevin

