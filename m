Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C86166C7
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiKBQAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKBQAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:00:17 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0142A70A
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:00:15 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id 15-20020a056e0220cf00b0030099e75602so11391819ilq.21
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w+ebisBkWPJ5RfFeeP4pPr1G3UX4W/TiA76RvuNqNLA=;
        b=XoYuKuLxkAD2axLD7g3mm5M0/BmoY8FOTvqzKmUp0b/Vvt4kD/ctbK7UHxs875OEP9
         h4aoaZDmPBd8F5BZZp4p8UljOXoHzb79rSy+mGFqwXsiuTZWSA4kKPi24zmuyQMxXx5e
         2hXDKm4K49Ap4mlzzp18Kb+6Hl7KH5QSdN161NtkbIwWKEtHV4Tr6yY/4VuscKO0LEAd
         +9rjF8gw5zjjB5+YPsPVhSXjuyQFxeVivE0YkDeZ4VXeapkCm3+5+BDTnK4h2ksqAerM
         lDJvMLNjzoH9CdQcyqZulou6EOpXV8IOctSbyH9lKs3rCuvRsuV99k/FLda3cNnra5HO
         EXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+ebisBkWPJ5RfFeeP4pPr1G3UX4W/TiA76RvuNqNLA=;
        b=qgYnMhluoY6n3tTU6mSTJqeR7A8xJ7y1d7AEpCSqpgW+EZng5MTGbXZElySSM/gStH
         kNSBmhwrUERCajDCcp3HHLRmWwq2B6O4wp+8USPSaoSlWNAlR9ART2W1Tfkk6XATLIu3
         iQb1JOpcajewOCAOcFdomI5q5oYvEikAXUIWBokXHR938IJdAn3Ta3HHSEOEN8s2YdXD
         /u8pHTymC18SVxTVW6A/AnJmxaQ4NSUD8dHEbrit75RymZwjt8pVfyER6RVd4RedDCjP
         a5i0hICSB8cD/A8roOFOLazeXD4Yd/69wKsNH5EH1kw2uuunhKs/JAIfw3yI+8ybMvGR
         eXuw==
X-Gm-Message-State: ACrzQf2bPB+TXu7QDqpCOlyBazEYzO6bDW+P1hMyeAeoi2j9aYNRQN11
        npl7AA8r/urtdKUCJ/cEo+6uVuwSTwQtCUfGcWQXd925OmpXNyx0iawXayy2wY/56eBigTaSNL0
        LGXNlj9riAieuuh+X3fx9uR5oGd9oWvRMs6KIGAZ8Sj/u70ZlDXUM0NDVbtO52NT2o6EIRHU=
X-Google-Smtp-Source: AMsMyM6zqOL1K//7aXhNXs8rhdxlChQl4VFyUXBU6xR8n3oPjWwm4mVAaWtqrFGQLlraR0U7LQqf9cObPcmop4hg6Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:c3cd:0:b0:6a8:3ca0:dafa with SMTP
 id t196-20020a6bc3cd000000b006a83ca0dafamr16203473iof.193.1667404815211; Wed,
 02 Nov 2022 09:00:15 -0700 (PDT)
Date:   Wed,  2 Nov 2022 16:00:04 +0000
In-Reply-To: <20221102160007.1279193-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221102160007.1279193-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102160007.1279193-2-coltonlewis@google.com>
Subject: [PATCH v9 1/4] KVM: selftests: implement random number generator for
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

