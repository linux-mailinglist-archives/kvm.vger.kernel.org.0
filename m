Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE76A69B8
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 15:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbfICNZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 09:25:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41590 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbfICNZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 09:25:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DOBP5048240;
        Tue, 3 Sep 2019 13:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=qv8voy15J0vDwU5XKrHvG6gwYjAjx6li7t3EIYvElEU=;
 b=WeeYkWVp3yhIf6PElEXi0hqWcsoYlkJvd5o+7ATzhAfpje+vFzM31IK9Yd0P8+trzCjO
 ju8YAFoRHqIqiH5V/xtN2xU7qK8YbvA5Zzgby68jxGXo0QO1QPjXCxOM/iNdIn/aHEA6
 VCWoqtoWZ01XZw0tWbiZ8+KB1g1HdcQ5CMKyqLRh0bgEDW50SMXhhehWO+bETfCSZI+i
 54pHzRsLAzwFZOA4oujPuwyZCmenute0Gccgm3v3LwwDzGXrtEZLNPS0uNOMNaTSstDg
 YGvpN3VQno66WrbyUFvXI3AgXc7QWpPX37x0Lxl+VLJwphM3qKRrdO+LWMiw0aDt2OOg Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2usrvcg353-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:25:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DOFM3129252;
        Tue, 3 Sep 2019 13:25:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2us5pguu4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:25:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83DP1rq017032;
        Tue, 3 Sep 2019 13:25:01 GMT
Received: from paddy.uk.oracle.com (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 06:25:01 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 3/4] cpuidle-haltpoll: return -ENODEV on modinit failure
Date:   Tue,  3 Sep 2019 14:24:43 +0100
Message-Id: <20190903132444.11808-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190903132444.11808-1-joao.m.martins@oracle.com>
References: <20190903132444.11808-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=884
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=942 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a user loads cpuidle-haltpoll on a non KVM guest the module will
successfully load, even though idle driver registration didn't take
place.

We should instead return -ENODEV signaling the user that the driver can't
be loaded, like other error paths in haltpoll_init().  An example of such
error paths is when we return -EBUSY when attempting to register an idle
driver when it had one already (e.g. intel_idle loads at boot and then we
attempt to insert module cpuidle-haltpoll).

Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
v2:
* Add missing Fixes tag
---
 drivers/cpuidle/cpuidle-haltpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index 519e90d125cf..7a0239ef717e 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -99,7 +99,7 @@ static int __init haltpoll_init(void)
 	cpuidle_poll_state_init(drv);
 
 	if (!kvm_para_available())
-		return 0;
+		return -ENODEV;
 
 	ret = cpuidle_register_driver(drv);
 	if (ret < 0)
-- 
2.17.1

