Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FFB47B299
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 19:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240360AbhLTSLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 13:11:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240332AbhLTSLM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 13:11:12 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BKHinxa022122;
        Mon, 20 Dec 2021 18:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uq8LYrtkuLTktp4XCUxI9Z+w4fQ3/w09etQgw07T4iY=;
 b=DOfTEW/CjrvDMR5aq5AdYCW4tCrFqg2TOfCattsmLqydlt2GrH+rfEhF2rzxHosThO1Z
 wzxUOx9siUYPGpYnkQZf3kWhqAdgtQuftS0ahF9txBC+WxaHRspFTwNfrnqEvLC8YpV6
 WF34zcKNM1w1UprWNMiSxh1KtgGIbjOi5pWZ14KoGyjQdDqkldgVqonqIn1DZQR+bhmH
 3nat41dl/a53KnXj9NEBWad1SDcxTIAKXZRvePSFP5RgRkhHb4WwTQHPQ7bU9mkwPsoF
 iUUGBbB+OsKKKHMR2LdFTXtwVJ4lhdgSGYjPgm/Q10v78v48hbRYj13JkF7ajkpY7Xs7 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d1sqn96c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:11 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BKHjPad031611;
        Mon, 20 Dec 2021 18:11:11 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d1sqn96be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:11 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BKI4iB5029688;
        Mon, 20 Dec 2021 18:11:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3d1799pc9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BKI2soE48497062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 18:02:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE40F52050;
        Mon, 20 Dec 2021 18:11:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 9AA6D5204E;
        Mon, 20 Dec 2021 18:11:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 560B8E63B2; Mon, 20 Dec 2021 19:11:05 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 1/6] KVM: s390: Fix names of skey constants in api documentation
Date:   Mon, 20 Dec 2021 19:10:59 +0100
Message-Id: <20211220181104.595009-2-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211220181104.595009-1-borntraeger@linux.ibm.com>
References: <20211220181104.595009-1-borntraeger@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: otH4a5O1ebnH1jSIxdlx4nnmdRGD96PQ
X-Proofpoint-GUID: RdsgtP3cLR7_iXsSTW-5anTsm_GSHqOj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_08,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=858 spamscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112200101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

They are defined in include/uapi/linux/kvm.h as
KVM_S390_GET_SKEYS_NONE and KVM_S390_SKEYS_MAX, but the
api documetation talks of KVM_S390_GET_KEYS_NONE and
KVM_S390_SKEYS_ALLOC_MAX respectively.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20211118102522.569660-1-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.33.1

