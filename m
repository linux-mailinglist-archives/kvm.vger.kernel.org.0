Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6E5C2FFF
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 11:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387563AbfJAJVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 05:21:13 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:39479 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387555AbfJAJVN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Oct 2019 05:21:13 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iFEL5-00019A-0W; Tue, 01 Oct 2019 11:20:59 +0200
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 0/4] KVM/arm updates for 5.4-rc2
Date:   Tue,  1 Oct 2019 10:20:34 +0100
Message-Id: <20191001092038.17097-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com, christoffer.dall@arm.com, yamada.masahiro@socionext.com, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

Here's the first set of KVM/arm fixes for 5.4. The first three patches
remove a construct which helped us bringing up VHE back in the days,
but which is now more of a confusing historical artefact, better
replaced with static keys that we already have. The last patch fixes
the ftrace include path that so far worked by luck (and has been
addressed in other places in the tree).

Please pull,

       M.

The following changes since commit 92f35b751c71d14250a401246f2c792e3aa5b386:

  KVM: arm/arm64: vgic: Allow more than 256 vcpus for KVM_IRQ_LINE (2019-09-09 12:29:09 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.4-1

for you to fetch changes up to aac60f1a867773de9eb164013d89c99f3ea1f009:

  KVM: arm/arm64: vgic: Use the appropriate TRACE_INCLUDE_PATH (2019-09-11 16:36:19 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.4, take #1

- Remove the now obsolete hyp_alternate_select construct
- Fix the TRACE_INCLUDE_PATH macro in the vgic code

----------------------------------------------------------------
Marc Zyngier (3):
      arm64: KVM: Drop hyp_alternate_select for checking for ARM64_WORKAROUND_834220
      arm64: KVM: Replace hyp_alternate_select with has_vhe()
      arm64: KVM: Kill hyp_alternate_select()

Zenghui Yu (1):
      KVM: arm/arm64: vgic: Use the appropriate TRACE_INCLUDE_PATH

 arch/arm64/include/asm/kvm_hyp.h | 24 ------------------------
 arch/arm64/kvm/hyp/switch.c      | 17 ++---------------
 arch/arm64/kvm/hyp/tlb.c         | 36 ++++++++++++++++++++++--------------
 virt/kvm/arm/vgic/trace.h        |  2 +-
 4 files changed, 25 insertions(+), 54 deletions(-)
