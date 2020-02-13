Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B278315B74E
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 03:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgBMCv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 21:51:58 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10614 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729333AbgBMCv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 21:51:58 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 268BC99038DBD4A45735;
        Thu, 13 Feb 2020 10:51:54 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Feb 2020
 10:51:45 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: x86: eliminate some unreachable code
Date:   Thu, 13 Feb 2020 10:53:25 +0800
Message-ID: <1581562405-30321-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

These code are unreachable, remove them.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 -
 arch/x86/kvm/x86.c     | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bb5c33440af8..b6d4eafe01cf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4505,7 +4505,6 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
 	case GP_VECTOR:
 	case MF_VECTOR:
 		return true;
-	break;
 	}
 	return false;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbabb2f06273..a597009aefd7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3081,7 +3081,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
 		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
-		break;
 	case MSR_IA32_TSCDEADLINE:
 		msr_info->data = kvm_get_lapic_tscdeadline_msr(vcpu);
 		break;
@@ -3164,7 +3163,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return kvm_hv_get_msr_common(vcpu,
 					     msr_info->index, &msr_info->data,
 					     msr_info->host_initiated);
-		break;
 	case MSR_IA32_BBL_CR_CTL3:
 		/* This legacy MSR exists but isn't fully documented in current
 		 * silicon.  It is however accessed by winxp in very narrow
@@ -8471,7 +8469,6 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 		break;
 	default:
 		return -EINTR;
-		break;
 	}
 	return 1;
 }
-- 
2.19.1

