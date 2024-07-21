Return-Path: <kvm+bounces-22024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C06E938436
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 11:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A78F281560
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 09:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C046DF49;
	Sun, 21 Jul 2024 09:30:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CD7C8C0;
	Sun, 21 Jul 2024 09:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721554214; cv=none; b=b27pVxXiPzPzErBodyG7mL9bw7uR+VHucksntimBgFBHyjk35XoV/3zHl3TI10jL5o/PJFoP3HQVRxH1us+jzEMlkBXnMO14vrz9dQ81nDqhcoeWgTRG2Foqkk+lGOH3Y4iAEF0QS0kkaRb7K3+4loNUXruJYthzFsA/g46Hs4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721554214; c=relaxed/simple;
	bh=P9Dm/KqDUiaARIJA0JEaJstefwjo3CXgis2kj6FDLjQ=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=WZyUFuc1X+c05h9SsnVG+9vsY0UdTWr0UGzpK8zKnqRob3D7qN2OyBBVcc0ZrLropAt3B4XVK4/wTZwoFkqp8PhJ5/7wlwSHxGGPQ2MjIFwv7OKBwHglDjTLi6B5NqCZ+gxaAFEs6RsUg9LS03xYv3bYDNCEO8HJyLosyJcBmhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WRdPY6Nw5zdjZr;
	Sun, 21 Jul 2024 17:28:17 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 8682A180064;
	Sun, 21 Jul 2024 17:30:03 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 21 Jul 2024 17:30:02 +0800
Subject: Re: [PATCH] arm64/sysreg: Correct the values for GICv4.1
To: Raghavendra Rao Ananta <rananta@google.com>
CC: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
References: <20240718215532.616447-1-rananta@google.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ab66968b-3d56-caec-cfe1-b509307caf94@huawei.com>
Date: Sun, 21 Jul 2024 17:29:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240718215532.616447-1-rananta@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/7/19 5:55, Raghavendra Rao Ananta wrote:
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

Fortunately there is no user for this bit inside kernel. We had checked
against the correct hard-coded value (0x3) in gic_cpuif_has_vsgi().

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

