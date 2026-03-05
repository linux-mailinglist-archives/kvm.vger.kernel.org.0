Return-Path: <kvm+bounces-72903-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4ImrHDDDqWl3EQEAu9opvQ
	(envelope-from <kvm+bounces-72903-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:53:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA38216986
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:53:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 89FA431D730D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C52407582;
	Thu,  5 Mar 2026 17:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QKlvR77e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6F53ED5A2;
	Thu,  5 Mar 2026 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732681; cv=none; b=t6mCq7mdRaiiLNlR0P+OJHzTv4sLUOoxQUVQJCWeJKQV96TOiu8z8g8T52/t+mwZQ837OHgmY0I7AHC6kobugLbQ0xop2RON5YJeF+rENNBWiKb+yP3H9gq1YeyWRFBA8oQS3I4kIytnFvyqSIa9ZfchkM8ny6lq2M+mbPZMeIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732681; c=relaxed/simple;
	bh=1Opn2f6DMZ4y5pqtubhiSso/f/rsTDueXc5LKTv0leM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6S0dhEkJVz6gC80aIc8clq+004MwUXLJP9NsLCBMYndozAeF1s9mklIrNS3KjkztJmju1e8C1fCnjR570adSyFHrCluY11jsb/QEnn/1RlC7Ylsl2eqEe9dnj9JWmd9ClsKMPt5bhbVycspCIKBE2E6XGY2sEJ8hJntgSMm4EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QKlvR77e; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732680; x=1804268680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Opn2f6DMZ4y5pqtubhiSso/f/rsTDueXc5LKTv0leM=;
  b=QKlvR77eTZsPdyfW2pGJCHLhg5z8ZFArhigcDobeW+Lw3gU4mQ+e0OSs
   V0L7KTyvlNVa5LUg7kdWh/zMH9TNHmtxqOaNVrAvbP2lHq09EVPVnRbN3
   WDQ5AFOrcJr/iO6cePBLctsWb7wAS2DK3j8axh5mX/BJeAFOEIPPmC1fw
   os32vGV43HvQI6exeOPss1d2LikDz+Hu67cM849f1X7Kf3yUStOBFNCpn
   0xdIYYpMhQEldRyWXq7CC/jjlKJakKAlOo3rJswgNESrQV9x6jVuHMlDC
   grcDOSAoIHVaVEg2H8oQ9+mL1CSJfAF13H3UDRFtz0UjTi7GkeQ21AYvR
   A==;
X-CSE-ConnectionGUID: oN2f2LVCTlu1UqpkC7EylQ==
X-CSE-MsgGUID: u2E2VtbSSh6XQi/FVKgQ6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431578"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431578"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:38 -0800
X-CSE-ConnectionGUID: lof77IP7TMCxsd1noR2VXA==
X-CSE-MsgGUID: fS3eNfvcRkKBphd1MRG0OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447882"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:37 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/36] KVM: nVMX: Update intercept on TSC deadline MSR
Date: Thu,  5 Mar 2026 09:43:53 -0800
Message-ID: <8987d935f9531f4afebccc6bb9d330fdb4812d80.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBA38216986
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72903-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

When APIC timer virtualization is enabled, the hardware handles the access
to the guest TSC deadline MSR, not by the VMM.  Disable/enable MSR
intercept on TSC DEADLINE MSR based on the APIC timer virtualization bit of
tertiary processor-based execution control.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.h |  5 +++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1bd5e164e285..8bb8734cc690 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -598,6 +598,26 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
 	}
 }
 
+static inline void prepare_tsc_deadline_msr_intercepts(struct vmcs12 *vmcs12,
+						       unsigned long *msr_bitmap_l1,
+						       unsigned long *msr_bitmap_l0)
+{
+	if (nested_cpu_has_guest_apic_timer(vmcs12)) {
+		if (vmx_test_msr_bitmap_read(msr_bitmap_l1, MSR_IA32_TSC_DEADLINE))
+			vmx_set_msr_bitmap_read(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+		else
+			vmx_clear_msr_bitmap_read(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+
+		if (vmx_test_msr_bitmap_write(msr_bitmap_l1, MSR_IA32_TSC_DEADLINE))
+			vmx_set_msr_bitmap_write(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+		else
+			vmx_clear_msr_bitmap_write(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+	} else {
+		vmx_set_msr_bitmap_read(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+		vmx_set_msr_bitmap_write(msr_bitmap_l0, MSR_IA32_TSC_DEADLINE);
+	}
+}
+
 #define BUILD_NVMX_MSR_INTERCEPT_HELPER(rw)					\
 static inline									\
 void nested_vmx_set_msr_##rw##_intercept(struct vcpu_vmx *vmx,			\
@@ -745,6 +765,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	prepare_tsc_deadline_msr_intercepts(vmcs12, msr_bitmap_l1, msr_bitmap_l0);
+
 	/*
 	 * Always check vmcs01's bitmap to honor userspace MSR filters and any
 	 * other runtime changes to vmcs01's bitmap, e.g. dynamic pass-through.
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 52bf035bcc03..6df2cfb20d87 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -286,6 +286,11 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
 }
 
+static inline bool nested_cpu_has_guest_apic_timer(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has3(vmcs12, TERTIARY_EXEC_GUEST_APIC_TIMER);
+}
+
 /*
  * if fixed0[i] == 1: val[i] must be 1
  * if fixed1[i] == 0: val[i] must be 0
-- 
2.45.2


