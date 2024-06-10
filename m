Return-Path: <kvm+bounces-19232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 531249023CA
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 070761F21104
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 14:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2066781729;
	Mon, 10 Jun 2024 14:14:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADD271B45;
	Mon, 10 Jun 2024 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718028870; cv=none; b=L29jjmfkQ+ur8fBwiOYp1TjiEhp8an7nxTU54E2gHuO4nrkOnjUeDWb5aE0BYCqSZ5SPAWwKsDKAkOzHNd4a4BO/bRPGFdZbSTHdMqjt/8WcBJ8O+X3zV28W9AXhWxDqlRJ4RskZm5tUxVCKkotQtx992zKrzL1Qvi1kT6c1ADs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718028870; c=relaxed/simple;
	bh=/RnFbqFrkgtxJGH9Ucg1ZU3e+IiD8Bt8Skqc2diIr0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JONyyoXRDcROpYgMtgHt23Lq0Cgls9Zn6DGmAr1d4/AFwpmOmQCS60rVBg4P7bhjQESrAS9E/DfZdST74z6QOSaGnxhTzq7H7uM75xS70y6PKA7Oh2S/v8Wf5dAvNgXEqSOKt7XJimbIwoCbSvc8kS+mIJmX5vt0HHD8j7bLo6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8A2C2BBFC;
	Mon, 10 Jun 2024 14:14:26 +0000 (UTC)
Date: Mon, 10 Jun 2024 15:14:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 01/14] arm64: rsi: Add RSI definitions
Message-ID: <ZmcKQHvqYmuDTNTf@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-2-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605093006.145492-2-steven.price@arm.com>

On Wed, Jun 05, 2024 at 10:29:53AM +0100, Steven Price wrote:
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi_cmds.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RSI_CMDS_H
> +#define __ASM_RSI_CMDS_H
[...]
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi_smc.h
> @@ -0,0 +1,142 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __SMC_RSI_H_
> +#define __SMC_RSI_H_

A small nitpick if you respin some patches - please make the header
guards consistent. We tend to to use the top variant above, so the
rsi_smc.h would be __ASM_RSI_SMC_H. The same throughout this series.

-- 
Catalin

