Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E1BCBC7B
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 16:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388969AbfJDOAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 10:00:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37064 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388333AbfJDOAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 10:00:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94Ds09H171507;
        Fri, 4 Oct 2019 13:58:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=rSQT7zn+rN0UMSmgUwlCXlBC2OS455/YhJU3/oDgah0=;
 b=kehqDksQ1SIaBXIVJcobNbGBXt8njy7h2mbqJ8XdawUEEqwcmONw4yez4uiNqUGVSRO8
 6dVsS1iFkBSEkcYpPW0nrh3/ukOqOJuB0actPm6fPBLPYKuD6jCZIMDmMxbCSxJhGl6F
 v6db0UVVRsrWIryGm/OXdJHpw0fL+i/CvqGQW4Mn+uOtoAQTwNHYbq/RXtIuXg97L/5P
 cneSE0gArXZ2mYhxjwKob+24VmQ4Z+IBzE8SD363vLKxigSSPvK0aO0GBmWClvpQWA5I
 An1pqCuWbRcDiTVseF/x0HRt0xQh3cysJM8XHQlg28LUX7vBkF4BH4Qgv2ApnxLR5cKU 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v9yfquk1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 13:58:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94DrYRo062517;
        Fri, 4 Oct 2019 13:58:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vdxu8t0gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 13:58:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x94DwHwL012969;
        Fri, 4 Oct 2019 13:58:18 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Oct 2019 06:58:17 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, peterz@infradead.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 4/4] x86/hyperv: Mark "hv_nopvspin" parameter obsolete
Date:   Thu,  3 Oct 2019 22:02:15 +0800
Message-Id: <1570111335-12731-5-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570111335-12731-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1570111335-12731-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Map "hv_nopvspin" to "nopvspin".

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 6 +++++-
 arch/x86/hyperv/hv_spinlock.c                   | 4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index df1eacc..08c6d34 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1436,6 +1436,10 @@
 	hv_nopvspin	[X86,HYPER_V] Disables the paravirt spinlock optimizations
 				      which allow the hypervisor to 'idle' the
 				      guest on lock contention.
+				      This parameter is obsoleted by "nopvspin"
+				      parameter, which has equivalent effect for
+				      HYPER_V platform.
+
 
 	keep_bootcon	[KNL]
 			Do not unregister boot console at start. This is only
@@ -5331,7 +5335,7 @@
 			as generic guest with no PV drivers. Currently support
 			XEN HVM, KVM, HYPER_V and VMWARE guest.
 
-	nopvspin	[X86,XEN,KVM]
+	nopvspin	[X86,XEN,KVM,HYPER_V]
 			Disables the qspinlock slow path using PV optimizations
 			which allow the hypervisor to 'idle' the guest on lock
 			contention.
diff --git a/arch/x86/hyperv/hv_spinlock.c b/arch/x86/hyperv/hv_spinlock.c
index 07f21a0..47c7d6c 100644
--- a/arch/x86/hyperv/hv_spinlock.c
+++ b/arch/x86/hyperv/hv_spinlock.c
@@ -64,6 +64,9 @@ __visible bool hv_vcpu_is_preempted(int vcpu)
 
 void __init hv_init_spinlocks(void)
 {
+	if (nopvspin)
+		hv_pvspin = false;
+
 	if (!hv_pvspin || !apic ||
 	    !(ms_hyperv.hints & HV_X64_CLUSTER_IPI_RECOMMENDED) ||
 	    !(ms_hyperv.features & HV_X64_MSR_GUEST_IDLE_AVAILABLE)) {
@@ -82,6 +85,7 @@ void __init hv_init_spinlocks(void)
 
 static __init int hv_parse_nopvspin(char *arg)
 {
+	pr_notice("\"hv_nopvspin\" is deprecated, please use \"nopvspin\" instead\n");
 	hv_pvspin = false;
 	return 0;
 }
-- 
1.8.3.1

