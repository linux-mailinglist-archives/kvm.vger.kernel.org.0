Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D542D6C5C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfJOAE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:04:28 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45740 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfJOAE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:04:28 -0400
Received: by mail-pg1-f202.google.com with SMTP id v10so1309171pge.12
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 17:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/epx1jtpSVt829SAvdwTHPwrDv7PHVQvxA/5Eb/brYE=;
        b=P84vo+oMgO+hC058P25Ph2dxwexJhp8/oZi+YFCAsZ+pC7EJ6pSbSW45q56I+rVJ/z
         4E8dMozFwbmNxlp4nkJSllfEGfAcKE1azrcH5Z+YACj+s+LsHdRpuVYpDx6LnET21CWl
         GlIdpHJ0k5CLL0IUK/spw6ZG6TBolSJnbXYQrnRJtilIWWbTa/TJ+e0R8/Tc5nwBfbT/
         0bc+2uHvinWSLynuwTqCx8goX/SWb7az1mZZh5Xz6KO4CdxxtlXvAzqSR70LGmKgE7ok
         jmz+Y6XBmHbVtYogPljh5f8UTsHq7yN8OUu3tKIyqRhWA/o0yZx5eMnTZRW1WGGkFivZ
         AhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/epx1jtpSVt829SAvdwTHPwrDv7PHVQvxA/5Eb/brYE=;
        b=EW+QBlK5ZsxDT+kZZX3OeZNuzMhR/Fw9WFLUee3NoMNP1zevOlOeTG26jdgmxW4BzE
         6XRBZXhMSGKQk7yQU2A73pX9mtPrG0ghailqiF2A+EPzWpg/WReKRUFCc1b+0FMYJz+q
         AvUHV2kYRF25TdS7XPa/059txBNjRreW0qN+mgueYtnF2hT2cIPuJVbVDDetExQ6ye/I
         xtbgig+nGtZcOPXGbQUQB6sRs/1YGiIQEgYiiI+ORYCREPTAHr/WCXQyJb2QriM1n8/y
         Y/aKO5e5vCuK57+XEaL2iEZJFfY53E9x0nrm3gvBihMIyXItLE2al+ibmKOefDBU5WYS
         SXpg==
X-Gm-Message-State: APjAAAU2ks0mly/etpdPS/MhsgRYiXgCxz0w5noBxA0A7hqCnrBsB+pK
        NcxjKqsJWJB4RQqjkwVaFsaF/kyA1hQqapdeJRpSv3BZrkLseScEcCnFp4XWX3GP5DomLIr3bEk
        8NowFKbWHSjiSLimCTQ7MmsC/3fuMcoIfW+T2JGNR4e5c0vFb/Ztt6A==
X-Google-Smtp-Source: APXvYqx/z8uL0rx1LaCc9nO1S3trt14XlurqiDKCODuJhO9VP+wu3zQX+ICHfI+U4XvRpt6RIZ6lfxfEbw==
X-Received: by 2002:a63:10d:: with SMTP id 13mr36164727pgb.173.1571097867484;
 Mon, 14 Oct 2019 17:04:27 -0700 (PDT)
Date:   Mon, 14 Oct 2019 17:04:11 -0700
In-Reply-To: <20191015000411.59740-1-morbo@google.com>
Message-Id: <20191015000411.59740-5-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191015000411.59740-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH v2 4/4] Makefile: add "cxx-option" for C++ builds
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
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
 Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 3ec0458..b9ae791 100644
--- a/Makefile
+++ b/Makefile
@@ -48,6 +48,8 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
 
 cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
+cxx-option = $(shell if $(CXX) -Werror $(1) -S -o /dev/null -xc++ /dev/null \
+              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
 
 COMMON_CFLAGS += -g $(autodepend-flags)
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
@@ -68,13 +70,15 @@ COMMON_CFLAGS += $(fno_pic) $(no_pie)
 COMMON_CFLAGS += $(call cc-option, -Wno-frame-address, "")
 COMMON_CFLAGS += $(call cc-option, -Wclobbered, "")
 COMMON_CFLAGS += $(call cc-option, -Wunused-but-set-parameter, "")
-COMMON_CFLAGS += $(call cc-option, -Wmissing-parameter-type, "")
-COMMON_CFLAGS += $(call cc-option, -Wold-style-declaration, "")
 
 CFLAGS += $(COMMON_CFLAGS)
+CFLAGS += $(call cc-option, -Wmissing-parameter-type, "")
+CFLAGS += $(call cc-option, -Wold-style-declaration, "")
 CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
 CXXFLAGS += $(COMMON_CFLAGS)
+CXXFLAGS += $(call cxx-option, -Wmissing-parameter-type, "")
+CXXFLAGS += $(call cxx-option, -Wold-style-declaration, "")
 
 autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
 
-- 
2.23.0.700.g56cf767bdb-goog

