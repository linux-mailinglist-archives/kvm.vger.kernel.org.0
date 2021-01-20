Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6002FD0AE
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbhATMtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:49:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388385AbhATLoQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 06:44:16 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KBaeqe022584;
        Wed, 20 Jan 2021 06:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mWfXdUSwEOyiqniHeylHVpIJoi0TTJz2NAGWPnowU7A=;
 b=WjKhHEW6z3F35yqYHOC+AIRE9yjLydqP/9kZ/bjTW0icieI5v4E0K/HdlZkQXm6KuU3l
 m9ee2Ksy5/c5lh8OB+HkG0EkEFlFEDrTrvn5cehxyyplgSo7E0X+/KX06Us3LjVVZH4l
 9cNrQJ0cnc9yoNbwH1h+5sP4YYXsEORShQge5qrPHKT60QMxfEICyPz9seHo+dWe0M47
 FSzAWRCk72L/MTVkV2g3g+Busmfz7AGlebSYaX+1rC7iRrskdrT0/fmcA7tPI17GnUY+
 Rd3BGz6Y9c4qqxZwKWHUEuUha4iLsRNNehzgg0xzu7JZ2Tj3moy+JSgj0zJSB0nburYd 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366jnb24rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:34 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KBd8v8036323;
        Wed, 20 Jan 2021 06:43:33 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366jnb24qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:33 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KBfPqx013629;
        Wed, 20 Jan 2021 11:43:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3668parhcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 11:43:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KBhLbU21365148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 11:43:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04A24AE04D;
        Wed, 20 Jan 2021 11:43:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BAF6AE059;
        Wed, 20 Jan 2021 11:43:27 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 11:43:27 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/11] s390x update
Date:   Wed, 20 Jan 2021 06:41:47 -0500
Message-Id: <20210120114158.104559-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_02:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 mlxscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please pull the following changes or merge them on gitlab:

* Moved to SPDX license identifiers and cleaning up licenses
* Added test_bit(_inv)() & SCLP feature bit checking
* Added first SIE lib and test for nesting tests
* Added diag318 emulation test
* Small UV fix


Gitlab merge request:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/4


The following changes since commit 4a54e8a3a88be171814e31dd6ab9b7a766644e32:

  lib/alloc_page: Properly handle requests for fresh blocks (2021-01-19 13:18:54 -0500)

are available in the Git repository at:

  https://gitlab.com/frankja/kvm-unit-tests.git tags/s390x-2021-20-01

for you to fetch changes up to 88fb0e5d52be357d3aab854c5c16303fe1608335:

  s390x: Fix uv_call() exception behavior (2021-01-20 04:15:21 -0500)


Janosch Frank (11):
  s390x: Move to GPL 2 and SPDX license identifiers
  s390x: lib: Move to GPL 2 and SPDX license identifiers
  s390x: Add test_bit to library
  s390x: Consolidate sclp read info
  s390x: SCLP feature checking
  s390x: Split assembly into multiple files
  s390x: sie: Add SIE to lib
  s390x: sie: Add first SIE test
  s390x: Add diag318 intercept test
  s390x: Fix sclp.h style issues
  s390x: Fix uv_call() exception behavior

 lib/s390x/asm-offsets.c     |  15 ++-
 lib/s390x/asm/arch_def.h    |  13 ++-
 lib/s390x/asm/asm-offsets.h |   4 +-
 lib/s390x/asm/barrier.h     |   4 +-
 lib/s390x/asm/bitops.h      |  26 +++++
 lib/s390x/asm/cpacf.h       |   1 +
 lib/s390x/asm/facility.h    |   7 +-
 lib/s390x/asm/float.h       |   4 +-
 lib/s390x/asm/interrupt.h   |   4 +-
 lib/s390x/asm/io.h          |   4 +-
 lib/s390x/asm/mem.h         |   4 +-
 lib/s390x/asm/page.h        |   4 +-
 lib/s390x/asm/pgtable.h     |   4 +-
 lib/s390x/asm/sigp.h        |   4 +-
 lib/s390x/asm/spinlock.h    |   4 +-
 lib/s390x/asm/stack.h       |   4 +-
 lib/s390x/asm/time.h        |   4 +-
 lib/s390x/asm/uv.h          |  24 +++--
 lib/s390x/css.h             |   4 +-
 lib/s390x/css_dump.c        |   4 +-
 lib/s390x/css_lib.c         |   4 +-
 lib/s390x/interrupt.c       |  11 +-
 lib/s390x/io.c              |   6 +-
 lib/s390x/mmu.c             |   4 +-
 lib/s390x/mmu.h             |   4 +-
 lib/s390x/sclp-console.c    |   5 +-
 lib/s390x/sclp.c            |  61 +++++++++--
 lib/s390x/sclp.h            | 183 ++++++++++++++++++---------------
 lib/s390x/sie.h             | 198 ++++++++++++++++++++++++++++++++++++
 lib/s390x/smp.c             |  31 +++---
 lib/s390x/smp.h             |   4 +-
 lib/s390x/stack.c           |   4 +-
 lib/s390x/vm.c              |   3 +-
 lib/s390x/vm.h              |   3 +-
 s390x/Makefile              |   7 +-
 s390x/cmm.c                 |   4 +-
 s390x/cpu.S                 | 121 ++++++++++++++++++++++
 s390x/cpumodel.c            |   4 +-
 s390x/css.c                 |   4 +-
 s390x/cstart64.S            | 123 +---------------------
 s390x/diag10.c              |   4 +-
 s390x/diag288.c             |   4 +-
 s390x/diag308.c             |   5 +-
 s390x/emulator.c            |   4 +-
 s390x/gs.c                  |   4 +-
 s390x/iep.c                 |   4 +-
 s390x/intercept.c           |  23 ++++-
 s390x/macros.S              |  77 ++++++++++++++
 s390x/pfmf.c                |   4 +-
 s390x/sclp.c                |   4 +-
 s390x/selftest.c            |   4 +-
 s390x/sie.c                 | 113 ++++++++++++++++++++
 s390x/skey.c                |   4 +-
 s390x/skrf.c                |   4 +-
 s390x/smp.c                 |   4 +-
 s390x/sthyi.c               |   4 +-
 s390x/sthyi.h               |   4 +-
 s390x/stsi.c                |   4 +-
 s390x/unittests.cfg         |   3 +
 s390x/uv-guest.c            |  16 ++-
 s390x/vector.c              |   4 +-
 61 files changed, 831 insertions(+), 392 deletions(-)
 create mode 100644 lib/s390x/sie.h
 create mode 100644 s390x/cpu.S
 create mode 100644 s390x/macros.S
 create mode 100644 s390x/sie.c

-- 
2.25.1

