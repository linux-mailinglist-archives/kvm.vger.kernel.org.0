Return-Path: <kvm+bounces-49911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE78ADF8FB
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDE574A23E1
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 21:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6225627E1B1;
	Wed, 18 Jun 2025 21:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="vRL+VCfQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6CB3085CC;
	Wed, 18 Jun 2025 21:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283798; cv=none; b=q6M2jXi/I7LE4yts+2GOfOKgLwmUNF5cIipB4B7/a7AFfzyAxYzEhek9yZVKsPHh2WsQPSj7b60sOctkAOUU9tNbT3oWROChIMH46IX4kt7m81tBsHcmpKPVj3pB8ps3uMxKPo9kRC3s8Lj4mFP5Rwtr9hGnR4g+lsBI79HDx7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283798; c=relaxed/simple;
	bh=fvGXz+xNX9iaAxQSDogvOS9k/q/JBZr5AdCHaYNG6SE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eEQDrt1JvOUThzPyuxo8nW2Sks+AI5MEwAXgYSbv74co+nHb4BzFaAMGJqzQ2L3/ETc/8xcP7YjxXcNd9xvBD19RAMQeJPi8vUEmMeSQYf+dj4DH3xndjJ/RbfWhTVuImRiedm8xm7LhlNAczZ1gSpLVPnD+37RKNDQ/Rits/mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=vRL+VCfQ; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55ILtuOd1734521
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 18 Jun 2025 14:55:56 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55ILtuOd1734521
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750283758;
	bh=puM42kcTAovjmQWW1no4m9dvbe+o/cW429QOEM8njwU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vRL+VCfQycs+GcU0imW3RUyWg8xb229EJz1tZwBR5mf4snuLeT9XiKGaRYV/fhBBQ
	 TdZQE/L2zr7zpkWgKxMmVAicPQi67sb9NjXuP4KLma3XLQYG1YAsn8mq2PPlK4PG7D
	 reA1ARtulk8Pt+W22Cl+0IJ+NILbtbI+FgV4aWUGlzCjjsI008pBGcjGlezBDhD2tF
	 +NlOjRxVpasWwcYXmkDjV0HgODxIYOJS5Vsv8rnT1W0Oyh9v2fByTVDHiYWOYKxDf3
	 MObAYl86SlrO4JjY4wtMn2D8jRBwX5unl3TTe3kYE98obV+zS7YBedx8buwICMtj6r
	 19z//CHW1iJkg==
Message-ID: <7480bb12-60a5-45ab-acb5-14f35c3f4782@zytor.com>
Date: Wed, 18 Jun 2025 14:55:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
To: Sean Christopherson <seanjc@google.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, peterz@infradead.org,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
References: <20250617073234.1020644-1-xin@zytor.com>
 <20250617073234.1020644-2-xin@zytor.com>
 <fa32b6e9-b087-495a-acf1-a28cfed7e28a@intel.com>
 <aFHUZh6koJyVi3p-@google.com>
 <25896236-de8d-4bd9-8a27-da407c0e5a38@zytor.com>
 <aFMudwy2uO5V8vM5@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aFMudwy2uO5V8vM5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/2025 2:24 PM, Sean Christopherson wrote:
> On Tue, Jun 17, 2025, Xin Li wrote:
>> On 6/17/2025 1:47 PM, Sean Christopherson wrote:
>>> On Tue, Jun 17, 2025, Sohil Mehta wrote:
>>> Note, DR6_VOLATILE and DR6_FIXED_1 aren't necessarily aligned with the current
>>> architectural definitions (I haven't actually checked),
>>
>> I'm not sure what do you mean by "architectural definitions" here.
> 
> I was trying to say that there may be bits that have been defined in the SDM,
> but are not yet makred as "supported" in DR6_VOLATILE, i.e. that are "incorrectly"
> marked as DR6_FIXED_1 (in quotes, because from KVM's perspective, the bits *are*
> fixed-1, for the guest).

Clear for me now, thanks for the explanation.

Wanted to echo that it's necessary to be in a KVM mindset sometimes.

>   
>> However because zeroing DR6 leads to different DR6 values depending on
>> whether the CPU supports BLD:
>>
>>    1) On CPUs with BLD support, DR6 becomes 0xFFFF07F0 (bit 11, DR6.BLD,
>>       is cleared).
>>
>>    2) On CPUs without BLD, DR6 becomes 0xFFFF0FF0.
>>
>> DR6_FIXED_1, if it is still defined to include all bits that can't be
>> cleared, is a constant value only on a *specific* CPU architecture,
>> i.e., it is not a constant value on all CPU implementations.
>>
>>
>>> rather they are KVM's
>>> view of the world, i.e. what KVM supports from a virtualization perspective.
>>
>> So KVM probably should expose the fixed 1s in DR6 to the guest depending on
>> which features, such as BLD or RTM, are enabled and visible to the
>> guest or not?
>>
>> (Sorry I haven't looked into how the macro DR6_FIXED_1 is used in KVM,
>> maybe it's already used in such a way)
> 
> Yep, that's exactly what KVM does.  DR6_FIXED_1 is the set of bits that KVM
> doesn't yet support for *any* guest.  The per-vCPU set of a fixed-1 bits starts
> with DR6_FIXED_1, and adds in bits for features that aren't supported/exposed
> to the guest.
> 
> static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
> {
> 	u64 fixed = DR6_FIXED_1;
> 
> 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RTM))
> 		fixed |= DR6_RTM;
> 
> 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
> 		fixed |= DR6_BUS_LOCK;
> 	return fixed;
> }

Excellent!

KVM is aware of BLD and behaves the same as real hardware, doing a
better job than native regarding this specific case.


