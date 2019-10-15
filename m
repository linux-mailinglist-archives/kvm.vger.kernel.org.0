Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FD8D6C5B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfJOAEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:04:25 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45739 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfJOAEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:04:25 -0400
Received: by mail-pg1-f202.google.com with SMTP id v10so1309040pge.12
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 17:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Vc8OTlhGfb05aXJfWu7AtqIcU+fGPGUvUYZpoXjMLmQ=;
        b=gnFepy27jjZWBkP18M8PxGjLiFmpf5wJIQ8U00bcFwiSrLu+9cR9L/EWEDBSXkR9kc
         QHtpBLdiCTxZ0ojL7+tHEXf/veSjhOxW5fyb4e6S/vkpB6bPK3+sIHDf0GD8guFnzcOe
         K6aPPAXPMQMJ70tVMSbSg0GOjyL6ckzL4gmNaGcf3I9y56WUj5nTeIDv75mKKp7XciRQ
         6FhJpk39/SYMEKOSyDLbkCVDbryzXf4tVe7MY8ecnhNVLox2eYILe1krA820wZSzHluI
         UXbfSGx5pC5RTc7hbvDMOmgfLBIwkfcH9LxodyDyKucSq+be7FOBvRx+b2UxBnKPrlPQ
         9U2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Vc8OTlhGfb05aXJfWu7AtqIcU+fGPGUvUYZpoXjMLmQ=;
        b=abXE9ueyDK3Yj84+oYz5AndZj1nVd6qYPRKFHuLW320R6/dVpp0aY64r0ofDOXEZTz
         2xwRSWwesG72ypUBbQ45Ad9X0i0/SHHAwUp9cU41a/xcWy5yAuEmnGsJ+zWT6yCYuAKa
         AJcrI98hpcRj0AMIAJ12V6uX2J52eR73PtqKh/dRzn/EHQ83oE89f+GiKdVyIXegevMb
         oK6FRR8AM5JWbVAkyO5vUsIGgYYcw6EbLaPTT1qjDbfde2NLliFEZdyZo1HzaUkha0Vr
         aJkR78appOtTuosCNPQQVlq/eH8AlfCsXR38GApOD7/tPLNIib+eFJkBhJWeNoder6ZK
         qx2Q==
X-Gm-Message-State: APjAAAX2VL4UaQAexyhKkdmmWRO3KHX4W4H3R2ayn3Tn52FqXB7Ga4DO
        1i6u+Xrq1TKtV6Tug9+HudC68DDdcgIolyCzAVGMwzrT1gbeUUoAIWggTKc0ZTTrNdmNFTKXzCk
        F4mVQ488x00/OApSTVT56qQ905w5noFnPvCTIOe8mL1RrowDrnPX/rw==
X-Google-Smtp-Source: APXvYqy/XzmmgVzAFIjC5or4NHSwEPVCNIA3yEdwDaRF7JtGpcUZmJHi9Gk0n/vxbWNexxP5YUKQLmMBug==
X-Received: by 2002:a63:5448:: with SMTP id e8mr8296227pgm.10.1571097864201;
 Mon, 14 Oct 2019 17:04:24 -0700 (PDT)
Date:   Mon, 14 Oct 2019 17:04:10 -0700
In-Reply-To: <20191015000411.59740-1-morbo@google.com>
Message-Id: <20191015000411.59740-4-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191015000411.59740-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH v2 3/4] Makefile: use "-Werror" in cc-option
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        Bill Wendling <morbo@google.com>
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
 Makefile | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 32414dc..3ec0458 100644
--- a/Makefile
+++ b/Makefile
@@ -46,30 +46,33 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
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
 fnostack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
-wno_frame_address := $(call cc-option, -Wno-frame-address, "")
 fno_pic := $(call cc-option, -fno-pic, "")
 no_pie := $(call cc-option, -no-pie, "")
 COMMON_CFLAGS += $(fomit_frame_pointer)
 COMMON_CFLAGS += $(fno_stack_protector)
 COMMON_CFLAGS += $(fno_stack_protector_all)
-COMMON_CFLAGS += $(wno_frame_address)
 COMMON_CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
 COMMON_CFLAGS += $(fno_pic) $(no_pie)
 
+COMMON_CFLAGS += $(call cc-option, -Wno-frame-address, "")
+COMMON_CFLAGS += $(call cc-option, -Wclobbered, "")
+COMMON_CFLAGS += $(call cc-option, -Wunused-but-set-parameter, "")
+COMMON_CFLAGS += $(call cc-option, -Wmissing-parameter-type, "")
+COMMON_CFLAGS += $(call cc-option, -Wold-style-declaration, "")
+
 CFLAGS += $(COMMON_CFLAGS)
-CFLAGS += -Wmissing-parameter-type -Wold-style-declaration -Woverride-init
-CFLAGS += -Wmissing-prototypes -Wstrict-prototypes
+CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
 CXXFLAGS += $(COMMON_CFLAGS)
 
-- 
2.23.0.700.g56cf767bdb-goog

