Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0984F4B08E5
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 09:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbiBJIxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 03:53:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbiBJIxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 03:53:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CC3D4A;
        Thu, 10 Feb 2022 00:53:17 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21A8RRoq008204;
        Thu, 10 Feb 2022 08:53:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Xpy0CKElFiGRc3KXFeBHMtuaOPp47obItROjImMKUcw=;
 b=LFS99HIORHtNYKkQvl48wvwSILc+5gGzhSmpF38spkptZg/xW+gLZj1iUNLc0ZE/ovqn
 r0Wva0ZvB2JfplyG154SeDNbAB6Sqgwu+Z64t1xmXanz2pvIsUygagNpUq9vM53jpoV5
 FXFzczCvYQWjX9FirJ9hzOELkZCtDe8sEMAy7bmYENTVlQAeGAg4vNpiY1KQ8kGC5e/J
 PeR9J4jUOYJm1vUx1UGnGwbHZU9z+SI3Bt9ZHQ7y3h1EffxRuwk9iiTGARaoiDUa1sS1
 vcgdCCzB7yD43g0advHcQSe0YpIE34ykqXFS1MjXAYcCZwVQsH0BotpIJ5U0cFlolJFg 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4y7b8jy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 08:53:17 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21A8UHau029478;
        Thu, 10 Feb 2022 08:53:16 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4y7b8jxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 08:53:16 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21A8hfr4030635;
        Thu, 10 Feb 2022 08:53:14 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3e1gv9v56g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 08:53:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21A8rB9T44302598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 08:53:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0547E52057;
        Thu, 10 Feb 2022 08:53:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id E67B252050;
        Thu, 10 Feb 2022 08:53:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A45F2E14D7; Thu, 10 Feb 2022 09:53:10 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH] KVM: s390: MAINTAINERS: promote Claudio Imbrenda
Date:   Thu, 10 Feb 2022 09:53:10 +0100
Message-Id: <20220210085310.26388-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 26noSJdC54zA2OI96Cgd2O-zOCv5rODX
X-Proofpoint-GUID: lPenW71w1lNs88M0zKuesktyyopwxGzz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_03,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=757
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio has volunteered to be more involved in the maintainership of
s390 KVM.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f41088418aae..cde32aebb6ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10548,8 +10548,8 @@ F:	arch/riscv/kvm/
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@linux.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
+M:	Claudio Imbrenda <imbrenda@linux.ibm.com>
 R:	David Hildenbrand <david@redhat.com>
-R:	Claudio Imbrenda <imbrenda@linux.ibm.com>
 L:	kvm@vger.kernel.org
 S:	Supported
 W:	http://www.ibm.com/developerworks/linux/linux390/
-- 
2.33.1

