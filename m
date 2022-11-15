Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB08D62A06D
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 18:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiKOReA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 12:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiKORd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 12:33:57 -0500
Received: from mail-oa1-x4a.google.com (mail-oa1-x4a.google.com [IPv6:2001:4860:4864:20::4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993452AC5
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:33:56 -0800 (PST)
Received: by mail-oa1-x4a.google.com with SMTP id 586e51a60fabf-13cc24bcecbso7003898fac.14
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VgjAyCYxfYSznAKHI0Sghitn9sjteqOiyCbyWAmSn+g=;
        b=UsLSGwQxfkxxl8w5uCBrXq2sq5cn6Cn5PavDDq/3xwTIOU5dPbTlfzNqkcZjrQYZtI
         EeMbk/Cu4GZk8tditbs/RuOf2BX1sSDN/skRB44oZtMH1Xerz5QPFy8kJKxG/tGZVm5k
         jarUs82hpIRyj3WzAdbCbZapV5uStHDSj/8LuzN+x5N6wGpjEQsemH64qjwWZI9kYj8z
         JUlvOUl2pBqpZRRxc43nCQ1dmeT5EtmbRJAJ8IwtWKptKUDSHP2vGOahcicb31StE04N
         kLzEhl12T61EbG4FViRiixbtbQrXKX4wPOcB9J1qytv2guqV32xwHEDafYpXD1Vt2rXd
         dflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgjAyCYxfYSznAKHI0Sghitn9sjteqOiyCbyWAmSn+g=;
        b=8GIYE1Ao0vjCrPqO5Z459oawe3msfcFxPtMCS+hsfCjCBkKNUZL7VANAaVkBeu/ypf
         y7HHUDh+T81GP4ES+pL/QTv0YpG7tBgNZwYAqv2K0UMV21nDSMBdUzVf0S/67spikym9
         n0CkOg+FdyE3p3afn7Mdld0M0FlZhkAo5juw8/XgeRLlGfHZaHWIAzI1y5yR8ZgedAvZ
         A9x1chc9rCEI0zFn5LjzIwQnIjcdefmeWsuPelLgzxFw3VmG1P8dLiABhun+yOUIwfs1
         CfGLtLbN8QRlwXNw7eq8uZDZOhI2FwSyCnUs913mH1kJ8jiH3B40JCYRxu6P07kBHsSd
         9PQA==
X-Gm-Message-State: ANoB5pnin/Eebk3Q4tXC0+v29RQQ9YchGMM8+IhpWpINobHyW8zs0vK+
        TH+3h2uvYtreSm5ma82cSoos1KscoO2gEkjez6Q6zYXITbqSIzRsrvPryLMfq7lFfmvfi13o6CG
        4pRaqtP2jOZUf+u5WL3gDDj1EziDonW8K9FHdNJJp0kAbIIqt9AN6LqmgjDvkOVQGVS/GBtA=
X-Google-Smtp-Source: AA0mqf7qMBcywdk6VjSUeeeGCovbU3tisROib/ECCHQoIFVpdXv+L9Dv4jLNcYXdeLfthnRQqXzpPfbKyWiWKj4YhQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6870:f209:b0:13b:a70a:9302 with
 SMTP id t9-20020a056870f20900b0013ba70a9302mr1759461oao.221.1668533634982;
 Tue, 15 Nov 2022 09:33:54 -0800 (PST)
Date:   Tue, 15 Nov 2022 17:32:57 +0000
In-Reply-To: <20221115173258.2530923-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221115173258.2530923-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115173258.2530923-3-coltonlewis@google.com>
Subject: [PATCH 2/3] KVM: selftests: Collect memory access latency samples
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, bgardon@google.com, oupton@google.com,
        ricarkol@google.com, Colton Lewis <coltonlewis@google.com>
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

Collect memory access latency measured in clock cycles.

This introduces a dependency on the timers for ARM and x86. No other
architectures are implemented and their samples will all be 0.

Because keeping all samples is impractical due to the space required
in some cases (pooled memory w/ 64 vcpus would be 64 GB/vcpu * 64
vcpus * 250,000 samples/GB * 8 bytes/sample ~ 8 Gb extra memory just
for samples), resevior sampling is used to only keep a small number of
samples per vcpu (1000 samples in this patch).

Resevoir sampling means despite keeping only a small number of
samples, each sample has an equal chance of making it to the
resevoir. Simple proofs of this can be found online. This makes the
resevoir a good representation of the distribution of samples and
enables calculation of reasonably accurate percentiles.

All samples are stored in a statically allocated flat array for ease
of combining them later. Samples are stored at an offset in this array
calculated by the vcpu index (so vcpu 5 sample 10 would be stored at
address sample_times + 5 * vcpu_idx + 10).

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/lib/perf_test_util.c        | 34 +++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index a48904b64e19..0311da76bae0 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -4,6 +4,9 @@
  */
 #include <inttypes.h>
 
+#if defined(__aarch64__)
+#include "aarch64/arch_timer.h"
+#endif
 #include "kvm_util.h"
 #include "perf_test_util.h"
 #include "processor.h"
@@ -44,6 +47,18 @@ static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 /* Store all samples in a flat array so they can be easily sorted later. */
 uint64_t latency_samples[SAMPLE_CAPACITY];
 
+static uint64_t perf_test_timer_read(void)
+{
+#if defined(__aarch64__)
+	return timer_get_cntct(VIRTUAL);
+#elif defined(__x86_64__)
+	return rdtsc();
+#else
+#warn __func__ " is not implemented for this architecture, will return 0"
+	return 0;
+#endif
+}
+
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
@@ -59,6 +74,10 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	int i;
 	struct guest_random_state rand_state =
 		new_guest_random_state(pta->random_seed + vcpu_idx);
+	uint64_t *latency_samples_offset = latency_samples + SAMPLES_PER_VCPU * vcpu_idx;
+	uint64_t count_before;
+	uint64_t count_after;
+	uint32_t maybe_sample;
 
 	gva = vcpu_args->gva;
 	pages = vcpu_args->pages;
@@ -75,10 +94,21 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 
 			addr = gva + (page * pta->guest_page_size);
 
-			if (guest_random_u32(&rand_state) % 100 < pta->write_percent)
+			if (guest_random_u32(&rand_state) % 100 < pta->write_percent) {
+				count_before = perf_test_timer_read();
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
-			else
+				count_after = perf_test_timer_read();
+			} else {
+				count_before = perf_test_timer_read();
 				READ_ONCE(*(uint64_t *)addr);
+				count_after = perf_test_timer_read();
+			}
+
+			maybe_sample = guest_random_u32(&rand_state) % (i + 1);
+			if (i < SAMPLES_PER_VCPU)
+				latency_samples_offset[i] = count_after - count_before;
+			else if (maybe_sample < SAMPLES_PER_VCPU)
+				latency_samples_offset[maybe_sample] = count_after - count_before;
 		}
 
 		GUEST_SYNC(1);
-- 
2.38.1.431.g37b22c650d-goog

