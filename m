Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5C82B7A81
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 10:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgKRJjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 04:39:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbgKRJju (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 04:39:50 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI9WPEx154655;
        Wed, 18 Nov 2020 04:39:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TY3VLLUExHJfU4HE1AKylU5l7bPNgjMgJr9aT+gGxTc=;
 b=HuTtTZRbsxHZ+YodwLEobdvGUpoB1KlHCXw6qNWHLISOdPXME9f78ClRK/RNGicFsKbu
 +I7G3lYN2MWJlcs/HvHby4Pb7cu2wmkZXAvK++VRn7ihcWu/Bxyw+XXVivJBaymggTed
 qSWH1HOKuKR0sLxK6T7ZOuTGqASFNU6nWkDI9XPw6CTXYijjYRKKBkw6buXMN55n+gBU
 3pUoPLvsW3baJv7h5VSOgBpwxDq+qWlAn3mozEcZQoSaRydr9Re71PGBvbWS+en1pBm9
 BanmuDS1TdW9qgljxSYhjBAdu36pE6Uq2ltEFnlhCJDUXKrbNPeEPnuVCOJ0F1NM3lsc wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w12kg8k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 04:39:50 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AI9WjIx158429;
        Wed, 18 Nov 2020 04:39:49 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w12kg8j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 04:39:49 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AI9bSq2008085;
        Wed, 18 Nov 2020 09:39:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 34t6v8a1v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 09:39:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AI9digw9765376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 09:39:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 461FCAE053;
        Wed, 18 Nov 2020 09:39:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34396AE04D;
        Wed, 18 Nov 2020 09:39:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Nov 2020 09:39:44 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E761DE23AF; Wed, 18 Nov 2020 10:39:43 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 2/2] MAINTAINERS: add uv.c also to KVM/s390
Date:   Wed, 18 Nov 2020 10:39:42 +0100
Message-Id: <20201118093942.457191-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201118093942.457191-1-borntraeger@de.ibm.com>
References: <20201118093942.457191-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_04:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=924 clxscore=1015 malwarescore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most changes in uv.c are related to KVM. Involve also the KVM team
regarding changes to uv.c.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e73636b75f29..06116d892a4b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9674,6 +9674,7 @@ F:	Documentation/virt/kvm/s390*
 F:	arch/s390/include/asm/gmap.h
 F:	arch/s390/include/asm/kvm*
 F:	arch/s390/include/uapi/asm/kvm*
+F:	arch/s390/kernel/uv.c
 F:	arch/s390/kvm/
 F:	arch/s390/mm/gmap.c
 F:	tools/testing/selftests/kvm/*/s390x/
-- 
2.28.0

