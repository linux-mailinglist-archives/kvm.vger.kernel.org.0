Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE7DCF2401
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 02:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfKGBJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 20:09:02 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:32996 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728265AbfKGBJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 20:09:01 -0500
Received: by mail-pg1-f202.google.com with SMTP id y22so445107pgc.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 17:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iswOSk/cZ98lnJ7BbrIe/h5JrJo81nLP88Lj3jwN4P0=;
        b=I+1tX8Kl7CXMH+Hz830Y99VMAsMZ/b0El9mFJo3kNwnTRCRKWTpejQKLJz20nv/OFe
         aY/7fDUshnB/CXOrTmjqlJJqueTT6+ZQmqi5CsZu4JlI2rFwqnDSRTiQGTRX6j3WQIQK
         d+BR6uV3C9YPNk1NrZ2wKNkvfQDdwKnBWaCtusdaUgBFiFOpdjgQCT1TGxEm9M+pgaIS
         GM9Z3lWasxEWBCg/YvWkip79fADKf4C+LlXqw+6ZqD/NXfu0vCmMKJkjL9zfaKc1Zjl/
         uTdG7WNYvP3umgQGATBdMPUgQv3p7SYEZHJ6O3HCXYc50K97nd1O1PDB5VT9O38GquQK
         WMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iswOSk/cZ98lnJ7BbrIe/h5JrJo81nLP88Lj3jwN4P0=;
        b=m5gmn709sN45028aH/oRVZnxUYMDm1m4E8Wx78YomH//KbfMWsWPfinLKRmDfxIld+
         9UxK2Noaqzflr9dY3Ph4XEQDssrgx7N3IiEIxbfxjHRNKY4NE5/zo4NxpXHyX2ee6QhQ
         aQm0Zq3vuGESzXaA986XqDBe44xXVCaLp06zBKdkPjtHv9uaqMVJ8slpCKaf9Eec8Rl1
         UY3laZpuVBn1aD03VzFn14SMxWEbfdNyNkACxcnX1Fu+AGSdalUFSzdXBlFpR0+2wuAO
         fdj1wDJOyWZ4ev6eFO6uLPPQAQ7doQPqKqmOVqG9WSO8uJK+/E1e1fn1ETIrf2aj/ohq
         Zx5Q==
X-Gm-Message-State: APjAAAVuLqIySOU6l34gdddiDI+1xsgwDpA7FkS0FQPA59cXnAZiVJhM
        cJDDi3T4EuB+j/o1MifLpakwPHUZNd93Z9ZvDBssEPLluAZIsirn4YXJG8DVxEBf8V+UP2bsMJs
        lG742J0xLG7Ft5YYxd41JrS1PqIWDkB3A79ssl46tYIx2AAhlkmCwdw==
X-Google-Smtp-Source: APXvYqy3gJ0/ynp+CqtY1t9JZ1HQVt0j6B0OPz6rLFZltcjSIj+bbBu1JCmx2qwRT0x92C4m93R1Yf342w==
X-Received: by 2002:a63:1323:: with SMTP id i35mr1039144pgl.450.1573088939030;
 Wed, 06 Nov 2019 17:08:59 -0800 (PST)
Date:   Wed,  6 Nov 2019 17:08:43 -0800
In-Reply-To: <20191107010844.101059-1-morbo@google.com>
Message-Id: <20191107010844.101059-2-morbo@google.com>
Mime-Version: 1.0
References: <20191107010844.101059-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH 1/2] Makefile: use "-Werror" in cc-option
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "cc-option" macro should use "-Werror" to determine if a flag is
supported. Otherwise the test may not return a nonzero result. Also
conditionalize some of the warning flags which aren't supported by
clang.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 Makefile | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 32414dc..4c716da 100644
--- a/Makefile
+++ b/Makefile
@@ -46,13 +46,13 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
 # cc-option
 # Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
 
-cc-option = $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null \
+cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
 
 COMMON_CFLAGS += -g $(autodepend-flags)
-COMMON_CFLAGS += -Wall -Wwrite-strings -Wclobbered -Wempty-body -Wuninitialized
-COMMON_CFLAGS += -Wignored-qualifiers -Wunused-but-set-parameter
-COMMON_CFLAGS += -Werror
+COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
+COMMON_CFLAGS += -Wignored-qualifiers -Werror
+
 frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
 fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
 fnostack_protector := $(call cc-option, -fno-stack-protector, "")
@@ -60,16 +60,24 @@ fnostack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
 wno_frame_address := $(call cc-option, -Wno-frame-address, "")
 fno_pic := $(call cc-option, -fno-pic, "")
 no_pie := $(call cc-option, -no-pie, "")
+wclobbered := $(call cc-option, -Wclobbered, "")
+wunused_but_set_parameter := $(call cc-option, -Wunused-but-set-parameter, "")
+wmissing_parameter_type := $(call cc-option, -Wmissing-parameter-type, "")
+wold_style_declaration := $(call cc-option, -Wold-style-declaration, "")
+
 COMMON_CFLAGS += $(fomit_frame_pointer)
 COMMON_CFLAGS += $(fno_stack_protector)
 COMMON_CFLAGS += $(fno_stack_protector_all)
 COMMON_CFLAGS += $(wno_frame_address)
 COMMON_CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
 COMMON_CFLAGS += $(fno_pic) $(no_pie)
+COMMON_CFLAGS += $(wclobbered)
+COMMON_CFLAGS += $(wunused_but_set_parameter)
 
 CFLAGS += $(COMMON_CFLAGS)
-CFLAGS += -Wmissing-parameter-type -Wold-style-declaration -Woverride-init
-CFLAGS += -Wmissing-prototypes -Wstrict-prototypes
+CFLAGS += $(wmissing_parameter_type)
+CFLAGS += $(wold_style_declaration)
+CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
 CXXFLAGS += $(COMMON_CFLAGS)
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

