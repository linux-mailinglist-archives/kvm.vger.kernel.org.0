Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F82B6325C3
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 15:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiKUO2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 09:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKUO2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 09:28:35 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA3758BCD
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 06:28:33 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h24so7298526qta.9
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 06:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5zhEtdmEkFo9VdIm4gjZs/qMfIsNfNo6eduh1VXurC8=;
        b=WGaWYuICWBTUxapnXeLbTTiSj+b+UQr1CSimb3jCEW4QyJzQNaRVOiCJfLfgYQDUJC
         gbPHMtG0an1Uyv3fHbdZO0S3g1lG+769VF/kvHNGyrCthcyjlECa78GbYQfw402BAjmU
         SZlk+l1CqVkde0eyJjEUPJtFXTYPkf5FxoJS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5zhEtdmEkFo9VdIm4gjZs/qMfIsNfNo6eduh1VXurC8=;
        b=toDUmCiTYGnMm8prYvTyHtS+T+so9FsidEd0UtrqpqxzZQ8Ar17TbYKJfon+uLc4Ie
         xPX2tBUYUF1gIzVOlAZZyaurc9uaX+A/BLbV1FFmfvPKe9lZ0uv59YQdenKr8jEOfMfB
         mGoRv5rilbR2x80M40f74XGKdnZ8V9yGicGNWBF9q4PvJ7M1pWGpbakPIqgfq/Nh8Lls
         KWyMFsA99bbvqSsUxB++JlZoXekYr9t6zovcKCp6vJ5gwxGZcvrR0ZdmjUMlNVp+mu7V
         JLoAPuFkTUkfbQynsgeIdYwJenSsVcuzXloom6jyzmZZpCX8+GHY162jd/pFxPwFLzeJ
         Feeg==
X-Gm-Message-State: ANoB5pm16oeKS1WQUuf66hk9TSboM1Hn3uftw0FeaNRPL7Y9BJRdkKMm
        z+6v/ddkqO1gFgbRycefRE1vQQ==
X-Google-Smtp-Source: AA0mqf49bOxG8fRibZHiwOJgu6RBwOjmSObhN9fTdA8xEXZm7NQ4ptQ5VeRERDixCLIXbr/icriUxw==
X-Received: by 2002:a05:622a:1b0e:b0:3a6:2197:520c with SMTP id bb14-20020a05622a1b0e00b003a62197520cmr16012886qtb.183.1669040913016;
        Mon, 21 Nov 2022 06:28:33 -0800 (PST)
Received: from [192.168.2.110] (107-142-220-210.lightspeed.wlfrct.sbcglobal.net. [107.142.220.210])
        by smtp.gmail.com with ESMTPSA id m19-20020a05620a291300b006fa43e139b5sm8235210qkp.59.2022.11.21.06.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 06:28:32 -0800 (PST)
Message-ID: <8b197d19-a43a-3b29-3a05-c92a09e28d5f@digitalocean.com>
Date:   Mon, 21 Nov 2022 09:28:29 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 3/3] target/i386/kvm: get and put AMD pmu registers
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, qemu-ppc@nongnu.org,
        qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc:     pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
        chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
        jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
        danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
        groug@kaod.org, palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        joe.jin@oracle.com, likexu@tencent.com
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
 <20221119122901.2469-4-dongli.zhang@oracle.com>
From:   Liang Yan <lyan@digitalocean.com>
In-Reply-To: <20221119122901.2469-4-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A little bit more information from kernel perspective.

https://lkml.org/lkml/2022/10/31/476


I was kindly thinking of the same idea, but not sure if it is expected  
from a bare-metal perspective, since the four legacy MSRs

are always there. Also not sure if they are used by other applications.


~Liang


