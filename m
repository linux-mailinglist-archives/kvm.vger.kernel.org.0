Return-Path: <kvm+bounces-68449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F625D39BEA
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 02:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 441A53009858
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 01:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D51B1C860C;
	Mon, 19 Jan 2026 01:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GoAIJAMa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1563022097
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 01:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768785890; cv=none; b=VIphqTdAf9OxULpr86jhGnIOsSc1VPqA1w/rZC+olSCJwkz4ig+zpmO6nQWwI0Aa2qMOV34uI0KXffxxC75qPkAvPwHxPB6KMp2DZQKG35WGhFoXllls7zc9A35ejcKcQsGNHhzjIuesCbAvNlaApv0pU2ZWn4oKYZJ7bm+6QcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768785890; c=relaxed/simple;
	bh=gzqyxXcr5hyOxWRuli4p9sdhoS/UBnm1DG1wuWcx49A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ToeAnaOQAqoNVfRSpDvq6+QezbX7xbgU808Mx1I5r5aqLyeihNIxG1wZMMXT1+cAvXf/9MWRPXGIeuSVHshqnEKf/ODUBXdVgmRDekaD110ymslvWpZwHA/2vgBq57rIYrTEDtVUlm2uWedOTV+kwUg2lgYynaeoBV2qVLjoICI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GoAIJAMa; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768785888; x=1800321888;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gzqyxXcr5hyOxWRuli4p9sdhoS/UBnm1DG1wuWcx49A=;
  b=GoAIJAMa0XRPklA+UTRJieeapjPeT4fqBrlpQtu/578tHJX7ayXUAYJt
   p0e0Gll0g2rPhmOE5eOjDKp35JACCWI7IFeospiyjdf6LyNXzHKnlJ99o
   OO76rbwLar/Ey78+SE4v3EvtM2cbnHhbnLgTaTDqaBibnxefzDKCPFq/x
   uu0gy2a6cH82yTYBaKd/Ba03y17wR39WB9GmkKQlfJj7elzGmT2cYTysx
   d02ThL6fFkwvNuwTudWUzONUTROzhzR9w0ZF3LVKhFXSQBKcz4g0qlJTW
   LkZCwFq96uBjOAlydyKC4rJWblKmhDa4EsF2tcvXAXt+fJfl456XIsh8w
   w==;
X-CSE-ConnectionGUID: ECt7Ws0dQeqvTddvSR+CqA==
X-CSE-MsgGUID: RQ9tOT5ERx61Tan6tdG9bA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="73626888"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="73626888"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 17:24:47 -0800
X-CSE-ConnectionGUID: G9QgKvaTS+u4t1vjFh7k5Q==
X-CSE-MsgGUID: 1HSsfGxlS7q6VJD2YF2RAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="210222664"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.14]) ([10.124.240.14])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 17:24:42 -0800
Message-ID: <9d4a646b-bd05-4210-8124-9b49150649be@linux.intel.com>
Date: Mon, 19 Jan 2026 09:24:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 4/5] target/i386/kvm: reset AMD PMU registers during VM
 reset
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com,
 ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com, zide.chen@intel.com
References: <20260109075508.113097-1-dongli.zhang@oracle.com>
 <20260109075508.113097-5-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260109075508.113097-5-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 1/9/2026 3:53 PM, Dongli Zhang wrote:
> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
> and kvm_put_msrs() to restore them to KVM. However, there is no support for
> AMD PMU registers. Currently, pmu_version and num_pmu_gp_counters are
> initialized based on cpuid(0xa), which does not apply to AMD processors.
> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
> is determined based on the CPU version.
>
> To address this issue, we need to add support for AMD PMU registers.
> Without this support, the following problems can arise:
>
> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
>
> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
>
> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
>
> 4. After a reboot, the VM kernel may report the following error:
>
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
>
> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
>
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Modify "MSR_K7_EVNTSEL0 + 3" and "MSR_K7_PERFCTR0 + 3" by using
>     AMD64_NUM_COUNTERS (suggested by Sandipan Das).
>   - Use "AMD64_NUM_COUNTERS_CORE * 2 - 1", not "MSR_F15H_PERF_CTL0 + 0xb".
>     (suggested by Sandipan Das).
>   - Switch back to "-pmu" instead of using a global "pmu-cap-disabled".
>   - Don't initialize PMU info if kvm.enable_pmu=N.
> Changed since v2:
>   - Remove 'static' from host_cpuid_vendorX.
>   - Change has_pmu_version to pmu_version.
>   - Use object_property_get_int() to get CPU family.
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Send error log when host and guest are from different vendors.
>   - Move "if (!cpu->enable_pmu)" to begin of function. Add comments to
>     reminder developers.
>   - Add support to Zhaoxin. Change is_same_vendor() to
>     is_host_compat_vendor().
>   - Didn't add Reviewed-by from Sandipan because the change isn't minor.
> Changed since v3:
>   - Use host_cpu_vendor_fms() from Zhao's patch.
>   - Check AMD directly makes the "compat" rule clear.
>   - Add comment to MAX_GP_COUNTERS.
>   - Skip PMU info initialization if !kvm_pmu_disabled.
> Changed since v4:
>   - Add Reviewed-by from Zhao and Sandipan.
> Changed since v6:
>   - Add Reviewed-by from Dapeng Mi.
> Changed since v8:
>   - Remove the usage of 'kvm_pmu_disabled' as sussged by Zide Chen.
>   - Remove Reviewed-by from Zhao Liu, Sandipan Das and Dapeng Mi, as the
>     usage of 'kvm_pmu_disabled' is removed.
>
>  target/i386/cpu.h     |  12 +++
>  target/i386/kvm/kvm.c | 168 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 176 insertions(+), 4 deletions(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 2bbc977d90..0960b98960 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -506,6 +506,14 @@ typedef enum X86Seg {
>  #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>  #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>  
> +#define MSR_K7_EVNTSEL0                 0xc0010000
> +#define MSR_K7_PERFCTR0                 0xc0010004
> +#define MSR_F15H_PERF_CTL0              0xc0010200
> +#define MSR_F15H_PERF_CTR0              0xc0010201
> +
> +#define AMD64_NUM_COUNTERS              4
> +#define AMD64_NUM_COUNTERS_CORE         6
> +
>  #define MSR_MC0_CTL                     0x400
>  #define MSR_MC0_STATUS                  0x401
>  #define MSR_MC0_ADDR                    0x402
> @@ -1737,6 +1745,10 @@ typedef struct {
>  #endif
>  
>  #define MAX_FIXED_COUNTERS 3
> +/*
> + * This formula is based on Intel's MSR. The current size also meets AMD's
> + * needs.
> + */
>  #define MAX_GP_COUNTERS    (MSR_IA32_PERF_STATUS - MSR_P6_EVNTSEL0)
>  
>  #define NB_OPMASK_REGS 8
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 3b803c662d..fb7b672a9d 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2096,7 +2096,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>      return 0;
>  }
>  
> -static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
> +static void kvm_init_pmu_info_intel(struct kvm_cpuid2 *cpuid)
>  {
>      struct kvm_cpuid_entry2 *c;
>  
> @@ -2129,6 +2129,89 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
>      }
>  }
>  
> +static void kvm_init_pmu_info_amd(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
> +{
> +    struct kvm_cpuid_entry2 *c;
> +    int64_t family;
> +
> +    family = object_property_get_int(OBJECT(cpu), "family", NULL);
> +    if (family < 0) {
> +        return;
> +    }
> +
> +    if (family < 6) {
> +        error_report("AMD performance-monitoring is supported from "
> +                     "K7 and later");
> +        return;
> +    }
> +
> +    pmu_version = 1;
> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS;
> +
> +    c = cpuid_find_entry(cpuid, 0x80000001, 0);
> +    if (!c) {
> +        return;
> +    }
> +
> +    if (!(c->ecx & CPUID_EXT3_PERFCORE)) {
> +        return;
> +    }
> +
> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +}
> +
> +static bool is_host_compat_vendor(CPUX86State *env)
> +{
> +    char host_vendor[CPUID_VENDOR_SZ + 1];
> +
> +    host_cpu_vendor_fms(host_vendor, NULL, NULL, NULL);
> +
> +    /*
> +     * Intel and Zhaoxin are compatible.
> +     */
> +    if ((g_str_equal(host_vendor, CPUID_VENDOR_INTEL) ||
> +         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN1) ||
> +         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN2)) &&
> +        (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
> +        return true;
> +    }
> +
> +    return g_str_equal(host_vendor, CPUID_VENDOR_AMD) &&
> +           IS_AMD_CPU(env);
> +}
> +
> +static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
> +{
> +    CPUX86State *env = &cpu->env;
> +
> +    /*
> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
> +     * disable the AMD PMU virtualization.
> +     *
> +     * Assume the user is aware of this when !cpu->enable_pmu. AMD PMU
> +     * registers are not going to reset, even they are still available to
> +     * guest VM.
> +     */
> +    if (!cpu->enable_pmu) {
> +        return;
> +    }
> +
> +    /*
> +     * It is not supported to virtualize AMD PMU registers on Intel
> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
> +     */
> +    if (!is_host_compat_vendor(env)) {
> +        error_report("host doesn't support requested feature: vPMU");
> +        return;
> +    }
> +
> +    if (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) {
> +        kvm_init_pmu_info_intel(cpuid);
> +    } else if (IS_AMD_CPU(env)) {
> +        kvm_init_pmu_info_amd(cpuid, cpu);
> +    }
> +}
> +
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2319,7 +2402,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
>  
> -    kvm_init_pmu_info(&cpuid_data.cpuid);
> +    kvm_init_pmu_info(&cpuid_data.cpuid, cpu);
>  
>      if (x86_cpu_family(env->cpuid_version) >= 6
>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
> @@ -4094,7 +4177,7 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>              kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>          }
>  
> -        if (pmu_version > 0) {
> +        if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
>              if (pmu_version > 1) {
>                  /* Stop the counter.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> @@ -4125,6 +4208,38 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>                                    env->msr_global_ctrl);
>              }
>          }
> +
> +        if (IS_AMD_CPU(env) && pmu_version > 0) {
> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
> +            /*
> +             * The address of the next selector or counter register is
> +             * obtained by incrementing the address of the current selector
> +             * or counter register by one.
> +             */
> +            uint32_t step = 1;
> +
> +            /*
> +             * When PERFCORE is enabled, AMD PMU uses a separate set of
> +             * addresses for the selector and counter registers.
> +             * Additionally, the address of the next selector or counter
> +             * register is determined by incrementing the address of the
> +             * current register by two.
> +             */
> +            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +                sel_base = MSR_F15H_PERF_CTL0;
> +                ctr_base = MSR_F15H_PERF_CTR0;
> +                step = 2;
> +            }
> +
> +            for (i = 0; i < num_pmu_gp_counters; i++) {
> +                kvm_msr_entry_add(cpu, ctr_base + i * step,
> +                                  env->msr_gp_counters[i]);
> +                kvm_msr_entry_add(cpu, sel_base + i * step,
> +                                  env->msr_gp_evtsel[i]);
> +            }
> +        }
> +
>          /*
>           * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>           * only sync them to KVM on the first cpu
> @@ -4629,7 +4744,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>      if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
> -    if (pmu_version > 0) {
> +
> +    if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
>          if (pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> @@ -4645,6 +4761,35 @@ static int kvm_get_msrs(X86CPU *cpu)
>          }
>      }
>  
> +    if (IS_AMD_CPU(env) && pmu_version > 0) {
> +        uint32_t sel_base = MSR_K7_EVNTSEL0;
> +        uint32_t ctr_base = MSR_K7_PERFCTR0;
> +        /*
> +         * The address of the next selector or counter register is
> +         * obtained by incrementing the address of the current selector
> +         * or counter register by one.
> +         */
> +        uint32_t step = 1;
> +
> +        /*
> +         * When PERFCORE is enabled, AMD PMU uses a separate set of
> +         * addresses for the selector and counter registers.
> +         * Additionally, the address of the next selector or counter
> +         * register is determined by incrementing the address of the
> +         * current register by two.
> +         */
> +        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +            sel_base = MSR_F15H_PERF_CTL0;
> +            ctr_base = MSR_F15H_PERF_CTR0;
> +            step = 2;
> +        }
> +
> +        for (i = 0; i < num_pmu_gp_counters; i++) {
> +            kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
> +            kvm_msr_entry_add(cpu, sel_base + i * step, 0);
> +        }
> +    }
> +
>      if (env->mcg_cap) {
>          kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>          kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
> @@ -4975,6 +5120,21 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>              env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>              break;
> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + AMD64_NUM_COUNTERS - 1:
> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
> +            break;
> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + AMD64_NUM_COUNTERS - 1:
> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
> +            break;
> +        case MSR_F15H_PERF_CTL0 ...
> +             MSR_F15H_PERF_CTL0 + AMD64_NUM_COUNTERS_CORE * 2 - 1:
> +            index = index - MSR_F15H_PERF_CTL0;
> +            if (index & 0x1) {
> +                env->msr_gp_counters[index] = msrs[i].data;
> +            } else {
> +                env->msr_gp_evtsel[index] = msrs[i].data;
> +            }
> +            break;
>          case HV_X64_MSR_HYPERCALL:
>              env->msr_hv_hypercall = msrs[i].data;
>              break;

The Intel related code looks good to me. Let AMD part to Sandipan. Thanks.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



