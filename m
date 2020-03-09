Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B585F17DB8D
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgCIIve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:51:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbgCIIve (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:34 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298nmDW104307
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:33 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ym8mqvv39-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:33 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:31 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:28 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pRRj7798836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CBA54C04A;
        Mon,  9 Mar 2020 08:51:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 357C04C04E;
        Mon,  9 Mar 2020 08:51:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id D84E6E0251; Mon,  9 Mar 2020 09:51:26 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 00/36] KVM: s390: Features and Enhancements for 5.7 part1
Date:   Mon,  9 Mar 2020 09:50:50 +0100
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-0028-0000-0000-000003E2343C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0029-0000-0000-000024A770F1
Message-Id: <20200309085126.3334302-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=959 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

an early pull request containing mostly the protected virtualization guest
support. Some remarks:

1.To avoid conflicts I would rather add this early. We do have in KVM
common code:
- a new capability KVM_CAP_S390_PROTECTED = 180
- a new ioctl  KVM_S390_PV_COMMAND =  _IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
- data structures for KVM_S390_PV_COMMAND
- new MEMOP ioctl subfunctions
- new files under Documentation
- additions to api.rst 4.125 KVM_S390_PV_COMMAND

2. There is an mm patch in Andrews mm tree which is needed for full
functionality. The patch is not necessary to build KVM or to run non
protected KVM though. So this can go independently.

3. I created a topic branch for the non-kvm s390x parts that I merged
in. Vasily, Heiko or myself will pull that into the s390 tree if there
will be a conflict.


The following changes since commit 11a48a5a18c63fd7621bb050228cebf13566e4d8:

  Linux 5.6-rc2 (2020-02-16 13:16:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.7-1

for you to fetch changes up to cc674ef252f4750bdcea1560ff491081bb960954:

  KVM: s390: introduce module parameter kvm.use_gisa (2020-02-27 19:47:13 +0100)

----------------------------------------------------------------
KVM: s390: Features and Enhancements for 5.7 part1

1. Allow to disable gisa
2. protected virtual machines
  Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's
  state like guest memory and guest registers anymore. Instead the
  PVMs are mostly managed by a new entity called Ultravisor (UV),
  which provides an API, so KVM and the PV can request management
  actions.

  PVMs are encrypted at rest and protected from hypervisor access
  while running.  They switch from a normal operation into protected
  mode, so we can still use the standard boot process to load a
  encrypted blob and then move it into protected mode.

  Rebooting is only possible by passing through the unprotected/normal
  mode and switching to protected again.

  One mm related patch will go via Andrews mm tree ( mm/gup/writeback:
  add callbacks for inaccessible pages)

----------------------------------------------------------------
Christian Borntraeger (5):
      Merge branch 'pvbase' of git://git.kernel.org/.../kvms390/linux into HEAD
      KVM: s390/mm: Make pages accessible before destroying the guest
      KVM: s390: protvirt: Add SCLP interrupt handling
      KVM: s390: protvirt: do not inject interrupts after start
      KVM: s390: protvirt: introduce and enable KVM_CAP_S390_PROTECTED

Claudio Imbrenda (2):
      s390/mm: provide memory management functions for protected KVM guests
      KVM: s390/mm: handle guest unpin events

Janosch Frank (24):
      s390/protvirt: Add sysfs firmware interface for Ultravisor information
      KVM: s390: protvirt: Add UV debug trace
      KVM: s390: add new variants of UV CALL
      KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
      KVM: s390: protvirt: Secure memory is not mergeable
      KVM: s390: protvirt: Handle SE notification interceptions
      KVM: s390: protvirt: Instruction emulation
      KVM: s390: protvirt: Handle spec exception loops
      KVM: s390: protvirt: Add new gprs location handling
      KVM: S390: protvirt: Introduce instruction data area bounce buffer
      KVM: s390: protvirt: handle secure guest prefix pages
      KVM: s390: protvirt: Write sthyi data to instruction data area
      KVM: s390: protvirt: STSI handling
      KVM: s390: protvirt: disallow one_reg
      KVM: s390: protvirt: Do only reset registers that are accessible
      KVM: s390: protvirt: Only sync fmt4 registers
      KVM: s390: protvirt: Add program exception injection
      KVM: s390: protvirt: UV calls in support of diag308 0, 1
      KVM: s390: protvirt: Report CPU state to Ultravisor
      KVM: s390: protvirt: Support cmd 5 operation state
      KVM: s390: protvirt: Mask PSW interrupt bits for interception 104 and 112
      KVM: s390: protvirt: Add UV cpu reset calls
      DOCUMENTATION: Protected virtual machine introduction and IPL
      KVM: s390: protvirt: Add KVM api documentation

Michael Mueller (2):
      KVM: s390: protvirt: Implement interrupt injection
      KVM: s390: introduce module parameter kvm.use_gisa

Ulrich Weigand (1):
      KVM: s390/interrupt: do not pin adapter interrupt pages

Vasily Gorbik (3):
      s390/protvirt: introduce host side setup
      s390/protvirt: add ultravisor initialization
      s390/mm: add (non)secure page access exceptions handlers

 Documentation/admin-guide/kernel-parameters.txt |   5 +
 Documentation/virt/kvm/api.rst                  |  65 ++-
 Documentation/virt/kvm/devices/s390_flic.rst    |  11 +-
 Documentation/virt/kvm/index.rst                |   2 +
 Documentation/virt/kvm/s390-pv-boot.rst         |  84 ++++
 Documentation/virt/kvm/s390-pv.rst              | 116 +++++
 MAINTAINERS                                     |   1 +
 arch/s390/boot/Makefile                         |   2 +-
 arch/s390/boot/uv.c                             |  20 +
 arch/s390/include/asm/gmap.h                    |   6 +
 arch/s390/include/asm/kvm_host.h                | 113 ++++-
 arch/s390/include/asm/mmu.h                     |   2 +
 arch/s390/include/asm/mmu_context.h             |   1 +
 arch/s390/include/asm/page.h                    |   5 +
 arch/s390/include/asm/pgtable.h                 |  35 +-
 arch/s390/include/asm/uv.h                      | 251 ++++++++++-
 arch/s390/kernel/Makefile                       |   1 +
 arch/s390/kernel/entry.h                        |   2 +
 arch/s390/kernel/pgm_check.S                    |   4 +-
 arch/s390/kernel/setup.c                        |   9 +-
 arch/s390/kernel/uv.c                           | 414 +++++++++++++++++
 arch/s390/kvm/Makefile                          |   2 +-
 arch/s390/kvm/diag.c                            |   6 +-
 arch/s390/kvm/intercept.c                       | 122 ++++-
 arch/s390/kvm/interrupt.c                       | 399 ++++++++++-------
 arch/s390/kvm/kvm-s390.c                        | 567 +++++++++++++++++++++---
 arch/s390/kvm/kvm-s390.h                        |  51 ++-
 arch/s390/kvm/priv.c                            |  13 +-
 arch/s390/kvm/pv.c                              | 303 +++++++++++++
 arch/s390/mm/fault.c                            |  78 ++++
 arch/s390/mm/gmap.c                             |  65 ++-
 include/uapi/linux/kvm.h                        |  43 +-
 32 files changed, 2488 insertions(+), 310 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
 create mode 100644 Documentation/virt/kvm/s390-pv.rst
 create mode 100644 arch/s390/kernel/uv.c
 create mode 100644 arch/s390/kvm/pv.c

