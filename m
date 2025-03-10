Return-Path: <kvm+bounces-40584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD0E2A58CE4
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:27:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00DA9166386
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3EB1DB34B;
	Mon, 10 Mar 2025 07:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X8hfUn64"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C8C1D6DA1
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 07:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741591618; cv=none; b=A75KJ5MfLr27IhRRml7WUmnQCaPyyaksD6lQ6ikdk6tTLZT675kvS8MY7jfExzQaamVFgYYl7Mrzkprp2+Vo2S20XiGG03EdtN7AsXHHpIAicIiQBHBczExgLutU3xWUYIWGQzFGYAaI98PKXPIOaQHlIfYBnmz38UEjKerqUww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741591618; c=relaxed/simple;
	bh=dtga0v/Ir792RWLzkgeY1Rc/Z50MXyKQb9VMOzOY2JY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAqP0q7A8IYMprhIlquzwDtVx5Liq5IrpnaszGDS62GsuBYAa8IXejSOlrXekQTdhySxL8qzWwlaUOTVaghFFTmyu4r+veAb6n6HR+dgWqJYjCtT6Z1K4y8Fmf2Dtt7RIWpJNuYfSS4ZLrmvLrU8PnDwI022ntRm3wT8Tc5td3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X8hfUn64; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741591617; x=1773127617;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dtga0v/Ir792RWLzkgeY1Rc/Z50MXyKQb9VMOzOY2JY=;
  b=X8hfUn64RilfnVBAXHIzgMoHVocg46KhPlJ0iSjt1q2hz+ZxZQ9hAmUA
   H9/eRRNv8IothPCHOlJRs6f9iEM8g/1eT9LfH7lVrlvDqLRangVmgZLxl
   jKy6VTSkvbrUHMq6chVISLIfSGt/osO0vzyfTpb13J+xPRcrvTzzeDsqS
   2iH1xHAnpWoxx2u1YaxGjDwMEovsppB2ar/Y8W5xbsNeHJqY4plzDPfeq
   rku+YAstRUS75n9MazNyE2hAn0cPHa1YU8y8RBmvrXiuNGQhFjs9eU1tu
   DKj81XAqQZWL1TuvKOGvEZYgY6/LUoLRz+cnV73YsxzS+XrqdDKPUeMLx
   w==;
X-CSE-ConnectionGUID: feNdCoJZRuark56jok315g==
X-CSE-MsgGUID: 8p8OZ5jSR0urOv5a+Sql5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42285202"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42285202"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:26:55 -0700
X-CSE-ConnectionGUID: UW5bvEmlSIKwTZYALKXqew==
X-CSE-MsgGUID: mf5ohgmBSwKbuNOWYs58tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="124508499"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa005.fm.intel.com with ESMTP; 10 Mar 2025 00:26:50 -0700
Date: Mon, 10 Mar 2025 15:47:00 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	ewanhai-oc@zhaoxin.com
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
Message-ID: <Z86Y9BxV6p25A2Wo@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302220112.17653-9-dongli.zhang@oracle.com>

(+EwanHai for zhaoxin case...)

...

> -static void kvm_init_pmu_info(CPUX86State *env)
> +static void kvm_init_pmu_info_intel(CPUX86State *env)
>  {
>      uint32_t eax, edx;
>      uint32_t unused;
> @@ -2106,6 +2106,94 @@ static void kvm_init_pmu_info(CPUX86State *env)
>      }
>  }
>  
> +static void kvm_init_pmu_info_amd(CPUX86State *env)
> +{
> +    uint32_t unused;
> +    int64_t family;
> +    uint32_t ecx;
> +
> +    has_pmu_version = 0;
> +
> +    /*
> +     * To determine the CPU family, the following code is derived from
> +     * x86_cpuid_version_get_family().
> +     */
> +    family = (env->cpuid_version >> 8) & 0xf;
> +    if (family == 0xf) {
> +        family += (env->cpuid_version >> 20) & 0xff;
> +    }
> +
> +    /*
> +     * Performance-monitoring supported from K7 and later.
> +     */
> +    if (family < 6) {
> +        return;
> +    }

I understand we can get family by object_property_get_int() helper:

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4902694129f9..ff08c7bfee6c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2106,27 +2106,22 @@ static void kvm_init_pmu_info_intel(CPUX86State *env)
     }
 }

