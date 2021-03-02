Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662CA32A715
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449029AbhCBQDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:03:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379954AbhCBLzk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 06:55:40 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122BXMXP036655
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 06:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=7PZgR+6w3Q+iyqOLwhgPHcOOjdby5a4K82j+edNuU6s=;
 b=bl71tMlkf0vufG2oazxMhPuJ5X8hYd1KbITvPZ/X9KWKAUA9YR04OzofcJz7/l0IGb4I
 JcXHS0+ZhgQ+hFlmP7qx69xFJxSO8DhA5s2o37vMOUdl4yQr08uUjAxukP9++whs0mIX
 OeHXbzwVjMKM/+1CjUVDU1Y98myXztJqfMKxLHC/c2M9nRTgtW7I359K+DR9YcWskGIw
 N/XQdkBeYcywmHYaozr8QbwvwZHJHESXx5ggTIEgjE2FjudkdIsJAX9yIog4AYFz4FFJ
 5ZgGXaCoYp5x9YagYaf1Txa7WqL0ApUv9FgDh0Qz49GhEL5+Z+tKlGVFNxz/F1CGC/eQ 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371mjp88fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 06:41:13 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122BXTG0037617
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 06:41:13 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371mjp88em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 06:41:13 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122BbBC1009192;
        Tue, 2 Mar 2021 11:41:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3712fmgsqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 11:41:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122Bf8Vv49086878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 11:41:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26412AE051;
        Tue,  2 Mar 2021 11:41:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE7B9AE053;
        Tue,  2 Mar 2021 11:41:07 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 11:41:07 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v4 0/3] s390x: mvpg test
Date:   Tue,  2 Mar 2021 12:41:04 +0100
Message-Id: <20210302114107.501837-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_03:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 mlxlogscore=931 spamscore=0 malwarescore=0
 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020098
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

v3->v4
* add memset after the first successful mvpg to make sure memory is really
  copied successfully
* add a comment and an additional prefix to the tests skipped when running
  in TCG

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
 s390x/mvpg.c             | 277 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   4 +
 5 files changed, 299 insertions(+), 2 deletions(-)
 create mode 100644 s390x/mvpg.c

-- 
2.26.2

