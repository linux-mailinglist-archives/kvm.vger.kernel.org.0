Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB209D419
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbfHZQfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 12:35:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727261AbfHZQfU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Aug 2019 12:35:20 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7QGOPFi026504
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 12:35:18 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2umjea1hsm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 12:35:18 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 26 Aug 2019 17:35:17 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 26 Aug 2019 17:35:14 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7QGZDem38338702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 16:35:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 379C111C04A;
        Mon, 26 Aug 2019 16:35:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0663711C054;
        Mon, 26 Aug 2019 16:35:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.27.33])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 26 Aug 2019 16:35:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/5] s390x: More emulation tests
Date:   Mon, 26 Aug 2019 18:34:57 +0200
X-Mailer: git-send-email 2.17.0
X-TM-AS-GCONF: 00
x-cbid: 19082616-0016-0000-0000-000002A32DF1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082616-0017-0000-0000-000033037537
Message-Id: <20190826163502.1298-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-26_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=858 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908260162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch allows for CECSIM booting via PSW restart.
The other ones add diag288 and STSI tests, as well as diag308 subcode 0.

v3:
* Addressed review
* Added review-bys

v2:

* Tested under TCG
* Split out stsi into library
* Addressed review

Janosch Frank (5):
  s390x: Support PSW restart boot
  s390x: Diag288 test
  s390x: Move stsi to library
  s390x: STSI tests
  s390x: Add diag308 subcode 0 testing

 lib/s390x/asm/arch_def.h |  17 +++++
 s390x/Makefile           |   2 +
 s390x/cstart64.S         |  27 ++++++++
 s390x/diag288.c          | 130 +++++++++++++++++++++++++++++++++++++++
 s390x/diag308.c          |  31 +++-------
 s390x/flat.lds           |  14 +++--
 s390x/skey.c             |  18 ------
 s390x/stsi.c             |  84 +++++++++++++++++++++++++
 s390x/unittests.cfg      |   7 +++
 9 files changed, 286 insertions(+), 44 deletions(-)
 create mode 100644 s390x/diag288.c
 create mode 100644 s390x/stsi.c

-- 
2.17.0

