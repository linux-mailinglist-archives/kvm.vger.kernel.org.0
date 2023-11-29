Return-Path: <kvm+bounces-2728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 198B37FCFC0
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 08:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B416A1F20D3B
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 07:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A20110944;
	Wed, 29 Nov 2023 07:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5008BF
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 23:14:02 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B03FD1FB;
	Tue, 28 Nov 2023 23:14:49 -0800 (PST)
Received: from [10.163.33.248] (unknown [10.163.33.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 293473F6C4;
	Tue, 28 Nov 2023 23:13:58 -0800 (PST)
Message-ID: <aeefd47d-60a8-4011-bd26-f520b9333e20@arm.com>
Date: Wed, 29 Nov 2023 12:43:57 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] arm64: Rename reserved values for CTR_EL0.L1Ip
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231127172613.1490283-1-maz@kernel.org>
 <20231127172613.1490283-4-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20231127172613.1490283-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/27/23 22:56, Marc Zyngier wrote:
> We now have *two* values for CTR_EL0.L1Ip that are reserved.
> Which makes things a bit awkward. In order to lift the ambiguity,
> rename RESERVED (0b01) to RESERVED_AIVIVT, and VPIPT (0b00) to
> RESERVED_VPIPT.
> 
> This makes it clear which of these meant what, and I'm sure
> archeologists will find it useful...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/sysreg | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 96cbeeab4eec..5a217e0fce45 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2004,9 +2004,10 @@ Field	27:24	CWG
>  Field	23:20	ERG
>  Field	19:16	DminLine
>  Enum	15:14	L1Ip
> -	0b00	VPIPT
> +	# This was named as VPIPT in the ARM but now documented as reserved
> +	0b00	RESERVED_VPIPT
>  	# This is named as AIVIVT in the ARM but documented as reserved
> -	0b01	RESERVED
> +	0b01	RESERVED_AVIVT

s/RESERVED_AVIVT/RESERVED_AIVIVT - matches the spec. Commit message
has got this right.

>  	0b10	VIPT
>  	0b11	PIPT
>  EndEnum

