Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE05C257617
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 11:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgHaJKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 05:10:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728152AbgHaJKC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Aug 2020 05:10:02 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07V92laj049413;
        Mon, 31 Aug 2020 05:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=DFIuqgVzlW8Gc0NVAJ9M0WRfu4+bFHJAw7ZdQPHo88A=;
 b=cqJO8560+nPBZCGRi7G4xsjjrOJKKN+zqkPWR9Hzd1ngBNQtTjgY/CD+73YZboPWLx5E
 xcvIlmcuY+MY6jgH2UQzOf5R82o1Du/fWfitH/RY+jBKCFVPIz5WeYggmOOp0gts3vhE
 ElBxCYGrm9wkEldyf8G9Y8GmVg/+j45fsajIS8mq3gGuwrRm/Njp92jY6fVBUrqDijH9
 aYQS5RDgG5iKZyUpVyPxft7BDLAnNj8DZBjBO5iPJdhgzaEkK6kmsjFSsquRyCosfSw1
 NVrGoa1b2MT4w+EQatP+OF+kwfZI/ph8xKT1dw3hxk8t7zwRhTwrYNf/qMVGSqaGR4iK RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 338vdd3j49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 05:09:55 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07V935tk050696;
        Mon, 31 Aug 2020 05:09:55 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 338vdd3j3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 05:09:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07V8TlVh007596;
        Mon, 31 Aug 2020 09:09:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 337en81yad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 09:09:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07V99nqv26411386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 09:09:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5271AE056;
        Mon, 31 Aug 2020 09:09:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02CA1AE045;
        Mon, 31 Aug 2020 09:09:49 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.40.55])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 09:09:48 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH v10 2/2] s390: virtio: PV needs VIRTIO I/O device protection
Date:   Mon, 31 Aug 2020 11:09:46 +0200
Message-Id: <1598864986-13875-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598864986-13875-1-git-send-email-pmorel@linux.ibm.com>
References: <1598864986-13875-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_01:2020-08-28,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0
 bulkscore=0 clxscore=1015 suspectscore=1 mlxlogscore=999 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310051
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If protected virtualization is active on s390, VIRTIO has only retricted
access to the guest memory.
Define CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS and export
arch_has_restricted_virtio_memory_access to advertize VIRTIO if that's
the case, preventing a host error on access attempt.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 arch/s390/Kconfig   |  1 +
 arch/s390/mm/init.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9cfd8de907cb..c12422c26389 100644
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
index 6dc7c3b60ef6..5f289ab1b0d2 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -161,6 +161,16 @@ bool force_dma_unencrypted(struct device *dev)
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

