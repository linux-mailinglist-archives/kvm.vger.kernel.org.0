Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DFC53AA35
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349997AbiFAPhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355654AbiFAPg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:36:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316B4B84C;
        Wed,  1 Jun 2022 08:36:56 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251ESsBq021505;
        Wed, 1 Jun 2022 15:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=M/15Gx8gRiKDWPHwcDEa6USgn5vZKC8Mz6Cma28NoJ0=;
 b=isoQKzNeFdoYCSgiYg7NTFE3iZsZDfVgESKYDgQrB5x4PW0L55AIjMsacEuGBYSIvitN
 x86U3J0Y8Cp9qYJ5HhuYfN8ZciArzuEx56HnXBEIuaPzI3LX+ZKbfYO7P7To9tOjK89h
 fz9f6VJyQ3mxWTwaRCxKX5CXJwtL9sb2AVGXET9aQfgOAa2CfKJCBYhdvyynymjAJbbT
 nR4wlLCNJz0pZczUKpiapGXRsDQ/xczpoqbMFB+i0l7i7MOXIKelaJqsICuZKrKzgqgh
 bmgClkg/w1gt0hXw7kCq/wLRvmY5VC82BZZZn2+DIWndd47l03nP+KHJEVrsIKKIkPxb Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge9wr1pcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:55 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251EWdvm004203;
        Wed, 1 Jun 2022 15:36:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge9wr1pc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251FLR4o013191;
        Wed, 1 Jun 2022 15:36:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3gbcae5tmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251FanUb28180928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:36:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A326211C050;
        Wed,  1 Jun 2022 15:36:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C7CF11C04A;
        Wed,  1 Jun 2022 15:36:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Jun 2022 15:36:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 53F11E028C; Wed,  1 Jun 2022 17:36:49 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 07/15] KVM: s390: Add CPU dump functionality
Date:   Wed,  1 Jun 2022 17:36:38 +0200
Message-Id: <20220601153646.6791-8-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601153646.6791-1-borntraeger@linux.ibm.com>
References: <20220601153646.6791-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: USfrLwQbk3s8dXzZ01ZbpRI4rP-NSiC6
X-Proofpoint-GUID: Mvf9HXWC99EHuqns3Gmus18L06uTTRrn
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206010072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The previous patch introduced the per-VM dump functions now let's
focus on dumping the VCPU state via the newly introduced
KVM_S390_PV_CPU_COMMAND ioctl which mirrors the VM UV ioctl and can be
extended with new commands later.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220517163629.3443-8-frankja@linux.ibm.com
Message-Id: <20220517163629.3443-8-frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 69 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h |  1 +
 arch/s390/kvm/pv.c       | 16 ++++++++++
 include/uapi/linux/kvm.h |  4 +++
 4 files changed, 90 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1d00aead6bc5..37be2a33edb5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5096,6 +5096,48 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 	return -ENOIOCTLCMD;
 }
 
+static int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu,
+					struct kvm_pv_cmd *cmd)
+{
+	struct kvm_s390_pv_dmp dmp;
+	void *data;
+	int ret;
+
+	/* Dump initialization is a prerequisite */
+	if (!vcpu->kvm->arch.pv.dumping)
+		return -EINVAL;
+
+	if (copy_from_user(&dmp, (__u8 __user *)cmd->data, sizeof(dmp)))
+		return -EFAULT;
+
+	/* We only handle this subcmd right now */
+	if (dmp.subcmd != KVM_PV_DUMP_CPU)
+		return -EINVAL;
+
+	/* CPU dump length is the same as create cpu storage donation. */
+	if (dmp.buff_len != uv_info.guest_cpu_stor_len)
+		return -EINVAL;
+
+	data = kvzalloc(uv_info.guest_cpu_stor_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = kvm_s390_pv_dump_cpu(vcpu, data, &cmd->rc, &cmd->rrc);
+
+	VCPU_EVENT(vcpu, 3, "PROTVIRT DUMP CPU %d rc %x rrc %x",
+		   vcpu->vcpu_id, cmd->rc, cmd->rrc);
+
+	if (ret)
+		ret = -EINVAL;
+
+	/* On success copy over the dump data */
+	if (!ret && copy_to_user((__u8 __user *)dmp.buff_addr, data, uv_info.guest_cpu_stor_len))
+		ret = -EFAULT;
+
+	kvfree(data);
+	return ret;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -5260,6 +5302,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 					   irq_state.len);
 		break;
 	}
+	case KVM_S390_PV_CPU_COMMAND: {
+		struct kvm_pv_cmd cmd;
+
+		r = -EINVAL;
+		if (!is_prot_virt_host())
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&cmd, argp, sizeof(cmd)))
+			break;
+
+		r = -EINVAL;
+		if (cmd.flags)
+			break;
+
+		/* We only handle this cmd right now */
+		if (cmd.cmd != KVM_PV_DUMP)
+			break;
+
+		r = kvm_s390_handle_pv_vcpu_dump(vcpu, &cmd);
+
+		/* Always copy over UV rc / rrc data */
+		if (copy_to_user((__u8 __user *)argp, &cmd.rc,
+				 sizeof(cmd.rc) + sizeof(cmd.rrc)))
+			r = -EFAULT;
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 2c11eb5ba3ef..dd01d989816f 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -250,6 +250,7 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 		       unsigned long tweak, u16 *rc, u16 *rrc);
 int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
+int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc);
 int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
 				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc);
 int kvm_s390_pv_dump_complete(struct kvm *kvm, void __user *buff_user,
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index e9912113879c..b4a499b10b67 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -300,6 +300,22 @@ int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
 	return 0;
 }
 
+int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc)
+{
+	struct uv_cb_dump_cpu uvcb = {
+		.header.cmd = UVC_CMD_DUMP_CPU,
+		.header.len = sizeof(uvcb),
+		.cpu_handle = vcpu->arch.pv.handle,
+		.dump_area_origin = (u64)buff,
+	};
+	int cc;
+
+	cc = uv_call_sched(0, (u64)&uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	return cc;
+}
+
 /* Size of the cache for the storage state dump data. 1MB for now */
 #define DUMP_BUFF_LEN HPAGE_SIZE
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 673be2061c6c..af5d254f8061 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1664,6 +1664,7 @@ enum pv_cmd_dmp_id {
 	KVM_PV_DUMP_INIT,
 	KVM_PV_DUMP_CONFIG_STOR_STATE,
 	KVM_PV_DUMP_COMPLETE,
+	KVM_PV_DUMP_CPU,
 };
 
 struct kvm_s390_pv_dmp {
@@ -2168,4 +2169,7 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_PROTECTED_DUMP */
+#define KVM_S390_PV_CPU_COMMAND	_IOWR(KVMIO, 0xd0, struct kvm_pv_cmd)
+
 #endif /* __LINUX_KVM_H */
-- 
2.35.1

