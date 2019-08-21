Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57F897793
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 12:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfHUKsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 06:48:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62106 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727099AbfHUKsk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Aug 2019 06:48:40 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LAmZMR021096
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 06:48:39 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uh2wdm7tw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 06:48:37 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 21 Aug 2019 11:48:16 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 21 Aug 2019 11:48:13 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7LAmCh846792894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 10:48:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67314AE051;
        Wed, 21 Aug 2019 10:48:12 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6869AAE04D;
        Wed, 21 Aug 2019 10:48:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.179])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Aug 2019 10:48:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/4] s390x: More emulation tests
Date:   Wed, 21 Aug 2019 12:47:32 +0200
X-Mailer: git-send-email 2.17.0
X-TM-AS-GCONF: 00
x-cbid: 19082110-0008-0000-0000-0000030B6A65
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082110-0009-0000-0000-00004A299507
Message-Id: <20190821104736.1470-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=741 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch allows for CECSIM booting via PSW restart.
The other ones add diag288 and STSI tests.

v2:

* Tested under TCG
* Split out stsi into library
* Addressed review

Janosch Frank (4):
  s390x: Support PSW restart boot
  s390x: Diag288 test
  s390x: Move stsi to library
  s390x: STSI tests

 lib/s390x/asm/arch_def.h |  17 +++++
 s390x/Makefile           |   2 +
 s390x/diag288.c          | 131 +++++++++++++++++++++++++++++++++++++++
 s390x/flat.lds           |  14 +++--
 s390x/skey.c             |  18 ------
 s390x/stsi.c             |  84 +++++++++++++++++++++++++
 s390x/unittests.cfg      |   7 +++
 7 files changed, 250 insertions(+), 23 deletions(-)
 create mode 100644 s390x/diag288.c
 create mode 100644 s390x/stsi.c

-- 
2.17.0

