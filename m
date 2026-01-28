Return-Path: <kvm+bounces-69425-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJ1VGL6Vemku8QEAu9opvQ
	(envelope-from <kvm+bounces-69425-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:03:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B4EA9D1E
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:03:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0E4BE3006211
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EDE314D0F;
	Wed, 28 Jan 2026 23:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WiCPP5UA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41DD2BEFE5;
	Wed, 28 Jan 2026 23:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769641398; cv=none; b=TelVcPx7tkKwggcFxk47/30t7a6b56Q9vHlZY58OhpZ3jJvKFQuMeJoPo0FlpteYAy+3uT59Z0/J24sCz9ba2wIoY7a7Z5aCrMAs4z53HM7q3Ojn9Z+VbNsDKU+jTfN6ehYa6/AhVIVyJvc/DPWp+xCg8vPmVF8a2hN407AIuJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769641398; c=relaxed/simple;
	bh=Qg+qewDO+0LovnBRqrbXzOE0i0zMAv5p5K8BdFqAB5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XFWpNrFNCZaN7fIdDwb8GAD3lxQtxIPj90CcYy6EDHp+LeDyzXbYCKKZuL0bVfU+uTG5ERNkDtMewbFtBSO1LikQNrSQHprIbD7vAfVs6zkcAT+/gL5MyLhVbMxYbogYyc1WQaj6tMwp8UFneem8NrVfbQznAQLdnjGCx0HM61Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WiCPP5UA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769641397; x=1801177397;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Qg+qewDO+0LovnBRqrbXzOE0i0zMAv5p5K8BdFqAB5U=;
  b=WiCPP5UA+pM+PKzan0io/UpmcRUswGCeRASs//yaViqvbTAG3XHgMpr2
   hL3eOUqrrsGRMFa0SezMR1kCvtBeh5xxQzsnxNGdiJlSLXq3f4hBWHg96
   9GzSj/+PuFui+wGfJuOR9Qjzc43N6Grqk5ES8fvtHVATfoLjQuwlNq+cq
   EvVxK3ZGCxg5zBfYuzlDU3JASd9BcBLHTp7tANahDsRiTtGUWfAnHFptC
   NoVALutwx+sQEmWj/UOr7yxFGgjG25aEku96Lxr9NqQYkLkg5ue41dKo7
   iq2UK657VJlo1lPshTFDqN/cTN/1JzxRt4Oh2PJiD7C0Jl/fHxCgcJtUn
   Q==;
X-CSE-ConnectionGUID: ROsbmsCjSXmOcmvBp8pu3g==
X-CSE-MsgGUID: +lQ10yuZRROrvZKyfZINzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="81504519"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="81504519"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:03:16 -0800
X-CSE-ConnectionGUID: vPtMAAQSSXCRlhXebKxAVg==
X-CSE-MsgGUID: U5TwJ5bWQJ+29P5QXOtSQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="231335173"
Received: from kcaccard-desk.amr.corp.intel.com (HELO [10.125.109.190]) ([10.125.109.190])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:03:15 -0800
Message-ID: <e2245231-ee39-40aa-bfdc-e43419fa30f4@intel.com>
Date: Wed, 28 Jan 2026 15:03:14 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/26] x86/virt/tdx: Prepare to support P-SEAMLDR
 SEAMCALLs
To: Chao Gao <chao.gao@intel.com>, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc: reinette.chatre@intel.com, ira.weiny@intel.com, kai.huang@intel.com,
 dan.j.williams@intel.com, yilun.xu@linux.intel.com, sagis@google.com,
 vannapurve@google.com, paulmck@kernel.org, nik.borisov@suse.com,
 zhenzhong.duan@intel.com, seanjc@google.com, rick.p.edgecombe@intel.com,
 kas@kernel.org, dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 Farrah Chen <farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-7-chao.gao@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260123145645.90444-7-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69425-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 86B4EA9D1E
X-Rspamd-Action: no action

On 1/23/26 06:55, Chao Gao wrote:
> P-SEAMLDR is another component alongside the TDX module within the
> protected SEAM range. P-SEAMLDR can update the TDX module at runtime.
> Software can talk with P-SEAMLDR via SEAMCALLs with the bit 63 of RAX
> (leaf number) set to 1 (a.k.a P-SEAMLDR SEAMCALLs).

This text kinda bugs me. It's OK, but needs improvement.

First, don't explain the ABI in the changelog. Nobody cares that it's
bit 63.


Background:

	The TDX architecture uses the "SEAMCALL" instruction to
	communicate with SEAM mode software. Right now, the only SEAM
	mode software that the kernel communicates with is the TDX
	module. But, there are actually some components that run in SEAM
	mode but that are separate from the TDX module: that SEAM
	loaders. Right now, the only component that communicates with
	them is the BIOS which loads the TDX module itself at boot. But,
	to support updating the TDX module, the kernel now needs to be
	able to talk to one of the the SEAM loaders: the Persistent
	loader or "P-SEAMLDR".

