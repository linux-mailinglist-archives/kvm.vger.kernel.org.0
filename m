Return-Path: <kvm+bounces-51363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BF6AAF6909
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EDDB4E7FB8
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 04:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5AF28B4EA;
	Thu,  3 Jul 2025 04:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lzONe2aa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230A017BA3
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 04:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751516093; cv=none; b=pwpYIIiVIjx3Qxwq12p0ecIc4qSP5ixnMSLhYfBeU8a9ScuMmqZxZSnE3u4CedHsIpzW7hTgE0fvZBopsxziditySYKnCNQX4d8ivnpVtkHNVdy+W8+AUttEdB9s371txaK9jYkS7zJOgz8upkmB3O71WVEJFLGHoDRsdho1Cuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751516093; c=relaxed/simple;
	bh=mOAUPLylIi7fAJo3wVvgPuNI2NNOupe5ZVOD2CTejP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r2rwN5VgRVO1AtBwMQz+oOcLxvMXJLFC2JW6Sf6YW4hbuW1ootURdGjdVLBv/jqDLpZl/ZptSypTXA6ns6/KGTlLW151+7r+6+tP4K48dLl9k442y+7pKqvphDrE2oKB2pst6UvdKLLQXe90ZO9W+2m/w/Kd2Ur4pOxpGBKC53I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lzONe2aa; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751516091; x=1783052091;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mOAUPLylIi7fAJo3wVvgPuNI2NNOupe5ZVOD2CTejP0=;
  b=lzONe2aaluUE7EgrVJO0tJvm64YC8dXA0W3Fhcpe/SyVHY6CgmBKOXGn
   mOoVWnQ1uHyvQjVfVT2I/oWc8bRBw2wcEwJ2Ui2u1zppeVdqbEzEr7r5Z
   GQVoEcKOuCd/qmR4y6fBJnMxheRp1wmSDKY+NZSM+QNxN3ieXfJ4BFtnS
   eEwoFX+v6pGXgGpGW6sW62Y2+j1zxf4ZETjUAOVkqyt9Z8H14coVcKIPr
   6+HaDbctooaZWa85m3M+c6D9MXSFzNuLIFv2Hg10ivCdnOCDI54aFRPd9
   w6ZPOSzUMm0CO/6VEeQc0+0s8h790xr/CNsEmTEKwZMyj1xIkg9c0yeKK
   w==;
X-CSE-ConnectionGUID: NbQOWdZGTfKJrel+xLlykA==
X-CSE-MsgGUID: ew7X2i+SRhqInxpi1Ut0og==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64524940"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64524940"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 21:14:50 -0700
X-CSE-ConnectionGUID: UZqpjDe9TO6CNE0t4gAgxA==
X-CSE-MsgGUID: WdCQMLVJRwaCymaURJ6/Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="191425678"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 21:14:46 -0700
Message-ID: <bb437e9d-c0af-4fb6-9c47-d495781ba29d@linux.intel.com>
Date: Thu, 3 Jul 2025 12:14:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] i386/cpu: Present same cache model in CPUID 0x2 &
 0x4
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
 qemu-devel@nongnu.org, kvm@vger.kernel.org, Alexander Graf <agraf@csgraf.de>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-5-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-5-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> For a long time, the default cache models used in CPUID 0x2 and
