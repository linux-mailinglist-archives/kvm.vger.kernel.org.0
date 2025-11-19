Return-Path: <kvm+bounces-63696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 643B9C6E0BE
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 11:47:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 943AA342534
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 10:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A85834D4D9;
	Wed, 19 Nov 2025 10:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O1gPaO1o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EF2346FA2
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 10:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763549078; cv=none; b=pxN8cTFkjjzKpJfc27+gf0OPqu0n5dewGoX74Qd4dfDe4xjoA+Nwnxm7vMdT3KyQsWuQ55y6HTHBhdknw1DKmJItIsYyGQywYuDNHtwOzUwt2otJY27UVdL74JmuoVI9dIlv9X66SDmt9BjsG0fxtzzDu0tkfoY0kS+zTTh/40k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763549078; c=relaxed/simple;
	bh=WhK5P4cuobRv3bMhRyzWkwxWn+7RqWPfiO66DzwlRZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NUe6PpwZOUo8o+upsDimoH7mvcQ34TlqvH8myXS9AoeCAWq+/kT0o7JKeLNu53fObUcR0mhJcVy718zq8QXOOVXEm2xD2DJk/z5A2joNft5vFnApikALdd3PCw22A07G5GX0pj/Jsm6CxCyP/EY9TB/QpVmK9W3UZyfM9I6bvLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O1gPaO1o; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763549076; x=1795085076;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WhK5P4cuobRv3bMhRyzWkwxWn+7RqWPfiO66DzwlRZg=;
  b=O1gPaO1o0D+dzbMNmue/c11DvmHptZb6rvQdAwxBALNIhtTjMKrxnK0l
   wupQaBEnXePh+oyPkvyRG383nJ5pu0ewQUCgRyb7UEV8Y5x3yn5X5XErj
   rV56YgjURufoYSOsMEFUMKOit/luC2iONY4XAkJ24WaVQrww2kuHfJjyE
   IInZkB4bnYmR9E6jOjEKH/w2Qaagd7A58754pMZ6S7Uap070wq81RXbu6
   P928uMOsdZjY24qilkD78/i9tS9l6BJ8ltuyFcZC00yyVNjX4KcMnrTkl
   +kRA+VqCyPTjDo5ibQbI5eRYfpICWUcWwexHTzsyXX8aTt7ZqSkUSi0Mv
   A==;
X-CSE-ConnectionGUID: fz3xAOHYRbeq+/Pted8tJw==
X-CSE-MsgGUID: ko8YeIGgRXmHI7gdL5PHhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65483370"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="65483370"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 02:44:35 -0800
X-CSE-ConnectionGUID: mItufiZIQR2Hevf9RtiK1g==
X-CSE-MsgGUID: USMTkdqxSGGJc3gf0UXzbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="195971496"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa004.fm.intel.com with ESMTP; 19 Nov 2025 02:44:31 -0800
Date: Wed, 19 Nov 2025 19:06:51 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com, groug@kaod.org,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com, zhao1.liu@intel.com
Subject: Re: [PATCH v7 2/9] target/i386: disable PERFCORE when "-pmu" is
 configured
Message-ID: <aR2ky5WU8CqH8+lS@intel.com>
References: <20251111061532.36702-1-dongli.zhang@oracle.com>
 <20251111061532.36702-3-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111061532.36702-3-dongli.zhang@oracle.com>

Hi Dongli,

> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 3653f8953e..4fcade89bc 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8360,6 +8360,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              !(env->hflags & HF_LMA_MASK)) {
>              *edx &= ~CPUID_EXT2_SYSCALL;
>          }
> +
> +        if (!cpu->enable_pmu) {
> +            *ecx &= ~CPUID_EXT3_PERFCORE;
> +        }

Learned the lessons from PDCM [*]:

[*] https://lore.kernel.org/qemu-devel/20250923104136.133875-3-pbonzini@redhat.com/

Directly masking CPUID bit off is not a good idea... modifying the
CPUID, even when fixing or adding dependencies, can easily break
migration.

So a safe way is to add a compat option. And I think it would be better
if patch 1 also has a compat option. A single compat option could cover
patch 1 & 2.

I have these thoughts:

* For "-pmu" dependency, it can be checked as [*] did.
* For normal feature bit dependency (patch 1), it seems possible to add
  compat_prop condition in feature_dependencies[].

I attached a draft for discussion (which is on the top of the whole
series).

Note, we are currently in the RC phase for v10.2, and the
pc_compat_10_2[] array is not yet added, which will be added before the
release of v10.2. Therefore, we have enough time for discussion I think.

If you think it's fine, I'll post compat_prop support separately as an
RFC. The specific compat option can be left to this series.

