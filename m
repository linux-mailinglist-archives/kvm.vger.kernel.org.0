Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE9162A06C
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 18:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiKORd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 12:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiKORd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 12:33:57 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CCE631D
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:33:56 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id j7-20020a056e02154700b003025b3c0ea3so4750974ilu.10
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=smrecohOmbo6ykZMskRiuETFcF02IbrRITp2mzypa4E=;
        b=U4pO1VbXzfdLK/PwQWM9KfGv0ExhhSaEIyHK29/z+fgXAoQKanQj/Z1+2topoa7p+j
         UYtpW0yMA4ObmIhgK72HMM1H/Cpwhakw7e96ufRiMKrCRxxHqYhNp0Nk/yeRAAbnUhF6
         Rf0S3oxn+RaQZ8GVrCBiNYltLUNsFvbWpDlo42h1C4l7f9YFfNdDIpEz5NY/dl3IYqwv
         G2DboPrlTRg21nAwczSuE4O886CT+fytbxVeinDJSZ0MPtTQeiysCzubi6IerZLpAZMl
         CbEnuPfYid1Ijfxvgzxv7FF18FReK0do+GS7QvIxe9wZ9AI/sN1u6zp6w72g6VbPuJLC
         4EkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=smrecohOmbo6ykZMskRiuETFcF02IbrRITp2mzypa4E=;
        b=2hDAEKmDZaZmT9Kk4x7Bht6RMcofoVAKMuw0b5GpFn1hqgfvxYT0YSWtrRcwSIZdEY
         OeztGPUNMPahgpLG4Za/6juGDuJCmxws5WUpL10EuxCZMQ3AXPwgLrxCqr9uEaJRguJ1
         5v+gUKy4zx0i+YGgl6g258UBJK9tMYkVmMueiBj5JuVMDtrKaw2CYsKa0WkDkXCyjJPR
         PMRg7QnJbG5LulzU+AH3juxBqJ3iX6C06/ZebW66P4jeUtO0v23K6/ZUTHwlymoe1bW+
         ER4YCKilToGLvu2SwXpcv7CTCZ30lX1qWFRL2FRX++eQ8aVOP1FAY4Z+AnYQll8JuoX7
         0dqw==
X-Gm-Message-State: ANoB5pmbaNQnr999BLYHW38qMLgBz6AgWt9RFcJsN2IHLlwPNs3GVTMM
        7JHGhoKKaccGYlt9YBkuIVNi3yeLfeYi/dG9Sn/pF0+p9ToRV0L9JY+cWyVXaoPIGi9yfvAAUyu
        uxJy2Ux6Z01U0CjXsLdYAU3tPwcaXuTYmuuvCix44OE/+ZZspXkwBLKSMbZIwP2+dm/YT3fk=
X-Google-Smtp-Source: AA0mqf6mJuXACvtGH9CZFxpZ1YzE6molLSzGdHognbVEtsOpnMPGngp5UNdj0wNimyGt8IgDjEVfGSNMOu0wpcOGkg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:b691:0:b0:375:577d:688b with SMTP
 id i17-20020a02b691000000b00375577d688bmr8666992jam.255.1668533636070; Tue,
 15 Nov 2022 09:33:56 -0800 (PST)
Date:   Tue, 15 Nov 2022 17:32:58 +0000
In-Reply-To: <20221115173258.2530923-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221115173258.2530923-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115173258.2530923-4-coltonlewis@google.com>
Subject: [PATCH 3/3] KVM: selftests: Print summary stats of memory latency distribution
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

Print summary stats of the memory latency distribution in
nanoseconds. For every iteration, this prints the minimum, the
maximum, and the 50th, 90th, and 99th percentiles.

Stats are calculated by sorting the samples taken from all vcpus and
picking from the index corresponding with each percentile.