> 0x4 were inconsistent and had a FIXME note from Eduardo at commit
> 5e891bf8fd50 ("target-i386: Use #defines instead of magic numbers for
> CPUID cache info"):
>
> "/*FIXME: CPUID leaf 2 descriptor is inconsistent with CPUID leaf 4 */".
>
> This difference is wrong, in principle, both 0x2 and 0x4 are used for
> Intel's cache description. 0x2 leaf is used for ancient machines while
> 0x4 leaf is a subsequent addition, and both should be based on the same
> cache model. Furthermore, on real hardware, 0x4 leaf should be used in
> preference to 0x2 when it is available.
>
> Revisiting the git history, that difference occurred much earlier.
>
> Current legacy_l2_cache_cpuid2 (hardcode: "0x2c307d"), which is used for
> CPUID 0x2 leaf, is introduced in commit d8134d91d9b7 ("Intel cache info,
> by Filip Navara."). Its commit message didn't said anything, but its
> patch [1] mentioned the cache model chosen is "closest to the ones
> reported in the AMD registers". Now it is not possible to check which
> AMD generation this cache model is based on (unfortunately, AMD does not
> use 0x2 leaf), but at least it is close to the Pentium 4.
>
> In fact, the patch description of commit d8134d91d9b7 is also a bit
> wrong, the original cache model in leaf 2 is from Pentium Pro, and its
> cache descriptor had specified the cache line size ad 32 byte by default,
> while the updated cache model in commit d8134d91d9b7 has 64 byte line
> size. But after so many years, such judgments are no longer meaningful.
>
> On the other hand, for legacy_l2_cache, which is used in CPUID 0x4 leaf,
> is based on Intel Core Duo (patch [2]) and Core2 Duo (commit e737b32a3688
> ("Core 2 Duo specification (Alexander Graf).")
>
> The patches of Core Duo and Core 2 Duo add the cache model for CPUID
> 0x4, but did not update CPUID 0x2 encoding. This is the reason that
> Intel Guests use two cache models in 0x2 and 0x4 all the time.
>
> Of course, while no Core Duo or Core 2 Duo machines have been found for
> double checking, this still makes no sense to encode different cache
> models on a single machine.
>
> Referring to the SDM and the real hardware available, 0x2 leaf can be
> directly encoded 0xFF to instruct software to go to 0x4 leaf to get the
> cache information, when 0x4 is available.
>
> Therefore, it's time to clean up Intel's default cache models. As the
> first step, add "x-consistent-cache" compat option to allow newer
> machines (v10.1 and newer) to have the consistent cache model in CPUID
> 0x2 and 0x4 leaves.
>
> This doesn't affect the CPU models with CPUID level < 4 ("486",
> "pentium", "pentium2" and "pentium3"), because they have already had the
> special default cache model - legacy_intel_cpuid2_cache_info.
>
> [1]: https://lore.kernel.org/qemu-devel/5b31733c0709081227w3e5f1036odbc649edfdc8c79b@mail.gmail.com/
> [2]: https://lore.kernel.org/qemu-devel/478B65C8.2080602@csgraf.de/
>
> Cc: Alexander Graf <agraf@csgraf.de>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  hw/i386/pc.c      | 4 +++-
>  target/i386/cpu.c | 7 ++++++-
>  target/i386/cpu.h | 7 +++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index b2116335752d..ad2d6495ebde 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -81,7 +81,9 @@
>      { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
>      { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },
>  
> -GlobalProperty pc_compat_10_0[] = {};
> +GlobalProperty pc_compat_10_0[] = {
> +    { TYPE_X86_CPU, "x-consistent-cache", "false" },
> +};
>  const size_t pc_compat_10_0_len = G_N_ELEMENTS(pc_compat_10_0);
>  
>  GlobalProperty pc_compat_9_2[] = {};
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 0a2c32214cc3..2f895bf13523 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8931,7 +8931,11 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>          /* Build legacy cache information */
>          env->cache_info_cpuid2.l1d_cache = &legacy_l1d_cache;
>          env->cache_info_cpuid2.l1i_cache = &legacy_l1i_cache;
> -        env->cache_info_cpuid2.l2_cache = &legacy_l2_cache_cpuid2;
> +        if (!cpu->consistent_cache) {
> +            env->cache_info_cpuid2.l2_cache = &legacy_l2_cache_cpuid2;
> +        } else {
> +            env->cache_info_cpuid2.l2_cache = &legacy_l2_cache;
> +        }

This would encode the valid L1 and L3 cache descriptors and "0xff"
descriptor into CPUID leaf 0x2 when there is CPUID leaf 0x4. It seems a
little bit of ambiguous to mix "0xff" descriptor with other valid
descriptors and it isn't identical with real HW. Do we consider to make it
identical with real HW? Thanks.


>          env->cache_info_cpuid2.l3_cache = &legacy_l3_cache;
>  
>          env->cache_info_cpuid4.l1d_cache = &legacy_l1d_cache;
> @@ -9457,6 +9461,7 @@ static const Property x86_cpu_properties[] = {
>       * own cache information (see x86_cpu_load_def()).
>       */
>      DEFINE_PROP_BOOL("legacy-cache", X86CPU, legacy_cache, true),
> +    DEFINE_PROP_BOOL("x-consistent-cache", X86CPU, consistent_cache, true),
>      DEFINE_PROP_BOOL("legacy-multi-node", X86CPU, legacy_multi_node, false),
>      DEFINE_PROP_BOOL("xen-vapic", X86CPU, xen_vapic, false),
>  
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 5910dcf74d42..3c7e59ffb12a 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2259,6 +2259,13 @@ struct ArchCPU {
>       */
>      bool legacy_cache;
>  
> +    /*
> +     * Compatibility bits for old machine types.
> +     * If true, use the same cache model in CPUID leaf 0x2
> +     * and 0x4.
> +     */
> +    bool consistent_cache;
> +
>      /* Compatibility bits for old machine types.
>       * If true decode the CPUID Function 0x8000001E_ECX to support multiple
>       * nodes per processor

