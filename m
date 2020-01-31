Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF5314EF10
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAaPED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:04:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729234AbgAaPED (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:04:03 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VF36Sm037964
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:04:02 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xvbm47mn7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:04:01 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:03:54 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:03:50 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF2vOX43254032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:02:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 727B7A4057;
        Fri, 31 Jan 2020 15:03:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60CEBA405F;
        Fri, 31 Jan 2020 15:03:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jan 2020 15:03:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 1DC89E0378; Fri, 31 Jan 2020 16:03:49 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 0/7] KVM: s390: Fixes and cleanups for 5.6
Date:   Fri, 31 Jan 2020 16:03:41 +0100
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013115-0028-0000-0000-000003D64A15
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0029-0000-0000-0000249A9C7D
Message-Id: <20200131150348.73360-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=815 clxscore=1015 adultscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,
mostly fixes and cleanups for 5.6.
Patch 2 has cc stable.

The following changes since commit d1eef1c619749b2a57e514a3fa67d9a516ffa919:

  Linux 5.5-rc2 (2019-12-15 15:16:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.6-1

for you to fetch changes up to b2ff728bae9b04b533fbc8de66f1719c4dc889de:

  selftests: KVM: testing the local IRQs resets (2020-01-31 13:17:21 +0100)

----------------------------------------------------------------
KVM: s390: Fixes and cleanups for 5.6
- fix register corruption
- ENOTSUPP/EOPNOTSUPP mixed
- reset cleanups/fixes
- selftests

----------------------------------------------------------------
Christian Borntraeger (2):
      KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups
      KVM: s390: do not clobber registers during guest reset/store status

Janosch Frank (4):
      KVM: s390: Cleanup initial cpu reset
      KVM: s390: Add new reset vcpu API
      selftests: KVM: Add fpu and one reg set/get library functions
      selftests: KVM: s390x: Add reset tests

Pierre Morel (1):
      selftests: KVM: testing the local IRQs resets

 Documentation/virt/kvm/api.txt                 |  43 ++++++
 arch/s390/include/asm/kvm_host.h               |   5 +
 arch/s390/kvm/interrupt.c                      |   6 +-
 arch/s390/kvm/kvm-s390.c                       |  92 +++++++-----
 include/uapi/linux/kvm.h                       |   5 +
 tools/testing/selftests/kvm/Makefile           |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c     |  36 +++++
 tools/testing/selftests/kvm/s390x/resets.c     | 197 +++++++++++++++++++++++++
 9 files changed, 354 insertions(+), 37 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/resets.c

