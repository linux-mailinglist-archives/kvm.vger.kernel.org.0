Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3106351A212
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 16:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351254AbiEDOYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 10:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351251AbiEDOYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 10:24:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19252CE39
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 07:21:00 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244EKrRR020961;
        Wed, 4 May 2022 14:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3ed2Ws8qLmO5dz/0UTvlzsSzcYkhW3e+Kz/UBvLyans=;
 b=RfNu9c05iLdxDO5+b6aCJi17rgD6YIRToQpP8JfJZ3qbKW1vVtviFClxJuQYO1mAx2df
 g3X2XUTZiU5H1buBoVVv1cUy7B+3wtjecmc5GUXCIxh+q3rekK4/Gj6OYNZlpzArgLSA
 Mm+TgC3NpSASrw3GuqlXkQlNLXekj1okdA59DllxA5ksyED4zVbm2fMpShPVnX2rxrJT
 dVtY+zQ+HLE9zG3crawX55xvlrBRpuraFSXvd0eO6Kl5bdoRkaiiMzRZ+gt9VlWuYOel
 UqondejHeZpcTFZANdtLbLCih2EOhjAK2tJVjGiGROvMT19T7FJJa2P+Y7nOWVGFhQx1 Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fuu5xr01u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 14:20:53 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 244EKmnh020853;
        Wed, 4 May 2022 14:20:48 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fuu5xr01a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 14:20:48 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 244EIQSc030200;
        Wed, 4 May 2022 14:20:47 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 3frvr9u39t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 14:20:47 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 244EKk3d18088402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 14:20:46 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 805F828059;
        Wed,  4 May 2022 14:20:46 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6459828066;
        Wed,  4 May 2022 14:20:43 +0000 (GMT)
Received: from [9.211.41.182] (unknown [9.211.41.182])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  4 May 2022 14:20:43 +0000 (GMT)
Message-ID: <205306ba-d046-8487-d89f-d8e2335c3a23@linux.ibm.com>
Date:   Wed, 4 May 2022 10:20:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 7/9] s390x/pci: enable adapter event notification for
 interpreted devices
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        qemu-s390x@nongnu.org, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-8-mjrosato@linux.ibm.com>
 <31b5f911-0e1f-ba3c-94f2-1947d5b16057@linux.ibm.com>
 <9a171204-6d71-ee1d-d8bd-cd4eac91c3d5@linux.ibm.com>
 <d14625f4-d648-05d9-38aa-a5ad7e0c9cf5@linux.ibm.com>
 <2df134498bf60e4878bdb362a28c56ec32d902f8.camel@linux.ibm.com>
 <eb2fde35-7b9d-a8c8-3212-ae92b2b3e754@linux.ibm.com>
 <8ad9f2c8-9fb8-cb47-fd1e-f9a33eced548@linux.ibm.com>
 <d0e37544-f355-b1cf-5fc0-77e25b20b459@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <d0e37544-f355-b1cf-5fc0-77e25b20b459@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lYSk3IB9uZqkzmhSjGaG1ESid9Gm38bs
