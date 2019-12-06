Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F24D21159C8
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfLFXtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:49:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfLFXtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:49:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6NnYBc071647;
        Fri, 6 Dec 2019 23:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=YW0ykxR3RkN8p20JLhjIb9MWIh5JiNPZgI7LprIIDaI=;
 b=KqkUNei3KhJXB9xXPM+ep20pQgTsB1MfvnaDtnixN6PjErXfPEH6PquKU4g80Eim66eX
 K1q9vfuXKzF3HolOMDDbOxG7apepx4wCZ6L2MZ2OMWLHm78eyaemPK4cwRAbLjgnH41h
 Ecnvrro3uoBTJNFBB0p+qUO0ajfLzxzo3wyahQ8lbYF/0EKZkPV4IL5n+ZAH6kRJqclg
 wHBvjFmKAdDe3smQEQY/HadehsvNdrAZaqP3Lu8scsz4OIj1BcGlttvL+QRf0uWOMcg7
 kwjzfPY1N/5ZU0F5xnzgrqHYhBJi72cIokAqLU0TzPvkqmyVBgaPIuMD7VJAPyxodiaY Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wkh2rxt3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 23:49:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6NnVw1171207;
        Fri, 6 Dec 2019 23:49:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wqm0ud7ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 23:49:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB6Nnc04029764;
        Fri, 6 Dec 2019 23:49:39 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Dec 2019 15:49:38 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 3/4] kvm-unit-test: nVMX: Remove test_sysenter_field() and use test_canonical() instead
Date:   Fri,  6 Dec 2019 18:13:01 -0500
Message-Id: <20191206231302.3466-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
References: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=813
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=868 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060190
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  ..as the latter already does what the former does.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7905861..5f836d4 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6620,30 +6620,6 @@ static void virt_x2apic_mode_test(void)
 	assert_exit_reason(VMX_VMCALL);
 }
 
-/*
- * On processors that support Intel 64 architecture, the IA32_SYSENTER_ESP
- * field and the IA32_SYSENTER_EIP field must each contain a canonical
- * address.
- *
- *  [Intel SDM]
- */
-static void test_sysenter_field(u32 field, const char *name)
-{
-	u64 addr_saved = vmcs_read(field);
-
-	vmcs_write(field, NONCANONICAL);
-	report_prefix_pushf("%s non-canonical", name);
-	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-	report_prefix_pop();
-
-	vmcs_write(field, 0xffffffff);
-	report_prefix_pushf("%s canonical", name);
-	test_vmx_vmlaunch(0);
-	report_prefix_pop();
-
-	vmcs_write(field, addr_saved);
-}
-
 static void test_ctl_reg(const char *cr_name, u64 cr, u64 fixed0, u64 fixed1)
 {
 	u64 val;
@@ -7432,8 +7408,8 @@ static void vmx_host_state_area_test(void)
 
 	test_host_ctl_regs();
 
-	test_sysenter_field(HOST_SYSENTER_ESP, "HOST_SYSENTER_ESP");
-	test_sysenter_field(HOST_SYSENTER_EIP, "HOST_SYSENTER_EIP");
+	test_canonical(HOST_SYSENTER_ESP, "HOST_SYSENTER_ESP", true);
+	test_canonical(HOST_SYSENTER_EIP, "HOST_SYSENTER_EIP", true);
 
 	test_host_efer();
 	test_load_host_pat();
-- 
2.20.1

