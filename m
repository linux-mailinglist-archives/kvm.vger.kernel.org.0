Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7DF194E2
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 23:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfEIVrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 17:47:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48968 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbfEIVrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 17:47:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49LihxY185862;
        Thu, 9 May 2019 21:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=ILnW0wsBivAJkm1XbUoPFgltWm+r7j/kZDMAfDd4L/Y=;
 b=miM7XTI63VOOmlnSechjN9cAWV2t/f0lXkAgxEg3Thyw4I5ebUNbH7f4pb0aPeMpfh4Y
 i3beZSLA4iDaQMh1bCxm/zfcO/KsrLeSA8PEncjhvvIruHkkpvGOfGc1NzFCYziuiqL2
 xsKu6oMgIdTseljXLz3K2Z9W6WlOpr5H4P9EOO+bIlxcygVWwU2kCIPl4g7yOBwi9NqJ
 lOZdPiLPxtFK2Z8kFhQ0pta+PHmLKdml+ZoFcIuH1Jkgq877aXorZB4Dd7pTUeVFKHUP
 qafDZPBayDIYuTesi9ja/BJLSyDnOwT++Bbd/86RCylIda/oThC6Js/7kmOZHlT3klee Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2s94b15nka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49LjC9r191548;
        Thu, 9 May 2019 21:46:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2schw032jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x49Lkv1Z032089;
        Thu, 9 May 2019 21:46:57 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 May 2019 14:46:57 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/4][kvm-unit-test nVMX]: Rename guest_pat_main to guest_state_test_main
Date:   Thu,  9 May 2019 17:20:52 -0400
Message-Id: <20190509212055.29933-2-krish.sadhukhan@oracle.com>
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
 x86/vmx_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index c01fa9d..ee96596 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4995,7 +4995,7 @@ static void test_sysenter_field(u32 field, const char *name)
 	vmcs_write(field, addr_saved);
 }
 
-static void guest_pat_main(void)
+static void guest_state_test_main(void)
 {
 	while (1) {
 		if (vmx_get_test_stage() != 2)
@@ -5097,7 +5097,7 @@ static void test_pat(u32 fld, const char * fld_name, u32 ctrl_fld, u64 ctrl_bit)
 	vmcs_clear_bits(ctrl_fld, ctrl_bit);
 	if (fld == GUEST_PAT) {
 		vmx_set_test_stage(1);
-		test_set_guest(guest_pat_main);
+		test_set_guest(guest_state_test_main);
 	}
 
 	for (i = 0; i < 256; i = (i < PAT_VAL_LIMIT) ? i + 1 : i * 2) {
-- 
2.20.1

