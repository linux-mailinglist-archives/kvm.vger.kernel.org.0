Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952262B5AEC
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 09:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgKQIZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 03:25:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgKQIZ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 03:25:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605601554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZSuUKIfTQbV7/SoLesS7J9SBrKd/8hvaQUTwyNieAhI=;
        b=CsoykzLYJ9ghYFHYoWXHhgFERN7HBYqm5ucq9ABQQMOiD3FZ9q+qL4+QyglN2WtM0P8aQ7
        KjUVmSSpS/7sw7fWzy3MgGfhe1gGx5hlVLy4DAoii0L6WtIyPrWlQg6/+Sv+0Q0nqk3fOm
        cKzVhJx8BZ7WvyHoQ3R8ShBmVMm6H5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-m6pNnaa4PtOCY4KyKsB9-A-1; Tue, 17 Nov 2020 03:25:49 -0500
X-MC-Unique: m6pNnaa4PtOCY4KyKsB9-A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B586A6D24D;
        Tue, 17 Nov 2020 08:25:47 +0000 (UTC)
Received: from [10.36.113.230] (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8175E60C04;
        Tue, 17 Nov 2020 08:25:42 +0000 (UTC)
Subject: Re: [RFC, v1 0/3] msi support for platform devices
From:   Auger Eric <eric.auger@redhat.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Manish Kurup <manish.kurup@broadcom.com>
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201112175852.21572-1-vikas.gupta@broadcom.com>
 <96436cba-88e3-ddb6-36d6-000929b86979@redhat.com>
 <CAHLZf_uAp-CzA-rkvFF70wT5zoB98OvErXxFthoBHyvzwTRxAQ@mail.gmail.com>
 <c78d2706-f406-32ab-1637-bd0c9f459e23@redhat.com>
 <CAHLZf_uQBzQndGo1vtPtrUd2KXk+im=A9evowggzk6U=5vEvAg@mail.gmail.com>
 <92188bdf-e0a9-aad9-d26b-78a5443f2a47@redhat.com>
Message-ID: <e44a2949-b86f-52a9-501c-4f099b820dcd@redhat.com>
Date:   Tue, 17 Nov 2020 09:25:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <92188bdf-e0a9-aad9-d26b-78a5443f2a47@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 11/17/20 9:05 AM, Auger Eric wrote:
> Hi Vikas,
> 
> On 11/17/20 7:25 AM, Vikas Gupta wrote:
>> Hi Eric,
>>
>> On Mon, Nov 16, 2020 at 6:44 PM Auger Eric <eric.auger@redhat.com> wrote:
>>>
>>> Hi Vikas,
>>>
>>> On 11/13/20 6:24 PM, Vikas Gupta wrote:
>>>> Hi Eric,
>>>>
>>>> On Fri, Nov 13, 2020 at 12:10 AM Auger Eric <eric.auger@redhat.com> wrote:
>>>>>
>>>>> Hi Vikas,
>>>>>
>>>>> On 11/12/20 6:58 PM, Vikas Gupta wrote:
>>>>>> This RFC adds support for MSI for platform devices.
>>>>>> a) MSI(s) is/are added in addition to the normal interrupts.
>>>>>> b) The vendor specific MSI configuration can be done using
>>>>>>    callbacks which is implemented as msi module.
>>>>>> c) Adds a msi handling module for the Broadcom platform devices.
>>>>>>
>>>>>> Changes from:
>>>>>> -------------
>>>>>>  v0 to v1:
>>>>>>    i)  Removed MSI device flag VFIO_DEVICE_FLAGS_MSI.
>>>>>>    ii) Add MSI(s) at the end of the irq list of platform IRQs.
>>>>>>        MSI(s) with first entry of MSI block has count and flag
>>>>>>        information.
>>>>>>        IRQ list: Allocation for IRQs + MSIs are allocated as below
>>>>>>        Example: if there are 'n' IRQs and 'k' MSIs
>>>>>>        -------------------------------------------------------
>>>>>>        |IRQ-0|IRQ-1|....|IRQ-n|MSI-0|MSI-1|MSI-2|......|MSI-k|
>>>>>>        -------------------------------------------------------
>>>>> I have not taken time yet to look at your series, but to me you should have
>>>>> |IRQ-0|IRQ-1|....|IRQ-n|MSI|MSIX
>>>>> then for setting a given MSIX (i) you would select the MSIx index and
>>>>> then set start=i count=1.
>>>>
>>>> As per your suggestion, we should have, if there are n-IRQs, k-MSIXs
>>>> and m-MSIs, allocation of IRQs should be done as below
>>>>
>>>> |IRQ0|IRQ1|......|IRQ-(n-1)|MSI|MSIX|
>>>>                                              |        |
>>>>                                              |
>>>> |MSIX0||MSIX1||MSXI2|....|MSIX-(k-1)|
>>>>                                              |MSI0||MSI1||MSI2|....|MSI-(m-1)|
>>> No I really meant this list of indices: IRQ0|IRQ1|......|IRQ-(n-1)|MSI|MSIX|
>>> and potentially later on IRQ0|IRQ1|......|IRQ-(n-1)|MSI|MSIX| ERR| REQ
>>> if ERR/REQ were to be added.
>> I agree on this. Actually the map I drew incorrectly above but wanted
>> to demonstrate the same. It was a child-parent relationship for MSI
>> and its members and similarly for MSIX as well.
>>>
>>> I think the userspace could query the total number of indices using
>>> VFIO_DEVICE_GET_INFO and retrieve num_irqs (corresponding to the n wire
>>> interrupts + MSI index + MSIX index)
>>>
>>> Then userspace can loop on all the indices using
>>> VFIO_DEVICE_GET_IRQ_INFO. For each index it uses count to determine the
>>> first indices related to wire interrupts (count = 1). Then comes the MSI
>>> index, and after the MSI index. If any of those is supported, count >1,
>>> otherwise count=0. The only thing I am dubious about is can the device
>>> use a single MSI/MSIX? Because my hypothesis here is we use count to
>>> discriminate between wire first indices and other indices.
>> I believe count can be one as well, especially for ERR/REQ as you
>> mentioned above.
> Given ERR and REQ indices would follow MSI and MSIX ones, MSI index
> could be recognized by the first index whose count != 1. But indeed I am
> not sure the number of supported vectors cannot be 1. In your case it is
> induced by the size of the ring so it is OK but for other devices this
> may be different.
> 
> I think we can not rely on the count > 1. Now, this is
>> blocking and we are not left with options unless we consider adding
>> more enums in flags in vfio_irq_info to tell userspace that particular
>> index is wired, MSI, MSIX etc. for the platform device.
>> What do you think?
> If count is not reliable to discriminate the first n wired interrupts
> from the subsequen MSI and MSIx index, Alex suggested to add a
> capability extension in the vfio_irq_info structure. Something similar
> to what was done for vfio_region_info.
> 
> Such kind of thing was attempted in
> https://lore.kernel.org/kvmarm/20201116110030.32335-8-eric.auger@redhat.com/T/#u
> 
> ` [PATCH v11 07/13] vfio: Use capability chains to handle device
> specific irq
> ` [PATCH v11 08/13] vfio/pci: Add framework for custom interrupt indices
> ` [PATCH v11 09/13] vfio: Add new IRQ for DMA fault reporting

By the way I was mentionning MSI/MSIx in my previous reply but, as Alex
pointed out, with platform device only a single MSI index does make
sense, no?

Thanks

Eric
> 
> Note this has not been reviewed yet.
> 
> Thanks
> 
> Eric
> 
>>>
>>>
>>>
>>>> With this implementation user space can know that, at indexes n and
>>>> n+1, edge triggered interrupts are present.
>>> note wired interrupts can also be edge ones.
>>>>    We may add an element in vfio_platform_irq itself to allocate MSIs/MSIXs
>>>>    struct vfio_platform_irq{
>>>>    .....
>>>>    .....
>>>>    struct vfio_platform_irq *block; => this points to the block
>>>> allocation for MSIs/MSIXs and all msi/msix are type of IRQs.As wired interrupts and MSI interrupts coexist, I would store in vdev an
>>> array of wired interrupts (the existing vdev->irqs) and a new array for
>>> MSI(x) as done in the PCI code.
>>>
>>> vdev->ctx = kcalloc(nvec, sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
>>>
>>> Does it make sense?
>> Yes, we can use similar kinds of allocations.
>>
>> Thanks,
>> Vikas
>>>
>>>>    };
>>>>                          OR
>>>> Another structure can be defined in 'vfio_pci_private.h'
>>>> struct vfio_msi_ctx {
>>>>         struct eventfd_ctx      *trigger;
>>>>         char                    *name;
>>>> };
>>>> and
>>>> struct vfio_platform_irq {
>>>>   .....
>>>>   .....
>>>>   struct vfio_msi_ctx *block; => this points to the block allocation
>>>> for MSIs/MSIXs
>>>> };
>>>> Which of the above two options sounds OK to you? Please suggest.
>>>>
>>>>> to me individual MSIs are encoded in the subindex and not in the index.
>>>>> The index just selects the "type" of interrupt.
>>>>>
>>>>> For PCI you just have:
>>>>>         VFIO_PCI_INTX_IRQ_INDEX,
>>>>>         VFIO_PCI_MSI_IRQ_INDEX, -> MSI index and then you play with
>>>>> start/count
>>>>>         VFIO_PCI_MSIX_IRQ_INDEX,
>>>>>         VFIO_PCI_ERR_IRQ_INDEX,
>>>>>         VFIO_PCI_REQ_IRQ_INDEX,
>>>>>
>>>>> (include/uapi/linux/vfio.h)
>>>>
>>>> In pci case, type of interrupts is fixed so they can be 'indexed' by
>>>> these enums but for VFIO platform user space will need to iterate all
>>>> (num_irqs) indexes to know at which indexes edge triggered interrupts
>>>> are present.
>>> indeed, but can't you loop over all indices looking until count !=1? At
>>> this point you know if have finished emurating the wires. Holds if
>>> MSI(x) count !=1 of course.
>>>
>>> Thanks
>>>
>>> Eric
>>>
>>>>
>>>> Thanks,
>>>> Vikas
>>>>>
>>>>> Thanks
>>>>>
>>>>> Eric
>>>>>>        MSI-0 will have count=k set and flags set accordingly.
>>>>>>
>>>>>> Vikas Gupta (3):
>>>>>>   vfio/platform: add support for msi
>>>>>>   vfio/platform: change cleanup order
>>>>>>   vfio/platform: add Broadcom msi module
>>>>>>
>>>>>>  drivers/vfio/platform/Kconfig                 |   1 +
>>>>>>  drivers/vfio/platform/Makefile                |   1 +
>>>>>>  drivers/vfio/platform/msi/Kconfig             |   9 +
>>>>>>  drivers/vfio/platform/msi/Makefile            |   2 +
>>>>>>  .../vfio/platform/msi/vfio_platform_bcmplt.c  |  74 ++++++
>>>>>>  drivers/vfio/platform/vfio_platform_common.c  |  86 ++++++-
>>>>>>  drivers/vfio/platform/vfio_platform_irq.c     | 238 +++++++++++++++++-
>>>>>>  drivers/vfio/platform/vfio_platform_private.h |  23 ++
>>>>>>  8 files changed, 419 insertions(+), 15 deletions(-)
>>>>>>  create mode 100644 drivers/vfio/platform/msi/Kconfig
>>>>>>  create mode 100644 drivers/vfio/platform/msi/Makefile
>>>>>>  create mode 100644 drivers/vfio/platform/msi/vfio_platform_bcmplt.c
>>>>>>
>>>>>
>>>

