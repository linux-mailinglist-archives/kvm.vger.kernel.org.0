Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB71B1B1EDC
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 08:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgDUGfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 02:35:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726591AbgDUGfI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 02:35:08 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03L6VwN4066504
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 02:35:07 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmu7r9ad-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 02:35:07 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 21 Apr 2020 07:34:14 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Apr 2020 07:33:59 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03L6YnZI13042120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 06:34:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 148CEA404D;
        Tue, 21 Apr 2020 06:34:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03703A4040;
        Tue, 21 Apr 2020 06:34:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 21 Apr 2020 06:34:48 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 86A11E04AA; Tue, 21 Apr 2020 08:34:48 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [GIT PULL 0/2] KVM: s390: Fix for 5.7 and maintainer update
Date:   Tue, 21 Apr 2020 08:34:45 +0200
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042106-0020-0000-0000-000003CBB5B3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042106-0021-0000-0000-00002224ABE0
Message-Id: <20200421063447.6814-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_01:2020-04-20,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=629
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210052
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

two things for kvm/master. One fix for the protected virtualization
feature where we have a too strong assert and Adding Claudio as a
reviewer.

The following changes since commit ae83d0b416db002fe95601e7f97f64b59514d936:

  Linux 5.7-rc2 (2020-04-19 14:35:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.7-2

for you to fetch changes up to 2a173ec993baa6a97e7b0fb89240200a88d90746:

  MAINTAINERS: add a reviewer for KVM/s390 (2020-04-20 11:24:00 +0200)

----------------------------------------------------------------
KVM: s390: Fix for 5.7 and maintainer update

- Silence false positive lockdep warning
- add Claudio as reviewer

----------------------------------------------------------------
Claudio Imbrenda (1):
      MAINTAINERS: add a reviewer for KVM/s390

Eric Farman (1):
      KVM: s390: Fix PV check in deliverable_irqs()

 MAINTAINERS               | 1 +
 arch/s390/kvm/interrupt.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

