Return-Path: <kvm+bounces-10361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8AAA86C0C9
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 259C5286E08
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532E64778B;
	Thu, 29 Feb 2024 06:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EhT6p143"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E610A45BFB
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188694; cv=none; b=L2rV0cwyeHc/lcPWtVxEOP739LbyvEvqanaWx4idoto2ob6MxLrGbxjIcCQrNiHKDI6Wg7JAPrvtfIacEyzxy60UUKOlozHGFEe60tTBimyKdkeJwCqEEqWJrapsLSYKeylrwDxTgtdFYHVwjbc9l5RpUsdfRuavoj1FxUbKk9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188694; c=relaxed/simple;
	bh=f7Yna66xFG6vgioX6UL9PlBV2R7eM20PlgwlQJeASr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GiMXBk8DWL6XNmxK4+hQ38YU4zd4hniJwSaeMBXYraSCLp5PiA0hy+JxFiESguM/TQx9CYY7AGRQwhduy9Q2Wa3tswIlmsPL7xEeuQLi+CC6psy2YvQOE3uN1rv6cQNL9AwK7nfaTO/3MGhn5K+c+Ca5K3Q+oiSLfqs7lFQUmFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EhT6p143; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709188691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KleE8wCACo4AS2Lz1c1ZuEjwPGn5dN3YYkDl6gBcdAY=;
	b=EhT6p1435Co6cQj+sn/gyZito+xuJPmXdzTGNsyshbFCooGKO3DwiR3EW9lhB2xvtquWC1
	DyaLUSg1Fr6HHeLPzqxCUMsCxBPvp+rLqo7f7zuuKOgODHB/N/ec7zXuOjsAN/Ui2NkBDZ
	5uwFGloIJBx1EWJFxv2zBFRAVl2KotY=
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: aarch64: Remove unused functions from vpmu test
Date: Thu, 29 Feb 2024 06:37:58 +0000
Message-ID: <170918867004.2623796.14243237544124867327.b4-ty@linux.dev>
In-Reply-To: <20231122221526.2750966-1-rananta@google.com>
References: <20231122221526.2750966-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 22 Nov 2023 22:15:26 +0000, Raghavendra Rao Ananta wrote:
> vpmu_counter_access's disable_counter() carries a bug that disables
> all the counters that are enabled, instead of just the requested one.
> Fortunately, it's not an issue as there are no callers of it. Hence,
> instead of fixing it, remove the definition entirely.
> 
> Remove enable_counter() as it's unused as well.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: selftests: aarch64: Remove unused functions from vpmu test
      https://git.kernel.org/kvmarm/kvmarm/c/43b3bedb7cc4

--
Best,
Oliver

