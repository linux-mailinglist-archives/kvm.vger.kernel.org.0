Return-Path: <kvm+bounces-68682-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDiGKCp/cGktYAAAu9opvQ
	(envelope-from <kvm+bounces-68682-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 08:24:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AED352C4A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 08:24:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9053D4EAEA9
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 07:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE9244DB90;
	Wed, 21 Jan 2026 07:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jd7DjhKB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15793AEF2D;
	Wed, 21 Jan 2026 07:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768980245; cv=none; b=qLw4E6WG/zaHVL11v2xg4a17p4UNx1Y0egUTqJOg4q1qElThO0G6JQHfMOKjX4hdHDVaCdn1Co9nuYtemamFnvr3JoYGxOTtlrkMnTE94aU/0FzcWtH1LXzIVmogDyVkAg4tY6S6x41mDw7c5xPZXEoeMuZIfrjRP56I5+hSD40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768980245; c=relaxed/simple;
	bh=OgMupP7U2Hhvx4lMbkzEIs76qr0+Su37AyQKBA6RlA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RSvmAkkUnc+3+gQTjG1xbUyrKHG8B+6uo6L0MpC55hE1J9BneYpQ5qVX1L6Pj0tuuidhN0YIxuySCcYIvD0Rf7biX/3hHNKXt3/zEyzTtvU4qZMGYYkUDmQ4KXdDssDPrZ6KrLa9cwhzL91m9jUUrcV4pn5C3XELSkaJF5EqpR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jd7DjhKB; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768980243; x=1800516243;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OgMupP7U2Hhvx4lMbkzEIs76qr0+Su37AyQKBA6RlA8=;
  b=jd7DjhKBgH4uNixJfV+id2rY1T6uS1gYtluUqWpwtB5Y+jGT8QrsVBYv
   rfRDTDhEJI7fcGAC2Md6+/S0XRW03FRyoQfbcd8drYVarIXLVgqQDbLkI
   TB1dRKYUpM05/f2xZnoId2JaEQsQkkvRTUB7beHromi09kzaOo6vuyRNJ
   5/Olj7YzVLwtmRqeUWSLSFKP/927D7anetaqymWPwGfwTRglypHPD2Z+8
   wDXo4MTHoia4U2iOTr/K+nvu4amgbL/nl2w442xanPEr3wBZmiy2M2asu
   mDCesUHmABLpw0e512d6fbVzw17RrzhfIzZOgszIPXbXTyhe8ihV9uKVg
   A==;
X-CSE-ConnectionGUID: lBs18XChQq6JCxtUvFJiiw==
X-CSE-MsgGUID: KFkYHrHYRhOzUStqLeDhWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="81311241"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="81311241"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 23:24:03 -0800
X-CSE-ConnectionGUID: UiYlb34rThK5ejrQgR7crg==
X-CSE-MsgGUID: /N5Rt8HkT5ugVNwzke/HJQ==
X-ExtLoop1: 1
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 23:23:58 -0800
Message-ID: <79adfc1f-6a0c-404d-aa3d-10efd788615a@linux.intel.com>
Date: Wed, 21 Jan 2026 15:23:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/22] KVM: VMX: Save/restore guest FRED RSP0
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
 hch@infradead.org, sohil.mehta@intel.com
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-10-xin@zytor.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251026201911.505204-10-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68682-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,intel.com:email,intel.com:dkim,linux.intel.com:mid]
X-Rspamd-Queue-Id: 2AED352C4A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 10/27/2025 4:18 AM, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Save guest FRED RSP0 in vmx_prepare_switch_to_host() and restore it
> in vmx_prepare_switch_to_guest() because MSR_IA32_FRED_RSP0 is passed
> through to the guest, thus is volatile/unknown.
> 
> Note, host FRED RSP0 is restored in arch_exit_to_user_mode_prepare(),
> regardless of whether it is modified in KVM.
> 
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
> 
> Changes in v5:
> * Remove the cpu_feature_enabled() check when set/get guest
>   MSR_IA32_FRED_RSP0, as guest_cpu_cap_has() should suffice (Sean).
> * Add a comment when synchronizing current MSR_IA32_FRED_RSP0 MSR to
>   the kernel's local cache, because its handling is different from
>   the MSR_KERNEL_GS_BASE handling (Sean).
> * Add TB from Xuelian Guo.
> 
> Changes in v3:
> * KVM only needs to save/restore guest FRED RSP0 now as host FRED RSP0
>   is restored in arch_exit_to_user_mode_prepare() (Sean Christopherson).
> 
> Changes in v2:
> * Don't use guest_cpuid_has() in vmx_prepare_switch_to_{host,guest}(),
>   which are called from IRQ-disabled context (Chao Gao).
> * Reset msr_guest_fred_rsp0 in __vmx_vcpu_reset() (Chao Gao).
> ---
>  arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
>  arch/x86/kvm/vmx/vmx.h |  1 +
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ef9765779884..c1fb3745247c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1292,6 +1292,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  	}
>  
>  	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
> +
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
> +		wrmsrns(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
>  #else
>  	savesegment(fs, fs_sel);
>  	savesegment(gs, gs_sel);
> @@ -1336,6 +1339,16 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
>  	invalidate_tss_limit();
>  #ifdef CONFIG_X86_64
>  	wrmsrq(MSR_KERNEL_GS_BASE, vmx->vt.msr_host_kernel_gs_base);
> +
> +	if (guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_FRED)) {
> +		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
> +		/*
> +		 * Synchronize the current value in hardware to the kernel's
> +		 * local cache.  The desired host RSP0 will be set when the
> +		 * CPU exits to userspace (RSP0 is a per-task value).
> +		 */
> +		fred_sync_rsp0(vmx->msr_guest_fred_rsp0);
> +	}
>  #endif
>  	load_fixmap_gdt(raw_smp_processor_id());
>  	vmx->vt.guest_state_loaded = false;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 645b0343e88c..48a5ab12cccf 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -227,6 +227,7 @@ struct vcpu_vmx {
>  	bool                  guest_uret_msrs_loaded;
>  #ifdef CONFIG_X86_64
>  	u64		      msr_guest_kernel_gs_base;
> +	u64		      msr_guest_fred_rsp0;
>  #endif
>  
>  	u64		      spec_ctrl;


