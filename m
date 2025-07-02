Return-Path: <kvm+bounces-51280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8F0AF10AF
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17CDC1898E72
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A9AF248F58;
	Wed,  2 Jul 2025 09:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VkXv1Jep"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57FF245038
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 09:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751450002; cv=none; b=Utuvoj3cwpmY5J3pWCfCcWTsHrfDHJVZpJ1GbBINNqg68Gxb8vxpDkIoHoMGeHeUEO4UGVnCb5NE2q0lYhbJhDukjeX7aHKBoJvnjMebYSxvRkruS9onSoIHrRN/y9zwu7khauUwQlt/NGCt3/1RfA/N9LowafGONlaELwNXhZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751450002; c=relaxed/simple;
	bh=xsYSFyWfUP4dM60KShwxzL7P0YUz5LJGiSX5HfsrnFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=orZw90wCwNzaGN35Ky3gL6Ruh1i2oNvxFMfTm3CNiWzggDEM1HOveWu/XnTqwzk+OsYmBZML9ujETtczgg4FPbtO9zbh/YG/fa7KswvAvFPB/S9/10GHrgOihQHN1PMfaDZAQBHMpikdZWtz6XIz0mjFFZsmbQyIPg94YspfJ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VkXv1Jep; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751450001; x=1782986001;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xsYSFyWfUP4dM60KShwxzL7P0YUz5LJGiSX5HfsrnFc=;
  b=VkXv1JepUFpWBEG5dsb0bWgVLKxVqOl/1/yY0QSvWGWitb/OyXUD4yqO
   VqHgt9yY8zdJ43rdEaK5isGZ7uyl7F5u9MD6qm49H8qfZLnYshJsgHq/b
   ZCQ7n5WX9MEUwg9e8b+hqeHnBQh1RRroVfig0an2TL7pqrdifEHQGoLZq
   rMa7QR59sXI30EIV6r0MplbFpnyjNBomk6FQAkw47PkL4m8p1FjqNyV07
   HkGNY1XXmlUToSywu9F0wnn8x3d9pe075MQ0HzDPjcZv0jkaWhY+RyrX1
   /WAlYt4kmWbz2BrBhbKdb5q5FDEa18lA++7M6QGCvAiMmI7rB10q7xdcN
   g==;
X-CSE-ConnectionGUID: qu+pfXaARkiUupVbE9+b7g==
X-CSE-MsgGUID: /X/oDfsQTRa78c/RwEJ+Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="41366767"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="41366767"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:53:18 -0700
X-CSE-ConnectionGUID: Up+UuLpWRlWJglhROrKgsA==
X-CSE-MsgGUID: 0Dj1I1MSSpO91+cMObr0Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153486819"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:53:14 -0700
Message-ID: <c93dce97-735b-4a1d-b766-f882e53eb50e@linux.intel.com>
Date: Wed, 2 Jul 2025 17:53:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] i386/cpu: Add default cache model for Intel CPUs
 with level < 4
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
 <20250620092734.1576677-4-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-4-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> Old Intel CPUs with CPUID level < 4, use CPUID 0x2 leaf (if available)
> to encode cache information.
>
> Introduce a cache model "legacy_intel_cpuid2_cache_info" for the CPUs
> with CPUID level < 4, based on legacy_l1d_cache, legacy_l1i_cache,
> legacy_l2_cache_cpuid2 and legacy_l3_cache. But for L2 cache, this
> cache model completes self_init, sets, partitions, no_invd_sharing and
> share_level fields, referring legacy_l2_cache, to avoid someone
> increases CPUID level manually and meets assert() error. But the cache
> information present in CPUID 0x2 leaf doesn't change.
>
> This new cache model makes it possible to remove legacy_l2_cache_cpuid2
> in X86CPUState and help to clarify historical cache inconsistency issue.
>
> Furthermore, apply this legacy cache model to all Intel CPUs with CPUID
> level < 4. This includes not only "pentium2" and "pentium3" (which have
> 0x2 leaf), but also "486" and "pentium" (which only have 0x1 leaf, and
> cache model won't be presented, just for simplicity).
>
> A legacy_intel_cpuid2_cache_info cache model doesn't change the cache
> information of the above CPUs, because they just depend on 0x2 leaf.
>
> Only when someone adjusts the min-level to >=4 will the cache
> information in CPUID leaf 4 differ from before: previously, the L2
> cache information in CPUID leaf 0x2 and 0x4 was different, but now with
> legacy_intel_cpuid2_cache_info, the information they present will be
> consistent. This case almost never happens, emulating a CPUID that is
> not supported by the "ancient" hardware is itself meaningless behavior.
>
> Therefore, even though there's the above difference (for really rare
> case) and considering these old CPUs ("486", "pentium", "pentium2" and
> "pentium3") won't be used for migration, there's no need to add new
> versioned CPU models
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 995766c9d74c..0a2c32214cc3 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -710,6 +710,67 @@ static CPUCacheInfo legacy_l3_cache = {
>      .share_level = CPU_TOPOLOGY_LEVEL_DIE,
>  };
>  
> +/*
> + * Only used for the CPU models with CPUID level < 4.
> + * These CPUs (CPUID level < 4) only use CPUID leaf 2 to present
> + * cache information.
> + *
> + * Note: This cache model is just a default one, and is not
> + *       guaranteed to match real hardwares.
> + */
> +static const CPUCaches legacy_intel_cpuid2_cache_info = {
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
> +        .size = 2 * MiB,
> +        .self_init = 1,
> +        .line_size = 64,
> +        .associativity = 8,
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

Does this cache information match the real legacy HW or just an emulation
of Qemu?


> +};
> +
>  /* TLB definitions: */
>  
>  #define L1_DTLB_2M_ASSOC       1
> @@ -3043,6 +3104,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              I486_FEATURES,
>          .xlevel = 0,
>          .model_id = "",
> +        .cache_info = &legacy_intel_cpuid2_cache_info,
>      },
>      {
>          .name = "pentium",
> @@ -3055,6 +3117,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              PENTIUM_FEATURES,
>          .xlevel = 0,
>          .model_id = "",
> +        .cache_info = &legacy_intel_cpuid2_cache_info,
>      },
>      {
>          .name = "pentium2",
> @@ -3067,6 +3130,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              PENTIUM2_FEATURES,
>          .xlevel = 0,
>          .model_id = "",
> +        .cache_info = &legacy_intel_cpuid2_cache_info,
>      },
>      {
>          .name = "pentium3",
> @@ -3079,6 +3143,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              PENTIUM3_FEATURES,
>          .xlevel = 0,
>          .model_id = "",
> +        .cache_info = &legacy_intel_cpuid2_cache_info,
>      },
>      {
>          .name = "athlon",

