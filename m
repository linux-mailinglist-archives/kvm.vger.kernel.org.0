Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E56B1556EE
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 12:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbgBGLka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 06:40:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727144AbgBGLkI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 06:40:08 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017Bc9TO117276;
        Fri, 7 Feb 2020 06:40:07 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0knevr34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:07 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 017Be6OE124410;
        Fri, 7 Feb 2020 06:40:06 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0knevr29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:06 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 017BcmZD031731;
        Fri, 7 Feb 2020 11:40:05 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 2xykca20w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:40:05 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017Be32i8126922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 11:40:03 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A195AC05F;
        Fri,  7 Feb 2020 11:40:03 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 436E2AC059;
        Fri,  7 Feb 2020 11:40:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 11:40:03 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 31/35] KVM: s390: protvirt: Add UV debug trace
Date:   Fri,  7 Feb 2020 06:39:54 -0500
Message-Id: <20200207113958.7320-32-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207113958.7320-1-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 suspectscore=2 mlxlogscore=999 adultscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's have some debug traces which stay around for longer than the
guest.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c |  9 ++++++++-
 arch/s390/kvm/kvm-s390.h |  9 +++++++++
 arch/s390/kvm/pv.c       | 20 +++++++++++++++++++-
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3a06622c52fb..ced2bac251a6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -222,6 +222,7 @@ static struct gmap_notifier gmap_notifier;
 static struct gmap_notifier vsie_gmap_notifier;
 static struct gmap_notifier adapter_gmap_notifier;
 debug_info_t *kvm_s390_dbf;
+debug_info_t *kvm_s390_dbf_uv;
 
 /* Section: not file related */
 int kvm_arch_hardware_enable(void)
@@ -466,7 +467,12 @@ int kvm_arch_init(void *opaque)
 	if (!kvm_s390_dbf)
 		return -ENOMEM;
 
-	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view))
+	kvm_s390_dbf_uv = debug_register("kvm-uv", 32, 1, 7 * sizeof(long));
+	if (!kvm_s390_dbf_uv)
+		goto out;
+
+	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view) ||
+	    debug_register_view(kvm_s390_dbf_uv, &debug_sprintf_view))
 		goto out;
 
 	kvm_s390_cpu_feat_init();
@@ -493,6 +499,7 @@ void kvm_arch_exit(void)
 {
 	kvm_s390_gib_destroy();
 	debug_unregister(kvm_s390_dbf);
+	debug_unregister(kvm_s390_dbf_uv);
 }
 
 /* Section: device related */
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 7530042a44e9..0121a5b36e54 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -25,6 +25,15 @@
 #define IS_ITDB_VALID(vcpu)	((*(char *)vcpu->arch.sie_block->itdba == TDB_FORMAT1))
 
 extern debug_info_t *kvm_s390_dbf;
+extern debug_info_t *kvm_s390_dbf_uv;
+
+#define KVM_UV_EVENT(d_kvm, d_loglevel, d_string, d_args...)\
+do { \
+	debug_sprintf_event(kvm_s390_dbf_uv, d_loglevel, \
+			    "%s: " d_string "\n", d_kvm->arch.dbf->name, \
+			    d_args); \
+} while (0)
+
 #define KVM_EVENT(d_loglevel, d_string, d_args...)\
 do { \
 	debug_sprintf_event(kvm_s390_dbf, d_loglevel, d_string "\n", \
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index a58f5106ba5f..da281d8dcc92 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -74,6 +74,8 @@ int kvm_s390_pv_destroy_vm(struct kvm *kvm)
 	atomic_set(&kvm->mm->context.is_protected, 0);
 	VM_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
 		 ret >> 16, ret & 0x0000ffff);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
+		 ret >> 16, ret & 0x0000ffff);
 	return rc;
 }
 
@@ -89,6 +91,8 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
 
 		VCPU_EVENT(vcpu, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
 			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+		KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
+			     vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
 	}
 
 	free_pages(vcpu->arch.pv.stor_base,
@@ -135,6 +139,10 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
 	VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
 		   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
 		   uvcb.header.rrc);
+	KVM_UV_EVENT(vcpu->kvm, 3,
+		     "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
+		     vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
+		     uvcb.header.rrc);
 
 	if (rc) {
 		kvm_s390_pv_destroy_cpu(vcpu);
@@ -174,6 +182,10 @@ int kvm_s390_pv_create_vm(struct kvm *kvm)
 		 uvcb.guest_handle, uvcb.guest_stor_len, uvcb.header.rc,
 		 uvcb.header.rrc);
 
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
+		 uvcb.guest_handle, uvcb.guest_stor_len, uvcb.header.rc,
+		 uvcb.header.rrc);
+
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
 
@@ -204,6 +216,8 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
 	rc = uv_call(0, (u64)&uvcb);
 	VM_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
 		 uvcb.header.rc, uvcb.header.rrc);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
+		     uvcb.header.rc, uvcb.header.rrc);
 	if (rc)
 		return -EINVAL;
 	return 0;
@@ -223,9 +237,12 @@ static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak[2])
 
 	rc = uv_make_secure(kvm->arch.gmap, addr, &uvcb);
 
-	if (rc)
+	if (rc) {
 		VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %x",
 			 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
+		KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed with rc %x rrc %x",
+			     uvcb.header.rc, uvcb.header.rrc);
+	}
 	return rc;
 }
 
@@ -251,6 +268,7 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 		tw[1] += PAGE_SIZE;
 	}
 	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x", rc);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x", rc);
 	return rc;
 }
 
-- 
2.24.0

