Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2463711A47F
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 07:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfLKG1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 01:27:11 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727888AbfLKG0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 01:26:52 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6B89661E3BC9A0B102EE;
        Wed, 11 Dec 2019 14:26:50 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 11 Dec 2019
 14:26:39 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 2/6] KVM: Fix some out-dated function names in comment
Date:   Wed, 11 Dec 2019 14:26:21 +0800
Message-ID: <1576045585-8536-3-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576045585-8536-1-git-send-email-linmiaohe@huawei.com>
References: <1576045585-8536-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Since commit b1346ab2afbe ("KVM: nVMX: Rename prepare_vmcs02_*_full to
prepare_vmcs02_*_rare"), prepare_vmcs02_full has been renamed to
prepare_vmcs02_rare.
nested_vmx_merge_msr_bitmap is renamed to nested_vmx_prepare_msr_bitmap
since commit c992384bde84 ("KVM: vmx: speed up MSR bitmap merge").

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/vmcs_shadow_fields.h | 2 +-
 arch/x86/kvm/vmx/vmx.c                | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 5f3d95c18c39..cad128d1657b 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -23,7 +23,7 @@ BUILD_BUG_ON(1)
  *
  * When adding or removing fields here, note that shadowed
  * fields must always be synced by prepare_vmcs02, not just
- * prepare_vmcs02_full.
+ * prepare_vmcs02_rare.
  */
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 51e3b27f90ed..bf24fbb2056c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2016,7 +2016,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 *
 		 * For nested:
 		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_merge_msr_bitmap. We should not touch the
+		 * nested_vmx_prepare_msr_bitmap. We should not touch the
 		 * vmcs02.msr_bitmap here since it gets completely overwritten
 		 * in the merging. We update the vmcs01 here for L1 as well
 		 * since it will end up touching the MSR anyway now.
@@ -2052,7 +2052,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 *
 		 * For nested:
 		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_merge_msr_bitmap. We should not touch the
+		 * nested_vmx_prepare_msr_bitmap. We should not touch the
 		 * vmcs02.msr_bitmap here since it gets completely overwritten
 		 * in the merging.
 		 */
-- 
2.19.1

