Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EB43E7D63
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 18:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbhHJQWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 12:22:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229977AbhHJQWy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 12:22:54 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17AG42k6006735;
        Tue, 10 Aug 2021 12:22:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version; s=pp1;
 bh=rhIiwDe/9t2V3PCCnUgpcGEvl7zLch4ChZvqc1epa5M=;
 b=ogHGJhTcKVUK90X+8GwjxdsqR8TIlK77aiNbJPEQq1ol/2i7akJTMagt32rb/HCQAkVH
 y970NfXSDS4i/sa3FehSz6I2c9v1pI6Ev0qlLJMQT2uS8fJyNehP4+WbkxbNk3iSL0Y6
 UQu0QW7nBULY0dUtX1Jvof2fKiXxDWPNkPOp/yfWosXDTn0GfMF8b3iOBIB9LIb+W6hH
 uB+HdCO2ObLkNw4RlNIDRx4ZRQ2S5uhAwb0oHpQKOW4GeYOUf3T3/9f/KwzfWm3Ry8Ov
 plMPpmhAMCsvqhC+Kb0e4ceNiWMIJTYKEUaycyzl7/qZjiLzrO29s+cOheMq8ioZQVyz 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abb7pamtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 12:22:31 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17AG45o0007133;
        Tue, 10 Aug 2021 12:22:31 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abb7pamt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 12:22:31 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17AGGZBJ001248;
        Tue, 10 Aug 2021 16:22:29 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8xe29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 16:22:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17AGMPpj56295688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 16:22:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7999AE055;
        Tue, 10 Aug 2021 16:22:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A5F3AE059;
        Tue, 10 Aug 2021 16:22:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.176.19])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Aug 2021 16:22:25 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/4] S390x: CPU Topology Information
Date:   Tue, 10 Aug 2021 18:22:20 +0200
Message-Id: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yR0o7jPPeJtlZROtXvn2KexX_syRc_63
X-Proofpoint-GUID: uQc8RsqtsSvbentZm_lses_cpE8vNlI-
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_07:2021-08-10,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 suspectscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

second version of the series with corrections.

When facility 11 is available inside the S390x architecture, 2 new
instructions are available: PTF and STSI with function code 15.

Let's check their availability in QEMU/KVM and their coherence
with the CPU topology provided by the QEMU -smp parameter.

To run these tests successfully you will need the Linux and the QEMU
patches:
    https://lkml.org/lkml/2021/8/3/201

    https://lists.nongnu.org/archive/html/qemu-s390x/2021-07/msg00165.html

Regards,
Pierre

Pierre Morel (4):
  s390x: lib: Add SCLP toplogy nested level
  s390x: lib: Simplify stsi_get_fc and move it to library
  s390x: topology: Check the Perform Topology Function
  s390x: topology: Checking Configuration Topology Information

 lib/s390x/asm/arch_def.h |  16 ++
 lib/s390x/sclp.c         |   6 +
 lib/s390x/sclp.h         |   4 +-
 s390x/Makefile           |   1 +
 s390x/stsi.c             |  20 +--
 s390x/topology.c         | 307 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   4 +
 7 files changed, 339 insertions(+), 19 deletions(-)
 create mode 100644 s390x/topology.c

-- 
2.25.1

Changelog:

From V1:

- Simplify the stsi_get_fc function when pushing it into lib
  (Janosch)

- Simplify PTF inline assembly as PTF instruction does not use RRE
  second argument
  (Claudio)

- Rename Test global name
  (Claudio, Janosch)

- readibility, naming for PTF_REQ_* and removed unused globals
  (Janosch)

- skipping tests which could fail when run on LPAR
  (Janosh)

- Missing prefix_pop
  (Janosch)

