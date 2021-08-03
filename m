Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89DC3DE85F
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhHCI1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:27:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64736 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234375AbhHCI1F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:27:05 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173840IN169552;
        Tue, 3 Aug 2021 04:26:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=uN9Jy/RygmPr0j2QVVcmgizp4GW3r4hPaAmCCbfhlhk=;
 b=Hgd1SO7gqRaDvFNaLMJ2Bpytxzo0sQQJPPfzORxoMC/r7l5HfFCmTaeDYT2d7ppT7a/n
 yJ62qslwaAzfx1Md7HOIazl+foIajfC+4szo9sGhXiIwaTGxdGuHqurdLCPFIdqUvyF8
 SxrRtgX5DVUH6X6XT/k6m+ZqrX/K0GyCVNPf9Np8ZAcsHVxSXy0Ra/ajgc/x2hvDmtAE
 W9lPeLy+qctPrQf7VOb72FXQjGpvqoiKtH/Y1Pyl6wdnqtoZ/21CQGOTvXbSFLe+a1VI
 vqPtAldbCgFRRS75pX25S93kU+1fAMAQfQx7fzECxa3nJeFg8TA62AwvPOn3PKB4G5Sb rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a5u8cf7bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:26:54 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17385VtB179680;
        Tue, 3 Aug 2021 04:26:54 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a5u8cf7ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:26:53 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1738HIia008820;
        Tue, 3 Aug 2021 08:26:52 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3a4wshpp41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 08:26:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1738QmAY44433852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 08:26:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90531A405E;
        Tue,  3 Aug 2021 08:26:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0516BA405D;
        Tue,  3 Aug 2021 08:26:48 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.75.95])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Aug 2021 08:26:47 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v3 1/3] s390x: KVM: accept STSI for CPU topology information
Date:   Tue,  3 Aug 2021 10:26:44 +0200
Message-Id: <1627979206-32663-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yr6EgA-hxe1ozPlaPLt9WzVgf3a33Y7b
X-Proofpoint-GUID: 1VN58dVkjlKTnda4kFo9g-UJ5gMuN3d5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_02:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030055
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

