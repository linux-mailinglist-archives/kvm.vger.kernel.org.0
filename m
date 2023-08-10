Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EEC777742
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 13:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjHJLhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 07:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbjHJLhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 07:37:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BAD26B8;
        Thu, 10 Aug 2023 04:37:35 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37ABbTc9012896;
        Thu, 10 Aug 2023 11:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=d/xhsfJwfaFb/osreQnKLbyyxSLj80rJVVW3Z4amqN8=;
 b=LcEWFQGA0YvfbZeyZqgzmf0TBwdnt3A59ipV4EhLaR76nr2XxVvBmghZZmBLu0oykrRd
 NRHcsliJqMnLe72meh5fQY1sJzFnNCkey6MUnnc5vsP4uPfJqzI8J7yee3XJQY2K4Gle
 a2zgsclwj1XkWrFZPhMcjv2SLIh4pQhrHQTshX0KRLSE+q7MaHCPjXEvpHg33KFV26ND
 3a97ChkEk0iULDwo3CPfpVpuNK7IMLx4Zrq0p+uBH5lXy5P48sjw72/iepDUOoLtvuHY
 1Bz2kGOFItUpSPsMvE/3kHYywglQ9TE6Te2dhnRbH+pUQsShXzQWUzqvTN5G0Jk8a2On eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3scxyqr84y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:37:34 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37ABbYqc013510;
        Thu, 10 Aug 2023 11:37:34 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3scxyqr7s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:37:34 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37ABH2MQ006646;
        Thu, 10 Aug 2023 11:32:59 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sa0rthfxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Aug 2023 11:32:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37ABWugc45810314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Aug 2023 11:32:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5293D20040;
        Thu, 10 Aug 2023 11:32:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 151D820043;
        Thu, 10 Aug 2023 11:32:56 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 10 Aug 2023 11:32:56 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v3 0/3] KVM: s390: Enable AP instructions for PV-guests
Date:   Thu, 10 Aug 2023 13:32:52 +0200
Message-Id: <20230810113255.2163043-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZP269-M4IYS4Lto_LmT28_1unS-oqYZt
X-Proofpoint-GUID: 8GV2C3SbpSZFAGcsAnQUYC3KqkQe83_Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-10_10,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxlogscore=598 spamscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308100098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables general KVM support for AP-passthrough for Secure
Execution guests (PV-guests).

To enable AP inside PV-guests two things have to be done/considered:
	1) set corresponding flags in the Create Secure Configuration UVC if
     firmware supports AP for PV-guests (patch 3).
	2) enable/disable AP in PV-guests if the VMM wants this (patch 2).

since v2:
  - applied styling recommendations from Heiko

since v1:
  - PATCH 1: r-b from Claudio
  - PATCH 2: fixed formatting issues (Claudio)
  - PATCH 3: removed unnecessary checks (Claudio)

Steffen

Steffen Eiden (3):
  s390: uv: UV feature check utility
  KVM: s390: Add UV feature negotiation
  KVM: s390: pv:  Allow AP-instructions for pv-guests

 arch/s390/include/asm/kvm_host.h |  2 +
 arch/s390/include/asm/uv.h       | 17 ++++++-
 arch/s390/include/uapi/asm/kvm.h | 16 +++++++
 arch/s390/kernel/uv.c            |  2 +-
 arch/s390/kvm/kvm-s390.c         | 76 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/pv.c               |  6 ++-
 arch/s390/mm/fault.c             |  2 +-
 7 files changed, 115 insertions(+), 6 deletions(-)

-- 
2.40.1

