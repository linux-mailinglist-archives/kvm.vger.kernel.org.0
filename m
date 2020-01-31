Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8936E14EA5E
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 11:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgAaKCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 05:02:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728160AbgAaKCT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 05:02:19 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00V9vehj046984
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 05:02:18 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xvfy8vnfp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 05:02:17 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 31 Jan 2020 10:02:15 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 10:02:12 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VA1JrI46465344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 10:01:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7262F11C04A;
        Fri, 31 Jan 2020 10:02:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C63E011C052;
        Fri, 31 Jan 2020 10:02:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.11.63])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jan 2020 10:02:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
Subject: [PATCH v10 0/6] KVM: s390: Add new reset vcpu API
Date:   Fri, 31 Jan 2020 05:01:59 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013110-0016-0000-0000-000002E2799C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013110-0017-0000-0000-00003345486D
Message-Id: <20200131100205.74720-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_02:2020-01-30,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=689 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=1 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's implement the remaining resets, namely the normal and clear
reset to improve architectural compliance.

While we're at it, let's also start testing the new API.
Those tests are not yet complete, but will be extended in the future.

v10:
	* Cleared up the test patch and added strerror information
	* Removed capability checks from irq test
	* Fixed clobber patch

Christian Borntraeger (1):
  KVM: s390: do not clobber registers during guest reset/store status

Janosch Frank (4):
  KVM: s390: Cleanup initial cpu reset
  KVM: s390: Add new reset vcpu API
  selftests: KVM: Add fpu and one reg set/get library functions
  selftests: KVM: s390x: Add reset tests

Pierre Morel (1):
  selftests: KVM: testing the local IRQs resets

 Documentation/virt/kvm/api.txt                |  43 ++++
 arch/s390/include/asm/kvm_host.h              |   5 +
 arch/s390/kvm/kvm-s390.c                      |  92 +++++---
 include/uapi/linux/kvm.h                      |   5 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  36 ++++
 tools/testing/selftests/kvm/s390x/resets.c    | 197 ++++++++++++++++++
 8 files changed, 351 insertions(+), 34 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/resets.c

-- 
2.20.1

