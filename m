Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88201190734
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 09:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgCXING (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 04:13:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726166AbgCXING (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 04:13:06 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02O85utI125783
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:05 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywd8ctk8m-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:04 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 24 Mar 2020 08:13:01 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 08:12:58 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02O8CwOq45809846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 08:12:58 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 938A8A4060;
        Tue, 24 Mar 2020 08:12:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F047A4054;
        Tue, 24 Mar 2020 08:12:57 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 08:12:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com
Subject: [kvm-unit-tests PATCH 00/10] s390x: smp: Improve smp code part 2
Date:   Tue, 24 Mar 2020 04:12:41 -0400
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20032408-0008-0000-0000-00000362DE2D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032408-0009-0000-0000-00004A844979
Message-Id: <20200324081251.28810-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_02:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=574 spamscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240042
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's continue cleaning up the smp test and smp related functions.

We add:
   * Test for external/emergency calls after reset
   * Test SIGP restart while running
   * SIGP stop and store status while running
   * CR testing on reset

We fix:
   * Proper check for sigp completion
   * smp_cpu_setup_state() loop and return address in r14


GIT: https://github.com/frankjaa/kvm-unit-tests/tree/smp_cleanup2


Janosch Frank (10):
  s390x: smp: Test all CRs on initial reset
  s390x: smp: Dirty fpc before initial reset test
  s390x: smp: Test stop and store status on a running and stopped cpu
  s390x: smp: Test local interrupts after cpu reset
  s390x: smp: Loop if secondary cpu returns into cpu setup again
  s390x: smp: Remove unneeded cpu loops
  s390x: smp: Use full PSW to bringup new cpu
  s390x: smp: Wait for sigp completion
  s390x: smp: Add restart when running test
  s390x: Fix library constant definitions

 lib/s390x/asm/arch_def.h |  8 ++--
 lib/s390x/smp.c          | 10 +++++
 lib/s390x/smp.h          |  1 +
 s390x/cstart64.S         |  5 ++-
 s390x/smp.c              | 84 ++++++++++++++++++++++++++++++++++++----
 5 files changed, 95 insertions(+), 13 deletions(-)

-- 
2.25.1

