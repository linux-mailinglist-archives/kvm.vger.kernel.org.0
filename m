Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AC736155A
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 00:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhDOWVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 18:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbhDOWVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 18:21:46 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FD2C061574
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:23 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id i9-20020ac85e490000b02901b186fa5716so4931801qtx.22
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ejNz6/mRycQ/8a4gZzvJd7025j920aJ4l8YEJ/7oL7w=;
        b=ex93+VhLDEnZyrU3fa14LC/l+d4QG+7TX3kkWOj6bc2ImObzfFwIA0H3Ej6OsaJ25/
         bXuSwIJLlLOWYitYmKqt6QfIfi4S55+UeHd6P/lXrdZqzvAFESJQrDcATMLmaeFyu/bJ
         V0IszkhtV/E8vmxCdhqRdF6h9PDRJHpPfOe+QryANb8Fwh5Gi8f8IZF+VpBy7KqNY7qV
         3h/Om4MO5KMZyf5Il785WcYyhTzZo/B/Uqxzh3/fzQJYfDdAUpzb50KLrFkzjYHgFWsA
         rhzCNKhQfbSItqxPNuB+B4tUE0G0MBCvwwAUYHlxRPE8XatqhsPf7AjfuNmKVeH5BjxK
         Xyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ejNz6/mRycQ/8a4gZzvJd7025j920aJ4l8YEJ/7oL7w=;
        b=PnJq/z+wt++K5qSEFuPhBJk4OLLcLgkmYoPCWH7kAboQgc2PJazWv94mhFaTtskDby
         69FGGO0h33/9IUPc4PBbUhX1yYpjeBzdKBRDJIdcuLxssGBJbT+eIuN7OZEJMfPYCvQQ
         BLa8jWbKCQ6+hbsqMbPOzoF9dvMExUrkKKukQesiJaX6U9xqEKTE/kKuZDKXRdzu+PAJ
         d6SfWrlYUtdHXigw2VYJn2mpEcIuOiRotwdeai5HPiKJZ7rdD2C9txLSAIXfhO92ZCp0
         y4h1oAIPes4e60vQzsTSRoeYPD2mtSjrCKLQ7lin/nBvh9hs/m6IQ9FaVbGvZ4nRi+Us
         bscg==
X-Gm-Message-State: AOAM530nxsNLE/9sw0dbJDlufgyH+Z6BcYrMX9ZIPtvWKiLyBFgX7eG0
        HnVHNllUNNOHo6ag0hefQPRv/9jumH4=
X-Google-Smtp-Source: ABdhPJzf+ldPvj6Fg4gh6aAz/cRIuHFFV6MjRkz9wisPDwSyKPmpjYPOqJcN0ic3Jp8qnjnXL7/Vcfx6ldE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c93:ada0:6bbf:e7db])
 (user=seanjc job=sendgmr) by 2002:ad4:4f84:: with SMTP id em4mr5435608qvb.26.1618525282494;
 Thu, 15 Apr 2021 15:21:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 15 Apr 2021 15:21:01 -0700
In-Reply-To: <20210415222106.1643837-1-seanjc@google.com>
Message-Id: <20210415222106.1643837-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210415222106.1643837-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH v3 4/9] sched/vtime: Move vtime accounting external
 declarations above inlines
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the blob of external declarations (and their stubs) above the set of
inline definitions (and their stubs) for vtime accounting.  This will
allow a future patch to bring in more inline definitions without also
having to shuffle large chunks of code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/vtime.h | 94 +++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 041d6524d144..6a4317560539 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -10,53 +10,6 @@
 
 struct task_struct;
 
-/*
- * vtime_accounting_enabled_this_cpu() definitions/declarations
- */
-#if defined(CONFIG_VIRT_CPU_ACCOUNTING_NATIVE)
-
-static inline bool vtime_accounting_enabled_this_cpu(void) { return true; }
-extern void vtime_task_switch(struct task_struct *prev);
-
-#elif defined(CONFIG_VIRT_CPU_ACCOUNTING_GEN)
-
-/*
- * Checks if vtime is enabled on some CPU. Cputime readers want to be careful
- * in that case and compute the tickless cputime.
- * For now vtime state is tied to context tracking. We might want to decouple
- * those later if necessary.
- */
-static inline bool vtime_accounting_enabled(void)
-{
-	return context_tracking_enabled();
-}
-
-static inline bool vtime_accounting_enabled_cpu(int cpu)
-{
-	return context_tracking_enabled_cpu(cpu);
-}
-
-static inline bool vtime_accounting_enabled_this_cpu(void)
-{
-	return context_tracking_enabled_this_cpu();
-}
-
-extern void vtime_task_switch_generic(struct task_struct *prev);
-
-static inline void vtime_task_switch(struct task_struct *prev)
-{
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_task_switch_generic(prev);
-}
-
-#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
-
-static inline bool vtime_accounting_enabled_cpu(int cpu) {return false; }
-static inline bool vtime_accounting_enabled_this_cpu(void) { return false; }
-static inline void vtime_task_switch(struct task_struct *prev) { }
-
-#endif
-
 /*
  * Common vtime APIs
  */
@@ -94,6 +47,53 @@ static inline void vtime_account_hardirq(struct task_struct *tsk) { }
 static inline void vtime_flush(struct task_struct *tsk) { }
 #endif
 
+/*
+ * vtime_accounting_enabled_this_cpu() definitions/declarations
+ */
+#if defined(CONFIG_VIRT_CPU_ACCOUNTING_NATIVE)
+
+static inline bool vtime_accounting_enabled_this_cpu(void) { return true; }
+extern void vtime_task_switch(struct task_struct *prev);
+
+#elif defined(CONFIG_VIRT_CPU_ACCOUNTING_GEN)
+
+/*
+ * Checks if vtime is enabled on some CPU. Cputime readers want to be careful
+ * in that case and compute the tickless cputime.
+ * For now vtime state is tied to context tracking. We might want to decouple
+ * those later if necessary.
+ */
+static inline bool vtime_accounting_enabled(void)
+{
+	return context_tracking_enabled();
+}
+
+static inline bool vtime_accounting_enabled_cpu(int cpu)
+{
+	return context_tracking_enabled_cpu(cpu);
+}
+
+static inline bool vtime_accounting_enabled_this_cpu(void)
+{
+	return context_tracking_enabled_this_cpu();
+}
+
+extern void vtime_task_switch_generic(struct task_struct *prev);
+
+static inline void vtime_task_switch(struct task_struct *prev)
+{
+	if (vtime_accounting_enabled_this_cpu())
+		vtime_task_switch_generic(prev);
+}
+
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
+
+static inline bool vtime_accounting_enabled_cpu(int cpu) {return false; }
+static inline bool vtime_accounting_enabled_this_cpu(void) { return false; }
+static inline void vtime_task_switch(struct task_struct *prev) { }
+
+#endif
+
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 extern void irqtime_account_irq(struct task_struct *tsk, unsigned int offset);
-- 
2.31.1.368.gbe11c130af-goog

