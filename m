Return-Path: <kvm+bounces-21064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48ABA9295DF
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 01:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F28891F219CA
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 23:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D8C6D1C1;
	Sat,  6 Jul 2024 23:18:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5361BC43;
	Sat,  6 Jul 2024 23:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720307886; cv=none; b=M66HtU27tPUyDjUyZi6cIrkXA4frdUOs45f1TcqeFN2J9VbjhTYIvM05dDsHx74vvVHZdTuUUVE7G2CnWil0drA90GN40taxfkF6NT2r1vJBuMVtQFYbOsqYz5/nOyc7VBSnf2dU8QbwYemhnkA4wOhXQj2oTZZN4z4ft/aMxyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720307886; c=relaxed/simple;
	bh=h147tY+T4qXsjdmOCEDUfCo/SJ+vQI1Dcn9s8XTR6JQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MYbZ8/8wCfBnWU1WVyJljpW2uvqJMRgLfWfaJB5+SinlRsp7rM5CT2VDEcz2Za6PaHUwE9yP7caqSWwssLhZ6ygA2bBjIcIziisOY41VA6hSGx9UQw2mRquvisXqsWCQ0DVHE9NdghFQJR9I5uRkj7qYDSapxOVNADH8jEkRgf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WGmWt20yHz4w2P;
	Sun,  7 Jul 2024 09:18:02 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20240615-md-powerpc-arch-powerpc-kvm-v1-1-7478648b3100@quicinc.com>
References: <20240615-md-powerpc-arch-powerpc-kvm-v1-1-7478648b3100@quicinc.com>
Subject: Re: [PATCH] KVM: PPC: add missing MODULE_DESCRIPTION() macros
Message-Id: <172030785715.968037.15780100801784026220.b4-ty@ellerman.id.au>
Date: Sun, 07 Jul 2024 09:17:37 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Sat, 15 Jun 2024 08:18:59 -0700, Jeff Johnson wrote:
> With ARCH=powerpc, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/kvm/test-guest-state-buffer.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/kvm/kvm-pr.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/kvm/kvm-hv.o
> 
> Add the missing invocations of the MODULE_DESCRIPTION() macro.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: add missing MODULE_DESCRIPTION() macros
      https://git.kernel.org/powerpc/c/ca8dad0415162efea3597abe06b2025f34213eb5

cheers

