Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA613A449B
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 17:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhFKPDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 11:03:55 -0400
Received: from mail-pj1-f73.google.com ([209.85.216.73]:59938 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbhFKPDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 11:03:52 -0400
Received: by mail-pj1-f73.google.com with SMTP id p22-20020a17090a9316b029016a0aced749so5592421pjo.9
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 08:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uim87IAj8KCKmOSsULsfH8blvn43ITFIDbaIVP4r8jE=;
        b=v3wrdyhzygEkOld+RcXbcgQEfgEJ/ExVLpVOv7yMLzWS/MfFUbYFdCePLElxJHQQCa
         r0jWml4EUh0VEomgu2N1VoVaDLVYmdDIk4l4/FXhx+2aGVOtDVY8OKt0wagIF07M6c31
         8deaonijuj/DIt11x3iPWcOJhVGN0Su90ZaZhM0tCXRE6Ql6Ox+kX3kHwtn1mnvMKL+L
         a27clHJFyEYK2O/tUui1ubh9bYB4H2SZyszh/esjihZ5jTVXpSia7z57EHrlz8sK74ue
         04OfluKuDLrd1h7z4vvQt6/GYcmfuD701Qycu9eyj5NBCmLXsRdNJTfb/6xAM6EPxDAE
         eI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uim87IAj8KCKmOSsULsfH8blvn43ITFIDbaIVP4r8jE=;
        b=qNvpZoJ0tWgvJwuM2cQrlXFdWjislU0wEIkamXxSDnYs+zQEHlpNMLvePkKm7EM0D8
         fND2BUSjCkULUJupUIeQzI1PpGPyt5+kNMQX6bp7UtbSRsTtMObT9sn9HtM7ygi9zUvG
         H79gNKO1X+O8997F7Xu5deqlPeWuM0aH0Fy8buvdgqn0yi2K6QMNk006pApXQlISVGXq
         y6dqmz+8Ey6mOC+Z8T4cDsjDOryDG6HpezxE54Ed396Ew7xiDS0Jt/nHWaX9rwjd9HqD
         ZafazWbmn8FgTYUhPMz7apmN5VPUXkhf9ULWeEzb+3cA0ZIOQh6xUF7pIdL0y4lT1eJM
         oo3w==
X-Gm-Message-State: AOAM5318NOr+11gMzu4X9236vjXTKTppA2+iy5kXpQFyslKkEkTKKzcC
        1fRsv8r1KL/QV5WmmCqXp+gc0G9O+nnW6wxWnIJOh14S8kpTJuGRPj+XVmhH2UnerRB3XihKZYH
        BRhFG+nVpM0evr6hxJn1bp5O3znJ8abBNfeV78A161hwbTpiAD4qURg1Po7L+Jq5jg1h1KbU=
X-Google-Smtp-Source: ABdhPJzw14sBk2SudnhzcJxOniJUb+JRBSy3KrK4tHQVYc9BYUY5vL/ROPIIfB7+IcCNqHSIWR4G5IcqYa3qDBT3nQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:c651:b029:118:896f:cead with
 SMTP id s17-20020a170902c651b0290118896fceadmr2568395pls.29.1623423640742;
 Fri, 11 Jun 2021 08:00:40 -0700 (PDT)
Date:   Fri, 11 Jun 2021 15:00:37 +0000
Message-Id: <20210611150037.1969770-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH] KVM: stats: Remove debugfs interface for KVM stats
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid duplication, remove the debugfs interface for KVM stats,
since the fd-based binary stats interface is available.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/guest.c    |  16 ---
 arch/mips/kvm/mips.c      |  39 ------
 arch/powerpc/kvm/book3s.c |  33 -----
 arch/powerpc/kvm/booke.c  |  25 ----
 arch/s390/kvm/kvm-s390.c  | 108 ----------------
 arch/x86/kvm/x86.c        |  47 -------
 include/linux/kvm_host.h  |  34 +----
 virt/kvm/kvm_main.c       | 258 --------------------------------------
 8 files changed, 1 insertion(+), 559 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 7048603f4b26..ab5b878b8b14 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -62,22 +62,6 @@ struct _kvm_stats_header kvm_vcpu_stats_header = {
 	}
 };
 
