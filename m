Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6341C4D9D17
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349017AbiCOONK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349026AbiCOOM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:12:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1BF546B2;
        Tue, 15 Mar 2022 07:11:44 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FDTPR0000913;
        Tue, 15 Mar 2022 14:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=ssaIfS7bjnzPkJAxH28Mboj6c3MPVUwPQhnDGZAwIXk=;
 b=g8sGVj2mEQbREIZuiIQD2DAIwjcKkONHzJV3AwhzBto+rDuBpfJKS66YDQLuRBSX2BhL
 gr/LWY4IrkleL2U111ofwE/pMwHiUN8D7aH2Uu6WrxWf42PIcJ5w8TPxP6/RQ7iGah1L
 XN3gUC58ZQuR7EShS8g70UFoht9kM6tXze5Rm7zx5ajgUQc8XN+4aqzfoHkswNrBapD3
 3LxVooIimD5eUnh12uXvSJEBxLTgruYa9rLu4P4ak3thp+dgZ5S3lxCMnu6b/MCHC+cr
 ary61XPqU2/2bakHsOsrC22QcDXtZRCZT8ywy6b5r65/P1sIdRO7I4xyDwUkBSdlOWCk /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etuqvs1nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:43 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FDXlhG011443;
        Tue, 15 Mar 2022 14:11:43 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etuqvs1n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:43 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE9F2A008200;
        Tue, 15 Mar 2022 14:11:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3erk58nsnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEBcJ440632742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:11:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C78211C04C;
        Tue, 15 Mar 2022 14:11:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49F1411C04A;
        Tue, 15 Mar 2022 14:11:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Mar 2022 14:11:38 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 0651CE11F3; Tue, 15 Mar 2022 15:11:38 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 0/7] KVM: s390: Fix, test and feature for 5.18 part 2
Date:   Tue, 15 Mar 2022 15:11:30 +0100
Message-Id: <20220315141137.357923-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GaZIYHfzLV0xiEbWHLp8qhCv-kkwO24F
X-Proofpoint-ORIG-GUID: Gho7twNlypdW2Q8Uk6Rs2QlZWs9I-9FB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203150092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

the 2nd chunk for 5.18 via kvm/next.

The following changes since commit 3d9042f8b923810c169ece02d91c70ec498eff0b:

  KVM: s390: Add missing vm MEM_OP size check (2022-02-22 09:16:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.18-2

for you to fetch changes up to 3bcc372c9865bec3ab9bfcf30b2426cf68bc18af:

  KVM: s390: selftests: Add error memop tests (2022-03-14 16:12:27 +0100)

----------------------------------------------------------------
KVM: s390: Fix, test and feature for 5.18 part 2

- memop selftest
- fix SCK locking
- adapter interruptions virtualization for secure guests

----------------------------------------------------------------
Claudio Imbrenda (1):
      KVM: s390x: fix SCK locking

Janis Schoetterl-Glausch (5):
      KVM: s390: selftests: Split memop tests
      KVM: s390: selftests: Add macro as abstraction for MEM_OP
      KVM: s390: selftests: Add named stages for memop test
      KVM: s390: selftests: Add more copy memop tests
      KVM: s390: selftests: Add error memop tests

Michael Mueller (1):
      KVM: s390: pv: make use of ultravisor AIV support

 arch/s390/include/asm/uv.h                |   1 +
 arch/s390/kvm/interrupt.c                 |  54 ++-
 arch/s390/kvm/kvm-s390.c                  |  30 +-
 arch/s390/kvm/kvm-s390.h                  |  15 +-
 arch/s390/kvm/priv.c                      |  15 +-
 tools/testing/selftests/kvm/s390x/memop.c | 731 +++++++++++++++++++++++++-----
 6 files changed, 715 insertions(+), 131 deletions(-)
