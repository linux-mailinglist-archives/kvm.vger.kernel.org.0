Return-Path: <kvm+bounces-25815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF28E96AF02
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:16:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FE0B1F2565B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04AF4F20E;
	Wed,  4 Sep 2024 03:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EA686JL/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D91874418;
	Wed,  4 Sep 2024 03:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419677; cv=none; b=BncibAK1vwzn991UfAFRb/xB78xG0gYcRdp/lT2HubA4SLZYZmF5mVsSduDBxVJw3IxEfZv3QA0oeYvGMqR7kF693iHoKeE2gmrFd3o/VxE8eZYHG7aeIxkfC282t4V906WKpTOJ8NwKi25KFJQ14CbBNl8t1cMludfG6Ear9Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419677; c=relaxed/simple;
	bh=m0aJmLVGUjr94xP1ERSToS276WOj1bIg2E0s9dvuB1U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FGUEbswwsly00iMcLTHzzX+MKY6sdKzMwBrfHDwZDSOh/3hbTnvebv3Is3vjujDcEg1PRUkUAdLwc+5JHGTBGAJA8IMsczCWkGiWNYhSfIGE3D3I3VxdN9IBJu/QTp24AeFKkdEqyqPzoahluZqWrpW0YrRl87h9OfSZeJmejLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EA686JL/; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419675; x=1756955675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m0aJmLVGUjr94xP1ERSToS276WOj1bIg2E0s9dvuB1U=;
  b=EA686JL/fEoN22Og7t1rGXbPlc6TQXDK9R/w6f65EV/rUZH5OXs9ocCp
   6Hgw0JQAYUzhLIrxxIG8G2NhBUbmkvTb5JMQVluw3PzYE3x4x6R/Ce7/L
   P7oM65pXt10nBaR9kxfKOB3o3+7Na5pHcOlKig6OIXZh/mWY3+r7yA05T
   htDnk8JoUig6J2EYmrZJ6tt/YeKYRpsp6p0SlttnseW6YK8NK1pKPVEjl
   /8D5zNf6PAlcIWf1bDog4W48CljcgUGvMd98chIH2fwt81w49Q3tiNyKB
   ypx8nHwIfy0fDzjrWc0VzBk/VACPTr9FsuBa/BoDvjZCqDrQMZJAG3bCq
   Q==;
X-CSE-ConnectionGUID: 4WKa0l1bQCqj7gDhLSS+pg==
X-CSE-MsgGUID: eFGCdBUGQnqr32N5NJFyrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564665"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564665"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:08 -0700
X-CSE-ConnectionGUID: 2x/iTZbURAehzn8Ov8nFrg==
X-CSE-MsgGUID: K/RD8d26TzqXJwI0iKeSMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106270"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:02 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/21] KVM: TDX: Set gfn_direct_bits to shared bit
Date: Tue,  3 Sep 2024 20:07:38 -0700
Message-Id: <20240904030751.117579-9-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Make the direct root handle memslot GFNs at an alias with the TDX shared
bit set.

For TDX shared memory, the memslot GFNs need to be mapped at an alias with
the shared bit set. These shared mappings will be be mapped on the KVM
MMU's "direct" root. The direct root has it's mappings shifted by
applying "gfn_direct_bits" as a mask. The concept of "GPAW" (guest
physical address width) determines the location of the shared bit. So set
gfn_direct_bits based on this, to map shared memory at the proper GPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Move setting of gfn_direct_bits to separate patch (Yan)
---
 arch/x86/kvm/vmx/tdx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8f43977ef4c6..25c24901061b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -921,6 +921,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	kvm_tdx->attributes = td_params->attributes;
 	kvm_tdx->xfam = td_params->xfam;
 
+	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
+		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
+	else
+		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
+
 out:
 	/* kfree() accepts NULL. */
 	kfree(init_vm);
-- 
2.34.1


