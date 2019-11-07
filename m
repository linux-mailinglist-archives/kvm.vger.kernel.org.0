Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89121F2402
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 02:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732689AbfKGBJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 20:09:04 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:57338 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKGBJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 20:09:03 -0500
Received: by mail-pg1-f202.google.com with SMTP id 11so395655pgm.23
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 17:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wCVCgwDANVIGIxCeEGctye8R+7lP7DshFbaab6MvEoc=;
        b=gvLdfGSIe6tXg1Q1iHltg/tBMaN6XZVeV87ue4/qdDx6HZVtKG20VlJM6KBTo3BVdb
         Z+veG92zi4nm00dVgR3/ksVbSaEjXkvecDAxb1ZRBW+0SOLH/YYdi1+PJnkxIJxCCiO/
         zIEiYwRzigtZnmtRmd5O+dat+zAXONYQU0tdUa3nQh/X93/n3bvMf8EBnhSeZR+5qqrg
         eeRtoq1pUVl493iu5kuevmI2PYv2VbkLtbByDbk0V5d1btC1WRVmCX8wUolTBUoWBm9O
         zZCtJHtDWnMc5uGnICPrNc6gRae7X873hwVfTAcUrNRw/+izMxXY99o7aYoH8Ccf6iLd
         QKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wCVCgwDANVIGIxCeEGctye8R+7lP7DshFbaab6MvEoc=;
        b=mcBB1YSj8GTUNb9qzpdYOzYsXyYhX6NRX0SgqeXYqquhyB/NKt37WkO8/2Rr9He07F
         k6bwFyPzU49Nlu1rCKKK3VAETKcrcThhNPgMkRBNfi6jRLwG7CSfnPuNVz2On9vMZxQh
         VSSPYj1T+VaYgCJtI7J1M+pGeFo8LBWOWj3RfGngGxQBfqb10OErIosAyDe1MVmKV6eU
         9iAyRs9Yv2Qh/0R/C+AMByrYozDS86m5HkSyyGOMYmDTu+tiJS+Q8MTfCASlYmuZee7W
         mSiN09augfU66m5ccynmjgDrpKwFUwhiFmO8QwlYbvG8f2YBBMRi0twJZIG0wT7TKDVD
         RPxQ==
X-Gm-Message-State: APjAAAXI5mKsZJSwglWb1blQ8lyHbvI88uxDn209cQY/aieG/98xriQg
        CdnNYydwaR9Otwouqq021EZO16zXo4Hlvtz3dSKbqYEhs2R7IbXjwMinPTG4ffDpA9w+9vPjZIa
        oBlxE0PMJu6dLuJoSSxATpzNuTociul4KMMOBkTZ+DI84tSxWpfiAZQ==
X-Google-Smtp-Source: APXvYqwGU38QKUG5yK6xcv4PG0DKHW1Kiqm7mt0rMEn8GMIMQRuA4/NDa1bW/CjueqS/vfvAu/ZuKcaVVg==
X-Received: by 2002:a65:5303:: with SMTP id m3mr970458pgq.400.1573088941471;
 Wed, 06 Nov 2019 17:09:01 -0800 (PST)
Date:   Wed,  6 Nov 2019 17:08:44 -0800
In-Reply-To: <20191107010844.101059-1-morbo@google.com>
Message-Id: <20191107010844.101059-3-morbo@google.com>
Mime-Version: 1.0
References: <20191107010844.101059-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH 2/2] Makefile: add "cxx-option" for C++ builds
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The C++ compiler may not support all of the same flags as the C
compiler. Add a separate test for these flags.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 Makefile | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 4c716da..9cb47e6 100644
--- a/Makefile
+++ b/Makefile
@@ -48,6 +48,8 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
 
 cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
+cxx-option = $(shell if $(CXX) -Werror $(1) -S -o /dev/null -xc++ /dev/null \
+              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
 
 COMMON_CFLAGS += -g $(autodepend-flags)
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
@@ -62,8 +64,6 @@ fno_pic := $(call cc-option, -fno-pic, "")
 no_pie := $(call cc-option, -no-pie, "")
 wclobbered := $(call cc-option, -Wclobbered, "")
 wunused_but_set_parameter := $(call cc-option, -Wunused-but-set-parameter, "")
-wmissing_parameter_type := $(call cc-option, -Wmissing-parameter-type, "")
-wold_style_declaration := $(call cc-option, -Wold-style-declaration, "")
 
 COMMON_CFLAGS += $(fomit_frame_pointer)
 COMMON_CFLAGS += $(fno_stack_protector)
@@ -75,11 +75,19 @@ COMMON_CFLAGS += $(wclobbered)
 COMMON_CFLAGS += $(wunused_but_set_parameter)
 
 CFLAGS += $(COMMON_CFLAGS)
+CXXFLAGS += $(COMMON_CFLAGS)
+
+wmissing_parameter_type := $(call cc-option, -Wmissing-parameter-type, "")
+wold_style_declaration := $(call cc-option, -Wold-style-declaration, "")
 CFLAGS += $(wmissing_parameter_type)
 CFLAGS += $(wold_style_declaration)
 CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
-CXXFLAGS += $(COMMON_CFLAGS)
+# Clang's C++ compiler doesn't support some of the flags its C compiler does.
+wmissing_parameter_type := $(call cxx-option, -Wmissing-parameter-type, "")
+wold_style_declaration := $(call cxx-option, -Wold-style-declaration, "")
+CXXFLAGS += $(wmissing_parameter_type)
+CXXFLAGS += $(wold_style_declaration)
 
 autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

