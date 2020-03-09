Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FC017E48C
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 17:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgCIQS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 12:18:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36694 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727421AbgCIQSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 12:18:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583770704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EZXRmsIY6zy5lcwKEjGL+Mve8eK4dIX3HbT9ljSN3RI=;
        b=dNm/QBUxx/dmflgeNhU+i+rx0FDeWQGa2QN8SrHedmOW1NRsbH+04m5kImuCF9NI/s1GgA
        LNdTP1MIOvbDAVd8iT1TtNcvFFIrkapzs3pLy8rXSoFsw7bI6l4LP+PaaDZyjj+TtU7LKH
        5FgXWrUgO+AOBwJYMpbcRg4gy2sccJU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-IQTiLceJPo-7R3gmhPQepw-1; Mon, 09 Mar 2020 12:18:20 -0400
X-MC-Unique: IQTiLceJPo-7R3gmhPQepw-1
Received: by mail-wm1-f71.google.com with SMTP id 20so42346wmk.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 09:18:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EZXRmsIY6zy5lcwKEjGL+Mve8eK4dIX3HbT9ljSN3RI=;
        b=T+MDkgoYd0ONTgwdVBC/aA6kC1yAE0ZJANmYF21q2fznSqrhRW+A5GHsTCGrCP+yNM
         8AuHmHSz2KWQKo5DFSwhkWVamWI77714To5YMnRG15IAP7wau8TZDGEI/uNxpMd4aVFg
         5BO/34rKOTfK2f1c2MQAKpGCkSJrXEIiwsn5aTC8MDYRHPo7sRMF6W1mFQl4a/7+gWYX
         SGV4rsRXAWKm9HMybewYMqyLy5uM+9om4rqAav+JRdWQtkk/n15U3MMxgegGK8cu06C0
         VQh0N+RkgLYejbQ/bErazabrnDd1QLgGgCEOvR7NGZqgvoicGMAlhqAFM5O/3ZTsx8UN
         s8mA==
X-Gm-Message-State: ANhLgQ3JCMeu8zdykC1eFzm/2z9p3FTI++lVXRKH7hCcEou6JKgrZq+O
        c4zjRfE2YmRBb8hb1yu/Ey1L4GT6vrQhmO0DSmxJeMRCbus+zpVo24/4YTXBkp17fKRUSuK83sZ
        3DOToEUIdzflk
X-Received: by 2002:adf:82ee:: with SMTP id 101mr21513311wrc.7.1583770699311;
        Mon, 09 Mar 2020 09:18:19 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vusbRqs5D8eRBPXnPHiktvp0ON5M+BqnhvSi3T4SDVDwzdIoRSwyStTGaRG1JXsCiyDdfKQPw==
X-Received: by 2002:adf:82ee:: with SMTP id 101mr21513284wrc.7.1583770698927;
        Mon, 09 Mar 2020 09:18:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f8sm70097wmf.20.2020.03.09.09.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 09:18:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     Jon Doron <arilou@gmail.com>
