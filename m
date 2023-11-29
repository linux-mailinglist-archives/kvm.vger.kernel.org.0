Return-Path: <kvm+bounces-2724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2927FCF14
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 07:31:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B4ED1F20FEB
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 06:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AECB11197;
	Wed, 29 Nov 2023 06:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78048171D
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 22:31:27 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2944D1FB;
	Tue, 28 Nov 2023 22:32:14 -0800 (PST)
Received: from [10.163.33.248] (unknown [10.163.33.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8497C3F6C4;
	Tue, 28 Nov 2023 22:31:21 -0800 (PST)
Message-ID: <083c8502-9a0d-4876-b60a-bc26bb2ebabf@arm.com>
Date: Wed, 29 Nov 2023 12:01:18 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] arm64: Drop support for VPIPT i-cache policy
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231127172613.1490283-1-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20231127172613.1490283-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/27/23 22:56, Marc Zyngier wrote:
> ARMv8.2 introduced support for VPIPT i-caches, the V standing for
> VMID-tagged. Although this looks like a reasonable idea, no
> implementation has ever made it into the wild.
> 
> Linux has supported this for over 6 years (amusingly, just as the
> architecture was dropping support for AVIVT i-caches), but we had no
> way to even test it, and it is likely that this code was just
> bit-rotting.
> 
> However, in a recent breakthrough (XML drop 2023-09, tagged as
> d55f5af8e09052abe92a02adf820deea2eaed717), the architecture has
> finally been purged of this option, making VIPT and PIPT the only two
> valid options.

Indeed, FEAT_VPIPT has been dropped from the 2023-09 document release.

https://developer.arm.com/documentation/ddi0601/2023-06/AArch64-Registers/CTR-EL0--Cache-Type-Register

CTR_EL0.L1Ip[15:14] = 00 - VMID aware Physical Index, Physical tag (VPIPT) with FEAT_VPIPT

https://developer.arm.com/documentation/ddi0601/2023-09/AArch64-Registers/CTR-EL0--Cache-Type-Register

CTR_EL0.L1Ip[15:14] = 00 - Reserved.

