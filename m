Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30F7EA51B
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 22:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfJ3VEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 17:04:38 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:48512 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbfJ3VEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 17:04:38 -0400
Received: by mail-qk1-f202.google.com with SMTP id z64so3423923qkc.15
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 14:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tP5VYyMFPyBsAqSM/e1ZfMjzucbp+c4GqFLPI5mcuDg=;
        b=AW992fJCZXBx956qeE2JdFQG1Vbfq3pWYaq+IPi3Lpg3GnG1Y7pF//+kjV7+NX+5wv
         t8eq4dBnSo4W2WGY3SOhICBGhR7E+gshJWwuB/qCYYIUvY+9m6yhACdODJLtIRlkwQQw
         oobIqJVsKs/8ujsx15RmPXd2gZEan2J0MgpsBs9bZUVFTyiUpfB9LYdk9gLm2j6B2ZBl
         zhbXCl6chkpJ4xc7DjivyJBd29wUk7sRL5mb4wxILJlnGWui8eC2ZzzIlFpwgGC0apmU
         bWE7JPxHbaziTsgmGlYASzh+4xdx6wWMdMQhFGYC28TvaZWakSaL05izMVLe+8MWymvO
         aK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tP5VYyMFPyBsAqSM/e1ZfMjzucbp+c4GqFLPI5mcuDg=;
        b=UfTNGGV5UKkoWvSS2gk0TMc424yZuiSW3dBaujz1K14Ld2K2weetZvFx6Uxw0Wxrt/
         XK2wupNjqzshJs0FflCKW5i5DFqQQRrcYZ5HGv08dwhJ5n0ERmIdfT1VzE6flsYlNbeo
         nRin1zOfkR5MrXKrW566DyC32jw+/wJsgh4kvdiGO6oYK0UHsiSNcattkV7203RxxZpQ
         PUSvhrKcO3TBZ5x8ayzcA55LaWdK0Rd5QblBAOY2y2MGxSv3iQjath9DLeilHvkyrgpX
         fNl7WLUBLUTwdsXBomK/BLcZiCGilaD7Jl054KNXdkzAqrVo6OYqt/7I7Up8mq9NaRHO
         siuA==
X-Gm-Message-State: APjAAAWlZhzMIyLLY120FywPqa1wqcpR3xy5L2lDOUdJ2zGhjx+3s1/N
        OkOYttfi+yIysiRp0hcUu60lKApt3mOnKKcPKiPusZpXGvTIOT+tQa+q4BYmGlQ5AaQwH/+y/aP
        pw9hmVB94LRXVDUXJvH5+OgZO+Wo1O//lQP/Mt/Wcdu51HsnYJGqgpQ==
X-Google-Smtp-Source: APXvYqyUJSCQqD3c0drhPQWOD2pFYe3h6vIeLr8FWx5hYto5aXXcfgL5N3jXcc6KZgh9Rv4dEHzZpd9GuQ==
X-Received: by 2002:a37:4ccb:: with SMTP id z194mr2044245qka.128.1572469476958;
 Wed, 30 Oct 2019 14:04:36 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:04:17 -0700
In-Reply-To: <20191030210419.213407-1-morbo@google.com>
Message-Id: <20191030210419.213407-5-morbo@google.com>
Mime-Version: 1.0
References: <20191015000411.59740-1-morbo@google.com> <20191030210419.213407-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v3 4/6] Makefile: add "cxx-option" for C++ builds
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The C++ compiler may not support all of the same flags as the C
compiler. Add a separate test for these flags.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 Makefile | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6201c45..9cb47e6 100644
--- a/Makefile
+++ b/Makefile
@@ -48,6 +48,8 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
 
 cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
+cxx-option = $(shell if $(CXX) -Werror $(1) -S -o /dev/null -xc++ /dev/null \
+              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
 
 COMMON_CFLAGS += -g $(autodepend-flags)
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
@@ -73,9 +75,19 @@ COMMON_CFLAGS += $(wclobbered)
 COMMON_CFLAGS += $(wunused_but_set_parameter)
 
 CFLAGS += $(COMMON_CFLAGS)
+CXXFLAGS += $(COMMON_CFLAGS)
+
+wmissing_parameter_type := $(call cc-option, -Wmissing-parameter-type, "")
+wold_style_declaration := $(call cc-option, -Wold-style-declaration, "")
+CFLAGS += $(wmissing_parameter_type)
+CFLAGS += $(wold_style_declaration)
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

