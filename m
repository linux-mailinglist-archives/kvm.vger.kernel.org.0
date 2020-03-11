Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4D1181965
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 14:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgCKNQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 09:16:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729103AbgCKNQd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 09:16:33 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02BDFgbB030116
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 09:16:32 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yq04ghny2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 09:16:32 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 11 Mar 2020 13:11:02 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Mar 2020 13:10:59 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02BDAwc535848430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 13:10:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31123A405D;
        Wed, 11 Mar 2020 13:10:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 295F3A4057;
        Wed, 11 Mar 2020 13:10:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 11 Mar 2020 13:10:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E0C45E024B; Wed, 11 Mar 2020 14:10:57 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH 2/2] selftests: KVM: s390: fix format strings for access reg test
Date:   Wed, 11 Mar 2020 14:10:56 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311131056.140016-1-borntraeger@de.ibm.com>
References: <20200311131056.140016-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20031113-0028-0000-0000-000003E31DA7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031113-0029-0000-0000-000024A86214
Message-Id: <20200311131056.140016-3-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_05:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=816 spamscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110084
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
2.24.1

