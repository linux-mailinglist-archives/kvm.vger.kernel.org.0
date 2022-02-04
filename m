Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639C14A9C5F
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376309AbiBDPyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:54:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376284AbiBDPx6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:53:58 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214EUesc005791;
        Fri, 4 Feb 2022 15:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9jnN67UpRgqVBvH4oww2cd+QaeirqlysCuGQIQht+Bo=;
 b=AdeGDq0lSzrFxUdiBYO6wkOroqXE2J7A+fjc2uf6H+S+huOOeRK0CZHQ5LDj/5ycdUN3
 IMURNyiO+y1DAwkCygQT5lQiQevlwUTzmhABiW2QgRS+eEa1rIRAQDqZmv5LImPE+xk3
 PQgeOvE4FdVUEXRQkmmzQuIkR4mSY0jLa1kBuzq6BcQeGzRBITUVv9HGkPRrdDW2m0tp
 nzXgdRiplNrBAysjsqLtJ2fJsEp3OeYwhDefdfYc+UIEGm/AoxS7VBc1K9j0aiCdB5pr
 FvK2qhM9o6QHhQNNkErt8Tz/mpXz5tkbu0TRVKddshh/IXA7gRojCE/jvwAgX9mu87/H tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12gae4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:53:58 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214FYHw5006387;
        Fri, 4 Feb 2022 15:53:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12gadn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:53:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214FlZP5024802;
        Fri, 4 Feb 2022 15:53:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e0r10eb0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:53:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214FrqSJ45678892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:53:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 567DFAE051;
        Fri,  4 Feb 2022 15:53:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8CA3AE04D;
        Fri,  4 Feb 2022 15:53:51 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:53:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: [PATCH v7 03/17] KVM: s390: pv: handle secure storage exceptions for normal guests
Date:   Fri,  4 Feb 2022 16:53:35 +0100
Message-Id: <20220204155349.63238-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204155349.63238-1-imbrenda@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DVJm_0s6481obVrW7__FVqvWExfI_mUG
X-Proofpoint-ORIG-GUID: -CbHkTFN-LS45Lvd_lY9sixgA2_rioZ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=572 lowpriorityscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With upcoming patches, normal guests might touch secure pages.

This patch extends the existing exception handler to convert the pages
to non secure also when the exception is triggered by a normal guest.

This can happen for example when a secure guest reboots; the first
stage of a secure guest is non secure, and in general a secure guest
can reboot into non-secure mode.

If the secure memory of the previous boot has not been cleared up
completely yet (which will be allowed to happen in an upcoming patch),
a non-secure guest might touch secure memory, which will need to be
handled properly.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/fault.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 47b52e5384f8..bbd37e2c7962 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -770,6 +770,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	struct page *page;
+	struct gmap *gmap;
 	int rc;
 
 	/*
@@ -799,6 +800,16 @@ void do_secure_storage_access(struct pt_regs *regs)
 	}
 
 	switch (get_fault_type(regs)) {
+	case GMAP_FAULT:
+		gmap = (struct gmap *)S390_lowcore.gmap;
+		mmap_read_lock(mm);
+		addr = __gmap_translate(gmap, addr);
+		mmap_read_unlock(mm);
+		if (IS_ERR_VALUE(addr)) {
+			do_fault_error(regs, VM_ACCESS_FLAGS, VM_FAULT_BADMAP);
+			break;
+		}
+		fallthrough;
 	case USER_FAULT:
 		mm = current->mm;
 		mmap_read_lock(mm);
@@ -827,7 +838,6 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			BUG();
 		break;
-	case GMAP_FAULT:
 	default:
 		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
 		WARN_ON_ONCE(1);
-- 
2.34.1

