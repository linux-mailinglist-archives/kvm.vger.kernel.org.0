Return-Path: <kvm+bounces-50603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E20AE746D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 03:47:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AD453A6858
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4FF418C02E;
	Wed, 25 Jun 2025 01:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dmWqUbmB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BDF3D76;
	Wed, 25 Jun 2025 01:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750816063; cv=none; b=VH3lLtCM1SLJR2xzBJmz3J1ToF9A8gcjTVfPrkvduL0D+NR97RCTTxC9O6JKz6QrVDEkrjDkJc4yttAnKZ85tP964Nv/Y50XjfUShWtaDgHJ2x8MIqiStfQTKgty+eOungXksgq13su+1mUzDR2ZkkHIO/CE2iuNc2Xy6Nv2Owk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750816063; c=relaxed/simple;
	bh=4H38wenJUcrfZeBiwfo2NC94xpjgMDEVgcu3+QfB6S4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eprKmMcwlNbiYDOgSDeJmIzuPL+KHFVajqdcCw1GsM+mxxE/vVrhryqcRVX1JNAiHFdCdLldV1Gc4vLc79HauCA6o8JN4j6kIgJioVAPi4X28xoID8KPRA5Jj1aiifYsjF9JnlkEia9UTMW1oMh/pErIZtinElOTUeY7VluK6B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dmWqUbmB; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750816062; x=1782352062;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4H38wenJUcrfZeBiwfo2NC94xpjgMDEVgcu3+QfB6S4=;
  b=dmWqUbmBDEWj81dPqT5P9iTVHiYYMKhSavDh6Iy5zbwq+Rg8TLHJ/Wnp
   6Df4vnPYB1UMAtbzOt6BQpXxEVmnKo3pBRujvkHW3u4VJYN2TUZhIWbb0
   fAja81waFuWp3S/X/WrhqMqUktseE1ow4PxsEczS8+2poNVED1lU4zJac
   JC53SBWYll3USJaHGqKGisMJL1sr318mZe94t7eDQWtTcCYc8l2oFjsMA
   kMTBuk9VtLHCstW6h69vkJ92IEqMpjtDHudb7ki3omutpAjJoLFtmVSeD
   zpEV/0i4KYmOfOgH0jPox1VA+2pj37atksOV93oZeR5sHlH3Ir0FhliSL
   g==;
X-CSE-ConnectionGUID: nAP3sBciQ3ec7YZ1cfHIXQ==
X-CSE-MsgGUID: wloRlYVtQ5CGcnA8a+NBjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="53170568"
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="53170568"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 18:47:41 -0700
X-CSE-ConnectionGUID: hocKXkiEQ7u8Il5YkEybIQ==
X-CSE-MsgGUID: 9gYgb96GTlyJqTz3sU83/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="152204636"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 18:47:38 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: sfr@canb.auug.org.au,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH] Documentation: KVM: Fix unexpected unindent warnings
Date: Wed, 25 Jun 2025 09:48:29 +0800
Message-ID: <20250625014829.82289-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add proper indentations to bullet list items to resolve the warning:
"Bullet list ends without a blank line; unexpected unindent."

Fixes: cf207eac06f6 ("KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>")
Fixes: 25e8b1dd4883 ("KVM: TDX: Exit to userspace for GetTdVmCallInfo")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes:https://lore.kernel.org/kvm/20250623162110.6e2f4241@canb.auug.org.au/
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
The fix for the same issue in Linux Next due to the patch
"KVM: TDX: Exit to userspace for SetupEventNotifyInterrupt" is not included.
---
 Documentation/virt/kvm/api.rst | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9abf93ee5f65..a7dbe08dc376 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7210,21 +7210,21 @@ number from register R11.  The remaining field of the union provide the
 inputs and outputs of the TDVMCALL.  Currently the following values of
 ``nr`` are defined:
 
-* ``TDVMCALL_GET_QUOTE``: the guest has requested to generate a TD-Quote
-signed by a service hosting TD-Quoting Enclave operating on the host.
-Parameters and return value are in the ``get_quote`` field of the union.
-The ``gpa`` field and ``size`` specify the guest physical address
-(without the shared bit set) and the size of a shared-memory buffer, in
-which the TDX guest passes a TD Report.  The ``ret`` field represents
-the return value of the GetQuote request.  When the request has been
-queued successfully, the TDX guest can poll the status field in the
-shared-memory area to check whether the Quote generation is completed or
-not. When completed, the generated Quote is returned via the same buffer.
-
-* ``TDVMCALL_GET_TD_VM_CALL_INFO``: the guest has requested the support
-status of TDVMCALLs.  The output values for the given leaf should be
-placed in fields from ``r11`` to ``r14`` of the ``get_tdvmcall_info``
-field of the union.
+ * ``TDVMCALL_GET_QUOTE``: the guest has requested to generate a TD-Quote
+   signed by a service hosting TD-Quoting Enclave operating on the host.
+   Parameters and return value are in the ``get_quote`` field of the union.
+   The ``gpa`` field and ``size`` specify the guest physical address
+   (without the shared bit set) and the size of a shared-memory buffer, in
+   which the TDX guest passes a TD Report.  The ``ret`` field represents
+   the return value of the GetQuote request.  When the request has been
+   queued successfully, the TDX guest can poll the status field in the
+   shared-memory area to check whether the Quote generation is completed or
+   not. When completed, the generated Quote is returned via the same buffer.
+
+ * ``TDVMCALL_GET_TD_VM_CALL_INFO``: the guest has requested the support
+   status of TDVMCALLs.  The output values for the given leaf should be
+   placed in fields from ``r11`` to ``r14`` of the ``get_tdvmcall_info``
+   field of the union.
 
 KVM may add support for more values in the future that may cause a userspace
 exit, even without calls to ``KVM_ENABLE_CAP`` or similar.  In this case,

base-commit: 86731a2a651e58953fc949573895f2fa6d456841
-- 
2.46.0


