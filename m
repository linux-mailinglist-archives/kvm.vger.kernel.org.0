Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8505AE0B8
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 09:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbiIFHPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 03:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238669AbiIFHPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 03:15:11 -0400
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE40B2C123;
        Tue,  6 Sep 2022 00:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=V3OOn
        rE1L2kDomzeAbLVraRMWLD+oxq9SYhKU9hqaZY=; b=DOlvmcoqJ2C9qd+UObzaJ
        5AL48kqPx0UinO0rJSdVWQrxauaGB2cek3RVLceKzVwG5HsRJ1bnD6Blf3M4YMlq
        ZnTzrpJJBbZ9aeP92v4pAOieey6W7UA6AW/680j/R8NgKv9pL5ulLvLgRITIo0z4
        U84Ncd4gUltlam0GPtUB9c=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by smtp3 (Coremail) with SMTP id G9xpCgCnUYtq8xZjhUBHbQ--.42433S2;
        Tue, 06 Sep 2022 15:14:53 +0800 (CST)
From:   Jiangshan Yi <13667453960@163.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiangshan Yi <yijiangshan@kylinos.cn>,
        k2ci <kernel-bot@kylinos.cn>
Subject: [PATCH] kvm_host.h: fix spelling typo in comment
Date:   Tue,  6 Sep 2022 15:14:22 +0800
Message-Id: <20220906071422.56715-1-13667453960@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgCnUYtq8xZjhUBHbQ--.42433S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrury7Jr47ZFy5Jw4rXF1DJrb_yoWftrbEv3
        Z7G3ykWrWfJr4S93W8ta4SqF1rKw4rCFyIgr95Wr47J3yqyws8Gw4kJF12ga4UGr4vkF93
        Zan5WrZ3Ar1DXjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU15C7UUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: bprtllyxuvjmiwq6il2tof0z/xtbBthV0+11uQXYk9QAAs5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_DIGITS,FROM_LOCAL_HEX,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jiangshan Yi <yijiangshan@kylinos.cn>

Fix spelling typo in comment.

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..261152086dac 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2184,7 +2184,7 @@ bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
 #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
 
 #ifdef CONFIG_HAVE_KVM_INVALID_WAKEUPS
-/* If we wakeup during the poll time, was it a sucessful poll? */
+/* If we wakeup during the poll time, was it a successful poll? */
 static inline bool vcpu_valid_wakeup(struct kvm_vcpu *vcpu)
 {
 	return vcpu->valid_wakeup;
-- 
2.25.1


No virus found
		Checked by Hillstone Network AntiVirus

