Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EC53D8B84
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhG1KOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:14:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231392AbhG1KOC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:14:02 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SACAiS180220;
        Wed, 28 Jul 2021 06:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4Ec2Ipp4q4Zjo75NudHiXKCPdi5YpgtaJTD6jZRngN8=;
 b=a3Bx5JI3TFheQcJ5iMcemXFl6i2FNnpD71vUpBdxqUeZzU+lio0MdtFYyC37Svx7gaS/
 X5wV/mVT2ZPcCbmfI/eODGPph/2GP0DZIErFGDwq7LYTqCl1yZzNbzR4v/g1PENnpEfM
 RgX5m9ZBXZHHJ96ACeJID+99wcpGnFXdnN1qwhukIGoATEeDdvb8iubsmojklU11tkHn
 Wvb03IC2bYU1+yB04gmDkzObyhdxSJhW/bNTBPqPGOa48Xorb5jlXNyQysvcYbEuVReI
 7GlmacilfKUtFl7n4Yg/y5qExj83bMhr0z+8I/RxKTJvLBObxYk17COvWxTP+lxV8VTJ UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a34vdrhw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:14:00 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SAD2Ux184919;
        Wed, 28 Jul 2021 06:14:00 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a34vdrhvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:14:00 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SACeAT025045;
        Wed, 28 Jul 2021 10:13:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3a235m0yf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:13:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SABH5e29753836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 10:11:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ECBD4C044;
        Wed, 28 Jul 2021 10:13:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B63414C040;
        Wed, 28 Jul 2021 10:13:55 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 10:13:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 0/3] s390x: SPDX and header comment fixes
Date:   Wed, 28 Jul 2021 10:13:25 +0000
Message-Id: <20210728101328.51646-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lyxQgY3WBMkbaHIY676NClZBNjpiT4FI
X-Proofpoint-ORIG-GUID: QeIiKrJ5Kz84l1cFt326EdgZ6t1vqBso
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the snippet support was included right before my vacation I
forgot to add proper SPDX statements and header comments to a few
files.

And while I'm at it I'll also fix my mail address in the author lists.

Janosch Frank (3):
  s390x: Add SPDX and header comments for s390x/* and lib/s390x/*
  s390x: Add SPDX and header comments for the snippets folder
  s390x: Fix my mail address in the headers

 lib/s390x/asm/mem.h             |  2 +-
 lib/s390x/mmu.h                 |  2 +-
 lib/s390x/stack.c               |  2 +-
 lib/s390x/uv.c                  |  9 +++++++++
 s390x/gs.c                      |  2 +-
 s390x/iep.c                     |  2 +-
 s390x/mvpg-sie.c                |  9 +++++++++
 s390x/sie.c                     | 10 ++++++++++
 s390x/snippets/c/cstart.S       |  9 +++++++++
 s390x/snippets/c/mvpg-snippet.c |  9 +++++++++
 s390x/vector.c                  |  2 +-
 x86/sieve.c                     |  5 +++++
 12 files changed, 57 insertions(+), 6 deletions(-)

-- 
2.30.2

