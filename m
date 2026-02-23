Return-Path: <kvm+bounces-71462-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yGo8LDIenGkZ/wMAu9opvQ
	(envelope-from <kvm+bounces-71462-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 10:30:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D0BF173EDA
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 10:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C33663038A40
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 09:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E9734EF19;
	Mon, 23 Feb 2026 09:29:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B1B137750;
	Mon, 23 Feb 2026 09:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771838951; cv=none; b=o288TXwrtqvEBZ27lmFyy3Y7LP+3f7notuAyLgZwXSffnM9O85/5nqWLtbiqg0ynjCVmaTtOU0n8gYwNgrULvxloPe8s35ICJNn/RzVt64M4LgluBxsruybmFaLRvueyS0PZNKRX8/OaBKx8Zqth6ukUuEmpr+TlZUL5g4eVYRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771838951; c=relaxed/simple;
	bh=w4etiE/+EmBNKw+Rwntrs8cBeDHziVbShKF2A2tYndM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aijKvhMuXvnTYrUfqjvL2FcIO1Zq87dXde6jHqW0rLeEd1QpkA2rgNaMZkBJZLbRPZ2CgA2RxLbMNqrNlH5sD4HesW+7Jz67ppM/qPQ50QYTlotStwVI232CFzU/SwMY49bxIfzH2mkMglmQ07VRIu4pohFiCm/zr3aCYnoNtkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD188339;
	Mon, 23 Feb 2026 01:29:02 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 437983F62B;
	Mon, 23 Feb 2026 01:29:02 -0800 (PST)
Message-ID: <1ef69ded-a5a5-401b-b91f-c4c43a2e2263@arm.com>
Date: Mon, 23 Feb 2026 09:29:00 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, "Moger, Babu" <bmoger@amd.com>,
 corbet@lwn.net, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
 <5857f3a0-999a-46ed-a36f-d2b02d04274a@arm.com>
 <68b6693c-a665-4c1a-ba5f-b6430a090e0c@intel.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <68b6693c-a665-4c1a-ba5f-b6430a090e0c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71462-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[45];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ben.horgan@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.966];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1D0BF173EDA
X-Rspamd-Action: no action

Hi Reinette,

On 2/20/26 18:39, Reinette Chatre wrote:
> Hi Ben,
> 
> On 2/20/26 2:07 AM, Ben Horgan wrote:
>>
>> I haven't fully understood what GLBE is but in MPAM we have an optional
>> feature in MSC (MPAM devices) called partid narrowing. For some MSC
>> there are limited controls and the incoming partid is mapped to an
>> effective partid using a mapping. This mapping is software controllable.
>> Dave (with Shaopeng and Zeng) has a proposal to use this to use partid
>> bits as pmg bits, [1]. This usage would have to be opt-in as it changes
>> the number of closid/rmid that MPAM presents to resctrl. If however, the
>> user doesn't use that scheme then the controls could be presented as
>> controls for groups of closid in resctrl. Is this similar/usable with
>> the same interface as GLBE or have I misunderstood?
>>
>> [1]
>> https://lore.kernel.org/linux-arm-kernel/20241212154000.330467-1-Dave.Martin@arm.com/
> 
> On a high level these look like different capabilities to me but I look forward to
> hear from others to understand where I may be wrong.
> 
> As I understand the feature you refer to is a way in which MPAM can increase the
> number of hardware monitoring IDs available(*). It does so by using the PARTID
> narrowing feature while taking advantage of the fact that PARTID for filtering
> resource monitors is always a "request PARTID". In itself I understand the PARTID
> narrowing feature to manage how resource allocation of a *single* "MPAM component"
> is managed.
> 
> On the other hand I see GLBE as a feature that essentially allows the scope of
> allocation to span multiple domains/components.
> 
> As I see it, applying GLBE to MPAM would need the capability to, for example,
> set a memory bandwidth MAX that is shared across multiple MPAM components.

Thanks for the explanation. They do seem like orthogonal features. Sorry
for the noise.

> 
> Reinette
> 
> * as a sidenote it is not clear to me why this would require an opt-in since
>   there only seems benefits to this.

On systems with a mix of intPARTID capable and non-intPARTID capable MSC
(with more partids) then on the non-intPARTID capable MSC you'll have to
use 2 partids as one and can then not use max per partid controls on
that component. Also, when using cdp on the caches we may want to use
partid narrowing to hide it for memory allocation.  However, it might be
sensible to make the monitoring id increase the default for some shapes
of platform.

> 

Thanks,

Ben


