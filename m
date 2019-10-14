Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C558DD6A0F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388822AbfJNTYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:24:50 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:48116 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388245AbfJNTYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:24:49 -0400
Received: by mail-pg1-f201.google.com with SMTP id 186so13284762pgd.14
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 12:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/epx1jtpSVt829SAvdwTHPwrDv7PHVQvxA/5Eb/brYE=;
        b=Q+GyopSRyzNJiq+p1q1++mIASjq7d4BnNQiuWYmLgpwfOpsBE8NAaq7mZ2H5/PXpml
         Gc6+Bzxc8SVANaM5EqQdDsl2ZFgxbdbed8tR4oIm4/V7LsJtmqP1lxW8Jp+6QLNmGsK/
         C2uv6E8Eb9RhAA+k7tXktTkAyFtGocB94/av2VVHD/7UGTXnDm125mqCt1tVTKGQJMBz
         lQDtt8iiuXPyuJ+nDUIhYwo7y9b/mcNG0tec7ORVGzro/PzCJQqfhTC2aM6pEkMySXjE
         MjHJszK2I03AW/0bSjLtTukhog9+hkFXUGBf0L2EFsjJJm3+58PZv0WAKHdoYg35A13V
         y+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/epx1jtpSVt829SAvdwTHPwrDv7PHVQvxA/5Eb/brYE=;
        b=PRCZmYNRGDpj9f4MtQChGP5m8F3HPX2cHZ9P2pMGjwNMj/RmqSoXZ4yk0IexESOIXT
         p0ge1Q+NHESGfsEgUA//wWE0tV0SyFbuO8g0MWSuFcKbtdxQd0hdKfUBhjHMyEqGtBW+
         uPNS806KrgcZxDSBCEGC3LzHo4WSvNDYfcMmOoGwordXnrqIDONX39VnIabxIPPj/1fq
         ahSUQqG5O+nBjTtnVldvcDr5mGqub5AuX9ladBdEpO3FYVU3JPkOa6vBSOjmzvAgfTLC
         v1+Xda4ObQFEI6Nc9vjcUM1NokkdRlPnCezZDyZdHZRP5ZD2n1ijEpCXV+OIOU8MhnSW
         lPqQ==
X-Gm-Message-State: APjAAAVdBsK9p+vVfU22xlX3pYCqLU+DVC4JhrPVr4YaQP+1LWiGp2Nd
        6wWXD77gXhaosZEgPL4qRdeXt0RsgRK7+d+N9PuNlZ0erR/2YqtWrjhcSYgZrndqwzk3Dow2YS8
        ibkVXBUXTFqJNyEnN2cgrlarCCeRVOJ7byiXtTJr/BcPoXJ4XmWBGbA==
X-Google-Smtp-Source: APXvYqySkBLQF86YkEN1ryNEaPuCf/DFkeq2NO0VH8CXmxfyx21NvDZhwrvw2ozfZ3YRUKIuocNlX9uZdA==
X-Received: by 2002:a63:f904:: with SMTP id h4mr7072165pgi.80.1571081088929;
 Mon, 14 Oct 2019 12:24:48 -0700 (PDT)
Date:   Mon, 14 Oct 2019 12:24:31 -0700
In-Reply-To: <20191014192431.137719-1-morbo@google.com>
Message-Id: <20191014192431.137719-5-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191014192431.137719-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 4/4] Makefile: add "cxx-option" for C++ builds
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

