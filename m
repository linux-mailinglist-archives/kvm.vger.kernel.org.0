Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A0B4FBD34
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 15:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346530AbiDKNgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 09:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbiDKNgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 09:36:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA766155;
        Mon, 11 Apr 2022 06:34:02 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BBwfbl029718;
        Mon, 11 Apr 2022 13:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=jf5I9pC3AfQKS3ko8W9rHAlPQ5T7DNgdEcJn+Wj7tXw=;
 b=oCDKd7HWqnxEmgTXnwaTlRXXxLIBEE39eIAyzMDTaHPOV8f1SpTnNDn+qfcvUiV9u+bO
 TAi/aXkNKuMT78TPRhZXT6iYoHsg58CY+Um6JZpul0fsG592Bx41Lqo5ajtd1oZS0z+S
 8x0KOvM7x5vfX51/LQTeDJwXUOldxvIo4WNrh5bBpgf0mqHWdLI7LOy2Qm+ilgqsesiz
 yXigY4/fISSlq4HcW7Lw5ykAYMozQBENsmwV0f0PPDQTy+pPCvuQ2A7GYNLEjhNla0DV
 TYSlkDmEDNIz4eCJe7i2NXYXfNZCPtwFg8sow8nLPoaSCEXnMVq9WTTb3123S8+Peejq Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fckxbt4e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:34:01 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BC7s1g029524;
        Mon, 11 Apr 2022 13:34:01 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fckxbt4d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:34:01 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BCrlPr004747;
        Mon, 11 Apr 2022 13:33:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3fb1s8thwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:33:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BDXtfX49807830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 13:33:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B19B542042;
        Mon, 11 Apr 2022 13:33:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C1BA4203F;
        Mon, 11 Apr 2022 13:33:55 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 13:33:55 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/2] s390x: Add tests for SIGP store adtl status
Date:   Mon, 11 Apr 2022 15:33:53 +0200
Message-Id: <20220411133355.3040084-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PU7px0vD2z29u9FHB3lQFu44OV1TILBt
X-Proofpoint-GUID: Oi0qgLwiz4FNFGv20GJzFEyDwghE93n1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_04,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=943
 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog from v2:
----
- Remove useless one variable
- Use BIT_ULL instead of shifting 1ULL
- Minor style fixes

As suggested by Claudio, move the store adtl status I sent previously
("[kvm-unit-tests PATCH v2 0/9] s390x: Further extend instruction interception
 tests") into its own file.

Nico Boehr (2):
  s390x: gs: move to new header file
  s390x: add test for SIGP STORE_ADTL_STATUS order

 lib/s390x/asm/vector.h |  16 ++
 lib/s390x/gs.h         |  69 +++++++
 s390x/Makefile         |   1 +
 s390x/adtl-status.c    | 408 +++++++++++++++++++++++++++++++++++++++++
 s390x/gs.c             |  54 +-----
 s390x/unittests.cfg    |  25 +++
 6 files changed, 520 insertions(+), 53 deletions(-)
 create mode 100644 lib/s390x/asm/vector.h
 create mode 100644 lib/s390x/gs.h
 create mode 100644 s390x/adtl-status.c

-- 
2.31.1

