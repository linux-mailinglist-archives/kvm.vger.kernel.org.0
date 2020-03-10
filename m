Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E13F17FC9B
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 14:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgCJNWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 09:22:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730315AbgCJNBt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 09:01:49 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ACxAti086416;
        Tue, 10 Mar 2020 09:01:49 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yp8yc5j6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 09:01:48 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02AD0G8d091518;
        Tue, 10 Mar 2020 09:01:48 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yp8yc5j5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 09:01:48 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02ACtYDg024197;
        Tue, 10 Mar 2020 13:01:46 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 2ym386jqhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 13:01:46 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02AD1kdB31588628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 13:01:46 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 590412805C;
        Tue, 10 Mar 2020 13:01:46 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1550F2806F;
        Tue, 10 Mar 2020 13:01:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 10 Mar 2020 13:01:46 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5/5] selftests: KVM: s390: fix format strings for access reg test
Date:   Tue, 10 Mar 2020 09:01:44 -0400
Message-Id: <20200310130144.9921-6-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200310130144.9921-1-borntraeger@de.ibm.com>
References: <20200310130144.9921-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_06:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

acrs are 32 bit and not 64 bit.

Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/s390x/sync_regs_test.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index b705637ca14b..70a56580042b 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -42,6 +42,13 @@ static void guest_code(void)
 		    " values did not match: 0x%llx, 0x%llx\n", \
 		    left->reg, right->reg)
 
+#define REG_COMPARE32(reg) \
+	TEST_ASSERT(left->reg == right->reg, \
+		    "Register " #reg \
+		    " values did not match: 0x%x, 0x%x\n", \
+		    left->reg, right->reg)
+
+
 static void compare_regs(struct kvm_regs *left, struct kvm_sync_regs *right)
 {
 	int i;
@@ -55,7 +62,7 @@ static void compare_sregs(struct kvm_sregs *left, struct kvm_sync_regs *right)
 	int i;
 
 	for (i = 0; i < 16; i++)
-		REG_COMPARE(acrs[i]);
+		REG_COMPARE32(acrs[i]);
 
 	for (i = 0; i < 16; i++)
 		REG_COMPARE(crs[i]);
@@ -155,7 +162,7 @@ int main(int argc, char *argv[])
 		    "r11 sync regs value incorrect 0x%llx.",
 		    run->s.regs.gprs[11]);
 	TEST_ASSERT(run->s.regs.acrs[0]  == 1 << 11,
-		    "acr0 sync regs value incorrect 0x%llx.",
+		    "acr0 sync regs value incorrect 0x%x.",
 		    run->s.regs.acrs[0]);
 
 	vcpu_regs_get(vm, VCPU_ID, &regs);
-- 
2.25.0

