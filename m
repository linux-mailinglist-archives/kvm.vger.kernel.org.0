Return-Path: <kvm+bounces-35262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9F36A0AD56
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E3133A6D61
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 02:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F0973477;
	Mon, 13 Jan 2025 02:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dDqwoy9b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283BC145B00;
	Mon, 13 Jan 2025 02:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736734437; cv=none; b=BLQF4GY4C7igtgCGPHCIQVg7gG9JRv2+vTe/09K7Q603f/x9kILykVBKJMO8W/LGrNjhADZ7kRtPN29SdHNWXC8cED3ujFf7TD8epeqAM9qEWxNL4MPOE9y3VUPtk+eVyF9f35M6aediYlT5alzPZ6xj4CbLSjrpNoKQaeds2eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736734437; c=relaxed/simple;
	bh=qpaRne1AKCGk1uWv551ShWBepilaFlywD79fQ72qHaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdgqdTw5C8oxOT8SIfAAd+nHKFadDCDGB3E1ojbMhKcWzg1c1V3FzCEN4u2dQtPlfI5mgsVyKgHtS0xZeUEgFujAJx2HEJ8ZPbeqzBj/7AORpXuEFmU6zi1ZOzFwd5lw4IpO+mfZJKwXNqEfcWvnmY8RhHycLEgh/cJvhVGZYAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dDqwoy9b; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736734436; x=1768270436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qpaRne1AKCGk1uWv551ShWBepilaFlywD79fQ72qHaA=;
  b=dDqwoy9b1u1U9Mn6E7mlnbnIvzV9jiFa6HZ5RvHHKhN67sqrqp4DEaU7
   YLt4NizVwB39nOqv7+Ff7UaRnfg3/MX817tDif0sbruRSFj0IvA2wF4q3
   YcGuvBbbQ9coHB6oYrezHOGyr/tRbCzQNG1qs/kAM8KOeBYpQbMr7sky4
   9uNk6Xl3amXJ++v1U3HatxskwvSegGFQoymlLrUee4XuUtP1bCtg6dHoJ
   pO4kDpoZCKMzfwrupb955GEqh+FgsZNaeVfUWdXWQs+qhDCz6wJ+83qO9
   /fwW7pFIGQ3iIEUg/D1Ja4k4mLQz4Qz6Bi7KlYd2lfZoB2IrxuKWRdOjL
   Q==;
X-CSE-ConnectionGUID: imRiQNcKTlK9fNxEjjAcVA==
X-CSE-MsgGUID: ZX4EVmoWQJGUE/L8wrAmUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="36996140"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="36996140"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:13:51 -0800
X-CSE-ConnectionGUID: 1MAAQdH8TH+kPiFxUFjHvQ==
X-CSE-MsgGUID: DGiZ8Ml5RUOhSmxlgcqmGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104896448"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:13:48 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH 5/7] fixup! KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table
Date: Mon, 13 Jan 2025 10:13:00 +0800
Message-ID: <20250113021301.18962-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250113020925.18789-1-yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Return -EBUSY instead of -EAGAIN when tdh_mem_sept_add() encounters any err
of TDX_OPERAND_BUSY.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 09677a4cd605..4fb9faca5db2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1740,8 +1740,9 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_sept_add(to_kvm_tdx(kvm)->tdr_pa, gpa, tdx_level, hpa, &entry,
 			       &level_state);
-	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
-		return -EAGAIN;
+	if (unlikely(err & TDX_OPERAND_BUSY))
+		return -EBUSY;
+
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
 		return -EIO;
-- 
2.43.2


