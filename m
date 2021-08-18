Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AD83EF685
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhHRAJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbhHRAJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:09:50 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEE3C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:16 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id q13-20020a05620a038d00b003d38f784161so495182qkm.8
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BLT94TLXpRYu5Mj/XjaInRqiHZpKk1KEUoMwsfP1jio=;
        b=afxt5ViE3fDd9WF0E3hVaTwGWE4OD/GfSqKiUVB37hk7scX/Y39DZiShMCjF2XZ1qT
         S7UPXjk/DEgMGXcUjWF0BVf87d6VeHDC8jzHJyjvF3Avae7s7fwJTuIiZw0bwPVssA8p
         2TabVqrWroebPD4qD2G+skQXtsB8JEDQaf1H8w37pQyvVY46Ea6KKwfzswP0D9Rntxke
         qUdUX/Kw/e4Kv06Cymtl092JOExVpNeloU6Dirqc2eHSspbYGM9iNqMHgkgaPrLvWcS4
         EO5W+pujXbsEFC3jhkvxYCoRy4eIB1a55sZ34AeCGvIlz2Mnl/NpGYsM3m8sjq9dwk+L
         6dRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BLT94TLXpRYu5Mj/XjaInRqiHZpKk1KEUoMwsfP1jio=;
        b=TB54lv4jRs3eNp+zTOjkmlZII/8qHF0yMoG+KfvmMisrG2hekQnwQD90iy+9SxfgDA
         JA5kRNKiB9QWvHryLAjeY33FCb+lZhxMj4JJ8DylcMKwGPGHTHAATZWrT7LX91aNmzhy
         zZsu7c7F5L/UBrDFXL1WBTxedRioeZsUdIU+F7jmAKdl2GWhGjI+yrRl3PLZAKKU6hnA
         WD22g9IiI04TD0sYN3e9cNLEvGgN4Gu9tsI3XaAY5mHbya8leMHtQ+/lbHWTQlH3zSgA
         1dxuRcnm7VH7L9T5j6AEr7E8GZ45XJxbXwlmUwmU9EIXDwQos+v/XROujp0Xj+Vx/afs
         BSYQ==
X-Gm-Message-State: AOAM532cRpGhWAqEiJ/mV8bSKSipBKq70AH/bZP7NwJX1lbB/PPOiOr9
        iDkohRiq4bE19TtvWoAPS9UgJ7aZIWcFUOmFyLIgNsMbGhkRwDYWG/ITZQiOQCFncHoL+jWaXgJ
        FaYcKVmh3ds0HLfOeH63zjzHxhP9H97jWsUCLHnM6VGfYp4UuvMsg5k0Wgz4CzK+5Xgq/
X-Google-Smtp-Source: ABdhPJx9Lf2xEufos4aA1Zj1Eg8FJoimekz9Atl6KL4kId7GQcv3qDKlINzoAr6+o1JeTsr+bcrr82dNY50SAtkk
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a05:6214:10c4:: with SMTP id
 r4mr6153128qvs.58.1629245355889; Tue, 17 Aug 2021 17:09:15 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:50 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-2-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 01/16] x86 UEFI: Copy code from GNU-EFI
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

To build x86 test cases with UEFI, we need to borrow a linker script
from GNU-EFI. This commit only copies the source code, without any
modification. The linker script will be used by KVM-Unit-Tests in the
following commits in this patch series.

The following source code is copied from GNU-EFI:
   1. x86/efi/elf_x86_64_efi.lds

We will put EFI-specific files under a new dir `x86/efi` because:
   1. EFI-related code is easy to find
   2. EFI-related code is separated from the original code in `x86/`
   3. EFI-related code can still reuse the Makefile and test case code
      in its parent dir `x86/`

GNU-EFI repo and version:
   GIT URL: https://git.code.sf.net/p/gnu-efi/code
   Commit ID: 4fe83e102674
   Website: https://sourceforge.net/p/gnu-efi/code/ci/4fe83e/tree/

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 x86/efi/README.md          | 25 +++++++++++++
 x86/efi/elf_x86_64_efi.lds | 77 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)
 create mode 100644 x86/efi/README.md
 create mode 100644 x86/efi/elf_x86_64_efi.lds

