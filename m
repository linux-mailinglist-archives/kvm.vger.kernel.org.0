Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA5431605F
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 08:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhBJHw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 02:52:27 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13339 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbhBJHwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 02:52:16 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DbBkW48WWz7jF4;
        Wed, 10 Feb 2021 15:50:11 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:51:25 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Bandan Das <bsd@redhat.com>, Wei Huang <wei.huang2@amd.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
Subject: [PATCH -next] KVM: SVM: Make symbol 'svm_gp_erratum_intercept' static
Date:   Wed, 10 Feb 2021 07:59:58 +0000
Message-ID: <20210210075958.1096317-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sparse tool complains as follows:

arch/x86/kvm/svm/svm.c:204:6: warning:
 symbol 'svm_gp_erratum_intercept' was not declared. Should it be static?

This symbol is not used outside of svm.c, so this
commit marks it static.

Fixes: 82a11e9c6fa2b ("KVM: SVM: Add emulation support for #GP triggered by SVM instructions")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4141caea857a..4a41d11aabfe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -201,7 +201,7 @@ module_param(sev_es, int, 0444);
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
-bool svm_gp_erratum_intercept = true;
+static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 

