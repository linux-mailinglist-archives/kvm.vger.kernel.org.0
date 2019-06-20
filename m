Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AC74CCC8
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 13:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfFTLXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 07:23:12 -0400
Received: from foss.arm.com ([217.140.110.172]:60526 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfFTLXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 07:23:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26A53360;
        Thu, 20 Jun 2019 04:23:11 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A77BC3F718;
        Thu, 20 Jun 2019 04:23:09 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm fixes for 5.2-rc6
Date:   Thu, 20 Jun 2019 12:22:57 +0100
Message-Id: <20190620112301.138137-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

Here's the second (and hopefully last) set of fixes for v5.2. We have
our usual timer fix (we obviously will never get it right), a memory
leak plug, a sysreg reporting fix, and an small SVE cleanup.

Please pull.

	M.

The following changes since commit 623e1528d4090bd1abaf93ec46f047dee9a6fb32:

  KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation (2019-05-24 14:53:20 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.2-2

for you to fetch changes up to e4e5a865e9a9e8e47ac1959b629e9f3ae3b062f2:

  KVM: arm/arm64: Fix emulated ptimer irq injection (2019-06-19 15:47:52 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.2, take #2

- SVE cleanup killing a warning with ancient GCC versions
- Don't report non-existent system registers to userspace
- Fix memory leak when freeing the vgic ITS
- Properly lower the interrupt on the emulated physical timer

----------------------------------------------------------------
Andrew Jones (1):
      KVM: arm/arm64: Fix emulated ptimer irq injection

Dave Martin (2):
      KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST
      KVM: arm/arm64: vgic: Fix kvm_device leak in vgic_its_destroy

Viresh Kumar (1):
      KVM: arm64: Implement vq_present() as a macro

 arch/arm64/kvm/guest.c       | 65 +++++++++++++++++++++++++++++---------------
 virt/kvm/arm/arch_timer.c    |  5 ++--
 virt/kvm/arm/vgic/vgic-its.c |  1 +
 3 files changed, 47 insertions(+), 24 deletions(-)
