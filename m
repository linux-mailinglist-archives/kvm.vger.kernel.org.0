Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E703A44DBC5
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 19:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhKKSvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 13:51:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233245AbhKKSvC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 13:51:02 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABH8PJN031101
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 18:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4JGzWKYd99Nn3BjwvwKYURHBiC/emTDyhDqhV+nview=;
 b=iqKbUSFkjz646hQyrgl3LGxchNaODRPdAoSmnhpCb3Jfut4MxU0zqHGS/b8ijfuNRwN/
 VXcQNZdY/EeQP3HMhU+btclzRosCH/kPEyqT8WYjmsze2kM9w8hjjlsZXeKIwmtNwy8X
 s9g7qKxkFBoihqeUmUOLck1PY6moIyrEKMf3HuOP2YQMWNz0nXaGVtGd9X6V1kCyCWBb
 ziBdTAffQUcev5MWse70yA+XErgZNnbwlS15EIdyFCUf76Iok5mrNCcMo0X55x2vRNrd
 R61I/RHnMET1fKDeTV0IFUulqaji3piuP6I+lG0+0Sx8VXp7Nn2JXcUW1qcPTGkYYJvA 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c955gx867-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 18:48:12 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABIEsKf004622
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 18:48:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c955gx856-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 18:48:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABIRC11018957;
        Thu, 11 Nov 2021 18:48:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3c5hbb1363-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 18:48:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABIfLoo63308126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 18:41:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74ABEAE045;
        Thu, 11 Nov 2021 18:48:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11148AE056;
        Thu, 11 Nov 2021 18:48:06 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.69.58])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 18:48:05 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH] s390x: io: declare s390x CPU as big endian
Date:   Thu, 11 Nov 2021 19:48:35 +0100
Message-Id: <20211111184835.113648-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NqrIg29VxyV3bj79qKZJm97ode8Djvf0
X-Proofpoint-ORIG-GUID: mYN4Wb1AO25w_ktkbtuMry-JCOrxsoVy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_06,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=819 clxscore=1015 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To use the swap byte transformations we need to declare
the s390x architecture as big endian.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm/io.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/s390x/asm/io.h b/lib/s390x/asm/io.h
index 1dc6283b..b5e661cf 100644
--- a/lib/s390x/asm/io.h
+++ b/lib/s390x/asm/io.h
@@ -10,6 +10,7 @@
 #define _ASMS390X_IO_H_
 
 #define __iomem
+#define __cpu_is_be() (1)
 
 #include <asm-generic/io.h>
 
-- 
2.25.1

