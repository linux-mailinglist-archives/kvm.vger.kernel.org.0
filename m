Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A09A2203
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 19:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfH2RRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 13:17:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53804 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfH2RRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 13:17:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THDj1p103579;
        Thu, 29 Aug 2019 17:16:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZdWf5nAKch2sAxvuPQKTnzRVXVUZevXhS0HZrqLFMAc=;
 b=je3kftSxptgJIpWxFn1l6IvYKMirQ/nXSXbrQHs6R3kHlwtm5+htT8dzIn438Mu61l0C
 R2lNW+mFAeEbTjlghAY5KYqB8Q4vQEZF+e61obUOe0G0vuW3a59mLvizN1vkFjCZH2zp
 LEtaLf+mC85Lit0Pb5qZ5tbqhzsgcZtOWkGUFd1PPPIjRQAf+emvrP/UIRRNhNw/k/i+
 uvLTtICXl5eSwVFvAeqMVuxekjTIJpuikYxzc5LJQnhFzjDXCcS8tpY00WK4sGRNbDuY
 RqL2vbh00Tv1O695LxqY8Di+BLhqqdF9l58QEuwUZd+GIxwU9udXk575AXkXK//4EUjV eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2upjss82qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:16:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THCw8M145631;
        Thu, 29 Aug 2019 17:16:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2unvu0aarh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:16:13 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7THGBkE006501;
        Thu, 29 Aug 2019 17:16:11 GMT
Received: from [10.175.160.184] (/10.175.160.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 10:16:10 -0700
Subject: Is: Default governor regardless of cpuidle driver Was: [PATCH v2]
 cpuidle-haltpoll: vcpu hotplug support
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190829151027.9930-1-joao.m.martins@oracle.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com>
Date:   Thu, 29 Aug 2019 18:16:05 +0100
MIME-Version: 1.0
In-Reply-To: <20190829151027.9930-1-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290183
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/19 4:10 PM, Joao Martins wrote:
> When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
> past the online ones and thus fail to register the idle driver.
> This is because cpuidle_add_sysfs() will return with -ENODEV as a
> consequence from get_cpu_device() return no device for a non-existing
> CPU.
> 
> Instead switch to cpuidle_register_driver() and manually register each
> of the present cpus through cpuhp_setup_state() callback and future
> ones that get onlined. This mimmics similar logic that intel_idle does.
> 
> Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---

While testing the above, I found out another issue on the haltpoll series.
But I am not sure what is best suited to cpuidle framework, hence requesting
some advise if below is a reasonable solution or something else is preferred.

Essentially after haltpoll governor got introduced and regardless of the cpuidle
driver the default governor is gonna be haltpoll for a guest (given haltpoll
governor doesn't get registered for baremetal). Right now, for a KVM guest, the
idle governors have these ratings:

 * ladder            -> 10
 * teo               -> 19
 * menu              -> 20
 * haltpoll          -> 21
 * ladder + nohz=off -> 25

When a guest is booted with MWAIT and intel_idle is probed and sucessfully
registered, we will end up with a haltpoll governor being used as opposed to
'menu' (which used to be the default case). This would prevent IIUC that other
C-states get used other than poll_state (state 0) and state 1.

Given that haltpoll governor is largely only useful with a cpuidle-haltpoll
it doesn't look reasonable to be the default? What about using haltpoll governor
as default when haltpoll idle driver registers or modloads.

My idea to achieve the above would be to decrease the rating to 9 (before the
lowest rated governor) and retain old defaults before haltpoll. Then we would
allow a cpuidle driver to define a preferred governor to switch on idle driver
registration. Naturally all of would be ignored if overidden by
cpuidle.governor=.

The diff below the scissors line is an example of that.

Thoughts?

---------------------------------- >8 --------------------------------

From: Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] cpuidle: switch to prefered governor on registration

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/cpuidle/cpuidle-haltpoll.c   |  1 +
 drivers/cpuidle/cpuidle.h            |  1 +
 drivers/cpuidle/driver.c             | 26 ++++++++++++++++++++++++++
 drivers/cpuidle/governor.c           |  6 +++---
 drivers/cpuidle/governors/haltpoll.c |  2 +-
 include/linux/cpuidle.h              |  3 +++
 6 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index 8baade23f8d0..88a38c3c35e4 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -33,6 +33,7 @@ static int default_enter_idle(struct cpuidle_device *dev,

 static struct cpuidle_driver haltpoll_driver = {
 	.name = "haltpoll",
+	.governor = "haltpoll",
 	.owner = THIS_MODULE,
 	.states = {
 		{ /* entry 0 is for polling */ },
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
index dc32f34e68d9..8b8b9d89ce58 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -87,6 +87,7 @@ static inline int __cpuidle_set_driver(struct cpuidle_driver *drv)
 #else

 static struct cpuidle_driver *cpuidle_curr_driver;
+static struct cpuidle_governor *cpuidle_default_governor = NULL;

 /**
  * __cpuidle_get_cpu_driver - return the global cpuidle driver pointer.
@@ -254,12 +255,25 @@ static void __cpuidle_unregister_driver(struct
cpuidle_driver *drv)
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
+			cpuidle_default_governor = cpuidle_curr_governor;
+			if (cpuidle_switch_governor(gov) < 0)
+				cpuidle_default_governor = NULL;
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
+	if (cpuidle_default_governor) {
+		if (!cpuidle_switch_governor(cpuidle_default_governor))
+			cpuidle_default_governor = NULL;
+	}
+	mutex_unlock(&cpuidle_lock);
 }
 EXPORT_SYMBOL_GPL(cpuidle_unregister_driver);

diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
index 2e3e14192bee..e93c11dc8304 100644
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
+struct cpuidle_governor * cpuidle_find_governor(const char *str)
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
diff --git a/drivers/cpuidle/governors/haltpoll.c
b/drivers/cpuidle/governors/haltpoll.c
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
