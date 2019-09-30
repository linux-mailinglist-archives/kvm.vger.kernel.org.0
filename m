Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27645C3481
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 14:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387946AbfJAMlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 08:41:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56686 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfJAMlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 08:41:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91CNwwP189082;
        Tue, 1 Oct 2019 12:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=GtVRWSkJdvDM4w/69JBG+TdrM2Ajm19z9dVkdS+dmOs=;
 b=LiRE0JojtzW/f4ThbLuY2RE1MQUrZiyZTkvlQt+gBNiCVr/JPaYolh2e7gPgAgB/fRho
 wjBhwo+0oRmTMIQh3ZqDXUfFfuwahuYVbu60Jbtzb37mjx4YNgB7aKP1dxFrxaDjj2rk
 uBz7S11rtrzh/ImdyldyxMK2kwdZQpJWC9+uLQPT/9j63LIt5wGewRHLcifhN+vT4Gs5
 9qmfVRR7Lgv3/aOQsNLamcQa3iDItpvWOkaW56gml7/a9Cmnw0p6nVKl1t8eg0ztc3jX
 L/pJSP2q6gv2ermNR8N6NKPEp/0P/1Zn+Gmc9SheFee1oN5myPKlN1ygJ8QrVGpXuy6I eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v9xxunhy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:40:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91COKG2196272;
        Tue, 1 Oct 2019 12:40:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vbmpygb20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:40:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x91Ce7vJ030504;
        Tue, 1 Oct 2019 12:40:07 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 05:40:06 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 3/4] xen: Mark "xen_nopvspin" parameter obsolete and map it to "nopvspin"
Date:   Mon, 30 Sep 2019 20:44:38 +0800
Message-Id: <1569847479-13201-4-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix stale description of "xen_nopvspin" as we use qspinlock now.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  7 ++++---
 arch/x86/xen/spinlock.c                         | 13 +++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4b956d8..1f0a62f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5303,8 +5303,9 @@
 			never -- do not unplug even if version check succeeds
 
 	xen_nopvspin	[X86,XEN]
-			Disables the ticketlock slowpath using Xen PV
-			optimizations.
+			Disables the qspinlock slowpath using Xen PV optimizations.
+			This parameter is obsoleted by "nopvspin" parameter, which
+			has equivalent effect for XEN platform.
 
 	xen_nopv	[X86]
 			Disables the PV optimizations forcing the HVM guest to
@@ -5330,7 +5331,7 @@
 			as generic guest with no PV drivers. Currently support
 			XEN HVM, KVM, HYPER_V and VMWARE guest.
 
-	nopvspin	[X86,KVM] Disables the qspinlock slow path
+	nopvspin	[X86,XEN,KVM] Disables the qspinlock slow path
 			using PV optimizations which allow the hypervisor to
 			'idle' the guest on lock contention.
 
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 6deb490..092a53f 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -18,7 +18,6 @@
 static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
 static DEFINE_PER_CPU(char *, irq_name);
 static DEFINE_PER_CPU(atomic_t, xen_qlock_wait_nest);
-static bool xen_pvspin = true;
 
 static void xen_qlock_kick(int cpu)
 {
@@ -68,7 +67,7 @@ void xen_init_lock_cpu(int cpu)
 	int irq;
 	char *name;
 
-	if (!xen_pvspin)
+	if (!pvspin)
 		return;
 
 	WARN(per_cpu(lock_kicker_irq, cpu) >= 0, "spinlock on CPU%d exists on IRQ%d!\n",
@@ -93,7 +92,7 @@ void xen_init_lock_cpu(int cpu)
 
 void xen_uninit_lock_cpu(int cpu)
 {
-	if (!xen_pvspin)
+	if (!pvspin)
 		return;
 
 	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
@@ -117,9 +116,9 @@ void __init xen_init_spinlocks(void)
 
 	/*  Don't need to use pvqspinlock code if there is only 1 vCPU. */
 	if (num_possible_cpus() == 1)
-		xen_pvspin = false;
+		pvspin = false;
 
-	if (!xen_pvspin) {
+	if (!pvspin) {
 		printk(KERN_DEBUG "xen: PV spinlocks disabled\n");
 		static_branch_disable(&virt_spin_lock_key);
 		return;
@@ -137,7 +136,9 @@ void __init xen_init_spinlocks(void)
 
 static __init int xen_parse_nopvspin(char *arg)
 {
-	xen_pvspin = false;
+	pr_notice("\"xen_nopvspin\" is deprecated, please use \"nopvspin\" instead\n");
+	if (xen_domain())
+		pvspin = false;
 	return 0;
 }
 early_param("xen_nopvspin", xen_parse_nopvspin);
-- 
1.8.3.1

