Return-Path: <kvm+bounces-61958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 473D5C305EF
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 10:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D4B234E7A43
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 09:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B4B31329E;
	Tue,  4 Nov 2025 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NJ84IDxd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B45305E01;
	Tue,  4 Nov 2025 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250149; cv=none; b=YrOCKmSGY//QkcHPKLxBjrrQ/TkpezIFJpnhDcSsks45PF9VAlDIvtkzSqsfzDWUz6qFbf9A2KlBm8d1Jx6Ile0w5Znt0F/Zgazi4+59O2epm0PK95DR/Wnu7tWt8HPBAK7s32CTw2UWP7lQO8xCxdVxX8DjT3M/nNo+R9Opsns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250149; c=relaxed/simple;
	bh=7DYEB3sfqraZqe5u9N0cq1EdSkfB6r2RUJ53TZ2nd74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LtgoFsMskmrztJnwNJbI8iaaG7GU27lOjc8eOUhvzddvLcqCDMmk1pWyZm+17mNgAkXSCKgc9/lVaGvvfKdyr/eRzdue4dOBTF3kL43xj/cFTjJVz3jfDYO3j+JsRGS7ZoSyyxa8+1rKCQcvZHnU4GhbCiRAIfePq8fuAqq4ttE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NJ84IDxd; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762250149; x=1793786149;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7DYEB3sfqraZqe5u9N0cq1EdSkfB6r2RUJ53TZ2nd74=;
  b=NJ84IDxdN+CnXtQNOmq6hq2BGtmBMHjmxxtWYCAZO9nCPMcDofk9/oht
   HMwTh//htrNcxvWQA9ADIOnh1jUAHfqXSdEieaAQtZE0KwDJxEbiXuiFJ
   HVxO5g6DlpfnxdNFj3o1t2xoXE38pHlBzHXhwrYZY0MX273lMehqqL2LT
   k9HTzY1tQK3R4SXgpkL5+EKlkVfT1WQCgHBiNtrjxcVQnjMdiCUMD0jW/
   0e19v6xOXSD4jViT/aDFqdrB4TI1CYSgm5OXz+E3S0LHZSMbT2TxvqoVS
   Isyou1G5ja8X8MagRjAcTTjKNrtSobsuHm8drylYtPj/LFX0JjepPn6ZL
   Q==;
X-CSE-ConnectionGUID: O1edlaerSCeaY3Fkw+z8Bw==
X-CSE-MsgGUID: oinmEtRhR+GW00zjpIa18w==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64037203"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="64037203"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:55:47 -0800
X-CSE-ConnectionGUID: sZqCLyO4QsyOw5q1qfwoHw==
X-CSE-MsgGUID: D+yviwQqRYi2FTLsfX9ufA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="187267273"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.49]) ([10.124.240.49])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:55:43 -0800
Message-ID: <72503421-803c-4fa8-8e28-b0c793798c7c@intel.com>
Date: Tue, 4 Nov 2025 17:55:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2][PATCH 1/2] x86/virt/tdx: Remove __user annotation from
 kernel pointer
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, x86@kernel.org
References: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
 <20251103234437.A0532420@davehans-spike.ostc.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251103234437.A0532420@davehans-spike.ostc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/2025 7:44 AM, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Separate __user pointer variable declaration from kernel one.
> 
> There are two 'kvm_cpuid2' pointers involved here. There's an "input"
> side: 'td_cpuid' which is a normal kernel pointer and an 'output'
> side. The output here is userspace and there is an attempt at properly
> annotating the variable with __user:
> 
> 	struct kvm_cpuid2 __user *output, *td_cpuid;
> 
> But, alas, this is wrong. The __user in the definition applies to both
> 'output' and 'td_cpuid'. Sparse notices the address space mismatch and
> will complain about it.
> 
> Fix it up by completely separating the two definitions so that it is
> obviously correct without even having to know what the C syntax rules
> even are.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Fixes: 488808e682e7 ("KVM: x86: Introduce KVM_TDX_GET_CPUID")
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

the prefix of the shortlog is still "x86/virt/tdx". I think Sean will 
change it to "KVM: TDX:", if it gets routed through KVM tree.

Anyway,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Kirill A. Shutemov" <kas@kernel.org>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>   b/arch/x86/kvm/vmx/tdx.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-3 arch/x86/kvm/vmx/tdx.c
> --- a/arch/x86/kvm/vmx/tdx.c~tdx-sparse-fix-3	2025-11-03 15:11:26.773525519 -0800
> +++ b/arch/x86/kvm/vmx/tdx.c	2025-11-03 15:11:26.782526277 -0800
> @@ -3054,7 +3054,8 @@ static int tdx_vcpu_get_cpuid_leaf(struc
>   
>   static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>   {
> -	struct kvm_cpuid2 __user *output, *td_cpuid;
> +	struct kvm_cpuid2 __user *output;
> +	struct kvm_cpuid2 *td_cpuid;
>   	int r = 0, i = 0, leaf;
>   	u32 level;
>   
> _


