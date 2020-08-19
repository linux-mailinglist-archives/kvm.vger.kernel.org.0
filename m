Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B37524A601
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 20:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgHSSa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 14:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHSSaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 14:30:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF97FC061757
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:30:18 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id c10so1486694pjn.1
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cERuJlDV7NTRJGjVkGRVTXHsJwTCTvANBx0F7hdApoA=;
        b=jG083Qm53OvAj42qYBCvVWCmcwHXtDKpasaDzAQmY3lywgaRZRzHb/e29tvVtmkvXy
         FAZwasPgbUHj9xhO1S3eslPmb4RXNK9PdYldzYMPPYZ2xbam9KU1rLkLoaV8oLZWV2cf
         mq0kAiqtR6+CQ0cx4HODpbOmMWIBGtDAcB2GgLDEt5J8zs54bOZuqU7CW1mvcZVNweUX
         sqpojq9JaKZBDUmWxOTKSfHAS2WSnMOQE6rKSNbiFmiU3PITGp0q56HJjyjQsYiFxxUm
         l6ZabPQlojxJxWGehCde6biDlYZxr4tEy8+8/jsOFo8bTPHO/L8fbQDJYzLI5IqeS65Z
         VNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cERuJlDV7NTRJGjVkGRVTXHsJwTCTvANBx0F7hdApoA=;
        b=FS3li36iAu5SiGPKqzhL2c2Q7nUyX82hYdZWt40W1cNUXP1jwcNLElQNgRC6EWpROV
         sqp4CWhXoiXGeZFySig3xVf/FJrX0qzp26TNZF+GyCULCLNFpcR1LSIn6YlNjKZpjE9P
         ssE2wIWSEBLqWtia1cN3viciRhrl4QyUL1nzyXP413PTbY9XW8ekYhwULLsAcjBvVvJi
         RkX5eL5kz5mPplDkaFAfzvs98HxFaw2KbmDUg7IwH2OVulSSYVQlGUaV6ltOvIFCreq6
         adu3btYdr62arupbi4pNi+/t3cBRkjQCxKPX8f4Wo9yiu/VgbXGT12JSNLA0mx8EFTEu
         9OLg==
X-Gm-Message-State: AOAM531fANHeahj4BO8kmHJcH6aOXG4TCpZasN8dD1a9aG1wXBOBmuUZ
        xf1VFmIwNDnRFSNjej+8S3ZuZg==
X-Google-Smtp-Source: ABdhPJz1Yvg8PSds4SVRrKCdwayuTg8Gc6KVcPFext56h6Uj0VZWXBPwzVbvHOl/clSvO15Z7KjYtg==
X-Received: by 2002:a17:902:6bc2:: with SMTP id m2mr19368856plt.114.1597861817962;
        Wed, 19 Aug 2020 11:30:17 -0700 (PDT)
Received: from Rfoley-MA01.hsd1.ma.comcast.net (c-73-47-162-176.hsd1.ma.comcast.net. [73.47.162.176])
        by smtp.gmail.com with ESMTPSA id p20sm220766pjg.44.2020.08.19.11.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 11:30:16 -0700 (PDT)
From:   Robert Foley <robert.foley@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     alex.bennee@linaro.org, pbonzini@redhat.com,
        peter.puhov@linaro.org, robert.foley@linaro.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Michael Rolnik <mrolnik@gmail.com>,
        Sarah Harris <S.E.Harris@kent.ac.uk>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Laurent Vivier <laurent@vivier.eu>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Anthony Green <green@moxielogic.com>,
        Chris Wulff <crwulff@gmail.com>, Marek Vasut <marex@denx.de>,
        Stafford Horne <shorne@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Max Filippov <jcmvbkbc@gmail.com>,
        qemu-ppc@nongnu.org (open list:sPAPR),
        qemu-arm@nongnu.org (open list:ARM TCG CPUs),
        kvm@vger.kernel.org (open list:Overall KVM CPUs),
        qemu-riscv@nongnu.org (open list:RISC-V TCG CPUs),
        qemu-s390x@nongnu.org (open list:S390 general arch...)
Subject: [PATCH v2 1/7] target: rename all *_do_interupt functions to _do_interrupt_locked
Date:   Wed, 19 Aug 2020 14:28:50 -0400
Message-Id: <20200819182856.4893-2-robert.foley@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200819182856.4893-1-robert.foley@linaro.org>
References: <20200819182856.4893-1-robert.foley@linaro.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The rename of all *_do_interrupt functions to *_do_interrupt_locked
is preparation for pushing the BQL lock around these functions
down into the per-arch implementation of *_do_interrupt.
In a later patch which pushes down the lock, we will add
a new *_do_interrupt function which grabs the BQL and calls to
*_do_interrupt_locked.

This is the first patch in a series of transitions to move the
BQL down into the do_interrupt per arch function.  This set of
transitions is needed to maintain bisectability.

The purpose of this set of changes is to set the groundwork
so that an arch could move towards removing
the BQL from the cpu_handle_interrupt/exception paths.

This approach was suggested by Paolo Bonzini.
For reference, here are key posts in the discussion, explaining
the reasoning/benefits of this approach.

https://lists.gnu.org/archive/html/qemu-devel/2020-08/msg00784.html
https://lists.gnu.org/archive/html/qemu-devel/2020-08/msg01517.html
https://lists.gnu.org/archive/html/qemu-devel/2020-07/msg08731.html
https://lists.gnu.org/archive/html/qemu-devel/2020-08/msg00044.html

Signed-off-by: Robert Foley <robert.foley@linaro.org>
---
 hw/ppc/spapr_events.c           |  2 +-
 target/alpha/cpu.c              |  2 +-
 target/alpha/cpu.h              |  2 +-
 target/alpha/helper.c           |  4 ++--
 target/arm/cpu.c                |  2 +-
 target/arm/cpu.h                |  4 ++--
 target/arm/cpu_tcg.c            |  2 +-
 target/arm/helper.c             |  2 +-
 target/arm/m_helper.c           |  2 +-
 target/avr/cpu.c                |  2 +-
 target/avr/cpu.h                |  2 +-
 target/avr/helper.c             |  2 +-
 target/cris/cpu.c               | 12 ++++++------
 target/cris/cpu.h               |  4 ++--
 target/cris/helper.c            | 10 +++++-----
 target/hppa/cpu.c               |  2 +-
 target/hppa/cpu.h               |  2 +-
 target/hppa/int_helper.c        |  4 ++--
 target/i386/cpu.c               |  2 +-
 target/i386/cpu.h               |  2 +-
 target/i386/seg_helper.c        |  2 +-
 target/lm32/cpu.c               |  2 +-
 target/lm32/cpu.h               |  2 +-
 target/lm32/helper.c            |  4 ++--
 target/m68k/cpu.c               |  2 +-
 target/m68k/cpu.h               |  2 +-
 target/m68k/op_helper.c         |  4 ++--
 target/microblaze/cpu.c         |  2 +-
 target/microblaze/cpu.h         |  2 +-
 target/microblaze/helper.c      |  6 +++---
 target/mips/cpu.c               |  2 +-
 target/mips/helper.c            |  4 ++--
 target/mips/internal.h          |  2 +-
 target/moxie/cpu.c              |  2 +-
 target/moxie/cpu.h              |  2 +-
 target/moxie/helper.c           |  2 +-
 target/nios2/cpu.c              |  4 ++--
 target/nios2/cpu.h              |  2 +-
 target/nios2/helper.c           |  4 ++--
 target/openrisc/cpu.c           |  2 +-
 target/openrisc/cpu.h           |  2 +-
 target/openrisc/interrupt.c     |  4 ++--
 target/ppc/cpu.h                |  2 +-
 target/ppc/excp_helper.c        |  4 ++--
 target/ppc/kvm.c                |  2 +-
 target/ppc/translate_init.inc.c |  2 +-
 target/riscv/cpu.c              |  2 +-
 target/riscv/cpu.h              |  2 +-
 target/riscv/cpu_helper.c       |  4 ++--
 target/rx/cpu.c                 |  2 +-
 target/rx/cpu.h                 |  2 +-
 target/rx/helper.c              |  4 ++--
 target/s390x/cpu.c              |  2 +-
 target/s390x/excp_helper.c      |  6 +++---
 target/s390x/internal.h         |  2 +-
 target/sh4/cpu.c                |  2 +-
 target/sh4/cpu.h                |  2 +-
 target/sh4/helper.c             |  6 +++---
 target/sparc/cpu.c              |  4 ++--
 target/sparc/cpu.h              |  2 +-
 target/sparc/int32_helper.c     |  2 +-
 target/sparc/int64_helper.c     |  2 +-
 target/tilegx/cpu.c             |  6 +++---
 target/unicore32/cpu.c          |  2 +-
 target/unicore32/cpu.h          |  2 +-
 target/unicore32/helper.c       |  2 +-
 target/unicore32/softmmu.c      |  2 +-
 target/xtensa/cpu.c             |  2 +-
 target/xtensa/cpu.h             |  2 +-
 target/xtensa/exc_helper.c      |  6 +++---
 70 files changed, 103 insertions(+), 103 deletions(-)

diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
index 1069d0197b..b281022e20 100644
--- a/hw/ppc/spapr_events.c
+++ b/hw/ppc/spapr_events.c
@@ -879,7 +879,7 @@ void spapr_mce_req_event(PowerPCCPU *cpu, bool recovered)
     if (spapr->fwnmi_machine_check_addr == -1) {
         /* Non-FWNMI case, deliver it like an architected CPU interrupt. */
         cs->exception_index = POWERPC_EXCP_MCHECK;
-        ppc_cpu_do_interrupt(cs);
+        ppc_cpu_do_interrupt_locked(cs);
         return;
     }
 
diff --git a/target/alpha/cpu.c b/target/alpha/cpu.c
index 09677c6c44..cb1074e0f9 100644
--- a/target/alpha/cpu.c
+++ b/target/alpha/cpu.c
@@ -217,7 +217,7 @@ static void alpha_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = alpha_cpu_class_by_name;
     cc->has_work = alpha_cpu_has_work;
-    cc->do_interrupt = alpha_cpu_do_interrupt;
+    cc->do_interrupt = alpha_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = alpha_cpu_exec_interrupt;
     cc->dump_state = alpha_cpu_dump_state;
     cc->set_pc = alpha_cpu_set_pc;
diff --git a/target/alpha/cpu.h b/target/alpha/cpu.h
index be29bdd530..4c6753df34 100644
--- a/target/alpha/cpu.h
+++ b/target/alpha/cpu.h
@@ -276,7 +276,7 @@ struct AlphaCPU {
 extern const VMStateDescription vmstate_alpha_cpu;
 #endif
 
-void alpha_cpu_do_interrupt(CPUState *cpu);
+void alpha_cpu_do_interrupt_locked(CPUState *cpu);
 bool alpha_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void alpha_cpu_dump_state(CPUState *cs, FILE *f, int flags);
 hwaddr alpha_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
diff --git a/target/alpha/helper.c b/target/alpha/helper.c
index 55d7274d94..ff9a2a7765 100644
--- a/target/alpha/helper.c
+++ b/target/alpha/helper.c
@@ -295,7 +295,7 @@ bool alpha_cpu_tlb_fill(CPUState *cs, vaddr addr, int size,
 }
 #endif /* USER_ONLY */
 
-void alpha_cpu_do_interrupt(CPUState *cs)
+void alpha_cpu_do_interrupt_locked(CPUState *cs)
 {
     AlphaCPU *cpu = ALPHA_CPU(cs);
     CPUAlphaState *env = &cpu->env;
@@ -445,7 +445,7 @@ bool alpha_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
     if (idx >= 0) {
         cs->exception_index = idx;
         env->error_code = 0;
-        alpha_cpu_do_interrupt(cs);
+        alpha_cpu_do_interrupt_locked(cs);
         return true;
     }
     return false;
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 401832ea95..46c1d92080 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2224,7 +2224,7 @@ static void arm_cpu_class_init(ObjectClass *oc, void *data)
     cc->gdb_read_register = arm_cpu_gdb_read_register;
     cc->gdb_write_register = arm_cpu_gdb_write_register;
 #ifndef CONFIG_USER_ONLY
-    cc->do_interrupt = arm_cpu_do_interrupt;
+    cc->do_interrupt = arm_cpu_do_interrupt_locked;
     cc->get_phys_page_attrs_debug = arm_cpu_get_phys_page_attrs_debug;
     cc->asidx_from_attrs = arm_asidx_from_attrs;
     cc->vmsd = &vmstate_arm_cpu;
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 9e8ed423ea..1f522964b5 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -991,8 +991,8 @@ uint64_t arm_cpu_mp_affinity(int idx, uint8_t clustersz);
 extern const VMStateDescription vmstate_arm_cpu;
 #endif
 
-void arm_cpu_do_interrupt(CPUState *cpu);
-void arm_v7m_cpu_do_interrupt(CPUState *cpu);
+void arm_cpu_do_interrupt_locked(CPUState *cpu);
+void arm_v7m_cpu_do_interrupt_locked(CPUState *cpu);
 bool arm_cpu_exec_interrupt(CPUState *cpu, int int_req);
 
 hwaddr arm_cpu_get_phys_page_attrs_debug(CPUState *cpu, vaddr addr,
diff --git a/target/arm/cpu_tcg.c b/target/arm/cpu_tcg.c
index 00b0e08f33..2fc7a29340 100644
--- a/target/arm/cpu_tcg.c
+++ b/target/arm/cpu_tcg.c
@@ -601,7 +601,7 @@ static void arm_v7m_class_init(ObjectClass *oc, void *data)
 
     acc->info = data;
 #ifndef CONFIG_USER_ONLY
-    cc->do_interrupt = arm_v7m_cpu_do_interrupt;
+    cc->do_interrupt = arm_v7m_cpu_do_interrupt_locked;
 #endif
 
     cc->cpu_exec_interrupt = arm_v7m_cpu_exec_interrupt;
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 0ef0ef65dd..e07924daf5 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -9845,7 +9845,7 @@ static void handle_semihosting(CPUState *cs)
  * to the AArch64-entry or AArch32-entry function depending on the
  * target exception level's register width.
  */
-void arm_cpu_do_interrupt(CPUState *cs)
+void arm_cpu_do_interrupt_locked(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
diff --git a/target/arm/m_helper.c b/target/arm/m_helper.c
index 036454234c..ca65b89fae 100644
--- a/target/arm/m_helper.c
+++ b/target/arm/m_helper.c
@@ -2039,7 +2039,7 @@ gen_invep:
     return false;
 }
 
-void arm_v7m_cpu_do_interrupt(CPUState *cs)
+void arm_v7m_cpu_do_interrupt_locked(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
diff --git a/target/avr/cpu.c b/target/avr/cpu.c
index 5d9c4ad5bf..d856069230 100644
--- a/target/avr/cpu.c
+++ b/target/avr/cpu.c
@@ -197,7 +197,7 @@ static void avr_cpu_class_init(ObjectClass *oc, void *data)
     cc->class_by_name = avr_cpu_class_by_name;
 
     cc->has_work = avr_cpu_has_work;
-    cc->do_interrupt = avr_cpu_do_interrupt;
+    cc->do_interrupt = avr_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = avr_cpu_exec_interrupt;
     cc->dump_state = avr_cpu_dump_state;
     cc->set_pc = avr_cpu_set_pc;
diff --git a/target/avr/cpu.h b/target/avr/cpu.h
index d148e8c75a..66a26f08ef 100644
--- a/target/avr/cpu.h
+++ b/target/avr/cpu.h
@@ -156,7 +156,7 @@ typedef struct AVRCPU {
 
 extern const struct VMStateDescription vms_avr_cpu;
 
-void avr_cpu_do_interrupt(CPUState *cpu);
+void avr_cpu_do_interrupt_locked(CPUState *cpu);
 bool avr_cpu_exec_interrupt(CPUState *cpu, int int_req);
 hwaddr avr_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
 int avr_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
diff --git a/target/avr/helper.c b/target/avr/helper.c
index d96d14372b..096bc35945 100644
--- a/target/avr/helper.c
+++ b/target/avr/helper.c
@@ -56,7 +56,7 @@ bool avr_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
     return ret;
 }
 
-void avr_cpu_do_interrupt(CPUState *cs)
+void avr_cpu_do_interrupt_locked(CPUState *cs)
 {
     AVRCPU *cpu = AVR_CPU(cs);
     CPUAVRState *env = &cpu->env;
diff --git a/target/cris/cpu.c b/target/cris/cpu.c
index 6d7e266042..40b110f161 100644
--- a/target/cris/cpu.c
+++ b/target/cris/cpu.c
@@ -199,7 +199,7 @@ static void crisv8_cpu_class_init(ObjectClass *oc, void *data)
     CRISCPUClass *ccc = CRIS_CPU_CLASS(oc);
 
     ccc->vr = 8;
-    cc->do_interrupt = crisv10_cpu_do_interrupt;
+    cc->do_interrupt = crisv10_cpu_do_interrupt_locked;
     cc->gdb_read_register = crisv10_cpu_gdb_read_register;
     cc->tcg_initialize = cris_initialize_crisv10_tcg;
 }
@@ -210,7 +210,7 @@ static void crisv9_cpu_class_init(ObjectClass *oc, void *data)
     CRISCPUClass *ccc = CRIS_CPU_CLASS(oc);
 
     ccc->vr = 9;
-    cc->do_interrupt = crisv10_cpu_do_interrupt;
+    cc->do_interrupt = crisv10_cpu_do_interrupt_locked;
     cc->gdb_read_register = crisv10_cpu_gdb_read_register;
     cc->tcg_initialize = cris_initialize_crisv10_tcg;
 }
@@ -221,7 +221,7 @@ static void crisv10_cpu_class_init(ObjectClass *oc, void *data)
     CRISCPUClass *ccc = CRIS_CPU_CLASS(oc);
 
     ccc->vr = 10;
-    cc->do_interrupt = crisv10_cpu_do_interrupt;
+    cc->do_interrupt = crisv10_cpu_do_interrupt_locked;
     cc->gdb_read_register = crisv10_cpu_gdb_read_register;
     cc->tcg_initialize = cris_initialize_crisv10_tcg;
 }
@@ -232,7 +232,7 @@ static void crisv11_cpu_class_init(ObjectClass *oc, void *data)
     CRISCPUClass *ccc = CRIS_CPU_CLASS(oc);
 
     ccc->vr = 11;
-    cc->do_interrupt = crisv10_cpu_do_interrupt;
+    cc->do_interrupt = crisv10_cpu_do_interrupt_locked;
     cc->gdb_read_register = crisv10_cpu_gdb_read_register;
     cc->tcg_initialize = cris_initialize_crisv10_tcg;
 }
@@ -243,7 +243,7 @@ static void crisv17_cpu_class_init(ObjectClass *oc, void *data)
     CRISCPUClass *ccc = CRIS_CPU_CLASS(oc);
 
     ccc->vr = 17;
-    cc->do_interrupt = crisv10_cpu_do_interrupt;
+    cc->do_interrupt = crisv10_cpu_do_interrupt_locked;
     cc->gdb_read_register = crisv10_cpu_gdb_read_register;
     cc->tcg_initialize = cris_initialize_crisv10_tcg;
 }
