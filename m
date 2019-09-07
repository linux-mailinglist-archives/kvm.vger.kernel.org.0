Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F789AC9FD
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2019 01:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395382AbfIGXqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 19:46:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395359AbfIGXqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 19:46:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Nhp3c084817;
        Sat, 7 Sep 2019 23:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=tRVOPXcmIvP6hLEjNyL59QRX+AnG9vh+uFcv9paTsEI=;
 b=eOTbzUj0NrHqeZRUqtae705XwbcUL4ns8+rSDShzWaMKUDr08/aiW9Z5lmecp0479NCG
 u2hu0sSQgG3Wv8sexdPnjsvO/SVCm5M2XNswjrM7uiC7B6VdeRx7PxiUxTrsdf8D1q6q
 qVwjiplK/5VyMY5Usp1lhD31Fxzrh8PUm3c79qDJaNhPgilOh294ylOnlMso/ssJnuZ1
 pbDw5WJpia3x0JkksAX/1hV9PgLxZ4pKV7BxMqm9+tmB2aJg2anjmpczbuC56Xag5Qqn
 iYnH/t/vMlishou28vxTGjw3xz+75hy4ZhD0Qs/eMmPQ4V2tuD3HNvp8Y00C0o7Wsqx8 yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uvpfqg06a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 23:46:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87NhnkH002272;
        Sat, 7 Sep 2019 23:46:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2uv3wjr126-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 23:46:03 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x87Nk3KR013835;
        Sat, 7 Sep 2019 23:46:03 GMT
Received: from paddy.uk.oracle.com (/10.175.163.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 16:46:02 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 4/4] cpuidle-haltpoll: do not set an owner to allow modunload
Date:   Sun,  8 Sep 2019 00:45:24 +0100
Message-Id: <20190907234524.5577-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190907234524.5577-1-joao.m.martins@oracle.com>
References: <20190907234524.5577-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=732
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070260
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=796 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070260
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
 * Added Fixes tag
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

