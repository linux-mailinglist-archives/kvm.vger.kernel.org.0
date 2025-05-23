Return-Path: <kvm+bounces-47532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3EC6AC1F58
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC0D07B5294
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420731487FE;
	Fri, 23 May 2025 09:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mb2RyrUU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979F022422F
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 09:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747991362; cv=none; b=jtfJNfuxOjKqx5RxNQ/qV7fJyIV18AMn6hIbT6DPwNhhE0AbGkIK28bi4dfthr3mm6wg1l6vMUen9K4iC+P5ZmnDoErlViADykQOVVvthGbPycc7GpZQHCiCSAgHhkj8uBaCCicMWsLJboz+DE5XCsNRfjOiGygDwswwvYn7E+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747991362; c=relaxed/simple;
	bh=CyAL8nGngyYPTPj/RyM0cG7AD5W56Xn51of35A6VfoY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QSh3dJJ0XEuaDxo+GIqI3q+8ImvjhxCCiIVHUuq3ub2Ibi8s42SwM+Bls6yAlPV/UNLZjyjg4UuJpqPFch0eCcGm3VxiO0OGASLfDQYe+3+ZqeF3j95AkYZMAKrA0fJihj1BDuDRWF5AfzGIvYT7p9/53eGAnFiAORQ9NmcBAUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mb2RyrUU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747991360; x=1779527360;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CyAL8nGngyYPTPj/RyM0cG7AD5W56Xn51of35A6VfoY=;
  b=Mb2RyrUU02wE35xvPCPuu4OY26dSrz3C07mvmyIAZs+jivwsFz+Hq6A5
   ZsvgpTmj3YQnNYDxmYmlznM9MUbuTuqYHdM8SsKWyt+Tk8kcc2bEi5bDL
   Ar5xoKCSfAknSKmXo0ELyQvtiuHuxqxZ5XAbsoT2UT8a/RD2zb5qDTmDB
   yx/AwzdztWCb40xBj+CIb3C6yJftSuJpctIZ1MT8Kh3XGcG9PNLFWJsAp
   N4RwMdXWuyPfr7woxkemxVi+F8VXbczqo4XlABHAvbrYkrXrabTj5txe6
   qBknv411RBFgPb20PxZMCFGgtz3i98NjtICljnIAh/w6FYSRUQQbgzPgR
   g==;
X-CSE-ConnectionGUID: rm50F+hARcSAR+n01iFr4g==
X-CSE-MsgGUID: OBhXvhYKSaO32GwkwaXvtA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="67606273"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="67606273"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:09:20 -0700
X-CSE-ConnectionGUID: //UJc5PXQB2PnkvugmWJrA==
X-CSE-MsgGUID: sRYeCB40Q3O2bE8ZF/n6fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="141482016"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:09:17 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] nVMX: Fix testing failure for canonical checks when forced emulation is not available
Date: Fri, 23 May 2025 17:08:31 +0800
Message-ID: <20250523090848.16133-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the _safe() variant instead of _fep_safe() to avoid failure if the
forced emulated is not available.

Fixes: 05fbb364b5b2 ("nVMX: add a test for canonical checks of various host state vmcs12 fields")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 x86/vmx_tests.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2f178227..01a15b7c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10881,12 +10881,11 @@ static int set_host_value(u64 vmcs_field, u64 value)
 	case HOST_BASE_GDTR:
 		sgdt(&dt_ptr);
 		dt_ptr.base = value;
-		lgdt(&dt_ptr);
-		return lgdt_fep_safe(&dt_ptr);
+		return lgdt_safe(&dt_ptr);
 	case HOST_BASE_IDTR:
 		sidt(&dt_ptr);
 		dt_ptr.base = value;
-		return lidt_fep_safe(&dt_ptr);
+		return lidt_safe(&dt_ptr);
 	case HOST_BASE_TR:
 		/* Set the base and clear the busy bit */
 		set_gdt_entry(FIRST_SPARE_SEL, value, 0x200, 0x89, 0);
-- 
2.43.5


