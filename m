Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98DA40370D
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 11:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347816AbhIHJi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 05:38:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:39069 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234842AbhIHJi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 05:38:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10100"; a="220466061"
X-IronPort-AV: E=Sophos;i="5.85,277,1624345200"; 
   d="scan'208";a="220466061"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 02:37:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,277,1624345200"; 
   d="scan'208";a="503493478"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.154])
  by fmsmga008.fm.intel.com with ESMTP; 08 Sep 2021 02:37:46 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: [PATCH] KVM: nVMX: fix comments of handle_vmon()
Date:   Thu,  9 Sep 2021 01:17:31 +0800
Message-Id: <20210908171731.18885-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"VMXON pointer" is saved in vmx->nested.vmxon_ptr since
commit 3573e22cfeca ("KVM: nVMX: additional checks on
vmxon region"). Also, handle_vmptrld() & handle_vmclear()
now have logic to check the VMCS pointer against the VMXON
pointer.

So just remove the obsolete comments of handle_vmon().

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..90f34f12f883 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4862,14 +4862,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	return -ENOMEM;
 }
 
-/*
- * Emulate the VMXON instruction.
- * Currently, we just remember that VMX is active, and do not save or even
- * inspect the argument to VMXON (the so-called "VMXON pointer") because we
- * do not currently need to store anything in that guest-allocated memory
- * region. Consequently, VMCLEAR and VMPTRLD also do not verify that the their
- * argument is different from the VMXON pointer (which the spec says they do).
- */
+/* Emulate the VMXON instruction. */
 static int handle_vmon(struct kvm_vcpu *vcpu)
 {
 	int ret;
-- 
2.17.1

