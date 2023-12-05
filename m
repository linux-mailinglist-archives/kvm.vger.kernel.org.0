Return-Path: <kvm+bounces-3431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79DB980446A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 767B01F2138A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B494A0C;
	Tue,  5 Dec 2023 02:04:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DE59101
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 18:04:36 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87EDA1474;
	Mon,  4 Dec 2023 18:05:22 -0800 (PST)
Received: from [10.163.35.139] (unknown [10.163.35.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 155843F5A1;
	Mon,  4 Dec 2023 18:04:31 -0800 (PST)
Message-ID: <2dfb07f4-39c3-4cfe-81ba-416c18f99b10@arm.com>
Date: Tue, 5 Dec 2023 07:34:28 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] arm64: Rename reserved values for CTR_EL0.L1Ip
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231204143606.1806432-1-maz@kernel.org>
 <20231204143606.1806432-4-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20231204143606.1806432-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/4/23 20:06, Marc Zyngier wrote:
> We now have *two* values for CTR_EL0.L1Ip that are reserved.
> Which makes things a bit awkward. In order to lift the ambiguity,
> rename RESERVED (0b01) to RESERVED_AIVIVT, and VPIPT (0b00) to
> RESERVED_VPIPT.
> 
> This makes it clear which of these meant what, and I'm sure
> archeologists will find it useful...
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/tools/sysreg | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 96cbeeab4eec..c5af75b23187 100644
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
> +	0b01	RESERVED_AIVIVT
>  	0b10	VIPT
>  	0b11	PIPT
>  EndEnum

