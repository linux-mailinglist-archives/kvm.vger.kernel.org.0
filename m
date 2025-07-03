Return-Path: <kvm+bounces-51377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5D9AF6B12
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8DF017A65E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD27C2951DD;
	Thu,  3 Jul 2025 07:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/hh9gIp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715EE6AA7
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751526463; cv=none; b=a3i4VvFWXuxo+JSknQaLfKqLTDV12ypJK01bw3b4adLw/REdPgGlkCtbvIg2AzqPXTZwiP9jeHZZiVJTz0JZVTlEDpIgp9zlUez7najKrM6bajh4W1osrTWMhnhLOHgJnlUaR2e3aYXtD3RwLC9sJ5u5VeCU0SBLs/FvyvePBNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751526463; c=relaxed/simple;
	bh=yhwYOjrKq9ebGmZR+FPGnDwzlieY5n9LStWiPQOmj6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DWgfe5AkiGnSjqKA8+Vaj3xsTNHSqK2WtzcYivalj4Q8q/WLCTEhE5Gpbqo+5GY/iQ129QJPRoJCjfaZMC8is2dpbHqfaPvml/ZUPGhNcgWZDfweh81fm4K88t51wKexhfqD1SptwBScR7VPTnlr7rD5oMXXY95y6/vH7wb7kUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l/hh9gIp; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751526461; x=1783062461;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yhwYOjrKq9ebGmZR+FPGnDwzlieY5n9LStWiPQOmj6U=;
  b=l/hh9gIpKu9mAT0X9pzLOZcFLIMqTyCJCNOEKL5/8g9vlJMftKYfnqii
   fPIv6KTVZ4y20zt8cWafw6ybB4OGI5pOSrzYqeaT9ppqwhDNXSckHsqy4
   rB6eBpnwDkD/77dF42biTJiQ2tLpxC1+XKGit8hXu8FKk36mi2rI8shHd
   2Fs8Z72nLQkq5Rvktjwj72/bhwMhxUgN9UyUEwlX1yELHVvJcQ7VWkOgf
   CFBt+MJjB1+s/W7jfuU6bnajnR2K5ycvYUXFFxLU/YiY5v6vCllG1kvVv
   RqnymZzc6oK146hEqpo0Jt8aUibm9JWAxUvrfBZDIAJ966lSh1LKxj30q
   g==;
X-CSE-ConnectionGUID: phrtrvh6TcKXgg32sMqmNg==
X-CSE-MsgGUID: /+wkT1H2SUignL5aN0RdsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53560553"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="53560553"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:07:41 -0700
X-CSE-ConnectionGUID: P2P8NYlaQfCrKV2v+DWr9g==
X-CSE-MsgGUID: UwQDhg03RpGOCpROJUYAXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="154778852"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:07:37 -0700
Message-ID: <44cdc08c-21e9-422c-b55a-17e53d34ef90@linux.intel.com>
Date: Thu, 3 Jul 2025 15:07:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/16] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
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
 <20250620092734.1576677-8-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-8-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> Per SDM, 0x80000005 leaf is reserved for Intel CPU, and its current
> "assert" check blocks adding new cache model for non-AMD CPUs.
>
> And please note, although Zhaoxin mostly follows Intel behavior,
> this leaf is an exception [1].
>
> So, add a compat property "x-vendor-cpuid-only-v2" (for PC machine v10.0
> and older) to keep the original behavior. For the machine since v10.1,
> check the vendor and encode this leaf as all-0 only for Intel CPU.
>
> This fix also resolves 2 FIXMEs of legacy_l1d_cache_amd and
> legacy_l1i_cache_amd:
>
> /*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
>
> In addition, per AMD's APM, update the comment of CPUID[0x80000005].
>
> [1]: https://lore.kernel.org/qemu-devel/fa16f7a8-4917-4731-9d9f-7d4c10977168@zhaoxin.com/
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since RFC:
>  * Only set all-0 for Intel CPU.
>  * Add x-vendor-cpuid-only-v2.
> ---
>  hw/i386/pc.c      |  1 +
>  target/i386/cpu.c | 11 ++++++++---
>  target/i386/cpu.h | 11 ++++++++++-
>  3 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index ad2d6495ebde..9ec3f4db31f3 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -83,6 +83,7 @@
>  
>  GlobalProperty pc_compat_10_0[] = {
>      { TYPE_X86_CPU, "x-consistent-cache", "false" },
> +    { TYPE_X86_CPU, "x-vendor-cpuid-only-v2", "false" },
>  };
>  const size_t pc_compat_10_0_len = G_N_ELEMENTS(pc_compat_10_0);
>  
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 8f174fb971b6..df40d1362566 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -655,7 +655,6 @@ static CPUCacheInfo legacy_l1d_cache = {
>      .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>  };
>  
> -/*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
>  static CPUCacheInfo legacy_l1d_cache_amd = {
>      .type = DATA_CACHE,
>      .level = 1,
> @@ -684,7 +683,6 @@ static CPUCacheInfo legacy_l1i_cache = {
>      .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>  };
>  
> -/*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
>  static CPUCacheInfo legacy_l1i_cache_amd = {
>      .type = INSTRUCTION_CACHE,
>      .level = 1,
> @@ -7889,11 +7887,17 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          *edx = env->cpuid_model[(index - 0x80000002) * 4 + 3];
>          break;
>      case 0x80000005:
> -        /* cache info (L1 cache) */
> +        /* cache info (L1 cache/TLB Associativity Field) */
>          if (cpu->cache_info_passthrough) {
>              x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
>              break;
>          }
> +
> +        if (cpu->vendor_cpuid_only_v2 && IS_INTEL_CPU(env)) {
> +            *eax = *ebx = *ecx = *edx = 0;
> +            break;
> +        }
> +
>          *eax = (L1_DTLB_2M_ASSOC << 24) | (L1_DTLB_2M_ENTRIES << 16) |
>                 (L1_ITLB_2M_ASSOC <<  8) | (L1_ITLB_2M_ENTRIES);
>          *ebx = (L1_DTLB_4K_ASSOC << 24) | (L1_DTLB_4K_ENTRIES << 16) |
> @@ -9464,6 +9468,7 @@ static const Property x86_cpu_properties[] = {
>      DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
>      DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
>      DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
> +    DEFINE_PROP_BOOL("x-vendor-cpuid-only-v2", X86CPU, vendor_cpuid_only_v2, true),
>      DEFINE_PROP_BOOL("x-amd-topoext-features-only", X86CPU, amd_topoext_features_only, true),
>      DEFINE_PROP_BOOL("lmce", X86CPU, enable_lmce, false),
>      DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 8d3ce8a2b678..02cda176798f 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2282,9 +2282,18 @@ struct ArchCPU {
>      /* Enable auto level-increase for all CPUID leaves */
>      bool full_cpuid_auto_level;
>  
> -    /* Only advertise CPUID leaves defined by the vendor */
> +    /*
> +     * Compatibility bits for old machine types (PC machine v6.0 and older).
> +     * Only advertise CPUID leaves defined by the vendor.
> +     */
>      bool vendor_cpuid_only;
>  
> +    /*
> +     * Compatibility bits for old machine types (PC machine v10.0 and older).
> +     * Only advertise CPUID leaves defined by the vendor.
> +     */
> +    bool vendor_cpuid_only_v2;
> +
>      /* Only advertise TOPOEXT features that AMD defines */
>      bool amd_topoext_features_only;
>  

The Intel related part looks good to me. (Not quite familiar with AMD's
Spec, so no reviewed-by tag)



