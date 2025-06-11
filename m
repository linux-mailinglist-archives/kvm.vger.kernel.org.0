Return-Path: <kvm+bounces-48959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 587C8AD48E0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 04:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D25431710CD
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3AE18D620;
	Wed, 11 Jun 2025 02:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W20+ASha"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804C933E7;
	Wed, 11 Jun 2025 02:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749608984; cv=none; b=c1pUtA2OLUxljg5GLgwPgbTPV1xGAHXNTqEXqEZFwSqwFEkVQJohszw71jyul922kp/GjrZKFPziabh3cu3gJka53ZaduUicrzu5QtB1zwolsil01DtLkljeW0DOpjktdndQbxwMPEBjgrS/e998azMBB/Ybx3OhjaUQCokssV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749608984; c=relaxed/simple;
	bh=/bP3uILDdQ7LYVJjPiQzYF06AAwnVAd6ybcPYYp/UUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DvizTlKcNrZwNnmM9ISncyNCAnvxb9lgvFUASs9hYwdTdNi2W9d0LxA0ZQKQCsMtkb8e+vpoJOmwBXdnGGF/5auSzr6nJCgTMLbGbIzEDyz+Awsnn3+mXrFeqR53oMx9e9osxQvXiRZbaJN+v/3H1kxLNaRZ0hS1yvTq4IrGwyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W20+ASha; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749608983; x=1781144983;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/bP3uILDdQ7LYVJjPiQzYF06AAwnVAd6ybcPYYp/UUw=;
  b=W20+ASha20Y+bN1ovTTwve4Ez5naavCkhmACsZesYzw/eUnIDCmhExtB
   ONlywoLX03J2VQPAWqlj4xjNsWJXZ5TJLDjkh4XLwIQHI+tfZPCFhYEVg
   rp89/M7VfYZlDXx9933Y19aDNMffOPr7ha5mGczc87YkcnP4k1GDbVs6k
   G1ylTsaRJsdNOd/1RspgFpL60rTHlvCVeHiu5Ws0i5y66JHl2PlRPTy3f
   SV65s9M1NLV59jJoO75fvDgqv7q97Fpc+Kgpo4335Sd5aRFI7y602HccM
   r+YaOU5Ep/xAVlRBHhDQCL9uTHH7DMqQ/D1nfWI4Af1TDWYcUo7/rVMw9
   Q==;
X-CSE-ConnectionGUID: 4duIjTpjThypQscusGfrKw==
X-CSE-MsgGUID: XkHccYbzTWyWUIIXKS6/3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51653641"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="51653641"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:29:42 -0700
X-CSE-ConnectionGUID: XrgJSVdPQjSsBITJp/bvbQ==
X-CSE-MsgGUID: wGwzBnltSiKh2CB3Jj7PsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="152009217"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:29:39 -0700
Message-ID: <121aac04-45ff-48c6-bab9-d57bf3f8524a@linux.intel.com>
Date: Wed, 11 Jun 2025 10:29:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/32] KVM: x86: Move definition of X2APIC_MSR() to
 lapic.h
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>,
 Xin Li <xin@zytor.com>, Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-18-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250610225737.156318-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/11/2025 6:57 AM, Sean Christopherson wrote:
> Dedup the definition of X2APIC_MSR and put it in the local APIC code
> where it belongs.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.h   | 2 ++
>  arch/x86/kvm/svm/svm.c | 2 --
>  arch/x86/kvm/vmx/vmx.h | 2 --
>  3 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 4ce30db65828..4518b4e0552f 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -21,6 +21,8 @@
>  #define APIC_BROADCAST			0xFF
>  #define X2APIC_BROADCAST		0xFFFFFFFFul
>  
> +#define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
> +
>  enum lapic_mode {
>  	LAPIC_MODE_DISABLED = 0,
>  	LAPIC_MODE_INVALID = X2APIC_ENABLE,
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4ee92e444dde..900a1303e0e7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -81,8 +81,6 @@ static uint64_t osvw_len = 4, osvw_status;
>  
>  static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  
> -#define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
> -
>  static const u32 direct_access_msrs[] = {
>  	MSR_STAR,
>  	MSR_IA32_SYSENTER_CS,
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index b5758c33c60f..0afe97e3478f 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -19,8 +19,6 @@
>  #include "../mmu.h"
>  #include "common.h"
>  
> -#define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
> -
>  #ifdef CONFIG_X86_64
>  #define MAX_NR_USER_RETURN_MSRS	7
>  #else

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



