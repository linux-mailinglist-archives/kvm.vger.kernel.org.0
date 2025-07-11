Return-Path: <kvm+bounces-52103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64993B016C8
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:49:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 464D7188F797
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50638218593;
	Fri, 11 Jul 2025 08:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVbgk0xZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76872213E9F;
	Fri, 11 Jul 2025 08:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752223739; cv=none; b=XiM2cjmwuVbps7deRRleZonNCfb/ndK5gB8fwdDjGv9lZsAea9GbvW7eAj/5mKQmvteHKE6ArfwR3QZwj7RMlCujiCs9ukX9oT6ZyA6L9m+28Xk1nAPkLtLt/Y2zjFWF1eGFLVHvpEmYwr0zp8XHFteSNFWLS1+3I0sMby5Cx+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752223739; c=relaxed/simple;
	bh=qz00TFtiE4R9C6GWhLvgyU/ZW+rbFxh0EXwo9y3XYzc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jCHBOLKNUF9KyE1dsNXeeqgqQ/gNoaVf6W768fYs2e+Me7CRviVoQKSjas1Np+ouxAFccpadXV+4R0UFsAjIvF0+IjrAgNrrEChWrUoWWo5JapfCdYxewcUmCJb1LcU/oWpE+fgAyjojC9fQoTIF8wUCcrJ3UH6DZOh4G/btEmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVbgk0xZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EADAC4CEED;
	Fri, 11 Jul 2025 08:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752223739;
	bh=qz00TFtiE4R9C6GWhLvgyU/ZW+rbFxh0EXwo9y3XYzc=;
	h=From:To:Cc:Subject:Date:From;
	b=NVbgk0xZyDfduDrHs8UvuNrW4RZ9tlGbUnqMtapN1luVq4ONDeRgmHkSO2+YZettB
	 RZmsn/qyEPqb2H8dhMuHSGbLcAAUR4nSPWWoYLPYQoRJmSduSWeUZNjYklwisZhrI1
	 1LESzMo/WKmdUSakFIYnsgiFVjabvXcWZGxnxShWXVXO53MDLCEtWXSwgwlwidGe/H
	 lcbCNOH6XXSf+OWLiuHzkj7eBYtwhW5xXXbOS8gSpvmJ8YHAUnUemdV7M39RTlVc9y
	 upB3qMCA/CZVN0sxmZOTpiaxPxGyBBEDCFB4jX0crY+grBRVLYv/JaPs4YyiB2YmVB
	 va1A2WSgGeXjA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ua9RA-00Eo6u-Ez;
	Fri, 11 Jul 2025 09:48:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ben Horgan <ben.horgan@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.16, take #6
Date: Fri, 11 Jul 2025 09:48:34 +0100
Message-Id: <20250711084835.2411230-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ben.horgan@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here the (hopefully) last fix for 6.16, addressing what can adequately
be called a brain fart in dealing with the sanitisation of the number
of PMU registers in nested virt.

Please pull,

	M.

The following changes since commit 42ce432522a17685f5a84529de49e555477c0a1f:

  KVM: arm64: Remove kvm_arch_vcpu_run_map_fp() (2025-07-03 10:39:24 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.16-6

for you to fetch changes up to 2265c08ec393ef1f5ef5019add0ab1e3a7ee0b79:

  KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN (2025-07-09 13:19:24 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.16, take #6

- Fix use of u64_replace_bits() in adjusting the guest's view of
  MDCR_EL2.HPMN.

----------------------------------------------------------------
Ben Horgan (1):
      KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN

 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

