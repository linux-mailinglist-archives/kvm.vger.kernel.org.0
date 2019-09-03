Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2ABFA679A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfICLj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 07:39:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38746 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbfICLjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 07:39:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83BdFqm148183;
        Tue, 3 Sep 2019 11:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+VllEEyT4iEiGSQ5dF27BA09Kf2mwJdY7Ifdj5cpMaE=;
 b=f79bAZgOVA5B6a63DGRCc265TPitbn0472cZorEeadWZZLdUY7gqOTw6ysITbc/XETcJ
 5SP4u8y7qpXij8Pp8oy9u7xcm0QbaZwB7kaw8S9Q+4eFo38tK+m62FE/xfBxdykdZjFR
 DOzCUGSIxyNH/J+zArb/0FiT/OJxmAVSAteLSRBRjuHGFYAimdDfT7WcM6xBNgOXK9FF
 XOI8j7QZILjA9m0jJzv0aNFmNQEI1qiJhLFFdx+kFiJ3VvztpwawtX4e/pwhVbSwvRSe
 lyjwXXSoMcbaLCIuGuobChaYcyxX3pFZT60E0u7Co0iC+TMB8KQYXAIpT77/QTCrzGIA mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2usptvg6ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 11:39:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83Bbd4J057633;
        Tue, 3 Sep 2019 11:39:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2usk7dr7kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 11:39:35 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83BdYOe016444;
        Tue, 3 Sep 2019 11:39:34 GMT
Received: from paddy.uk.oracle.com (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 04:39:33 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v1 2/4] cpuidle-haltpoll: set haltpoll as preferred governor
Date:   Tue,  3 Sep 2019 12:39:11 +0100
Message-Id: <20190903113913.9257-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190903113913.9257-1-joao.m.martins@oracle.com>
References: <20190903113913.9257-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=359
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=412 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, guest current governors have the following ratings:

 * ladder            -> 10
 * teo               -> 19
 * menu              -> 20
 * haltpoll          -> 21
 * ladder + nohz=off -> 25

haltpoll governor got introduced and it is now the default governor given
its highest rating -- with ladder+nohz being the exception -- regardless of
idle driver in the guest. An example of an undesirable case is x86 KVM
guests with MWAIT which have intel_idle registered first, and consequently
will have haltpoll be used as governor which would get limited to a poll
state and state 1 and the other states wouldn't get used.

To keep the previous defaults we decrease rating of governor to 9 (below
current lowest rating) and thus rely on @governor switch on
cpuidle_register_driver() to tie in haltpoll idle driver and governor
together.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/cpuidle/cpuidle-haltpoll.c   | 1 +
 drivers/cpuidle/governors/haltpoll.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index 56d8ab814466..519e90d125cf 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -34,6 +34,7 @@ static int default_enter_idle(struct cpuidle_device *dev,
 
 static struct cpuidle_driver haltpoll_driver = {
 	.name = "haltpoll",
+	.governor = "haltpoll",
 	.owner = THIS_MODULE,
 	.states = {
 		{ /* entry 0 is for polling */ },
diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 797477bda486..7a703d2e0064 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -133,7 +133,7 @@ static int haltpoll_enable_device(struct cpuidle_driver *drv,
 
 static struct cpuidle_governor haltpoll_governor = {
 	.name =			"haltpoll",
-	.rating =		21,
+	.rating =		9,
 	.enable =		haltpoll_enable_device,
 	.select =		haltpoll_select,
 	.reflect =		haltpoll_reflect,
-- 
2.17.1

