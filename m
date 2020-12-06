Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCD52D0810
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgLFXkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLFXkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:40:39 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA16C0613D1
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:39:58 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h21so12088886wmb.2
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k2eeYOSwnhkGWaF7Gqxwyv5DCY5GnWH/sPRKUd7DVSw=;
        b=lCV2tVlTBuYcB4tKKpyVcUZy/dLgDw+fUlNSeB8cvB+ESWGUKwbBTmkJ9hSkZxaaLj
         gzZNP95EGEBFqJtamjQICHTD7pQe6Brz85Df8Miuns1r2Qmua1gMgWA7Dxfn8LAHXzwI
         7SkpOkiwubtSKtkoqhR4BBr5TSsCjl5kPaq7g7M7wyQ8UjYtS1uw3SsWfMr/AhL+FrlG
         YA49GUPLOV2H3wYgykcJcK28LQcDJhoItqoP2Wi2HiAgfvpUjw7EFMpZ6/B46cxfQE0W
         629C1e2wy/sm6XEp9hrkrAv3qTp7Ye5JCxZUxOwTRL869MEaf/eeiJPwjSVcl840NXGm
         zwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=k2eeYOSwnhkGWaF7Gqxwyv5DCY5GnWH/sPRKUd7DVSw=;
        b=euRo/4/5dTC8Lxm/cnsk8GJ99te1QvoOL6ueIkRoWNNJskCG6oqo95h0zYuMqV4S+h
         awpMnOtRyexNry/W2bVktykL43OxOSIHw5MuwgWxJY5+b4cbugXexWetOhI6vcnlxY5Q
         JlrHiuI9ASoWJpNnai2ttqFV0UWYGp7ODh5YFoEqo08K6cwqYAYyAaMff3UtrXJ0FDGH
         gE4gOcURh6fudtF1QAzNh7381emRLivQV2y1yhve/SRWQatr1KTrbFEiFTGnWYbxhQTu
         3k7IcFckBEt+VC8yhZFQzYzpB7Qny9zQMvDFJ95y5SbzHH/emtqYXg/qb5TuSebIEuh9
         gLDA==
X-Gm-Message-State: AOAM532oqRPI9prdajdDRQrrJSp15Qa6sER0jRBBPERiwmMq+t7cx5r2
        Bk5Vka/zbZCHJgRI24VZFLXyiverhPw=
X-Google-Smtp-Source: ABdhPJy3xT0vKlHKdf2n/udhIrOm526CJP1KpDJx6fJG7TXfFZ2bHXieBHHTpA97RbYwzkbqLswFEQ==
X-Received: by 2002:a1c:2b05:: with SMTP id r5mr15395706wmr.179.1607297997495;
        Sun, 06 Dec 2020 15:39:57 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id n17sm3479198wmc.33.2020.12.06.15.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:39:56 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 01/19] hw/mips: Move address translation helpers to target/mips/
Date:   Mon,  7 Dec 2020 00:39:31 +0100
Message-Id: <20201206233949.3783184-2-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Address translation is an architectural thing (not hardware
related). Move the helpers from hw/ to target/.

As physical address and KVM are specific to system mode
emulation, restrict this file to softmmu, so it doesn't
get compiled for user-mode emulation.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 include/hw/mips/cpudevs.h  | 7 -------
 target/mips/cpu.h          | 8 ++++++++
 hw/mips/boston.c           | 1 -
 {hw => target}/mips/addr.c | 2 +-
 target/mips/translate.c    | 2 --
 hw/mips/meson.build        | 2 +-
 target/mips/meson.build    | 1 +
 7 files changed, 11 insertions(+), 12 deletions(-)
 rename {hw => target}/mips/addr.c (98%)

diff --git a/include/hw/mips/cpudevs.h b/include/hw/mips/cpudevs.h
index 291f59281a0..f7c9728fa9f 100644
--- a/include/hw/mips/cpudevs.h
+++ b/include/hw/mips/cpudevs.h
@@ -5,13 +5,6 @@
 
 /* Definitions for MIPS CPU internal devices.  */
 
