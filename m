Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412B63A392D
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 03:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhFKBN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 21:13:28 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:43575 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhFKBN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 21:13:27 -0400
Received: by mail-pl1-f201.google.com with SMTP id e14-20020a170902784eb0290102b64712f9so1947767pln.10
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 18:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4aDyFvrxlFwPOgnkxkIlU3KeNadi1hrIbCCSRD9xSSc=;
        b=YGy5QJg9Hws1yT/Ru5qLO1HC2J/F0QhvK4R9XpwC06AK9L4lg19fWiwepuXsuVtVgo
         UW/xvDPVAiQC4duDkeaCNCkx0HsWVYsjYUr7wRtCUIVrJU8gyKEsNkf0BLz2XVmzdyYd
         DxL1XbdIohcgKHLbdBX6m9Pq8KBwIFCLXI8DL+P66L4zyvsml5oJv1wWwyWs+KyieP/C
         tLCB38gdAK4PIl2/q3S+ebNmUvwtzd5Gk6THaod+3iPu7FE8x1UlcIXePjSliI3oOJ9z
         xB2XKiuhX6kbbImNW81Onzot1LCNQ3P5k9MO/kShNWfsRtWg2ZodEQdfWmklcKkqt354
         SxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4aDyFvrxlFwPOgnkxkIlU3KeNadi1hrIbCCSRD9xSSc=;
        b=Qel2M85jETkYwtwS4vOzUEEYst9LFV2RaDBgthLJc8MBJYBvbQhXrHcPtGv8mCq75r
         uqFtgYDL9B72lbDJaEwP9hofQF2aCLvunNljT55ZSvetAkmU/GhrYmgOtUhAOPlIFB8x
         +bTVP1d3ot5ewmwRIHsLLrGjlZjT8s9OY9cZesBHQpyafopYPdAA2ky32Ib82rCOkE6p
         T+wOuZ8uEVHaHVvq63pPc+qKPVc9/77UQ/aky2F3Zfb+4jb6E2dk/MCNSXCO4/Uehyes
         QZR5VqCh+ijZPYumBpLqpt0plhrU2cQx6CtvGZYCapymPjkaQ+bzhr8+qBhLZ90TB2Az
         mXEw==
X-Gm-Message-State: AOAM5320OLECRPR02fVxJ0XYlh8K57tnq1B495NYTp9QtAFLRPyOAonr
        zEk9KU7Vy84rGvqoFB6c3+c1RSOL8j9slJDQ27MwrVhJv/LpAOHLmffbEDCFcjKK+yRHcGqeYwx
        t/bWES661mFfuj/GnRQORdZzrtyS7z3F1L0zQPOundnLXzsE05JiOLxS8dYRkG0M=
X-Google-Smtp-Source: ABdhPJwmhURii809YCjVm28/KNSwi4P3CmWOGzFj0fBc202yAjKSbR3hkxDL3AqrZOdTdClXsq/E8FCFh6Qdlg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:1042:b029:112:6ce1:667 with SMTP
 id f2-20020a1709031042b02901126ce10667mr1449831plc.44.1623373830056; Thu, 10
 Jun 2021 18:10:30 -0700 (PDT)
Date:   Thu, 10 Jun 2021 18:10:18 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 4/6] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com, vkuznets@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move GUEST_ASSERT_EQ to a common header, kvm_util.h, for other
architectures and tests to use. Also modify __GUEST_ASSERT so it can be
reused to implement GUEST_ASSERT_EQ.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 22 ++++++++++---------
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  9 --------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index beb76d6deaa9..ce49e22843d8 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -368,26 +368,28 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
-#define __GUEST_ASSERT(_condition, _nargs, _args...) do {	\
-	if (!(_condition))					\
-		ucall(UCALL_ABORT, 2 + _nargs,			\
-			"Failed guest assert: "			\
-			#_condition, __LINE__, _args);		\
+#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
+	if (!(_condition))                                              \
+		ucall(UCALL_ABORT, 2 + _nargs,                          \
+			"Failed guest assert: "                         \
+			_condstr, __LINE__, _args);                     \
 } while (0)
 
 #define GUEST_ASSERT(_condition) \
-	__GUEST_ASSERT((_condition), 0, 0)
+	__GUEST_ASSERT(_condition, #_condition, 0, 0)
 
 #define GUEST_ASSERT_1(_condition, arg1) \
-	__GUEST_ASSERT((_condition), 1, (arg1))
+	__GUEST_ASSERT(_condition, #_condition, 1, (arg1))
 
 #define GUEST_ASSERT_2(_condition, arg1, arg2) \
-	__GUEST_ASSERT((_condition), 2, (arg1), (arg2))
+	__GUEST_ASSERT(_condition, #_condition, 2, (arg1), (arg2))
 
 #define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
-	__GUEST_ASSERT((_condition), 3, (arg1), (arg2), (arg3))
+	__GUEST_ASSERT(_condition, #_condition, 3, (arg1), (arg2), (arg3))
 
 #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
-	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
+	__GUEST_ASSERT(_condition, #_condition, 4, (arg1), (arg2), (arg3), (arg4))
+
+#define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
 
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
2.32.0.272.g935e593368-goog

