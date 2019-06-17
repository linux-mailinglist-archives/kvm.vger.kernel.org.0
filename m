Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5D348AE4
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 19:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfFQR6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 13:58:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbfFQR6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 13:58:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HHrrVe054554;
        Mon, 17 Jun 2019 17:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=PUudmWsO4oM3kj7HanyTpVYm25ckjUYuN03qqDaTqkA=;
 b=kFjhk5JP/Vc8LXAl38ckoSgczXRAvvucm5IeSb5xT8uEa0tuF3HrHT3Do6SsDUNll5mx
 SEbVS67Wto3MB2Sfg2Yzodze+fe85gjyJ7gd3PmhxmHTIpsdf4Gkzb7qstOp1dCcmG0R
 RNYDCjvxmRoQVsOazS4KANvpcZSufn5hZRhcl2FbLmZrK0C3bKw7d632BkYfonaC9lM2
 wvC1DKL1XpdarNExIsKFrx5naeAna7d9az5j1QbYp3qL4arRuI/DLoTGDIdZahmipbAZ
 5hGRPhcYcMDmv6yHMvr7BtGh0Fw54m5zFc9pgY1dPvc9ZR8LO7l/9mQ4iv2yoD++Z3UU SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t4rmnyx8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 17:57:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HHvWQp130477;
        Mon, 17 Jun 2019 17:57:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t59gdc0gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 17:57:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5HHvQWE002589;
        Mon, 17 Jun 2019 17:57:26 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 10:57:26 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, kvm@vger.kernel.org, jmattson@google.com,
        maran.wilson@oracle.com, dgilbert@redhat.com,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [QEMU PATCH v3 2/9] KVM: i386: Use symbolic constant for #DB/#BP exception constants
Date:   Mon, 17 Jun 2019 20:56:51 +0300
Message-Id: <20190617175658.135869-3-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190617175658.135869-1-liran.alon@oracle.com>
References: <20190617175658.135869-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=914
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=953 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 target/i386/kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 29889aa6b001..738dd91ff3cc 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -3006,9 +3006,9 @@ static int kvm_guest_debug_workarounds(X86CPU *cpu)
     unsigned long reinject_trap = 0;
 
     if (!kvm_has_vcpu_events()) {
-        if (env->exception_injected == 1) {
+        if (env->exception_injected == EXCP01_DB) {
             reinject_trap = KVM_GUESTDBG_INJECT_DB;
-        } else if (env->exception_injected == 3) {
+        } else if (env->exception_injected == EXCP03_INT3) {
             reinject_trap = KVM_GUESTDBG_INJECT_BP;
         }
         env->exception_injected = -1;
@@ -3520,8 +3520,8 @@ static int kvm_handle_debug(X86CPU *cpu,
     int ret = 0;
     int n;
 
-    if (arch_info->exception == 1) {
-        if (arch_info->dr6 & (1 << 14)) {
+    if (arch_info->exception == EXCP01_DB) {
+        if (arch_info->dr6 & DR6_BS) {
             if (cs->singlestep_enabled) {
                 ret = EXCP_DEBUG;
             }
-- 
2.20.1

