Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733453CC8A9
	for <lists+kvm@lfdr.de>; Sun, 18 Jul 2021 12:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhGRK6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jul 2021 06:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232766AbhGRK63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Jul 2021 06:58:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8C2D60E09;
        Sun, 18 Jul 2021 10:55:31 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m54SH-00E3PG-Gb; Sun, 18 Jul 2021 11:55:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steven Price <steven.price@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.14, take #1
Date:   Sun, 18 Jul 2021 11:55:22 +0100
Message-Id: <20210718105522.1490392-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, catalin.marinas@arm.com, steven.price@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the first batch of KVM/arm64 fixes for 5.14. The most important
one is an embarrassing MTE one-liner, but we also have a couple of
selftest changes courtesy of Andrew.

Please pull,

	M.

The following changes since commit e73f0f0ee7541171d89f2e2491130c7771ba58d3:

  Linux 5.14-rc1 (2021-07-11 15:07:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.14-1

for you to fetch changes up to 5cf17746b302aa32a4f200cc6ce38865bfe4cf94:

  KVM: arm64: selftests: get-reg-list: actually enable pmu regs in pmu sublist (2021-07-14 11:55:18 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.14, take #1

- Fix MTE shared page detection

- Fix selftest use of obsolete pthread_yield() in favour of sched_yield()

- Enable selftest's use of PMU registers when asked to

----------------------------------------------------------------
Andrew Jones (2):
      KVM: selftests: change pthread_yield to sched_yield
      KVM: arm64: selftests: get-reg-list: actually enable pmu regs in pmu sublist

Marc Zyngier (1):
      KVM: arm64: Fix detection of shared VMAs on guest fault

 arch/arm64/kvm/mmu.c                               | 2 +-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 ++-
 tools/testing/selftests/kvm/steal_time.c           | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)
