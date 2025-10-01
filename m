Return-Path: <kvm+bounces-59320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2521BB1173
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3F76189196F
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA02D27B35F;
	Wed,  1 Oct 2025 15:35:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2E3223DD1;
	Wed,  1 Oct 2025 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759332908; cv=none; b=RzPnRqcOhXrCfKRWMmxlO+mRjIS57+EYBBbnRMETFDk4zrCicK8U6XgeGE2MhjijJl6CxxWsKDn5qleLAqG9kxk3F5Hfu3PYMUrYBXv/jr9/i8XeLMeu8lJ/rw8ipN1hrrtNji7BsvAWFoIEQoz3hv9VuTL/TUckebecNuRbri8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759332908; c=relaxed/simple;
	bh=59Mqh0CdSpOWIsPEyEauP63ultt2BPHEwJ6nY4gUEKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q4G98jP0AQ9oBO8vg1f+Gw/YtB9GYBKi6ZH2VEkdyccdFUBEa93AHYdEZQxutLltW6FNvJJty0vBoTxdADvMJoI+Rmw276EYTSPa4TSL1sIxmC2t8BYToLkQapra+xvuZJwPbpCW4owFpvl5iYUhABS/dPtFYHLAY1o7+CzLrmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 608601692;
	Wed,  1 Oct 2025 08:34:58 -0700 (PDT)
Received: from [10.57.0.204] (unknown [10.57.0.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1A183F59E;
	Wed,  1 Oct 2025 08:35:01 -0700 (PDT)
Message-ID: <99de8b04-7e7d-404b-aab8-5759a1f28c1a@arm.com>
Date: Wed, 1 Oct 2025 16:34:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/43] arm64: RME: Check for RME support at KVM init
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-6-steven.price@arm.com> <86ms6azxt5.wl-maz@kernel.org>
 <2226e62f-76ca-4467-a8ae-460fd463df0a@arm.com> <86h5wizqvn.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86h5wizqvn.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/10/2025 14:35, Marc Zyngier wrote:
> On Wed, 01 Oct 2025 14:20:13 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>>>> +static int rmi_check_version(void)
>>>> +{
>>>> +	struct arm_smccc_res res;
>>>> +	unsigned short version_major, version_minor;
>>>> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>>>> +						     RMI_ABI_MINOR_VERSION);
>>>> +
>>>> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
>>>
>>> Shouldn't you first check that RME is actually available, by looking
>>> at ID_AA64PFR0_EL1.RME?
>>
>> Well, you made a good point above that this isn't RME, it's CCA. And I
>> guess there's a possible world where the CCA interface could be
>> supported with something other than FEAT_RME (FEAT_RME2 maybe?) so I'm
>> not sure it necessarily a good idea to pin this on a CPU feature
>> bit.
> 
> But you cannot have CCA without RME. You cannot have CCA with
> GICv3. And my point was more that RME could be used by something other
> than CCA  - I certainly don't anticipate someone else adopting the CCA
> interface for anything...
> 
>> Ultimately what we want to know is whether the firmware thinks it can
>> supply us with the CCA interface and we don't really care how it
>> achieves it.
> 
> I disagree. You rely on specific feature sets to be available (hell,
> everything is baked around GICv3... GICv5 anyone?).
> 
> For this sort of stuff, you absolutely need to know what you are
> running on, not what some broken firmware tries to pretend it is.

Well I don't agree, but equally I think the chances of the RMM interface
existing without RME is nil, so I guess the extra check doesn't really
matter. So I'll add it. In the (highly) unlikely event that it causes a
problem then it would be easy enough to remove.

Thanks,
Steve


