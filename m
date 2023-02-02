Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A6D6880CC
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 15:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjBBO5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 09:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjBBO5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 09:57:11 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DF619F0B;
        Thu,  2 Feb 2023 06:56:50 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id q6so811340ior.12;
        Thu, 02 Feb 2023 06:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQ8bDqJqafzJlWgH9YAd57sfVxi9qer6mz3hjUfSQvQ=;
        b=gZyQzQ2rvgMhVdXi6jyKe0CiVXZslMNfjsAkFkhVDMpfg/MWlnIV+k7c/XVMuyXkrv
         NOcA9U9NdVJt5F1lN+JrsuIbUkYP56ti7wDsfCjinot7gpotX4Si0NIa4uX/M/Qx0Wql
         F6TUpp1JFIGxfQosE8nrnVwI8agcf6LrLzobJ0fyc8QjcyO7UiGtKANt9ZxoMfGaDe6Q
         M6866aZBiqm3on3qwGOHrL/QIxrsoqgAMHa/zAB+6KVkJbdKNirYD15quMKZF+Ve5J71
         y09ZZTpZLNJWapZmr53YjyMpVIaHEB0NUc9+VjKxzqSsgUo3nlmQKbG7WHNNSTTsbpnq
         sz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQ8bDqJqafzJlWgH9YAd57sfVxi9qer6mz3hjUfSQvQ=;
        b=bI6lEuiSIKC8+h0dVoTwJh/KzNZdvHKyOiCMEmJA4ANUhQU1rcfo8je6jpionyW+gF
         QQmJyUuahet7S2PDGO62Eyps8M0jPKGd95myoPvXlZgBNQAYZ/lAHTlugnjkK08p+LbJ
         iAs0+Wf+X37MuUqy58PDrwWmw8pp891JcxpMKleKk0VUg+kIwXjfBrirP+KTW2LxDBNA
         rIU1bQrkEnAgHIEQC7W7xqScmlnOyipwavsvujeJiN5UtLztjr1GJoTQzxyerz8dPZuc
         tlCqI6ginrMdxgBU1UML2c0BlWfB8MdOfNTAUta+1Yc62duDgIdfzdHAwm8R1Xp1Apx7
         8vaQ==
X-Gm-Message-State: AO0yUKWi02fs5+gAq5RHa0VUoQvcftNh376zLICIR1Mr8luq7u8gDzVk
        wEUuVeSBZAdcMun7H7ARmto=
X-Google-Smtp-Source: AK7set/b37fgV/Epoq5eUQj89WWweWKHmOn2ZVHkT6PG1EQiINP0FUEN6FJYntrREAovq7ywyt2A8A==
X-Received: by 2002:a5e:de07:0:b0:716:8f6a:f480 with SMTP id e7-20020a5ede07000000b007168f6af480mr3854901iok.0.1675349809177;
        Thu, 02 Feb 2023 06:56:49 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id h11-20020a02b60b000000b0039e90ba37e3sm7709820jam.43.2023.02.02.06.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 06:56:48 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:56:43 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 2/6] KVM: x86: Move *_in_guest power management
 flags to vCPU scope
Message-ID: <20230202165643.00003a3b@gmail.com>
In-Reply-To: <20230121020738.2973-3-kechenl@nvidia.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
        <20230121020738.2973-3-kechenl@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 21 Jan 2023 02:07:34 +0000
Kechen Lu <kechenl@nvidia.com> wrote:

