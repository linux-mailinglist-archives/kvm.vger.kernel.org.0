Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE6730B522
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 03:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhBBCQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 21:16:24 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:38178 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230122AbhBBCQV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 21:16:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UNdRSz6_1612232136;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UNdRSz6_1612232136)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Feb 2021 10:15:36 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     chenhuacai@kernel.org
Cc:     aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] KVM: MIPS: remove unneeded semicolon
Date:   Tue,  2 Feb 2021 10:15:35 +0800
Message-Id: <1612232135-26683-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eliminate the following coccicheck warning:
./arch/mips/kvm/mips.c:151:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 arch/mips/kvm/mips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 3d6a7f5..58a8812 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -148,7 +148,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	default:
 		/* Unsupported KVM type */
 		return -EINVAL;
-	};
+	}
 
 	/* Allocate page table to map GPA -> RPA */
 	kvm->arch.gpa_mm.pgd = kvm_pgd_alloc();
-- 
1.8.3.1

