Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E026F41CA28
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345919AbhI2QdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344370AbhI2QdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 12:33:09 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693ECC06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:31:28 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x20so5271453wrg.10
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N3IJV0m/ZFM0ggqe7+WRaHWf341S7hpElakJ20EkmsI=;
        b=Vxx20VuLOomRCmIrdrDCiCHZKDkLreLOKim8fQK+khAezLamZNy2m5a6ouNRM3uPwV
         EW6xhMIOgl5zIXK7XgyxX7D+/EVY7iR6eyOBskk34Rz8dO9cteclLkNsroU6TChInkNp
         mWM7rzwc9ejqqk7pKJb6Z8yEwQ4PsY6e6LyDZcNpv/c43NC7VFZdKX+FdPqRrDIRv1FA
         jlW6NGYyyBvOjS3E9/EebZZI50h6ALfwPnWInxeRfxyKzHrMg3BQg/lm23GY//oDmRZU
         dxlFcpRazyeLB60MX/ocyWRgou+2yCAV3u+KxuUhNHOq/gQS2UUcfVzxaz4nYgfkPszh
         exuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=N3IJV0m/ZFM0ggqe7+WRaHWf341S7hpElakJ20EkmsI=;
        b=T/6ayAtmr39Un8O6g8ZG6ihzQlF2hUiaLyxlpnEtui1wcqMXjrc2poQNAoGTK165PA
         3FTWDD/lq9+Aiiwyix5XRxl3aTO2VoU3cZVdeY2lhpKcy90BkdLHXbc0TT6m5EkUHivD
         Zsl/vp+Od/hufWPP8rsR/NNBpoJV5rT6IbgBe1T2BSFkewIB32uN7m/jdkDRMGSGuq6K
         aYKwAQeFDTF9s+lqt5dxKTtawTvJIH8chAYF8k12o9Dnrp1hQpolU0syAZw0jgbWqJoL
         HxL9jDuZtV+t38nO8SB2e4oa2DcTcyMOWZRDwNxOIpyJ0nnNtMMUyLdBXRw0VStLmT3X
         ywFQ==
X-Gm-Message-State: AOAM531abDbl/O/UnMv1miNZQUNSiJwJVFo7bQotdCl8cDe/fxRC0nOx
        kCALdENotQUdX3X5XTG37hrGSmJVyjA=
X-Google-Smtp-Source: ABdhPJx58FdQ3h8ScVZyvT0XMTE/Z+oNevVl88ncNK3lbBYBEp1D4Wfhmku9AXw1a3xxirKpNId8qw==
X-Received: by 2002:adf:e449:: with SMTP id t9mr956316wrm.201.1632933086919;
        Wed, 29 Sep 2021 09:31:26 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id 1sm2437902wms.0.2021.09.29.09.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 09:31:26 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     haxm-team@intel.com, Eduardo Habkost <ehabkost@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>, qemu-trivial@nongnu.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Colin Xu <colin.xu@intel.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v3] target/i386: Include 'hw/i386/apic.h' locally
Date:   Wed, 29 Sep 2021 18:31:24 +0200
Message-Id: <20210929163124.2523413-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of including a sysemu-specific header in "cpu.h"
(which is shared with user-mode emulations), include it
locally when required.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/i386/cpu.h                    | 4 ----
 hw/i386/kvmvapic.c                   | 1 +
 hw/i386/x86.c                        | 1 +
 target/i386/cpu-dump.c               | 1 +
 target/i386/cpu-sysemu.c             | 1 +
 target/i386/cpu.c                    | 1 +
 target/i386/gdbstub.c                | 4 ++++
 target/i386/hax/hax-all.c            | 1 +
 target/i386/helper.c                 | 1 +
 target/i386/hvf/hvf.c                | 1 +
 target/i386/hvf/x86_emu.c            | 1 +
 target/i386/nvmm/nvmm-all.c          | 1 +
 target/i386/tcg/sysemu/misc_helper.c | 1 +
 target/i386/tcg/sysemu/seg_helper.c  | 1 +
 target/i386/whpx/whpx-all.c          | 1 +
 15 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c2954c71ea0..4411718bb7a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2045,10 +2045,6 @@ typedef X86CPU ArchCPU;
 #include "exec/cpu-all.h"
 #include "svm.h"
 
