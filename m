Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABD3245E31
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 09:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgHQHlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 03:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgHQHlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 03:41:03 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E25C061388;
        Mon, 17 Aug 2020 00:41:02 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z18so13899652wrm.12;
        Mon, 17 Aug 2020 00:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rHQ4xMykMaYzmKYcciJ0rrSU9YLiVKU1u6aMO/QeTf0=;
        b=PS1luolkWZY5Oh7auOQXOzCmGCVxSgnSBuYpEfGYfc/ekRTAdeYT+gbHPh0WBHHHFa
         LLD97UZg2YImVHN4zGiBX6HYTiHU5iDcOic3rY7gfgGuPbJeIAD4GQwsm49eN8n4mDls
         4jePHz7xOSWuCCm8XOvFoLD1ngAH1UnPJWdcs+9Q4nrpZWqPM803E2zp/v34JFhQCM74
         aRBtRSjsnAx0YA7ybXrubnOgtCOH+e4y2b7BIeIugM0LxxZofa0CvpU9Dy7knZc8LKG2
         vwhDYBbPSIf/Zh7JD2FnbhTnKlPi4lNz6FpFJqc6uE97Cqxk0kZBTW0g0sMyY90Ekzk5
         P5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rHQ4xMykMaYzmKYcciJ0rrSU9YLiVKU1u6aMO/QeTf0=;
        b=G5wMx2tEzffUJREdKCRniFRqjufptrxzhoZsGrgpEAPMKlv/F1NTnKblPxj8bcnsdA
         pQ4OxuES0Xk95glIBAdSByfJyaeQDXqvHWHM4ke/SsvCOcT613Rs9vDqkD9ZFWvfY4t9
         qmt6zjxhFrliNxnsLRlHOLm6Rsm3Wv1FZMRtfN6P0LdiS/olbtEsBEGAGgX6xfW8Zx9N
         6SYM9C4CsV2pL9J49fUPe/mU+buXCnsbYGC4GNlRCcoYRk2SGVonBq6CPJJ8+COZB5Ad
         QVYHSnpdjcn8H3onyvcDRavo6RH0hnpt5N6Lf1ak3YsxsyjITi6Hs85ds89rNuW2fgOn
         ftRA==
X-Gm-Message-State: AOAM531LdQpdkwP9OSN3/cJQ/yhgBzH+HNVVx3CWy7tiEDZbXV+lDsZq
        u8d+WBtpp98TqGWJ/bkq8cDDNwgZj7g=
X-Google-Smtp-Source: ABdhPJxD/SpWdp8O4H7ZsEqCH+NXbt9XIUSFps04TRqRz2irwylI4CUzkbGS1jK6P61XNnNkddSfJQ==
X-Received: by 2002:adf:97dd:: with SMTP id t29mr13235478wrb.97.1597650061210;
        Mon, 17 Aug 2020 00:41:01 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g16sm26910678wrs.88.2020.08.17.00.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 00:41:00 -0700 (PDT)
Subject: Re: [PATCH v6 14/15] vfio: Document dual stage control
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-15-git-send-email-yi.l.liu@intel.com>
 <aa1297cb-2bde-0cea-70a4-fc8f56d745e6@redhat.com>
 <DM5PR11MB143519ABA63F46D7864E9EA2C35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger.pro@gmail.com>
Message-ID: <77c8b564-d8b8-4169-3556-5e0d91d3ea9b@gmail.com>
Date:   Mon, 17 Aug 2020 09:40:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB143519ABA63F46D7864E9EA2C35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 8/17/20 9:00 AM, Liu, Yi L wrote:
> Hi Eric,
> 
>> From: Auger Eric <eric.auger@redhat.com>
>> Sent: Sunday, August 16, 2020 7:52 PM
>>
>> Hi Yi,
>>
>> On 7/28/20 8:27 AM, Liu Yi L wrote:
>>> From: Eric Auger <eric.auger@redhat.com>
>>>
>>> The VFIO API was enhanced to support nested stage control: a bunch of> new
>> ioctls and usage guideline.
>>>
>>> Let's document the process to follow to set up nested mode.
>>>
>>> Cc: Kevin Tian <kevin.tian@intel.com>
>>> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>> Cc: Alex Williamson <alex.williamson@redhat.com>
>>> Cc: Eric Auger <eric.auger@redhat.com>
>>> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>> Cc: Joerg Roedel <joro@8bytes.org>
>>> Cc: Lu Baolu <baolu.lu@linux.intel.com>
>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>>> ---
>>> v5 -> v6:
>>> *) tweak per Eric's comments.
>>>
>>> v3 -> v4:
>>> *) add review-by from Stefan Hajnoczi
>>>
>>> v2 -> v3:
>>> *) address comments from Stefan Hajnoczi
>>>
>>> v1 -> v2:
>>> *) new in v2, compared with Eric's original version, pasid table bind
>>>    and fault reporting is removed as this series doesn't cover them.
>>>    Original version from Eric.
>>>    https://lkml.org/lkml/2020/3/20/700
>>> ---
>>>  Documentation/driver-api/vfio.rst | 75
>> +++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 75 insertions(+)
>>>
>>> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
>>> index f1a4d3c..c0d43f0 100644
>>> --- a/Documentation/driver-api/vfio.rst
>>> +++ b/Documentation/driver-api/vfio.rst
>>> @@ -239,6 +239,81 @@ group and can access them as follows::
>>>  	/* Gratuitous device reset and go... */
>>>  	ioctl(device, VFIO_DEVICE_RESET);
>>>
>>> +IOMMU Dual Stage Control
>>> +------------------------
>>> +
>>> +Some IOMMUs support 2 stages/levels of translation. Stage corresponds
>>> +to the ARM terminology while level corresponds to Intel's terminology.
>>> +In the following text we use either without distinction.
>>> +
>>> +This is useful when the guest is exposed with a virtual IOMMU and some
>>> +devices are assigned to the guest through VFIO. Then the guest OS can
>>> +use stage-1 (GIOVA -> GPA or GVA->GPA), while the hypervisor uses stage
>>> +2 for VM isolation (GPA -> HPA).
>>> +
>>> +Under dual stage translation, the guest gets ownership of the stage-1 page
>>> +tables and also owns stage-1 configuration structures. The hypervisor owns
>>> +the root configuration structure (for security reason), including stage-2
>>> +configuration.
>> This is only true for vtd. On ARM the stage2 cfg is the Context
>> Descriptor table (aka PASID table). root cfg only store the GPA of the
>> CD table.
> 
> I've a check with you on the meaning of "configuration structures".
> For Vt-d, does it mean the root table/context table/pasid table? if
> I'm correct, then how about below description?
Yes I agree
> 
> "Under dual stage translation, the guest gets ownership of the stage-1
> configuration structures or page tables.
Actually on ARM the guest both owns the S1 configuration (CD table) and
S1 page tables ;-)

