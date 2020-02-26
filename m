Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9A717093F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 21:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgBZUNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 15:13:14 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:50429 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgBZUNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 15:13:14 -0500
Received: by mail-pg1-f201.google.com with SMTP id 22so271659pgw.17
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 12:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OdYlpv2ga298KF/gq7X6DdauhYrmwjzn6r6GXhMlTFY=;
        b=acW9weaZrIae64ShTa5DEXYIEHCSozEW83xlO15vq6HZz7lT896h58NTTRaLqWoC7s
         k1bMAAgi8WvA1wFKjId1/+Ll5xKd9WQkT+6y6HK9qnsgbhszi/ISgG1anfIw+XHwrx6P
         g8fmZ9reIo+9h5uRKerCgiySOvBnElWo4BdxajxOKjCiICGesrN0Zz905P9xZSyzUJBZ
         xWEjALDxGkib9/A2tuisAFDmIraTKHsbABUh2zZ+eFtVFY7fzETic0Gc4Yf5SIYrWtv1
         UaIMXdKXvD00EYoWuDMHKcF8sNu7JSTa7TW1HTZMLnUBJRA6GPBe+t0J7jvhFpcz00rS
         GsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OdYlpv2ga298KF/gq7X6DdauhYrmwjzn6r6GXhMlTFY=;
        b=Pg+IOjc+7UBzgQAp2PmkfdbEkNPk1GtDsOm+55OBFMG627xFJF1uBs7Neis+Uly/5K
         IFYwMTCby6YVvqoinMt96YGIgDynkMAPLiWmY43uxMIKIdvJeZpdjnzZ/5+NvzlBmJxW
         tjCDYvD8nFviLuV1sdyQW2r8Afae+GxtlNfLTx0umKEXIpExC3UIAxWn6o1C34vt9+WW
         CUnaC2GLp6lzWB/rckuYfOKKoIktqtk6pEQ0FKddJaXmFIdpiW3gYbVLr8fGVXF3HMmG
         P/BJwkl8i3uL7QPcy6Qp1nITGtYzFe+Uq2isJOiAN9VXjJM8j6h34mU1LxwLrm7x034H
         WxZA==
X-Gm-Message-State: APjAAAWZU92JmnDHZWd3Y6FszgRvKXx82trETVgKm2FAdo1DPJ5EGEck
        qSMye9hf9tJdIMM8NteaINdNkQT8PrLgU6ZnIbH6NAb90XecpF0nr2w7HEKi01o61VjrBqUtefw
        2eF+T6gX00VI3wvRKOSG/8TcM3rrH4Adny4KCGC4LiuOWKz4TAGstbQ==
X-Google-Smtp-Source: APXvYqzsj4/uYcHspUiV1VEsrYEp8PRW3TP7VSa28A4OliGP9du6wxTK7mxr1vR1v4V8gze6uohOVT9FKw==
X-Received: by 2002:a63:360a:: with SMTP id d10mr510305pga.366.1582747992896;
 Wed, 26 Feb 2020 12:13:12 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:12:40 -0800
In-Reply-To: <20200226201243.86988-1-morbo@google.com>
Message-Id: <20200226201243.86988-5-morbo@google.com>
Mime-Version: 1.0
References: <20200226094433.210968-1-morbo@google.com> <20200226201243.86988-1-morbo@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [kvm-unit-tests PATCH v3 4/7] svm: change operand to output-only for
 matching constraint
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, oupton@google.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to GNU extended asm documentation, "the two operands [of
matching constraints] must include one input-only operand and one
output-only operand." So remove the read/write modifier from the output
constraint.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index aa3d995..ae85194 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -288,8 +288,8 @@ static void test_run(struct test *test, struct vmcb *vmcb)
             "cli \n\t"
             "stgi"
             : // inputs clobbered by the guest:
-	      "+D" (the_test),            // first argument register
-	      "+b" (the_vmcb)             // callee save register!
+	      "=D" (the_test),            // first argument register
+	      "=b" (the_vmcb)             // callee save register!
             : [test] "0" (the_test),
 	      [vmcb_phys] "1"(the_vmcb),
 	      [PREPARE_GIF_CLEAR] "i" (offsetof(struct test, prepare_gif_clear))
-- 
2.25.1.481.gfbce0eb801-goog

