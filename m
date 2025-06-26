Return-Path: <kvm+bounces-50843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EA68AEA281
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F77A1885831
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8982EBB84;
	Thu, 26 Jun 2025 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5Jli4GU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FBD28934F;
	Thu, 26 Jun 2025 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750951234; cv=none; b=U5PPGq7YJaYr7v0mwR8pcZMuqZpmp2Dj4QxMiiLaWn+OJC35HAZXkqHNlKqvZ+eHWkFK5RmzxTEk+Bg829s0RvAPtNnMe2Vu6QIouD6WcMDOdRPBumaycQirpwtwKCq8FOZQC20IQs2Phrs5wVWsvHEavGYsZRVku/xo6EyP4KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750951234; c=relaxed/simple;
	bh=Dds48T+13Rl1lPltLORehbpwNU4/j51XA94K8+avE5w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tcZKEaQ142Z07iFwuEXq8t1W/cYpG7V6OJwssDmJDp9C+GWtsjeTl/7vXeWK4Qq1MtJryMQtx3pYkCxe7qdCKAd06Nk0AA8y1BTbRHj3fudOU6DEf3iNA/CLLESQHUSrbuVLXWjhk78qXR6/VlgfyKL6EYMVJhyze3z4E9tF8p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5Jli4GU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9637C4CEEB;
	Thu, 26 Jun 2025 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750951234;
	bh=Dds48T+13Rl1lPltLORehbpwNU4/j51XA94K8+avE5w=;
	h=From:To:Cc:Subject:Date:From;
	b=Y5Jli4GUKuhTeHTX8HNMlcQxc3urmUV61Hch6xuZ20Lxj54j7rVARi41Wa7fBanQj
	 EKV+c01kX7Z19580K+dqEimfUHxhE3EUY475Y+3PY7pz+v7p7515q4T5Aw92CjzkT8
	 cG/U3lUDtVCwBCSiWD3QFjDxfKyAFnAUUwUTRH5DX/9YU9p7Z7zl9S+CyaJMigY5vA
	 Bzgz135J1cN9K4zkdP1xNUa0n2G90c5x3+QYev66JFV8J19iBFZRC+FcnGHAjxiUdH
	 jwcVzVIJcueW2BC6b6zRJ6rnW2+JVPDx0YYCedwR+xpLdSRghZ3nFDEe8/14sRRbST
	 J580m0nbOuamg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uUoOt-00AGoI-H6;
	Thu, 26 Jun 2025 16:20:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.16, take #4
Date: Thu, 26 Jun 2025 16:20:23 +0100
Message-Id: <20250626152023.192347-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, smostafa@google.com, qperret@google.com, r09922117@csie.ntu.edu.tw, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Another week, another set of fixes. Nothing major this time: allow
pKVM to fail to initialise without taking the host down, make sure we
are not mapping too much in the host S2 (another pKVM special), and a
brown-paper-bag quality bug fix on the nested GICv3 emulation.

Please pull,

	M.

The following changes since commit 04c5355b2a94ff3191ce63ab035fb7f04d036869:

  KVM: arm64: VHE: Centralize ISBs when returning to host (2025-06-19 13:34:59 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.16-4

for you to fetch changes up to 0e02219f9cf4f0c0aa3dbf3c820e6612bf3f0c8c:

  KVM: arm64: Don't free hyp pages with pKVM on GICv2 (2025-06-26 11:39:15 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.16, take #4

- Gracefully fail initialising pKVM if the interrupt controller isn't
  GICv3

- Also gracefully fail initialising pKVM if the carveout allocation
  fails

- Fix the computing of the minimum MMIO range required for the host on
  stage-2 fault

- Fix the generation of the GICv3 Maintenance Interrupt in nested mode

----------------------------------------------------------------
Mostafa Saleh (1):
      KVM: arm64: Fix error path in init_hyp_mode()

Quentin Perret (2):
      KVM: arm64: Adjust range correctly during host stage-2 faults
      KVM: arm64: Don't free hyp pages with pKVM on GICv2

Wei-Lin Chang (1):
      KVM: arm64: nv: Fix MI line level calculation in vgic_v3_nested_update_mi()

 arch/arm64/kvm/arm.c                  | 12 ++++++++++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 20 ++++++++++++--------
 arch/arm64/kvm/vgic/vgic-v3-nested.c  |  4 +---
 3 files changed, 23 insertions(+), 13 deletions(-)

