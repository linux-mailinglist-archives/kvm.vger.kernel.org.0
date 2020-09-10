Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8203426409E
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 10:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgIJIy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 04:54:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729005AbgIJIyK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 04:54:10 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08A8XweY103296;
        Thu, 10 Sep 2020 04:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=yO1GjViRv1bglEtAAUDSoRen6fdrhR52DgjMHr1Ss7E=;
 b=GJealwQiVQrXqukAXO9zL3qSD0+he4QldOpyqughATuLoumJLkwN2ElncH1Zg1cFFmRD
 j/ufpEIKJKXxnACxidzrxkci2ns+kPwoB6JOMYHLc8DCphqUagtwz7Zd3O/7yxygdzkp
 AHNdCTb3M1y+5YI0Z260ImbvhDYYt9j7XteLw6eRJGsDUaMtYsN7NLE9dWhyi+EsM8fj
 q/ZowfqWXtAWg8nM4eOUFFMskEguOLqnBvssfHc8GyACkesgXipe34UKRA7K8j9ZCtmB
 RjBEpPLaVvDz2gCc6lO0iucO86vBEX+umNv0n4p8ye5KBmAszYvSho7G7Kgqk8nKKieW kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fgmn0p35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 04:54:01 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08A8YIV4103913;
        Thu, 10 Sep 2020 04:54:01 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fgmn0p1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 04:54:01 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08A8qqOI024628;
        Thu, 10 Sep 2020 08:53:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 33f91w885p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 08:53:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08A8qL4R60031370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 08:52:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C12511C050;
        Thu, 10 Sep 2020 08:53:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8050211C058;
        Thu, 10 Sep 2020 08:53:53 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.144])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 08:53:53 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH v12 2/2] s390: virtio: PV needs VIRTIO I/O device protection
Date:   Thu, 10 Sep 2020 10:53:50 +0200
Message-Id: <1599728030-17085-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1599728030-17085-1-git-send-email-pmorel@linux.ibm.com>
References: <1599728030-17085-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_01:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 adultscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100079
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If protected virtualization is active on s390, VIRTIO has only retricted
access to the guest memory.
Define CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS and export
arch_has_restricted_virtio_memory_access to advertize VIRTIO if that's
the case.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
 arch/s390/Kconfig   |  1 +
 arch/s390/mm/init.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index b29fcc66ec39..938246200d39 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -820,6 +820,7 @@ menu "Virtualization"
 config PROTECTED_VIRTUALIZATION_GUEST
 	def_bool n
 	prompt "Protected virtualization guest support"
+	select ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS
 	help
 	  Select this option, if you want to be able to run this
 	  kernel as a protected virtualization KVM guest.
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 0d282081dc1f..e27f050cb516 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -45,6 +45,7 @@
 #include <asm/kasan.h>
 #include <asm/dma-mapping.h>
 #include <asm/uv.h>
+#include <linux/virtio_config.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
 
@@ -160,6 +161,16 @@ bool force_dma_unencrypted(struct device *dev)
 	return is_prot_virt_guest();
 }
 
+#ifdef CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS
+
+int arch_has_restricted_virtio_memory_access(void)
+{
+	return is_prot_virt_guest();
+}
+EXPORT_SYMBOL(arch_has_restricted_virtio_memory_access);
+
+#endif
+
 /* protected virtualization */
 static void pv_init(void)
 {
-- 
2.25.1

