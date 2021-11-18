Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5370A455904
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 11:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245134AbhKRK3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 05:29:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243415AbhKRK3F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 05:29:05 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIABPfD011744;
        Thu, 18 Nov 2021 10:26:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=m8OGdty1aA6IVWuRNAcYSIV5uW9EeB7e1U5YtYJ+HwA=;
 b=Ztk2YE9uchCTVHvNQSI2WstTTnKC1+0Qi/6sAZExQpa0BQAsXagV/ob6kgLpJtj1LfL8
 c2grmx/D4RSCeEe26vwRNTMvirvH3zn5eOR0hW5nyehrkW2E9xCe06ZrEGLXaVXy0OnO
 3qjGOsWpeKTZJN0J48fxrJcUQqAdElZbJGNI9DxwZB8JZb1LdZJdicY+mi8E9s3fsur/
 fAIwpl0Ec+nBNmiDU06LWiPKQZ2ZR9mRA83xEsrxGybGbMrUOf/3oapZyOW1LQsyuGT/
 P7jE1aMsE2eyG66IvDSyP+9cEAp3vSDoKRoHde95kU75eVBFxdnIMz5o8IClfDgsJGFu 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdmv008ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 10:26:04 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AIABkm7017004;
        Thu, 18 Nov 2021 10:26:03 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdmv008ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 10:26:03 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIAIddC014406;
        Thu, 18 Nov 2021 10:26:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ca50aj8nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 10:26:01 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIAPw1m32965090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 10:25:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47BED52051;
        Thu, 18 Nov 2021 10:25:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0C02F5204F;
        Thu, 18 Nov 2021 10:25:58 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: Fix names of skey constants in api documentation
Date:   Thu, 18 Nov 2021 11:25:22 +0100
Message-Id: <20211118102522.569660-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I-62SnQjNXul2OVFXqxtHTM-aoLhQTQP
X-Proofpoint-ORIG-GUID: NA1tRtkHtwRKJBAmtgCga1wt-CPbO4IS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_04,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 phishscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1011 impostorscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111180059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The are defined in include/uapi/linux/kvm.h as
KVM_S390_GET_SKEYS_NONE and KVM_S390_SKEYS_MAX, but the
api documetation talks of KVM_S390_GET_KEYS_NONE and
KVM_S390_SKEYS_ALLOC_MAX respectively.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..b86c7edae888 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3701,7 +3701,7 @@ KVM with the currently defined set of flags.
 :Architectures: s390
 :Type: vm ioctl
 :Parameters: struct kvm_s390_skeys
-:Returns: 0 on success, KVM_S390_GET_KEYS_NONE if guest is not using storage
+:Returns: 0 on success, KVM_S390_GET_SKEYS_NONE if guest is not using storage
           keys, negative value on error
 
 This ioctl is used to get guest storage key values on the s390
@@ -3720,7 +3720,7 @@ you want to get.
 
 The count field is the number of consecutive frames (starting from start_gfn)
 whose storage keys to get. The count field must be at least 1 and the maximum
-allowed value is defined as KVM_S390_SKEYS_ALLOC_MAX. Values outside this range
+allowed value is defined as KVM_S390_SKEYS_MAX. Values outside this range
 will cause the ioctl to return -EINVAL.
 
 The skeydata_addr field is the address to a buffer large enough to hold count
@@ -3744,7 +3744,7 @@ you want to set.
 
 The count field is the number of consecutive frames (starting from start_gfn)
 whose storage keys to get. The count field must be at least 1 and the maximum
-allowed value is defined as KVM_S390_SKEYS_ALLOC_MAX. Values outside this range
+allowed value is defined as KVM_S390_SKEYS_MAX. Values outside this range
 will cause the ioctl to return -EINVAL.
 
 The skeydata_addr field is the address to a buffer containing count bytes of
-- 
2.25.1

