Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312B43AFF12
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhFVIXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:23:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229628AbhFVIXu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:23:50 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M8I9Dh153731;
        Tue, 22 Jun 2021 04:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=guOHEWAUJmaU4W/263HDVfe89kN/IbabEf98436S2Yw=;
 b=Yo4PA4zdZoiPo7Ax3nkRfsAXd+j+eKgU+7YVIGJuqzJjYeEYfAI+AyGMHuSSMjdxnIOS
 zhw0/3HlPQSY/rB42xSO75mmpL52MmJVDoNe1dvjwlqdcSUrTyh6vPi75UfqmHp33d2d
 sEM5zZ5VP9IZUwiS14Xl6GJvQGG4m3viiMUFps/Jbk+q18udsg3ZP3VeMSlMZUPZAs5A
 97kbW+Y1Q/krrwqXTv1KBsh1JVMwRvgraCzsE7JD7cayqlIifNriDTiS/uJmyPkwdrGC
 oaCIWkHSgFh96n83Z1HDfgadvAQcZ6GAZQ5F6Qr3h/in7zJhP+UQxfLg6L2l4M5glxZx ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bc7yr1ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:35 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M8Ilpe154249;
        Tue, 22 Jun 2021 04:21:34 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bc7yr1hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:34 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8DQcc007660;
        Tue, 22 Jun 2021 08:21:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3998788q5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8KCOE25821640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:20:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5147EAE051;
        Tue, 22 Jun 2021 08:21:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C55DCAE04D;
        Tue, 22 Jun 2021 08:21:28 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 00/12] s390x update 2021-22-06
Date:   Tue, 22 Jun 2021 10:20:30 +0200
Message-Id: <20210622082042.13831-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ODtYAHCpvJ5BEwSK2Ik-QMMpmxT2_Y3a
X-Proofpoint-ORIG-GUID: qkGw2IGNcoHwmaqxCETnxtYfZr8f-cl6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please merge or pull the following changes:

Merge:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/11

Pipeline:
https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/324608397

Pull:
The following changes since commit f09465ac9044145f20435344d41566aede62fc08:

  x86: Flush the TLB after setting user-bit (2021-06-17 14:36:25 -0400)

are available in the Git repository at:

  https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-22-06

for you to fetch changes up to d58ec2ec341cbea746944a8ae92c737041c35172:

  s390x: edat test (2021-06-21 14:55:12 +0000)


Claudio Imbrenda (7):
  s390x: lib: add and use macros for control register bits
  libcflat: add SZ_1M and SZ_2G
  s390x: lib: fix pgtable.h
  s390x: lib: Add idte and other huge pages functions/macros
  s390x: lib: add teid union and clear teid from lowcore
  s390x: mmu: add support for large pages
  s390x: edat test

Janosch Frank (5):
  s390x: sie: Only overwrite r3 if it isn't needed anymore
  s390x: selftest: Add prefixes to fix report output
  s390x: Don't run PV testcases under tcg
  configure: s390x: Check if the host key document exists
  s390x: run: Skip PV tests when tcg is the accelerator

 configure                 |   5 +
 lib/libcflat.h            |   2 +
 lib/s390x/asm/arch_def.h  |  12 ++
 lib/s390x/asm/float.h     |   4 +-
 lib/s390x/asm/interrupt.h |  28 +++-
 lib/s390x/asm/pgtable.h   |  44 +++++-
 lib/s390x/interrupt.c     |   2 +
 lib/s390x/mmu.c           | 264 ++++++++++++++++++++++++++++++++----
 lib/s390x/mmu.h           |  84 +++++++++++-
 lib/s390x/sclp.c          |   4 +-
 s390x/Makefile            |   1 +
 s390x/cpu.S               |   2 +-
 s390x/diag288.c           |   2 +-
 s390x/edat.c              | 274 ++++++++++++++++++++++++++++++++++++++
 s390x/gs.c                |   2 +-
 s390x/iep.c               |   4 +-
 s390x/run                 |   5 +
 s390x/selftest.c          |  26 ++--
 s390x/skrf.c              |   2 +-
 s390x/smp.c               |   8 +-
 s390x/unittests.cfg       |   3 +
 s390x/vector.c            |   2 +-
 scripts/s390x/func.bash   |   3 +
 23 files changed, 724 insertions(+), 59 deletions(-)
 create mode 100644 s390x/edat.c

-- 
2.31.1

