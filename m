Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85524502C58
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354834AbiDOPJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348301AbiDOPJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:09:45 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CCEBD7E8;
        Fri, 15 Apr 2022 08:07:15 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id q20so5092811wmq.1;
        Fri, 15 Apr 2022 08:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h3oyEPn3XqVXHA6J3WUv1G+Jq//hs7VIltyFgIKyw60=;
        b=JWPXLfHSc4CgJv3UmjWqBDPMmsbLQRnPKSYpSZ17CsZkdNgm6e8s5FIJTVJjO3S/6N
         1nP5FXfqNy50RW/xMk+ry42vTDC8UYhbSseQtw/KONz4AWcLqinfzEehTcv7CCjnVjiE
         WLjQxWNxKZrMEEvu7/avXNheeQ9qq/PJ9K7jkglY9UBXETCoGa1hjZOrOGqRVr9MxOt5
         mV4WAsrg1meV+8ahFN2XsTrYUYMPSLKlZvKF3XNmu1jpFk9UnpjZh4nBhxJKfu+NafUz
         s1+jos3V4ecUNytFBbub5V5qva2VxO54uBHMPy+SKi1aAj1lB+9qrFnu73nL7dXGpRTA
         fWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h3oyEPn3XqVXHA6J3WUv1G+Jq//hs7VIltyFgIKyw60=;
        b=eiNc94TFo9cqfXm9EH8rPrlSkQbgyLOui2/644lhP2gK7l0C4RAsji0Er4xzevjEF7
         UO0TKoO6FBu2BOUzt/6Us1x3kK2o9xhjqlOJpUeUzKsVFg7UHSv6HjeC188FDXMcwz1s
         kqY4xXFfhEOKr1EkQ2+iPbT3JZb83rdBMF67kJqccRFCQM6t6cJGhrt7PyaCn4sSk6vY
         KQ5rTwZHnof2xYQkQBvs+YBmb4+G4wFS8TvBSghPHhEK/CBP44p7K0NQ3V/5+zBamsC7
         ZA0Yq2ehe/1f9bDQvOWU7wrmDN2RnJ/gsvNeeHN4OY+/rqcF4h2TUA6HvDxJwLyjs7G/
         BWnw==
X-Gm-Message-State: AOAM530Md82cOtd37jnz7SJg6dMEsQzwQcik9+DSFBoDtDq7Uo7PlYDG
        fR5emfjY1JhgwfRk69GhIHU=
X-Google-Smtp-Source: ABdhPJznKoIHHDsd5QOSsOE3phy5zLL3MxR7aJu21+vTYoG3YYOu/J6yffAzGvuwdWD/2jWf3NJeDg==
X-Received: by 2002:a05:600c:1d88:b0:38e:c4d8:7dbb with SMTP id p8-20020a05600c1d8800b0038ec4d87dbbmr3646853wms.1.1650035234137;
        Fri, 15 Apr 2022 08:07:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id u16-20020a05600c441000b0038ebcbadcedsm12654908wmn.2.2022.04.15.08.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 08:07:13 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <ad1090e4-824f-2ffe-d69b-148e08e45047@redhat.com>