on Intel I understand the guest only owns the S1 page tables.

If confirmed, you may use such kind of explicit statement.

Thanks

Eric

 This depends on vendor. The
> hypervisor owns the root configuration structure (for security reason),
> including stage-2 configuration."
> 
>>  This works as long as configuration structures and page table
>>> +formats are compatible between the virtual IOMMU and the physical IOMMU.
>>> +
>>> +Assuming the HW supports it, this nested mode is selected by choosing the
>>> +VFIO_TYPE1_NESTING_IOMMU type through:
>>> +
>>> +    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
>>> +
>>> +This forces the hypervisor to use the stage-2, leaving stage-1 available
>>> +for guest usage. The stage-1 format and binding method are vendor specific
>> . There are reported in the nesting capability ...
> 
> got it.
> 
> "The stage-1 format and binding method are reported in nesting capability."
> 
>>> +and reported in nesting cap (VFIO_IOMMU_TYPE1_INFO_CAP_NESTING) through
>>> +VFIO_IOMMU_GET_INFO:
>>> +
>>> +    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
>>> +
>>> +The nesting cap info is available only after NESTING_IOMMU is selected.
>>> +If underlying IOMMU doesn't support nesting, VFIO_SET_IOMMU fails and
>> If the underlying
> 
> got it.
> 
>>> +userspace should try other IOMMU types. Details of the nesting cap info
>>> +can be found in Documentation/userspace-api/iommu.rst.
>>> +
>>> +The stage-1 page table can be bound to the IOMMU in two methods: directly>
>> +or indirectly. Direct binding requires userspace to notify VFIO of every
>> Not sure we shall use this direct/indirect terminology. I don't think
>> this is part of either ARM or Intel SPEC.
>>
>> Suggestion: On Intel, the stage1 page table info are mediated by the
>> userspace for each PASID. On ARM, the userspace directly passes the GPA
>> of the whole PASID table. Currently only Intel's binding is supported.
> 
> got it. this is what we want to say by ditect/indirect terminology.
> 
> Regards,
> Yi Liu
> 
>>> +guest stage-1 page table binding, while indirect binding allows userspace
>>> +to bind once with an intermediate structure (e.g. PASID table) which
>>> +indirectly links to guest stage-1 page tables. The actual binding method
>>> +depends on IOMMU vendor. Currently only the direct binding capability (
>>> +IOMMU_NESTING_FEAT_BIND_PGTBL) is supported:
>>> +
>>> +    nesting_op->flags = VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
>>> +    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
>>> +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
>>> +
>>> +When multiple stage-1 page tables are supported on a device, each page
>>> +table is associated with a PASID (Process Address Space ID) to differentiate
>>> +with each other. In such case, userspace should include PASID in the
>>> +bind_data when issuing direct binding request.
>>> +
>>> +PASID could be managed per-device or system-wide which, again, depends on
>>> +IOMMU vendor and is reported in nesting cap info. When system-wide policy
>>> +is reported (IOMMU_NESTING_FEAT_SYSWIDE_PASID), e.g. as by Intel platforms,
>>> +userspace *must* allocate PASID from VFIO before attempting binding of
>>> +stage-1 page table:
>>> +
>>> +    req.flags = VFIO_IOMMU_ALLOC_PASID;
>>> +    ioctl(container, VFIO_IOMMU_PASID_REQUEST, &req);
>>> +
>>> +Once the stage-1 page table is bound to the IOMMU, the guest is allowed to
>>> +fully manage its mapping at its disposal. The IOMMU walks nested stage-1
>>> +and stage-2 page tables when serving DMA requests from assigned device, and
>>> +may cache the stage-1 mapping in the IOTLB. When required (IOMMU_NESTING_
>>> +FEAT_CACHE_INVLD), userspace *must* forward guest stage-1 invalidation to
>>> +the host, so the IOTLB is invalidated:
>>> +
>>> +    nesting_op->flags = VFIO_IOMMU_NESTING_OP_CACHE_INVLD;
>>> +    memcpy(&nesting_op->data, &cache_inv_data, sizeof(cache_inv_data));
>>> +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
>>> +
>>> +Forwarded invalidations can happen at various granularity levels (page
>>> +level, context level, etc.)
>>> +
>>>  VFIO User API
>>>  -------------------------------------------------------------------------------
>>>
>>>
>> Thanks
>>
>> Eric
> 
