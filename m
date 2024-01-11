Return-Path: <kvm+bounces-6055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F1482A753
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 06:54:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A6461F241E1
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 05:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80F423AD;
	Thu, 11 Jan 2024 05:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hpBHtJ9S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD1D20FA
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 05:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704952443; x=1736488443;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sAoUH8ZBvemh/CjIaJFZIR8239N0TlWDc3kD6VlGl7c=;
  b=hpBHtJ9SE5taMhqrc81FL6W7bAtCSaWfFw7WMLNxUhVJCDO5P6ji4hWj
   rghiNQke1V/Jp24FQldgFgJHr7gAjWH45teZkXj3QdpxfOs+P26izlrkX
   cSyOhQud1v5Ferpj3qqbRx9AfAyUJ/FhuW05UkkiPjKN+08B+2JMMAsHX
   0ja20GSG85yDWPidugVtYJK25tG7hhZyuXos+ecfiRhVh+gsP7jjDn7NR
   ZqtZC+FG2OCqe6ZkXUoRYRVibE4MXlj6TXiYxCqUzVmQQqXx1OzXly5dr
   LMFnbURXB/FlNT5lWINt9sNsuh/dHxA+by5W4OCy34Y/7alNEMBIwTGqk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="6105133"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="6105133"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 21:54:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="758642311"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="758642311"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 21:53:57 -0800
