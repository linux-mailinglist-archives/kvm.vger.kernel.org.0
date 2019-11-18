Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD7410006E
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 09:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKRIgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 03:36:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726552AbfKRIgK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 03:36:10 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAI8WCIa033122
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 03:36:09 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2way66v1sd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 03:36:09 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 18 Nov 2019 08:36:07 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 18 Nov 2019 08:36:04 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAI8a3rG53018826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 08:36:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46F6511C05B;
        Mon, 18 Nov 2019 08:36:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33B0611C04A;
        Mon, 18 Nov 2019 08:36:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 18 Nov 2019 08:36:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E4780E02C4; Mon, 18 Nov 2019 09:36:02 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [GIT PULL 0/5] KVM: s390: fixes and enhancements for 5.5
Date:   Mon, 18 Nov 2019 09:35:57 +0100
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19111808-0016-0000-0000-000002C6954A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111808-0017-0000-0000-000033284445
Message-Id: <20191118083602.15835-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-18_01:2019-11-15,2019-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=826
 bulkscore=0 mlxscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911180077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

everybody is busy on the ultravisor related things, so only a small
number of changes for s390 for 5.5.

The following changes since commit 54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c:

  Linux 5.4-rc1 (2019-09-30 10:35:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.5-1

for you to fetch changes up to c7b7de63124645089ccf9900b9e5ea08059ccae0:

  KVM: s390: Do not yield when target is already running (2019-10-10 13:18:40 +0200)

----------------------------------------------------------------
KVM: s390: small fixes and enhancements

- selftest improvements
- yield improvements
- cleanups

----------------------------------------------------------------
Christian Borntraeger (3):
      selftests: kvm: make syncregs more reliable on s390
      KVM: s390: count invalid yields
      KVM: s390: Do not yield when target is already running

Janosch Frank (1):
      KVM: s390: Cleanup kvm_arch_init error path

Thomas Huth (1):
      KVM: s390: Remove unused parameter from __inject_sigp_restart()

 arch/s390/include/asm/kvm_host.h                   |  1 +
 arch/s390/kvm/diag.c                               | 22 ++++++++++++++++++----
 arch/s390/kvm/interrupt.c                          |  5 ++---
 arch/s390/kvm/kvm-s390.c                           | 19 ++++++++-----------
 tools/testing/selftests/kvm/s390x/sync_regs_test.c | 15 +++++++++------
 5 files changed, 38 insertions(+), 24 deletions(-)

