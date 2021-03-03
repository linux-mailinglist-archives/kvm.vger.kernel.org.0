Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA0032C720
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbhCDAbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1386546AbhCCS3c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:29:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZTO3x/pXi2BQffGU8Ahgki8e6dMOggVVDCSg/uLSOA=;
        b=XCmf2vXFVaCI5iTGQkmU/lJKNL/i5B7kNe/YGCQhSho6zXNlTeoxQ0Gs1TpuxAtORZfhXv
        VpX/13a7pIdED5ErVa1GZPSx/KlO+lNLWB59x9x8z8ANZO5gNBvy2rpJh0XupTfDgmyheS
        3H4M3+HbIJe5BF05vTUfET9RyEXiYfM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-ihXjdLqIP--Sx2lrLU4Mxw-1; Wed, 03 Mar 2021 13:24:10 -0500
X-MC-Unique: ihXjdLqIP--Sx2lrLU4Mxw-1
Received: by mail-wr1-f72.google.com with SMTP id z6so4440854wrh.11
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:24:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aZTO3x/pXi2BQffGU8Ahgki8e6dMOggVVDCSg/uLSOA=;
        b=apj5ypjTXlP5+nZTpwEVWTF68jOdWyZDFk15nnt+MdLDtTV7rauWwLdngWM3cKhKCc
         pwhwAAcqGuFP4ljEpogZfHQIJYQSFJxKOtFwP+Nk0k5UEfrws1zEGRQ+OGz1rCtExNVf
         wAZ9UX0QQ2i1SGj5+OJrrrbaWZa8/TtN0G7kGjLdUjzWRuULp0n0Lkl9VucoQxvhdKYf
         PT/cRgQP3BFQx1qShp7oEpJawRGv+yDC0k0EzszOawhL0/jsUQoNfa8yRqxVdZv/YIZA
         qpPG6tGdTQwZosaSSmFfpO0uiiKD1WmM/szGT3ePFfie389p8lU+LWwEvMKdFRoFOMen
         FpmA==
X-Gm-Message-State: AOAM532Xh+TYKPk4iF/XhCYU/TUK6seqVO9OZI7LDMHXhZhVYnxy8reo
        cnwuavTIKesRgzfIN6Zh2LAF9pxh8IRCD9Xe+pBljiH12+s+ETJ7apUx97ZSR7u/Vq9messWs1G
        8wl/C7uj8uefD
X-Received: by 2002:adf:e482:: with SMTP id i2mr28327023wrm.392.1614795847968;
        Wed, 03 Mar 2021 10:24:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysTIK0lXRu39FtCQ9OTCPkfsknp8BOt8AZSrD9mXO72PDaVrwkpYfYBypZC5XeuQMn16k2cw==
X-Received: by 2002:adf:e482:: with SMTP id i2mr28326953wrm.392.1614795847187;
        Wed, 03 Mar 2021 10:24:07 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id h19sm6328046wmq.47.2021.03.03.10.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:24:06 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 16/19] accel/kvm: Move the 'kvm_run' field to AccelvCPUState
Date:   Wed,  3 Mar 2021 19:22:16 +0100
Message-Id: <20210303182219.1631042-17-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch created mechanically using:

  $ sed -i 's/->kvm_run/->accel_vcpu->kvm_run/' $(git grep -l kvm_run)

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/core/cpu.h    |  1 -
 include/sysemu/kvm_int.h |  1 +
 accel/kvm/kvm-all.c      | 16 ++++++++--------
 hw/s390x/pv.c            |  3 ++-
 target/i386/kvm/kvm.c    |  2 +-
 target/s390x/kvm.c       | 19 ++++++++++---------
 6 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 4f280509f9b..3268f1393f1 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -415,7 +415,6 @@ struct CPUState {
 
     /* Accelerator-specific fields. */
     struct AccelvCPUState *accel_vcpu;
-    struct kvm_run *kvm_run;
     int hvf_fd;
     /* shared by kvm, hax and hvf */
     bool vcpu_dirty;
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index dc45b3c3afa..b83264847aa 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -19,6 +19,7 @@ struct AccelvCPUState {
      */
     int kvm_fd;
     struct KVMState *kvm_state;
+    struct kvm_run *kvm_run;
 };
 
 typedef struct KVMSlot
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 737db3d3e0e..69df35497d2 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -380,7 +380,7 @@ static int do_kvm_destroy_vcpu(CPUState *cpu)
         goto err;
     }
 
