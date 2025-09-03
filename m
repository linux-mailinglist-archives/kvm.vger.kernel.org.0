Return-Path: <kvm+bounces-56664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8813DB41571
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33393547860
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863EC2DA74D;
	Wed,  3 Sep 2025 06:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GXF2Q9EB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29022D94BC;
	Wed,  3 Sep 2025 06:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882048; cv=none; b=YgrUz7VE/KKD1YV66AnjmXU0ssqMDzAFEZoTXi/t+qhYsQv7wnkzOoZZ5vzH4DH1ZujcfJJIB70+fQqsjVmxHgre/xmmqtCB2H/zyIoqV+9zsRxTaep8fwUkh9XjD9SUnHS3ZKenGuJ25oXNcKckzV0zCEcLS1wbFIvZeIgSm9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882048; c=relaxed/simple;
	bh=6eRvm9cZzbpKgdE4GQTdQUwYkONs6b4GJehdP1EioZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e1vfG2qyHd51wSAAjMS4EwBiihfjzjZym0xnQrFU7w1GKvmxHB3qCWdQip+XuTy05dNboZF2ko1ZlmcVy1MfUpZvM3gXziNDIpgdGmPJoQX4z/Q4UpHAFbMfCxnRJa/MnWyq0gChu1F4jxK3jKysDNO99LyZSW/rzse12jhVdLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GXF2Q9EB; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882047; x=1788418047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6eRvm9cZzbpKgdE4GQTdQUwYkONs6b4GJehdP1EioZo=;
  b=GXF2Q9EBcznWqEZx1hlJfJbs6RJg3H09yPxoIgEGv1dWw/SNWA95/YRe
   iOuGSLm3dWqlliWI0z+Kzt7HKbK7lTFRABICsBCIa7egF4Y/LjzN0yeBm
   5yzjRYx/Z2gRy0UnfrB8AdSrBoKQslybuJl7XUaAO+SuqVPk8TSJi5iRI
   ITtZGLHi3R+w0PjI/sKuDBGQiQY3CMdchHCLAvMRCdColqWbr8tv6cF/s
   ZTnfqFHVWDRVfWBi6zEgiu1MupmtQL6wVWCpeupHDGDUVaR0rsr3tWP3T
   oQaAFffYoyNptw2aq8JNoG9aEu/jGKjifIoh3l3ulJtTf05M3OlnaI6oL
   A==;
X-CSE-ConnectionGUID: vY/6puujTKmw6vsTJ9snDg==
X-CSE-MsgGUID: C8yrbcMZS1quhCGpVWhPrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="63003775"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="63003775"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:47:26 -0700
X-CSE-ConnectionGUID: cEH1r5zITxqLFuTbblbDoQ==
X-CSE-MsgGUID: CkmYMpvvS3K1akr+J5tx6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171656547"
Received: from spr.sh.intel.com ([10.112.230.239])
  by orviesa008.jf.intel.com with ESMTP; 02 Sep 2025 23:47:23 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [kvm-unit-tests patch v3 2/8] x86/pmu: Relax precise count validation for Intel overcounted platforms
Date: Wed,  3 Sep 2025 14:45:55 +0800
Message-Id: <20250903064601.32131-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

As the VM-Exit/VM-Entry overcount issue on Intel Atom platforms,
there is no way to validate the precise count for "instructions" and
"branches" events on these overcounted Atom platforms. Thus relax the
precise count validation on these overcounted platforms.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 87365aff..04946d10 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -237,10 +237,15 @@ static void adjust_events_range(struct pmu_event *gp_events,
 	 * occur while running the measured code, e.g. if the host takes IRQs.
 	 */
 	if (pmu.is_intel && this_cpu_has_perf_global_ctrl()) {
-		gp_events[instruction_idx].min = LOOP_INSNS;
-		gp_events[instruction_idx].max = LOOP_INSNS;
-		gp_events[branch_idx].min = LOOP_BRANCHES;
-		gp_events[branch_idx].max = LOOP_BRANCHES;
+		if (!(intel_inst_overcount_flags & INST_RETIRED_OVERCOUNT)) {
+			gp_events[instruction_idx].min = LOOP_INSNS;
+			gp_events[instruction_idx].max = LOOP_INSNS;
+		}
+
+		if (!(intel_inst_overcount_flags & BR_RETIRED_OVERCOUNT)) {
+			gp_events[branch_idx].min = LOOP_BRANCHES;
+			gp_events[branch_idx].max = LOOP_BRANCHES;
+		}
 	}
 
 	/*
-- 
2.34.1


