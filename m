Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB424CE872
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 04:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiCFDUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 22:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiCFDUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 22:20:13 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7D533365;
        Sat,  5 Mar 2022 19:19:22 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id bc10so10681389qtb.5;
        Sat, 05 Mar 2022 19:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dGkLL1QQ2WoqaBJzjMOFNqMmNcr14rRZ+z4Dqgvsa0s=;
        b=PGG60hxI5hJuHOH0RwSxbhXgl3bLOFlDGB2U4s0U2rB1JrUH/+9NM9tvM5CUxwcqti
         ly87YFFXfl4Uu/zGq5Emc6Bzy4R9fvoyaJfUFOGL/PCaum957EQxcaS91NZlbmO8qoGn
         teU6AlFVK8eP4hZshzn2LhShTNTkXcVlVwDqiCcZ+4C6XVLXINEJpaTBvp0KFFO5BUc+
         lI3oguSH86e/tY2Aw39nMqv0zQbopJONZXHSiN73SUBRpzyY2J9warSecnD3z0061ReD
         vkmuAjzWytl+LpkEIUMiux6z2PDAx7Ygxsw9rSlFIbEQBnXmdi82eT0Ojbkwtk1wbY5l
         gBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dGkLL1QQ2WoqaBJzjMOFNqMmNcr14rRZ+z4Dqgvsa0s=;
        b=ioZZn/WlqTUsyMswzrTbdC6Dxu9IWayFVRDL2RvtUsAA3NxulmIAqFtWsO4P7hUlsX
         5rR87Uos8JrgTfYU/u/g0veYdu1QsCqlnw7mEpmCVsMfS/d6Q8Hun3l30npIqhJfSwLS
         9bsMug2GJ+rAYnljmOBUxzYKJU8ZJi+GTvHdclGhH9bLzvZM+qqMvLAf7AHobSjqwC5v
         kd6j5vIiTR7j9FA3S4YyiVyGrktqO83kW/cUjNwGtT+Hrkg1GnsnmYcquSYEqi0qKSpH
         +c1YlVKv3yAmXBUFg0J3d4RVos94cHPbxVAx2Am9XOjw5vyWk2XWWSMLoLYZCz4OcQqS
         wcUg==
X-Gm-Message-State: AOAM533FCNZqeey4bTFLEbKWBKGJitL1FZqgWwuqz5LhhKCY1UVMWeOV
        328Xby7dB+Z+MK86DQK5SyQ=
X-Google-Smtp-Source: ABdhPJyqnCf5QOrI+lgXJsCrA+YYXDDYCA0Q1zYPDuh3696w5HfbicNk/HS6eZV17o8z+2mtEIQQJQ==
X-Received: by 2002:ac8:7d8d:0:b0:2de:2c14:8c97 with SMTP id c13-20020ac87d8d000000b002de2c148c97mr4854528qtd.85.1646536761389;
        Sat, 05 Mar 2022 19:19:21 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id f1-20020a37ad01000000b0064919f4b37csm4463183qkm.75.2022.03.05.19.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 19:19:21 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] KVM: Use typical style for block comments
Date:   Sat,  5 Mar 2022 22:19:05 -0500
Message-Id: <20220306031907.210499-7-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306031907.210499-1-henryksloan@gmail.com>
References: <20220306031907.210499-1-henryksloan@gmail.com>
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

Adjusted spacing and line breaks for some comments so that the
asterisks align properly.

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

