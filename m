Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881D241757E
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345814AbhIXNY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345419AbhIXNYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:51 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5D2C08EAE8
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:10 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id j16-20020adfa550000000b0016012acc443so7988543wrb.14
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=W+2w1qwCuEn0t2SEv46R5dHRsrtW6N98LhGxQR4ZHMs=;
        b=fB29omoApOyd7KWBCUSp019JzllSe991ZbrpXIl/8+wD518FgOf68xWf1p080OQzLK
         7ef+DcagPMxgJ1sICd9uZ37FbAyEV43bQtw0dqqbG/gJFzVs8A0S/Bb39XrkMckmrqxM
         1xQ+TEJK1KB7xTTgmdXlNGKw2wBihF3ZOqPeIzc+8ysz20+GBCRUZot2z/oGTAuMPAoo
         iN4EUiT0JIIy7df/wYX3JoMf0BR7l/n4skiALWB3CGeAqMwOjDzvwWn/yw0Kt27/4qEP
         UjBSemQMkNmHZNIT3OiGLvTr/IT7xnhAOOJrXtzxLcGqL285afdsuBvWqD5Jq8CQSmAl
         7+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=W+2w1qwCuEn0t2SEv46R5dHRsrtW6N98LhGxQR4ZHMs=;
        b=cNF/OmpK1WItj3ydlxrD3xIWV2v5UkXDHDOGfbJp2Xwi4LrH5O5NDHHyPa+5NDPPTU
         jhBvfpZk/a7CyGy5ZAakrByMC+ibyQaej+CeX+lxNOtYNe6qlDNa8RVyMRInf3FjwXOB
         ynLtk7/8PTXIt+opiFdCTQPvCwXR4K71COdiA96fnf3CpSvm27SOw+Cv1VJvAKTdayUI
         LLBRMjG6VtqVLA7Awp0A2lHyq/b74DjsMpHgul8rd7XwDx8Z5mqtY8/bnndb4vti1jtG
         CkGvbMM+zxHMUWJYi7SsxhelBXwl2CaSmcztBQxkQmz+zBlwL0R6+KSDV6VjJ7Uf/2gE
         4RzA==
X-Gm-Message-State: AOAM533f+Lt0/a/oCdZVDOwKwNxVRBDeyfcb57GZedK446o+xl8BrCqo
        Cskeoyd5VzUoYK7hSGX6ytSZdJvdAw==
X-Google-Smtp-Source: ABdhPJx/AhXU7v63bYO98iWD72IfKcnea82QgZwoY4OwP8dr+1tbs2DMALrsIf7vL8Tvaw9WkugTCl9mXQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:4c14:: with SMTP id z20mr1965423wmf.82.1632488048707;
 Fri, 24 Sep 2021 05:54:08 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:32 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-4-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 03/30] [DONOTMERGE] Coccinelle scripts for refactoring
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These Coccinelle scripts are used in the coming refactoring
patches. Adding them as a commit to keep them as part of the
history.

For running the scripts please use a recent version of
Coccinelle, which has this patch [*].

Signed-off-by: Fuad Tabba <tabba@google.com>

[*]
Link: https://lore.kernel.org/cocci/alpine.DEB.2.22.394.2104211654020.13358=
@hadrien/T/#t
---
 cocci_refactor/add_ctxt.cocci           | 169 ++++++++++++++++++++++++
 cocci_refactor/add_hypstate.cocci       | 125 ++++++++++++++++++
 cocci_refactor/hyp_ctxt.cocci           |  38 ++++++
 cocci_refactor/range.cocci              |  50 +++++++
 cocci_refactor/remove_unused.cocci      |  69 ++++++++++
 cocci_refactor/test.cocci               |  20 +++
 cocci_refactor/use_ctxt.cocci           |  32 +++++
 cocci_refactor/use_ctxt_access.cocci    |  39 ++++++
 cocci_refactor/use_hypstate.cocci       |  63 +++++++++
 cocci_refactor/vcpu_arch_ctxt.cocci     |  13 ++
 cocci_refactor/vcpu_declr.cocci         |  59 +++++++++
 cocci_refactor/vcpu_flags.cocci         |  10 ++
 cocci_refactor/vcpu_hyp_accessors.cocci |  35 +++++
 cocci_refactor/vcpu_hyp_state.cocci     |  30 +++++
 cocci_refactor/vgic3_cpu.cocci          | 118 +++++++++++++++++
 15 files changed, 870 insertions(+)
 create mode 100644 cocci_refactor/add_ctxt.cocci
 create mode 100644 cocci_refactor/add_hypstate.cocci
 create mode 100644 cocci_refactor/hyp_ctxt.cocci
 create mode 100644 cocci_refactor/range.cocci
 create mode 100644 cocci_refactor/remove_unused.cocci
 create mode 100644 cocci_refactor/test.cocci
 create mode 100644 cocci_refactor/use_ctxt.cocci
 create mode 100644 cocci_refactor/use_ctxt_access.cocci
 create mode 100644 cocci_refactor/use_hypstate.cocci
 create mode 100644 cocci_refactor/vcpu_arch_ctxt.cocci
 create mode 100644 cocci_refactor/vcpu_declr.cocci
 create mode 100644 cocci_refactor/vcpu_flags.cocci
 create mode 100644 cocci_refactor/vcpu_hyp_accessors.cocci
 create mode 100644 cocci_refactor/vcpu_hyp_state.cocci
 create mode 100644 cocci_refactor/vgic3_cpu.cocci

