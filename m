Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995385007BF
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 10:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiDNIFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 04:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiDNIFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 04:05:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22014C7A2;
        Thu, 14 Apr 2022 01:03:23 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23E81jfQ019872;
        Thu, 14 Apr 2022 08:03:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=UfSsVSH/XbyaQgXIudfw2xx/cGQsp2ek6QQQcCCbzRs=;
 b=YhEhfRU6gdvK/vB92FqI0NfjNnTBn/91fShtbssSZBkDDLH3NVT59/Ns2uS45H5o8IiQ
 BIWIXRM43pYhpDqkBl1oN1Fml18gGXDK2xiqkO7mJhUqFFBfFLiHrVK9XqZu5IAYbnXb
 gAcnBzXgVOmSsUbx0wNRlLTyHnBFRqHj2XPDU0gUFPr3sW2q1/vT6X9o/ygDdGfqb7A8
 0Woe6bpCgab2IEcrR5ecv0ei8sns04fSf/Dqq2AJPsD/ORE8ZP14cl0eZnh1ai+MXjwc
 X34AYxuOEAwP6TEvvUWuE3CdZ4yj+nNRlXtEXQXugTP4we/Ri8cZolWfaxRIWlsklK6P Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fefr9g0x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:23 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23E82pvP026241;
        Thu, 14 Apr 2022 08:03:22 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fefr9g0wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:22 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23E7m2A1011844;
        Thu, 14 Apr 2022 08:03:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3fb1s8xfv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23E83QoH26935790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 08:03:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A22DAE055;
        Thu, 14 Apr 2022 08:03:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A769DAE053;
        Thu, 14 Apr 2022 08:03:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.1.140])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 08:03:16 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v10 00/19] KVM: s390: pv: implement lazy destroy for reboot
Date:   Thu, 14 Apr 2022 10:02:51 +0200
Message-Id: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IBeNWsp4oj2DqpiP8VrOPGKRIaDBmBNY
X-Proofpoint-GUID: JcWKZmzKKxHvUBRpaGIH5gPQXN7gq4gh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, when a protected VM was rebooted or when it was shut down,
its memory was made unprotected, and then the protected VM itself was
destroyed. Looping over the whole address space can take some time,
considering the overhead of the various Ultravisor Calls (UVCs). This
means that a reboot or a shutdown would take a potentially long amount
of time, depending on the amount of used memory.

This patchseries implements a deferred destroy mechanism for protected
guests. When a protected guest is destroyed, its memory can be cleared
in background, allowing the guest to restart or terminate significantly
faster than before.

There are 2 possibilities when a protected VM is torn down:
* it still has an address space associated (reboot case)
* it does not have an address space anymore (shutdown case)

For the reboot case, two new commands are available for the
KVM_S390_PV_COMMAND:

KVM_PV_ASYNC_DISABLE_PREPARE: prepares the current protected VM for
asynchronous teardown. The current VM will then continue immediately
as non-protected. If a protected VM had already been set aside without
starting the teardown process, this call will fail. In this case the
userspace process should issue a normal KVM_PV_DISABLE

KVM_PV_ASYNC_DISABLE: tears down the protected VM previously set aside
for asychronous teardown. This PV command should ideally be issued by
userspace from a separate thread. If a fatal signal is received (or
the process terminates naturally), the command will terminate
immediately without completing.

The idea is that userspace should first issue the
KVM_PV_ASYNC_DISABLE_PREPARE command, and in case of success, create a
new thread and issue KVM_PV_ASYNC_DISABLE from there. This also allows
for proper accounting of the CPU time needed for the asynchronous
teardown.

This means that the same address space can have memory belonging to
more than one protected guest, although only one will be running, the
others will in fact not even have any CPUs.

The shutdown case should be dealt with in userspace (e.g. using
clone(CLONE_VM)).

A module parameter is also provided to disable the new functionality,
which is otherwise enabled by default. This should not be an issue
since the new functionality is opt-in anyway. This is mainly thought to
aid debugging.

v9->v10
* improved and expanded comments, fix typos
* add new patch: perform destroy configuration UVC before clearing
  memory for unconditional deinit_vm (instead of afterwards)
* explicitly initialize kvm->arch.pv.async_deinit in kvm_arch_init_vm
* do not try to call the destroy fast UVC in the MMU notifier if it is
  not available

