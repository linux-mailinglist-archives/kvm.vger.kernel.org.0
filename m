Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA433EF688
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbhHRAJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbhHRAJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:09:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D200C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t101-20020a25aaee0000b0290578c0c455b2so940661ybi.13
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IiM/DXlP0UDNoD3+R1FZh5utNS2/xJDRzidYz5LXQYE=;
        b=OCq96ZaENfar69JdJFOn3HbfF3JFj/F9minYzUsxMjaD0kBqprdxfcprXKbpYMOpg+
         OD2j4sj1Eu985DKYr6UmHu/RviqGlEL2OU5K3nwRAylUFCzmEE5ijMPwP4/4YRUuee4U
         9Wg3kkaWon4g3Tn//dXv/ivAB9i+8EiOWYvCegJlzQkVUxyrXOF0AdY/BOBdFaTcqJqM
         BHYMzXq95tkW+mUm8Fqe2EaGOKR0sVvFT3zr7fR6NI0apNDRpmlWYwrPnIA+KKS2QGIw
         xvEglXLMqiNbiNbnUlwR2DAtaTd+kH24c36Etnt4RH7C82OqbAJODP253J6XyZdm6JBw
         9GvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IiM/DXlP0UDNoD3+R1FZh5utNS2/xJDRzidYz5LXQYE=;
        b=QzfbwQd5BVRtacpS3HwHxFnAQYnyMjuxJoVJ5rA9GhCxmhC7hVH8IKtXu5A5dii5tJ
         dd3X3MfJgGevk6xVfJGpVqGK8GnN8JGv9DaPbkx6h0rmD0UMmHCj0VOD/Hw+EXt1k90E
         T6meXM9vVq0opAWzqIu7ePS4etQoJf+x1v8gC4Qcycl/VeAMfKP9DkpOyqfnYxjfK7Mk
         0QoyEHrGbH8i2ctN+SNOaUQ3VKGFUNGuNl1ZsGmtMGsMqQsGczdA+FuJCYcYzyiEPomo
         d9bapGLXPcCgxJwtZNaSIgOofeM+q+QBcIG2RRlnpxcXNXxQn7sSFy0eoxVlQXufrCAV
         E02Q==
X-Gm-Message-State: AOAM532ySCQ+KAsv8bOwWIa7dHOgmemg3lf0ssOmsu0FHiPsyMzrFEty
        2ynUWWV5fqol5cxBDgNMGbbBrjVHrzHISl/OE3edQV0Y0mFF8QI7FqswUY1iEkvpSRZYrO3zLnv
        YWFY52FmHHV+/m82ij2Ijb0UrYXlYfcwOpI+G9OrKSK80pfbZmeK7BZaFpXB2RWByr04Z
X-Google-Smtp-Source: ABdhPJzpnOISBxZGoYIdbAuZ5Sk2lfWz5jn9ZbneDbF0eQveqRoH56862JJfUApP1HtXccvXxLf872Ix6r3HUqUu
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:aaf1:: with SMTP id
 t104mr8014005ybi.516.1629245361426; Tue, 17 Aug 2021 17:09:21 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:53 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-5-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 04/16] x86 UEFI: Load KVM-Unit-Tests IDT after
 UEFI boot up
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
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

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/setup.c            |  6 ++++++
 x86/Makefile.common        |  3 ++-
 x86/Makefile.x86_64        |  2 +-
 x86/efi/README.md          |  4 ++--
 x86/efi/efistart64.S       | 32 ++++++++++++++++++++++++++++++++
 x86/efi/elf_x86_64_efi.lds |  6 +++++-
 6 files changed, 48 insertions(+), 5 deletions(-)
 create mode 100644 x86/efi/efistart64.S

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index e3faf00..9548c5b 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -9,6 +9,7 @@
 #include "fwcfg.h"
 #include "alloc_phys.h"
 #include "argv.h"
+#include "x86/desc.h"
 #include "asm/setup.h"
 
 extern char edata;
@@ -121,9 +122,14 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
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
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 00adddd..314bf47 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -48,7 +48,8 @@ ifeq ($(TARGET_EFI),y)
 
 %.so: %.o $(FLATLIBS) $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(cstart.o)
 	$(LD) -T $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(EFI_LDFLAGS) -o $@ \
-		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
+		$(EFI_LIBS_PATH)/crt0-efi-x86_64.o $(filter %.o, $^) \
+		$(FLATLIBS) $(EFI_LIBS)
 	@chmod a-x $@
 
 %.efi: %.so
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 7063ba1..aa23b22 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -5,7 +5,7 @@ ifeq ($(TARGET_EFI),y)
 exe = efi
 bin = so
 FORMAT = efi-app-x86_64
-cstart.o = $(EFI_LIBS_PATH)/crt0-efi-x86_64.o
+cstart.o = $(TEST_DIR)/efi/efistart64.o
 else
 exe = flat
 bin = elf
diff --git a/x86/efi/README.md b/x86/efi/README.md
index b7f760a..d31993e 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -30,13 +30,13 @@ searches GNU-EFI headers under `/usr/include/efi` and static libraries under
 
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
index 0000000..e8d5ad6
--- /dev/null
+++ b/x86/efi/efistart64.S
@@ -0,0 +1,32 @@
+/* Startup code and pre-defined data structures */
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
2.33.0.rc1.237.g0d66db33f3-goog

