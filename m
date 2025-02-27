Return-Path: <kvm+bounces-39457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C92A470F5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6525A18892A0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248731CDA2E;
	Thu, 27 Feb 2025 01:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bgjTqVw7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF721C5D63;
	Thu, 27 Feb 2025 01:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619193; cv=none; b=WocB+RczTTRJYvYCF+EcBqSqqZUiziY606nkp1o5HDv6Ruy1Ld9M2TbFGPEqZ3XiMI6MD4HB4voNkWEc1LQncUPEE8gq/7mI2SRtH5BJl0G44fmyTEx0jXJ66jOQ7QCjBTC1+G87OEREEHcSC4X4I/rYW2tf9+9R/oQTo6TGUgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619193; c=relaxed/simple;
	bh=69h9BawlmRPy4kcfbZCH7uVMvPfzAdDJo52SPxWa6Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sw5bZAKU4AaKrYmJrI2/oXq0bzcqiXj8CAY6K+S3YdD5ZqSxRwBxx/lPv6Lofi+4JJCNv/5WUmRfSrYpXPRhlmYZW5wtEzRU+RICl0jNYzxCk9h5lIcinS67SiOb64LwBCchgnvAMebUun4hPzZso2ucqq0FA61oc6QJU92uiME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bgjTqVw7; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619192; x=1772155192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=69h9BawlmRPy4kcfbZCH7uVMvPfzAdDJo52SPxWa6Ec=;
  b=bgjTqVw78XbR0DMZ8y4/j++w/3+143IsqNqcaGPNrp0NEEsbDU+k8fuK
   irXJ9YN7cEciD6vt9VkjaMqmqjt585n18PrtgzbMYMqZQn6GDYGxL4/7j
   lbICneFvtRwJzEbbVxe/vgN2Vg/wBkjcmceMP4OP3HsvMo7Qoo4LyT38R
   J5wdq0MN2FpWQAJUsaj7ESJ6KUBfTdzedAwi52RC93tLaE7gRZJRnlhsy
   zN2VT1gNaz/fEei8hfeUzJwGHdLALaQppAtp7lcN5ebxQYmhWBiW2IR8P
   3L4au1+uQh/DfzKvH94H2bNpeP/+9QTGDBewFasiDDZuSHqoIhFodfOEu
   g==;
X-CSE-ConnectionGUID: WI5UhokuQuGWvW26BQR9+g==
X-CSE-MsgGUID: KUCUUu0NQZytttnV0B34jw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959705"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959705"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:52 -0800
X-CSE-ConnectionGUID: sqt1etO+R8WB9MUAhgAXIQ==
X-CSE-MsgGUID: oGhUGVg4RGuyI61XIhJlrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674941"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:48 -0800
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
Subject: [PATCH v2 19/20] KVM: TDX: Make TDX VM type supported
Date: Thu, 27 Feb 2025 09:20:20 +0800
Message-ID: <20250227012021.1778144-20-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Now all the necessary code for TDX is in place, it's ready to run TDX
guest.  Advertise the VM type of KVM_X86_TDX_VM so that the user space
VMM like QEMU can start to use it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- No change.

TDX "the rest" v1:
- Move down to the end of patch series.
---
 arch/x86/kvm/vmx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index fa8b5f609666..320c96e1e80a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1092,6 +1092,7 @@ static int __init vt_init(void)
 		vcpu_align = max_t(unsigned, vcpu_align,
 				__alignof__(struct vcpu_tdx));
 		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
+		kvm_caps.supported_vm_types |= BIT(KVM_X86_TDX_VM);
 	}
 
 	/*
-- 
2.46.0


