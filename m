Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87784EED34
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 14:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbiDAMfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 08:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344270AbiDAMfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 08:35:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E694B84E;
        Fri,  1 Apr 2022 05:33:28 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231BpiBI030647;
        Fri, 1 Apr 2022 12:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vVFuQ78CXT7+JWdDldow68rgMukMG0bN12yjsV/TRVQ=;
 b=WeuizP5XJIyHHPZUV1aBNbPf0QkT2N5Jvk+LRmILuqXeQl613IlBNS2slk5wyG7H4mrr
 qyXnA+kPfH3CXM2Wjdh++jN85G0MnK1wxH5DsH6WTHmXmAow0E6wdw8COkTthoL9vaOk
 ww4/6YdNfP2GvmVm4jV3husW5EjRfSOT6soVJe75Wz5+ZDVHVIXKacdIWQX2yULzAqpB
 PXzwcK6dGqq33Jrre4GNclseKnCcRKy4krN9e2Ne4k4qS+cGdaKCgbRsnSkTapXKxa17
 atP52Kmo/NIIb8WiBXq/KUztDHSrknJS2qkja3oe1XM08MJ7F0V8Ttgxoz2MNnoQShsO bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f556ubjpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 12:33:27 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231CUxiv020931;
        Fri, 1 Apr 2022 12:33:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f556ubjnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 12:33:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231CD9bL029416;
        Fri, 1 Apr 2022 12:33:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf950xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 12:33:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231CLH2Q52691244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 12:21:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88A81A4060;
        Fri,  1 Apr 2022 12:33:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44F40A4054;
        Fri,  1 Apr 2022 12:33:21 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 12:33:21 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/2] s390x: Add tests for SIGP store adtl status
Date:   Fri,  1 Apr 2022 14:33:19 +0200
Message-Id: <20220401123321.1714489-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qDMFvprFzggTfunu46FBe9nI-Rcv9yTw
X-Proofpoint-ORIG-GUID: FiovIH6s5CTsnuNQoYDEJgZARycJd01l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=830
 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog from v1:
----
- Move vector related defines to own header
- Write restart_write_vector in assembler to avoid undesired use of floating
  point registers by the compiler.
- Minor naming fixes

As suggested by Claudio, move the store adtl status I sent previously
("[kvm-unit-tests PATCH v2 0/9] s390x: Further extend instruction interception
 tests") into its own file.

Nico Boehr (2):
  s390x: gs: move to new header file
  s390x: add test for SIGP STORE_ADTL_STATUS order

 lib/s390x/asm/vector.h |  16 ++
 lib/s390x/gs.h         |  69 +++++++
 s390x/Makefile         |   1 +
 s390x/adtl-status.c    | 411 +++++++++++++++++++++++++++++++++++++++++
 s390x/gs.c             |  54 +-----
 s390x/unittests.cfg    |  25 +++
 6 files changed, 523 insertions(+), 53 deletions(-)
 create mode 100644 lib/s390x/asm/vector.h
 create mode 100644 lib/s390x/gs.h
 create mode 100644 s390x/adtl-status.c

-- 
2.31.1

