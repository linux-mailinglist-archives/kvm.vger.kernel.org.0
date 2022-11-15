Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5B462970E
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbiKOLQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiKOLQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:25 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9756551
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:23 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id w23-20020adf8bd7000000b002358f733307so2691565wra.17
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yCP+R1g4kcGfSH64+R9MdUQUTy2IYW1+H52mLQqOgI0=;
        b=GkgRruqA0ppSlajCi5sm7hIvaWziRxBEokjpV00yqTBlg11/iJ5bQ4fv88DDvvVyrn
         PFRSyu6npvXn1oWFj07Xd7+8grAiaZgMt75w7BROa4SPEyYuebDSXU25m1SzPRokS/85
         jf/TK5QpHH4RdPGBgrr8kqkTuB9lDfkJXIFhKAJVNOVIYiWHbb8MpqU/OzEZipUyHufO
         FFJpIybTzPzY2zglp86kVhUnGPR6DMIsQ/hUnYaiCsbZPlntd/HPqHnUNzVL969VWSl4
         IQms1zf/51S0Ar1BGI4YAbeknS66cjS6c67VPFE/SYfbdDkftidqSGDW4vW66bqZIiuq
         NGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yCP+R1g4kcGfSH64+R9MdUQUTy2IYW1+H52mLQqOgI0=;
        b=KHhaszFeIQosqyBvJSAVngv12Iec1/edPdoNEbtI+bx9BzCWLPd2+fqVP4vxJ3bz7t
         msi9MMLL1pwdMoDbDaYyYTYHxDj/4NI/Z0KxrDfpo9s0B67/pQtMqpQHkukorDszF+Wu
         hUO1vP69kqjPQyk4irz939MtOsoldz21X/RUhndZH1dfwAdxFGQDLnxFlES3FXvO3SRU
         RarUKCJKda+hsz+Sba8J3A1+hhW68JahQpe6ZYxTFcHxehhLkZB1qW5Cf2g8UhMp5bNq
         5spuhd/e5T8Q5ztvp/BOlwtaBS6BEHhXTwGm0/Oro1BvgEywZXcxhcmKVYC9Vg8ESWtN
         xqcg==
X-Gm-Message-State: ANoB5pkm9ZgNpqjirjaBlk7vFY756aZ2YlCiL6bswjWVAO4HPw+A34OZ
        MGhu4vO8SETV8AbhlIhz5H/IKcxvw2/lVSrffFE7Aav6Oy2aOK1kl+ZRXW9+iqkR3i3lPLBMoZa
        yaMAuVOYepg0zTUAvoX7GGWIx2mdedjtAG+3hzkcpqVqat07tANNxg9w=
X-Google-Smtp-Source: AA0mqf592W1RIt1x7Z41ndYoXso/HvA7o2CB/Xgvo7p+oQzoIrG6P3bXvLp6fVweCFHAHgk8gXtmn344LQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:354c:b0:3cf:d70d:d5b3 with SMTP id
 i12-20020a05600c354c00b003cfd70dd5b3mr1057541wmq.202.1668510982429; Tue, 15
 Nov 2022 03:16:22 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:46 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-15-tabba@google.com>
Subject: [PATCH kvmtool v1 14/17] Replace kvm_arch_delete_ram with kvm_delete_ram
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

Now that deleting ram is the same across all architectures, no
need for arch-specific deletion of ram.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/kvm.c         |  5 -----
 include/kvm/kvm.h |  1 -
 kvm.c             | 13 +++++++++----
 mips/kvm.c        |  5 -----
 powerpc/kvm.c     |  5 -----
 riscv/kvm.c       |  5 -----
 x86/kvm.c         |  5 -----
 7 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 770075e..5cceef8 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -61,11 +61,6 @@ void kvm__init_ram(struct kvm *kvm)
 		 phys_start, phys_start + phys_size - 1, (u64)kvm->ram_start);
 }
 
-void kvm__arch_delete_ram(struct kvm *kvm)
-{
-	munmap(kvm->ram_start, kvm->ram_size);
-}
-
 void kvm__arch_read_term(struct kvm *kvm)
 {
 	serial8250__update_consoles(kvm);
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index d0d519b..f0be524 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -198,7 +198,6 @@ void kvm__arch_validate_cfg(struct kvm *kvm);
 void kvm__arch_set_cmdline(char *cmdline, bool video);
 void kvm__arch_init(struct kvm *kvm);
 u64 kvm__arch_default_ram_address(void);
-void kvm__arch_delete_ram(struct kvm *kvm);
 int kvm__arch_setup_firmware(struct kvm *kvm);
 int kvm__arch_free_firmware(struct kvm *kvm);
 bool kvm__arch_cpu_supports_vm(void);
diff --git a/kvm.c b/kvm.c
index ed29d68..695c038 100644
--- a/kvm.c
+++ b/kvm.c
@@ -169,14 +169,19 @@ struct kvm *kvm__new(void)
 	return kvm;
 }
 
-int kvm__exit(struct kvm *kvm)
+static void kvm__delete_ram(struct kvm *kvm)
 {
-	struct kvm_mem_bank *bank, *tmp;
-
-	kvm__arch_delete_ram(kvm);
+	munmap(kvm->ram_start, kvm->ram_size);
 
 	if (kvm->ram_fd >= 0)
 		close(kvm->ram_fd);
+}
+
+int kvm__exit(struct kvm *kvm)
+{
+	struct kvm_mem_bank *bank, *tmp;
+
+	kvm__delete_ram(kvm);
 
 	list_for_each_entry_safe(bank, tmp, &kvm->mem_banks, list) {
 		list_del(&bank->list);
diff --git a/mips/kvm.c b/mips/kvm.c
index 0faa03a..0a0d025 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -56,11 +56,6 @@ void kvm__init_ram(struct kvm *kvm)
 	}
 }
 
-void kvm__arch_delete_ram(struct kvm *kvm)
-{
-	munmap(kvm->ram_start, kvm->ram_size);
-}
-
 void kvm__arch_set_cmdline(char *cmdline, bool video)
 {
 
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 7b0d066..8d467e9 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -148,11 +148,6 @@ void kvm__arch_init(struct kvm *kvm)
 			 SPAPR_PCI_IO_WIN_SIZE);
 }
 
-void kvm__arch_delete_ram(struct kvm *kvm)
-{
-	munmap(kvm->ram_start, kvm->ram_size);
-}
-
 void kvm__irq_trigger(struct kvm *kvm, int irq)
 {
 	kvm__irq_line(kvm, irq, 1);
diff --git a/riscv/kvm.c b/riscv/kvm.c
index d05b8e4..4a2a3df 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -46,11 +46,6 @@ void kvm__init_ram(struct kvm *kvm)
 	kvm->arch.memory_guest_start = phys_start;
 }
 
-void kvm__arch_delete_ram(struct kvm *kvm)
-{
-	munmap(kvm->ram_start, kvm->ram_size);
-}
-
 void kvm__arch_read_term(struct kvm *kvm)
 {
 	serial8250__update_consoles(kvm);
diff --git a/x86/kvm.c b/x86/kvm.c
index 328fa75..8d29904 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -177,11 +177,6 @@ void kvm__arch_init(struct kvm *kvm)
 		die_perror("KVM_CREATE_IRQCHIP ioctl");
 }
 
-void kvm__arch_delete_ram(struct kvm *kvm)
-{
-	munmap(kvm->ram_start, kvm->ram_size);
-}
-
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
 {
 	struct kvm_irq_level irq_level;
-- 
2.38.1.431.g37b22c650d-goog

