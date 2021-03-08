Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9473310D5
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCHOdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:33:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229737AbhCHOdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:44 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EWmV7001745;
        Mon, 8 Mar 2021 09:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aXRKdTUTrAAAnxWCaRraVCjjQUDpTiVeLhhHQan33Og=;
 b=pf+bmAWd4+Jrw9wpT77Buddv97K5/b0eTjbXaW482H71aDKNBjRPsbi2wyeMykpxV19N
 durlchD2IwvNIDhTxFXzn9vizMw5pcXZHlxvaxj9NR8/iXOiuRoCvMHjQ3kmAgdxZ6vO
 HscmiE3U6PK6TetA2qmfhAXTmbK8C6tc5thG7SZX0zUIeOR/BR+vhPOdvPWj/TTpbn4L
 cOLL8tL/twFEwh12RRna7T7ARLU5AEP3IZLCaTi8zt/lDtYFEZ32xBdOxQdxwL8bwMJN
 2oxE5j/H+bF0QYveNTxIu3VQNOeoF6kYfEVPz3TG2+DEr1PF+VlrdYiKFrh3cwnwUY2h YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375mtwj8d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:44 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EWqdd002175;
        Mon, 8 Mar 2021 09:33:43 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375mtwj8c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:43 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EXGqk015217;
        Mon, 8 Mar 2021 14:33:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3741c8h03a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXNHo16187714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DB6DA4053;
        Mon,  8 Mar 2021 14:33:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10EB2A4055;
        Mon,  8 Mar 2021 14:33:38 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:37 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 03/16] s390x: define UV compatible I/O allocation
Date:   Mon,  8 Mar 2021 15:31:34 +0100
Message-Id: <20210308143147.64755-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 clxscore=1015 adultscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

To centralize the memory allocation for I/O we define
the alloc_io_mem/free_io_mem functions which share the I/O
memory with the host in case the guest runs with
protected virtualization.

These functions allocate on a page integral granularity to
ensure a dedicated sharing of the allocated objects.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@de.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Message-Id: <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
 s390x/Makefile        |  1 +
 3 files changed, 117 insertions(+)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
new file mode 100644
index 00000000..1dcf1691
--- /dev/null
+++ b/lib/s390x/malloc_io.c
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * I/O page allocation
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * Using this interface provide host access to the allocated pages in
+ * case the guest is a protected guest.
+ * This is needed for I/O buffers.
+ *
+ */
+#include <libcflat.h>
+#include <asm/page.h>
+#include <asm/uv.h>
+#include <malloc_io.h>
+#include <alloc_page.h>
+#include <asm/facility.h>
+#include <bitops.h>
+
+static int share_pages(void *p, int count)
+{
+	int i = 0;
+
+	for (i = 0; i < count; i++, p += PAGE_SIZE)
+		if (uv_set_shared((unsigned long)p))
+			break;
+	return i;
+}
+
+static void unshare_pages(void *p, int count)
+{
+	int i;
+
+	for (i = count; i > 0; i--, p += PAGE_SIZE)
+		uv_remove_shared((unsigned long)p);
+}
+
+void *alloc_io_mem(int size, int flags)
+{
+	int order = get_order(size >> PAGE_SHIFT);
+	void *p;
+	int n;
+
+	assert(size);
+
+	p = alloc_pages_flags(order, AREA_DMA31 | flags);
+	if (!p || !test_facility(158))
+		return p;
+
+	n = share_pages(p, 1 << order);
+	if (n == 1 << order)
+		return p;
+
+	unshare_pages(p, n);
+	free_pages(p);
+	return NULL;
+}
+
+void free_io_mem(void *p, int size)
+{
+	int order = get_order(size >> PAGE_SHIFT);
+
+	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
+
+	if (test_facility(158))
+		unshare_pages(p, 1 << order);
+	free_pages(p);
+}
diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
new file mode 100644
index 00000000..cc5fad79
--- /dev/null
+++ b/lib/s390x/malloc_io.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * I/O allocations
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ */
+#ifndef _S390X_MALLOC_IO_H_
+#define _S390X_MALLOC_IO_H_
+
+/*
+ * Allocates a page aligned page bound range of contiguous real or
+ * absolute memory in the DMA31 region large enough to contain size
+ * bytes.
+ * If Protected Virtualisation facility is present, shares the pages
+ * with the host.
+ * If all the pages for the specified size cannot be reserved,
+ * the function rewinds the partial allocation and a NULL pointer
+ * is returned.
+ *
+ * @size: the minimal size allocated in byte.
+ * @flags: the flags used for the underlying page allocator.
+ *
+ * Errors:
+ *   The allocation will assert the size parameter, will fail if the
+ *   underlying page allocator fail or in the case of protected
+ *   virtualisation if the sharing of the pages fails.
+ *
+ * Returns a pointer to the first page in case of success, NULL otherwise.
+ */
+void *alloc_io_mem(int size, int flags);
+
+/*
+ * Frees a previously memory space allocated by alloc_io_mem.
+ * If Protected Virtualisation facility is present, unshares the pages
+ * with the host.
+ * The address must be aligned on a page boundary otherwise an assertion
+ * breaks the program.
+ */
+void free_io_mem(void *p, int size);
+
+#endif /* _S390X_MALLOC_IO_H_ */
diff --git a/s390x/Makefile b/s390x/Makefile
index 08d85c9f..f3b0fccf 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -64,6 +64,7 @@ cflatobjs += lib/s390x/smp.o
 cflatobjs += lib/s390x/vm.o
 cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
+cflatobjs += lib/s390x/malloc_io.o
 
 OBJDIRS += lib/s390x
 
-- 
2.29.2

