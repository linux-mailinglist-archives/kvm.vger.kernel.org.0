Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDE529A49
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 16:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404159AbfEXOsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 10:48:02 -0400
Received: from foss.arm.com ([217.140.101.70]:44488 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403911AbfEXOsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 10:48:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 717DA15A2;
        Fri, 24 May 2019 07:48:01 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4E623F575;
        Fri, 24 May 2019 07:47:59 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 1/3] MAINTAINERS: KVM: arm/arm64: Remove myself as maintainer
Date:   Fri, 24 May 2019 15:47:43 +0100
Message-Id: <20190524144745.227242-2-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524144745.227242-1-marc.zyngier@arm.com>
References: <20190524144745.227242-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

I no longer have time to actively review patches and manage the tree and
it's time to make that official.

Huge thanks to the incredible Linux community and all the contributors
who have put up with me over the past years.

I also take this opportunity to remove the website link to the Columbia
web page, as that information is no longer up to date and I don't know
who manages that anymore.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5cfbea4ce575..4ba271a8e0ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8611,14 +8611,12 @@ F:	arch/x86/include/asm/svm.h
 F:	arch/x86/kvm/svm.c
 
 KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
-M:	Christoffer Dall <christoffer.dall@arm.com>
 M:	Marc Zyngier <marc.zyngier@arm.com>
 R:	James Morse <james.morse@arm.com>
 R:	Julien Thierry <julien.thierry@arm.com>
 R:	Suzuki K Pouloze <suzuki.poulose@arm.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.cs.columbia.edu
-W:	http://systems.cs.columbia.edu/projects/kvm-arm
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
 S:	Maintained
 F:	arch/arm/include/uapi/asm/kvm*
-- 
2.20.1