-    ret = munmap(cpu->kvm_run, mmap_size);
+    ret = munmap(cpu->accel_vcpu->kvm_run, mmap_size);
     if (ret < 0) {
         goto err;
     }
@@ -448,9 +448,9 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
         goto err;
     }
 
-    cpu->kvm_run = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED,
-                        cpu->accel_vcpu->kvm_fd, 0);
-    if (cpu->kvm_run == MAP_FAILED) {
+    cpu->accel_vcpu->kvm_run = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+                                    MAP_SHARED, cpu->accel_vcpu->kvm_fd, 0);
+    if (cpu->accel_vcpu->kvm_run == MAP_FAILED) {
         ret = -errno;
         error_setg_errno(errp, ret,
                          "kvm_init_vcpu: mmap'ing vcpu state failed (%lu)",
@@ -460,7 +460,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     if (s->coalesced_mmio && !s->coalesced_mmio_ring) {
         s->coalesced_mmio_ring =
-            (void *)cpu->kvm_run + s->coalesced_mmio * PAGE_SIZE;
+            (void *)cpu->accel_vcpu->kvm_run + s->coalesced_mmio * PAGE_SIZE;
     }
 
     ret = kvm_arch_init_vcpu(cpu);
@@ -2382,7 +2382,7 @@ static __thread bool have_sigbus_pending;
 
 static void kvm_cpu_kick(CPUState *cpu)
 {
-    qatomic_set(&cpu->kvm_run->immediate_exit, 1);
+    qatomic_set(&cpu->accel_vcpu->kvm_run->immediate_exit, 1);
 }
 
 static void kvm_cpu_kick_self(void)
@@ -2403,7 +2403,7 @@ static void kvm_eat_signals(CPUState *cpu)
     int r;
 
     if (kvm_immediate_exit) {
-        qatomic_set(&cpu->kvm_run->immediate_exit, 0);
+        qatomic_set(&cpu->accel_vcpu->kvm_run->immediate_exit, 0);
         /* Write kvm_run->immediate_exit before the cpu->exit_request
          * write in kvm_cpu_exec.
          */
@@ -2431,7 +2431,7 @@ static void kvm_eat_signals(CPUState *cpu)
 
 int kvm_cpu_exec(CPUState *cpu)
 {
-    struct kvm_run *run = cpu->kvm_run;
+    struct kvm_run *run = cpu->accel_vcpu->kvm_run;
     int ret, run_ret;
 
     DPRINTF("kvm_cpu_exec()\n");
diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
index 93eccfc05d5..061c92fc4e3 100644
--- a/hw/s390x/pv.c
+++ b/hw/s390x/pv.c
@@ -17,6 +17,7 @@
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_int.h"
 #include "qom/object_interfaces.h"
 #include "exec/confidential-guest-support.h"
 #include "hw/s390x/ipl.h"
@@ -108,7 +109,7 @@ void s390_pv_unshare(void)
 
 void s390_pv_inject_reset_error(CPUState *cs)
 {
-    int r1 = (cs->kvm_run->s390_sieic.ipa & 0x00f0) >> 4;
+    int r1 = (cs->accel_vcpu->kvm_run->s390_sieic.ipa & 0x00f0) >> 4;
     CPUS390XState *env = &S390_CPU(cs)->env;
 
     /* Report that we are unable to enter protected mode */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index b2facf4f7c1..c0ccaf6b06a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4329,7 +4329,7 @@ static int kvm_handle_halt(X86CPU *cpu)
 static int kvm_handle_tpr_access(X86CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
-    struct kvm_run *run = cs->kvm_run;
+    struct kvm_run *run = cs->accel_vcpu->kvm_run;
 
     apic_handle_tpr_access_report(cpu->apic_state, run->tpr_access.rip,
                                   run->tpr_access.is_write ? TPR_ACCESS_WRITE
diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index cf6790b2678..7968b10fa52 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -460,14 +460,15 @@ void kvm_s390_reset_vcpu_normal(S390CPU *cpu)
 
 static int can_sync_regs(CPUState *cs, int regs)
 {
-    return cap_sync_regs && (cs->kvm_run->kvm_valid_regs & regs) == regs;
+    return cap_sync_regs
+           && (cs->accel_vcpu->kvm_run->kvm_valid_regs & regs) == regs;
 }
 
 int kvm_arch_put_registers(CPUState *cs, int level)
 {
     S390CPU *cpu = S390_CPU(cs);
     CPUS390XState *env = &cpu->env;
-    struct kvm_run *run = cs->kvm_run;
+    struct kvm_run *run = cs->accel_vcpu->kvm_run;
     struct kvm_sregs sregs;
     struct kvm_regs regs;
     struct kvm_fpu fpu = {};
@@ -624,7 +625,7 @@ int kvm_arch_get_registers(CPUState *cs)
 {
     S390CPU *cpu = S390_CPU(cs);
     CPUS390XState *env = &cpu->env;
-    struct kvm_run *run = cs->kvm_run;
+    struct kvm_run *run = cs->accel_vcpu->kvm_run;
     struct kvm_sregs sregs;
     struct kvm_regs regs;
     struct kvm_fpu fpu;
@@ -1621,8 +1622,8 @@ void kvm_s390_set_diag318(CPUState *cs, uint64_t diag318_info)
     /* Feat bit is set only if KVM supports sync for diag318 */
     if (s390_has_feat(S390_FEAT_DIAG_318)) {
         env->diag318_info = diag318_info;
-        cs->kvm_run->s.regs.diag318 = diag318_info;
-        cs->kvm_run->kvm_dirty_regs |= KVM_SYNC_DIAG318;
+        cs->accel_vcpu->kvm_run->s.regs.diag318 = diag318_info;
+        cs->accel_vcpu->kvm_run->kvm_dirty_regs |= KVM_SYNC_DIAG318;
     }
 }
 
@@ -1783,7 +1784,7 @@ static int handle_oper_loop(S390CPU *cpu, struct kvm_run *run)
 static int handle_intercept(S390CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
-    struct kvm_run *run = cs->kvm_run;
+    struct kvm_run *run = cs->accel_vcpu->kvm_run;
     int icpt_code = run->s390_sieic.icptcode;
     int r = 0;
 
@@ -1844,7 +1845,7 @@ static int handle_intercept(S390CPU *cpu)
 static int handle_tsch(S390CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
-    struct kvm_run *run = cs->kvm_run;
+    struct kvm_run *run = cs->accel_vcpu->kvm_run;
     int ret;
 
     ret = ioinst_handle_tsch(cpu, cpu->env.regs[1], run->s390_tsch.ipb,
@@ -1934,7 +1935,7 @@ static void insert_stsi_3_2_2(S390CPU *cpu, __u64 addr, uint8_t ar)
 static int handle_stsi(S390CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
-    struct kvm_run *run = cs->kvm_run;
+    struct kvm_run *run = cs->accel_vcpu->kvm_run;
 
     switch (run->s390_stsi.fc) {
     case 3:
@@ -1952,7 +1953,7 @@ static int handle_stsi(S390CPU *cpu)
 static int kvm_arch_handle_debug_exit(S390CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
-    struct kvm_run *run = cs->kvm_run;
+    struct kvm_run *run = cs->accel_vcpu->kvm_run;
 
     int ret = 0;
     struct kvm_debug_exit_arch *arch_info = &run->debug.arch;
-- 
2.26.2

