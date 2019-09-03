Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9BEA69B6
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 15:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfICNZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 09:25:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33634 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729020AbfICNZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 09:25:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DO2M3042149;
        Tue, 3 Sep 2019 13:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=KM/hdDQyd8Z+6S0BJ3ZElEafo02FzH2F7BIJZJMmdtk=;
 b=l9sDZyu5HJrQ8N3sKPlLr9yrmFxj6JhIDDRNX5ipMZcVcBqNkM/7RZEsZW7iFNcNrDaN
 0oopaJTECQwvZLMfTQZBeEX5DYMsxhgUEgRLIlxCEIyXRzrOQpFGs0E97cicPxw9tju6
 uYpCaY7nzJwYDKEUwGXvAhHZCF0ZcWj1Eecsa87AMTWFucZDKGYz0YtsUnPRSTIt2ued
 Sh+H0R/5vqSZjsWwxmD0pY95MruWkC/LhS3JAj+oDkJqa7MXxslq5UU5zPYFJakIkcRP
 cdhfY1+vXIFWXL8qm3tpWiZpqTCNlstzxAMfIHqANTpfLu9nwQY+S6oGIDc1350cidAB 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2usrw8r1fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:25:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DOF3j129247;
        Tue, 3 Sep 2019 13:25:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2us5pguu5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:25:04 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x83DP3IJ000558;
        Tue, 3 Sep 2019 13:25:03 GMT
Received: from paddy.uk.oracle.com (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 06:25:03 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 4/4] cpuidle-haltpoll: do not set an owner to allow modunload
Date:   Tue,  3 Sep 2019 14:24:44 +0100
Message-Id: <20190903132444.11808-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190903132444.11808-1-joao.m.martins@oracle.com>
References: <20190903132444.11808-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=704
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=766 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cpuidle-haltpoll can be built as a module to allow optional late load.
Given we are setting @owner to THIS_MODULE, cpuidle will attempt to grab a
module reference every time a cpuidle_device is registered -- so
essentially all online cpus get a reference.

This prevents for the module to be unloaded later, which makes the
module_exit callback entirely unused. Thus remove the @owner and allow
module to be unloaded.

Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
v2:
* Add missing Fixes tag
---
 drivers/cpuidle/cpuidle-haltpoll.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index 7a0239ef717e..49a65c6fe91e 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -35,7 +35,6 @@ static int default_enter_idle(struct cpuidle_device *dev,
 static struct cpuidle_driver haltpoll_driver = {
 	.name = "haltpoll",
 	.governor = "haltpoll",
-	.owner = THIS_MODULE,
 	.states = {
 		{ /* entry 0 is for polling */ },
 		{
-- 
2.17.1

