Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03CE57D0D1
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiGUQNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGUQNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0FF5FAFF;
        Thu, 21 Jul 2022 09:13:10 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFFQ2H020317;
        Thu, 21 Jul 2022 16:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=ctWPDrt5szzbZCsDcOUopZiX9abksgvjHJHgd1RgdbA=;
 b=FoV7ybQl3dWkZylUYn9YUSlWTm+DV8O0RrO76coCwgak0CSCGVdCdri6+NDez/UbZ4A/
 ECvE47hEjVVf01u6ebK6/O4wohRZkxckQX8ruA6ApFjO2taIiGrAN9364x/V7oiy8qPs
 aD4LImrfnovoemN5sq3YRwzRxiiIqqJJaZw7fE9bbHPJ7QZZdmNYZvrWAKh2nQmhFMJo
 pEgcOaYUVxNnc1Kkglmparfv6unHYgDaEvwY/ITlex+X8Qx7Y0C71wSwAeCCdwmduULI
 ksHk5H8ODXCATEN/4HMWWDw29F4b+25jF1fXDHXFdvA6QFHTSmxUdKoMWn+5KX822ihx ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m374-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:09 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFmcR2017628;
        Thu, 21 Jul 2022 16:13:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m35p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6iX5029928;
        Thu, 21 Jul 2022 16:13:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj7697-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDGdc22610398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 793F4A405C;
        Thu, 21 Jul 2022 16:13:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 051CDA4054;
        Thu, 21 Jul 2022 16:13:03 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Subject: [GIT PULL 00/42] KVM: s390: PCI, CPU topology, PV features
Date:   Thu, 21 Jul 2022 18:12:20 +0200
Message-Id: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PPFNioCLLBZjCD39ZV7Qsk9Vy4b74sM4
X-Proofpoint-GUID: G-JGH0e3rBf3GMJ23vEFJuFNI1cuwmDN
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

today you are getting the pull request from me :)


this request has:

* First part of deferred teardown (Claudio)
* CPU Topology (Pierre)
* interpretive execution for PCI instructions (Matthew)
* PV attestation (Steffen)
* Minor fixes 


Please pull


The following changes since commit 4b88b1a518b337de1252b8180519ca4c00015c9e:

  KVM: selftests: Enhance handling WRMSR ICR register in x2APIC mode (2022-06-24 04:52:04 -0400)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-5.20-1

for you to fetch changes up to f5ecfee94493475783074e86ded10a0499d779fc:

  KVM: s390: resetting the Topology-Change-Report (2022-07-20 10:57:37 +0200)

----------------------------------------------------------------
KVM: s390x: Fixes and features for 5.20

* First part of deferred teardown
* CPU Topology
* interpretive execution for PCI instructions
* PV attestation
* Minor fixes

----------------------------------------------------------------
Bagas Sanjaya (1):
      Documentation: kvm: extend KVM_S390_ZPCI_OP subheading underline

Christian Borntraeger (3):
      Merge tag 'kvm-s390-pci-5.20' into kernelorgnext
      KVM: s390/pci: fix include duplicates
      KVM: s390: Add facility 197 to the allow list

Claudio Imbrenda (12):
      KVM: s390: pv: leak the topmost page table when destroy fails
      KVM: s390: pv: handle secure storage violations for protected guests
      KVM: s390: pv: handle secure storage exceptions for normal guests
      KVM: s390: pv: refactor s390_reset_acc
      KVM: s390: pv: usage counter instead of flag
      KVM: s390: pv: add export before import
      KVM: s390: pv: clear the state without memset
      KVM: s390: pv: Add kvm_s390_cpus_from_pv to kvm-s390.h and add documentation
      KVM: s390: pv: add mmu_notifier
      s390/mm: KVM: pv: when tearing down, try to destroy protected pages
      KVM: s390: pv: refactoring of kvm_s390_pv_deinit_vm
      KVM: s390: pv: destroy the configuration before its memory

Jiang Jian (1):
      KVM: s390: drop unexpected word 'and' in the comments

