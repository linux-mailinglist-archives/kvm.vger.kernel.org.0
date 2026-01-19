Return-Path: <kvm+bounces-68459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B8DAD39CB3
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 04:11:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6C5230081A9
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 03:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F47023EAA4;
	Mon, 19 Jan 2026 03:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VTx53R+x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7535B1E32CF
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 03:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768792287; cv=none; b=oYqII7dYWYHrmUQg89OvczT4Wm0oc1fmypZNvcbhyJR6bJs4Pz5/rVdoek/5Qi2nqCle77MXX4FEGyYcURnGgC6hs8LmhebhVot+6Rw7ab0H1PgLlMkjjBQoQmJensJ2qpqDdMK9D92NxVAn5IbwyIfeNT9zRI0ITHIQfXt7GMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768792287; c=relaxed/simple;
	bh=K1sx3BAKiFng90kP/ICSmlmjhduH54u+7BGcWd2QHFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T6v4mbIHWCSILUf9Inyh+lAfpzBJ5M91Tpo3dSGJv3WYp7teclhnYHkYGye3ypBFF9O/UhAFEcaYYWZ/DyWCyROkmdc7ozBJJkaHRtx2krT2SPqxzX1yvCoyGeMO71SWryCQ2HgqorP0qnCkG7ijx8bTd1FcQ/841QqiGFZqzDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VTx53R+x; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768792285; x=1800328285;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K1sx3BAKiFng90kP/ICSmlmjhduH54u+7BGcWd2QHFQ=;
  b=VTx53R+xvZc1z+Zg5Ol4AUmv0ZwlA5VaLTxuB2NQuLkoBbpMMiyOjAWV
   FJw2hYTBkaiPqhR3pAsbLQjacOa0wB7k+AJuNS+jBRSn07/vIG/qckias
   v8iKK9dtwoPzVKQM2YG4adnW8ewgv9kDHVDWBd/NGb7UanyeLDPcGFH+d
   B+48OWBr68v5Kq/OGo/FjAcP/7Fv+OYrO3o6qenE9qKZiYEYqt8gSrRSe
   IW+FRlgEDjGV407r3sj1Si+JSXc8Mybvb81IlkO7Nqc2o0L94qdbgXPsh
   TMfhrb6klS5THUlJpZFZEgXs5DRsLpmrbTI0RdNr7JUJIJw0Fd81DAayf
   g==;
X-CSE-ConnectionGUID: TrfVXZ4uQ4i3wCJwUbJNMg==
X-CSE-MsgGUID: tKYZhq/TSM2sq8v3BNfwBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69976530"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69976530"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 19:11:25 -0800
X-CSE-ConnectionGUID: pq4w/BB0TdmRE9okeyn6Qg==
X-CSE-MsgGUID: VXs1+OQFTb+HGudxMhdzlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="205366230"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.14]) ([10.124.240.14])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 19:11:22 -0800
Message-ID: <be80ed86-1d4f-4115-bff8-812df7083b7f@linux.intel.com>
Date: Mon, 19 Jan 2026 11:11:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] target/i386: Support full-width writes for perf
 counters
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
 <20260117011053.80723-5-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260117011053.80723-5-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 1/17/2026 9:10 AM, Zide Chen wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>
