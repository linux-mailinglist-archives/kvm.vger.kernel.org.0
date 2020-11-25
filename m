Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C812C3B92
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgKYJHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:07:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbgKYJHF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:07:05 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AP94UBq160234;
        Wed, 25 Nov 2020 04:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2DWrLZN/AMjBuA8TzWNiQ+ZPU8UThgTKLRNsgUQGFFw=;
 b=haV1423+T9HvYt9thxikbVTtZo3SKLwMIO36wzj9w0h9iygSZ406hsUiYKlEqo+9kOKI
 ZsjPnMPJ6LAp4fDUu7lOL5jD6eCvSmzuy5Yy7fjmC/h0wgtOpFlZKowy4X5sJ0Wo42OX
 W5NXzzIyj1qDcsMQAXZvbvSExklzGiyg97Y4eZJW+tr3q8sKE0DFlrYiIgIe9F1AAtDD
 7VwuRRaGiQ7d66JiZyUheL3BFJ5WQX5CUL8NjROqogvojxNcDWtvwQLVhANjUbbIY8lN
 zV6Re1Ljj0mA0yR841aI1yCruisMp7vXTNBZQ7n8B5KsZRZNMpsV++qgK9dcAXVxJQoV OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351dd3tw44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 04:07:04 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AP94s7Z162639;
        Wed, 25 Nov 2020 04:07:04 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351dd3tw2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 04:07:04 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AP9252o006316;
        Wed, 25 Nov 2020 09:07:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34xth8cf67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 09:07:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AP96xhc64356734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 09:06:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 699AEAE057;
        Wed, 25 Nov 2020 09:06:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 615A3AE072;
        Wed, 25 Nov 2020 09:06:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Nov 2020 09:06:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 1D963E1472; Wed, 25 Nov 2020 10:06:59 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: [PATCH] KVM: s390: track synchronous pfault events in kvm_stat
Date:   Wed, 25 Nov 2020 10:06:58 +0100
Message-Id: <20201125090658.38463-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-25_04:2020-11-25,2020-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250051
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now we do count pfault (pseudo page faults aka async page faults
start and completion events). What we do not count is, if an async page
fault would have been possible by the host, but it was disabled by the
guest (e.g. interrupts off, pfault disabled, secure execution....).  Let
us count those as well in the pfault_sync counter.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 1 +
 arch/s390/kvm/kvm-s390.c         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 463c24e26000..74f9a036bab2 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -459,6 +459,7 @@ struct kvm_vcpu_stat {
 	u64 diagnose_308;
 	u64 diagnose_500;
 	u64 diagnose_other;
+	u64 pfault_sync;
 };
 
 #define PGM_OPERATION			0x01
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 282a13ece554..dbafd057ca6a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -60,6 +60,7 @@
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("userspace_handled", exit_userspace),
 	VCPU_STAT("exit_null", exit_null),
+	VCPU_STAT("pfault_sync", pfault_sync),
 	VCPU_STAT("exit_validity", exit_validity),
 	VCPU_STAT("exit_stop_request", exit_stop_request),
 	VCPU_STAT("exit_external_request", exit_external_request),
@@ -4109,6 +4110,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 		current->thread.gmap_pfault = 0;
 		if (kvm_arch_setup_async_pf(vcpu))
 			return 0;
+		vcpu->stat.pfault_sync++;
 		return kvm_arch_fault_in_page(vcpu, current->thread.gmap_addr, 1);
 	}
 	return vcpu_post_run_fault_in_sie(vcpu);
-- 
2.28.0

