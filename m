Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700CF390797
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 19:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhEYR2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 13:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbhEYR2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 13:28:05 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2E6C06138A
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:35 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o127so17190329wmo.4
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 10:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8vhxbSb0kOGC8+nQM9S+UwSASWSZTJvJYDcePLw1qik=;
        b=DvkmYHVn3HaRgZzPceU2GhR2wTdg+bNlZ8zWdNizKPR5jm/SkWQSY1j8trE6BlsdDQ
         OBsU5vB5YZDLMDteDH80B5XFp14rtd//uQrxUV8pD6J3FPQv2ruiqlq+m/ySrzTYNCK4
         v3XUJkSWiUQikJioCoUPTH58TJV4co8CCV/V/n7xbCMLd611nyRR6FWkN01WytKVXR61
         waIDp54ysmCOksR1TNsGmp2n2Td+0vL+VhAq+LSI0Jt8Kfi2ysCW3/B0yIzF62CS/0wh
         eKc6SeUh8Lv+brC/Ubivypvjpu0AKAYIeSqmmI9wJw2o8iFdKTKoo1K3rwu3lVoRVp2k
         GyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8vhxbSb0kOGC8+nQM9S+UwSASWSZTJvJYDcePLw1qik=;
        b=HYX7Sy7PjYl8SRoXJEBquz3bVcrBt3BWhmEYHzb8RmVjwycitwph9tBLuJw6CJu9Wt
         f0IV/b3esTIaO6o7EkGTyYhx4CixIgjAfAvMHBhkPPbGodNk2k/pc9z7Ori5eT+nZ9nS
         86RfmdqZ0FCtjd7V9l9eKCAa+fAVW0nYxxvsPLeSbC6DyjpNyLZSu1MNpBmTnWWThXYF
         E7NpmIiLf25UBk4FeSB7sUV83ToEILrTg8T6IhfQd2FTzXYZxlMEGHDZ2A1rPQAw6evt
         MPyk95nbN4RcEIqvNTIBOFBfeTSQqFG7c937z4XsZzKNdf9ACQnSTt7Xs1Fn1e6UXgM7
         JlpA==
X-Gm-Message-State: AOAM532JJZIJGJM7LtzSygqkK5w0XdNogfU0nZo8UclYDThx/KQiS+qO
        8FSN4gOEeTelMb+mkep/ydlHUQ==
X-Google-Smtp-Source: ABdhPJwJcS6ubLrQtKSjUB+dF+9hCxd+Me0VaOsHNU0DUOoeSkOw+4jNx+Dkf/HE7m6wlUQVP4fjaw==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr4950802wml.84.1621963594304;
        Tue, 25 May 2021 10:26:34 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id k132sm3533580wma.34.2021.05.25.10.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 10:26:29 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id A4E181FF90;
        Tue, 25 May 2021 18:26:28 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v2 4/4] arm64: split its-migrate-unmapped-collection into KVM and TCG variants
Date:   Tue, 25 May 2021 18:26:28 +0100
Message-Id: <20210525172628.2088-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210525172628.2088-1-alex.bennee@linaro.org>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running the test in TCG we are basically running on bare metal so
don't rely on having a particular kernel errata applied.

You might wonder why we handle this with a totally new test name
instead of adjusting the append to take an extra parameter? Well the
run_migration shell script uses eval "$@" which unwraps the -append
leading to any second parameter being split and leaving QEMU very
confused and the test hanging. This seemed simpler than re-writing all
the test running logic in something sane ;-)

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Shashi Mallela <shashi.mallela@linaro.org>
---
 arm/gic.c         |  8 +++++++-
 arm/unittests.cfg | 10 +++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index bef061a..0fce2a4 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -36,6 +36,7 @@ static struct gic *gic;
 static int acked[NR_CPUS], spurious[NR_CPUS];
 static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
 static cpumask_t ready;
+static bool under_tcg;
 
 static void nr_cpu_check(int nr)
 {
@@ -834,7 +835,7 @@ static void test_migrate_unmapped_collection(void)
 		goto do_migrate;
 	}
 
-	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
+	if (!errata(ERRATA_UNMAPPED_COLLECTIONS) && !under_tcg) {
 		report_skip("Skipping test, as this test hangs without the fix. "
 			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
 		test_skipped = true;
@@ -1005,6 +1006,11 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		test_migrate_unmapped_collection();
 		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection-tcg")) {
+		under_tcg = true;
+		report_prefix_push(argv[1]);
+		test_migrate_unmapped_collection();
+		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") == 0) {
 		report_prefix_push(argv[1]);
 		test_its_introspection();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 1a39428..adc1bbf 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -205,7 +205,7 @@ extra_params = -machine gic-version=3 -append 'its-pending-migration'
 groups = its migration
 arch = arm64
 
-[its-migrate-unmapped-collection]
+[its-migrate-unmapped-collection-kvm]
 file = gic.flat
 smp = $MAX_SMP
 accel = kvm
@@ -213,6 +213,14 @@ extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
 groups = its migration
 arch = arm64
 
+[its-migrate-unmapped-collection-tcg]
+file = gic.flat
+smp = $MAX_SMP
+accel = tcg
+extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection-tcg'
+groups = its migration
+arch = arm64
+
 # Test PSCI emulation
 [psci]
 file = psci.flat
-- 
2.20.1

