Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A80B79CA
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390399AbfISMxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:53:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57266 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390392AbfISMxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:53:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCnMAr192145;
        Thu, 19 Sep 2019 12:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=9SZQUXKdrUQBvyYWQRH9Ad4ui8DD00uYNkCItZfCZtY=;
 b=bxqxXC/AlHecSvdSM1pn6Axsm94ZtTd1RLrEkJLap/VZD6l1Gu6oHUANC/q7WjzscWxM
 M+42op+e5LknddSkYGA4/F123Q04fPK22ht0u8zplXeT/7ZYhbm66pcID2Ldtq85ETBt
 zHTA9QDkA79P6gGgIfVnwRTCXHD89PTpAvEZXl0IK8DkelxWozoSjziTWKdpNpHt5a/u
 sQhJxAFfK/gOuYdMj4xgmlqr5E5IIRnfikUBkVCNI/vNn6KiFnkSLo4TeAd68lG6Ju6g
 YKAha74tT5Sw9R3qF1Mt4bUvCKI0ZB6T98Swf7luQhIvsIJ33HGKVuhdFI+AKxP3oNeA +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v3vb4uqqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8JCn0pf056533;
        Thu, 19 Sep 2019 12:52:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v3vbg2dyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 12:52:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8JCqeqY012371;
        Thu, 19 Sep 2019 12:52:40 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 05:52:40 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 5/8] x86: vmx: Use MSR_IA32_FEATURE_CONTROL bits names
Date:   Thu, 19 Sep 2019 15:52:08 +0300
Message-Id: <20190919125211.18152-6-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190919125211.18152-1-liran.alon@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=981
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909190121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909190121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid using hard-coded numbers to improve code readability.

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/vmx.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 4b839ea8cc66..146734d334a1 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1314,13 +1314,18 @@ static int test_vmx_feature_control(void)
 {
 	u64 ia32_feature_control;
 	bool vmx_enabled;
+	bool feature_control_locked;
 
 	ia32_feature_control = rdmsr(MSR_IA32_FEATURE_CONTROL);
-	vmx_enabled = ((ia32_feature_control & 0x5) == 0x5);
-	if ((ia32_feature_control & 0x5) == 0x5) {
+	vmx_enabled =
+		ia32_feature_control & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
+	feature_control_locked =
+		ia32_feature_control & FEATURE_CONTROL_LOCKED;
+
+	if (vmx_enabled && feature_control_locked) {
 		printf("VMX enabled and locked by BIOS\n");
 		return 0;
-	} else if (ia32_feature_control & 0x1) {
+	} else if (feature_control_locked) {
 		printf("ERROR: VMX locked out by BIOS!?\n");
 		return 1;
 	}
@@ -1329,12 +1334,17 @@ static int test_vmx_feature_control(void)
 	report("test vmxon with FEATURE_CONTROL cleared",
 	       test_for_exception(GP_VECTOR, &do_vmxon_off, NULL));
 
-	wrmsr(MSR_IA32_FEATURE_CONTROL, 0x4);
+	wrmsr(MSR_IA32_FEATURE_CONTROL, FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX);
 	report("test vmxon without FEATURE_CONTROL lock",
 	       test_for_exception(GP_VECTOR, &do_vmxon_off, NULL));
 
-	wrmsr(MSR_IA32_FEATURE_CONTROL, 0x5);
-	vmx_enabled = ((rdmsr(MSR_IA32_FEATURE_CONTROL) & 0x5) == 0x5);
+	wrmsr(MSR_IA32_FEATURE_CONTROL,
+		  FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX |
+		  FEATURE_CONTROL_LOCKED);
+
+	ia32_feature_control = rdmsr(MSR_IA32_FEATURE_CONTROL);
+	vmx_enabled =
+		ia32_feature_control & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
 	report("test enable VMX in FEATURE_CONTROL", vmx_enabled);
 
 	report("test FEATURE_CONTROL lock bit",
@@ -1922,6 +1932,7 @@ test_wanted(const char *name, const char *filters[], int filter_count)
 int main(int argc, const char *argv[])
 {
 	int i = 0;
+	bool vmx_enabled;
 
 	setup_vm();
 	smp_init();
@@ -1943,8 +1954,13 @@ int main(int argc, const char *argv[])
 		if (test_vmx_feature_control() != 0)
 			goto exit;
 	} else {
-		if ((rdmsr(MSR_IA32_FEATURE_CONTROL) & 0x5) != 0x5)
-			wrmsr(MSR_IA32_FEATURE_CONTROL, 0x5);
+		vmx_enabled = rdmsr(MSR_IA32_FEATURE_CONTROL) &
+			FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
+		if (!vmx_enabled) {
+			wrmsr(MSR_IA32_FEATURE_CONTROL,
+				  FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX |
+				  FEATURE_CONTROL_LOCKED);
+		}
 	}
 
 	if (test_wanted("test_vmxon", argv, argc)) {
-- 
2.20.1

