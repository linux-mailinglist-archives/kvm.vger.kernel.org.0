Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A92F275FDF
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgIWSba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:31:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:62459 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgIWSba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:31:30 -0400
IronPort-SDR: iZrxXMApBgqFbuvWmDVKZiqMPDFAnlh5+a7+jpV1JrchYcSYnx3tNRzkePZyi3LxSmqvBFahIp
 z6LLh8Orw6lw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="179071090"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="179071090"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:31:14 -0700
IronPort-SDR: FwN5aNVGE1jN+tKOofPqtaoXgNPIoheYhQdfLjM9Mkoqc6ZsZ5SzC3Lgb+JHu404GRGskn9X7F
 vpvKB74ffcJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="413082168"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2020 11:31:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 2/2] KVM: VMX: Rename ops.h to vmx_ops.h
Date:   Wed, 23 Sep 2020 11:31:12 -0700
Message-Id: <20200923183112.3030-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923183112.3030-1-sean.j.christopherson@intel.com>
References: <20200923183112.3030-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename ops.h to vmx_ops.h to allow adding a tdx_ops.h in the future
without causing massive confusion.

Trust Domain Extensions (TDX) is built on VMX, but KVM cannot directly
access the VMCS(es) for a TDX guest, thus TDX will need its own "ops"
implementation for wrapping the low level operations.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c                | 1 -
 arch/x86/kvm/vmx/vmx.h                | 2 +-
 arch/x86/kvm/vmx/{ops.h => vmx_ops.h} | 0
 3 files changed, 1 insertion(+), 2 deletions(-)
 rename arch/x86/kvm/vmx/{ops.h => vmx_ops.h} (100%)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d5bd5bd7165..8416b7a27f3f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -56,7 +56,6 @@
 #include "lapic.h"
 #include "mmu.h"
 #include "nested.h"
-#include "ops.h"
 #include "pmu.h"
 #include "trace.h"
 #include "vmcs.h"
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ab7d5e000a91..4769a086ad50 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -9,9 +9,9 @@
 
 #include "capabilities.h"
 #include "kvm_cache_regs.h"
-#include "ops.h"
 #include "posted_intr.h"
 #include "vmcs.h"
+#include "vmx_ops.h"
 #include "cpuid.h"
 
 extern const u32 vmx_msr_index[];
diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/vmx_ops.h
similarity index 100%
rename from arch/x86/kvm/vmx/ops.h
rename to arch/x86/kvm/vmx/vmx_ops.h
-- 
2.28.0

