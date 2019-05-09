Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5495F194DF
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 23:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfEIVrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 17:47:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfEIVrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 17:47:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49LiP2Q167641;
        Thu, 9 May 2019 21:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=hd70tYlMcjdgM84KL5FEKIqbP+hq+PffgStFpNuCJwI=;
 b=43Xi/4JMWWTUUV02XhV/Mk3Xnmbug4lCcDcBH9wfLMAd91yLIWMvsUYvQ0qCZqCt+GWW
 dOQOc9EAg2DZE+TeJypJibVj4jfFUykqN8yP2BokejrWEt+Kg/noJWuQIHao/35I04fN
 FsPFVLzPPUNQN9ZY8lex6kIdzrfUfuOTUjPW5A/CvrltRccZ0mQUnm6tKu9jxH0nmZC6
 1zkFV7B2+WpC22V0RvS/40ocLEq1zBp4OiEI4hVxG4mPerQkBS1yIbvFcIsjRrCqOp7y
 YRtGI2hcGyjbjoLDG2xFcRAbn/jhFsKS8QZq/70YoBMmWQXsr5WucqY5DcNOjtfp/emI rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2s94bgdp0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49Lj6YZ159159;
        Thu, 9 May 2019 21:46:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2scpy5wvjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x49LkvOd032092;
        Thu, 9 May 2019 21:46:57 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 May 2019 14:46:57 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/4][kvm-unit-test nVMX]: Rename report_guest_pat_test to report_guest_state_test
Date:   Thu,  9 May 2019 17:20:53 -0400
Message-Id: <20190509212055.29933-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
References: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905090123
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905090123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  ...so that it can be re-used by other tests.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ee96596..a339bb3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5007,13 +5007,14 @@ static void guest_state_test_main(void)
 	asm volatile("fnop");
 }
 
-static void report_guest_pat_test(const char *test, u32 xreason, u64 guest_pat)
+static void report_guest_state_test(const char *test, u32 xreason,
+				    u64 field, const char * field_name)
 {
 	u32 reason = vmcs_read(EXI_REASON);
 	u64 guest_rip;
 	u32 insn_len;
 
-	report("%s, GUEST_PAT %lx", reason == xreason, test, guest_pat);
+	report("%s, %s %lx", reason == xreason, test, field_name, field);
 
 	guest_rip = vmcs_read(GUEST_RIP);
 	insn_len = vmcs_read(EXI_INST_LEN);
@@ -5112,8 +5113,9 @@ static void test_pat(u32 fld, const char * fld_name, u32 ctrl_fld, u64 ctrl_bit)
 
 			} else {	// GUEST_PAT
 				__enter_guest(ABORT_ON_EARLY_VMENTRY_FAIL);
-				report_guest_pat_test("ENT_LOAD_PAT enabled",
-						       VMX_VMCALL, val);
+				report_guest_state_test("ENT_LOAD_PAT enabled",
+							VMX_VMCALL, val,
+							"GUEST_PAT");
 			}
 		}
 	}
@@ -5139,17 +5141,19 @@ static void test_pat(u32 fld, const char * fld_name, u32 ctrl_fld, u64 ctrl_bit)
 			} else {	// GUEST_PAT
 				if (i == 0x2 || i == 0x3 || i == 0x8) {
 					__enter_guest(ABORT_ON_EARLY_VMENTRY_FAIL);
-					report_guest_pat_test("ENT_LOAD_PAT "
-								"enabled",
+					report_guest_state_test("ENT_LOAD_PAT "
+							     "enabled",
 							     VMX_FAIL_STATE |
 							     VMX_ENTRY_FAILURE,
-							     val);
+							     val,
+							     "GUEST_PAT");
 				} else {
 					__enter_guest(ABORT_ON_EARLY_VMENTRY_FAIL);
-					report_guest_pat_test("ENT_LOAD_PAT "
+					report_guest_state_test("ENT_LOAD_PAT "
 							      "enabled",
 							      VMX_VMCALL,
-							      val);
+							      val,
+							      "GUEST_PAT");
 				}
 			}
 
-- 
2.20.1

