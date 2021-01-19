Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21432FBDF8
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 18:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391352AbhASOua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:50:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389551AbhASKFs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:05:48 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JA1l50010572;
        Tue, 19 Jan 2021 05:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=moOU28gvvMta6uWMdNJk6EeImI3fQmyyyTwDtyprFDY=;
 b=SWwLGAPUJ9Muz4W82v6pk5dFnLded0DcWW6lq+Gzwt73PX59XTfThAzlPXg4Af/EDExC
 YPaRcX8Uo/JiE/c05LrPZB5atbZTrlx91KSGkuYNUtc7eA5l4tM+T6SQIMMa3FRDq9qi
 BLuPkwxgWvualcgg8BIrzpP6Bx55Yxsk003u47vy55Ygekhs2S5hIL74vevOWvwfdqgR
 HkejhMq9ipKupusED+pnRK2+rizMRBa4B4UdaNMG6mjXPgEa5w7HSIKU0TY+6lE4P4yd
 FX4ww07hqVlANv+wBgeLeohk/sg4X7aWHmq64SBt6d3VvM2/YUBC7IO/rUWqa+ZT4/9h Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 365w8wg6tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:05:06 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JA2tDJ015937;
        Tue, 19 Jan 2021 05:05:06 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 365w8wg6s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:05:06 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JA3MSq009050;
        Tue, 19 Jan 2021 10:05:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 363qs7jx2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:05:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JA516M33620394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 10:05:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C67BE4C040;
        Tue, 19 Jan 2021 10:05:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA0814C059;
        Tue, 19 Jan 2021 10:05:00 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 10:05:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: [PATCH 2/2] s390: mm: Fix secure storage access exception handling
Date:   Tue, 19 Jan 2021 05:04:02 -0500
Message-Id: <20210119100402.84734-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119100402.84734-1-frankja@linux.ibm.com>
References: <20210119100402.84734-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 clxscore=1011 spamscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Turns out that the bit 61 in the TEID is not always 1 and if that's
the case the address space ID and the address are
unpredictable. Without an address and it's address space ID we can't
export memory and hence we can only send a SIGSEGV to the process or
panic the kernel depending on who caused the exception.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 084ea4d611a3d ("s390/mm: add (non)secure page access exceptions handlers")
Cc: stable@vger.kernel.org
---
 arch/s390/mm/fault.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index e30c7c781172..5442937e5b4b 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -791,6 +791,20 @@ void do_secure_storage_access(struct pt_regs *regs)
 	struct page *page;
 	int rc;
 
+	/* There are cases where we don't have a TEID. */
+	if (!(regs->int_parm_long & 0x4)) {
+		/*
+		 * Userspace could for example try to execute secure
+		 * storage and trigger this. We should tell it that it
+		 * shouldn't do that.
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