Then do this part:

> P-SEAMLDR SEAMCALLs differ from SEAMCALLs of the TDX module in terms of
> error codes and the handling of the current VMCS.
Except I don't even know how the TDX module handles the current VMCS.
That probably needs to be in there. Or, it should be brought up in the
patch itself that implements this. Or, uplifted to the cover letter.

> In preparation for adding support for P-SEAMLDR SEAMCALLs, do the two
> following changes to SEAMCALL low-level helpers:
> 
> 1) Tweak sc_retry() to retry on "lack of entropy" errors reported by
>    P-SEAMLDR because it uses a different error code.
> 
> 2) Add seamldr_err() to log error messages on P-SEAMLDR SEAMCALL failures.



> diff --git a/arch/x86/virt/vmx/tdx/seamcall.h b/arch/x86/virt/vmx/tdx/seamcall.h
> index 0912e03fabfe..256f71d6ca70 100644
> --- a/arch/x86/virt/vmx/tdx/seamcall.h
> +++ b/arch/x86/virt/vmx/tdx/seamcall.h
> @@ -34,15 +34,28 @@ static __always_inline u64 __seamcall_dirty_cache(sc_func_t func, u64 fn,
>  	return func(fn, args);
>  }
>  
> +#define SEAMLDR_RND_NO_ENTROPY	0x8000000000030001ULL

<sigh>

#define TDX_RND_NO_ENTROPY      0x8000020300000000ULL

So they're not even close values. They're not consistent or even a bit
off or anything.

Honestly, this needs a justification for why this was done this way. Why
can't "SEAM mode" be a monolithic thing from the kernel's perspective?

> +#define SEAMLDR_SEAMCALL_MASK	_BITUL(63)
> +
> +static inline bool is_seamldr_call(u64 fn)
> +{
> +	return fn & SEAMLDR_SEAMCALL_MASK;
> +}
> +
>  static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
>  			   struct tdx_module_args *args)
>  {
> +	u64 retry_code = TDX_RND_NO_ENTROPY;
>  	int retry = RDRAND_RETRY_LOOPS;
>  	u64 ret;
>  
> +	if (unlikely(is_seamldr_call(fn)))
> +		retry_code = SEAMLDR_RND_NO_ENTROPY;

(un)likey() has two uses:

1. It's in performance critical code and compilers have been
   demonstrated to be generating bad code.
2. It's in code where it's not obvious what the fast path is
   and (un)likey() makes the code more readable.

Which one is this?

Second, this is nitpicky, but I'd rather this be:

	if (is_seamldr_call(fn))
		retry_code = SEAMLDR_RND_NO_ENTROPY;
	else
		retry_code = TDX_RND_NO_ENTROPY;

or even:

	retry_code = TDX_RND_NO_ENTROPY;
	if (is_seamldr_call(fn))
		retry_code = SEAMLDR_RND_NO_ENTROPY;

That makes it trivial that 'retry_code' can only have two values. It's
nitpicky because the original initialization is so close.

>  	do {
>  		ret = func(fn, args);
> -	} while (ret == TDX_RND_NO_ENTROPY && --retry);
> +	} while (ret == retry_code && --retry);
>  
>  	return ret;
>  }
> @@ -68,6 +81,16 @@ static inline void seamcall_err_ret(u64 fn, u64 err,
>  			args->r9, args->r10, args->r11);
>  }
>  
> +static inline void seamldr_err(u64 fn, u64 err, struct tdx_module_args *args)
> +{
> +	/*
> +	 * Note: P-SEAMLDR leaf numbers are printed in hex as they have
> +	 * bit 63 set, making them hard to read and understand if printed
> +	 * in decimal
> +	 */
> +	pr_err("P-SEAMLDR (%llx) failed: %#016llx\n", fn, err);
> +}

Oh, lovely.

Didn't you just propose changing the module SEAMCALL leaf numbers in
decimal? Isn't it a little crazy to do one in decimal and the other in hex?

I'd really rather just see the TDX documentation changed.

But, honestly, I'd probably just leave the thing in hex, drop this hunk,
and go thwack someone that writes TDX module documentation instead.

>  static __always_inline int sc_retry_prerr(sc_func_t func,
>  					  sc_err_func_t err_func,
>  					  u64 fn, struct tdx_module_args *args)
> @@ -96,4 +119,7 @@ static __always_inline int sc_retry_prerr(sc_func_t func,
>  #define seamcall_prerr_ret(__fn, __args)					\
>  	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
>  
> +#define seamldr_prerr(__fn, __args)						\
> +	sc_retry_prerr(__seamcall, seamldr_err, (__fn), (__args))
> +
>  #endif

So, honestly, for me, it's a NAK for this whole patch.

Go change the P-SEAMLDR to use the same error code as the TDX module,
and fix the documentation. No kernel changes, please.

