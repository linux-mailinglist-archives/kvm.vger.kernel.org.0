Return-Path: <kvm+bounces-45697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAB2AAD97B
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 10:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B7037BEB31
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 07:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C0A221704;
	Wed,  7 May 2025 07:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="krCymqbL"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F568221554
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 07:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746604632; cv=none; b=a8RcJ0i+X4Lt2T3j4XDH12Td+o5eGUrD1M5GWPkLOlLxCFyAublBA3JMsxoHZTlk8shYlSsO6Bi4Mx8H2idgDut8NS23QKolflPgNsyF9ppTUhFrqOKUUwtnILcEVKE/tMHxR2J564iMlpvsg4jtcIeQ6GlJDR0Gq2bTm5+Gg14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746604632; c=relaxed/simple;
	bh=uuJWPfHJXcnB4dBIwpisrMyjhNK9JSAOkWSSPue3dkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RpJ7O6Flp6GgC31ExWKEJuVVyvFbgmL0IdyDtTghxFYIT7isOzbLv8qIpe0OnBDFFtWzYQwu9ZeLFd2UIpHxgHjUfkGGj2xquE+lUOCQ6e7nIsGmkeauUohIJHXrhmGL2dpk/Fg5r+1Ral/aOQVt5PKt0a3GdRzhQkTY8ZVk6+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=krCymqbL; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746604626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nHAbVa6E1A/wHvD5/4+iVSocKc6b/G3IZErcqqcFL0s=;
	b=krCymqbLFkpq88vV/Mhy4It39SJqdhzNcJtBDki6dLsYGxo/0LkfTarWJ4hw2m9MsghJ/K
	dUDJZJvsi5y+TSOOUJd78Eap71hGr0jO49hbYlhznHBcDrCkTufg5nfuPxwd6IIuomgo+X
	NfzwyoYrIAvLzcA73mtDg0KTiSdOQAI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Make AArch64 support sticky
Date: Wed,  7 May 2025 00:56:49 -0700
Message-Id: <174660459090.2542293.281555922316726481.b4-ty@linux.dev>
In-Reply-To: <20250429114117.3618800-1-maz@kernel.org>
References: <20250429114117.3618800-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 29 Apr 2025 12:41:15 +0100, Marc Zyngier wrote:
> It's been recently reported[1] that our sorry excuse for a test suite
> is writing a bunch of zeroes to ID_AA64PFR0_EL1.EL{0,1,2,3},
> effectively removing the advertised support for AArch64 to the guest.
> 
> This leads to an interesting interaction with the NV code which reacts
> in a slightly overzealous way and inject an UNDEF at the earliest
> opportunity.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Prevent userspace from disabling AArch64 support at any virtualisable EL
      https://git.kernel.org/kvmarm/kvmarm/c/7af7cfbe78e2
[2/2] KVM: arm64: selftest: Don't try to disable AArch64 support
      https://git.kernel.org/kvmarm/kvmarm/c/b60e285b6acd

--
Best,
Oliver

