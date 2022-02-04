Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21BC4A9C75
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376602AbiBDPya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:54:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376368AbiBDPyH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:54:07 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214FgL5j003793;
        Fri, 4 Feb 2022 15:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2oWzQ/SNcNYt0kngd9Dogpe/jWJDppi3iZBxylArBcE=;
 b=OvbF+6I+cgZ6qEwRZUnBXZbxUttOUO/y5bthicFO+659gTYl845vF+Eve6Xf1X6YL7e4
 jw4Pns0n3jLYa4Qa7pGeT8AQBOOTL00J7AoDe+WqstjC7lJRLCsvfvJ3xsHJ0dLpt5Fq
 Kur2XH5Kbz+BEZcjb5Ru1JzqoodelZdwTy+FWtWQ0qXngkMjev5F7sDtYsxrZhMLXBnF
 +Oacx6GhzKnjDJ0KAb2h7CbUgIEAkZhm4SJE17BPwJdMM4mcNGNP6w4EQKSBOqCpeaxW
 Bcongn2b0JKqYH/wb/Khp589fkg6aMwIGnn1Sdy7UIdfbFwxdV8WFvPleGvyVB59muNN zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0w6tkerj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:07 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214DDhTh019583;
        Fri, 4 Feb 2022 15:54:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0w6tker0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214FlWMW024761;
        Fri, 4 Feb 2022 15:54:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3e0r10eb1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214Fs1gq32113126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:54:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5216EAE051;
        Fri,  4 Feb 2022 15:54:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BADD4AE063;
        Fri,  4 Feb 2022 15:54:00 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:54:00 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: [PATCH v7 17/17] KVM: s390: pv: avoid export before import if possible
Date:   Fri,  4 Feb 2022 16:53:49 +0100
Message-Id: <20220204155349.63238-18-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204155349.63238-1-imbrenda@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mOPZkG-Re3_PytrS3NAIRvUEAng0lN4i
X-Proofpoint-ORIG-GUID: ZKwOj84RHjXKRh5NJMEVHM3aXJ7M9Aur
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202040088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the appropriate UV feature bit is set, there is no need to perform
an export before import.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index e358b8bd864b..43393568f844 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -236,7 +236,8 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 
 static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
 {
-	return uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
+	return !test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications) &&
+		uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
 		atomic_read(&mm->context.protected_count) > 1;
 }
 
-- 
2.34.1

