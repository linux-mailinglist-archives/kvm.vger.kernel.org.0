Return-Path: <kvm+bounces-17008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D13498BFF1E
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 716CC1F2651F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 13:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0967F126F04;
	Wed,  8 May 2024 13:42:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0008615C;
	Wed,  8 May 2024 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715175721; cv=none; b=U/3HaWDg9qx1S/RM91HXGObl8ZAXVNe8l5PaM2TQD8yhxWEXI6UCgkdAp6qJrgse6JvkAmtKGs/2Wp2A2CR5zV6xMnxpIVVewbi9XkHnC/UeTZcUVgBoY0Sjyg298eaYEEkRUkEfldC2gbbojjsCCf61IvzI556QL/GBUo7OC3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715175721; c=relaxed/simple;
	bh=Z3UoGjcVQojEIaroYcDyo95FKDRaXFaw6zcSksTz3Tg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YtZaB/RNSEVZtm/gmwF+1J2Q96jCQvVepr4PwOAwPjsZ+L8ENr0nwj9p2izN4Jj9ttlC1DZXGoyBLebGEykMHPQtjWZFjJUp2XtIGXqxo6nayjbbKPAY+uBsvRsgjz9wCPEAd37q9dqLBjSaBoObEvCoeDKWiB7SzRO7DoJPNBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VZGXR5Wghz4xDB;
	Wed,  8 May 2024 23:41:59 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Michael Ellerman <mpe@ellerman.id.au>, Christophe Leroy <christophe.leroy@csgroup.eu>, Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux@ew.tq-group.com
In-Reply-To: <20240124105031.45734-1-matthias.schiffer@ew.tq-group.com>
References: <20240124105031.45734-1-matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH] powerpc: rename SPRN_HID2 define to SPRN_HID2_750FX
Message-Id: <171517558558.165093.2026366324457459260.b4-ty@ellerman.id.au>
Date: Wed, 08 May 2024 23:39:45 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Wed, 24 Jan 2024 11:50:31 +0100, Matthias Schiffer wrote:
> This register number is hardware-specific, rename it for clarity.
> 
> FIXME comments are added in a few places where it seems like the wrong
> register is used. As I can't test this, only the rename is done with no
> functional change.
> 
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc: rename SPRN_HID2 define to SPRN_HID2_750FX
      https://git.kernel.org/powerpc/c/ad679719d7020a200c4a10248ebb3bbb374d423d

cheers

