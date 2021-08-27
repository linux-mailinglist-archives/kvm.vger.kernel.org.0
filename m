Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD193F92B1
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244120AbhH0DN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbhH0DNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF6BC06179A
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q11-20020a170902c9cb00b0013346a0d4e6so813931pld.14
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7ltC4LZo1AcY0S785rbycN7qIa7ski/y0jqVxQdf//g=;
        b=LYE1laivzODuZsXoshmJAtzheodVE2wwS8bkF9cHWqmMDcCBsKcl+w4+x9dFffcuzf
         w5FU6go/6Jwok8enOr/d2pGjShsKPReeuuVyQWT7w419tOPcxUUQl3dKRK+rnG+Mua2H
         1mBzkdfqe5nbhmQDZd5IfPBiXLdDF2cR613UU5UgcK5VhM3TUmY0QkeR+0hbua6KYCM8
         dYcyx4kLa3rmpLzo/GkB24OHESdShWZ+4rR4hkHXsonwUGD3imXvgqJtTbmLJBYh9rk4
         tXnRW+r7mfWxerft/N9Sit/QTNDfWYffQWXOQb0gAFldO6XLUJ/dmWaUGzv9MtO8EajJ
         UlwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7ltC4LZo1AcY0S785rbycN7qIa7ski/y0jqVxQdf//g=;
        b=Av2ju32YxfeQRIoyN2CZOn7e/qwb4eE16+tS232AZc8aPhG9WY+zJYeDTOdG7MWfay
         5yyfbloeKKzDcSCbxQhbjCUF7UnuPHQU9j/voWEH5K+cx57tQMqOeR/9ZjijrVpSl+RJ
         A4OZH7Us6pq34gOfdMCwPS0/xEy1LvmMfmtA+oU2QHT3yCZ1eOUUTzruSn2W4HTDU3iN
         fMZ+DdRo+FrsG1LvshFj7LkV+goHGcUOz3BxxeWVKxLGFmSrMCHb9VCiZZVeXY0YydHT
         5msW3ngWacqbGqNi3CU3h/xKMltoFUF4bJdKCUmgsGbK/T5svbIwidMpBvSiCX6M9Cjy
         koww==
X-Gm-Message-State: AOAM533NK0qT9v9gH+XTDKzTXXNkN3wva1EeJ0Wm+cnkU1t6K/sLyw1L
        KsU76tB1KjkDINPEYb/kfREkQihaKXPdxb3pRXEeOf9/Og0Kvd5c7lWPdTqCuunxffJw6cC8z8N
        uI2g5V4Y+M4AzL1TYLOdmLVwVv2Btrlv5oNMsAnWF5LL6tfZ+V5hataDzQzS2Izsoubif
X-Google-Smtp-Source: ABdhPJys1F+IiVgX0Px/VLafA4eGGvfLR/Gd068xwtfS4zriSzQhRWWClkaefTPD2Emo10msKLXMscD2SaLaxyhu
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a62:5c7:0:b029:3e0:dd9c:8fd2 with SMTP
 id 190-20020a6205c70000b02903e0dd9c8fd2mr6993660pff.28.1630033953505; Thu, 26
 Aug 2021 20:12:33 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:10 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-6-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 05/17] x86 UEFI: Load IDT after UEFI boot up
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interrupt descriptor table (IDT) is used by x86 arch to describe the
interrupt handlers. UEFI already setup an IDT before running the test
binaries, but this IDT is not compatible with the existing
KVM-Unit-Tests test cases, e.g., x86/msr.c triggers a #GP fault when
using UEFI IDT. This is because test cases setup new interrupt handlers
and register them into KVM-Unit-Tests' IDT, but it takes no effect if we
do not load KVM-Unit-Tests' IDT.

This commit fixes this issue:

   1. Port the IDT definition from cstart64.S to efistart64.S
   2. Update IDT descriptor with runtime IDT address and load it

In this commit, the x86/msr.c can run in UEFI and generates same output
as the default Seabios version.

