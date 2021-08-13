Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A5A3EB08B
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 08:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbhHMGne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 02:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234716AbhHMGnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 02:43:33 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FE6D610CD;
        Fri, 13 Aug 2021 06:43:07 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mEQuH-004jCS-1Q; Fri, 13 Aug 2021 07:43:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 5.14, take #2
Date:   Fri, 13 Aug 2021 07:42:41 +0100
Message-Id: <20210813064241.2603475-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, dbrazdil@google.com, qperret@google.com, steven.price@arm.com, will@kernel.org, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the second batch of KVM/arm64 fixes for 5.14, and hopefully the
last for this cycle. We have another MTE fix from Steven, but also
have an off-by-one bug squashed by David in the protected memory path.

Please pull,

	M.

The following changes since commit 5cf17746b302aa32a4f200cc6ce38865bfe4cf94:

  KVM: arm64: selftests: get-reg-list: actually enable pmu regs in pmu sublist (2021-07-14 11:55:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.14-2

for you to fetch changes up to c4d7c51845af9542d42cd18a25c570583abf2768:

  KVM: arm64: Fix race when enabling KVM_ARM_CAP_MTE (2021-07-29 17:34:01 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.14, take #2

- Plug race between enabling MTE and creating vcpus
- Fix off-by-one bug when checking whether an address range is RAM

----------------------------------------------------------------
David Brazdil (1):
      KVM: arm64: Fix off-by-one in range_is_memory

Steven Price (1):
      KVM: arm64: Fix race when enabling KVM_ARM_CAP_MTE

 arch/arm64/kvm/arm.c                  | 12 ++++++++----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)
