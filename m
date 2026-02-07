Return-Path: <kvm+bounces-70531-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mE77IpuUhmnuOwQAu9opvQ
	(envelope-from <kvm+bounces-70531-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:25:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E41691047E2
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01B3F307B237
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 01:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DEE290D81;
	Sat,  7 Feb 2026 01:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gYdt6FZ9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E703286418
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 01:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770427438; cv=none; b=ZdaikzXxNri3ib1mmGq367aqsOWnVOYi7DgclDPU+iFmGszorfJ4PZNUkBEhFxEyDwy7gUBG2Y3WiQD3bKjuFBloNPqCz8HcgLlvdlAgAC3r8VnSz4Dats6vOcoE0thOiaWAm5bltes+y8peyaAZ6D+t1oiiNHLBoH7CHwxg7DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770427438; c=relaxed/simple;
	bh=2GgBCsfprKhcXfHGilZWm/7dHAnCoVcRRuhBWLgA7rg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AjHvIzknLXS1vovCJZQk3uLYfaAe9nukX1zGAIeizK/SaFugCzRU0E9D0BWakq1zZ34lSEgHlpL/wqCNgAVf+NjGovnVW9/z9xkJO0BT2BjNe2itfUmgdV7Fi/fY/Mm/mAsHxliuj3PY4/WsXM802+BOM6hlBlI57wxVID+Qh9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gYdt6FZ9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352e6fcd72dso2267808a91.3
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 17:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770427438; x=1771032238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vJYQh1/AHMiGSmp1C/Vj2riCycFzgp01zsmPrrucJzY=;
        b=gYdt6FZ9IE96Rq+htKsZu/zdiOO9YX9MUMEZ6Ol4BOAloWuGFs+YDdUN9Y8JVuBZiJ
         9lShzzs9Pfqkydsb5yRQODKiX8xEfOAJlp6TdrdErHorZhKGMug3e/Gmnsj0QYcDVL4s
         A7gnIJhpNvCq5HV7wzX0xdW9EFXvPvS+errADq/uzyfI0hWkdQ4whRpG8D4MJ14AInuS
         po/oz5I35jhOExO58Llv3N/1N2r1z3lM7d8robbg3jDHWctN3G3Y36V6t08voIi+FSJx
         eTdB1tcMtMiJKbhududD3y8z9f4riScflrVtXv4ld7JLiQhaVtSJ7X3YkVEZi5YdvWXj
         8R/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770427438; x=1771032238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vJYQh1/AHMiGSmp1C/Vj2riCycFzgp01zsmPrrucJzY=;
        b=Lh7eJOqBT1A73xrg32CRlkv3Z4iEKcMcGUmz9igVZA1ENi1m02XU6jodL06+ax2XNa
         bVtqWvv1eZIRNV0lZfuuPTtD69IoeN88bjF+77eV5xSZYe0wN2wI2oVvjd9jNxHL77zq
         siBvwZelMggGV0q/cPVJ4yr3DYpxb4JgQmTDzK97VEdjXjOIrjTcPiZTxdETF4u6ZPnp
         Izw+ueQmRINmPYhBWN6eQxTrVZOd/om3GGSeAnRactXzf0q5ZU5WUYQHI+3cyheS/iDC
         0S1mStaAb1UkYrluaXa3AApHuITKTgcWp+4ln7xYZ0aOgWJLRohMnut6dYD0yl4lJ5/0
         vyHA==
X-Forwarded-Encrypted: i=1; AJvYcCVpe0XKLcROue5NwM8TKHJ5KT+0GwrlfPqyDyFKOTut7JHIfmqseIsSx2wbm8Vo3dWv6E4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz4S0Rqk4RvDRRwwN1I2uNTijUIyo0yNCvuITr7NGXAsLuQAwE
	lyR2qzoc9njGcKHH+PpsEd8acvsg23k8vItx6MoVCX1l8u5ZW2MW/asB5OSOn8HXQzaqyzZSE2h
	dejJRnhIF8NsffQ==
X-Received: from pjbpi14.prod.google.com ([2002:a17:90b:1e4e:b0:340:5073:f80f])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c47:b0:352:ccae:fe65 with SMTP id 98e67ed59e1d1-354b3c379d7mr3937008a91.4.1770427438017;
 Fri, 06 Feb 2026 17:23:58 -0800 (PST)
Date: Fri,  6 Feb 2026 17:23:29 -0800
In-Reply-To: <20260207012339.2646196-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207012339.2646196-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207012339.2646196-4-jmattson@google.com>
Subject: [PATCH v3 3/5] KVM: x86/pmu: Refresh Host-Only/Guest-Only eventsel at
 nested transitions
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70531-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E41691047E2
X-Rspamd-Action: no action

Add amd_pmu_refresh_host_guest_eventsel_hw() to recalculate eventsel_hw for
all PMCs based on the current vCPU state. This is needed because Host-Only
and Guest-Only counters must be enabled/disabled at:

  - SVME changes: When EFER.SVME is modified, counters with Guest-Only bits
    need their hardware enable state updated.

  - Nested transitions: When entering or leaving guest mode, Host-Only
    counters should be disabled/enabled and Guest-Only counters should be
    enabled/disabled accordingly.

Add a nested_transition() callback to kvm_x86_ops and call it from
enter_guest_mode() and leave_guest_mode() to ensure the PMU state stays
synchronized with guest mode transitions.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/kvm_cache_regs.h      |  2 ++
 arch/x86/kvm/svm/pmu.c             | 12 ++++++++++++
 arch/x86/kvm/svm/svm.c             |  3 +++
 arch/x86/kvm/svm/svm.h             |  5 +++++
 arch/x86/kvm/x86.c                 |  1 +
 7 files changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index de709fb5bd76..62ac8ecd26e9 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -108,6 +108,7 @@ KVM_X86_OP(get_entry_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
+KVM_X86_OP_OPTIONAL(nested_transition)
 KVM_X86_OP_OPTIONAL(vcpu_blocking)
 KVM_X86_OP_OPTIONAL(vcpu_unblocking)
 KVM_X86_OP_OPTIONAL(pi_update_irte)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c73..8dbc5c731859 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1901,6 +1901,8 @@ struct kvm_x86_ops {
 
 	void (*update_cpu_dirty_logging)(struct kvm_vcpu *vcpu);
 
+	void (*nested_transition)(struct kvm_vcpu *vcpu);
+
 	const struct kvm_x86_nested_ops *nested_ops;
 
 	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 8ddb01191d6f..14e2cbab8312 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -227,6 +227,7 @@ static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hflags |= HF_GUEST_MASK;
 	vcpu->stat.guest_mode = 1;
+	kvm_x86_call(nested_transition)(vcpu);
 }
 
 static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
@@ -239,6 +240,7 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->stat.guest_mode = 0;
+	kvm_x86_call(nested_transition)(vcpu);
 }
 
 static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 8d451110a94d..e2a849fc7daa 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -171,6 +171,18 @@ static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
 	pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
+void amd_pmu_refresh_host_guest_eventsel_hw(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	int i;
+
+	if (pmu->reserved_bits & AMD64_EVENTSEL_HOST_GUEST_MASK)
+		return;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
+		amd_pmu_set_eventsel_hw(&pmu->gp_counters[i]);
+}
+
 static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f0136dbdde6..5753388542cf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -244,6 +244,8 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
 		}
+
+		amd_pmu_refresh_host_guest_eventsel_hw(vcpu);
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
@@ -5222,6 +5224,7 @@ struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.check_intercept = svm_check_intercept,
 	.handle_exit_irqoff = svm_handle_exit_irqoff,
+	.nested_transition = amd_pmu_refresh_host_guest_eventsel_hw,
 
 	.nested_ops = &svm_nested_ops,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebd7b36b1ceb..c31ef7c46d58 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -864,6 +864,11 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
+
+/* pmu.c */
+void amd_pmu_refresh_host_guest_eventsel_hw(struct kvm_vcpu *vcpu);
+
+
 #ifdef CONFIG_KVM_AMD_SEV
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
 int sev_mem_enc_register_region(struct kvm *kvm,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..01ccbaa5b2e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -150,6 +150,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
+EXPORT_STATIC_CALL_GPL(kvm_x86_nested_transition);
 
 static bool __read_mostly ignore_msrs = 0;
 module_param(ignore_msrs, bool, 0644);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


