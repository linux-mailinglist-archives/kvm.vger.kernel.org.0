Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9AE41157D
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbhITN0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:26:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239355AbhITN0i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:26:38 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD3KB025896;
        Mon, 20 Sep 2021 09:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3QcLxw9Pl3fllBrjZDMb1xG5pgYHY19y6fIGD7yExEo=;
 b=gS4eHSv6eXB8f4EjpWDtZhHx7qvQVWhJYkTUDW8uq+zyOhyIPXbH0jKIihfZOM62DzYl
 vLcWvy8wHz9putEBUTLdq4zEXtMwbgphAuITvXAAfz8VlCy0MtIYAWPrnAWCucEZCKYX
 A5M3z9IezuXLoamcu/VsCp0kyLpYzeqOi9KsJ+M0wNVQvtPS2Vt7UOY5EChXqwKW5Y1F
 YSqV6sGMXpsf6dPCsz7IIPtUDD+nBCilPMRCE5wIutWEFoay53BuySZtYV+st554VcAe
 /LOuwv5xdkKgTZD6a+0KPRnFmQC99+SwvjvVZwR1NSfehq1PZQchCi3xjMG2F7Iey2+T HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wq59u03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:11 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDE9g8029338;
        Mon, 20 Sep 2021 09:25:11 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wq59txw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:11 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD8b4030978;
        Mon, 20 Sep 2021 13:25:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3b57r98vta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:25:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDP4Jx29557070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:25:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C13CA4057;
        Mon, 20 Sep 2021 13:25:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A39BFA406E;
        Mon, 20 Sep 2021 13:25:03 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.9.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 13:25:03 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v5 02/14] KVM: s390: pv: avoid double free of sida page
Date:   Mon, 20 Sep 2021 15:24:50 +0200
Message-Id: <20210920132502.36111-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920132502.36111-1-imbrenda@linux.ibm.com>
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 11J18oDJYFjDdqM2OmKqw9sjuLGyqFKW
X-Proofpoint-GUID: gqj2ierpLA70BjhtZ6Wi0Jnl0oEhR4-n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 bulkscore=0 clxscore=1015 mlxlogscore=538 mlxscore=0
 impostorscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If kvm_s390_pv_destroy_cpu is called more than once, we risk calling
free_page on a random page, since the sidad field is aliased with the
gbea, which is not guaranteed to be zero.

This can happen, for example, if userspace calls the KVM_PV_DISABLE
IOCTL, and it fails, and then userspace calls the same IOCTL again.
This scenario is only possible if KVM has some serious bug or if the
hardware is broken.

The solution is to simply return successfully immediately if the vCPU
was already non secure.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 19e1227768863a1469797c13ef8fea1af7beac2c ("KVM: S390: protvirt: Introduce instruction data area bounce buffer")
---
 arch/s390/kvm/pv.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index c8841f476e91..0a854115100b 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -16,18 +16,17 @@
 
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
-	int cc = 0;
+	int cc;
 
-	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
-		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
-				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
+	if (!kvm_s390_pv_cpu_get_handle(vcpu))
+		return 0;
+
+	cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu), UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
+
+	KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
+		     vcpu->vcpu_id, *rc, *rrc);
+	WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x", *rc, *rrc);
 
-		KVM_UV_EVENT(vcpu->kvm, 3,
-			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
-			     vcpu->vcpu_id, *rc, *rrc);
-		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
-			  *rc, *rrc);
-	}
 	/* Intended memory leak for something that should never happen. */
 	if (!cc)
 		free_pages(vcpu->arch.pv.stor_base,
-- 
2.31.1

