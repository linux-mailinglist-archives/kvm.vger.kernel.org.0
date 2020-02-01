Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA84B14F86E
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 16:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgBAP3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 10:29:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbgBAP3E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 Feb 2020 10:29:04 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 011FJaFE109299
        for <kvm@vger.kernel.org>; Sat, 1 Feb 2020 10:29:03 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xwa7ujf67-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2020 10:29:03 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Sat, 1 Feb 2020 15:29:01 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 1 Feb 2020 15:28:57 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 011FSu6S59113634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 1 Feb 2020 15:28:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C04B852051;
        Sat,  1 Feb 2020 15:28:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.30.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E33E85204E;
        Sat,  1 Feb 2020 15:28:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 0/7] s390x: smp: Improve smp code and reset checks
Date:   Sat,  1 Feb 2020 10:28:44 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020115-0020-0000-0000-000003A61C0A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020115-0021-0000-0000-000021FDD8E7
Message-Id: <20200201152851.82867-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-01_03:2020-01-31,2020-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0
 mlxlogscore=373 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002010113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's cleanup the smp library and smp tests.

GIT: https://github.com/frankjaa/kvm-unit-tests/tree/smp_cleanup

v5:
	* Split up series into three parts to make review easier
	* Greetings from FOSDEM :-)

V4:
	* Introduce set_flag() for manipulating testflag
	* Cleanup of stray braces and mb()s

v3:
	* Added patch to introduce cpu loop in cpu setup
	* Added patch that removes cpu loops in favor of the previously introduced one
	* Fixed inline assembly for fpc dirtying
	* Moved cpu stop hunk from first into the second patch
	* Reworked patch #4 commit message and added a comment when waiting for PU

v2:
	* Added cpu stop to test_store_status()
	* Added smp_cpu_destroy() to the end of smp.c main()
	* New patch that prints cpu id on interrupt errors
	* New patch that reworks cpu start in the smp library (needed for lpar)
	* nullp is now an array

Janosch Frank (7):
  s390x: smp: Cleanup smp.c
  s390x: smp: Fix ecall and emcall report strings
  s390x: Stop the cpu that is executing exit()
  s390x: Add cpu id to interrupt error prints
  s390x: smp: Only use smp_cpu_setup once
  s390x: smp: Rework cpu start and active tracking
  s390x: smp: Wait for cpu setup to finish

 lib/s390x/interrupt.c | 20 +++++------
 lib/s390x/io.c        |  2 +-
 lib/s390x/smp.c       | 59 +++++++++++++++++++------------
 s390x/cstart64.S      |  2 ++
 s390x/smp.c           | 80 ++++++++++++++++++++++++++-----------------
 5 files changed, 100 insertions(+), 63 deletions(-)

-- 
2.20.1

