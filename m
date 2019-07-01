Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D265BC48
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 14:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfGAM7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 08:59:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727049AbfGAM65 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jul 2019 08:58:57 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61CuwI0019780
        for <kvm@vger.kernel.org>; Mon, 1 Jul 2019 08:58:56 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tfgnmy89g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 08:58:55 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 1 Jul 2019 13:58:53 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 1 Jul 2019 13:58:50 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x61CwnV537552432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 12:58:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2418D4C059;
        Mon,  1 Jul 2019 12:58:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 119BD4C050;
        Mon,  1 Jul 2019 12:58:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Jul 2019 12:58:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id BE5B4E0506; Mon,  1 Jul 2019 14:58:48 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [GIT PULL 0/7] KVM: s390: add kselftests
Date:   Mon,  1 Jul 2019 14:58:41 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070112-0012-0000-0000-0000032E2E2B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070112-0013-0000-0000-0000216777D4
Message-Id: <20190701125848.276133-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

kselftest for s390x. There is a small conflict with Linus tree due to
61cfcd545e42 ("kvm: tests: Sort tests in the Makefile alphabetically")
which is part of kvm/master but not kvm/next.
Other than that this looks good.


The following changes since commit f2c7c76c5d0a443053e94adb9f0918fa2fb85c3a:

  Linux 5.2-rc3 (2019-06-02 13:55:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.3-1

for you to fetch changes up to 8343ba2d4820b1738bbb7cb40ec18ea0a3b0b331:

  KVM: selftests: enable pgste option for the linker on s390 (2019-06-04 14:05:38 +0200)

----------------------------------------------------------------
KVM: s390: add kselftests

This is the initial implementation for KVM selftests on s390.

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: selftests: enable pgste option for the linker on s390

Thomas Huth (6):
      KVM: selftests: Guard struct kvm_vcpu_events with __KVM_HAVE_VCPU_EVENTS
      KVM: selftests: Introduce a VM_MODE_DEFAULT macro for the default bits
      KVM: selftests: Align memory region addresses to 1M on s390x
      KVM: selftests: Add processor code for s390x
      KVM: selftests: Add the sync_regs test for s390x
      KVM: selftests: Move kvm_create_max_vcpus test to generic code

 MAINTAINERS                                        |   2 +
 tools/testing/selftests/kvm/Makefile               |  14 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |   8 +
 .../selftests/kvm/include/s390x/processor.h        |  22 ++
 .../kvm/{x86_64 => }/kvm_create_max_vcpus.c        |   3 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  23 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  | 286 +++++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   2 +-
 tools/testing/selftests/kvm/s390x/sync_regs_test.c | 151 +++++++++++
 10 files changed, 503 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/processor.h
 rename tools/testing/selftests/kvm/{x86_64 => }/kvm_create_max_vcpus.c (93%)
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/processor.c
 create mode 100644 tools/testing/selftests/kvm/s390x/sync_regs_test.c

