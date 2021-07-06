Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6B43BD868
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhGFOko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:40:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231932AbhGFOkn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gGUA9Bem+CP6UqPyM4MAk1m839vi5F4hWGOT4QjcGOw=;
        b=Fv55SXt1JwnFSW3TbCrzIwSam3PTyX95HIx01N6DGvTDRmQmEx+PIpJuW58OkS5ySmM95f
        aiRDZ6Q7djligCKUbCw24nMeMu1lRZeYLbZM6vwY4iuArS/Pd7kOGsUzQ7bt4Ep6CkURR8
        msQCfDZPzak4kiEqKPY7Dcx3REiKakM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-silT3q_3PxWuqyM47MFGWA-1; Tue, 06 Jul 2021 10:23:08 -0400
X-MC-Unique: silT3q_3PxWuqyM47MFGWA-1
Received: by mail-ej1-f70.google.com with SMTP id hg14-20020a1709072cceb02904dcfba77bceso1487952ejc.19
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:23:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gGUA9Bem+CP6UqPyM4MAk1m839vi5F4hWGOT4QjcGOw=;
        b=RYqdTd+9uf+hV9G0gnZUD5DYWx5LqHMjcKqLt4J6pzfuImV4aoo1ORyKys0igkEIEh
         /FLI8HgANmGVge+9UyLtJuHuJyozC2/un3dIEcY0tJ/lOzUNAAOuf4Z0J0jyVMEODcV/
         2zpkP4K8QVpCzamTNi4CEYecte/Sd/jN5AdDykf9m0LasK/OitzlCvuXF38zh/XQRMBR
         ku5k9PC9nDEz8iqZ0I2Qup4YvqRQArQ1zkBlBPMJtWuLfKjjelvbh/1JlG6Vmhm/Y744
         ELGfGAtCq0L9KuuW2Jmg5Iabebx4PTjgv05G0YUl7rPLek94JIxRhqAsPJrxxTCp2obE
         HWdg==
X-Gm-Message-State: AOAM531dxWy6iHT0v2zePEoIPPUPhVzrE7ZLfFbvDbpBWTGPRerHuoW4
        xDEDZsXSj6WPkIEu++tlowLgAUGQRBOLzOs3m7qKwBo1X0Qd2xWCR/VCLaTyV3vlckOchuXIy5r
        Qa1p4bXJpi0M6
X-Received: by 2002:aa7:cd13:: with SMTP id b19mr23682247edw.45.1625581386990;
        Tue, 06 Jul 2021 07:23:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLZHCy7hLZCTczthuSgXTPHxkcjRMRN9zxpC3mlWZzL3CM3AnAT+KRqWjk2LeTRTbqi49NmA==
X-Received: by 2002:aa7:cd13:: with SMTP id b19mr23682206edw.45.1625581386778;
        Tue, 06 Jul 2021 07:23:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e16sm7404844edr.86.2021.07.06.07.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:23:06 -0700 (PDT)
