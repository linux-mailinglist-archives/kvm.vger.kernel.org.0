Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0B5322C30
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 15:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhBWOZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 09:25:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233016AbhBWOZR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 09:25:17 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NE3ucf193085
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:24:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=H5vKPjD25lRMEQ55cQ0nHIOU7Rkj2x9070/l/fWXPOQ=;
 b=eis6e6HHWz/1VO31slGbCksFPQRgHF3lYqYO4b8TT+k/yueEXYLTA5ipOE8/EkS/KItj
 YSnpUvfUBxw8gaPMtitw6RpMs8UUCJFCxTX8G3ztuwD/8IznQcbatHAZZUkj4cj0fyL+
 1WDIA4p7owTDVXeV9Ziwcp/ARL+Kjn5rw8IO58yF/owS2G9Yg5TJCLf53tGxopNbFDlH
 oLgFZDn0JbjxLl2t5TSNaym3Vs/0sdasEIUKx/g8xRCEC8VBvwRaNgwygUddzUkQgvd0
 MFSVupa9A7M4trve9DnuyTC85WhOY43XbHd9TGI+VIwRrUkaVxsO4E2RRzIxDBVQrs/Q mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkmyg4ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:24:35 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NE4FQj195054
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:24:35 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkmyg4sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:24:35 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NEOQqW031336;
        Tue, 23 Feb 2021 14:24:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt282p79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:24:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NEOIea23331110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 14:24:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A51D0A4051;
        Tue, 23 Feb 2021 14:24:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 450CEA404D;
        Tue, 23 Feb 2021 14:24:30 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.213])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 14:24:30 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/2] s390x: mvpg test
Date:   Tue, 23 Feb 2021 15:24:27 +0100
Message-Id: <20210223142429.256420-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_07:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=742 malwarescore=0 impostorscore=0
 mlxscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102230119
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

v1->v2
* droppped patch 2 which introduced is_pgm();
* patch 1: replace a hardcoded value with the new macro SVC_LEAVE_PSTATE
* patch 2: clear_pgm_int() returns the old value, use that instad of is_pgm()

Claudio Imbrenda (2):
  s390x: introduce leave_pstate to leave userspace
  s390x: mvpg: simple test

 s390x/Makefile           |   1 +
 lib/s390x/asm/arch_def.h |   7 ++
 lib/s390x/interrupt.c    |  12 +-
 s390x/mvpg.c             | 266 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   4 +
 5 files changed, 288 insertions(+), 2 deletions(-)
 create mode 100644 s390x/mvpg.c

-- 
2.26.2

