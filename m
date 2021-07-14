Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF173C8756
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 17:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbhGNP2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 11:28:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4900 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239635AbhGNP2n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 11:28:43 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EF3JKZ108614;
        Wed, 14 Jul 2021 11:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=1sc9Xz4hxz0zAaCmRS3NsVtq3kwNQftcr+zf199WTOs=;
 b=CgwLi9PBcnSpChuAqJYcjyjGFbNFDxUbBSuBauU2vqCdxgtUwFz+F53IeZt9qWOIYIHT
 S5SNRJmX2nsfBa+SLTMs5azAOiBcWkqZMPzjIMw6YvCtrRgTZDBebyR/SK/froFq8joc
 Wj6PbUDPnszrwxN2o+T4P5PF8Lk8LPStWiLwZlj01h2IPJUOWsn3UgSlRxuMKoIA1JkV
 Ej+okkawDrlUYEoeYNtzKOqi2Kn+dvHv3xTUHcAEV1VoDMWeqYUrPHNJJQRk5eFJpzQZ
 YUdFxEcbUhm9Imw3KmoSje3mcPj0KAF6PqBtoVbQPRxUgTQzMI1XJhP52SwZSGLTdPVL IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc2y61a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 11:25:50 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16EF48Pw116249;
        Wed, 14 Jul 2021 11:25:50 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc2y619c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 11:25:50 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16EFCA6j008376;
        Wed, 14 Jul 2021 15:25:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 39s3p78dcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 15:25:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16EFPjwJ25362860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 15:25:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71ABDA404D;
        Wed, 14 Jul 2021 15:25:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC5A6A4053;
        Wed, 14 Jul 2021 15:25:44 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.181.132])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 14 Jul 2021 15:25:44 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v1 0/2] s390x: KVM: CPU Topology
Date:   Wed, 14 Jul 2021 17:25:41 +0200
Message-Id: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UtkeMHUWBubjVOcQoQIWDH-1S7-HfTAX
X-Proofpoint-ORIG-GUID: JbL4kCpqV2aBQ-rTaKTINMAI-kyuZ7W6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-14_08:2021-07-14,2021-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 spamscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 mlxlogscore=905 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To provide Topology information to the guest through the STSI
instruction, we need to forward STSI with Function Code 15 to
QEMU which will take care to provide the right information to
the guest.

To let the guest use the PTF instruction and ask if a topology
change occured we add a new KVM capability to enable the topology
facility.

Pierre Morel (2):
  s390x: KVM: accept STSI for CPU topology information
  KVM: s390: Topology expose TOPOLOGY facility

 arch/s390/kvm/priv.c             | 11 ++++++++++-
 arch/s390/tools/gen_facilities.c |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.25.1

