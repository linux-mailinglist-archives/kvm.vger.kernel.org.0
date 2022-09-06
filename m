Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CF45AF351
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 20:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiIFSJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 14:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiIFSJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 14:09:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F232CDC7
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 11:09:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-34577a9799dso25549457b3.6
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 11:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=WT2R6z6Lj/wGUMYzxUUXh6/WyMLsyb+mHF2mn3pQS0A=;
        b=Hpd5SISjcMrCHf9JGChu9s9F77ftmvQgJ0eeVwHgoh+jmH8F1saN/GiAHzrJkOyH4a
         iN6WTYT7UVvEuvarYM60NPIkdylI6USs8tojmkKw77K+FzJsBDpeS6tRdMmQaJ90Yqj0
         ZJptnNxxyoNksHntqPxpLUfqAYcJyBFpG+lpFu5PKIHClFsH9axeaw3Irj+zAzHR1Wfo
         7Rp+ZrH8BINtd+Ovld090w5P713yDfv9HryiEhwngEjv8zWXNGhM2yH+RuBBofiX+EhY
         flQGGu0JTrWNMppeNXJADO1ooRWl7S4HeZJmmlUGmaEgOGwDpImEYqEqW8UOFK/Rk65u
         aT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=WT2R6z6Lj/wGUMYzxUUXh6/WyMLsyb+mHF2mn3pQS0A=;
        b=yidv248pmHZ4BVRY6tudJAOQyOqrjWUcmlZNYJHpBg6zMJTFPW99USuHhrbUsK6J4P
         HPUJ+sWFxzcv7P370o/QkiKZZDiE5GR9LvttFx1U79UiklnkCd83omAd4tYdCrAvBJAS
         YIQt2JISvSvhTTu0NE4SwwIANyF/1UBXAZr+XrKI/CBEIkKBucQUHZlIJyB/3fwLRxvq
         P/hLap7mGGQRq6LXESxG2lrcGNn4ch1eFEOjwuH+Ittf5+o1k0xm71K7ZvWU0yhZ86qt
         WJmihmCfrtiVRYrSyiAU7RutdIOrWEnrfob0ox2yeJXHj5+mhAB/mL9MvJG5fC3ztciI
         w6wQ==
X-Gm-Message-State: ACgBeo1DxJZgbYgedd2jETd6BdLHNhhetJh81FE5KnBudoYldpN53LMs
        AHqEvx2CKvElO41Bl86B6JAWKbBZDj1SN+NG/+WPUVPn1Ui72Ui6igFwmwO89+o/NjsFnIEGrKw
        FdbtoHEn5t2erbE0lUCLON0Zcp1LNJX/7/oQCZu67o4nI5sIOq5B/nMPnpPgQMb4=
X-Google-Smtp-Source: AA6agR5HZOlR46dlOCLVnDPm04bTiVUX60QtegJVypIVw2VNqy4drQBeKd/JOH3/A4EZV6bHfN4lbEVmHNvhtg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:10c5:b0:671:7158:cf2c with SMTP
 id w5-20020a05690210c500b006717158cf2cmr39837170ybu.314.1662487782395; Tue,
 06 Sep 2022 11:09:42 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:09:21 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-5-ricarkol@google.com>
Subject: [PATCH v6 04/13] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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
2.37.2.789.g6183377224-goog