Subject: Re: [PATCH v3 3/5] x86/kvm/hyper-v: Add support for synthetic debugger capability
In-Reply-To: <20200306163909.1020369-4-arilou@gmail.com>
References: <20200306163909.1020369-1-arilou@gmail.com> <20200306163909.1020369-4-arilou@gmail.com>
Date:   Mon, 09 Mar 2020 17:18:17 +0100
Message-ID: <87h7yxcxiu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> Add support for Hyper-V synthetic debugger (syndbg) interface.
> The syndbg interface is using MSRs to emulate a way to send/recv packets
> data.
>
> The debug transport dll (kdvm/kdnet) will identify if Hyper-V is enabled
> and if it supports the synthetic debugger interface it will attempt to
> use it, instead of trying to initialize a network adapter.
>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  13 ++++
>  arch/x86/kvm/hyperv.c           | 134 +++++++++++++++++++++++++++++++-
>  arch/x86/kvm/hyperv.h           |   5 ++
>  arch/x86/kvm/trace.h            |  48 ++++++++++++
>  arch/x86/kvm/x86.c              |   9 +++
>  include/uapi/linux/kvm.h        |  10 +++
>  6 files changed, 218 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 98959e8cd448..f8e58e8866bb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -854,6 +854,18 @@ struct kvm_apic_map {
>  	struct kvm_lapic *phys_map[];
>  };
>  
> +/* Hyper-V synthetic debugger (SynDbg)*/
> +struct kvm_hv_syndbg {
> +	struct {
> +		u64 control;
> +		u64 status;
> +		u64 send_page;
> +		u64 recv_page;
> +		u64 pending_page;
> +	} control;
> +	u64 options;
> +};
> +
>  /* Hyper-V emulation context */
>  struct kvm_hv {
>  	struct mutex hv_lock;
> @@ -877,6 +889,7 @@ struct kvm_hv {
>  	atomic_t num_mismatched_vp_indexes;
>  
>  	struct hv_partition_assist_pg *hv_pa_pg;
> +	struct kvm_hv_syndbg hv_syndbg;
>  };
>  
>  enum kvm_irqchip_mode {
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a86fda7a1d03..554e78f961bc 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -266,6 +266,106 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
>  	return ret;
>  }
>  
> +static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_hv *hv = &kvm->arch.hyperv;
> +
> +	if (vcpu->run->hyperv.u.syndbg.msr == HV_X64_MSR_SYNDBG_CONTROL)
> +		hv->hv_syndbg.control.status =
> +			vcpu->run->hyperv.u.syndbg.status;
> +	return 1;
> +}
> +
> +static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
> +{
> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
> +
> +	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNDBG;
> +	hv_vcpu->exit.u.syndbg.msr = msr;
> +	hv_vcpu->exit.u.syndbg.control = syndbg->control.control;
> +	hv_vcpu->exit.u.syndbg.send_page = syndbg->control.send_page;
> +	hv_vcpu->exit.u.syndbg.recv_page = syndbg->control.recv_page;
> +	hv_vcpu->exit.u.syndbg.pending_page = syndbg->control.pending_page;
> +	vcpu->arch.complete_userspace_io =
> +			kvm_hv_syndbg_complete_userspace;
> +
> +	kvm_make_request(KVM_REQ_HV_EXIT, vcpu);
> +}
> +
> +static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> +{
> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +	int ret;
> +
> +	trace_kvm_hv_syndbg_set_msr(vcpu->vcpu_id,
> +				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr, data);
> +	ret = 0;
> +	switch (msr) {
> +	case HV_X64_MSR_SYNDBG_CONTROL:
> +		syndbg->control.control = data;
> +		syndbg_exit(vcpu, msr);
> +		break;
> +	case HV_X64_MSR_SYNDBG_STATUS:
> +		syndbg->control.status = data;
> +		break;
> +	case HV_X64_MSR_SYNDBG_SEND_BUFFER:
> +		syndbg->control.send_page = data;
> +		break;
> +	case HV_X64_MSR_SYNDBG_RECV_BUFFER:
> +		syndbg->control.recv_page = data;
> +		break;
> +	case HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +		syndbg->control.pending_page = data;
> +		syndbg_exit(vcpu, msr);
> +		break;
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +		syndbg->options = data;
> +		break;
> +	default:
> +		ret = 1;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> +{
> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +	int ret;
> +
> +	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id,
> +				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr);
> +	ret = 0;
> +	switch (msr) {
> +	case HV_X64_MSR_SYNDBG_CONTROL:
> +		*pdata = syndbg->control.control;
> +		break;
> +	case HV_X64_MSR_SYNDBG_STATUS:
> +		*pdata = syndbg->control.status;
> +		break;
> +	case HV_X64_MSR_SYNDBG_SEND_BUFFER:
> +		*pdata = syndbg->control.send_page;
> +		break;
> +	case HV_X64_MSR_SYNDBG_RECV_BUFFER:
> +		*pdata = syndbg->control.recv_page;
> +		break;
> +	case HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +		*pdata = syndbg->control.pending_page;
> +		break;
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +		*pdata = syndbg->options;
> +		break;
> +	default:
> +		ret = 1;
> +		break;
> +	}
> +

Nitpick: I would've moved trace_kvm_hv_syndbg_get_msr() here so we can
actually see the value (*pdata) which was read. kvm_hv_syndbg_get_msr()
tracepoint will now look exactly as kvm_hv_syndbg_set_msr().


> +	return ret;
> +}
> +
>  static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
>  			 bool host)
>  {
> @@ -800,6 +900,8 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
>  	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		r = true;
>  		break;
>  	}
> @@ -1061,6 +1163,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  		if (!host)
>  			return 1;
>  		break;
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +		return syndbg_set_msr(vcpu, msr, data);
>  	default:
>  		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
>  			    msr, data);
> @@ -1227,6 +1332,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
>  		data = hv->hv_tsc_emulation_status;
>  		break;
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +		return syndbg_get_msr(vcpu, msr, pdata);
>  	default:
>  		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
>  		return 1;
> @@ -1797,6 +1905,9 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
>  		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
>  		{ .function = HYPERV_CPUID_NESTED_FEATURES },
> +		{ .function = HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS },
> +		{ .function = HYPERV_CPUID_SYNDBG_INTERFACE },
> +		{ .function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	},
>  	};
>  	int i, nent = ARRAY_SIZE(cpuid_entries);
>  
> @@ -1821,7 +1932,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		case HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS:
>  			memcpy(signature, "Linux KVM Hv", 12);
>  
> -			ent->eax = HYPERV_CPUID_NESTED_FEATURES;
> +			ent->eax = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES;
>  			ent->ebx = signature[0];
>  			ent->ecx = signature[1];
>  			ent->edx = signature[2];
> @@ -1856,9 +1967,12 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  
>  			ent->ebx |= HV_X64_POST_MESSAGES;
>  			ent->ebx |= HV_X64_SIGNAL_EVENTS;
> +			ent->ebx |= HV_X64_DEBUGGING;
>  
>  			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
>  			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
> +			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
> +			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
>  
>  			/*
>  			 * Direct Synthetic timers only make sense with in-kernel
> @@ -1903,6 +2017,24 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  
>  			break;
>  
> +		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
> +			memcpy(signature, "Linux KVM Hv", 12);
> +
> +			ent->eax = 0;
> +			ent->ebx = signature[0];
> +			ent->ecx = signature[1];
> +			ent->edx = signature[2];
> +			break;
> +
> +		case HYPERV_CPUID_SYNDBG_INTERFACE:
> +			memcpy(signature, "VS#1\0\0\0\0\0\0\0\0", 12);
> +			ent->eax = signature[0];
> +			break;
> +
> +		case HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES:
> +			ent->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
> +			break;
> +
>  		default:
>  			break;
>  		}
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 757cb578101c..6a86151fac53 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -46,6 +46,11 @@ static inline struct kvm_vcpu *synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
>  	return hv_vcpu_to_vcpu(container_of(synic, struct kvm_vcpu_hv, synic));
>  }
>  
> +static inline struct kvm_hv_syndbg *vcpu_to_hv_syndbg(struct kvm_vcpu *vcpu)
> +{
> +	return &vcpu->kvm->arch.hyperv.hv_syndbg;
> +}
> +
>  int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host);
>  int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host);
>  
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index f194dd058470..97f4edea0e71 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1515,6 +1515,54 @@ TRACE_EVENT(kvm_nested_vmenter_failed,
>  		__print_symbolic(__entry->err, VMX_VMENTER_INSTRUCTION_ERRORS))
>  );
>  
> +/*
> + * Tracepoint for syndbg_set_msr.
> + */
> +TRACE_EVENT(kvm_hv_syndbg_set_msr,
> +	TP_PROTO(int vcpu_id, u32 vp_index, u32 msr, u64 data),
> +	TP_ARGS(vcpu_id, vp_index, msr, data),
> +
> +	TP_STRUCT__entry(
> +		__field(int, vcpu_id)
> +		__field(u32, vp_index)
> +		__field(u32, msr)
> +		__field(u64, data)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu_id = vcpu_id;
> +		__entry->vp_index = vp_index;
> +		__entry->msr = msr;
> +		__entry->data = data;
> +	),
> +
> +	TP_printk("vcpu_id %d vp_index %u msr 0x%x data 0x%llx",
> +		  __entry->vcpu_id, __entry->vp_index, __entry->msr,
> +		  __entry->data)
> +);
> +
> +/*
> + * Tracepoint for syndbg_get_msr.
> + */
> +TRACE_EVENT(kvm_hv_syndbg_get_msr,
> +	TP_PROTO(int vcpu_id, u32 vp_index, u32 msr),
> +	TP_ARGS(vcpu_id, vp_index, msr),
> +
> +	TP_STRUCT__entry(
> +		__field(int, vcpu_id)
> +		__field(u32, vp_index)
> +		__field(u32, msr)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu_id = vcpu_id;
> +		__entry->vp_index = vp_index;
> +		__entry->msr = msr;
> +	),
> +
> +	TP_printk("vcpu_id %d vp_index %u msr 0x%x",
> +		  __entry->vcpu_id, __entry->vp_index, __entry->msr)
> +);
>  #endif /* _TRACE_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5de200663f51..619c24bac79e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1214,6 +1214,10 @@ static const u32 emulated_msrs_all[] = {
>  	HV_X64_MSR_VP_ASSIST_PAGE,
>  	HV_X64_MSR_REENLIGHTENMENT_CONTROL, HV_X64_MSR_TSC_EMULATION_CONTROL,
>  	HV_X64_MSR_TSC_EMULATION_STATUS,
> +	HV_X64_MSR_SYNDBG_OPTIONS,
> +	HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
> +	HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
> +	HV_X64_MSR_SYNDBG_PENDING_BUFFER,
>  
>  	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
>  	MSR_KVM_PV_EOI_EN,
> @@ -2906,6 +2910,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 */
>  		break;
>  	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>  	case HV_X64_MSR_CRASH_CTL:
>  	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
> @@ -3151,6 +3157,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		msr_info->data = 0x20000000;
>  		break;
>  	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>  	case HV_X64_MSR_CRASH_CTL:
>  	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
> @@ -3323,6 +3331,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_HYPERV_TLBFLUSH:
>  	case KVM_CAP_HYPERV_SEND_IPI:
>  	case KVM_CAP_HYPERV_CPUID:
> +	case KVM_CAP_HYPERV_DEBUGGING:
>  	case KVM_CAP_PCI_SEGMENT:
>  	case KVM_CAP_DEBUGREGS:
>  	case KVM_CAP_X86_ROBUST_SINGLESTEP:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 24b7c48ccc6f..97a208728b3d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -188,6 +188,7 @@ struct kvm_s390_cmma_log {
>  struct kvm_hyperv_exit {
>  #define KVM_EXIT_HYPERV_SYNIC          1
>  #define KVM_EXIT_HYPERV_HCALL          2
> +#define KVM_EXIT_HYPERV_SYNDBG         3
>  	__u32 type;
>  	union {
>  		struct {
> @@ -202,6 +203,14 @@ struct kvm_hyperv_exit {
>  			__u64 result;
>  			__u64 params[2];
>  		} hcall;
> +		struct {
> +			__u32 msr;
> +			__u64 control;
> +			__u64 status;
> +			__u64 send_page;
> +			__u64 recv_page;
> +			__u64 pending_page;
> +		} syndbg;
>  	} u;
>  };
>  
> @@ -1011,6 +1020,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_NISV_TO_USER 177
>  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
>  #define KVM_CAP_S390_VCPU_RESETS 179
> +#define KVM_CAP_HYPERV_DEBUGGING 180
>  
>  #ifdef KVM_CAP_IRQ_ROUTING

-- 
Vitaly