diff --git a/cocci_refactor/add_ctxt.cocci b/cocci_refactor/add_ctxt.cocci
new file mode 100644
index 000000000000..203644944ace
--- /dev/null
+++ b/cocci_refactor/add_ctxt.cocci
@@ -0,0 +1,169 @@
+// <smpl>
+
+/*
+spatch --sp-file add_ctxt.cocci --dir arch/arm64/kvm/hyp --ignore arch/arm=
64/kvm/hyp/nvhe/debug-sr.c --ignore arch/arm64/kvm/hyp/vhe/debug-sr.c --inc=
lude-headers --in-place
+*/
+
+
+@exists@
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+identifier fc;
+@@
+<...
+(
+  struct kvm_vcpu *vcpu =3D NULL;
++ struct kvm_cpu_context *vcpu_ctxt;
+|
+  struct kvm_vcpu *vcpu =3D ...;
++ struct kvm_cpu_context *vcpu_ctxt =3D &vcpu_ctxt(vcpu);
+|
+  struct kvm_vcpu *vcpu;
++ struct kvm_cpu_context *vcpu_ctxt;
+)
+<...
+  vcpu =3D ...;
++ vcpu_ctxt =3D &vcpu_ctxt(vcpu);
+...>
+fc(..., vcpu, ...)
+...>
+
+@exists@
+identifier func !=3D {kvm_arch_vcpu_run_pid_change};
+identifier fc !=3D {vcpu_ctxt};
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+@@
+func(..., struct kvm_vcpu *vcpu, ...) {
++ struct kvm_cpu_context *vcpu_ctxt =3D &vcpu_ctxt(vcpu);
+<+...
+fc(..., vcpu, ...)
+...+>
+ }
+
+@@
+expression a, b;
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+iterator name kvm_for_each_vcpu;
+identifier fc;
+@@
+kvm_for_each_vcpu(a, vcpu, b)
+ {
++ vcpu_ctxt =3D &vcpu_ctxt(vcpu);
+<+...
+fc(..., vcpu, ...)
+...+>
+ }
+
+@@
+identifier vcpu_ctxt, vcpu;
+iterator name kvm_for_each_vcpu;
+type T;
+identifier x;
+statement S1, S2;
+@@
+kvm_for_each_vcpu(...)
+ {
+- vcpu_ctxt =3D &vcpu_ctxt(vcpu);
+... when !=3D S1
++ vcpu_ctxt =3D &vcpu_ctxt(vcpu);
+ S2
+ ... when any
+ }
+
+@
+disable optional_qualifier
+exists
+@
+identifier vcpu;
+identifier vcpu_ctxt;
+@@
+<...
+  const struct kvm_vcpu *vcpu =3D ...;
+- struct kvm_cpu_context *vcpu_ctxt =3D &vcpu_ctxt(vcpu);
++ const struct kvm_cpu_context *vcpu_ctxt =3D &vcpu_ctxt(vcpu);
+...>
+
+@disable optional_qualifier@
+identifier func, vcpu;
+identifier vcpu_ctxt;
+@@
+func(..., const struct kvm_vcpu *vcpu, ...) {
+- struct kvm_cpu_context *vcpu_ctxt =3D &vcpu_ctxt(vcpu);
++ const struct kvm_cpu_context *vcpu_ctxt =3D &vcpu_ctxt(vcpu);
+...
+ }
+
+@exists@
+expression r1, r2;
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+@@
+(
+- vcpu_gp_regs(vcpu)
++ ctxt_gp_regs(vcpu_ctxt)
+|
+- vcpu_spsr_abt(vcpu)
++ ctxt_spsr_abt(vcpu_ctxt)
+|
+- vcpu_spsr_und(vcpu)
++ ctxt_spsr_und(vcpu_ctxt)
+|
+- vcpu_spsr_irq(vcpu)
++ ctxt_spsr_irq(vcpu_ctxt)
+|
+- vcpu_spsr_fiq(vcpu)
++ ctxt_spsr_fiq(vcpu_ctxt)
+|
+- vcpu_fp_regs(vcpu)
++ ctxt_fp_regs(vcpu_ctxt)
+|
+- __vcpu_sys_reg(vcpu, r1)
++ ctxt_sys_reg(vcpu_ctxt, r1)
+|
+- __vcpu_read_sys_reg(vcpu, r1)
++ __ctxt_read_sys_reg(vcpu_ctxt, r1)
+|
+- __vcpu_write_sys_reg(vcpu, r1, r2)
++ __ctxt_write_sys_reg(vcpu_ctxt, r1, r2)
+|
+- __vcpu_write_spsr(vcpu, r1)
++ __ctxt_write_spsr(vcpu_ctxt, r1)
+|
+- __vcpu_write_spsr_abt(vcpu, r1)
++ __ctxt_write_spsr_abt(vcpu_ctxt, r1)
+|
+- __vcpu_write_spsr_und(vcpu, r1)
++ __ctxt_write_spsr_und(vcpu_ctxt, r1)
+|
+- vcpu_pc(vcpu)
++ ctxt_pc(vcpu_ctxt)
+|
+- vcpu_cpsr(vcpu)
++ ctxt_cpsr(vcpu_ctxt)
+|
+- vcpu_mode_is_32bit(vcpu)
++ ctxt_mode_is_32bit(vcpu_ctxt)
+|
+- vcpu_set_thumb(vcpu)
++ ctxt_set_thumb(vcpu_ctxt)
+|
+- vcpu_get_reg(vcpu, r1)
++ ctxt_get_reg(vcpu_ctxt, r1)
+|
+- vcpu_set_reg(vcpu, r1, r2)
++ ctxt_set_reg(vcpu_ctxt, r1, r2)
+)
+
+
+/* Handles one case of a call within a call. */
+@@
+expression r1, r2;
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+@@
+- vcpu_pc(vcpu)
++ ctxt_pc(vcpu_ctxt)
+
+// </smpl>
diff --git a/cocci_refactor/add_hypstate.cocci b/cocci_refactor/add_hypstat=
e.cocci
new file mode 100644
index 000000000000..e8635d0e8f57
--- /dev/null
+++ b/cocci_refactor/add_hypstate.cocci
@@ -0,0 +1,125 @@
+// <smpl>
+
+/*
+FILES=3D"$(find arch/arm64/kvm/hyp -name "*.[ch]" ! -name "debug-sr*") arc=
h/arm64/include/asm/kvm_hyp.h"
+spatch --sp-file add_hypstate.cocci $FILES --in-place
+*/
+
+@exists@
+identifier vcpu;
+fresh identifier hyps =3D vcpu ## "_hyps";
+identifier fc;
+@@
+<...
+(
+  struct kvm_vcpu *vcpu =3D NULL;
++ struct vcpu_hyp_state *hyps;
+|
+  struct kvm_vcpu *vcpu =3D ...;
++ struct vcpu_hyp_state *hyps =3D &hyp_state(vcpu);
+|
+  struct kvm_vcpu *vcpu;
++ struct vcpu_hyp_state *hyps;
+)
+<...
+  vcpu =3D ...;
++ hyps =3D &hyp_state(vcpu);
+...>
+fc(..., vcpu, ...)
+...>
+
+@exists@
+identifier func !=3D {kvm_arch_vcpu_run_pid_change};
+identifier vcpu;
+fresh identifier hyps =3D vcpu ## "_hyps";
+identifier fc;
+@@
+func(..., struct kvm_vcpu *vcpu, ...) {
++ struct vcpu_hyp_state *hyps =3D &hyp_state(vcpu);
+<+...
+fc(..., vcpu, ...)
+...+>
+ }
+
+@@
+expression a, b;
+identifier vcpu;
+fresh identifier hyps =3D vcpu ## "_hyps";
+iterator name kvm_for_each_vcpu;
+identifier fc;
+@@
+kvm_for_each_vcpu(a, vcpu, b)
+ {
++ hyps =3D &hyp_state(vcpu);
+<+...
+fc(..., vcpu, ...)
+...+>
+ }
+
+@@
+identifier hyps, vcpu;
+iterator name kvm_for_each_vcpu;
+statement S1, S2;
+@@
+kvm_for_each_vcpu(...)
+ {
+- hyps =3D &hyp_state(vcpu);
+... when !=3D S1
++ hyps =3D &hyp_state(vcpu);
+ S2
+ ... when any
+ }
+
+@
+disable optional_qualifier
+exists
+@
+identifier vcpu, hyps;
+@@
+<...
+  const struct kvm_vcpu *vcpu =3D ...;
+- struct vcpu_hyp_state *hyps =3D &hyp_state(vcpu);
++ const struct vcpu_hyp_state *hyps =3D &hyp_state(vcpu);
+...>
+
+
+@@
+identifier func, vcpu, hyps;
+@@
+func(..., const struct kvm_vcpu *vcpu, ...) {
+- struct vcpu_hyp_state *hyps =3D &hyp_state(vcpu);
++ const struct vcpu_hyp_state *hyps =3D &hyp_state(vcpu);
+...
+ }
+
+@exists@
+identifier vcpu;
+fresh identifier hyps =3D vcpu ## "_hyps";
+@@
+(
+- vcpu_hcr_el2(vcpu)
++ hyp_state_hcr_el2(hyps)
+|
+- vcpu_mdcr_el2(vcpu)
++ hyp_state_mdcr_el2(hyps)
+|
+- vcpu_vsesr_el2(vcpu)
++ hyp_state_vsesr_el2(hyps)
+|
+- vcpu_fault(vcpu)
++ hyp_state_fault(hyps)
+|
+- vcpu_flags(vcpu)
++ hyp_state_flags(hyps)
+|
+- vcpu_has_sve(vcpu)
++ hyp_state_has_sve(hyps)
+|
+- vcpu_has_ptrauth(vcpu)
++ hyp_state_has_ptrauth(hyps)
+|
+- kvm_arm_vcpu_sve_finalized(vcpu)
++ kvm_arm_hyp_state_sve_finalized(hyps)
+)
+
+// </smpl>
diff --git a/cocci_refactor/hyp_ctxt.cocci b/cocci_refactor/hyp_ctxt.cocci
new file mode 100644
index 000000000000..af7974e3a502
--- /dev/null
+++ b/cocci_refactor/hyp_ctxt.cocci
@@ -0,0 +1,38 @@
+// Remove vcpu if all we're using is hypstate and ctxt
+
+/*
+FILES=3D"$(find arch/arm64/kvm/hyp -name "*.[ch]")"
+spatch --sp-file hyp_ctxt.cocci $FILES --in-place;
+*/
+
+// <smpl>
+
+@remove@
+identifier func !~ "^trap_|^access_|dbg_to_reg|check_pmu_access_disabled|m=
atch_mpidr|get_ctr_el0|emulate_cp|unhandled_cp_access|index_to_sys_reg_desc=
|kvm_pmu_|pmu_counter_idx_valid|reset_|read_from_write_only|write_to_read_o=
nly|undef_access|vgic_|kvm_handle_|handle_sve|handle_smc|handle_no_fpsimd|i=
d_visibility|reg_to_dbg|ptrauth_visibility|sve_visibility|kvm_arch_sched_in=
|kvm_arch_vcpu_|kvm_vcpu_pmu_|kvm_psci_|kvm_arm_copy_fw_reg_indices|kvm_arm=
_pvtime_|kvm_trng_|kvm_arm_timer_";
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+fresh identifier vcpu_hyps =3D vcpu ## "_hyps";
+identifier hyps_remove;
+identifier ctxt_remove;
+@@
+func(...,
+- struct kvm_vcpu *vcpu
++ struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps
+,...) {
+?- struct vcpu_hyp_state *hyps_remove =3D ...;
+?- struct kvm_cpu_context *ctxt_remove =3D ...;
+... when !=3D vcpu
+ }
+
+@@
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+fresh identifier vcpu_hyps =3D vcpu ## "_hyps";
+identifier remove.func;
+@@
+ func(
+- vcpu
++ vcpu_ctxt, vcpu_hyps
+  , ...)
+
+// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/range.cocci b/cocci_refactor/range.cocci
new file mode 100644
index 000000000000..d99b9ee30657
--- /dev/null
+++ b/cocci_refactor/range.cocci
@@ -0,0 +1,50 @@
+
+
+// <smpl>
+
+/*
+ FILES=3D"$(find arch/arm64 -name "*.[ch]") include/kvm/arm_hypercalls.h";=
 spatch --sp-file range.cocci $FILES
+*/
+
+@initialize:python@
+@@
+starts =3D ("start", "begin", "from", "floor", "addr", "kaddr")
+ends =3D ("size", "length", "len")
+
+//ends =3D ("end", "to", "ceiling", "size", "length", "len")
+
+
+@start_end@
+identifier f;
+type A, B;
+identifier start, end;
+parameter list[n] ps;
+@@
+f(ps, A start, B end, ...) {
+...
+}
+
+@script:python@
+start << start_end.start;
+end << start_end.end;
+ta << start_end.A;
+tb << start_end.B;
+@@
+
+if ta !=3D tb and tb !=3D "size_t":
+        cocci.include_match(False)
+elif not any(x in start for x in starts) and not any(x in end for x in end=
s):
+        cocci.include_match(False)
+
+@@
+identifier f =3D start_end.f;
+expression list[start_end.n] xs;
+expression a, b;
+@@
+(
+* f(xs, a, a, ...)
+|
+* f(xs, a, a - b, ...)
+)
+
+// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/remove_unused.cocci b/cocci_refactor/remove_unu=
sed.cocci
new file mode 100644
index 000000000000..c06278398198
--- /dev/null
+++ b/cocci_refactor/remove_unused.cocci
@@ -0,0 +1,69 @@
+// <smpl>
+
+/*
+spatch --sp-file remove_unused.cocci --dir arch/arm64/kvm/hyp --in-place -=
-include-headers --force-diff
+*/
+
+@@
+identifier hyps;
+@@
+{
+...
+(
+- struct vcpu_hyp_state *hyps =3D ...;
+|
+- struct vcpu_hyp_state *hyps;
+)
+... when !=3D hyps
+    when !=3D if (...) { <+...hyps...+> }
+?- hyps =3D ...;
+... when !=3D hyps
+    when !=3D if (...) { <+...hyps...+> }
+}
+
+@@
+identifier vcpu_ctxt;
+@@
+{
+...
+(
+- struct kvm_cpu_context *vcpu_ctxt =3D ...;
+|
+- struct kvm_cpu_context *vcpu_ctxt;
+)
+... when !=3D vcpu_ctxt
+    when !=3D if (...) { <+...vcpu_ctxt...+> }
+?- vcpu_ctxt =3D ...;
+... when !=3D vcpu_ctxt
+    when !=3D if (...) { <+...vcpu_ctxt...+> }
+}
+
+@@
+identifier x;
+identifier func;
+statement S;
+@@
+func(...)
+ {
+...
+struct kvm_cpu_context *x =3D ...;
++
+S
+...
+ }
+
+@@
+identifier x;
+identifier func;
+statement S;
+@@
+func(...)
+ {
+...
+struct vcpu_hyp_state *x =3D ...;
++
+S
+...
+ }
+
+// </smpl>
diff --git a/cocci_refactor/test.cocci b/cocci_refactor/test.cocci
new file mode 100644
index 000000000000..5eb685240ce7
--- /dev/null
+++ b/cocci_refactor/test.cocci
@@ -0,0 +1,20 @@
+/*
+ FILES=3D"$(find arch/arm64 -name "*.[ch]") include/kvm/arm_hypercalls.h";=
 spatch --sp-file test.cocci $FILES
+
+*/
+
+@r@
+identifier fn;
+@@
+fn(...) {
+ hello;
+ ...
+}
+
+@@
+identifier r.fn;
+@@
+static fn(...) {
++ world;
+ ...
+}
diff --git a/cocci_refactor/use_ctxt.cocci b/cocci_refactor/use_ctxt.cocci
new file mode 100644
index 000000000000..f3f961f567fd
--- /dev/null
+++ b/cocci_refactor/use_ctxt.cocci
@@ -0,0 +1,32 @@
+// <smpl>
+/*
+spatch --sp-file use_ctxt.cocci  --dir arch/arm64/kvm/hyp --ignore debug-s=
r --include-headers  --in-place
+spatch --sp-file use_ctxt.cocci  --dir arch/arm64/kvm/hyp --ignore debug-s=
r --include-headers  --in-place
+*/
+
+@remove_vcpu@
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+identifier ctxt_remove;
+identifier func !~ "(reset_unknown|reset_val|kvm_pmu_valid_counter_mask|re=
set_pmcr|kvm_arch_vcpu_in_kernel|__vgic_v3_)";
+@@
+func(
+- struct kvm_vcpu *vcpu
++ struct kvm_cpu_context *vcpu_ctxt
+, ...) {
+- struct kvm_cpu_context *ctxt_remove =3D ...;
+... when !=3D vcpu
+    when !=3D if (...) { <+...vcpu...+> }
+}
+
+@@
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+identifier func =3D remove_vcpu.func;
+@@
+func(
+- vcpu
++ vcpu_ctxt
+  , ...)
+
+// </smpl>
diff --git a/cocci_refactor/use_ctxt_access.cocci b/cocci_refactor/use_ctxt=
_access.cocci
new file mode 100644
index 000000000000..74f94141e662
--- /dev/null
+++ b/cocci_refactor/use_ctxt_access.cocci
@@ -0,0 +1,39 @@
+// </smpl>
+
+/*
+spatch --sp-file use_ctxt_access.cocci --dir arch/arm64/kvm/ --include-hea=
ders --in-place
+*/
+
+@@
+constant r;
+@@
+- __ctxt_sys_reg(&vcpu->arch.ctxt, r)
++ &__vcpu_sys_reg(vcpu, r)
+
+@@
+identifier r;
+@@
+- vcpu->arch.ctxt.regs.r
++ vcpu_gp_regs(vcpu)->r
+
+@@
+identifier r;
+@@
+- vcpu->arch.ctxt.fp_regs.r
++ vcpu_fp_regs(vcpu)->r
+
+@@
+identifier r;
+fresh identifier accessor =3D "vcpu_" ## r;
+@@
+- &vcpu->arch.ctxt.r
++ accessor(vcpu)
+
+@@
+identifier r;
+fresh identifier accessor =3D "vcpu_" ## r;
+@@
+- vcpu->arch.ctxt.r
++ *accessor(vcpu)
+
+// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/use_hypstate.cocci b/cocci_refactor/use_hypstat=
e.cocci
new file mode 100644
index 000000000000..f685149de748
--- /dev/null
+++ b/cocci_refactor/use_hypstate.cocci
@@ -0,0 +1,63 @@
+// <smpl>
+
+/*
+FILES=3D"$(find arch/arm64/kvm/hyp -name "*.[ch]" ! -name "debug-sr*") arc=
h/arm64/include/asm/kvm_hyp.h"
+spatch --sp-file use_hypstate.cocci $FILES --in-place
+*/
+
+
+@remove_vcpu_hyps@
+identifier vcpu;
+fresh identifier hyps =3D vcpu ## "_hyps";
+identifier hyps_remove;
+identifier func;
+@@
+func(
+- struct kvm_vcpu *vcpu
++ struct vcpu_hyp_state *hyps
+, ...) {
+- struct vcpu_hyp_state *hyps_remove =3D ...;
+... when !=3D vcpu
+    when !=3D if (...) { <+...vcpu...+> }
+}
+
+@@
+identifier vcpu;
+fresh identifier hyps =3D vcpu ## "_hyps";
+identifier func =3D remove_vcpu_hyps.func;
+@@
+func(
+- vcpu
++ hyps
+  , ...)
+
+@remove_vcpu_hyps_ctxt@
+identifier vcpu;
+fresh identifier hyps =3D vcpu ## "_hyps";
+identifier hyps_remove;
+identifier ctxt_remove;
+identifier func;
+@@
+func(
+- struct kvm_vcpu *vcpu
++ struct vcpu_hyp_state *hyps
+, ...) {
+- struct vcpu_hyp_state *hyps_remove =3D ...;
+- struct kvm_cpu_context *ctxt_remove =3D ...;
+... when !=3D vcpu
+    when !=3D if (...) { <+...vcpu...+> }
+    when !=3D ctxt_remove
+    when !=3D if (...) { <+...ctxt_remove...+> }
+}
+
+@@
+identifier vcpu;
+fresh identifier hyps =3D vcpu ## "_hyps";
+identifier func =3D remove_vcpu_hyps_ctxt.func;
+@@
+func(
+- vcpu
++ hyps
+  , ...)
+
+// </smpl>
diff --git a/cocci_refactor/vcpu_arch_ctxt.cocci b/cocci_refactor/vcpu_arch=
_ctxt.cocci
new file mode 100644
index 000000000000..69b3a000de4e
--- /dev/null
+++ b/cocci_refactor/vcpu_arch_ctxt.cocci
@@ -0,0 +1,13 @@
+// spatch --sp-file vcpu_arch_ctxt.cocci --no-includes --include-headers  =
--dir arch/arm64
+
+// <smpl>
+@@
+identifier vcpu;
+@@
+(
+- vcpu->arch.ctxt.regs
++ vcpu_gp_regs(vcpu)
+|
+- vcpu->arch.ctxt.fp_regs
++ vcpu_fp_regs(vcpu)
+)
diff --git a/cocci_refactor/vcpu_declr.cocci b/cocci_refactor/vcpu_declr.co=
cci
new file mode 100644
index 000000000000..59cd46bd6b2d
--- /dev/null
+++ b/cocci_refactor/vcpu_declr.cocci
@@ -0,0 +1,59 @@
+
+/*
+FILES=3D"$(find arch/arm64 -name "*.[ch]") include/kvm/arm_hypercalls.h"; =
 spatch --sp-file vcpu_declr.cocci $FILES --in-place
+*/
+
+// <smpl>
+
+@@
+identifier vcpu;
+expression E;
+@@
+<...
+- struct kvm_vcpu *vcpu;
++ struct kvm_vcpu *vcpu =3D E;
+
+- vcpu =3D E;
+...>
+
+
+/*
+@@
+identifier vcpu;
+identifier f1, f2;
+@@
+f1(...)
+{
+- struct kvm_vcpu *vcpu =3D NULL;
++ struct kvm_vcpu *vcpu;
+... when !=3D f2(..., vcpu, ...)
+}
+*/
+
+/*
+@find_after@
+identifier vcpu;
+position p;
+identifier f;
+@@
+<...
+ struct kvm_vcpu *vcpu@p;
+ ... when !=3D vcpu =3D ...;
+ f(..., vcpu, ...);
+...>
+
+@@
+identifier vcpu;
+expression E;
+position p !=3D find_after.p;
+@@
+<...
+- struct kvm_vcpu *vcpu@p;
++ struct kvm_vcpu *vcpu =3D E;
+ ...
+- vcpu =3D E;
+...>
+
+*/
+
+// </smpl>
diff --git a/cocci_refactor/vcpu_flags.cocci b/cocci_refactor/vcpu_flags.co=
cci
new file mode 100644
index 000000000000..609bb7bd7bd0
--- /dev/null
+++ b/cocci_refactor/vcpu_flags.cocci
@@ -0,0 +1,10 @@
+// spatch --sp-file el2_def_flags.cocci --no-includes --include-headers  -=
-dir arch/arm64
+
+// <smpl>
+@@
+expression vcpu;
+@@
+
+- vcpu->arch.flags
++ vcpu_flags(vcpu)
+// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/vcpu_hyp_accessors.cocci b/cocci_refactor/vcpu_=
hyp_accessors.cocci
new file mode 100644
index 000000000000..506b56f7216f
--- /dev/null
+++ b/cocci_refactor/vcpu_hyp_accessors.cocci
@@ -0,0 +1,35 @@
+// <smpl>
+
+/*
+spatch --sp-file vcpu_hyp_accessors.cocci --dir arch/arm64 --include-heade=
rs --in-place
+*/
+
+@find_defines@
+identifier macro;
+identifier vcpu;
+position p;
+@@
+#define macro(vcpu) vcpu@p
+
+@@
+identifier vcpu;
+position p !=3D find_defines.p;
+@@
+(
+- vcpu@p->arch.hcr_el2
++ vcpu_hcr_el2(vcpu)
+|
+- vcpu@p->arch.mdcr_el2
++ vcpu_mdcr_el2(vcpu)
+|
+- vcpu@p->arch.vsesr_el2
++ vcpu_vsesr_el2(vcpu)
+|
+- vcpu@p->arch.fault
++ vcpu_fault(vcpu)
+|
+- vcpu@p->arch.flags
++ vcpu_flags(vcpu)
+)
+
+// </smpl>
diff --git a/cocci_refactor/vcpu_hyp_state.cocci b/cocci_refactor/vcpu_hyp_=
state.cocci
new file mode 100644
index 000000000000..3005a6f11871
--- /dev/null
+++ b/cocci_refactor/vcpu_hyp_state.cocci
@@ -0,0 +1,30 @@
+// <smpl>
+
+// spatch --sp-file vcpu_hyp_state.cocci --no-includes --include-headers  =
--dir arch/arm64 --very-quiet --in-place
+
+@@
+expression vcpu;
+@@
+- vcpu->arch.
++ vcpu->arch.hyp_state.
+(
+ hcr_el2
+|
+ mdcr_el2
+|
+ vsesr_el2
+|
+ fault
+|
+ flags
+|
+ sysregs_loaded_on_cpu
+)
+
+@@
+identifier arch;
+@@
+- arch.fault
++ arch.hyp_state.fault
+
+// </smpl>
\ No newline at end of file
diff --git a/cocci_refactor/vgic3_cpu.cocci b/cocci_refactor/vgic3_cpu.cocc=
i
new file mode 100644
index 000000000000..f7495b2e49cb
--- /dev/null
+++ b/cocci_refactor/vgic3_cpu.cocci
@@ -0,0 +1,118 @@
+// <smpl>
+
+/*
+spatch --sp-file vgic3_cpu.cocci arch/arm64/kvm/hyp/vgic-v3-sr.c --in-plac=
e
+*/
+
+
+@@
+identifier vcpu;
+fresh identifier vcpu_hyps =3D vcpu ## "_hyps";
+@@
+(
+- kvm_vcpu_sys_get_rt
++ kvm_hyp_state_sys_get_rt
+|
+- kvm_vcpu_get_esr
++ kvm_hyp_state_get_esr
+)
+- (vcpu)
++ (vcpu_hyps)
+
+@add_cpu_if@
+identifier func;
+identifier c;
+@@
+int func(
+- struct kvm_vcpu *vcpu
++ struct vgic_v3_cpu_if *cpu_if
+ , ...)
+{
+<+...
+- vcpu->arch.vgic_cpu.vgic_v3.c
++ cpu_if->c
+...+>
+}
+
+@@
+identifier func =3D add_cpu_if.func;
+@@
+ func(
+- vcpu
++ cpu_if
+ , ...
+ )
+
+
+@add_vgic_ctxt_hyps@
+identifier func;
+@@
+void func(
+- struct kvm_vcpu *vcpu
++ struct vgic_v3_cpu_if *cpu_if, struct kvm_cpu_context *vcpu_ctxt, struct=
 vcpu_hyp_state *vcpu_hyps
+ , ...) {
+?- struct vcpu_hyp_state *vcpu_hyps =3D ...;
+?- struct kvm_cpu_context *vcpu_ctxt =3D ...;
+ ...
+ }
+
+@@
+identifier func =3D add_vgic_ctxt_hyps.func;
+@@
+ func(
+- vcpu,
++ cpu_if, vcpu_ctxt, vcpu_hyps,
+ ...
+ )
+
+
+@find_calls@
+identifier fn;
+type a, b;
+@@
+- void (*fn)(struct kvm_vcpu *, a, b);
++ void (*fn)(struct vgic_v3_cpu_if *, struct kvm_cpu_context *, struct vcp=
u_hyp_state *, a, b);
+
+@@
+identifier fn =3D find_calls.fn;
+identifier a, b;
+@@
+- fn(vcpu, a, b);
++ fn(cpu_if, vcpu_ctxt, vcpu_hyps, a, b);
+
+@@
+@@
+int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu) {
++ struct vgic_v3_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v3;
+...
+}
+
+@remove@
+identifier func;
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+fresh identifier vcpu_hyps =3D vcpu ## "_hyps";
+identifier hyps_remove;
+identifier ctxt_remove;
+@@
+func(...,
+- struct kvm_vcpu *vcpu
++ struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps
+,...) {
+?- struct vcpu_hyp_state *hyps_remove =3D ...;
+?- struct kvm_cpu_context *ctxt_remove =3D ...;
+... when !=3D vcpu
+ }
+
+@@
+identifier vcpu;
+fresh identifier vcpu_ctxt =3D vcpu ## "_ctxt";
+fresh identifier vcpu_hyps =3D vcpu ## "_hyps";
+identifier remove.func;
+@@
+ func(
+- vcpu
++ vcpu_ctxt, vcpu_hyps
+  , ...)
+
+// </smpl>
--=20
2.33.0.685.g46640cef36-goog

