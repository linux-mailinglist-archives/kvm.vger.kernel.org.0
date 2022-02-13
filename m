Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7684B3A1C
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 09:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiBMI1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Feb 2022 03:27:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiBMI1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Feb 2022 03:27:33 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F775E77A
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 00:27:28 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id 9-20020a170902c20900b0014dc0faf52fso4841457pll.14
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 00:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=az/IM13vdigg1dA8yh55P3qX2v782bmFgi/cg6GI8pI=;
        b=I9NkeOuGpnBJTo8lfQpRM9LciV+cZWVgIapqj1ZIB77XacEHXTGODJksw8cK5upFX4
         mwqwkrVAVueAHs70s+01H3LcaP+baB0NFczd3ozsxXogIWwbyIWMr2dX0PCreqEao2L8
         nIYvBBRO1bVfvAMgRnnCaEKbnpahCGRGYTr9MnQmYUlM7DAqtWpX8+jokgQyvQWmxNWX
         mrZJwUYfdPW64WrZGk75wsjm3zcg2InHb8QEk/W/48GlDBm3YPc3mshpCejW5EtC5iis
         IhJWPgvfZihdqTRwNYK69/MXSsfuh55qR1hRaz1wvnBtRI1l4YuLjZCx5EqOaEGKtA8h
         Ikrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=az/IM13vdigg1dA8yh55P3qX2v782bmFgi/cg6GI8pI=;
        b=rqRzT0LJiDy7NA9GyGifNc/3+B1FpukDrvfU0Sa2KnQdHTKDOcPKB9ksNo3GcMqRf4
         xMiS6dCoQ9xCLfEbpbDE2B6ZVSWpRpSPl3MeBPMhzmKPZwVc/FCfSa5xiU0t6Oe+yx3S
         KlnQ38b5rracY7/dgDImqNyEJ9Bqzd1YgCtoZZahlVUWckkC8Ui90cpqCnBZ817GJ9cx
         KAJ/vM5zCocCXPGTJHGuIhIh8qRsnzPpYWLAgJKI3HaoiODyeg12QZ1fqd/gDkg3QowO
         ubJFutuuk5m8QUziFplEzDOykKqUedKQ67vZw+nX9yc/oxqU4crLD/KFeTz/MJYHfFD3
         4rXQ==
X-Gm-Message-State: AOAM532RYfr66xThC98/UbX5qAFxT2oIkytDc+apuwJzPDeofccqU31r
        hnfCiZwCneb5Sj+Jc5tUmXa/RoawBzVv1m9EKxI8DV9bT4ovv5DrzNo9thZjTwPuVRtDkEFCOAk
        t4ByYb3QDw6Ad9iloXkMmq91YwTnrAPz+9sgblwcReqAehY1cBtVTDW/MzuBAcBs=
X-Google-Smtp-Source: ABdhPJzeQIA6OPUbSCIbupFhvTwztOmzItdrGn6PzyM+UzpYH+vu9TzQ8WBzZZB8KUnRIJncudFge0M+S58rxA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90b:507:: with SMTP id
 r7mr8645135pjz.78.1644740847265; Sun, 13 Feb 2022 00:27:27 -0800 (PST)
Date:   Sun, 13 Feb 2022 00:27:14 -0800
Message-Id: <20220213082714.636061-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [kvm-unit-tests PATCH] x86/pmu: Set appropriate expectations for
 reference cycles
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Jacob Xu <jacobhxu@gmail.com>
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

Per the SDM, reference cycles (as a general purpose event) are
currently implemented using the core crystal clock, TSC, or bus
clock. Therefore, it's unreasonable to expect reference cycles for the
measured loop to fall within some constant multiples of the number of
loop iterations, unless those bounds are set so wide as to be
pointless.

The bounds initially established when this test was written were
broadened in commit 4779578b24b3 ("make PMU test to pass on more cpu
types"), but even the new bounds are too narrow to accommodate a
2.6GHz Ice Lake, with the TSC frequency at 104 times the reference
cycle (for this implementation, the core crystal clock) frequency.

Restore the initial (tighter) bounds, calculate the ratio of TSC
frequency to reference cycle frequency, and then scale the bounds
accordingly.

Tested on several generations of Xeon E5 parts: Ice Lake, Cascade
Lake, Skylake, Broadwell, and Haswell.

Opportunistically fixed a spelling error and a commented-out printf
format string.

Fixes: 4779578b24b3 ("make PMU test to pass on more cpu types")
Reported-by: Jacob Xu <jacobhxu@gmail.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/pmu.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 92206ad0548f..f2e4d44d3a97 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -86,8 +86,8 @@ struct pmu_event {
 } gp_events[] = {
 	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
-	{"ref cycles", 0x013c, 0.1*N, 30*N},
-	{"llc refference", 0x4f2e, 1, 2*N},
+	{"ref cycles", 0x013c, 1*N, 30*N},
+	{"llc references", 0x4f2e, 1, 2*N},
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
 	{"branch misses", 0x00c5, 0, 0.1*N},
@@ -223,7 +223,7 @@ static void measure(pmu_counter_t *evt, int count)
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
-	// printf("%lld >= %lld <= %lld\n", e->min, count, e->max);
+	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
 	return count >= e->min  && count <= e->max;
 
 }
@@ -605,6 +605,54 @@ static void  check_gp_counters_write_width(void)
 	}
 }
 
+/*
+ * Per the SDM, reference cycles are currently implemented using the
+ * core crystal clock, TSC, or bus clock. Calibrate to the TSC
+ * frequency to set reasonable expectations.
+ */
+static void set_ref_cycle_expectations(void)
+{
+	pmu_counter_t cnt = {
+		.ctr = MSR_IA32_PERFCTR0,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[2].unit_sel,
+		.count = 0,
+	};
+	uint64_t tsc_delta;
+	uint64_t t0, t1, t2, t3;
+
+	if (!eax.split.num_counters || (ebx.full & (1 << 2)))
+		return;
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	t0 = fenced_rdtsc();
+	start_event(&cnt);
+	t1 = fenced_rdtsc();
+
+	/*
+	 * This loop has to run long enough to dominate the VM-exit
+	 * costs for playing with the PMU MSRs on start and stop.
+	 *
+	 * On a 2.6GHz Ice Lake, with the TSC frequency at 104 times
+	 * the core crystal clock, this function calculated a guest
+	 * TSC : ref cycles ratio of around 105 with ECX initialized
+	 * to one billion.
+	 */
+	asm volatile("loop ." : "+c"((int){1000000000ull}));
+
+	t2 = fenced_rdtsc();
+	stop_event(&cnt);
+	t3 = fenced_rdtsc();
+
+	tsc_delta = ((t2 - t1) + (t3 - t0)) / 2;
+
+	if (!tsc_delta)
+		return;
+
+	gp_events[2].min = (gp_events[2].min * cnt.count) / tsc_delta;
+	gp_events[2].max = (gp_events[2].max * cnt.count) / tsc_delta;
+}
+
 int main(int ac, char **av)
 {
 	struct cpuid id = cpuid(10);
@@ -627,6 +675,8 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
+	set_ref_cycle_expectations();
+
 	printf("PMU version:         %d\n", eax.split.version_id);
 	printf("GP counters:         %d\n", eax.split.num_counters);
 	printf("GP counter width:    %d\n", eax.split.bit_width);
-- 
2.35.1.265.g69c8d7142f-goog

