Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FE13D2ABC
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhGVQWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 12:22:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233442AbhGVQWN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 12:22:13 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MGYYFP093776;
        Thu, 22 Jul 2021 13:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=uN9Jy/RygmPr0j2QVVcmgizp4GW3r4hPaAmCCbfhlhk=;
 b=JuXHvVoEDFQdzgQH3iFNWzW1G6ylE2xPbImjLpb02cyVp+KVRFmD/By8sDluK6z9eN0g
 Q/mrbmoky5jWUMMkHcfd4mud9kQEmvP6bsuaiZRQoyeHYdvIPTTnG1N+lpcLn9w5VlKJ
 j55Xw3CZLV6jfNz8UtEWs9Y8skuKKu7ckClyzcHKXSy4uDJ+uaTPleEJqU2ZSmGABjxA
 WQ30WorX8j32I8Dth1shkFsDGIqDzdrVKJAFBHMN8JU+IUsmMrbhZVUMtv+XsxCs4CRV
 hBUDzEiZonHUIwYtrBOBd+H38/hjSu5KB4yPpCLaFPYO2CGqSqbGRRXPbATCZ7ze4isf xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ybdske8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 13:02:47 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16MGYaii093955;
        Thu, 22 Jul 2021 13:02:47 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ybdske7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 13:02:47 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16MGxtDd001816;
        Thu, 22 Jul 2021 17:02:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 39xhx48s7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 17:02:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16MH2gx327460088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 17:02:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E84CEAE055;
        Thu, 22 Jul 2021 17:02:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61178AE051;
        Thu, 22 Jul 2021 17:02:41 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.18.177])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jul 2021 17:02:41 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v2 1/2] s390x: KVM: accept STSI for CPU topology information
Date:   Thu, 22 Jul 2021 19:02:32 +0200
Message-Id: <1626973353-17446-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626973353-17446-1-git-send-email-pmorel@linux.ibm.com>
References: <1626973353-17446-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qjWlHxae05-kGmDxNnDpWIspBhxKv5Q0
X-Proofpoint-ORIG-GUID: fYgjY9eys8L0rH2InpKZ7p1FHM251IrQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-22_09:2021-07-22,2021-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 bulkscore=0
 spamscore=0 phishscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

STSI(15.1.x) gives information on the CPU configuration topology.
Let's accept the interception of STSI with the function code 15 and
let the userland part of the hypervisor handle it when userland
support the CPU Topology facility.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/kvm/priv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 9928f785c677..8581b6881212 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -856,7 +856,8 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	if (fc > 3) {
+	if ((fc > 3 && fc != 15) ||
+	    (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))) {
 		kvm_s390_set_psw_cc(vcpu, 3);
 		return 0;
 	}
@@ -893,6 +894,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 			goto out_no_data;
 		handle_stsi_3_2_2(vcpu, (void *) mem);
 		break;
+	case 15:
+		trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
+		insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
+		return -EREMOTE;
 	}
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
-- 
2.25.1

