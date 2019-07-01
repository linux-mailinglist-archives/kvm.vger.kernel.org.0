Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23C025667
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 19:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbfEUROw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 13:14:52 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:44535 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfEUROw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 13:14:52 -0400
Received: by mail-ot1-f73.google.com with SMTP id o98so8769618ota.11
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 10:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=H9evgUtJKk9iOh7s92VoABd87c19KFvCz9OXqkkAR5Y=;
        b=FSVq4k3IgzVdLTFdIe8okEbWjo9vwGx6zzWcZ4gR25d5HhwRfuwewjMecO2CSIYyfk
         xE6yTDp7d1bESO6kZIKFN0/zoyctYMlP5XjTMoGs9krMQOnPdyWAVLBVMHD3wZfmjI6S
         Y1j/482ukx3gJY7ewSPEaIRLeWIRigCoZ/PCP52zJWQYbTOuHX1sFkP6i07WPXC0EZ2z
         qRGeu0/rq4tkQsIqnNfdPeIMblM63x8wtiPuLo6oWtjjdTeq9y9319Gj6U+D0dG1gydP
         4KKRJGsF7QoUDvxfM1/jWPDLoPUpTIE1mAYROy9554ASuV6pXraHdFT44OOjauQeUksz
         dELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=H9evgUtJKk9iOh7s92VoABd87c19KFvCz9OXqkkAR5Y=;
        b=Y/sYNvxaz59eFfoUkXkEdjWcVxZcFoKGjD+BzKCxD/55Wds1wSB6G5FYSsWfi1nbA0
         LwwVQgFBsqply+2mm3Y1qrd6b6FTVEfUy9GQv81vRN1rTpOSEPjZyDxAoeg3ecmjZSKS
         +bXNL0tg1SwIwmgrP8RxUgCA694Psu48Um1FEwr6tEMkg8KjoomF68ul13BeoYbIqUpF
         fWxRddoxotsDEobEcN6yphhf2cvs9rzQ7htdRwrMNrftAihsQDI2PGyGRxF5F4WQckCu
         IcT4pWb9ZiaaHuuWPWExUoGdAzLYxvk4C5xda0lUYuIo1ARAQzi+Pq8mevXnokOJcS0t
         FYsw==
X-Gm-Message-State: APjAAAUkdYV8ACnmGZHYjOb5yIFvpSa+pmJ1sFqxHDb30WrqnbT2vUmY
        twZRi313udj6MZ1PGlUjVC4qBxTnZLuj7WS3
X-Google-Smtp-Source: APXvYqxA1/SkRyXS78iGWR++jmybxmYnyHrRuF9qm+iSxFU+cf5G/E+GzkrrZHcpQy5Ba+VGPuKntXkCIMkSPdhk
X-Received: by 2002:aca:5517:: with SMTP id j23mr4161792oib.17.1558458891361;
 Tue, 21 May 2019 10:14:51 -0700 (PDT)
Date:   Tue, 21 May 2019 10:13:58 -0700
Message-Id: <20190521171358.158429-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH] kvm: tests: Sort tests in the Makefile alphabetically
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, pshier@google.com, marcorr@google.com,
        kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 tools/testing/selftests/kvm/Makefile | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 79c524395ebe..234f679fa5ad 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -10,23 +10,23 @@ LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebi
 LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
 LIBKVM_aarch64 = lib/aarch64/processor.c
 
-TEST_GEN_PROGS_x86_64 = x86_64/platform_info_test
-TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
-TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
-TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
-TEST_GEN_PROGS_x86_64 += x86_64/state_test
+TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
-TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
-TEST_GEN_PROGS_x86_64 += x86_64/smm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
+TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
+TEST_GEN_PROGS_x86_64 += x86_64/smm_test
+TEST_GEN_PROGS_x86_64 += x86_64/state_test
+TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
-TEST_GEN_PROGS_x86_64 += dirty_log_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
+TEST_GEN_PROGS_x86_64 += dirty_log_test
 
-TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
+TEST_GEN_PROGS_aarch64 += dirty_log_test
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
-- 
2.21.0.1020.gf2820cf01a-goog

