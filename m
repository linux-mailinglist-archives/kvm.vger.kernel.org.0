Return-Path: <kvm+bounces-69826-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKiGOLNzgGnU8QIAu9opvQ
	(envelope-from <kvm+bounces-69826-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:51:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8787DCA4CD
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:51:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EF33A30059AD
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 09:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D01AB2DC349;
	Mon,  2 Feb 2026 09:51:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8B225D208
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 09:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770025901; cv=none; b=jOcSh62wtqNdaardUwpXiZs42EWpKLhS6gHvT/Ke0JpEYbmgNUJq4vai9y0DMD6Fq4DK5Ja+vl+IFajqVS4oBCq6GnBX+pA8ZNBgPILviTw6azyxki3HM2GBc/Km/pY1HD8eVwxW09Z7tvIdIpUMQOo/Hm6jgq4hybsJcd1ax0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770025901; c=relaxed/simple;
	bh=b5o0cY6qCWOuNRxh+lvzaEyEWML+dzfY8rihfm/kSJk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iwfimJrpqVO0Et0ic/wDUpeFh3IHA4Yu1ZCNy8CiSuTMrFYYA/cEcnb1R2y1TdiYDIhdGDqSswojeZOPrizN5usPYcZCzs7xN58vVQGsxauLA6HLTVT9Th+oK0jNDMtJLoardDWot5KbQUBZa9Uh+xb8iKLd34w97tC9r4FcWWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H . Peter Anvin"
	<hpa@zytor.com>, <kvm@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v2] KVM: SVM: Mark module parameters as __ro_after_init for security and performance
