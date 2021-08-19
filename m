Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4915E3F231C
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhHSWb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhHSWb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:31:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67622C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:30:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b127-20020a25e485000000b005943f1efa05so8005783ybh.15
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RG48wLZpmkVWmFAgeiCFjLWl4QHYtJvNQmZHx9cng3U=;
        b=bvgbvQThIF5mhwg8O6C4LPKBSTcK1WwlDB7Op+iy/eMr24Q1seNwGSxz92114HfL6O
         oOOx+i620GP7M//Obl63+vgbVhy44b/ePR+yE5Eomu6spdt7OI2+HvMMAQn5PVEtIfI3
         NBfJ5xF004GBZlctcVwlhg+gOSDVkI+7qNQY+5o8lk36AGmcr7EdAY5aKX19GKtq0tmK
         f0i5p05DI72KB5EUIS50KUr9fYHhWkgHujch3QF6L77IWzlgTDxXCv3oXwxSa1LI7hHd
         C6n9L4hohQpvUGBKZHf7J02q+MbRO14dB2EcNRo8NWYFRSZuTPYiVpF3Mz9gqYiWkVFk
         eL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RG48wLZpmkVWmFAgeiCFjLWl4QHYtJvNQmZHx9cng3U=;
        b=YQuE7NLmc2+z3a8ydiuIvC6XqqbUtP4s61m4TkxF3awYFRub1bBjp//aIxV/g+YWX8
         AJ/xq9++NI6/P909Q2RWAHrb6gokJzIFDxYsLQX246nTzJMCzJj4GQirINjEWqZHaMdW
         RTDyayzoI44v87Cb+nVDAFah+EBLdbSsq1u+s5GWoNGQgo8rBJVdcbkVGNLHxtRJ+6xb
         KdH5ew08S8Zq1W7DbnRh4aKH0rCtR0oQaX0RZq1AK2YjEOSZAiKwTJ6wP7DMuiuYenI1
         avLPtdETYT2BQYVDx6hoxg/SKPbZIIHTcjdgObKYpHGBfv0q5tJ8bf3pyGOCkie+n46K
         eZfQ==
X-Gm-Message-State: AOAM531VgHuS9pBmWQGSOr+W8ftROIp6C4YgbQuy64pqRFfOJkC7KrEi
        Rg83IRbRy/ytNQlYrtq9DDzh143M4wNJ3gtfcApmM7CfN5oth1z+UbQUqJeTG5RkrqiccHbKt45
        PlQ1mDCwJA9bTLES0XTlWF5BYvBOlZa05q8DZNpyP8xPK85nPANV4w5RD/ayVyNY=
X-Google-Smtp-Source: ABdhPJyg9s8mUNZZ0GfIbfiWuHKUwe0pyiTm6hz2LEySEEcSL/wFlv76Tn768XQjJM0eO/NiDzye69oQ8atmQQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:bd7:: with SMTP id
 206mr4890819ybl.240.1629412250581; Thu, 19 Aug 2021 15:30:50 -0700 (PDT)
Date:   Thu, 19 Aug 2021 15:30:47 -0700
Message-Id: <20210819223047.2813268-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [kvm-unit-tests PATCH] arm64: Link with -z notext
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        drjones@redhat.com
Cc:     oupton@google.com, jacobhxu@google.com, jingzhangos@google.com,
        pshier@google.com, rananta@google.com, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Building the tests on arm64 fails when using LLD (the LLVM linker):

  ld.lld: error: can't create dynamic relocation R_AARCH64_ABS64 against
  local symbol in readonly segment; recompile object files with -fPIC or
  pass '-Wl,-z,notext' to allow text relocations in the output
  >>> defined in lib/libcflat.a(processor.o)
  >>> referenced by processor.c
  >>>               processor.o:(vector_names) in archive lib/libcflat.a

The reason is that LLD defaults to errors for text relocations. The GNU
LD defaults to let it go. In fact, the same error can be reproduced when
using GNU LD with the '-z text' arg (to error on text relocations):

  aarch64-linux-gnu-ld: read-only segment has dynamic relocations

Fix this link error by adding `-z notext` into the arm64 linker flags.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/Makefile.arm64 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index dbc7524..e8a38d7 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -7,6 +7,7 @@ bits = 64
 ldarch = elf64-littleaarch64
 
 arch_LDFLAGS = -pie -n
+arch_LDFLAGS += -z notext
 CFLAGS += -mstrict-align
 
 mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
-- 
2.33.0.rc2.250.ged5fa647cd-goog

