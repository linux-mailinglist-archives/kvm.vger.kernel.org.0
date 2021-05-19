Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A12F388966
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 10:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245169AbhESI3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:29:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25834 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245141AbhESI3F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 04:29:05 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J83mvE073641;
        Wed, 19 May 2021 04:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=A4DdO4Wl7QT1jblXnN6RsoPIDMfpmtxhWFkIPRD6V00=;
 b=myS0+IhHUAURyHggfpxlT9MzsivI7skMHOeruewnWAY1r14nPc5+4C2w+XX9z9HstaPV
 1alVyxYemwE4Qygek/awGA76SnaAelLONsNB9WU/MxHJuHUty/vsz5XDfK+UVjqhygJl
 33p2sMiFKfU8DxVS7hmV/gwS0kpA8ZASZ6xiT2+pjXuKuj0Duwlzd1YXVi91RRFhxlvD
 nQWaEOYB6JxGHfwFgegCddf710xw+3dEc9PvWmKNKgpcbLx8EN6QzzM22/mVtD2MpUV4
 EspLlbKyTGfKRINE9IdMrZslsONb98VLGYTDsECW6DgTTl9nze0Iso4vuelqp1Kexxoe rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mxj1162h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:27:45 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14J83qm2074071;
        Wed, 19 May 2021 04:27:45 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mxj11620-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:27:44 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14J8MMeJ003217;
        Wed, 19 May 2021 08:27:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 38m1gv0ewx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 08:27:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14J8Re9Y36045140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 08:27:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17EA342045;
        Wed, 19 May 2021 08:27:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49AEC42041;
        Wed, 19 May 2021 08:27:39 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 08:27:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: cpumodel: Add sclp checks
Date:   Wed, 19 May 2021 08:26:45 +0000
Message-Id: <20210519082648.46803-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0r9jNsgzMTqZMhei2Kg8tvH9WkOKtBNs
X-Proofpoint-ORIG-GUID: PzdhCvRqzL2d-Iz_SMpnUzh2VmLgUEh5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_02:2021-05-18,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 impostorscore=0 adultscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SCLP facilities have been a bit overlooked in cpumodel tests and have
recently caused some headaches. So let's extend the tests and the
library with a bit of sclp feature checking.

Based on the uv_host branch / patches.

v2:
	* Check bit instead of mask
	* Squashed fmt 2 and 4 patches into one

Janosch Frank (3):
  s390x: sclp: Only fetch read info byte 134 if cpu entries are above it
  lib: s390x: sclp: Extend feature probing
  s390x: cpumodel: FMT2 and FMT4 SCLP test

 lib/s390x/sclp.c | 23 +++++++++++++++-
 lib/s390x/sclp.h | 38 ++++++++++++++++++++++++--
 s390x/cpumodel.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 127 insertions(+), 5 deletions(-)

-- 
2.30.2

