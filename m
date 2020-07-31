Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F45423438D
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732373AbgGaJq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:46:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731922AbgGaJq0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 05:46:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V9Vi7q046934;
        Fri, 31 Jul 2020 05:46:24 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32mfpj20wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:46:24 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06V9Vkr2047072;
        Fri, 31 Jul 2020 05:46:24 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32mfpj20w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:46:24 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V9kAIS001654;
        Fri, 31 Jul 2020 09:46:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 32gcpx740n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 09:46:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06V9kJDS62193928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 09:46:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9451AAE053;
        Fri, 31 Jul 2020 09:46:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23C1DAE04D;
        Fri, 31 Jul 2020 09:46:19 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.62.184])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jul 2020 09:46:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        thuth@redhat.com, pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/11] s390x patches
Date:   Fri, 31 Jul 2020 11:45:56 +0200
Message-Id: <20200731094607.15204-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_02:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

The following changes since commit 82147b77199bbfec2c61c97685cfb34f3f97c889:

  fw_cfg: avoid index out of bounds (2020-07-30 17:57:55 -0400)

are available in the Git repository at:

  https://github.com/frankjaa/kvm-unit-tests.git tags/s390x-2020-31-07

for you to fetch changes up to c2f4799a861993b82950b9e5a3a44fc65ba05ec6:

  s390x: fix inline asm on gcc10 (2020-07-31 04:35:33 -0400)

----------------------------------------------------------------
* IO tests from Pierre
* GCC 10 compile fix from Claudio
* CPU model test fix from Thomas
----------------------------------------------------------------

Claudio Imbrenda (1):
  s390x: fix inline asm on gcc10

Pierre Morel (9):
  s390x: saving regs for interrupts
  s390x: I/O interrupt registration
  s390x: export the clock get_clock_ms() utility
  s390x: clock and delays calculations
  s390x: define function to wait for interrupt
  s390x: Library resources for CSS tests
  s390x: css: stsch, enumeration test
  s390x: css: msch, enable test
  s390x: css: ssch/tsch with sense and interrupt

Thomas Huth (1):
  s390x/cpumodel: The missing DFP facility on TCG is expected

 lib/s390x/asm/arch_def.h |  14 ++
 lib/s390x/asm/cpacf.h    |   5 +-
 lib/s390x/asm/time.h     |  50 ++++++
 lib/s390x/css.h          | 294 +++++++++++++++++++++++++++++++++++
 lib/s390x/css_dump.c     | 152 +++++++++++++++++++
 lib/s390x/css_lib.c      | 320 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/interrupt.c    |  23 ++-
 lib/s390x/interrupt.h    |   8 +
 lib/s390x/vm.c           |  46 ++++++
 lib/s390x/vm.h           |  14 ++
 s390x/Makefile           |   4 +
 s390x/cpumodel.c         |  19 ++-
 s390x/css.c              | 150 ++++++++++++++++++
 s390x/cstart64.S         |  41 ++++-
 s390x/emulator.c         |  25 +--
 s390x/intercept.c        |  11 +-
 s390x/unittests.cfg      |   4 +
 17 files changed, 1147 insertions(+), 33 deletions(-)
 create mode 100644 lib/s390x/asm/time.h
 create mode 100644 lib/s390x/css.h
 create mode 100644 lib/s390x/css_dump.c
 create mode 100644 lib/s390x/css_lib.c
 create mode 100644 lib/s390x/interrupt.h
 create mode 100644 lib/s390x/vm.c
 create mode 100644 lib/s390x/vm.h
 create mode 100644 s390x/css.c

-- 
2.25.4

