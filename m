Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB31A67A1
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 13:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbfICLl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 07:41:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbfICLl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 07:41:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83BdILQ148258;
        Tue, 3 Sep 2019 11:41:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=2niyy18iMJJrJbnP8/27ZI5yggmyydzdGwzqDO8E1T8=;
 b=aiI+07M6+dErSEfDUqW5pKOo44r8JCLXMKr5mF6BjjMtUTynJnUJbcFw30BhtDIkiQGQ
 5r++ansMeXQsb3WbKLEwd0fb5tQZZMfUiFwWsetT7dh/UYniwvMj2/7x/FNjltg7Am/t
 h01gutDr++PW63Ro3Bus98IDDQ/xF3l9YJVGadIdRjiSAtzdXHKw38BULJ+e5gT3s37k
 NyFHIU7oR+3QnWKSDsglTMrsGzhFckH+tXDP3wZQs/46Z3hleVhJxIAEHZ/bViVlGZ6R
 8Odi23udtgDNdFlu1Ugu4cqfQOq4TkVeIjw2MsmZ+XSV+NiawRrP/Bu6DjmBolj88Z7b Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uspv805x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 11:41:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83BcdPp155219;
        Tue, 3 Sep 2019 11:39:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2us4wdr040-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 11:39:39 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x83BdcOe017661;
        Tue, 3 Sep 2019 11:39:38 GMT
Received: from paddy.uk.oracle.com (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 04:39:38 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v1 4/4] cpuidle-haltpoll: do not set an owner to allow modunload
Date:   Tue,  3 Sep 2019 12:39:13 +0100
Message-Id: <20190903113913.9257-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190903113913.9257-1-joao.m.martins@oracle.com>
References: <20190903113913.9257-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=716
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=778 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030123
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

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
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

