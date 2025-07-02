Return-Path: <kvm+bounces-51251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4FCAF096E
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 617967A928E
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B571D7E41;
	Wed,  2 Jul 2025 03:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OwGda6u2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A9A53A7
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 03:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751428341; cv=none; b=Gp4rY0ldJQPJqo/NSjlwGZSZvgESoVLPk7nWOoXrfcNAqTroiIio9BtBWp3bTk+caJVhILQkxoyWPxKLloY0DHV3KWCrdKgLCQymQw5dDaSHEzjCsWIKkAPDe79tTfGm0yX5z009QfMsGBmrCimu7LzaRj4Bg3ELRjfXpfIyoQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751428341; c=relaxed/simple;
	bh=ijwJ+PlLJaAwgiDKAbcCgBAxgNGVERXIgFbmZkE6Sfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nBiYjk7ZwiJmr1N+vNU7qGnj2sdEwoT9nCPhEL+ctFMePNf5TCNcYNhUw/rWanIrojpuezqgHRJZL0vZdSkMG8y6Us8AKUKl/anDnHSOoHm3NjpZq08KwLqfAWFvlo3Yn3Hcv8VkysPS7enxjmdFTLweTH6783yVSVF7kuYwh3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OwGda6u2; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751428339; x=1782964339;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ijwJ+PlLJaAwgiDKAbcCgBAxgNGVERXIgFbmZkE6Sfs=;
  b=OwGda6u2SyvOf4oibDerkapXsmZJUdpNXkOyvRkeiM1Z/1ICShHmlerX
   wq+w8C66M16bcMOec0zhgDjf4K6STz5tcfxcwGRTeABEQBOWvEXiX59vG
   03IaB1feOBfUhCqJ7NVohAcV536Fxg9ez8hD8gLMcDqLO4CRRqu/kT9u0
   kAyenti9CXRK2iv3yWx7jMBDjYWMC2GuCN92vkyqZmCKp3j36qhjCn6kI
   GUxixho5zB/62jEjaWOMEc8n1Qy3GSuMHXnR7mMNHF8nVR+IonP/eYgaN
   i+JaE0BD1CcitPzOU+2qP7P5PU+RpQvY6goFc/F48Jl4GI/FFJrPtIJwH
   Q==;
X-CSE-ConnectionGUID: YxRdarniQ3O16aSwSYJV+Q==
X-CSE-MsgGUID: 9H62qcRUTaGnr1kNkNirSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="53670778"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="53670778"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:52:17 -0700
X-CSE-ConnectionGUID: Q/nhgqerQCmOc4CQjnPDTg==
X-CSE-MsgGUID: 7U9qfPclTiW0lCR+Y7KYfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="154278881"
Received: from jiatingt-mobl.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:52:13 -0700
Message-ID: <59fb1bc6-e3d6-4865-87f0-ed7182caaee5@linux.intel.com>
Date: Wed, 2 Jul 2025 11:52:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] target/i386/kvm: extract unrelated code out of
 kvm_x86_build_cpuid()
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com,
 ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com
References: <20250624074421.40429-1-dongli.zhang@oracle.com>
 <20250624074421.40429-5-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250624074421.40429-5-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/24/2025 3:43 PM, Dongli Zhang wrote:
> The initialization of 'has_architectural_pmu_version',
> 'num_architectural_pmu_gp_counters', and
> 'num_architectural_pmu_fixed_counters' is unrelated to the process of
> building the CPUID.
>
> Extract them out of kvm_x86_build_cpuid().
>
> In addition, use cpuid_find_entry() instead of cpu_x86_cpuid(), because
> CPUID has already been filled at this stage.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changed since v1:
>   - Still extract the code, but call them for all CPUs.
> Changed since v2:
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Didn't add Reviewed-by from Dapeng as the change isn't minor.
>
>  target/i386/kvm/kvm.c | 62 ++++++++++++++++++++++++-------------------
>  1 file changed, 35 insertions(+), 27 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 15155b79b5..4baaa069b8 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1968,33 +1968,6 @@ uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
>          }
>      }
>  
> -    if (limit >= 0x0a) {
> -        uint32_t eax, edx;
> -
> -        cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
> -
> -        has_architectural_pmu_version = eax & 0xff;
> -        if (has_architectural_pmu_version > 0) {
> -            num_architectural_pmu_gp_counters = (eax & 0xff00) >> 8;
> -
> -            /* Shouldn't be more than 32, since that's the number of bits
> -             * available in EBX to tell us _which_ counters are available.
> -             * Play it safe.
> -             */
> -            if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
> -                num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
> -            }
> -
> -            if (has_architectural_pmu_version > 1) {
> -                num_architectural_pmu_fixed_counters = edx & 0x1f;
> -
> -                if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
> -                    num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
> -                }
> -            }
> -        }
> -    }
> -
>      cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
>  
>      for (i = 0x80000000; i <= limit; i++) {
> @@ -2098,6 +2071,39 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>      return 0;
>  }
>  
> +static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
> +{
> +    struct kvm_cpuid_entry2 *c;
> +
> +    c = cpuid_find_entry(cpuid, 0xa, 0);
> +
> +    if (!c) {
> +        return;
> +    }
> +
> +    has_architectural_pmu_version = c->eax & 0xff;
> +    if (has_architectural_pmu_version > 0) {
> +        num_architectural_pmu_gp_counters = (c->eax & 0xff00) >> 8;
> +
> +        /*
> +         * Shouldn't be more than 32, since that's the number of bits
> +         * available in EBX to tell us _which_ counters are available.
> +         * Play it safe.
> +         */
> +        if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
> +            num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
> +        }
> +
> +        if (has_architectural_pmu_version > 1) {
> +            num_architectural_pmu_fixed_counters = c->edx & 0x1f;
> +
> +            if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
> +                num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
> +            }
> +        }
> +    }
> +}
> +
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2288,6 +2294,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
>  
> +    kvm_init_pmu_info(&cpuid_data.cpuid);
> +
>      if (((env->cpuid_version >> 8)&0xF) >= 6
>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
>             (CPUID_MCE | CPUID_MCA)) {

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>




