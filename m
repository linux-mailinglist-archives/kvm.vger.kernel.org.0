Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1553C875B
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 17:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239676AbhGNP2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 11:28:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239647AbhGNP2o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 11:28:44 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16EF4EMj122319;
        Wed, 14 Jul 2021 11:25:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=PTC/PA3UPm2od0iUuksIWrCPOHRc4KP6jR15/OK6v18=;
 b=Ha9oFDUWLFMgw4Sf+SswwrNfhegpzuZEpd33L68wTThYeCRYIEk7/f8IAJGokbQ8gMMs
 E19XirqSI1SXnvr1qPrpPb2N1rU1DkriL/rFaSNrBVyYG+eCD+q9RMNTab2eCWSS67bS
 nvS4akEyl2zo2VFWdDgEH879RWV1eLNUCBs3U6u31swT+HtFoACd8q16PgJ+9u6xRlT0
 E960sOfG0gNsoAoHdG8ZAhfd2JZvgbhKEik3jlZTUkkjppRMV1FMZ4jiLhJ/d2iVHuXV
 8y0J3ua1x4qUMe/Ey/dLgMHbk2XWUV7tA1s8r9TNgRiuAV7pMzXknNthbA/aOxGhhhap pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sph3cquq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 11:25:52 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16EF5j5K128514;
        Wed, 14 Jul 2021 11:25:51 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sph3cqtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 11:25:51 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16EFDSC3013353;
        Wed, 14 Jul 2021 15:25:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 39q2th8yms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 15:25:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16EFNZvP36700524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 15:23:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24322A4040;
        Wed, 14 Jul 2021 15:25:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E2EFA4053;
        Wed, 14 Jul 2021 15:25:45 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.181.132])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 14 Jul 2021 15:25:45 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v1 1/2] s390x: KVM: accept STSI for CPU topology information
Date:   Wed, 14 Jul 2021 17:25:42 +0200
Message-Id: <1626276343-22805-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
References: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ziB4WlOpU_yw75zYet2dHSpXaCx5AX_u
X-Proofpoint-ORIG-GUID: TvPVNJjMNi5Y1FUEcK6Ez-p-pkNY5hAI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-14_08:2021-07-14,2021-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 spamscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107140090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

STSI(15.1.x) gives information on the CPU configuration topology.
Let's accept the interception of STSI with the function code 15 and
let the userland part of the hypervisor handle it.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/kvm/priv.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 9928f785c677..4ab5f8b7780e 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -856,7 +856,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	if (fc > 3) {
+	if (fc > 3 && fc != 15) {
 		kvm_s390_set_psw_cc(vcpu, 3);
 		return 0;
 	}
@@ -893,6 +893,15 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 			goto out_no_data;
 		handle_stsi_3_2_2(vcpu, (void *) mem);
 		break;
+	case 15:
+		if (sel1 != 1 || sel2 < 2 || sel2 > 6)
+			goto out_no_data;
+		if (vcpu->kvm->arch.user_stsi) {
+			insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
+			return -EREMOTE;
+		}
+		kvm_s390_set_psw_cc(vcpu, 3);
+		return 0;
 	}
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
-- 
2.25.1