-struct kvm_stats_debugfs_item debugfs_entries[] = {
-	VCPU_STAT_GENERIC("halt_successful_poll", halt_successful_poll),
-	VCPU_STAT_GENERIC("halt_attempted_poll", halt_attempted_poll),
-	VCPU_STAT_GENERIC("halt_poll_invalid", halt_poll_invalid),
-	VCPU_STAT_GENERIC("halt_wakeup", halt_wakeup),
-	VCPU_STAT("hvc_exit_stat", hvc_exit_stat),
-	VCPU_STAT("wfe_exit_stat", wfe_exit_stat),
-	VCPU_STAT("wfi_exit_stat", wfi_exit_stat),
-	VCPU_STAT("mmio_exit_user", mmio_exit_user),
-	VCPU_STAT("mmio_exit_kernel", mmio_exit_kernel),
-	VCPU_STAT("exits", exits),
-	VCPU_STAT_GENERIC("halt_poll_success_ns", halt_poll_success_ns),
-	VCPU_STAT_GENERIC("halt_poll_fail_ns", halt_poll_fail_ns),
-	{ NULL }
-};
-
 static bool core_reg_offset_is_vreg(u64 off)
 {
 	return off >= KVM_REG_ARM_CORE_REG(fp_regs.vregs) &&
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8fc70539a83b..285f009f02d1 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -97,45 +97,6 @@ struct _kvm_stats_header kvm_vcpu_stats_header = {
 	}
 };
 
-struct kvm_stats_debugfs_item debugfs_entries[] = {
-	VCPU_STAT("wait", wait_exits),
-	VCPU_STAT("cache", cache_exits),
-	VCPU_STAT("signal", signal_exits),
-	VCPU_STAT("interrupt", int_exits),
-	VCPU_STAT("cop_unusable", cop_unusable_exits),
-	VCPU_STAT("tlbmod", tlbmod_exits),
-	VCPU_STAT("tlbmiss_ld", tlbmiss_ld_exits),
-	VCPU_STAT("tlbmiss_st", tlbmiss_st_exits),
-	VCPU_STAT("addrerr_st", addrerr_st_exits),
-	VCPU_STAT("addrerr_ld", addrerr_ld_exits),
-	VCPU_STAT("syscall", syscall_exits),
-	VCPU_STAT("resvd_inst", resvd_inst_exits),
-	VCPU_STAT("break_inst", break_inst_exits),
-	VCPU_STAT("trap_inst", trap_inst_exits),
-	VCPU_STAT("msa_fpe", msa_fpe_exits),
-	VCPU_STAT("fpe", fpe_exits),
-	VCPU_STAT("msa_disabled", msa_disabled_exits),
-	VCPU_STAT("flush_dcache", flush_dcache_exits),
-	VCPU_STAT("vz_gpsi", vz_gpsi_exits),
-	VCPU_STAT("vz_gsfc", vz_gsfc_exits),
-	VCPU_STAT("vz_hc", vz_hc_exits),
-	VCPU_STAT("vz_grr", vz_grr_exits),
-	VCPU_STAT("vz_gva", vz_gva_exits),
-	VCPU_STAT("vz_ghfc", vz_ghfc_exits),
-	VCPU_STAT("vz_gpa", vz_gpa_exits),
-	VCPU_STAT("vz_resvd", vz_resvd_exits),
-#ifdef CONFIG_CPU_LOONGSON64
-	VCPU_STAT("vz_cpucfg", vz_cpucfg_exits),
-#endif
-	VCPU_STAT_GENERIC("halt_successful_poll", halt_successful_poll),
-	VCPU_STAT_GENERIC("halt_attempted_poll", halt_attempted_poll),
-	VCPU_STAT_GENERIC("halt_poll_invalid", halt_poll_invalid),
-	VCPU_STAT_GENERIC("halt_wakeup", halt_wakeup),
-	VCPU_STAT_GENERIC("halt_poll_success_ns", halt_poll_success_ns),
-	VCPU_STAT_GENERIC("halt_poll_fail_ns", halt_poll_fail_ns),
-	{NULL}
-};
-
 bool kvm_trace_guest_mode_change;
 
 int kvm_guest_mode_change_trace_reg(void)
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index eff5a96aa638..f0fd9d1d5ee0 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -98,39 +98,6 @@ struct _kvm_stats_header kvm_vcpu_stats_header = {
 	}
 };
 
