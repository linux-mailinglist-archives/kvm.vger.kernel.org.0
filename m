Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5B0104BB4
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 08:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKUHQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 02:16:05 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:53750 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbfKUHQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 02:16:04 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AAC8DC4C53B3229B3B3C;
        Thu, 21 Nov 2019 15:16:01 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Thu, 21 Nov 2019
 15:15:52 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <maz@kernel.org>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>
CC:     <linmiaohe@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH] KVM: arm: get rid of unused arg in cpu_init_hyp_mode()
Date:   Thu, 21 Nov 2019 15:15:59 +0800
Message-ID: <1574320559-5662-1-git-send-email-linmiaohe@huawei.com>
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

As arg dummy is not really needed, there's no need to pass
NULL when calling cpu_init_hyp_mode(). So clean it up.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 virt/kvm/arm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86c6aa1cb58e..a5470f1b1a19 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1315,7 +1315,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 }
 
-static void cpu_init_hyp_mode(void *dummy)
+static void cpu_init_hyp_mode(void)
 {
 	phys_addr_t pgd_ptr;
 	unsigned long hyp_stack_ptr;
@@ -1349,7 +1349,7 @@ static void cpu_hyp_reinit(void)
 	if (is_kernel_in_hyp_mode())
 		kvm_timer_init_vhe();
 	else
-		cpu_init_hyp_mode(NULL);
+		cpu_init_hyp_mode();
 
 	kvm_arm_init_debug();
 
-- 
2.19.1

