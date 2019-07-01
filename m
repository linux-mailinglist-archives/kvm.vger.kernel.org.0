Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F04E5BC47
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 14:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbfGAM7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 08:59:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727667AbfGAM65 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jul 2019 08:58:57 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61CvS8r138701
        for <kvm@vger.kernel.org>; Mon, 1 Jul 2019 08:58:56 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tfgmsyket-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 08:58:56 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 1 Jul 2019 13:58:53 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 1 Jul 2019 13:58:51 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x61CwoGh27001292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 12:58:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EC19AE056;
        Mon,  1 Jul 2019 12:58:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CFCBAE053;
        Mon,  1 Jul 2019 12:58:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Jul 2019 12:58:50 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id D5CB0E0506; Mon,  1 Jul 2019 14:58:49 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [GIT PULL 3/7] KVM: selftests: Align memory region addresses to 1M on s390x
Date:   Mon,  1 Jul 2019 14:58:44 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190701125848.276133-1-borntraeger@de.ibm.com>
References: <20190701125848.276133-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070112-0028-0000-0000-0000037F5784
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070112-0029-0000-0000-0000243F8D3A
Message-Id: <20190701125848.276133-4-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=906 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

On s390x, there is a constraint that memory regions have to be aligned
to 1M (or running the VM will fail). Introduce a new "alignment" variable
in the vm_userspace_mem_region_add() function which now can be used for
both, huge page and s390x alignment requirements.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190523164309.13345-6-thuth@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
[prepare for THP as outlined by Andrew Jones]
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9ea9ba28af1f1..ab7fcb9acf3da 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -557,6 +557,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	int ret;
 	struct userspace_mem_region *region;
 	size_t huge_page_size = KVM_UTIL_PGS_PER_HUGEPG * vm->page_size;
+	size_t alignment;
 
 	TEST_ASSERT((guest_paddr % vm->page_size) == 0, "Guest physical "
 		"address not on a page boundary.\n"
@@ -606,9 +607,20 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	TEST_ASSERT(region != NULL, "Insufficient Memory");
 	region->mmap_size = npages * vm->page_size;
 
-	/* Enough memory to align up to a huge page. */
+#ifdef __s390x__
+	/* On s390x, the host address must be aligned to 1M (due to PGSTEs) */
+	alignment = 0x100000;
+#else
+	alignment = 1;
+#endif
+
 	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
-		region->mmap_size += huge_page_size;
+		alignment = max(huge_page_size, alignment);
+
+	/* Add enough memory to align up if necessary */
+	if (alignment > 1)
+		region->mmap_size += alignment;
+
 	region->mmap_start = mmap(NULL, region->mmap_size,
 				  PROT_READ | PROT_WRITE,
 				  MAP_PRIVATE | MAP_ANONYMOUS
@@ -618,9 +630,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 		    "test_malloc failed, mmap_start: %p errno: %i",
 		    region->mmap_start, errno);
 
-	/* Align THP allocation up to start of a huge page. */
-	region->host_mem = align(region->mmap_start,
-				 src_type == VM_MEM_SRC_ANONYMOUS_THP ?  huge_page_size : 1);
+	/* Align host address */
+	region->host_mem = align(region->mmap_start, alignment);
 
 	/* As needed perform madvise */
 	if (src_type == VM_MEM_SRC_ANONYMOUS || src_type == VM_MEM_SRC_ANONYMOUS_THP) {
-- 
2.21.0

