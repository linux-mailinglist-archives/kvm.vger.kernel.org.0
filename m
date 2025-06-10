Return-Path: <kvm+bounces-48768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4611AD2BDA
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 04:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E82D71890408
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 02:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFA0242D75;
	Tue, 10 Jun 2025 02:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iZKTQPGF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376B5241CB6;
	Tue, 10 Jun 2025 02:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521616; cv=none; b=jiXjr/wRv7vX+2BhXkhCbpHKTG33GD3KqGx5UpaX/rajHiw8KEcbgvg6FE4vCJtfRcIlGEqkV51p7+R2oujNfEYAMuq2n232asoeXsga9aJw/4V8wx4KV+svPdwY6YthwUW6+rgVACVp4SXzq676YKxwA0Pni7a9iaEVZYA1tyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521616; c=relaxed/simple;
	bh=JBhvf9pacAdWdDHVLo4yQfhQ98AEN7EsRSZJLl5dERU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvLQq0lw92hAyP4v/mpBfbNON1eb+dI8Jbw+LQIT3GL265jd13jlRv2/HMU/wBMdnxr9d9dsIwDqOJKQofrF3rW6WkoJw9eHgRbSkWfshvZ/A1ozTI8nUYfrRPwEB7tikbSgmf5WeVEQjIggh3BV1PnPg/bPpBvhde81zAY8k94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iZKTQPGF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749521614; x=1781057614;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JBhvf9pacAdWdDHVLo4yQfhQ98AEN7EsRSZJLl5dERU=;
  b=iZKTQPGFvu872WaD8kqh0ya/9YnXW8Mo/NPhgPvfCT09oiVPEHa5Rn5t
   ga/2QyLRJyzImp7WUJ8wXIX9+1iD94p+1ojZIfcmzs/n5Y/b0ZC6Gr95u
   PWxBM/00ZiIYfThv15uXLsE7yYW5/hPL4U1Jn9dbZ3ikE0X1/DGLHD48E
   jB/rgk0htvrZqge/RkyZt/CoHP5/FHQ6D24VlcwKSMJMxH6XVJhWfCf6Q
   i0MjIShcpCvmnAX4Zk458nHIA28VdUtOdP8Cfxwvz/jL8Et77KD6/oNLr
   gridxw6qxm4l6OeAwFrnn0xkZAXAcX8jqO1CJn8LSFqcPWTFLkea7Tq4k
   g==;
X-CSE-ConnectionGUID: H5FmMI4uQGqptHYQ+nOcng==
X-CSE-MsgGUID: 3asSDE3YRP67ckevvyQNkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="50841179"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="50841179"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:34 -0700
X-CSE-ConnectionGUID: GI01MJORQ1ejLb+7OMo2bw==
X-CSE-MsgGUID: B/DgHdgsT7yQFqdOuJf+1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147253724"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:13:31 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	mikko.ylinen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kirill.shutemov@intel.com,
	jiewen.yao@intel.com,
	binbin.wu@linux.intel.com
Subject: [RFC PATCH 1/4] KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
Date: Tue, 10 Jun 2025 10:14:19 +0800
Message-ID: <20250610021422.1214715-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the new TDVMCALL status code TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED and
return it for unimplemented TDVMCALL subfunctions.

Returning TDVMCALL_STATUS_INVALID_OPERAND when a subfunction is not
implemented is vague because TDX guests can't tell the error is due to
the subfunction is not supported or an invalid input of the subfunction.
New GHCI spec adds TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED to avoid the
ambiguity. Use it instead of TDVMCALL_STATUS_INVALID_OPERAND.

Before the change, for common guest implementations, when a TDX guest
receives TDVMCALL_STATUS_INVALID_OPERAND, it has two cases:
1. Some operand is invalid. It could change the operand to another value
   retry.
2. The subfunction is not supported.
For case 1, an invalid operand usually means the guest implementation bug.
Since the TDX guest can't tell which case is, the best practice for
handling TDVMCALL_STATUS_INVALID_OPERAND is stopping calling such leaf.
Treat it as fatal if the TDVMCALL is essential or ignore it if the TDVMCALL
is optional.

After the change, TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED is unknown to the
old TDX guest, the guest will make the same action as
TDVMCALL_STATUS_INVALID_OPERAND, unless the guest check the
TDVMCALL_STATUS_INVALID_OPERAND specifically.  Currently, no known
TDX guests do it, e.g., Linux TDX guests just check for success.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/include/asm/shared/tdx.h | 1 +
 arch/x86/kvm/vmx/tdx.c            | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index fd9209e996e7..b109b947fadf 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -79,6 +79,7 @@
 #define TDVMCALL_STATUS_RETRY		0x0000000000000001ULL
 #define TDVMCALL_STATUS_INVALID_OPERAND	0x8000000000000000ULL
 #define TDVMCALL_STATUS_ALIGN_ERROR	0x8000000000000002ULL
+#define TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED	0x8000000000000003ULL
 
 /*
  * Bitmasks of exposed registers (with VMM).
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..8134d5805b03 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1476,7 +1476,7 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED);
 	return 1;
 }
 
-- 
2.46.0


