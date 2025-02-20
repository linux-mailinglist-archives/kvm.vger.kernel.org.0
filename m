Return-Path: <kvm+bounces-38767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BAB8A3E2E6
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:46:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5406A189FA20
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5679E213E75;
	Thu, 20 Feb 2025 17:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uk2jw35O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA6021324F;
	Thu, 20 Feb 2025 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740073460; cv=none; b=Br5d3Kte2M6mnlXhXi4yW8GO2kg+GgXptGlqEPytlAYa3d9HxHmeVxWO0Z4vX0Tfl3lnI79XJlKkOcFOxW5niIPHF4N5AhscBcAnE8rzGszw3JMJjiOuUjGquX9GNFl926Z8QO1R2K7OiQFwuZRssOLFb/3dvGvYJ/krriH/8RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740073460; c=relaxed/simple;
	bh=JG9qAobTzeeNJhvrxW9wlpTi2Gx0CaoQMhNmfQShIEA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZMdSX3jLgf5jPQ6QZ/4JptuE+7jbO+htz0lYsko59lL9BGpbx8AkHAJtWh62aTpN/leM1rXGWF+XSl4qgclJMKX4GofHRsByss9UZ/1oc3uNY3XyP46xyQl7CEJHDyuDy1H9We8paNWyCOXx0SwMPUW+ZedFO6RMTIH7Ed1d6HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uk2jw35O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D8DC4CED1;
	Thu, 20 Feb 2025 17:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740073459;
	bh=JG9qAobTzeeNJhvrxW9wlpTi2Gx0CaoQMhNmfQShIEA=;
	h=From:To:Cc:Subject:Date:From;
	b=Uk2jw35ObtTTcxrptF2N88WVGFylhY2GEZlmBKieFMZC8RHGgcmyLDvZ8E05TlDjx
	 ZEFwUacTcTMXzvoYTkd+xqv2v6mG9o7IVQEjcVJNme+iDErOrMNDrT8EWo3E2UqjGL
	 ghzzM3LLFHaA02J676iF8uKFoQSk479xKBDiOw1jE3PNsq3pXkdV9pIb99hynzq+V+
	 pwmTlOszNT4vtYc3PmwxYhZbM1qgn+nkGXW49jGiGEU+m+j3UhTII6c+QJebY1ygB6
	 aaG5LbXp1O6RMuNLxE+JU4GFIf9Gki5b2XPmqsBvFC/LpnoFlJIuC0E16ySSCeTWgF
	 HAZJ1ixyiS26Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tlAau-006J9w-EF;
	Thu, 20 Feb 2025 17:44:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.14, take #3
Date: Thu, 20 Feb 2025 17:44:06 +0000
Message-Id: <20250220174406.749490-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oliver.upton@linux.dev, vladimir.murzin@arm.com, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Another week, another set of fixes.

This time around, we have a focus on MMU bugs, with one bug affecting
hVHE EL2 stage-1 and picking the ASID from the wrong register, while
the other affects VHE and allows it to run with a stale VMID value.

Either way, this is ugly.

Please pull,

	M.

The following changes since commit 0ad2507d5d93f39619fc42372c347d6006b64319:

  Linux 6.14-rc3 (2025-02-16 14:02:44 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.14-3

for you to fetch changes up to fa808ed4e199ed17d878eb75b110bda30dd52434:

  KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2 (2025-02-20 16:29:28 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.14, take #3

- Fix TCR_EL2 configuration to not use the ASID in TTBR1_EL2
  and not mess-up T1SZ/PS by using the HCR_EL2.E2H==0 layout.

- Bring back the VMID allocation to the vcpu_load phase, ensuring
  that we only setup VTTBR_EL2 once on VHE. This cures an ugly
  race that would lead to running with an unallocated VMID.

----------------------------------------------------------------
Oliver Upton (1):
      KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2

Will Deacon (1):
      KVM: arm64: Fix tcr_el2 initialisation in hVHE mode

 arch/arm64/include/asm/kvm_arm.h  |  2 +-
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              | 37 +++++++++++++++++--------------------
 arch/arm64/kvm/vmid.c             | 11 +++--------
 4 files changed, 22 insertions(+), 30 deletions(-)

