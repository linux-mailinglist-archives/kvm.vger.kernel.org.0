Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E00BA69B0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 15:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbfICNZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 09:25:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbfICNZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 09:25:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DO83k046784;
        Tue, 3 Sep 2019 13:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=TsBg3V/tl4aUXqQSiAeslWhIsTsbykMZwpQqZWYisWA=;
 b=WNRLaYpHRBuP3zb6p2taNRXBUo6YOe+dD1O0DJadXYjIfejdgWZ0Wmum/bICxKIzpORF
 gyvXV/2Cpph6LUPRnCjQiwZ5HXi/VQ1Ogd+Wx3wngW6kWYkfF2XKMq0MRDFncr6aC+x3
 sOqNX1au3nIpv7937lSUkdEmj4k/u9NDHj9uF0+rejUdcyQvDNlYsGQe6qWmBo5oPTok
 aA+4fu3MgMZ4Hq1FzSVzvB8MjyCjU7yxVb/OPxx3DcTZmuhNfgD4FOKcjbiczJWuhEMC
 msk7r1ouS200bgpEw+5vAUV4QnfubslMtmfDRMZMg9914Ep5SobgqpTGk3x1Yvmm6zT/ 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2usrvsr1u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:24:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DO4Fu165077;
        Tue, 3 Sep 2019 13:24:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2uryv6py47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:24:58 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83DOu87023850;
        Tue, 3 Sep 2019 13:24:56 GMT
Received: from paddy.uk.oracle.com (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 06:24:55 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 1/4] cpuidle: allow governor switch on cpuidle_register_driver()
Date:   Tue,  3 Sep 2019 14:24:41 +0100
Message-Id: <20190903132444.11808-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190903132444.11808-1-joao.m.martins@oracle.com>
References: <20190903132444.11808-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The recently introduced haltpoll driver is largely only useful with
haltpoll governor. To allow drivers to associate with a particular idle
behaviour, add a @governor property to 'struct cpuidle_driver' and thus
allow a cpuidle driver to switch to a *preferred* governor on idle driver
registration. We save the previous governor, and when an idle driver is
unregistered we switch back to that.

The @governor can be overridden by cpuidle.governor= boot param or
alternatively be ignored if the governor doesn't exist.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/cpuidle/cpuidle.h  |  1 +
 drivers/cpuidle/driver.c   | 26 ++++++++++++++++++++++++++
 drivers/cpuidle/governor.c |  6 +++---
 include/linux/cpuidle.h    |  3 +++
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index d6613101af92..c046f49c1920 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -22,6 +22,7 @@ extern void cpuidle_install_idle_handler(void);
 extern void cpuidle_uninstall_idle_handler(void);
 
 /* governors */
+extern struct cpuidle_governor *cpuidle_find_governor(const char *str);
 extern int cpuidle_switch_governor(struct cpuidle_governor *gov);
 
 /* sysfs */
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index dc32f34e68d9..16a3f6c5ad69 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -87,6 +87,7 @@ static inline int __cpuidle_set_driver(struct cpuidle_driver *drv)
 #else
 
 static struct cpuidle_driver *cpuidle_curr_driver;
+static struct cpuidle_governor *cpuidle_prev_governor;
 
 /**
  * __cpuidle_get_cpu_driver - return the global cpuidle driver pointer.
@@ -254,12 +255,25 @@ static void __cpuidle_unregister_driver(struct cpuidle_driver *drv)
  */
 int cpuidle_register_driver(struct cpuidle_driver *drv)
 {
+	struct cpuidle_governor *gov;
 	int ret;
 
 	spin_lock(&cpuidle_driver_lock);
 	ret = __cpuidle_register_driver(drv);
 	spin_unlock(&cpuidle_driver_lock);
 
+	if (!ret && !strlen(param_governor) && drv->governor &&
+	    (cpuidle_get_driver() == drv)) {
+		mutex_lock(&cpuidle_lock);
+		gov = cpuidle_find_governor(drv->governor);
+		if (gov) {
+			cpuidle_prev_governor = cpuidle_curr_governor;
+			if (cpuidle_switch_governor(gov) < 0)
+				cpuidle_prev_governor = NULL;
+		}
+		mutex_unlock(&cpuidle_lock);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpuidle_register_driver);
@@ -274,9 +288,21 @@ EXPORT_SYMBOL_GPL(cpuidle_register_driver);
  */
 void cpuidle_unregister_driver(struct cpuidle_driver *drv)
 {
+	bool enabled = (cpuidle_get_driver() == drv);
+
 	spin_lock(&cpuidle_driver_lock);
 	__cpuidle_unregister_driver(drv);
 	spin_unlock(&cpuidle_driver_lock);
+
+	if (!enabled)
+		return;
+
+	mutex_lock(&cpuidle_lock);
+	if (cpuidle_prev_governor) {
+		if (!cpuidle_switch_governor(cpuidle_prev_governor))
+			cpuidle_prev_governor = NULL;
+	}
+	mutex_unlock(&cpuidle_lock);
 }
 EXPORT_SYMBOL_GPL(cpuidle_unregister_driver);
 
diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
index 2e3e14192bee..08707759469e 100644
--- a/drivers/cpuidle/governor.c
+++ b/drivers/cpuidle/governor.c
@@ -22,12 +22,12 @@ LIST_HEAD(cpuidle_governors);
 struct cpuidle_governor *cpuidle_curr_governor;
 
 /**
- * __cpuidle_find_governor - finds a governor of the specified name
+ * cpuidle_find_governor - finds a governor of the specified name
  * @str: the name
  *
  * Must be called with cpuidle_lock acquired.
  */
-static struct cpuidle_governor * __cpuidle_find_governor(const char *str)
+struct cpuidle_governor *cpuidle_find_governor(const char *str)
 {
 	struct cpuidle_governor *gov;
 
@@ -87,7 +87,7 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
 		return -ENODEV;
 
 	mutex_lock(&cpuidle_lock);
-	if (__cpuidle_find_governor(gov->name) == NULL) {
+	if (cpuidle_find_governor(gov->name) == NULL) {
 		ret = 0;
 		list_add_tail(&gov->governor_list, &cpuidle_governors);
 		if (!cpuidle_curr_governor ||
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 1a9f54eb3aa1..2dc4c6b19c25 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -121,6 +121,9 @@ struct cpuidle_driver {
 
 	/* the driver handles the cpus in cpumask */
 	struct cpumask		*cpumask;
+
+	/* preferred governor to switch at register time */
+	const char		*governor;
 };
 
 #ifdef CONFIG_CPU_IDLE
-- 
2.17.1

