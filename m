Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E7C8A97F
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 23:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfHLVj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 17:39:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfHLVj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 17:39:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CLXwIt043320;
        Mon, 12 Aug 2019 21:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=wKzANzeArf+pHxJ0YOpVNV2QTB/B/kf+dVJDoah4JJg=;
 b=BdJHVeXFa2rlKKGEprMqZlDcA9rOOeS0FsdxAyGzwEl7UFXF1ANNrDdzkmZxOTMfl9pI
 bt3R4qCs3eFXwpQ0E47q9Bqgpr2sfS8uN5CUvYWG05oyWKHyy6ylPR0usLzbwCbWjgvs
 cLa/u8dzYZ8blQF0iyzxmsMSR8wtDP3H/9MYqSjswBqaCgdqCmglfqQzywC1aukSmonv
 xQvlbLVsq2zYHTW1GXwoeHA5xWOLhAiN/DgjpqlXy2Jxxbqf0mAZMKyFlXKrczw0xWPZ
 u0J7F4eH9pt9xmCI4ZxeMEu5fe8hRBdBrlN0j1k9nqqBoO2p7F4OyaF90TfjA2bqsjW9 OA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=wKzANzeArf+pHxJ0YOpVNV2QTB/B/kf+dVJDoah4JJg=;
 b=qbXU3F7NKhjhJPEd2gPDTYJuODL4/TN+d6nrWhDfp0xGhXCd7O+pNZz8FblxNGfUVjTd
 VSS1+AY1YGolqczdTlG6mpnFKveWSsOU8FTnAwL6j0L6d6cc1rhK/gyQHgU7uz/hdzvP
 1vnkFNu3Xfw1Bcq0hXCtxHjO+DjbqgLnaj+FWu2rNWLad0tYpo0kftlF1ahnI/0QmDtn
 DBK4ERtUIMYDA8xvVL4FmFdxZVqL1d+6vVlXalALKxTFNTJcpnNLcKyo6GZ/qhxB9Drf
 cc4L/AatK4XCORCBduLwfevQNx74SGZl7bOx8qT/F2Ed/PHSF4/bUPwwbTmp4w5ixV0h fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvp2a5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 21:39:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CLboU0133029;
        Mon, 12 Aug 2019 21:39:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u9n9hc82v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 21:39:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CLd4H1006850;
        Mon, 12 Aug 2019 21:39:04 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 14:39:03 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH] kvm-unit-test: nVMX: Fix 95d6d2c32288 ("nVMX: Test Host Segment Registers and Descriptor Tables on vmentry of nested guests")
Date:   Mon, 12 Aug 2019 17:11:08 -0400
Message-Id: <20190812211108.17186-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=752
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=806 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120207
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 95d6d2c32288 added a test for the Segment Selector VMCS field. That test
sets the "host address-space size" VM-exit control to zero and as a result, on
VM-exit the guest exits as 32-bit. Since vmx tests are 64-bit, this results in
a hardware error.
This patch also cleans up a few other areas in commit 95d6d2c32288, including
replacing make_non_canonical() with NONCANONICAL.

Reported-by: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Krish Sadhukhan <kris.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 lib/x86/processor.h |  5 ---
 x86/vmx_tests.c     | 76 ++++++++++++++++++++-------------------------
 2 files changed, 33 insertions(+), 48 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 8b8bb7a..4fef0bc 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -461,11 +461,6 @@ static inline void write_pkru(u32 pkru)
         : : "a" (eax), "c" (ecx), "d" (edx));
 }
 
-static inline u64 make_non_canonical(u64 addr)
-{
-	return (addr | 1ull << 48);
-}
-
 static inline bool is_canonical(u64 addr)
 {
 	return (s64)(addr << 16) >> 16 == addr;
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 8ad2674..e115e48 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6952,15 +6952,14 @@ static void test_load_host_pat(void)
 }
 
 /*
- * Test a value for the given VMCS field.
- *
- *  "field" - VMCS field
- *  "field_name" - string name of VMCS field
- *  "bit_start" - starting bit
- *  "bit_end" - ending bit
- *  "val" - value that the bit range must or must not contain
- *  "valid_val" - whether value given in 'val' must be valid or not
- *  "error" - expected VMCS error when vmentry fails for an invalid value
+ * test_vmcs_field - test a value for the given VMCS field
+ * @field: VMCS field
+ * @field_name: string name of VMCS field
+ * @bit_start: starting bit
+ * @bit_end: ending bit
+ * @val: value that the bit range must or must not contain
+ * @valid_val: whether value given in 'val' must be valid or not
+ * @error: expected VMCS error when vmentry fails for an invalid value
  */
 static void test_vmcs_field(u64 field, const char *field_name, u32 bit_start,
 			    u32 bit_end, u64 val, bool valid_val, u32 error)
