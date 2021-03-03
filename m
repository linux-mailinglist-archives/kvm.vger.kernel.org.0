Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBF232B5C9
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449385AbhCCHUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:20:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:64029 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1450806AbhCCFwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 00:52:55 -0500
IronPort-SDR: xw+0gtmw6emeXrX5MRE2sCZTw/IrVgH5wSvMEBbeAqdI4dXUF0HhZYYEuMUtlmg759UH+1eQed
 cygSnMUkQKjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="187168416"
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="187168416"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 21:52:13 -0800
IronPort-SDR: PPCaIJ1yCXU3MQyLWu37t4XQhskMV0FHuE68tL3dJg7WneBmpaJ+EiW2Zcdl0Nbp9Qat9tskR3
 wTSfznF+aUhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="399515380"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2021 21:52:11 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH] KVM: nVMX: Add CET entry/exit load bits to evmcs unsupported list
Date:   Wed,  3 Mar 2021 14:04:34 +0800
Message-Id: <20210303060435.8158-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET in nested guest over Hyper-V is not supported for now. Relevant
enabling patches will be posted as a separate patch series.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/evmcs.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index bd41d9462355..25588694eb04 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -59,8 +59,10 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
 	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
-#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
-#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
+#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | \
+					VM_EXIT_LOAD_CET_STATE)
+#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | \
+					 VM_ENTRY_LOAD_CET_STATE)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
 #if IS_ENABLED(CONFIG_HYPERV)
-- 
2.26.2

