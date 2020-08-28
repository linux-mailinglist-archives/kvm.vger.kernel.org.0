Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298452556F1
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 10:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgH1Iyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 04:54:40 -0400
Received: from mga17.intel.com ([192.55.52.151]:49199 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728787AbgH1IyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 04:54:25 -0400
IronPort-SDR: 1PTEW7zs7UUUOl75dQNDb6TMfeayM+uIvG/+0q4UH2HYtqVJR/wXxRwHn+N7pI3qomXidkdyHL
 phHtLWokc6jQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="136697532"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="136697532"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:54:25 -0700
IronPort-SDR: ItBcVC3F3UmqJ9rRUzFVilhximdi3EqypJMhen2WXzA8b31ihEc4d02uCp6hxyGiuG89DMux+d
 fs1mrO0W7HEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="332483519"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2020 01:54:23 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] KVM: nVMX: Fix the update value of nested load IA32_PERF_GLOBAL_CTRL control
Date:   Fri, 28 Aug 2020 16:56:21 +0800
Message-Id: <20200828085622.8365-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200828085622.8365-1-chenyi.qiang@intel.com>
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A minor fix for the update of VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL field
in exit_ctls_high.

Fixes: 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
VM-{Entry,Exit} control")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 47bee53e235a..7d15765dfe17 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4699,7 +4699,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 		vmx->nested.msrs.entry_ctls_high &=
 				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 		vmx->nested.msrs.exit_ctls_high &=
-				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+				~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
 	}
 }
 
-- 
2.17.1

