Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F56A1159C6
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfLFXtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:49:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35608 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfLFXtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:49:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6NnSNk074783;
        Fri, 6 Dec 2019 23:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=dHHKRfH7Bu5v/VX5yzfDwHdYAJrduNKU2JguT5uhnCs=;
 b=YRfJhRhRehJjnFeni5SjlH+QZH42145S3NquSGM2Zsl5tjIsRn/a5la0Oj5C1ehktLoF
 qsC3dnl4MgZdiEjwfpdh0wzlx5wk9Widsm06uNMKJB4ewEfqt+Sf1RKITLMCYXuDThW7
 qNJrwuKxpLfiFKdcwbgk1UNAxht8VBZ2bGDM1XvS9dN5kG7fehvlkRVAkfQaWwdSZ/bZ
 rjmLF+e4ATR2RdHZEt4D6cT04NjNpEjRtFesHq3kcItngWWeUvByXoOkKPS4vZ86dhkv
 NYXozOymmkfvHwVKmyKjlNv2JRoKDtiPgY5cCUJxsoZkk3k+wKV8KixdEi9wPBgxVmLO XQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wkgcqxufb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 23:49:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6NnVUe171261;
        Fri, 6 Dec 2019 23:49:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wqm0ud7hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 23:49:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB6Nnc8Q004115;
        Fri, 6 Dec 2019 23:49:38 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Dec 2019 15:49:38 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/4] kvm-unit-test: nVMX: Modify test_canonical() to process guest fields also
Date:   Fri,  6 Dec 2019 18:13:00 -0500
Message-Id: <20191206231302.3466-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
References: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060190
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhkan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 54 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a456bd1..7905861 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7232,24 +7232,52 @@ static void test_vmcs_field(u64 field, const char *field_name, u32 bit_start,
 	vmcs_write(field, field_saved);
 }
 
-static void test_canonical(u64 field, const char * field_name)
+static void test_canonical(u64 field, const char * field_name, bool host)
 {
 	u64 addr_saved = vmcs_read(field);
 
-	report_prefix_pushf("%s %lx", field_name, addr_saved);
 	if (is_canonical(addr_saved)) {
-		test_vmx_vmlaunch(0);
-		report_prefix_pop();
+		if (host) {
+			report_prefix_pushf("%s %lx", field_name, addr_saved);
+			test_vmx_vmlaunch(0);
+			report_prefix_pop();
+		} else {
+			enter_guest();
+			report_guest_state_test("%s",
+						VMX_VMCALL, addr_saved,
+						"GUEST_XXXXXXX");
+		}
 
 		vmcs_write(field, NONCANONICAL);
-		report_prefix_pushf("%s %llx", field_name, NONCANONICAL);
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+
+		if (host) {
+			report_prefix_pushf("%s %llx", field_name, NONCANONICAL);
+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+			report_prefix_pop();
+		} else {
+			enter_guest_with_invalid_guest_state();
+			report_guest_state_test("ENT_LOAD_PAT "
+					        "enabled",
+					        VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
+					        addr_saved,
+					        "GUEST_PAT");
+		}
 
 		vmcs_write(field, addr_saved);
 	} else {
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+		if (host) {
+			report_prefix_pushf("%s %llx", field_name, NONCANONICAL);
+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+			report_prefix_pop();
+		} else {
+			enter_guest_with_invalid_guest_state();
+			report_guest_state_test("ENT_LOAD_PAT "
+					        "enabled",
+					        VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
+					        addr_saved,
+					        "GUEST_PAT");
+		}
 	}
-	report_prefix_pop();
 }
 
 #define TEST_RPL_TI_FLAGS(reg, name)				\
@@ -7310,9 +7338,9 @@ static void test_host_segment_regs(void)
 	/*
 	 * Base address for FS, GS and TR must be canonical
 	 */
-	test_canonical(HOST_BASE_FS, "HOST_BASE_FS");
-	test_canonical(HOST_BASE_GS, "HOST_BASE_GS");
-	test_canonical(HOST_BASE_TR, "HOST_BASE_TR");
+	test_canonical(HOST_BASE_FS, "HOST_BASE_FS", true);
+	test_canonical(HOST_BASE_GS, "HOST_BASE_GS", true);
+	test_canonical(HOST_BASE_TR, "HOST_BASE_TR", true);
 #endif
 }
 
@@ -7323,8 +7351,8 @@ static void test_host_segment_regs(void)
 static void test_host_desc_tables(void)
 {
 #ifdef __x86_64__
-	test_canonical(HOST_BASE_GDTR, "HOST_BASE_GDTR");
-	test_canonical(HOST_BASE_IDTR, "HOST_BASE_IDTR");
+	test_canonical(HOST_BASE_GDTR, "HOST_BASE_GDTR", true);
+	test_canonical(HOST_BASE_IDTR, "HOST_BASE_IDTR", true);
 #endif
 }
 
-- 
2.20.1

