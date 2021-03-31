Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A11134A347
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 09:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhCZIh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 04:37:58 -0400
Received: from m12-18.163.com ([220.181.12.18]:37635 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhCZIhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 04:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=khWhN
        Liz8Y0gCiaThaxGXk9TRfGzQp0749K+yDhDHHc=; b=nh14fARKixuP4m/P2RqBf
        GI4o9SA1elGFBM7E268Yr/YB0UJLa7QGvwdeYHK4SQRJho0fcbnMbaT0S4f3hhtG
        KW0lGlmqHs9BiVO7Zvstr485aGVYoAZP81eawpeF03WW3ATSr/BRlu7JC8QhGvAE
        +m48qf4KN8PHhhh1B8F1G0=
Received: from COOL-20200916KH.ccdomain.com (unknown [218.94.48.178])
        by smtp14 (Coremail) with SMTP id EsCowABXVvQtnV1gz7cAaw--.4509S2;
        Fri, 26 Mar 2021 16:37:05 +0800 (CST)
From:   qiumibaozi_1@163.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ganjisheng <ganjisheng@yulong.com>
Subject: [PATCH 7/7] Remove unnecessary variable
Date:   Fri, 26 Mar 2021 16:36:59 +0800
Message-Id: <20210326083659.496-1-qiumibaozi_1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowABXVvQtnV1gz7cAaw--.4509S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr48AF13GFWDurWrJw18Zrb_yoW3uFb_Zr
        1fGa1UGw4kXa1Fvwn2ka15XF13Cwn3WF45Ar1rt39xAF90yr15Cr1vyr95CFZ7WFWfZrWk
        XrZrX3yfKF4I9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYUGYPUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5tlxzxxedr6xjbr6il2tof0z/1tbiLRFh2FSIlawR4AAAsR
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: ganjisheng <ganjisheng@yulong.com>

Signed-off-by: ganjisheng <ganjisheng@yulong.com>
---
 arch/x86/kvm/emulate.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f7970ba..7dfd529 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1403,8 +1403,6 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 static int decode_abs(struct x86_emulate_ctxt *ctxt,
 		      struct operand *op)
 {
-	int rc = X86EMUL_CONTINUE;
-
 	op->type = OP_MEM;
 	switch (ctxt->ad_bytes) {
 	case 2:
@@ -1418,7 +1416,7 @@ static int decode_abs(struct x86_emulate_ctxt *ctxt,
 		break;
 	}
 done:
-	return rc;
+	return X86EMUL_CONTINUE;
 }
 
 static void fetch_bit_operand(struct x86_emulate_ctxt *ctxt)
-- 
1.9.1


