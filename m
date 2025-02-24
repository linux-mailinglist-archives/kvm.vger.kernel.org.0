Return-Path: <kvm+bounces-39044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF66A42D17
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 20:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5779D3A01CC
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4230D200138;
	Mon, 24 Feb 2025 19:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aN0tE1Pd"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8051A5B8B
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 19:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426786; cv=none; b=hzCVOx++3SATaBTRS8z9AxL+pTGJ/1X2oZxe4T4Kna3vak7HA+YXxxLfhZ9WvzQRl70ycm6rin1bfkeWpQOa77Q93ERrlzCHIP5z0PAA1ZMVDDy6BVCPcjmc6SkFvE3ndyRT2fv8jh0i3CBHuvaNrSfcCznBLvOPB30GUy4gYEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426786; c=relaxed/simple;
	bh=QPNXldP8/aXCfk0xXpeMkBJumd7LGA27Zao1AHKS6zI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tp+O+y7p3IHuF+yLgMyF5bH18g3OS9dlXQABj0RwmQPPqG9G1Ycqk0SID+XToHsj39eKQmQMjaGYmtGbR3ozI9oSqnQHyIKeiffxHqIE+Yuk8KxXHIzUKBckKBDDPeBZ+PID3qo3YgkFtpt4DEu/IoRRbTxPjTWtSmjjrCnw+Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aN0tE1Pd; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740426782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Xh1+d4+0/2s7r35AQ1iEnqkZSbg7dbv/TfdOk1/Ssg=;
	b=aN0tE1Pd1MEvzE4n+wYxC+wbOBiJbdoTQwM05uEvYofjAXAPxnfokLf1kAfI9sWOuqxmp8
	hhsHxyhQr/nWZPPkewHxSc9EC8AH5L8F7zz3RIfJnceWkFkmSz3C2J52Frot0hhPBuWoXj
	cFWZwESFmcvtbDmYJQ662pddCSqOVuo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: Re: (subset) [PATCH v2 00/14] KVM: arm64: NV userspace ABI
Date: Mon, 24 Feb 2025 11:52:52 -0800
Message-Id: <174042670061.586392.7441716091084012083.b4-ty@linux.dev>
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 20 Feb 2025 13:48:53 +0000, Marc Zyngier wrote:
> Since the previous incarnation of the ABI was proved to be subtly
> wrong, I have reworked it to be more in line with the current way KVM
> operates.
> 
> No more late NV-specific adjustment nor writable ID_AA64MMFR0_EL1.VH.
> The NV configuration is now entirely selected from the vcpu flags.
> I've preserved the KVM_ARM_VCPU_EL2 flag which enables NV with VHE,
> and added KVM_ARM_VCPU_EL2_E2H0 which alters the NV behaviour to only
> allow nVHE guests without recursive NV support.
> 
> [...]

I fixed up the typos, including the one that breaks bisection. Can
always back this out if anything is out of place.

Applied to next, thanks!

[01/14] arm64: cpufeature: Handle NV_frac as a synonym of NV2
        https://git.kernel.org/kvmarm/kvmarm/c/88aea41b9bc5
[02/14] KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest and userspace
        https://git.kernel.org/kvmarm/kvmarm/c/9d6745572899
[03/14] KVM: arm64: Mark HCR.EL2.E2H RES0 when ID_AA64MMFR1_EL1.VH is zero
        https://git.kernel.org/kvmarm/kvmarm/c/d9f943f76506
[04/14] KVM: arm64: Mark HCR.EL2.{NV*,AT} RES0 when ID_AA64MMFR4_EL1.NV_frac is 0
        https://git.kernel.org/kvmarm/kvmarm/c/8f8d6084f5b5
[05/14] KVM: arm64: Advertise NV2 in the boot messages
        https://git.kernel.org/kvmarm/kvmarm/c/2cd9542a375a
[06/14] KVM: arm64: Consolidate idreg callbacks
        https://git.kernel.org/kvmarm/kvmarm/c/57e7de2650c8
[07/14] KVM: arm64: Make ID_REG_LIMIT_FIELD_ENUM() more widely available
        https://git.kernel.org/kvmarm/kvmarm/c/179fd7e30f04
[08/14] KVM: arm64: Enforce NV limits on a per-idregs basis
        https://git.kernel.org/kvmarm/kvmarm/c/e7ef6ed4583e
[09/14] KVM: arm64: Move NV-specific capping to idreg sanitisation
        https://git.kernel.org/kvmarm/kvmarm/c/94f296dcd6d9
[10/14] KVM: arm64: Allow userspace to limit NV support to nVHE
        https://git.kernel.org/kvmarm/kvmarm/c/f83c41fb3ddd
[11/14] KVM: arm64: Make ID_AA64MMFR4_EL1.NV_frac writable
        https://git.kernel.org/kvmarm/kvmarm/c/642c23ea8b45
[12/14] KVM: arm64: Advertise FEAT_ECV when possible
        https://git.kernel.org/kvmarm/kvmarm/c/8b0b98ebf34d

--
Best,
Oliver

