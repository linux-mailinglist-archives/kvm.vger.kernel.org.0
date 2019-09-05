Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A481EA9D3B
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 10:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732764AbfIEIkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 04:40:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731660AbfIEIkk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Sep 2019 04:40:40 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x858ba1w109818
        for <kvm@vger.kernel.org>; Thu, 5 Sep 2019 04:40:39 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2utwptbtvv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 04:40:39 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 5 Sep 2019 09:40:36 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Sep 2019 09:40:33 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x858eWhC53936138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Sep 2019 08:40:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CEE3A405B;
        Thu,  5 Sep 2019 08:40:32 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4ECEA405D;
        Thu,  5 Sep 2019 08:40:31 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Sep 2019 08:40:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, frankja@linux.vnet.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [GIT PULL 0/8] KVM: s390: extend selftests add more input checks
Date:   Thu,  5 Sep 2019 10:40:01 +0200
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19090508-0028-0000-0000-00000397F9BF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090508-0029-0000-0000-0000245A4E0D
Message-Id: <20190905084009.26106-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-05_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=467 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909050089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

Thomas extended the selftests and added some input checks to KVM s390
ioctls. Cornelia contributed the documentation changes needed after
the added checks.

Please pull.

The following changes since commit 609488bc979f99f805f34e9a32c1e3b71179d10b:

  Linux 5.3-rc2 (2019-07-28 12:47:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-5.4-1

for you to fetch changes up to 81cb736c0c928444e2f4707513c167d5d39844a4:

  KVM: selftests: Test invalid bits in kvm_valid_regs and kvm_dirty_regs on s390x (2019-09-04 15:38:05 +0200)

----------------------------------------------------------------
* More selftests
* Improved KVM_S390_MEM_OP ioctl input checking
* Add kvm_valid_regs and kvm_dirty_regs invalid bit checking
----------------------------------------------------------------
Cornelia Huck (1):
      KVM: s390: improve documentation for S390_MEM_OP

Thomas Huth (7):
      KVM: selftests: Split ucall.c into architecture specific files
      KVM: selftests: Implement ucall() for s390x
      KVM: selftests: Enable dirty_log_test on s390x
      KVM: s390: Test for bad access register and size at the start of S390_MEM_OP
      KVM: selftests: Add a test for the KVM_S390_MEM_OP ioctl
      KVM: s390: Disallow invalid bits in kvm_valid_regs and kvm_dirty_regs
      KVM: selftests: Test invalid bits in kvm_valid_regs and kvm_dirty_regs on s390x

 Documentation/virt/kvm/api.txt                     |  14 +-
 arch/s390/include/uapi/asm/kvm.h                   |   6 +
 arch/s390/kvm/kvm-s390.c                           |   6 +-
 tools/testing/selftests/kvm/Makefile               |  10 +-
 tools/testing/selftests/kvm/dirty_log_test.c       |  61 +++++++-
 tools/testing/selftests/kvm/include/kvm_util.h     |   8 +-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    | 112 ++++++++++++++
 tools/testing/selftests/kvm/lib/s390x/ucall.c      |  56 +++++++
 tools/testing/selftests/kvm/lib/ucall.c            | 157 -------------------
 tools/testing/selftests/kvm/lib/x86_64/ucall.c     |  56 +++++++
 tools/testing/selftests/kvm/s390x/memop.c          | 166 +++++++++++++++++++++
 tools/testing/selftests/kvm/s390x/sync_regs_test.c |  36 ++++-
 12 files changed, 503 insertions(+), 185 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/ucall.c
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/ucall.c
 delete mode 100644 tools/testing/selftests/kvm/lib/ucall.c
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/ucall.c
 create mode 100644 tools/testing/selftests/kvm/s390x/memop.c

