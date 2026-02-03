Return-Path: <kvm+bounces-70068-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHAsDHc/gmlHRQMAu9opvQ
	(envelope-from <kvm+bounces-70068-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:33:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C03DBDDA54
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 19D8931E34E8
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D40A3B8D72;
	Tue,  3 Feb 2026 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GxD6RPro"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB9C36921A
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 18:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142851; cv=none; b=jm/XkrHxr1lv8OjXxwrRGi0Itz7XEkDM2p+WqXcglCMXP0R+qnP5G6Rl5r3G4cxEXZUS4hDdSxt0PU3beW1IUyy/gGUj+feujvCnExDLXLkWSF7d6M76g6uWMR013n/AwmxKoR4KAOK3jhkjggLo3kWQA1n+hjXQpZRT1BA4okc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142851; c=relaxed/simple;
	bh=5qKciU/wQTlAZYz07tWCnSZCwBLFf8ZHzGIS4i11qSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E/FOSjXX8er3H5Jbjpp0EyekLOt32mGR97wMFOzdifw/iBlqKokz/62RUgkSLKCQE2dLSDe4t7Po2LhEaExkgcKS2Qo8Rz+a0MLpwB4SqGk4A2sX+IVDUGO3GsXoReXpapetZgEH8WdfIZLMHowyuoaJIA50jCkw8X8D7Biyoyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GxD6RPro; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142850; x=1801678850;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5qKciU/wQTlAZYz07tWCnSZCwBLFf8ZHzGIS4i11qSE=;
  b=GxD6RProNEcKQKQMCHJWg9o3awhDEwo8ozPzMQbSsYa+PORNrKZWZn4i
   LiSYAf4ZOdrtUFCECCBD5aekIQ42Tj847CmROJ8GYkG3wSEnTLU7cFteJ
   6HA8VCp04wrM+XWcSx9H8z/qeiaZjEEopOMF6jhqzwEPfnWPKF2FVBKwY
   boo50BOA7L+kieugK3DpRZnKVNodTdCueqC5wUCjlBtmIE/HoG6SY4YFF
   4Dj4RE2hmKI5DIvEKgg345InYClhF28XZ6GTCObcqHEYBHmvlomJrXMUr
   YCyIc8hLgRNzQO6sZVsSBR1fQKpEQI5OHEZXOd3PcrBXAa54zScewI9++
   A==;
X-CSE-ConnectionGUID: SxQu99WkTumzrw2v2lVXHg==
X-CSE-MsgGUID: 5CzsewYFSRiwkDEEltHODA==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71300779"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="71300779"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:20:50 -0800
X-CSE-ConnectionGUID: qerOpgUhRKyRhSPvD5+Yng==
X-CSE-MsgGUID: uSn06fLHQuyHWC0kT6T77A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="232845413"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:20:49 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86: apic, vmexit: replace nop with serialize to wait for deadline timer
Date: Tue,  3 Feb 2026 10:20:39 -0800
Message-ID: <7acdd9974effabe5dc461aa755eacf9fb0697467.1770116601.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70068-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: C03DBDDA54
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Fix apic and vmexit test cases to pass with APIC timer virtualization
by replacing nop instruction with serialize instruction.

apic and vmexit test cases use "wrmsr(TSCDEADLINE); nop" sequence to cause
deadline timer to fire immediately.  It's not guaranteed because
wrmsr(TSCDEADLINE) isn't serializing instruction according to SDM [1].
With APIC timer virtualization enabled, those test can fail.  It worked
before because KVM intercepts wrmsr(TSCDEADLINE).  KVM doesn't intercept it
with apic timer virtualization.

[1] From SDM 3a Serializing intructions
  An execution of WRMSR to any non-serializing MSR is not
  serializing. Non-serializing MSRs include the following: IA32_SPEC_CTRL
  MSR (MSR index 48H), IA32_PRED_CMD MSR (MSR index 49H), IA32_TSX_CTRL MSR
  (MSR index 122H), IA32_TSC_DEADLINE MSR (MSR index 6E0H), IA32_PKRS MSR
  (MSR index 6E1H), IA32_HWP_REQUEST MSR (MSR index 774H), or any of the
  x2APIC MSRs (MSR indices 802H to 83FH).

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 lib/x86/processor.h | 6 ++++++
 x86/apic.c          | 2 +-
 x86/vmexit.c        | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 42dd2d2a4787..ec91c9c2f87d 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -1086,6 +1086,12 @@ static inline void wrtsc(u64 tsc)
 }
 
 
+static inline void serialize(void)
+{
+	/* serialize instruction. It needs binutils >= 2.35. */
+	asm_safe(".byte 0x0f, 0x01, 0xe8");
+}
+
 static inline void invlpg(volatile void *va)
 {
 	asm volatile("invlpg (%0)" ::"r" (va) : "memory");
diff --git a/x86/apic.c b/x86/apic.c
index 0a52e9a45f1c..0ee788594499 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -35,7 +35,7 @@ static void __test_tsc_deadline_timer(void)
 	handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
 
 	wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
-	asm volatile ("nop");
+	serialize();
 	report(tdt_count == 1, "tsc deadline timer");
 	report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
 }
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 5296ed38aa34..6e3f4442f2f3 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -437,7 +437,7 @@ static int has_tscdeadline(void)
 static void tscdeadline_immed(void)
 {
 	wrmsr(MSR_IA32_TSCDEADLINE, rdtsc());
-	asm volatile("nop");
+	serialize();
 }
 
 static void tscdeadline(void)

base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
-- 
2.45.2


