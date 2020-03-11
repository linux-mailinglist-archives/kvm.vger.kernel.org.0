Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A265181950
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 14:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgCKNLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 09:11:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14074 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729442AbgCKNLs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 09:11:48 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02BD4Nbn160683
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 09:11:47 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ypyph9qbr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 09:11:45 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 11 Mar 2020 13:11:00 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Mar 2020 13:10:58 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02BD9w1i48431552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 13:09:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8E9CA405D;
        Wed, 11 Mar 2020 13:10:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7409A4059;
        Wed, 11 Mar 2020 13:10:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 11 Mar 2020 13:10:57 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 6AE6AE024B; Wed, 11 Mar 2020 14:10:57 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH 1/2] selftests: KVM: s390: fixup fprintf format error in reset.c
Date:   Wed, 11 Mar 2020 14:10:55 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311131056.140016-1-borntraeger@de.ibm.com>
References: <20200311131056.140016-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20031113-0012-0000-0000-0000038F669F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031113-0013-0000-0000-000021CC354D
Message-Id: <20200311131056.140016-2-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_05:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

value is u64 and not string.

Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/s390x/resets.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index b567705f0d41..221e9c9a8bd2 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -66,7 +66,7 @@ static void test_one_reg(uint64_t id, uint64_t value)
 	reg.addr = (uintptr_t)&eval_reg;
 	reg.id = id;
 	vcpu_get_reg(vm, VCPU_ID, &reg);
-	TEST_ASSERT(eval_reg == value, "value == %s", value);
+	TEST_ASSERT(eval_reg == value, "value == 0x%lx", value);
 }
 
 static void assert_noirq(void)
-- 
2.24.1

