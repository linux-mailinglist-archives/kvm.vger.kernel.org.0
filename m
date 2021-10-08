Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D86E426FB1
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 19:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbhJHRmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 13:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbhJHRmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 13:42:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BDCC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 10:40:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 81-20020a251254000000b005b6220d81efso13390230ybs.12
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 10:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=S8FBbl6lmGnPBVMI8VNGPJDiN+mj3/gpo0KwKgQSUK0=;
        b=qP6aS0hp2202u33t77wMPCFTdcTl3UJGnUlf8F+uwXTszHWfGIxA+ejlgc2EszEayd
         Q5k442RcV8byW8GFezjWQStprHq/mrBDuc/fhFbqdlMRC1JBlDLeSE7gKWdT4kMwbcE/
         GiZ3tNGPWjQLia1W2UcaoYRbfq28YZmHCNhDisme7PPSDX+LMRIF0aYTwel3WezFxChy
         GNS8ca+uB+AYE6RycMBO4ouXizikGggu09YuYAUzs6KVyufLJfeVQB6eAA4fSZNn/W8y
         jqlfT8WSGjNG67favmpYGPaus3GjOEIPSdSnoA/ozHC8h1GGZjrpRx3lcvCcigw3SN8l
         cLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=S8FBbl6lmGnPBVMI8VNGPJDiN+mj3/gpo0KwKgQSUK0=;
        b=K5mZBPZ5IlGmtpzrOFFuSF5apQBr+rMux6ZUixhRj2kTnc3mc3fTT0HprdaMB/lA9O
         dFp2zJdtyIkt1U3M91eEDCKH8t1wSBtmdi9sjNEogr/O9tsaEzdcdVvU6xg1Ei4gSik9
         1XYh23AC9F26eZefxIAf6l9yoTn+atL9G2zKN20fgQmhHoeccSroWm0BrGZ0qUCHC2Bw
         sngsnRkkyOWo7yOOtd51BW7oI+3ouQcElzYvTi79a+TRNTHD4bwhuix3ojmxHpFLVm+I
         sh8/VyR/rzZ7dHTfxL5sUpQ8tKpjL1qYBlf65RbnvmZcPGcepDYm5DXYtzNNcKOoeA23
         vZcQ==
X-Gm-Message-State: AOAM530hmRasF+3Jc1CJhiCmMvSEm6gxMLHPiQqG32PBudnBxMQkJ/2Y
        8SXIc8z0q+HOTNvfIR3VhxpC9O5UAKK85H+aIpx83Pxn+TxQ2mnl/OaBl8zLVYbw/yLL/OfGq/H
        747qV5T8nxgbqo7lvAE+UbgM6pXAc9gbSIzFyoZNIKXFswtGMIlPorTQnaGlpCE0=
X-Google-Smtp-Source: ABdhPJwMjy9k6BstIagSN5//XDryWlcz664ABmmd/chGimhmfE/yUQZn+HiHpd+cLcIO82rS5B+TmIMNOebU5g==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:114a:: with SMTP id
 p10mr5254440ybu.234.1633714825228; Fri, 08 Oct 2021 10:40:25 -0700 (PDT)
Date:   Fri,  8 Oct 2021 10:40:22 -0700
Message-Id: <20211008174022.3028983-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [kvm-unit-tests PATCH v2] arm64: Add mmio_addr arg to arm/micro-bench
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a command line arg to arm/micro-bench to set the mmio_addr to other
values besides the default QEMU one. Default to the QEMU value if no arg
is passed.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/micro-bench.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 8e1d4ab..c731b1d 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -19,16 +19,19 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <util.h>
 #include <asm/gic.h>
 #include <asm/gic-v3-its.h>
 #include <asm/timer.h>
 
-#define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
+#define NS_5_SECONDS		(5 * 1000 * 1000 * 1000UL)
+#define QEMU_MMIO_ADDR		0x0a000008
 
 static u32 cntfrq;
 
 static volatile bool irq_ready, irq_received;
 static int nr_ipi_received;
+static unsigned long mmio_addr = QEMU_MMIO_ADDR;
 
 static void *vgic_dist_base;
 static void (*write_eoir)(u32 irqstat);
@@ -278,12 +281,14 @@ static void *userspace_emulated_addr;
 static bool mmio_read_user_prep(void)
 {
 	/*
-	 * FIXME: Read device-id in virtio mmio here in order to
-	 * force an exit to userspace. This address needs to be
-	 * updated in the future if any relevant changes in QEMU
-	 * test-dev are made.
+	 * FIXME: We need an MMIO address that we can safely read to test
+	 * exits to userspace. Ideally, the test-dev would provide us this
+	 * address (and one we could write to too), but until it does we
+	 * use a virtio-mmio transport address. FIXME2: We should be getting
+	 * this address (and the future test-dev address) from the devicetree,
+	 * but so far we lazily hardcode it.
 	 */
-	userspace_emulated_addr = (void*)ioremap(0x0a000008, sizeof(u32));
+	userspace_emulated_addr = (void *)ioremap(mmio_addr, sizeof(u32));
 	return true;
 }
 
@@ -378,10 +383,29 @@ static void loop_test(struct exit_test *test)
 		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
 }
 
+static void parse_args(int argc, char **argv)
+{
+	int i, len;
+	long val;
+
+	for (i = 1; i < argc; ++i) {
+		len = parse_keyval(argv[i], &val);
+		if (len == -1)
+			continue;
+
+		if (strncmp(argv[i], "mmio-addr", len) == 0) {
+			mmio_addr = val;
+			report_info("found mmio_addr=0x%lx", mmio_addr);
+		}
+	}
+}
+
 int main(int argc, char **argv)
 {
 	int i;
 
+	parse_args(argc, argv);
+
 	if (!test_init())
 		return 1;
 
-- 
2.33.0.882.g93a45727a2-goog

