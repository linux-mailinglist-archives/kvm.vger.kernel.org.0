Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6546137040A
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 01:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhD3XZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 19:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhD3XZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 19:25:05 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9897C06174A
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:15 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 9-20020a056a000729b029025d0d3c2062so146205pfm.1
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+DSPnKtKLaCWYruB9RUFpApCJLw7ci5vJYpmKsxCMpY=;
        b=GHmtm/HM2OsR4qjLE/kzZOFZvHz4TWk6oZ3ISonugQE6amsbiSELaSSMwNq1EmIKhD
         dlftmhUu0LrDTzlEUbYbo7zrpSF89uaN24YRWR4BBjiUaG44gV9W5Akqw+fPwnSngtUV
         vvrLatZTJP5fXD8VrPgRQFP1Zml58ooiVF7NdK0+e4dCErXUfJjk4IC1v5q2H4PQjjNd
         nztXvIOclQ/qwp6OkK+R35UH+ZXmMTdf36MXFViViWfnIYPrpFBncFkkcaGUptG7WPL+
         KJK0kR5vRn7Fpz9JKPs9IqiTc6AW727iV7E4+zFBAxPc70hIB4Kcpge+JFoEDo2Z7m6g
         L+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+DSPnKtKLaCWYruB9RUFpApCJLw7ci5vJYpmKsxCMpY=;
        b=liIn5uXVX+RznSVqQPq8awQpU9WCD3rbwo9jkAtHJZyhBsImIg0yQk44IQa+TGYjmN
         9TkJH0dFNssNq6mhNtfNN3OLWjHmVsiQF5EmtJeIclQnnbjaSlXDwUItlNduA0ayQCul
         DHY+vMTmXHWMF0I3/UGFeUY+hZgllq2eBabKmJGUR6V8uRLPC5NKQcJ6CiJ9yvSttV/8
         k5fXEsRvlu7Rvrw5pGBDTDwJnhCVgvOpZxivXZZlCn1C8EKf9nWtHIIwkOXehYNwxw+X
         UtgSQB7ikacQBYO5jBFSG3fWCsSiIj/dkasexz/7xiO5JR9YEwnOk1WHbkcIiHn3qxmj
         7T1Q==
X-Gm-Message-State: AOAM531uy4x0lwSwjq1hugFzM8a7ZLMLDMfj6Na/+6CqBPNXqoxEpPMR
        9C+Fans1q6o8NzHO2Oncw6VpIDoKn8CuHasw7EJKE4Ikoo3W2QDPnqLTEWztvSfUDuFjPw/JwUD
        3S4HUmQoSyDytngtEm7FacWJeNIHbXGptuRYZR+EavcwZwOnKaJR8u+Ivu7KJhpM=
X-Google-Smtp-Source: ABdhPJwC5V/hbECRi8QXjzfu3qwYiwVszsZ2QtYnlFZCKfIcZmSzuCJ4ZAqv7NpufKqwn6hZrHJb7GOdJFz6fQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:b905:b029:ed:2235:ad2c with SMTP
 id bf5-20020a170902b905b02900ed2235ad2cmr7763186plb.28.1619825055219; Fri, 30
 Apr 2021 16:24:15 -0700 (PDT)
Date:   Fri, 30 Apr 2021 16:24:05 -0700
In-Reply-To: <20210430232408.2707420-1-ricarkol@google.com>
Message-Id: <20210430232408.2707420-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210430232408.2707420-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move GUEST_ASSERT_EQ to a common header, kvm_util.h, for other
architectures and tests to use.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h     | 9 +++++++++
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 7880929ea548..bd26dd93ab56 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -388,4 +388,13 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
 	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
 
+#define GUEST_ASSERT_EQ(a, b) do {				\
+	__typeof(a) _a = (a);					\
+	__typeof(b) _b = (b);					\
+	if (_a != _b)						\
+		ucall(UCALL_ABORT, 4,				\
+			"Failed guest assert: "			\
+			#a " == " #b, __LINE__, _a, _b);	\
+} while(0)
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
index e357d8e222d4..5a6a662f2e59 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -18,15 +18,6 @@
 #define rounded_rdmsr(x)       ROUND(rdmsr(x))
 #define rounded_host_rdmsr(x)  ROUND(vcpu_get_msr(vm, 0, x))
 
-#define GUEST_ASSERT_EQ(a, b) do {				\
-	__typeof(a) _a = (a);					\
-	__typeof(b) _b = (b);					\
-	if (_a != _b)						\
-                ucall(UCALL_ABORT, 4,				\
-                        "Failed guest assert: "			\
-                        #a " == " #b, __LINE__, _a, _b);	\
-  } while(0)
-
 static void guest_code(void)
 {
 	u64 val = 0;
-- 
2.31.1.527.g47e6f16901-goog