-static void kvm_init_pmu_info_amd(CPUX86State *env)
+static void kvm_init_pmu_info_amd(X86CPU *cpu)
 {
+    CPUX86State *env = &cpu->env;
     uint32_t eax, ebx, ecx;
     uint32_t unused;
     int64_t family;

     has_pmu_version = 0;

-    /*
-     * To determine the CPU family, the following code is derived from
-     * x86_cpuid_version_get_family().
-     */
-    family = (env->cpuid_version >> 8) & 0xf;
-    if (family == 0xf) {
-        family += (env->cpuid_version >> 20) & 0xff;
+    family = object_property_get_int(OBJECT(cpu), "family", &error_abort);
+    if (family < 0) {
+        return;
     }

-    /*
-     * Performance-monitoring supported from K7 and later.
-     */
     if (family < 6) {
+        error_report("AMD performance-monitoring is supported from K7 and later")
         return;
     }

@@ -2197,7 +2192,7 @@ static void kvm_init_pmu_info(CPUState *cs)
     if (IS_INTEL_CPU(env)) {
         kvm_init_pmu_info_intel(env);
     } else if (IS_AMD_CPU(env)) {
-        kvm_init_pmu_info_amd(env);
+        kvm_init_pmu_info_amd(cpu);
     }
 }

---
Then for consistency, kvm_init_pmu_info_intel() could also accept
"X86CPU *cpu" as the argument.

> +    has_pmu_version = 1;
> +
> +    cpu_x86_cpuid(env, 0x80000001, 0, &unused, &unused, &ecx, &unused);
> +
> +    if (!(ecx & CPUID_EXT3_PERFCORE)) {
> +        num_pmu_gp_counters = AMD64_NUM_COUNTERS;
> +        return;
> +    }
> +
> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +}

...

> +static void kvm_init_pmu_info(CPUState *cs)
> +{
> +    X86CPU *cpu = X86_CPU(cs);
> +    CPUX86State *env = &cpu->env;
> +
> +    /*
> +     * The PMU virtualization is disabled by kvm.enable_pmu=N.
> +     */
> +    if (kvm_pmu_disabled) {
> +        return;
> +    }

As I said in patch 7, we could return an error instead.

> +    /*
> +     * It is not supported to virtualize AMD PMU registers on Intel
> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
> +     */
> +    if (!is_same_vendor(env)) {

Here it deserves a warning like:

error_report("host doesn't support requested feature: vPMU\n");

> +        return;
> +    }
>
> +    /*
> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
> +     * disable the AMD pmu virtualization.
> +     *
> +     * If KVM_CAP_PMU_CAPABILITY is supported !cpu->enable_pmu
> +     * indicates the KVM has already disabled the PMU virtualization.
> +     */
> +    if (has_pmu_cap && !cpu->enable_pmu) {
> +        return;
> +    }

Could we only check "cpu->enable_pmu" at the beginning of this function?
then if pmu is already disabled, we don't need to initialize the pmu info.

> +    if (IS_INTEL_CPU(env)) {

Zhaoxin also supports architectural PerfMon in 0xa.

I'm not sure if this check should also involve Zhaoxin CPU, so cc
zhaoxin guys for double check.

> +        kvm_init_pmu_info_intel(env);
> +    } else if (IS_AMD_CPU(env)) {
> +        kvm_init_pmu_info_amd(env);
> +    }
> +}
> +
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2288,7 +2376,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
>  
> -    kvm_init_pmu_info(env);
> +    kvm_init_pmu_info(cs);
>  
>      if (((env->cpuid_version >> 8)&0xF) >= 6
>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
> @@ -4064,7 +4152,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>              kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>          }
>  
> -        if (has_pmu_version > 0) {
> +        if (IS_INTEL_CPU(env) && has_pmu_version > 0) {

ditto.

>              if (has_pmu_version > 1) {
>                  /* Stop the counter.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> @@ -4095,6 +4183,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                                    env->msr_global_ctrl);
>              }
>          }
> +

...

>          /*
>           * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>           * only sync them to KVM on the first cpu
> @@ -4542,7 +4662,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>      if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
> -    if (has_pmu_version > 0) {
> +
> +    if (IS_INTEL_CPU(env) && has_pmu_version > 0) {

ditto.

>          if (has_pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> @@ -4558,6 +4679,35 @@ static int kvm_get_msrs(X86CPU *cpu)
>          }
>      }
>

Thanks,
Zhao



