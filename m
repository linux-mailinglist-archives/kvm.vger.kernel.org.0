Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D2A26871D
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 10:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgINIW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 04:22:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726139AbgINIWX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 04:22:23 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08E82Lr9168862;
        Mon, 14 Sep 2020 04:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=i+OwX1kg/u3h4oRJPcu0H6VxX72SaJLtZbABQK7m36w=;
 b=BynVaRT1h4Cd3qcVDL9O7Rz81Qq5WHQSyFcfsDxeC3rCHj2dYIbWkLyt/Pg/PUGj5LHK
 vVult16AmkS0szCRuc+l7dar7ejfko9hfqNSzvZZTWdmLiXUiZMu2zQii2Tt/NHY7Hdh
 /cogDdb7aEU4nBWkzGq9ufLqYFBiQ5zCFKexOIE2JL09c+9a5EU9QUQrthGqYCckwP/W
 qRuonKmcgt9tAgUMOhdKeC0Ni9VMvZaT/x3Cny52//UkSggEi2RWsDp6CQZipKIsOm85
 A8vsYt2ybNm+5tee/99JqXjB4K6OsrqnqMMmfaLTd2A61SSBAFaWkW5iS36u6yHvdYE7 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j4g4rvbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:22:22 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08E82uiK171395;
        Mon, 14 Sep 2020 04:22:22 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j4g4rvas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:22:22 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08E8KvgW028114;
        Mon, 14 Sep 2020 08:22:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 33hkfagcfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 08:22:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08E8MHXu20840938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 08:22:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E92A84C046;
        Mon, 14 Sep 2020 08:22:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5F484C040;
        Mon, 14 Sep 2020 08:22:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 14 Sep 2020 08:22:16 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 969DCE235D; Mon, 14 Sep 2020 10:22:16 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>
Subject: [GIT PULL 1/1] docs: kvm: add documentation for KVM_CAP_S390_DIAG318
Date:   Mon, 14 Sep 2020 10:22:15 +0200
Message-Id: <20200914082215.6143-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200914082215.6143-1-borntraeger@de.ibm.com>
References: <20200914082215.6143-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-13_09:2020-09-10,2020-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140062
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Collin Walling <walling@linux.ibm.com>

Documentation for the s390 DIAGNOSE 0x318 instruction handling.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/kvm/20200625150724.10021-2-walling@linux.ibm.com/
Message-Id: <20200625150724.10021-2-walling@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 Documentation/virt/kvm/api.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d2b733dc7892..51191b56e61c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6173,3 +6173,23 @@ specific interfaces must be consistent, i.e. if one says the feature
 is supported, than the other should as well and vice versa.  For arm64
 see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
 For x86 see Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".
+
+8.25 KVM_CAP_S390_DIAG318
+-------------------------
+
+:Architectures: s390
+
+This capability enables a guest to set information about its control program
+(i.e. guest kernel type and version). The information is helpful during
+system/firmware service events, providing additional data about the guest
+environments running on the machine.
+
+The information is associated with the DIAGNOSE 0x318 instruction, which sets
+an 8-byte value consisting of a one-byte Control Program Name Code (CPNC) and
+a 7-byte Control Program Version Code (CPVC). The CPNC determines what
+environment the control program is running in (e.g. Linux, z/VM...), and the
+CPVC is used for information specific to OS (e.g. Linux version, Linux
+distribution...)
+
+If this capability is available, then the CPNC and CPVC can be synchronized
+between KVM and userspace via the sync regs mechanism (KVM_SYNC_DIAG318).
-- 
2.25.4

