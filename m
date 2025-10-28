Return-Path: <kvm+bounces-61284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D465FC138D6
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 09:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4CE3335056A
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 08:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0901926F467;
	Tue, 28 Oct 2025 08:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CSTtp0i+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC8CD271
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761640401; cv=none; b=immyQpGViU8Fv1n0BJUVnjdmnVL4fQO9qEziiBieFwvySKgl25upUKiXghc30NaxAHobJ3tKGpnXlHAkKfIDcsAgaASxi046HGzgDV427g0TvCXS173RYR1OJ3h2liruvhg5/qLZBcCMAPZ4jzaumuUcXbo3J7mzR1DT1tK+ruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761640401; c=relaxed/simple;
	bh=JtwjiXeZbF82FprgRA+z7v+PU021hA/Ygg03TKh5C+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hYpc3MPaeaQzw01eUX3SVrAhNoxP+Ef50qniTo1YjEtbjDhJBK5OzZu5NKCyCutlOIXJc5eVDiZH9mittdfY39qLJ9IlZBXXT97+f4O3tpjewQK+rxF+AIunV4a2akK/FIh7v1YRQNXNY7mIardxP+KkCnC3+mf33V9ooT9F/Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CSTtp0i+; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761640400; x=1793176400;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JtwjiXeZbF82FprgRA+z7v+PU021hA/Ygg03TKh5C+Y=;
  b=CSTtp0i+13A0x1Wh/AOT7+7zRI1tnN+A5Wj59LCI0iqMycEloiv4Qd4U
   Pd/Nlt9WGVBcY9ueiLjAy2M2QB5darFCCgCxreZ596grNAXpz40n1GdqJ
   wjjohAM1dtY63kE/sfWXKg62yuqHDmfVyKr4pv54oEqh/ukLFQHpgmIaT
   ZOfeg6o9+WWbGwVkTEH9B2lECVBfU0tsnxEzPaJ5+vUXNtpeotYg+YtO+
   IjO2WqCn69SDhLUaolSEjGr4C27aRN3N0nXOl+rJ5z2ASDy0BlzahFlG+
   RADTVvIoXae2p036c5AZvGhDVQXSg4i0jZizx0tJ01HAlKvjgL2sWwGEK
   Q==;
X-CSE-ConnectionGUID: i4EnFeTeSg6Z8Y4xTiJVgA==
X-CSE-MsgGUID: VhdWUwZAR+WrnzOhqhE3OA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63436231"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="63436231"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:33:19 -0700
X-CSE-ConnectionGUID: Elr61Lh9TGmH8IkK9ySpEw==
X-CSE-MsgGUID: jzO8APFNRqGG/OFA5FwHdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="189341692"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:33:15 -0700
Message-ID: <534db36d-d440-409a-8a80-ee0fe9df12b4@intel.com>
Date: Tue, 28 Oct 2025 16:33:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/20] i386/cpu: Advertise CET related flags in feature
 words
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-18-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-18-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Add SHSTK and IBT flags in feature words with entry/exit
> control flags.
> 
> CET SHSTK and IBT feature are enumerated via CPUID(EAX=7,ECX=0)
> ECX[bit 7] and EDX[bit 20]. CET states load/restore at vmentry/
> vmexit are controlled by VMX_ENTRY_CTLS[bit 20] and VMX_EXIT_CTLS[bit 28].
> Enable these flags so that KVM can enumerate the features properly.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
> Changes Since v2:
>   - Rename "shstk"/"ibt" to "cet-ss"/"cet-ibt" to match feature names
>     in SDM & APM.
>   - Rename "vmx-exit-save-cet-ctl"/"vmx-entry-load-cet-ctl" to
>     "vmx-exit-save-cet"/"vmx-entry-load-cet".
>   - Define the feature mask macro for easier double check.
> ---
>   target/i386/cpu.c | 8 ++++----
>   target/i386/cpu.h | 2 ++
>   2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index c08066a338a3..9a1001c47891 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1221,7 +1221,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>           .type = CPUID_FEATURE_WORD,
>           .feat_names = {
>               NULL, "avx512vbmi", "umip", "pku",
> -            NULL /* ospke */, "waitpkg", "avx512vbmi2", NULL,
> +            NULL /* ospke */, "waitpkg", "avx512vbmi2", "cet-ss",
>               "gfni", "vaes", "vpclmulqdq", "avx512vnni",
>               "avx512bitalg", NULL, "avx512-vpopcntdq", NULL,
>               "la57", NULL, NULL, NULL,
> @@ -1244,7 +1244,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>               "avx512-vp2intersect", NULL, "md-clear", NULL,
>               NULL, NULL, "serialize", NULL,
>               "tsx-ldtrk", NULL, NULL /* pconfig */, "arch-lbr",
> -            NULL, NULL, "amx-bf16", "avx512-fp16",
> +            "cet-ibt", NULL, "amx-bf16", "avx512-fp16",
>               "amx-tile", "amx-int8", "spec-ctrl", "stibp",
>               "flush-l1d", "arch-capabilities", "core-capability", "ssbd",
>           },
> @@ -1666,7 +1666,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>               "vmx-exit-save-efer", "vmx-exit-load-efer",
>                   "vmx-exit-save-preemption-timer", "vmx-exit-clear-bndcfgs",
>               NULL, "vmx-exit-clear-rtit-ctl", NULL, NULL,
> -            NULL, "vmx-exit-load-pkrs", NULL, "vmx-exit-secondary-ctls",
> +            "vmx-exit-save-cet", "vmx-exit-load-pkrs", NULL, "vmx-exit-secondary-ctls",
>           },
>           .msr = {
>               .index = MSR_IA32_VMX_TRUE_EXIT_CTLS,
> @@ -1681,7 +1681,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>               NULL, "vmx-entry-ia32e-mode", NULL, NULL,
>               NULL, "vmx-entry-load-perf-global-ctrl", "vmx-entry-load-pat", "vmx-entry-load-efer",
>               "vmx-entry-load-bndcfgs", NULL, "vmx-entry-load-rtit-ctl", NULL,
> -            NULL, NULL, "vmx-entry-load-pkrs", "vmx-entry-load-fred",
> +            "vmx-entry-load-cet", NULL, "vmx-entry-load-pkrs", "vmx-entry-load-fred",
>               NULL, NULL, NULL, NULL,
>               NULL, NULL, NULL, NULL,
>           },
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index ad4287822831..fa3e5d87fe50 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1369,6 +1369,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
>   #define VMX_VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>   #define VMX_VM_EXIT_PT_CONCEAL_PIP                  0x01000000
>   #define VMX_VM_EXIT_CLEAR_IA32_RTIT_CTL             0x02000000
> +#define VMX_VM_EXIT_SAVE_CET                        0x10000000
>   #define VMX_VM_EXIT_LOAD_IA32_PKRS                  0x20000000
>   #define VMX_VM_EXIT_ACTIVATE_SECONDARY_CONTROLS     0x80000000
>   
> @@ -1382,6 +1383,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
>   #define VMX_VM_ENTRY_LOAD_BNDCFGS                   0x00010000
>   #define VMX_VM_ENTRY_PT_CONCEAL_PIP                 0x00020000
>   #define VMX_VM_ENTRY_LOAD_IA32_RTIT_CTL             0x00040000
> +#define VMX_VM_ENTRY_LOAD_CET                       0x00100000
>   #define VMX_VM_ENTRY_LOAD_IA32_PKRS                 0x00400000
>   
>   /* Supported Hyper-V Enlightenments */


