Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C44A3417C7
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 09:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhCSIxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 04:53:53 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:42757 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229624AbhCSIxV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 04:53:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0USZNPTU_1616143992;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0USZNPTU_1616143992)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Mar 2021 16:53:18 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] KVM: x86: Remove unused variable rc
Date:   Fri, 19 Mar 2021 16:53:12 +0800
Message-Id: <1616143992-30228-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following coccicheck warnings:

./arch/x86/kvm/emulate.c:4985:5-7: Unneeded variable: "rc". Return
"X86EMUL_CONTINUE" on line 5019.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 arch/x86/kvm/emulate.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f7970ba..8ae1e16 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4982,8 +4982,6 @@ static unsigned imm_size(struct x86_emulate_ctxt *ctxt)
 static int decode_imm(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		      unsigned size, bool sign_extension)
 {
-	int rc = X86EMUL_CONTINUE;
-
 	op->type = OP_IMM;
 	op->bytes = size;
 	op->addr.mem.ea = ctxt->_eip;
@@ -5016,7 +5014,7 @@ static int decode_imm(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		}
 	}
 done:
-	return rc;
+	return X86EMUL_CONTINUE;
 }
 
 static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
-- 
1.8.3.1

