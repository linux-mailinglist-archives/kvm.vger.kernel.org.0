Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F117B4BDF3
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 18:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfFSQXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 12:23:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729061AbfFSQXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 12:23:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JGDmuS130849;
        Wed, 19 Jun 2019 16:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=F+Gcfp9dlPhla7i45Van9Vb6VGMrUmjoVKTqLpj7sQE=;
 b=Bsul6HY4C0qKV6VafRfLbcqHCusygoQDzerPepsKKJui7qEfZvahulBsQ0Bzko5uc/x9
 k0ra+naBc2nphYJmHK8UOql5MyGfVLxFEhIAy60Kr00om6LxO32uOZVSrLMVYCP8hVBH
 0+/zcpZeBMAJQofIiHF3AKYuMg0WoRuX27kko7hvzN2FwpAll5EKyoR205SQnBl5yQM6
 7OuQGfBzV5yuIXpNhX3jUNRj3Te+/KwnNgGoQReZZyPySLOdYRkPe2vTh2563rMtnSbS
 wdra7zSBvzahL1x8i9iSav0G6ODxHz8MnqG0rZgmi/KqbbQPX2cTu0ihn6jK/SeHGd7B 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t7809cfpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 16:22:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JGLER3187116;
        Wed, 19 Jun 2019 16:22:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t77yn6nwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 16:22:09 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5JGM8Yu000727;
        Wed, 19 Jun 2019 16:22:08 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 09:22:08 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, kvm@vger.kernel.org, jmattson@google.com,
        maran.wilson@oracle.com, dgilbert@redhat.com,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [QEMU PATCH v4 03/10] target/i386: kvm: Use symbolic constant for #DB/#BP exception constants
Date:   Wed, 19 Jun 2019 19:21:33 +0300
Message-Id: <20190619162140.133674-4-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619162140.133674-1-liran.alon@oracle.com>
References: <20190619162140.133674-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=913
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=952 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190131
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
index efbecfc9d7f0..7b3b80833fdd 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -3009,9 +3009,9 @@ static int kvm_guest_debug_workarounds(X86CPU *cpu)
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
@@ -3523,8 +3523,8 @@ static int kvm_handle_debug(X86CPU *cpu,
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

