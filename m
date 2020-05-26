Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3981C6FCB
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgEFL7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:59:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727994AbgEFL7y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 07:59:54 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BhZG0113419;
        Wed, 6 May 2020 07:59:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30uvm90eba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 07:59:53 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 046BjDxF117461;
        Wed, 6 May 2020 07:59:52 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30uvm90eah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 07:59:52 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 046BoK2n021410;
        Wed, 6 May 2020 11:59:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5s4ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 11:59:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 046BxlFY62325060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 11:59:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0052AE051;
        Wed,  6 May 2020 11:59:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D41BAE04D;
        Wed,  6 May 2020 11:59:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  6 May 2020 11:59:47 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 460F6E0554; Wed,  6 May 2020 13:59:47 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Qian Cai <cailca@icloud.com>
Subject: [GIT PULL 1/1] KVM: s390: Remove false WARN_ON_ONCE for the PQAP instruction
Date:   Wed,  6 May 2020 13:59:45 +0200
Message-Id: <20200506115945.13132-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200506115945.13132-1-borntraeger@de.ibm.com>
References: <20200506115945.13132-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_04:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In LPAR we will only get an intercept for FC==3 for the PQAP
instruction. Running nested under z/VM can result in other intercepts as
well as ECA_APIE is an effective bit: If one hypervisor layer has
turned this bit off, the end result will be that we will get intercepts for
all function codes. Usually the first one will be a query like PQAP(QCI).
So the WARN_ON_ONCE is not right. Let us simply remove it.

Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: stable@vger.kernel.org # v5.3+
Fixes: e5282de93105 ("s390: ap: kvm: add PQAP interception for AQIC")
Link: https://lore.kernel.org/kvm/20200505083515.2720-1-borntraeger@de.ibm.com
Reported-by: Qian Cai <cailca@icloud.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/priv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 69a824f9ef0b..893893642415 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -626,10 +626,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	 * available for the guest are AQIC and TAPQ with the t bit set
 	 * since we do not set IC.3 (FIII) we currently will only intercept
 	 * the AQIC function code.
+	 * Note: running nested under z/VM can result in intercepts for other
+	 * function codes, e.g. PQAP(QCI). We do not support this and bail out.
 	 */
 	reg0 = vcpu->run->s.regs.gprs[0];
 	fc = (reg0 >> 24) & 0xff;
-	if (WARN_ON_ONCE(fc != 0x03))
+	if (fc != 0x03)
 		return -EOPNOTSUPP;
 
 	/* PQAP instruction is allowed for guest kernel only */
-- 
2.25.4

