Return-Path: <kvm+bounces-717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE9F07E1F91
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D20581C20BE6
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577F71A5BB;
	Mon,  6 Nov 2023 11:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k3sA5ePH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B461A596
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:09:11 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885EB191
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:09:08 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-507adc3381cso5489697e87.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268947; x=1699873747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csVQGgR+Tak3/eKK57JrtNqjD/O4/1GmajzGwSgP8l0=;
        b=k3sA5ePHaUaL+0NraaBP33n7zYhynEv4csu+5APLc7yzzXu1A84C0ccY5u6Fnn1+sD
         SWIpDM15l8NeV3QCS7dD7UJ5Cx3PtkQZIFfBjLNmqKnQc5IHqU70tnNiQkN7wLvVd3sp
         /FWlAs/6cnpsKWA1DySqq+0LvE1jrz0X4od+ov2KVrV2m+xsDIz0rjwOezGkVuE3cd+K
         UVnw7OPDsk2tGIjFfvZZ3MYtsakQ+SI9nE9ho92YfXM0Kbm9bGJyECR0Zf8ekEDSNPVD
         hC8oyPoUNruRoZkjCCqnutp6zCo/izO46HuWGtntldtOnpobsTIwd9oi+k3hTcYJTXI/
         WJOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268947; x=1699873747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csVQGgR+Tak3/eKK57JrtNqjD/O4/1GmajzGwSgP8l0=;
        b=I+Qv/oLbh+EkAlwhIf8gKgaZiIyhaccJhPWnyhGneCm6FpM5mj8uOzejw9UYTeh9Ig
         fdFwsrwmNBTT5KbmT2nmRgLrT1a2ltdW9de65i+iz4XmMJ9u3ItHZQmJI8pUhYPHs8if
         v2Vg1xgI4vTU3kBecGYCXBAVaSFDdjPbWz9yYCKNaqG6wThpbBRnAkTElCkSqb+eDAuH
         K/NGApBGNr0g1/s56U7NuoH43E9UShSL7Qe5iCKN8yI7cByGTuxCq6qf/NQZEcVa6+Ks
         PZVvM7Ijb8ltFDVSqEjBFjoGDcQL83Wn7/cil1FOV/DJQ9Py1h6pRm8cuHBaCOJ/zrH7
         snkw==
X-Gm-Message-State: AOJu0Yx12yQcnZHJtFTYwm4m/ndK3kX6UdoXVhqyiWoAZ4rpgNNWRZeT
	8yXSe3/8Z6Fis9i3XTyf1T05bQ==
X-Google-Smtp-Source: AGHT+IF/NpB8HMHP7H/FI9jfuMU1i8ZqGUSvagHUJCDZQ+ivvnwriIb7n7tIOJDMRsdh2YcofDQnWA==
X-Received: by 2002:a05:6512:370b:b0:507:a6a5:a87b with SMTP id z11-20020a056512370b00b00507a6a5a87bmr20578908lfr.51.1699268946691;
        Mon, 06 Nov 2023 03:09:06 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id j19-20020a05600c191300b004090ca6d785sm11949457wmq.2.2023.11.06.03.09.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:09:06 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Fiona Ebner <f.ebner@proxmox.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PULL 48/60] tests/qtest: ahci-test: add test exposing reset issue with pending callback
Date: Mon,  6 Nov 2023 12:03:20 +0100
Message-ID: <20231106110336.358-49-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
References: <20231106110336.358-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fiona Ebner <f.ebner@proxmox.com>

Before commit "hw/ide: reset: cancel async DMA operation before
resetting state", this test would fail, because a reset with a
pending write operation would lead to an unsolicited write to the
first sector of the disk.

The test writes a pattern to the beginning of the disk and verifies
that it is still intact after a reset with a pending operation. It
also checks that the pending operation actually completes correctly.

Signed-off-by: Fiona Ebner <f.ebner@proxmox.com>
Message-ID: <20230906130922.142845-2-f.ebner@proxmox.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 tests/qtest/ahci-test.c | 86 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 85 insertions(+), 1 deletion(-)

diff --git a/tests/qtest/ahci-test.c b/tests/qtest/ahci-test.c
index eea8b5f77b..5a1923f721 100644
--- a/tests/qtest/ahci-test.c
+++ b/tests/qtest/ahci-test.c
@@ -1424,6 +1424,89 @@ static void test_reset(void)
     ahci_shutdown(ahci);
 }
 
