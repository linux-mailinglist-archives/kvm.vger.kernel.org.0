Return-Path: <kvm+bounces-68678-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLDjGPVhcGkVXwAAu9opvQ
	(envelope-from <kvm+bounces-68678-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 06:19:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A8939516D8
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 06:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 225E25A3422
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 05:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E47D36A027;
	Wed, 21 Jan 2026 05:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cYTpSL6z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40E336655D
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 05:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768972777; cv=none; b=pH1MnYNvZZzJQBKyqS71rOPMSG9JJ8+3tBi2A+P269fBQ4llD8GfEA02lj8OGnQC7D/FbVpM3TUEO4OettaNX98LLcRNblP3PrHYolCZ5GiTVA73c2bO0tbLFDfyIkvSuRMBl5zQQnfLbCNalAJIlV6qyHynn/2H/wzU1g25L4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768972777; c=relaxed/simple;
	bh=36eUIuF0FMwRHHdfsmDn9x6uLIz/x6CIt7c8I/nawr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xtn3gHLvQECc6RdRuV5vcuDRqnkQ7Zvhv+6fwrpD23w1q+KmCouRdpYT5tOcwKMQ8h9f9k+zbw8ZVTHCxBdpLcxlAHlwehxH59OyADjuPyRgVxPGMCqtCMTsSwWkE7NSZnIYJImLLBApazAtWJfPwdIPR/dJj2rnKHgSRy2fFRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cYTpSL6z; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768972776; x=1800508776;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=36eUIuF0FMwRHHdfsmDn9x6uLIz/x6CIt7c8I/nawr4=;
  b=cYTpSL6zLLUHOdjJ7aiBSJ/fehYuic48zvh6OUbxo+5UhxuPeMLl34Fq
   GIjgUOGPpuXQ48PMuVoNWnGD8wBS/b3jICh8VrEw/Cb0oWM0YC+prTgQ4
   XYJ96phdRGGFJLQt/fJ4fgPQd4faV/PWvBtcZ55SUtCoE29/HOkZKBQJN
   AERNi1E5drJWR1imtHxu/7kwY5+nqBYzcm5aSCtPa6congzEHAHY/KwYX
   S4KYE/sn5vvnT49iC355k4co1sfbTo+2FJBY66v0P2t+diREv2iOANnS1
   Nimq1/igxzEd2+APkFwDPwDj4eXgE8USTBrcmWy6Ef7gpYUQZ273An3UJ
   g==;
X-CSE-ConnectionGUID: 0Hn0qz4mRKepRiWMB00uSA==
X-CSE-MsgGUID: JhXBTHz9TuW76xIvPKwVmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="87606691"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="87606691"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 21:19:35 -0800
X-CSE-ConnectionGUID: lx9zVxU/T6e1wqxPpYZklQ==
X-CSE-MsgGUID: n5SLNxg+TUi9wrdEumSwog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="210788675"
Received: from unknown (HELO [10.238.3.254]) ([10.238.3.254])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 21:19:33 -0800
Message-ID: <c87ba875-5708-4ef9-8e75-5558d8b49b14@linux.intel.com>
Date: Wed, 21 Jan 2026 13:19:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] target/i386: Make some PEBS features user-visible
To: "Chen, Zide" <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
 <20260117011053.80723-7-zide.chen@intel.com>
 <56dd6056-e3e2-46cd-9426-87c7889bed49@linux.intel.com>
 <513c6944-b80a-46f2-ad6c-4de77dac4b09@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <513c6944-b80a-46f2-ad6c-4de77dac4b09@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68678-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: A8939516D8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On 1/21/2026 5:58 AM, Chen, Zide wrote:
>
> On 1/18/2026 7:30 PM, Mi, Dapeng wrote:
>> On 1/17/2026 9:10 AM, Zide Chen wrote:
>>> Populate selected PEBS feature names in FEAT_PERF_CAPABILITIES to make
>>> the corresponding bits user-visible CPU feature knobs, allowing them to
>>> be explicitly enabled or disabled via -cpu +/-<feature>.
>>>
>>> Once named, these bits become part of the guest CPU configuration
>>> contract.  If a VM is configured with such a feature enabled, migration
>>> to a destination that does not support the feature may fail, as the
>>> destination cannot honor the guest-visible CPU model.
>>>
>>> The PEBS_FMT bits are intentionally not exposed. They are not meaningful
>>> as user-visible features, and QEMU registers CPU features as boolean
>>> QOM properties, which makes them unsuitable for representing and
>>> checking numeric capabilities.
>> Currently KVM supports user space sets PEBS_FMT (see vmx_set_msr()), but
>> just requires the guest PEBS_FMT is identical with host PEBS_FMT.
> My mistake — this is indeed problematic.
>
> There are four possible ways to expose pebs_fmt to the guest when
> cpu->migratable = true:
>
> 1. Add a pebs_fmt option similar to lbr_fmt.
> This may work, but is not user-friendly and adds unnecessary complexity.
>
> 2. Set feat_names[8] = feat_names[9] = ... = "pebs-fmt".
> This violates the implicit rule that feat_names[] entries should be
> unique, and target/i386 does not support numeric features.
>
> 3. Use feat_names[8..11] = "pebs-fmt[1/2/3/4]".
> This has two issues:
> - It exposes pebs-fmt[1/2/3/4] as independent features, which is
> semantically incorrect.
> - Migration may fail incorrectly; e.g., migrating from pebs_fmt=2 to a
> more capable host (pebs_fmt=4) would be reported as missing pebs-fmt2.
>
> Given this, I propose the below changes. This may allow migration to a
> less capable destination, which is not ideal, but it avoids false
> “missing feature” bug and preserves the expectation that ensuring
> destination compatibility is the responsibility of the management
> application or the user.
>
> BTW, I am not proposing a generic “x86 CPU numeric feature” mechanism at
> this time, as it is unclear whether lbr_fmt and pebs_fmt alone justify
> such a change.
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 015ba3fc9c7b..b6c95d5ceb31 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1629,6 +1629,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>          .msr = {
>              .index = MSR_IA32_PERF_CAPABILITIES,
>          },
> +       .migratable_flags = PERF_CAP_PEBS_FMT,
>      },
>
>      [FEAT_VMX_PROCBASED_CTLS] = {
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 1666eff65300..de4074d6baa7 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -421,6 +421,7 @@ typedef enum X86Seg {
>
>  #define MSR_IA32_PERF_CAPABILITIES      0x345
>  #define PERF_CAP_LBR_FMT                0x3f
> +#define PERF_CAP_PEBS_FMT               0xf00
>  #define PERF_CAP_FULL_WRITE             (1U << 13)
>  #define PERF_CAP_PEBS_BASELINE          (1U << 14)

I can't say if this is the best way. Maybe @Zhao can give some comments.
Thanks.


>
>
>> IIRC, many places in KVM judges whether guest PEBS is enabled by checking
>> the guest PEBS_FMT. If we don't expose PEBS_FMT to user space, how does KVM
>> get the guest PEBS_FMT?
>>
>>
>>> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>> Signed-off-by: Zide Chen <zide.chen@intel.com>
>>> ---
>>>  target/i386/cpu.c | 6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index f1ac98970d3e..fc6a64287415 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -1618,10 +1618,10 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>>>          .type = MSR_FEATURE_WORD,
>>>          .feat_names = {
>>>              NULL, NULL, NULL, NULL,
>>> +            NULL, NULL, "pebs-trap", "pebs-arch-reg"
>>>              NULL, NULL, NULL, NULL,
>>> -            NULL, NULL, NULL, NULL,
>>> -            NULL, "full-width-write", NULL, NULL,
>>> -            NULL, NULL, NULL, NULL,
>>> +            NULL, "full-width-write", "pebs-baseline", NULL,
>>> +            NULL, "pebs-timing-info", NULL, NULL,
>>>              NULL, NULL, NULL, NULL,
>>>              NULL, NULL, NULL, NULL,
>>>              NULL, NULL, NULL, NULL,
>

