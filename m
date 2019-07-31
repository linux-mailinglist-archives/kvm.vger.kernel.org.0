Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F4C7CA97
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 19:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfGaRhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 13:37:00 -0400
Received: from foss.arm.com ([217.140.110.172]:52438 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfGaRhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 13:37:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70839337;
        Wed, 31 Jul 2019 10:36:59 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD8053F71F;
        Wed, 31 Jul 2019 10:36:56 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Andrew Murray <andrew.murray@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm updates for 5.3-rc3
Date:   Wed, 31 Jul 2019 18:36:45 +0100
Message-Id: <20190731173650.12627-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

Here's a handful of patches for 5.3-rc3: Two actual fixes (missing
break; in the 32bit register mapping, PMU reset being broken after the
chained counter update). The rest is either cosmetic (exception
classes in debug/tracing) or silence warnings (the fall-through
explosion).

Please pull.

	M.

The following changes since commit 5f9e832c137075045d15cd6899ab0505cfb2ca4b:

  Linus 5.3-rc1 (2019-07-21 14:05:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.3

for you to fetch changes up to cdb2d3ee0436d74fa9092f2df46aaa6f9e03c969:

  arm64: KVM: hyp: debug-sr: Mark expected switch fall-through (2019-07-29 11:01:37 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.3

- A bunch of switch/case fall-through annotation, fixing one actual bug
- Fix PMU reset bug
- Add missing exception class debug strings

----------------------------------------------------------------
Anders Roxell (3):
      arm64: KVM: regmap: Fix unexpected switch fall-through
      KVM: arm: vgic-v3: Mark expected switch fall-through
      arm64: KVM: hyp: debug-sr: Mark expected switch fall-through

Zenghui Yu (2):
      KVM: arm/arm64: Introduce kvm_pmu_vcpu_init() to setup PMU counter index
      KVM: arm64: Update kvm_arm_exception_class and esr_class_str for new EC

 arch/arm64/include/asm/kvm_arm.h |  7 ++++---
 arch/arm64/kernel/traps.c        |  1 +
 arch/arm64/kvm/hyp/debug-sr.c    | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/regmap.c          |  5 +++++
 include/kvm/arm_pmu.h            |  2 ++
 virt/kvm/arm/arm.c               |  2 ++
 virt/kvm/arm/hyp/vgic-v3-sr.c    |  8 ++++++++
 virt/kvm/arm/pmu.c               | 18 +++++++++++++++---
 8 files changed, 67 insertions(+), 6 deletions(-)
