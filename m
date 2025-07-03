Return-Path: <kvm+bounces-51379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08A25AF6B32
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 140C44E3503
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DECB1F0E4B;
	Thu,  3 Jul 2025 07:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mt51tAOh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2085129A9
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751526930; cv=none; b=RgzUGb1KAQG9EF/K23LB5Ef6s+7BI/V6JAuZLS6/p6Ct24M4ZCwFgsQwnWtbpUB3kXkBA43zXfy1ovsZSpYjlyjXsqT4vRGszg9SIxFDr7nzfVSCuOfflbff3QwZCsDkmGI+a7zKUSoImVT80vEs5VVt91BmNsPqyMTuBsFb/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751526930; c=relaxed/simple;
	bh=sEhMyh7ACkcJdENP3Uqt+6GOmATUkVCYwXQABZ6A4kQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B4yLm8ots8xnY49+6hoRv4qvRiXeFc1u4RUQrxsv1SyWS240jz2H5eVZ+wRndd8Fpl+3mYVdokeCxkQQUhyiNSHRorwA69d4MOhniIzHTMsMRBJQ+IAz5sbcuLPkgI3chZn6N5w0CH1okl5L7w9gbqCM9t9neGaYMBdzFvlI92c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mt51tAOh; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751526929; x=1783062929;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sEhMyh7ACkcJdENP3Uqt+6GOmATUkVCYwXQABZ6A4kQ=;
  b=mt51tAOhLln3SRSOt5DXu12ZVjOxbh1UWgaUKx7k/WmjfknVaPZ1pzEE
   OI+i09ucMR4/3ggym6FHR2hjCDj0eTqK+zVJaUnOCJvIuuGushIow6+Vy
   8v8753muFFqoGmjhDHL2U+rW4P2rv4dibB5b9v7kaw0bapTBHc8OSMXjE
   87nooSSpOj8R08Chht4t8TACQ3Zh3oOo7x8YBGpLj4WRegSXU8lEaM+6V
   mHonUkxCzq7avr0owhJYcpVY/PIDKiA0EAWGpzu/3L4gi1qgywsuOeu9P
   sLmV/dpno2Edv47D87DBZ3vznpiPVPeQ5orYfxYN+QnyFjI4/M82moNMQ
   Q==;
X-CSE-ConnectionGUID: MUin8/IGSI62d82aKr3tSQ==
X-CSE-MsgGUID: hIdHWCJRSd+o0Mv7g/pUag==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64437336"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64437336"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:15:29 -0700
X-CSE-ConnectionGUID: d/2L23pDTSeJZL/b6YqqaA==
X-CSE-MsgGUID: nJ3OZbkPRTSFV7vWdwVhuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="185315215"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:15:24 -0700
Message-ID: <42641bcb-67b8-4c06-900c-378593e74d6b@linux.intel.com>
Date: Thu, 3 Jul 2025 15:15:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/16] i386/cpu: Add legacy_intel_cache_info cache model
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
 Pu Wen <puwen@hygon.cn>, Tao Su <tao1.su@intel.com>,
 Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-10-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-10-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> Based on legacy_l1d_cache, legacy_l1i_cache, legacy_l2_cache and
> legacy_l3_cache, build a complete legacy intel cache model, which can
> clarify the purpose of these trivial legacy cache models, simplify the
> initialization of cache info in X86CPUState, and make it easier to
> handle compatibility later.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 101 +++++++++++++++++++++++++---------------------
>  1 file changed, 54 insertions(+), 47 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 0b292aa2e07b..ec229830c532 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -643,21 +643,6 @@ static void encode_topo_cpuid8000001e(X86CPU *cpu, X86CPUTopoInfo *topo_info,
>   * These are legacy cache values. If there is a need to change any
>   * of these values please use builtin_x86_defs
>   */
> -
> -/* L1 data cache: */
> -static CPUCacheInfo legacy_l1d_cache = {
> -    .type = DATA_CACHE,
> -    .level = 1,
> -    .size = 32 * KiB,
> -    .self_init = 1,
> -    .line_size = 64,
> -    .associativity = 8,
> -    .sets = 64,
> -    .partitions = 1,
> -    .no_invd_sharing = true,
> -    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> -};
> -
>  static CPUCacheInfo legacy_l1d_cache_amd = {
>      .type = DATA_CACHE,
>      .level = 1,
> @@ -672,20 +657,6 @@ static CPUCacheInfo legacy_l1d_cache_amd = {
>      .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>  };
>  
> -/* L1 instruction cache: */
> -static CPUCacheInfo legacy_l1i_cache = {
> -    .type = INSTRUCTION_CACHE,
> -    .level = 1,
> -    .size = 32 * KiB,
> -    .self_init = 1,
> -    .line_size = 64,
> -    .associativity = 8,
> -    .sets = 64,
> -    .partitions = 1,
> -    .no_invd_sharing = true,
> -    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> -};
> -
>  static CPUCacheInfo legacy_l1i_cache_amd = {
>      .type = INSTRUCTION_CACHE,
>      .level = 1,
> @@ -700,20 +671,6 @@ static CPUCacheInfo legacy_l1i_cache_amd = {
>      .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>  };
>  
> -/* Level 2 unified cache: */
> -static CPUCacheInfo legacy_l2_cache = {
> -    .type = UNIFIED_CACHE,
> -    .level = 2,
> -    .size = 4 * MiB,
> -    .self_init = 1,
> -    .line_size = 64,
> -    .associativity = 16,
> -    .sets = 4096,
> -    .partitions = 1,
> -    .no_invd_sharing = true,
> -    .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> -};
> -
>  static CPUCacheInfo legacy_l2_cache_amd = {
>      .type = UNIFIED_CACHE,
>      .level = 2,
> @@ -803,6 +760,59 @@ static const CPUCaches legacy_intel_cpuid2_cache_info = {
>      },
>  };
>  
> +static const CPUCaches legacy_intel_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .self_init = 1,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .sets = 64,
> +        .partitions = 1,
> +        .no_invd_sharing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .self_init = 1,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .sets = 64,
> +        .partitions = 1,
> +        .no_invd_sharing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l2_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 2,
> +        .size = 4 * MiB,
> +        .self_init = 1,
> +        .line_size = 64,
> +        .associativity = 16,
> +        .sets = 4096,
> +        .partitions = 1,
> +        .no_invd_sharing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l3_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 3,
> +        .size = 16 * MiB,
> +        .line_size = 64,
> +        .associativity = 16,
> +        .sets = 16384,
> +        .partitions = 1,
> +        .lines_per_tag = 1,
> +        .self_init = true,
> +        .inclusive = true,
> +        .complex_indexing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
> +    },
> +};
> +
>  /* TLB definitions: */
>  
>  #define L1_DTLB_2M_ASSOC       1
> @@ -8971,10 +8981,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>              env->enable_legacy_cpuid2_cache = true;
>          }
>  
> -        env->cache_info_cpuid4.l1d_cache = &legacy_l1d_cache;
> -        env->cache_info_cpuid4.l1i_cache = &legacy_l1i_cache;
> -        env->cache_info_cpuid4.l2_cache = &legacy_l2_cache;
> -        env->cache_info_cpuid4.l3_cache = &legacy_l3_cache;
> +        env->cache_info_cpuid4 = legacy_intel_cache_info;
>  
>          env->cache_info_amd.l1d_cache = &legacy_l1d_cache_amd;
>          env->cache_info_amd.l1i_cache = &legacy_l1i_cache_amd;

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



