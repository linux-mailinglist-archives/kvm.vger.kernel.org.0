Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F91E30EE
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439193AbfJXLmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1622 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439202AbfJXLmz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:55 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBb8Qf146682
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:54 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vub6pg892-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:53 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:52 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:49 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBgmNx11468984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22CB252050;
        Thu, 24 Oct 2019 11:42:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9EE335204E;
        Thu, 24 Oct 2019 11:42:46 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 37/37] KVM: s390: protvirt: Add UV debug trace
Date:   Thu, 24 Oct 2019 07:40:59 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-4275-0000-0000-00000376D3EC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-4276-0000-0000-00003889FDF0
Message-Id: <20191024114059.102802-38-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=946 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's have some debug traces which stay around for longer than the
guest.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 10 +++++++++-
 arch/s390/kvm/kvm-s390.h |  9 +++++++++
 arch/s390/kvm/pv.c       | 16 ++++++++++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5cc9108c94e4..56627968f2ed 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -221,6 +221,7 @@ static struct kvm_s390_vm_cpu_subfunc kvm_s390_available_subfunc;
 static struct gmap_notifier gmap_notifier;
 static struct gmap_notifier vsie_gmap_notifier;
 debug_info_t *kvm_s390_dbf;
+debug_info_t *kvm_s390_dbf_uv;
 
 /* Section: not file related */
 int kvm_arch_hardware_enable(void)
@@ -462,7 +463,13 @@ int kvm_arch_init(void *opaque)
 	if (!kvm_s390_dbf)
 		return -ENOMEM;
 
-	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view))
+	kvm_s390_dbf_uv = debug_register("kvm-uv", 32, 1, 7 * sizeof(long));
+	if (!kvm_s390_dbf_uv)
+		return -ENOMEM;
+
+
+	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view) ||
+	    debug_register_view(kvm_s390_dbf_uv, &debug_sprintf_view))
 		goto out;
 
 	kvm_s390_cpu_feat_init();
@@ -489,6 +496,7 @@ void kvm_arch_exit(void)
 {
 	kvm_s390_gib_destroy();
 	debug_unregister(kvm_s390_dbf);
+	debug_unregister(kvm_s390_dbf_uv);
 }
 
 /* Section: device related */
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 8cd2e978363d..d13ddf2113c0 100644
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
index cf79a6503e1c..78e4510a7776 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -100,6 +100,8 @@ int kvm_s390_pv_destroy_vm(struct kvm *kvm)
 			   UVC_CMD_DESTROY_SEC_CONF, &ret);
 	VM_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
 		 ret >> 16, ret & 0x0000ffff);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
+		 ret >> 16, ret & 0x0000ffff);
 	return rc;
 }
 
@@ -115,6 +117,8 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
 
 		VCPU_EVENT(vcpu, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
 			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+		KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
+			     vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
 	}
 
 	free_pages(vcpu->arch.pv.stor_base,
@@ -163,6 +167,10 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
 	VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
 		   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
 		   uvcb.header.rrc);
+	KVM_UV_EVENT(vcpu->kvm, 3,
+		     "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
+		     vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
+		     uvcb.header.rrc);
 
 	/* Output */
 	vcpu->arch.pv.handle = uvcb.cpu_handle;
@@ -200,6 +208,10 @@ int kvm_s390_pv_create_vm(struct kvm *kvm)
 		 uvcb.guest_handle, uvcb.guest_stor_len, uvcb.header.rc,
 		 uvcb.header.rrc);
 
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
+		 uvcb.guest_handle, uvcb.guest_stor_len, uvcb.header.rc,
+		 uvcb.header.rrc);
+
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
 
@@ -230,6 +242,8 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
 	rc = uv_call(0, (u64)&uvcb);
 	VM_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
 		 uvcb.header.rc, uvcb.header.rrc);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
+		     uvcb.header.rc, uvcb.header.rrc);
 	if (rc)
 		return -EINVAL;
 	return 0;
@@ -278,6 +292,8 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 	}
 	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x rrc %x",
 		 uvcb.header.rc, uvcb.header.rrc);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x rrc %x",
+		     uvcb.header.rc, uvcb.header.rrc);
 	return rc;
 }
 
-- 
2.20.1

