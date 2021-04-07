Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DACC356C5D
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243168AbhDGMm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:42:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229615AbhDGMm0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 08:42:26 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137CXUlZ083278;
        Wed, 7 Apr 2021 08:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=qiPZxDT5xpw5aEMhdIKhnmtraJWLLkMe/zzUUNH+roE=;
 b=nj6rRNmTXEHVM/40LZZpkqMIQgh/3ee8DNo1SyAO/bjSXASrVOuasgO70KPUYhdbfv3r
 Q6Zus/5lp9ptn15Y24dwjN68TdIZ+vWlIclmEfBoWOSMlG8otb0AD1ScU9EbUdA6MejX
 9G+gzYr6z8ldJH3xImzrVLRpZUC9V0UwfIWZRu5c9oUwxFXLBXV8wR2KKFPsaDPqd/62
 gewZk+lcrutcGLzec1XVwg4KpaJ74O0hVlLMzuEF+gK90MdNEfO2jF63TvfJdFYpinGI
 ot0z/HZcPodeFhUNyedzPn7U8vk/cwAdgIFU/cb84lZpRWo3VMZQDatmWHcNj1mtOfUE ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvn0g75r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 08:42:16 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137CY4bB084987;
        Wed, 7 Apr 2021 08:42:15 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvn0g74j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 08:42:15 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137CXqKh012941;
        Wed, 7 Apr 2021 12:42:13 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 37rvbw0cpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 12:42:13 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137CgAIR46203146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 12:42:10 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 951B65204E;
        Wed,  7 Apr 2021 12:42:10 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3C5975204F;
        Wed,  7 Apr 2021 12:42:10 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 0/7] s390: Add support for large pages
Date:   Wed,  7 Apr 2021 14:42:02 +0200
Message-Id: <20210407124209.828540-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _INqaYQC7DlcsZij8mxTyGRTsqQyqp8D
X-Proofpoint-ORIG-GUID: ZjK8AdcJiE9Qi0nxHaZ0jKwtKaPtBW6v
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_07:2021-04-07,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104070087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support for large (1M) and huge (2G) pages.

Add a simple testcase for EDAT1 and EDAT2.

v2->v3
* Add proper macros for control register bits
* Improved patch titles and descriptions
* Moved definition of TEID bits to library
* Rebased on the lastest upstream branch

v1->v2

* split patch 2 -> new patch 2 and new patch 3
* patch 2: fixes pgtable.h, also fixes wrong usage of REGION_TABLE_LENGTH
  instead of SEGMENT_TABLE_LENGTH
* patch 3: introduces new macros and functions for large pages
* patch 4: remove erroneous double call to pte_alloc in get_pte
* patch 4: added comment in mmu.c to bridge the s390x architecural names
  with the Linux ones used in the kvm-unit-tests
* patch 5: added and fixed lots of comments to explain what's going on
* patch 5: set FC for region 3 after writing the canary, like for segments
* patch 5: use uintptr_t instead of intptr_t for set_prefix
* patch 5: introduce new macro PGD_PAGE_SHIFT instead of using magic value 41
* patch 5: use VIRT(0) instead of mem to make it more clear what we are
  doing, even though VIRT(0) expands to mem

Claudio Imbrenda (7):
  s390x: lib: add and use macros for control register bits
  libcflat: add SZ_1M and SZ_2G
  s390x: lib: fix pgtable.h
  s390x: lib: Add idte and other huge pages functions/macros
  s390x: lib: add PGM_TEID_* macros
  s390x: mmu: add support for large pages
  s390x: edat test

 s390x/Makefile            |   1 +
 lib/s390x/asm/arch_def.h  |  12 ++
 lib/s390x/asm/float.h     |   4 +-
 lib/s390x/asm/interrupt.h |  10 +-
 lib/s390x/asm/pgtable.h   |  44 +++++-
 lib/libcflat.h            |   2 +
 lib/s390x/mmu.h           |  73 +++++++++-
 lib/s390x/mmu.c           | 260 +++++++++++++++++++++++++++++++----
 lib/s390x/sclp.c          |   4 +-
 s390x/diag288.c           |   2 +-
 s390x/edat.c              | 279 ++++++++++++++++++++++++++++++++++++++
 s390x/gs.c                |   2 +-
 s390x/iep.c               |   4 +-
 s390x/skrf.c              |   2 +-
 s390x/smp.c               |   8 +-
 s390x/vector.c            |   2 +-
 s390x/unittests.cfg       |   3 +
 17 files changed, 663 insertions(+), 49 deletions(-)
 create mode 100644 s390x/edat.c

-- 
2.26.2

