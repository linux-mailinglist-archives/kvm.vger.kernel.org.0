Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8AA629710
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiKOLRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbiKOLQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:30 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ACA13CD8
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:28 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id m34-20020a05600c3b2200b003cf549cb32bso10386694wms.1
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sE/AjWGs85/jSnKi8kMix3x7KNT1E0UXCsHHKkvydVw=;
        b=Fhf8kzCbiOIw1urSU9e47/uZlsJ3VJeGJu/AiGsRB+hJ7XrqDOy+HRkYzEnXgwwRJJ
         ZRq0/9U9t9HylcL89/DJhxMSsEjr20fn+qkeaSaxW8VgzqAtzv0DVgxVgOBF7IcYhken
         JwUZTD+gY6TV/HADNOYE+aVemozVHFOurUPJpNAb5lUDFpzLsSI1AgOgRCmvAI+PGf0w
         vQ3OjFPyvyfgpEysXKMaVIBZ/Sv/XyQl4qp3KqOumjQRpslt5KN0se6WhbT73WKwH8N4
         XHh8qPAkMWd40bxd6AJxyWXtrxy2pyIT/XuzD/k1c1HXXuzIZvegmtjf3CtCg6Z7s/Mm
         KBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sE/AjWGs85/jSnKi8kMix3x7KNT1E0UXCsHHKkvydVw=;
        b=fEiBSS60HvhDze3yzjDN7D13SGwg5eiCt0u+FdQHic4SmVdlittKLZy78VOrE43ghz
         1A1MwAYmSgX4tbtgl4YNHYkM/NwMtnUwHTKt9xwjihb9WpCj/CIHyOrFAeILOZaiLzhI
         X4zCL0Hi0yds8GfEBi/Y5H7sWE598/vRLNWfGxqQb2upNcatP+LK9BFxXZAU+AtLWUn4
         fPFsFb68BXf3G81UCnRQhjGmtCvQrz1Wf4dFRPx8Ck/kyD+Rr2Ydpm4yDAKykiA4yus6
         ZXesZZmTS0jh1tKobDh2+aVLF5il+9V+n3pTEHMWPRT9scHVHTXDMkdBxQTo8R6c//Iv
         7iSQ==
X-Gm-Message-State: ANoB5pmz6tI+uexFvU8PDpXw4b0J4e51U0AsUUHKh2hv0KyNPo2M2x74
        ZHNdQnY4zmBg0iHHsCZNQlMTWpaBtOLV8ZLA17dZQYgp9L0YsG6wjYEp4ZTtrXP+L10IFoaWFkm
        Ol/HY/e30FeePDJ1cu8vY0IFt9YH7XvFLvBpHxyHYON0vfvYltp0pddY=
X-Google-Smtp-Source: AA0mqf4DUpAVLKt4u3X4kUyNKM+2ktYZQ0+aAP8X+Rz8jazkzEAeqUm3O0+LLgWkUMpgxQAD6ssxWXbIBw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:54ed:b0:3cf:486f:2700 with SMTP id
 jb13-20020a05600c54ed00b003cf486f2700mr1114421wmb.83.1668510987166; Tue, 15
 Nov 2022 03:16:27 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:48 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-17-tabba@google.com>
Subject: [PATCH kvmtool v1 16/17] Factor out set_user_memory_region code
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is common code, and will be reused in the future when
setting memory regions using file descriptors.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 kvm.c | 53 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/kvm.c b/kvm.c
index 695c038..a1eb365 100644
--- a/kvm.c
+++ b/kvm.c
@@ -193,10 +193,30 @@ int kvm__exit(struct kvm *kvm)
 }
 core_exit(kvm__exit);
 
+
+static int set_user_memory_region(int vm_fd, u32 slot, u32 flags,
+				  u64 guest_phys, u64 size,
+				  u64 userspace_addr)
+{
+	int ret = 0;
+	struct kvm_userspace_memory_region mem = {
+		.slot			= slot,
+		.flags			= flags,
+		.guest_phys_addr	= guest_phys,
+		.memory_size		= size,
+		.userspace_addr		= (unsigned long)userspace_addr,
+	};
+
+	ret = ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
+	if (ret < 0)
+		ret = -errno;
+
+	return ret;
+}
+
 int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		     void *userspace_addr)
 {
-	struct kvm_userspace_memory_region mem;
 	struct kvm_mem_bank *bank;
 	int ret;
 
@@ -220,18 +240,10 @@ int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		goto out;
 	}
 
-	mem = (struct kvm_userspace_memory_region) {
-		.slot			= bank->slot,
-		.guest_phys_addr	= guest_phys,
-		.memory_size		= 0,
-		.userspace_addr		= (unsigned long)userspace_addr,
-	};
-
-	ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
-	if (ret < 0) {
-		ret = -errno;
+	ret = set_user_memory_region(kvm->vm_fd, bank->slot, 0, guest_phys, 0,
+				     (u64) userspace_addr);
+	if (ret < 0)
 		goto out;
-	}
 
 	list_del(&bank->list);
 	free(bank);
@@ -246,7 +258,6 @@ out:
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		      void *userspace_addr, enum kvm_mem_type type)
 {
-	struct kvm_userspace_memory_region mem;
 	struct kvm_mem_bank *merged = NULL;
 	struct kvm_mem_bank *bank;
 	struct list_head *prev_entry;
@@ -327,19 +338,11 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		flags |= KVM_MEM_READONLY;
 
 	if (type != KVM_MEM_TYPE_RESERVED) {
-		mem = (struct kvm_userspace_memory_region) {
-			.slot			= slot,
-			.flags			= flags,
-			.guest_phys_addr	= guest_phys,
-			.memory_size		= size,
-			.userspace_addr		= (unsigned long)userspace_addr,
-		};
-
-		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
-		if (ret < 0) {
-			ret = -errno;
+		ret = set_user_memory_region(kvm->vm_fd, slot, flags,
+					     guest_phys, size,
+					     (u64) userspace_addr);
+		if (ret < 0)
 			goto out;
-		}
 	}
 
 	list_add(&bank->list, prev_entry);
-- 
2.38.1.431.g37b22c650d-goog