@@ -268,7 +268,7 @@ static void cris_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = cris_cpu_class_by_name;
     cc->has_work = cris_cpu_has_work;
-    cc->do_interrupt = cris_cpu_do_interrupt;
+    cc->do_interrupt = cris_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = cris_cpu_exec_interrupt;
     cc->dump_state = cris_cpu_dump_state;
     cc->set_pc = cris_cpu_set_pc;
diff --git a/target/cris/cpu.h b/target/cris/cpu.h
index 8f08d7628b..597ccd6451 100644
--- a/target/cris/cpu.h
+++ b/target/cris/cpu.h
@@ -187,8 +187,8 @@ struct CRISCPU {
 extern const VMStateDescription vmstate_cris_cpu;
 #endif
 
-void cris_cpu_do_interrupt(CPUState *cpu);
-void crisv10_cpu_do_interrupt(CPUState *cpu);
+void cris_cpu_do_interrupt_locked(CPUState *cpu);
+void crisv10_cpu_do_interrupt_locked(CPUState *cpu);
 bool cris_cpu_exec_interrupt(CPUState *cpu, int int_req);
 
 void cris_cpu_dump_state(CPUState *cs, FILE *f, int flags);
diff --git a/target/cris/helper.c b/target/cris/helper.c
index 67946d9246..e0ee6b4e05 100644
--- a/target/cris/helper.c
+++ b/target/cris/helper.c
@@ -40,7 +40,7 @@
 
 #if defined(CONFIG_USER_ONLY)
 
-void cris_cpu_do_interrupt(CPUState *cs)
+void cris_cpu_do_interrupt_locked(CPUState *cs)
 {
     CRISCPU *cpu = CRIS_CPU(cs);
     CPUCRISState *env = &cpu->env;
@@ -49,9 +49,9 @@ void cris_cpu_do_interrupt(CPUState *cs)
     env->pregs[PR_ERP] = env->pc;
 }
 
-void crisv10_cpu_do_interrupt(CPUState *cs)
+void crisv10_cpu_do_interrupt_locked(CPUState *cs)
 {
-    cris_cpu_do_interrupt(cs);
+    cris_cpu_do_interrupt_locked(cs);
 }
 
 bool cris_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
@@ -123,7 +123,7 @@ bool cris_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
     cpu_loop_exit(cs);
 }
 
-void crisv10_cpu_do_interrupt(CPUState *cs)
+void crisv10_cpu_do_interrupt_locked(CPUState *cs)
 {
     CRISCPU *cpu = CRIS_CPU(cs);
     CPUCRISState *env = &cpu->env;
@@ -185,7 +185,7 @@ void crisv10_cpu_do_interrupt(CPUState *cs)
                   env->pregs[PR_ERP]);
 }
 
-void cris_cpu_do_interrupt(CPUState *cs)
+void cris_cpu_do_interrupt_locked(CPUState *cs)
 {
     CRISCPU *cpu = CRIS_CPU(cs);
     CPUCRISState *env = &cpu->env;
diff --git a/target/hppa/cpu.c b/target/hppa/cpu.c
index 287055f96e..7241ffbd7f 100644
--- a/target/hppa/cpu.c
+++ b/target/hppa/cpu.c
@@ -139,7 +139,7 @@ static void hppa_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = hppa_cpu_class_by_name;
     cc->has_work = hppa_cpu_has_work;
-    cc->do_interrupt = hppa_cpu_do_interrupt;
+    cc->do_interrupt = hppa_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = hppa_cpu_exec_interrupt;
     cc->dump_state = hppa_cpu_dump_state;
     cc->set_pc = hppa_cpu_set_pc;
diff --git a/target/hppa/cpu.h b/target/hppa/cpu.h
index 801a4fb1ba..7fc7682ca8 100644
--- a/target/hppa/cpu.h
+++ b/target/hppa/cpu.h
@@ -323,7 +323,7 @@ int cpu_hppa_signal_handler(int host_signum, void *pinfo, void *puc);
 hwaddr hppa_cpu_get_phys_page_debug(CPUState *cs, vaddr addr);
 int hppa_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
 int hppa_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, int reg);