-#if !defined(CONFIG_USER_ONLY)
-#include "hw/i386/apic.h"
-#endif
-
 static inline void cpu_get_tb_cpu_state(CPUX86State *env, target_ulong *pc,
                                         target_ulong *cs_base, uint32_t *flags)
 {
diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
index 43f8a8f679e..7333818bdd1 100644
--- a/hw/i386/kvmvapic.c
+++ b/hw/i386/kvmvapic.c
@@ -16,6 +16,7 @@
 #include "sysemu/hw_accel.h"
 #include "sysemu/kvm.h"
 #include "sysemu/runstate.h"
+#include "hw/i386/apic.h"
 #include "hw/i386/apic_internal.h"
 #include "hw/sysbus.h"
 #include "hw/boards.h"
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 00448ed55aa..e0218f8791f 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -43,6 +43,7 @@
 #include "target/i386/cpu.h"
 #include "hw/i386/topology.h"
 #include "hw/i386/fw_cfg.h"
+#include "hw/i386/apic.h"
 #include "hw/intc/i8259.h"
 #include "hw/rtc/mc146818rtc.h"
 
diff --git a/target/i386/cpu-dump.c b/target/i386/cpu-dump.c
index 02b635a52cf..0158fd2bf28 100644
--- a/target/i386/cpu-dump.c
+++ b/target/i386/cpu-dump.c
@@ -22,6 +22,7 @@
 #include "qemu/qemu-print.h"
 #ifndef CONFIG_USER_ONLY
 #include "hw/i386/apic_internal.h"
+#include "hw/i386/apic.h"
 #endif
 
 /***********************************************************/
diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
index 37b7c562f53..4e8a6973d08 100644
--- a/target/i386/cpu-sysemu.c
+++ b/target/i386/cpu-sysemu.c
@@ -30,6 +30,7 @@
 #include "hw/qdev-properties.h"
 
 #include "exec/address-spaces.h"
+#include "hw/i386/apic.h"
 #include "hw/i386/apic_internal.h"
 
 #include "cpu-internal.h"
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6b029f1bdf1..52422cbf21b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -33,6 +33,7 @@
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "hw/qdev-properties.h"
 #include "hw/i386/topology.h"
+#include "hw/i386/apic.h"
 #ifndef CONFIG_USER_ONLY
 #include "exec/address-spaces.h"
 #include "hw/boards.h"
diff --git a/target/i386/gdbstub.c b/target/i386/gdbstub.c
index 098a2ad15a9..5438229c1a9 100644
--- a/target/i386/gdbstub.c
+++ b/target/i386/gdbstub.c
@@ -21,6 +21,10 @@
 #include "cpu.h"
 #include "exec/gdbstub.h"
 
+#ifndef CONFIG_USER_ONLY
+#include "hw/i386/apic.h"
+#endif
+
 #ifdef TARGET_X86_64
 static const int gpr_map[16] = {
     R_EAX, R_EBX, R_ECX, R_EDX, R_ESI, R_EDI, R_EBP, R_ESP,
diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
index bf65ed6fa92..cd89e3233a9 100644
--- a/target/i386/hax/hax-all.c
+++ b/target/i386/hax/hax-all.c
@@ -32,6 +32,7 @@
 #include "sysemu/reset.h"
 #include "sysemu/runstate.h"
 #include "hw/boards.h"
+#include "hw/i386/apic.h"
 
 #include "hax-accel-ops.h"
 
diff --git a/target/i386/helper.c b/target/i386/helper.c
index 533b29cb91b..874beda98ae 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -26,6 +26,7 @@
 #ifndef CONFIG_USER_ONLY
 #include "sysemu/hw_accel.h"
 #include "monitor/monitor.h"
+#include "hw/i386/apic.h"
 #endif
 
 void cpu_sync_bndcs_hflags(CPUX86State *env)
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 4ba6e82fab3..50058a24f2a 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -70,6 +70,7 @@
 #include <sys/sysctl.h>
 
 #include "hw/i386/apic_internal.h"
+#include "hw/i386/apic.h"
 #include "qemu/main-loop.h"
 #include "qemu/accel.h"
 #include "target/i386/cpu.h"
diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
index 7c8203b21fb..fb3e88959d4 100644
--- a/target/i386/hvf/x86_emu.c
+++ b/target/i386/hvf/x86_emu.c
@@ -45,6 +45,7 @@
 #include "x86_flags.h"
 #include "vmcs.h"
 #include "vmx.h"
+#include "hw/i386/apic.h"
 
 void hvf_handle_io(struct CPUState *cpu, uint16_t port, void *data,
                    int direction, int size, uint32_t count);
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index a488b00e909..944bdb49663 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -22,6 +22,7 @@
 #include "qemu/queue.h"
 #include "migration/blocker.h"
 #include "strings.h"
+#include "hw/i386/apic.h"
 
 #include "nvmm-accel-ops.h"
 
diff --git a/target/i386/tcg/sysemu/misc_helper.c b/target/i386/tcg/sysemu/misc_helper.c
index 9ccaa054c4c..b1d3096e9c9 100644
--- a/target/i386/tcg/sysemu/misc_helper.c
+++ b/target/i386/tcg/sysemu/misc_helper.c
@@ -24,6 +24,7 @@
 #include "exec/cpu_ldst.h"
 #include "exec/address-spaces.h"
 #include "tcg/helper-tcg.h"
+#include "hw/i386/apic.h"
 
 void helper_outb(CPUX86State *env, uint32_t port, uint32_t data)
 {
diff --git a/target/i386/tcg/sysemu/seg_helper.c b/target/i386/tcg/sysemu/seg_helper.c
index bf3444c26b0..34f2c65d47f 100644
--- a/target/i386/tcg/sysemu/seg_helper.c
+++ b/target/i386/tcg/sysemu/seg_helper.c
@@ -24,6 +24,7 @@
 #include "exec/cpu_ldst.h"
 #include "tcg/helper-tcg.h"
 #include "../seg_helper.h"
+#include "hw/i386/apic.h"
 
 #ifdef TARGET_X86_64
 void helper_syscall(CPUX86State *env, int next_eip_addend)
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 3e925b9da70..9ab844fd05d 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -20,6 +20,7 @@
 #include "qemu/main-loop.h"
 #include "hw/boards.h"
 #include "hw/i386/ioapic.h"
+#include "hw/i386/apic.h"
 #include "hw/i386/apic_internal.h"
 #include "qemu/error-report.h"
 #include "qapi/error.h"
-- 
2.31.1

