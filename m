Return-Path: <kvm+bounces-3589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD89F80585B
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 16:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0ACE61C21101
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D60C68E98;
	Tue,  5 Dec 2023 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTwZiRm8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF5C67E92;
	Tue,  5 Dec 2023 15:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878D2C433CB;
	Tue,  5 Dec 2023 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701789422;
	bh=ythRDbHamCF1V960slPinsGfd+YNI6SDqBoOYO7K2x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTwZiRm8s2c6snTdYDkQtv/CeJA2v5zipvPAIN1D7nX8GBiqG75MVpxvTuBrI986p
	 949AhbN+0FBFYQQhybk2cuB7vaxL82NbdfeJDYQHQyVa2uJBLZwz0VQhMUbc/WVPTO
	 YBzmognQorgb7BCEvR/a40RtvNB3/nQ4I3f3So14aLBOTVVh15iSAF79cr0Vgsz6ZA
	 6k62i6q6dKjGgKBCfmrNHhrL97+V3YGWxRBVsq1CrU3gSOUw+Kc/KiadzQUceu9Kdd
	 wScFcOHxai1PgA/H/KIHxWQvr/iILmb6c/vrKn4MGPBL/T1Ikf0p0iGlRLBABjBZOW
	 fAZq82SmP7KDQ==
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 0/3] arm64: Drop support for VPIPT i-cache policy
Date: Tue,  5 Dec 2023 15:16:34 +0000
Message-Id: <170177628445.1801906.11394045917050132780.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20231204143606.1806432-1-maz@kernel.org>
References: <20231204143606.1806432-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 4 Dec 2023 14:36:03 +0000, Marc Zyngier wrote:
> ARMv8.2 introduced support for VPIPT i-caches, the V standing for
> VMID-tagged. Although this looked like a reasonable idea, no
> implementation has ever made it into the wild.
> 
> Linux has supported this for over 6 years (amusingly, just as the
> architecture was dropping support for AIVIVT i-caches), but we had no
> way to even test it, and it is likely that this code was just
> bit-rotting.
> 
> [...]

Applied to arm64 (for-next/rip-vpipt), thanks!

[1/3] KVM: arm64: Remove VPIPT I-cache handling
      https://git.kernel.org/arm64/c/ced242ba9d7c
[2/3] arm64: Kill detection of VPIPT i-cache policy
      https://git.kernel.org/arm64/c/d8e12a0d3715
[3/3] arm64: Rename reserved values for CTR_EL0.L1Ip
      https://git.kernel.org/arm64/c/f35c32ca6839

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

