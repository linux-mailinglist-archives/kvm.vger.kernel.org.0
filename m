Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A004ECF580
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 11:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfJHJB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 05:01:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730156AbfJHJB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 05:01:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x988hhgg176985;
        Tue, 8 Oct 2019 09:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=3+a8jxRfmNDEdrqLNhrQpAvhMUL4KphFXVnnvxuHmRQ=;
 b=DoACfvRbds8AUzjLAMbJj8NrxYWZ4mQ1fcU4I4d1iyWiMtXuOLiaozcP0qoKDCJ34dnd
 V1VOId4Men5E7t9w19W/T2ii+o5P/mYG1nQjnMrCAnlpNcuPlp2wcc88OnceKsD1xOJs
 wkfH7+1dVFne9oT8Yxk8VueQ4FaxU0BNpkprF5krJ5rW2bh3vJ9SFUrrSj4dCZjbFXho
 NSfi8HZ2EGkDkzUa3lPDTEqZuRT3mb34I4CVQoNHV4lrHUShC6U653o/EiVwSKibx4I1
 qV+1u6Kc54h7Yj/yR4Bb8k0oL5ZXXO5yjwPn1Yz6/oMvrHsJ0IojdbIMrx+Ga9uyhJQP eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vektrbvkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 09:00:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x988h365124670;
        Tue, 8 Oct 2019 09:00:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vgefa8jj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 09:00:15 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9890CJc023974;
        Tue, 8 Oct 2019 09:00:12 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Oct 2019 02:00:11 -0700
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
Subject: [PATCH v5 4/5] xen: Mark "xen_nopvspin" parameter obsolete
Date:   Mon,  7 Oct 2019 17:04:30 +0800
Message-Id: <1570439071-9814-5-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Map "xen_nopvspin" to "nopvspin", fix stale description of "xen_nopvspin"
as we use qspinlock now.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
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
 arch/x86/xen/spinlock.c                         | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

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
index 6deb490..799f4eb 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -114,9 +114,8 @@ void xen_uninit_lock_cpu(int cpu)
  */
 void __init xen_init_spinlocks(void)
 {
-
 	/*  Don't need to use pvqspinlock code if there is only 1 vCPU. */
-	if (num_possible_cpus() == 1)
+	if (num_possible_cpus() == 1 || nopvspin)
 		xen_pvspin = false;
 
 	if (!xen_pvspin) {
@@ -137,6 +136,7 @@ void __init xen_init_spinlocks(void)
 
 static __init int xen_parse_nopvspin(char *arg)
 {
+	pr_notice("\"xen_nopvspin\" is deprecated, please use \"nopvspin\" instead\n");
 	xen_pvspin = false;
 	return 0;
 }
-- 
1.8.3.1