+static void test_reset_pending_callback(void)
+{
+    AHCIQState *ahci;
+    AHCICommand *cmd;
+    uint8_t port;
+    uint64_t ptr1;
+    uint64_t ptr2;
+
+    int bufsize = 4 * 1024;
+    int speed = bufsize + (bufsize / 2);
+    int offset1 = 0;
+    int offset2 = bufsize / AHCI_SECTOR_SIZE;
+
+    g_autofree unsigned char *tx1 = g_malloc(bufsize);
+    g_autofree unsigned char *tx2 = g_malloc(bufsize);
+    g_autofree unsigned char *rx1 = g_malloc0(bufsize);
+    g_autofree unsigned char *rx2 = g_malloc0(bufsize);
+
+    /* Uses throttling to make test independent of specific environment. */
+    ahci = ahci_boot_and_enable("-drive if=none,id=drive0,file=%s,"
+                                "cache=writeback,format=%s,"
+                                "throttling.bps-write=%d "
+                                "-M q35 "
+                                "-device ide-hd,drive=drive0 ",
+                                tmp_path, imgfmt, speed);
+
+    port = ahci_port_select(ahci);
+    ahci_port_clear(ahci, port);
+
+    ptr1 = ahci_alloc(ahci, bufsize);
+    ptr2 = ahci_alloc(ahci, bufsize);
+
+    g_assert(ptr1 && ptr2);
+
+    /* Need two different patterns. */
+    do {
+        generate_pattern(tx1, bufsize, AHCI_SECTOR_SIZE);
+        generate_pattern(tx2, bufsize, AHCI_SECTOR_SIZE);
+    } while (memcmp(tx1, tx2, bufsize) == 0);
+
+    qtest_bufwrite(ahci->parent->qts, ptr1, tx1, bufsize);
+    qtest_bufwrite(ahci->parent->qts, ptr2, tx2, bufsize);
+
+    /* Write to beginning of disk to check it wasn't overwritten later. */
+    ahci_guest_io(ahci, port, CMD_WRITE_DMA_EXT, ptr1, bufsize, offset1);
+
+    /* Issue asynchronously to get a pending callback during reset. */
+    cmd = ahci_command_create(CMD_WRITE_DMA_EXT);
+    ahci_command_adjust(cmd, offset2, ptr2, bufsize, 0);
+    ahci_command_commit(ahci, cmd, port);
+    ahci_command_issue_async(ahci, cmd);
+
+    ahci_set(ahci, AHCI_GHC, AHCI_GHC_HR);
+
+    ahci_command_free(cmd);
+
+    /* Wait for throttled write to finish. */
+    sleep(1);
+
+    /* Start again. */
+    ahci_clean_mem(ahci);
+    ahci_pci_enable(ahci);
+    ahci_hba_enable(ahci);
+    port = ahci_port_select(ahci);
+    ahci_port_clear(ahci, port);
+
+    /* Read and verify. */
+    ahci_guest_io(ahci, port, CMD_READ_DMA_EXT, ptr1, bufsize, offset1);
+    qtest_bufread(ahci->parent->qts, ptr1, rx1, bufsize);
+    g_assert_cmphex(memcmp(tx1, rx1, bufsize), ==, 0);
+
+    ahci_guest_io(ahci, port, CMD_READ_DMA_EXT, ptr2, bufsize, offset2);
+    qtest_bufread(ahci->parent->qts, ptr2, rx2, bufsize);
+    g_assert_cmphex(memcmp(tx2, rx2, bufsize), ==, 0);
+
+    ahci_free(ahci, ptr1);
+    ahci_free(ahci, ptr2);
+
+    ahci_clean_mem(ahci);
+
+    ahci_shutdown(ahci);
+}
+
 static void test_ncq_simple(void)
 {
     AHCIQState *ahci;
@@ -1945,7 +2028,8 @@ int main(int argc, char **argv)
     qtest_add_func("/ahci/migrate/dma/halted", test_migrate_halted_dma);
 
     qtest_add_func("/ahci/max", test_max);
-    qtest_add_func("/ahci/reset", test_reset);
+    qtest_add_func("/ahci/reset/simple", test_reset);
+    qtest_add_func("/ahci/reset/pending_callback", test_reset_pending_callback);
 
     qtest_add_func("/ahci/io/ncq/simple", test_ncq_simple);
     qtest_add_func("/ahci/migrate/ncq/simple", test_migrate_ncq);
-- 
2.41.0


