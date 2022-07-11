Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830BD570416
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiGKNWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 09:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGKNWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 09:22:33 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9CC3C16C
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 06:22:30 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q82so4715440pgq.6
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 06:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=u0wAr4upCVZRooXgOjKHGSTU5W+O4lveiB+3Eihyras=;
        b=TiE4LrBMx9ByHBvT8CyXTfPrjJdFTrnRe8+TqfdjQKx4fQbEvZFxBxRv/Igl/Ugxnn
         oeZHblw45Lk6MsKz1B3rg/bNf0Uv2tpgOsRGPsT5zHepUB45kKcO6DkTLeq50tV7CWnb
         q3ZDIll+5XzLEp8KxV2eiE0aue6kWVWz5MsSl6qUQThdaacR6dYYHJ3xGcOYocZA87yK
         PeB+rKUqy+OzG5tWpYC2rsdJIJ/hquhbfmEQw9X4iGlbJ4HQTts8K4Sb779UISqUTtgB
         90CNKcv//eEvsFQkHvEZv6/GEw2np3XE35KH6IVxNQLZ96gHn7DLNguTFvbQbgS1uIab
         i/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=u0wAr4upCVZRooXgOjKHGSTU5W+O4lveiB+3Eihyras=;
        b=tNloMAVgYWXh+ufEicdKDb1YaI0kSwZZgIAkyzWWn1RGQE1yzTW/NyQ351aRhzCaTs
         m7CLh3njlSWqSTkF1iWrWQR1V3+0cUu1bqPvbR2QW4jab/DbqMK/a4Mv1aieKGdF4tZb
         dM9KTGSYaVHxzbD/h0ImV/j8qKc/mKnaOAj3iNQ8obSOeZJjqQ/04XgbXDX8F4BsrQbX
         4Sdbsqdnp2GVE1Y3l4TcsMbgJoPGobaqCnSPjEUcg6yy5gUrIAQNCAncLgFoL5JX3/Ny
         CojV7Q9rpAwmDNrCKOwgrPhf3RGfS4Frq6GyAlK5Q5gMJVavLu1SnubGDyNNobGYoN2O
         ES5Q==
X-Gm-Message-State: AJIora/+AAm+C1rM+soaW4NDa37uuSQLKgNf7BQsWXo63sSWJGSDxGeQ
        OQw2u2/ODuAQtIUo1nNNxItHOw==
X-Google-Smtp-Source: AGRyM1usYEtxcunKKGc+ooAdB/jHx3OTPzPK4KcYuAwwi41aLzREct1kVkBMf7cAMctP/YCZ+nEZRA==
X-Received: by 2002:a05:6a00:18a7:b0:51b:c63f:1989 with SMTP id x39-20020a056a0018a700b0051bc63f1989mr18229943pfh.49.1657545750304;
        Mon, 11 Jul 2022 06:22:30 -0700 (PDT)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id d10-20020a621d0a000000b005289f594326sm4716835pfd.69.2022.07.11.06.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 06:22:29 -0700 (PDT)
Message-ID: <64bc8c04-2162-2e4b-6556-03b9dde051e2@ozlabs.ru>
Date:   Mon, 11 Jul 2022 23:24:32 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linuxppc-dev@lists.ozlabs.org, Robin Murphy <robin.murphy@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joerg Roedel <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Oliver O'Halloran <oohall@gmail.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20220707135552.3688927-1-aik@ozlabs.ru>
 <20220707151002.GB1705032@nvidia.com>
 <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru>
 <bbe29694-66a3-275b-5a79-71237ad7388f@ozlabs.ru>
 <20220708115522.GD1705032@nvidia.com>
 <8329c51a-601e-0d93-41b4-2eb8524c9bcb@ozlabs.ru>
 <Yspx307fxRXT67XG@nvidia.com>
 <861e8bd1-9f04-2323-9b39-d1b46bf99711@ozlabs.ru>
In-Reply-To: <861e8bd1-9f04-2323-9b39-d1b46bf99711@ozlabs.ru>
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



On 10/07/2022 22:32, Alexey Kardashevskiy wrote:
> 
> 
> On 10/07/2022 16:29, Jason Gunthorpe wrote:
>> On Sat, Jul 09, 2022 at 12:58:00PM +1000, Alexey Kardashevskiy wrote:
>>> driver->ops->attach_group on POWER attaches a group so VFIO claims 
>>> ownership
>>> over a group, not devices. Underlying API 
>>> (pnv_ioda2_take_ownership()) does
>>> not need to keep track of the state, it is one group, one ownership
>>> transfer, easy.
>>
>> It should not change, I think you can just map the attach_dev to the 
>> group?
> 
> There are multiple devices in a group, cannot just map 1:1.
> 
> 
>>> What is exactly the reason why iommu_group_claim_dma_owner() cannot stay
>>> inside Type1 (sorry if it was explained, I could have missed)?
>>
>> It has nothing to do with type1 - the ownership system is designed to
>> exclude other in-kernel drivers from using the group at the same time
>> vfio is using the group. power still needs this protection regardless
>> of if is using the formal iommu api or not.
> 
> POWER deals with it in vfio_iommu_driver_ops::attach_group.


I really think that for 5.19 we should really move this blocked domain 
business to Type1 like this:

https://github.com/aik/linux/commit/96f80c8db03b181398ad355f6f90e574c3ada4bf

Thanks,


>>> Also, from another mail, you said iommu_alloc_default_domain() should 
>>> fail
>>> on power but at least IOMMU_DOMAIN_BLOCKED must be supported, or the 
>>> whole
>>> iommu_group_claim_dma_owner() thing falls apart.
>>
>> Yes
>>
>>> And iommu_ops::domain_alloc() is not told if it is asked to create a 
>>> default
>>> domain, it only takes a type.
>>
>> "default domain" refers to the default type pased to domain_alloc(),
>> it will never be blocking, so it will always fail on power.
>> "default domain" is better understood as the domain used by the DMA
>> API
> 
> The DMA API on POWER does not use iommu_ops, it is dma_iommu_ops from 
> arch/powerpc/kernel/dma-iommu.c from before 2005. so the default domain 
> is type == 0 where 0 == BLOCKED.
> 

-- 
Alexey
