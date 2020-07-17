Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116B6223941
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 12:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgGQK3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 06:29:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgGQK3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 06:29:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594981741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hsLQzqU/DSHbl54CuoL1GP4Qg8GB7o5Im2iyC5P3/Y0=;
        b=Hhd7h+jV83h+ZEx3IBGjEWHXjUos0xgV0DPXGAN4qzf5CG/IITxXW8ruDnqM7kk1GpeW5P
        BsgVR79kxEQa7Ucp0vywtuEenY2+mOFvmPpt68v4415Rc3EEqplr2ZgkJ7a1/u4EUJixju
        0pXBahaHvONHGHolognpGPyaq3Sx9Gk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-8xMqunhAM1yEke4WMmg9cA-1; Fri, 17 Jul 2020 06:28:57 -0400
X-MC-Unique: 8xMqunhAM1yEke4WMmg9cA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D02B380BCAD;
        Fri, 17 Jul 2020 10:28:54 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 851855C1BB;
        Fri, 17 Jul 2020 10:28:44 +0000 (UTC)
Subject: Re: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>, Will Deacon <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
 <20200713131454.GA2739@willie-the-truck>
 <CY4PR11MB1432226D0A52D099249E95A0C3610@CY4PR11MB1432.namprd11.prod.outlook.com>
 <20200716153959.GA447208@myrica>
 <f3779a69-0295-d668-5f2f-746b6ff2bdce@redhat.com>
 <20200717090900.GC4850@myrica>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <74ea9416-6bcf-1e71-33f9-b61d7d853be1@redhat.com>
Date:   Fri, 17 Jul 2020 12:28:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200717090900.GC4850@myrica>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On 7/17/20 11:09 AM, Jean-Philippe Brucker wrote:
> On Thu, Jul 16, 2020 at 10:38:17PM +0200, Auger Eric wrote:
>> Hi Jean,
>>
>> On 7/16/20 5:39 PM, Jean-Philippe Brucker wrote:
>>> On Tue, Jul 14, 2020 at 10:12:49AM +0000, Liu, Yi L wrote:
>>>>> Have you verified that this doesn't break the existing usage of
>>>>> DOMAIN_ATTR_NESTING in drivers/vfio/vfio_iommu_type1.c?
>>>>
>>>> I didn't have ARM machine on my hand. But I contacted with Jean
>>>> Philippe, he confirmed no compiling issue. I didn't see any code
>>>> getting DOMAIN_ATTR_NESTING attr in current drivers/vfio/vfio_iommu_type1.c.
>>>> What I'm adding is to call iommu_domai_get_attr(, DOMAIN_ATTR_NESTIN)
>>>> and won't fail if the iommu_domai_get_attr() returns 0. This patch
>>>> returns an empty nesting info for DOMAIN_ATTR_NESTIN and return
>>>> value is 0 if no error. So I guess it won't fail nesting for ARM.
>>>
>>> I confirm that this series doesn't break the current support for
>>> VFIO_IOMMU_TYPE1_NESTING with an SMMUv3. That said...
>>>
>>> If the SMMU does not support stage-2 then there is a change in behavior
>>> (untested): after the domain is silently switched to stage-1 by the SMMU
>>> driver, VFIO will now query nesting info and obtain -ENODEV. Instead of
>>> succeding as before, the VFIO ioctl will now fail. I believe that's a fix
>>> rather than a regression, it should have been like this since the
>>> beginning. No known userspace has been using VFIO_IOMMU_TYPE1_NESTING so
>>> far, so I don't think it should be a concern.
>> But as Yi mentioned ealier, in the current vfio code there is no
>> DOMAIN_ATTR_NESTING query yet.
> 
> That's why something that would have succeeded before will now fail:
> Before this series, if user asked for a VFIO_IOMMU_TYPE1_NESTING, it would
> have succeeded even if the SMMU didn't support stage-2, as the driver
> would have silently fallen back on stage-1 mappings (which work exactly
> the same as stage-2-only since there was no nesting supported). After the
> series, we do check for DOMAIN_ATTR_NESTING so if user asks for
> VFIO_IOMMU_TYPE1_NESTING and the SMMU doesn't support stage-2, the ioctl
> fails.
OK I now understand what you meant. Yes this actual change is brought by
the next patch, ie.
[PATCH v5 04/15] vfio/type1: Report iommu nesting info to userspace

Thanks

Eric
> 
> I believe it's a good fix and completely harmless, but wanted to make sure
> no one objects because it's an ABI change.
> 
> Thanks,
> Jean
> 
>> In my SMMUV3 nested stage series, I added
>> such a query in vfio-pci.c to detect if I need to expose a fault region
>> but I already test both the returned value and the output arg. So to me
>> there is no issue with that change.
>>>
>>> And if userspace queries the nesting properties using the new ABI
>>> introduced in this patchset, it will obtain an empty struct. I think
>>> that's acceptable, but it may be better to avoid adding the nesting cap if
>>> @format is 0?
>> agreed
>>
>> Thanks
>>
>> Eric
>>>
>>> Thanks,
>>> Jean
>>>
>>>>
>>>> @Eric, how about your opinion? your dual-stage vSMMU support may
>>>> also share the vfio_iommu_type1.c code.
>>>>
>>>> Regards,
>>>> Yi Liu
>>>>
>>>>> Will
>>>
>>
> 

