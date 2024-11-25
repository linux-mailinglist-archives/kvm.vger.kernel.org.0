Return-Path: <kvm+bounces-32414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B196A9D84D5
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1AD9B33436
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29928196C7B;
	Mon, 25 Nov 2024 11:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XhAOqtb9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A2D192589;
	Mon, 25 Nov 2024 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732533050; cv=none; b=NBNA6iqD1/2QxoPQujQRC8er0aQAkAkDEchgZZLDfczv4zrhWKnsJSo7SzAv7d+99DrzaEta09MAu3a1JHu8M3rAtS0UvvVPcZsbe+IuZi1/30+lEYZlfGYqw2V6GkG9X0fLSdwbTtK6qZAYHV+D6ayq+LxUq2RfmEUtiLbZzIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732533050; c=relaxed/simple;
	bh=mzdUoYSo8U5mMFN+HnRKNXhF4nTnOARWiNB1Z+Bwclg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDFbrrmhKL17hkmjONXSFhAvwuk8WU0EJUANaA1/ygxxUcIfH5mjF+7Wxh5jncB0KFU7jaalTsu9iaq55BhqXgcEf1tzRl3FSIziI9f4unxrd6deLeMnmUDPtQlaqpbf02ZHhTYx15mVgXLAR1M7lc+IZSa3pHIUenb9opZl5E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XhAOqtb9; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732533049; x=1764069049;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mzdUoYSo8U5mMFN+HnRKNXhF4nTnOARWiNB1Z+Bwclg=;
  b=XhAOqtb9J+ge8GPX+YYb4Ci7h2uDu+LJ17UwVguu2DLuqLzsSvfv5gGC
   CU0Jwc0WitE6vIh5vfWnl3wRe/79lGLgHvDvyPPAcDZrHWrFVMXMWTCTk
   aDi0LXLB/V+J8ey4SfEw2YV+wj6wWlWI34/VrqE9//f6trVt/kPaAnhwF
   KBt1TbUznG0/WHPLsdDxRC5Z2+RpA6aaNdD54xdYz0kyY49306Fhi9DD3
   rQXXRdEclptBpqFiFrvERYpsiy6A+PcOiV4zYQVMv0oNeTaYSehHcZz/h
   bW1zpGYe4mXg+OHd8FTailpmJkUA3welaqFQYdPsNkAwU3XRB/SW07kwE
   A==;
X-CSE-ConnectionGUID: iGWZyahvTAGEOFUApXDCHQ==
X-CSE-MsgGUID: 84OHOioBQdGB4EEiBirS+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11266"; a="32884689"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="32884689"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 03:10:48 -0800
X-CSE-ConnectionGUID: MfymY+8zRSqny8Xy6KGkmg==
X-CSE-MsgGUID: h2Ger/bZScCM52AfSgpu4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="91361137"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 03:10:43 -0800
Message-ID: <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
Date: Mon, 25 Nov 2024 13:10:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z0AbZWd/avwcMoyX@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 22/11/24 07:49, Chao Gao wrote:
>> +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>> +
>> +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
>> +	    kvm_host.xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
>> +		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
>> +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
>> +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
>> +	    kvm_host.xss != (kvm_tdx->xfam &
>> +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
>> +			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)))
> 
> Should we drop CET/PT from this series? I think they are worth a new
> patch/series.

This is not really about CET/PT

What is happening here is that we are calculating the current
MSR_IA32_XSS value based on the TDX Module spec which says the
TDX Module sets MSR_IA32_XSS to the XSS bits from XFAM.  The
TDX Module does that literally, from TDX Module source code:

	#define XCR0_SUPERVISOR_BIT_MASK            0x0001FD00
and
	ia32_wrmsr(IA32_XSS_MSR_ADDR, xfam & XCR0_SUPERVISOR_BIT_MASK);

For KVM, rather than:

			kvm_tdx->xfam &
			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)

it would be more direct to define the bits and enforce them
via tdx_get_supported_xfam() e.g.

/* 
 * Before returning from TDH.VP.ENTER, the TDX Module assigns:
 *   XCR0 to the TD’s user-mode feature bits of XFAM (bits 7:0, 9)
 *   IA32_XSS to the TD's supervisor-mode feature bits of XFAM (bits 8, 16:10)
 */
#define TDX_XFAM_XCR0_MASK	(GENMASK(7, 0) | BIT(9))
#define TDX_XFAM_XSS_MASK	(GENMASK(16, 10) | BIT(8))
#define TDX_XFAM_MASK		(TDX_XFAM_XCR0_MASK | TDX_XFAM_XSS_MASK)

static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_conf)
{
	u64 val = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;

	/* Ensure features are in the masks */
	val &= TDX_XFAM_MASK;

	if ((val & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
		return 0;

	val &= td_conf->xfam_fixed0;

	return val;
}

and then:

	if (static_cpu_has(X86_FEATURE_XSAVE) &&
	    kvm_host.xcr0 != (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK))
		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
	if (static_cpu_has(X86_FEATURE_XSAVES) &&
	    kvm_host.xss != (kvm_tdx->xfam & TDX_XFAM_XSS_MASK))
		wrmsrl(MSR_IA32_XSS, kvm_host.xss);

> 
>> +		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
>> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> 
> How about using cpu_feature_enabled()? It is used in kvm_load_host_xsave_state()
> It handles the case where CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not
> enabled.
> 
>> +	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
>> +		write_pkru(vcpu->arch.host_pkru);
> 
> If host_pkru happens to match the hardware value after TD-exits, the write can
> be omitted, similar to what is done above for xss and xcr0.

True.  It might be better to make restoring PKRU a separate
patch so that the commit message can explain why it needs to
be done here.


