Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AFD14609E
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 03:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgAWCGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 21:06:30 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10131 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbgAWCGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 21:06:30 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1B545BF418CF57AB050E;
        Thu, 23 Jan 2020 10:06:28 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 23 Jan 2020
 10:06:17 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: nVMX: delete meaningless nested_vmx_run() declaration
Date:   Thu, 23 Jan 2020 10:08:20 +0800
Message-ID: <1579745300-13029-1-git-send-email-linmiaohe@huawei.com>
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

The function nested_vmx_run() declaration is below its implementation. So
this is meaningless and should be removed.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/nested.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 95b3f4306ac2..7608924ee8c1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4723,8 +4723,6 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	return nested_vmx_succeed(vcpu);
 }
 
-static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch);
-
 /* Emulate the VMLAUNCH instruction */
 static int handle_vmlaunch(struct kvm_vcpu *vcpu)
 {
-- 
2.19.1

