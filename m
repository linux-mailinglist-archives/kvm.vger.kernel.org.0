Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3687A6030E5
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 18:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJRQmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 12:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJRQmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 12:42:24 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0DFE8C4B
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:42:22 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b4so24519584wrs.1
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zyuk2vqool0ZJsR32P+3e4lQalita2jOOTT18RJHHoY=;
        b=WvBgZntHJH1LRfE6NUAsZ9MWhwho5l3Cw1x0tS61S8rhXUrBGt7T+aXzwHrJHHSMqP
         z2bUAMqoWrSMCUhPOoStkE46O8N0mA81YVXgAGFmAS4+IIZQn1lSmWOSXJRs5U5vBLZL
         cRfjvB8XRf9LGME/5vIRSf4lAFwff+ojQl8WMyN4TgKOSD1eVpeoaguUY/+hqngQ1hDZ
         JXCHsLsF0P8a1eJEyGrolQaUG9QKxl6KcpcHoTwx0KftEKJxKxF2QbG7FcDV8WcuHaYU
         Rx7XL0RCDNJjt6dFEjyJTbrkUspTtG6nghQzrt3+JXMqNaVHt3RqLMhQxwMMUk5JdqvU
         qd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zyuk2vqool0ZJsR32P+3e4lQalita2jOOTT18RJHHoY=;
        b=L6q+wZMGmDNa1UR/Vg9Jijmgt5rWmT8vl3qJ6gVzTRGMiA5vrGdlV1pL1Lwr4BBmFP
         0gPt7I5GZjqQCEmnvXtPbffB84tx4YULydQFUFbIvTx6lUzknh8V3SKgiwYjCa2vlIxo
         Bs22BlDHuuVJW7+KPfp4NEZdHu86kUT5ln6A7/CdF9V9KNllxlXknha6k91xgfNnwN/M
         1Gn2pIMeXEgYuYH72H2BmSt+He4Z3qSQ3rfhVFQugGsjfidfYuLkSKn2/pZA7VFIWFww
         QHeqnOXgrtFL4LXXi/zFpNxFe7PlOPiAeDBIpaoeX9OR7kL0pAx6nlV944mODJfkrb7D
         RJ9Q==
X-Gm-Message-State: ACrzQf2EfC+ug2LQ36mLoMLe1EXu12et33TUx2mocnmkoaofabnuhP8b
        xX3XPtsDsEwil6uXAAaLtXzNRA==
X-Google-Smtp-Source: AMsMyM5912HfPWSludNbWAHArs7ZDbAyFVAHpAbhZKcK3gEZgDte7ZYWreKddEYJaTpsKpLG3VydZw==
X-Received: by 2002:a5d:64c2:0:b0:22e:41b1:faf7 with SMTP id f2-20020a5d64c2000000b0022e41b1faf7mr2380429wri.428.1666111341291;
        Tue, 18 Oct 2022 09:42:21 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id a19-20020a05600c225300b003a6a3595edasm14146164wmm.27.2022.10.18.09.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 09:42:20 -0700 (PDT)
Message-ID: <7ed5b0d3-70e3-3542-1895-4bbf6a0784d2@linaro.org>
Date:   Tue, 18 Oct 2022 18:42:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v3 2/5] vfio/spapr: Move VFIO_CHECK_EXTENSION into
 tce_iommu_ioctl()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <2-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <2-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/22 20:38, Jason Gunthorpe wrote:
> The PPC64 kconfig is a bit of a rats nest, but it turns out that if
> CONFIG_SPAPR_TCE_IOMMU is on then EEH must be too:
> 
> config SPAPR_TCE_IOMMU
> 	bool "sPAPR TCE IOMMU Support"
> 	depends on PPC_POWERNV || PPC_PSERIES
> 	select IOMMU_API
> 	help
> 	  Enables bits of IOMMU API required by VFIO. The iommu_ops
> 	  is not implemented as it is not necessary for VFIO.
> 
> config PPC_POWERNV
> 	select FORCE_PCI
> 
> config PPC_PSERIES
> 	select FORCE_PCI
> 
> config EEH
> 	bool
> 	depends on (PPC_POWERNV || PPC_PSERIES) && PCI
> 	default y
> 
> So, just open code the call to eeh_enabled() into tce_iommu_ioctl().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio_iommu_spapr_tce.c | 10 ++++------
>   drivers/vfio/vfio_spapr_eeh.c       |  6 ------
>   2 files changed, 4 insertions(+), 12 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
