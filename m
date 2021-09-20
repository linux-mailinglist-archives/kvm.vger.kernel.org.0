Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CED411586
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbhITN0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:26:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53646 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235999AbhITN0h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:26:37 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD351008139;
        Mon, 20 Sep 2021 09:25:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=B4RQ/9HgU9wLNITAjWryN+1uWQszbgP8cnJLufN5sTw=;
 b=GzwYAK9dlVLJzG4wuOl4tXo4QbC8RQROhec6QTW+JP31MT6d9qyhGVMUBUGNGquOxzNV
 8x1FOh7P7FsC1MIf7knHT/fnQX1NM0QwcFd1saMUaT0AeIVxq8bRECtkwHyeMVdV/LSE
 X9aaAa3O2dK4BafXdqh7KysjvhMU5q29XuIMtDp7kPUWO7wDKv3JUZfLuTvzhfoRgnw8
 N+b7dtrsxhzNzyJfILuwpZh5L8Gm+y5T+L29lsCUJC/ZbFOBzL3e+PNPpYoEw2aqb84O
 TdbgOsOjI0AIL1ihIl/xjbrYNAKNJPqGJXSysi1AHy+ZnmBpdfLZYGUJ80+DVWmYzLNa QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wjy1jc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:09 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDNChN012253;
        Mon, 20 Sep 2021 09:25:09 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wjy1jb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:09 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD6tW030518;
        Mon, 20 Sep 2021 13:25:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3b57r903vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:25:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDKKFS61669808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:20:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0704A406D;
        Mon, 20 Sep 2021 13:25:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A306A4040;
        Mon, 20 Sep 2021 13:25:02 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.9.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 13:25:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v5 00/14] KVM: s390: pv: implement lazy destroy for reboot
Date:   Mon, 20 Sep 2021 15:24:48 +0200
Message-Id: <20210920132502.36111-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 84VXZJh3MeivruS--m_JYr5MJAQK32PX
X-Proofpoint-ORIG-GUID: YLC-af-oj-yD04htae4S37ZUmdPCBRNh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 adultscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200079
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
guests. When a protected guest is destroyed, its memory is cleared in
background, allowing the guest to restart or terminate significantly
faster than before.

There are 2 possibilities when a protected VM is torn down:
* it still has an address space associated (reboot case)
* it does not have an address space anymore (shutdown case)

For the reboot case, the reference count of the mm is increased, and
then a background thread is started to clean up. Once the thread went
through the whole address space, the protected VM is actually
destroyed.

This means that the same address space can have memory belonging to
more than one protected guest, although only one will be running, the
others will in fact not even have any CPUs.

The shutdown case is more controversial, and it will be dealt with in a
future patchseries.

When a guest is destroyed, its memory still counts towards its memory
control group until it's actually freed (I tested this experimentally)

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

Claudio Imbrenda (14):
  KVM: s390: pv: add macros for UVC CC values
  KVM: s390: pv: avoid double free of sida page
  KVM: s390: pv: avoid stalls for kvm_s390_pv_init_vm
  KVM: s390: pv: avoid stalls when making pages secure
  KVM: s390: pv: leak the topmost page table when destroy fails
  KVM: s390: pv: properly handle page flags for protected guests
  KVM: s390: pv: handle secure storage violations for protected guests
  KVM: s390: pv: handle secure storage exceptions for normal guests
  KVM: s390: pv: refactor s390_reset_acc
  KVM: s390: pv: usage counter instead of flag
  KVM: s390: pv: add export before import
  KVM: s390: pv: module parameter to fence lazy destroy
  KVM: s390: pv: lazy destroy for reboot
  KVM: s390: pv: avoid export before import if possible

 arch/s390/include/asm/gmap.h        |   6 +-
 arch/s390/include/asm/mmu.h         |   2 +-
 arch/s390/include/asm/mmu_context.h |   2 +-
 arch/s390/include/asm/pgtable.h     |  11 +-
 arch/s390/include/asm/uv.h          |  16 ++-
 arch/s390/kernel/uv.c               | 118 ++++++++++++++++--
 arch/s390/kvm/intercept.c           |   5 +
 arch/s390/kvm/kvm-s390.c            |   6 +-
 arch/s390/kvm/kvm-s390.h            |   2 +-
 arch/s390/kvm/pv.c                  | 187 ++++++++++++++++++++++++----
 arch/s390/mm/fault.c                |  20 ++-
 arch/s390/mm/gmap.c                 | 141 +++++++++++++++++----
 12 files changed, 447 insertions(+), 69 deletions(-)

-- 
2.31.1

