Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D9E42ECAC
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 10:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhJOIpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 04:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhJOIpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 04:45:17 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E42AF60FC3;
        Fri, 15 Oct 2021 08:43:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mbIo1-00GuxM-R3; Fri, 15 Oct 2021 09:43:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.15, take #2
Date:   Fri, 15 Oct 2021 09:42:45 +0100
Message-Id: <20211015084245.2994276-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, qperret@google.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Another couple of fixes for KVM/arm64: a fix for a stage-2 refcounting
issue, and an error handling howler affecting MTE, all thanks to Quentin.

Please pull,

	M.

The following changes since commit e840f42a49925707fca90e6c7a4095118fdb8c4d:

  KVM: arm64: Fix PMU probe ordering (2021-09-20 12:43:34 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.15-2

for you to fetch changes up to 6e6a8ef088e1222cb1250942f51ad9c1ab219ab2:

  KVM: arm64: Release mmap_lock when using VM_SHARED with MTE (2021-10-05 13:22:45 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.15, take #2

- Properly refcount pages used as a concatenated stage-2 PGD
- Fix missing unlock when detecting the use of MTE+VM_SHARED

----------------------------------------------------------------
Quentin Perret (3):
      KVM: arm64: Fix host stage-2 PGD refcount
      KVM: arm64: Report corrupted refcount at EL2
      KVM: arm64: Release mmap_lock when using VM_SHARED with MTE

 arch/arm64/kvm/hyp/include/nvhe/gfp.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 13 ++++++++++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 15 +++++++++++++++
 arch/arm64/kvm/mmu.c                  |  6 ++++--
 4 files changed, 32 insertions(+), 3 deletions(-)
