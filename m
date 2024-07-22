Return-Path: <kvm+bounces-22039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9FB938B64
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 10:40:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01911C211CC
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 08:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A98A16A37C;
	Mon, 22 Jul 2024 08:40:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860BF35280;
	Mon, 22 Jul 2024 08:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721637602; cv=none; b=E2rqpzAntBGMKQV5WotKann8nliqDp3Oto0/mbVZGYHecPpamPmuTUXYqqVpuY8omQFF1KSMq1zQGqeCzUxHpoUUw3FT2IDQcT7xNc2qFXJqFSaxp/kzLBHl5PHqujyFdHD7ZUCO9apggLVcCqA8GLgo/79TmlMExL5KejSQ8JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721637602; c=relaxed/simple;
	bh=ncs6m08XL3Rtle4jkWhhGYwkPc99G2aXkxvhLe83aO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W6b8jzuEKwKGB46eHlJ9UEOCc0MY7R8ZBko9D1sqeubLtyoI9Rt1Xpz7IKlMerQpDhs4k1PVZOR+Bz2zQwyhZ+55alXClNXCl0CBe4A2W0E9wn855lz9RBKmVTE/u84U+QMovhV1QlDBj6U9js0Bk2lUJaIWhbO8JjrHPnBDoSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 825DE367;
	Mon, 22 Jul 2024 01:40:24 -0700 (PDT)
Received: from [10.162.41.8] (a077893.blr.arm.com [10.162.41.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6E4F3F73F;
	Mon, 22 Jul 2024 01:39:55 -0700 (PDT)
Message-ID: <c324b32d-a932-44c2-9d16-445b604d2eb5@arm.com>
Date: Mon, 22 Jul 2024 14:09:52 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/sysreg: Correct the values for GICv4.1
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240718215532.616447-1-rananta@google.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240718215532.616447-1-rananta@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/19/24 03:25, Raghavendra Rao Ananta wrote:
> Currently, sysreg has value as 0b0010 for the presence of GICv4.1 in
> ID_PFR1_EL1 and ID_AA64PFR0_EL1, instead of 0b0011 as per ARM ARM.
> Hence, correct them to reflect ARM ARM.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/tools/sysreg | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a4c1dd4741a47..7ceaa1e0b4bc2 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -149,7 +149,7 @@ Res0	63:32
>  UnsignedEnum	31:28	GIC
>  	0b0000	NI
>  	0b0001	GICv3
> -	0b0010	GICv4p1
> +	0b0011	GICv4p1
>  EndEnum
>  UnsignedEnum	27:24	Virt_frac
>  	0b0000	NI
> @@ -903,7 +903,7 @@ EndEnum
>  UnsignedEnum	27:24	GIC
>  	0b0000	NI
>  	0b0001	IMP
> -	0b0010	V4P1
> +	0b0011	V4P1
>  EndEnum
>  SignedEnum	23:20	AdvSIMD
>  	0b0000	IMP
> 
> base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd

This checks against ARM DDI 0487K.a and ddi0601/2024-06 XML.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