v8->v9
* rebased
* added dependency on MMU_NOTIFIER for KVM in arch/s390/kvm/Kconfig
* add support for the Destroy Secure Configuration Fast UVC
* minor fixes

v7->v8
* switched patches 8 and 9
* improved comments, documentation and patch descriptions
* remove mm notifier when the struct kvm is torn down
* removed useless locks in the mm notifier
* use _ASCE_ORIGIN instead of PAGE_MASK for ASCEs
* cleanup of some compiler warnings
* remove some harmless but useless duplicate code
* the last parameter of __s390_uv_destroy_range is now bool
* rename the KVM capability to KVM_CAP_S390_PROTECTED_ASYNC_DISABLE

v6->v7
* moved INIT_LIST_HEAD inside spinlock in patch 1
* improved commit messages in patch 2
* added missing locks in patch 3
* added and expanded some comments in patch 11
* rebased

v5->v6
* completely reworked the series
* removed kernel thread for asynchronous teardown
* added new commands to KVM_S390_PV_COMMAND ioctl

v4->v5
* fixed and improved some patch descriptions
* added some comments to better explain what's going on
* use vma_lookup instead of find_vma
* rename is_protected to protected_count since now it's used as a counter

v3->v4
* added patch 2
* split patch 3
* removed the shutdown part -- will be a separate patchseries
* moved the patch introducing the module parameter

v2->v3
* added definitions for CC return codes for the UVC instruction
* improved make_secure_pte:
  - renamed rc to cc
  - added comments to explain why returning -EAGAIN is ok
* fixed kvm_s390_pv_replace_asce and kvm_s390_pv_remove_old_asce:
  - renamed
  - added locking
  - moved to gmap.c
* do proper error management in do_secure_storage_access instead of
  trying again hoping to get a different exception
* fix outdated patch descriptions

v1->v2
* rebased on a more recent kernel
* improved/expanded some patch descriptions
* improves/expanded some comments
* added patch 1, which prevents stall notification when the system is
  under heavy load.
* rename some members of struct deferred_priv to improve readability
* avoid an use-after-free bug of the struct mm in case of shutdown
* add missing return when lazy destroy is disabled
* add support for OOM notifier

Claudio Imbrenda (19):
  KVM: s390: pv: leak the topmost page table when destroy fails
  KVM: s390: pv: handle secure storage violations for protected guests
  KVM: s390: pv: handle secure storage exceptions for normal guests
  KVM: s390: pv: refactor s390_reset_acc
  KVM: s390: pv: usage counter instead of flag
  KVM: s390: pv: add export before import
  KVM: s390: pv: module parameter to fence lazy destroy
  KVM: s390: pv: clear the state without memset
  KVM: s390: pv: Add kvm_s390_cpus_from_pv to kvm-s390.h and add
    documentation
  KVM: s390: pv: add mmu_notifier
  s390/mm: KVM: pv: when tearing down, try to destroy protected pages
  KVM: s390: pv: refactoring of kvm_s390_pv_deinit_vm
  KVM: s390: pv: destroy the configuration before its memory
  KVM: s390: pv: cleanup leftover protected VMs if needed
  KVM: s390: pv: asynchronous destroy for reboot
  KVM: s390: pv: api documentation for asynchronous destroy
  KVM: s390: pv: add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
  KVM: s390: pv: avoid export before import if possible
  KVM: s390: pv: support for Destroy fast UVC

 Documentation/virt/kvm/api.rst      |  25 ++-
 arch/s390/include/asm/gmap.h        |  39 +++-
 arch/s390/include/asm/kvm_host.h    |   4 +
 arch/s390/include/asm/mmu.h         |   2 +-
 arch/s390/include/asm/mmu_context.h |   2 +-
 arch/s390/include/asm/pgtable.h     |  20 +-
 arch/s390/include/asm/uv.h          |  11 +
 arch/s390/kernel/uv.c               |  64 ++++++
 arch/s390/kvm/Kconfig               |   1 +
 arch/s390/kvm/kvm-s390.c            |  65 +++++-
 arch/s390/kvm/kvm-s390.h            |   3 +
 arch/s390/kvm/pv.c                  | 299 +++++++++++++++++++++++++++-
 arch/s390/mm/fault.c                |  23 ++-
 arch/s390/mm/gmap.c                 | 167 +++++++++++++---
 include/uapi/linux/kvm.h            |   3 +
 15 files changed, 681 insertions(+), 47 deletions(-)

-- 
2.34.1

