Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF0D42E60F
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhJOBUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbhJOBTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:19:49 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0EFC061793;
        Thu, 14 Oct 2021 18:16:38 -0700 (PDT)
Message-ID: <20211015011539.896573039@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=qXPN8X8kmxRIkmpqRqhxyp/xhryH6JXN4VJULuCHRLE=;
        b=mr/S+AxYZDBrtj0qvbRAefEmbCaT4Tx1tvTEq2ZQyydXwFUd4ORLmKxyKs5G+wX50G4Lje
        qIrWDT18h+SRkNAT2/7hfo3/4JAgt5MjiHZ2z0onDxl+YuFhjFWdWXKJLYMfX6wbCyDq3n
        ZrzJE4UY5AkBkeYJgfJs1YSf9fa9mqth4+lNhYMmZosOzgN/jzrnvUp/n5p1wo4KynLXh9
        f7e86ltBsopYjMDHlklKkrNkaCGcxjxS+m70F9HbAIULYoLfPEvTocLPaLDg26PpLr7hKI
        /T0BKAdgnvqJJwzkbN0KFjJJ43MXI+quNkJywXejitR0uOh2wPfnFcuPm07gJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=qXPN8X8kmxRIkmpqRqhxyp/xhryH6JXN4VJULuCHRLE=;
        b=tu43GJXm/jdi/JGF+7Ss/F8W74AY7cHLI4theZomCOkKne1d8B0WG2ukdNrWmSj8yg9y3T
        eq1dEvFzjlDEl+AQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 27/30] x86/sev: Include fpu/xcr.h
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:36 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include the header which only provides the XCR accessors. That's all what
is needed here.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: s/XRC/XCR/ - Xiaoyao Li
---
 arch/x86/kernel/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a6895e440bc3..50c773c3384c 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -23,7 +23,7 @@
 #include <asm/stacktrace.h>
 #include <asm/sev.h>
 #include <asm/insn-eval.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/xcr.h>
 #include <asm/processor.h>
 #include <asm/realmode.h>
 #include <asm/traps.h>

