Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0AC2501C
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 15:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfEUNZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 09:25:44 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:34978 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbfEUNZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 09:25:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D7FA80D;
        Tue, 21 May 2019 06:25:44 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C75D3F5AF;
        Tue, 21 May 2019 06:25:43 -0700 (PDT)
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Marc Zyngier <marc.zyngier@arm.com>, james.morse@arm.com,
        julien.thierry@arm.com, suzuki.poulose@arm.com,
        kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH] MAINTAINERS: KVM: arm/arm64: Remove myself as maintainer
Date:   Tue, 21 May 2019 15:25:40 +0200
Message-Id: <20190521132540.12729-1-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I no longer have time to actively review patches and manage the tree and
it's time to make that official.

Huge thanks to the incredible Linux community and all the contributors
who have put up with me over the past years.

I also take this opportunity to remove the website link to the Columbia
web page, as that information is no longer up to date and I don't know
who manages that anymore.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
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
2.18.0

