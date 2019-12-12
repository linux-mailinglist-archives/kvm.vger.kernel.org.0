Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A173011C823
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 09:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfLLITU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 03:19:20 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7223 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728266AbfLLITS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 03:19:18 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0DD7949115BDF9A61BEA;
        Thu, 12 Dec 2019 16:19:17 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Dec 2019
 16:19:05 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2 3/4] KVM: Fix some writing mistakes and wrong function name in comments
Date:   Thu, 12 Dec 2019 16:18:37 +0800
Message-ID: <1576138718-32728-4-git-send-email-linmiaohe@huawei.com>
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

Fix some writing mistakes in the comments. And mmu_check_roots is a typo
for mmu_check_root.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3aa21bec028d..94ec01af708b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -964,7 +964,7 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 
 	/*
 	 * Increment the new memslot generation a second time, dropping the
-	 * update in-progress flag and incrementing then generation based on
+	 * update in-progress flag and incrementing the generation based on
 	 * the number of address spaces.  This provides a unique and easily
 	 * identifiable generation number while the memslots are in flux.
 	 */
@@ -1117,7 +1117,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		 *
 		 * validation of sp->gfn happens in:
 		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
-		 *	- kvm_is_visible_gfn (mmu_check_roots)
+		 *	- kvm_is_visible_gfn (mmu_check_root)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
 
@@ -1519,7 +1519,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
- * only part that runs if we can are in atomic context.
+ * only part that runs if we are in atomic context.
  */
 static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 			    bool *writable, kvm_pfn_t *pfn)
-- 
2.19.1

