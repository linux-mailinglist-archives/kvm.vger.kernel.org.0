Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3436C11D3D2
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbfLLR2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:28:45 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:53578 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730023AbfLLR2p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 12:28:45 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifSGU-00069s-N1; Thu, 12 Dec 2019 18:28:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>, Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [GIT PULL] KVM/arm updates for 5.5-rc2
Date:   Thu, 12 Dec 2019 17:28:16 +0000
Message-Id: <20191212172824.11523-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, alexandru.elisei@arm.com, ard.biesheuvel@linaro.org, christoffer.dall@arm.com, eric.auger@redhat.com, james.morse@arm.com, justin.he@arm.com, mark.rutland@arm.com, linmiaohe@huawei.com, steven.price@arm.com, will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

This is the first set of fixes for 5.5-rc2. This time around,
a couple of MM fixes, a ONE_REG fix for an issue detected by
GCC-10, and a handful of cleanups.

Please pull,

	M.

The following changes since commit cd7056ae34af0e9424da97bbc7d2b38246ba8a2c:

  Merge remote-tracking branch 'kvmarm/misc-5.5' into kvmarm/next (2019-11-08 11:27:29 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.5-1

for you to fetch changes up to 6d674e28f642e3ff676fbae2d8d1b872814d32b6:

  KVM: arm/arm64: Properly handle faulting of device mappings (2019-12-12 16:22:40 +0000)

----------------------------------------------------------------
KVM/arm fixes for .5.5, take #1

- Fix uninitialised sysreg accessor
- Fix handling of demand-paged device mappings
- Stop spamming the console on IMPDEF sysregs
- Relax mappings of writable memslots
- Assorted cleanups

----------------------------------------------------------------
Jia He (1):
      KVM: arm/arm64: Remove excessive permission check in kvm_arch_prepare_memory_region

Marc Zyngier (1):
      KVM: arm/arm64: Properly handle faulting of device mappings

Mark Rutland (2):
      KVM: arm64: Sanely ratelimit sysreg messages
      KVM: arm64: Don't log IMP DEF sysreg traps

Miaohe Lin (3):
      KVM: arm/arm64: Get rid of unused arg in cpu_init_hyp_mode()
      KVM: arm/arm64: vgic: Fix potential double free dist->spis in __kvm_vgic_destroy()
      KVM: arm/arm64: vgic: Use wrapper function to lock/unlock all vcpus in kvm_vgic_create()

Will Deacon (1):
      KVM: arm64: Ensure 'params' is initialised when looking up sys register

 arch/arm64/kvm/sys_regs.c     | 25 ++++++++++++++++++-------
 arch/arm64/kvm/sys_regs.h     | 17 +++++++++++++++--
 virt/kvm/arm/arm.c            |  4 ++--
 virt/kvm/arm/mmu.c            | 30 +++++++++++++++++-------------
 virt/kvm/arm/vgic/vgic-init.c | 20 +++++---------------
 5 files changed, 57 insertions(+), 39 deletions(-)
