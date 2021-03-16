Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2291333D073
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 10:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhCPJUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 05:20:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235954AbhCPJUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 05:20:04 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G93vjK125009;
        Tue, 16 Mar 2021 05:20:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=eOw77kQpWiRR6YWM8to7+u1ZLsalzFpmsK4j0hjUOMg=;
 b=iDRaq+EA7EwM5wIGhW0B1ekG4uAARneKJZQ+LCro6DslFSV2oSC2MdzfXSlu3gxvTtIS
 FoZKK1aIbizStNi804ETjHRelIFE9fNbm3GmZuYEnY7bIhfdQ3w44ybGLpQjM6qtHpzk
 yiATsbLLqcerNMFZNRvppcOL+KVniF9oH0GHWhqmSnEERV9h7ZxGGzjhIqGr02oDwYeM
 wC/VmU1c9OlwWdmdSJCFk3ZUnHJPzNw9c+4NBF6qO/aZ02vJGKSZBbhcitTGbyTxTpev
 s4AHJ1uT/EotrmFdJpWknO9KQ5lEE15gL0ixgfLvkuny1VqrGX5zIBdJo7PAL+di+8d5 iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37arj1je5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:03 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12G94O1l127260;
        Tue, 16 Mar 2021 05:20:02 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37arj1je57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:02 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12G9CGdd005543;
        Tue, 16 Mar 2021 09:20:01 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 378mnh2pfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 09:20:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12G9JwRh48300508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 09:19:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90D5E4C044;
        Tue, 16 Mar 2021 09:19:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 549904C052;
        Tue, 16 Mar 2021 09:19:57 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.146.129])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Mar 2021 09:19:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/6] s390x: uv: Extend guest test and add host test
Date:   Tue, 16 Mar 2021 09:16:48 +0000
Message-Id: <20210316091654.1646-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My stack of patches is starting to lean, so lets try to put some of
them upstream...

The first part is just additions to the UV guest test and a library
that makes checking the installed UV calls easier. Additionally we now
check for the proper UV share/unshare availability when allocating IO
memory instead of only relying on stfle 158.

The second part adds a UV host test with a large number UV of return
code checks. This is currently a guest 1 test.

Janosch Frank (6):
  s390x: uv-guest: Add invalid share location test
  s390x: Add more Ultravisor command structure definitions
  s390x: uv: Add UV lib
  s390x: Test for share/unshare call support before using them
  s390x: uv-guest: Test invalid commands
  s390x: Add UV host test

 lib/s390x/asm/uv.h    | 152 ++++++++++++-
 lib/s390x/io.c        |   2 +
 lib/s390x/malloc_io.c |   5 +-
 lib/s390x/uv.c        |  48 ++++
 lib/s390x/uv.h        |  10 +
 s390x/Makefile        |   2 +
 s390x/uv-guest.c      |  57 ++++-
 s390x/uv-host.c       | 513 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 776 insertions(+), 13 deletions(-)
 create mode 100644 lib/s390x/uv.c
 create mode 100644 lib/s390x/uv.h
 create mode 100644 s390x/uv-host.c

-- 
2.27.0

