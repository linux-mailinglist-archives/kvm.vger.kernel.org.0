Return-Path: <kvm+bounces-48126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94858AC9833
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 01:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDF03A459BD
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 23:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB4C28C86C;
	Fri, 30 May 2025 23:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="mA1rzIBL"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AB421772B;
	Fri, 30 May 2025 23:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748648330; cv=none; b=WO0EbNiFiIUbeCSjLv8BZrgGnGhPilJsJfgXT7eLyem/o83dTSz7PH0OxZ+fNusiTcC3M2WLNAzYlTXlOFTKb8vyWg3UwYchKItdq64mA8tLCSpmWHjD7IHlAUMOL23jBEfOp9emASM6vA/jN9tCabfZAifWlApPtsMsa9odVYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748648330; c=relaxed/simple;
	bh=Bnmh/dAY6eRBoePr4rFBhIDN7bYULVheR4frTt6jZ2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qVUZ+zlYEA0C48KRa7406UZcpK51ZbnPV3yC8phNme8kaf4i/R5H3KqpUKjL5I4G0B5yUyvsUV9f1MnQW/dGCc1s7gjKUpBjEPE30ClRXfwVjpy0P0FxEdu4XSbCWnRli4gIAjG88UhJdBY5OLd+hE0zHuFk3UjHVXoBI+dMSKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=mA1rzIBL; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 54UNcOYe2536046
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 30 May 2025 16:38:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 54UNcOYe2536046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1748648305;
	bh=OAz+XFES4XvKjugunJeITNkDCOGM7BToNv+VQUPI56c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mA1rzIBLKvwp4EqOxYIxvoMUjYqnj6lX1PuFo4elMilH5OqbjNOc5KKiGTe/p/FbE
	 QD4Wsqi1MxMRfO1TVQJXu4SPzp7/IjhCBcgPMmr5zRnryL2u8UJXs4eAC1WNEcBHQD
	 g9YSTaZixthf6RAVM2isaL7TgFBT5qdG34sE07C99o8/ASgsuKIHbCPeBZdRZDUR51
	 e2EAC2uw+9XH7E4ySqx6fbehYjFuH2dgNiV2n1hJLTfmoadSH7EQT0REk02Iao38do
	 G2CZiL7nFJFu2i6OYlgxYe2Oz+uAwHv4RDDvAdhv/JnVmeNyPqUovwNuziGHdK9Yih
	 KdhFMD+iUY9ZQ==
Message-ID: <04e4c088-46f9-41fe-a681-cf494bdbdb03@zytor.com>
Date: Fri, 30 May 2025 16:38:23 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/28] KVM: VMX: Manually recalc all MSR intercepts on
 userspace MSR filter change
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>, Chao Gao <chao.gao@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-17-seanjc@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 xsDNBGUPz1cBDACS/9yOJGojBFPxFt0OfTWuMl0uSgpwk37uRrFPTTLw4BaxhlFL0bjs6q+0
 2OfG34R+a0ZCuj5c9vggUMoOLdDyA7yPVAJU0OX6lqpg6z/kyQg3t4jvajG6aCgwSDx5Kzg5
 Rj3AXl8k2wb0jdqRB4RvaOPFiHNGgXCs5Pkux/qr0laeFIpzMKMootGa4kfURgPhRzUaM1vy
 bsMsL8vpJtGUmitrSqe5dVNBH00whLtPFM7IbzKURPUOkRRiusFAsw0a1ztCgoFczq6VfAVu
 raTye0L/VXwZd+aGi401V2tLsAHxxckRi9p3mc0jExPc60joK+aZPy6amwSCy5kAJ/AboYtY
 VmKIGKx1yx8POy6m+1lZ8C0q9b8eJ8kWPAR78PgT37FQWKYS1uAroG2wLdK7FiIEpPhCD+zH
 wlslo2ETbdKjrLIPNehQCOWrT32k8vFNEMLP5G/mmjfNj5sEf3IOKgMTMVl9AFjsINLHcxEQ
 6T8nGbX/n3msP6A36FDfdSEAEQEAAc0WWGluIExpIDx4aW5Aenl0b3IuY29tPsLBDQQTAQgA
 NxYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89XBQkFo5qAAhsDBAsJCAcFFQgJCgsFFgID
 AQAACgkQa70OVx2uN1HUpgv/cM2fsFCQodLArMTX5nt9yqAWgA5t1srri6EgS8W3F+3Kitge
 tYTBKu6j5BXuXaX3vyfCm+zajDJN77JHuYnpcKKr13VcZi1Swv6Jx1u0II8DOmoDYLb1Q2ZW
 v83W55fOWJ2g72x/UjVJBQ0sVjAngazU3ckc0TeNQlkcpSVGa/qBIHLfZraWtdrNAQT4A1fa
 sWGuJrChBFhtKbYXbUCu9AoYmmbQnsx2EWoJy3h7OjtfFapJbPZql+no5AJ3Mk9eE5oWyLH+
 QWqtOeJM7kKvn/dBudokFSNhDUw06e7EoVPSJyUIMbYtUO7g2+Atu44G/EPP0yV0J4lRO6EA
 wYRXff7+I1jIWEHpj5EFVYO6SmBg7zF2illHEW31JAPtdDLDHYcZDfS41caEKOQIPsdzQkaQ
 oW2hchcjcMPAfyhhRzUpVHLPxLCetP8vrVhTvnaZUo0xaVYb3+wjP+D5j/3+hwblu2agPsaE
 vgVbZ8Fx3TUxUPCAdr/p73DGg57oHjgezsDNBGUPz1gBDAD4Mg7hMFRQqlzotcNSxatlAQNL
 MadLfUTFz8wUUa21LPLrHBkUwm8RujehJrzcVbPYwPXIO0uyL/F///CogMNx7Iwo6by43KOy
 g89wVFhyy237EY76j1lVfLzcMYmjBoTH95fJC/lVb5Whxil6KjSN/R/y3jfG1dPXfwAuZ/4N
 cMoOslWkfZKJeEut5aZTRepKKF54T5r49H9F7OFLyxrC/uI9UDttWqMxcWyCkHh0v1Di8176
 jjYRNTrGEfYfGxSp+3jYL3PoNceIMkqM9haXjjGl0W1B4BidK1LVYBNov0rTEzyr0a1riUrp
 Qk+6z/LHxCM9lFFXnqH7KWeToTOPQebD2B/Ah5CZlft41i8L6LOF/LCuDBuYlu/fI2nuCc8d
 m4wwtkou1Y/kIwbEsE/6RQwRXUZhzO6llfoN96Fczr/RwvPIK5SVMixqWq4QGFAyK0m/1ap4
 bhIRrdCLVQcgU4glo17vqfEaRcTW5SgX+pGs4KIPPBE5J/ABD6pBnUUAEQEAAcLA/AQYAQgA
 JhYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89ZBQkFo5qAAhsMAAoJEGu9DlcdrjdR4C0L
 /RcjolEjoZW8VsyxWtXazQPnaRvzZ4vhmGOsCPr2BPtMlSwDzTlri8BBG1/3t/DNK4JLuwEj
 OAIE3fkkm+UG4Kjud6aNeraDI52DRVCSx6xff3bjmJsJJMb12mWglN6LjdF6K+PE+OTJUh2F
 dOhslN5C2kgl0dvUuevwMgQF3IljLmi/6APKYJHjkJpu1E6luZec/lRbetHuNFtbh3xgFIJx
 2RpgVDP4xB3f8r0I+y6ua+p7fgOjDLyoFjubRGed0Be45JJQEn7A3CSb6Xu7NYobnxfkwAGZ
 Q81a2XtvNS7Aj6NWVoOQB5KbM4yosO5+Me1V1SkX2jlnn26JPEvbV3KRFcwV5RnDxm4OQTSk
 PYbAkjBbm+tuJ/Sm+5Yp5T/BnKz21FoCS8uvTiziHj2H7Cuekn6F8EYhegONm+RVg3vikOpn
 gao85i4HwQTK9/D1wgJIQkdwWXVMZ6q/OALaBp82vQ2U9sjTyFXgDjglgh00VRAHP7u1Rcu4
 l75w1xInsg==
