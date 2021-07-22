Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81283D2AC0
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhGVQWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 12:22:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57471 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230217AbhGVQWN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 12:22:13 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MGagqA110183;
        Thu, 22 Jul 2021 13:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=s7dbO+/Zyl/Hsjg3IdCOdqBt2Zx6l1ppAGlCp0MGhT0=;
 b=I1LwOjuHx+nX0wb9Ob2ZUV+R8OTolXdt5hsO8/j2OESNoVw+kPSpVHcymzFNwliCLM5o
 d2/CRdwz5G5U+8dxAyypC1zd69Q1xTbLKKAvgChzzRRhQl1NSQOcjQFYdmSMKWj2Zmno
 ZqRx7q7JQn5tNOttNLPVrabqab9zCqsObKpWURxbHvKyDIfxJQc/rf2j2iolCrwJ9H9v
 N7hiBa1FslR1KRCigmn/jBJUfrayWtOAkNIN80PVsC5JmKdT8nf61pNtxWvRsGVXFbSo
 0qktmj8tw1GO3qZXPZQLWJqVXO2wa9MjcVHshaXTlanLSsn9hOA0JtswKCfdo5Ahv3Eg fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39yah35pgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 13:02:47 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16MGanTW110704;
        Thu, 22 Jul 2021 13:02:46 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39yah35pew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 13:02:46 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16MGxdMq017923;
        Thu, 22 Jul 2021 17:02:44 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 39upfh9k9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 17:02:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16MH2fmd26935776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 17:02:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FBAAAE04D;
        Thu, 22 Jul 2021 17:02:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF940AE053;
        Thu, 22 Jul 2021 17:02:40 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.18.177])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jul 2021 17:02:40 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v2 0/2] s390x: KVM: CPU Topology
Date:   Thu, 22 Jul 2021 19:02:31 +0200
Message-Id: <1626973353-17446-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W-jaRrSjG2mZbzBjux2ZKe5Esan75EO8
X-Proofpoint-GUID: Ax9ENQCG6iNT9VjWbhuP75s5Th4U0TPk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-22_09:2021-07-22,2021-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=864 spamscore=0 priorityscore=1501 adultscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220110
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
  s390:kvm: Topology expose TOPOLOGY facility

 arch/s390/kvm/kvm-s390.c | 1 +
 arch/s390/kvm/priv.c     | 7 ++++++-
 include/uapi/linux/kvm.h | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

-- 
2.25.1

Changelog:

- Add a KVM capability to let QEMU know we support PTF and STSI 15
  (David)

- check KVM facility 11 before accepting STSI fc 15
  (David)

- handle all we can in userland
  (David)

- add tracing to STSI fc 15
  (Connie)

