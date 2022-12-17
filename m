Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7FC64F646
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 01:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLQA2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 19:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLQA2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 19:28:12 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365B01408C
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 16:28:12 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id u5so3976693pjy.5
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 16:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HDhsKZHfuqUNMSX9urbcifEWfhPYxHuNfIQ1M3OmjVc=;
        b=g/Ab07/GycQYUrotiz4yubH5NwGDTExZBr0yFWOpPCQrFK/4bkTmvElbK7EkdePWN3
         Xo6jl3RahkYuI96U+hSOrzHs+Dl+c/tt6DFCb5RU/Iq9FpGiOedmySI/h8gbYnibG8Yl
         So+qh0BNpq3I45POomANVJAPnl94Ox+QFNvhdTec9ow+VFVoS6u/6GMhtdsbHSAsnpna
         uXVNpeRb+Le9TpRlh3AGkqH1B4wx6aJhcraYZwYe9xUFEagqpOqMZ68uopAkwQ4Md0tS
         ClqpP0XhFMTZvWSGTgdCNexPqdg719ULyUPjoQG1eyAcACKoqDrqzrJ4TNA3jvqRVLA0
         GXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HDhsKZHfuqUNMSX9urbcifEWfhPYxHuNfIQ1M3OmjVc=;
        b=PDT7oAwno4m+VRPtLoL8Z5cl5H5pZuAxlhlmnlIH+H1tthyWN2X3iMDZLsKc6kCy30
         gLB6whGba/WFziM49Hv0KHMcUSqyo9+bKZGSCN+HtMNe/hk+V8prx4rEj8vHHNnMPwHc
         KnMLPHFYGovULynlISRgGa4X2prKrehsd3/5ElIoFvhTfjLoqKWZHHPpNxbJq8OeaKj2
         //VwdccAB28qy/SbJfhoPyJxrarVg3Rylm8yXuHqMKiZHZdzf29KbYfBed/TBRvpnAKh
         uCWISIJCnkLeEAYM3xiTQjqMZNzBr23tbZL+y0DB+KNTyDQeX3eQI7T8cQoO2B5oP1Ac
         jhJA==
X-Gm-Message-State: ANoB5pnViFlc3b80+MlM7ReGhcuyjQtK84cKjAz63GT6dLzSia3AN/ww
        TDPCoq0gEPf0FIBS7VY8gybYTQ==
X-Google-Smtp-Source: AA0mqf624f5KinsjkPkQbOhYbb3Vj/Ub2KIm+y6ratnfOe4aE3d1ouF0nbiSe/dUePV2L2N/ms2e4g==
X-Received: by 2002:a17:902:728e:b0:189:ba67:4739 with SMTP id d14-20020a170902728e00b00189ba674739mr33550109pll.66.1671236891689;
        Fri, 16 Dec 2022 16:28:11 -0800 (PST)
Received: from ?IPV6:2602:47:d48c:8101:c606:9489:98df:6a3b? ([2602:47:d48c:8101:c606:9489:98df:6a3b])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b00188fce6e8absm2161137plf.280.2022.12.16.16.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 16:28:11 -0800 (PST)
Message-ID: <b1317b71-d8a9-c04b-93db-12f24a35a09c@linaro.org>
Date:   Fri, 16 Dec 2022 16:28:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] sysemu/kvm: Reduce target-specific declarations
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20221216220738.7355-1-philmd@linaro.org>
 <20221216220738.7355-3-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20221216220738.7355-3-philmd@linaro.org>
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

On 12/16/22 14:07, Philippe Mathieu-Daudé wrote:
> Only the declarations using the target_ulong type are
> target specific.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/sysemu/kvm.h | 25 ++++++++++++-------------
>   1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index c8281c07a7..a53d6dab49 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -242,9 +242,6 @@ bool kvm_arm_supports_user_irq(void);
>   int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
>   int kvm_on_sigbus(int code, void *addr);
>   
> -#ifdef NEED_CPU_H
> -#include "cpu.h"
> -
>   void kvm_flush_coalesced_mmio_buffer(void);
>   
>   /**
> @@ -410,6 +407,9 @@ void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
>   struct kvm_guest_debug;
>   struct kvm_debug_exit_arch;
>   
> +#ifdef NEED_CPU_H
> +#include "cpu.h"
> +
>   struct kvm_sw_breakpoint {
>       target_ulong pc;
>       target_ulong saved_insn;
> @@ -436,6 +436,15 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg);
>   
>   bool kvm_arch_stop_on_emulation_error(CPUState *cpu);
>   
> +uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
> +                                      uint32_t index, int reg);
> +uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
> +
> +int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
> +                                       hwaddr *phys_addr);

Why did these need to move?


r~

> +
> +#endif /* NEED_CPU_H */
> +
>   int kvm_check_extension(KVMState *s, unsigned int extension);
>   
>   int kvm_vm_check_extension(KVMState *s, unsigned int extension);
> @@ -464,18 +473,8 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension);
>           kvm_vcpu_ioctl(cpu, KVM_ENABLE_CAP, &cap);                   \
>       })
>   
> -uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
> -                                      uint32_t index, int reg);
> -uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
> -
> -
>   void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len);
>   
> -int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
> -                                       hwaddr *phys_addr);
> -
> -#endif /* NEED_CPU_H */
> -
>   void kvm_cpu_synchronize_state(CPUState *cpu);
>   
>   void kvm_init_cpu_signals(CPUState *cpu);

