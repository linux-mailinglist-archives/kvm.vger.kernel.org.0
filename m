Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BF860184E
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 21:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiJQT6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 15:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiJQT6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 15:58:45 -0400
Received: from mail-ot1-x34a.google.com (mail-ot1-x34a.google.com [IPv6:2607:f8b0:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B797748DC
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:44 -0700 (PDT)
Received: by mail-ot1-x34a.google.com with SMTP id q6-20020a9d6306000000b0065757df1611so5367194otk.19
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jgCIrvyj0IDci5P6m/g4M7I9DXQORNjMkIRBxaHCRXY=;
        b=ovz62uUAclqokr4+sK1sld0IXpy5sVrMhhq9Ztw46WvF06VocRRF4bINqwtQ6BZPpl
         TNxpT6pwkIsjNqwfbE24kJqeTaMuQij07JvtMzpJpnWb+k5lMBn94JUxBekLZOfAKXHA
         YwoG4h5WTYFEfxyyOEKLHR3jPojJCjxl+RHcO2yT69Pk0UQyNkkjW1XYvBmgAXKIMNK4
         HUTYWrNphngocXw+g5WSAN3blUVG4SRK/GOZ1gstMo4GM8RHzi+F6BWGm67ZuNY6lubq
         tP6zlKbL8jorR6bNLrO3wq0LZPuDLWOgObxgm6qD4CMOuwGYUbIE88qhCbRwtqRv3V2C
         OPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jgCIrvyj0IDci5P6m/g4M7I9DXQORNjMkIRBxaHCRXY=;
        b=T1eBMhaGBT4HRmTHi6LCgfd7qPHHJ0BLgyCci7y5gd6GKZrLsnSshgZeVaIPvr+08F
         zfSSkpQkYweU7KyNIGg+mf8zW17Dxqs8DBaPVnvjqTSBk/NY5Q8BM85JXdfJpaf/W6rG
         7vu9W8my9TUpzzLh7+1iWyPvuSGyaZxPnTVmsGd+RmqDCJn4++6I5Fuwdp4Pt6p1qwrF
         DRU5eRg86JkcTxEihD+u1yQw0Z49/26BnCLHrJRxqGWocFRGl4BY5P8Jj/qtb9VWGFF4
         sxbWPWeETgbrTz6F8aJ+KniLQM92V37o+kR3SN/rLd4MKQF6hda+DQMLa1G+twqf1vSJ
         FAHw==
X-Gm-Message-State: ACrzQf2BiQu4L5v6tpK7C9GHYJudajCEVbwoSbQYWWrC9fPrGuU0jYTG
        j5FuL32lgommO96bEoVoQ+2G9qWXGgy6Y8vP+hRP3vAZnznKgAovFu6lLU3lxXv4oH7Z2HrJ1KA
        XkSyasS14619UlVRfF10GYTjPJ0tqIxr1Omd1RKuloBRGX4zGoLdo9m0jvXI6LTA=
X-Google-Smtp-Source: AMsMyM5gN6HolrDQXK8DQ3qq5P69fItYC8UeUiEblU9Fno7u5E4vwNaG4hNg/nv1vmJNSfk9bS6oI/cvGWAmIQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6870:525:b0:130:9e35:137a with SMTP
 id j37-20020a056870052500b001309e35137amr6295123oao.88.1666036723631; Mon, 17
 Oct 2022 12:58:43 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:58:24 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-5-ricarkol@google.com>
Subject: [PATCH v10 04/14] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
with macros from asm/sysreg.h.  The index macros can then be used when
constructing PTEs (instead of using raw numbers).

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 25 ++++++++++++++-----
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index df4bfac69551..c1ddca8db225 100644
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
index 63ef3c78e55e..26f0eccff6fe 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -133,7 +133,7 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
+	uint64_t attr_idx = MT_NORMAL;
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
-- 
2.38.0.413.g74048e4d9e-goog

