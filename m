Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC2A596657
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 02:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbiHQAgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 20:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238024AbiHQAgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 20:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FF78C461
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660696579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/SVxUH9CqIfzsVnNZsd2Uihd8CdpKj/1oI3QClWoPk=;
        b=NqCQfPjjE4H71DARY83H9QlQo0RUPd4iOkjtfGvuWS9VH/G5Ad4Q0M1A/mXf71c6WqrVuz
        D6I5YDK9MmpWADPRfJoAQa7GAWU0bfv+d8gw94W9B4kpURnVDnH8Sggf/qugE6KxFrzBn4
        PT4Gw+uJIlKO25HIUDmgPOfHGhU+Y0A=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-387-kyR4Ak0dPg2I97BjBmr8Rg-1; Tue, 16 Aug 2022 20:36:18 -0400
X-MC-Unique: kyR4Ak0dPg2I97BjBmr8Rg-1
Received: by mail-qv1-f70.google.com with SMTP id l10-20020ad44bca000000b0049664e99a57so743406qvw.17
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=e/SVxUH9CqIfzsVnNZsd2Uihd8CdpKj/1oI3QClWoPk=;
        b=aZ73dNtgqFC9GJfqdlT42o55zUZWkQsOd5dITI+2EYzg42blDCEOkrDLPOfdUcBTzC
         pXio4v79ijB/2oZyMHdBHgIKrcdj9asg561G8X2ak6SFHhiO3PDtLeXnTzp5Fl91lsLB
         Igv21U2328jVKx7RVZhlMmrotZt+xFGECDcx5cVgk1biZ92OJBiMbISSShaGXr63dpdw
         1GoiaEetgRckpHSD/0uG5WRl6FTOD9BnRZxGl7v4RkIDBfrbxksLe4UtdNEbmF8fuN2g
         i0EoTyCPPck2kdMJJbR8OUNfkP+EH2d+X6P9IYINp/ybBuMqnAo5RHQe/wdhJhK5CU25
         PvEg==
X-Gm-Message-State: ACgBeo1bwIUtZVFR663sMttN53jgrz7haGPO2LCgbLLK4Kj4cD9wqRpW
        nYmkQoFvm1tEnXeaEe2HqqE95E7TeFaan7rxVwOeZ6k/vXmkIkAfyeQ2aS2G8QBB8p9rpQepPYP
        olpSLV8m2ADs8
X-Received: by 2002:a05:620a:164b:b0:6bb:761:fe1d with SMTP id c11-20020a05620a164b00b006bb0761fe1dmr10840791qko.597.1660696578019;
        Tue, 16 Aug 2022 17:36:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR43jJoPki+u1Yj/TOnNQJFWojKLBcEgxpYaJnT2CS+d5ISlEfpihIPryWn36nZhVvg5r/Yv2g==
X-Received: by 2002:a05:620a:164b:b0:6bb:761:fe1d with SMTP id c11-20020a05620a164b00b006bb0761fe1dmr10840780qko.597.1660696577744;
        Tue, 16 Aug 2022 17:36:17 -0700 (PDT)
Received: from localhost.localdomain (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id c13-20020ac87dcd000000b0034358bfc3c8sm12007175qte.67.2022.08.16.17.36.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Aug 2022 17:36:17 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v3 1/3] mm/gup: Add FOLL_INTERRUPTIBLE
Date:   Tue, 16 Aug 2022 20:36:12 -0400
Message-Id: <20220817003614.58900-2-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220817003614.58900-1-peterx@redhat.com>
References: <20220817003614.58900-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have had FAULT_FLAG_INTERRUPTIBLE but it was never applied to GUPs.  One
issue with it is that not all GUP paths are able to handle signal delivers
besides SIGKILL.

That's not ideal for the GUP users who are actually able to handle these
cases, like KVM.

