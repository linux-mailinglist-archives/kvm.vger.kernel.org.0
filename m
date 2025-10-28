Return-Path: <kvm+bounces-61283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CF89EC138D3
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 09:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C50365044DD
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 08:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E890C13D521;
	Tue, 28 Oct 2025 08:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VWCwsRK1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4A2D73B1
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 08:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761640209; cv=none; b=HSbxGxhvu/4jgyspVtU9s08cBhxX1Efw8iZKCYjI1LR2uIbejx0h6hr/28F69OcAS8EAO++/jWRLx+xtNX3S73Vlz40lUli7zKTumQIZMTVfl3ZFQshT3HsQmAMGwmxvbcHHdc/J2E3NmtzcvAcEvqiLN1SPW5s8/oweqiUh4XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761640209; c=relaxed/simple;
	bh=NwoPJ+QPtaDuf+sBJLBVlCChGUU0Iuj/ciX76s/tQK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I/U0g8XWj9iZJ5lazN3+cth7oaMzzi9gQ5PXXbC9e7OsOJ/oj5IjbTfhtFNXTjTzs68/ZgW8LTnXmpPwVqSSQpQuht+rbK9fjLr2JZdZzEz2hLld2mCJzWBOlseSfUAckJAX1MLr6aXrfFPd1iQAmyUkxuccMx/gE+kH7LjN6O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VWCwsRK1; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761640208; x=1793176208;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NwoPJ+QPtaDuf+sBJLBVlCChGUU0Iuj/ciX76s/tQK8=;
  b=VWCwsRK1n1LIq/EiPeoHoGC02JSuQ+jg2q18irBjXb59ueNUDNESzUpZ
   BK9WcMEKUmR/X8qce+wOHSWEudi58X6zq7omzTAnoAChSb+IatEKpjzBz
   zZ5g4/LsxBMjGDgOLu/Q+7fwQyB6dyIUigd7w0phcinsBHzV7WNaPN6qV
   R721jEZ/doQK5fdCQRiEI99UKvBS73USZK6envu/GIhrBOtHjuIDeqeA0
   BVVyGPwUHfn9pTPIrcm0Fy6IOTp4CWUvX4uSi4rFWbsWAHzM8D+2Bl7QL
   XudYSu4OoA11SBYTJ1mu6wpwMWx9OUWEeNFeqmAqPN3z6LnxM591pyz9t
   g==;
X-CSE-ConnectionGUID: zzpP3TsKSCKLILEb533s4g==
X-CSE-MsgGUID: hi5tdSpnRh2BXCBFxL9V1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74334888"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="74334888"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:30:07 -0700
X-CSE-ConnectionGUID: JYg7o9JqRVGXyvow0m2/tw==
X-CSE-MsgGUID: 1ZxJMpwlSru4aHM5d8YP1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="189340578"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:30:03 -0700
Message-ID: <445462e9-22e5-4e8b-999e-7be468731752@intel.com>
Date: Tue, 28 Oct 2025 16:29:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/20] i386/machine: Add vmstate for cet-ss and cet-ibt
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-16-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-16-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Add vmstates for cet-ss and cet-ibt
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes Since v2:
>   - Split a subsection "vmstate_ss" since shstk is user-configurable.
> ---
>   target/i386/machine.c | 53 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 53 insertions(+)
> 
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 45b7cea80aa7..3ad07ec82428 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -1668,6 +1668,58 @@ static const VMStateDescription vmstate_triple_fault = {
>       }
>   };
>   
> +static bool shstk_needed(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +
> +    return !!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK);
> +}
> +
> +static const VMStateDescription vmstate_ss = {
> +    .name = "cpu/cet_ss",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = shstk_needed,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(env.pl0_ssp, X86CPU),
> +        VMSTATE_UINT64(env.pl1_ssp, X86CPU),
> +        VMSTATE_UINT64(env.pl2_ssp, X86CPU),
> +        VMSTATE_UINT64(env.pl3_ssp, X86CPU),
> +#ifdef TARGET_X86_64
> +        /* This MSR is only present on Intel 64 architecture. */
> +        VMSTATE_UINT64(env.int_ssp_table, X86CPU),
> +#endif

It seems we need to split int_ssp_table into a separate vmstate_*

Its .needed function needs to check both  CPUID_7_0_ECX_CET_SHSTK && 
CPUID_EXT2_LM.

> +        VMSTATE_UINT64(env.guest_ssp, X86CPU),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static bool cet_needed(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +
> +    return !!((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) ||
> +              (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT));
> +}
> +
> +static const VMStateDescription vmstate_cet = {
> +    .name = "cpu/cet",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = cet_needed,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(env.u_cet, X86CPU),
> +        VMSTATE_UINT64(env.s_cet, X86CPU),
> +        VMSTATE_END_OF_LIST()
> +    },
> +    .subsections = (const VMStateDescription * const []) {
> +        &vmstate_ss,
> +        NULL,
> +    },
> +};
> +
>   const VMStateDescription vmstate_x86_cpu = {
>       .name = "cpu",
>       .version_id = 12,
> @@ -1817,6 +1869,7 @@ const VMStateDescription vmstate_x86_cpu = {
>   #endif
>           &vmstate_arch_lbr,
>           &vmstate_triple_fault,
> +        &vmstate_cet,

missing &vmstate_ss

>           NULL
>       }
>   };


