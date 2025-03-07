Return-Path: <kvm+bounces-40318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B6FBA56305
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 09:55:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F55C17588E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D261E1DE4;
	Fri,  7 Mar 2025 08:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqXblCeE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242891A5B9E
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 08:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741337735; cv=none; b=q7qiQ8CrWOCMi6JFHrIdG54BsSy/s4oDDKL4NF07ImkerJ7oSzHkKOE3hOavQ3ADhKh27rWpmrCvOG9M/FJuJRzckMdVwVY2hUHpjO5SaEHOM8W8OzHewWp7iytjdLq7sAtMvHb8jTUbpBbDewnCasQ2h65TkeC/Wb7aUEXrksM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741337735; c=relaxed/simple;
	bh=RpN/LeNWfGyP6YXcs9FmCYAJxwp+Z5cSq5y5kR3MKmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYijwXljLC6yINQbZm8K9BPr3mgpJy05UCUWz9BzzJEesSfNAc2clEsl8AuW1FFrdRGcZtoxIhIZd6wXfTpYnwCQFNmXk5CLnfdE6WA56mYiW7rUPkQ2DxRt6LZKLXuRwmKtf+0EPjI83g03hqEFIJSrCb/ZDWFxZOjGugEOKZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqXblCeE; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741337733; x=1772873733;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RpN/LeNWfGyP6YXcs9FmCYAJxwp+Z5cSq5y5kR3MKmw=;
  b=DqXblCeE0sFGUHm18O0NYvJLkd+3Ehgn6P0tke3xGWfoV88q3YUeZwhi
   a04IDmWoVO29MFwb1ewBc7D5hNgOTCAKt2xfls01vCJvUltZ7g3LERGQz
   gslRZwYFmP4+h6Pra3KmEVMWtH8VRW2mlVzpzjrEfE0/+Nu0a3k1Her7I
   Qe2vpDhqF4u/TMrtuDbCnEld5KCW2cgimdSKaYPwT9Cpzo6UBU1H8fH5u
   Mr1gR7oZ9tOYYJ74MvThQD+2gKYiKNcWnfP/XeXf4oaru+nXbiCMZUg9l
   aVAYZBlVIL23etCo48iJvx4URdufRrKDhhE0bhbh0Ipfa82XAdTv+PT+5
   Q==;
X-CSE-ConnectionGUID: 0AQ/7n+2SxqtmaoiY0Go5Q==
X-CSE-MsgGUID: Qs0lCtoURUCRZiOgjVeHMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="29961617"
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="29961617"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 00:55:31 -0800
X-CSE-ConnectionGUID: bm/QiMATQDK5kl9bpcb14Q==
X-CSE-MsgGUID: c+VQWqPuQSmOZZgXgIJGBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119789356"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 07 Mar 2025 00:55:24 -0800
Date: Fri, 7 Mar 2025 17:15:32 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 05/10] target/i386/kvm: extract unrelated code out of
 kvm_x86_build_cpuid()
Message-ID: <Z8q5NHQeIgXxTmPO@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-6-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302220112.17653-6-dongli.zhang@oracle.com>

> +static void kvm_init_pmu_info(CPUX86State *env)
> +{
> +    uint32_t eax, edx;
> +    uint32_t unused;
> +    uint32_t limit;
> +
> +    cpu_x86_cpuid(env, 0, 0, &limit, &unused, &unused, &unused);

At this stage, CPUID has already been filled and we should not use
cpu_x86_cpuid() to get the "raw" CPUID info.

Instead, after kvm_x86_build_cpuid(), the cpuid_find_entry() helper
should be preferred.

With cpuid_find_entry(), we don't even need to check the limit again.

> +
> +    if (limit < 0x0a) {
> +        return;
> +    }

...

>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2267,6 +2277,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
>  
> +    kvm_init_pmu_info(env);
> +

Referring what has_msr_feature_control did, what about the following
change?

 int kvm_arch_init_vcpu(CPUState *cs)
 {
     struct {
@@ -2277,8 +2240,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
     cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
     cpuid_data.cpuid.nent = cpuid_i;

-    kvm_init_pmu_info(env);
-
     if (((env->cpuid_version >> 8)&0xF) >= 6
         && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
            (CPUID_MCE | CPUID_MCA)) {
@@ -2329,6 +2290,31 @@ int kvm_arch_init_vcpu(CPUState *cs)
         has_msr_feature_control = true;
     }

+    c = cpuid_find_entry(&cpuid_data.cpuid, 0xa, 0);
+    if (c) {
+        has_architectural_pmu_version = c->eax & 0xff;
+        if (has_architectural_pmu_version > 0) {
+            num_architectural_pmu_gp_counters = (c->eax & 0xff00) >> 8;
+
+            /*
+             * Shouldn't be more than 32, since that's the number of bits
+             * available in EBX to tell us _which_ counters are available.
+             * Play it safe.
+             */
+            if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
+                num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
+            }
+
+            if (has_architectural_pmu_version > 1) {
+                num_architectural_pmu_fixed_counters = c->edx & 0x1f;
+
+                if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
+                    num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
+                }
+            }
+        }
+    }
+
     if (env->mcg_cap & MCG_LMCE_P) {
         has_msr_mcg_ext_ctl = has_msr_feature_control = true;
     }
---

The above codes check 0xa after 0x1 and 0x7, and uses the local variable
`c`, so that it doesn't need to wrap another new function.

Regards,
Zhao




