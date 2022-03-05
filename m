Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA64CE6FA
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiCEU2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiCEU2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:28:03 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8E66466;
        Sat,  5 Mar 2022 12:27:13 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id f21so9027737qke.13;
        Sat, 05 Mar 2022 12:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rY+Ye49v9G2IkJArVdUk2nKJVHCfthPoU709aRLqMk4=;
        b=Fck1TW46QmJPln39vFQUaisPRPzcTEBhPLRaSQLo6j3VHVl2I/k24gMeBog2cRv6Pb
         Jei5m7vrLZ/RXjmMu55c+28Ky5tnS/uE0JXQaj+Mhzk/ThhmrDVDN+HFZfLf6CKpJq11
         LIsVFL6PwtGEgaiivBS6eW07C+gZIzdwhCaGfDYh016E4RgOXdUN3Xf2M5BKQbti1PWK
         6R8xcqkajESny0WR3V0JrVM3zLDUA2NeS4HlrWuC7GrzUMcVw/ZfG5+TQicAy407NgBA
         ULq4/MDCJVjiZzPu5P1QaUSBkEg7jdMdpCAJJgmS9XVUmuenj1VXSruEhrYCwbDf1l6j
         j8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rY+Ye49v9G2IkJArVdUk2nKJVHCfthPoU709aRLqMk4=;
        b=Xp7pXcjzwqai4UtA8e9czjkqktnC23LbjKsrc13DDKO1DgsgtKIXABd+bVCWCD0ABP
         x9UgCjIpJzokJ9b+t+HRjc3TsPBKIGNGuqQuOCcPyQ75CX1p1P+hITBdHrxhxPMeMoet
         g5gi8xBcz60mahd1B1egPVd/XudmJ0hSngRpIe+cxsEK81ia0mU8LbBRpGS7t3DemIf9
         depRw1VsQnWcl+faptryqs/CCp5rLM+rXUBLTd3ZbMCCuUfJ8kkIzZEOlhbp5fRls2uc
         wCqaZUXszcLNMVkzUlvWbBmG6WBhoM7sT93eby9KzN2H6OvGIJYyFXcxlD2S+YDuBzk7
         ZdSQ==
X-Gm-Message-State: AOAM531sfdg3QlDdw1wq/r7HcNq6kwa7WE/tZ8vGLU4D0e643YUJi25o
        HqE9VpPK+vuIL799D28bHkY=
X-Google-Smtp-Source: ABdhPJxyROsd1tcVL1NnFmNX4ILzm4IVG9Y5Y+SaRW06yZo7lEICZBWrTY9uwYtvwaZmqVgOd8QKkg==
X-Received: by 2002:a05:620a:e1c:b0:47d:87eb:18b2 with SMTP id y28-20020a05620a0e1c00b0047d87eb18b2mr2764134qkm.527.1646512032783;
        Sat, 05 Mar 2022 12:27:12 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id e9-20020ac85989000000b002de2bfc8f94sm5654208qte.88.2022.03.05.12.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:27:12 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] KVM: fix checkpatch warnings
Date:   Sat,  5 Mar 2022 15:26:36 -0500
Message-Id: <20220305202637.457103-5-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220305202637.457103-1-henryksloan@gmail.com>
References: <20220305202637.457103-1-henryksloan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix warnings involving block comments

Signed-off-by: Henry Sloan <henryksloan@gmail.com>
---
 virt/kvm/irqchip.c  | 6 ++++--
 virt/kvm/kvm_main.c | 6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 69a327c043d7..80708f6ec9d9 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -120,8 +120,10 @@ static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
 
 void kvm_free_irq_routing(struct kvm *kvm)
 {
-	/* Called only during vm destruction. Nobody can use the pointer
-	   at this stage */
+	/*
+	 * Called only during vm destruction. Nobody can use the pointer
+	 * at this stage
+	 */
 	struct kvm_irq_routing_table *rt = rcu_access_pointer(kvm->irq_routing);
 
 	free_irq_routing_table(rt);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1988dd081606..1a9f20e3fa2d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2182,7 +2182,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 		 * never includes any bits beyond the length of the memslot (if
 		 * the length is not aligned to 64 pages), therefore it is not
 		 * a problem if userspace sets them in log->dirty_bitmap.
-		*/
+		 */
 		if (mask) {
 			flush = true;
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
@@ -5245,8 +5245,8 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 
 	/*
 	 * The debugfs files are a reference to the kvm struct which
-        * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
-        * avoids the race between open and the removal of the debugfs directory.
+	 * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
+	 * avoids the race between open and the removal of the debugfs directory.
 	 */
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
-- 
2.35.1

