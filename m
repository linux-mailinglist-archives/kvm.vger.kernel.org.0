Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9888136E436
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 06:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbhD2EXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 00:23:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:60569 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236230AbhD2EXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 00:23:47 -0400
IronPort-SDR: 2ri/VPHsvYU4K5Ad8I+t5APa4qaPRtlIeJLuy9B4T/Bjqm/4qkUNORLfVQmjpYXiw/08PC+f0g
 45RbrPhjOqmA==
X-IronPort-AV: E=McAfee;i="6200,9189,9968"; a="217643620"
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="217643620"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 21:22:53 -0700
IronPort-SDR: +46sYziGc1P2unbdLWaf+MGFGQ/RtbJflfMG9BETMwPbjQSQ4cUCxb+G1kmzVJyNMe1QmW3rmm
 N2wl/hJydfHQ==
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="393732622"
Received: from savora-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.50.252])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 21:22:52 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM: VMX: Fix a typo in comment around handle_vmx_instruction()
Date:   Thu, 29 Apr 2021 16:22:37 +1200
Message-Id: <20210429042237.51280-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is nested_vmx_hardware_setup() which overwrites VMX instruction VM
exits handlers, but not nested_vmx_setup().  Fix the typo in comment.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 10b610fc7bbc..f8661bc113ed 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5618,7 +5618,7 @@ static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 
 /*
  * When nested=0, all VMX instruction VM Exits filter here.  The handlers
- * are overwritten by nested_vmx_setup() when nested=1.
+ * are overwritten by nested_vmx_hardware_setup() when nested=1.
  */
 static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
 {
-- 
2.30.2

