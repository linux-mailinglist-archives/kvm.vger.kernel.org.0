Return-Path: <kvm+bounces-45093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A29D9AA5F76
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:47:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA2D4981FC0
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018BE1C1F22;
	Thu,  1 May 2025 13:47:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9EE2EAE5;
	Thu,  1 May 2025 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746107231; cv=none; b=g4xlM0JIXO5GdZEHIOXNrsuKZb01KctbPbi6NgAV615v7ztdZbQdcp0ut2devj+R8i6IYYb+wqnV1foiKHke+znY3TPpnpubYroHYjYhOOt0CYKYd4pfIeYoRuhyUYzbbcSbfJuy9HlOzC7C/saxNrKe6AFI/aIFwFe8VdQzjFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746107231; c=relaxed/simple;
	bh=/a/p0KgdgwXQOmdA8fU5VhnO2KALgr9NefxVSc2NBkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kSWqzOZzkJwldWMN9l1knpmhfkB/8ZRU94J9CNcezpSQQVLDrIzipRxGn1IW9qJZdMRaNXrfS2C3Q4jdGdTxgh3tZajuLEwK3oq5XN5yhViKA4wk3jVY7inFJ8NEu5IPJe0Mo/2Bkjg5Dote2tTD5/KrvKOVtiLO+YNHbK5PsFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3BC701CC4;
	Thu,  1 May 2025 06:47:01 -0700 (PDT)
Received: from [10.1.37.71] (Suzukis-MBP.cambridge.arm.com [10.1.37.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B0E5E3F5A1;
	Thu,  1 May 2025 06:47:05 -0700 (PDT)
Message-ID: <9efc4db0-4264-4e8f-881e-2656c22a8b3e@arm.com>
Date: Thu, 1 May 2025 14:47:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/43] arm64: RME: Define the user ABI
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-7-steven.price@arm.com>
 <35a91f8c-cdf6-4595-9ed2-c792a8e9d679@arm.com>
 <961bd6f8-2c0c-47d7-991d-aab7d247ffa8@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <961bd6f8-2c0c-47d7-991d-aab7d247ffa8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01/05/2025 14:31, Steven Price wrote:
> On 28/04/2025 09:58, Suzuki K Poulose wrote:
>> Hi Steven
>>
>> On 16/04/2025 14:41, Steven Price wrote:
>>> There is one (multiplexed) CAP which can be used to create, populate and
>>> then activate the realm.
>>>
>>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v7:
>>>    * Add documentation of new ioctls
>>>    * Bump the magic numbers to avoid conflicts
>>> Changes since v6:
>>>    * Rename some of the symbols to make their usage clearer and avoid
>>>      repetition.
>>> Changes from v5:
>>>    * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>>>      KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
>>> ---
>>>    Documentation/virt/kvm/api.rst    | 70 +++++++++++++++++++++++++++++++

>>
>> May be rephrase it to:
>>
>> No changes can be made to Realm's memory (including the IPA state). No
>> new VCPUs can be created after this step.
> 
> I was attmepting to include that CONFIG_REALM cannot be called. How about:
> 
> 	Request the RMM to activate the realm. No
> 	changes can be made to the Realm's memory,
> 	IPA state or configuration parameters.  No
> 	new VCPUs can be created after this step.

Looks good to me, cheers

Suzuki


