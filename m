Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A259D61FCBE
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiKGSFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiKGSFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:05:05 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43EA24BD8
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:02:03 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso10154794wme.5
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:user-agent:message-id:date:references:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VuTsw6+GkSRwP58GovhtYe/JYxk+oyo+mlW8nXi3XHk=;
        b=c9L+/2+mr+pVaf+wpuESBoLqmizXoqXWcAlhmtmu9t6DBk0yMBH8Uk0jEUCbKU9YLV
         5oDUYWjLaGbzaTXz8G2w1DM+iE3tFkI+D8wq4Yrz9k4pId5WbgjBNvanKY3J8Q69aQsm
         YQ/+H+U6bwxOh7QDA1Ntbys5xrUcQFdOE+3uIKnxEWq5TrZ0SAsQo9EHomlmfg6MPbGG
         EYezTniaGhsm8bPey5aoHm6x2YZmfb5kaKjPrEImej3mAzM3/4JF/9f0FsiDzjwDOVs6
         ZIFVtGSzxG+1xoFAEJxrHhJLcBqi6FqUpkbjnVeIu/92+M2eXVYBKfscHvgzjiIPc86Q
         EDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:message-id:date:references:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VuTsw6+GkSRwP58GovhtYe/JYxk+oyo+mlW8nXi3XHk=;
        b=r4X2uVjtwdGrEB6LFPlEESd46NbaIOSt4EBBiZl1X2wcdSG57eIVydO4C3vkFHopb4
         +6PYtPgUVKLLvqjgJPUy09Jmk8uA33PtZl2bidHHjitpXmW6moI20k7zir0PFbEqqCKq
         EWhtHFa/NpN091ugWdNYP8RNiTA9IWPvEJo8w6iub0w6itFVaD6mz/L8npArsac9IWD4
         UIFdm5DakwjxG0nr/7eQItsO+DhCIJEpEAcib3aAVhhJMY/Y0UOMOWGmGoeojfnVYV6O
         9ZuRmxYid/tFk2e4qbMgvqMAh9ch9pqYZHNZefUpMYC87BjGa/WMS4u5AGK+t6e3GNcv
         +BDw==
X-Gm-Message-State: ACrzQf2EoFshXRgsYNjgBOTYLHmarpMu+7H9q2tRrrMRfUh9VeSwHCTB
        /D2VjkFWCZxhx3Td8ZDum9YTbw==
X-Google-Smtp-Source: AMsMyM5nRAXExBmaX/9edNvRducHDs1nArzvmQSX0pCwzRaBpCURrnomLsO/Kxet7CldyN/wPn+q+w==
X-Received: by 2002:a05:600c:4fd5:b0:3cf:9e9b:68f5 with SMTP id o21-20020a05600c4fd500b003cf9e9b68f5mr9168709wmq.60.1667844122108;
        Mon, 07 Nov 2022 10:02:02 -0800 (PST)
Received: from localhost ([95.148.15.66])
        by smtp.gmail.com with ESMTPSA id n1-20020a5d4841000000b002366c3eefccsm7718037wrs.109.2022.11.07.10.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 10:02:01 -0800 (PST)
From:   Punit Agrawal <punit.agrawal@bytedance.com>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, fam.zheng@bytedance.com,
        liangma@liangbit.com, punit.agrawal@bytedance.com
Subject: Re: [v2 3/6] KVM: arm64: Support pvlock preempted via shared structure
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
        <20221104062105.4119003-4-usama.arif@bytedance.com>
Date:   Mon, 07 Nov 2022 18:02:01 +0000
Message-ID: <8735au3ap2.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Usama Arif <usama.arif@bytedance.com> writes:

> Implement the service call for configuring a shared structure between a
> VCPU and the hypervisor in which the hypervisor can tell whether the
> VCPU is running or not.
>
> The preempted field is zero if the VCPU is not preempted.
> Any other value means the VCPU has been preempted.
>
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>  Documentation/virt/kvm/arm/hypercalls.rst |  3 ++
>  arch/arm64/include/asm/kvm_host.h         | 18 ++++++++++
>  arch/arm64/include/uapi/asm/kvm.h         |  1 +
>  arch/arm64/kvm/Makefile                   |  2 +-
>  arch/arm64/kvm/arm.c                      |  8 +++++
>  arch/arm64/kvm/hypercalls.c               |  8 +++++
>  arch/arm64/kvm/pvlock.c                   | 43 +++++++++++++++++++++++
>  tools/arch/arm64/include/uapi/asm/kvm.h   |  1 +
>  8 files changed, 83 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/pvlock.c
>
> diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> index 3e23084644ba..872a16226ace 100644
> --- a/Documentation/virt/kvm/arm/hypercalls.rst
> +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> @@ -127,6 +127,9 @@ The pseudo-firmware bitmap register are as follows:
>      Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
>        The bit represents the Precision Time Protocol KVM service.
>  
> +    Bit-2: KVM_REG_ARM_VENDOR_HYP_BIT_PV_LOCK:
> +      The bit represents the Paravirtualized lock service.
> +
>  Errors:
>  
>      =======  =============================================================
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 45e2136322ba..18303b30b7e9 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -417,6 +417,11 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +
> +	/* Guest PV lock state */
> +	struct {
> +		gpa_t base;
> +	} pv;

Using "pv" for the structure isn't quite describing the usage well. It'd
be better to call it "pv_lock" or "pvlock" at the least.

[...]

