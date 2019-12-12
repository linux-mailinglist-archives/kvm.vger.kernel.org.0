Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B601211C821
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 09:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfLLITU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 03:19:20 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7224 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728267AbfLLITT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 03:19:19 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 15CED9057459FCEC7938;
        Thu, 12 Dec 2019 16:19:17 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Dec 2019
 16:19:07 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2 4/4] KVM: hyperv: Fix some typos in vcpu unimpl info
Date:   Thu, 12 Dec 2019 16:18:38 +0800
Message-ID: <1576138718-32728-5-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576138718-32728-1-git-send-email-linmiaohe@huawei.com>
References: <1576138718-32728-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Fix some typos in vcpu unimpl info and a writing error in the comment.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/hyperv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index c7d4640b7b1c..b255b9e865e5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1059,7 +1059,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 			return 1;
 		break;
 	default:
-		vcpu_unimpl(vcpu, "Hyper-V uhandled wrmsr: 0x%x data 0x%llx\n",
+		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
 			    msr, data);
 		return 1;
 	}
@@ -1122,7 +1122,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 			return 1;
 
 		/*
-		 * Clear apic_assist portion of f(struct hv_vp_assist_page
+		 * Clear apic_assist portion of struct hv_vp_assist_page
 		 * only, there can be valuable data in the rest which needs
 		 * to be preserved e.g. on migration.
 		 */
@@ -1179,7 +1179,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 			return 1;
 		break;
 	default:
-		vcpu_unimpl(vcpu, "Hyper-V uhandled wrmsr: 0x%x data 0x%llx\n",
+		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
 			    msr, data);
 		return 1;
 	}
-- 
2.19.1

