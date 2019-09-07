Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575DAACA02
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2019 01:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395337AbfIGXqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 19:46:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbfIGXqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 19:46:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Nk0Ye034021;
        Sat, 7 Sep 2019 23:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kniHXHoprbjvqots8o+Jx0LwbVRfUxK/t4nIZCC7Rcc=;
 b=HcZPWKUg5CLQFvK9++znMgP89sxsHNM1ahY4h8YHxy5iccw3uellN4Xv0LlzAqkCFNuG
 8spUAIy8fPbVVvVb6DICxDg3eZlszp6YDfaJhadqeAfsCi+Ifw0f9+WW+rqoBV9PthrX
 koqH3z9SUDk5olgmJKSQFQC57VkF/gx6BF5X5QHlaahOO6cpmCNIiTuSwOZvNsjuFSdf
 0akfxqVKKfCo/TipIv9GMu1kjPkeEV+P4bc1ie3+5ShsysTIXXgKA57yIk2Qm8Eu/3cg
 lZGIy5AkSuMEdjB3hjch7+HTPsJZgun/poMuEA5jBXFYV1s3NqruTrMCU+3Ud41K+ols 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uvpgdr00t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 23:46:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Ngt1k098621;
        Sat, 7 Sep 2019 23:46:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uv2kxkujx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 23:46:02 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x87Nk0pi013991;
        Sat, 7 Sep 2019 23:46:01 GMT
Received: from paddy.uk.oracle.com (/10.175.163.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 16:46:00 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 3/4] cpuidle-haltpoll: return -ENODEV on modinit failure
Date:   Sun,  8 Sep 2019 00:45:23 +0100
Message-Id: <20190907234524.5577-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190907234524.5577-1-joao.m.martins@oracle.com>
References: <20190907234524.5577-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=922
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070260
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=982 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070260
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
 * Added Fixes tag
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

