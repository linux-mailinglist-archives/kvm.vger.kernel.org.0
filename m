Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA9B35E0AA
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 15:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346213AbhDMNxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 09:53:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346205AbhDMNxb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 09:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618321986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e9WkIOMcUwFDUyMACLWoMxGh3LJBvXzjIkBwNop4nTo=;
        b=IoYEkMgyCAFePLizOPD5RdfhMxjh5hRMhJUXHUBh52vktI/m3OVff5fKXzgrlquD7Q4oyt
        D3frxX02J1DJYj+AtAwoa92Tz7716fY7veCQ1rGOX72ecV+f256L0HnXk2dYDset82YiM3
        8I8gwpL2d3MaklxclR9YS21cDabOd1M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-NIEGRDQXOvq4Xbyf_at74Q-1; Tue, 13 Apr 2021 09:53:04 -0400
X-MC-Unique: NIEGRDQXOvq4Xbyf_at74Q-1
Received: by mail-ed1-f69.google.com with SMTP id co5-20020a0564020c05b02903825bcdad12so1304068edb.0
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 06:53:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=e9WkIOMcUwFDUyMACLWoMxGh3LJBvXzjIkBwNop4nTo=;
        b=cBqgsqFb8jQtMzvs/KxG/aVC0oupl22ZUs8tLwjfk++AcNYiCWlK0jKAHtuwN4C+x8
         jsvaSn4zHj8Wz2rQYiVFl/vpp3oFZsjmdkK+/fZqYS/9HCwBqXVr1wcyujCsLQwL5QNA
         GHWa1EvVka5J4Jk8IPngZusr3Noelx8fwfK3YcflXjTPtKn8YI/m+G94RCJ3b8ZBCBSG
         KcbnWR5rnVGiPDtND+KjT/bxwIMm5oLN96lR2YZ3rGMcLc7q1EZVWcVnTexifU4t1yHb
         iF1tKQcIBI9aJSxBCZjyJSjlTybVjeIOoN+6ndvQ1Bqtmx9rzl7xGnRxUjxGa0n7bk8o
         AkMw==
X-Gm-Message-State: AOAM533ST+2I2ymulgoETsHCDjQgr0wPq9XFi3fyGADKMko4VBRdHLtT
        oDIDIfpud07ISt7BcbOnkeJMmlxcdrRnVpwMOm9UTvZQGoQJqq28zpJ2Khw4c6KZICpJOqlNUbs
        Um+RWVTZKOd/N
X-Received: by 2002:a05:6402:447:: with SMTP id p7mr35041155edw.89.1618321983123;
        Tue, 13 Apr 2021 06:53:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyHXOomQgkxeyE0F364NR5DIH4O6xkBxKCUnul0gTroAkuVjAwAjSvP8dggQhbTetDhwMHgQ==
X-Received: by 2002:a05:6402:447:: with SMTP id p7mr35041131edw.89.1618321982854;
        Tue, 13 Apr 2021 06:53:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v8sm9269491edc.30.2021.04.13.06.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:53:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 2/4] KVM: hyper-v: Collect hypercall params into struct
In-Reply-To: <2ca35d1660401780a530e4dbdf3dcd49b8390e61.1618244920.git.sidcha@amazon.de>
References: <cover.1618244920.git.sidcha@amazon.de>
 <2ca35d1660401780a530e4dbdf3dcd49b8390e61.1618244920.git.sidcha@amazon.de>
Date:   Tue, 13 Apr 2021 15:53:01 +0200
Message-ID: <87v98q5m0y.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Siddharth Chandrasekaran <sidcha@amazon.de> writes:

> As of now there are 7 parameters (and flags) that are used in various
> hyper-v hypercall handlers. There are 6 more input/output parameters
> passed from XMM registers which are to be added in an upcoming patch.
>
> To make passing arguments to the handlers more readable, capture all
> these parameters into a single structure.
>
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>  arch/x86/kvm/hyperv.c | 147 +++++++++++++++++++++++-------------------
>  1 file changed, 79 insertions(+), 68 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index f98370a39936..8f6babd1ea0d 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1623,7 +1623,18 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
>  	return vcpu_bitmap;
>  }
>  
> -static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
> +struct kvm_hv_hcall {
> +	u64 param;
> +	u64 ingpa;
> +	u64 outgpa;
> +	u16 code;
> +	u16 rep_cnt;
> +	u16 rep_idx;
> +	bool fast;
> +	bool rep;
> +};
> +
> +static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)

