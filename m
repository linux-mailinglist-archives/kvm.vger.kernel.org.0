Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F892FEE43
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732725AbhAUPRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:17:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732297AbhAUPPs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 10:15:48 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LF3NdL038914;
        Thu, 21 Jan 2021 10:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f/iVi2BnD5qrsshoRRjT0AaZeRvDrPk45GZQX1577jQ=;
 b=DwWixBXsPqUV5I3ptePSD9NK64IXHChx2hhQ1eH+QXdL4qPiiZv6UCZTDNoKtiWh7rdL
 fcbN8ypG05iq7pXlzPhW/FmLnmp8tPmrIoJs4R0dCxYSI1yU6Lpwv9yYX1ssaLa3Oy4u
 rp+cubA42isxv7sUGtlgJJhJUHDzNxvn06MonVbOLYnFVE8hKv/cOocon0c5ahKb/PNb
 4Uh5qVWs1s9XwIL9CwZJUwxEbz0FQdArM+am4lnIxv1SBy0WIupGQOPuYLo5X2cBwmDb
 4fPB8a1en9wVMYB2a7ikk5d7v23F9LAIE5nJCJPPOPxS4xyyZBQ/P2nId21tSMppyJLp 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367bc2hveq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:15:07 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LF3k2M040701;
        Thu, 21 Jan 2021 10:15:06 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367bc2hvd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:15:06 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LFDKYA018797;
        Thu, 21 Jan 2021 15:15:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwss47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 15:15:04 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LFF1sS44499390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 15:15:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E44A11C05C;
        Thu, 21 Jan 2021 15:15:01 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13F4211C066;
        Thu, 21 Jan 2021 15:15:00 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 15:14:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com, hca@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: [PATCH v2 2/2] s390: mm: Fix secure storage access exception handling
Date:   Thu, 21 Jan 2021 10:14:35 -0500
Message-Id: <20210121151436.417240-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121151436.417240-1-frankja@linux.ibm.com>
References: <20210121151436.417240-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_08:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 impostorscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Turns out that the bit 61 in the TEID is not always 1 and if that's
the case the address space ID and the address are
unpredictable. Without an address and its address space ID we can't
export memory and hence we can only send a SIGSEGV to the process or
panic the kernel depending on who caused the exception.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 084ea4d611a3d ("s390/mm: add (non)secure page access exceptions handlers")
Cc: stable@vger.kernel.org
---
 arch/s390/mm/fault.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index e30c7c781172..3e8685ad938d 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -791,6 +791,20 @@ void do_secure_storage_access(struct pt_regs *regs)
 	struct page *page;
 	int rc;
 
+	/* There are cases where we don't have a TEID. */
+	if (!(regs->int_parm_long & 0x4)) {
+		/*
+		 * When this happens, userspace did something that it
+		 * was not supposed to do, e.g. branching into secure
+		 * memory. Trigger a segmentation fault.
+		 */
+		if (user_mode(regs)) {
+			send_sig(SIGSEGV, current, 0);
+			return;
+		} else
+			panic("Unexpected PGM 0x3d with TEID bit 61=0");
+	}
+
 	switch (get_fault_type(regs)) {
 	case USER_FAULT:
 		mm = current->mm;
-- 
2.25.1

