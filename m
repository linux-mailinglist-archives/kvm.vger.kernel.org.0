Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7645B496279
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381736AbiAUP7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381742AbiAUP7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 10:59:12 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49255C06173D
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:59:12 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id n23-20020a17090a161700b001b3ea76b406so8803577pja.5
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/nVQL044VkFMI3iybl+vKkbz76a4Xh01nLuzyZTcW1s=;
        b=Bna7dU48kinRNiRoyf0LD79h+hOUzztSeQBE8thzNLwTzn61mW8Ht6jbjzsnys6Sgl
         i6SrJFiZCt7XmF0saONNNwMwT+RoN6HpqzVcfAThj8TfVVbyBciFyKuBMAFRAvfZgHsv
         asnTXw5FgMWOJyINsTjEnEyTeQsSWn6uxkGMg/XbNB7IglI7smWuFdWeIkxabwYFKH4s
         k9Ffbev4uZSnTOvoAw6jiNj2DrEtA9MmUhpdsRQGZuEAAzUCM8Dik8Y4PImTGT/Vz778
         32y7ChpjwEm/2AaZBQyix1WwXYvh25qqtWtRQs/VtPbgizC+3gKRXlvIbcUrsk10KBUy
         EPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/nVQL044VkFMI3iybl+vKkbz76a4Xh01nLuzyZTcW1s=;
        b=i466eflt5yoicwzA7VZHeqeIYNSk116zI0KwL+8LmrTiW/tzv96mp2wMWBkRzK9YFw
         52BTV7Kx/R0X9alsJ4SdgX5aN8i9XnPDJR2G7a/mF5k72s/QHCqbqf+Zyyzo3I8s4iqW
         LLkn/7wX1vsQlV+ctCcAJLBXXkgArshcyQYCWuqcS/ZPU488HN7l4KTNdxiWQkSO6g3u
         OMVDZFxpFCq4oe9MUiYBURsAHyvTwbDf7I7j+MpEjKU6fdzOwjdnVb3KcoY22GKz1LLp
         EMJUrnjigMnMPQ1YCVl39W2KZNchl0Ks97zaWICP0UTSh4wC0VudGH5vLNxduOH4Bahw
         nxMA==
X-Gm-Message-State: AOAM531ZysNchqFqg/mavgTYq9C8rjjDXVcjcByaZXJTuhmjcNOdFtyW
        hTq5b4MO0k5yoyxYQIdAVelQ+baqGKlzujdl+d527aI0UhurKrI006NkiWJ1ILP5bvdTNGZgzIi
        UmJhUKyyt/F9nxX4DFd3xzCGGARYwFAFdP6Bq2OFQCdkb09SHDwq+5Nlekgs7vg5B5MkO
X-Google-Smtp-Source: ABdhPJyHnGlwqmDaygCikL0cZEmljL8XZEPcmK4PWybzoYG8DPAwlhrDwmzhEKb5UHP7IcOfCGXCRc8H+hn3lfuF
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:8683:0:b0:4c7:2221:2f93 with SMTP
 id x125-20020a628683000000b004c722212f93mr4162122pfd.79.1642780751658; Fri,
 21 Jan 2022 07:59:11 -0800 (PST)
Date:   Fri, 21 Jan 2022 15:58:54 +0000
In-Reply-To: <20220121155855.213852-1-aaronlewis@google.com>
Message-Id: <20220121155855.213852-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220121155855.213852-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH v4 2/3] x86: Add support for running a nested
 guest multiple times in one test
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KUT has a limit of only being able to run one nested guest per vmx test.
This is limiting and not necessary.  Add support for allowing a test to
run guest code multiple times.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/vmx.c | 24 ++++++++++++++++++++++--
 x86/vmx.h |  2 ++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index f4fbb94..51eed8c 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1884,15 +1884,35 @@ void test_add_teardown(test_teardown_func func, void *data)
 	step->data = data;
 }
 
+static void __test_set_guest(test_guest_func func)
+{
+	assert(current->v2);
+	v2_guest_main = func;
+}
+
 /*
  * Set the target of the first enter_guest call. Can only be called once per
  * test. Must be called before first enter_guest call.
  */
 void test_set_guest(test_guest_func func)
 {
-	assert(current->v2);
 	TEST_ASSERT_MSG(!v2_guest_main, "Already set guest func.");
-	v2_guest_main = func;
+	__test_set_guest(func);
+}
+
+/*
+ * Set the target of the enter_guest call and reset the RIP so 'func' will
+ * start from the beginning.  This can be called multiple times per test.
+ */
+void test_override_guest(test_guest_func func)
+{
+	__test_set_guest(func);
+	init_vmcs_guest();
+}
+
+void test_set_guest_finished(void)
+{
+	guest_finished = 1;
 }
 
 static void check_for_guest_termination(union exit_reason exit_reason)
diff --git a/x86/vmx.h b/x86/vmx.h
index 4423986..11cb665 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -1055,7 +1055,9 @@ void hypercall(u32 hypercall_no);
 typedef void (*test_guest_func)(void);
 typedef void (*test_teardown_func)(void *data);
 void test_set_guest(test_guest_func func);
+void test_override_guest(test_guest_func func);
 void test_add_teardown(test_teardown_func func, void *data);
 void test_skip(const char *msg);
+void test_set_guest_finished(void);
 
 #endif
-- 
2.35.0.rc0.227.g00780c9af4-goog

