Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4CCF16F8B1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 08:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgBZHpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 02:45:01 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:49759 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgBZHpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 02:45:01 -0500
Received: by mail-pf1-f202.google.com with SMTP id z17so1494518pfq.16
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 23:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E11peBCBeUkU5QqrM9F+hDGSoXytqmeuQIcQ91AaOag=;
        b=PXhC3lkx7kzJcBy6Q3o9LjR3kjP+Qb7O7T1Pjc6CF7JJl8lurJ2pRvfGajoRWtjV0B
         DLBkk9ql1m6PPU+KR7A5Gy1Vo0Tii9gD9esRBzP/G++Uv8qSs16kofc9FrfUDd3zYds0
         Kio9RC9B5YEEjcpdI6WGI2mBPxx7HWA53lu7JfeDVoiOk9yr5CadDP1TrfoxsWJrz9kV
         XiAR9BjpkaF/+Cz30vu0wqNphR1MY3nIxDBMPzOOLyzNhicHNnyccZxUQty8DtoJoTwl
         h70hV+LWAhoHCi9gj8tEqXcoXCL5IVUbccky7kbed9aGZ9/VXwFA+k3P+ull6JxS4nis
         +tPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E11peBCBeUkU5QqrM9F+hDGSoXytqmeuQIcQ91AaOag=;
        b=TZ7kKtU3scqr4jKnFenYviT88WkcqHhGnx6Kwan5j12pn+Bo+AqhPKL2JPLBi3fbGQ
         sEuOd0khD/GLpe3vVcnRSTvIKmEsprdCFLH3xGEP2AjWyQU2PuU6AYC/xxZHxR34l8DQ
         Eoyr0PIapXU8hxt9ctO/2Ph2DEjVTE06WAmQPSLtFHCrgGtl5c4JCtfFBc1JuDMgoH0t
         +CfI3KEaAFKYCjxE0uAMELdvUC5WiBlof/gdNqMYU7YfTvU0uLteir6gdAYBNwYDPomF
         65Mceyz7NLoVrNGAUyGHCVyq60pMlR04o/o1ox3VXdS3eMnSfVRG2xPn0Iq+a62LrgeA
         9VJQ==
X-Gm-Message-State: APjAAAUKU0+bGC5zzLl2L1DQyElZ3QGGSRozSGo24Ro5X/Bzl5SkbSYH
        mgWM970IPKIFy/LweCsZ9dMnjaC8UeTO8JqI96y5f5k+WfUQ6Y9XaKxcimnHx909zx0EI246Src
        RiuMg7BJVnAqlXoqHrg52vXUuCJhiuQHC54xXOvUiguzWcHoHCYNwJw==
X-Google-Smtp-Source: APXvYqwnF4T9oiM0Mq/9sMFYg+ye9CPyJsFfHWxWUaYTEotetUTGSucmt3tgFaUqi3bXPtsizq+glA7jwQ==
X-Received: by 2002:a63:1d18:: with SMTP id d24mr2463870pgd.189.1582703099990;
 Tue, 25 Feb 2020 23:44:59 -0800 (PST)
Date:   Tue, 25 Feb 2020 23:44:24 -0800
In-Reply-To: <20200226074427.169684-1-morbo@google.com>
Message-Id: <20200226074427.169684-5-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 4/7] svm: change operand to output-only for
 matching constraint
From:   morbo@google.com
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

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
2.25.0.265.gbab2e86ba0-goog

