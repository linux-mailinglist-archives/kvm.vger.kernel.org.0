Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7233E0479
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbhHDPl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:41:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46838 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239252AbhHDPlU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 11:41:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174FXuEE150622;
        Wed, 4 Aug 2021 11:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=i9QeVr7L3vj7MXmdhLO4n8mnVY8D8W7TsDDgGOfEoX8=;
 b=BaxzbY34fYVbiht0/4staJGg462C/Hx0Tm3OmXRlY4yJGOrvQYQLGkCl/YSBEsY7VQ6g
 V61HjYkNTS56R2SFs0hcc1LJczYlAR8lIzT5qD5f3RIEPcVWymcqPE5m/cp8WXbFbty7
 At9qKWTUiyQQyUG5WR4NlpJsLNKp2w8YvlhMqlPR9PEJjSfjx8aaucuyefkoOKCPZbdj
 aYHgy0y6kniB5S/4SqGHEgDiBFlXfWuQuVBoy1xnkrhHsKhHGZToUfMWrtg+TfNiks+Z
 6ZLctooqfzAgp2yd1/DLswiKZX8o9CNSyAGpmXjYnE1iPIkMQwj7YMXeYe2n7OgTF2Yp Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7b78bx5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:06 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 174FYKjl155462;
        Wed, 4 Aug 2021 11:41:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7b78bx4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 174FYLjX031232;
        Wed, 4 Aug 2021 15:41:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3a4x591gu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 15:41:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 174FexLV52298038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Aug 2021 15:40:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 859664C06E;
        Wed,  4 Aug 2021 15:40:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19C714C052;
        Wed,  4 Aug 2021 15:40:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.150])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Aug 2021 15:40:59 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v3 12/14] KVM: s390: pv: module parameter to fence lazy destroy
Date:   Wed,  4 Aug 2021 17:40:44 +0200
Message-Id: <20210804154046.88552-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210804154046.88552-1-imbrenda@linux.ibm.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lOi98GvE88KWcb_Gbwl9fmOxMvOXO-Q3
X-Proofpoint-ORIG-GUID: FOHEZh9L4LzySD1mbfrwINw7EDVT4nLA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-04_03:2021-08-04,2021-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the module parameter "lazy_destroy", to allow the lazy destroy
mechanism to be switched off. This might be useful for debugging
purposes.

The parameter is enabled by default.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index e10392a8b1ae..c570d4ce29c3 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -26,6 +26,10 @@ struct deferred_priv {
 	unsigned long stor_base;
 };
 
+static int lazy_destroy = 1;
+module_param(lazy_destroy, int, 0444);
+MODULE_PARM_DESC(lazy_destroy, "Deferred destroy for protected guests");
+
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
 	int cc = 0;
@@ -312,6 +316,9 @@ int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct deferred_priv *priv;
 
+	if (!lazy_destroy)
+		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
+
 	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);
 	if (!priv)
 		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
@@ -360,6 +367,12 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
 
+	if (!lazy_destroy) {
+		mmap_write_lock(kvm->mm);
+		kvm->mm->context.pv_sync_destroy = 1;
+		mmap_write_unlock(kvm->mm);
+	}
+
 	atomic_inc(&kvm->mm->context.is_protected);
 	if (cc) {
 		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
-- 
2.31.1

