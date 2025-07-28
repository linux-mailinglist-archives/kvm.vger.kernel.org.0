Return-Path: <kvm+bounces-53529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F3FB13606
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 10:05:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC2CA7A5B06
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 08:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24045224240;
	Mon, 28 Jul 2025 08:05:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFC821171D;
	Mon, 28 Jul 2025 08:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.175.24.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753689943; cv=none; b=PGi+BVuOiUWlWEzQefIo4tyEs0eSKa2pfap0Llwwkgcky47OiXKRflG1UZKGYfEEqZAUsPIK4V05hRAb6WUkd+PXKTw6PMnvYfCxot/TjefeQ9o0KfxtvQDVeiI7dK5xfhgUJhlCSIlkV1PPHPCI5veikbAZ0MVs/Iwfjtwu1+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753689943; c=relaxed/simple;
	bh=6JgSIWz0uXkE8A7gc81GbAoQ+FWUTjTMENnNbm7nmg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2vRqpN2YaJEDmvfcvpRELQojKtR5wsk7Gfw2iOU+8kW4S2Z8xUUw6XUTW+ayLUCFGABaGdZwxhSMuU9KI/KvU621KG0Dw+KeBB9dGH9c8tR951CYhGmA9FVqVEkMPRO02466gPzzVsB5AxDkQW4tDOoSHYSfwn4memeuy6N0q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de; spf=pass smtp.mailfrom=alpha.franken.de; arc=none smtp.client-ip=193.175.24.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alpha.franken.de
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1ugIrY-0003qP-00; Mon, 28 Jul 2025 10:05:36 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id 6DDDDC0765; Mon, 28 Jul 2025 10:01:31 +0200 (CEST)
Date: Mon, 28 Jul 2025 10:01:31 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND] MIPS: Don't use %pK through printk
Message-ID: <aIcuWxhtNrULHvnO@alpha.franken.de>
References: <20250718-restricted-pointers-mips-v1-1-45de40dcc662@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250718-restricted-pointers-mips-v1-1-45de40dcc662@linutronix.de>

On Fri, Jul 18, 2025 at 03:18:24PM +0200, Thomas Weiﬂschuh wrote:
> Restricted pointers ("%pK") are not meant to be used through printk().
> It can unintentionally expose security sensitive, raw pointer values.
> 
> Use regular pointer formatting instead.
> 
> Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
> Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> ---
>  arch/mips/kernel/relocate.c | 10 +++++-----
>  arch/mips/kvm/mips.c        |  2 +-
>  arch/mips/mm/physaddr.c     |  2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