> Make the runtime disabled mwait/hlt/pause/cstate exits flags vCPU scope
> to allow finer-grained, per-vCPU control.  The VM-scoped control is only
> allowed before vCPUs are created, thus preserving the existing behavior
> is a simple matter of snapshotting the flags at vCPU creation.
> 
> Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 +++++
>  arch/x86/kvm/cpuid.c            |  4 ++--
>  arch/x86/kvm/lapic.c            |  7 +++----
>  arch/x86/kvm/svm/nested.c       |  4 ++--
>  arch/x86/kvm/svm/svm.c          | 12 ++++++------
>  arch/x86/kvm/vmx/vmx.c          | 16 ++++++++--------
>  arch/x86/kvm/x86.c              |  6 +++++-
>  arch/x86/kvm/x86.h              | 16 ++++++++--------
>  8 files changed, 39 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6aaae18f1854..41b998234a04 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1009,6 +1009,11 @@ struct kvm_vcpu_arch {
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	hpa_t hv_root_tdp;
>  #endif
> +
> +	bool mwait_in_guest;
> +	bool hlt_in_guest;
> +	bool pause_in_guest;
> +	bool cstate_in_guest;

Better add some comments here. When xxx_in_guest stays together with
XXX_DISABLE_EXIT_XXX, it can be quite confusing. Or maybe align the naming
like bool disable_exit_mwait <-> XXX_DISABLE_EXIT_XXX.

>  };
>  
>  struct kvm_lpage_info {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 596061c1610e..20e427dc608c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -283,8 +283,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
>  	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
> -	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> -		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> +	if (kvm_hlt_in_guest(vcpu) &&
> +	    best && (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
>  		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
>  
>  	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 4efdb4a4d72c..f0f49d0c6e69 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -151,14 +151,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> -		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
> +		(kvm_mwait_in_guest(vcpu) || kvm_hlt_in_guest(vcpu));
>  }
>  
>  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_x86_ops.set_hv_timer
> -	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
> -		    kvm_can_post_timer_interrupt(vcpu));
> +	return kvm_x86_ops.set_hv_timer &&
> +		!(kvm_mwait_in_guest(vcpu) || kvm_can_post_timer_interrupt(vcpu));
>  }
>  
>  static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index add65dd59756..ed26b6de3007 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -721,7 +721,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  
>  	pause_count12 = svm->pause_filter_enabled ? svm->nested.ctl.pause_filter_count : 0;
>  	pause_thresh12 = svm->pause_threshold_enabled ? svm->nested.ctl.pause_filter_thresh : 0;
> -	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
> +	if (kvm_pause_in_guest(&svm->vcpu)) {
>  		/* use guest values since host doesn't intercept PAUSE */
>  		vmcb02->control.pause_filter_count = pause_count12;
>  		vmcb02->control.pause_filter_thresh = pause_thresh12;
> @@ -1012,7 +1012,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
>  	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
>  
> -	if (!kvm_pause_in_guest(vcpu->kvm)) {
> +	if (!kvm_pause_in_guest(vcpu)) {
>  		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
>  		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9a194aa1a75a..dc7176605e01 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1014,7 +1014,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
>  	struct vmcb_control_area *control = &svm->vmcb->control;
>  	int old = control->pause_filter_count;
>  
> -	if (kvm_pause_in_guest(vcpu->kvm))
> +	if (kvm_pause_in_guest(vcpu))
>  		return;
>  
>  	control->pause_filter_count = __grow_ple_window(old,
> @@ -1035,7 +1035,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  	struct vmcb_control_area *control = &svm->vmcb->control;
>  	int old = control->pause_filter_count;
>  
> -	if (kvm_pause_in_guest(vcpu->kvm))
> +	if (kvm_pause_in_guest(vcpu))
>  		return;
>  
>  	control->pause_filter_count =
> @@ -1229,12 +1229,12 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	svm_set_intercept(svm, INTERCEPT_RDPRU);
>  	svm_set_intercept(svm, INTERCEPT_RSM);
>  
> -	if (!kvm_mwait_in_guest(vcpu->kvm)) {
> +	if (!kvm_mwait_in_guest(vcpu)) {
>  		svm_set_intercept(svm, INTERCEPT_MONITOR);
>  		svm_set_intercept(svm, INTERCEPT_MWAIT);
>  	}
>  
> -	if (!kvm_hlt_in_guest(vcpu->kvm))
> +	if (!kvm_hlt_in_guest(vcpu))
>  		svm_set_intercept(svm, INTERCEPT_HLT);
>  
>  	control->iopm_base_pa = __sme_set(iopm_base);
> @@ -1278,7 +1278,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	svm->nested.vmcb12_gpa = INVALID_GPA;
>  	svm->nested.last_vmcb12_gpa = INVALID_GPA;
>  
> -	if (!kvm_pause_in_guest(vcpu->kvm)) {
> +	if (!kvm_pause_in_guest(vcpu)) {
>  		control->pause_filter_count = pause_filter_count;
>  		if (pause_filter_thresh)
>  			control->pause_filter_thresh = pause_filter_thresh;
> @@ -4362,7 +4362,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  
>  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  {
> -	if (!kvm_pause_in_guest(vcpu->kvm))
> +	if (!kvm_pause_in_guest(vcpu))
>  		shrink_ple_window(vcpu);
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fc9008dbed33..019a20029878 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1689,7 +1689,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
>  	 * then the instruction is already executing and RIP has already been
>  	 * advanced.
>  	 */
> -	if (kvm_hlt_in_guest(vcpu->kvm) &&
> +	if (kvm_hlt_in_guest(vcpu) &&
>  			vmcs_read32(GUEST_ACTIVITY_STATE) == GUEST_ACTIVITY_HLT)
>  		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
>  }
> @@ -4412,10 +4412,10 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  		exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
>  				  CPU_BASED_CR3_STORE_EXITING |
>  				  CPU_BASED_INVLPG_EXITING);
> -	if (kvm_mwait_in_guest(vmx->vcpu.kvm))
> +	if (kvm_mwait_in_guest(&vmx->vcpu))
>  		exec_control &= ~(CPU_BASED_MWAIT_EXITING |
>  				CPU_BASED_MONITOR_EXITING);
> -	if (kvm_hlt_in_guest(vmx->vcpu.kvm))
> +	if (kvm_hlt_in_guest(&vmx->vcpu))
>  		exec_control &= ~CPU_BASED_HLT_EXITING;
>  	return exec_control;
>  }
> @@ -4515,7 +4515,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  	}
>  	if (!enable_unrestricted_guest)
>  		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
> -	if (kvm_pause_in_guest(vmx->vcpu.kvm))
> +	if (kvm_pause_in_guest(&vmx->vcpu))
>  		exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
>  	if (!kvm_vcpu_apicv_active(vcpu))
>  		exec_control &= ~(SECONDARY_EXEC_APIC_REGISTER_VIRT |
> @@ -4661,7 +4661,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  		vmcs_write16(LAST_PID_POINTER_INDEX, kvm->arch.max_vcpu_ids - 1);
>  	}
>  
> -	if (!kvm_pause_in_guest(kvm)) {
> +	if (!kvm_pause_in_guest(&vmx->vcpu)) {
>  		vmcs_write32(PLE_GAP, ple_gap);
>  		vmx->ple_window = ple_window;
>  		vmx->ple_window_dirty = true;
> @@ -5833,7 +5833,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>   */
>  static int handle_pause(struct kvm_vcpu *vcpu)
>  {
> -	if (!kvm_pause_in_guest(vcpu->kvm))
> +	if (!kvm_pause_in_guest(vcpu))
>  		grow_ple_window(vcpu);
>  
>  	/*
> @@ -7379,7 +7379,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
>  	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
>  	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> -	if (kvm_cstate_in_guest(vcpu->kvm)) {
> +	if (kvm_cstate_in_guest(vcpu)) {
>  		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
>  		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
>  		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> @@ -7935,7 +7935,7 @@ static void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
>  
>  static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  {
> -	if (!kvm_pause_in_guest(vcpu->kvm))
> +	if (!kvm_pause_in_guest(vcpu))
>  		shrink_ple_window(vcpu);
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c8ae9c4f9f08..9a77b55142c6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11634,6 +11634,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	vcpu->arch.hv_root_tdp = INVALID_PAGE;
>  #endif
> +	vcpu->arch.mwait_in_guest = vcpu->kvm->arch.mwait_in_guest;
> +	vcpu->arch.hlt_in_guest = vcpu->kvm->arch.hlt_in_guest;
> +	vcpu->arch.pause_in_guest = vcpu->kvm->arch.pause_in_guest;
> +	vcpu->arch.cstate_in_guest = vcpu->kvm->arch.cstate_in_guest;
>  
>  	r = static_call(kvm_x86_vcpu_create)(vcpu);
>  	if (r)
> @@ -12885,7 +12889,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  		     kvm_is_exception_pending(vcpu)))
>  		return false;
>  
> -	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
> +	if (kvm_hlt_in_guest(vcpu) && !kvm_can_deliver_async_pf(vcpu))
>  		return false;
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9de72586f406..b8e49a9d353d 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -351,24 +351,24 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
>  	    __rem;						\
>  	 })
>  
> -static inline bool kvm_mwait_in_guest(struct kvm *kvm)
> +static inline bool kvm_mwait_in_guest(struct kvm_vcpu *vcpu)
>  {
> -	return kvm->arch.mwait_in_guest;
> +	return vcpu->arch.mwait_in_guest;
>  }
>  
> -static inline bool kvm_hlt_in_guest(struct kvm *kvm)
> +static inline bool kvm_hlt_in_guest(struct kvm_vcpu *vcpu)
>  {
> -	return kvm->arch.hlt_in_guest;
> +	return vcpu->arch.hlt_in_guest;
>  }
>  
> -static inline bool kvm_pause_in_guest(struct kvm *kvm)
> +static inline bool kvm_pause_in_guest(struct kvm_vcpu *vcpu)
>  {
> -	return kvm->arch.pause_in_guest;
> +	return vcpu->arch.pause_in_guest;
>  }
>  
> -static inline bool kvm_cstate_in_guest(struct kvm *kvm)
> +static inline bool kvm_cstate_in_guest(struct kvm_vcpu *vcpu)
>  {
> -	return kvm->arch.cstate_in_guest;
> +	return vcpu->arch.cstate_in_guest;
>  }
>  
>  static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)

