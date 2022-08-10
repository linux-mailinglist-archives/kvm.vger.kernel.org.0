Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2924E58EC72
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiHJM4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiHJM4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:56:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E8B5C94F;
        Wed, 10 Aug 2022 05:56:36 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ACoU8U022104;
        Wed, 10 Aug 2022 12:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H+c3OOZvQuKXwnaer4RzsqK0V/wcSRQ8/ZF6HymAva4=;
 b=JaWT9lv5kGc/+Luac6BHushEu5u3GOK+SJERAk/ehfR0y6ZXpR3fBtmP3cGgxhg0kMMM
 KEXw6KCBduxo2jnkhYMszWeD/wVKRHzZiofAK4G31GE5STz5H0v3Icyz+TyAvkzw08/1
 ock2lzhzGxKFfiOv4yX5uUW+UUjnTRHOvX1gYxf/iNZkKJfIDvIcsus0FcBwQYNwy7Jb
 3lRBom2EQiHTniNkkquFcZ69qtEYj/sYxNVAwF1Uo4OQE7Z3gl+QFECSGMMM0dlGLwts
 AokR2Z+S3r6CWdflP99ssr/c0cIj9bNtARbf5VcDbvHyMylcl8EdQW2dvEbZqjMaczE6 dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv31vswgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:36 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ACuZuD016636;
        Wed, 10 Aug 2022 12:56:35 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv31vswfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:35 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27ACuSp1012812;
        Wed, 10 Aug 2022 12:56:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3huww0ru72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27ACuTIZ23527910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 12:56:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A818F4C046;
        Wed, 10 Aug 2022 12:56:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0345F4C040;
        Wed, 10 Aug 2022 12:56:29 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.0.105])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 12:56:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v13 4/6] KVM: s390: pv: avoid export before import if possible
Date:   Wed, 10 Aug 2022 14:56:23 +0200
Message-Id: <20220810125625.45295-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810125625.45295-1-imbrenda@linux.ibm.com>
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PIgJ43YdXg8ZDTZOTVlhMQYQWwdN3ST_
X-Proofpoint-ORIG-GUID: keNZ0Mi_ORXwctl6o1OJ3MTSMwin1gxl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_07,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the appropriate UV feature bit is set, there is no need to perform
an export before import.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index f9810d2a267c..b455646c8d74 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -255,6 +255,8 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
  */
 static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
 {
+	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
+		return false;
 	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
 		return false;
 	return atomic_read(&mm->context.protected_count) > 1;
-- 
2.37.1

