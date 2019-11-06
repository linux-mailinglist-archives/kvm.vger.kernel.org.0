Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7315F1581
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 12:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbfKFL4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 06:56:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40192 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfKFL4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 06:56:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Bs8Ph049980;
        Wed, 6 Nov 2019 11:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=EPKzfVRRWTGlG40d7rhnldMOWGwhBLJaJGkHe+80yiw=;
 b=moDcX+2wcqRmyIvB8FKPWFflJ+KDihvj4whWqFyfE71UiGmuXEcGhGKPKz9FEVAUbH5x
 B8NYPal0fGdPgvfDBKNL4KoNIBWB8AEtJMFNz42PELtAui17slpTuYsQf8+n4KNDxUkJ
 Zom61tgP25VcZthq73P1v19qA5b1galtl0XPq1zc73QravPV9ZTtnkTE5Ghd+V0JLCv4
 vWf/9DK4tmPXPo35oLEfxdYPttPAW5yszxDrkHAIeY2uddzROD/Qb/+KFIDMP5XTisKo
 Itv9SGVp5JZ6a+oOi9sOiR+nNKxmSFlY5KfLLj7Llty49P8C2qEvmyy0zX7I2pVDd4Y/ Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rq5m5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 11:55:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6BsLeu051863;
        Wed, 6 Nov 2019 11:55:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w31639sgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 11:55:42 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6BtffF022120;
        Wed, 6 Nov 2019 11:55:41 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 03:55:41 -0800
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        rafael.j.wysocki@intel.com, joao.m.martins@oracle.com,
        mtosatti@redhat.com, kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH RESEND v2 1/4] cpuidle-haltpoll: ensure grow start value is nonzero
Date:   Wed,  6 Nov 2019 19:54:59 +0800
Message-Id: <1573041302-4904-2-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=808
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=886 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

dev->poll_limit_ns could be zeroed in certain cases (e.g. by
guest_halt_poll_ns = 0). If guest_halt_poll_grow_start is zero,
dev->poll_limit_ns will never be bigger than zero.

Use param callback to avoid writing zero to guest_halt_poll_grow_start.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 drivers/cpuidle/governors/haltpoll.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 7a703d2..660859d 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -20,6 +20,26 @@
 #include <linux/module.h>
 #include <linux/kvm_para.h>
 
+static int grow_start_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	unsigned int n;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtouint(val, 0, &n);
+	if (ret || !n)
+		return -EINVAL;
+
+	return param_set_uint(val, kp);
+}
+
+static const struct kernel_param_ops grow_start_ops = {
+	.set = grow_start_set,
+	.get = param_get_uint,
+};
+
 static unsigned int guest_halt_poll_ns __read_mostly = 200000;
 module_param(guest_halt_poll_ns, uint, 0644);
 
@@ -33,7 +53,7 @@
 
 /* value in us to start growing per-cpu halt_poll_ns */
 static unsigned int guest_halt_poll_grow_start __read_mostly = 50000;
-module_param(guest_halt_poll_grow_start, uint, 0644);
+module_param_cb(guest_halt_poll_grow_start, &grow_start_ops, &guest_halt_poll_grow_start, 0644);
 
 /* allow shrinking guest halt poll */
 static bool guest_halt_poll_allow_shrink __read_mostly = true;
-- 
1.8.3.1

