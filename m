Return-Path: <kvm+bounces-20918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0357B926C68
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 01:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD7E51F234F9
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 23:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F134194A43;
	Wed,  3 Jul 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eRNfDrfN"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CC518C33E
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 23:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049130; cv=none; b=WfnWuKKWqeLBuNIJv2/kcubbaC/0uxCWv3/AoK45nRoQu1/VaEKEidLphQ6ebKoNztZKdW2RaV07e6u98b7z7W6XQ7/BWUzijxBFcC45IFNvNABcYPS+nC01OAGtQyp9DGa6u8lYtDbuBuPt/d1MbjuqFpOiT6SC1haOee1m00g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049130; c=relaxed/simple;
	bh=vQkkYYookm1SccwgPTp+zLqynes6an3LesJyQlYT2CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tPbpsOubrOPiSrogUDx7vtPy8TJP8Hpyu1aSrmvvY2TtUDcV+deiXY1YHBidRuFSj6g3xtp9KpPEYrWq55/u1DBL/Ti0jYn7lPgEdn/mtYvMM3KTfCx7wY5HEUoXO93T+YTpjBZhgaEMcFmcJWkokATHw0UCDYj7Kk4IkM+PJkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eRNfDrfN; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: oliver.upton@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720049125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8f2C+uPQ7mJKJ1v22Tj4TxmB+gRhlgbNvzJmy/2m/Jw=;
	b=eRNfDrfNXEISri4PDKmyemc/LvaCQ/C1TkwtfkZ4SZJzWw0YKGv4loCnH2wosFHOaZofR0
	u55R1FmXOWJasCKtrsYl1aTlEEOT7D9rKvp8/zT3yu2GFYGI/7/IeZ3uZtCZc/GqIyoY4L
	chHbVI47z4JRpKIfFeeHVd8OlCN/NM8=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: pbonzini@redhat.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: james.morse@arm.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH] MAINTAINERS: Include documentation in KVM/arm64 entry
Date: Wed,  3 Jul 2024 23:25:11 +0000
Message-ID: <172004909840.2946123.5315611063908366779.b4-ty@linux.dev>
In-Reply-To: <20240628222147.3153682-1-oliver.upton@linux.dev>
References: <20240628222147.3153682-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 28 Jun 2024 22:21:47 +0000, Oliver Upton wrote:
> Ensure updates to the KVM/arm64 documentation get sent to the right
> place.
> 
> 

Applied to kvmarm/next, thanks!

[1/1] MAINTAINERS: Include documentation in KVM/arm64 entry
      https://git.kernel.org/kvmarm/kvmarm/c/88a0a4f6068c

--
Best,
Oliver

