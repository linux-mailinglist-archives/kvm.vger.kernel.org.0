Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B8F2A99B1
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 17:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgKFQoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 11:44:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgKFQoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 11:44:38 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6EC12151B;
        Fri,  6 Nov 2020 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604681077;
        bh=9iUTO9V9vPdMlxcyJuoPtkCPdy41zNPPUWFKgP7BkOw=;
        h=From:To:Cc:Subject:Date:From;
        b=Ks7WKJLle02cLYsQQgyk9w62RINaerwNRmf10+VjBh95ZlWfrm9S5PwzeMdxzqy6b
         MkiAzpGRo7AaPEc+d0tTlsaq5nniQCwhRlvZRK+H1ZqVn8LHC5NALxTs+qMSMA7kTl
         2QIL16ALCeSJKNm50eH6Dn714OpONcvRV/WdPuOw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kb4qp-008FYW-Fr; Fri, 06 Nov 2020 16:44:35 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?q?=E5=BC=A0=E4=B8=9C=E6=97=AD?= <xu910121@sina.com>,
        dave.martin@arm.com, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 5.10, take #2
Date:   Fri,  6 Nov 2020 16:44:11 +0000
Message-Id: <20201106164416.326787-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com, xu910121@sina.com, dave.martin@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the second set of fixes for 5.10. A compilation fix for
non-48bit VA builds and a live migration regressions are on the menu
this time. I have another set of regression fixes brewing, but in the
meantime this will fit nicely in mainline.

Please pull,

	M.

The following changes since commit 22f553842b14a1289c088a79a67fb479d3fa2a4e:

  KVM: arm64: Handle Asymmetric AArch32 systems (2020-10-30 16:06:22 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-2

for you to fetch changes up to c512298eed0360923d0cbc4a1f30bc0509af0d50:

  KVM: arm64: Remove AA64ZFR0_EL1 accessors (2020-11-06 16:00:29 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for v5.10, take #2

- Fix compilation error when PMD and PUD are folded
- Fix regresssion of the RAZ behaviour of ID_AA64ZFR0_EL1

----------------------------------------------------------------
Andrew Jones (4):
      KVM: arm64: Don't hide ID registers from userspace
      KVM: arm64: Consolidate REG_HIDDEN_GUEST/USER
      KVM: arm64: Check RAZ visibility in ID register accessors
      KVM: arm64: Remove AA64ZFR0_EL1 accessors

Gavin Shan (1):
      KVM: arm64: Fix build error in user_mem_abort()

 arch/arm64/kvm/mmu.c      |   2 +
 arch/arm64/kvm/sys_regs.c | 108 ++++++++++++++--------------------------------
 arch/arm64/kvm/sys_regs.h |  16 +++----
 3 files changed, 43 insertions(+), 83 deletions(-)
