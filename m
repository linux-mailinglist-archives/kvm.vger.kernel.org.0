Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB00328B6E
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 19:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240168AbhCASeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 13:34:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16648 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238228AbhCAS3c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 13:29:32 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121I4POv081043
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 13:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YbG2OBL2N5PMXDb2+dtY5EXRge19HsWuqPlyqbRvF3A=;
 b=LB8ATkuhTPkBCA2aUJSFAGIH9xHfB5+PxLtpJ2NyTtghfCHw/Lk7O4OEhCTbne/4zV13
 ThyjOwiffsxB4IV7hLL2Zyck4lidKZkdYxpV2UypvCad9xoCSbj26fkFVf07LcfUXSfU
 tpkb9wRAZ5nF4x4PbIpxO3mxRLPKj2lyLrX/NTgggtBPHBPX3w18WzFlev2oMZAwqCBg
 TwvqWhLSatgXCPBWHf2RbW4Sf2CUL3OUe1E1JV+XLAJv1Zvqme80m2EX7gWo5sgWAP+H
 dJbwxJGiSf+eg82MmG35tCtoTt16y9LKBxHcDZ2n4tEaEqJEP2yNjiXWLdjW1DmHRPE0 Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37142k3cxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 13:28:36 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121IHRtZ147161
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 13:28:36 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37142k3cx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 13:28:36 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121ISYKu015267;
        Mon, 1 Mar 2021 18:28:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 370c59s61b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 18:28:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121ISVhx45613504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 18:28:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 285E642047;
        Mon,  1 Mar 2021 18:28:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B838642042;
        Mon,  1 Mar 2021 18:28:30 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Mar 2021 18:28:30 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v3 0/3] s390x: mvpg test
Date:   Mon,  1 Mar 2021 19:28:27 +0100
Message-Id: <20210301182830.478145-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_12:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 adultscore=0 mlxlogscore=869
 spamscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A simple unit test for the MVPG instruction.

The timeout is set to 10 seconds because the test should complete in a
fraction of a second even on busy machines. If the test is run in VSIE
and the host of the host is not handling MVPG properly, the test will
probably hang.

Testing MVPG behaviour in VSIE is the main motivation for this test.

Anything related to storage keys is not tested.

v2->v3
* fix copyright (2020 is over!)
* add the third patch to skip some known issues when running in TCG

v1->v2
* droppped patch 2 which introduced is_pgm();
* patch 1: replace a hardcoded value with the new macro SVC_LEAVE_PSTATE
* patch 2: clear_pgm_int() returns the old value, use that instad of is_pgm()

Claudio Imbrenda (3):
  s390x: introduce leave_pstate to leave userspace
  s390x: mvpg: simple test
  s390x: mvpg: skip some tests when using TCG

 s390x/Makefile           |   1 +
 lib/s390x/asm/arch_def.h |   7 +
 lib/s390x/interrupt.c    |  12 +-
 s390x/mvpg.c             | 273 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   4 +
 5 files changed, 295 insertions(+), 2 deletions(-)
 create mode 100644 s390x/mvpg.c

-- 
2.26.2