-struct kvm_stats_debugfs_item debugfs_entries[] = {
-	VCPU_STAT("exits", sum_exits),
-	VCPU_STAT("mmio", mmio_exits),
-	VCPU_STAT("sig", signal_exits),
-	VCPU_STAT("sysc", syscall_exits),
-	VCPU_STAT("inst_emu", emulated_inst_exits),
-	VCPU_STAT("dec", dec_exits),
-	VCPU_STAT("ext_intr", ext_intr_exits),
-	VCPU_STAT("queue_intr", queue_intr),
-	VCPU_STAT_GENERIC("halt_poll_success_ns", halt_poll_success_ns),
-	VCPU_STAT_GENERIC("halt_poll_fail_ns", halt_poll_fail_ns),
-	VCPU_STAT("halt_wait_ns", halt_wait_ns),
-	VCPU_STAT_GENERIC("halt_successful_poll", halt_successful_poll),
-	VCPU_STAT_GENERIC("halt_attempted_poll", halt_attempted_poll),
-	VCPU_STAT("halt_successful_wait", halt_successful_wait),
-	VCPU_STAT_GENERIC("halt_poll_invalid", halt_poll_invalid),
-	VCPU_STAT_GENERIC("halt_wakeup", halt_wakeup),
-	VCPU_STAT("pf_storage", pf_storage),
-	VCPU_STAT("sp_storage", sp_storage),
-	VCPU_STAT("pf_instruc", pf_instruc),
-	VCPU_STAT("sp_instruc", sp_instruc),
-	VCPU_STAT("ld", ld),
-	VCPU_STAT("ld_slow", ld_slow),
-	VCPU_STAT("st", st),
-	VCPU_STAT("st_slow", st_slow),
-	VCPU_STAT("pthru_all", pthru_all),
-	VCPU_STAT("pthru_host", pthru_host),
-	VCPU_STAT("pthru_bad_aff", pthru_bad_aff),
-	VM_STAT("largepages_2M", num_2M_pages, .mode = 0444),
-	VM_STAT("largepages_1G", num_1G_pages, .mode = 0444),
-	{ NULL }
-};
-
 static inline void kvmppc_update_int_pending(struct kvm_vcpu *vcpu,
 			unsigned long pending_now, unsigned long old_pending)
 {
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 5b0c4dff4f10..890ec72cd327 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -89,31 +89,6 @@ struct _kvm_stats_header kvm_vcpu_stats_header = {
 	}
 };
 
-struct kvm_stats_debugfs_item debugfs_entries[] = {
-	VCPU_STAT("mmio", mmio_exits),
-	VCPU_STAT("sig", signal_exits),
-	VCPU_STAT("itlb_r", itlb_real_miss_exits),
-	VCPU_STAT("itlb_v", itlb_virt_miss_exits),
-	VCPU_STAT("dtlb_r", dtlb_real_miss_exits),
-	VCPU_STAT("dtlb_v", dtlb_virt_miss_exits),
-	VCPU_STAT("sysc", syscall_exits),
-	VCPU_STAT("isi", isi_exits),
-	VCPU_STAT("dsi", dsi_exits),
-	VCPU_STAT("inst_emu", emulated_inst_exits),
-	VCPU_STAT("dec", dec_exits),
-	VCPU_STAT("ext_intr", ext_intr_exits),
-	VCPU_STAT_GENERIC("halt_successful_poll", halt_successful_poll),
-	VCPU_STAT_GENERIC("halt_attempted_poll", halt_attempted_poll),
-	VCPU_STAT_GENERIC("halt_poll_invalid", halt_poll_invalid),
-	VCPU_STAT_GENERIC("halt_wakeup", halt_wakeup),
-	VCPU_STAT("doorbell", dbell_exits),
-	VCPU_STAT("guest doorbell", gdbell_exits),
-	VCPU_STAT_GENERIC("halt_poll_success_ns", halt_poll_success_ns),
-	VCPU_STAT_GENERIC("halt_poll_fail_ns", halt_poll_fail_ns),
-	VM_STAT_GENERIC("remote_tlb_flush", remote_tlb_flush),
-	{ NULL }
-};
-
 /* TODO: use vcpu_printf() */
 void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 522a6ac2e347..75d6d499c455 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -183,114 +183,6 @@ struct _kvm_stats_header kvm_vcpu_stats_header = {
 	}
 };
 
