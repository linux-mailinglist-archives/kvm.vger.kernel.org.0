Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E074172B43
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 23:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgB0Waw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 17:30:52 -0500
Received: from mga04.intel.com ([192.55.52.120]:35152 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730279AbgB0Waw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 17:30:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 14:30:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="385312255"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 27 Feb 2020 14:30:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: VMX: Make loaded_vmcs_init() a static function
Date:   Thu, 27 Feb 2020 14:30:47 -0800
Message-Id: <20200227223047.13125-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227223047.13125-1-sean.j.christopherson@intel.com>
References: <20200227223047.13125-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make loaded_vmcs_init() static as it's only used in vmx.c.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 arch/x86/kvm/vmx/vmx.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a5109804abee..1aeb3359c4d1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -654,7 +654,7 @@ static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr,
 	return ret;
 }
 
-void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use)
+static void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use)
 {
 	vmcs_clear(loaded_vmcs->vmcs);
 	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a0a93b2a238e..8df23af2cb58 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -493,7 +493,6 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
 void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
-void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs, bool in_use);
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 
 static inline struct vmcs *alloc_vmcs(bool shadow)
-- 
2.24.1

