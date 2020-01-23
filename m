Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502221460E0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 04:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAWDMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 22:12:08 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9236 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbgAWDMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 22:12:08 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 38780C59AB2450DB0290;
        Thu, 23 Jan 2020 11:12:05 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 23 Jan 2020
 11:11:58 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: nVMX: set rflags to specify success in handle_invvpid() default case
Date:   Thu, 23 Jan 2020 11:14:01 +0800
Message-ID: <1579749241-712-1-git-send-email-linmiaohe@huawei.com>
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

In handle_invvpid() default case, we just skip emulated instruction and
forget to set rflags to specify success. This would result in indefinite
rflags value and thus indeterminate return value for guest.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
	Chinese New Year is coming. Happy Spring Festival! ^_^
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7608924ee8c1..985d3307ec56 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5165,7 +5165,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		return kvm_skip_emulated_instruction(vcpu);
+		break;
 	}
 
 	return nested_vmx_succeed(vcpu);
-- 
2.19.1

