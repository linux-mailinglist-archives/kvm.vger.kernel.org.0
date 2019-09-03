Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07850A69B3
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 15:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbfICNZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 09:25:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbfICNZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 09:25:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DOBrM042257;
        Tue, 3 Sep 2019 13:25:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+VllEEyT4iEiGSQ5dF27BA09Kf2mwJdY7Ifdj5cpMaE=;
 b=N5B6PkiJt+VTDiKACfjykl3rhZtFTGRAvnf99gPhmKspLwggZAjajpgpEnt2HPMBk14d
 el+C+0DQMKBDE/qq+U6GIGGwgpCYKo8o9CD3MOSjHVnr/Z+C+0r8W5Nt88WxQnmYmEN+
 JWz1v2o4Uo0Cyk2Gyb3Pnm9Ii0xtYm+J8ESK/KJvRzbNQftZKa/zj4m44595Zp+DwUJv
 dpY53+fm/eHqN5Mr1O8dsMeqWUxQT/qUImccGr1rUcpjjcJtZkDWX3rTuMaSboKaFp1B
 Zh+4ldG87qW3sgmzBh76j9JyerOu4OmfuofcyL98Noys/CZonsukB9JfHD54YBcVmlkT eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2usrw8r1f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:24:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DO3DH164824;
        Tue, 3 Sep 2019 13:24:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2uryv6py59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:24:59 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83DOw7a016999;
        Tue, 3 Sep 2019 13:24:58 GMT
Received: from paddy.uk.oracle.com (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 06:24:58 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 2/4] cpuidle-haltpoll: set haltpoll as preferred governor
Date:   Tue,  3 Sep 2019 14:24:42 +0100
Message-Id: <20190903132444.11808-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190903132444.11808-1-joao.m.martins@oracle.com>
References: <20190903132444.11808-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=359
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=412 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030142
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

