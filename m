Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB48C3C875D
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 17:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbhGNP2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 11:28:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16204 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239654AbhGNP2o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 11:28:44 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EF3LmR108704;
        Wed, 14 Jul 2021 11:25:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=XAIV8edDl+vWuTri4GUkylTAefVkVrTAbXsqFw30784=;
 b=jyJFRCxdI0U7Etq5LvDXCkWRkRMxCcbpaoaAChTVY72qL4NuWTRvfN/dsqO7uFoPrQSY
 fwn9Ea8ifrFD1W5LPwsXeEqI+ytx6Pv7cp4H4OI7Nc7Abyjg/zO7cmKPLYymP0Ixz/Cb
 4nA5cTtmcn29+eFjm48ZfXJQU9WsS9H6FmT5LTwSXjHNalpJUImdYjlNGaL360cuNzkL
 49mUL6rCi19zhEt1jkezcEk+wzrGJcIaACwpP7drPOlyK0gypVjrUqXhsGj9WSIbHajt
 ygajG/uaswfpmh2t9/4FkKTn5qT1gCrxMGJ+EHcKG1bhxhNC2BVAHt/GrtQ0tACfUFws /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc2y61ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 11:25:52 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16EF3Ooi108928;
        Wed, 14 Jul 2021 11:25:51 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc2y61a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 11:25:51 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16EFCpG3011662;
        Wed, 14 Jul 2021 15:25:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 39q3689um0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 15:25:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16EFNaJh33292798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 15:23:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C721DA404D;
        Wed, 14 Jul 2021 15:25:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3716EA4053;
        Wed, 14 Jul 2021 15:25:46 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.181.132])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 14 Jul 2021 15:25:46 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v1 2/2] KVM: s390: Topology expose TOPOLOGY facility
Date:   Wed, 14 Jul 2021 17:25:43 +0200
Message-Id: <1626276343-22805-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
References: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WaSwic6vY5jXMKlr6yeYCpntcelhnZfB
X-Proofpoint-ORIG-GUID: 3Y7C8GCaaYZaCSij0dDgHr1zUbuVLUqe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-14_08:2021-07-14,2021-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add the KVM extension KVM_CAP_S390_CPU_TOPOLOGY, this will
allow the userland hypervisor to handle the interception of the
PTF (Perform topology Function) instruction.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/tools/gen_facilities.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index 606324e56e4e..2c260eb22bae 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -112,6 +112,7 @@ static struct facility_def facility_defs[] = {
 
 		.name = "FACILITIES_KVM_CPUMODEL",
 		.bits = (int[]){
+			11, /* configuration topology facility */
 			12, /* AP Query Configuration Information */
 			15, /* AP Facilities Test */
 			156, /* etoken facility */
-- 
2.25.1

