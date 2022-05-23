Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1A0530D5E
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiEWJ4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiEWJ4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:56:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C462635;
        Mon, 23 May 2022 02:56:32 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N8FcEQ025827;
        Mon, 23 May 2022 09:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=//7riZxFSqx79veqBcZ9Vwp6zrKkd4aWRCQw7V1IzhU=;
 b=mY/7sUwhxLkaHFCNJhTZOeOrqBfX0FJuw0XGf1AlHHFCccLQ68awBzFNTwAs9pO8LGWe
 Sp7Z0Z8Qyoetmd79YJmeWYlGKT9YJQlWzVRlfmY0MCAZB86DUnD2TheVVqBvuyB3YMz7
 bXpxj9sM6eM0eLzf1ZHfjVLELGDfYJKN2zQ2I9gHEjWNHur72PC3duHBUPdbBJDd6muq
 Zg95GLZRUFY69ZGql8pgt6juKWj0731Jo8JPjUpihx5Tja5I2VNSWQH5WuynmcQeeuc1
 0+CbMDHdgk6gqlv3PR4N/Opc/nJdfymMEwRtIBoEWzw3Pnyuuej/bG2mVxj0cLQpyq39 PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79f59hj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:56:32 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24N9IONt003260;
        Mon, 23 May 2022 09:56:31 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79f59hhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:56:31 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24N9PFxs022803;
        Mon, 23 May 2022 09:56:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3g6qq9a5ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:56:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24N9uPmE22086008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 09:56:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1F5D42042;
        Mon, 23 May 2022 09:56:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF63A4203F;
        Mon, 23 May 2022 09:56:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 23 May 2022 09:56:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 85679E7962; Mon, 23 May 2022 11:56:25 +0200 (CEST)
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
Subject: [GIT PULL 0/4] KVM: s390: Fix and feature for 5.19
Date:   Mon, 23 May 2022 11:56:21 +0200
Message-Id: <20220523095625.13913-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Hu-xkmGfz3Gb7qx3ScVXWblL7zUmIShE
X-Proofpoint-ORIG-GUID: kz5C-fpvKDJGec2PxLoUrRARpfB7Xpmu
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_03,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

only a small set of changes and sorry for the late pull.
If Greg asks, the ultravisor device driver has userspace code that is
acked by the s390 tools maintainer and will follow after the driver
hits the kernel.


The following changes since commit ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e:

  Linux 5.18-rc2 (2022-04-10 14:21:36 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.19-1

for you to fetch changes up to c71159648c3cf0f7127ddc0bdf3eb4d7885210df:

  KVM: s390: selftest: Test suppression indication on key prot exception (2022-05-20 16:38:42 +0200)

----------------------------------------------------------------
KVM: s390: Fix and feature for 5.19

- ultravisor communication device driver
- fix TEID on terminating storage key ops

----------------------------------------------------------------
Janis Schoetterl-Glausch (2):
      KVM: s390: Don't indicate suppression on dirtying, failing memop
      KVM: s390: selftest: Test suppression indication on key prot exception

Steffen Eiden (2):
      drivers/s390/char: Add Ultravisor io device
      selftests: drivers/s390x: Add uvdevice tests

 Documentation/virt/kvm/api.rst                     |   6 +
 MAINTAINERS                                        |   3 +
 arch/s390/include/asm/uv.h                         |  23 +-
 arch/s390/include/uapi/asm/uvdevice.h              |  51 ++++
 arch/s390/kvm/gaccess.c                            |  22 +-
 drivers/s390/char/Kconfig                          |  10 +
 drivers/s390/char/Makefile                         |   1 +
 drivers/s390/char/uvdevice.c                       | 257 +++++++++++++++++++
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/drivers/.gitignore         |   1 +
 .../selftests/drivers/s390x/uvdevice/Makefile      |  22 ++
 .../selftests/drivers/s390x/uvdevice/config        |   1 +
 .../drivers/s390x/uvdevice/test_uvdevice.c         | 276 +++++++++++++++++++++
 tools/testing/selftests/kvm/s390x/memop.c          |  46 +++-
 14 files changed, 714 insertions(+), 6 deletions(-)
 create mode 100644 arch/s390/include/uapi/asm/uvdevice.h
 create mode 100644 drivers/s390/char/uvdevice.c
 create mode 100644 tools/testing/selftests/drivers/s390x/uvdevice/Makefile
 create mode 100644 tools/testing/selftests/drivers/s390x/uvdevice/config
 create mode 100644 tools/testing/selftests/drivers/s390x/uvdevice/test_uvdevice.c
