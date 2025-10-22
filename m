Return-Path: <kvm+bounces-60801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32824BFA6A7
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 09:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 250F83A7734
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E92D32F3C12;
	Wed, 22 Oct 2025 07:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kFP9CdYp"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313112F39CF
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 07:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761116472; cv=none; b=DK/VHqbXO8NcRZYZ9PkNPwXOnQblrp39NRr3qJhIHs4g8DSJQms5R0jsqmEIvib2s3Jbfavng3RtWVW0Zt6b+kEqU4OP+AUL8419jA+5nojY3BLJihd6lIIoQJCJ1zjpXUEmk0VNWBH4Kf0sDiScFytE/9Y4IIGhN+dt92eQEuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761116472; c=relaxed/simple;
	bh=9KEBoR2NF5SFNxXTP9ERe3gk24NqRNbTEKVIDs5duuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2m22Jld4wDpXbWQxyfgeiKxTXRR0dyZPlhFkXJ5CUX1Mip8amJMqMlt5tb60lS3D8k+KVmPYHm/Mq86W9/I5NSyJRAjvUQpzxJ/WdCwFs3s0AhqYIpcTc89oBUMFYzB+rgHv3R+yQfCVnYh4q0F80DzAdjckem71D2pRsJRghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kFP9CdYp; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 22 Oct 2025 00:00:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761116457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9KEBoR2NF5SFNxXTP9ERe3gk24NqRNbTEKVIDs5duuM=;
	b=kFP9CdYpXFhlbYcBxvLZpwKZovKdHaNAHaCCudWiy6suLIs0ODT5J9cVI2s04HjjfNbudz
	taiovlVK8FDkQ/YF3Dg6TrgQvASB2YIzETsutcZ331Oxg/BRyCyEec0l/wfjYuHU49Nrpj
	lI7AtI8dGYdJoVHpT7Gj8RouzUqRxzg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Make ID_PFR1_EL1.GIC writable
Message-ID: <aPiBH1_WZicoE7Od@linux.dev>
References: <20251013083207.518998-1-maz@kernel.org>
 <20251013083207.518998-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013083207.518998-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Mon, Oct 13, 2025 at 09:32:05AM +0100, Marc Zyngier wrote:
> Similarly to ID_AA64PFR0_EL1.GIC, relax ID_PFR1_EL1.GIC to be writable.

This looks fine to me, although I do wonder if we should just allow
userspace to write whatever value it wants to the 32-bit ID registers
and be done with it.

Nowhere do we use a 32-bit ID register value as a condition for trap
configuration / emulation, so even if the VMM lies to the guest it
shouldn't trip up KVM.

Thanks,
Oliver

