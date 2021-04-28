Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09A436D5A6
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbhD1KTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbhD1KTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 06:19:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74205C06138A
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:52 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d11so4582065wrw.8
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oZnOV6h4qE9XN8eV45ogIXJuOiGbasz5bo3bp014tJU=;
        b=ANukVHXncbLdbgHdhFWXicL6oAdfFtCcf2YirwriVA4no99pPgstEO2RBPIjibx6g8
         nlffMe5pHxW6pOhzQoEmoo/n+D4hKxlvyGOY7k+NC3PlSWu5Jb4CY8BANgzKFMZqavfU
         roWKWKJGmaCbeAun1KO/Luh2ACBlD7nxDsp0vFvUeCj+iDoPZir35+uMZzC1Cp2sr4Lu
         VVN0vSbiol6mSi5ECjnJjcXI4+hSUIkgBUI6ay7IUnvinESDf1WTMc8u1938koOC85Gy
         x99mUjPVIg6Xste2niTYJqDR5SNkeOpLFtOE6U8z8c8zJuW1KL7geU/8NzMdg+WB77n8
         gLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oZnOV6h4qE9XN8eV45ogIXJuOiGbasz5bo3bp014tJU=;
        b=A0ueESOhXl/pfv8yTq620A18Mo3xMi1mX429WOBOxhxdqfAkflPGCqEp7upgsrS72v
         XWZZ9dGFg88UnPBvNc1r/AC5x2wv49NieSHQvOzZ9Gv4579fHr0Wp62DKV9Qf+kAvrpV
         VAJlqhlbkWQASY7IW7+zvKi9ZNjzAY4khAQfQqlXgN7ZikyVsAqxjwuHC04yUI6nel8x
         e8bYsAxVqhkaRYYbZ6hzeWt6pu9t2ka4pE+XwwtWKVI/CtGZiOandYqFITMIRB1D6bG6
         1R2QbsvtY3lWtPjmzzxefnl86U2wIcsfnLPlMlt+4P6A/0E4sP9ncsgg33V/MKMBr5lj
         d1qA==
X-Gm-Message-State: AOAM530BdGyKsLnsn3XjgoiG6OZe6yPImg8JFOpNhjGUddaNHCsozkRy
        Zt+hZ8hBBBGRm5+Cyut2X40sSQ==
X-Google-Smtp-Source: ABdhPJx4lXogaQ0G+Fi1V4EswMRVo+Z1RplrLBVXheFEI7EdeYbid5vv/TMhgbDmRt2wHswrTJ4YPg==
X-Received: by 2002:adf:dd52:: with SMTP id u18mr2611724wrm.32.1619605131119;
        Wed, 28 Apr 2021 03:18:51 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id u2sm5734412wmc.22.2021.04.28.03.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 4D0661FF90;
        Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v1 4/4] arm64: split its-migrate-unmapped-collection into KVM and TCG variants
Date:   Wed, 28 Apr 2021 11:18:44 +0100
Message-Id: <20210428101844.22656-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428101844.22656-1-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running the test in TCG we are basically running on bare metal so
don't rely on having a particular kernel errata applied.

You might wonder why we handle this with a totally new test name
instead of adjusting the append as we have before? Well the
run_migration shell script uses eval "$@" which unwraps the -append
leading to any second parameter being split and leaving QEMU very
confused and the test hanging. This seemed simpler than re-writing all
the test running logic in something sane ;-)

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Shashi Mallela <shashi.mallela@linaro.org>
---
 arm/gic.c         |  7 ++++++-
 arm/unittests.cfg | 11 ++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 96a329d..3bc7477 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -843,7 +843,7 @@ static void test_migrate_unmapped_collection(void)
 		goto do_migrate;
 	}
 
-	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
+	if (!errata(ERRATA_UNMAPPED_COLLECTIONS) && !under_tcg) {
 		report_skip("Skipping test, as this test hangs without the fix. "
 			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
 		test_skipped = true;
@@ -1017,6 +1017,11 @@ int main(int argc, char **argv)
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
index d4dbc8b..e8f2e74 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -214,13 +214,22 @@ extra_params = -machine gic-version=3 -append 'its-pending-migration'
 groups = its migration
 arch = arm64
 
-[its-migrate-unmapped-collection]
+[its-migrate-unmapped-collection-kvm]
 file = gic.flat
 smp = $MAX_SMP
+accel = kvm
 extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
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

