Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0DCD11AA5F
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 12:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbfLKL7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 06:59:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727365AbfLKL7e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 06:59:34 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBBqIvS036381
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 06:59:33 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wtf83ktbk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 06:59:33 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 11 Dec 2019 11:59:31 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Dec 2019 11:59:29 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBBxT6K45023384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 11:59:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E305542042;
        Wed, 11 Dec 2019 11:59:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33B824203F;
        Wed, 11 Dec 2019 11:59:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.149])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Dec 2019 11:59:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/2] s390x: smp: Improve setup of additional cpus
Date:   Wed, 11 Dec 2019 06:59:21 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19121111-0020-0000-0000-00000397205B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121111-0021-0000-0000-000021EE242F
Message-Id: <20191211115923.9191-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_02:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 mlxscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 mlxlogscore=662
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's not use constants for the PSW mask and CRs, but set them from
input data or cpu 0.

Later on we could add functions that take a ptr for setting up CRs of
additional cpus, but for now using the CRs 0,1,7,13 from cpu 0 will at
least result in a working DAT environment.

Janosch Frank (2):
  s390x: smp: Use full PSW to bringup new cpu
  s390x: smp: Setup CRs from cpu 0

 lib/s390x/smp.c  | 7 ++++++-
 s390x/cstart64.S | 4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.20.1

