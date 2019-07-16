Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76AFD6ADD4
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 19:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388172AbfGPRn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 13:43:59 -0400
Received: from foss.arm.com ([217.140.110.172]:38180 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbfGPRn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 13:43:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB28D2B;
        Tue, 16 Jul 2019 10:43:57 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EE163F71A;
        Tue, 16 Jul 2019 10:43:54 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org
Subject: [PATCH] MAINTAINERS: Update my email address to @kernel.org
Date:   Tue, 16 Jul 2019 18:43:08 +0100
Message-Id: <20190716174308.17147-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I will soon lose access to my @arm.com email address, so let's
update the MAINTAINERS file to point to my @kernel.org address,
as well as .mailmap for good measure.

Note that my @arm.com address will still work, but someone else
will be reading whatever is sent there. Don't say you didn't know!

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---

Notes:
    Yes, I'm sending this from my ARM address. That's intentional.
    I'll probably send it as part of a pull request later in the
    cycle, but that's just so that people know what is coming.

 .mailmap    | 1 +
 MAINTAINERS | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/.mailmap b/.mailmap
index 0fef932de3db..23cfed2e015c 100644
--- a/.mailmap
+++ b/.mailmap
@@ -132,6 +132,7 @@ Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Maciej W. Rozycki <macro@mips.com> <macro@imgtec.com>
+Marc Zyngier <maz@kernel.org> <marc.zyngier@arm.com>
 Marcin Nowakowski <marcin.nowakowski@mips.com> <marcin.nowakowski@imgtec.com>
 Mark Brown <broonie@sirena.org.uk>
 Mark Yao <markyao0591@gmail.com> <mark.yao@rock-chips.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 677ef41cb012..eff3dca4869d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1161,7 +1161,7 @@ F:	include/uapi/linux/if_arcnet.h
 
 ARM ARCHITECTED TIMER DRIVER
 M:	Mark Rutland <mark.rutland@arm.com>
-M:	Marc Zyngier <marc.zyngier@arm.com>
+M:	Marc Zyngier <maz@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/include/asm/arch_timer.h
@@ -8303,7 +8303,7 @@ S:	Obsolete
 F:	include/uapi/linux/ipx.h
 
 IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
-M:	Marc Zyngier <marc.zyngier@arm.com>
+M:	Marc Zyngier <maz@kernel.org>
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 F:	Documentation/IRQ-domain.txt
@@ -8321,7 +8321,7 @@ F:	kernel/irq/
 IRQCHIP DRIVERS
 M:	Thomas Gleixner <tglx@linutronix.de>
 M:	Jason Cooper <jason@lakedaemon.net>
-M:	Marc Zyngier <marc.zyngier@arm.com>
+M:	Marc Zyngier <maz@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
@@ -8633,7 +8633,7 @@ F:	arch/x86/include/asm/svm.h
 F:	arch/x86/kvm/svm.c
 
 KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
-M:	Marc Zyngier <marc.zyngier@arm.com>
+M:	Marc Zyngier <maz@kernel.org>
 R:	James Morse <james.morse@arm.com>
 R:	Julien Thierry <julien.thierry@arm.com>
 R:	Suzuki K Pouloze <suzuki.poulose@arm.com>
-- 
2.20.1

