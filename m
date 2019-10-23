Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B568E18A0
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 13:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404698AbfJWLTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 07:19:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52694 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404682AbfJWLTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 07:19:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9NB9FxV066143;
        Wed, 23 Oct 2019 11:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=qaL3Wn/zckv6LbHPeF9PDceDQSnByrsojCND7DKPF+c=;
 b=VTpYw8tRc38lzsY/V+r+EwxfBM+uHwJpcsFCbJVtVpRvlxs53tSk3M0ZnlRLl9Lf2scb
 ohjWLBqGavS0nMX+SBpzORc8XtSrZvtK3/4RsK00qVwpcqduGP8PCOUGhl+r18+5sacV
 FCoQIc9ps8jqm+/mlGK4RzU+dm5+wUxvihRukD3bmSWVVQBkCCzGPiteEzXtT89DeJ2+
 vyppriMrsP6Fn/5x9qs8vo/G7ELQdGE27dJpvxGHOAOZZP3SO3h4N4JmEHOPYouDP9N9
 SxFEir08iWO09DejOFVMdsBXZYdKeGa+LqddfQWLCStMFo8gL24AVbtIQzN3lwkEXXj+ tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswtmrg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 11:17:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9NBCw91047239;
        Wed, 23 Oct 2019 11:17:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vtjkffemh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 11:17:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9NBHV3r000778;
        Wed, 23 Oct 2019 11:17:31 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Oct 2019 04:17:31 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com, peterz@infradead.org,
        will@kernel.org, linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v8 5/5] x86/hyperv: Mark "hv_nopvspin" parameter obsolete
Date:   Wed, 23 Oct 2019 19:16:24 +0800
Message-Id: <1571829384-5309-6-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571829384-5309-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1571829384-5309-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910230114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910230114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Map "hv_nopvspin" to "nopvspin".

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
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
index 85059dd..78648bb 100644
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
@@ -5335,7 +5339,7 @@
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

