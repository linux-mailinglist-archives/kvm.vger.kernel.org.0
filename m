Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221AE188DD2
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 20:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCQTPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 15:15:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgCQTPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 15:15:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HJD34Y020899;
        Tue, 17 Mar 2020 19:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rOOsSiks5gEH+WKOn7GSUYyMKiAsXTsxMf1t9nUy2dY=;
 b=G3KLpRgJAqFJlqJRgmDsAsU/5D/1ZVagOLG2SIoXML48znE6iwPWGWAyiXHT4WX+EG1z
 dzfFxTDASZRYaRx029rFtPYZGuwsv2CCQB07eSFqkMxdRSSo4OQz+pI0zyhSxpaK3Slh
 gWS5zIqk2r+ylGnFMPI/W+4tGp0Oh3ZbS1xdxYpqSQZY/1Gzlyy7sR8RW68GRI4vl0Tb
 fwaqYAJCTLSZs6gb73ScLJhzQdhndbp1s4KJWshxb/WNJip2OcQHmNYFYg/3K8DRH7r2
 BjYMNdii+h/sOpwTX5szSOWzRpvLbIOklUm16pwHeFQKMeAX4bLVUDWZDeAQNVq3U/H6 wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yrq7kxt8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 19:15:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HJCSRM103933;
        Tue, 17 Mar 2020 19:15:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ys8yysrr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 19:15:47 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02HJFkT1024868;
        Tue, 17 Mar 2020 19:15:46 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Mar 2020 12:15:46 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/2 v2] kvm-unit-test: nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of nested guests
Date:   Tue, 17 Mar 2020 19:15:30 +0000
Message-Id: <1584472530-31728-3-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584472530-31728-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1584472530-31728-1-git-send-email-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=13
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=13
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Control Registers, Debug Registers,
and MSRs" in Intel SDM vol 3C, the following checks are performed on
vmentry of nested guests:

    If the "load IA32_BNDCFGS" VM-entry control is 1, the following
    checks are performed on the field for the IA32_BNDCFGS MSR:

      —  Bits reserved in the IA32_BNDCFGS MSR must be 0.
      —  The linear address in bits 63:12 must be canonical.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0ae0046..7a37c37 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7606,6 +7606,50 @@ static void test_load_guest_pat(void)
 	test_pat(GUEST_PAT, "GUEST_PAT", ENT_CONTROLS, ENT_LOAD_PAT);
 }
 
+#define MSR_IA32_BNDCFGS_RSVD_MASK	0x00000ffc
+
+/*
+ * If the “load IA32_BNDCFGS” VM-entry control is 1, the following
+ * checks are performed on the field for the IA32_BNDCFGS MSR:
+ *
+ *   —  Bits reserved in the IA32_BNDCFGS MSR must be 0.
+ *   —  The linear address in bits 63:12 must be canonical.
+ *
+ *  [Intel SDM]
+ */
+static void test_load_guest_bndcfgs(void)
+{
+	u64 bndcfgs_saved = vmcs_read(GUEST_BNDCFGS);
+	u64 bndcfgs;
+
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_BNDCFGS)) {
+		printf("\"Load-IA32-BNDCFGS\" entry control not supported\n");
+		return;
+	}
+
+	vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_BNDCFGS);
+
+	vmcs_write(GUEST_BNDCFGS, NONCANONICAL);
+	test_guest_state("ENT_LOAD_BNDCFGS disabled", false,
+			 GUEST_BNDCFGS, "GUEST_BNDCFGS");
+	bndcfgs = bndcfgs_saved | MSR_IA32_BNDCFGS_RSVD_MASK;
+	vmcs_write(GUEST_BNDCFGS, bndcfgs);
+	test_guest_state("ENT_LOAD_BNDCFGS disabled", false,
+			 GUEST_BNDCFGS, "GUEST_BNDCFGS");
+
+	vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_BNDCFGS);
+
+	vmcs_write(GUEST_BNDCFGS, NONCANONICAL);
+	test_guest_state("ENT_LOAD_BNDCFGS enabled", true,
+			 GUEST_BNDCFGS, "GUEST_BNDCFGS");
+	bndcfgs = bndcfgs_saved | MSR_IA32_BNDCFGS_RSVD_MASK;
+	vmcs_write(GUEST_BNDCFGS, bndcfgs);
+	test_guest_state("ENT_LOAD_BNDCFGS enabled", true,
+			 GUEST_BNDCFGS, "GUEST_BNDCFGS");
+
+	vmcs_write(GUEST_BNDCFGS, bndcfgs_saved);
+}
+
 /*
  * Check that the virtual CPU checks the VMX Guest State Area as
  * documented in the Intel SDM.
@@ -7626,6 +7670,7 @@ static void vmx_guest_state_area_test(void)
 	test_load_guest_pat();
 	test_guest_efer();
 	test_load_guest_perf_global_ctrl();
+	test_load_guest_bndcfgs();
 
 	/*
 	 * Let the guest finish execution
-- 
1.8.3.1

