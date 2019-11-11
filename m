Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED73F77C5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 16:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfKKPfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 10:35:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726988AbfKKPfZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 10:35:25 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xABFVoEm041358
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 10:35:24 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w7a6qrsb0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 10:34:06 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 11 Nov 2019 15:33:55 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 11 Nov 2019 15:33:52 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xABFXp6Q49873084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 15:33:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 755DF52057;
        Mon, 11 Nov 2019 15:33:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.179.89])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 53D235204F;
        Mon, 11 Nov 2019 15:33:50 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: Improve architectural compliance for diag308
Date:   Mon, 11 Nov 2019 10:33:42 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19111115-0008-0000-0000-0000032E10C3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111115-0009-0000-0000-00004A4D1193
Message-Id: <20191111153345.22505-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-11_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=487 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911110142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When testing diag308 subcodes 0/1 on lpar with virtual mem set up, I
experienced spec PGMs and addressing PGMs due to the tests not setting
short psw bit 12 and leaving the DAT bit on. The problem was not found
under KVM/QEMU, because Qemu just ignores all cpu mask bits.

v1 -> v2:
   * Fixed comment in extra patch
   * Now using pre-defined reset psw
   * Fixed some comments

Janosch Frank (3):
  s390x: Fix initial cr0 load comments
  s390x: Add CR save area
  s390x: Load reset psw on diag308 reset

 lib/s390x/asm-offsets.c  |  3 ++-
 lib/s390x/asm/arch_def.h |  5 +++--
 lib/s390x/interrupt.c    |  4 ++--
 lib/s390x/smp.c          |  2 +-
 s390x/cstart64.S         | 38 ++++++++++++++++++++++++--------------
 5 files changed, 32 insertions(+), 20 deletions(-)

-- 
2.20.1

