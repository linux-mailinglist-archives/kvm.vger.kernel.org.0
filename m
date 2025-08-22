Return-Path: <kvm+bounces-55490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F11DBB3113F
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 10:09:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C40561624B5
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 08:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08D72EB861;
	Fri, 22 Aug 2025 08:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F3QO8FD4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656632EAD01;
	Fri, 22 Aug 2025 08:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849800; cv=none; b=WPR3PpzmgXvCo/itOn20pp6iCu4YulvoRQ1nutuavjMSLGL/0R5vxxawcJk1W7dFYuMgFpJ+BpZ4nG/STxxL4QlXXmlbCevf5bmQAU/fBnZItanNcyEtkveztQhoILv9m9/W3+FNqlCPxY5R/Fsf3+5oqqq9qka7V/Hd28/lmtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849800; c=relaxed/simple;
	bh=EVzPf3iifPs/2ZMUXNHNk5PkufPMs3ozehXKj84KWnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHkq+4hqKcThS5Ueoha5mlUfS/MjXrvQhC6+8Fua2A53U/GjGWRJyudbuOdYZH2/Ewb8nu23Q3tOCDbbL92/SKznnf/yCcaUbKx82hCVph5P3BWNtlacSmE0WS4LBCCzQ84+aOPty0rtV/t+X3GTE5iO7rdSD/FM5fWywxVQlZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F3QO8FD4; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755849798; x=1787385798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EVzPf3iifPs/2ZMUXNHNk5PkufPMs3ozehXKj84KWnk=;
  b=F3QO8FD4D69TgJVneslkcoxEnFzpDuoDbnLyLWXg2w4slPoPLzASeqfn
   4RgouK/q4I2IQLWZBBTqlNAr9zLvUMe5XithxOwazMO33lG+h8s16IHiO
   hiiLP8yIOx4xc+mNecTKno8WLUDiIkaael6o/rJJLsJbs4hNHTIt56HRE
   HUxtcpqT0L7p62R8Lzwob7g8zC7qXVuicttfZAIa8Xjw41Kgw0T5qF8Dq
   End1qcX+fp2Proh51oT4LzkQ1E8sunddFKen/Y+oAQa9ljQerSu0JrVsj
   it5GwLRznP0TeusMiHFKyDinvBO6RaBykDJ2CRV3/IWnzHgh+iVYLE4jl
   A==;
X-CSE-ConnectionGUID: rWKqiFNKRGurTV18MZFCPw==
X-CSE-MsgGUID: XgQYl4ZsQw632kdUPlBo6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58078198"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58078198"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:03:17 -0700
X-CSE-ConnectionGUID: 7xYl+hhAShS3eaKN54z8kA==
X-CSE-MsgGUID: 6vp66775TT2JXJdzYyYKsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="199606690"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:03:15 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: peterx@redhat.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 2/3] KVM: Skip invoking shared memory handler for entirely private GFN ranges
Date: Fri, 22 Aug 2025 16:02:34 +0800
Message-ID: <20250822080235.27274-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250822080100.27218-1-yan.y.zhao@intel.com>
References: <20250822080100.27218-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a GFN range is entirely private, it's unnecessary for
kvm_handle_hva_range() to invoke handlers for the GFN range, because
1) the gfn_range.attr_filter for the handler is KVM_FILTER_SHARED, which
   is for shared mappings only;
2) KVM has already zapped all shared mappings before setting the memory
   attribute to private.

This can avoid unnecessary zaps on private mappings for VMs of type
KVM_X86_SW_PROTECTED_VM, e.g., during auto numa balancing scans of VMAs.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 virt/kvm/kvm_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f769d1dccc21..e615ad405ce4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -620,6 +620,17 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.slot = slot;
 			gfn_range.lockless = range->lockless;
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+			/*
+			 * If GFN range are all private, no need to invoke the
+			 * handler.
+			 */
+			if (kvm_range_has_memory_attributes(kvm, gfn_range.start,
+							    gfn_range.end, ~0,
+							    KVM_MEMORY_ATTRIBUTE_PRIVATE))
+				continue;
+#endif
+
 			if (!r.found_memslot) {
 				r.found_memslot = true;
 				if (!range->lockless) {
-- 
2.43.2


