Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A57431942
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhJRMkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhJRMkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IBKcTJ029815;
        Mon, 18 Oct 2021 08:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Oaa0CwHdnMSalrAjplpMQD30im/qcLAuqUmWaPRnQpU=;
 b=jJTNNGYs0XWsKByeX2LKePfdPE6mUNyi6Hxl9GMUhyW3JiDClZxC3RUifT4m7TkVxF9v
 oF96fWUWR2mE5X3kHNuqiU51Sl9VPTVB6eV+qJNLe7S0GEs7aKTllMlFTJCNb741VCZc
 znWVExrptisuj1+A+oXkS4TrViQA11mn72HG2NqIHDeLGZDgbpo9qo78a+EH4wgDNdBt
 oHzD6hOZGueEeZFygGI4zLE6hWOAkSr6SCEwndPO/qBKSPDX7tCwOvnhqJJr3GluFZB7
 Ifikip71HfDlBhptxNV/qx3BCjMbWqxDi62OIBIXbMDfefR4zfDMHa//4jzpUjG5kYdU Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs7yg1m74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:04 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19IBVFkJ003401;
        Mon, 18 Oct 2021 08:38:03 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs7yg1m6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:03 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbKeS005239;
        Mon, 18 Oct 2021 12:38:01 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3bqpc9cyk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:01 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICbwDk48038238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:37:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 091185204E;
        Mon, 18 Oct 2021 12:37:58 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 856405205A;
        Mon, 18 Oct 2021 12:37:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 00/17] s390x update 2021-10-18
Date:   Mon, 18 Oct 2021 14:26:18 +0200
Message-Id: <20211018122635.53614-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dN1eH0zNla2itZFXoV-QviTI7nEVkbRQ
X-Proofpoint-GUID: v_r4jgV-2yWUuyo9aSenyuZBeI9lHAPz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please merge or pull the following changes:
       * Skey addressing exception test (David)
       * sthyi reg 2 + 1 check (Janosch)
       * General cleanup (Thomas, Janosch & Janis)
       * Snippet cleanup (Thomas & Janosch)

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/18

PIPELINE:
https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/390243055

The pipeline fails because the new SKEY checks fail without a QEMU fix
which is not yet in the CI's QEMU version. I've already contacted
Thomas about this.

PULL:
The following changes since commit b4667f4ca26aea926a2ddecfcb5669e0e4e7cbf4:

  arm64: gic-v3: Avoid NULL dereferences (2021-10-12 09:33:49 +0200)

are available in the Git repository at:

  https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-10-18

for you to fetch changes up to a2b44f223e7655155ff926eea60eb40e0b4d14f5:

  lib: s390x: Fix copyright message (2021-10-18 09:31:39 +0000)

----------------------------------------------------------------

David Hildenbrand (1):
  s390x: skey: Test for ADDRESSING exceptions

Janis Schoetterl-Glausch (1):
  lib: s390x: Add access key argument to tprot

Janosch Frank (13):
  s390x: uv-host: Explain why we set up the home space and remove the
    space change
  lib: s390x: Control register constant cleanup
  lib: s390x: Print addressing related exception information
  s390x: uv: Tolerate 0x100 query return code
  s390x: uv-host: Fence a destroy cpu test on z15
  lib: s390x: uv: Fix share return value and print
  lib: s390x: uv: Add UVC_ERR_DEBUG switch
  lib: s390x: Print PGM code as hex
  s390x: Add sthyi cc==0 r2+1 verification
  s390x: snippets: Set stackptr and stacktop in cstart.S
  lib: s390x: Fix PSW constant
  lib: s390x: snippet.h: Add a few constants that will make our life
    easier
  lib: s390x: Fix copyright message

Thomas Huth (2):
  s390x: mvpg-sie: Remove unused variable
  s390x: snippets: Define all things that are needed to link the libc

 lib/s390x/asm/arch_def.h  | 55 +++++++++++++++++-----------
 lib/s390x/asm/mem.h       | 12 +++++++
 lib/s390x/asm/uv.h        | 21 ++++++-----
 lib/s390x/css.h           |  2 +-
 lib/s390x/fault.c         | 76 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/fault.h         | 44 +++++++++++++++++++++++
 lib/s390x/interrupt.c     | 29 +++++++++++++--
 lib/s390x/sclp.c          |  2 +-
 lib/s390x/sclp.h          |  2 +-
 lib/s390x/smp.c           |  3 +-
 lib/s390x/snippet.h       | 34 ++++++++++++++++++
 s390x/Makefile            |  3 +-
 s390x/mvpg-sie.c          | 16 ++++-----
 s390x/skey.c              | 28 +++++++++++++++
 s390x/skrf.c              |  6 ++--
 s390x/snippets/c/cstart.S | 13 ++++++-
 s390x/snippets/c/flat.lds |  2 ++
 s390x/sthyi.c             | 21 ++++++-----
 s390x/uv-guest.c          |  4 ++-
 s390x/uv-host.c           | 30 ++++++++++------
 20 files changed, 333 insertions(+), 70 deletions(-)
 create mode 100644 lib/s390x/fault.c
 create mode 100644 lib/s390x/fault.h
 create mode 100644 lib/s390x/snippet.h

-- 
2.31.1

