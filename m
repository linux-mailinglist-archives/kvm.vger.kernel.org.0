Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93253B4277
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 13:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhFYL1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 07:27:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229470AbhFYL1B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 07:27:01 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PBK10K009462;
        Fri, 25 Jun 2021 07:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=5paAsb/00rM0viWLvsHO3lrwBcruKvATB3KvpvtjF5o=;
 b=Vs8y696HOWplc98opPQsbBjVzHDGo3n2ckUs38UrV2DesxV3vI5Z8wY+toeguyvu4LRv
 s1DRUZ2Hw4lMiS+zWjfOcUwfT0/A0nDRXW0jfjeNMRCTIXEEJXc+CdWW3DkiOXqen1Ep
 UMDQqs6nBCHgj8IfrL+CAZ0qYA8EDVNOfAkOaXwtbk/NEJDzM1HgO+TKE+x/uMrKkf6R
 ozGLWERP9mo6p6Ois7/8s8fwM2f3afyIEh2UKYzao1N2eiy3VnZMU2xmnlulxj4n9xEv
 DjLJ4sfOeRUrAKu1U2D2nGm6frd/XZxvzuIBy2tx0O8rbZKkIvPaW4QG3/mSenF8oPMQ CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39de6005pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:24:39 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15PBKDI2010348;
        Fri, 25 Jun 2021 07:24:39 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39de6005np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:24:39 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15PBMxwx023600;
        Fri, 25 Jun 2021 11:24:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3998789p4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 11:24:37 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15PBNAc037224790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 11:23:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2F1211C04C;
        Fri, 25 Jun 2021 11:24:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C11EF11C04A;
        Fri, 25 Jun 2021 11:24:34 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Jun 2021 11:24:34 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 84EA5E07DE; Fri, 25 Jun 2021 13:24:34 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 0/3] KVM: s390: Features and Cleanups for 5.14
Date:   Fri, 25 Jun 2021 13:24:31 +0200
Message-Id: <20210625112434.12308-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OjcBO9nQHwy4FNT6i6GEwGSxDs1wO2-5
X-Proofpoint-GUID: WXC3epGgfdH8MSydB2aDVTnPyw18RmeR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_03:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

only a small amount of patches for 5.14 for KVM on s390.

The following changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:

  Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.14-1

for you to fetch changes up to 1f703d2cf20464338c3d5279dddfb65ac79b8782:

  KVM: s390: allow facility 192 (vector-packed-decimal-enhancement facility 2) (2021-06-23 09:35:20 +0200)

----------------------------------------------------------------
KVM: s390: Features for 5.14

- new HW facilities for guests
- make inline assembly more robust with KASAN and co

----------------------------------------------------------------
Christian Borntraeger (2):
      KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196
      KVM: s390: allow facility 192 (vector-packed-decimal-enhancement facility 2)

Heiko Carstens (1):
      KVM: s390: get rid of register asm usage

 arch/s390/kvm/kvm-s390.c         | 22 +++++++++++++---------
 arch/s390/tools/gen_facilities.c |  4 ++++
 2 files changed, 17 insertions(+), 9 deletions(-)
