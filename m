Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030FDA6794
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 13:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfICLjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 07:39:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbfICLjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 07:39:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83BdbjY148414;
        Tue, 3 Sep 2019 11:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Yg3gXbo1BBpCILnBXocPDkPieXl1D3dVfuZvhW7kQfs=;
 b=rZfGqhhAN7xrF0O6CEgjZtKEzfiV1wV7SaOUXdY6BkaF/53eqOIKsUbNfucCvvNexvgl
 Ah2/A1y4WVZzqq5gbGTHHY7Q4wLgPtXxC4lpU6Mk4Hmh1YGUQxS/wtEtl4TF8SsNYqnA
 i2Hm2QVgrf+NA+2fsxNUzVFgAM2CqWCVPzzgYKEPPjMF6/XNewWOL3Vse8ydlflYPxjV
 HQHpCarTfdc8yNE22JZBwe6jCDhjbDJhoVLtGzHZhfxL/mbC71FXp3DM/uJp//TUf7b3
 4vlK1yWFzkG28INp1Ryq1QK9bYvROOM2hTS+yDoMfqlTb4yWVOKimvZ/dCQl793BM/fn 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uspv805p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 11:39:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83BcHBY070771;
        Tue, 3 Sep 2019 11:39:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2us5pgs2m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 11:39:36 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83Bda3R016520;
        Tue, 3 Sep 2019 11:39:36 GMT
Received: from paddy.uk.oracle.com (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 04:39:36 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v1 3/4] cpuidle-haltpoll: return -ENODEV on modinit failure
Date:   Tue,  3 Sep 2019 12:39:12 +0100
Message-Id: <20190903113913.9257-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190903113913.9257-1-joao.m.martins@oracle.com>
References: <20190903113913.9257-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=893
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=954 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030123
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

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
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

