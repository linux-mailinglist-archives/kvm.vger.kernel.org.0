Return-Path: <kvm+bounces-19315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4FAB903BC9
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:22:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 064651C2297C
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60AE617C7AF;
	Tue, 11 Jun 2024 12:22:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB3B17623D;
	Tue, 11 Jun 2024 12:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.175.24.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718108543; cv=none; b=UFdRm0EmWHIp/L4aFcFt+OmfhG6iVxqyoO22ZnkSJ1ozASKsRsTafI47bS/3miXrcca/PCdgqEeSHZxbI1AkSaPUiZ0kGZzIzJsG5Rkj8bIHAVvVhcICquGsn8WIfn5sX46cM5QfdPpV+6VmqKIfhfcQeJHDpCkjsmrsROHkYto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718108543; c=relaxed/simple;
	bh=HJ+Q9A0b0sRWunjfn/hvX1NjHm8Ef3Hcvu4jm5Haf+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HE8FOQBcbxjobL2fInOUZ9/CPksWJP3H/kozD9FT1qM8/JXztOCveuG5vEDzBuuYGQs/hHl8JfeLYjJ3P3+weewCSyitC/DLCeAvYtrEp9n79chwp9CJaTSnOy5iS0b6WKB+EMJ6mxxz7/JK9kksXMXj2ctZxR6n3iVtT/rocOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de; spf=pass smtp.mailfrom=alpha.franken.de; arc=none smtp.client-ip=193.175.24.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alpha.franken.de
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1sH0Vq-0002Bd-00; Tue, 11 Jun 2024 14:22:06 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id 60A9AC0120; Tue, 11 Jun 2024 13:15:44 +0200 (CEST)
Date: Tue, 11 Jun 2024 13:15:44 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-mips@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 0/4] MIPS: Loongson64: Sweeping build warnings
Message-ID: <Zmgx4CdyAiFuzOyR@alpha.franken.de>
References: <20240507-loongson64-warnings-v1-0-2cad88344e9e@flygoat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507-loongson64-warnings-v1-0-2cad88344e9e@flygoat.com>

On Tue, May 07, 2024 at 07:51:18PM +0100, Jiaxun Yang wrote:
> Hi all,
> 
> This series sweeped various build warnings for loongson3_defconfig.
> This is based on next-20240507.
> 
> There are still some warnings remain in pm.c, those errors are
> covered by [1].
> 
> Thanks
> 
> [1]: https://lore.kernel.org/linux-mips/20240507-loongson64-suspend-v1-0-534d92a4e09a@flygoat.com/
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
> To: Huacai Chen <chenhuacai@kernel.org>
> To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> To: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> To: Paolo Bonzini <pbonzini@redhat.com>
> To: Jiaxun Yang <jiaxun.yang@flygoat.com>
> To: Rob Herring <robh@kernel.org>
> To: Krzysztof Kozlowski <krzk+dt@kernel.org>
> To: Conor Dooley <conor+dt@kernel.org>
> Cc: linux-mips@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> 
> ---
> Jiaxun Yang (4):
>       MIPS: kvm: Declare prototype for kvm_init_loongson_ipi
>       MIPS: Loongson64: Include bootinfo.h in dma.c
>       MIPS: Loongson64: DTS: Fix msi node for ls7a
>       MIPS: Loongson64: DTS: Fix PCIe port nodes for ls7a
> 
>  arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi | 37 ++++++++++++++++++----
>  .../boot/dts/loongson/loongson64g_4core_ls7a.dts   |  1 +
>  arch/mips/kvm/interrupt.h                          |  4 +++
>  arch/mips/kvm/loongson_ipi.c                       |  2 ++
>  arch/mips/kvm/mips.c                               |  2 --
>  arch/mips/loongson64/dma.c                         |  1 +
>  6 files changed, 38 insertions(+), 9 deletions(-)

series applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

