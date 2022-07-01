Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F960562AB2
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 06:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiGAE5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 00:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGAE5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 00:57:42 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A67677E8
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 21:57:39 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m2so1317104plx.3
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 21:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NOQXYB9rVtqMbvMp0KZP/NXMDdG6KY+bHR2qpMf2XHA=;
        b=7OyJBILUprUR9iDklBoQBQpLducUR42bx72zwhlY9m+b9yAQyxIlMFxqW/mgn++w65
         We1HnbnuNAMJq0G5M7MVZJKumIbFt5Yu6Fu7sT75nBEKm5DUjjZED+5Wm8+8MnINDzdT
         ZzpBIYqeIwIoPpRtGWI29+G1yE0bsTTJ68Dcykscu1KNi9XSar7iMDAXIjdvLULCz0Os
         oSzd0c5eJ9bwTStTU1nD6NGsF4NtYXQ8gflxDZryr223QWBfGC4ByDBWiyt8IOcVpEau
         BWNhtKTVxZsFmm7CFh4GsvGg6H9RyoyzWVKbJtufFKmnTA3ABZYTQiI5WoSc7kaSKUx1
         sAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NOQXYB9rVtqMbvMp0KZP/NXMDdG6KY+bHR2qpMf2XHA=;
        b=oTNuPYrA3N5XL1HHvesbApW0asFf4h13CIyaFLMJfGIfYKCTYy9aGBydT9FKb05CW8
         PjIOYDA4Mycs9VurdSIK8+0MduWSSdM6G435FxLSy56ynXrnTEWJoVzYKlwNE5f7HEdF
         vcXkChMc4Whb5uBSkhVAuJ0oluSEOBNpz2xGDGsjACJic7HoXTFA/plDWYuCCU/YCKL0
         jJl0vNg38wUklw0f899Nl4t4acst+5DMvYh4RGR4OcUE6GKJaQ9BsjmgSohMueuZ0xuo
         9DkIgIhhMaVYLV4ZqDHBrT9BMalZa+rVhiWYXhE377d2T8VlkLRpvmscdbGAN7lj4/g/
         i+8w==
X-Gm-Message-State: AJIora9qUqVE2YG1a2FvD4EPFecgrUJxgTX8tweXmIn6F/5eJL5kIdcz
        xiMbiMGxrCeAA9DDo6o5YKSm4w==
X-Google-Smtp-Source: AGRyM1sVGvDA3ns0++pkE+BFdtHLCQLsuxT1sVa57tgF9DUpwyoflMPLWsNwhMGEc9AtFWBtCnuoHA==
X-Received: by 2002:a17:902:b287:b0:16b:85cd:ef6b with SMTP id u7-20020a170902b28700b0016b85cdef6bmr18021195plr.8.1656651458842;
        Thu, 30 Jun 2022 21:57:38 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id b7-20020a62cf07000000b0051835ccc008sm14562343pfg.115.2022.06.30.21.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 21:57:38 -0700 (PDT)
Message-ID: <b39e78e4-05d3-8e83-cf40-be6de3a41909@ozlabs.ru>
Date:   Fri, 1 Jul 2022 14:57:32 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH v2 4/4] vfio: Require that devices support DMA cache
 coherence
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>
References: <4-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <4-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/8/22 01:23, Jason Gunthorpe via iommu wrote:
> IOMMU_CACHE means that normal DMAs do not require any additional coherency
> mechanism and is the basic uAPI that VFIO exposes to userspace. For
> instance VFIO applications like DPDK will not work if additional coherency
> operations are required.
> 
> Therefore check IOMMU_CAP_CACHE_COHERENCY like vdpa & usnic do before
> allowing an IOMMU backed VFIO device to be created.


This just broke VFIO on POWER which does not use iommu_ops.


> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index a4555014bd1e72..9edad767cfdad3 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -815,6 +815,13 @@ static int __vfio_register_dev(struct vfio_device *device,
>   
>   int vfio_register_group_dev(struct vfio_device *device)
>   {
> +	/*
> +	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> +	 * restore cache coherency.
> +	 */
> +	if (!iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
> +		return -EINVAL;
> +
>   	return __vfio_register_dev(device,
>   		vfio_group_find_or_alloc(device->dev));
>   }

-- 
Alexey
