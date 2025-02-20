Return-Path: <kvm+bounces-38662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A9CA3D6F0
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B523B165917
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 10:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696631F1312;
	Thu, 20 Feb 2025 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QvMnMTO5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA271CAA9C
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 10:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740048005; cv=none; b=GaEFpyYBFxjriP5FnYkoylEqQRrxLUgU0wLZSKisgNlJaXpdKmwNnjJizx+KIdT11MIsStjDCH4uoeUn0BbNlWSHAIosZYVVjhcxlGXwezRZqMT/GvRZY9/wzAPtIy6omwOGyi+QSo2THB5cnVHMPby2+v91xAfUIHIlKf9cajw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740048005; c=relaxed/simple;
	bh=TdzYaPLHZ16bLzvmwwZ5c+AojcvTSJL6pVcmyKLeuvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSeJFLFZA+4t5vP0QP/KHSxh9+buUy/E3jtaPf9g4OJkwr+3yNhNMABYmEqmoIR2bTEcpg75gAzHHJI/xKdnjHNvwWoqe6xHQsPw0Kh5scqBWfYlOhnWSMYUJHfwKiUpYG0kRvmewPyO7KeQrfSTwkr/V8uJzhWkd4IPH3GYQN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QvMnMTO5; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740048004; x=1771584004;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TdzYaPLHZ16bLzvmwwZ5c+AojcvTSJL6pVcmyKLeuvE=;
  b=QvMnMTO5zBY6w+lryG+S9vwDpuRVqMuAu4t1uNXkBMvOvHjazskMyUyg
   YQTzG3FnOxNgY9f90fZN8wCYLmwUU28kCb0v7a53eLZD7phNDzaZKPVgr
   LsQJeIQyrSE4FzGVvICNHhR1f6FGOi2QQpIZJXB6IDA9U6ipuos9mnW4y
   k36/ALtKSHDUk3O9imji1VtWKIzUvCiqnY2ly2sfVbX+QEHFdoH+NNadH
   0mhfVcwGRw9Y5TanF3MD1wJDDjKOC38OX5tsLXkgA/fiTXSNb9seF5NFW
   Jr9oeb8gtBR4ud3aNOSsXxexx/qwhr3r1Q/R2UX9DE8Fhcy/jVh1DSwc3
   g==;
X-CSE-ConnectionGUID: mVSasrVsQ4mCoUxbfY7BQQ==
X-CSE-MsgGUID: 8yMfpfIySueG4YqX3w96OA==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="41076447"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="41076447"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:40:02 -0800
X-CSE-ConnectionGUID: 4Io3i1pjTgiuFU3HtpbDOw==
X-CSE-MsgGUID: Yo7MKmgDTMi9F1FsY5heQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="114856938"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 20 Feb 2025 02:40:00 -0800
Date: Thu, 20 Feb 2025 18:59:34 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
	davydov-max@yandex-team.ru
Subject: Re: [PATCH v5 1/6] target/i386: Update EPYC CPU model for Cache
 property, RAS, SVM feature bits
Message-ID: <Z7cLFrIPmrUGuqp4@intel.com>
References: <cover.1738869208.git.babu.moger@amd.com>
 <c777bf763a636c8922164a174685b4f03864452f.1738869208.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c777bf763a636c8922164a174685b4f03864452f.1738869208.git.babu.moger@amd.com>

> +static CPUCaches epyc_v5_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,
> +        .self_init = 1,

For consistency as the below parts, it's better to code `true` for all
boolean types.

> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .size = 64 * KiB,
> +        .line_size = 64,
> +        .associativity = 4,
> +        .partitions = 1,
> +        .sets = 256,
> +        .lines_per_tag = 1,
> +        .self_init = 1,

ditto.

Others are fine for me, so,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


And one more thing :-) ...

>  static const CPUCaches epyc_rome_cache_info = {
>      .l1d_cache = &(CPUCacheInfo) {
>          .type = DATA_CACHE,
> @@ -5207,6 +5261,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>                  },
>                  .cache_info = &epyc_v4_cache_info
>              },
> +            {
> +                .version = 5,
> +                .props = (PropValue[]) {
> +                    { "overflow-recov", "on" },
> +                    { "succor", "on" },

When I checks the "overflow-recov" and "succor" enabling, I find these 2
bits are set unconditionally.

I'm not sure if all AMD platforms support both bits, do you think it's
necessary to check the host support?

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c749d4ee812..03e463076632 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -555,7 +555,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         cpuid_1_edx = kvm_arch_get_supported_cpuid(s, 1, 0, R_EDX);
         ret |= cpuid_1_edx & CPUID_EXT2_AMD_ALIASES;
     } else if (function == 0x80000007 && reg == R_EBX) {
-        ret |= CPUID_8000_0007_EBX_OVERFLOW_RECOV | CPUID_8000_0007_EBX_SUCCOR;
+        uint32_t ebx;
+        host_cpuid(0x80000007, 0, &unused, &ebx, &unused, &unused);
+
+        ret |= ebx & (CPUID_8000_0007_EBX_OVERFLOW_RECOV | CPUID_8000_0007_EBX_SUCCOR);
     } else if (function == KVM_CPUID_FEATURES && reg == R_EAX) {
         /* kvm_pv_unhalt is reported by GET_SUPPORTED_CPUID, but it can't
          * be enabled without the in-kernel irqchip

Thanks,
Zhao



