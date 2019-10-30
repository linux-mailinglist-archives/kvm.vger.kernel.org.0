Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F20EA51A
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 22:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfJ3VEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 17:04:37 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:53170 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfJ3VEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 17:04:37 -0400
Received: by mail-pl1-f202.google.com with SMTP id g4so1179891plj.19
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 14:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BsEtptDhLoQ7dpINugZ/k0hkp7TfbimScSD2i2zd5S0=;
        b=ThZ0KL4N1ZvDkR86Lo1JPNSN5tVDlBU/YzyMTKCxX76ux/C7VuRlsn44X2VIJCLiPv
         aBS7Gkw+bxZrTM3spSqQGNoz7+WCEhJq513miltZKNg7XXNG7PEInYxsCs5YjFdnG0Wr
         QqG0BV6+G0x/rFhSa8bP87NyrQ3vOK92dsvnlv17ColLMJbvFcsxZDrQCehstY0w8h1q
         jYdgxnBdSEDcoUeUrhJo8RjsJmOhRUVx4W+rfqfe7wpf1cAgF/xMhPczQfEo0oLPXW04
         RftD2AsekxDkQ682nqy1IMx2I/FLsCfboE+NAwb7QVvYSidz37XcBX9t77nWRGr4NOHK
         QsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BsEtptDhLoQ7dpINugZ/k0hkp7TfbimScSD2i2zd5S0=;
        b=ZdgF068p+EmELUMvsZfZozqnxgjSbjORw3Jx8VmXHIIle5HMCKHS8R+/246Ygbqe99
         z7OQeKYkiY/rfIJnesl9wOv3j68hQFPILd1DmMJxvF0ErAaWMIRhgr0W5/dHaFO0Ybp3
         QQMVhquHWR2/3ljYxR/mGubpkx8pmBACGVdRqKFSYbJ7CoLrMIu2jtPuxGYs16vaiYGz
         Om4hAEr8Oz6arkHzRhPcfhtnjvyKx3wiACOFF8Q+A2dLskO0OkFuOdZjkBLEDxcStIyS
         xXysOH/z+nx1OezgwvFH5R5utFjom4yjWAcMnfWKvlEMfRtEw44WWmBaR7B3NIjm1OWH
         L2KA==
X-Gm-Message-State: APjAAAWIvUEegIVVWN5+fhdkBZgkzX/dOUU6g+OcvuwBkgixaYkejbNv
        TMNcPdeif6SBTvOV53TBEKx7eD+7EX2FlBEWwsgfjXiJtBpgeenbArebdvjI1OfPtyaO/i1lpCf
        JnLp74E9Elnf3IK4lRRmp4TVsqmyfxTyaFnDSMxDvlsCe3KRSN+q9pg==
X-Google-Smtp-Source: APXvYqzG0Ax9LnXGFBRKa01rGs0a++gYZvn8FF9ElZIdeQqZXwXhzEZfWlvLe5iKXZk+KP8lwq1JufaNow==
X-Received: by 2002:a63:eb52:: with SMTP id b18mr1516544pgk.205.1572469474317;
 Wed, 30 Oct 2019 14:04:34 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:04:16 -0700
In-Reply-To: <20191030210419.213407-1-morbo@google.com>
Message-Id: <20191030210419.213407-4-morbo@google.com>
Mime-Version: 1.0
References: <20191015000411.59740-1-morbo@google.com> <20191030210419.213407-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v3 3/6] Makefile: use "-Werror" in cc-option
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
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
 Makefile | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 32414dc..6201c45 100644
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
@@ -60,16 +60,20 @@ fnostack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
 wno_frame_address := $(call cc-option, -Wno-frame-address, "")
 fno_pic := $(call cc-option, -fno-pic, "")
 no_pie := $(call cc-option, -no-pie, "")
+wclobbered := $(call cc-option, -Wclobbered, "")
+wunused_but_set_parameter := $(call cc-option, -Wunused-but-set-parameter, "")
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
+CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
 CXXFLAGS += $(COMMON_CFLAGS)
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

