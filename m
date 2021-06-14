Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B853A67C3
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhFNN03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:26:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233972AbhFNN03 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 09:26:29 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EDFawj038966;
        Mon, 14 Jun 2021 09:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=y9CL84wnQe7k7A1taQtIcuVMRjAuvsiBTF3+9QEQdGo=;
 b=U1Wgyf/Z0yoXHQFU2sbiLqZXm3/YHU9POZSg4qUdCy1XVz2EB6kzmJF2NyN13JP/CaX7
 Moi0MYc4PkyjaUy7F3UyPHMFXj+fVnXm+X2rpaQwf4YFdKFVIIdahXIZ/miV/aheN3VR
 MTMNVT8vtlUJAe4R1rvT9HtGug7iJ6UNivexOBVhb8op5k5Y9+ZDrisr0s6hr5HEdcmw
 EC2veyTa2IiWUZybIrK0x7S9JYDu20eLsM1obxESJuK0hbB+VnoTtKIA/K7ofSi4x/F8
 9UQ7KBNOZDZ1VSxEi5Z/KJx+V/aJ9zHShmKUv0mxEkX+wt0xMAx4XZ5Gh9TDem9EVN5D tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3967ucr6je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 09:24:06 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15EDHGUC046255;
        Mon, 14 Jun 2021 09:24:06 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3967ucr6hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 09:24:05 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15EDMHHo020121;
        Mon, 14 Jun 2021 13:24:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 394mj90h85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 13:24:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15EDO0a835455290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 13:24:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 096C95204E;
        Mon, 14 Jun 2021 13:24:00 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.73])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 655D452051;
        Mon, 14 Jun 2021 13:23:59 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        david@redhat.com, linux-mm@kvack.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 2/2] KVM: s390: prepare for hugepage vmalloc
Date:   Mon, 14 Jun 2021 15:23:57 +0200
Message-Id: <20210614132357.10202-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614132357.10202-1-imbrenda@linux.ibm.com>
References: <20210614132357.10202-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MACOUu0uzbxoBZ8s-N-FmWGSXvIVkZfQ
X-Proofpoint-GUID: eP1R_AiSZTWmqqULMpxtGYKhlub9CE4J
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_07:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=563 malwarescore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Create Secure Configuration Ultravisor Call does not support using
large pages for the virtual memory area. This is a hardware limitation.

This patch replaces the vzalloc call with an almost equivalent call to
the newly introduced vmalloc_no_huge function, which guarantees that
only small pages will be used for the backing.

The new call will not clear the allocated memory, but that has never
been an actual requirement.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 arch/s390/kvm/pv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 813b6e93dc83..c8841f476e91 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -140,7 +140,12 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	/* Allocate variable storage */
 	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
 	vlen += uv_info.guest_virt_base_stor_len;
-	kvm->arch.pv.stor_var = vzalloc(vlen);
+	/*
+	 * The Create Secure Configuration Ultravisor Call does not support
+	 * using large pages for the virtual memory area.
+	 * This is a hardware limitation.
+	 */
+	kvm->arch.pv.stor_var = vmalloc_no_huge(vlen);
 	if (!kvm->arch.pv.stor_var)
 		goto out_err;
 	return 0;
-- 
2.31.1

