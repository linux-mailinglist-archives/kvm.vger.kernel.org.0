Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A8430EDFB
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 09:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhBDIF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 03:05:26 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12419 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbhBDIFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 03:05:16 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DWWJc1DFVzjGlq;
        Thu,  4 Feb 2021 16:03:28 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 16:04:24 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>,
        <david@redhat.com>, <cohuck@redhat.com>, <imbrenda@linux.ibm.com>,
        <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] KVM: s390: Return the correct errno code
Date:   Thu, 4 Feb 2021 16:05:23 +0800
Message-ID: <20210204080523.18943-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When valloc failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 2f177298c663..6b7acc27cfa2 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2252,7 +2252,7 @@ static int get_all_floating_irqs(struct kvm *kvm, u8 __user *usrbuf, u64 len)
 	 */
 	buf = vzalloc(len);
 	if (!buf)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	max_irqs = len / sizeof(struct kvm_s390_irq);
 
-- 
2.22.0