In-Reply-To: <20250529234013.3826933-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/29/2025 4:40 PM, Sean Christopherson wrote:
> On a userspace MSR filter change, recalculate all MSR intercepts using the
> filter-agnostic logic instead of maintaining a "shadow copy" of KVM's
> desired intercepts.  The shadow bitmaps add yet another point of failure,
> are confusing (e.g. what does "handled specially" mean!?!?), an eyesore,
> and a maintenance burden.
> 
> Given that KVM *must* be able to recalculate the correct intercepts at any
> given time, and that MSR filter updates are not hot paths, there is zero
> benefit to maintaining the shadow bitmaps.

+1

To me, this patch does simplify the logic by removing the bitmap state 
management.


Just one very minor comment below — other than that:

Reviewed-by: Xin Li (Intel) <xin@zytor.com>

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8f7fe04a1998..6ffa2b2b85ce 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4159,35 +4074,59 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>   	}
>   }
>   
> -void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
> +static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>   {
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	u32 i;
> -
>   	if (!cpu_has_vmx_msr_bitmap())
>   		return;
>   
> -	/*
> -	 * Redo intercept permissions for MSRs that KVM is passing through to
> -	 * the guest.  Disabling interception will check the new MSR filter and
> -	 * ensure that KVM enables interception if usersepace wants to filter
> -	 * the MSR.  MSRs that KVM is already intercepting don't need to be
> -	 * refreshed since KVM is going to intercept them regardless of what
> -	 * userspace wants.
> -	 */
> -	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
> -		u32 msr = vmx_possible_passthrough_msrs[i];
> -
> -		if (!test_bit(i, vmx->shadow_msr_intercept.read))
> -			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_R);
> -
> -		if (!test_bit(i, vmx->shadow_msr_intercept.write))
> -			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_W);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
> +#ifdef CONFIG_X86_64
> +	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> +#endif
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> +	if (kvm_cstate_in_guest(vcpu->kvm)) {
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
>   	}
>   
>   	/* PT MSRs can be passed through iff PT is exposed to the guest. */
>   	if (vmx_pt_mode_is_host_guest())
>   		pt_update_intercept_for_msr(vcpu);
> +
> +	if (vcpu->arch.xfd_no_write_intercept)
> +		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
> +
> +
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
> +				  !to_vmx(vcpu)->spec_ctrl);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
> +					  !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD));
> +
> +	if (boot_cpu_has(X86_FEATURE_IBPB))

I think Boris prefers using cpu_feature_enabled() instead — maybe this
is a good opportunity to update this occurrence?

> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
> +					  !guest_has_pred_cmd_msr(vcpu));
> +
> +	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))

Ditto.

> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
> +					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
> +
> +	/*
> +	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
> +	 * filtered by userspace.
> +	 */
> +}