Message-ID: <866a3a37-cba8-425c-9d9b-57ad05b16bc4@intel.com>
Date: Thu, 11 Jan 2024 13:53:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/16] i386: Support modules_per_die in X86CPUTopoInfo
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-8-zhao1.liu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240108082727.420817-8-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/2024 4:27 PM, Zhao Liu wrote:
> From: Zhuocheng Ding <zhuocheng.ding@intel.com>
> 
> Support module level in i386 cpu topology structure "X86CPUTopoInfo".
> 
> Since x86 does not yet support the "clusters" parameter in "-smp",
> X86CPUTopoInfo.modules_per_die is currently always 1. Therefore, the
> module level width in APIC ID, which can be calculated by
> "apicid_bitwidth_for_count(topo_info->modules_per_die)", is always 0
> for now, so we can directly add APIC ID related helpers to support
> module level parsing.
> 
> In addition, update topology structure in test-x86-topo.c.
> 
> Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Babu Moger <babu.moger@amd.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> Changes since v3:
>   * Drop the description about not exposing module level in commit
>     message.
>   * Update topology related calculation in newly added helpers:
>     num_cpus_by_topo_level() and apicid_offset_by_topo_level().
> 
> Changes since v1:
>   * Include module level related helpers (apicid_module_width() and
>     apicid_module_offset()) in this patch. (Yanan)
> ---
>   hw/i386/x86.c              |  3 ++-
>   include/hw/i386/topology.h | 22 +++++++++++++++----
>   target/i386/cpu.c          | 17 +++++++++-----
>   tests/unit/test-x86-topo.c | 45 ++++++++++++++++++++------------------
>   4 files changed, 55 insertions(+), 32 deletions(-)
> 
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index 1d19a8c609b1..85b847ac7914 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -72,7 +72,8 @@ static void init_topo_info(X86CPUTopoInfo *topo_info,
>       MachineState *ms = MACHINE(x86ms);
>   
>       topo_info->dies_per_pkg = ms->smp.dies;
> -    topo_info->cores_per_die = ms->smp.cores;
> +    topo_info->modules_per_die = ms->smp.clusters;
> +    topo_info->cores_per_module = ms->smp.cores;
>       topo_info->threads_per_core = ms->smp.threads;
>   }
>   
> diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
> index d4eeb7ab8290..517e51768c13 100644
> --- a/include/hw/i386/topology.h
> +++ b/include/hw/i386/topology.h
> @@ -56,7 +56,8 @@ typedef struct X86CPUTopoIDs {
>   
>   typedef struct X86CPUTopoInfo {
>       unsigned dies_per_pkg;
> -    unsigned cores_per_die;
> +    unsigned modules_per_die;
> +    unsigned cores_per_module;
>       unsigned threads_per_core;
>   } X86CPUTopoInfo;
>   
> @@ -77,7 +78,13 @@ static inline unsigned apicid_smt_width(X86CPUTopoInfo *topo_info)
>   /* Bit width of the Core_ID field */
>   static inline unsigned apicid_core_width(X86CPUTopoInfo *topo_info)
>   {
> -    return apicid_bitwidth_for_count(topo_info->cores_per_die);
> +    return apicid_bitwidth_for_count(topo_info->cores_per_module);
> +}
> +
> +/* Bit width of the Module_ID (cluster ID) field */
> +static inline unsigned apicid_module_width(X86CPUTopoInfo *topo_info)
> +{
> +    return apicid_bitwidth_for_count(topo_info->modules_per_die);
>   }
>   
>   /* Bit width of the Die_ID field */
> @@ -92,10 +99,16 @@ static inline unsigned apicid_core_offset(X86CPUTopoInfo *topo_info)
>       return apicid_smt_width(topo_info);
>   }
>   
> +/* Bit offset of the Module_ID (cluster ID) field */
> +static inline unsigned apicid_module_offset(X86CPUTopoInfo *topo_info)
> +{
> +    return apicid_core_offset(topo_info) + apicid_core_width(topo_info);
> +}
> +
>   /* Bit offset of the Die_ID field */
>   static inline unsigned apicid_die_offset(X86CPUTopoInfo *topo_info)
>   {
> -    return apicid_core_offset(topo_info) + apicid_core_width(topo_info);
> +    return apicid_module_offset(topo_info) + apicid_module_width(topo_info);
>   }
>   
>   /* Bit offset of the Pkg_ID (socket ID) field */
> @@ -127,7 +140,8 @@ static inline void x86_topo_ids_from_idx(X86CPUTopoInfo *topo_info,
>                                            X86CPUTopoIDs *topo_ids)
>   {
>       unsigned nr_dies = topo_info->dies_per_pkg;
> -    unsigned nr_cores = topo_info->cores_per_die;
> +    unsigned nr_cores = topo_info->cores_per_module *
> +                        topo_info->modules_per_die;
>       unsigned nr_threads = topo_info->threads_per_core;
>   
>       topo_ids->pkg_id = cpu_index / (nr_dies * nr_cores * nr_threads);
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 0a2ce9b92b1f..294ca6b8947a 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -278,10 +278,11 @@ static uint32_t num_cpus_by_topo_level(X86CPUTopoInfo *topo_info,
>       case CPU_TOPO_LEVEL_CORE:
>           return topo_info->threads_per_core;
>       case CPU_TOPO_LEVEL_DIE:
> -        return topo_info->threads_per_core * topo_info->cores_per_die;
> +        return topo_info->threads_per_core * topo_info->cores_per_module *
> +               topo_info->modules_per_die;
>       case CPU_TOPO_LEVEL_PACKAGE:
> -        return topo_info->threads_per_core * topo_info->cores_per_die *
> -               topo_info->dies_per_pkg;
> +        return topo_info->threads_per_core * topo_info->cores_per_module *
> +               topo_info->modules_per_die * topo_info->dies_per_pkg;
>       default:
>           g_assert_not_reached();
>       }
> @@ -450,7 +451,9 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>   
>       /* L3 is shared among multiple cores */
>       if (cache->level == 3) {
> -        l3_threads = topo_info->cores_per_die * topo_info->threads_per_core;
> +        l3_threads = topo_info->modules_per_die *
> +                     topo_info->cores_per_module *
> +                     topo_info->threads_per_core;
>           *eax |= (l3_threads - 1) << 14;
>       } else {
>           *eax |= ((topo_info->threads_per_core - 1) << 14);
> @@ -6131,10 +6134,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>       uint32_t cpus_per_pkg;
>   
>       topo_info.dies_per_pkg = env->nr_dies;
> -    topo_info.cores_per_die = cs->nr_cores / env->nr_dies;
> +    topo_info.modules_per_die = env->nr_modules;
> +    topo_info.cores_per_module = cs->nr_cores / env->nr_dies / env->nr_modules;
>       topo_info.threads_per_core = cs->nr_threads;
>   
> -    cores_per_pkg = topo_info.cores_per_die * topo_info.dies_per_pkg;
> +    cores_per_pkg = topo_info.cores_per_module * topo_info.modules_per_die *
> +                    topo_info.dies_per_pkg;

Nit. maybe we can introduce some helper function like

static inline uint32_t topo_info_cores_per_pkg(X86CPUTopoInfo *topo_info) {
	return topo_info.cores_per_module * topo_info.modules_per_die *
                topo_info.dies_per_pkg;
}

so we don't need to care how it calculates.

Besides,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>       cpus_per_pkg = cores_per_pkg * topo_info.threads_per_core;
>   
>       /* Calculate & apply limits for different index ranges */
> diff --git a/tests/unit/test-x86-topo.c b/tests/unit/test-x86-topo.c
> index 2b104f86d7c2..f21b8a5d95c2 100644
> --- a/tests/unit/test-x86-topo.c
> +++ b/tests/unit/test-x86-topo.c
> @@ -30,13 +30,16 @@ static void test_topo_bits(void)
>   {
>       X86CPUTopoInfo topo_info = {0};
>   
> -    /* simple tests for 1 thread per core, 1 core per die, 1 die per package */
> -    topo_info = (X86CPUTopoInfo) {1, 1, 1};
> +    /*
> +     * simple tests for 1 thread per core, 1 core per module,
> +     *                  1 module per die, 1 die per package
> +     */
> +    topo_info = (X86CPUTopoInfo) {1, 1, 1, 1};
>       g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 0);
>       g_assert_cmpuint(apicid_core_width(&topo_info), ==, 0);
>       g_assert_cmpuint(apicid_die_width(&topo_info), ==, 0);
>   
> -    topo_info = (X86CPUTopoInfo) {1, 1, 1};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 1, 1};
>       g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 0), ==, 0);
>       g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 1), ==, 1);
>       g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 2), ==, 2);
> @@ -45,39 +48,39 @@ static void test_topo_bits(void)
>   
>       /* Test field width calculation for multiple values
>        */
> -    topo_info = (X86CPUTopoInfo) {1, 1, 2};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 1, 2};
>       g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 1);
> -    topo_info = (X86CPUTopoInfo) {1, 1, 3};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 1, 3};
>       g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 2);
> -    topo_info = (X86CPUTopoInfo) {1, 1, 4};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 1, 4};
>       g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 2);
>   
> -    topo_info = (X86CPUTopoInfo) {1, 1, 14};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 1, 14};
>       g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 4);
> -    topo_info = (X86CPUTopoInfo) {1, 1, 15};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 1, 15};
>       g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 4);
> -    topo_info = (X86CPUTopoInfo) {1, 1, 16};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 1, 16};
>       g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 4);
> -    topo_info = (X86CPUTopoInfo) {1, 1, 17};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 1, 17};
>       g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 5);
>   
>   
> -    topo_info = (X86CPUTopoInfo) {1, 30, 2};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 30, 2};
>       g_assert_cmpuint(apicid_core_width(&topo_info), ==, 5);
> -    topo_info = (X86CPUTopoInfo) {1, 31, 2};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 31, 2};
>       g_assert_cmpuint(apicid_core_width(&topo_info), ==, 5);
> -    topo_info = (X86CPUTopoInfo) {1, 32, 2};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 32, 2};
>       g_assert_cmpuint(apicid_core_width(&topo_info), ==, 5);
> -    topo_info = (X86CPUTopoInfo) {1, 33, 2};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 33, 2};
>       g_assert_cmpuint(apicid_core_width(&topo_info), ==, 6);
>   
> -    topo_info = (X86CPUTopoInfo) {1, 30, 2};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 30, 2};
>       g_assert_cmpuint(apicid_die_width(&topo_info), ==, 0);
> -    topo_info = (X86CPUTopoInfo) {2, 30, 2};
> +    topo_info = (X86CPUTopoInfo) {2, 1, 30, 2};
>       g_assert_cmpuint(apicid_die_width(&topo_info), ==, 1);
> -    topo_info = (X86CPUTopoInfo) {3, 30, 2};
> +    topo_info = (X86CPUTopoInfo) {3, 1, 30, 2};
>       g_assert_cmpuint(apicid_die_width(&topo_info), ==, 2);
> -    topo_info = (X86CPUTopoInfo) {4, 30, 2};
> +    topo_info = (X86CPUTopoInfo) {4, 1, 30, 2};
>       g_assert_cmpuint(apicid_die_width(&topo_info), ==, 2);
>   
>       /* build a weird topology and see if IDs are calculated correctly
> @@ -85,18 +88,18 @@ static void test_topo_bits(void)
>   
>       /* This will use 2 bits for thread ID and 3 bits for core ID
>        */
> -    topo_info = (X86CPUTopoInfo) {1, 6, 3};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 6, 3};
>       g_assert_cmpuint(apicid_smt_width(&topo_info), ==, 2);
>       g_assert_cmpuint(apicid_core_offset(&topo_info), ==, 2);
>       g_assert_cmpuint(apicid_die_offset(&topo_info), ==, 5);
>       g_assert_cmpuint(apicid_pkg_offset(&topo_info), ==, 5);
>   
> -    topo_info = (X86CPUTopoInfo) {1, 6, 3};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 6, 3};
>       g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 0), ==, 0);
>       g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 1), ==, 1);
>       g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 2), ==, 2);
>   
> -    topo_info = (X86CPUTopoInfo) {1, 6, 3};
> +    topo_info = (X86CPUTopoInfo) {1, 1, 6, 3};
>       g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 1 * 3 + 0), ==,
>                        (1 << 2) | 0);
>       g_assert_cmpuint(x86_apicid_from_cpu_idx(&topo_info, 1 * 3 + 1), ==,


