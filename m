Return-Path: <kvm+bounces-31571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE509C4FA8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4A231F27307
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483FC20DD61;
	Tue, 12 Nov 2024 07:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aFuTflUe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0988820C03B;
	Tue, 12 Nov 2024 07:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397126; cv=none; b=UuK1fQdsilOwWpaT386qyYkh43UGfhTKY81PFOQ0mxmpb1Vbo2918okTYi7zKfSi39jmvqoiAsPF58F+o5Oi4dzx766J68YeGHknUDjuSmX0BeMjPaYwBxulBJUmN4emp9nWiaxkxvsvLkOiYiDsgi1Xeip6Q46KELACcdOQaXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397126; c=relaxed/simple;
	bh=hpL8qRg9b5uNCj3fBmLnd4DdrGDSB5YFOl7ygYxVAmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCGTZ9/9GTbT8kO2kI9FZaL2Z/nvu83Ec5F374MGv+emDLxhwUlSyy9sQ7s38wuzVO9bPnsUnSPHcEbVMC+uPaTRAoB7UsmzrJUt+AOL3fOlYLwSKMvHgZ4FXuTfFQmYGN2E8rleDSrdiD2mj2u0J8lrw79buZiEfCbXen9sEyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aFuTflUe; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397125; x=1762933125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hpL8qRg9b5uNCj3fBmLnd4DdrGDSB5YFOl7ygYxVAmQ=;
  b=aFuTflUeEQpgyHYt3BOHsAtCROEmMANLkTxhA7kj2sYbhYz4inqOdSlX
   XqJEzHGL6ac0rjmOlHYHDM7ddt0xh+rDwjZqBnIptOCtnG36mk5IZLX13
   kV8WhPRgYKyS+R0BsffdLa0RsNh6nFpFVNgilsNt5JBLGXXutHTD/p7W4
   TnSKMzRfsGpL6DgvdMdvVWCQ/cLv15LGQqzYCRpp0w8MUyE+5GDCpW6Hn
   JuvATrFw+EFOAsdRLJnw5OxswxvWqOy/tUoz2DFgQXVkIE2/a12E/5UeW
   DOKdORXdo3qB9MhCTOwp/e2W0OIkGzMaY54qMHdY4DXzK0NBmmJxoPVMI
   g==;
X-CSE-ConnectionGUID: c2nd6TvbQa+/sTwlC07bTQ==
X-CSE-MsgGUID: 8/KQMbcfS0mPI9dea2mgug==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31389345"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31389345"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:44 -0800
X-CSE-ConnectionGUID: 4cd0IoREQ7KLeIrtfNa9jA==
X-CSE-MsgGUID: 1JFz42ZjS4OSeolUaLGb8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87736272"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:40 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 08/24] KVM: TDX: Set gfn_direct_bits to shared bit
Date: Tue, 12 Nov 2024 15:36:13 +0800
Message-ID: <20241112073613.22100-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
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
the shared bit set. These shared mappings will be mapped on the KVM MMU's
"direct" root. The direct root has it's mappings shifted by applying
"gfn_direct_bits" as a mask. The concept of "GPAW" (guest physical address
width) determines the location of the shared bit. So set gfn_direct_bits
based on this, to map shared memory at the proper GPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX MMU part 2 v2:
 - Added Paolo's rb
 - Use TDX 1.5 naming of config_flags instead of exec_controls (Xiaoyao)
 - Use macro TDX_SHARED_BITS_PWL_5 and TDX_SHARED_BITS_PWL_4 for
   gfn_direct_bits. (Yan)

TDX MMU part 2 v1:
 - Move setting of gfn_direct_bits to separate patch (Yan)
---
 arch/x86/kvm/vmx/tdx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 785ee9f95504..38369cafc175 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1041,6 +1041,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	kvm_tdx->attributes = td_params->attributes;
 	kvm_tdx->xfam = td_params->xfam;
 
+	if (td_params->config_flags & TDX_CONFIG_FLAGS_MAX_GPAW)
+		kvm->arch.gfn_direct_bits = TDX_SHARED_BIT_PWL_5;
+	else
+		kvm->arch.gfn_direct_bits = TDX_SHARED_BIT_PWL_4;
+
 	kvm_tdx->state = TD_STATE_INITIALIZED;
 out:
 	/* kfree() accepts NULL. */
-- 
2.43.2


