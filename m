Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B430A60F136
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 09:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbiJ0Hic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 03:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiJ0Hib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 03:38:31 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3905616657B
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 00:38:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id io19so588311plb.8
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 00:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VKQSudBZvWki0+CLHG9r3IJk/dRwqSLfexPzsqrOL10=;
        b=x1Vidfs809+nxHcSntjvb/QuAdCG/z26RlTfItr4BZ9GE6g8GavghOayuC4MBT/FZB
         kT0kux16HUr9NO46eRsomZONq8pXnJ1jwrcuCz9YkE3UXxEttVvN4mLLBjIAVuOeXyGL
         QT4FGgxubG6/xLSAjLDBGs566fxEhoXOGphArVzf9Q1Rk9fBfBV3iz7OZX5TXob34wgq
         JrNW3q9mVdkUMnZNIu4+hptcIxzJ4/DY5YAN9coC9YrQQBsM6JjNRaoUMom6IjxOYGdG
         AXMkgiiwlFEB/PsR67CLg3fbtTfM+sUJhiYGsJik+BeQsyi6xwlii/IWNnYzzCstX0wt
         Yuag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VKQSudBZvWki0+CLHG9r3IJk/dRwqSLfexPzsqrOL10=;
        b=cbFo/bgt2KZ+PQK25O0f58zYVrd0wEs2pkU3obuHAjC0SXyJcRIWnCwhOty2VlGbps
         NoAdrPFnylwpEZjIOo0RMJcJXsg9bBUGmLJ8Px98KRYx9X8bjs13RQz8vwRCurREktOD
         JwbwVNMAfNXAybG8gee0riKPVkWscqe89ah8fhUNINnQRQyWE7pzNYaYZQZ7QSpCEe7q
         x2Ocfo/Jg5MLt0OyqpVy9WL/Mm7oyiW4+y83DIzsLNVSJKMhjvSHkmcVsvDpJJKmZ2kU
         CLaZ8LbLe1jEChc88Gus+Umb/d/aJOuC0lRT04JD7+u2S1YllhVNoYt3RcuJupdRWvZt
         kqZg==
X-Gm-Message-State: ACrzQf0mhVrjDN+b0GwBHBWVC44SslxmdqIprdGvpSle1pnQ9584UXX0
        vhmRlfLqroPFv8LLJ9RGiItGGJHATRX9Pg==
X-Google-Smtp-Source: AMsMyM6H1exe3qYH4Ks+/ZVGoyDVw8cDO6zYG/dyVO3aZTV3T/P8NAf+BoYHwqqdQxR4cjI0F5IXhg==
X-Received: by 2002:a17:902:f641:b0:17f:3633:5439 with SMTP id m1-20020a170902f64100b0017f36335439mr48542732plg.94.1666856307429;
        Thu, 27 Oct 2022 00:38:27 -0700 (PDT)
Received: from [192.168.10.153] (ppp121-45-204-168.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.204.168])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090264c100b00178ab008364sm548557pli.37.2022.10.27.00.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 00:38:26 -0700 (PDT)
Message-ID: <7a790aa8-c643-1098-4d28-bd3b10399fcd@ozlabs.ru>
Date:   Thu, 27 Oct 2022 18:38:12 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
Content-Language: en-US
To:     kvm@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>, kvm-ppc@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Marc Zyngier <maz@kernel.org>
References: <20221003235722.2085145-1-aik@ozlabs.ru>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20221003235722.2085145-1-aik@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, ping?


On 04/10/2022 10:57, Alexey Kardashevskiy wrote:
> When introduced, IRQFD resampling worked on POWER8 with XICS. However
> KVM on POWER9 has never implemented it - the compatibility mode code
> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
> XIVE mode does not handle INTx in KVM at all.
> 
> This moved the capability support advertising to platforms and stops
> advertising it on XIVE, i.e. POWER9 and later.
> 
> This should cause no behavioural change for other architectures.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Acked-by: Nicholas Piggin <npiggin@gmail.com>
> Acked-by: Marc Zyngier <maz@kernel.org>
> ---
> Changes:
> v4:
> * removed incorrect clause about changing behavoir on MIPS and RISCV
> 
> v3:
> * removed all ifdeferry
> * removed the capability for MIPS and RISCV
> * adjusted the commit log about MIPS and RISCV
> 
> v2:
> * removed ifdef for ARM64.
> ---
>   arch/arm64/kvm/arm.c       | 1 +
>   arch/powerpc/kvm/powerpc.c | 6 ++++++
>   arch/s390/kvm/kvm-s390.c   | 1 +
>   arch/x86/kvm/x86.c         | 1 +
>   virt/kvm/kvm_main.c        | 1 -
>   5 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 2ff0ef62abad..d2daa4d375b5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_VCPU_ATTRIBUTES:
>   	case KVM_CAP_PTP_KVM:
>   	case KVM_CAP_ARM_SYSTEM_SUSPEND:
> +	case KVM_CAP_IRQFD_RESAMPLE:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index fb1490761c87..908ce8bd91c9 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		break;
>   #endif
>   
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +	case KVM_CAP_IRQFD_RESAMPLE:
> +		r = !xive_enabled();
> +		break;
> +#endif
> +
>   	case KVM_CAP_PPC_ALLOC_HTAB:
>   		r = hv_enabled;
>   		break;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index edfd4bbd0cba..7521adadb81b 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -577,6 +577,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_S390_DIAG318:
>   	case KVM_CAP_S390_MEM_OP_EXTENSION:
> +	case KVM_CAP_IRQFD_RESAMPLE:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43a6a7efc6ec..2d6c5a8fdf14 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4395,6 +4395,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_VAPIC:
>   	case KVM_CAP_ENABLE_CAP:
>   	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +	case KVM_CAP_IRQFD_RESAMPLE:
>   		r = 1;
>   		break;
>   	case KVM_CAP_EXIT_HYPERCALL:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 584a5bab3af3..05cf94013f02 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4447,7 +4447,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>   #endif
>   #ifdef CONFIG_HAVE_KVM_IRQFD
>   	case KVM_CAP_IRQFD:
> -	case KVM_CAP_IRQFD_RESAMPLE:
>   #endif
>   	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
>   	case KVM_CAP_CHECK_EXTENSION_VM:

-- 
Alexey