Nitpick: Would it make sense to also pack the fact that we're dealing
with a hypercall using ExProcessorMasks into 'struct kvm_hv_hcall' and
get rid of 'bool ex' parameter for both kvm_hv_flush_tlb() and
kvm_hv_send_ipi()? 'struct kvm_hv_hcall' is already a synthetic
aggregator for input and output so adding some other information there
may not be that big of a stretch...

>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> @@ -1638,7 +1649,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
>  	bool all_cpus;
>  
>  	if (!ex) {
> -		if (unlikely(kvm_read_guest(kvm, ingpa, &flush, sizeof(flush))))
> +		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush, sizeof(flush))))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
>  		trace_kvm_hv_flush_tlb(flush.processor_mask,
> @@ -1657,7 +1668,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
>  		all_cpus = (flush.flags & HV_FLUSH_ALL_PROCESSORS) ||
>  			flush.processor_mask == 0;
>  	} else {
> -		if (unlikely(kvm_read_guest(kvm, ingpa, &flush_ex,
> +		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
>  					    sizeof(flush_ex))))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
> @@ -1679,8 +1690,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
>  
>  		if (!all_cpus &&
>  		    kvm_read_guest(kvm,
> -				   ingpa + offsetof(struct hv_tlb_flush_ex,
> -						    hv_vp_set.bank_contents),
> +				   hc->ingpa + offsetof(struct hv_tlb_flush_ex,
> +							hv_vp_set.bank_contents),
>  				   sparse_banks,
>  				   sparse_banks_len))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> @@ -1700,9 +1711,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
>  				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
>  
>  ret_success:
> -	/* We always do full TLB flush, set rep_done = rep_cnt. */
> +	/* We always do full TLB flush, set rep_done = hc->rep_cnt. */

Nitpicking: I'd suggest we word it a bit differently:

"We always do full TLB flush, set 'Reps completed' = 'Rep Count'."

so it matches TLFS rather than KVM internals.

>  	return (u64)HV_STATUS_SUCCESS |
> -		((u64)rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
> +		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
>  }
>  
>  static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
> @@ -1724,8 +1735,7 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
>  	}
>  }
>  
> -static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
> -			   bool ex, bool fast)
> +static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	struct hv_send_ipi_ex send_ipi_ex;
> @@ -1740,25 +1750,25 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
>  	bool all_cpus;
>  
>  	if (!ex) {
> -		if (!fast) {
> -			if (unlikely(kvm_read_guest(kvm, ingpa, &send_ipi,
> +		if (!hc->fast) {
> +			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
>  						    sizeof(send_ipi))))
>  				return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			sparse_banks[0] = send_ipi.cpu_mask;
>  			vector = send_ipi.vector;
>  		} else {
>  			/* 'reserved' part of hv_send_ipi should be 0 */
> -			if (unlikely(ingpa >> 32 != 0))
> +			if (unlikely(hc->ingpa >> 32 != 0))
>  				return HV_STATUS_INVALID_HYPERCALL_INPUT;
> -			sparse_banks[0] = outgpa;
> -			vector = (u32)ingpa;
> +			sparse_banks[0] = hc->outgpa;
> +			vector = (u32)hc->ingpa;
>  		}
>  		all_cpus = false;
>  		valid_bank_mask = BIT_ULL(0);
>  
>  		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
>  	} else {
> -		if (unlikely(kvm_read_guest(kvm, ingpa, &send_ipi_ex,
> +		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
>  					    sizeof(send_ipi_ex))))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
> @@ -1778,8 +1788,8 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
>  
>  		if (!all_cpus &&
>  		    kvm_read_guest(kvm,
> -				   ingpa + offsetof(struct hv_send_ipi_ex,
> -						    vp_set.bank_contents),
> +				   hc->ingpa + offsetof(struct hv_send_ipi_ex,
> +							vp_set.bank_contents),
>  				   sparse_banks,
>  				   sparse_banks_len))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> @@ -1839,20 +1849,21 @@ static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
>  	return kvm_hv_hypercall_complete(vcpu, vcpu->run->hyperv.u.hcall.result);
>  }
>  
> -static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
> +static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  {
>  	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
>  	struct eventfd_ctx *eventfd;
>  
> -	if (unlikely(!fast)) {
> +	if (unlikely(!hc->fast)) {
>  		int ret;
> -		gpa_t gpa = param;
> +		gpa_t gpa = hc->ingpa;
>  
> -		if ((gpa & (__alignof__(param) - 1)) ||
> -		    offset_in_page(gpa) + sizeof(param) > PAGE_SIZE)
> +		if ((gpa & (__alignof__(hc->ingpa) - 1)) ||
> +		    offset_in_page(gpa) + sizeof(hc->ingpa) > PAGE_SIZE)
>  			return HV_STATUS_INVALID_ALIGNMENT;
>  
> -		ret = kvm_vcpu_read_guest(vcpu, gpa, &param, sizeof(param));
> +		ret = kvm_vcpu_read_guest(vcpu, gpa,
> +					  &hc->ingpa, sizeof(hc->ingpa));
>  		if (ret < 0)
>  			return HV_STATUS_INVALID_ALIGNMENT;
>  	}
> @@ -1862,15 +1873,15 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
>  	 * have no use for it, and in all known usecases it is zero, so just
>  	 * report lookup failure if it isn't.
>  	 */
> -	if (param & 0xffff00000000ULL)
> +	if (hc->ingpa & 0xffff00000000ULL)
>  		return HV_STATUS_INVALID_PORT_ID;
>  	/* remaining bits are reserved-zero */
> -	if (param & ~KVM_HYPERV_CONN_ID_MASK)
> +	if (hc->ingpa & ~KVM_HYPERV_CONN_ID_MASK)
>  		return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
>  	/* the eventfd is protected by vcpu->kvm->srcu, but conn_to_evt isn't */
>  	rcu_read_lock();
> -	eventfd = idr_find(&hv->conn_to_evt, param);
> +	eventfd = idr_find(&hv->conn_to_evt, hc->ingpa);
>  	rcu_read_unlock();
>  	if (!eventfd)
>  		return HV_STATUS_INVALID_PORT_ID;
> @@ -1881,9 +1892,8 @@ static u16 kvm_hvcall_signal_event(struct kvm_vcpu *vcpu, bool fast, u64 param)
>  
>  int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  {
> -	u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
> -	uint16_t code, rep_idx, rep_cnt;
> -	bool fast, rep;
> +	struct kvm_hv_hcall hc;
> +	u64 ret = HV_STATUS_SUCCESS;
>  
>  	/*
>  	 * hypercall generates UD from non zero cpl and real mode
> @@ -1896,104 +1906,105 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  
>  #ifdef CONFIG_X86_64
>  	if (is_64_bit_mode(vcpu)) {
> -		param = kvm_rcx_read(vcpu);
> -		ingpa = kvm_rdx_read(vcpu);
> -		outgpa = kvm_r8_read(vcpu);
> +		hc.param = kvm_rcx_read(vcpu);
> +		hc.ingpa = kvm_rdx_read(vcpu);
> +		hc.outgpa = kvm_r8_read(vcpu);
>  	} else
>  #endif
>  	{
> -		param = ((u64)kvm_rdx_read(vcpu) << 32) |
> -			(kvm_rax_read(vcpu) & 0xffffffff);
> -		ingpa = ((u64)kvm_rbx_read(vcpu) << 32) |
> -			(kvm_rcx_read(vcpu) & 0xffffffff);
> -		outgpa = ((u64)kvm_rdi_read(vcpu) << 32) |
> -			(kvm_rsi_read(vcpu) & 0xffffffff);
> +		hc.param = ((u64)kvm_rdx_read(vcpu) << 32) |
> +			    (kvm_rax_read(vcpu) & 0xffffffff);
> +		hc.ingpa = ((u64)kvm_rbx_read(vcpu) << 32) |
> +			    (kvm_rcx_read(vcpu) & 0xffffffff);
> +		hc.outgpa = ((u64)kvm_rdi_read(vcpu) << 32) |
> +			     (kvm_rsi_read(vcpu) & 0xffffffff);
>  	}
>  
> -	code = param & 0xffff;
> -	fast = !!(param & HV_HYPERCALL_FAST_BIT);
> -	rep_cnt = (param >> HV_HYPERCALL_REP_COMP_OFFSET) & 0xfff;
> -	rep_idx = (param >> HV_HYPERCALL_REP_START_OFFSET) & 0xfff;
> -	rep = !!(rep_cnt || rep_idx);
> +	hc.code = hc.param & 0xffff;
> +	hc.fast = !!(hc.param & HV_HYPERCALL_FAST_BIT);
> +	hc.rep_cnt = (hc.param >> HV_HYPERCALL_REP_COMP_OFFSET) & 0xfff;
> +	hc.rep_idx = (hc.param >> HV_HYPERCALL_REP_START_OFFSET) & 0xfff;
> +	hc.rep = !!(hc.rep_cnt || hc.rep_idx);
>  
> -	trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
> +	trace_kvm_hv_hypercall(hc.code, hc.fast, hc.rep_cnt, hc.rep_idx,
> +			       hc.ingpa, hc.outgpa);
>  
> -	switch (code) {
> +	switch (hc.code) {
>  	case HVCALL_NOTIFY_LONG_SPIN_WAIT:
> -		if (unlikely(rep)) {
> +		if (unlikely(hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
>  		kvm_vcpu_on_spin(vcpu, true);
>  		break;
>  	case HVCALL_SIGNAL_EVENT:
> -		if (unlikely(rep)) {
> +		if (unlikely(hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hvcall_signal_event(vcpu, fast, ingpa);
> +		ret = kvm_hvcall_signal_event(vcpu, &hc);
>  		if (ret != HV_STATUS_INVALID_PORT_ID)
>  			break;
>  		fallthrough;	/* maybe userspace knows this conn_id */
>  	case HVCALL_POST_MESSAGE:
>  		/* don't bother userspace if it has no way to handle it */
> -		if (unlikely(rep || !to_hv_synic(vcpu)->active)) {
> +		if (unlikely(hc.rep || !to_hv_synic(vcpu)->active)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
>  		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
>  		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> -		vcpu->run->hyperv.u.hcall.input = param;
> -		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
> -		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
> +		vcpu->run->hyperv.u.hcall.input = hc.param;
> +		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
> +		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
>  		vcpu->arch.complete_userspace_io =
>  				kvm_hv_hypercall_complete_userspace;
>  		return 0;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
> -		if (unlikely(fast || !rep_cnt || rep_idx)) {
> +		if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
> +		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
>  		break;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
> -		if (unlikely(fast || rep)) {
> +		if (unlikely(hc.fast || hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
> +		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
>  		break;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
> -		if (unlikely(fast || !rep_cnt || rep_idx)) {
> +		if (unlikely(hc.fast || !hc.rep_cnt || hc.rep_idx)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
> +		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
>  		break;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
> -		if (unlikely(fast || rep)) {
> +		if (unlikely(hc.fast || hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
> +		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
>  		break;
>  	case HVCALL_SEND_IPI:
> -		if (unlikely(rep)) {
> +		if (unlikely(hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, false, fast);
> +		ret = kvm_hv_send_ipi(vcpu, &hc, false);
>  		break;
>  	case HVCALL_SEND_IPI_EX:
> -		if (unlikely(fast || rep)) {
> +		if (unlikely(hc.fast || hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
> +		ret = kvm_hv_send_ipi(vcpu, &hc, true);
>  		break;
>  	case HVCALL_POST_DEBUG_DATA:
>  	case HVCALL_RETRIEVE_DEBUG_DATA:
> -		if (unlikely(fast)) {
> +		if (unlikely(hc.fast)) {
>  			ret = HV_STATUS_INVALID_PARAMETER;
>  			break;
>  		}
> @@ -2012,9 +2023,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		}
>  		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
>  		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> -		vcpu->run->hyperv.u.hcall.input = param;
> -		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
> -		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
> +		vcpu->run->hyperv.u.hcall.input = hc.param;
> +		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
> +		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
>  		vcpu->arch.complete_userspace_io =
>  				kvm_hv_hypercall_complete_userspace;
>  		return 0;

With or without the nitpicks from above addressed,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

