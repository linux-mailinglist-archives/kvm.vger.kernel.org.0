Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4722D906A
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404978AbgLMUVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404142AbgLMUVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:35 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DE7C061794
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:55 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id a3so13416986wmb.5
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uJl+/EeXqBxB7hfG+/ZfbRL30Nmwpy+BSYnXX9dfemM=;
        b=u0ko4PweyxhLkeeWo3yjo1wYFhxgNEC5xrZTR5djqgHZbI8mv4MheQT0hAFOCezq1y
         +t+3hg7NcxRhx5zGvUWyOQD/p4xngcgSYKQMqZfOpdvwVne724d8k7enBYPR8EEBO+Ox
         WQJBbfGqH/t/swYfHhLzKf58Gnqqduou53TdAER3Rs4MeTNB483JcdU4MHLKZRSr7Mz9
         05sglCyISn7H2VfrielSp9BMFJIzKeB03RoLFBZEbTEZ/pdDM11S49XzFQe9uadwbl88
         nZkR0X5hG4lVOf0s6Up0ZgAaMPZ7phLTFTweLuF9xF706SfIDnJYl1HfY6PkSueSwrCx
         7JAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=uJl+/EeXqBxB7hfG+/ZfbRL30Nmwpy+BSYnXX9dfemM=;
        b=ka83iiaWV6oX0IVjeY5nvY8u21u2NOB0KcX6WUQC8AUM7YF3anFibrMEz+TS+Zr01T
         YZaovhN96rR2zWx2K6+KAo41mG8VyP4tBfmoONRNqmc482Q0DyoqSl0A0orspolque1d
         iimLZfiosIymGMwMnaMICEGrpPCtn02wAs6QBi90SD7sDE/d8lxQdNDSQJltneJkijti
         WEkOaGpwO2akfc2rjG+2DSV8qpiio22GgzGy0NKLBmV4BTN0y5eceWlz5WEPwl4x2ezx
         yOBZRezvnn61wsZXxgMygzUordmSD+pSFit7QZXHZJqxH0qKLcZDJk+l10BSrBv14J+q
         gLLg==
X-Gm-Message-State: AOAM532oaV8B1q5WyvH/YXnXZhMKc3lU5cL5AscWupZWZsfwJIgY8yqv
        PWpw38G0yFJtuEKX5TUEIuc=
X-Google-Smtp-Source: ABdhPJwyr3Bcz0npqHp1+rzM78Aj/bFoHAUN+iHfi/EMO7r5KVcn6S69kfPOW50IF7acg/ABH6c7cA==
X-Received: by 2002:a1c:b78a:: with SMTP id h132mr24042122wmf.141.1607890853818;
        Sun, 13 Dec 2020 12:20:53 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id s1sm31441773wrv.97.2020.12.13.12.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:53 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 13/26] hw/mips: Move address translation helpers to target/mips/
Date:   Sun, 13 Dec 2020 21:19:33 +0100
Message-Id: <20201213201946.236123-14-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-2-f4bug@amsat.org>
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
index e8bca75f237..5d3b2a01c01 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1291,6 +1291,14 @@ bool cpu_supports_isa(const CPUMIPSState *env, uint64_t isa_mask);
 bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa);
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
index 16467ea4752..c3b94c68e1b 100644
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
index b8ed16bb779..4a1ae73f9d0 100644
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
index 681a5524c0e..4179395a8ea 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -14,6 +14,7 @@
 
 mips_softmmu_ss = ss.source_set()
 mips_softmmu_ss.add(files(
+  'addr.c',
   'cp0_helper.c',
   'cp0_timer.c',
   'machine.c',
-- 
2.26.2

