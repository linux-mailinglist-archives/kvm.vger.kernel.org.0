Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D407B4FFA16
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 17:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbiDMP3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 11:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiDMP31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 11:29:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDAE5F241;
        Wed, 13 Apr 2022 08:27:05 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DFDj6j021460;
        Wed, 13 Apr 2022 15:27:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=1wHRhR6wddy5uxhfeu/qLJ3cP7nf60kh+/6PCQedZiA=;
 b=CHjDyw/RP55zTVqH4X0HGccPU2BN/gJQy8PuOG86esTDXQXroEJvlwFQmTE8EekdxmVi
 VhkNTZM+HXzxs2o5tjrrKKCkkKZg3FnhWFMvoTdGmcaKcphXmC5sWfuH+qkvWhEqF+dS
 JWYxdA46NUYsBE34fRLWqZ1durDIIokOVgKj1qz4cY1zOJpyPCPHeG7I+5lEBlPlL0r4
 o3gAaUnAQFDmD2Tz8i4xjQLG9TNhuNPn8Xjf0IKy3I1LWEPHzhvqBmvtnU0QwiCE2Xe+
 aU7zoqs1g5Cp2fo3ERG+lCiWrBeKk12De5fks8ZFMDYgX9iBGBNcTUhWQEg8iuVNYpiG 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fe0ys89qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:27:04 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23DFEud0024905;
        Wed, 13 Apr 2022 15:27:04 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fe0ys89pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:27:03 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DFI3YS009964;
        Wed, 13 Apr 2022 15:27:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3fb1s8npwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:27:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DFQwDP8388970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 15:26:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14EE4C044;
        Wed, 13 Apr 2022 15:26:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A32F4C040;
        Wed, 13 Apr 2022 15:26:58 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 15:26:58 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/4] s390x: add migration test support
Date:   Wed, 13 Apr 2022 17:26:54 +0200
Message-Id: <20220413152658.715003-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C6d10xpZn4AP7mymQ2ZTeybEh_plPhkl
X-Proofpoint-GUID: yHJGRNQIj2TK5rt-W5jFF91AfiY6Qjoy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog from v1:
----
- Instead of the selftest, do an actual migration tests of guarded storage and
  vector registers. To have access to gs and vector related defines, this now
  depends on my SIGP store adtl status series
  ("[kvm-unit-tests PATCH v3 0/2] s390x: Add tests for SIGP store adtl status")
- Lower case const ints (Thanks Janosch)
- Use define instead of magic number (Thanks Thomas)
- Add missing "ret = 0" (Thanks Thomas)
- Minor typos and style fixes

This series depends on my SIGP store additional status series to have access to
the guarded-storage and vector related defines
("[kvm-unit-tests PATCH v3 0/2] s390x: Add tests for SIGP store adtl status").

Add migration test support for s390x.

arm and powerpc already support basic migration tests.

If a test is in the migration group, it can print "migrate" on its console. This
will cause it to be migrated to a new QEMU instance. When migration is finished,
the test will be able to read a newline from its standard input.

We need the following pieces for this to work under s390x:

* read support for the sclp console. This can be very basic, it doesn't even
  have to read anything useful, we just need to know something happened on
  the console.
* s390/run adjustments to call the migration helper script.

This series adds basic migration tests for s390x, which I plan to extend
further.

Nico Boehr (4):
  lib: s390x: add support for SCLP console read
  s390x: add support for migration tests
  s390x: don't run migration tests under PV
  s390x: add basic migration test

 lib/s390x/sclp-console.c |  79 ++++++++++++++++--
 lib/s390x/sclp.h         |   8 ++
 s390x/Makefile           |   2 +
 s390x/migration.c        | 172 +++++++++++++++++++++++++++++++++++++++
 s390x/run                |   7 +-
 s390x/unittests.cfg      |   5 ++
 scripts/s390x/func.bash  |   2 +-
 7 files changed, 267 insertions(+), 8 deletions(-)
 create mode 100644 s390x/migration.c

-- 
2.31.1

