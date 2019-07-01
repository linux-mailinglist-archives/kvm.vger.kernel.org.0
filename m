Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8FE5BC43
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 14:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfGAM7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 08:59:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727848AbfGAM66 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jul 2019 08:58:58 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61Cuubt101076
        for <kvm@vger.kernel.org>; Mon, 1 Jul 2019 08:58:57 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tfhxyjmm1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 08:58:57 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 1 Jul 2019 13:58:55 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 1 Jul 2019 13:58:52 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x61CwpYj47710326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 12:58:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3110011C054;
        Mon,  1 Jul 2019 12:58:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F8BD11C04C;
        Mon,  1 Jul 2019 12:58:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Jul 2019 12:58:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id DAAA3E0506; Mon,  1 Jul 2019 14:58:50 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [GIT PULL 6/7] KVM: selftests: Move kvm_create_max_vcpus test to generic code
Date:   Mon,  1 Jul 2019 14:58:47 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190701125848.276133-1-borntraeger@de.ibm.com>
References: <20190701125848.276133-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070112-0028-0000-0000-0000037F5785
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070112-0029-0000-0000-0000243F8D3C
Message-Id: <20190701125848.276133-7-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

There is nothing x86-specific in the test apart from the VM_MODE_P52V48_4K
which we can now replace with VM_MODE_DEFAULT. Thus let's move the file to
the main folder and enable it for aarch64 and s390x, too.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190523164309.13345-10-thuth@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/Makefile                          | 4 +++-
 .../testing/selftests/kvm/{x86_64 => }/kvm_create_max_vcpus.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)
 rename tools/testing/selftests/kvm/{x86_64 => }/kvm_create_max_vcpus.c (93%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ed8eb6007566b..05a94a13a0a31 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -22,15 +22,17 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
-TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
+TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
+TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 
 TEST_GEN_PROGS_s390x += s390x/sync_regs_test
+TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
similarity index 93%
rename from tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
rename to tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index 50e92996f9186..db78ce07c4164 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * kvm_create_max_vcpus
  *
@@ -28,7 +29,7 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
 	printf("Testing creating %d vCPUs, with IDs %d...%d.\n",
 	       num_vcpus, first_vcpu_id, first_vcpu_id + num_vcpus - 1);
 
-	vm = vm_create(VM_MODE_P52V48_4K, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 
 	for (i = 0; i < num_vcpus; i++) {
 		int vcpu_id = first_vcpu_id + i;
-- 
2.21.0

