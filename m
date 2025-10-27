Return-Path: <kvm+bounces-61136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7879AC0C091
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 08:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5ED794E9A46
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 07:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EFCD2D9EF2;
	Mon, 27 Oct 2025 07:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="egwhfqqt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8991D2F5B
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 07:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548720; cv=none; b=Q5K79C9nzNKFkx8vm2IwpQUrGyl+JtC4/pzbyiMH60h9WI4j9YRR5R2zfBTnpahAO3ohyASW3kZjX8dGykKEII+eXm1Gm2SxMb7OK3RhZYohgLKCZiEVeaZR0KuO0165vmPMXH5drWjLshcPzn4agJMPrrcBXiEidWhdNndAU+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548720; c=relaxed/simple;
	bh=92iIV6RDBJqkO12qftZuVJ7paoQuUYviIHpplpoCTWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZgpG3IimvzqJNHzCcpUmPeASgOIQX50IwyhWiPZb5iI2g+h9BLRa84g93Sj6ghXp9YYACjxKw8EE2ia3f2vVsCR6f36vCUjlHsngb2J+yvWAQwdPPP7QTTN4w/E4dCe2rGegsaExoiaegpfyYIr69DLhMhJyLz1Cctph4cZQxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=egwhfqqt; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761548719; x=1793084719;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=92iIV6RDBJqkO12qftZuVJ7paoQuUYviIHpplpoCTWE=;
  b=egwhfqqtmmpkBx8w7yXkPdZv0EEbLAiY4CsD4HM8kM8i1VJj8gXetvjK
   MbGIrVa2I0BdPUvZHCJvNlGaWrp+pFxOOsfF5u+/s6bsUDWRgAlIMalEO
   qS9EG+BSUwcklcG8Cz/huz8YuegJW/6C3nUK3uNman/TLuHcyAwr7/56/
   qlS+gUmry0XiWf53BiYMW97qJpvSG/Tv5L8nUYo8nrPJlTGN17qGITD7y
   h+EzgW7zDPs+QRFOzqwnj2BlgoJRVkkvEIwtNf3uHbWCu51NkjtAAnwni
   EmW8OlqE01lb2EVviBVbqCyuPkkcDMDuGWB9WCjRLMvB6CWAznwesEWQg
   w==;
X-CSE-ConnectionGUID: Vxk4MXkUQDyhG8EChRGGXg==
X-CSE-MsgGUID: fkJYPAZzSFWGQ4I731dFBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74223944"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="74223944"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:05:18 -0700
X-CSE-ConnectionGUID: hAsd1gKVTF+3LEAswftFfg==
X-CSE-MsgGUID: TCS3iW28RdKATST0eLrExg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184583647"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:05:14 -0700
Message-ID: <93f57118-99ea-4dc0-b2cb-a8f929f4cbfa@intel.com>
Date: Mon, 27 Oct 2025 15:05:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/20] i386/cpu: Add avx10 dependency for
 Opmask/ZMM_Hi256/Hi16_ZMM
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-7-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-7-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> With feature array in ExtSaveArea, add avx10 as the second dependency
> for Opmask/ZMM_Hi256/Hi16_ZMM xsave components, and drop the special
> check in cpuid_has_xsave_feature().
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/cpu.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index cd269d15ce0b..236a2f3a9426 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -2054,18 +2054,21 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
>           .size = sizeof(XSaveOpmask),
>           .features = {
>               { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
> +            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
>           },
>       },
>       [XSTATE_ZMM_Hi256_BIT] = {
>           .size = sizeof(XSaveZMM_Hi256),
>           .features = {
>               { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
> +            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
>           },
>       },
>       [XSTATE_Hi16_ZMM_BIT] = {
>           .size = sizeof(XSaveHi16_ZMM),
>           .features = {
>               { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
> +            { FEAT_7_1_EDX,         CPUID_7_1_EDX_AVX10   },
>           },
>       },
>       [XSTATE_PKRU_BIT] = {
> @@ -8643,12 +8646,6 @@ static bool cpuid_has_xsave_feature(CPUX86State *env, const ExtSaveArea *esa)
>           }
>       }
>   
> -    if (esa->features[0].index == FEAT_7_0_EBX &&
> -        esa->features[0].mask == CPUID_7_0_EBX_AVX512F &&
> -        (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10)) {
> -        return true;
> -    }
> -
>       return false;
>   }
>   


