Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82BD54D1A5
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 21:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346681AbiFOTbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 15:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346557AbiFOTbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 15:31:37 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C7B544E5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:31:36 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id r9-20020a92cd89000000b002d16798b3cfso8984767ilb.22
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OlpkQtFjEA6qewpRBAT14bPQnFjhhsciW1Lv/k5zWG8=;
        b=lqinctO2QCwci3P4aZTFnX0uxxIG+XgQuOKBHKCugg6ujYrJQis8gvN4TxUWJTyM6D
         JaSGqdTHn35GPXcRMXrt19hIl9K+SJE2y7fwCoJf9VYSTIWUBtJUTvOGQgW/HG14trDj
         O6wudR4uE/BmHlxf2dbQAN8gLe8WkWpPA3YqytvB9UM9r9XQSD0ZYXgy1jvf+5eIWFoj
         RYesUWRjy4+ZPeg9KvSg/fLw1I7UW0PbetlrgriWZ3RUPcKDu/+biFfuqYlwstrxKrQi
         lD9GrVXW6CU1fYJlnctxCggkpbVSgII/uRDOrb2mrMwfhi6nSgrwkmy1KeLA2sT+qU7s
         617A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OlpkQtFjEA6qewpRBAT14bPQnFjhhsciW1Lv/k5zWG8=;
        b=RhSPdFzY/JskLQ+3CGF9gUgpg/zUXD0uBDhSaz4ICopWc0R9d+Pud+xRNzB/qTq79Q
         BN9KGDZnYvbQkTVP1hTsAybFmZRPtgMf+p4LNjm8zS9t71VoFxZCE/iX9EhRgjUspKYQ
         oAgewoc4NlLv6bQyjabXsuzttOzuxmAL/nX0BDxKGwUX96u4lBQVFlbtgQoorJ7cuJn1
         xuAGIs9EJaDjPjhQ1rS8sVIOhlT8fhxYX4mRv9SfWZKW/XyYgTmcFvZYJ8VhQqh4HWDr
         IQwAqDzHDaXoTWkrN91IWKNtsiQvnDGMH2p1XyaqtyguWY8aeaSMP0I4cT3zRk4kuEwD
         CuTQ==
X-Gm-Message-State: AJIora/6hr7B+RHgiW5egp22W3ZKVmKgc+AAtkA1GnEonBjbU4G04nMs
        UCIgPum8O2/Hxz5WExvd/e9roI8VSDx7AZi7pajXMfuYVjtKi9hEkE9Owl6wm2pmlY5Ok+MprjA
        8rXsk/RFsZ6ElxCkZGWyM3EnVfOdLfqTJC/x8zO93Xawg2s33yHoo7U8V5H4rCm5643kFyWI=
X-Google-Smtp-Source: AGRyM1voscU1JxJ/hQMda5mYs4PrEqB3RuwB8jAsoWPnyKEEhH69+E+kp8IXB1gWJlBpEzSd3+uNt3+Qm+tD7uZuAg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5d:9817:0:b0:65a:f20b:db2c with SMTP
 id a23-20020a5d9817000000b0065af20bdb2cmr691990iol.118.1655321496198; Wed, 15
 Jun 2022 12:31:36 -0700 (PDT)
Date:   Wed, 15 Jun 2022 19:31:15 +0000
In-Reply-To: <20220615193116.806312-1-coltonlewis@google.com>
Message-Id: <20220615193116.806312-4-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220615193116.806312-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 3/4] KVM: selftests: Write REPORT_GUEST_ASSERT macros to pair
 with GUEST_ASSERT
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Cc:     seanjc@google.com, drjones@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, maz@kernel.org,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Write REPORT_GUEST_ASSERT macros to pair with GUEST_ASSERT to abstract
and make consistent all guest assertion reporting. Every report
includes an explanatory string, a filename, and a line number.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/include/ucall_common.h      | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 568c562f14cd..e8af3b4fef6d 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -6,6 +6,7 @@
  */
 #ifndef SELFTEST_KVM_UCALL_COMMON_H
 #define SELFTEST_KVM_UCALL_COMMON_H
+#include "test_util.h"
 
 /* Common ucalls */
 enum {
@@ -64,4 +65,45 @@ enum guest_assert_builtin_args {
 
 #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
 
+#define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
+	TEST_FAIL("%s at %s:%ld\n" fmt,					\
+		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
+		  (const char *)(_ucall).args[GUEST_FILE],		\
+		  (_ucall).args[GUEST_LINE],				\
+		  ##_args)
+
+#define GUEST_ASSERT_ARG(ucall, i) ((ucall).args[GUEST_ASSERT_BUILTIN_NARGS + i])
+
+#define REPORT_GUEST_ASSERT(ucall)		\
+	__REPORT_GUEST_ASSERT((ucall), "")
+
+#define REPORT_GUEST_ASSERT_1(ucall, fmt)			\
+	__REPORT_GUEST_ASSERT((ucall),				\
+			      fmt,				\
+			      GUEST_ASSERT_ARG((ucall), 0))
+
+#define REPORT_GUEST_ASSERT_2(ucall, fmt)			\
+	__REPORT_GUEST_ASSERT((ucall),				\
+			      fmt,				\
+			      GUEST_ASSERT_ARG((ucall), 0),	\
+			      GUEST_ASSERT_ARG((ucall), 1))
+
+#define REPORT_GUEST_ASSERT_3(ucall, fmt)			\
+	__REPORT_GUEST_ASSERT((ucall),				\
+			      fmt,				\
+			      GUEST_ASSERT_ARG((ucall), 0),	\
+			      GUEST_ASSERT_ARG((ucall), 1),	\
+			      GUEST_ASSERT_ARG((ucall), 2))
+
+#define REPORT_GUEST_ASSERT_4(ucall, fmt)			\
+	__REPORT_GUEST_ASSERT((ucall),				\
+			      fmt,				\
+			      GUEST_ASSERT_ARG((ucall), 0),	\
+			      GUEST_ASSERT_ARG((ucall), 1),	\
+			      GUEST_ASSERT_ARG((ucall), 2),	\
+			      GUEST_ASSERT_ARG((ucall), 3))
+
+#define REPORT_GUEST_ASSERT_N(ucall, fmt, args...)	\
+	__REPORT_GUEST_ASSERT((ucall), fmt, ##args)
+
 #endif /* SELFTEST_KVM_UCALL_COMMON_H */
-- 
2.36.1.476.g0c4daa206d-goog