KVM uses GUP extensively on faulting guest pages, during which we've got
existing infrastructures to retry a page fault at a later time.  Allowing
the GUP to be interrupted by generic signals can make KVM related threads
to be more responsive.  For examples:

  (1) SIGUSR1: which QEMU/KVM uses to deliver an inter-process IPI,
      e.g. when the admin issues a vm_stop QMP command, SIGUSR1 can be
      generated to kick the vcpus out of kernel context immediately,

  (2) SIGINT: which can be used with interactive hypervisor users to stop a
      virtual machine with Ctrl-C without any delays/hangs,

  (3) SIGTRAP: which grants GDB capability even during page faults that are
      stuck for a long time.

Normally hypervisor will be able to receive these signals properly, but not
if we're stuck in a GUP for a long time for whatever reason.  It happens
easily with a stucked postcopy migration when e.g. a network temp failure
happens, then some vcpu threads can hang death waiting for the pages.  With
the new FOLL_INTERRUPTIBLE, we can allow GUP users like KVM to selectively
enable the ability to trap these signals.

Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm.h |  1 +
 mm/gup.c           | 33 +++++++++++++++++++++++++++++----
 mm/hugetlb.c       |  5 ++++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cf3d0d673f6b..c09eccd5d553 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2941,6 +2941,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
 #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
+#define FOLL_INTERRUPTIBLE  0x100000 /* allow interrupts from generic signals */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
diff --git a/mm/gup.c b/mm/gup.c
index 551264407624..f39cbe011cf1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -933,8 +933,17 @@ static int faultin_page(struct vm_area_struct *vma,
 		fault_flags |= FAULT_FLAG_WRITE;
 	if (*flags & FOLL_REMOTE)
 		fault_flags |= FAULT_FLAG_REMOTE;
-	if (locked)
+	if (locked) {
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+		/*
+		 * FAULT_FLAG_INTERRUPTIBLE is opt-in. GUP callers must set
+		 * FOLL_INTERRUPTIBLE to enable FAULT_FLAG_INTERRUPTIBLE.
+		 * That's because some callers may not be prepared to
+		 * handle early exits caused by non-fatal signals.
+		 */
+		if (*flags & FOLL_INTERRUPTIBLE)
+			fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
+	}
 	if (*flags & FOLL_NOWAIT)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
 	if (*flags & FOLL_TRIED) {
@@ -1322,6 +1331,22 @@ int fixup_user_fault(struct mm_struct *mm,
 }
 EXPORT_SYMBOL_GPL(fixup_user_fault);
 
+/*
+ * GUP always responds to fatal signals.  When FOLL_INTERRUPTIBLE is
+ * specified, it'll also respond to generic signals.  The caller of GUP
+ * that has FOLL_INTERRUPTIBLE should take care of the GUP interruption.
+ */
+static bool gup_signal_pending(unsigned int flags)
+{
+	if (fatal_signal_pending(current))
+		return true;
+
+	if (!(flags & FOLL_INTERRUPTIBLE))
+		return false;
+
+	return signal_pending(current);
+}
+
 /*
  * Please note that this function, unlike __get_user_pages will not
  * return 0 for nr_pages > 0 without FOLL_NOWAIT
@@ -1403,11 +1428,11 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 		 * Repeat on the address that fired VM_FAULT_RETRY
 		 * with both FAULT_FLAG_ALLOW_RETRY and
 		 * FAULT_FLAG_TRIED.  Note that GUP can be interrupted
-		 * by fatal signals, so we need to check it before we
+		 * by fatal signals of even common signals, depending on
+		 * the caller's request. So we need to check it before we
 		 * start trying again otherwise it can loop forever.
 		 */
-
-		if (fatal_signal_pending(current)) {
+		if (gup_signal_pending(flags)) {
 			if (!pages_done)
 				pages_done = -EINTR;
 			break;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a57e1be41401..4025a305d573 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6176,9 +6176,12 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				fault_flags |= FAULT_FLAG_WRITE;
 			else if (unshare)
 				fault_flags |= FAULT_FLAG_UNSHARE;
-			if (locked)
+			if (locked) {
 				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
 					FAULT_FLAG_KILLABLE;
+				if (flags & FOLL_INTERRUPTIBLE)
+					fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
+			}
 			if (flags & FOLL_NOWAIT)
 				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
 					FAULT_FLAG_RETRY_NOWAIT;
-- 
2.32.0

