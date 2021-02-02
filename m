Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669FF30C830
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbhBBRog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:44:36 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18566 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237751AbhBBRmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 12:42:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60198ec50000>; Tue, 02 Feb 2021 09:41:25 -0800
Received: from [172.27.0.48] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 17:41:19 +0000
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <yishaih@nvidia.com>, <aik@ozlabs.ru>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
Date:   Tue, 2 Feb 2021 19:41:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202170659.1c62a9e8.cohuck@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612287685; bh=T9u2m8ib6L6wjnHIIPMQb8zM6/4WXaLdn05UdqoTT0c=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=N7eZ8ReEx0/Bqg8xyxrqzQMO8fa7xE7tK+5n1zO5nKxn2aYadp7UDLxOdfBN4PSSe
         jaiYRM/E0kIc4jRblHs/SaiNHjJ1jxm+uqMe8sH0sKUkui7HPuNc4b/T3WygdpT0Fs
         bVxhgrB9M3V1aKw6FkHNIUq6bEnRf38pCsmYhM6J1CqsSu+IOT5Ki9g0aSjidqqIF1
         t62ePGc3K4aYGh/H69wI4+ypPBwQZkih1aNx4aqUOc8u6J9hHW9WPxw4Wt23P3FVzQ
         6VXZAy3ZTiVS85rAJgkB/woIpeIX+MwVm+d8aTCVdkEjAodn6ogQZ1h2oeXsrTkRff
         xfJCT2DFJ5I+g==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/2/2021 6:06 PM, Cornelia Huck wrote:
> On Mon, 1 Feb 2021 11:42:30 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
>
>> On Mon, 1 Feb 2021 12:49:12 -0500
>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>
>>> On 2/1/21 12:14 PM, Cornelia Huck wrote:
>>>> On Mon, 1 Feb 2021 16:28:27 +0000
>>>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>>>>      
>>>>> This patch doesn't change any logic but only align to the concept of
>>>>> vfio_pci_core extensions. Extensions that are related to a platform
>>>>> and not to a specific vendor of PCI devices should be part of the core
>>>>> driver. Extensions that are specific for PCI device vendor should go
>>>>> to a dedicated vendor vfio-pci driver.
>>>> My understanding is that igd means support for Intel graphics, i.e. a
>>>> strict subset of x86. If there are other future extensions that e.g.
>>>> only make sense for some devices found only on AMD systems, I don't
>>>> think they should all be included under the same x86 umbrella.
>>>>
>>>> Similar reasoning for nvlink, that only seems to cover support for some
>>>> GPUs under Power, and is not a general platform-specific extension IIUC.
>>>>
>>>> We can arguably do the zdev -> s390 rename (as zpci appears only on
>>>> s390, and all PCI devices will be zpci on that platform), although I'm
>>>> not sure about the benefit.
>>> As far as I can tell, there isn't any benefit for s390 it's just
>>> "re-branding" to match the platform name rather than the zdev moniker,
>>> which admittedly perhaps makes it more clear to someone outside of s390
>>> that any PCI device on s390 is a zdev/zpci type, and thus will use this
>>> extension to vfio_pci(_core).  This would still be true even if we added
>>> something later that builds atop it (e.g. a platform-specific device
>>> like ism-vfio-pci).  Or for that matter, mlx5 via vfio-pci on s390x uses
>>> these zdev extensions today and would need to continue using them in a
>>> world where mlx5-vfio-pci.ko exists.
>>>
>>> I guess all that to say: if such a rename matches the 'grand scheme' of
>>> this design where we treat arch-level extensions to vfio_pci(_core) as
>>> "vfio_pci_(arch)" then I'm not particularly opposed to the rename.  But
>>> by itself it's not very exciting :)
>> This all seems like the wrong direction to me.  The goal here is to
>> modularize vfio-pci into a core library and derived vendor modules that
>> make use of that core library.  If existing device specific extensions
>> within vfio-pci cannot be turned into vendor modules through this
>> support and are instead redefined as platform specific features of the
>> new core library, that feels like we're already admitting failure of
>> this core library to support known devices, let alone future devices.
>>
>> IGD is a specific set of devices.  They happen to rely on some platform
>> specific support, whose availability should be determined via the
>> vendor module probe callback.  Packing that support into an "x86"
>> component as part of the core feels not only short sighted, but also
>> avoids addressing the issues around how userspace determines an optimal
>> module to use for a device.
> Hm, it seems that not all current extensions to the vfio-pci code are
> created equal.
>
> IIUC, we have igd and nvlink, which are sets of devices that only show
> up on x86 or ppc, respectively, and may rely on some special features
> of those architectures/platforms. The important point is that you have
> a device identifier that you can match a driver against.

maybe you can supply the ids ?

Alexey K, I saw you've been working on the NVLINK2 for P9. can you 
supply the exact ids for that should be bounded to this driver ?

I'll add it to V3.

>
> On the other side, we have the zdev support, which both requires s390
> and applies to any pci device on s390. If we added special handling for
> ISM on s390, ISM would be in a category similar to igd/nvlink.
>
> Now, if somebody plugs a mlx5 device into an s390, we would want both
> the zdev support and the specialized mlx5 driver. Maybe zdev should be
> some kind of library that can be linked into normal vfio-pci, into
> vfio-pci-mlx5, and a hypothetical vfio-pci-ism? You always want zdev on
> s390 (if configured into the kernel).
>
