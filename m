Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F2F1644A7
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 13:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbgBSMvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 07:51:04 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10644 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727103AbgBSMvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 07:51:04 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id ABEEFDECA7019B363D4E;
        Wed, 19 Feb 2020 20:51:00 +0800 (CST)
Received: from host-suse12sp4.huawei.com (10.67.133.175) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 19 Feb 2020 20:50:51 +0800
From:   Yan Zhu <zhuyan34@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liucheng32@huawei.com>
Subject: [PATCH] KVM: x86: fix mmu_set_spte coding style warning
Date:   Wed, 19 Feb 2020 20:50:51 +0800
Message-ID: <20200219125051.49529-1-zhuyan34@huawei.com>
X-Mailer: git-send-email 2.12.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.133.175]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

checkpatch.pl warns:

ERROR: code indent should use tabs where possible
+^I^I       ^Ibool speculative, bool host_writable)$

WARNING: please, no space before tabs
+^I^I       ^Ibool speculative, bool host_writable)$

This warning occurs because there is a space before the tab on this line.
Remove them so that the indentation is consistent with the Linux kernel
coding style

Fixes: 61524f1bccc0 ("KVM: x86: extend usage of RET_MMIO_PF_* constants")
Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
---
 arch/x86/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3a281a2decde..0d403f41afc5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2682,7 +2682,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
 			int write_fault, int level, gfn_t gfn, kvm_pfn_t pfn,
-		       	bool speculative, bool host_writable)
+			bool speculative, bool host_writable)
 {
 	int was_rmapped = 0;
 	int rmap_count;
-- 
2.12.3

