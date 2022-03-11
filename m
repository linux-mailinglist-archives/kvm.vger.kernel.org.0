Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65DB4D673B
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242355AbiCKRKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiCKRKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:10:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CD5071ECB
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647018537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CGRRW1HyrjpX/mPdb1gMd4vnitCkHwitZW09OE4n8UI=;
        b=W9e1BMIXfkgs7lyVzLwV4Mn6FmRJvj2s5Yci58tQfz5SBLMBTfF7Cgpu1LFWJIBfjnMvRF
        MJDEVM6/twzoB38V5pHN6QrQA23OztUJHOxFaO2c+YDbk6WLnouQKF88Xu92NEle9GfJkr
        /w44IvbzSSZzgd3EzUiNZudA1/xExBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-M_2iTGDXOeu-AwPOdsOApg-1; Fri, 11 Mar 2022 12:08:55 -0500
X-MC-Unique: M_2iTGDXOeu-AwPOdsOApg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1144FC80;
        Fri, 11 Mar 2022 17:08:54 +0000 (UTC)
Received: from thuth.com (unknown [10.39.194.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7596E1059163;
        Fri, 11 Mar 2022 17:08:53 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH] arm: Fix typos
Date:   Fri, 11 Mar 2022 18:08:50 +0100
Message-Id: <20220311170850.2911898-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Correct typos which were discovered with the "codespell" utility.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arm/cstart.S              | 2 +-
 arm/gic.c                 | 2 +-
 arm/micro-bench.c         | 2 +-
 lib/arm64/asm/assembler.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 2401d92..7036e67 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -44,7 +44,7 @@ start:
 
 	/*
 	 * set stack, making room at top of stack for cpu0's
-	 * exception stacks. Must start wtih stackptr, not
+	 * exception stacks. Must start with stackptr, not
 	 * stacktop, so the thread size masking (shifts) work.
 	 */
 	ldr	sp, =stackptr
diff --git a/arm/gic.c b/arm/gic.c
index 1e3ea80..60457e2 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -909,7 +909,7 @@ static void test_its_pending_migration(void)
 	gicv3_lpi_rdist_disable(pe0);
 	gicv3_lpi_rdist_disable(pe1);
 
-	/* lpis are interleaved inbetween the 2 PEs */
+	/* lpis are interleaved between the 2 PEs */
 	for (i = 0; i < 256; i++) {
 		struct its_collection *col = i % 2 ? collection[0] :
 						     collection[1];
diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index c731b1d..8436612 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -265,7 +265,7 @@ static void timer_post(uint64_t ntimes, uint64_t *total_ticks)
 {
 	/*
 	 * We use a 10msec timer to test the latency of PPI,
-	 * so we substract the ticks of 10msec to get the
+	 * so we subtract the ticks of 10msec to get the
 	 * actual latency
 	 */
 	*total_ticks -= ntimes * (cntfrq / 100);
diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
index a271e4c..aa8c65a 100644
--- a/lib/arm64/asm/assembler.h
+++ b/lib/arm64/asm/assembler.h
@@ -32,7 +32,7 @@
  * kvm-unit-tests has no concept of scheduling.
  *
  * 	op:		operation passed to dc instruction
- * 	domain:		domain used in dsb instruciton
+ * 	domain:		domain used in dsb instruction
  * 	addr:		starting virtual address of the region
  * 	size:		size of the region
  * 	Corrupts:	addr, size, tmp1, tmp2
-- 
2.27.0

