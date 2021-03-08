Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABABC3310D6
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhCHOdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:33:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229468AbhCHOdm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:42 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EWnYF161015;
        Mon, 8 Mar 2021 09:33:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YQ2xqBz+K61sY8lEOElTHWKKvhBTkNPn9aAf7ENPDZo=;
 b=GS/xtQSs42vHrd3mEW6M+6dWjva1hs+6Q60tKeqHAyzbLo/H0iRKmmwsHVYPMxiFQOkC
 SpDLPSQ65a/05yn5gCLuv+rvkUNQJdrLl7IeN5A238vg0vyeIM/eCqGJn7yNjjsJC4WL
 P5BNHmWXv1+3bn5myY0+7f4RBPqphEEEKANvmUVfYAKu3xFYWf99qvoS6oVjxxQw2eI8
 K7rIeHLOT7jk5cODkdBhgwOgfkT3svnj+oj5OR7Vdah4WOJ2w6aNenaOKLMj79UuSiIH
 km8h8Des1kHuI1naPgIUOsgR+tJ9sdFWDEAqYznxRnFQQnYol3vVoox1uvO00QaADGDR 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375nsk80r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:41 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EWoSx161041;
        Mon, 8 Mar 2021 09:33:41 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375nsk80qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:41 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EXOPk028755;
        Mon, 8 Mar 2021 14:33:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3741c89wfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXbu040108302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9741A4053;
        Mon,  8 Mar 2021 14:33:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75827A4055;
        Mon,  8 Mar 2021 14:33:36 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/16] s390x update
Date:   Mon,  8 Mar 2021 15:31:31 +0100
Message-Id: <20210308143147.64755-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please merge or pull the following changes:
 * IO tests PV compatibility (Pierre)
 * Backtrace support (Janosch)
 * mvpg test (Claudio)
 * Fixups (Thomas)


MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/5


PULL:
The following changes since commit 739f7de6b3c8deaf22d2fa5e6016ad2c7bd22ddc:

  x86: clean up EFER definitions (2021-02-18 13:31:22 -0500)

are available in the Git repository at:

  https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-08-03

for you to fetch changes up to b7f0f9a2e1fdb9d4235164f0a8d8ea880e1cefd4:

  s390x: mvpg: skip some tests when using TCG (2021-03-08 12:03:47 +0100)

----------------------------------------------------------------
Claudio Imbrenda (3):
  s390x: introduce leave_pstate to leave userspace
  s390x: mvpg: simple test
  s390x: mvpg: skip some tests when using TCG

Janosch Frank (8):
  s390x: Remove sthyi partition number check
  s390x: Fix fpc store address in RESTORE_REGS_STACK
  s390x: Fully commit to stack save area for exceptions
  s390x: Introduce and use CALL_INT_HANDLER macro
  s390x: Provide preliminary backtrace support
  s390x: Print more information on program exceptions
  s390x: Move diag308_load_reset to stack saving
  s390x: Remove SAVE/RESTORE_STACK and lowcore fpc and fprs save areas

Pierre Morel (3):
  s390x: pv: implement routine to share/unshare memory
  s390x: define UV compatible I/O allocation
  s390x: css: pv: css test adaptation for PV

Thomas Huth (2):
  lib/s390x/sclp: Clarify that the CPUEntry array could be at a
    different spot
  Fix the length in the stsi check for the VM name

 lib/s390x/asm-offsets.c   |  17 ++-
 lib/s390x/asm/arch_def.h  |  42 ++++--
 lib/s390x/asm/interrupt.h |   4 +-
 lib/s390x/asm/uv.h        |  39 ++++++
 lib/s390x/css.h           |   3 +-
 lib/s390x/css_lib.c       |  28 ++--
 lib/s390x/interrupt.c     |  61 +++++++--
 lib/s390x/malloc_io.c     |  71 ++++++++++
 lib/s390x/malloc_io.h     |  45 +++++++
 lib/s390x/sclp.h          |   9 +-
 lib/s390x/stack.c         |  20 ++-
 s390x/Makefile            |   3 +
 s390x/cpu.S               |   6 +-
 s390x/css.c               |  43 ++++--
 s390x/cstart64.S          |  25 +---
 s390x/macros.S            |  96 ++++++-------
 s390x/mvpg.c              | 277 ++++++++++++++++++++++++++++++++++++++
 s390x/sthyi.c             |   1 -
 s390x/stsi.c              |   2 +-
 s390x/unittests.cfg       |   4 +
 20 files changed, 657 insertions(+), 139 deletions(-)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h
 create mode 100644 s390x/mvpg.c

-- 
2.29.2

