Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC77562B80
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 08:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiGAGYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 02:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiGAGYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 02:24:44 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFBD44A29
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 23:24:43 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a11-20020a17090acb8b00b001eca0041455so4451525pju.1
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 23:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OX5Xg3nmvuN3ZdgvoyCzaDoFDJ+1KDxFWAEkKaBYDxA=;
        b=kwTAIBLfu5raJ2HbD/ZxE2raE9aoUqz4c+H0tSDw7q549JL1Y9wrPrS6IUVoysBAFb
         5BqtFQOTPInNj9M/sAcwbzzRXOuH/kap72enUcF99tXSFuIoZagmb8uk192yXfT+4PuI
         JsoIYKQm6sbtamcyExbGcOBvnlzZe4vPVtAXpro/jhOYzKnSxc/htmXip+DY4XEBCoZr
         LoP04yz/kkQB/bSOwX5jO6EQGvO89UrP8bHYZGktQx1+uK6WNnMqpBk+Cgr+y+hHVMlC
         wkxDBUk4mcMNK72a+Q1rBTAfug0ZaNEKL1qzfnWIsdDE4x7daRrljx4clOanu3N9E+QS
         N+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OX5Xg3nmvuN3ZdgvoyCzaDoFDJ+1KDxFWAEkKaBYDxA=;
        b=TngRs0VM7w2HbCyKFBpkqNiTy3uA0nlYUyN9R1KoYOT5qAqX+YEv7mdOpQRlL9mHJj
         BGlCQIpaK8CIJcnalnb9TuXvPk2m54wpqBndB2J0FEXh3H1pBLETV+I9g0eP6zDc7sZ7
         ZF3oFHwoNguyBWAgtpNrfTO2fNayfO0S8c0NgCIJRWYHVq3YOCODH9SPr4f5ecF/qUPr
         Pd7LA/4BZvhb92HEiFy3IA7884klH/61sTVL3E9nWvT6e3hLG8YayNM60Wa/Qbt3yoNb
         9DZVxp8VHoGMzxaj4lynEZzUdWCBZiDyp6PXdQXB3C4OKtSpQwhHL/3mqjkhfz7TOTMk
         8G+g==
X-Gm-Message-State: AJIora8F4HFZQ5cZ6Tf3OcKkMcgxSlEzRSNfxdXf6frKq6qn4jmHHHsc
        ERKVG0CIm9qDWVHupx2lJMG6Rg==
X-Google-Smtp-Source: AGRyM1vRd0ySk+kAbx1QptbeAO9Bkw32uc/JUMymtxGRnvcUoujckfrV9HqzCtVKRNewU+f39JWr/g==
X-Received: by 2002:a17:90b:4c92:b0:1ec:ea7c:89af with SMTP id my18-20020a17090b4c9200b001ecea7c89afmr16712408pjb.195.1656656682607;
        Thu, 30 Jun 2022 23:24:42 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id y3-20020a170902ed4300b0016a1c216b73sm14685102plb.9.2022.06.30.23.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 23:24:41 -0700 (PDT)
Message-ID: <28ccf234-926a-2338-6d97-68225f6e3559@ozlabs.ru>
Date:   Fri, 1 Jul 2022 16:24:35 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH v2 4/4] vfio: Require that devices support DMA cache
 coherence
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>
References: <4-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <b39e78e4-05d3-8e83-cf40-be6de3a41909@ozlabs.ru>
 <BN9PR11MB5276EBBA17A869C7489B41C98CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <BN9PR11MB5276EBBA17A869C7489B41C98CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/1/22 16:07, Tian, Kevin wrote:
>> From: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Sent: Friday, July 1, 2022 12:58 PM
>>
>> On 4/8/22 01:23, Jason Gunthorpe via iommu wrote:
>>> IOMMU_CACHE means that normal DMAs do not require any additional
>> coherency
>>> mechanism and is the basic uAPI that VFIO exposes to userspace. For
>>> instance VFIO applications like DPDK will not work if additional coherency
>>> operations are required.
>>>
>>> Therefore check IOMMU_CAP_CACHE_COHERENCY like vdpa & usnic do
>> before
>>> allowing an IOMMU backed VFIO device to be created.
>>
>>
>> This just broke VFIO on POWER which does not use iommu_ops.
> 
> In this case below check is more reasonable to be put in type1
> attach_group(). Do a iommu_group_for_each_dev() to verify
> CACHE_COHERENCY similar to what Robin did for INTR_REMAP.


ah makes sense. I've posted an RFC with another problem - "[RFC PATCH 
kernel] vfio: Skip checking for IOMMU_CAP_CACHE_COHERENCY on POWER and 
more", would be great if both addressed, or I try moving those next week 
:) Thanks,


> 
> (sorry no access to my build machine now but I suppose Jason
> can soon work out a fix once he sees this. 😊)
> 
>>
>>
>>>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> ---
>>>    drivers/vfio/vfio.c | 7 +++++++
>>>    1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>> index a4555014bd1e72..9edad767cfdad3 100644
>>> --- a/drivers/vfio/vfio.c
>>> +++ b/drivers/vfio/vfio.c
>>> @@ -815,6 +815,13 @@ static int __vfio_register_dev(struct vfio_device
>> *device,
>>>
>>>    int vfio_register_group_dev(struct vfio_device *device)
>>>    {
>>> +	/*
>>> +	 * VFIO always sets IOMMU_CACHE because we offer no way for
>> userspace to
>>> +	 * restore cache coherency.
>>> +	 */
>>> +	if (!iommu_capable(device->dev->bus,
>> IOMMU_CAP_CACHE_COHERENCY))
>>> +		return -EINVAL;
>>> +
>>>    	return __vfio_register_dev(device,
>>>    		vfio_group_find_or_alloc(device->dev));
>>>    }
>>
>> --
>> Alexey

-- 
Alexey
