Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6D3640C72
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbiLBRpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbiLBRp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:28 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2FCEFD30
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:13 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3dddef6adb6so41118627b3.11
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=beB34PxrwokOKRwQ8xX4T+xnA3Uimq2Xl8QpEqhqffA=;
        b=o/OjwIVyALbfqTrJjPTPr8HceThCvm7SjfCFEzPLNyJJCJPsa3QcZ2DImnmBkrZCW4
         7XDL+CaXI6VgRa5YAh+f29lE2McM4H3vX3I+4ynv8jjgrY+D7dtMiJ1aNs70pC6Ab1RT
         JBBegRulixaGpkMAsIV1FTj9RoYrttZHyBUOlY4wuhQnjmb7fCLR7gK9jjw3y/qsnZ2Y
         VKRTrnZfONqx2StzOk/PMG2BNqOy9OjLXqBrlcqFDuuMGgaqLfx6axGGB0D58vil6aeD
         evg7fowe0LVlDotyWmoajqy7gwJUikq8/nCGQFbGVxhl9nLuZdvasALvONSB30WlZXvC
         sBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=beB34PxrwokOKRwQ8xX4T+xnA3Uimq2Xl8QpEqhqffA=;
        b=71ddygpIxAttG0rexOtlxz3wo8I2TAakUSmrK4GQhX5UsMWCNf+dghrD0eFZMo5DlB
         SDz31tGXTPoKCMizPas+5OGIqPYTtyFZI+TZcjjEIW9BuKWqIPjuu5Dh+fzvzxAb7nYu
         8hV1ofzvJwKC+yfpd6nuHUNomfpk5t4eVBonypG/D1X1Gfs+dlvNxX+r+YVGReAqILiM
         Gb12+UvXYws/mA1MCLO+YOb3yOkCmEXb7TrtuzSf+wdbWt90oYYJP6k6S0uVL16WIo8e
         rJdtYW2nZJZDA6kjUd8WGEpwgj2mkbW+YLNBLzitJgvEv+E9IQtUz+EPCL/lpUa/tkxU
         FsFw==
X-Gm-Message-State: ANoB5pkDN8MVxsCrI+aVO4n5x6dCx91tzK34XT+A0hEHuQlchlKEZdjF
        euTPdN82fYPds9GIl5O58qFqjVDmj4/dZMh9DeS0m0ZEhlB+9sLEMK1jG687pUC/CKextBIDg3D
        eLR66bCAwA9hREdIU54ChWMT7643FbyudWnms6MOKbfx17WTnjhm1Y3w=
X-Google-Smtp-Source: AA0mqf7i54GXu9DUwt9r49UbWUKugAzuHriqgSQUqIFDvtyFnVoQlgcnPMdFw+wTcw5d7m8LJcUrWKeyBw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:715:0:b0:369:edd9:6c8b with SMTP id
 21-20020a810715000000b00369edd96c8bmr576329ywh.452.1670003102340; Fri, 02 Dec
 2022 09:45:02 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:05 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-21-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 20/32] Add kvm linux headers and structure
 extensions for restricted_fd
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
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

This enables building kvmtool on a host that doesn't have the
kernel with the new extensions yet.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 0d5d441..1d35153 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -103,6 +103,14 @@ struct kvm_userspace_memory_region {
 	__u64 userspace_addr; /* start of the userspace allocated memory */
 };
 
+struct kvm_userspace_memory_region_ext {
+	struct kvm_userspace_memory_region region;
+	__u64 restricted_offset;
+	__u32 restricted_fd;
+	__u32 pad1;
+	__u64 pad2[14];
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
  * other bits are reserved for kvm internal use which are defined in
@@ -110,6 +118,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_PRIVATE		(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -272,6 +281,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_MEMORY_FAULT     38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -510,6 +520,14 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+#define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1 << 0)
+			__u32 flags;
+			__u32 padding;
+			__u64 gpa;
+			__u64 size;
+		} memory;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1178,6 +1196,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_PRIVATE_MEM 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