-struct kvm_stats_debugfs_item debugfs_entries[] = {
-	VCPU_STAT("userspace_handled", exit_userspace),
-	VCPU_STAT("exit_null", exit_null),
-	VCPU_STAT("pfault_sync", pfault_sync),
-	VCPU_STAT("exit_validity", exit_validity),
-	VCPU_STAT("exit_stop_request", exit_stop_request),
-	VCPU_STAT("exit_external_request", exit_external_request),
-	VCPU_STAT("exit_io_request", exit_io_request),
-	VCPU_STAT("exit_external_interrupt", exit_external_interrupt),
-	VCPU_STAT("exit_instruction", exit_instruction),
-	VCPU_STAT("exit_pei", exit_pei),
-	VCPU_STAT("exit_program_interruption", exit_program_interruption),
-	VCPU_STAT("exit_instr_and_program_int", exit_instr_and_program),
-	VCPU_STAT("exit_operation_exception", exit_operation_exception),
-	VCPU_STAT_GENERIC("halt_successful_poll", halt_successful_poll),
-	VCPU_STAT_GENERIC("halt_attempted_poll", halt_attempted_poll),
-	VCPU_STAT_GENERIC("halt_poll_invalid", halt_poll_invalid),
-	VCPU_STAT("halt_no_poll_steal", halt_no_poll_steal),
-	VCPU_STAT_GENERIC("halt_wakeup", halt_wakeup),
-	VCPU_STAT_GENERIC("halt_poll_success_ns", halt_poll_success_ns),
-	VCPU_STAT_GENERIC("halt_poll_fail_ns", halt_poll_fail_ns),
-	VCPU_STAT("instruction_lctlg", instruction_lctlg),
-	VCPU_STAT("instruction_lctl", instruction_lctl),
-	VCPU_STAT("instruction_stctl", instruction_stctl),
-	VCPU_STAT("instruction_stctg", instruction_stctg),
-	VCPU_STAT("deliver_ckc", deliver_ckc),
-	VCPU_STAT("deliver_cputm", deliver_cputm),
-	VCPU_STAT("deliver_emergency_signal", deliver_emergency_signal),
-	VCPU_STAT("deliver_external_call", deliver_external_call),
-	VCPU_STAT("deliver_service_signal", deliver_service_signal),
-	VCPU_STAT("deliver_virtio", deliver_virtio),
-	VCPU_STAT("deliver_stop_signal", deliver_stop_signal),
-	VCPU_STAT("deliver_prefix_signal", deliver_prefix_signal),
-	VCPU_STAT("deliver_restart_signal", deliver_restart_signal),
-	VCPU_STAT("deliver_program", deliver_program),
-	VCPU_STAT("deliver_io", deliver_io),
-	VCPU_STAT("deliver_machine_check", deliver_machine_check),
-	VCPU_STAT("exit_wait_state", exit_wait_state),
-	VCPU_STAT("inject_ckc", inject_ckc),
-	VCPU_STAT("inject_cputm", inject_cputm),
-	VCPU_STAT("inject_external_call", inject_external_call),
-	VM_STAT("inject_float_mchk", inject_float_mchk),
-	VCPU_STAT("inject_emergency_signal", inject_emergency_signal),
-	VM_STAT("inject_io", inject_io),
-	VCPU_STAT("inject_mchk", inject_mchk),
-	VM_STAT("inject_pfault_done", inject_pfault_done),
-	VCPU_STAT("inject_program", inject_program),
-	VCPU_STAT("inject_restart", inject_restart),
-	VM_STAT("inject_service_signal", inject_service_signal),
-	VCPU_STAT("inject_set_prefix", inject_set_prefix),
-	VCPU_STAT("inject_stop_signal", inject_stop_signal),
-	VCPU_STAT("inject_pfault_init", inject_pfault_init),
-	VM_STAT("inject_virtio", inject_virtio),
-	VCPU_STAT("instruction_epsw", instruction_epsw),
-	VCPU_STAT("instruction_gs", instruction_gs),
-	VCPU_STAT("instruction_io_other", instruction_io_other),
-	VCPU_STAT("instruction_lpsw", instruction_lpsw),
-	VCPU_STAT("instruction_lpswe", instruction_lpswe),
-	VCPU_STAT("instruction_pfmf", instruction_pfmf),
-	VCPU_STAT("instruction_ptff", instruction_ptff),
-	VCPU_STAT("instruction_stidp", instruction_stidp),
-	VCPU_STAT("instruction_sck", instruction_sck),
-	VCPU_STAT("instruction_sckpf", instruction_sckpf),
-	VCPU_STAT("instruction_spx", instruction_spx),
-	VCPU_STAT("instruction_stpx", instruction_stpx),
-	VCPU_STAT("instruction_stap", instruction_stap),
-	VCPU_STAT("instruction_iske", instruction_iske),
-	VCPU_STAT("instruction_ri", instruction_ri),
-	VCPU_STAT("instruction_rrbe", instruction_rrbe),
-	VCPU_STAT("instruction_sske", instruction_sske),
-	VCPU_STAT("instruction_ipte_interlock", instruction_ipte_interlock),
-	VCPU_STAT("instruction_essa", instruction_essa),
-	VCPU_STAT("instruction_stsi", instruction_stsi),
-	VCPU_STAT("instruction_stfl", instruction_stfl),
-	VCPU_STAT("instruction_tb", instruction_tb),
-	VCPU_STAT("instruction_tpi", instruction_tpi),
-	VCPU_STAT("instruction_tprot", instruction_tprot),
-	VCPU_STAT("instruction_tsch", instruction_tsch),
-	VCPU_STAT("instruction_sthyi", instruction_sthyi),
-	VCPU_STAT("instruction_sie", instruction_sie),
-	VCPU_STAT("instruction_sigp_sense", instruction_sigp_sense),
-	VCPU_STAT("instruction_sigp_sense_running", instruction_sigp_sense_running),
-	VCPU_STAT("instruction_sigp_external_call", instruction_sigp_external_call),
-	VCPU_STAT("instruction_sigp_emergency", instruction_sigp_emergency),
-	VCPU_STAT("instruction_sigp_cond_emergency", instruction_sigp_cond_emergency),
-	VCPU_STAT("instruction_sigp_start", instruction_sigp_start),
-	VCPU_STAT("instruction_sigp_stop", instruction_sigp_stop),
-	VCPU_STAT("instruction_sigp_stop_store_status", instruction_sigp_stop_store_status),
-	VCPU_STAT("instruction_sigp_store_status", instruction_sigp_store_status),
-	VCPU_STAT("instruction_sigp_store_adtl_status", instruction_sigp_store_adtl_status),
-	VCPU_STAT("instruction_sigp_set_arch", instruction_sigp_arch),
-	VCPU_STAT("instruction_sigp_set_prefix", instruction_sigp_prefix),
-	VCPU_STAT("instruction_sigp_restart", instruction_sigp_restart),
-	VCPU_STAT("instruction_sigp_cpu_reset", instruction_sigp_cpu_reset),
-	VCPU_STAT("instruction_sigp_init_cpu_reset", instruction_sigp_init_cpu_reset),
-	VCPU_STAT("instruction_sigp_unknown", instruction_sigp_unknown),
-	VCPU_STAT("instruction_diag_10", diagnose_10),
-	VCPU_STAT("instruction_diag_44", diagnose_44),
-	VCPU_STAT("instruction_diag_9c", diagnose_9c),
-	VCPU_STAT("diag_9c_ignored", diagnose_9c_ignored),
-	VCPU_STAT("diag_9c_forward", diagnose_9c_forward),
-	VCPU_STAT("instruction_diag_258", diagnose_258),
-	VCPU_STAT("instruction_diag_308", diagnose_308),
-	VCPU_STAT("instruction_diag_500", diagnose_500),
-	VCPU_STAT("instruction_diag_other", diagnose_other),
-	{ NULL }
-};
-
 /* allow nested virtualization in KVM (if enabled by user space) */
 static int nested;
 module_param(nested, int, S_IRUGO);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index abc5cc8293b3..d24055fcdc0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -282,53 +282,6 @@ struct _kvm_stats_header kvm_vcpu_stats_header = {
 	}
 };
 