@@ -7004,16 +7003,14 @@ static void test_vmcs_field(u64 field, const char *field_name, u32 bit_start,
 static void test_canonical(u64 field, const char * field_name)
 {
 	u64 addr_saved = vmcs_read(field);
-	u64 addr = addr_saved;
 
-	report_prefix_pushf("%s %lx", field_name, addr);
-	if (is_canonical(addr)) {
+	report_prefix_pushf("%s %lx", field_name, addr_saved);
+	if (is_canonical(addr_saved)) {
 		test_vmx_vmlaunch(0, false);
 		report_prefix_pop();
 
-		addr = make_non_canonical(addr);
-		vmcs_write(field, addr);
-		report_prefix_pushf("%s %lx", field_name, addr);
+		vmcs_write(field, NONCANONICAL);
+		report_prefix_pushf("%s %llx", field_name, NONCANONICAL);
 		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
 				  false);
 
@@ -7025,6 +7022,14 @@ static void test_canonical(u64 field, const char * field_name)
 	report_prefix_pop();
 }
 
+#define TEST_RPL_TI_FLAGS(reg, name)				\
+	test_vmcs_field(reg, name, 0, 2, 0x0, true,		\
+			VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+
+#define TEST_CS_TR_FLAGS(reg, name)				\
+	test_vmcs_field(reg, name, 3, 15, 0x0000, false,	\
+			VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+
 /*
  * 1. In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
  *    RPL (bits 1:0) and the TI flag (bit 2) must be 0.
@@ -7036,34 +7041,24 @@ static void test_canonical(u64 field, const char * field_name)
  */
 static void test_host_segment_regs(void)
 {
-	u32 exit_ctrl_saved = vmcs_read(EXI_CONTROLS);
 	u16 selector_saved;
 
 	/*
 	 * Test RPL and TI flags
 	 */
-	test_vmcs_field(HOST_SEL_CS, "HOST_SEL_CS", 0, 2, 0x0, true,
-		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-	test_vmcs_field(HOST_SEL_SS, "HOST_SEL_SS", 0, 2, 0x0, true,
-		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-	test_vmcs_field(HOST_SEL_DS, "HOST_SEL_DS", 0, 2, 0x0, true,
-		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-	test_vmcs_field(HOST_SEL_ES, "HOST_SEL_ES", 0, 2, 0x0, true,
-		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-	test_vmcs_field(HOST_SEL_FS, "HOST_SEL_FS", 0, 2, 0x0, true,
-		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-	test_vmcs_field(HOST_SEL_GS, "HOST_SEL_GS", 0, 2, 0x0, true,
-		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-	test_vmcs_field(HOST_SEL_TR, "HOST_SEL_TR", 0, 2, 0x0, true,
-		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+	TEST_RPL_TI_FLAGS(HOST_SEL_CS, "HOST_SEL_CS");
+	TEST_RPL_TI_FLAGS(HOST_SEL_SS, "HOST_SEL_SS");
+	TEST_RPL_TI_FLAGS(HOST_SEL_DS, "HOST_SEL_DS");
+	TEST_RPL_TI_FLAGS(HOST_SEL_ES, "HOST_SEL_ES");
+	TEST_RPL_TI_FLAGS(HOST_SEL_FS, "HOST_SEL_FS");
+	TEST_RPL_TI_FLAGS(HOST_SEL_GS, "HOST_SEL_GS");
+	TEST_RPL_TI_FLAGS(HOST_SEL_TR, "HOST_SEL_TR");
 
 	/*
 	 * Test that CS and TR fields can not be 0x0000
 	 */
-	test_vmcs_field(HOST_SEL_CS, "HOST_SEL_CS", 3, 15, 0x0000, false,
-			     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-	test_vmcs_field(HOST_SEL_TR, "HOST_SEL_TR", 3, 15, 0x0000, false,
-			     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+	TEST_CS_TR_FLAGS(HOST_SEL_CS, "HOST_SEL_CS");
+	TEST_CS_TR_FLAGS(HOST_SEL_TR, "HOST_SEL_TR");
 
 	/*
 	 * SS field can not be 0x0000 if "host address-space size" VM-exit
@@ -7071,20 +7066,15 @@ static void test_host_segment_regs(void)
 	 */
 	selector_saved = vmcs_read(HOST_SEL_SS);
 	vmcs_write(HOST_SEL_SS, 0);
-	if (exit_ctrl_saved & EXI_HOST_64) {
-		report_prefix_pushf("HOST_SEL_SS 0");
+	report_prefix_pushf("HOST_SEL_SS 0");
+	if (vmcs_read(EXI_CONTROLS) & EXI_HOST_64) {
 		test_vmx_vmlaunch(0, false);
-		report_prefix_pop();
-
-		vmcs_write(EXI_CONTROLS, exit_ctrl_saved & ~EXI_HOST_64);
+	} else {
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
 	}
-
-	report_prefix_pushf("HOST_SEL_SS 0");
-	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
 	report_prefix_pop();
 
 	vmcs_write(HOST_SEL_SS, selector_saved);
-	vmcs_write(EXI_CONTROLS, exit_ctrl_saved);
 
 #ifdef __x86_64__
 	/*
-- 
2.20.1