-void hppa_cpu_do_interrupt(CPUState *cpu);
+void hppa_cpu_do_interrupt_locked(CPUState *cpu);
 bool hppa_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void hppa_cpu_dump_state(CPUState *cs, FILE *f, int);
 bool hppa_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
diff --git a/target/hppa/int_helper.c b/target/hppa/int_helper.c
index 462747baf8..31fce959d6 100644
--- a/target/hppa/int_helper.c
+++ b/target/hppa/int_helper.c
@@ -90,7 +90,7 @@ void HELPER(write_eiem)(CPUHPPAState *env, target_ureg val)
 }
 #endif /* !CONFIG_USER_ONLY */
 
-void hppa_cpu_do_interrupt(CPUState *cs)
+void hppa_cpu_do_interrupt_locked(CPUState *cs)
 {
     HPPACPU *cpu = HPPA_CPU(cs);
     CPUHPPAState *env = &cpu->env;
@@ -255,7 +255,7 @@ bool hppa_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
     /* If interrupts are requested and enabled, raise them.  */
     if ((env->psw & PSW_I) && (interrupt_request & CPU_INTERRUPT_HARD)) {
         cs->exception_index = EXCP_EXT_INTERRUPT;
-        hppa_cpu_do_interrupt(cs);
+        hppa_cpu_do_interrupt_locked(cs);
         return true;
     }
 #endif
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 592aa0baf7..fdb8ae11b6 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7297,7 +7297,7 @@ static void x86_cpu_common_class_init(ObjectClass *oc, void *data)
     cc->parse_features = x86_cpu_parse_featurestr;
     cc->has_work = x86_cpu_has_work;
 #ifdef CONFIG_TCG
-    cc->do_interrupt = x86_cpu_do_interrupt;
+    cc->do_interrupt = x86_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = x86_cpu_exec_interrupt;
 #endif
     cc->dump_state = x86_cpu_dump_state;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d784eeaf29..8d4dac129b 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1770,7 +1770,7 @@ extern VMStateDescription vmstate_x86_cpu;
  * x86_cpu_do_interrupt:
  * @cpu: vCPU the interrupt is to be handled by.
  */
-void x86_cpu_do_interrupt(CPUState *cpu);
+void x86_cpu_do_interrupt_locked(CPUState *cpu);
 bool x86_cpu_exec_interrupt(CPUState *cpu, int int_req);
 int x86_cpu_pending_interrupt(CPUState *cs, int interrupt_request);
 
diff --git a/target/i386/seg_helper.c b/target/i386/seg_helper.c
index 818f65f35f..0d8464abec 100644
--- a/target/i386/seg_helper.c
+++ b/target/i386/seg_helper.c
@@ -1280,7 +1280,7 @@ static void do_interrupt_all(X86CPU *cpu, int intno, int is_int,
 #endif
 }
 
-void x86_cpu_do_interrupt(CPUState *cs)
+void x86_cpu_do_interrupt_locked(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
diff --git a/target/lm32/cpu.c b/target/lm32/cpu.c
index 9e7d8ca929..93da742520 100644
--- a/target/lm32/cpu.c
+++ b/target/lm32/cpu.c
@@ -222,7 +222,7 @@ static void lm32_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = lm32_cpu_class_by_name;
     cc->has_work = lm32_cpu_has_work;
-    cc->do_interrupt = lm32_cpu_do_interrupt;
+    cc->do_interrupt = lm32_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = lm32_cpu_exec_interrupt;
     cc->dump_state = lm32_cpu_dump_state;
     cc->set_pc = lm32_cpu_set_pc;
diff --git a/target/lm32/cpu.h b/target/lm32/cpu.h
index 01d408eb55..cd96a2905e 100644
--- a/target/lm32/cpu.h
+++ b/target/lm32/cpu.h
@@ -198,7 +198,7 @@ struct LM32CPU {
 extern const VMStateDescription vmstate_lm32_cpu;
 #endif
 
-void lm32_cpu_do_interrupt(CPUState *cpu);
+void lm32_cpu_do_interrupt_locked(CPUState *cpu);
 bool lm32_cpu_exec_interrupt(CPUState *cs, int int_req);
 void lm32_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 hwaddr lm32_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
diff --git a/target/lm32/helper.c b/target/lm32/helper.c
index 1130fc8884..8599a59df2 100644
--- a/target/lm32/helper.c
+++ b/target/lm32/helper.c
@@ -148,7 +148,7 @@ void lm32_debug_excp_handler(CPUState *cs)
     }
 }
 
-void lm32_cpu_do_interrupt(CPUState *cs)
+void lm32_cpu_do_interrupt_locked(CPUState *cs)
 {
     LM32CPU *cpu = LM32_CPU(cs);
     CPULM32State *env = &cpu->env;
@@ -205,7 +205,7 @@ bool lm32_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 
     if ((interrupt_request & CPU_INTERRUPT_HARD) && (env->ie & IE_IE)) {
         cs->exception_index = EXCP_IRQ;
-        lm32_cpu_do_interrupt(cs);
+        lm32_cpu_do_interrupt_locked(cs);
         return true;
     }
     return false;
diff --git a/target/m68k/cpu.c b/target/m68k/cpu.c
index f2585154f5..6ac0dd87a6 100644
--- a/target/m68k/cpu.c
+++ b/target/m68k/cpu.c
@@ -277,7 +277,7 @@ static void m68k_cpu_class_init(ObjectClass *c, void *data)
 
     cc->class_by_name = m68k_cpu_class_by_name;
     cc->has_work = m68k_cpu_has_work;
-    cc->do_interrupt = m68k_cpu_do_interrupt;
+    cc->do_interrupt = m68k_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = m68k_cpu_exec_interrupt;
     cc->dump_state = m68k_cpu_dump_state;
     cc->set_pc = m68k_cpu_set_pc;
diff --git a/target/m68k/cpu.h b/target/m68k/cpu.h
index 521ac67cdd..1afbe94570 100644
--- a/target/m68k/cpu.h
+++ b/target/m68k/cpu.h
@@ -164,7 +164,7 @@ struct M68kCPU {
 };
 
 
-void m68k_cpu_do_interrupt(CPUState *cpu);
+void m68k_cpu_do_interrupt_locked(CPUState *cpu);
 bool m68k_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void m68k_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 hwaddr m68k_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
diff --git a/target/m68k/op_helper.c b/target/m68k/op_helper.c
index 4a032a150e..8fd6481883 100644
--- a/target/m68k/op_helper.c
+++ b/target/m68k/op_helper.c
@@ -25,7 +25,7 @@
 
 #if defined(CONFIG_USER_ONLY)
 
-void m68k_cpu_do_interrupt(CPUState *cs)
+void m68k_cpu_do_interrupt_locked(CPUState *cs)
 {
     cs->exception_index = -1;
 }
@@ -443,7 +443,7 @@ static void do_interrupt_all(CPUM68KState *env, int is_hw)
     cf_interrupt_all(env, is_hw);
 }
 
-void m68k_cpu_do_interrupt(CPUState *cs)
+void m68k_cpu_do_interrupt_locked(CPUState *cs)
 {
     M68kCPU *cpu = M68K_CPU(cs);
     CPUM68KState *env = &cpu->env;
diff --git a/target/microblaze/cpu.c b/target/microblaze/cpu.c
index ce70f7d281..b19e386bcf 100644
--- a/target/microblaze/cpu.c
+++ b/target/microblaze/cpu.c
@@ -316,7 +316,7 @@ static void mb_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = mb_cpu_class_by_name;
     cc->has_work = mb_cpu_has_work;
-    cc->do_interrupt = mb_cpu_do_interrupt;
+    cc->do_interrupt = mb_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = mb_cpu_exec_interrupt;
     cc->dump_state = mb_cpu_dump_state;
     cc->set_pc = mb_cpu_set_pc;
diff --git a/target/microblaze/cpu.h b/target/microblaze/cpu.h
index a31134b65c..7617565a0c 100644
--- a/target/microblaze/cpu.h
+++ b/target/microblaze/cpu.h
@@ -315,7 +315,7 @@ struct MicroBlazeCPU {
 };
 
 
-void mb_cpu_do_interrupt(CPUState *cs);
+void mb_cpu_do_interrupt_locked(CPUState *cs);
 bool mb_cpu_exec_interrupt(CPUState *cs, int int_req);
 void mb_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 hwaddr mb_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
diff --git a/target/microblaze/helper.c b/target/microblaze/helper.c
index ab2ceeb055..263cdf59be 100644
--- a/target/microblaze/helper.c
+++ b/target/microblaze/helper.c
@@ -28,7 +28,7 @@
 
 #if defined(CONFIG_USER_ONLY)
 
-void mb_cpu_do_interrupt(CPUState *cs)
+void mb_cpu_do_interrupt_locked(CPUState *cs)
 {
     MicroBlazeCPU *cpu = MICROBLAZE_CPU(cs);
     CPUMBState *env = &cpu->env;
@@ -108,7 +108,7 @@ bool mb_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
     cpu_loop_exit_restore(cs, retaddr);
 }
 
-void mb_cpu_do_interrupt(CPUState *cs)
+void mb_cpu_do_interrupt_locked(CPUState *cs)
 {
     MicroBlazeCPU *cpu = MICROBLAZE_CPU(cs);
     CPUMBState *env = &cpu->env;
@@ -297,7 +297,7 @@ bool mb_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
         && !(env->sregs[SR_MSR] & (MSR_EIP | MSR_BIP))
         && !(env->iflags & (D_FLAG | IMM_FLAG))) {
         cs->exception_index = EXCP_IRQ;
-        mb_cpu_do_interrupt(cs);
+        mb_cpu_do_interrupt_locked(cs);
         return true;
     }
     return false;
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index ec9dde5100..c616a0ef5a 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -196,7 +196,7 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
 
     cc->class_by_name = mips_cpu_class_by_name;
     cc->has_work_with_iothread_lock = mips_cpu_has_work;
-    cc->do_interrupt = mips_cpu_do_interrupt;
+    cc->do_interrupt = mips_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = mips_cpu_exec_interrupt;
     cc->dump_state = mips_cpu_dump_state;
     cc->set_pc = mips_cpu_set_pc;
diff --git a/target/mips/helper.c b/target/mips/helper.c
index afd78b1990..a85c4057d0 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -1083,7 +1083,7 @@ static inline void set_badinstr_registers(CPUMIPSState *env)
 }
 #endif
 
-void mips_cpu_do_interrupt(CPUState *cs)
+void mips_cpu_do_interrupt_locked(CPUState *cs)
 {
 #if !defined(CONFIG_USER_ONLY)
     MIPSCPU *cpu = MIPS_CPU(cs);
@@ -1409,7 +1409,7 @@ bool mips_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
             /* Raise it */
             cs->exception_index = EXCP_EXT_INTERRUPT;
             env->error_code = 0;
-            mips_cpu_do_interrupt(cs);
+            mips_cpu_do_interrupt_locked(cs);
             return true;
         }
     }