-struct kvm_stats_debugfs_item debugfs_entries[] = {
-	VCPU_STAT("pf_fixed", pf_fixed),
-	VCPU_STAT("pf_guest", pf_guest),
-	VCPU_STAT("tlb_flush", tlb_flush),
-	VCPU_STAT("invlpg", invlpg),
-	VCPU_STAT("exits", exits),
-	VCPU_STAT("io_exits", io_exits),
-	VCPU_STAT("mmio_exits", mmio_exits),
-	VCPU_STAT("signal_exits", signal_exits),
-	VCPU_STAT("irq_window", irq_window_exits),
-	VCPU_STAT("nmi_window", nmi_window_exits),
-	VCPU_STAT("halt_exits", halt_exits),
-	VCPU_STAT_GENERIC("halt_successful_poll", halt_successful_poll),
-	VCPU_STAT_GENERIC("halt_attempted_poll", halt_attempted_poll),
-	VCPU_STAT_GENERIC("halt_poll_invalid", halt_poll_invalid),
-	VCPU_STAT_GENERIC("halt_wakeup", halt_wakeup),
-	VCPU_STAT("hypercalls", hypercalls),
-	VCPU_STAT("request_irq", request_irq_exits),
-	VCPU_STAT("irq_exits", irq_exits),
-	VCPU_STAT("host_state_reload", host_state_reload),
-	VCPU_STAT("fpu_reload", fpu_reload),
-	VCPU_STAT("insn_emulation", insn_emulation),
-	VCPU_STAT("insn_emulation_fail", insn_emulation_fail),
-	VCPU_STAT("irq_injections", irq_injections),
-	VCPU_STAT("nmi_injections", nmi_injections),
-	VCPU_STAT("req_event", req_event),
-	VCPU_STAT("l1d_flush", l1d_flush),
-	VCPU_STAT_GENERIC("halt_poll_success_ns", halt_poll_success_ns),
-	VCPU_STAT_GENERIC("halt_poll_fail_ns", halt_poll_fail_ns),
-	VCPU_STAT("nested_run", nested_run),
-	VCPU_STAT("directed_yield_attempted", directed_yield_attempted),
-	VCPU_STAT("directed_yield_successful", directed_yield_successful),
-	VCPU_STAT("guest_mode", guest_mode),
-	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
-	VM_STAT("mmu_pte_write", mmu_pte_write),
-	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
-	VM_STAT("mmu_flooded", mmu_flooded),
-	VM_STAT("mmu_recycled", mmu_recycled),
-	VM_STAT("mmu_cache_miss", mmu_cache_miss),
-	VM_STAT("mmu_unsync", mmu_unsync),
-	VM_STAT_GENERIC("remote_tlb_flush", remote_tlb_flush),
-	VM_STAT("largepages", lpages, .mode = 0444),
-	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
-	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
-	{ NULL }
-};
-
 u64 __read_mostly host_xcr0;
 u64 __read_mostly supported_xcr0;
 EXPORT_SYMBOL_GPL(supported_xcr0);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5e77f32abef5..60ddb64a134e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -589,7 +589,6 @@ struct kvm {
 	struct list_head devices;
 	u64 manual_dirty_log_protect;
 	struct dentry *debugfs_dentry;
-	struct kvm_stat_data **debugfs_stat_data;
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
@@ -1255,23 +1254,6 @@ static inline bool kvm_is_error_gpa(struct kvm *kvm, gpa_t gpa)
 	return kvm_is_error_hva(hva);
 }
 
