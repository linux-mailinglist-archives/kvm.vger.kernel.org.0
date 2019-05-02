Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E8212121
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 19:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfEBReq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 13:34:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfEBReX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 May 2019 13:34:23 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x42HMher105798
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 13:34:22 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s84n4s0qr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 13:34:22 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 2 May 2019 18:34:20 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 May 2019 18:34:17 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x42HYFMk57409566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 May 2019 17:34:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1C374C046;
        Thu,  2 May 2019 17:34:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20B824C040;
        Thu,  2 May 2019 17:34:15 +0000 (GMT)
Received: from morel-ThinkPad-W530.boeblingen.de.ibm.com (unknown [9.145.190.191])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 May 2019 17:34:15 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     borntraeger@de.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, akrowiak@linux.ibm.com,
        pasic@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, freude@linux.ibm.com, mimu@linux.ibm.com
Subject: [PATCH v8 4/4] s390: ap: kvm: Enable PQAP/AQIC facility for the guest
Date:   Thu,  2 May 2019 19:34:11 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556818451-1806-1-git-send-email-pmorel@linux.ibm.com>
References: <1556818451-1806-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19050217-0012-0000-0000-00000317A4AA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050217-0013-0000-0000-0000215014DD
Message-Id: <1556818451-1806-5-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-02_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=813 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905020112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AP Queue Interruption Control (AQIC) facility gives
the guest the possibility to control interruption for
the Cryptographic Adjunct Processor queues.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 arch/s390/tools/gen_facilities.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index 61ce5b5..aed14fc 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -114,6 +114,7 @@ static struct facility_def facility_defs[] = {
 		.bits = (int[]){
 			12, /* AP Query Configuration Information */
 			15, /* AP Facilities Test */
+			65, /* AP Queue Interruption Control */
 			156, /* etoken facility */
 			-1  /* END */
 		}
-- 
2.7.4

