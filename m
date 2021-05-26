Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8841C391AE8
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbhEZO5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:57:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235077AbhEZO53 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 10:57:29 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QEYD7g138443;
        Wed, 26 May 2021 10:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=fZ/XWn2n2fJy0yY2iPtc8klpUSKaCGn1B4h736AIaW0=;
 b=T0E+9WsGSO5iwPjMCzmeAFNgfAPlZfUXq4z29/DHBT4o47N1ZZEKfvvP1NaX0icvMcR4
 HWgd6cb3+cPCHCK6SRPPCChwnkeEOdbMsbAxv4eeFZWpWcTxDxIXL2m0j2u5/HuYhs2b
 237Sx/IXMUiBtYjI3Dt0A3FMAx+t1h8PMLi3yg2a9Q4tgm7/L7f4TpjuYHkWLbGE6NFQ
 Xfbut9PDGs9aa03XAsXBKhf16slOsWcIwTjNvZMGDFwPJSlqTZ89qd05m73s8WwbwhqK
 cYwsnfsDlH27IzM0qcttoP0PASwvQBQhjV7+M6Jhx1sndRpNseBoNav+2mrGZZS4Cbd4 IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38sqtv1pqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:57 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QEY7ja137852;
        Wed, 26 May 2021 10:55:56 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38sqtv1pq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:56 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QEr2oP004171;
        Wed, 26 May 2021 14:55:54 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 38s1ssrbnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 14:55:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QEtM1s19988950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 14:55:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4408AA40CC;
        Wed, 26 May 2021 14:55:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B316AA408B;
        Wed, 26 May 2021 14:55:47 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.174.11])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 14:55:47 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 0/9] s390x update 2021-26-05
Date:   Wed, 26 May 2021 16:55:30 +0200
Message-Id: <20210526145539.52008-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n4BFQQrYZYYLG3XQ-WiWX59sQXMPda4x
X-Proofpoint-GUID: oQuH_dQEscI7NEbv-Zm69enHTl-HhIzY
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_09:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please merge or pull the following changes:
* SCLP feature probing
* SCLP cpu model check
* UV host tests

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/9

PIPELINE:
https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/309936640

PULL:
The following changes since commit 74ff0e9675ec6d9477f5e98ec7d5d50878fa7ebc:

  Merge branch 'arm/queue' into 'master' (2021-05-18 11:07:08 +0000)

are available in the Git repository at:

  https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-26-05

for you to fetch changes up to 21f5f67675830e1c088539656cdc0f63bc18e4e0:

  s390x: cpumodel: FMT2 and FMT4 SCLP test (2021-05-26 14:27:09 +0000)


Janosch Frank (9):
  s390x: uv-guest: Add invalid share location test
  s390x: Add more Ultravisor command structure definitions
  s390x: uv: Add UV lib
  s390x: Test for share/unshare call support before using them
  s390x: uv-guest: Test invalid commands
  s390x: Add UV host test
  s390x: sclp: Only fetch read info byte 134 if cpu entries are above it
  lib: s390x: sclp: Extend feature probing
  s390x: cpumodel: FMT2 and FMT4 SCLP test

 lib/s390x/asm/uv.h    | 152 ++++++++++++-
 lib/s390x/io.c        |   2 +
 lib/s390x/malloc_io.c |   5 +-
 lib/s390x/sclp.c      |  23 +-
 lib/s390x/sclp.h      |  39 +++-
 lib/s390x/uv.c        |  45 ++++
 lib/s390x/uv.h        |  10 +
 s390x/Makefile        |   2 +
 s390x/cpumodel.c      |  71 ++++++-
 s390x/uv-guest.c      |  60 +++++-
 s390x/uv-host.c       | 480 ++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 871 insertions(+), 18 deletions(-)
 create mode 100644 lib/s390x/uv.c
 create mode 100644 lib/s390x/uv.h
 create mode 100644 s390x/uv-host.c

-- 
2.31.1

