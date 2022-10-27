Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DA86103F0
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 23:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbiJ0VER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 17:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236152AbiJ0VDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 17:03:18 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE44B05
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:57:02 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id w6-20020a6bd606000000b006bcd951c261so2161488ioa.2
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w+ebisBkWPJ5RfFeeP4pPr1G3UX4W/TiA76RvuNqNLA=;
        b=ZjdvwkrRMlhvSLfD5kKtUE/tigBMjTjznRjvYEOrjPe74SLU7gD59enpZVak2r0hUh
         MsMX4ZmafqeKn6mUz04IxR/7dSsWdSDltuBO12TbxvJNuCPfeEdFOrUmLogJO2mk7Y7J
         jZvpkhNT+WSCa2OwyJd/vJbMuawt0LEJq37ml6T7qxVUZpwE5lf+df7rA2PWsoVOymi8
         vwfpOxl7V54EFvVDyDINGGeeXLUxprwDcDLfon3ljV7rDQFCt0AUQHEsRygcEYQqnvf3
         C/BOiSUZ9LyzRFPmgkzaeZdj0beVS16Ur+0Jgm28q6Kw0JuYXVZpvFBpx0Au/TxJUAvg
         o4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+ebisBkWPJ5RfFeeP4pPr1G3UX4W/TiA76RvuNqNLA=;
        b=wft5VWL45XkLU7G43TLgmwOEMo8dCMhFTHela1fOqsYLyu6Zf+ryAgVu9uX7oI5mgP
         R9UdnwUVRdEFgcTfecyuGFs+ucs1PS1cd/ur/wWlcmaH61xgjZQO/kwMc3VFqB6nyElp
         LfU1W1cMTU3Dqftvudu7bNUhb4m6YujjaMoUi1qp90yFUXCP1CB+qvfC2ORSyIYs4OPB
         CbI1ymaE2egOJBZ+4vml6sfLPJ6WbDhgk57IvUEKSu2nMaYAbTDLR3xYLhmXnfoa7AsI
         F8CkT+KgY4AHCml5k8eFmpMZwN7NX6JOoZvzwpxqX4zml+7dOEQJwGTN5s273WhmFHtS
         3ePw==
X-Gm-Message-State: ACrzQf0VAbbhqgsD2awHzMfmFzz00gYQ+urfj170RavbYTCRPCnq3jyg
        SliFcAVh2jYiJwSToPU0znIxKRiZcnE2DJenGX9G7sgE6C6kJfUu29ZMKnPihAxMX6qRRuxi4L3
        jDRwSitoeW0XC/e7uJtyx60utRV01CFanAVJARdmi1SNJBpOSZEWt90JN4Au6Hvpvw3+Ty1c=
X-Google-Smtp-Source: AMsMyM6e8iG0MQgrjrHwVUKo7RGkDRhmmxtlk2KKCHiu0t8FXwxHM/AhkgoQ5WRtfEbSfNLCE+FbUXwnWDbqIwgVKA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1561:b0:300:3d37:6296 with
 SMTP id k1-20020a056e02156100b003003d376296mr9830290ilu.233.1666904221444;
 Thu, 27 Oct 2022 13:57:01 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:56:28 +0000
In-Reply-To: <20221027205631.340339-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221027205631.340339-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027205631.340339-2-coltonlewis@google.com>
Subject: [PATCH v8 1/4] KVM: selftests: implement random number generator for
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
random number generator entirely sufficient for this purpose. Each
vCPU calculates its own seed by adding its index to the seed provided.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
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
2.38.1.273.g43a17bfeac-goog