The conversion to nanoseconds needs the frequency of the Intel
timestamp counter, which is estimated by reading the counter before
and after sleeping for 1 second. This is not a pretty trick, but it
also exists in vmx_nested_tsc_scaling_test.c

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       |  2 +
 .../selftests/kvm/include/perf_test_util.h    |  2 +
 .../selftests/kvm/lib/perf_test_util.c        | 62 +++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 202f38a72851..2bc066bba460 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -274,6 +274,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	ts_diff = timespec_elapsed(start);
 	pr_info("Populate memory time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
+	perf_test_print_percentiles(vm, nr_vcpus);
 
 	/* Enable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
@@ -304,6 +305,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vcpu_dirty_total = timespec_add(vcpu_dirty_total, ts_diff);
 		pr_info("Iteration %d dirty memory time: %ld.%.9lds\n",
 			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
+		perf_test_print_percentiles(vm, nr_vcpus);
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
 		get_dirty_log(vm, bitmaps, p->slots);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 3d0b75ea866a..ca378c262f12 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -47,6 +47,8 @@ struct perf_test_args {
 
 extern struct perf_test_args perf_test_args;
 
+void perf_test_print_percentiles(struct kvm_vm *vm, int nr_vcpus);
+
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src,
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 0311da76bae0..927d22421f7c 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -115,6 +115,68 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	}
 }
 
+#if defined(__x86_64__)
+/* This could be determined with the right sequence of cpuid
+ * instructions, but that's oddly complicated.
+ */
+static uint64_t perf_test_intel_timer_frequency(void)
+{
+	uint64_t count_before;
+	uint64_t count_after;
+	uint64_t measured_freq;
+	uint64_t adjusted_freq;
+
+	count_before = perf_test_timer_read();
+	sleep(1);
+	count_after = perf_test_timer_read();
+
+	/* Using 1 second implies our units are in Hz already. */
+	measured_freq = count_after - count_before;
+	/* Truncate to the nearest MHz. Clock frequencies are round numbers. */
+	adjusted_freq = measured_freq / 1000000 * 1000000;
+
+	return adjusted_freq;
+}
+#endif
+
+static double perf_test_cycles_to_ns(double cycles)
+{
+#if defined(__aarch64__)
+	return cycles * (1e9 / timer_get_cntfrq());
+#elif defined(__x86_64__)
+	static uint64_t timer_frequency;
+
+	if (timer_frequency == 0)
+		timer_frequency = perf_test_intel_timer_frequency();
+
+	return cycles * (1e9 / timer_frequency);
+#else
+#warn __func__ " is not implemented for this architecture, will return 0"
+	return 0.0;
+#endif
+}
+
+/* compare function for qsort */
+static int perf_test_qcmp(const void *a, const void *b)
+{
+	return *(int *)a - *(int *)b;
+}
+
+void perf_test_print_percentiles(struct kvm_vm *vm, int nr_vcpus)
+{
+	uint64_t n_samples = nr_vcpus * SAMPLES_PER_VCPU;
+
+	sync_global_from_guest(vm, latency_samples);
+	qsort(latency_samples, n_samples, sizeof(uint64_t), &perf_test_qcmp);
+
+	pr_info("Latency distribution (ns) = min:%6.0lf, 50th:%6.0lf, 90th:%6.0lf, 99th:%6.0lf, max:%6.0lf\n",
+		perf_test_cycles_to_ns((double)latency_samples[0]),
+		perf_test_cycles_to_ns((double)latency_samples[n_samples / 2]),
+		perf_test_cycles_to_ns((double)latency_samples[n_samples * 9 / 10]),
+		perf_test_cycles_to_ns((double)latency_samples[n_samples * 99 / 100]),
+		perf_test_cycles_to_ns((double)latency_samples[n_samples - 1]));
+}
+
 void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 			   struct kvm_vcpu *vcpus[],
 			   uint64_t vcpu_memory_bytes,
-- 
2.38.1.431.g37b22c650d-goog

