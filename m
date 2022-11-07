Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBD861FD5D
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiKGSWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiKGSWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:22:36 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91938B56
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:22:33 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-360b9418f64so114390797b3.7
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5F1HQsOyjh1Vv5cVsbFCGWYbBVnWvtObjqi8ChAEuPU=;
        b=f/KDzAG4vBKh8BGHJ0KL8fPOWldM4TTkJMK49wLeo17mFpPO4Ul5YWjHWy0gHdI5rm
         XKIaZHR6Q/H9cnjgk6rs6maGR9yb/yD9kjfYv0O6DtaQV1YQA6V42qD69fuegJuuO/KI
         Djw49FhIenFOlAqqQbkUuL7fIHGjx0BLXYvX6A4JPi1M7ugFkxa2kDmbX+/d5EY/VBxC
         Vfl97x/VFi7eGtnFE6ULq9xP4avtwaCFolzNoZPqCNtB/cGZUcr7p0QvIyM7cDp0Joc7
         /h1jpzQrLIemPnX8X5kdc1nWEs9vkA7yQs4QQ+eV+Kpc+8eASfJz5A3aH+VfnFwt98j1
         oryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5F1HQsOyjh1Vv5cVsbFCGWYbBVnWvtObjqi8ChAEuPU=;
        b=1CGrOzbLOmirwJRBiJE3uFl2nBSeJCxzrhgXdgAGmEbXACU1TQ2JTHDl1R0LtSKG83
         xwH55u98O8YooH7zsA7w9IBRvNsAUiOldWuXmnU71w2Ahx/xAD5tB+nllbOu+t3u4lt8
         s2sVXT+OkOijek8fddTxdkRYS+WVf5odpO0aMbZLRGnFM/VDxf09d13BTn0o0qcPmDbd
         niA27R+KKz18WmSbk6+W9K6e/E6g2MMTDohlu3jOyJXblpHmcHHLyz4u52t61UOmwn36
         i7ACdkkeBu2C+SHSc8/VFafTMQPVKByo1pc5muLjm3QxNAAetgd5nUZf4tX14MXs78fK
         bp2Q==
X-Gm-Message-State: ACrzQf0qwj/ZWPAb5a0c0K+KxNB6fOAdy4W11Qm5BNsCC8VISc2KfS0P
        hso81DQhgAZGX0fR7PdCZ0qcsDjZ+bVoI7KBlKMdHvUiI/zlLGvT+7izEFuzLISr6SRhYbDa99G
        aIEUKEt1sFd5XgW8hsq1G4+8K3PzObvDWkZD+vAl83pHzMlgXXw/QTsejOd+14T/RqPTjmGc=
X-Google-Smtp-Source: AMsMyM6qVecqLuwFkaw/FwMzlo7t65bdAhjD6H5SPJrwztlrCB34FMk7XC9fPLGd6BIO39lthO9t2awEYgSNHoIlVQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:18a:b0:6cc:2d7b:4721 with
 SMTP id t10-20020a056902018a00b006cc2d7b4721mr50282853ybh.12.1667845352839;
 Mon, 07 Nov 2022 10:22:32 -0800 (PST)
Date:   Mon,  7 Nov 2022 18:22:05 +0000
In-Reply-To: <20221107182208.479157-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221107182208.479157-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221107182208.479157-2-coltonlewis@google.com>
Subject: [PATCH v10 1/4] KVM: selftests: implement random number generator for
 guest code
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement random number generator for guest code to randomize parts
of the test, making it less predictable and a more accurate reflection
of reality.

The random number generator chosen is the Park-Miller Linear
Congruential Generator, a fancy name for a basic and well-understood
random number generator entirely sufficient for this purpose.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h |  7 +++++++
 tools/testing/selftests/kvm/lib/test_util.c     | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index befc754ce9b3..9e4f36a1a8b0 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -152,4 +152,11 @@ static inline void *align_ptr_up(void *x, size_t size)
 	return (void *)align_up((unsigned long)x, size);
 }
 
+struct guest_random_state {
+	uint32_t seed;
+};
+
+struct guest_random_state new_guest_random_state(uint32_t seed);
+uint32_t guest_random_u32(struct guest_random_state *state);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 6d23878bbfe1..c4d2749fb2c3 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -17,6 +17,23 @@
 
 #include "test_util.h"
 
+/*
+ * Random number generator that is usable from guest code. This is the
+ * Park-Miller LCG using standard constants.
+ */
+
+struct guest_random_state new_guest_random_state(uint32_t seed)
+{
+	struct guest_random_state s = {.seed = seed};
+	return s;
+}
+
+uint32_t guest_random_u32(struct guest_random_state *state)
+{
+	state->seed = (uint64_t)state->seed * 48271 % ((uint32_t)(1 << 31) - 1);
+	return state->seed;
+}
+
 /*
  * Parses "[0-9]+[kmgt]?".
  */
-- 
2.38.1.431.g37b22c650d-goog

