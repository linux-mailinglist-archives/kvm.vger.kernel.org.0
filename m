Return-Path: <kvm+bounces-40093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55AFDA4F110
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 00:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B1F1177E47
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F02E264619;
	Tue,  4 Mar 2025 23:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YVv+Memv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4787E1DB125;
	Tue,  4 Mar 2025 23:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741129308; cv=none; b=GlWzwpqX5ejLME9SlqVtaaoS7ipn8qPsNoQwBKNff1llZdMH2MNGlp49pcFq3xnzk6whxqRmZXtjTT+9OIgyECwZw2kJ3ukD2xIyIISOclJ4/mypYSkzzjs1ohezng9oPfVNkzmVGV/VCLXo1EOyaYDEdUOnQmEl7FmiPzG95jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741129308; c=relaxed/simple;
	bh=IwFjo5xnnNo0G4mp39det8GtoWQboNWFzjSKLgwyiDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZpvtdM8HbYPehLNKPaWsAn/BnXOgAC+F9Gyl7GiwQus21UKNE8xh3CXzr+dPtzFKTfWvnGL+e90UkR/+y896csY7xjD5aCkBraJM5I0s0yqrEAFvFZOkc370JlkL6DLDcOcHNGXCLhiVGxqBcqh1uZV3EJNM7pCkTVatNav9ZA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YVv+Memv; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741129306; x=1772665306;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IwFjo5xnnNo0G4mp39det8GtoWQboNWFzjSKLgwyiDE=;
  b=YVv+Memv5Hx/f/MorUAApppLj1DAdNMzjjlNhsLOGUalLZFjRZh/RbU/
   tc2qJkTht649ZbsM3DWFRfIGOb5XXA/OtAjlRDFXTALLJYHBz041WAmFB
   62WaTUsib/tSNXx6FvpHJYHrzS3eOPATDTiIkNhESpg6/hCIMUzuS4kCU
   5N2zdUx7AjVZ5MuqXictzjiU79NjSmd3JgVT50lUezFL07NB/PZScwRbf
   5iel187l9Q8gGib/KkCUt/aO+XwhUvWoTWcn9keGUUywp0ar0RZF4P8DA
   el5MgHsQzTroT6+KITRAwHLZmYlLE05qhlOsBGs8mrAulMwj9L41K5bU8
   Q==;
X-CSE-ConnectionGUID: TFJi605BSZ23HzsdGltV7g==
X-CSE-MsgGUID: VdumFJ78QPeWlVoaLaqE1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="29658032"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="29658032"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 15:01:45 -0800
X-CSE-ConnectionGUID: 5qIB9JHmSNaXWO1AYW3lVw==
X-CSE-MsgGUID: PPmFtYLKQxO0sZZvAqHOdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="155698833"
Received: from kinlongk-mobl1.amr.corp.intel.com (HELO [10.125.109.165]) ([10.125.109.165])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 15:01:45 -0800
Message-ID: <d6127d2e-ea95-4e52-b3db-b39203bad935@intel.com>
Date: Tue, 4 Mar 2025 15:02:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] x86/fpu/xstate: Create guest fpstate with guest
 specific config
To: Chao Gao <chao.gao@intel.com>, tglx@linutronix.de, x86@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: peterz@infradead.org, rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
 weijiang.yang@intel.com, john.allen@amd.com
References: <20241126101710.62492-1-chao.gao@intel.com>
 <20241126101710.62492-6-chao.gao@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20241126101710.62492-6-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/24 02:17, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Use fpu_guest_cfg to calculate guest fpstate settings, open code for
> __fpstate_reset() to avoid using kernel FPU config.
> 
> Below configuration steps are currently enforced to get guest fpstate:
> 1) Kernel sets up guest FPU settings in fpu__init_system_xstate().
> 2) User space sets vCPU thread group xstate permits via arch_prctl().
> 3) User space creates guest fpstate via __fpu_alloc_init_guest_fpstate()
>    for vcpu thread.
> 4) User space enables guest dynamic xfeatures and re-allocate guest
>    fpstate.
> 
> By adding kernel dynamic xfeatures in above #1 and #2, guest xstate area
> size is expanded to hold (fpu_kernel_cfg.default_features | kernel dynamic
> xfeatures | user dynamic xfeatures), then host xsaves/xrstors can operate
> for all guest xfeatures.

These changelogs have a lot of content, but they're honestly not helping
my along here very much.

>  arch/x86/kernel/fpu/core.c | 39 +++++++++++++++++++++++++++++---------
>  1 file changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 9e2e5c46cf28..00d7dcf45b34 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -194,8 +194,6 @@ void fpu_reset_from_exception_fixup(void)
>  }
>  
>  #if IS_ENABLED(CONFIG_KVM)
> -static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
> -
>  static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>  {
>  	struct fpu_state_perm *fpuperm;
> @@ -216,25 +214,48 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>  	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
>  }
>  
> -bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
> +static struct fpstate *__fpu_alloc_init_guest_fpstate(struct fpu_guest *gfpu)
>  {
>  	struct fpstate *fpstate;
>  	unsigned int size;
>  
> -	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
> +	/*
> +	 * fpu_guest_cfg.default_size is initialized to hold all enabled
> +	 * xfeatures except the user dynamic xfeatures. If the user dynamic
> +	 * xfeatures are enabled, the guest fpstate will be re-allocated to
> +	 * hold all guest enabled xfeatures, so omit user dynamic xfeatures
> +	 * here.
> +	 */
> +	size = fpu_guest_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
> +
>  	fpstate = vzalloc(size);
>  	if (!fpstate)
> -		return false;
> +		return NULL;
> +	/*
> +	 * Initialize sizes and feature masks, use fpu_user_cfg.*
> +	 * for user_* settings for compatibility of exiting uAPIs.
> +	 */
> +	fpstate->size		= fpu_guest_cfg.default_size;
> +	fpstate->xfeatures	= fpu_guest_cfg.default_features;
> +	fpstate->user_size	= fpu_user_cfg.default_size;
> +	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
> +	fpstate->xfd		= 0;
>  
> -	/* Leave xfd to 0 (the reset value defined by spec) */
> -	__fpstate_reset(fpstate, 0);
>  	fpstate_init_user(fpstate);
>  	fpstate->is_valloc	= true;
>  	fpstate->is_guest	= true;
>  
>  	gfpu->fpstate		= fpstate;
> -	gfpu->xfeatures		= fpu_user_cfg.default_features;
> -	gfpu->perm		= fpu_user_cfg.default_features;
> +	gfpu->xfeatures		= fpu_guest_cfg.default_features;
> +	gfpu->perm		= fpu_guest_cfg.default_features;
> +
> +	return fpstate;
> +}
> +
> +bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
> +{
> +	if (!__fpu_alloc_init_guest_fpstate(gfpu))
> +		return false;
>  
>  	/*
>  	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state

This series is starting to look backward to me.

The normal way you do these things is that you introduce new
abstractions and refactor the code. Then you go adding features.

For instance, this series should spend a few patches introducing
'fpu_guest_cfg' and using it before ever introducing the concept of a
dynamic xfeature.

