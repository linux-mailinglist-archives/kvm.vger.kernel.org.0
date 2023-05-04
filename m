Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811B66F70A5
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 19:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjEDRQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 13:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjEDRQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 13:16:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76E926B8;
        Thu,  4 May 2023 10:16:18 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344HANUw004031;
        Thu, 4 May 2023 17:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=kJt7bs+LptIuBUV+lN3mzRQlOtnKEX1f/BjBN6yTk+w=;
 b=lBfvlAdooiEojwSKkUIB5Ik5tqdSIrhJQtjC/VWos/tOvR2vd3uSD7sExNXZ2ZdAo2LM
 uaVUPAY6XeUxFm2u58B8qttBnEkPdDnWxJtreEzS4TZ5nApfvS9rtoWf/XqRV+D27R/H
 lY7TpFzzerE77WQ63nQWwJptII4Zl+lH4wCdle6QmC8W9frrav0Up0zGsQrCbf1ibPmD
 wLUp0Sy2p0PqVgtXei3c3+9RuiNsQqjhjFuM6PTKgRxYxGHjKyb8TcOjWzwx8FiXOOW+
 RO7j93PDn/f3b/z3OtC5ez4cJZGTOt2PecZitIGAfHqLHjC/NN2kj6TA36ln19pFbjNh jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qcgfdruuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 17:16:17 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 344HC1IY010663;
        Thu, 4 May 2023 17:16:17 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qcgfdrutn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 17:16:17 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 344GwP3i028489;
        Thu, 4 May 2023 17:16:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6tg66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 17:16:15 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 344HGBlF31981874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 May 2023 17:16:12 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0F062004E;
        Thu,  4 May 2023 17:16:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A43D22004B;
        Thu,  4 May 2023 17:16:11 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  4 May 2023 17:16:11 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, david@redhat.com
Subject: [GIT PULL 0/2] KVM: s390: Some fixes for 6.4
Date:   Thu,  4 May 2023 19:16:09 +0200
Message-Id: <20230504171611.54844-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qyKYPNvi1pfoZtdOVWW-_8endOGEwfxE
X-Proofpoint-ORIG-GUID: YJBMvlmxiFUx1lspsA7-skIbZUlAm3TS
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_10,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=811 spamscore=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040139
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

just a couple of bugfixes, nothing too exceptional here.


please pull, thanks!

Claudio


The following changes since commit 8a46df7cd135fe576c18efa418cd1549e51f2732:

  KVM: s390: pci: fix virtual-physical confusion on module unload/load (2023-04-20 16:30:35 +0200)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.4-2

for you to fetch changes up to c148dc8e2fa403be501612ee409db866eeed35c0:

  KVM: s390: fix race in gmap_make_secure() (2023-05-04 18:26:27 +0200)

----------------------------------------------------------------
For 6.4

----------------------------------------------------------------
Claudio Imbrenda (2):
      KVM: s390: pv: fix asynchronous teardown for small VMs
      KVM: s390: fix race in gmap_make_secure()

 arch/s390/kernel/uv.c | 32 +++++++++++---------------------
 arch/s390/kvm/pv.c    |  5 +++++
 arch/s390/mm/gmap.c   |  7 +++++++
 3 files changed, 23 insertions(+), 21 deletions(-)
