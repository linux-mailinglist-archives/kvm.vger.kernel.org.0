Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D377988381
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 21:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHITzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 15:55:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbfHITzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 15:55:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79JsDhm004085;
        Fri, 9 Aug 2019 19:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=3cLipeOeq4Abj15327yswiVZfcW4l0akhsgTjfMliOc=;
 b=lMmSloRBwII7lyyyeGrsTvknVXYnyXJAeVSWryeeI91+uCBR5mD+QB60L2w5/6e71WsG
 LdiU44UbdIaaLKTWskT91tFX8JYOGHSKRMuImwwsoXdWAIc9cl5JhkkWhuiipMWxNgQa
 FL5eg0NiIiygN1H/h7mDnTeO8DY1EQ+tfhVwi8+2RaWcQfNyh/0PrF3NlrBxOcPZ2OVW
 BqVKomV+cC6ncakfa12bA1wD7S0zUNHkruLXjNWkHY90V3Bp0fE48ZH28DFFUZ8mWXdY
 a8Vl8wL99VGDnopjzeiOZFSyqg4CFMO1LjaG6ZnlnsceQ4O4SWIkpJgXB+P1wrQ9aCQI MQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=3cLipeOeq4Abj15327yswiVZfcW4l0akhsgTjfMliOc=;
 b=LuUkkhUe3vB2G3K9z4RswJI8QTaJw/WiEMC3qbISMfAohsy9h7f12r07mlnelbgsr+HV
 JP6iYcjKPHLphNlfv87nL3RuSF4xCqWlPCtmzFuqqI6V5jkey4wp3UNVKcp1T/OMnQXV
 WmVZj/+LfuqKZRCFTLpp3j2UeRzO71nYCmAUMpwKS1g91PbYMLPr77g7AMaEP2ufvcJM
 Dx2o3+Tg1JKnN8Syhso8xhtx+E85vZOtPSEVEs6NI07rjiAa/xE9+VtM69l/HcJBc6X2
 OpJpTUHTzwdIknwA8UH2Lnd9CoJCX5vXcG2PIFxMwt1yWrUtNiwPo41BsxoQHq/gMCPu nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u8hgp9ts1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:54:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79Jr7F2162453;
        Fri, 9 Aug 2019 19:54:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u8pj9gj2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:54:39 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79Jschr017989;
        Fri, 9 Aug 2019 19:54:38 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Fri, 09 Aug 2019 12:54:21 -0700
MIME-Version: 1.0
Message-ID: <20190809192620.29318-3-krish.sadhukhan@oracle.com>
Date:   Fri, 9 Aug 2019 12:26:20 -0700 (PDT)
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/2] kvm-unit-test: nVMX: Check Host Address Space Size on
 vmentry of nested guests
References: <20190809192620.29318-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20190809192620.29318-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090195
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks Related to Address-Space Size" in Intel SDM vol
3C, the following checks are performed on vmentry of nested guests:

    If the "host address-space size" VM-exit control is 0, the following must
    hold:
	- The "IA-32e mode guest" VM-entry control is 0.
	- Bit 17 of the CR4 field (corresponding to CR4.PCIDE) is 0.
	- Bits 63:32 in the RIP field are 0.

    If the "host address-space size" VM-exit control is 1, the following must
    hold:
	- Bit 5 of the CR4 field (corresponding to CR4.PAE) is 1.
	- The RIP field contains a canonical address.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 8ad2674..fae00d3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7108,6 +7108,68 @@ static void test_host_desc_tables(void)
 #endif
 }
 
+/*
+ * If the "host address-space size" VM-exit control is 0, the following must
+ * hold:
+ *    - The "IA-32e mode guest" VM-entry control is 0.
+ *    - Bit 17 of the CR4 field (corresponding to CR4.PCIDE) is 0.
+ *    - Bits 63:32 in the RIP field are 0.
+ *
+ * If the "host address-space size" VM-exit control is 1, the following must
+ * hold:
+ *    - Bit 5 of the CR4 field (corresponding to CR4.PAE) is 1.
+ *    - The RIP field contains a canonical address.
+ *
+ */
+static void test_host_addr_size(void)
+{
+	u64 cr4_saved = vmcs_read(HOST_CR4);
+	u64 rip_saved = vmcs_read(HOST_RIP);
+	u64 entry_ctrl_saved = vmcs_read(ENT_CONTROLS);
+	int i;
+	u64 tmp;
+
+	if (vmcs_read(EXI_CONTROLS) & EXI_HOST_64) {
+		vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
+		report_prefix_pushf("\"IA-32e mode guest\" enabled");
+		test_vmx_vmlaunch(0, false);
+		report_prefix_pop();
+
+		vmcs_write(HOST_CR4, cr4_saved | X86_CR4_PCIDE);
+		report_prefix_pushf("\"CR4.PCIDE\" set");
+		test_vmx_vmlaunch(0, false);
+		report_prefix_pop();
+
+		for (i = 32; i <= 63; i = i + 4) {
+			tmp = rip_saved | 1ull << i;
+			vmcs_write(HOST_RIP, tmp);
+			report_prefix_pushf("HOST_RIP %lx", tmp);
+			test_vmx_vmlaunch(0, false);
+			report_prefix_pop();
+		}
+
+		if (cr4_saved & X86_CR4_PAE) {
+			vmcs_write(HOST_CR4, cr4_saved  & ~X86_CR4_PAE);
+			report_prefix_pushf("\"CR4.PAE\" unset");
+			test_vmx_vmlaunch(
+				VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
+		} else {
+			report_prefix_pushf("\"CR4.PAE\" set");
+			test_vmx_vmlaunch(0, false);
+		}
+		report_prefix_pop();
+
+		vmcs_write(HOST_RIP, NONCANONICAL);
+		report_prefix_pushf("HOST_RIP %llx", NONCANONICAL);
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
+		report_prefix_pop();
+
+		vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
+		vmcs_write(HOST_RIP, rip_saved);
+		vmcs_write(HOST_CR4, cr4_saved);
+	}
+}
+
 /*
  * Check that the virtual CPU checks the VMX Host State Area as
  * documented in the Intel SDM.
@@ -7130,6 +7192,7 @@ static void vmx_host_state_area_test(void)
 	test_load_host_pat();
 	test_host_segment_regs();
 	test_host_desc_tables();
+	test_host_addr_size();
 }
 
 /*
-- 
2.20.1

