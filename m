Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E7137F070
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 02:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbhEMAiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 20:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346565AbhEMAgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 20:36:36 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F19CC061373
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 17:28:10 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id n46-20020a056a000d6eb029028e9efbc4a7so16119832pfv.3
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 17:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zxsHwg8ACVNG0gj0HNIoWiAKTaI+aSlQScKBGdMUvH4=;
        b=Unpjke8IQLXkNhIYkxb+SPawwcggozVP0BB7RB6uACCF+nrypeohw8OfYSJSNtlkQU
         JAXsB+ex5idQoDtTDvElLM6Ld1LCY6KmYH78OKz6/UCkNFb3r7xNmiIlHdH7TZWOyFLf
         mnoblhbaqCH9aekNRo+kF0/nFsS8cp/1jafEd6sTbm+shshgc6M/lUubgF7kwzmxg3BV
         Wa7i7w01FM1wPf1doS2Y53EFmSO8Q5kJ8ROKHMjVuVf+iH7tRoP9dYzjC8sogy+YW1s9
         LmwJm0KGZQn0YO8xB2GTlYKHzLN6vCVKLy/GlGj66aokbRSvYYRrIfR5bpTR0YcmbCYO
         RwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zxsHwg8ACVNG0gj0HNIoWiAKTaI+aSlQScKBGdMUvH4=;
        b=JIZgqnaz+7XpFgDufhV4yXLe6ZmOJwS5RJL2wL6eF2bLB+pEf4mDflENYncebLqrQB
         ZLskWTHyFyz6XV2UhS3Dm0TUwo8RA4c6NZbiGS1v57CA9aMds3uIm6oHAFjLdpAyaum6
         wO2OI94qSrdJYf1uWzA19noDc8v1Gk+wwO3CXl5CPx+5lF6uZfVJDF+OlF6CyO51EqvR
         JttRyv96Fts+6HajYuCNvTjyes10hKD4vEstuydHk0Xw93cdA0KBdf0q8LwGscKMkAdb
         aGTJYz/+H/Ly+xlsj5EFD+yuMWfZTddLJHg+MhlBrfWZItab2YQrvjwfpQDov4srUkwV
         2GUg==
X-Gm-Message-State: AOAM533EykNCI5gPepdkkNZvTEgJXuK3AMbI/Y0GpE7vK0/ZUsJnyPdK
        yaHZniCorEQ/JYtJDP327ZOEOHpysFwhgMECcqjSVqxMzOmJcF8O+pnOcI9LFQib5HIrfT+/vgy
        4ViN+r0IctB2Jk5T9EOaOO+juvbqwwFQqEMClbM2GdPi6Bh4VjL8nuqAZ9357j/0=
X-Google-Smtp-Source: ABdhPJzFm4lOfQYwC9X/y1at01TOWZJErvamhpunfM0O+KbGLvK9yj0IacinPrLxCSbfLxWTUd9LxBKe7NshAQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:bf0c:: with SMTP id
 c12mr40963575pjs.206.1620865689672; Wed, 12 May 2021 17:28:09 -0700 (PDT)
Date:   Wed, 12 May 2021 17:28:00 -0700
In-Reply-To: <20210513002802.3671838-1-ricarkol@google.com>
Message-Id: <20210513002802.3671838-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210513002802.3671838-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
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
architectures and tests to use. Also modify __GUEST_ASSERT so it can be
reused to implement GUEST_ASSERT_EQ.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 22 ++++++++++---------
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  9 --------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 7880929ea548..fb2b8964f2ca 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -366,26 +366,28 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
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
2.31.1.607.g51e8a6a459-goog

