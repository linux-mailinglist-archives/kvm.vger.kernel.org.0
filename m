Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8656A46C608
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbhLGVIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:08:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235145AbhLGVIh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:08:37 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JbfKC022854;
        Tue, 7 Dec 2021 21:05:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Sc9wEjWRut2zOeanlPcjuoj5CWHOX1UmHD3Qdu7RcJI=;
 b=tHhqYQg+u69VtJGa3HJUmns+hZnu6x1fCA85Se2ynW3luj2zXFOTDbfA3sQ4JSCJ5P68
 PwbskDvjvnp1639e4LsUFOx0ff5wvlKhS2+gHpYVTtgHIpATv/MDMZ75Ho20cFq6wuTI
 H69+/kDujYgYFWzomypd6Lv1aDzXQva5pSPqUlI9w+/Mfs7PIA5hjMZis1W/8hapIqgR
 m0Ci5j8uCAEyZKaXjV5yFf/LGXjlAe9hheg1DcgEVBPYaqzaqIRAZf2j6wfi3uMw1c+p
 0caeckutrJIASOk/LPbzCD7b5XWhKKQjNQreLT/WOLDP53a73+xbopW71ebOjIKE3pAX rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxphdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:05:03 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KqRjK003251;
        Tue, 7 Dec 2021 21:05:02 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxphd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:05:02 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kvmx9002333;
        Tue, 7 Dec 2021 21:05:01 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 3cqyyc38jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:05:01 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L4xPj65208818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:04:59 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54998AE06A;
        Tue,  7 Dec 2021 21:04:59 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B1BDAE05C;
        Tue,  7 Dec 2021 21:04:55 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:04:54 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 06/12] target/s390x: add zpci-interp to cpu models
Date:   Tue,  7 Dec 2021 16:04:19 -0500
Message-Id: <20211207210425.150923-7-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207210425.150923-1-mjrosato@linux.ibm.com>
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hVImhk4iiIRfDu80ZkTOlYaxDtPqra-k
X-Proofpoint-GUID: _aGumvI27UaMNTkCa2vwxoINt9qKI7A3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=993 lowpriorityscore=0 adultscore=1 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The zpci-interp feature is used to specify whether zPCI interpretation is
to be used for this guest.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 target/s390x/cpu_features_def.h.inc | 1 +
 target/s390x/gen-features.c         | 2 ++
 target/s390x/kvm/kvm.c              | 1 +
 3 files changed, 4 insertions(+)

diff --git a/target/s390x/cpu_features_def.h.inc b/target/s390x/cpu_features_def.h.inc
index e86662bb3b..4ade3182aa 100644
--- a/target/s390x/cpu_features_def.h.inc
+++ b/target/s390x/cpu_features_def.h.inc
@@ -146,6 +146,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: Conditional-external-interception f
 DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
 DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management facility")
 DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
+DEF_FEAT(ZPCI_INTERP, "zpci-interp", MISC, 0, "zPCI interpretation")
 
 /* Features exposed via the PLO instruction. */
 DEF_FEAT(PLO_CL, "plo-cl", PLO, 0, "PLO Compare and load (32 bit in general registers)")
diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
index 7cb1a6ec10..7005d22415 100644
--- a/target/s390x/gen-features.c
+++ b/target/s390x/gen-features.c
@@ -554,6 +554,7 @@ static uint16_t full_GEN14_GA1[] = {
     S390_FEAT_HPMA2,
     S390_FEAT_SIE_KSS,
     S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
+    S390_FEAT_ZPCI_INTERP,
 };
 
 #define full_GEN14_GA2 EmptyFeat
@@ -650,6 +651,7 @@ static uint16_t default_GEN14_GA1[] = {
     S390_FEAT_GROUP_MSA_EXT_8,
     S390_FEAT_MULTIPLE_EPOCH,
     S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
+    S390_FEAT_ZPCI_INTERP,
 };
 
 #define default_GEN14_GA2 EmptyFeat
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 5b1fdb55c4..b13d78f988 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -2290,6 +2290,7 @@ static int kvm_to_feat[][2] = {
     { KVM_S390_VM_CPU_FEAT_PFMFI, S390_FEAT_SIE_PFMFI},
     { KVM_S390_VM_CPU_FEAT_SIGPIF, S390_FEAT_SIE_SIGPIF},
     { KVM_S390_VM_CPU_FEAT_KSS, S390_FEAT_SIE_KSS},
+    { KVM_S390_VM_CPU_FEAT_ZPCI_INTERP, S390_FEAT_ZPCI_INTERP },
 };
 
 static int query_cpu_feat(S390FeatBitmap features)
-- 
2.27.0

