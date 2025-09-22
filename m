Return-Path: <kvm+bounces-58365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7138B8F632
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 10:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF45D7A771D
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29DDF2F90C9;
	Mon, 22 Sep 2025 08:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mIST54By"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6891862A;
	Mon, 22 Sep 2025 08:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758528060; cv=none; b=U2RgoSLtDEGw58iKwA06ZZ0A/kzxDLgv70jRPjwvrh1UH70JOAN+9Si0KZzyfGpS3cKD9EcP0iiwkkzk33cgAdjnYfdqY5RgVkgXkj6q3BdnmkhYxL4fZQIu1CIfjYso8KFHMEOgLxXL3QHO+7LONmQpSLAUJoYDPT7r6riNKwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758528060; c=relaxed/simple;
	bh=vNyASgDMALp2F+nu5vVRejbnwXsKQbnGGWSCJj1fXLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ggehHn4vs3UxbeKN9xIqjrzNUGnxPYUe+7kZ5GZTdlWl+0T/K5t3ilm2mJZcgZ5JSiAQuXmQ8coIEu9UzNF63vWR2cyjkzRf+UYukPaJ1AYe/q6FQr44dlpECdcSXdP0nKvovX+4E43hNkPFUw1NA5W+658TToUTLlwRt3Mh6VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mIST54By; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758528058; x=1790064058;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vNyASgDMALp2F+nu5vVRejbnwXsKQbnGGWSCJj1fXLc=;
  b=mIST54ByvG/UIIHADxI+A9gOVNIUczAcxzWBIfri72Xua//mukCsTgzl
   oDmiltlVnCAAHP8kph5RVejLWGHY8H10ZCGeJeTZbs38aDdiM986G6TtW
   IRgcZRT09RJ4blJCvJSQ8fskfhFXlf6hHh0fxwjNcMfjLLkgUmaiOWvva
   Hfg1LBxmOMVgqKpVKXu8tKNdq+jzjT+g8i94G+Lkmjwk1B0KPfcb58iyd
   TYqRXZMspQmnEZPufo1+qA3wR6vSXtJrZbr32vcN/01ZYUjMkMYfEp+c4
   WCKD1dKnGHUSOcVB3kchOCLWT1x9MTWQ+CfTNw2KK8BOBpL7zqKDeuadc
   w==;
X-CSE-ConnectionGUID: W7d7nakgSt6NfKrGoiR/0Q==
X-CSE-MsgGUID: r5a/wRedR6CHolHPv7mJig==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60725629"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60725629"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:00:57 -0700
X-CSE-ConnectionGUID: nMxVTHJvQkaET8Hj31utaw==
X-CSE-MsgGUID: hIfwrIfwR82Hg2GM3Lh0BA==
X-ExtLoop1: 1
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:00:53 -0700
Message-ID: <380c48c1-26ca-4a78-81fe-529fcdc56960@linux.intel.com>
Date: Mon, 22 Sep 2025 16:00:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 27/51] KVM: x86: Disable support for IBT and SHSTK if
 allow_smaller_maxphyaddr is true
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-28-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-28-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Make IBT and SHSTK virtualization mutually exclusive with "officially"
> supporting setups with guest.MAXPHYADDR < host.MAXPHYADDR, i.e. if the
> allow_smaller_maxphyaddr module param is set.  Running a guest with a
> smaller MAXPHYADDR requires intercepting #PF, and can also trigger
> emulation of arbitrary instructions.  Intercepting and reacting to #PFs
> doesn't play nice with SHSTK, as KVM's MMU hasn't been taught to handle
> Shadow Stack accesses, and emulating arbitrary instructions doesn't play
> nice with IBT or SHSTK, as KVM's emulator doesn't handle the various side
> effects, e.g. doesn't enforce end-branch markers or model Shadow Stack
> updates.
>
> Note, hiding IBT and SHSTK based solely on allow_smaller_maxphyaddr is
> overkill, as allow_smaller_maxphyaddr is only problematic if the guest is
> actually configured to have a smaller MAXPHYADDR.  However, KVM's ABI
> doesn't provide a way to express that IBT and SHSTK may break if enabled
> in conjunction with guest.MAXPHYADDR < host.MAXPHYADDR.  I.e. the
> alternative is to do nothing in KVM and instead update documentation and
> hope KVM users are thorough readers.  Go with the conservative-but-correct
> approach; worst case scenario, this restriction can be dropped if there's
> a strong use case for enabling CET on hosts with allow_smaller_maxphyaddr.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/cpuid.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 499c86bd457e..b5c4cb13630c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -963,6 +963,16 @@ void kvm_set_cpu_caps(void)
>   	if (!tdp_enabled)
>   		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>   
> +	/*
> +	 * Disable support for IBT and SHSTK if KVM is configured to emulate
> +	 * accesses to reserved GPAs, as KVM's emulator doesn't support IBT or
> +	 * SHSTK, nor does KVM handle Shadow Stack #PFs (see above).
> +	 */
> +	if (allow_smaller_maxphyaddr) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +	}
> +
>   	kvm_cpu_cap_init(CPUID_7_EDX,
>   		F(AVX512_4VNNIW),
>   		F(AVX512_4FMAPS),