diff --git a/target/mips/internal.h b/target/mips/internal.h
index 7f159a9230..fb0181c095 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -80,7 +80,7 @@ enum CPUMIPSMSADataFormat {
     DF_DOUBLE
 };
 
-void mips_cpu_do_interrupt(CPUState *cpu);
+void mips_cpu_do_interrupt_locked(CPUState *cpu);
 bool mips_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void mips_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 hwaddr mips_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
diff --git a/target/moxie/cpu.c b/target/moxie/cpu.c
index f823eb234d..bba886cfe1 100644
--- a/target/moxie/cpu.c
+++ b/target/moxie/cpu.c
@@ -107,7 +107,7 @@ static void moxie_cpu_class_init(ObjectClass *oc, void *data)
     cc->class_by_name = moxie_cpu_class_by_name;
 
     cc->has_work = moxie_cpu_has_work;
-    cc->do_interrupt = moxie_cpu_do_interrupt;
+    cc->do_interrupt = moxie_cpu_do_interrupt_locked;
     cc->dump_state = moxie_cpu_dump_state;
     cc->set_pc = moxie_cpu_set_pc;
     cc->tlb_fill = moxie_cpu_tlb_fill;
diff --git a/target/moxie/cpu.h b/target/moxie/cpu.h
index 455553b794..1a47ce4d8c 100644
--- a/target/moxie/cpu.h
+++ b/target/moxie/cpu.h
@@ -88,7 +88,7 @@ typedef struct MoxieCPU {
 } MoxieCPU;
 
 
-void moxie_cpu_do_interrupt(CPUState *cs);
+void moxie_cpu_do_interrupt_locked(CPUState *cs);
 void moxie_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 hwaddr moxie_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
 void moxie_translate_init(void);
diff --git a/target/moxie/helper.c b/target/moxie/helper.c
index b1919f62b3..c222895ca5 100644
--- a/target/moxie/helper.c
+++ b/target/moxie/helper.c
@@ -95,7 +95,7 @@ bool moxie_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
     cpu_loop_exit_restore(cs, retaddr);
 }
 