Although wait for a while, in a way, it is lucky :) - there's an
opportunity to avoid making mistakes for us.

Regards,
Zhao

------------------------------------------------
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index f8b919cb6c47..d2b8e83e556d 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -83,6 +83,7 @@

 GlobalProperty pc_compat_10_1[] = {
     { "mch", "extended-tseg-mbytes", "16" },
+    { TYPE_X86_CPU, "x-amd-perfmon-always-on", "true" }, // This should be added to pc_compat_10_2!
 };
 const size_t pc_compat_10_1_len = G_N_ELEMENTS(pc_compat_10_1);

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4fcade89bcea..8c56789eb296 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1997,6 +1997,8 @@ static FeatureDep feature_dependencies[] = {
     {
         .from = { FEAT_8000_0001_ECX,       CPUID_EXT3_PERFCORE },
         .to = { FEAT_8000_0022_EAX,         CPUID_8000_0022_EAX_PERFMON_V2 },
+        .compat_prop =
+            { "x-amd-perfmon-always-on",    "false" },
     },
 };

@@ -8998,15 +9000,36 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
         }
     }

-    if (!cpu->pdcm_on_even_without_pmu) {
+    if (!cpu->enable_pmu) {
         /* PDCM is fixed1 bit for TDX */
-        if (!cpu->enable_pmu && !is_tdx_vm()) {
+        if (!cpu->pdcm_on_even_without_pmu && !is_tdx_vm()) {
             env->features[FEAT_1_ECX] &= ~CPUID_EXT_PDCM;
         }
+
+        if (!cpu->amd_perfmon_always_on) {
+            env->features[FEAT_8000_0001_ECX] &= ~CPUID_EXT3_PERFCORE;
+        }
     }

     for (i = 0; i < ARRAY_SIZE(feature_dependencies); i++) {
         FeatureDep *d = &feature_dependencies[i];
+        bool compat_omit = false;
+        PropValue *prop = &d->compat_prop;
+
+        if (prop->value) {
+            char *v = object_property_print(OBJECT(cpu), prop->prop, false, NULL);
+            if (v) {
+                compat_omit = !strcmp(prop->value, v);
+                printf("feature_dependencies: v: %s, value: %s, omit: %d\n",
+                       v, prop->value, compat_omit);
+                g_free(v);
+            }
+
+            if (compat_omit) {
+                continue;
+            }
+        }
+
         if (!(env->features[d->from.index] & d->from.mask)) {
             uint64_t unavailable_features = env->features[d->to.index] & d->to.mask;

@@ -10065,6 +10088,8 @@ static const Property x86_cpu_properties[] = {
                      arch_cap_always_on, false),
     DEFINE_PROP_BOOL("x-pdcm-on-even-without-pmu", X86CPU,
                      pdcm_on_even_without_pmu, false),
+    DEFINE_PROP_BOOL("x-amd-perfmon-always-on", X86CPU,
+                     amd_perfmon_always_on, false),
 };

 #ifndef CONFIG_USER_ONLY
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6d78f3995b6b..ac8dd92efc59 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -696,8 +696,14 @@ typedef struct FeatureMask {
     uint64_t mask;
 } FeatureMask;

+typedef struct PropValue {
+    const char *prop, *value;
+} PropValue;
+
 typedef struct FeatureDep {
     FeatureMask from, to;
+    /* Once set, only when prop is satisfied, dependency can be checked. */
+    PropValue compat_prop;
 } FeatureDep;

 typedef uint64_t FeatureWordArray[FEATURE_WORDS];
@@ -2353,6 +2359,16 @@ struct ArchCPU {
      */
     bool pdcm_on_even_without_pmu;

+    /*
+     * Backwards compatibility with QEMU <10.2. (TODO: change 10.2 to 11.0!)
+     * This flag covers 2 parts:
+     * - The PERFCORE feature is now disabled when PMU is not available, but prior to
+     *   10.2 it was enabled even if PMU is off.
+     * - The PerfMonV2 feature is now disabled when PERFCORE is disabled, but prior to
+     *   10.2 it was enabled even if PERFCORE is off.
+     */
+    bool amd_perfmon_always_on;
+
     /* Number of physical address bits supported */
     uint32_t phys_bits;

@@ -2579,9 +2595,7 @@ bool cpu_x86_xrstor(CPUX86State *s, void *host, size_t len, uint64_t rbfm);
 /* cpu.c */
 void x86_cpu_vendor_words2str(char *dst, uint32_t vendor1,
                               uint32_t vendor2, uint32_t vendor3);
-typedef struct PropValue {
-    const char *prop, *value;
-} PropValue;
+
 void x86_cpu_apply_props(X86CPU *cpu, PropValue *props);

 void x86_cpu_after_reset(X86CPU *cpu);



