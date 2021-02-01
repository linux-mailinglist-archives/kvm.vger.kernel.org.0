Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D3E30A488
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 10:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhBAJlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 04:41:39 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18656 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbhBAJlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 04:41:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6017cca50000>; Mon, 01 Feb 2021 01:40:53 -0800
Received: from [172.27.0.0] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 09:40:48 +0000
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210122122503.4e492b96@omen.home.shazbot.org>
 <20210122200421.GH4147@nvidia.com>
 <20210125172035.3b61b91b.cohuck@redhat.com>
 <20210125180440.GR4147@nvidia.com>
 <20210125163151.5e0aeecb@omen.home.shazbot.org>
 <20210126004522.GD4147@nvidia.com>
 <20210125203429.587c20fd@x1.home.shazbot.org>
 <1419014f-fad2-9599-d382-9bba7686f1c4@nvidia.com>
 <20210128172930.74baff41.cohuck@redhat.com>
 <20210128140256.178d3912@omen.home.shazbot.org>
 <536caa01-7fef-7256-b281-03b40a6ca217@nvidia.com>
 <20210131213228.0e0573f4@x1.home.shazbot.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <44999661-5e15-deca-be22-545163d79919@nvidia.com>
Date:   Mon, 1 Feb 2021 11:40:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210131213228.0e0573f4@x1.home.shazbot.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612172453; bh=Cdd25w9vapEy0RLzraAd9AT/SDCNN+pdJq0tAuF8OXY=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=H9lc44ucojFJzy+g+WxOld4+bHR+BoAwAa6clHs9lvBromeTrspmIURYXVZ2mAxxr
         t8nZgOIlvu0vQX2flkTViX8QxRoFV3UDLhlKW7J0jqPgNjCW9sTZM8nl9Kc6TzvhND
         M/LrLmRzEX9iWhmDd52wW8S2KVKaBT3aRKEoI+7s2jmMrbAikYEFUZKPOcwroB5+fd
         Npa1zx+sP6SRdmJKVEne635EehFMfGowkqibljwi9INky6bKnLBjSprzvOaaBcBYIN
         CRMT5MnW9+pN3J3MhzNrjUGQSzzAP764OKuZ1U76NqeWqp5DDDLaY+y/YjUARoZXO+
         HkqFCZ3Qn4DHA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/1/2021 6:32 AM, Alex Williamson wrote:
> On Sun, 31 Jan 2021 20:46:40 +0200
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
>> On 1/28/2021 11:02 PM, Alex Williamson wrote:
>>> On Thu, 28 Jan 2021 17:29:30 +0100
>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>  =20
>>>> On Tue, 26 Jan 2021 15:27:43 +0200
>>>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>>>>> On 1/26/2021 5:34 AM, Alex Williamson wrote:
>>>>>> On Mon, 25 Jan 2021 20:45:22 -0400
>>>>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>>>       =20
>>>>>>> On Mon, Jan 25, 2021 at 04:31:51PM -0700, Alex Williamson wrote:
>>>>>>>> extensions potentially break vendor drivers, etc.  We're only even=
 hand
>>>>>>>> waving that existing device specific support could be farmed out t=
o new
>>>>>>>> device specific drivers without even going to the effort to prove =
that.
>>>>>>> This is a RFC, not a complete patch series. The RFC is to get feedb=
ack
>>>>>>> on the general design before everyone comits alot of resources and
>>>>>>> positions get dug in.
>>>>>>>
>>>>>>> Do you really think the existing device specific support would be a
>>>>>>> problem to lift? It already looks pretty clean with the
>>>>>>> vfio_pci_regops, looks easy enough to lift to the parent.
>>>>>>>       =20
>>>>>>>> So far the TODOs rather mask the dirty little secrets of the
>>>>>>>> extension rather than showing how a vendor derived driver needs to
>>>>>>>> root around in struct vfio_pci_device to do something useful, so
>>>>>>>> probably porting actual device specific support rather than furthe=
r
>>>>>>>> hand waving would be more helpful.
>>>>>>> It would be helpful to get actual feedback on the high level design=
 -
>>>>>>> someting like this was already tried in May and didn't go anywhere =
-
>>>>>>> are you surprised that we are reluctant to commit alot of resources
>>>>>>> doing a complete job just to have it go nowhere again?
>>>>>> That's not really what I'm getting from your feedback, indicating
>>>>>> vfio-pci is essentially done, the mlx stub driver should be enough t=
o
>>>>>> see the direction, and additional concerns can be handled with TODO
>>>>>> comments.  Sorry if this is not construed as actual feedback, I thin=
k
>>>>>> both Connie and I are making an effort to understand this and being
>>>>>> hampered by lack of a clear api or a vendor driver that's anything m=
ore
>>>>>> than vfio-pci plus an aux bus interface.  Thanks,
>>>>> I think I got the main idea and I'll try to summarize it:
>>>>>
>>>>> The separation to vfio-pci.ko and vfio-pci-core.ko is acceptable, and=
 we
