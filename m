Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E934331E19
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 05:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCIExX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 23:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhCIExB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 23:53:01 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C1FC06174A
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 20:53:01 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id m4so7716492pfd.20
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 20:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=g7IY8Tcrq5NLNN6TDDduO6XJePxJkfxYBv5xiq6DiHs=;
        b=DpULcv3v3UVNWYAf7whBKSa7An4eQZj6C83d3VgbfmD++AbA8vIt0W+nfGJRP1pfVi
         m8lGWs1pUBWSXJYBGisutPKE9RPQsw7/BYtLvEc5KhF22UW9WymiXRCTz1lLo211TzZx
         XnZ3O2AaJ7cOQA8G7m1wNGLxc4XugW1lb6Xg5EKxlBHHclD+2PFq6rU4GHFpHwWIzKbb
         00jXX61/XpCIgKXFUajBYJLAuDRZkn8XBf50B6rDVxOaJHWtNzgkxyfSto8FmJQBLfSc
         rtThQsmbpfbSymnprzj+8p8uv4pYo5xS7Mi9Q0hGeHX9royKu8j41Y+EmSP/Q3CKwIy9
         oOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=g7IY8Tcrq5NLNN6TDDduO6XJePxJkfxYBv5xiq6DiHs=;
        b=kSqnHqOydYfe1Hzvzf3QpgIbPhVW4r4cbXfHDibj4hyfoj9Dsw+i7E6HbYQfDThB/2
         LISDMziFZgH2eh3SYMU8iXMqb1MVirGHB+Qip8j81JgYwfqm68B0/BJlOYffGsdXhOzJ
         jPP2b9v/lRuTlDh5uwhwp/FIY0MQQmNYAUFAO074q+te2JU4zJGReRXbYeEpokWACLS/
         k8bOjAcmURWtBAPX/RLr63Isg6QP6HXUEspvN2ji9+WS2cxZX3PE7HXKx49kteV6yRSP
         vc8t4jdIn6artzqM+W1i2uw4IkSyzaSW7JE0zE2GUTap7vMsdtSc1HQBCOge91facHTm
         Yw3w==
X-Gm-Message-State: AOAM531tmA+FSC28qbkdgtt49/Pd1hpNo7/krBlbEADQwlnxeyOc0/9Q
        JaJlF06imSqFjLL+Yv7V7opGLCu0Q4hb8eNuTRuvFh0ymMCNQJhBf5evs+F0aZVeq1v6SMxo6z/
        i61nlb3bnCHL/9BT8crd0+NDWudguXAIfov7DFKrsNbK5uyVsTgqTKg==
X-Google-Smtp-Source: ABdhPJzvF2vBZNfjF2t6Zq80JiFAgawfERpdIzTI4spvMWF6TFib6QAl1nIzNKFN99TP1VQX1rJFdngKfw==
Sender: "morbo via sendgmr" <morbo@fawn.svl.corp.google.com>
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:ec92:b06d:3efe:189a])
 (user=morbo job=sendgmr) by 2002:a17:90a:a584:: with SMTP id
 b4mr2699996pjq.186.1615265580925; Mon, 08 Mar 2021 20:53:00 -0800 (PST)
Date:   Mon,  8 Mar 2021 20:52:50 -0800
Message-Id: <20210309045250.3333311-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [kvm-unit-tests PATCH] Makefile: do not use "libgcc" for clang
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The -nostdlib flag disables the driver from adding libclang_rt.*.a
during linking. Adding a specific library to the command line then
causes the linker to report unresolved symbols, because the libraries
that resolve those symbols aren't automatically added. Turns out clang
doesn't need to specify that library.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 Makefile            | 6 ++++++
 arm/Makefile.common | 2 ++
 x86/Makefile.common | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/Makefile b/Makefile
index e0828fe..61a1276 100644
--- a/Makefile
+++ b/Makefile
@@ -22,10 +22,16 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
 cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
 
+# cc-name
+# Expands to either gcc or clang
+cc-name = $(shell $(CC) -v 2>&1 | grep -q "clang version" && echo clang || echo gcc)
+
 #make sure env CFLAGS variable is not used
 CFLAGS =
 
+ifneq ($(cc-name),clang)
 libgcc := $(shell $(CC) --print-libgcc-file-name)
+endif
 
 libcflat := lib/libcflat.a
 cflatobjs := \
diff --git a/arm/Makefile.common b/arm/Makefile.common
index a123e85..94922aa 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -58,7 +58,9 @@ OBJDIRS += lib/arm
 libeabi = lib/arm/libeabi.a
 eabiobjs = lib/arm/eabi_compat.o
 
+ifneq ($(cc-name),clang)
 libgcc := $(shell $(CC) $(machine) --print-libgcc-file-name)
+endif
 
 FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libgcc) $(libeabi)
 %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 55f7f28..a96b236 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -37,7 +37,9 @@ COMMON_CFLAGS += -O1
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
 
+ifneq ($(cc-name),clang)
 libgcc := $(shell $(CC) -m$(bits) --print-libgcc-file-name)
+endif
 
 # We want to keep intermediate file: %.elf and %.o 
 .PRECIOUS: %.elf %.o
-- 
2.30.1.766.gb4fecdf3b7-goog