On 11/19/22 07:29, Dongli Zhang wrote:
> The QEMU side calls kvm_get_msrs() to save the pmu registers from the KVM
> side to QEMU, and calls kvm_put_msrs() to store the pmu registers back to
> the KVM side.
>
> However, only the Intel gp/fixed/global pmu registers are involved. There
> is not any implementation for AMD pmu registers. The
> 'has_architectural_pmu_version' and 'num_architectural_pmu_gp_counters' are
> calculated at kvm_arch_init_vcpu() via cpuid(0xa). This does not work for
> AMD. Before AMD PerfMonV2, the number of gp registers is decided based on
> the CPU version.
>
> This patch is to add the support for AMD version=1 pmu, to get and put AMD
> pmu registers. Otherwise, there will be a bug:
>
> 1. The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
> is running "perf top". The pmu registers are not disabled gracefully.
>
> 2. Although the x86_cpu_reset() resets many registers to zero, the
> kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
> some pmu events are still enabled at the KVM side.
>
> 3. The KVM pmc_speculative_in_use() always returns true so that the events
> will not be reclaimed. The kvm_pmc->perf_event is still active.
>
> 4. After the reboot, the VM kernel reports below error:
>
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
>
> 5. In a worse case, the active kvm_pmc->perf_event is still able to
> inject unknown NMIs randomly to the VM kernel.
>
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>
> The patch is to fix the issue by resetting AMD pmu registers during the
> reset.
>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>   target/i386/cpu.h     |  5 +++
>   target/i386/kvm/kvm.c | 83 +++++++++++++++++++++++++++++++++++++++++--
>   2 files changed, 86 insertions(+), 2 deletions(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index d4bc19577a..4cf0b98817 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -468,6 +468,11 @@ typedef enum X86Seg {
>   #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>   
> +#define MSR_K7_EVNTSEL0                 0xc0010000
> +#define MSR_K7_PERFCTR0                 0xc0010004
> +#define MSR_F15H_PERF_CTL0              0xc0010200
> +#define MSR_F15H_PERF_CTR0              0xc0010201
> +
>   #define MSR_MC0_CTL                     0x400
>   #define MSR_MC0_STATUS                  0x401
>   #define MSR_MC0_ADDR                    0x402
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 0b1226ff7f..023fcbce48 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2005,6 +2005,32 @@ int kvm_arch_init_vcpu(CPUState *cs)
>           }
>       }
>   
> +    if (IS_AMD_CPU(env)) {
> +        int64_t family;
> +
> +        family = (env->cpuid_version >> 8) & 0xf;
> +        if (family == 0xf) {
> +            family += (env->cpuid_version >> 20) & 0xff;
> +        }
> +
> +        /*
> +         * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
> +         * disable the AMD pmu virtualization.
> +         *
> +         * If KVM_CAP_PMU_CAPABILITY is supported, "!has_pmu_cap" indicates
> +         * the KVM side has already disabled the pmu virtualization.
> +         */
> +        if (family >= 6 && (!has_pmu_cap || cpu->enable_pmu)) {
> +            has_architectural_pmu_version = 1;
> +
> +            if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE) {
> +                num_architectural_pmu_gp_counters = 6;
> +            } else {
> +                num_architectural_pmu_gp_counters = 4;
> +            }
> +        }
> +    }
> +
>       cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
>   
>       for (i = 0x80000000; i <= limit; i++) {
> @@ -3326,7 +3352,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>               kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>           }
>   
> -        if (has_architectural_pmu_version > 0) {
> +        if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
>               if (has_architectural_pmu_version > 1) {
>                   /* Stop the counter.  */
>                   kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> @@ -3357,6 +3383,26 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                                     env->msr_global_ctrl);
>               }
>           }
> +
> +        if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
> +            uint32_t step = 1;
> +
> +            if (num_architectural_pmu_gp_counters == 6) {
> +                sel_base = MSR_F15H_PERF_CTL0;
> +                ctr_base = MSR_F15H_PERF_CTR0;
> +                step = 2;
> +            }
> +
> +            for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> +                kvm_msr_entry_add(cpu, ctr_base + i * step,
> +                                  env->msr_gp_counters[i]);
> +                kvm_msr_entry_add(cpu, sel_base + i * step,
> +                                  env->msr_gp_evtsel[i]);
> +            }
> +        }
> +
>           /*
>            * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>            * only sync them to KVM on the first cpu
> @@ -3817,7 +3863,7 @@ static int kvm_get_msrs(X86CPU *cpu)
>       if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
>           kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>       }
> -    if (has_architectural_pmu_version > 0) {
> +    if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
>           if (has_architectural_pmu_version > 1) {
>               kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>               kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> @@ -3833,6 +3879,25 @@ static int kvm_get_msrs(X86CPU *cpu)
>           }
>       }
>   
> +    if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
> +        uint32_t sel_base = MSR_K7_EVNTSEL0;
> +        uint32_t ctr_base = MSR_K7_PERFCTR0;
> +        uint32_t step = 1;
> +
> +        if (num_architectural_pmu_gp_counters == 6) {
> +            sel_base = MSR_F15H_PERF_CTL0;
> +            ctr_base = MSR_F15H_PERF_CTR0;
> +            step = 2;
> +        }
> +
> +        for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> +            kvm_msr_entry_add(cpu, ctr_base + i * step,
> +                              env->msr_gp_counters[i]);
> +            kvm_msr_entry_add(cpu, sel_base + i * step,
> +                              env->msr_gp_evtsel[i]);
> +        }
> +    }
> +
>       if (env->mcg_cap) {
>           kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>           kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
> @@ -4118,6 +4183,20 @@ static int kvm_get_msrs(X86CPU *cpu)
>           case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>               env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>               break;
> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + 3:
> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
> +            break;
> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + 3:
> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
> +            break;
> +        case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTL0 + 0xb:
> +            index = index - MSR_F15H_PERF_CTL0;
> +            if (index & 0x1) {
> +                env->msr_gp_counters[index] = msrs[i].data;
> +            } else {
> +                env->msr_gp_evtsel[index] = msrs[i].data;
> +            }
> +            break;
>           case HV_X64_MSR_HYPERCALL:
>               env->msr_hv_hypercall = msrs[i].data;
>               break;
