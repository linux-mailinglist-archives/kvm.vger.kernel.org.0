Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1B7D6CA6
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfJOAw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:52:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59200 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfJOAwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:52:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0n2No188140;
        Tue, 15 Oct 2019 00:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=gqPM86jL7ujSnfBfEoGk3RGIHzFJd3Vua4/5hTs2+9s=;
 b=hUa+M5gW6X/Kud1iqTKzYJq4UOy1JXv+FKHJB8Y4cwYSvz6I5YerPpKrxRVsqvcjzFtD
 081vCp9BPrKz9SpPv9ryCCIVeUAI9+On9/mq0nlsCUmqDg2KnTSqzbUw0HJxEGAwut2v
 FiZ+U9XJbZQCFCCZ7nMANerJ3x+uKeT0B42Nh+dPik8vT6Ra1scPLwuRS70BRJzDtPwG
 w9o0tc98gHjeLTCr7goNjOzB8i3RrdYbLRW2BDYzHyV5CiJe2O5CV9dkc0p7DtNc4UJ5
 zUtpMt1S3wtjUcM/Hj6qJL+j+SmBbtC3Vj5dUO6/fWNveKY2RvsEk0C3qBQfLlatP2gS NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vk6sqcabc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0mv4G101047;
        Tue, 15 Oct 2019 00:52:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vkrbkw0de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9F0qboJ017529;
        Tue, 15 Oct 2019 00:52:37 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 00:52:37 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH 4/4] kvm-unit-test: nVMX: Use #defines for exit reason in advance_guest_state_test()
Date:   Mon, 14 Oct 2019 20:16:33 -0400
Message-Id: <20191015001633.8603-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
References: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=956
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index d68f0c0..759e24a 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5043,7 +5043,7 @@ static void guest_state_test_main(void)
 static void advance_guest_state_test(void)
 {
 	u32 reason = vmcs_read(EXI_REASON);
-	if (! (reason & 0x80000000)) {
+	if (! (reason & VMX_ENTRY_FAILURE)) {
 		u64 guest_rip = vmcs_read(GUEST_RIP);
 		u32 insn_len = vmcs_read(EXI_INST_LEN);
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
-- 
2.20.1

