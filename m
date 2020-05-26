Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE5B1AEA9A
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 09:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgDRHxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 03:53:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35880 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbgDRHxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 03:53:13 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 68869CE304963797192C;
        Sat, 18 Apr 2020 15:53:10 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 15:53:00 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>,
        <david@redhat.com>, <cohuck@redhat.com>,
        <heiko.carstens@de.ibm.com>, <gor@linux.ibm.com>,
        <Ulrich.Weigand@de.ibm.com>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] KVM: s390: remove unneeded semicolon in gisa_vcpu_kicker()
Date:   Sat, 18 Apr 2020 16:19:26 +0800
Message-ID: <20200418081926.41666-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following coccicheck warning:

arch/s390/kvm/interrupt.c:3085:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 8191106bf7b9..559177123d0f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3082,7 +3082,7 @@ static enum hrtimer_restart gisa_vcpu_kicker(struct hrtimer *timer)
 		__airqs_kick_single_vcpu(kvm, pending_mask);
 		hrtimer_forward_now(timer, ns_to_ktime(gi->expires));
 		return HRTIMER_RESTART;
-	};
+	}
 
 	return HRTIMER_NORESTART;
 }
-- 
2.21.1

