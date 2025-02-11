Return-Path: <kvm+bounces-37785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC282A301C2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75E94168F1B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D89F1E570E;
	Tue, 11 Feb 2025 02:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LclGEA6c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC63C1E412A;
	Tue, 11 Feb 2025 02:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242412; cv=none; b=I3/ipOfkAQNgoA6d1g5R1rEcNSQgMqYINrUCwAxShsx0VZFLoHCpZLufjVXFzM9jKOzCHiA3ZJO6gqn13nuTGGzTc5XEQeffbMgED2/+WL4w4hkuCUth3ac8HX7unJF3sqc+enD+WHKb/A6cvYAP4yy+d/gEo9HGaJ11cVlqCLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242412; c=relaxed/simple;
	bh=z/5Bed58RE9KjC8zRoI9EixAQOU33U2F+6O/XNNHdTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7jlkJtga3RT1dBkGjd81c6DlQLHRhLGhyPWp5siw2dIvVa2qwnzTFIycVJcajTgA/9pMgb313nx0HGtyHgNfxgdnIo6fzJbsUg270hm0WzZKs1fEX3+2LhsLlEYUgGaxtPb2y1mLPWp3GCrAgH0Qnr0OyayIoBNDGmuDn8G4fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LclGEA6c; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242412; x=1770778412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z/5Bed58RE9KjC8zRoI9EixAQOU33U2F+6O/XNNHdTo=;
  b=LclGEA6cpWNZHDoD14UkdtkH5u9rbLwDBycYNDCpHoh9QQUNFZoPq+w4
   9oBQSbyMpZdEiRsMKHBY0QLqpdYtdqgYGih6/pi+CMEFjoofi+yY3m8d+
   rFpxX4dRlIt282tJHvjhYEp8sYj/6g5QibgXF+3Lx0AsxXoiSu0ZPxy9M
   DH0HD5+qPZzCSJSlcVVh1NDJvi8OQILI97ds48fwDRv4N/3/RmGflR9vD
   MyEeySUgYYhw9zFans/EU6qJ9EksVP/2T3YI8HQQQt/U8dpNzRuCqG6S4
   L4k879KPADFfIL1ER6h01WWXZcGf4Xb+vzndRnKEuScTgi0YmbRa/SZms
   g==;
X-CSE-ConnectionGUID: zSFkclmfSsyy2kzeKokzFw==
X-CSE-MsgGUID: U5XBPrcZSx+OpnXmveCGBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43506629"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43506629"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:31 -0800
X-CSE-ConnectionGUID: NZ+142KPQcKnn5+W8TMeiw==
X-CSE-MsgGUID: LK/1cOQRTxGmbsU8QOSYJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112236466"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:27 -0800
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
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 7/8] KVM: TDX: Handle TDX PV port I/O hypercall
Date: Tue, 11 Feb 2025 10:54:41 +0800
Message-ID: <20250211025442.3071607-8-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Emulate port I/O requested by TDX guest via TDVMCALL with leaf
Instruction.IO (same value as EXIT_REASON_IO_INSTRUCTION) according to
TDX Guest Host Communication Interface (GHCI).

All port I/O instructions inside the TDX guest trigger the #VE exception.
On #VE triggered by I/O instructions, TDX guest can call TDVMCALL with
leaf Instruction.IO to request VMM to emulate I/O instructions.

Similar to normal port I/O emulation, try to handle the port I/O in kernel
first, if kernel can't support it, forward the request to userspace.

Note string I/O operations are not supported in TDX.  Guest should unroll
them before calling the TDVMCALL.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
Hypercalls exit to userspace v2:
- Morph PV port I/O hypercall to EXIT_REASON_IO_INSTRUCTION. (Sean)
- Use vp_enter_args instead of x86 registers.
- Check write is either 0 or 1. (Chao)
- Skip setting return code as TDVMCALL_STATUS_SUCCESS. (Sean)

Hypercalls exit to userspace v1:
- Renamed from "KVM: TDX: Handle TDX PV port io hypercall" to
  "KVM: TDX: Handle TDX PV port I/O hypercall".
- Update changelog.
- Add missing curly brackets.
- Move reset of pio.count to tdx_complete_pio_out() and remove the stale
  comment. (binbin)
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
- Set status code to TDVMCALL_STATUS_SUCCESS when PIO is handled in kernel.
- Don't write to R11 when it is a write operation for output.

v18:
- Fix out case to set R10 and R11 correctly when user space handled port
  out.
---
 arch/x86/kvm/vmx/tdx.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 85956768c515..f13da28dd4a2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1135,6 +1135,64 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.pio.count = 0;
+	return 1;
+}
+
+static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	int ret;
+
+	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
+					 vcpu->arch.pio.port, &val, 1);
+
+	WARN_ON_ONCE(!ret);
+
+	tdvmcall_set_return_val(vcpu, val);
+
+	return 1;
+}
+
+static int tdx_emulate_io(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	unsigned int port;
+	u64 size, write;
+	int ret;
+
+	++vcpu->stat.io_exits;
+
+	size = tdx->vp_enter_args.r12;
+	write = tdx->vp_enter_args.r13;
+	port = tdx->vp_enter_args.r14;
+
+	if ((write != 0 && write != 1) || (size != 1 && size != 2 && size != 4)) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
+	}
+
+	if (write) {
+		val = tdx->vp_enter_args.r15;
+		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
+	} else {
+		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
+	}
+
+	if (!ret)
+		vcpu->arch.complete_userspace_io = write ? tdx_complete_pio_out :
+							   tdx_complete_pio_in;
+	else if (!write)
+		tdvmcall_set_return_val(vcpu, val);
+
+	return ret;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
@@ -1486,6 +1544,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return handle_tdvmcall(vcpu);
 	case EXIT_REASON_VMCALL:
 		return tdx_emulate_vmcall(vcpu);
+	case EXIT_REASON_IO_INSTRUCTION:
+		return tdx_emulate_io(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0