>>>>> do need it to be able to create vendor-vfio-pci.ko driver in the futu=
re
>>>>> to include vendor special souse inside.
>>>> One other thing I'd like to bring up: What needs to be done in
>>>> userspace? Does a userspace driver like QEMU need changes to actually
>>>> exploit this? Does management software like libvirt need to be involve=
d
>>>> in decision making, or does it just need to provide the knobs to make
>>>> the driver configurable?
>>> I'm still pretty nervous about the userspace aspect of this as well.
>>> QEMU and other actual vfio drivers are probably the least affected,
>>> at least for QEMU, it'll happily open any device that has a pointer to
>>> an IOMMU group that's reflected as a vfio group device.  Tools like
>>> libvirt, on the other hand, actually do driver binding and we need to
>>> consider how they make driver decisions. Jason suggested that the
>>> vfio-pci driver ought to be only spec compliant behavior, which sounds
>>> like some deprecation process of splitting out the IGD, NVLink, zpci,
>>> etc. features into sub-drivers and eventually removing that device
>>> specific support from vfio-pci.  Would we expect libvirt to know, "this
>>> is an 8086 graphics device, try to bind it to vfio-pci-igd" or "uname
>>> -m says we're running on s390, try to bind it to vfio-zpci"?  Maybe we
>>> expect derived drivers to only bind to devices they recognize, so
>>> libvirt could blindly try a whole chain of drivers, ending in vfio-pci.
>>> Obviously if we have competing drivers that support the same device in
>>> different ways, that quickly falls apart.
>> I think we can leave common arch specific stuff, such as s390 (IIUC) in
>> the core driver. And only create vfio_pci drivers for
>> vendor/device/subvendor specific stuff.
> So on one hand you're telling us that the design principles here can be
> applied to various other device/platform specific support, but on the
> other you're saying, but don't do that...

I guess I was looking at nvlink2 as device specific.

But let's update the nvlink2, s390 and IGD a bit:

1. s390 -=C2=A0 config VFIO_PCI_ZDEV rename to config VFIO_PCI_S390 (it wil=
l=20
include all needed tweeks for S390)

2. nvlink2 - config VFIO_PCI_NVLINK2 rename to config VFIO_PCI_P9 (it=20
will include all needed tweeks for P9)

3. igd - config VFIO_PCI_IGD rename to config VFIO_PCI_X86 (it will=20
include all needed tweeks for X86)

All the 3 stays in the vfio-pci-core.ko since we might need S390 stuff=20
if we plug Network adapter from vendor-A or=C2=A0 NVMe adapter from vendor-=
B=20
for example. This is platform specific and we don't want to duplicate it=20
in each vendor driver.

Same for P9 (and nvlink2 is only a special case in there) and X86.

>  =20
>> Also, the competing drivers issue can also happen today, right ? after
>> adding new_id to vfio_pci I don't know how linux will behave if we'll
>> plug new device with same id to the system. which driver will probe it ?
> new_id is non-deterministic, that's why we have driver_override.

I'm not sure I understand how driver_override help in the competition ?

it's only enforce driver binding to a device.

if we have device AAA0 that is driven by aaa.ko and we add AAA as new_id=20
to vfio_pci and afterwards we plug AAA1 that is also driven by aaa.ko=20
and can be driven by vfio_pci.ko. what will happen ? will it be the=20
wanted behavior always ?

We will have a competition in any case in the current linux design. Only=20
now we add new players to the competition.

how does libvirt use driver_override ?

and why will it change in case of vendor specific vfio-pci driver ?


>  =20
>> I don't really afraid of competing drivers since we can ask from vendor
>> vfio pci_drivers to add vendor_id, device_id, subsystem_vendor and
>> subsystem_device so we won't have this problem. I don't think that there
>> will be 2 drivers that drive the same device with these 4 ids.
>>
>> Userspace tool can have a map of ids to drivers and bind the device to
>> the right vfio-pci vendor driver if it has one. if not, bind to vfio_pci=
.ko.
> As I've outlined, the support is not really per device, there might be
> a preferred default driver for the platform, ex. s390.
>
>>> Libvirt could also expand its available driver models for the user to
>>> specify a variant, I'd support that for overriding a choice that libvir=
t
>>> might make otherwise, but forcing the user to know this information is
>>> just passing the buck.
>> We can add a code to libvirt as mentioned above.
> That's rather the question here, what is that algorithm by which a
> userspace tool such as libvirt would determine the optimal driver for a
> device?

If exist, the optimal driver is the vendor driver according to mapping=20
of device_id + vendor_id + subsystem_device + subsystem_vendor to=20
vendor-vfio-pci.ko.

If not, bind to vfio-pci.ko.

Platform specific stuff will be handled in vfio-pci-core.ko and not in a=20
vendor driver. vendor drivers are for PCI devices and not platform tweeks.

>
>>> Some derived drivers could probably actually include device IDs rather
>>> than only relying on dynamic ids, but then we get into the problem that
>>> we're competing with native host driver for a device.  The aux bus
>>> example here is essentially the least troublesome variation since it
>>> works in conjunction with the native host driver rather than replacing
>>> it.  Thanks,
>> same competition after we add new_id to vfio_pci, right ?
> new_id is already superseded by driver_override to avoid the ambiguity,
> but to which driver does a userspace tool like libvirt define as the
> ultimate target driver for a device and how?

it will have a lookup table as mentioned above.


>  =20
>> A pointer to needed additions to libvirt will be awsome (or any other hi=
nt).
>>
>> I'll send the V2 soon and then move to libvirt.
> The libvirt driver for a device likely needs to accept vfio variants
> and allow users to specify a variant, but the real question is how
> libvirt makes an educated guess which variant to use initially, which I
> don't really have any good ideas to resolve.  Thanks,
>
> Alex
>
