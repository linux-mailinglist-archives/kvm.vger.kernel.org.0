Return-Path: <kvm+bounces-30143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34EF09B72C2
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 04:14:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86017B21BBB
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 03:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B56E12FF9C;
	Thu, 31 Oct 2024 03:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fTvOylPA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAE034CDE;
	Thu, 31 Oct 2024 03:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344461; cv=none; b=QaSDBPuDjIEvoL7uupYx7ChyU3I18qjlmNsUf+cj+3IecxgFkKgzD0fTQXiw6cmo8Dmw31aapRRCMHNNngUV1uF5Ge5ua5WaLdGA45PO8Uz3fltciHpk3ah+991IeC+QTdr+9kJZbA/ks87WPo+RZhc/2IrTz+P0Tm+JPz0s8cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344461; c=relaxed/simple;
	bh=oHmtr5scO0FwSLZgcuTA2U+qmznB3p4d4+Sjpor4oig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f0awhmCAEJlAhg/RQ833/qQuQ076SL4dsmHX/Vjhk/WHiGQIeLQ+6iviJt3ZHbStU445hhip5UhxmqwQ+pSdhasLwec4QMcuhLHzpy/R5ZKOFmsfx0yMX3S2S8s+a/jHfTjhfifeGCTugGO83/fU+ijzLmK+weU7XTU/ucCVQcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fTvOylPA; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730344460; x=1761880460;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oHmtr5scO0FwSLZgcuTA2U+qmznB3p4d4+Sjpor4oig=;
  b=fTvOylPAG9tYEJBlXFjUISIi7xyZKVPFpVDwAv9G2x8WMlcZLqD9wNLX
   8DpLl+Eijn8tuOFeCBnmtN0cWBwkmfb8Fnohl7i5kbDp395rio3+92oZq
   3ru4iV77KS5hDqxPcjK3gf37LjNcoENW0jdgu2PBRpGq3SyO+er8bB8n0
   /mMz8KRbkWF8q2L+SCyEFCRpyxM/sqXv2ldt2fQE1fOpRBeqqWsA04aex
   aCdWyjIZUKDIetwKw8fH2P079+7WoYwyjGkSlZ9CJuKHI524qa4tHj80L
   djNo6agJMuY2yXn3l1GKzhxzaNVPgSkvn366x8XBSwAl6s8Hmm2XNgpDK
   Q==;
X-CSE-ConnectionGUID: whY0OwYbRD+Or/czH+jspg==
X-CSE-MsgGUID: aPnkxZ4JRmCPGouaEgn0MQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47530688"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47530688"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 20:14:19 -0700
X-CSE-ConnectionGUID: 2ONhQCDJTeeaI7n/nPBOvg==
X-CSE-MsgGUID: FAA3zc5uSlOkGDbwR0Ji1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="82931206"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 20:14:13 -0700
Message-ID: <86578354-9241-4702-86bf-f0fff1539945@linux.intel.com>
Date: Thu, 31 Oct 2024 11:14:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 37/58] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL
 at VM boundary
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-38-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240801045907.4010984-38-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>
> In PMU passthrough mode, use global_ctrl field in struct kvm_pmu as the
> cached value. This is convenient for KVM to set and get the value from the
> host side. In addition, load and save the value across VM enter/exit
> boundary in the following way:
>
>  - At VM exit, if processor supports
>    GUEST_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, read guest
>    IA32_PERF_GLOBAL_CTRL GUEST_IA32_PERF_GLOBAL_CTRL VMCS field, else read
>    it from VM-exit MSR-stroe array in VMCS. The value is then assigned to
>    global_ctrl.
>
>  - At VM Entry, if processor supports
>    GUEST_VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, read guest
>    IA32_PERF_GLOBAL_CTRL from GUEST_IA32_PERF_GLOBAL_CTRL VMCS field, else
>    read it from VM-entry MSR-load array in VMCS. The value is then
>    assigned to global ctrl.
>
> Implement the above logic into two helper functions and invoke them around
> VM Enter/exit boundary.
>
> Co-developed-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/vmx/vmx.c          | 49 ++++++++++++++++++++++++++++++++-
>  2 files changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 93c17da8271d..7bf901a53543 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -601,6 +601,8 @@ struct kvm_pmu {
>  	u8 event_count;
>  
>  	bool passthrough;
> +	int global_ctrl_slot_in_autoload;
> +	int global_ctrl_slot_in_autostore;
>  };
>  
>  struct kvm_pmu_ops;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 41102658ed21..b126de6569c8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4430,6 +4430,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
>  			}
>  			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
>  			m->val[i].value = 0;
> +			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autoload = i;
>  		}
>  		/*
>  		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
> @@ -4457,6 +4458,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
>  				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
>  			}
>  			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
> +			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autostore = i;
>  		}
>  	} else {
>  		if (!(vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)) {
> @@ -4467,6 +4469,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
>  				m->val[i] = m->val[m->nr];
>  				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
>  			}
> +			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autoload = -ENOENT;
>  		}
>  		if (!(vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
>  			m = &vmx->msr_autoload.host;
> @@ -4485,6 +4488,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
>  				m->val[i] = m->val[m->nr];
>  				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
>  			}
> +			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autostore = -ENOENT;
>  		}
>  	}
>  
> @@ -7272,7 +7276,7 @@ void vmx_cancel_injection(struct kvm_vcpu *vcpu)
>  	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
>  }
>  
> -static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> +static void __atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>  {
>  	int i, nr_msrs;
>  	struct perf_guest_switch_msr *msrs;
> @@ -7295,6 +7299,46 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>  					msrs[i].host, false);
>  }
>  
> +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
> +	int i;
> +
> +	if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL) {
> +		pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
> +	} else {
> +		i = pmu->global_ctrl_slot_in_autostore;
> +		pmu->global_ctrl = vmx->msr_autostore.guest.val[i].value;
> +	}

When GLOBAL_CTRL MSR is in interception mode, if guest global_ctrl contains
some invalid bit, there may be issue here. The saved guest_ctrl here would
be restored in vm-entry, and it would contains invalid bit as well.

It looks we need to only save valid bits of guest global_ctrl here.


> +}
> +
> +static void load_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
> +	u64 global_ctrl = pmu->global_ctrl;
> +	int i;
> +
> +	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
> +	} else {
> +		i = pmu->global_ctrl_slot_in_autoload;
> +		vmx->msr_autoload.guest.val[i].value = global_ctrl;
> +	}
> +}
> +
> +static void __atomic_switch_perf_msrs_in_passthrough_pmu(struct vcpu_vmx *vmx)
> +{
> +	load_perf_global_ctrl_in_passthrough_pmu(vmx);
> +}
> +
> +static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> +{
> +	if (is_passthrough_pmu_enabled(&vmx->vcpu))
> +		__atomic_switch_perf_msrs_in_passthrough_pmu(vmx);
> +	else
> +		__atomic_switch_perf_msrs(vmx);
> +}
> +
>  static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7405,6 +7449,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  	vcpu->arch.cr2 = native_read_cr2();
>  	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>  
> +	if (is_passthrough_pmu_enabled(vcpu))
> +		save_perf_global_ctrl_in_passthrough_pmu(vmx);
> +
>  	vmx->idt_vectoring_info = 0;
>  
>  	vmx_enable_fb_clear(vmx);

