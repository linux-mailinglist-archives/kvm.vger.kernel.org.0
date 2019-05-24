Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3B429A48
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 16:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404197AbfEXOsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 10:48:00 -0400
Received: from foss.arm.com ([217.140.101.70]:44478 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403911AbfEXOr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 10:47:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8594980D;
        Fri, 24 May 2019 07:47:59 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB7E23F575;
        Fri, 24 May 2019 07:47:57 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm updates for 5.2-rc2
Date:   Fri, 24 May 2019 15:47:42 +0100
Message-Id: <20190524144745.227242-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

This is the first batch of KVM/arm fixes for 5.2. The biggest item on
the menu is Christoffer removing himself from the MAINTAINERS
file. He'll be missed. The rest is a set of fixes moving some code
around to prevent KASAN and co from crashing the kernel on non-VHE
systems.

Please pull,

	M.

The following changes since commit a188339ca5a396acc588e5851ed7e19f66b0ebd9:

  Linux 5.2-rc1 (2019-05-19 15:47:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.2

for you to fetch changes up to 623e1528d4090bd1abaf93ec46f047dee9a6fb32:

  KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation (2019-05-24 14:53:20 +0100)

----------------------------------------------------------------
KVM/arm updates for 5.2-rc2

- Correctly annotate HYP-callable code to be non-traceable
- Remove Christoffer from the MAINTAINERS file as his request

----------------------------------------------------------------
Christoffer Dall (1):
      MAINTAINERS: KVM: arm/arm64: Remove myself as maintainer

James Morse (2):
      KVM: arm64: Move pmu hyp code under hyp's Makefile to avoid instrumentation
      KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation

 MAINTAINERS                       |   2 -
 arch/arm/kvm/hyp/Makefile         |   1 +
 arch/arm64/include/asm/kvm_host.h |   3 -
 arch/arm64/kvm/hyp/Makefile       |   1 +
 arch/arm64/kvm/hyp/switch.c       |  39 +++++++++++
 arch/arm64/kvm/pmu.c              |  38 -----------
 virt/kvm/arm/aarch32.c            | 121 ---------------------------------
 virt/kvm/arm/hyp/aarch32.c        | 136 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 177 insertions(+), 164 deletions(-)
 create mode 100644 virt/kvm/arm/hyp/aarch32.c
