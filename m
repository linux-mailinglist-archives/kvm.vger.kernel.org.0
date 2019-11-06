Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA6BF11D3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 10:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbfKFJLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 04:11:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfKFJLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 04:11:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA698wYd116234;
        Wed, 6 Nov 2019 09:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=EPKzfVRRWTGlG40d7rhnldMOWGwhBLJaJGkHe+80yiw=;
 b=L6Aemdo9fhglASfZz2I71e0bQ6RJFLKi23q2FFx8QEXB8h+shi2JmTu2aijSZBJNxag5
 FL8ciWvzZK2/qc2IWw0Gswr9Z9wm931bc3WonurMT9rl0zOVNf0wkNJ9vVdU2kzB1Ecj
 2gBv+Hkdq0t1s8Nn9q3SJLlsD3ownbR7HuQ00IGCPxhSa3Msgdmo3ioVM5RRVAefKNAe
 ST6/7q/FNwlpqE7Pe0zG8o9tJpdEm1kAcS/VpP4JzzcGQ0RztuB5CXkZ4gQt+e709AWQ
 OhmCYy5JrS56J8x+WBsYni3NYzpoGMnXV6uOtaccfnEPpRm865Yj1jwzOurwWnY7PrY0 Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w117u4h0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:11:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6986Ah077631;
        Wed, 6 Nov 2019 09:09:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w35pqk36k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:09:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA699N3M001024;
        Wed, 6 Nov 2019 09:09:23 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 01:09:23 -0800
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        rafael.j.wysocki@intel.com, joao.m.martins@oracle.com,
        mtosatti@redhat.com, Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH v2 1/4] cpuidle-haltpoll: ensure grow start value is nonzero
Date:   Wed,  6 Nov 2019 17:08:49 +0800
Message-Id: <1573031332-2121-2-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573031332-2121-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1573031332-2121-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=854
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=932 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060096
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

