Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75238CD18
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 09:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfHNHmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 03:42:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4258 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbfHNHmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 03:42:17 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8F7B1411C80551F4DD67;
        Wed, 14 Aug 2019 15:42:14 +0800 (CST)
Received: from huawei.com (10.175.104.217) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Wed, 14 Aug 2019
 15:42:04 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <joro@8bytes.org>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <linmiaohe@huawei.com>, <mingfangsen@huawei.com>
Subject: [PATCH] KVM : remove redundant assignment of var new_entry
Date:   Mon, 12 Aug 2019 10:33:00 +0800
Message-ID: <20190812023300.20153-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.21.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.217]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

new_entry is reassigned a new value next line. So
it's redundant and remove it.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d685491fce4d..e3d3b2128f2b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1714,7 +1714,6 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	if (!entry)
 		return -EINVAL;
 
-	new_entry = READ_ONCE(*entry);
 	new_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
 			      AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
 			      AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
-- 
2.21.GIT

