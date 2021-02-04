Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E9530EF6D
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 10:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhBDJOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 04:14:33 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2486 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbhBDJNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 04:13:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601bba9b0000>; Thu, 04 Feb 2021 01:12:59 -0800
Received: from [172.27.14.32] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 4 Feb
 2021 09:12:52 +0000
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <yishaih@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <806c138e-685c-0955-7c15-93cb1d4fe0d9@ozlabs.ru>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <6c96f41a-0daa-12d4-528e-6db44df1a5a6@nvidia.com>
Date:   Thu, 4 Feb 2021 11:12:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <806c138e-685c-0955-7c15-93cb1d4fe0d9@ozlabs.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612429979; bh=Im6b2xJcAnUmmkLeZvyMpIlZqw5KvTd23d+h59l+1NE=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=kGDo9/y7WGxnkF02zkOPydUY4e5OY4qaCHEVq3sGjqtekjkRk4mE9+4NoO8tRWOFD
         F7Tbi3oqTQ52Nv3Ye2iQqhmURx6kwcRF9IF+qo4W6tiqiUZNDA28TaeicYTdC6Z2Qn
         X7ln8QEzwlPVH1ZQZytCWw+6H75nweOQp/qbiXETARQMyIKSuqjdTW73s6NF21528Q
         p2XOit/IHi0/mIQaMzCqA0qkqnTnlOug3BTKe0RkwlKIKsRg/5p3xhDzhhrrRYK7Je
         /Dk5DCsKbyB+Ok6ic/Pnq9ARUR6zWRmeTov7vdinUwW59kpAG6Sxzsf1PnAoWopk8d
         YWg56psZFFTeg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/3/2021 5:24 AM, Alexey Kardashevskiy wrote:
