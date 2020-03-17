Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAC7188F3B
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 21:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCQUoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 16:44:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgCQUod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 16:44:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HKhXul045454;
        Tue, 17 Mar 2020 20:44:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Or6ulmNBLB/TI5MLSJANmm+PoQlvOs0NJ4zozZd8QoM=;
 b=iEVjvYfMh/9a8s7CMS/IeTvWS+55bHv4xYQEn9r2CbvQDPKJJSVJaVeE1IvCiKitY7Fr
 2cIVUasJ/tjZwI5la0xPUfHRMiLvCrUxW75fJfaaAmOriSydQ5MqT/Q1sbIeiJBgouCq
 ywSsXEVtSilAG6R4J+6mothn19ER5oQyxJWXwIY+zXQIF1tci+ooCGvqVnEyVa7WnIvL
 7/M9ZxFO383zDi0qvQj79LD9UMJz1T8qxLDjMV43rRi9J7mtrxe2++dPH1CDqDqrZ4WB
 kZJCod0WjXNMlAuZFq2pf+u7rWMG5L/D9AcDl1zqq4/aotV5Vn8XDShCeZRvTgQJ6WhL uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yrppr79n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 20:44:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HKcQ5C148739;
        Tue, 17 Mar 2020 20:44:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ys8yyx3b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 20:44:29 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02HKiTjq010736;
        Tue, 17 Mar 2020 20:44:29 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Tue, 17 Mar 2020 13:43:17 -0700
MIME-Version: 1.0
Message-ID: <20200317200537.21593-3-krish.sadhukhan@oracle.com>
Date:   Tue, 17 Mar 2020 13:05:36 -0700 (PDT)
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/3] kvm-unit-test: nSVM: Add helper functions to write and
 read vmcb fields
References: <20200317200537.21593-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20200317200537.21593-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=13
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=13 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c | 16 ++++++++++++++++
 x86/svm.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/x86/svm.c b/x86/svm.c
index 7ce33a6..3803032 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -233,6 +233,22 @@ int svm_vmrun(void)
 	return (vmcb->control.exit_code);
 }
 
+u64 vmcb_save_read64(size_t offset)
+{
+	u64 *ptr = (u64 *) ((char *) vmcb + offsetof(struct vmcb, save) +
+	    offset);
+
+       return (*ptr);
+}
+
+void vmcb_save_write64(size_t offset, u64 value)
+{
+	u64 *ptr = (u64 *) ((char *) vmcb + offsetof(struct vmcb, save) +
+	    offset);
+
+       *ptr = value;
+}
+
 static void test_run(struct svm_test *test)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
diff --git a/x86/svm.h b/x86/svm.h
index 25514de..3a6af6e 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -380,5 +380,7 @@ struct regs get_regs(void);
 void vmmcall(void);
 int svm_vmrun(void);
 void test_set_guest(test_guest_func func);
+u64 vmcb_save_read64(size_t offset);
+void vmcb_save_write64(size_t offset, u64 value);
 
 #endif
-- 
1.8.3.1

