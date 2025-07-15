Return-Path: <kvm+bounces-52496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFE0B05CCD
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 094BD3A87DC
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA9102397BF;
	Tue, 15 Jul 2025 13:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D3eImw9K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369C08633F;
	Tue, 15 Jul 2025 13:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586070; cv=none; b=XW177bFAVIStleUpUCvTjmirGm2yKrBPHPZZ/GpUOAoQia9F/gx1ae1uOKSePH8s3Qxq4hNxGBuNYzj7Nu9SrHk4OXg6XMSKKjt7irt8dvVqeyNn/3QDb1NRlRBVfUlTTRvpsueWlWlbylxupqfHMU7iJ40ggaIfCLVeQc/BkN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586070; c=relaxed/simple;
	bh=piGD4FwRVCAt6B4eBAwBCwgyfxtHlNrnruAIbLdI6GM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kv/eLH+cAfwe8DgTqpJ8b7RXIswSYGR6q/rvBZv5TSnD+AMKAI/E9oSL2sp6SuXBxG6g0L6zOPxtdOCOqt3P8I6++TDifmvt1fmTGwQzcAenw0sX1SrNvN7ZSnrpmwef3jwG0ena7EbSdAVHfr+swj0tinf0+aeqOzppbN0Nz08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D3eImw9K; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752586068; x=1784122068;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=piGD4FwRVCAt6B4eBAwBCwgyfxtHlNrnruAIbLdI6GM=;
  b=D3eImw9KKG4NG0iSZdmGSnRQBWarxv9xT6UKTCGrMg6ixeejJnKTeYKV
   Rwtn6PnQGFe9ZcmayLXefT6P9w1NycoVh47BO8ecQ7CPq5B4Yv0eLi1rC
   fgnuvVgzQhNdwUwUd7rcNgo1i6ymdZbUVV9fty+E4ZX0j1dcWHDIAQK5J
   snVqp7wujXggsMuTxEsFEr/oBEM1p8qh7liWBiOKJHGA5o1o/KzkPfXNr
   RodFnG6JzSiZGEcnpBP31gQI7wk4LM5ydJjFtIUG2LHmELztkB7VLbJjO
   6D62/4/Gefh5Zo8UicTYGEGt4lcNFBpykcV12JgVWpUvKIOv4z58oN8Z+
   A==;
X-CSE-ConnectionGUID: xyZsN/c+RAe9PYctKXePHw==
X-CSE-MsgGUID: 6RgXSpLfQ6GMSzDzT5I1Ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="53918396"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="53918396"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 06:27:47 -0700
X-CSE-ConnectionGUID: XAO5LoGBRWir+UkimXidwg==
X-CSE-MsgGUID: x40WA/RnR3uqahYvAJh38w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="156638325"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 06:27:43 -0700
Message-ID: <e635c41e-55be-408d-ab43-7875021a9ecc@intel.com>
Date: Tue, 15 Jul 2025 21:27:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests patch 1/5] x86/pmu: Add helper to detect Intel
 overcount issues
To: Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>,
 Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>,
 Shukla Manali <Manali.Shukla@amd.com>, Yi Lai <yi1.lai@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, dongsheng <dongsheng.x.zhang@intel.com>
References: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
 <20250712174915.196103-2-dapeng1.mi@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250712174915.196103-2-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/13/2025 1:49 AM, Dapeng Mi wrote:
> From: dongsheng <dongsheng.x.zhang@intel.com>
> 
> For Intel Atom CPUs, the PMU events "Instruction Retired" or
> "Branch Instruction Retired" may be overcounted for some certain
> instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
> and complex SGX/SMX/CSTATE instructions/flows.
> 
> The detailed information can be found in the errata (section SRF7):
> https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
> 
> For the Atom platforms before Sierra Forest (including Sierra Forest),
> Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
> be overcounted on these certain instructions, but for Clearwater Forest
> only "Instruction Retired" event is overcounted on these instructions.
> 
> So add a helper detect_inst_overcount_flags() to detect whether the
> platform has the overcount issue and the later patches would relax the
> precise count check by leveraging the gotten overcount flags from this
> helper.
> 
> Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
> [Rewrite comments and commit message - Dapeng]
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
>   lib/x86/processor.h | 17 ++++++++++++++++
>   x86/pmu.c           | 47 +++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 64 insertions(+)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 62f3d578..3f475c21 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -1188,4 +1188,21 @@ static inline bool is_lam_u57_enabled(void)
>   	return !!(read_cr3() & X86_CR3_LAM_U57);
>   }
>   
> +static inline u32 x86_family(u32 eax)
> +{
> +	u32 x86;
> +
> +	x86 = (eax >> 8) & 0xf;
> +
> +	if (x86 == 0xf)
> +		x86 += (eax >> 20) & 0xff;
> +
> +	return x86;
> +}
> +
> +static inline u32 x86_model(u32 eax)
> +{
> +	return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
> +}

It seems to copy the implementation of kvm selftest.

I need to point it out that it's not correct (because I fixed the 
similar issue on QEMU recently).

We cannot count Extended Model ID unconditionally. Intel counts Extended 
Model when (base) Family is 0x6 or 0xF, while AMD counts EXtended Model 
when (base) Family is 0xF.

You can refer to kernel's x86_model() in arch/x86/lib/cpu.c, while it 
optimizes the condition to "family >= 0x6", which seems to have the 
assumption that Intel doesn't have processor with family ID from 7 to 
0xe and AMD doesn't have processor with family ID from 6 to 0xe.

