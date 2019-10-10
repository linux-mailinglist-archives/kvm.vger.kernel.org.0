Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115EBD3078
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 20:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfJJSfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 14:35:48 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:56521 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfJJSfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 14:35:48 -0400
Received: by mail-pf1-f202.google.com with SMTP id b17so5375772pfo.23
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 11:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Vc8OTlhGfb05aXJfWu7AtqIcU+fGPGUvUYZpoXjMLmQ=;
        b=EwTYoOE9eywTE/DXHv5xVrGexu/+p1lMCXoJs7rJcUGKp3k5A1Eh22/a94Dy1XOhA8
         g9UlQ2q9qeckAReRDj2fxKEIPpgt7Gev+8CvyxkjDDBSWW8/z+va0WLxzn9grp/jsvXV
         FLM3DsABT95CYMNH6UdADm7ET3q60CQrZhGUzecopP2obbpOnzeErjFryhNVeyu20WN5
         CPq5bEXlLyirAqL1wyBSnnHAbmbfwiqnOZbTQyiyZhcB/v6V+tJ79m1R7szTWElW/bHN
         uCyVrZ95S1cpTCCG7Vguwkn2LBauSogqMjAU3Nx5eXj5TkXASkD389y95BDid/tS4hw+
         Cr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Vc8OTlhGfb05aXJfWu7AtqIcU+fGPGUvUYZpoXjMLmQ=;
        b=I2SePKShn9PKlb2vKGrK80dKOHfD2HQaMO/qKkoWQrD7JyIyNH9Q/dclzQx1oXiXzP
         LPs2mZWh52j5wcMYvEKn9fZBNZWGWE5iUADV0uxG3m5BxJnlJPYpXvsAd2YAk3HNIbTZ
         td6NySiLUA4Tj8muMWmycXIH1ZOmCl6HDymrDiZkkMstpbtJLCuF3kTXBWpFF/pBLbnd
         uPSW1ihjn0QoWE3orJt8gPsvf1n3Qhl+z1KiufRP47OqNFaqUM5NQDtXnG0m6Kryu36j
         pi+YPfdSVQdCZo06v5TxFVVIZ2IsgA96/RhR1ofGLf3JW2xhIf5wRN/4Rybjk84Fgffk
         /0tw==
X-Gm-Message-State: APjAAAURTMke+2ah4wOFTN5yg/MJf1uYhnQO6iXxf+MDVUWGtYnNLd5r
        Svmx1v1ujFtsFHUmeFWoHi5y7vT3LctaXr/lNB5uvdDHf0SLuOXorkiZ2YGQUUvw7ND8jsdd1+o
        +6+qLzJjPvSi6f2KdPj9UhXovbgdnnYdR2o7/qiSTNnhuOw9KXDKvpA==
X-Google-Smtp-Source: APXvYqzntkMflsMnpnnQWNiQ/DP9MuJvwejmuBUH65YaBDTdcBsjYBjZsscAJG2slifaDddwTSesZo9EHw==
X-Received: by 2002:a63:f418:: with SMTP id g24mr12763866pgi.15.1570732547118;
 Thu, 10 Oct 2019 11:35:47 -0700 (PDT)
Date:   Thu, 10 Oct 2019 11:35:06 -0700
In-Reply-To: <20191010183506.129921-1-morbo@google.com>
Message-Id: <20191010183506.129921-4-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 3/3] Makefile: use "-Werror" in cc-option
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

