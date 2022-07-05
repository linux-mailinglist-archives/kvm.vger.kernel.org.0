Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ECA566230
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 06:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbiGEEWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 00:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiGEEWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 00:22:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8252E009
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 21:22:42 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id z12-20020a17090a7b8c00b001ef84000b8bso5197484pjc.1
        for <kvm@vger.kernel.org>; Mon, 04 Jul 2022 21:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cM65vaRgPXMbz7bzmMhan9u9d+HO/BgaeCm7nQ9iBpY=;
        b=Drh1NgdiOSt7+g3QCLMmXp+8pqJrBgmLmcxii/kj14n0vqVQmkfB3dqzspaW0SoKn4
         kHPv51z7550dRyof6EUtIsG6n6As/bgk+cYSZzmS+bH2m523tzX9QHHKEAaIZk3kUCSc
         EN0W5L9T+QDf/JCcjC3uKXMWRv1bEO7iGXupKc7yefH+CRSwe9JoXZZZUrUOIKcLfxlI
         qB05GEBd14hqILQUCB981gVpBkbQK8CTTlG2obzy+vhQQfinqzkbCW7XQSlp23w+fgn0
         GkUj422eEoPQiXwEA6F7GXC79NWT0VNNqgarbcOigCy5zjxcsdodEy9eLS7fTlDR2klD
         wjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cM65vaRgPXMbz7bzmMhan9u9d+HO/BgaeCm7nQ9iBpY=;
        b=7g3h2xaCntNE7oq7w0rzAU34oXNNMeCcsnmC+J0eMjTpJ7tn+yQv7VBs/SH5FElbjI
         ix90Yk4anmZ6CuiA5MUuX0Zhkp1iHsytwGLylwaKAxcfLWAruSwIRcW4Kpp6i23hiiVN
         rVP6MqQnxJKAvY9rDqYmN1w7sYn2lDDtPoDWjuf8KqCcyqHtHlf0jeF5GPY2cQinDqKo
         RL7BI7Gnzo4bhR737kaqDi2rQ4Tu98aRwXwE4gzW0S4cvqJTORWg2+l5jOjJfI7JY6cS
         kN5cOdOf5JxMyLcziZe3o9mx5UdT9NRutoINcuNzWWwcE4269k1IRpPDvGb83ardzy8J
         Mz+A==
X-Gm-Message-State: AJIora+BwxQkU5pbiCHdt75vKF9Bk/ADIyoE3PPb0zbBzfXAlVkGyD2J
        17SDf3tscKPSeS2APVe3sruZ6w==
X-Google-Smtp-Source: AGRyM1veEg4+4kA74G4Y9y9l/a0vr3Ru4s3t2Y/NQtpl9oo298lJccz7QjHnzI0x3y8IgSlfjUQE/A==
X-Received: by 2002:a17:90b:1bc4:b0:1ed:361b:702c with SMTP id oa4-20020a17090b1bc400b001ed361b702cmr38225421pjb.136.1656994962180;
        Mon, 04 Jul 2022 21:22:42 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id cj15-20020a056a00298f00b0052559bd12aasm21671946pfb.61.2022.07.04.21.22.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 21:22:41 -0700 (PDT)
Message-ID: <27589342-4603-614e-6c9a-816fa0e270fc@ozlabs.ru>
Date:   Tue, 5 Jul 2022 14:22:36 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH rc] vfio: Move IOMMU_CAP_CACHE_COHERENCY test to after we
 know we have a group
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <0-v1-e8934b490f36+f4-vfio_cap_fix_jgg@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <0-v1-e8934b490f36+f4-vfio_cap_fix_jgg@nvidia.com>
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



On 7/5/22 11:10, Jason Gunthorpe wrote:
> The test isn't going to work if a group doesn't exist. Normally this isn't
> a problem since VFIO isn't going to create a device if there is no group,
> but the special CONFIG_VFIO_NOIOMMU behavior allows bypassing this
> prevention. The new cap test effectively forces a group and breaks this
> config option.
> 
> Move the cap test to vfio_group_find_or_alloc() which is the earliest time
> we know we have a group available and thus are not running in noiommu mode.
> 
> Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
> Reported-by "chenxiang (M)" <chenxiang66@hisilicon.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> This should fixe the issue with dpdk on noiommu, but I've left PPC out.
> 
> I think the right way to fix PPC is to provide the iommu_ops for the devices
> groups it is creating. They don't have to be fully functional - eg they don't
> have to to create domains, but if the ops exist they can correctly respond to
> iommu_capable() and we don't need special code here to work around PPC being
> weird.


This is what I've been doing since Friday and while the coherency thing 
is easy to do, the iommu_group_claim_dma_owner() is not - it wants to 
allocate domains which leads to more hooks and even when I do all that - 
for example, iommu_group_claim_dma_owner() won't do what it supposed to 
as nothing outside VFIO is going to try mapping DMA and fail to report 
that the group is not "viable".

I think I'll post the iommu_ops PPC patch for coherency and continue 
poking the other thing. Thanks,


> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index e43b9496464bbf..cbb693359502d9 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -552,6 +552,16 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>   	if (!iommu_group)
>   		return ERR_PTR(-EINVAL);
>   
> +	/*
> +	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> +	 * restore cache coherency. It has to be checked here because it is only
> +	 * valid for cases where we are using iommu groups.
> +	 */
> +	if (!iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY)) {
> +		iommu_group_put(iommu_group);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>   	group = vfio_group_get_from_iommu(iommu_group);
>   	if (!group)
>   		group = vfio_create_group(iommu_group, VFIO_IOMMU);
> @@ -604,13 +614,6 @@ static int __vfio_register_dev(struct vfio_device *device,
>   
>   int vfio_register_group_dev(struct vfio_device *device)
>   {
> -	/*
> -	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> -	 * restore cache coherency.
> -	 */
> -	if (!iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
> -		return -EINVAL;
> -
>   	return __vfio_register_dev(device,
>   		vfio_group_find_or_alloc(device->dev));
>   }
> 
> base-commit: e2475f7b57209e3c67bf856e1ce07d60d410fb40

-- 
Alexey
