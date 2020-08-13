Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457892433C1
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 08:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHMGCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 02:02:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36233 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726253AbgHMGCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 02:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597298555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vY8vnehO56XjlQrEEeygaT/MkeY3wULexFdzVU37Xfc=;
        b=S2Ds+7rty5t9Ma3eeyVgzvoNyhyvvRuqiFWSYHUSIO72nMnAp2RyXO2SiGEbaK+VqcaJLW
        upoZPnnbbvDxYcEdRMW+Min2bWFkv/aR9vO2EDU4Yj9k9Aq8yla/PACFVBHwExSXOomdJv
        J1rYti89Z0BTkrVNhPsPBwXUV1khKQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-iMb9FvaNOg2PnYpJQ4BiPA-1; Thu, 13 Aug 2020 02:02:31 -0400
X-MC-Unique: iMb9FvaNOg2PnYpJQ4BiPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3A591005504;
        Thu, 13 Aug 2020 06:02:27 +0000 (UTC)
Received: from [10.72.13.44] (ovpn-13-44.pek2.redhat.com [10.72.13.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A26415D9E8;
        Thu, 13 Aug 2020 06:02:00 +0000 (UTC)
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <b59ce5b0-5530-1f30-9852-409f7c9f630a@redhat.com>
 <MWHPR11MB1645DDC2C87D533B2A09A2D58C420@MWHPR11MB1645.namprd11.prod.outlook.com>
 <ecc76dfb-7047-c1ab-e244-d73f05688f20@redhat.com>
 <MWHPR11MB1645F911EFB993C9067B58DD8C430@MWHPR11MB1645.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e3f45862-c3a5-8bac-e04d-7be0e76908a9@redhat.com>
Date:   Thu, 13 Aug 2020 14:01:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB1645F911EFB993C9067B58DD8C430@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/13 下午1:26, Tian, Kevin wrote:
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Thursday, August 13, 2020 12:34 PM
>>
>>
>> On 2020/8/12 下午12:05, Tian, Kevin wrote:
>>>> The problem is that if we tie all controls via VFIO uAPI, the other
>>>> subsystem like vDPA is likely to duplicate them. I wonder if there is a
>>>> way to decouple the vSVA out of VFIO uAPI?
>>> vSVA is a per-device (either pdev or mdev) feature thus naturally should
>>> be managed by its device driver (VFIO or vDPA). From this angle some
>>> duplication is inevitable given VFIO and vDPA are orthogonal passthrough
>>> frameworks. Within the kernel the majority of vSVA handling is done by
>>> IOMMU and IOASID modules thus most logic are shared.
>>
>> So why not introduce vSVA uAPI at IOMMU or IOASID layer?
> One may ask a similar question why IOMMU doesn't expose map/unmap
> as uAPI...


I think this is probably a good idea as well. If there's anything missed 
in the infrastructure, we can invent. Besides vhost-vDPA, there are 
other subsystems that relaying their uAPI to IOMMU API. Duplicating 
uAPIs is usually a hint of the codes duplication. Simple map/unmap could 
be easy but vSVA uAPI is much more complicated.


>
>>
>>>>>     If an userspace DMA interface can be easily
>>>>> adapted to be a passthrough one, it might be the choice.
>>>> It's not that easy even for VFIO which requires a lot of new uAPIs and
>>>> infrastructures(e.g mdev) to be invented.
>>>>
>>>>
>>>>> But for idxd,
>>>>> we see mdev a much better fit here, given the big difference between
>>>>> what userspace DMA requires and what guest driver requires in this hw.
>>>> A weak point for mdev is that it can't serve kernel subsystem other than
>>>> VFIO. In this case, you need some other infrastructures (like [1]) to do
>>>> this.
>>> mdev is not exclusive from kernel usages. It's perfectly fine for a driver
>>> to reserve some work queues for host usages, while wrapping others
>>> into mdevs.
>>
>> I meant you may want slices to be an independent device from the kernel
>> point of view:
>>
>> E.g for ethernet devices, you may want 10K mdevs to be passed to guest.
>>
>> Similarly, you may want 10K net devices which is connected to the kernel
>> networking subsystems.
>>
>> In this case it's not simply reserving queues but you need some other
>> type of device abstraction. There could be some kind of duplication
>> between this and mdev.
>>
> yes, some abstraction required but isn't it what the driver should
> care about instead of mdev framework itself?


With mdev you present a "PCI" device, but what's kind of device it tries 
to present to kernel? If it's still PCI, there's duplication with mdev, 
if it's something new, maybe we can switch to that API.


> If the driver reports
> the same set of resource to both mdev and networking, it needs to
> make sure when the resource is claimed in one interface then it
> should be marked in-use in another. e.g. each mdev includes a
> available_intances attribute. the driver could report 10k available
> instances initially and then update it to 5K when another 5K is used
> for net devices later.


Right but this probably means you need another management layer under mdev.


>
> Mdev definitely has its usage limitations. Some may be improved
> in the future, some may not. But those are distracting from the
> original purpose of this thread (mdev vs. userspace DMA) and better
> be discussed in other places e.g. LPC...


Ok.

Thanks


>
> Thanks
> Kevin