diff --git a/x86/efi/README.md b/x86/efi/README.md
new file mode 100644
index 0000000..4deba6e
--- /dev/null
+++ b/x86/efi/README.md
@@ -0,0 +1,25 @@
+# EFI Startup Code and Linker Script
+
+This dir contains a linker script copied from
+[GNU-EFI](https://sourceforge.net/projects/gnu-efi/):
+   - elf_x86_64_efi.lds: linker script to build an EFI application
+
+The following pre-compiled object files ship with GNU-EFI library, and are used
+to build KVM-Unit-Tests with GNU-EFI:
+   - crt0-efi-x86_64.o: startup code of an EFI application
+   - libgnuefi.a: position independent x86_64 ELF shared object relocator
+
+EFI application binaries should be relocatable as UEFI loads binaries to dynamic
+runtime addresses. To build such relocatable binaries, GNU-EFI utilizes the
+above-mentioned files in its build process:
+
+   1. build an ELF shared object and link it using linker script
+      `elf_x86_64_efi.lds` to organize the sections in a way UEFI recognizes
+   2. link the shared object with self-relocator `libgnuefi.a` that applies
+      dynamic relocations that may be present in the shared object
+   3. link the entry point code `crt0-efi-x86_64.o` that invokes self-relocator
+      and then jumps to EFI application's `efi_main()` function
+   4. convert the shared object to an EFI binary
+
+More details can be found in `GNU-EFI/README.gnuefi`, section "Building
+Relocatable Binaries".
diff --git a/x86/efi/elf_x86_64_efi.lds b/x86/efi/elf_x86_64_efi.lds
new file mode 100644
index 0000000..5eae376
--- /dev/null
+++ b/x86/efi/elf_x86_64_efi.lds
@@ -0,0 +1,77 @@
+/* Copied from GNU-EFI/gnuefi/elf_x86_64_efi.lds, licensed under GNU GPL */
+/* Same as elf_x86_64_fbsd_efi.lds, except for OUTPUT_FORMAT below - KEEP IN SYNC */
+OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
+OUTPUT_ARCH(i386:x86-64)
+ENTRY(_start)
+SECTIONS
+{
+  . = 0;
+  ImageBase = .;
+  /* .hash and/or .gnu.hash MUST come first! */
+  .hash : { *(.hash) }
+  .gnu.hash : { *(.gnu.hash) }
+  . = ALIGN(4096);
+  .eh_frame : 
+  { 
+    *(.eh_frame)
+  }
+  . = ALIGN(4096);
+  .text :
+  {
+   _text = .;
+   *(.text)
+   *(.text.*)
+   *(.gnu.linkonce.t.*)
+   . = ALIGN(16);
+  }
+  _etext = .;
+  _text_size = . - _text;
+  . = ALIGN(4096);
+  .reloc :
+  {
+   *(.reloc)
+  }
+  . = ALIGN(4096);
+  .data :
+  {
+   _data = .;
+   *(.rodata*)
+   *(.got.plt)
+   *(.got)
+   *(.data*)
+   *(.sdata)
+   /* the EFI loader doesn't seem to like a .bss section, so we stick
+      it all into .data: */
+   *(.sbss)
+   *(.scommon)
+   *(.dynbss)
+   *(.bss)
+   *(COMMON)
+   *(.rel.local)
+  }
+  .note.gnu.build-id : { *(.note.gnu.build-id) }
+
+  _edata = .;
+  _data_size = . - _etext;
+  . = ALIGN(4096);
+  .dynamic  : { *(.dynamic) }
+  . = ALIGN(4096);
+  .rela :
+  {
+    *(.rela.data*)
+    *(.rela.got)
+    *(.rela.stab)
+  }
+  . = ALIGN(4096);
+  .dynsym   : { *(.dynsym) }
+  . = ALIGN(4096);
+  .dynstr   : { *(.dynstr) }
+  . = ALIGN(4096);
+  .ignored.reloc :
+  {
+    *(.rela.reloc)
+    *(.eh_frame)
+    *(.note.GNU-stack)
+  }
+  .comment 0 : { *(.comment) }
+}
-- 
2.33.0.rc1.237.g0d66db33f3-goog

