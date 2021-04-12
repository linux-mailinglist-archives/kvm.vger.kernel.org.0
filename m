Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3522235CAC8
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243302AbhDLQGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:06:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41246 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243252AbhDLQGQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 12:06:16 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG3vrf016611;
        Mon, 12 Apr 2021 12:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=ATEshe8k928PibaQLa2a2U6E8anqabzsu3OrNRgQCk8=;
 b=p2NZBSw6Nt5pafYbnpDo7tjxONzzzS7dZfy1zCbQQ1Q7WwpVhzNXZ3NmNJRCT0qE5uwX
 xVcpjYZiI2K7ssJprsea1gAYooInQBT9Y1B358YNeiKqOvMvEKlo8rzT7maO17/ulPCv
 e9d7tUOLQV+kjVvo48PFo08+P4aKML0K0+vB+bJ7FjC32L/wZbLF3ANlruqGmZPW4vmf
 1smZ4iqZdD4qRrDwsuP6TOrvSgAKoUPf3r4s2j5y+h3EpG1VKr4CLPoQVmm5jmb1ZuVr
 vvPavkze07b2MLM9WTls00cuz09EG+5HUnfcSDrntcDwOf5yOY9wCvT2rtwsHDoshxiZ vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vjtt7s3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:52 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CG4TLf019942;
        Mon, 12 Apr 2021 12:05:51 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vjtt7s2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CFprfZ029682;
        Mon, 12 Apr 2021 16:05:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 37u3n89y1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:05:49 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CG5ktM57409848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:05:46 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACF584C046;
        Mon, 12 Apr 2021 16:05:46 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A29D74C058;
        Mon, 12 Apr 2021 16:05:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 12 Apr 2021 16:05:46 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 6199BE02A6; Mon, 12 Apr 2021 18:05:46 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [GIT PULL 1/7] KVM: s390: Fix comment spelling in kvm_s390_vcpu_start()
Date:   Mon, 12 Apr 2021 18:05:39 +0200
Message-Id: <20210412160545.231194-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412160545.231194-1-borntraeger@de.ibm.com>
References: <20210412160545.231194-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J9DqRhg995KS7rA2OZ_QAdDLi1-DFBlT
X-Proofpoint-ORIG-GUID: uk1mVnzQOlfzzOX9silV3MyN-BDsJlDj
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxscore=0 mlxlogscore=900 clxscore=1015 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

s/oustanding/outstanding/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20210213153227.1640682-1-unixbhaskar@gmail.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2f09e9d7dc95..333193982e51 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4542,7 +4542,7 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 		/*
 		 * As we are starting a second VCPU, we have to disable
 		 * the IBS facility on all VCPUs to remove potentially
-		 * oustanding ENABLE requests.
+		 * outstanding ENABLE requests.
 		 */
 		__disable_ibs_on_all_vcpus(vcpu->kvm);
 	}
-- 
2.30.2

