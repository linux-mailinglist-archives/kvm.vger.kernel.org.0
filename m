Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9604E3BE939
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhGGOGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:06:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231631AbhGGOGP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:06:15 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167E3VLu124404;
        Wed, 7 Jul 2021 10:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=K+R8+3MHE3zIf59ukIN0Ynk4o375oDG64/SpJmwPcgs=;
 b=JhGM8Kr40P31Les/ZIRgH5drFldQiWo4ldGjLBwpyE1CwsuAICxpBD3vpxN9o1BZyy+G
 fdc75LmOjyUYJSspZV7UimBfKtldGXrJPAQnuwGDbWDg95tXrrM1ZPCrkIOrP6e8HGmV
 thJcwWUQbTFIGtUXDAPjz4O82x4fQPIyN2GyPOZRPskIIq7n/md4/q9Dooz6HLVMfIet
 Lb2P331b6EY2zC2eR2WUuqvSDu4dgKqQ8RM7RZw+s6OblEQ6ySgzbAWNenR31uYB9mlj
 8FeBRXLcPDEf2rABX+TUIR0BZaH5FfD5+Tkku781jqwaQXrLeGQFs8VUvLsHbl/gSdRX hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mbkf4des-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:34 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167E3XWX124637;
        Wed, 7 Jul 2021 10:03:33 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mbkf4ddg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:33 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167E3UO7002904;
        Wed, 7 Jul 2021 14:03:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 39jfh8gy4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 14:03:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167E1Ww631523282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 14:01:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17335A4057;
        Wed,  7 Jul 2021 14:03:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AF8AA405F;
        Wed,  7 Jul 2021 14:03:26 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.29.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 14:03:26 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 0/8] s390x update 2021-07-07
Date:   Wed,  7 Jul 2021 16:03:10 +0200
Message-Id: <20210707140318.44255-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tXVrxvc8c6vlPftT_P9oWR7sEP__sehy
X-Proofpoint-ORIG-GUID: eeD6zcMoFfo31S9832CSl9EUyrmZ6ilu
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please merge or pull the following changes:

* Add snippet support that makes starting guests in tests easier
* Cleanup

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/13

PIPELINE:
https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/333035606

PULL:
The following changes since commit bc6f264386b4cb2cadc8b2492315f3e6e8a801a2:

  Merge branch 'arm/queue' into 'master' (2021-06-30 13:35:55 +0000)

are available in the Git repository at:

  https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-07-07

for you to fetch changes up to 81598ca0d3fbeb52e02eecf5ddbc15e30f8c600a:

  lib: s390x: Remove left behing PGM report (2021-07-07 08:00:29 +0000)

Janosch Frank (7):
  s390x: snippets: Add gitignore as well as linker script and start
    assembly
  s390x: mvpg: Add SIE mvpg test
  s390x: sie: Add missing includes
  s390x: sie: Fix sie.h integer types
  lib: s390x: uv: Add offset comments to uv_query and extend it
  lib: s390x: Print if a pgm happened while in SIE
  lib: s390x: Remove left behing PGM report

Steffen Eiden (1):
  s390x: snippets: Add snippet compilation

 .gitignore                      |   1 +
 lib/s390x/asm/uv.h              |  33 +++----
 lib/s390x/interrupt.c           |  14 +--
 lib/s390x/sie.h                 |  11 ++-
 s390x/Makefile                  |  29 +++++--
 s390x/mvpg-sie.c                | 149 ++++++++++++++++++++++++++++++++
 s390x/snippets/c/cstart.S       |  16 ++++
 s390x/snippets/c/flat.lds       |  51 +++++++++++
 s390x/snippets/c/mvpg-snippet.c |  33 +++++++
 s390x/unittests.cfg             |   3 +
 10 files changed, 308 insertions(+), 32 deletions(-)
 create mode 100644 s390x/mvpg-sie.c
 create mode 100644 s390x/snippets/c/cstart.S
 create mode 100644 s390x/snippets/c/flat.lds
 create mode 100644 s390x/snippets/c/mvpg-snippet.c

-- 
2.31.1