Co-developed-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/setup.c            |  6 ++++++
 x86/Makefile.x86_64        |  2 +-
 x86/efi/README.md          |  4 ++--
 x86/efi/efistart64.S       | 34 ++++++++++++++++++++++++++++++++++
 x86/efi/elf_x86_64_efi.lds |  6 +++++-
 5 files changed, 48 insertions(+), 4 deletions(-)
 create mode 100644 x86/efi/efistart64.S

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index efb5ecd..5e369ea 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -10,6 +10,7 @@
 #include "fwcfg.h"
 #include "alloc_phys.h"
 #include "argv.h"
+#include "x86/desc.h"
 #include "asm/setup.h"
 
 extern char edata;
@@ -122,9 +123,14 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
 #ifdef TARGET_EFI
 
+/* From x86/efi/efistart64.S */
+extern void load_idt(void);
+
 void setup_efi(void)
 {
 	reset_apic();
+	setup_idt();
+	load_idt();
 	mask_pic_interrupts();
 	enable_apic();
 	enable_x2apic();
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index a5f8923..aa23b22 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -5,7 +5,7 @@ ifeq ($(TARGET_EFI),y)
 exe = efi
 bin = so
 FORMAT = efi-app-x86_64
-cstart.o = x86/efi/crt0-efi-x86_64.o
+cstart.o = $(TEST_DIR)/efi/efistart64.o
 else
 exe = flat
 bin = elf
diff --git a/x86/efi/README.md b/x86/efi/README.md
index befe9cc..360f9fe 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -22,13 +22,13 @@ To build:
 
 To run a test case with UEFI:
 
-    ./x86/efi/run ./x86/dummy.efi
+    ./x86/efi/run ./x86/msr.efi
 
 By default the runner script loads the UEFI firmware `/usr/share/ovmf/OVMF.fd`;
 please install UEFI firmware to this path, or specify the correct path through
 the env variable `EFI_UEFI`:
 
-    EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/dummy.efi
+    EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
 
 ## Code structure
 
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
new file mode 100644
index 0000000..ec607da
--- /dev/null
+++ b/x86/efi/efistart64.S
@@ -0,0 +1,34 @@
+/* Startup code and pre-defined data structures */
+
+#include "crt0-efi-x86_64.S"
+
+.globl boot_idt
+.globl idt_descr
+
+.data
+
+boot_idt:
+	.rept 256
+	.quad 0
+	.quad 0
+	.endr
+end_boot_idt:
+
+idt_descr:
+	.word end_boot_idt - boot_idt - 1
+	.quad 0 /* To be filled with runtime addr of boot_idt(%rip) */
+
+.section .init
+.code64
+.text
+
+.globl load_idt
+load_idt:
+	/* Set IDT runtime address */
+	lea boot_idt(%rip), %rax
+	mov %rax, idt_descr+2(%rip)
+
+	/* Load IDT */
+	lidtq idt_descr(%rip)
+
+	retq
diff --git a/x86/efi/elf_x86_64_efi.lds b/x86/efi/elf_x86_64_efi.lds
index 5eae376..3d92c86 100644
--- a/x86/efi/elf_x86_64_efi.lds
+++ b/x86/efi/elf_x86_64_efi.lds
@@ -1,4 +1,4 @@
-/* Copied from GNU-EFI/gnuefi/elf_x86_64_efi.lds, licensed under GNU GPL */
+/* Developed based on GNU-EFI/gnuefi/elf_x86_64_efi.lds, licensed under GNU GPL */
 /* Same as elf_x86_64_fbsd_efi.lds, except for OUTPUT_FORMAT below - KEEP IN SYNC */
 OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
 OUTPUT_ARCH(i386:x86-64)
@@ -38,6 +38,10 @@ SECTIONS
    *(.rodata*)
    *(.got.plt)
    *(.got)
+   /* Expected by lib/x86/desc.c to store exception_table */
+   exception_table_start = .;
+   *(.data.ex)
+   exception_table_end = .;
    *(.data*)
    *(.sdata)
    /* the EFI loader doesn't seem to like a .bss section, so we stick
-- 
2.33.0.259.gc128427fd7-goog

