Return-Path: <kvm+bounces-68453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB08AD39C2E
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 03:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92BF530057DE
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 02:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1654B21E091;
	Mon, 19 Jan 2026 02:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bS4Eg/u7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F91DF26E
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 02:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768788144; cv=none; b=jdihmL9BaLwSqHjMaVVEMUJQYwWPV0z7NVGgPYYZ7UbT5aDznYBorhfBfQK8lkHfuFgwLyuJln6uFCqzKeDmCMbZegqp18ffxXqHFUVNTBGuFQEM6K039R072/paieHHW94g5RETfQnnstVO5WmjekqtR1+QxmkhK3Swg5VATno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768788144; c=relaxed/simple;
	bh=3wDWTskNBuEFL+W/N1MD6bW9dCDN1qyL975rH+2XUZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P5TXjM3RAXXJU/3b4MhbEk43nA22Hs6dDdHEgKBXMOmXGViDdMKEVCK31mviv3hWPLZ/vkeZFw+JPKrpM96+EkGeCBSYmSd7j07fkWxgZs0ZLwLEJcevt5p59zLzik0j5pwLA7Na8zsknpW5TDNHd8b+RY8WK/V1b1CPV4QS37E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bS4Eg/u7; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768788142; x=1800324142;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3wDWTskNBuEFL+W/N1MD6bW9dCDN1qyL975rH+2XUZs=;
  b=bS4Eg/u7OJKRwPFHMWevzy6coBUV4c8Kypw17p43EQT2HVz3By3BwRVB
   ImKfzOz6BvCh/DYcf+YMEtBS3swNYWXC8xShq0DJT5ncWcsKFlwFupz41
   xgrS34DTFCduGRDJuasg3ijkMWV4ve3dOjM4Oxzjq3OJDNAx/oDMZVGGX
   k/xhpEziV7W//ne2WGNAlCG66/7zx/vuu4sUzFc4E0E7TlELTm+dCdp6+
   vPP8vGkqSSYH+tKekE5m9GddKL97E+kiwKazcCTo9GthDBaEUJJaFeEsF
   KVAcngpT4eZZ9a2M9yb02x+gmp8XDNreoQuRHlwgcldItotK8zAmtz9Eq
   w==;
X-CSE-ConnectionGUID: YAYtzFgsSB+lQt8apBW96w==
X-CSE-MsgGUID: 9yntsmhWQd2toWFzyERd1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="70165192"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="70165192"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 18:02:21 -0800
X-CSE-ConnectionGUID: 8nzoHSV8RbeIbug7x0bmRg==
X-CSE-MsgGUID: DCoGKgYZTRywTlZy0sNVFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="210240722"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.14]) ([10.124.240.14])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 18:02:19 -0800
Message-ID: <eb2c185b-9edc-4ef7-b71b-5cc3fed3827c@linux.intel.com>
Date: Mon, 19 Jan 2026 10:02:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] target/i386: Gate enable_pmu on kvm_enabled()
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
 <20260117011053.80723-4-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260117011053.80723-4-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 1/17/2026 9:10 AM, Zide Chen wrote:
> Guest PMU support requires KVM.  Clear cpu->enable_pmu when KVM is not
> enabled, so PMU-related code can rely solely on cpu->enable_pmu.
>
> This reduces duplication and avoids bugs where one of the checks is
> missed.  For example, cpu_x86_cpuid() enables CPUID.0AH when
> cpu->enable_pmu is set but does not check kvm_enabled(). This is
> implicitly fixed by this patch:
>
> if (cpu->enable_pmu) {
> 	x86_cpu_get_supported_cpuid(0xA, count, eax, ebx, ecx, edx);
> }
>
> Also fix two places that check kvm_enabled() but not cpu->enable_pmu.
>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
>  target/i386/cpu.c     | 9 ++++++---
>  target/i386/kvm/kvm.c | 4 ++--
>  2 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 37803cd72490..f1ac98970d3e 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8671,7 +8671,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          *ecx = 0;
>          *edx = 0;
>          if (!(env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) ||
> -            !kvm_enabled()) {
> +            !cpu->enable_pmu) {
>              break;
>          }
>  
> @@ -9018,7 +9018,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>      case 0x80000022:
>          *eax = *ebx = *ecx = *edx = 0;
>          /* AMD Extended Performance Monitoring and Debug */
> -        if (kvm_enabled() && cpu->enable_pmu &&
> +        if (cpu->enable_pmu &&
>              (env->features[FEAT_8000_0022_EAX] & CPUID_8000_0022_EAX_PERFMON_V2)) {
>              *eax |= CPUID_8000_0022_EAX_PERFMON_V2;
>              *ebx |= kvm_arch_get_supported_cpuid(cs->kvm_state, index, count,
> @@ -9642,7 +9642,7 @@ static bool x86_cpu_filter_features(X86CPU *cpu, bool verbose)
>       * are advertised by cpu_x86_cpuid().  Keep these two in sync.
>       */
>      if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) &&
> -        kvm_enabled()) {
> +        cpu->enable_pmu) {
>          x86_cpu_get_supported_cpuid(0x14, 0,
>                                      &eax_0, &ebx_0, &ecx_0, &edx_0);
>          x86_cpu_get_supported_cpuid(0x14, 1,
> @@ -9790,6 +9790,9 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>      Error *local_err = NULL;
>      unsigned requested_lbr_fmt;
>  
> +    if (!kvm_enabled())
> +	    cpu->enable_pmu = false;
> +
>  #if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
>      /* Use pc-relative instructions in system-mode */
>      tcg_cflags_set(cs, CF_PCREL);
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index cffbc90d1c50..e81fa46ed66c 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4222,7 +4222,7 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>                                env->msr_xfd_err);
>          }
>  
> -        if (kvm_enabled() && cpu->enable_pmu &&
> +        if (cpu->enable_pmu &&
>              (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
>              uint64_t depth;
>              int ret;
> @@ -4698,7 +4698,7 @@ static int kvm_get_msrs(X86CPU *cpu)
>          kvm_msr_entry_add(cpu, MSR_IA32_XFD_ERR, 0);
>      }
>  
> -    if (kvm_enabled() && cpu->enable_pmu &&
> +    if (cpu->enable_pmu &&
>          (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
>          uint64_t depth;
>  

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



