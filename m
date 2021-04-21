Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED7E36759B
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 01:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343678AbhDUXNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 19:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244043AbhDUXNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 19:13:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378D5C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 16:13:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c1-20020a5b0bc10000b02904e7c6399b20so17717471ybr.12
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 16:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=c4DrM/LT5tBLj73VSLr9DqeLdFK8eZgbdj+R4jNuKjY=;
        b=jgc2UocMpPlGp2kfA6ChPksCj+wwHmHp3iEYMnY8C2SnStnb5WCsrGpBydK2xKNSq7
         HEEmM80db+j2jxK7cyKx7ERmMrGsVehI8kUy0+UYzYmfAq7l65AJVCqfWGMvS6plxkfj
         w4QUl3ZKnxZ1GjlzF9ywldGXkT8f+Zmp95g0SUmOBaMGIzQUBpHQb1ijOkAvGHblQnzm
         PkejpsGcF4oqu+KyV/5UnQfIlb7H/sle26gjcFWzMMWoBrf/cKn6OQcSnGUZD0n6uEbL
         Kpg1Xeg+5Q+8aKLYBGZBY+APOI2z3QXTnLZDqFXfAAyDeMGCBXh00BsTYNcK6c4HJfC3
         lrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=c4DrM/LT5tBLj73VSLr9DqeLdFK8eZgbdj+R4jNuKjY=;
        b=te4jqXWlKG6L89bp4b8DfQTSBWueo9E6uk3safZ66MiK1qjGmdpDgaJVIgYJ9yjvUy
         wpCyqEU6Ao3aTPSuJ34+DBzDAbbgLY3BwmZWKLIbS/FD7ZPKXAzRSx08wY1PHBb3zb/K
         rZQDB6pjbSpeuQxzVkIWw9H9/Y29CIkdHu4Q512p8jj/lHLGoPuPk1HGOZvJnbxE3NP8
         FCgJhByU7CEbjkTXIYXQNL63tYkVqJq4u5ZrnkZTmaPa2V5hnM8MXcR++3XIwbyIzAkZ
         MRVgK8RSMb5o+oXqrkYuoDoKGedraGWGSj83zkFpHKPnp+MZjBvplLsq29ThqH7BcRLq
         +Zvw==
X-Gm-Message-State: AOAM530I9AiAS1lGqlDAfc2w6r7HT3nTpDxuWLxsm3MpikCNw0oybgjr
        U/5uL1SgxnUOLpcdsRCSQeM4GSa9OPN/Hg==
X-Google-Smtp-Source: ABdhPJyrLYl2A/eXtMDi+Rb8poyahq1CpFQZkXLGakYoV2bGpySxhRJrrSOzEhvdqWqfGtW1DMm6ef5OH/WVGQ==
X-Received: from mhmmm.sea.corp.google.com ([2620:15c:100:202:c919:a1bb:1eab:984c])
 (user=jacobhxu job=sendgmr) by 2002:a5b:448:: with SMTP id
 s8mr523404ybp.363.1619046790504; Wed, 21 Apr 2021 16:13:10 -0700 (PDT)
Date:   Wed, 21 Apr 2021 16:12:57 -0700
Message-Id: <20210421231258.2583654-1-jacobhxu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [kvm-unit-tests PATCH 1/2] x86: add movups/movupd sse testcases to emulator.c
From:   Jacob Xu <jacobhxu@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Jacob Xu <jacobhxu@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here we add movups/movupd tests corresponding to functionality
introduced in commit 29916968c486 ("kvm: Add emulation for movups/movupd").

Signed-off-by: Jacob Xu <jacobhxu@google.com>
---
 x86/emulator.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 6100b6d..ff3c2bf 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -664,30 +664,26 @@ static bool sseeq(sse_union *v1, sse_union *v2)
 
 static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
 {
-    sse_union v;
-
-    write_cr0(read_cr0() & ~6); /* EM, TS */
-    write_cr4(read_cr4() | 0x200); /* OSFXSR */
-    v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-    asm("movdqu %1, %0" : "=m"(*mem) : "x"(v.sse));
-    report(sseeq(&v, mem), "movdqu (read)");
-    mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
-    asm("movdqu %1, %0" : "=x"(v.sse) : "m"(*mem));
-    report(sseeq(mem, &v), "movdqu (write)");
-
-    v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-    asm("movaps %1, %0" : "=m"(*mem) : "x"(v.sse));
-    report(sseeq(mem, &v), "movaps (read)");
-    mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
-    asm("movaps %1, %0" : "=x"(v.sse) : "m"(*mem));
-    report(sseeq(&v, mem), "movaps (write)");
-
-    v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-    asm("movapd %1, %0" : "=m"(*mem) : "x"(v.sse));
-    report(sseeq(mem, &v), "movapd (read)");
-    mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
-    asm("movapd %1, %0" : "=x"(v.sse) : "m"(*mem));
-    report(sseeq(&v, mem), "movapd (write)");
+	sse_union v;
+
+	write_cr0(read_cr0() & ~6); /* EM, TS */
+	write_cr4(read_cr4() | 0x200); /* OSFXSR */
+
+#define TEST_RW_SSE(insn) do { \
+		v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4; \
+		asm(insn " %1, %0" : "=m"(*mem) : "x"(v.sse)); \
+		report(sseeq(&v, mem), insn " (read)"); \
+		mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8; \
+		asm(insn " %1, %0" : "=x"(v.sse) : "m"(*mem)); \
+		report(sseeq(&v, mem), insn " (write)"); \
+} while (0)
+
+	TEST_RW_SSE("movdqu");
+	TEST_RW_SSE("movaps");
+	TEST_RW_SSE("movapd");
+	TEST_RW_SSE("movups");
+	TEST_RW_SSE("movupd");
+#undef TEST_RW_SSE
 }
 
 static void test_mmx(uint64_t *mem)
-- 
2.31.1.368.gbe11c130af-goog

