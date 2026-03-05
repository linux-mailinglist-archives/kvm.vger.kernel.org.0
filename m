Return-Path: <kvm+bounces-72902-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4EyPEZrCqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72902-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:51:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A04912168C5
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:51:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDFE931D4069
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E9A3FFAC6;
	Thu,  5 Mar 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aaxebCE3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C805A3E8C6F;
	Thu,  5 Mar 2026 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732681; cv=none; b=Ox69a8mSFPBja8bxUs/JKGtv2T8es2ue7fEFX9k7mkO3wB2umN0Df1+PDbz/s2FQ0EW9xx5Z3TU+3vPRnD70+GJ42kOTusnbPnW50W6gAx0DQZAXHRuLqmCjpJMCciC9kAaX4Ma3lFRQheUr/TBQFJtxId2O/Otn5rGFQsYrTjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732681; c=relaxed/simple;
	bh=kSruFzXc1Zum96mNVfzSPzNRNnCqz3iLxx8kTs52I20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZA3RrgQVztSqSsdAYiXq8ZMGCumZiD60VeUd5Q+yn11v2LNFyDwJmVJNBdRCi1ajtl1Pda5pMPzGg0mGkFIMWiYU3LIeZVM5u+un9ItAiVRXM96tiqH16THziQ3K3HKxjJBnTLju1iE56lefHJnDvLFI6PSgZUCKyON3MuXI2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aaxebCE3; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732678; x=1804268678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kSruFzXc1Zum96mNVfzSPzNRNnCqz3iLxx8kTs52I20=;
  b=aaxebCE3Jgjh4qp24adqSiUimOWtF/91MEyLyp3vZLz+qykFKfJlHxJe
   jko723CLK8OD5whKdiD2moc9ioe5TDbk92KhRfx7iQfyJQmFljs6AyE7/
   DI+AxhKfwu3iiIPN3oVEvTQC+beiNBCZJTYh7huOQD7d8Itoyg3PmW4ev
   VHg+DscCIsvY82RYKRorAZ8SruTcpTNYYXxS/wfYRq5L7XImEdIDyKvgs
   TFVBB9rJKyKSUjKehhSsSguHPYgE5lBi09WACYY2z7Ik31P+adJF55Osf
   31Stal62FqkGXl8YhjaDGigM7tMqHAxa9vbyam2gYwJc6wi2oJWu593lF
   A==;
X-CSE-ConnectionGUID: Wtr4i5GYRUKIE4T0+ZjTPA==
X-CSE-MsgGUID: PiiHdOHRQ8OEx+0nRGbDOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77431570"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77431570"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:37 -0800
X-CSE-ConnectionGUID: 49uCp5y9Q3eDjhM4KFggQg==
X-CSE-MsgGUID: MvTPDXUKRr6v8ZY0d9jMaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223447871"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:36 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/36] KVM: nVMX: Add alignment check for struct vmcs12
Date: Thu,  5 Mar 2026 09:43:51 -0800
Message-ID: <7112ca5bb871e809e469aa03b586f8b220d2d827.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: A04912168C5
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
	TAGGED_FROM(0.00)[bounces-72902-lists,kvm=lfdr.de];
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

As struct vmcs12 has __packed attributes and it has manual alignment,
it's easy to add unaligned member without any warnings.  Add alignment
check to avoid accidental misalignment.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmcs12.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 21cd1b75e4fd..8c9d4c22b960 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -217,7 +217,8 @@ struct __packed vmcs12 {
  * although appending fields and/or filling gaps is obviously allowed.
  */
 #define CHECK_OFFSET(field, loc) \
-	ASSERT_STRUCT_OFFSET(struct vmcs12, field, loc)
+	ASSERT_STRUCT_OFFSET(struct vmcs12, field, loc);		\
+	static_assert(loc % __alignof(((struct vmcs12 *)0)->field) == 0)
 
 static inline void vmx_check_vmcs12_offsets(void)
 {
-- 
2.45.2


