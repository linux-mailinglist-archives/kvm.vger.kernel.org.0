Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E113ED6B9
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbhHPNXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:23:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30516 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237308AbhHPNVq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:46 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD5g7p056732;
        Mon, 16 Aug 2021 09:21:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=ehE3Lg/5UjDftoPTqUH99EseAM97zPwJoDlBcB/4kvE=;
 b=jldeLA32jjvEXHYlWHyzU3B4691+ppDa+e46dDyFHgT8u3aVWunN7l9tyRLui0sykyFh
 k+ppWrfCaYwED58B/9xio3Wbu08jtwTfZFeQr5O1VJsmC8VVIj+4Wfl7MVKJzq1F9d1U
 +Gn1JEoKAYLRW32TLDbUSKloyLdNKR/cmwQubYDhe0dts8z79PPW4oeFBXF2wkTe92Gb
 aUiTdyr2nO5p29GDpP352x1bgugDwwSvFhlok0oODTSFVdL39lVXb/waObl7RJoWydM7
 DUi2BKmk0ed/qXQWcHZnrrGsyKE8rTlcVTi+/3iCTo7fc5DIdviUtihg7AtxulpaTWzn tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeud8ffu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:14 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GD5qdt057642;
        Mon, 16 Aug 2021 09:21:14 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeud8fftk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:14 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDCEcW030749;
        Mon, 16 Aug 2021 13:21:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ae5f8twp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDHko258261886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:17:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC82211C054;
        Mon, 16 Aug 2021 13:21:08 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C0FC11C070;
        Mon, 16 Aug 2021 13:21:08 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.144.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 13:21:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 00/11] s390x update 2021-16-08
Date:   Mon, 16 Aug 2021 15:20:43 +0200
Message-Id: <20210816132054.60078-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O3Bd_Y_zQVImfLhO-u3fgusG-ZdEOPy-
X-Proofpoint-ORIG-GUID: jafOcFO2cTJCbWuPYIBKkZ16WyjitWuY
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please merge or pull the following changes:

 - SPDX cleanup
 - SIE lib extensions
 - Fixes/cleanup in the lib

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/15

PIPELINE:
https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/353890035

PULL:
The following changes since commit c90c646d7381c99ac7d9d7812bd8535214458978:

  access: treat NX as reserved if EFER.NXE=0 (2021-08-13 07:29:28 -0400)

are available in the Git repository at:

  https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-16-08

for you to fetch changes up to 454da83a513761a0cd2bfda08f335735f345ef87:

  lib: s390x: Add PSW_MASK_64 (2021-08-16 11:28:02 +0000)

Janosch Frank (10):
  s390x: Add SPDX and header comments for s390x/* and lib/s390x/*
  s390x: Add SPDX and header comments for the snippets folder
  s390x: Fix my mail address in the headers
  s390x: sie: Add sie lib validity handling
  s390x: lib: Introduce HPAGE_* constants
  s390x: lib: sie: Add struct vm (de)initialization functions
  lib: s390x: sie: Move sie function into library
  lib: s390x: Add 0x3d, 0x3e and 0x3f PGM constants
  lib: s390x: uv: Add rc 0x100 query error handling
  lib: s390x: Add PSW_MASK_64

Pierre Morel (1):
  s390x: lib: Simplify stsi_get_fc and move it to library

 lib/s390x/asm/arch_def.h        | 22 +++++++++
 lib/s390x/asm/mem.h             |  2 +-
 lib/s390x/asm/page.h            |  4 ++
 lib/s390x/interrupt.c           |  3 ++
 lib/s390x/mmu.h                 |  2 +-
 lib/s390x/sie.c                 | 83 +++++++++++++++++++++++++++++++++
 lib/s390x/sie.h                 |  7 +++
 lib/s390x/smp.c                 |  2 +-
 lib/s390x/stack.c               |  2 +-
 lib/s390x/uv.c                  | 13 +++++-
 s390x/Makefile                  |  1 +
 s390x/gs.c                      |  2 +-
 s390x/iep.c                     |  2 +-
 s390x/mvpg-sie.c                | 42 +++++------------
 s390x/sie.c                     | 53 ++++++---------------
 s390x/skrf.c                    |  6 +--
 s390x/snippets/c/cstart.S       |  9 ++++
 s390x/snippets/c/mvpg-snippet.c |  9 ++++
 s390x/stsi.c                    | 20 +-------
 s390x/vector.c                  |  2 +-
 20 files changed, 188 insertions(+), 98 deletions(-)
 create mode 100644 lib/s390x/sie.c

-- 
2.31.1

