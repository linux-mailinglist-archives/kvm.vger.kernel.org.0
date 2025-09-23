Return-Path: <kvm+bounces-58548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50089B96780
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F15D7162705
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4523246BA4;
	Tue, 23 Sep 2025 14:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dbqiApKS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D36814A0BC;
	Tue, 23 Sep 2025 14:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639418; cv=none; b=MbSgfpfz1fa1bgsT7nTrzYDXMyvTfxUEyaZhPcR8cxUynWM/59kiHXh3lW3ldQOxhKG3b9oo5nSNBWpSZLO1PvYG5TzHitfPzl/jsvDcGIhdNnV82JgxBsq2VNdt0qJy6ucilFbJIH2xsI+qCm5514ugQLIul3pzfi6v45SyIXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639418; c=relaxed/simple;
	bh=nI4rWRfZtvQYN5NakqVwjaQ3OUxNgN9iPKmZBer+On8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ags4l6STkMrSPwe3xPuSoJ8s8wOGcHJsIIAO9VKRT94kQLnwkGV69TGXNr2Hg5pcImI60wy0nzJyEmpsmEDNG1JQZriBeTTpb70zROa9Gsr0qURsxnACLvaelDgfF16KeXJZhhXXbweA4oHxsHxI3DXaQ4mzD1Rg9e4ryd+pOWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dbqiApKS; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758639417; x=1790175417;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nI4rWRfZtvQYN5NakqVwjaQ3OUxNgN9iPKmZBer+On8=;
  b=dbqiApKSHIN6hN2Y/mHDkHUX2DlME38wjkRzPIBsdYoW8EU188J6cLfL
   pN5SefrtnYSUGB45hNtxvxqHwf5n8bHGpEJKZrK3c9wUctrR0zInlHIPE
   1Q625dS2xwxmKKYcdKHFzheF+u9YH3ocZCRJB+ImTyDHNGynhlU7cJHOy
   uVyyiH7a3aRumpc//Mc5ERLdohBRB2yaIhVvWnBjaMHC25q+yu64GRJ/Y
   G04Z1KEFXeR07UdvSY5RnL1y3NDRZaGY21IW+bfRI5a0VWe36kZbwNbpW
   wPTl2hO5Z/1f0Sml/BgbfddxkksOwAcJChPzs4GgnpcderPznFxHGiCvF
   Q==;
X-CSE-ConnectionGUID: MJMwINTeTye15IuzKLKxLw==
X-CSE-MsgGUID: noukLTDjSNKVYywjsEcQUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71593570"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="71593570"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:56:56 -0700
X-CSE-ConnectionGUID: nnGWmcTCQBORqzHzD5ARyg==
X-CSE-MsgGUID: ezUHpW+6RhmmSB/LfVq2Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="180775880"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:56:51 -0700
Message-ID: <5cb515e7-3d29-4b75-b581-f3e126d8b1c3@intel.com>
Date: Tue, 23 Sep 2025 22:56:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 26/51] KVM: x86: Disable support for Shadow Stacks if
 TDP is disabled
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-27-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919223258.1604852-27-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Make TDP a hard requirement for Shadow Stacks, as there are no plans to
> add Shadow Stack support to the Shadow MMU.  E.g. KVM hasn't been taught
> to understand the magic Writable=0,Dirty=0 combination that is required
> for Shadow Stack accesses, and so enabling Shadow Stacks when using
> shadow paging will put the guest into an infinite #PF loop (KVM thinks the
> shadow page tables have a valid mapping, hardware says otherwise).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/cpuid.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 32fde9e80c28..499c86bd457e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -955,6 +955,14 @@ void kvm_set_cpu_caps(void)
>   	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
>   		kvm_cpu_cap_clear(X86_FEATURE_PKU);
>   
> +	/*
> +	 * Shadow Stacks aren't implemented in the Shadow MMU.  Shadow Stack
> +	 * accesses require "magic" Writable=0,Dirty=1 protection, which KVM
> +	 * doesn't know how to emulate or map.
> +	 */
> +	if (!tdp_enabled)
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +
>   	kvm_cpu_cap_init(CPUID_7_EDX,
>   		F(AVX512_4VNNIW),
>   		F(AVX512_4FMAPS),


