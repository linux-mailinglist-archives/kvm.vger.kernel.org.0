Return-Path: <kvm+bounces-48649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B8AACFF86
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 11:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A4F11896177
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 09:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F12E28688E;
	Fri,  6 Jun 2025 09:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ig6MjsCH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636932857EF;
	Fri,  6 Jun 2025 09:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749203036; cv=none; b=PFY9PMDeT7AxiPlrKUzCZBdqIEk0E2+L+f0LI6/BmHQ3E9pKUSTyOKm8gDxCWDc9AFgnCUB22gBZ1hquL65yH4eveemtkd7LipFaewMrtBgMnngMYTQYuPZPvlalAsVVLU4JVY9Vf0SBSmS6GB9xRWpmiXRpNwZdZcodt61Cg3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749203036; c=relaxed/simple;
	bh=vZSEXUYli2C2cAp32nX+g8RtQUwpt0WT3dasG2Hy6hg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZMfdO0DiadLuR7FtPcBquCit9Ic1JYE1q67cYnLDU2ynb2mhU+gnFrUndCVCGbzaQ/8H4qa2ZdQ9AD/0+jhIJGlIR1fGr2gJ0wyXRTxo6wVE7k+ZgVYEeD+ZI6g4LFNTSsNu8cjAyHhp21HQVfhVofDNuy+xHvbdz9kMwzm2Kt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ig6MjsCH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3CAC4CEEB;
	Fri,  6 Jun 2025 09:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749203035;
	bh=vZSEXUYli2C2cAp32nX+g8RtQUwpt0WT3dasG2Hy6hg=;
	h=From:To:Cc:Subject:Date:From;
	b=Ig6MjsCHBZ7IiVBqLMDcvDaLhYqnM0A4Fsr8bfQNcpKZBDqKkHL/GPwKIZAD5mL8r
	 juLZAgbz/5TFL1jUx58LwcFWDSqLi5WPBPu0qX5P/ON6CXu+DFBl85STG4m7qWhm95
	 jGNMY2aF6Dyfs0polPjGy4wRCKNezFcQE9FgT1kdTCBwSR5tUi3lMmUIhb7FfbH4Xv
	 MGJZtiifI27wXajNXfUh4HlboZ26pw1QZoVasHefQeErT7S2OSwdRUwNxMR4UQuPpA
	 IFj/P4rt40KIh4MjPVNRaiuGcrGpKEmSfcmTImb5C9Grq73Rjp8WE91z/0/ext99zX
	 l2fTVmOARpPhg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uNTc9-004WjE-7M;
	Fri, 06 Jun 2025 10:43:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sebastian Ott <sebott@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.16, take #2
Date: Fri,  6 Jun 2025 10:43:50 +0100
Message-Id: <20250606094350.1318309-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, miguel.luis@oracle.com, oliver.upton@linux.dev, sebott@redhat.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here the second batch of fixes for 6.16. We have a significant rework
of our system register accessors so that the RES0/RES1 sanitisation
gets applied at the right time, and a bunch of fixes for a single
selftest that really *never* worked.

Please pull,

	M.

The following changes since commit 4d62121ce9b58ea23c8d62207cbc604e98ecdc0a:

  KVM: arm64: vgic-debug: Avoid dereferencing NULL ITE pointer (2025-05-30 10:24:49 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.16-2

for you to fetch changes up to fad4cf944839da7f5c3376243aa353295c88f588:

  KVM: arm64: selftests: Determine effective counter width in arch_timer_edge_cases (2025-06-05 14:28:44 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.16, take #2

- Rework of system register accessors for system registers that are
  directly writen to memory, so that sanitisation of the in-memory
  value happens at the correct time (after the read, or before the
  write). For convenience, RMW-style accessors are also provided.

- Multiple fixes for the so-called "arch-timer-edge-cases' selftest,
  which was always broken.

----------------------------------------------------------------
Marc Zyngier (4):
      KVM: arm64: Add assignment-specific sysreg accessor
      KVM: arm64: Add RMW specific sysreg accessor
      KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysreg
      KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand

Sebastian Ott (4):
      KVM: arm64: selftests: Fix help text for arch_timer_edge_cases
      KVM: arm64: selftests: Fix thread migration in arch_timer_edge_cases
      KVM: arm64: selftests: Fix xVAL init in arch_timer_edge_cases
      KVM: arm64: selftests: Determine effective counter width in arch_timer_edge_cases

 arch/arm64/include/asm/kvm_host.h                  | 32 ++++++++++--
 arch/arm64/kvm/arch_timer.c                        | 18 +++----
 arch/arm64/kvm/debug.c                             |  4 +-
 arch/arm64/kvm/fpsimd.c                            |  4 +-
 arch/arm64/kvm/hyp/exception.c                     |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  4 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  6 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  4 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  4 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 | 48 ++++++++---------
 arch/arm64/kvm/nested.c                            |  2 +-
 arch/arm64/kvm/pmu-emul.c                          | 24 ++++-----
 arch/arm64/kvm/sys_regs.c                          | 60 +++++++++++-----------
 arch/arm64/kvm/sys_regs.h                          |  4 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c               | 10 ++--
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    | 39 +++++++++-----
 16 files changed, 151 insertions(+), 116 deletions(-)

