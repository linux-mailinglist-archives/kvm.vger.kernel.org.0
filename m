Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35106416E1B
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 10:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244788AbhIXIkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 04:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244765AbhIXIkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 04:40:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB31B61211;
        Fri, 24 Sep 2021 08:38:49 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mTgjH-00Ci2m-O5; Fri, 24 Sep 2021 09:38:47 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.15, take #1
Date:   Fri, 24 Sep 2021 09:38:29 +0100
Message-Id: <20210924083829.2766529-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, masahiroy@kernel.org, rmk+kernel@armlinux.org.uk, yuzenghui@huawei.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Only two fixes so far for KVM/arm64: one patch squashing a Kbuild
warning, and a fix for a regression when probing the availability of a
PMU.

Please pull,

	M.

The following changes since commit 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f:

  Linux 5.15-rc1 (2021-09-12 16:28:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.15-1

for you to fetch changes up to e840f42a49925707fca90e6c7a4095118fdb8c4d:

  KVM: arm64: Fix PMU probe ordering (2021-09-20 12:43:34 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.15, take #1

- Add missing FORCE target when building the EL2 object
- Fix a PMU probe regression on some platforms

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Fix PMU probe ordering

Zenghui Yu (1):
      KVM: arm64: nvhe: Fix missing FORCE for hyp-reloc.S build rule

 arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
 arch/arm64/kvm/perf.c            | 3 ---
 arch/arm64/kvm/pmu-emul.c        | 9 ++++++++-
 drivers/perf/arm_pmu.c           | 2 ++
 include/kvm/arm_pmu.h            | 3 ---
 include/linux/perf/arm_pmu.h     | 6 ++++++
 6 files changed, 17 insertions(+), 8 deletions(-)
