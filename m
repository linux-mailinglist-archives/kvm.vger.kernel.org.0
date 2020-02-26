Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DD716FB30
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgBZJpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:45:15 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:32874 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgBZJpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:45:14 -0500
Received: by mail-pg1-f201.google.com with SMTP id 37so1523816pgq.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ansmD08qeSQd3zCEhBBHvF2ZiEtCQ7Cypjwva684W3Y=;
        b=bSg/lgzO8EyFmpdJa2X9yE+aw7omAzEe9b9MN0UpOqHdJFzplGKmhAesP+WMvUIDrI
         d3/0M5sRUyLVelAeJxhhqyo5hXn4A02sR3tS0HIs8rO4FuedRefAi9WxyNETryov/+ru
         VzhtVqsEQ1YQlWwDviU76BXc7+2G+D9UXp4mxzdyhicvhhvycR23ofF65zNCLC1E25ul
         fmX0NbdyEq2cKOw7lfVIe5C421n0RzvVZouIJH/mW9x4RVPyV3QEYLvvi9ehwRJTXY2W
         eL53JViDy4p776qC8pXqse9wztUajrD+U7oUc4rfdi80447xXd9pJAZY5kWGpG4DpzWq
         k6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ansmD08qeSQd3zCEhBBHvF2ZiEtCQ7Cypjwva684W3Y=;
        b=nL/FglODf68Coo6OhgC0mo6I0SglRq6rbbVZGouDew5f0JzDs6e4lbB6p7d3+vpgRX
         9tuZEXODFJdKPP1GrIbPCyhEhzG/LKSmjxeEyd2zazkTTaYptZ5E3gEnkdYOUuvjJCA+
         /HJ/DrPKAKUFihxo/COMsNW4LYuCU/NrDYSUDbOCu35qrdwU34r26YoJM7SFsTPuVc80
         JpdNFInkTwfsGTs1DlbAypD2kyjvucqMDg0FrPAukM9xvjt5Vj3AHLByPazp6LflSRaw
         LlRZQgIMLZOj6T1idL1RfbdnGlLGadKAdAgKWRlq+EYD+GIeghn+6YSHMu9ZShEs7uEu
         8YVw==
X-Gm-Message-State: APjAAAWheNpyyn6NXTsLEF5K5X6AcXDn1naB6uo+UQV9sret0RcaifQO
        NSG7hwXZaDBWwp1lyT29QcMVfiOywjsvPDvHpaUy5HOyOQV1NN8dmsUFiqoGf7WmSazs672TW8l
        RCOGWZ2pThQ7fBU1Nqo90jD3tRV4zghyUdU1S6GPHqJprKJJQ8mXrgA==
X-Google-Smtp-Source: APXvYqxtDaimY5cY7HlA/FVJiMnSVTNbWXaOP/GHptQrOggE8upKzyNBA59154aPbwXqe4FyTqfA8XtYJQ==
X-Received: by 2002:a63:68a:: with SMTP id 132mr3136042pgg.12.1582710313516;
 Wed, 26 Feb 2020 01:45:13 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:33 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-15-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 7/7] x86: VMX: the "noclone" attribute is gcc-specific
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't use the "noclone" attribute for clang as it's not supported.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/vmx_tests.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ad8c002..ec88016 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4976,7 +4976,10 @@ extern unsigned char test_mtf1;
 extern unsigned char test_mtf2;
 extern unsigned char test_mtf3;
 
-__attribute__((noclone)) static void test_mtf_guest(void)
+#ifndef __clang__
+__attribute__((noclone))
+#endif
+static void test_mtf_guest(void)
 {
 	asm ("vmcall;\n\t"
 	     "out %al, $0x80;\n\t"
-- 
2.25.0.265.gbab2e86ba0-goog

