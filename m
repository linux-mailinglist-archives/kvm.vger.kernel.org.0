Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AEE5BEDC9
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 21:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiITTae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 15:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiITTac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 15:30:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF17419A3;
        Tue, 20 Sep 2022 12:30:31 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KJQwe3031857;
        Tue, 20 Sep 2022 19:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=yJs8gEoJfAHlEeAkD9cNauZ8f84x1nCZ2qm0z8D/NkI=;
 b=KoISAPMhlQrSRHhS89wFg3XPadsCy3jWPqfQusBR6bWhTT9VBJwBYcE8IznmbwIYX8xL
 gZvau8MZwB/TgX5g2+jFloEuhVHgJBXqLMUFq5R4sORvQtx17cck6rRcJq93vuyBq+nJ
 CCM5rzCZEafgpZcJfk1fuBVWWQyg9wtsbbvYRg+R4ZYYNgYauZHsZmNl0Hj+VeWf5vqR
 NuFmG/KpVi/Zz2+ls9Zeu/pm7eo9EHtb592/zyhJJxlfqNDtC8VhqSN5A/xYDvEuH/4F
 b5XwukGxG0U59wjc8dqXF8ToZuK7p/4lLK5jdOAECxTqp6L4Uldd/ocXEKDNKkaOetht 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqkfa0mfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:30:31 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28KJCFMQ039502;
        Tue, 20 Sep 2022 19:30:30 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqkfa0mf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:30:30 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28KJL6at018138;
        Tue, 20 Sep 2022 19:30:29 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 3jn5v9k2k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:30:29 +0000
Received: from smtpav06.wdc07v.mail.ibm.com ([9.208.128.115])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28KJUSgK40370432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 19:30:28 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F08465806A;
        Tue, 20 Sep 2022 19:30:27 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0189E58071;
        Tue, 20 Sep 2022 19:30:26 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.65.230.56])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 19:30:25 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: pci: register pci hooks without interpretation
Date:   Tue, 20 Sep 2022 15:30:25 -0400
Message-Id: <20220920193025.135655-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RXSrdCmhULqULPaBKfhyzSPImvrIqLhg
X-Proofpoint-GUID: 3oKdLWS0d4IOIW2Yv87Lb2fIPIp4wpEJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_09,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=970 malwarescore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm registration hooks must be registered even if the facilities
necessary for zPCI interpretation are unavailable, as vfio-pci-zdev will
expect to use the hooks regardless.
This fixes an issue where vfio-pci-zdev will fail its open function
because of a missing kvm_register when running on hardware that does not
support zPCI interpretation.

Fixes: ca922fecda6c ("KVM: s390: pci: Hook to access KVM lowlevel from VFIO")
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c |  4 ++--
 arch/s390/kvm/pci.c      | 14 +++++++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e20e126944aa..5c7f5f97ea09 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -510,7 +510,7 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
-	if (kvm_s390_pci_interp_allowed()) {
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
 		rc = kvm_s390_pci_init();
 		if (rc) {
 			pr_err("Unable to allocate AIFT for PCI\n");
@@ -532,7 +532,7 @@ int kvm_arch_init(void *opaque)
 void kvm_arch_exit(void)
 {
 	kvm_s390_gib_destroy();
-	if (kvm_s390_pci_interp_allowed())
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
 		kvm_s390_pci_exit();
 	debug_unregister(kvm_s390_dbf);
 	debug_unregister(kvm_s390_dbf_uv);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 90aaba80696a..c50c1645c0ae 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -672,23 +672,31 @@ int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
 
 int kvm_s390_pci_init(void)
 {
+	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
+	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
+
+	if (!kvm_s390_pci_interp_allowed())
+		return 0;
+
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
 	if (!aift)
 		return -ENOMEM;
 
 	spin_lock_init(&aift->gait_lock);
 	mutex_init(&aift->aift_lock);
-	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
-	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
 
 	return 0;
 }
 
 void kvm_s390_pci_exit(void)
 {
-	mutex_destroy(&aift->aift_lock);
 	zpci_kvm_hook.kvm_register = NULL;
 	zpci_kvm_hook.kvm_unregister = NULL;
 
+	if (!kvm_s390_pci_interp_allowed())
+		return;
+
+	mutex_destroy(&aift->aift_lock);
+
 	kfree(aift);
 }
-- 
2.37.3

