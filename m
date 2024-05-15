Return-Path: <kvm+bounces-17426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C39EA8C6551
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 13:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 502E32828F1
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 11:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DCF66DD08;
	Wed, 15 May 2024 11:10:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3985BAFC;
	Wed, 15 May 2024 11:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715771407; cv=none; b=NbkGOdqfq8hFSrIm9dKnQ0dVWuk35bZMcLO+fR2UJeEzgCKwSnsa7Cpm9mVe/0uUK8AKNySBYovlGJ+KNibrh2cGyRaAA034KNVi9jmrC8QqgO1hmQWpZPnMh/iirjoj191QmZ66ZFHbVStFVTsYtGOjnAi3IMOqZq80oixnvpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715771407; c=relaxed/simple;
	bh=DaChnHbMuBT0EbeOyLIHANpkyNbg7flUDNy6OkASHSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WsyNHvMCm8HRVOpp9h1Wyb69cbI/4oDK4o0k7wWFU58iswVhZ/VlQvmJupoRKyW0pqB+FH5tlVmM+ABrxUUHh+v3UTWL+yHaSsOqe32y33uPvv3MRzWdNnbS8575RwqtGCYdR8FtSXg/cjT7PAY//rTTgKA1PRW53LHa2oZiel4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E049C116B1;
	Wed, 15 May 2024 11:10:03 +0000 (UTC)
Date: Wed, 15 May 2024 12:10:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Sami Mujawar <sami.mujawar@arm.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 13/14] arm64: rsi: Interfaces to query attestation
 token
Message-ID: <ZkSYCYOWxKSV9t8S@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-14-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084213.1733764-14-steven.price@arm.com>

On Fri, Apr 12, 2024 at 09:42:12AM +0100, Steven Price wrote:
> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
> index b4cbeafa2f41..c1850aefe54e 100644
> --- a/arch/arm64/include/asm/rsi_cmds.h
> +++ b/arch/arm64/include/asm/rsi_cmds.h
> @@ -10,6 +10,9 @@
>  
>  #include <asm/rsi_smc.h>
>  
> +#define GRANULE_SHIFT		12
> +#define GRANULE_SIZE		(_AC(1, UL) << GRANULE_SHIFT)

The name is too generic and it goes into a header file. Also maybe move
it to rsi.h, and use it for other definitions like rsi_config struct
size and alignment.

-- 
Catalin

