Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713F095CB2
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 12:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbfHTK4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 06:56:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729308AbfHTK4M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Aug 2019 06:56:12 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KAqgXZ015306
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 06:56:12 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ugdc5pajx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 06:56:11 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 20 Aug 2019 11:56:09 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 11:56:06 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KAti1941091492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 10:55:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BE334C04A;
        Tue, 20 Aug 2019 10:56:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 494644C052;
        Tue, 20 Aug 2019 10:56:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 10:56:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 0/3] s390x: More emulation tests
Date:   Tue, 20 Aug 2019 12:55:47 +0200
X-Mailer: git-send-email 2.17.0
X-TM-AS-GCONF: 00
x-cbid: 19082010-0008-0000-0000-0000030B0346
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082010-0009-0000-0000-00004A292A06
Message-Id: <20190820105550.4991-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=807 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch allows for CECSIM booting via PSW restart.
The other ones add diag288 and STSI tests.

I chose to start with these since they are low controversy. My queue
still contains the sclp patches and a simple smp library with
tests. They will follow later.

Janosch Frank (3):
  s390x: Support PSW restart boot
  s390x: Diag288 test
  s390x: STSI tests

 s390x/Makefile      |   2 +
 s390x/diag288.c     | 111 +++++++++++++++++++++++++++++++++++++++
 s390x/flat.lds      |  14 +++--
 s390x/stsi.c        | 123 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   7 +++
 5 files changed, 252 insertions(+), 5 deletions(-)
 create mode 100644 s390x/diag288.c
 create mode 100644 s390x/stsi.c

-- 
2.17.0

