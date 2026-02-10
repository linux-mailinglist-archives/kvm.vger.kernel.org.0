Return-Path: <kvm+bounces-70776-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJU7GLyBi2m+UwAAu9opvQ
	(envelope-from <kvm+bounces-70776-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:06:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C81BE11E7FA
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B8D8306826E
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 19:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30ABE2DFA2D;
	Tue, 10 Feb 2026 19:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lzPx6bI/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9FC1F03EF
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770750328; cv=none; b=PTSmLsu2g2m9QMXLT6C8QDPFyYEXTyaud7Nhp69hT35pHTsv7jJnwVhFkhnR6XjFnrFBg0NdjfWUHAsq2M3THrecgH77GNE9cl9VCFsHp86kDFqwcKaimtnGNFHQrxL3wKzUiLAWuRUg7os8MHqOomDByxv1c5TOaBtoBa5ovIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770750328; c=relaxed/simple;
	bh=ylcl4fb3NHyomkpp/UlE8A9D2DVzsDW11g1wPGUvirE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQYUy9bJvilDh4bRiagegS7bJqkh/a4W20LE8Yfd8NxYBsdWTnw9e4EeQhxmu1okxGZUfFID/InUIBCfoiQNqlxiG4oFZ2EOWjXQX6VozpiYtPAslVV57OcXHVqIdA2gAVKahYcZ6dBczqpJ3/zck66fp+XdM9MGmeBFNQl+OnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lzPx6bI/; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770750328; x=1802286328;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ylcl4fb3NHyomkpp/UlE8A9D2DVzsDW11g1wPGUvirE=;
  b=lzPx6bI/Hpop1DGh6EZ6VkExT/+fQaIHRC5FG2MOL13wIizr0+aFiMcy
   fdkNuCZgPKJ9kX0CVGmlTSiTojfGd4J3UNMxeJvSngBzsWASx24HIlH8i
   0vh6jjKq4lJhCTuCtHCz7FanAjevzux6AFezJBP8PL8HfH21iKSrc8CrS
   xCsuVSd153FdLTqoPfaVSZxUWgI4Y/X43ubegjHHtmhsXH896wMWgRhjh
   Hvqcjcw1QkTFpEiwzqrcoI7mrIJFpPI+/GUGu3t5qsNMAcnwdXFTLq4o3
   RG+/00T1XShDAVdyAzCCI3OF5IbQZVAYaW/OvLl6O0GEtfCDv2FYWh1tv
   Q==;
X-CSE-ConnectionGUID: BcPBI5QaQKygroIPGb82SA==
X-CSE-MsgGUID: +XDIZOeoRuOksRT2o8w8IQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71789399"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71789399"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 11:05:28 -0800
X-CSE-ConnectionGUID: zCijB2DbQZuWXl8byfvD5w==
X-CSE-MsgGUID: AHHvJZfgS02KcdI2813xiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212098802"
Received: from unknown (HELO [10.241.241.84]) ([10.241.241.84])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 11:05:27 -0800
Message-ID: <488a2ea7-062d-4561-89ec-f053af234cdd@intel.com>
Date: Tue, 10 Feb 2026 11:05:26 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 11/11] target/i386: Disable guest PEBS capability when
 not enabled
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
 <20260128231003.268981-12-zide.chen@intel.com>
 <576b57e3-92df-4a35-ba7c-00bf12833313@linux.intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <576b57e3-92df-4a35-ba7c-00bf12833313@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70776-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: C81BE11E7FA
X-Rspamd-Action: no action



On 2/9/2026 11:30 PM, Mi, Dapeng wrote:
> 
> On 1/29/2026 7:09 AM, Zide Chen wrote:
>> When PMU is disabled, guest CPUID must not advertise Debug Store
>> support.  Clear both CPUID.01H:EDX[21] (DS) and CPUID.01H:ECX[2]
>> (DS64) in this case.
>>
>> Set IA32_MISC_ENABLE[12] (PEBS_UNAVAILABLE) when Debug Store is not
>> exposed to the guest.
>>
>> Note: Do not infer that PEBS is unsupported from
>> IA32_PERF_CAPABILITIES[11:8] (PEBS_FMT) being 0.  A value of 0 is a
>> valid PEBS record format on some CPUs.
>>
>> Signed-off-by: Zide Chen <zide.chen@intel.com>
>> ---
>> V2:
>> - New patch.
>>
>>  target/i386/cpu.c | 6 ++++++
>>  target/i386/cpu.h | 1 +
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index ec6f49916de3..445361ab7a06 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -9180,6 +9180,10 @@ static void x86_cpu_reset_hold(Object *obj, ResetType type)
>>          env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
>>      }
>>  
>> +    if (!(env->features[FEAT_1_EDX] & CPUID_DTS)) {
>> +        env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
>> +    }
>> +
>>      memset(env->dr, 0, sizeof(env->dr));
>>      env->dr[6] = DR6_FIXED_1;
>>      env->dr[7] = DR7_FIXED_1;
>> @@ -9474,6 +9478,8 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>>              env->features[FEAT_1_ECX] &= ~CPUID_EXT_PDCM;
>>          }
>>  
>> +        env->features[FEAT_1_ECX] &= ~CPUID_EXT_DTES64;
>> +        env->features[FEAT_1_EDX] &= ~CPUID_DTS;
> 
> Strictly speaking, we need to check BTS as well before clearing DS. BTS
> also depends on DS.

But BTS is already unconditionally disabled from the guest in patch 1/11.


> 
>>          env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_LBR;
>>      }
>>  
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index 5ab107dfa29f..0fecf561173e 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -483,6 +483,7 @@ typedef enum X86Seg {
>>  /* Indicates good rep/movs microcode on some processors: */
>>  #define MSR_IA32_MISC_ENABLE_FASTSTRING    (1ULL << 0)
>>  #define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL   (1ULL << 11)
>> +#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL  (1ULL << 12)
>>  #define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
>>  #define MSR_IA32_MISC_ENABLE_DEFAULT    (MSR_IA32_MISC_ENABLE_FASTSTRING     |\
>>                                           MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)


