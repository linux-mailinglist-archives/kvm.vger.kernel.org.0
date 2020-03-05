Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E6817A250
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 10:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgCEJgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:36:53 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42848 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgCEJgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:36:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id v11so4148591wrm.9
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 01:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CXVlcp4rV/eWS8npZ8qAK0kaNe+d3hDfH3kziUz7KK0=;
        b=DKua6c6FJkL4IisF//4Yr39hw8aM46YyaBScqrA3m8S7eTXslBcOj4ZR6U/xaUtuOD
         j5VNLo1APEKvYzZtyuz/5OhCQlDg5S4uV1/jQQoHHNqD2E+ysH9AfUC8qaiqXAyt5Jpy
         Kq968RWGvn2weSg1ZbBsJbCCkQZnVN6shR7QfQrJ4ak6udUjAjG09p5ngbmxq5AVj9AU
         yGo0HBqQKyJRSg/2kzf5WQh/SqHmuoCeG0zf+QH4xxBjTObu4dJYj28LfbNS4QbFoqTI
         7TUgCwyCad6IxVLgurRBIwjsTwkcF4ySj0xO/lAhT4aGBup5g/U+pioos9Ye6wFaQDGF
         ucdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=CXVlcp4rV/eWS8npZ8qAK0kaNe+d3hDfH3kziUz7KK0=;
        b=DXXHodvfN7NEdoCNCXZOWJ/u5mRGdtHCkMsxIcVb1in833wUFvpikqbSLH8OOLSQ8D
         Zh3jYL6v9AWzT6f3XG58QyuG5W5UzlrIqR8676OEttkpnQZk4UvLhShLnQxj7bwtPQzf
         H/ulKB3GONjBwPD5ykTYuCL9xECnI78V4lr7U4i703lB+WC0bV9raGc8mHPPnJLjfvAw
         6YMW5xRGuDhOHUXCV1COJn1y1AzHY1K0OfIedcNysUNyOkCWak5KDageG7xvl3YIxl6p
         9r7HYFFU2h5XMnGkgT00QUFrmIsZ7hIwiazSkL1KqKfzpuj6hmQRgBeeGWY+At4bZIZt
         ajfA==
X-Gm-Message-State: ANhLgQ1NYSKSQreqlQ0RDcm0HWygn5xTyac2GHF6t4i2qTFsp48TPtEP
        6L2c7m9FHjqDRU8xlcn4K2SjBRgA
X-Google-Smtp-Source: ADFU+vvVrfkc5awtDes5Ju1KJawyQtZrz4WA8Vh5Khraa+TGd2MpC9AFGeB0khx9WiNDW0Kkly8/gw==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr1266856wrq.79.1583401009495;
        Thu, 05 Mar 2020 01:36:49 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w1sm8188563wmc.11.2020.03.05.01.36.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 01:36:49 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     cavery@redhat.com
Subject: [PATCH kvm-unit-tests 1/2] svm: rename and comment the pending_event_vmask test
Date:   Thu,  5 Mar 2020 10:36:45 +0100
Message-Id: <1583401006-57136-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583401006-57136-1-git-send-email-pbonzini@redhat.com>
References: <1583401006-57136-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both the pending_event and pending_event_vmask test are using the
V_INTR_MASKING field.  The difference is that pending_event_vmask
runs with host IF cleared, and therefore does not expect INTR
vmexits.  Rename the test to clarify this, and add comments to
explain what's going on.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 70e5169..f300c8a 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -1400,7 +1400,7 @@ static bool pending_event_check(struct test *test)
     return get_test_stage(test) == 2;
 }
 
-static void pending_event_prepare_vmask(struct test *test)
+static void pending_event_cli_prepare(struct test *test)
 {
     default_prepare(test);
 
@@ -1414,12 +1414,12 @@ static void pending_event_prepare_vmask(struct test *test)
     set_test_stage(test, 0);
 }
 
-static void pending_event_prepare_gif_clear_vmask(struct test *test)
+static void pending_event_cli_prepare_gif_clear(struct test *test)
 {
     asm("cli");
 }
 
-static void pending_event_test_vmask(struct test *test)
+static void pending_event_cli_test(struct test *test)
 {
     if (pending_event_ipi_fired == true) {
         set_test_stage(test, -1);
@@ -1427,6 +1427,7 @@ static void pending_event_test_vmask(struct test *test)
         vmmcall();
     }
 
+    /* VINTR_MASKING is zero.  This should cause the IPI to fire.  */
     irq_enable();
     asm volatile ("nop");
     irq_disable();
@@ -1438,12 +1439,17 @@ static void pending_event_test_vmask(struct test *test)
 
     vmmcall();
 
+    /*
+     * Now VINTR_MASKING=1, but no interrupt is pending so
+     * the VINTR interception should be clear in VMCB02.  Check
+     * that L0 did not leave a stale VINTR in the VMCB.
+     */
     irq_enable();
     asm volatile ("nop");
     irq_disable();
 }
 
-static bool pending_event_finished_vmask(struct test *test)
+static bool pending_event_cli_finished(struct test *test)
 {
     if ( test->vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
         report(false, "VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
@@ -1459,6 +1465,7 @@ static bool pending_event_finished_vmask(struct test *test)
 
         test->vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
 
+	/* Now entering again with VINTR_MASKING=1.  */
         apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
               APIC_DM_FIXED | 0xf1, 0);
 
@@ -1490,7 +1497,7 @@ static bool pending_event_finished_vmask(struct test *test)
     return get_test_stage(test) == 2;
 }
 
-static bool pending_event_check_vmask(struct test *test)
+static bool pending_event_cli_check(struct test *test)
 {
     return get_test_stage(test) == 2;
 }
@@ -1571,10 +1578,10 @@ static struct test tests[] = {
     { "pending_event", default_supported, pending_event_prepare,
       default_prepare_gif_clear,
       pending_event_test, pending_event_finished, pending_event_check },
-    { "pending_event_vmask", default_supported, pending_event_prepare_vmask,
-      pending_event_prepare_gif_clear_vmask,
-      pending_event_test_vmask, pending_event_finished_vmask,
-      pending_event_check_vmask },
+    { "pending_event_cli", default_supported, pending_event_cli_prepare,
+      pending_event_cli_prepare_gif_clear,
+      pending_event_cli_test, pending_event_cli_finished,
+      pending_event_cli_check },
 };
 
 int matched;
-- 
1.8.3.1


