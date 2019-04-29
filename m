Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E85DEB5
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfD2JKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:10:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727259AbfD2JKL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Apr 2019 05:10:11 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3T99wfN042138
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:10 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s5w7uavx5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:09 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 29 Apr 2019 10:10:07 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 29 Apr 2019 10:10:04 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3T9A3uD48955596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 09:10:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3406A4C071;
        Mon, 29 Apr 2019 09:10:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29C664C06E;
        Mon, 29 Apr 2019 09:10:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Apr 2019 09:10:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id C7EF320F5D4; Mon, 29 Apr 2019 11:10:02 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 00/12] KVM: s390: Features and fixes for kvm/next
Date:   Mon, 29 Apr 2019 11:09:50 +0200
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042909-0028-0000-0000-00000368691D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042909-0029-0000-0000-00002427C958
Message-Id: <20190429091002.71164-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

Nothing big this time. Some fixes and new hardware features.
Please pull

The following changes since commit 79a3aaa7b82e3106be97842dedfd8429248896e6:

  Linux 5.1-rc3 (2019-03-31 14:39:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.2-1

for you to fetch changes up to b2d0371d2e374facd45e115d3668086df13730ff:

  KVM: s390: vsie: Return correct values for Invalid CRYCB format (2019-04-29 09:01:22 +0200)

----------------------------------------------------------------
KVM: s390: Features and fixes for 5.2

- VSIE crypto fixes
- new guest features for gen15
- disable halt polling for nested virtualization with overcommit

----------------------------------------------------------------
Christian Borntraeger (9):
      KVM: s390: add vector enhancements facility 2 to cpumodel
      KVM: s390: add vector BCD enhancements facility to cpumodel
      KVM: s390: add MSA9 to cpumodel
      KVM: s390: provide query function for instructions returning 32 byte
      KVM: s390: add enhanced sort facilty to cpu model
      KVM: s390: add deflate conversion facilty to cpu model
      KVM: s390: enable MSA9 keywrapping functions depending on cpu model
      KVM: polling: add architecture backend to disable polling
      KVM: s390: provide kvm_arch_no_poll function

Eric Farman (1):
      KVM: s390: Fix potential spectre warnings

Pierre Morel (2):
      KVM: s390: vsie: Do not shadow CRYCB when no AP and no keys
      KVM: s390: vsie: Return correct values for Invalid CRYCB format

 Documentation/virtual/kvm/devices/vm.txt |   3 +-
 arch/s390/include/asm/cpacf.h            |   1 +
 arch/s390/include/asm/kvm_host.h         |   2 +
 arch/s390/include/uapi/asm/kvm.h         |   5 +-
 arch/s390/kvm/Kconfig                    |   1 +
 arch/s390/kvm/interrupt.c                |  11 ++-
 arch/s390/kvm/kvm-s390.c                 | 117 ++++++++++++++++++++++++++++++-
 arch/s390/kvm/vsie.c                     |  13 ++--
 arch/s390/tools/gen_facilities.c         |   3 +
 include/linux/kvm_host.h                 |  10 +++
 tools/arch/s390/include/uapi/asm/kvm.h   |   3 +-
 virt/kvm/Kconfig                         |   3 +
 virt/kvm/kvm_main.c                      |   2 +-
 13 files changed, 163 insertions(+), 11 deletions(-)

