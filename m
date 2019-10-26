Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C27E584E
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 05:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfJZDZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 23:25:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43440 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfJZDZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 23:25:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9Q3OPgI051029;
        Sat, 26 Oct 2019 03:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=JH5g7kGl18GmOwGR9exKyCwwdZcdLzKY/dznWLlvQQA=;
 b=F+wGFwf3/iCqaqO3tACZ9VBzsZnhkahSeBlmxuAVt93LTYHTgF6aLfc8S9hXR0DAsDqj
 6+mE2DfrYXWU9YHcQ0BYx/WS1c6G0hGgueOQ8f8dJxlqV/J7A6DqVoS2n8H/mRQkfH9n
 Nklx70T+kQ2sSqgYaG9aYf3XRXOQ8Z9QX00g89fD9qqnCrn7curvDvkaOxavlx3C+b87
 FkwpRq2OYrwyC3aVTBXHVPk5xn6NUjlMnyF3X6KgLj9gdKo5tCimntE6JGC651l1CH31
 zSQM/Zg9rIamN2C4IcHJTxsRsI5u4vBzjUNPCUemOcqhE+Ev/ZNZlbkTZqWSwi4UC8y3 Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vvdjtr51n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Oct 2019 03:24:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9Q3OJEc082815;
        Sat, 26 Oct 2019 03:24:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vvc6mmwkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Oct 2019 03:24:50 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9Q3OoJl025657;
        Sat, 26 Oct 2019 03:24:50 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 20:24:50 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, mtosatti@redhat.com,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH 4/5] cpuidle-haltpoll: add a check to ensure grow start value is nonzero
Date:   Sat, 26 Oct 2019 11:23:58 +0800
Message-Id: <1572060239-17401-5-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=875
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910260033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=954 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910260034
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

dev->poll_limit_ns could be zeroed in certain cases (e.g. by
guest_halt_poll_shrink). If guest_halt_poll_grow_start is zero,
dev->poll_limit_ns will never be larger than zero.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 drivers/cpuidle/governors/haltpoll.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 7a703d2..4b00d7a 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -77,7 +77,7 @@ static int haltpoll_select(struct cpuidle_driver *drv,
 
 static void adjust_poll_limit(struct cpuidle_device *dev, unsigned int block_us)
 {
-	unsigned int val;
+	unsigned int val, grow_start;
 	u64 block_ns = block_us*NSEC_PER_USEC;
 
 	/* Grow cpu_halt_poll_us if
@@ -86,8 +86,17 @@ static void adjust_poll_limit(struct cpuidle_device *dev, unsigned int block_us)
 	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns) {
 		val = dev->poll_limit_ns * guest_halt_poll_grow;
 
-		if (val < guest_halt_poll_grow_start)
-			val = guest_halt_poll_grow_start;
+		/*
+		 * vcpu->halt_poll_ns needs a nonzero start point to grow if
+		 * it's zero.
+		 */
+		grow_start = guest_halt_poll_grow_start;
+		if (!grow_start)
+			grow_start = 1;
+
+		if (val < grow_start)
+			val = grow_start;
+
 		if (val > guest_halt_poll_ns)
 			val = guest_halt_poll_ns;
 
-- 
1.8.3.1

