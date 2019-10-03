Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCA3CBC83
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 16:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389018AbfJDOBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 10:01:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388417AbfJDOBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 10:01:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94Ds0G1013640;
        Fri, 4 Oct 2019 13:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=YJRsdhrYloPVFVI8bVI+pnWLbrEExewFoaxkTINXFWg=;
 b=XvnQcoyeXmmdjw2sz+7dW23NMe7Wjl+2ArqLRIgszua+50WPAfbwPJcNqz9LO9LjSGv+
 0+M3zQthEviVi/CIXXlkWtv//tDk8a5Q4/Hn3TWfLfAXfm47/ia2U/DgzZjGrH0OBBCx
 sg88shmSKNJiS403NPT/CCyCYN9xg2SA5yYGHQ/0krT+IZEZNitaJYeO3dQHIpcVHSwH
 THeEnAEYHE/JyajwFdN6CVrBCK/PHDheXoe80JNtjV1YVQ2vCbQOlOQEAIJlV+mWGCZ2
 RdMhWYH67nLP45Ig/5Mrfeza/kWIiGGYBv703t0OutEsUQe9GDQpuSIR+MrnyjxGimIm MQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05sbh78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 13:58:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94DrNid009194;
        Fri, 4 Oct 2019 13:58:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vdn19tq6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 13:58:13 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x94DwCZU011936;
        Fri, 4 Oct 2019 13:58:12 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Oct 2019 06:58:12 -0700
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
Subject: [PATCH v4 3/4] xen: Mark "xen_nopvspin" parameter obsolete
Date:   Thu,  3 Oct 2019 22:02:14 +0800
Message-Id: <1570111335-12731-4-git-send-email-zhenzhong.duan@oracle.com>
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

Map "xen_nopvspin" to "nopvspin", fix stale description of "xen_nopvspin"
as we use qspinlock now.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 7 ++++---
 arch/x86/xen/spinlock.c                         | 3 +++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 89d77ea..df1eacc 100644
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
 
-	nopvspin	[X86,KVM]
+	nopvspin	[X86,XEN,KVM]
 			Disables the qspinlock slow path using PV optimizations
 			which allow the hypervisor to 'idle' the guest on lock
 			contention.
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 6deb490..bae29a4 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -114,6 +114,8 @@ void xen_uninit_lock_cpu(int cpu)
  */
 void __init xen_init_spinlocks(void)
 {
+	if (nopvspin)
+		xen_pvspin = false;
 
 	/*  Don't need to use pvqspinlock code if there is only 1 vCPU. */
 	if (num_possible_cpus() == 1)
@@ -137,6 +139,7 @@ void __init xen_init_spinlocks(void)
 
 static __init int xen_parse_nopvspin(char *arg)
 {
+	pr_notice("\"xen_nopvspin\" is deprecated, please use \"nopvspin\" instead\n");
 	xen_pvspin = false;
 	return 0;
 }
-- 
1.8.3.1