-/* addr.c */
-uint64_t cpu_mips_kseg0_to_phys(void *opaque, uint64_t addr);
-uint64_t cpu_mips_phys_to_kseg0(void *opaque, uint64_t addr);
-uint64_t cpu_mips_kvm_um_phys_to_kseg0(void *opaque, uint64_t addr);
-bool mips_um_ksegs_enabled(void);
-void mips_um_ksegs_enable(void);
-
 /* mips_int.c */
 void cpu_mips_irq_init_cpu(MIPSCPU *cpu);
 
diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 23f8c6f96cd..313e3252cbb 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1290,6 +1290,14 @@ bool cpu_supports_cps_smp(const char *cpu_type);
 bool cpu_supports_isa(const char *cpu_type, uint64_t isa);
 void cpu_set_exception_base(int vp_index, target_ulong address);
 
+/* addr.c */
+uint64_t cpu_mips_kseg0_to_phys(void *opaque, uint64_t addr);
+uint64_t cpu_mips_phys_to_kseg0(void *opaque, uint64_t addr);
+
+uint64_t cpu_mips_kvm_um_phys_to_kseg0(void *opaque, uint64_t addr);
+bool mips_um_ksegs_enabled(void);
+void mips_um_ksegs_enable(void);
+
 /* mips_int.c */
 void cpu_mips_soft_irq(CPUMIPSState *env, int irq, int level);
 
diff --git a/hw/mips/boston.c b/hw/mips/boston.c
index 3d40867dc4c..91183363ff3 100644
--- a/hw/mips/boston.c
+++ b/hw/mips/boston.c
@@ -28,7 +28,6 @@
 #include "hw/loader.h"
 #include "hw/loader-fit.h"
 #include "hw/mips/cps.h"
-#include "hw/mips/cpudevs.h"
 #include "hw/pci-host/xilinx-pcie.h"
 #include "hw/qdev-clock.h"
 #include "hw/qdev-properties.h"
diff --git a/hw/mips/addr.c b/target/mips/addr.c
similarity index 98%
rename from hw/mips/addr.c
rename to target/mips/addr.c
index 2f138fe1ea8..27a6036c451 100644
--- a/hw/mips/addr.c
+++ b/target/mips/addr.c
@@ -21,7 +21,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "hw/mips/cpudevs.h"
+#include "cpu.h"
 
 static int mips_um_ksegs;
 
diff --git a/target/mips/translate.c b/target/mips/translate.c
index c64a1bc42e1..87dc38c0683 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28,8 +28,6 @@
 #include "exec/exec-all.h"
 #include "tcg/tcg-op.h"
 #include "exec/cpu_ldst.h"
-#include "hw/mips/cpudevs.h"
-
 #include "exec/helper-proto.h"
 #include "exec/helper-gen.h"
 #include "hw/semihosting/semihost.h"
diff --git a/hw/mips/meson.build b/hw/mips/meson.build
index bcdf96be69f..77b4d8f365e 100644
--- a/hw/mips/meson.build
+++ b/hw/mips/meson.build
@@ -1,5 +1,5 @@
 mips_ss = ss.source_set()
-mips_ss.add(files('addr.c', 'mips_int.c'))
+mips_ss.add(files('mips_int.c'))
 mips_ss.add(when: 'CONFIG_FULOONG', if_true: files('fuloong2e.c'))
 mips_ss.add(when: 'CONFIG_JAZZ', if_true: files('jazz.c'))
 mips_ss.add(when: 'CONFIG_MALTA', if_true: files('gt64xxx_pci.c', 'malta.c'))
diff --git a/target/mips/meson.build b/target/mips/meson.build
index fa1f024e782..d980240f9e3 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -15,6 +15,7 @@
 
 mips_softmmu_ss = ss.source_set()
 mips_softmmu_ss.add(files(
+  'addr.c',
   'cp0_timer.c',
   'machine.c',
   'mips-semi.c',
-- 
2.26.2

