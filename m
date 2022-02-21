Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE08F4BE3AB
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358553AbiBUNIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 08:08:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiBUNIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 08:08:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3416E1EAFB;
        Mon, 21 Feb 2022 05:07:54 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LCCBqW020136;
        Mon, 21 Feb 2022 13:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ZmBY9+AvODRxpQRzREpNEPh35MCCjgnrfk7sVn1Afj0=;
 b=ZIqs+Gj5ymLU6Hbgyt3Vh7E6F/bGXtzFDZcapi6xMrwi+nB5BrTISwlbHSNtcydcdWLA
 AZ4JW6zFCHEQEyVvClE8sQWMCqHKtoESpqfpNgcKO30nWr+hF0/y4ILvqERvgYW3Yt/N
 fnCAkI//rG+6LC0Y3aHEIlivvHhFPGG0VhzmgLHspie4kXaK4lV2ve4mMA6Yx8NmzJI+
 /1HN8/teE2hfqXNayVe5V2o8jkxTrhn3SFZocfg9V1ODgZMhM3eSNc/zCbA3bEjqrIdw
 DUKizZJdvi7z3OaHhqSUvqAzJ6Fp9wWt45KbMNoF0kmM4/QxEQ2LjT/74l0HEFUUuih/ Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecahjh3vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:53 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LD3LLf018155;
        Mon, 21 Feb 2022 13:07:53 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecahjh3v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:53 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LCwjMR012698;
        Mon, 21 Feb 2022 13:07:51 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ear68stgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:07:50 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LD7ldM48890246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 13:07:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FCDF4C05A;
        Mon, 21 Feb 2022 13:07:47 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 231FD4C04A;
        Mon, 21 Feb 2022 13:07:47 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 13:07:47 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/8] s390x: Extend instruction interception tests
Date:   Mon, 21 Feb 2022 14:07:38 +0100
Message-Id: <20220221130746.1754410-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i_Qidz9YPtDdopemna0NuQvM1n6Jo9Mv
X-Proofpoint-ORIG-GUID: Dj-YzL5P5GSAUA85P0JeNM6q-e5TyRAD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_06,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=910
 suspectscore=0 mlxscore=0 clxscore=1015 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series extends the instruction interception tests for s390x.

For most instructions, there is already coverage in existing tests, but they are
not covering some failure cases, e.g. bad alignment. In this case, the existing
tests were extended.

SCK was not under test anywhere yet, hence a new test file was added.

The EPSW test gets it's own file, too, because it requires a I/O device, more
details in the respective commit. 

Changelog from v1:
----
- Reset pmcw flags at test end
- Rebase

Nico Boehr (8):
  s390x: Add more tests for MSCH
  s390x: Add test for PFMF low-address protection
  s390x: Add sck tests
  s390x: Add tests for STCRW
  s390x: Add more tests for SSCH
  s390x: Add more tests for STSCH
  s390x: Add tests for TSCH
  s390x: Add EPSW test

 lib/s390x/css.h     |  17 +++
 lib/s390x/css_lib.c |  60 ++++++++++
 s390x/Makefile      |   2 +
 s390x/css.c         | 278 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/epsw.c        | 113 ++++++++++++++++++
 s390x/pfmf.c        |  29 +++++
 s390x/sck.c         | 127 ++++++++++++++++++++
 s390x/unittests.cfg |   7 ++
 8 files changed, 633 insertions(+)
 create mode 100644 s390x/epsw.c
 create mode 100644 s390x/sck.c

-- 
2.31.1

