Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31EDAC9FF
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2019 01:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395367AbfIGXqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 19:46:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59968 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395358AbfIGXqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 19:46:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87NjwfD069572;
        Sat, 7 Sep 2019 23:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=c1lJWkpKkLbkP8Na/Z0awsFnB98HoBMs0un3nCrWlNI=;
 b=BJmXLG7bsH8wkKnm4zDFDn3fjngc1ouZhfROyNvNHLyHsgsoO7JszdiAgVp79YLxMomR
 S0MBRdlioPccHYmeEQNqf+/O5aykrwHEIuD62DP7fDKxj+/A/bDs6FbSqjQ1R40B+j1W
 hkpEinnORDVKSIvZk3TZgCoky+xNScvzaUiWhF032q/+ccOWjVgSnD2tTfOFgbNP0KGl
 3Dwd+ayenmqv+eUzqBYcioQ9u/aPdcwqgu4PWBC2ow60pN75XxxmEu37DygCOQcQ4cA9
 NVj4IRobCmtp4o3woGWm02wh2+7WeASKK6eMB+KyJeaNiA+WuK8yY1Y5sayFR/gzDi/E zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uvpg2800q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 23:45:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87NhoDE002315;
        Sat, 7 Sep 2019 23:45:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2uv3wjr0wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 23:45:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x87Njuht025811;
        Sat, 7 Sep 2019 23:45:56 GMT
Received: from paddy.uk.oracle.com (/10.175.163.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 16:45:56 -0700
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-pm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 1/4] cpuidle: allow governor switch on cpuidle_register_driver()
Date:   Sun,  8 Sep 2019 00:45:21 +0100
Message-Id: <20190907234524.5577-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190907234524.5577-1-joao.m.martins@oracle.com>
References: <20190907234524.5577-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070260
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070260
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
v3:
* Fix kbuild test robot arm issues with CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
  Specifically, moved @cpuidle_prev_governor to a more generic place
  as this is not really tied to !CONFIG_CPU_IDLE_MULTIPLE_DRIVERS
---
 drivers/cpuidle/cpuidle.h  |  2 ++
 drivers/cpuidle/driver.c   | 25 +++++++++++++++++++++++++
 drivers/cpuidle/governor.c |  7 ++++---
 include/linux/cpuidle.h    |  3 +++
 4 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index d6613101af92..9f336af17fa6 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -9,6 +9,7 @@
 /* For internal use only */
 extern char param_governor[];
 extern struct cpuidle_governor *cpuidle_curr_governor;
+extern struct cpuidle_governor *cpuidle_prev_governor;
 extern struct list_head cpuidle_governors;
 extern struct list_head cpuidle_detected_devices;
 extern struct mutex cpuidle_lock;
@@ -22,6 +23,7 @@ extern void cpuidle_install_idle_handler(void);
 extern void cpuidle_uninstall_idle_handler(void);
 
 /* governors */
+extern struct cpuidle_governor *cpuidle_find_governor(const char *str);
 extern int cpuidle_switch_governor(struct cpuidle_governor *gov);
 
 /* sysfs */
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index dc32f34e68d9..80c1a830d991 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -254,12 +254,25 @@ static void __cpuidle_unregister_driver(struct cpuidle_driver *drv)
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
@@ -274,9 +287,21 @@ EXPORT_SYMBOL_GPL(cpuidle_register_driver);
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
index 2e3e14192bee..e9801f26c732 100644
--- a/drivers/cpuidle/governor.c
+++ b/drivers/cpuidle/governor.c
@@ -20,14 +20,15 @@ char param_governor[CPUIDLE_NAME_LEN];
 
 LIST_HEAD(cpuidle_governors);
 struct cpuidle_governor *cpuidle_curr_governor;
+struct cpuidle_governor *cpuidle_prev_governor;
 
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
 
@@ -87,7 +88,7 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
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

