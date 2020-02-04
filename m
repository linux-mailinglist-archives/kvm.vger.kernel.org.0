Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1718B151D56
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 16:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgBDPdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 10:33:01 -0500
Received: from mga05.intel.com ([192.55.52.43]:6851 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbgBDPdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 10:33:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 07:33:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="scan'208";a="249375173"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 04 Feb 2020 07:33:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Remove stale comment from nested_vmx_load_cr3()
Date:   Tue,  4 Feb 2020 07:32:59 -0800
Message-Id: <20200204153259.16318-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The blurb pertaining to the return value of nested_vmx_load_cr3() no
longer matches reality, remove it entirely as the behavior it is
attempting to document is quite obvious when reading the actual code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7608924ee8c1..0c9b847f7a25 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1076,8 +1076,6 @@ static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
 /*
  * Load guest's/host's cr3 at nested entry/exit. nested_ept is true if we are
  * emulating VM entry into a guest with EPT enabled.
- * Returns 0 on success, 1 on failure. Invalid state exit qualification code
- * is assigned to entry_failure_code on failure.
  */
 static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
 			       u32 *entry_failure_code)
-- 
2.24.1