>
>
> On 03/02/2021 04:41, Max Gurtovoy wrote:
>>
>> On 2/2/2021 6:06 PM, Cornelia Huck wrote:
>>> On Mon, 1 Feb 2021 11:42:30 -0700
>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>
>>>> On Mon, 1 Feb 2021 12:49:12 -0500
>>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>>
>>>>> On 2/1/21 12:14 PM, Cornelia Huck wrote:
>>>>>> On Mon, 1 Feb 2021 16:28:27 +0000
>>>>>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>>>>>>> This patch doesn't change any logic but only align to the=20
>>>>>>> concept of
>>>>>>> vfio_pci_core extensions. Extensions that are related to a platform
>>>>>>> and not to a specific vendor of PCI devices should be part of=20
>>>>>>> the core
>>>>>>> driver. Extensions that are specific for PCI device vendor=20
>>>>>>> should go
>>>>>>> to a dedicated vendor vfio-pci driver.
>>>>>> My understanding is that igd means support for Intel graphics,=20
>>>>>> i.e. a
>>>>>> strict subset of x86. If there are other future extensions that e.g.
>>>>>> only make sense for some devices found only on AMD systems, I don't
>>>>>> think they should all be included under the same x86 umbrella.
>>>>>>
>>>>>> Similar reasoning for nvlink, that only seems to cover support=20
>>>>>> for some
>>>>>> GPUs under Power, and is not a general platform-specific=20
>>>>>> extension IIUC.
>>>>>>
>>>>>> We can arguably do the zdev -> s390 rename (as zpci appears only on
>>>>>> s390, and all PCI devices will be zpci on that platform),=20
>>>>>> although I'm
>>>>>> not sure about the benefit.
>>>>> As far as I can tell, there isn't any benefit for s390 it's just
>>>>> "re-branding" to match the platform name rather than the zdev=20
>>>>> moniker,
>>>>> which admittedly perhaps makes it more clear to someone outside of=20
>>>>> s390
>>>>> that any PCI device on s390 is a zdev/zpci type, and thus will use=20
>>>>> this
>>>>> extension to vfio_pci(_core).=C2=A0 This would still be true even if =
we=20
>>>>> added
>>>>> something later that builds atop it (e.g. a platform-specific device
>>>>> like ism-vfio-pci).=C2=A0 Or for that matter, mlx5 via vfio-pci on=20
>>>>> s390x uses
>>>>> these zdev extensions today and would need to continue using them=20
>>>>> in a
>>>>> world where mlx5-vfio-pci.ko exists.
>>>>>
>>>>> I guess all that to say: if such a rename matches the 'grand=20
>>>>> scheme' of
>>>>> this design where we treat arch-level extensions to=20
>>>>> vfio_pci(_core) as
>>>>> "vfio_pci_(arch)" then I'm not particularly opposed to the=20
>>>>> rename.=C2=A0 But
>>>>> by itself it's not very exciting :)
>>>> This all seems like the wrong direction to me.=C2=A0 The goal here is =
to
>>>> modularize vfio-pci into a core library and derived vendor modules=20
>>>> that
>>>> make use of that core library.=C2=A0 If existing device specific exten=
sions
>>>> within vfio-pci cannot be turned into vendor modules through this
>>>> support and are instead redefined as platform specific features of the
>>>> new core library, that feels like we're already admitting failure of
>>>> this core library to support known devices, let alone future devices.
>>>>
>>>> IGD is a specific set of devices.=C2=A0 They happen to rely on some=20
>>>> platform
>>>> specific support, whose availability should be determined via the
>>>> vendor module probe callback.=C2=A0 Packing that support into an "x86"
>>>> component as part of the core feels not only short sighted, but also
>>>> avoids addressing the issues around how userspace determines an=20
>>>> optimal
>>>> module to use for a device.
>>> Hm, it seems that not all current extensions to the vfio-pci code are
>>> created equal.
>>>
>>> IIUC, we have igd and nvlink, which are sets of devices that only show
>>> up on x86 or ppc, respectively, and may rely on some special features
>>> of those architectures/platforms. The important point is that you have
>>> a device identifier that you can match a driver against.
>>
>> maybe you can supply the ids ?
>>
>> Alexey K, I saw you've been working on the NVLINK2 for P9. can you=20
>> supply the exact ids for that should be bounded to this driver ?
>>
>> I'll add it to V3.
>
> Sorry no, I never really had the exact ids, they keep popping up after=20
> years.
>
> The nvlink2 support can only work if the platform supports it as there=20
> is nothing to do to the GPUs themselves, it is about setting up those=20
> nvlink2 links. If the platform advertises certain features in the=20
> device tree - then any GPU in the SXM2 form factor (not sure about the=20
> exact abbrev, not an usual PCIe device) should just work.
>
> If the nvlink2 "subdriver" fails to find nvlinks (the platform does=20
> not advertise them or some parameters are new to this subdriver, such=20
> as link-speed), we still fall back to generic vfio-pci and try passing=20
> through this GPU as a plain PCI device with no extra links.=20
> Semi-optimal but if the user is mining cryptocoins, then highspeed=20
> links are not really that important :) And the nvidia driver is=20
> capable of running such GPUs without nvlinks. Thanks,
>
I see.

But the PCI function (the bounded BDF) is GPU function or NVLINK function ?

If it's NVLINK function then we should fail probing in the host vfio-pci=20
driver.

if its a GPU function so it shouldn't been called nvlink2 vfio-pci=20
driver. Its just an extension in the GPU vfio-pci driver.

>
>>
>>>
>>> On the other side, we have the zdev support, which both requires s390
>>> and applies to any pci device on s390. If we added special handling for
>>> ISM on s390, ISM would be in a category similar to igd/nvlink.
>>>
>>> Now, if somebody plugs a mlx5 device into an s390, we would want both
>>> the zdev support and the specialized mlx5 driver. Maybe zdev should be
>>> some kind of library that can be linked into normal vfio-pci, into
>>> vfio-pci-mlx5, and a hypothetical vfio-pci-ism? You always want zdev on
>>> s390 (if configured into the kernel).
>>>
>
