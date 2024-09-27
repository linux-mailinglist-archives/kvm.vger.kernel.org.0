Return-Path: <kvm+bounces-27629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D002A988831
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 17:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4019EB233E3
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 15:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105BB1C1730;
	Fri, 27 Sep 2024 15:21:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CD31C172A;
	Fri, 27 Sep 2024 15:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727450491; cv=none; b=oTEkQXjVDOrpengE1wc2at8oYq9Rr/YrPmlzZT7aDgHqe9SO8l2TFmsq6lZkoFnKOIjHgyRbmJFQxJgt6lWUWrD/PL3VProfACPsBe7CF64hlUqpusU2RbW3YoYd1OH3tdJNldblUeqIIWdSc4JworIhZs8VZU9Rp69Al9iAkTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727450491; c=relaxed/simple;
	bh=1WCmFJhiKXxWGemw9OzjjWcFBusiAndw+m3K35nodxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r7b82AE4mro5rWyIHeTVyDuDcZSiDyEXC6krPe1k5EzluAcFQxv/DgWv8u2GqaGdixw5Y0u0E3VJNg5CltsHclG/6t4Enj3rwstzbZkh9lMixA8wUKLJIJXLMxjTwP9dWdQUAwzGtTF5KwWkEOtXXBlaqvVgWnNEt+sd353rNgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE0A314BF;
	Fri, 27 Sep 2024 08:21:57 -0700 (PDT)
Received: from [10.1.37.46] (e122027.cambridge.arm.com [10.1.37.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB4B83F587;
	Fri, 27 Sep 2024 08:21:21 -0700 (PDT)
Message-ID: <56886e2e-b5ce-4753-b36f-43d1d7ac427b@arm.com>
Date: Fri, 27 Sep 2024 16:21:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 19/19] virt: arm-cca-guest: TSM_REPORT support for
 realms
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, Sami Mujawar <sami.mujawar@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-20-steven.price@arm.com> <yq5aikveemnk.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5aikveemnk.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/09/2024 04:53, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> From: Sami Mujawar <sami.mujawar@arm.com>
>  
> ...
>  
>> --- /dev/null
>> +++ b/drivers/virt/coco/arm-cca-guest/Kconfig
>> @@ -0,0 +1,11 @@
>> +config ARM_CCA_GUEST
>> +	tristate "Arm CCA Guest driver"
>> +	depends on ARM64
>> +	default m
>> +	select TSM_REPORTS
>> +	help
>> +	  The driver provides userspace interface to request and
>> +	  attestation report from the Realm Management Monitor(RMM).
>> +
>> +	  If you choose 'M' here, this module will be called
>> +	  arm-cca-guest.
>>
> 
> Can we rename the generic Kconfig variable to ARM_CCA_TSM_REPORT?. Also
> should the directory be arm64-cca-guest?

This matches the existing sev-guest and tdx-guest directories (and
SEV_GUEST/TDX_GUEST_DRIVER kconfig), although I agree it's not great
naming as it stands.

But I'm also wondering if this will one day expand to include some other
communication with the RMM. For example I know it's been discussed
whether the guest should have involvement with firmware updates or
migration to another host. So there's a reasonable chance we could end
up renaming it back to a general "arm_cca_guest" if it grows more
capabilities in the future.

Steve