X-Proofpoint-ORIG-GUID: V37tMoz9noxkg-Zg3WkZ6Hzfw5KXoIPs
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_04,2022-05-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 bulkscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040090
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/22 10:53 AM, Pierre Morel wrote:
> 
> 
> On 5/2/22 21:57, Matthew Rosato wrote:
>> On 5/2/22 7:30 AM, Pierre Morel wrote:
>>>
>>>
>>> On 5/2/22 11:19, Niklas Schnelle wrote:
>>>> On Mon, 2022-05-02 at 09:48 +0200, Pierre Morel wrote:
>>>>>
>>>>> On 4/22/22 14:10, Matthew Rosato wrote:
>>>>>> On 4/22/22 5:39 AM, Pierre Morel wrote:
>>>>>>>
>>>>>>> On 4/4/22 20:17, Matthew Rosato wrote:
>>>>>>>> Use the associated kvm ioctl operation to enable adapter event
>>>>>>>> notification
>>>>>>>> and forwarding for devices when requested.  This feature will be 
>>>>>>>> set up
>>>>>>>> with or without firmware assist based upon the 'forwarding_assist'
>>>>>>>> setting.
>>>>>>>>
>>>>>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>>>>>> ---
>>>>>>>>    hw/s390x/s390-pci-bus.c         | 20 ++++++++++++++---
>>>>>>>>    hw/s390x/s390-pci-inst.c        | 40 
>>>>>>>> +++++++++++++++++++++++++++++++--
>>>>>>>>    hw/s390x/s390-pci-kvm.c         | 30 +++++++++++++++++++++++++
>>>>>>>>    include/hw/s390x/s390-pci-bus.h |  1 +
>>>>>>>>    include/hw/s390x/s390-pci-kvm.h | 14 ++++++++++++
>>>>>>>>    5 files changed, 100 insertions(+), 5 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
>>>>>>>> index 9c02d31250..47918d2ce9 100644
>>>>>>>> --- a/hw/s390x/s390-pci-bus.c
>>>>>>>> +++ b/hw/s390x/s390-pci-bus.c
>>>>>>>> @@ -190,7 +190,10 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
>>>>>>>>            rc = SCLP_RC_NO_ACTION_REQUIRED;
>>>>>>>>            break;
>>>>>>>>        default:
>>>>>>>> -        if (pbdev->summary_ind) {
>>>>>>>> +        if (pbdev->interp && (pbdev->fh & FH_MASK_ENABLE)) {
>>>>>>>> +            /* Interpreted devices were using interrupt 
>>>>>>>> forwarding */
>>>>>>>> +            s390_pci_kvm_aif_disable(pbdev);
>>>>>>>
>>>>>>> Same remark as for the kernel part.
>>>>>>> The VFIO device is already initialized and the action is on this
>>>>>>> device, Shouldn't we use the VFIO device interface instead of the 
>>>>>>> KVM
>>>>>>> interface?
>>>>>>>
>>>>>>
>>>>>> I don't necessarily disagree, but in v3 of the kernel series I was 
>>>>>> told
>>>>>> not to use VFIO ioctls to accomplish tasks that are unique to KVM 
>>>>>> (e.g.
>>>>>> AEN interpretation) and to instead use a KVM ioctl.
>>>>>>
>>>>>> VFIO_DEVICE_SET_IRQS won't work as-is for reasons described in the
>>>>>> kernel series (e.g. we don't see any of the config space notifiers
>>>>>> because of instruction interpretation) -- as far as I can figure we
>>>>>> could add our own s390 code to QEMU to issue VFIO_DEVICE_SET_IRQS
>>>>>> directly for an interpreted device, but I think would also need
>>>>>> s390-specific changes to VFIO_DEVICE_SET_IRQS accommodate this (e.g.
>>>>>> maybe something like a VFIO_IRQ_SET_DATA_S390AEN where we can then
>>>>>> specify the aen information in vfio_irq_set.data -- or something 
>>>>>> else I
>>>>>
>>>>> Hi,
>>>>>
>>>>> yes this in VFIO_DEVICE_SET_IRQS is what I think should be done.
>>>>>
>>>>>> haven't though of yet) -- I can try to look at this some more and 
>>>>>> see if
>>>>>> I get a good idea.
>>>>>
>>>>>
>>>>> I understood that the demand was concerning the IOMMU but I may be 
>>>>> wrong.
>>
>> The IOMMU was an issue, but the request to move the ioctl out of vfio 
>> to kvm was specifically because these ioctl operations were only 
>> relevant for VMs and are not applicable to vfio uses cases outside of 
>> virtualization.
>>
>> https://lore.kernel.org/kvm/20220208185141.GH4160@nvidia.com/
> 
> I absolutely agree that KVM specific handling should go through KVM fd.
> But as I say here under, AEN is not KVM specific but device specific.
> Instruction interpretation is KVM specific.
> see later---v
> 
>>
>>>>> For my opinion, the handling of AEN is not specific to KVM but 
>>>>> specific
>>>>> to the device, for example the code should be the same if Z ever 
>>>>> decide
>>>>> to use XEN or another hypervizor, except for the GISA part but this 
>>>>> part
>>>>> is already implemented in KVM in a way it can be used from a device 
>>>>> like
>>>>> in VFIO AP.
>>
>>
>> Fundamentally, these operations are valid only when you have _both_ a 
>> virtual machine and vfio device.  (Yes, you could swap in a new 
>> hypervisor with a new GISA implementation, but at the end of it the 
>> hypervisor must still provide the GISA designation for this to work)
>>
>> If fh lookup is a concern, one idea that Jason floated was passing the 
>> vfio device fd as an argument to the kvm ioctl (so pass this down on a 
>> kvm ioctl from userspace instead of a fh) and then using a new vfio 
>> external API to get the relevant device from the provided fd.
>>
>> https://lore.kernel.org/kvm/20220208195117.GI4160@nvidia.com/
> 
> ^------
> This looks like a wrong architecture to me.
> 
> If something is used to virtualize the I/O of a device it should go 
> through the device VFIO fd.
> 
> If we need a new VFIO external API why not using an extension of the 
> VFIO_DEVICE_SET_IRQS and use directly the VFIO device to setup interrupts?
> 
> see following ----v
> 
>>
>>>>>
>>>>> @Alex, what do you think?
>>>>>
>>>>> Regards,
>>>>> Pierre
>>>>>
>>>>
>>>> As I understand it the question isn't if it is specific to KVM but
>>>> rather if it is specific to virtualization. As vfio-pci is also used
>>>> for non virtualization purposes such as with DPDK/SPDK or a fully
>>>> emulating QEMU, it should only be in VFIO if it is relevant for these
>>>> kinds of user-space PCI accesses too. I'm not an AEN expert but as I
>>>> understand it, this does forwarding interrupts into a SIE context which
>>>> only makes sense for virtualization not for general user-space PCI.
>>
>> Right, AEN forwarding is only relevant for virtual machines.
>>
>>>>
>>>
>>> Being in VFIO kernel part does not mean that this part should be 
>>> called from any user of VFIO in userland.
>>> That is a reason why I did propose an extension and not using the 
>>> current implementation of VFIO_DEVICE_SET_IRQS as is.
>>>
>>> The reason behind is that the AEN hardware handling is device 
>>> specific: we need the Function Handle to program AEN.
>>
>> You also need the GISA designation which is provided by the kvm or you 
>> also can't program AEN.  So you ultimately need both a function handle 
>> that is 'owned' by the device (vfio device fd) and the GISA 
>> designation that is 'owned' by kvm (kvm fd).  So there are 2 different 
>> "owning" fds involved.
> 
> Yes GISA is a host structure, not device specific but guest specific and 
> exist very soon during the guest creation, there should be no problem to 
> retrieve it from a VFIO device IOTCL.
> 
>>
>>>
>>> If the API is through KVM which is device agnostic the implementation 
>>> in KVM has to search through the system to find the device being 
>>> handled to apply AEN on it.
>>
>> See comment above about instead passing the vfio device fd.
>>
>>>
>>> This not the logical way for me and it is a potential source of 
>>> problems for future extensions.
>>>
>>
>>
>>
> ^------
> 
> There are three different things to modify for the Z-guest to use VFIO:
> - IOMMU
> - device IRQ
> - instruction interpretation, feature negociation
> 
> For my opinion only the last one should go directly through the KVM fd.
> 
> This should be possible for all architectures.
> If it is not possible for Z, the failing path must be adapted it should 
> not go through another path.
> 
> Giving the right IRQ information to the host can be done with a 
> dedicated IOCTL through the VFIO device fd, just like we need an 
> extension in the other direction to retrieve the Z specific capabilities.
> 
> I am quite sure that other architectures will need some specificity too 
> for the interrupt or IOMMU handling in the future with increasing 
> implementation of virtualization in the firmware.
> 
> Having a dedicated IOCTL command means it can be called from QEMU and 
> for guest virtualizuation only then let unused for other userland access.
> 

Another approach (that I admittedly don't have all the details worked 
out on yet) would be to do something like add a new type of 
kvm_irq_routing_entry that can be used specifically for AEN.  Then we 
can establish this route with the following info:

struct kvm_irq_routing_s390_aen {
        __u64 ind_addr;
        __u64 summary_addr;
        __u32 fd; /* vfio device fd */
        __u32 noi;
        __u8  isc;
        __u8  sbo;
};

The vfio device fd is required as it would then be used to get the 
associated zdev and thus its fh, which we need when we go to activate 
AEN (mpcifc).  Our existing adapter-based routes 
(kvm_irq_routing_s390_adapter) lack this association and I can't think 
of a way around that besides introducing a different route type.

During interrupt.c:kvm_set_routing_entry() we can stash the guest info + 
fd.  Then during irq_bypass_{add,del}_producer for this new route type 
we can find the zpci->fh via the vfio device fd and then actually 
(un)pin guest addresses / issue the host mpcfic using the routing info. 
vfio will trigger irq_bypass_{add,del}_producer when the virq is 
enabled/disabled.

 From QEMU though, it gets a bit weird -- since we enable load/store 
interpretation, we will never see any of the config space writes from 
the guest.  So, vfio MSI notifiers never get triggered to call e.g. 
kvm_irqchip_add_msi_route -- we would have to do this ourselves in 
s390x-pci, specifying the new route type above.  And then also possibly 
issue our own VFIO_DEVICE_SET_IRQS since again, it will never get 
tripped via a vfio notifier.

Or alternatively, we can intentionally trigger the MSI notifiers from 
s390x-pci code (looks like spapr does this via spapr_msi_setmsg) for the 
number of vectors the guest specifies on the mpcific to create the 
necessary virq(s) and drive the subsequent VFIO_DEVICE_SET_IRQ call. 
Actually, we might have to do that anyway to satisfy 
VFIO_DEVICE_SET_IRQS expectations in the kernel.  And, using the above 
structure, we probably only need to create a single virq since it 
contains all of the routes in one payload + once AEN is established we 
are always delivering interrupts to the guest via GISA, not over eventfd.

