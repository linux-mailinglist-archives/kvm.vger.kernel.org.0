Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375295BDCD6
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 08:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiITGC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 02:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiITGC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 02:02:26 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01CD13AB29;
        Mon, 19 Sep 2022 23:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=rPz6M
        0iDGacqM/TYQJ5LIsccdvNf/oq58gZjr7E4IwY=; b=atd0TWWv0ZgPTF5bcjo9y
        LajXUsE2dEpsqFlxYdRppFIpYIEX4bFl6A2pHVMH2rva6NdnQxR/9yBtbwgSI1N7
        fB89hX2GCZL8tUTH96c7uoUmY8XZ9+6/a3jZ4IPGj0Hh/8eggKbCOLWI042xjT/I
        s9UGMf2B1vab/7TJRKkm9U=
Received: from localhost.localdomain (unknown [117.160.246.157])
        by smtp2 (Coremail) with SMTP id DMmowAAnhbFoVyljNH+WBw--.22081S4;
        Tue, 20 Sep 2022 14:02:17 +0800 (CST)
From:   wangliangzz@126.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangliangzz@inspur.com
Subject: [PATCH] kvm_host.h: fix spelling typo in function declaration
Date:   Tue, 20 Sep 2022 14:02:10 +0800
Message-Id: <20220920060210.4842-1-wangliangzz@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowAAnhbFoVyljNH+WBw--.22081S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWDuFy8Cry5Kr18JrWDJwb_yoWfKrg_Za
        yfG3sYgFW7Wr1xtw1jkanaqr1Fgw4kJF409a15CryDJFyDtws8Cw4kWr1UXrWUWrZFkF93
        ZFnY9FyfZr12qjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU08MaUUUUUU==
X-Originating-IP: [117.160.246.157]
X-CM-SenderInfo: pzdqwzpldqw6b26rjloofrz/1tbiJAqC1lpEFrw1IgAAsZ
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wang Liang <wangliangzz@inspur.com>

Make parameters in function declaration consistent with
those in function definition for better cscope-ability

Signed-off-by: Wang Liang <wangliangzz@inspur.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..a2c71c205fd1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1345,7 +1345,7 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
-void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
+void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 
-- 
2.31.1

