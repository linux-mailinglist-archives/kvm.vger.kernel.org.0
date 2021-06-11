Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FDF3A43BF
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhFKOJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:09:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231691AbhFKOJJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 10:09:09 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BE5RZn184155;
        Fri, 11 Jun 2021 10:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=I9yqvrZ5ZI+S7ULnvlkthskQx5MPaTLNCKHYlQUFvIg=;
 b=nFrn846SlqJ42Q523Ht++BlydAGCgCaNpSGtaqcBh+Kn3LteZYbN8mTrljtRUw7vnr/c
 wPq+1ADiMIMkTbziQ439iYtD3hO7/dv3moKxaLwIu6dq4PjAaQiEDXQNF+WDgzT2xX2h
 EQyccQB9pmV4mkMedIuAo4gL6RVjHogjnock86gxJAzdvIBaIS29FXOCthqWFVIOKfJZ
 zxdTmszpgVMblSyJyDEKw9HCBGFaovUnHPD6dksU6SuWO/u+ZwBn/0494SaZzr7uruLy
 0x62ockJHNIdaFZDPjd2IJ6saeDSrJsp0Ey8tt0Fl39UzGxXs4qmGcQgN6m9lXF89Z6i LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39492r0grw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:11 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15BE6D0o187334;
        Fri, 11 Jun 2021 10:07:10 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39492r0gqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15BDveuj028240;
        Fri, 11 Jun 2021 14:07:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8kg0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 14:07:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15BE76nL34210160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 14:07:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C4B652067;
        Fri, 11 Jun 2021 14:07:06 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D2B5352050;
        Fri, 11 Jun 2021 14:07:05 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 0/7] s390: Add support for large pages
Date:   Fri, 11 Jun 2021 16:06:58 +0200
Message-Id: <20210611140705.553307-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 80n3r-NN01Uen5vifg0ieVloncKrrBv2
X-Proofpoint-GUID: mPGk62vQE5slG2Z7vHUb7CoAOGi5XaT5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_05:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support for large (1M) and huge (2G) pages.

Add a simple testcase for EDAT1 and EDAT2.

v4->v5
* fixed some typos and comment style issues
* introduced enum pgt_level, switched all functions to use it

v3->v4
* replace macros in patch 5 with a union representing TEID fields
* clear the teid in expect_pgm_int and clear_pgm_int
* update testcase to use expect_pgm_int, remove expect_dat_fault
* update testcase to use teid union

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
  s390x: lib: add teid union and clear teid from lowcore
  s390x: mmu: add support for large pages
  s390x: edat test

 s390x/Makefile            |   1 +
 lib/s390x/asm/arch_def.h  |  12 ++
 lib/s390x/asm/float.h     |   4 +-
 lib/s390x/asm/interrupt.h |  28 +++-
 lib/s390x/asm/pgtable.h   |  44 +++++-
 lib/libcflat.h            |   2 +
 lib/s390x/mmu.h           |  84 +++++++++++-
 lib/s390x/interrupt.c     |   2 +
 lib/s390x/mmu.c           | 262 ++++++++++++++++++++++++++++++++----
 lib/s390x/sclp.c          |   4 +-
 s390x/diag288.c           |   2 +-
 s390x/edat.c              | 274 ++++++++++++++++++++++++++++++++++++++
 s390x/gs.c                |   2 +-
 s390x/iep.c               |   4 +-
 s390x/skrf.c              |   2 +-
 s390x/smp.c               |   8 +-
 s390x/vector.c            |   2 +-
 s390x/unittests.cfg       |   3 +
 18 files changed, 691 insertions(+), 49 deletions(-)
 create mode 100644 s390x/edat.c

-- 
2.31.1

