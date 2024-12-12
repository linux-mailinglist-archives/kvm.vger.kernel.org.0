Return-Path: <kvm+bounces-33542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9082A9EDDE3
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 04:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5ED2518879A2
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 03:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BCA13F43A;
	Thu, 12 Dec 2024 03:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U9xBdfy9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0EE7E765
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 03:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733973908; cv=none; b=oMaJdehVYhmIb6SepxANpv4A9PzGMuyG+8F1cqDqmo3JfPe4HXpz43o599FGys55N10K4Lvo2Gj1SNQ9KLcA+NesvpznEaot7SWH0Ia4F/Fbw36dWKXD4qgwNEvBB3T4me08ijeK39r3p1EapcBmYlB5xT+irMyXYze0PkFJZVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733973908; c=relaxed/simple;
	bh=GLCRNHfklif14YZfFPd8l3g1BDbCi9VJi69RCLiwMqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MBp1Birj6F7wyqf70q4cZyPt2WaOAIDutkYqq1c0E7nb4JD78CGq3MdTy8jz0HL1V90raCUIr9JSXposhr35FW8s0IXWhfdBbXUXucMB1K2MVJJxGfNXIWpnOG7+yvQx4l0Mm+zbZfH13aiL/KZlHAGKdTaYjMacpxcouz/iMNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U9xBdfy9; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733973907; x=1765509907;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GLCRNHfklif14YZfFPd8l3g1BDbCi9VJi69RCLiwMqk=;
  b=U9xBdfy98O9anSSY8oo7PSvuWFYNZgWCnyBRKdZ2N643BVkQ7rgwl6//
   aa6FgTCR2punHKyRbdTm62TN+mOaJ3n0CsIJ8aiABHy6v4fKJ9R/bH6Ei
   VPa1D1ZaiheG2ZxuP3QE2dOn0b8Q0ZXM3J+siA4mBkZtNGRycoSIkqMak
   8jRo4UHz0HSKxjNuRCh9XR0+BOE67TOfWmixhiw7o8etWWEWFyYQr1+jU
   f+lALusXdjivS3qhScNJJqVCXGypNVMBSUkYkRHP6aNRdF4IRCr0JufKH
   dP3KCW3H6sTYY8RxNgZ83CdJ3tUUh4AQauQDpFLAknfE7zfDCo7yGeYym
   g==;
X-CSE-ConnectionGUID: PobsVdl2Sr+1OBaX3rOKiw==
X-CSE-MsgGUID: v3tSuOcFSJO81PR9oh19zA==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="45053238"
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="45053238"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 19:25:06 -0800
X-CSE-ConnectionGUID: Dhxs3Hq1RQKSCK2qH1yG7w==
X-CSE-MsgGUID: rB0F80/pSSytv/L1/kcNVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="96293296"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 19:24:59 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	farrah.chen@intel.com,
	kvm@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH] i386/kvm: Set return value after handling KVM_EXIT_HYPERCALL
Date: Thu, 12 Dec 2024 11:26:28 +0800
Message-ID: <20241212032628.475976-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace should set the ret field of hypercall after handling
KVM_EXIT_HYPERCALL.  Otherwise, a stale value could be returned to KVM.

Fixes: 47e76d03b15 ("i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE")
Reported-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
To test the TDX code in kvm-coco-queue, please apply the patch to the QEMU,
otherwise, TDX guest boot could fail.
A matching QEMU tree including this patch is here:
https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu-upstream-v6.1-fix_kvm_hypercall_return_value

Previously, the issue was not triggered because no one would modify the ret
value. But with the refactor patch for __kvm_emulate_hypercall() in KVM,
https://lore.kernel.org/kvm/20241128004344.4072099-7-seanjc@google.com/, the
value could be modified.
---
 target/i386/kvm/kvm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8e17942c3b..4bcccb48d1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6005,10 +6005,14 @@ static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
 
 static int kvm_handle_hypercall(struct kvm_run *run)
 {
+    int ret = -EINVAL;
+
     if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
-        return kvm_handle_hc_map_gpa_range(run);
+        ret = kvm_handle_hc_map_gpa_range(run);
+
+    run->hypercall.ret = ret;
 
-    return -EINVAL;
+    return ret;
 }
 
 #define VMX_INVALID_GUEST_STATE 0x80000021

base-commit: ae35f033b874c627d81d51070187fbf55f0bf1a7
-- 
2.46.0


