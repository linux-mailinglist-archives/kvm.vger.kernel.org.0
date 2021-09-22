Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1AA414AF1
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhIVNoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234405AbhIVNob (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 09:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632318181;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+JWo7IWTXSlpZNK2XfHGpxPNo71k2+QBHUACSQR7vWo=;
        b=GHFJwUI086HVY05vs8d1cqZhdlwS/KTz1bWGtM6DD6Dn6wGR0//T+nGXZwJGO7cA2Ca4UD
        QscSiI+PN4VQWnvlAOFSYHAoahOZkGuuaJg8Al3+z975KoDz2gXZBeA3lw1vsiuBYIFxMH
        zJH6qOBkHL1m+xziZ6wEsGaousMPWCw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-iLOOWf5dO-qMoBqWJ8YxTg-1; Wed, 22 Sep 2021 09:43:00 -0400
X-MC-Unique: iLOOWf5dO-qMoBqWJ8YxTg-1
Received: by mail-wr1-f71.google.com with SMTP id x2-20020a5d54c2000000b0015dfd2b4e34so2214328wrv.6
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 06:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=+JWo7IWTXSlpZNK2XfHGpxPNo71k2+QBHUACSQR7vWo=;
        b=m0qIb3xVFWCMR5pwU0QH7EMvvOGWxgs/ZVYXX+7BdEJCRwIooSKwa+0q0EtTqEHVNA
         gXAvC/UfIbXoQdXESS2qXWKeZYOfpMxgA0Bho++55uwvmkBfO7FUatqqmLtPPTESYhqa
         hX+xyz8ue01pCtUyH3145Ed3LoZplForC8K4rCgiSqmMeixa5BSeekpbunAcZYA44f64
         ZWUYDszD9qS/n2MSBAb5Z3y6tWIOgEP20TmnySJKGZMtJfmu7XrG7bRM1CNRCde1p3XI
         ltSLLZcOMI3qqA4PTdQCrMSxcl31uk7O52GZqBG7+UBEVYSFeSSr6pqhuimt8koK0R2t
         i/Rw==
X-Gm-Message-State: AOAM532NpNQEnmaaU/YUHWjg3VhMC/d+F69sKJ6ioErnbAUDkkHfdCqR
        mKC42gwdD/XKwvvo9dpkN6EmCyJbSmNUHK6quQx6ZDphpQuMGoD2KYg8H5bIsOK2OpqZYRliaV1
        N+TNY4VTK2sRh
X-Received: by 2002:a5d:526f:: with SMTP id l15mr41168338wrc.0.1632318178793;
        Wed, 22 Sep 2021 06:42:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznc1KSiF5aPkuH636x53Cc3ByiW8cBM1EzDuEwJOc+UzPa3JyVYA67rj7GZoExD7VAGn/rhA==
X-Received: by 2002:a5d:526f:: with SMTP id l15mr41168305wrc.0.1632318178583;
        Wed, 22 Sep 2021 06:42:58 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id v8sm2207321wrt.12.2021.09.22.06.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 06:42:57 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 09/20] iommu: Add page size and address width attributes
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, hch@lst.de, jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        corbet@lwn.net, ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-10-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <e158380d-cb13-c1aa-6dd6-77032fe72106@redhat.com>
Date:   Wed, 22 Sep 2021 15:42:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210919063848.1476776-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/19/21 8:38 AM, Liu Yi L wrote:
> From: Lu Baolu <baolu.lu@linux.intel.com>
>
> This exposes PAGE_SIZE and ADDR_WIDTH attributes. The iommufd could use
> them to define the IOAS.
>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 943de6897f56..86d34e4ce05e 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -153,9 +153,13 @@ enum iommu_dev_features {
>  /**
>   * enum iommu_devattr - Per device IOMMU attributes
>   * @IOMMU_DEV_INFO_FORCE_SNOOP [bool]: IOMMU can force DMA to be snooped.
> + * @IOMMU_DEV_INFO_PAGE_SIZE [u64]: Page sizes that iommu supports.
> + * @IOMMU_DEV_INFO_ADDR_WIDTH [u32]: Address width supported.
I think this deserves additional info. What address width do we talk
about, input, output, what stage if the IOMMU does support multiple stages

Thanks

Eric
>   */
>  enum iommu_devattr {
>  	IOMMU_DEV_INFO_FORCE_SNOOP,
> +	IOMMU_DEV_INFO_PAGE_SIZE,
> +	IOMMU_DEV_INFO_ADDR_WIDTH,
>  };
>  
>  #define IOMMU_PASID_INVALID	(-1U)