Subject: Re: [RFC PATCH v2 67/69] KVM: TDX: add trace point for TDVMCALL and
 SEPT operation
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Yuan Yao <yuan.yao@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <0fc6ab7acf3ac2e764ada5abd76500ce8adb3d33.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0457d38-33ab-4402-afea-e06a91c87ea1@redhat.com>
Date:   Tue, 6 Jul 2021 16:23:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0fc6ab7acf3ac2e764ada5abd76500ce8adb3d33.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/trace.h        | 58 +++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.c      | 16 ++++++++++
>   arch/x86/kvm/vmx/tdx_arch.h |  9 ++++++
>   arch/x86/kvm/x86.c          |  2 ++
>   4 files changed, 85 insertions(+)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index c3398d0de9a7..58631124f08d 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -739,6 +739,64 @@ TRACE_EVENT(kvm_tdx_seamcall_exit,
>   		  __entry->r9, __entry->r10, __entry->r11)
>   );
>   
> +/*
> + * Tracepoint for TDVMCALL from a TDX guest
> + */
> +TRACE_EVENT(kvm_tdvmcall,
> +	TP_PROTO(struct kvm_vcpu *vcpu, __u32 exit_reason,
> +		 __u64 p1, __u64 p2, __u64 p3, __u64 p4),
> +	TP_ARGS(vcpu, exit_reason, p1, p2, p3, p4),
> +
> +	TP_STRUCT__entry(
> +		__field(	__u64,		rip		)
> +		__field(	__u32,		exit_reason	)
> +		__field(	__u64,		p1		)
> +		__field(	__u64,		p2		)
> +		__field(	__u64,		p3		)
> +		__field(	__u64,		p4		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->rip			= kvm_rip_read(vcpu);
> +		__entry->exit_reason		= exit_reason;
> +		__entry->p1			= p1;
> +		__entry->p2			= p2;
> +		__entry->p3			= p3;
> +		__entry->p4			= p4;
> +	),
> +
> +	TP_printk("rip: %llx reason: %s p1: %llx p2: %llx p3: %llx p4: %llx",
> +		  __entry->rip,
> +		  __print_symbolic(__entry->exit_reason,
> +				   TDG_VP_VMCALL_EXIT_REASONS),
> +		  __entry->p1, __entry->p2, __entry->p3, __entry->p4)
> +);
> +
> +/*
> + * Tracepoint for SEPT related SEAMCALLs.
> + */
> +TRACE_EVENT(kvm_sept_seamcall,
> +	TP_PROTO(__u64 op, __u64 gpa, __u64 hpa, int level),
> +	TP_ARGS(op, gpa, hpa, level),
> +
> +	TP_STRUCT__entry(
> +		__field(	__u64,		op	)
> +		__field(	__u64,		gpa	)
> +		__field(	__u64,		hpa	)
> +		__field(	int,		level	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->op			= op;
> +		__entry->gpa			= gpa;
> +		__entry->hpa			= hpa;
> +		__entry->level			= level;
> +	),
> +
> +	TP_printk("op: %llu gpa: 0x%llx hpa: 0x%llx level: %u",
> +		  __entry->op, __entry->gpa, __entry->hpa, __entry->level)
> +);
> +
>   /*
>    * Tracepoint for nested #vmexit because of interrupt pending
>    */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 1aed4286ce0c..63130fb5a003 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -934,6 +934,10 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   
>   	exit_reason = tdvmcall_exit_reason(vcpu);
>   
> +	trace_kvm_tdvmcall(vcpu, exit_reason,
> +			   tdvmcall_p1_read(vcpu), tdvmcall_p2_read(vcpu),
> +			   tdvmcall_p3_read(vcpu), tdvmcall_p4_read(vcpu));
> +
>   	switch (exit_reason) {
>   	case EXIT_REASON_CPUID:
>   		return tdx_emulate_cpuid(vcpu);
> @@ -1011,11 +1015,15 @@ static void tdx_sept_set_private_spte(struct kvm_vcpu *vcpu, gfn_t gfn,
>   
>   	/* Build-time faults are induced and handled via TDH_MEM_PAGE_ADD. */
>   	if (is_td_finalized(kvm_tdx)) {
> +		trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_PAGE_AUG, gpa, hpa, level);
> +
>   		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, hpa, &ex_ret);
>   		SEPT_ERR(err, &ex_ret, TDH_MEM_PAGE_AUG, vcpu->kvm);
>   		return;
>   	}
>   
> +	trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_PAGE_ADD, gpa, hpa, level);
> +
>   	source_pa = kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION;
>   
>   	err = tdh_mem_page_add(kvm_tdx->tdr.pa,  gpa, hpa, source_pa, &ex_ret);
> @@ -1039,6 +1047,8 @@ static void tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn, int level,
>   		return;
>   
>   	if (is_hkid_assigned(kvm_tdx)) {
> +		trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_PAGE_REMOVE, gpa, hpa, level);
> +
>   		err = tdh_mem_page_remove(kvm_tdx->tdr.pa, gpa, level, &ex_ret);
>   		if (SEPT_ERR(err, &ex_ret, TDH_MEM_PAGE_REMOVE, kvm))
>   			return;
> @@ -1063,6 +1073,8 @@ static int tdx_sept_link_private_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
>   	struct tdx_ex_ret ex_ret;
>   	u64 err;
>   
> +	trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_SEPT_ADD, gpa, hpa, level);
> +
>   	err = tdh_mem_spet_add(kvm_tdx->tdr.pa, gpa, level, hpa, &ex_ret);
>   	if (SEPT_ERR(err, &ex_ret, TDH_MEM_SEPT_ADD, vcpu->kvm))
>   		return -EIO;
> @@ -1077,6 +1089,8 @@ static void tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn, int level)
>   	struct tdx_ex_ret ex_ret;
>   	u64 err;
>   
> +	trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_RANGE_BLOCK, gpa, -1ull, level);
> +
>   	err = tdh_mem_range_block(kvm_tdx->tdr.pa, gpa, level, &ex_ret);
>   	SEPT_ERR(err, &ex_ret, TDH_MEM_RANGE_BLOCK, kvm);
>   }
> @@ -1088,6 +1102,8 @@ static void tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn, int level)
>   	struct tdx_ex_ret ex_ret;
>   	u64 err;
>   
> +	trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_RANGE_UNBLOCK, gpa, -1ull, level);
> +
>   	err = tdh_mem_range_unblock(kvm_tdx->tdr.pa, gpa, level, &ex_ret);
>   	SEPT_ERR(err, &ex_ret, TDH_MEM_RANGE_UNBLOCK, kvm);
>   }
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index 7258825b1e02..414b933a3b03 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -104,6 +104,15 @@
>   #define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
>   #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
>   
> +#define TDG_VP_VMCALL_EXIT_REASONS				\
> +	{ TDG_VP_VMCALL_GET_TD_VM_CALL_INFO,			\
> +			"GET_TD_VM_CALL_INFO" },		\
> +	{ TDG_VP_VMCALL_MAP_GPA,	"MAP_GPA" },		\
> +	{ TDG_VP_VMCALL_GET_QUOTE,	"GET_QUOTE" },		\
> +	{ TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT,		\
> +			"SETUP_EVENT_NOTIFY_INTERRUPT" },	\
> +	VMX_EXIT_REASONS
> +
>   /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
>   #define TDX_CLASS_SHIFT		56
>   #define TDX_FIELD_MASK		GENMASK_ULL(31, 0)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ba69abcc663a..ad619c1b2a88 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12104,6 +12104,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_tdvmcall);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_sept_seamcall);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter_failed);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
> 

Please split this in two parts for each tracepoint, and squash it in the 
earlier patches that introduced handle_tdvmcall and tdx_sept_*.

Paolo