-enum kvm_stat_kind {
-	KVM_STAT_VM,
-	KVM_STAT_VCPU,
-};
-
-struct kvm_stat_data {
-	struct kvm *kvm;
-	struct kvm_stats_debugfs_item *dbgfs_item;
-};
-
-struct kvm_stats_debugfs_item {
-	const char *name;
-	int offset;
-	enum kvm_stat_kind kind;
-	int mode;
-};
-
 struct _kvm_stats_header {
 	struct kvm_stats_header header;
 	char id[KVM_STATS_ID_MAXLEN];
@@ -1283,20 +1265,7 @@ struct _kvm_stats_desc {
 	char name[KVM_STATS_NAME_LEN];
 };
 
-#define KVM_DBGFS_GET_MODE(dbgfs_item)                                         \
-	((dbgfs_item)->mode ? (dbgfs_item)->mode : 0644)
-
-#define VM_STAT(n, x, ...)						       \
-	{ n, offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__ }
-#define VCPU_STAT(n, x, ...)						       \
-	{ n, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__ }
-#define VM_STAT_GENERIC(n, x, ...)					       \
-	{ n, offsetof(struct kvm, stat.generic.x), KVM_STAT_VM, ## __VA_ARGS__ }
-#define VCPU_STAT_GENERIC(n, x, ...)					       \
-	{ n, offsetof(struct kvm_vcpu, stat.generic.x),			       \
-	  KVM_STAT_VCPU, ## __VA_ARGS__ }
-
-#define STATS_DESC(stat, type, unit, base, exp)			       \
+#define STATS_DESC(stat, type, unit, base, exp)				       \
 	{								       \
 		{							       \
 			.flags = type | unit | base |			       \
@@ -1410,7 +1379,6 @@ struct _kvm_stats_desc {
 	STATS_DESC_TIME_NSEC("halt_poll_success_ns"),			       \
 	STATS_DESC_TIME_NSEC("halt_poll_fail_ns")
 
-extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
 extern struct _kvm_stats_header kvm_vm_stats_header;
 extern struct _kvm_stats_header kvm_vcpu_stats_header;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f5bea71ea61c..f2da1d94057d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -115,9 +115,6 @@ static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
 struct dentry *kvm_debugfs_dir;
 EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 
-static int kvm_debugfs_num_entries;
-static const struct file_operations stat_fops_per_vm;
-
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 #ifdef CONFIG_KVM_COMPAT
@@ -862,25 +859,15 @@ static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
 
 static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 {
-	int i;
-
 	if (!kvm->debugfs_dentry)
 		return;
 
 	debugfs_remove_recursive(kvm->debugfs_dentry);
-
-	if (kvm->debugfs_stat_data) {
-		for (i = 0; i < kvm_debugfs_num_entries; i++)
-			kfree(kvm->debugfs_stat_data[i]);
-		kfree(kvm->debugfs_stat_data);
-	}
 }
 
 static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 {
 	char dir_name[ITOA_MAX_LEN * 2];
-	struct kvm_stat_data *stat_data;
-	struct kvm_stats_debugfs_item *p;
 
 	if (!debugfs_initialized())
 		return 0;
@@ -888,24 +875,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
 	kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
 
-	kvm->debugfs_stat_data = kcalloc(kvm_debugfs_num_entries,
-					 sizeof(*kvm->debugfs_stat_data),
-					 GFP_KERNEL_ACCOUNT);
-	if (!kvm->debugfs_stat_data)
-		return -ENOMEM;
-
-	for (p = debugfs_entries; p->name; p++) {
-		stat_data = kzalloc(sizeof(*stat_data), GFP_KERNEL_ACCOUNT);
-		if (!stat_data)
-			return -ENOMEM;
-
-		stat_data->kvm = kvm;
-		stat_data->dbgfs_item = p;
-		kvm->debugfs_stat_data[p - debugfs_entries] = stat_data;
-		debugfs_create_file(p->name, KVM_DBGFS_GET_MODE(p),
-				    kvm->debugfs_dentry, stat_data,
-				    &stat_fops_per_vm);
-	}
 	return 0;
 }
 
@@ -4937,214 +4906,6 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_get_dev);
 
-static int kvm_debugfs_open(struct inode *inode, struct file *file,
-			   int (*get)(void *, u64 *), int (*set)(void *, u64),
-			   const char *fmt)
-{
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
-					  inode->i_private;
-
-	/* The debugfs files are a reference to the kvm struct which
-	 * is still valid when kvm_destroy_vm is called.
-	 * To avoid the race between open and the removal of the debugfs
-	 * directory we test against the users count.
-	 */
-	if (!refcount_inc_not_zero(&stat_data->kvm->users_count))
-		return -ENOENT;
-
-	if (simple_attr_open(inode, file, get,
-		    KVM_DBGFS_GET_MODE(stat_data->dbgfs_item) & 0222
-		    ? set : NULL,
-		    fmt)) {
-		kvm_put_kvm(stat_data->kvm);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int kvm_debugfs_release(struct inode *inode, struct file *file)
-{
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
-					  inode->i_private;
-
-	simple_attr_release(inode, file);
-	kvm_put_kvm(stat_data->kvm);
-
-	return 0;
-}
-
-static int kvm_get_stat_per_vm(struct kvm *kvm, size_t offset, u64 *val)
-{
-	*val = *(u64 *)((void *)kvm + offset);
-
-	return 0;
-}
-
-static int kvm_clear_stat_per_vm(struct kvm *kvm, size_t offset)
-{
-	*(u64 *)((void *)kvm + offset) = 0;
-
-	return 0;
-}
-
-static int kvm_get_stat_per_vcpu(struct kvm *kvm, size_t offset, u64 *val)
-{
-	int i;
-	struct kvm_vcpu *vcpu;
-
-	*val = 0;
-
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		*val += *(u64 *)((void *)vcpu + offset);
-
-	return 0;
-}
-
-static int kvm_clear_stat_per_vcpu(struct kvm *kvm, size_t offset)
-{
-	int i;
-	struct kvm_vcpu *vcpu;
-
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		*(u64 *)((void *)vcpu + offset) = 0;
-
-	return 0;
-}
-
-static int kvm_stat_data_get(void *data, u64 *val)
-{
-	int r = -EFAULT;
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
-
-	switch (stat_data->dbgfs_item->kind) {
-	case KVM_STAT_VM:
-		r = kvm_get_stat_per_vm(stat_data->kvm,
-					stat_data->dbgfs_item->offset, val);
-		break;
-	case KVM_STAT_VCPU:
-		r = kvm_get_stat_per_vcpu(stat_data->kvm,
-					  stat_data->dbgfs_item->offset, val);
-		break;
-	}
-
-	return r;
-}
-
-static int kvm_stat_data_clear(void *data, u64 val)
-{
-	int r = -EFAULT;
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
-
-	if (val)
-		return -EINVAL;
-
-	switch (stat_data->dbgfs_item->kind) {
-	case KVM_STAT_VM:
-		r = kvm_clear_stat_per_vm(stat_data->kvm,
-					  stat_data->dbgfs_item->offset);
-		break;
-	case KVM_STAT_VCPU:
-		r = kvm_clear_stat_per_vcpu(stat_data->kvm,
-					    stat_data->dbgfs_item->offset);
-		break;
-	}
-
-	return r;
-}
-
-static int kvm_stat_data_open(struct inode *inode, struct file *file)
-{
-	__simple_attr_check_format("%llu\n", 0ull);
-	return kvm_debugfs_open(inode, file, kvm_stat_data_get,
-				kvm_stat_data_clear, "%llu\n");
-}
-
-static const struct file_operations stat_fops_per_vm = {
-	.owner = THIS_MODULE,
-	.open = kvm_stat_data_open,
-	.release = kvm_debugfs_release,
-	.read = simple_attr_read,
-	.write = simple_attr_write,
-	.llseek = no_llseek,
-};
-
-static int vm_stat_get(void *_offset, u64 *val)
-{
-	unsigned offset = (long)_offset;
-	struct kvm *kvm;
-	u64 tmp_val;
-
-	*val = 0;
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_get_stat_per_vm(kvm, offset, &tmp_val);
-		*val += tmp_val;
-	}
-	mutex_unlock(&kvm_lock);
-	return 0;
-}
-
-static int vm_stat_clear(void *_offset, u64 val)
-{
-	unsigned offset = (long)_offset;
-	struct kvm *kvm;
-
-	if (val)
-		return -EINVAL;
-
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_clear_stat_per_vm(kvm, offset);
-	}
-	mutex_unlock(&kvm_lock);
-
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(vm_stat_fops, vm_stat_get, vm_stat_clear, "%llu\n");
-
-static int vcpu_stat_get(void *_offset, u64 *val)
-{
-	unsigned offset = (long)_offset;
-	struct kvm *kvm;
-	u64 tmp_val;
-
-	*val = 0;
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_get_stat_per_vcpu(kvm, offset, &tmp_val);
-		*val += tmp_val;
-	}
-	mutex_unlock(&kvm_lock);
-	return 0;
-}
-
-static int vcpu_stat_clear(void *_offset, u64 val)
-{
-	unsigned offset = (long)_offset;
-	struct kvm *kvm;
-
-	if (val)
-		return -EINVAL;
-
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_clear_stat_per_vcpu(kvm, offset);
-	}
-	mutex_unlock(&kvm_lock);
-
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_stat_fops, vcpu_stat_get, vcpu_stat_clear,
-			"%llu\n");
-
-static const struct file_operations *stat_fops[] = {
-	[KVM_STAT_VCPU] = &vcpu_stat_fops,
-	[KVM_STAT_VM]   = &vm_stat_fops,
-};
-
 static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 {
 	struct kobj_uevent_env *env;
@@ -5179,16 +4940,6 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	}
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
-	if (!IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
-		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
-
-		if (p) {
-			tmp = dentry_path_raw(kvm->debugfs_dentry, p, PATH_MAX);
-			if (!IS_ERR(tmp))
-				add_uevent_var(env, "STATS_PATH=%s", tmp);
-			kfree(p);
-		}
-	}
 	/* no need for checks, since we are adding at most only 5 keys */
 	env->envp[env->envp_idx++] = NULL;
 	kobject_uevent_env(&kvm_dev.this_device->kobj, KOBJ_CHANGE, env->envp);
@@ -5197,16 +4948,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 
 static void kvm_init_debug(void)
 {
-	struct kvm_stats_debugfs_item *p;
-
 	kvm_debugfs_dir = debugfs_create_dir("kvm", NULL);
-
-	kvm_debugfs_num_entries = 0;
-	for (p = debugfs_entries; p->name; ++p, kvm_debugfs_num_entries++) {
-		debugfs_create_file(p->name, KVM_DBGFS_GET_MODE(p),
-				    kvm_debugfs_dir, (void *)(long)p->offset,
-				    stat_fops[p->kind]);
-	}
 }
 
 static int kvm_suspend(void)
-- 
2.32.0.272.g935e593368-goog

