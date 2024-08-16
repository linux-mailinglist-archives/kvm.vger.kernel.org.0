Return-Path: <kvm+bounces-24403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E71954E6F
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48DFC1C22AF8
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 16:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80DD01BE86E;
	Fri, 16 Aug 2024 16:06:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5581BDA87;
	Fri, 16 Aug 2024 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723824391; cv=none; b=Xobx+jOWS3DzBpzdGt7lV/tTYrqnyJriLLe+QnRSgIFckzhc7Ha5pH0QAky7UN3wyryjz6q7sEF6+wPMXL3OcYI7Y+b3ciwcOtrl1Yrf8g056c5/PlnEfmOrZou/R/OUt3CoaIE/9ftDYYQR23uH+tlbyk9LjjpdTWVcjIhdPPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723824391; c=relaxed/simple;
	bh=37h/oRDfh6L4BPlZhucfApa/80jVTHA6BUgyGnnHCjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJauXQkuIrP1lxYLPJbOHtyX/Cu5wl978Sk4e6qjHGn0TogQXGqT624agarnH5v6DIol8HUvCPXV2s6PJoTXyBoH+smBvjl2+gG8JhS1L8oNrf0dkkBMJYm3JHcMX2fDvYkTwISuHrGmuy8aIUC5hrZkEaRgah/oumMAR+VQIJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C928013D5;
	Fri, 16 Aug 2024 09:06:54 -0700 (PDT)
Received: from [10.1.34.14] (e122027.cambridge.arm.com [10.1.34.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44E003F58B;
	Fri, 16 Aug 2024 09:06:26 -0700 (PDT)
Message-ID: <27c942e0-0e7c-4e71-b1df-1a8f70df5411@arm.com>
Date: Fri, 16 Aug 2024 17:06:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/15] arm64: Support for running as a guest in Arm CCA
To: Shanker Donthineni <sdonthineni@nvidia.com>,
 Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <ZpDvTXMDq6i+4O0m@fedora> <09fdebd7-32a0-4a88-9002-0f24eebe00a8@nvidia.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <09fdebd7-32a0-4a88-9002-0f24eebe00a8@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 15/08/2024 23:16, Shanker Donthineni wrote:
> Hi Steven,
> 
> On 7/12/24 03:54, Matias Ezequiel Vara Larsen wrote:
>> On Mon, Jul 01, 2024 at 10:54:50AM +0100, Steven Price wrote:
>>> This series adds support for running Linux in a protected VM under the
>>> Arm Confidential Compute Architecture (CCA). This has been updated
>>> following the feedback from the v3 posting[1]. Thanks for the feedback!
>>> Individual patches have a change log. But things to highlight:
>>>
>>>   * a new patch ("firmware/psci: Add psci_early_test_conduit()") to
>>>     prevent SMC calls being made on systems which don't support them -
>>>     i.e. systems without EL2/EL3 - thanks Jean-Philippe!
>>>
>>>   * two patches dropped (overriding set_fixmap_io). Instead
>>>     FIXMAP_PAGE_IO is modified to include PROT_NS_SHARED. When support
>>>     for assigning hardware devices to a realm guest is added this will
>>>     need to be brought back in some form. But for now it's just adding
>>>     complixity and confusion for no gain.
>>>
>>>   * a new patch ("arm64: mm: Avoid TLBI when marking pages as valid")
>>>     which avoids doing an extra TLBI when doing the break-before-make.
>>>     Note that this changes the behaviour in other cases when making
>>>     memory valid. This should be safe (and saves a TLBI for those
>>> cases),
>>>     but it's a separate patch in case of regressions.
>>>
>>>   * GIC ITT allocation now uses a custom genpool-based allocator. I
>>>     expect this will be replaced with a generic way of allocating
>>>     decrypted memory (see [4]), but for now this gets things working
>>>     without wasting too much memory.
>>>
>>> The ABI to the RMM from a realm (the RSI) is based on the final RMM v1.0
>>> (EAC 5) specification[2]. Future RMM specifications will be backwards
>>> compatible so a guest using the v1.0 specification (i.e. this series)
>>> will be able to run on future versions of the RMM without modification.
>>>
>>> This series is based on v6.10-rc1. It is also available as a git
>>> repository:
>>>
>>> https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v4
> 
> Which cca-host branch should I use for testing cca-guest/v4?
> 
> I'm getting compilation errors with cca-host/v3 and cca-guest/v4, is there
> any known WAR or fix to resolve this issue?

cca-host/v3 should work with cca-guest/v4. I've been working on
rebasing/updating the branches and should be able to post v4/v5 series
next week.

> 
> arch/arm64/kvm/rme.c: In function ‘kvm_realm_reset_id_aa64dfr0_el1’:
> ././include/linux/compiler_types.h:487:45: error: call to
> ‘__compiletime_assert_650’ declared with attribute error: FIELD_PREP:
> value too large for the field
>   487 |         _compiletime_assert(condition, msg,
> __compiletime_assert_, __COUNTER__)
>       |                                             ^
> ././include/linux/compiler_types.h:468:25: note: in definition of macro
> ‘__compiletime_assert’
>   468 |                         prefix ##
> suffix();                             \
>       |                         ^~~~~~
> ././include/linux/compiler_types.h:487:9: note: in expansion of macro
> ‘_compiletime_assert’
>   487 |         _compiletime_assert(condition, msg,
> __compiletime_assert_, __COUNTER__)
>       |         ^~~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:39:37: note: in expansion of macro
> ‘compiletime_assert’
>    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond),
> msg)
>       |                                     ^~~~~~~~~~~~~~~~~~
> ./include/linux/bitfield.h:68:17: note: in expansion of macro
> ‘BUILD_BUG_ON_MSG’
>    68 |                 BUILD_BUG_ON_MSG(__builtin_constant_p(_val)
> ?           \
>       |                 ^~~~~~~~~~~~~~~~
> ./include/linux/bitfield.h:115:17: note: in expansion of macro
> ‘__BF_FIELD_CHECK’
>   115 |                 __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP:
> ");    \
>       |                 ^~~~~~~~~~~~~~~~
> arch/arm64/kvm/rme.c:315:16: note: in expansion of macro ‘FIELD_PREP’
>   315 |         val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps - 1) |
>       |                ^~~~~~~~~~
> make[5]: *** [scripts/Makefile.build:244: arch/arm64/kvm/rme.o] Error 1
> make[4]: *** [scripts/Makefile.build:485: arch/arm64/kvm] Error 2
> make[3]: *** [scripts/Makefile.build:485: arch/arm64] Error 2
> make[3]: *** Waiting for unfinished jobs....
> 
> I'm using gcc-13.3.0 compiler and cross-compiling on X86 machine.

I'm not sure quite how this happens. The 'value' (bps - 1) shouldn't be
considered constant, so I don't see how the compiler has decided to
complain here - the __builtin_constant_p() should really be evaluating to 0.

The only thing I can think of is if the compiler has somehow determined
that rmm_feat_reg0 is 0 - which in theory it could do if it knew that
kvm_init_rme() cannot succeed (rmi_features() would never be called, so
the variable will never be set). Which makes me wonder if you're
building with a PAGE_SIZE other than 4k?

Obviously the code should still build if that's the case (so this would
be a bug) but we don't currently support CCA with PAGE_SIZE != 4k.

Steve