Date:   Fri, 15 Apr 2022 17:07:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 095/104] KVM: TDX: Implement callbacks for MSR
 operations for TDX
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c98edbcdf5f7163ae04456f7e40be436f6d95744.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <c98edbcdf5f7163ae04456f7e40be436f6d95744.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Implements set_msr/get_msr/has_emulated_msr methods for TDX to handle
> hypercall from guest TD for paravirtualized rdmsr and wrmsr.  The TDX
> module virtualizes MSRs.  For some MSRs, it injects #VE to the guest TD
> upon RDMSR or WRMSR.  The exact list of such MSRs are defined in the spec.
> 
> Upon #VE, the guest TD may execute hypercalls,
> TDG.VP.VMCALL<INSTRUCTION.RDMSR> and TDG.VP.VMCALL<INSTRUCTION.WRMSR>,
> which are defined in GHCI (Guest-Host Communication Interface) so that the
> host VMM (e.g. KVM) can virtualizes the MSRs.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 34 +++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 68 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  6 ++++
>   3 files changed, 105 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 1e65406e3882..a528cfdbce54 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -165,6 +165,34 @@ static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   	vmx_handle_exit_irqoff(vcpu);
>   }
>   
> +static int vt_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> +{
> +	if (unlikely(is_td_vcpu(vcpu)))
> +		return tdx_set_msr(vcpu, msr_info);
> +
> +	return vmx_set_msr(vcpu, msr_info);
> +}
> +
> +/*
> + * The kvm parameter can be NULL (module initialization, or invocation before
> + * VM creation). Be sure to check the kvm parameter before using it.
> + */
> +static bool vt_has_emulated_msr(struct kvm *kvm, u32 index)
> +{
> +	if (kvm && is_td(kvm))
> +		return tdx_is_emulated_msr(index, true);
> +
> +	return vmx_has_emulated_msr(kvm, index);
> +}
> +
> +static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> +{
> +	if (unlikely(is_td_vcpu(vcpu)))
> +		return tdx_get_msr(vcpu, msr_info);
> +
> +	return vmx_get_msr(vcpu, msr_info);
> +}
> +
>   static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -393,7 +421,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.hardware_enable = vt_hardware_enable,
>   	.hardware_disable = vt_hardware_disable,
>   	.cpu_has_accelerated_tpr = report_flexpriority,
> -	.has_emulated_msr = vmx_has_emulated_msr,
> +	.has_emulated_msr = vt_has_emulated_msr,
>   
>   	.is_vm_type_supported = vt_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_vmx),
> @@ -411,8 +439,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.update_exception_bitmap = vmx_update_exception_bitmap,
>   	.get_msr_feature = vmx_get_msr_feature,
> -	.get_msr = vmx_get_msr,
> -	.set_msr = vmx_set_msr,
> +	.get_msr = vt_get_msr,
> +	.set_msr = vt_set_msr,
>   	.get_segment_base = vmx_get_segment_base,
>   	.get_segment = vmx_get_segment,
>   	.set_segment = vmx_set_segment,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 914af5da4805..cec2660206bd 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1517,6 +1517,74 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>   	*error_code = 0;
>   }
>   
> +bool tdx_is_emulated_msr(u32 index, bool write)
> +{
> +	switch (index) {
> +	case MSR_IA32_UCODE_REV:
> +	case MSR_IA32_ARCH_CAPABILITIES:
> +	case MSR_IA32_POWER_CTL:
> +	case MSR_MTRRcap:
> +	case 0x200 ... 0x26f:
> +		/* IA32_MTRR_PHYS{BASE, MASK}, IA32_MTRR_FIX*_* */
> +	case MSR_IA32_CR_PAT:
> +	case MSR_MTRRdefType:
> +	case MSR_IA32_TSC_DEADLINE:
> +	case MSR_IA32_MISC_ENABLE:
> +	case MSR_KVM_STEAL_TIME:
> +	case MSR_KVM_POLL_CONTROL:
> +	case MSR_PLATFORM_INFO:
> +	case MSR_MISC_FEATURES_ENABLES:
> +	case MSR_IA32_MCG_CAP:
> +	case MSR_IA32_MCG_STATUS:
> +	case MSR_IA32_MCG_CTL:
> +	case MSR_IA32_MCG_EXT_CTL:
> +	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_MISC(28) - 1:
> +		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC} */
> +		return true;
> +	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
> +		/*
> +		 * x2APIC registers that are virtualized by the CPU can't be
> +		 * emulated, KVM doesn't have access to the virtual APIC page.
> +		 */
> +		switch (index) {
> +		case X2APIC_MSR(APIC_TASKPRI):
> +		case X2APIC_MSR(APIC_PROCPRI):
> +		case X2APIC_MSR(APIC_EOI):
> +		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
> +		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
> +		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
> +			return false;
> +		default:
> +			return true;
> +		}
> +	case MSR_IA32_APICBASE:
> +	case MSR_EFER:
> +		return !write;
> +	case MSR_IA32_MCx_CTL2(0) ... MSR_IA32_MCx_CTL2(31):
> +		/*
> +		 * 0x280 - 0x29f: The x86 common code doesn't emulate MCx_CTL2.
> +		 * Refer to kvm_{get,set}_msr_common(),
> +		 * kvm_mtrr_{get, set}_msr(), and msr_mtrr_valid().
> +		 */
> +	default:
> +		return false;
> +	}
> +}
> +
> +int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	if (tdx_is_emulated_msr(msr->index, false))
> +		return kvm_get_msr_common(vcpu, msr);
> +	return 1;
> +}
> +
> +int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	if (tdx_is_emulated_msr(msr->index, true))
> +		return kvm_set_msr_common(vcpu, msr);
> +	return 1;
> +}
> +
>   static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index c0a34186bc37..dcaa5806802e 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -156,6 +156,9 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>   void tdx_inject_nmi(struct kvm_vcpu *vcpu);
>   void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>   		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
> +bool tdx_is_emulated_msr(u32 index, bool write);
> +int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
> +int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -193,6 +196,9 @@ static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_get_exit_info(
>   	struct kvm_vcpu *vcpu, u32 *reason, u64 *info1, u64 *info2,
>   	u32 *intr_info, u32 *error_code) {}
> +static inline bool tdx_is_emulated_msr(u32 index, bool write) { return false; }
> +static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
> +static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
