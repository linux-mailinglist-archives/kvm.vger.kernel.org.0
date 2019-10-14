Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D984FD6A0E
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388810AbfJNTYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:24:47 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:55182 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388752AbfJNTYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:24:46 -0400
Received: by mail-pg1-f201.google.com with SMTP id b26so449142pgn.21
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 12:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Vc8OTlhGfb05aXJfWu7AtqIcU+fGPGUvUYZpoXjMLmQ=;
        b=WAhc65CrQxShRPul30U/irwJc3Xv36N36CE0d5N4KpETUO4S1OFMwPgu/Yjr8gqPgX
         LGZ7BqpQ/HYhHbUW9Ws+i+wn6jZXLeZOGqdLL6HPGGgqW2bWGtvZxE7VD4pda2X90OTA
         8VNGhH0xV/YA1clyM2jQLx9KU69Bbp+0Tjj0Imdbwc0ftn8iPbBk3MJNSvXqKeVK+XFn
         6m1IJjIsMX27RLoEK2KBkWOq2T36IwPE4mqzrlhmXOMKLV2HGFbuG/nvjX6rdefSpABw
         5LgdVKmzJ+S/6roI/8EjLg2odLZbczFZ6NeOw0XoLMBojHbWpEZyYVcgI+HAJ9amS6q7
         sWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Vc8OTlhGfb05aXJfWu7AtqIcU+fGPGUvUYZpoXjMLmQ=;
        b=GFXyEbX1FCRPqQLU6ZnUGDWkO1seVITEjfzTVaRTFlmn73IMH8XhEY7wBumWEYZAoP
         aXkaFYF1pVPJngr9Os7sqa8lMurhMPY/2HjSQ4m3kqqVZocelswwoKN51UroGxw/UNGI
         fJ65PcZBeqatpJTQCv0VqV7FHZY3rZAvN/lBpwayGZG3VkC4q0BiKWvgPeVVo+udApyl
         eBnRIHne+UPN2R29afUK8R6DEaDKIpPXG6X1hRIQjYIxgV72deY7hjBmQ34llFYhDsW6
         BQRTL2X9ak/uPS/ie8XW10/D5WkCbVAcIJypqcaZChieNj7cbiHGs3+hayyqKRPqel3O
         vakw==
X-Gm-Message-State: APjAAAWddhb5duWLAYjPfDnCqLBbJL60u2Sd4m544NZTrfPLiDf8zKo8
        JSoi9ovvACU6KLIczFrOf1zGS6MYpjMCLKcibAEA+OOJ8JRZSS3tvT6Cl9JwcjvRKyrlDGHPvsO
        ojD4/FaPVeAbuy7UfwRN9e6wMAlg9dhq1lnFBFsShwhwyjKRQa8Xv8g==
X-Google-Smtp-Source: APXvYqxmquaVcN6XavAqx3SmG7R4thfdgwuuEYR3oURjqm0+Glwwod+M/kvJvj/1vCXZekq5iSjw/bHPEw==
X-Received: by 2002:a63:fb52:: with SMTP id w18mr13708493pgj.251.1571081085810;
 Mon, 14 Oct 2019 12:24:45 -0700 (PDT)
Date:   Mon, 14 Oct 2019 12:24:30 -0700
In-Reply-To: <20191014192431.137719-1-morbo@google.com>
Message-Id: <20191014192431.137719-4-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191014192431.137719-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 3/4] Makefile: use "-Werror" in cc-option
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