> If IA32_PERF_CAPABILITIES.FW_WRITE (bit 13) is set, each general-
> purpose counter IA32_PMCi (starting at 0xc1) is accompanied by a
> corresponding alias MSR starting at 0x4c1 (IA32_A_PMC0), which are
> 64-bit wide.
>
> The legacy IA32_PMCi MSRs are not full-width and their effective width
> is determined by CPUID.0AH:EAX[23:16].
>
> Since these two sets of MSRs are aliases, when IA32_A_PMCi is supported
> it is safe to use it for save/restore instead of the legacy MSRs,
> regardless of whether the hypervisor uses the legacy or the 64-bit
> counterpart.
>
> Full-width write is a user-visible feature and can be disabled
> individually.
>
> Reduce MAX_GP_COUNTERS from 18 to 15 to avoid conflicts between the
> full-width MSR range and MSR_MCG_EXT_CTL.  Current CPUs support at most
> 10 general-purpose counters, so 15 is sufficient for now and leaves room
> for future expansion.
>
> Bump minimum_version_id to avoid migration from older QEMU, as this may
> otherwise cause VMState overflow. This also requires bumping version_id,
> which prevents migration to older QEMU as well.
>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
>  target/i386/cpu.h     |  5 ++++-
>  target/i386/kvm/kvm.c | 19 +++++++++++++++++--
>  target/i386/machine.c |  4 ++--
>  3 files changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 0b480c631ed0..e7cf4a7bd594 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -421,6 +421,7 @@ typedef enum X86Seg {
>  
>  #define MSR_IA32_PERF_CAPABILITIES      0x345
>  #define PERF_CAP_LBR_FMT                0x3f
> +#define PERF_CAP_FULL_WRITE             (1U << 13)
>  
>  #define MSR_IA32_TSX_CTRL		0x122
>  #define MSR_IA32_TSCDEADLINE            0x6e0
> @@ -448,6 +449,8 @@ typedef enum X86Seg {
>  #define MSR_IA32_SGXLEPUBKEYHASH3       0x8f
>  
>  #define MSR_P6_PERFCTR0                 0xc1
> +/* Alternative perfctr range with full access. */
> +#define MSR_IA32_PMC0                   0x4c1
>  
>  #define MSR_IA32_SMBASE                 0x9e
>  #define MSR_SMI_COUNT                   0x34
> @@ -1740,7 +1743,7 @@ typedef struct {
>  #endif
>  
>  #define MAX_FIXED_COUNTERS 3
> -#define MAX_GP_COUNTERS    (MSR_IA32_PERF_STATUS - MSR_P6_EVNTSEL0)
> +#define MAX_GP_COUNTERS    15

I suppose this is good enough for AMD CPUs, but need AMD guys to double
confirm. Thanks.


>  
>  #define NB_OPMASK_REGS 8
>  
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index e81fa46ed66c..530f50e4b218 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4049,6 +4049,12 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>          }
>  
>          if (has_architectural_pmu_version > 0) {
> +            uint32_t perf_cntr_base = MSR_P6_PERFCTR0;
> +
> +            if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_FULL_WRITE) {
> +                perf_cntr_base = MSR_IA32_PMC0;
> +            }
> +
>              if (has_architectural_pmu_version > 1) {
>                  /* Stop the counter.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> @@ -4061,7 +4067,7 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>                                    env->msr_fixed_counters[i]);
>              }
>              for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> -                kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i,
> +                kvm_msr_entry_add(cpu, perf_cntr_base + i,
>                                    env->msr_gp_counters[i]);
>                  kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i,
>                                    env->msr_gp_evtsel[i]);
> @@ -4582,6 +4588,12 @@ static int kvm_get_msrs(X86CPU *cpu)
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
>      if (has_architectural_pmu_version > 0) {
> +        uint32_t perf_cntr_base = MSR_P6_PERFCTR0;
> +
> +        if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_FULL_WRITE) {
> +            perf_cntr_base = MSR_IA32_PMC0;
> +        }
> +
>          if (has_architectural_pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> @@ -4591,7 +4603,7 @@ static int kvm_get_msrs(X86CPU *cpu)
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
>          }
>          for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> -            kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i, 0);
> +            kvm_msr_entry_add(cpu, perf_cntr_base + i, 0);
>              kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i, 0);
>          }
>      }
> @@ -4920,6 +4932,9 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR0 + MAX_GP_COUNTERS - 1:
>              env->msr_gp_counters[index - MSR_P6_PERFCTR0] = msrs[i].data;
>              break;
> +        case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + MAX_GP_COUNTERS - 1:
> +            env->msr_gp_counters[index - MSR_IA32_PMC0] = msrs[i].data;
> +            break;
>          case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>              env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>              break;
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 1125c8a64ec5..7d08a05835fc 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -685,8 +685,8 @@ static bool pmu_enable_needed(void *opaque)
>  
>  static const VMStateDescription vmstate_msr_architectural_pmu = {
>      .name = "cpu/msr_architectural_pmu",
> -    .version_id = 1,
> -    .minimum_version_id = 1,
> +    .version_id = 2,
> +    .minimum_version_id = 2,
>      .needed = pmu_enable_needed,
>      .fields = (const VMStateField[]) {
>          VMSTATE_UINT64(env.msr_fixed_ctr_ctrl, X86CPU),

