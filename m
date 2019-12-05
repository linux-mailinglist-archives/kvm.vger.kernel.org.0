Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADBC113A31
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 04:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbfLEDF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 22:05:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6754 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728132AbfLEDF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 22:05:26 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 873A727D263DBA667E76;
        Thu,  5 Dec 2019 11:05:24 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Dec 2019
 11:05:09 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: get rid of var page in kvm_set_pfn_dirty()
Date:   Thu, 5 Dec 2019 11:05:05 +0800
Message-ID: <1575515105-19426-1-git-send-email-linmiaohe@huawei.com>
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

We can get rid of unnecessary var page in
kvm_set_pfn_dirty() , thus make code style
similar with kvm_set_pfn_accessed().
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 virt/kvm/kvm_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 00268290dcbd..3aa21bec028d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1931,11 +1931,8 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
 
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
-		struct page *page = pfn_to_page(pfn);
-
-		SetPageDirty(page);
-	}
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+		SetPageDirty(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
-- 
2.19.1