Matthew Rosato (21):
      s390/sclp: detect the zPCI load/store interpretation facility
      s390/sclp: detect the AISII facility
      s390/sclp: detect the AENI facility
      s390/sclp: detect the AISI facility
      s390/airq: pass more TPI info to airq handlers
      s390/airq: allow for airq structure that uses an input vector
      s390/pci: externalize the SIC operation controls and routine
      s390/pci: stash associated GISA designation
      s390/pci: stash dtsm and maxstbl
      vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
      KVM: s390: pci: add basic kvm_zdev structure
      KVM: s390: pci: do initial setup for AEN interpretation
      KVM: s390: pci: enable host forwarding of Adapter Event Notifications
      KVM: s390: mechanism to enable guest zPCI Interpretation
      KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding
      KVM: s390: pci: add routines to start/stop interpretive execution
      vfio-pci/zdev: add open/close device hooks
      vfio-pci/zdev: add function handle to clp base capability
      vfio-pci/zdev: different maxstbl for interpreted devices
      KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
      MAINTAINERS: additional files related kvm s390 pci passthrough

Nico Boehr (1):
      KVM: s390: pv: don't present the ecall interrupt twice

Pierre Morel (3):
      KVM: s390: Cleanup ipte lock access and SIIF facility checks
      KVM: s390: guest support for topology function
      KVM: s390: resetting the Topology-Change-Report

Steffen Eiden (1):
      s390: Add attestation query information

 Documentation/virt/kvm/api.rst      |  71 ++++
 MAINTAINERS                         |   1 +
 arch/s390/boot/uv.c                 |   2 +
 arch/s390/include/asm/airq.h        |   7 +-
 arch/s390/include/asm/gmap.h        |  39 +-
 arch/s390/include/asm/kvm_host.h    |  43 ++-
 arch/s390/include/asm/mmu.h         |   2 +-
 arch/s390/include/asm/mmu_context.h |   2 +-
 arch/s390/include/asm/pci.h         |  11 +
 arch/s390/include/asm/pci_clp.h     |   9 +-
 arch/s390/include/asm/pci_insn.h    |  29 +-
 arch/s390/include/asm/pgtable.h     |  21 +-
 arch/s390/include/asm/sclp.h        |   4 +
 arch/s390/include/asm/tpi.h         |  13 +
 arch/s390/include/asm/uv.h          |   8 +-
 arch/s390/include/uapi/asm/kvm.h    |   1 +
 arch/s390/kernel/uv.c               | 103 ++++++
 arch/s390/kvm/Kconfig               |   1 +
 arch/s390/kvm/Makefile              |   1 +
 arch/s390/kvm/gaccess.c             |  96 ++---
 arch/s390/kvm/gaccess.h             |   6 +-
 arch/s390/kvm/intercept.c           |  15 +
 arch/s390/kvm/interrupt.c           |  98 ++++-
 arch/s390/kvm/kvm-s390.c            | 211 ++++++++++-
 arch/s390/kvm/kvm-s390.h            |  11 +
 arch/s390/kvm/pci.c                 | 690 ++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h                 |  87 +++++
 arch/s390/kvm/priv.c                |  26 +-
 arch/s390/kvm/pv.c                  |  71 +++-
 arch/s390/kvm/sigp.c                |   4 +-
 arch/s390/kvm/vsie.c                |   8 +
 arch/s390/mm/fault.c                |  23 +-
 arch/s390/mm/gmap.c                 | 177 +++++++--
 arch/s390/pci/pci.c                 |  16 +
 arch/s390/pci/pci_clp.c             |   7 +
 arch/s390/pci/pci_insn.c            |   4 +-
 arch/s390/pci/pci_irq.c             |  48 +--
 arch/s390/tools/gen_facilities.c    |   1 +
 drivers/s390/char/sclp_early.c      |   4 +
 drivers/s390/cio/airq.c             |  12 +-
 drivers/s390/cio/qdio_thinint.c     |   6 +-
 drivers/s390/crypto/ap_bus.c        |   9 +-
 drivers/s390/virtio/virtio_ccw.c    |   6 +-
 drivers/vfio/pci/Kconfig            |  11 +
 drivers/vfio/pci/Makefile           |   2 +-
 drivers/vfio/pci/vfio_pci_core.c    |  10 +-
 drivers/vfio/pci/vfio_pci_zdev.c    |  35 +-
 include/linux/sched/user.h          |   3 +-
 include/linux/vfio_pci_core.h       |  12 +-
 include/uapi/linux/kvm.h            |  32 ++
 include/uapi/linux/vfio_zdev.h      |   7 +
 51 files changed, 1944 insertions(+), 172 deletions(-)
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h
