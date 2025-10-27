Return-Path: <kvm+bounces-61139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3258C0C2AA
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 08:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE51718A262D
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 07:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09182DFA28;
	Mon, 27 Oct 2025 07:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DJj6ZeKz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6620B2DF710
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761550853; cv=none; b=ZhQxa0tYvrMKg7Ge6+h7l/orEY0KEkf0scP/lVKWYkgVHFL7BtVmabfvD6cNMm3nv8DoXKZbSWR2BSKW6HH/soqWM0j8x1HJK458wrvY7nZQ+Q6MQi1OZBMBdbPMj2RT916VmC8O6SSvAR8jgc4uuFPVTASQLP/ThRF15mErggw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761550853; c=relaxed/simple;
	bh=90WGIYiz342/9n5Am0mUlA7YJgiuYO06cMySOm9BPDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VTZG7c8WRy6TTH85OsUfm3aPr11H826kTRUbve4OsTozLWH56xLX7Pke0R+qzf8+aO6aXKZQ1Hf9dxfO++JJSLoiapJkcrZeIWjy4BjqhOUAMgOfqFPKkJ3V65JJyXBGQJRDNbGhoXGT0Bn++x+eAH2wdTuv7u39tCDkXfQgg98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DJj6ZeKz; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761550852; x=1793086852;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=90WGIYiz342/9n5Am0mUlA7YJgiuYO06cMySOm9BPDA=;
  b=DJj6ZeKzx6Lfwz7uELUF7QE9f3Z4Rfcmqqx/MJlHAZLEfhC9CmMlZdJF
   WsRHVsI+pJ3rDvLnOzlJ8wTyFJE+Utn/Sdn9unLSMezZDfNatrahbGMyK
   ivGH3iuOAJcJEU6bpbyHLBzS59YuLtgwog8G/kCJhuONBb4njhmxjA9C3
   fWSM1mnhIlVGbyH7Z5td9dGzElS42AjTf0aowg+q4bm3zXNSkM1aJy4ve
   o/7EbUVFr/ErMIagC9fmvpKfq9f2vWj9MLUqe2faaB5fmRHAPamPsQBVM
   OZPjb318YoVF7oJNQ7LQIMPFa87JRk/j31VyQVaZH2lo7lZvh72RaJQmR
   A==;
X-CSE-ConnectionGUID: I9haSMXrTi2N/9hh51VZgg==
X-CSE-MsgGUID: WhsFgxtwSY+2EeVU3mHzhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81050300"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="81050300"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:40:51 -0700
X-CSE-ConnectionGUID: 1I5iDUVATj+91BIuSCf/2g==
X-CSE-MsgGUID: n8QsUQdcSXyCM5i1t879wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184591771"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:40:47 -0700
Message-ID: <d34f682a-c6c0-4609-96e8-2a0b76585c7d@intel.com>
Date: Mon, 27 Oct 2025 15:40:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/20] i386/cpu: Reorganize dependency check for arch
 lbr state
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-8-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-8-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> The arch lbr state has 2 dependencies:
>   * Arch lbr feature bit (CPUID 0x7.0x0:EDX[bit 19]):
> 
>     This bit also depends on pmu property. Mask it off if pmu is disabled
>     in x86_cpu_expand_features(), so that it is not needed to repeatedly
>     check whether this bit is set as well as pmu is enabled.
> 
>     Note this doesn't need compat option, since even KVM hasn't support
>     arch lbr yet.
> 
>     The supported xstate is constructed based such dependency in
>     cpuid_has_xsave_feature(), so if pmu is disabled and arch lbr bit is
>     masked off, then arch lbr state won't be included in supported
>     xstates.
> 
>     Thus it's safe to drop the check on arch lbr bit in CPUID 0xD
>     encoding.
> 
>   * XSAVES feature bit (CPUID 0xD.0x1.EAX[bit 3]):
> 
>     Arch lbr state is a supervisor state, which requires the XSAVES
>     feature support. Enumerate supported supervisor state based on XSAVES
>     feature bit in x86_cpu_enable_xsave_components().
> 
>     Then it's safe to drop the check on XSAVES feature support during
>     CPUID 0XD encoding.
> 
> Suggested-by: Zide Chen <zide.chen@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/cpu.c | 22 ++++++++++------------
>   1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 236a2f3a9426..5b7a81fcdb1b 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8174,16 +8174,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>               *ebx = xsave_area_size(xstate, true);
>               *ecx = env->features[FEAT_XSAVE_XSS_LO];
>               *edx = env->features[FEAT_XSAVE_XSS_HI];
> -            if (kvm_enabled() && cpu->enable_pmu &&
> -                (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR) &&
> -                (*eax & CPUID_XSAVE_XSAVES)) {
> -                *ecx |= XSTATE_ARCH_LBR_MASK;
> -            } else {
> -                *ecx &= ~XSTATE_ARCH_LBR_MASK;
> -            }

> -        } else if (count == 0xf && cpu->enable_pmu
> -                   && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
> -            x86_cpu_get_supported_cpuid(0xD, count, eax, ebx, ecx, edx);

This chunk needs to be a separate patch. It's a functional change.

>           } else if (count < ARRAY_SIZE(x86_ext_save_areas)) {
>               const ExtSaveArea *esa = &x86_ext_save_areas[count];
>   
> @@ -8902,6 +8892,12 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
>   
>       mask = 0;
>       for (i = 0; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
> +        /* Skip supervisor states if XSAVES is not supported. */
> +        if (CPUID_XSTATE_XSS_MASK & (1 << i) &&
> +            !(env->features[FEAT_XSAVE] & CPUID_XSAVE_XSAVES)) {
> +            continue;
> +        }
> +
>           const ExtSaveArea *esa = &x86_ext_save_areas[i];
>           if (cpuid_has_xsave_feature(env, esa)) {
>               mask |= (1ULL << i);
> @@ -9019,11 +9015,13 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>           }
>       }
>   
> -    if (!cpu->pdcm_on_even_without_pmu) {
> +    if (!cpu->enable_pmu) {
>           /* PDCM is fixed1 bit for TDX */
> -        if (!cpu->enable_pmu && !is_tdx_vm()) {
> +        if (!cpu->pdcm_on_even_without_pmu && !is_tdx_vm()) {
>               env->features[FEAT_1_ECX] &= ~CPUID_EXT_PDCM;
>           }
> +
> +        env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_LBR;
>       }
>   
>       for (i = 0; i < ARRAY_SIZE(feature_dependencies); i++) {


