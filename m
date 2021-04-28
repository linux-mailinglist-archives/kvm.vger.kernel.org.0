Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A5736D5A5
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhD1KTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbhD1KTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 06:19:35 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84333C06138B
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:50 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id g65so4306726wmg.2
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W/65gl/q8IPHxxfmkIEqzGwlIffS1aBvU9xDbEnZyHM=;
        b=SSrrTtwZJ02Zr0JA6NRj0GmP0uyFPOUSFabhokoV6Sy5GNCyllTC4VWQMLE81igmUe
         Wh0Vi6utYveAA/fpekiI7G8ty768Nqo3K2LOp81FzggyzgrXoRp1v5KCSAMdAMjCuyuX
         r9IM1GiXmva9cV/s22qi9+5GmGGbvx5LX8EDykKoW42J+NlR2k9rKWnZXSzadxTkzeUd
         8J/bswhnJIBlc10SW99J5bPaBrR8JUigyAKh1GY1S03X1swxtLM4p+pB0ZXIwfxYh19v
         CSzoeIhOjW5U/V0rLWA1tjAH0VlGLBK6V5mrPM0R1DcsKn2suEmABcoaH6S5DiU8qNgM
         REDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W/65gl/q8IPHxxfmkIEqzGwlIffS1aBvU9xDbEnZyHM=;
        b=EyXLYwaApc/BnKMcdUWfNG7cEoLTuikEDK4l8CkIS5S91eH8/0nmGX1q/WMGEXmagR
         V6nhu6neKm66JKU8OTuFMFOH/E0MC6pf3qvsN8q521hz7Ya0A2YaC10J72yhVvjU8aIX
         m4t5VWCAKn7B8iLAGLXVfp0HNjanFoY82fVHAndBVe1i/QdSxuKAOkjA7Zmmvf97SxFB
         zZgQ59f5PY4CvBgJXKI980wfRhmMCWs0nwQqzMbk3wYI6vvfku6CJ1vHX8shwzoX6IhI
         9RCArz06WaakPnYdVm8lzD8kZoGw1/HghkKVBkBgD6IBOSqGCZOdX+e5yf8ZhJsqy/H9
         39Zg==
X-Gm-Message-State: AOAM530nmbKpqhr30SMa18rGysyfcDLlPf22vNTcN84SqjrCtPkAYrxV
        gPQxEFKTUr+a6Bff3UXfxQ2f6g==
X-Google-Smtp-Source: ABdhPJxRO3MjPBAuuf7/5yeRHIOMTjCLbzPgeFWy3MG9Ge5F6gbUkBS3K7ic1Vpc5z70bIjpSShKyA==
X-Received: by 2002:a7b:cd85:: with SMTP id y5mr3586309wmj.93.1619605129193;
        Wed, 28 Apr 2021 03:18:49 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id b14sm7950544wrf.75.2021.04.28.03.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 27D401FF87;
        Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test into KVM and TCG variants
Date:   Wed, 28 Apr 2021 11:18:41 +0100
Message-Id: <20210428101844.22656-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428101844.22656-1-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few of the its-trigger tests rely on IMPDEF behaviour where caches
aren't flushed before invall events. However TCG emulation doesn't
model any invall behaviour and as we can't probe for it we need to be
told. Split the test into a KVM and TCG variant and skip the invall
tests when under TCG.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Shashi Mallela <shashi.mallela@linaro.org>
---
 arm/gic.c         | 60 +++++++++++++++++++++++++++--------------------
 arm/unittests.cfg | 11 ++++++++-
 2 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 98135ef..96a329d 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -36,6 +36,7 @@ static struct gic *gic;
 static int acked[NR_CPUS], spurious[NR_CPUS];
 static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
 static cpumask_t ready;
+static bool under_tcg;
 
 static void nr_cpu_check(int nr)
 {
@@ -734,32 +735,38 @@ static void test_its_trigger(void)
 	/*
 	 * re-enable the LPI but willingly do not call invall
 	 * so the change in config is not taken into account.
-	 * The LPI should not hit
+	 * The LPI should not hit. This does however depend on
+	 * implementation defined behaviour - under QEMU TCG emulation
+	 * it can quite correctly process the event directly.
 	 */
-	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
-	stats_reset();
-	cpumask_clear(&mask);
-	its_send_int(dev2, 20);
-	wait_for_interrupts(&mask);
-	report(check_acked(&mask, -1, -1),
-			"dev2/eventid=20 still does not trigger any LPI");
-
-	/* Now call the invall and check the LPI hits */
-	stats_reset();
-	cpumask_clear(&mask);
-	cpumask_set_cpu(3, &mask);
-	its_send_invall(col3);
-	wait_for_interrupts(&mask);
-	report(check_acked(&mask, 0, 8195),
-			"dev2/eventid=20 pending LPI is received");
-
-	stats_reset();
-	cpumask_clear(&mask);
-	cpumask_set_cpu(3, &mask);
-	its_send_int(dev2, 20);
-	wait_for_interrupts(&mask);
-	report(check_acked(&mask, 0, 8195),
-			"dev2/eventid=20 now triggers an LPI");
+	if (under_tcg) {
+		report_skip("checking LPI triggers without invall");
+	} else {
+		gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
+		stats_reset();
+		cpumask_clear(&mask);
+		its_send_int(dev2, 20);
+		wait_for_interrupts(&mask);
+		report(check_acked(&mask, -1, -1),
+		       "dev2/eventid=20 still does not trigger any LPI");
+
+		/* Now call the invall and check the LPI hits */
+		stats_reset();
+		cpumask_clear(&mask);
+		cpumask_set_cpu(3, &mask);
+		its_send_invall(col3);
+		wait_for_interrupts(&mask);
+		report(check_acked(&mask, 0, 8195),
+		       "dev2/eventid=20 pending LPI is received");
+
+		stats_reset();
+		cpumask_clear(&mask);
+		cpumask_set_cpu(3, &mask);
+		its_send_int(dev2, 20);
+		wait_for_interrupts(&mask);
+		report(check_acked(&mask, 0, 8195),
+		       "dev2/eventid=20 now triggers an LPI");
+	}
 
 	report_prefix_pop();
 
@@ -981,6 +988,9 @@ int main(int argc, char **argv)
 	if (argc < 2)
 		report_abort("no test specified");
 
+	if (argc == 3 && strcmp(argv[2], "tcg") == 0)
+		under_tcg = true;
+
 	if (strcmp(argv[1], "ipi") == 0) {
 		report_prefix_push(argv[1]);
 		nr_cpu_check(2);
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index f776b66..c72dc34 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -184,13 +184,22 @@ extra_params = -machine gic-version=3 -append 'its-introspection'
 groups = its
 arch = arm64
 
-[its-trigger]
+[its-trigger-kvm]
 file = gic.flat
 smp = $MAX_SMP
+accel = kvm
 extra_params = -machine gic-version=3 -append 'its-trigger'
 groups = its
 arch = arm64
 
+[its-trigger-tcg]
+file = gic.flat
+smp = $MAX_SMP
+accel = tcg
+extra_params = -machine gic-version=3 -append 'its-trigger tcg'
+groups = its
+arch = arm64
+
 [its-migration]
 file = gic.flat
 smp = $MAX_SMP
-- 
2.20.1

