Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AE7640C6D
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiLBRpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbiLBRpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:03 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ABDEDD65
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:53 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id c187-20020a1c35c4000000b003cfee3c91cdso2814986wma.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JIsIuRXiWXnXCKwBJDitiOnCfkciTH1HHiRQDJHgesk=;
        b=lY3D0DG7OYlu/yLytmFiO8bmtzr8j9RfeLmUddAzokAVSmv+7ynAuyoKHx7GcG8t/F
         55ZnmvJMFoCE0O0DAA8Axw8QMGxURWTXZsAb7YDYjVjKkZXhnxCe4Fk8ik8VyKqnCvRL
         L6BNV1DD2lvnBStXHefVhTW4vwgGHseRN4XPWWc2TCRVgZ/AKW+nUTUVKzF0gqdUOIpl
         GgsiQUH2slfO3tUMNZSJrY31AmOGGLD9oie3FPW1g9QRDikHVR0cBa3AgsL6Ipkr0VdL
         rwnWmr2s+oCVC8OmEfGr81javC5h99KB6ZQuYwZaFWYZmsxXUhIJ2CznxwRmcL4gczNc
         hhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JIsIuRXiWXnXCKwBJDitiOnCfkciTH1HHiRQDJHgesk=;
        b=IsDH+61WsfwIm4djGEB+6BBAoj881/eRc5sVdlciWHCTlImj6mgl+1a+niARQBdqEb
         B0uN3e1ULuEmCvEfOIpF/AshZ+rvODtdub0wkiu/5NGM1G1i7YU9dif5ge56pZFwsocM
         IkCj9bmbdq2ByySBIBkjTzDLZB8X+NwZSVt9cY0xDoUF3RtINt7OshkCWMc6kmdOLE9q
         ebk1wBWGkh2c34rCHVjFriZq7WVGfREHd/7WOeaqabQ8R/a04exxkr+fl0NQ3pT9Gfxb
         ijMSG5T2j3In3av5fPzYH90oMOKRhK1cRkCcmHhvhxYzvS7TQUS/Jp8DKsVjuMuzs8y8
         pbTw==
X-Gm-Message-State: ANoB5pmLl5KDmPSjBj/HG+XlougSH8WhvyZ5/cSm48iEepkglyBGVU9T
        F4BSiCDmup7/AFxlVUFQWanQvcRmgUKEgSnLUGKwlDxPh7ykReTxPc/QlbsKodQhfc2Ho9nV5wx
        b55EZfKvIf+ydEjKFP+AzLZlpNPMvt4Ye/Zck8cah1NRtqDNXXrHZxCQ=
X-Google-Smtp-Source: AA0mqf43ij/55PqTAKj6ipU15xRnsATW4/+aFXEeVudl+Q4NKkeJLuJLubxlzu1acaQojbKVMfCbZr/kLQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:2145:b0:3d0:920f:f7b7 with SMTP id
 v5-20020a05600c214500b003d0920ff7b7mr515672wml.22.1670003092186; Fri, 02 Dec
 2022 09:44:52 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:00 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-16-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 15/32] Replace kvm__arch_delete_ram() with kvm__delete_ram()
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
index 84a8675..3a3383a 100644
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
2.39.0.rc0.267.gcb52ba06e7-goog

