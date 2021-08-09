Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BA43E41CF
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 10:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhHIItb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 04:49:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234030AbhHIIt2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 04:49:28 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1798dYKr019680;
        Mon, 9 Aug 2021 04:49:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version; s=pp1;
 bh=P0ePVus6cr2Vttbo6o55rGCqiFf0cNA0uhesatFHGvg=;
 b=TIp5ctsxQfiMyteNvyRqE4CUheMIovyVa/5BlWePtUHpjN3qFuk4gkYRUyBB14UK6h25
 IUuQnHolvKIW6LvZWDLohj+n0NMtdcpBz7Mq3aVxDDgAS0EBGS+sBJc4pUSXKVS0s7qc
 TH6/WLChQiydjDQnZlbxkmuK7oQFNziq/PNr0nQpK23dOXLp20z3poqUJZdOf/KA9ajX
 HVOe/MNNI11ObZml+qjbSx/YGtRShFDrXfFaApPfDzXVrFFFHt0vwZ2WA/fsEA3KPFkz
 I6Fu8gJHetVMR7FFu2H7FlXxz66Yz6nX5IkbUZQaj0mlLPtbH24lOSff15XTEU9aNEUD vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa7n01224-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:02 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1798eJiD021439;
        Mon, 9 Aug 2021 04:49:01 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa7n0121t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:01 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798m8hI009034;
        Mon, 9 Aug 2021 08:49:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8un4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:48:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798muBx34472328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:48:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 349A34204D;
        Mon,  9 Aug 2021 08:48:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEF7B4204B;
        Mon,  9 Aug 2021 08:48:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:48:55 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/4] S390x: CPU Topology Information
Date:   Mon,  9 Aug 2021 10:48:50 +0200
Message-Id: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rgVghRioj5_DAHytVVh1u1i8W9xFjNj0
X-Proofpoint-ORIG-GUID: 941HX_St9Jr5QRpvCP_2Irs2wzn_15j5
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
  s390x: lib: Move stsi_get_fc to library
  s390x: topology: check the Perform Topology Function
  s390x: Topology: checking Configuration Topology Information

 lib/s390x/asm/arch_def.h |  16 +++
 lib/s390x/sclp.c         |   6 +
 lib/s390x/sclp.h         |   4 +-
 s390x/Makefile           |   1 +
 s390x/stsi.c             |  16 ---
 s390x/topology.c         | 294 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   4 +
 7 files changed, 324 insertions(+), 17 deletions(-)
 create mode 100644 s390x/topology.c

-- 
2.25.1

