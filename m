Return-Path: <kvm+bounces-72917-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DgQBObCqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72917-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:52:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E32B121692D
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C859A3065800
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA45E4657F8;
	Thu,  5 Mar 2026 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hi03cx9p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE3B3EB819;
	Thu,  5 Mar 2026 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732697; cv=none; b=caXB428RzyXhlkVZEFJ7qfxpZ2XxoqmDhLO0QINQOAf31Wh+5QHiakJ+nbs16GO5/ExwITt1k/YwIJ/8E41MWwsloMAA/vlpWV9DC0xyY79Unh2ZBmBTuYuYGSTR8hq/T8EKarrtFrj/fN+LJe1DcIveLuo4i4RXbHwnW6NUIQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732697; c=relaxed/simple;
	bh=FMWxjFCblL92ZgWxMifGSelJ5wPyhBSh9S4BSW9hSkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2jgjJugYhwCFOS5Aftt80Ag8Y2VfdvYGQhZE5ELscXq9yC2Z9lfadaoJG8wlqfH+sIamrC6r93Bg2BBChSAeg3fXSoD9BB0CXgHfkCuyo87V3Dr3KJa3jiHUh4YYSxW6WzkKejkXONUd7OVHVym0PUuDVdqOQDDte9s/Khidtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hi03cx9p; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732696; x=1804268696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FMWxjFCblL92ZgWxMifGSelJ5wPyhBSh9S4BSW9hSkM=;
  b=hi03cx9pLdL7PzSdVBVlHaep5AF8+Y01f71axRyEEr1Voc4VlI6yHD6g
   HQZ/4IjIF5Xw2KtwqJG2cQZeWgSsQA5Ifrp1cgiq+iqcXCINn3kIobSPO
   8TYGV1fUYoF2NxPDlsj5xaUHZHuXcSX1RoTR1v4ObkFPwZOUK1hqiznPi
   99hsfhr6j5S3e+CWEMeH3jWq/Mv/4lr7R4JyPYDvQ3r92FVw6N4uUU8dm
   rPl3/4xSu+houYuiXBC4kf4qewoQ69O1kmqoyMy0JZhfCTu+fUZ5+DgXk
   YYcrqIsCEsgqDaBdYyAjp32IUjeefviLThvOQrKp/hbcmoBe2lAhH7L0d
   g==;
X-CSE-ConnectionGUID: G7g3lI/OSAuURcrmgyQnpA==
X-CSE-MsgGUID: +iJcCx4UTOiGPx+13zvTSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77701154"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77701154"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:55 -0800
X-CSE-ConnectionGUID: J/ZL7bbLRx+Ba+U+Lj423Q==
X-CSE-MsgGUID: PabPas1QS2yTIHBXJJMglg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="256647699"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:55 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 34/36] KVM: selftests: Add a global option to disable in-kernel irqchip
Date: Thu,  5 Mar 2026 09:44:14 -0800
Message-ID: <65c95008d3f3994fb220df26e661ef7d570b9a07.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: E32B121692D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72917-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

For test cases with in-kernel irqchip/apic disabled.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
--
Changes v1 -> v2:
- Newly added.
---
 tools/testing/selftests/kvm/include/x86/kvm_util_arch.h | 1 +
 tools/testing/selftests/kvm/lib/x86/processor.c         | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index be35d26bb320..fe502956b2ad 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -9,6 +9,7 @@
 #include "test_util.h"
 
 extern bool is_forced_emulation_enabled;
+extern bool disable_inkernel_irqchip;
 
 struct pte_masks {
 	uint64_t present;
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index f4e8649071b6..2342ea227638 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -27,6 +27,7 @@ bool host_cpu_is_hygon;
 bool host_cpu_is_amd_compatible;
 bool is_forced_emulation_enabled;
 uint64_t guest_tsc_khz;
+bool disable_inkernel_irqchip;
 
 const char *ex_str(int vector)
 {
@@ -789,7 +790,8 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus)
 	TEST_ASSERT(kvm_has_cap(KVM_CAP_GET_TSC_KHZ),
 		    "Require KVM_GET_TSC_KHZ to provide udelay() to guest.");
 
-	vm_create_irqchip(vm);
+	if (!disable_inkernel_irqchip)
+		vm_create_irqchip(vm);
 	vm_init_descriptor_tables(vm);
 
 	sync_global_to_guest(vm, host_cpu_is_intel);
@@ -798,6 +800,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus)
 	sync_global_to_guest(vm, host_cpu_is_amd_compatible);
 	sync_global_to_guest(vm, is_forced_emulation_enabled);
 	sync_global_to_guest(vm, pmu_errata_mask);
+	sync_global_to_guest(vm, disable_inkernel_irqchip);
 
 	if (is_sev_vm(vm)) {
 		struct kvm_sev_init init = { 0 };
-- 
2.45.2