Date: Mon, 2 Feb 2026 04:50:04 -0500
Message-ID: <20260202095004.1765-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc13.internal.baidu.com (172.31.51.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[baidu.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69826-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_NEQ_ENVFROM(0.00)[lirongqing@baidu.com,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8787DCA4CD
X-Rspamd-Action: no action

From: Li RongQing <lirongqing@baidu.com>

SVM module parameters such as avic, sev_enabled, npt_enabled, and
pause_filter_thresh are configured exclusively during initialization
(via kernel command line) and remain constant throughout runtime.
Additionally, sev_supported_vmsa_features and svm_gp_erratum_intercept,
while not exposed as module parameters, share the same initialization
pattern and runtime constancy.

Mark these variables with '__ro_after_init' to:
- Harden against accidental or malicious runtime modification
- Enable compiler and CPU optimizations (improved caching, branch prediction)
- Align with kernel security best practices for init-only configuration

The exception is 'iopm_base', which retains '__read_mostly' as it requires
updates during module unloading.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Diff with v1: mark as __ro_after_init, not __read_mostly

 arch/x86/kvm/svm/avic.c |  4 ++--
 arch/x86/kvm/svm/sev.c  | 12 ++++++------
 arch/x86/kvm/svm/svm.c  | 32 ++++++++++++++++----------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6b77b20..7cc22d1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -86,13 +86,13 @@ static const struct kernel_param_ops avic_ops = {
  * Enable / disable AVIC.  In "auto" mode (default behavior), AVIC is enabled
  * for Zen4+ CPUs with x2AVIC (and all other criteria for enablement are met).
  */
-static int avic = AVIC_AUTO_MODE;
+static int __ro_after_init avic = AVIC_AUTO_MODE;
 module_param_cb(avic, &avic_ops, &avic, 0444);
 __MODULE_PARM_TYPE(avic, "bool");
 
 module_param(enable_ipiv, bool, 0444);
 
-static bool force_avic;
+static bool __ro_after_init force_avic;
 module_param_unsafe(force_avic, bool, 0444);
 
 /* Note:
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65a..afd2375 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -42,23 +42,23 @@
 #define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 /* enable/disable SEV support */
-static bool sev_enabled = true;
+static bool __ro_after_init sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
 
 /* enable/disable SEV-ES support */
-static bool sev_es_enabled = true;
+static bool __ro_after_init sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-SNP support */
-static bool sev_snp_enabled = true;
+static bool __ro_after_init sev_snp_enabled = true;
 module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
-static bool sev_es_debug_swap_enabled = true;
+static bool __ro_after_init sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
-static u64 sev_supported_vmsa_features;
+static u64 __ro_after_init sev_supported_vmsa_features;
 
-static unsigned int nr_ciphertext_hiding_asids;
+static unsigned int __ro_after_init nr_ciphertext_hiding_asids;
 module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 0444);
 
 #define AP_RESET_HOLD_NONE		0
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59cc..cc1c9cb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -110,52 +110,52 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
  *	count only mode.
  */
 
-static unsigned short pause_filter_thresh = KVM_DEFAULT_PLE_GAP;
+static unsigned short __ro_after_init pause_filter_thresh = KVM_DEFAULT_PLE_GAP;
 module_param(pause_filter_thresh, ushort, 0444);
 
-static unsigned short pause_filter_count = KVM_SVM_DEFAULT_PLE_WINDOW;
+static unsigned short __ro_after_init pause_filter_count = KVM_SVM_DEFAULT_PLE_WINDOW;
 module_param(pause_filter_count, ushort, 0444);
 
 /* Default doubles per-vcpu window every exit. */
-static unsigned short pause_filter_count_grow = KVM_DEFAULT_PLE_WINDOW_GROW;
+static unsigned short __ro_after_init pause_filter_count_grow = KVM_DEFAULT_PLE_WINDOW_GROW;
 module_param(pause_filter_count_grow, ushort, 0444);
 
 /* Default resets per-vcpu window every exit to pause_filter_count. */
-static unsigned short pause_filter_count_shrink = KVM_DEFAULT_PLE_WINDOW_SHRINK;
+static unsigned short __ro_after_init pause_filter_count_shrink = KVM_DEFAULT_PLE_WINDOW_SHRINK;
 module_param(pause_filter_count_shrink, ushort, 0444);
 
 /* Default is to compute the maximum so we can never overflow. */
-static unsigned short pause_filter_count_max = KVM_SVM_DEFAULT_PLE_WINDOW_MAX;
+static unsigned short __ro_after_init pause_filter_count_max = KVM_SVM_DEFAULT_PLE_WINDOW_MAX;
 module_param(pause_filter_count_max, ushort, 0444);
 
 /*
  * Use nested page tables by default.  Note, NPT may get forced off by
  * svm_hardware_setup() if it's unsupported by hardware or the host kernel.
  */
-bool npt_enabled = true;
+bool __ro_after_init npt_enabled = true;
 module_param_named(npt, npt_enabled, bool, 0444);
 
 /* allow nested virtualization in KVM/SVM */
-static int nested = true;
+static int __ro_after_init nested = true;
 module_param(nested, int, 0444);
 
 /* enable/disable Next RIP Save */
-int nrips = true;
+int __ro_after_init nrips = true;
 module_param(nrips, int, 0444);
 
 /* enable/disable Virtual VMLOAD VMSAVE */
-static int vls = true;
+static int __ro_after_init vls = true;
 module_param(vls, int, 0444);
 
 /* enable/disable Virtual GIF */
-int vgif = true;
+int __ro_after_init vgif = true;
 module_param(vgif, int, 0444);
 
 /* enable/disable LBR virtualization */
-int lbrv = true;
+int __ro_after_init lbrv = true;
 module_param(lbrv, int, 0444);
 
-static int tsc_scaling = true;
+static int __ro_after_init tsc_scaling = true;
 module_param(tsc_scaling, int, 0444);
 
 module_param(enable_device_posted_irqs, bool, 0444);
@@ -164,17 +164,17 @@ bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
 
-bool intercept_smi = true;
+bool __ro_after_init intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
-bool vnmi = true;
+bool __ro_after_init vnmi = true;
 module_param(vnmi, bool, 0444);
 
-static bool svm_gp_erratum_intercept = true;
+static bool __ro_after_init svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
-static unsigned long iopm_base;
+static unsigned long __read_mostly iopm_base;
 
 DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
-- 
2.9.4