-void moxie_cpu_do_interrupt(CPUState *cs)
+void moxie_cpu_do_interrupt_locked(CPUState *cs)
 {
     switch (cs->exception_index) {
     case MOXIE_EX_BREAK:
diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index fe5fd9adfd..cc813181a4 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -106,7 +106,7 @@ static bool nios2_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
     if ((interrupt_request & CPU_INTERRUPT_HARD) &&
         (env->regs[CR_STATUS] & CR_STATUS_PIE)) {
         cs->exception_index = EXCP_IRQ;
-        nios2_cpu_do_interrupt(cs);
+        nios2_cpu_do_interrupt_locked(cs);
         return true;
     }
     return false;
@@ -192,7 +192,7 @@ static void nios2_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = nios2_cpu_class_by_name;
     cc->has_work = nios2_cpu_has_work;
-    cc->do_interrupt = nios2_cpu_do_interrupt;
+    cc->do_interrupt = nios2_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = nios2_cpu_exec_interrupt;
     cc->dump_state = nios2_cpu_dump_state;
     cc->set_pc = nios2_cpu_set_pc;
diff --git a/target/nios2/cpu.h b/target/nios2/cpu.h
index 4dddf9c3a1..dcf1715092 100644
--- a/target/nios2/cpu.h
+++ b/target/nios2/cpu.h
@@ -195,7 +195,7 @@ typedef struct Nios2CPU {
 
 
 void nios2_tcg_init(void);
-void nios2_cpu_do_interrupt(CPUState *cs);
+void nios2_cpu_do_interrupt_locked(CPUState *cs);
 int cpu_nios2_signal_handler(int host_signum, void *pinfo, void *puc);
 void dump_mmu(CPUNios2State *env);
 void nios2_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
diff --git a/target/nios2/helper.c b/target/nios2/helper.c
index 57c97bde3c..25c6c6d4d8 100644
--- a/target/nios2/helper.c
+++ b/target/nios2/helper.c
@@ -30,7 +30,7 @@
 
 #if defined(CONFIG_USER_ONLY)
 
-void nios2_cpu_do_interrupt(CPUState *cs)
+void nios2_cpu_do_interrupt_locked(CPUState *cs)
 {
     Nios2CPU *cpu = NIOS2_CPU(cs);
     CPUNios2State *env = &cpu->env;
@@ -48,7 +48,7 @@ bool nios2_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
 
 #else /* !CONFIG_USER_ONLY */
 
-void nios2_cpu_do_interrupt(CPUState *cs)
+void nios2_cpu_do_interrupt_locked(CPUState *cs)
 {
     Nios2CPU *cpu = NIOS2_CPU(cs);
     CPUNios2State *env = &cpu->env;
diff --git a/target/openrisc/cpu.c b/target/openrisc/cpu.c
index fd2da39124..e428946dc2 100644
--- a/target/openrisc/cpu.c
+++ b/target/openrisc/cpu.c
@@ -154,7 +154,7 @@ static void openrisc_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = openrisc_cpu_class_by_name;
     cc->has_work = openrisc_cpu_has_work;
-    cc->do_interrupt = openrisc_cpu_do_interrupt;
+    cc->do_interrupt = openrisc_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = openrisc_cpu_exec_interrupt;
     cc->dump_state = openrisc_cpu_dump_state;
     cc->set_pc = openrisc_cpu_set_pc;
diff --git a/target/openrisc/cpu.h b/target/openrisc/cpu.h
index f37a52e153..e77f075cd9 100644
--- a/target/openrisc/cpu.h
+++ b/target/openrisc/cpu.h
@@ -316,7 +316,7 @@ typedef struct OpenRISCCPU {
 
 
 void cpu_openrisc_list(void);
-void openrisc_cpu_do_interrupt(CPUState *cpu);
+void openrisc_cpu_do_interrupt_locked(CPUState *cpu);
 bool openrisc_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void openrisc_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 hwaddr openrisc_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
diff --git a/target/openrisc/interrupt.c b/target/openrisc/interrupt.c
index 3eab771dcd..f95289444f 100644
--- a/target/openrisc/interrupt.c
+++ b/target/openrisc/interrupt.c
@@ -26,7 +26,7 @@
 #include "hw/loader.h"
 #endif
 
-void openrisc_cpu_do_interrupt(CPUState *cs)
+void openrisc_cpu_do_interrupt_locked(CPUState *cs)
 {
 #ifndef CONFIG_USER_ONLY
     OpenRISCCPU *cpu = OPENRISC_CPU(cs);
@@ -115,7 +115,7 @@ bool openrisc_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
     }
     if (idx >= 0) {
         cs->exception_index = idx;
-        openrisc_cpu_do_interrupt(cs);
+        openrisc_cpu_do_interrupt_locked(cs);
         return true;
     }
     return false;
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index e7d382ac10..ed297acdb4 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -1231,7 +1231,7 @@ struct PPCVirtualHypervisorClass {
                      TYPE_PPC_VIRTUAL_HYPERVISOR)
 #endif /* CONFIG_USER_ONLY */
 
-void ppc_cpu_do_interrupt(CPUState *cpu);
+void ppc_cpu_do_interrupt_locked(CPUState *cpu);
 bool ppc_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void ppc_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 void ppc_cpu_dump_statistics(CPUState *cpu, int flags);
diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
index bf9e1e27e9..fe9b122fd0 100644
--- a/target/ppc/excp_helper.c
+++ b/target/ppc/excp_helper.c
@@ -38,7 +38,7 @@
 /*****************************************************************************/
 /* Exception processing */
 #if defined(CONFIG_USER_ONLY)
-void ppc_cpu_do_interrupt(CPUState *cs)
+void ppc_cpu_do_interrupt_locked(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
     CPUPPCState *env = &cpu->env;
@@ -865,7 +865,7 @@ static inline void powerpc_excp(PowerPCCPU *cpu, int excp_model, int excp)
     powerpc_set_excp_state(cpu, vector, new_msr);
 }
 
-void ppc_cpu_do_interrupt(CPUState *cs)
+void ppc_cpu_do_interrupt_locked(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
     CPUPPCState *env = &cpu->env;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index f94c45a508..5f0ab06daa 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -1650,7 +1650,7 @@ static int kvm_handle_debug(PowerPCCPU *cpu, struct kvm_run *run)
     env->nip += 4;
     cs->exception_index = POWERPC_EXCP_PROGRAM;
     env->error_code = POWERPC_EXCP_INVAL;
-    ppc_cpu_do_interrupt(cs);
+    ppc_cpu_do_interrupt_locked(cs);
 
     return DEBUG_RETURN_GUEST;
 }
diff --git a/target/ppc/translate_init.inc.c b/target/ppc/translate_init.inc.c
index 27ae7fa195..653b04aef6 100644
--- a/target/ppc/translate_init.inc.c
+++ b/target/ppc/translate_init.inc.c
@@ -10885,7 +10885,7 @@ static void ppc_cpu_class_init(ObjectClass *oc, void *data)
     pcc->parent_parse_features = cc->parse_features;
     cc->parse_features = ppc_cpu_parse_featurestr;
     cc->has_work_with_iothread_lock = ppc_cpu_has_work;
-    cc->do_interrupt = ppc_cpu_do_interrupt;
+    cc->do_interrupt = ppc_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = ppc_cpu_exec_interrupt;
     cc->dump_state = ppc_cpu_dump_state;
     cc->dump_statistics = ppc_cpu_dump_statistics;
diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 832171c360..833e6d4f1e 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -537,7 +537,7 @@ static void riscv_cpu_class_init(ObjectClass *c, void *data)
 
     cc->class_by_name = riscv_cpu_class_by_name;
     cc->has_work_with_iothread_lock = riscv_cpu_has_work;
-    cc->do_interrupt = riscv_cpu_do_interrupt;
+    cc->do_interrupt = riscv_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = riscv_cpu_exec_interrupt;
     cc->dump_state = riscv_cpu_dump_state;
     cc->set_pc = riscv_cpu_set_pc;
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index a804a5d0ba..372005b79c 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -312,7 +312,7 @@ extern const char * const riscv_fpr_regnames[];
 extern const char * const riscv_excp_names[];
 extern const char * const riscv_intr_names[];
 
-void riscv_cpu_do_interrupt(CPUState *cpu);
+void riscv_cpu_do_interrupt_locked(CPUState *cpu);
 int riscv_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
 int riscv_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, int reg);
 bool riscv_cpu_exec_interrupt(CPUState *cs, int interrupt_request);
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index 75d2ae3434..477cf66b66 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -85,7 +85,7 @@ bool riscv_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
         int interruptno = riscv_cpu_local_irq_pending(env);
         if (interruptno >= 0) {
             cs->exception_index = RISCV_EXCP_INT_FLAG | interruptno;
-            riscv_cpu_do_interrupt(cs);
+            riscv_cpu_do_interrupt_locked(cs);
             return true;
         }
     }
@@ -820,7 +820,7 @@ bool riscv_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
  * Adapted from Spike's processor_t::take_trap.
  *
  */
-void riscv_cpu_do_interrupt(CPUState *cs)
+void riscv_cpu_do_interrupt_locked(CPUState *cs)
 {
 #if !defined(CONFIG_USER_ONLY)
 
diff --git a/target/rx/cpu.c b/target/rx/cpu.c
index 219e05397b..51e10da7cc 100644
--- a/target/rx/cpu.c
+++ b/target/rx/cpu.c
@@ -185,7 +185,7 @@ static void rx_cpu_class_init(ObjectClass *klass, void *data)
 
     cc->class_by_name = rx_cpu_class_by_name;
     cc->has_work = rx_cpu_has_work;
-    cc->do_interrupt = rx_cpu_do_interrupt;
+    cc->do_interrupt = rx_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = rx_cpu_exec_interrupt;
     cc->dump_state = rx_cpu_dump_state;
     cc->set_pc = rx_cpu_set_pc;
diff --git a/target/rx/cpu.h b/target/rx/cpu.h
index d1fb1ef3ca..d188e7d43f 100644
--- a/target/rx/cpu.h
+++ b/target/rx/cpu.h
@@ -125,7 +125,7 @@ typedef RXCPU ArchCPU;
 #define CPU_RESOLVING_TYPE TYPE_RX_CPU
 
 const char *rx_crname(uint8_t cr);
-void rx_cpu_do_interrupt(CPUState *cpu);
+void rx_cpu_do_interrupt_locked(CPUState *cpu);
 bool rx_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void rx_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 int rx_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
diff --git a/target/rx/helper.c b/target/rx/helper.c
index a6a337a311..332f89435a 100644
--- a/target/rx/helper.c
+++ b/target/rx/helper.c
@@ -42,7 +42,7 @@ void rx_cpu_unpack_psw(CPURXState *env, uint32_t psw, int rte)
 }
 
 #define INT_FLAGS (CPU_INTERRUPT_HARD | CPU_INTERRUPT_FIR)
-void rx_cpu_do_interrupt(CPUState *cs)
+void rx_cpu_do_interrupt_locked(CPUState *cs)
 {
     RXCPU *cpu = RXCPU(cs);
     CPURXState *env = &cpu->env;
@@ -137,7 +137,7 @@ bool rx_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
         accept = 1;
     }
     if (accept) {
-        rx_cpu_do_interrupt(cs);
+        rx_cpu_do_interrupt_locked(cs);
         return true;
     }
     return false;
diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
index 4d0d323cf9..eb23d64f36 100644
--- a/target/s390x/cpu.c
+++ b/target/s390x/cpu.c
@@ -493,7 +493,7 @@ static void s390_cpu_class_init(ObjectClass *oc, void *data)
     cc->class_by_name = s390_cpu_class_by_name,
     cc->has_work_with_iothread_lock = s390_cpu_has_work;
 #ifdef CONFIG_TCG
-    cc->do_interrupt = s390_cpu_do_interrupt;
+    cc->do_interrupt = s390_cpu_do_interrupt_locked;
 #endif
     cc->dump_state = s390_cpu_dump_state;
     cc->set_pc = s390_cpu_set_pc;
diff --git a/target/s390x/excp_helper.c b/target/s390x/excp_helper.c
index dde7afc2f0..a663127f17 100644
--- a/target/s390x/excp_helper.c
+++ b/target/s390x/excp_helper.c
@@ -85,7 +85,7 @@ void HELPER(data_exception)(CPUS390XState *env, uint32_t dxc)
 
 #if defined(CONFIG_USER_ONLY)
 
-void s390_cpu_do_interrupt(CPUState *cs)
+void s390_cpu_do_interrupt_locked(CPUState *cs)
 {
     cs->exception_index = -1;
 }
@@ -464,7 +464,7 @@ static void do_mchk_interrupt(CPUS390XState *env)
     load_psw(env, mask, addr);
 }
 
-void s390_cpu_do_interrupt(CPUState *cs)
+void s390_cpu_do_interrupt_locked(CPUState *cs)
 {
     QEMUS390FLICState *flic = QEMU_S390_FLIC(s390_get_flic());
     S390CPU *cpu = S390_CPU(cs);
@@ -555,7 +555,7 @@ bool s390_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
             return false;
         }
         if (s390_cpu_has_int(cpu)) {
-            s390_cpu_do_interrupt(cs);
+            s390_cpu_do_interrupt_locked(cs);
             return true;
         }
         if (env->psw.mask & PSW_MASK_WAIT) {
diff --git a/target/s390x/internal.h b/target/s390x/internal.h
index b1e0ebf67f..6ab0fb481a 100644
--- a/target/s390x/internal.h
+++ b/target/s390x/internal.h
@@ -268,7 +268,7 @@ ObjectClass *s390_cpu_class_by_name(const char *name);
 
 /* excp_helper.c */
 void s390x_cpu_debug_excp_handler(CPUState *cs);
-void s390_cpu_do_interrupt(CPUState *cpu);
+void s390_cpu_do_interrupt_locked(CPUState *cpu);
 bool s390_cpu_exec_interrupt(CPUState *cpu, int int_req);
 bool s390_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
diff --git a/target/sh4/cpu.c b/target/sh4/cpu.c
index 18f3448183..5e5921a220 100644
--- a/target/sh4/cpu.c
+++ b/target/sh4/cpu.c
@@ -218,7 +218,7 @@ static void superh_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = superh_cpu_class_by_name;
     cc->has_work = superh_cpu_has_work;
-    cc->do_interrupt = superh_cpu_do_interrupt;
+    cc->do_interrupt = superh_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = superh_cpu_exec_interrupt;
     cc->dump_state = superh_cpu_dump_state;
     cc->set_pc = superh_cpu_set_pc;
diff --git a/target/sh4/cpu.h b/target/sh4/cpu.h
index dbe58c7888..2ae3dd132b 100644
--- a/target/sh4/cpu.h
+++ b/target/sh4/cpu.h
@@ -204,7 +204,7 @@ struct SuperHCPU {
 };
 
 
-void superh_cpu_do_interrupt(CPUState *cpu);
+void superh_cpu_do_interrupt_locked(CPUState *cpu);
 bool superh_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void superh_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 hwaddr superh_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
diff --git a/target/sh4/helper.c b/target/sh4/helper.c
index 1e32365c75..2d61f65d50 100644
--- a/target/sh4/helper.c
+++ b/target/sh4/helper.c
@@ -45,7 +45,7 @@
 
 #if defined(CONFIG_USER_ONLY)
 
-void superh_cpu_do_interrupt(CPUState *cs)
+void superh_cpu_do_interrupt_locked(CPUState *cs)
 {
     cs->exception_index = -1;
 }
@@ -58,7 +58,7 @@ int cpu_sh4_is_cached(CPUSH4State *env, target_ulong addr)
 
 #else /* !CONFIG_USER_ONLY */
 
-void superh_cpu_do_interrupt(CPUState *cs)
+void superh_cpu_do_interrupt_locked(CPUState *cs)
 {
     SuperHCPU *cpu = SUPERH_CPU(cs);
     CPUSH4State *env = &cpu->env;
@@ -792,7 +792,7 @@ bool superh_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
         if (env->flags & DELAY_SLOT_MASK) {
             return false;
         } else {
-            superh_cpu_do_interrupt(cs);
+            superh_cpu_do_interrupt_locked(cs);
             return true;
         }
     }
diff --git a/target/sparc/cpu.c b/target/sparc/cpu.c
index 20c7c0c434..4c8842adcf 100644
--- a/target/sparc/cpu.c
+++ b/target/sparc/cpu.c
@@ -89,7 +89,7 @@ static bool sparc_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 
             if (type != TT_EXTINT || cpu_pil_allowed(env, pil)) {
                 cs->exception_index = env->interrupt_index;
-                sparc_cpu_do_interrupt(cs);
+                sparc_cpu_do_interrupt_locked(cs);
                 return true;
             }
         }
@@ -863,7 +863,7 @@ static void sparc_cpu_class_init(ObjectClass *oc, void *data)
     cc->class_by_name = sparc_cpu_class_by_name;
     cc->parse_features = sparc_cpu_parse_features;
     cc->has_work_with_iothread_lock = sparc_cpu_has_work;
-    cc->do_interrupt = sparc_cpu_do_interrupt;
+    cc->do_interrupt = sparc_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = sparc_cpu_exec_interrupt;
     cc->dump_state = sparc_cpu_dump_state;
 #if !defined(TARGET_SPARC64) && !defined(CONFIG_USER_ONLY)
diff --git a/target/sparc/cpu.h b/target/sparc/cpu.h
index b9369398f2..3563e65d73 100644
--- a/target/sparc/cpu.h
+++ b/target/sparc/cpu.h
@@ -568,7 +568,7 @@ struct SPARCCPU {
 extern const VMStateDescription vmstate_sparc_cpu;
 #endif
 
-void sparc_cpu_do_interrupt(CPUState *cpu);
+void sparc_cpu_do_interrupt_locked(CPUState *cpu);
 void sparc_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 hwaddr sparc_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
 int sparc_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
diff --git a/target/sparc/int32_helper.c b/target/sparc/int32_helper.c
index 9a71e1abd8..90f4aa4a78 100644
--- a/target/sparc/int32_helper.c
+++ b/target/sparc/int32_helper.c
@@ -65,7 +65,7 @@ static const char *excp_name_str(int32_t exception_index)
     return excp_names[exception_index];
 }
 
-void sparc_cpu_do_interrupt(CPUState *cs)
+void sparc_cpu_do_interrupt_locked(CPUState *cs)
 {
     SPARCCPU *cpu = SPARC_CPU(cs);
     CPUSPARCState *env = &cpu->env;
diff --git a/target/sparc/int64_helper.c b/target/sparc/int64_helper.c
index f3e7f32de6..b81b4abaa8 100644
--- a/target/sparc/int64_helper.c
+++ b/target/sparc/int64_helper.c
@@ -62,7 +62,7 @@ static const char * const excp_names[0x80] = {
 };
 #endif
 
-void sparc_cpu_do_interrupt(CPUState *cs)
+void sparc_cpu_do_interrupt_locked(CPUState *cs)
 {
     SPARCCPU *cpu = SPARC_CPU(cs);
     CPUSPARCState *env = &cpu->env;
diff --git a/target/tilegx/cpu.c b/target/tilegx/cpu.c
index 1fee87c094..a2ff335977 100644
--- a/target/tilegx/cpu.c
+++ b/target/tilegx/cpu.c
@@ -105,7 +105,7 @@ static void tilegx_cpu_initfn(Object *obj)
     cpu_set_cpustate_pointers(cpu);
 }
 
-static void tilegx_cpu_do_interrupt(CPUState *cs)
+static void tilegx_cpu_do_interrupt_locked(CPUState *cs)
 {
     cs->exception_index = -1;
 }
@@ -128,7 +128,7 @@ static bool tilegx_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
 static bool tilegx_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        tilegx_cpu_do_interrupt(cs);
+        tilegx_cpu_do_interrupt_locked(cs);
         return true;
     }
     return false;
@@ -147,7 +147,7 @@ static void tilegx_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = tilegx_cpu_class_by_name;
     cc->has_work = tilegx_cpu_has_work;
-    cc->do_interrupt = tilegx_cpu_do_interrupt;
+    cc->do_interrupt = tilegx_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = tilegx_cpu_exec_interrupt;
     cc->dump_state = tilegx_cpu_dump_state;
     cc->set_pc = tilegx_cpu_set_pc;
diff --git a/target/unicore32/cpu.c b/target/unicore32/cpu.c
index 06bf4b4b63..a96077d666 100644
--- a/target/unicore32/cpu.c
+++ b/target/unicore32/cpu.c
@@ -131,7 +131,7 @@ static void uc32_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = uc32_cpu_class_by_name;
     cc->has_work = uc32_cpu_has_work;
-    cc->do_interrupt = uc32_cpu_do_interrupt;
+    cc->do_interrupt = uc32_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = uc32_cpu_exec_interrupt;
     cc->dump_state = uc32_cpu_dump_state;
     cc->set_pc = uc32_cpu_set_pc;
diff --git a/target/unicore32/cpu.h b/target/unicore32/cpu.h
index 7a32e086ed..d948392ff3 100644
--- a/target/unicore32/cpu.h
+++ b/target/unicore32/cpu.h
@@ -75,7 +75,7 @@ struct UniCore32CPU {
 };
 
 
-void uc32_cpu_do_interrupt(CPUState *cpu);
+void uc32_cpu_do_interrupt_locked(CPUState *cpu);
 bool uc32_cpu_exec_interrupt(CPUState *cpu, int int_req);
 void uc32_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 hwaddr uc32_cpu_get_phys_page_debug(CPUState *cpu, vaddr addr);
diff --git a/target/unicore32/helper.c b/target/unicore32/helper.c
index 54c26871fe..f024b83bc8 100644
--- a/target/unicore32/helper.c
+++ b/target/unicore32/helper.c
@@ -175,7 +175,7 @@ bool uc32_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 
         if (!(env->uncached_asr & ASR_I)) {
             cs->exception_index = UC32_EXCP_INTR;
-            uc32_cpu_do_interrupt(cs);
+            uc32_cpu_do_interrupt_locked(cs);
             return true;
         }
     }
diff --git a/target/unicore32/softmmu.c b/target/unicore32/softmmu.c
index 9660bd2a27..a12526a8ca 100644
--- a/target/unicore32/softmmu.c
+++ b/target/unicore32/softmmu.c
@@ -75,7 +75,7 @@ void switch_mode(CPUUniCore32State *env, int mode)
 }
 
 /* Handle a CPU exception.  */
-void uc32_cpu_do_interrupt(CPUState *cs)
+void uc32_cpu_do_interrupt_locked(CPUState *cs)
 {
     UniCore32CPU *cpu = UNICORE32_CPU(cs);
     CPUUniCore32State *env = &cpu->env;
diff --git a/target/xtensa/cpu.c b/target/xtensa/cpu.c
index 0f96483563..7962bc66a8 100644
--- a/target/xtensa/cpu.c
+++ b/target/xtensa/cpu.c
@@ -190,7 +190,7 @@ static void xtensa_cpu_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = xtensa_cpu_class_by_name;
     cc->has_work_with_iothread_lock = xtensa_cpu_has_work;
-    cc->do_interrupt = xtensa_cpu_do_interrupt;
+    cc->do_interrupt = xtensa_cpu_do_interrupt_locked;
     cc->cpu_exec_interrupt = xtensa_cpu_exec_interrupt;
     cc->dump_state = xtensa_cpu_dump_state;
     cc->set_pc = xtensa_cpu_set_pc;
diff --git a/target/xtensa/cpu.h b/target/xtensa/cpu.h
index 32749378bf..c02f531b64 100644
--- a/target/xtensa/cpu.h
+++ b/target/xtensa/cpu.h
@@ -563,7 +563,7 @@ struct XtensaCPU {
 bool xtensa_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                          MMUAccessType access_type, int mmu_idx,
                          bool probe, uintptr_t retaddr);
-void xtensa_cpu_do_interrupt(CPUState *cpu);
+void xtensa_cpu_do_interrupt_locked(CPUState *cpu);
 bool xtensa_cpu_exec_interrupt(CPUState *cpu, int interrupt_request);
 void xtensa_cpu_do_transaction_failed(CPUState *cs, hwaddr physaddr, vaddr addr,
                                       unsigned size, MMUAccessType access_type,
diff --git a/target/xtensa/exc_helper.c b/target/xtensa/exc_helper.c
index 01d1e56feb..10d4762f36 100644
--- a/target/xtensa/exc_helper.c
+++ b/target/xtensa/exc_helper.c
@@ -195,7 +195,7 @@ static void handle_interrupt(CPUXtensaState *env)
 }
 
 /* Called from cpu_handle_interrupt with BQL held */
-void xtensa_cpu_do_interrupt(CPUState *cs)
+void xtensa_cpu_do_interrupt_locked(CPUState *cs)
 {
     XtensaCPU *cpu = XTENSA_CPU(cs);
     CPUXtensaState *env = &cpu->env;
@@ -254,7 +254,7 @@ void xtensa_cpu_do_interrupt(CPUState *cs)
     check_interrupts(env);
 }
 #else
-void xtensa_cpu_do_interrupt(CPUState *cs)
+void xtensa_cpu_do_interrupt_locked(CPUState *cs)
 {
 }
 #endif
@@ -263,7 +263,7 @@ bool xtensa_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
         cs->exception_index = EXC_IRQ;
-        xtensa_cpu_do_interrupt(cs);
+        xtensa_cpu_do_interrupt_locked(cs);
         return true;
     }
     return false;
-- 
2.17.1

