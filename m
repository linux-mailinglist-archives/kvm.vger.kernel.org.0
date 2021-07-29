Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08F83DA4AD
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbhG2Nsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:48:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237817AbhG2Ns1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:48:27 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TDd7Qu096221;
        Thu, 29 Jul 2021 09:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lwJCc90aN8KQlLvvDHeNTaJloHXjpyWgyqEET1WzgLA=;
 b=RawLKFJlZ4kGocOIirF2CoFeNpZP6nRI7gnZ/WhdoG/oLcb4OvE8Gx64MVgy92v6P1MV
 5OBrdO15ZBikVwtZN8eoVa00AoO66tOdHDgoobbYTv6ClkD4O9wdvZmn9zdIgsh/1XYc
 SlQ3gs0PCw5u08jAG2rRIHsh1gjE3uEojCu3QWGWr1UqGQSEOtv+X+B7UVPirmi5CWns
 KsNcMmPFOMhI2EHxpxuaN52ne9fnSluoaWdmY2Cb5m1djJKmGnfuvuJpcJ5NwvKprZbz
 IxXoZHTIv1p4Dc5EKqo6OmqGgXpXtJWiGSNtH49T4O4cfO6Ny+RKcsoQ+m8D+9kDRHkL Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3vp9spr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:16 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TDe897105363;
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3vp9spq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDZqdh009450;
        Thu, 29 Jul 2021 13:48:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3a235yhrds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:48:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDmA4K18415898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:48:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BFC74C0AF;
        Thu, 29 Jul 2021 13:48:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 154434C073;
        Thu, 29 Jul 2021 13:48:10 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:48:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 0/4] s390x: SIE cleanup 2
Date:   Thu, 29 Jul 2021 13:47:59 +0000
Message-Id: <20210729134803.183358-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ig9PIBcqFXKAQHNUgJGv_u0MT-T9ZVUI
X-Proofpoint-GUID: kUenPIkog8-tQBG2gY6ml4FfeyRjfxrp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 impostorscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time to deduplicate code before we copy it around even more.

Most problems originated from my desire to rapidly integrate SIE PV
support and as more and more people are using the SIE support it's
time to have a SIE library.

The SIE lib is by no means perfect. For that we might need a few more
iterations but it's good enough that we only need a bit of code in the
tests to get a guest going. This means we have a low entry to test
development which is my main goal.

Janosch Frank (4):
  s390x: sie: Add sie lib validity handling
  s390x: lib: Introduce HPAGE_* constants
  s390x: lib: sie: Add struct vm (de)initialization functions
  lib: s390x: sie: Move sie function into library

 lib/s390x/asm/page.h |  4 +++
 lib/s390x/sie.c      | 84 ++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/sie.h      |  7 ++++
 s390x/Makefile       |  1 +
 s390x/mvpg-sie.c     | 31 ++--------------
 s390x/sie.c          | 41 ++-------------------
 6 files changed, 101 insertions(+), 67 deletions(-)
 create mode 100644 lib/s390x/sie.c

-- 
2.30.2

