Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E9955A39B
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiFXVdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiFXVdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:33:15 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4B715FF9
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:13 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 189-20020a6216c6000000b005252417051fso1638414pfw.8
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2pvMWA5+LGv3RdMZNBoLvpYZzgKfwmddMMIH/iaxNxg=;
        b=DWRLrw0Pt69QOEsBGJR5o/AN8ZFPsVl53Xo8K8BIJhG/IDN/uxsSrynpUdplQs376z
         lqxwwBt1kmwr+toD0URkkYAZ3p7c5C/TMMc0W6SGwg5q9acLZEawJ5XW5EXAT/hHjF+7
         dJ8PYxHzObjsF5WwmcCMZQdoecdsWgnkpFR5MqkLUlicWqozJaLjCY+kYPY8m8boWU73
         90T/Iq11fKY2ZMiVbBwrBqEkDPhJzPWD2OPeXPHsjK7tRr1yHWnCUQd870WkN9B9LODN
         FwGfF6Rh0mSy5RG+yZxvNpJYKx7RCfin80oYvjsMMgugwBlD2sdn8A22hN5v09qAIyQr
         KDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2pvMWA5+LGv3RdMZNBoLvpYZzgKfwmddMMIH/iaxNxg=;
        b=LyMResuJhwEMDUn2XDaCiReJtee4BWHBO1QYooR1e2kiugXlBs4aNzBNeHyGQPP8xT
         OJnze3QL6WGgZCGwNzmOhZCwmP9OLGh/GfqAqhrbvVkqfl9ZAjVBhFnQaAPK1gCpeNE9
         EtcLdypLHla8SHz9GEFFtvdRU20avA8FQz1FTElu4Aty7rOARdLP+uxo83cXPqhi0uEr
         ZBitCVDDnDVeXiL7ymbnAYtaNa+DgJq9ZkHKRGvFzwIf40LsvMruc+SRQD6Ufww7GCZs
         nKquMCUaXM+ji+wbxmPlaNB5CD1DFd7BOcPoLuUd+mAu7xiXbcCpuJU02j5L1HTnN56f
         ztLQ==
X-Gm-Message-State: AJIora8EGwp4c6AU8z+V3bwQVy3uYDma21dbJrVIJk69giDzu0J2KYNL
        y4ArJ9ZNqG4lQUdtLfA2cmXyZlyYzEHbFH6I1DVGwbQiDeloheHhcvSvs5gqD5f6KThE+7CCeLH
        t02JNbyaX8IJnpQbv48MNNt+H624rFYlFYtFxzGTp+0/BzKpmGOyfnBCBAYkWwlY=
X-Google-Smtp-Source: AGRyM1tXnFVHX/mA1hKXRSHVJBfUgoA+2551qzmvFCvbDgZmsP7oq3cp/lqnX0pyYD+bQFHOsi/Tr1cAB3hKtA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e8c6:b0:169:10c4:5231 with SMTP
 id v6-20020a170902e8c600b0016910c45231mr1144856plg.173.1656106392828; Fri, 24
 Jun 2022 14:33:12 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:32:51 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 07/13] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
with macros from asm/sysreg.h.  The index macros can then be used when
constructing PTEs (instead of using raw numbers).

Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 25 ++++++++++++++-----
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 6649671fa7c1..74f10d006e15 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -38,12 +38,25 @@
  * NORMAL             4     1111:1111
  * NORMAL_WT          5     1011:1011
  */
-#define DEFAULT_MAIR_EL1 ((0x00ul << (0 * 8)) | \
-			  (0x04ul << (1 * 8)) | \
-			  (0x0cul << (2 * 8)) | \
-			  (0x44ul << (3 * 8)) | \
-			  (0xfful << (4 * 8)) | \
-			  (0xbbul << (5 * 8)))
+
+/* Linux doesn't use these memory types, so let's define them. */
+#define MAIR_ATTR_DEVICE_GRE	UL(0x0c)
+#define MAIR_ATTR_NORMAL_WT	UL(0xbb)
+
+#define MT_DEVICE_nGnRnE	0
+#define MT_DEVICE_nGnRE		1
+#define MT_DEVICE_GRE		2
+#define MT_NORMAL_NC		3
+#define MT_NORMAL		4
+#define MT_NORMAL_WT		5
+
+#define DEFAULT_MAIR_EL1							\
+	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT))
 
 #define MPIDR_HWID_BITMASK (0xff00fffffful)
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 8dd511aa79c2..733a2b713580 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -133,7 +133,7 @@ void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
+	uint64_t attr_idx = MT_NORMAL;
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
 }
-- 
2.37.0.rc0.161.g10f37bed90-goog

