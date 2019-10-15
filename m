Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C259BD6CA2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfJOAwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:52:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58634 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfJOAwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:52:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0nILK014310;
        Tue, 15 Oct 2019 00:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=q+YiKeIY2xF6EGM7ufhqqTMFE16YcJb84j67MEUh+Ic=;
 b=PvQeyWpYrqlyjwTL9uXgZrXn0kd9AlVATI1tnZ3xkfmTVGsTE3Eae2R41GpRb4RrC54C
 HtssdsgeFqGHnFZYC/OalW+hp+nfq5gKsY94zI+KboB1zMxpdqkv3HP3mX1nXmBtb0RV
 SJA6sowNVJiMwLDya8LRMRj9LvftfTMfc7ffQdtqlLsK+ml3G8+vhwpUH5iHjz59Qtlo
 VhyGqZnst+fm+J2XUZLrZY+MGe7uieE5qCutRcHMX7akqB21/MvzGW0AiTYnV3023IUT
 6KR+V+EforyI8hy+tiOZCph34ClpAFIPFyrmY+P40j9Uup1PTXzwpsQs6OIBoxau0CTb 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vk68ucax3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0mCvh029357;
        Tue, 15 Oct 2019 00:52:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vkry7hbvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:37 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9F0qaLk020535;
        Tue, 15 Oct 2019 00:52:36 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 00:52:36 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH 1/4] kvm-unit-test: VMX: Replace hard-coded exit instruction length
Date:   Mon, 14 Oct 2019 20:16:30 -0400
Message-Id: <20191015001633.8603-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
References: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=740
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=823 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  ..with value read from EXI_INST_LEN field.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4aebc3f..7d73ee3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -87,6 +87,7 @@ static int vmenter_exit_handler(void)
 {
 	u64 guest_rip;
 	ulong reason;
+	u32 insn_len = vmcs_read(EXI_INST_LEN);
 
 	guest_rip = vmcs_read(GUEST_RIP);
 	reason = vmcs_read(EXI_REASON) & 0xff;
@@ -97,7 +98,7 @@ static int vmenter_exit_handler(void)
 			return VMX_TEST_VMEXIT;
 		}
 		regs.rax = 0xFFFF;
-		vmcs_write(GUEST_RIP, guest_rip + 3);
+		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
 		report("test vmresume", 0);
@@ -340,7 +341,9 @@ static int test_ctrl_pat_exit_handler(void)
 	u64 guest_rip;
 	ulong reason;
 	u64 guest_pat;
+	u32 insn_len;
 
+	insn_len = vmcs_read(EXI_INST_LEN);
 	guest_rip = vmcs_read(GUEST_RIP);
 	reason = vmcs_read(EXI_REASON) & 0xff;
 	switch (reason) {
@@ -357,7 +360,7 @@ static int test_ctrl_pat_exit_handler(void)
 		else
 			report("Exit load PAT", rdmsr(MSR_IA32_CR_PAT) == ia32_pat);
 		vmcs_write(GUEST_PAT, ia32_pat);
-		vmcs_write(GUEST_RIP, guest_rip + 3);
+		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
 		printf("ERROR : Undefined exit reason, reason = %ld.\n", reason);
@@ -407,7 +410,9 @@ static int test_ctrl_efer_exit_handler(void)
 	u64 guest_rip;
 	ulong reason;
 	u64 guest_efer;
+	u32 insn_len;
 
+	insn_len = vmcs_read(EXI_INST_LEN);
 	guest_rip = vmcs_read(GUEST_RIP);
 	reason = vmcs_read(EXI_REASON) & 0xff;
 	switch (reason) {
@@ -426,7 +431,7 @@ static int test_ctrl_efer_exit_handler(void)
 			report("Exit load EFER", rdmsr(MSR_EFER) == (ia32_efer ^ EFER_NX));
 		}
 		vmcs_write(GUEST_PAT, ia32_efer);
-		vmcs_write(GUEST_RIP, guest_rip + 3);
+		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
 		printf("ERROR : Undefined exit reason, reason = %ld.\n", reason);
@@ -2076,6 +2081,11 @@ static void disable_rdtscp_main(void)
 static int disable_rdtscp_exit_handler(void)
 {
 	unsigned int reason = vmcs_read(EXI_REASON) & 0xff;
+	u64 guest_rip;
+	u32 insn_len;
+
+	guest_rip = vmcs_read(GUEST_RIP);
+	insn_len = vmcs_read(EXI_INST_LEN);
 
 	switch (reason) {
 	case VMX_VMCALL:
@@ -2086,7 +2096,7 @@ static int disable_rdtscp_exit_handler(void)
 			/* fallthrough */
 		case 1:
 			vmx_inc_test_stage();
-			vmcs_write(GUEST_RIP, vmcs_read(GUEST_RIP) + 3);
+			vmcs_write(GUEST_RIP, guest_rip + insn_len);
 			return VMX_TEST_RESUME;
 		case 2:
 			report("RDPID triggers #UD", false);
-- 
2.20.1

