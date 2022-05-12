Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03380524678
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 09:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350752AbiELHHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 03:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350719AbiELHHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 03:07:17 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8A627CCF
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 00:07:16 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id v11so3996603pff.6
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 00:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=319/RuN0YbUvetJSlx7oakpoNVUE7HqxCIHYWexkjE8=;
        b=qXsG/am9c+VWQf5Ax7DDEiD7YTOX11ziFugMqIwdRFa04Jj1YYM48p/7qXy9lg1y04
         7Jwllemv5olYSyGOq5y1qMoawTD1tcIDB/4uNCZOJ6IwuLaa8V7f6VZbgKJg7luxfPjY
         C08dCjUignSH2HieQeP+e+GnrIBNVZ+rvDQI5OAMmSvKR51oXnvZRcVFBTVa8uIkck51
         pZoUcPsETkTN5K1y+81lXhxwilMfJyJd03m5k1GODCq5SS+uqTGVr+LkoKbWG0pIiYGc
         h5VWxwkz8d0DfmSRM50R41eSTBX4haaF8QIqAsRw45SauOluQ0EUm33nVIuYAsv6cive
         hwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=319/RuN0YbUvetJSlx7oakpoNVUE7HqxCIHYWexkjE8=;
        b=QDci9YYrpvOU45/o85eDiav8dHreoTrkU25lnMGSdR1+qZvZaG7ycYLnGBvs6IvuiS
         Nxu9dA/qZq8G5icnsEw+AiqZwMTcKkRnbqwlO+D5WSdzIZU1rtgy1SnTVUZylbjH7kZt
         tB9/MEbK8xrHcziAA6Oqw7oVU12TeYwiUJBzQ+eDl/7j/QAqseu8WQ9oEyuLdwWx14EF
         xeUEa/5vtNR+/xMIAPdC49DT997oSPi7HisUOXjxpv6sA9ZL0fx/IrXAYhdPLAFs4mqz
         NhT2pXxqOCzz7h+4kJKvbX7YLtr63RFqU0Rrcm2Q2l8LCa7AaekP3cUULVPzO8ClRZno
         hBAA==
X-Gm-Message-State: AOAM5322qmetXh4Pf3caxp+jrYOihyIeFS7KoJk3FLUobwhR0Rxdw8+g
        RrV62XsKh/QbFli+ZSQxeN9AW2dJzo8D8A==
X-Google-Smtp-Source: ABdhPJyOi6aHqIM/y47xJpvmXjwkOxBj1StA3kwlf04wBc+qONTuJ9Djhqk8fbU3a+uSq8FDWzj2kA==
X-Received: by 2002:a63:303:0:b0:3db:5806:c365 with SMTP id 3-20020a630303000000b003db5806c365mr2525523pgd.302.1652339235992;
        Thu, 12 May 2022 00:07:15 -0700 (PDT)
Received: from [10.87.0.6] ([94.177.118.16])
        by smtp.gmail.com with ESMTPSA id p17-20020a63b811000000b003c14af50607sm1112765pge.31.2022.05.12.00.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 00:07:15 -0700 (PDT)
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        kvm@vger.kernel.org, Vivek Kumar Gautam <Vivek.Gautam@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
 <0e2f7cb8-f0d9-8209-6bc2-ca87fff57f1f@arm.com>
 <20220510181327.GM49344@nvidia.com>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <6c6f3ecb-6339-4093-a15a-fcf95a7c61fb@linaro.org>
Date:   Thu, 12 May 2022 15:07:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220510181327.GM49344@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jason

On 2022/5/11 上午2:13, Jason Gunthorpe via iommu wrote:
> On Tue, May 10, 2022 at 06:52:06PM +0100, Robin Murphy wrote:
>> On 2022-05-10 17:55, Jason Gunthorpe via iommu wrote:
>>> This control causes the ARM SMMU drivers to choose a stage 2
>>> implementation for the IO pagetable (vs the stage 1 usual default),
>>> however this choice has no visible impact to the VFIO user. Further qemu
>>> never implemented this and no other userspace user is known.
>>>
>>> The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
>>> new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
>>> SMMU translation services to the guest operating system" however the rest
>>> of the API to set the guest table pointer for the stage 1 was never
>>> completed, or at least never upstreamed, rendering this part useless dead
>>> code.
>>>
>>> Since the current patches to enable nested translation, aka userspace page
>>> tables, rely on iommufd and will not use the enable_nesting()
>>> iommu_domain_op, remove this infrastructure. However, don't cut too deep
>>> into the SMMU drivers for now expecting the iommufd work to pick it up -
>>> we still need to create S2 IO page tables.
>>>
>>> Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
>>> enable_nesting iommu_domain_op.
>>>
>>> Just in-case there is some userspace using this continue to treat
>>> requesting it as a NOP, but do not advertise support any more.
>> I assume the nested translation/guest SVA patches that Eric and Vivek were
>> working on pre-IOMMUFD made use of this, and given that they got quite far
>> along, I wouldn't be too surprised if some eager cloud vendors might have
>> even deployed something based on the patches off the list.
> With upstream there is no way to make use of this flag, if someone is
> using it they have other out of tree kernel, vfio, kvm and qemu
> patches to make it all work.
>
> You can see how much is still needed in Eric's tree:
>
> https://github.com/eauger/linux/commits/v5.15-rc7-nested-v16
>
>> I can't help feeling a little wary about removing this until IOMMUFD
>> can actually offer a functional replacement - is it in the way of
>> anything upcoming?
>  From an upstream perspective if someone has a patched kernel to
> complete the feature, then they can patch this part in as well, we
> should not carry dead code like this in the kernel and in the uapi.
>
> It is not directly in the way, but this needs to get done at some
> point, I'd rather just get it out of the way.

We are using this interface for nested mode.

Is the replacing patch ready?
Can we remove this until submitting the new one?

Thanks

