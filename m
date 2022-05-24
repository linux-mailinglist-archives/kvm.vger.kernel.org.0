Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A10C533126
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbiEXTBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240904AbiEXTBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:01:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B3F66AE9;
        Tue, 24 May 2022 12:00:34 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIohkw024501;
        Tue, 24 May 2022 19:00:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XzuK60EkdY/iOUaUejLhy7+ds1HfY9E8zbPXnrBzoWA=;
 b=LfQ8Oei6iZ4VEBy9sqmkhiIYpnafxrXZTECmvddXF9rGT6agvpGCiTN41qQoLudSTd37
 QN4l/xtmX+m+eQMOnqewL3ltexozfhbARrFkN09ezr3s2xGHtsBCaD90EoHUn8thlBIr
 36pmRk0/Hp0DEpSDm+y7snSNY+3hue0feCOTMditv9xNaNVdJPBnJnlD10hvLeZ1p/Yp
 rXGxWdzLGhl7/elNofxEpN/NpCLKa8NezGzw/SLwuSmcHT0ZD2roqXDqSDNLjFFXJNXS
 uAyJxhak6J2WXZ0Z83filixXdTsAmYbHWqOBI92JN/1IzWklNlBuGNUJhYRnb2IbKVyW hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g950g052e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:00:03 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIsrb2007896;
        Tue, 24 May 2022 19:00:02 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g950g051q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:00:02 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIsOxk018808;
        Tue, 24 May 2022 19:00:01 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3g93uyghqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:00:01 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OJ001528115286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 19:00:00 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C6FEBE056;
        Tue, 24 May 2022 19:00:00 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1D6FBE054;
        Tue, 24 May 2022 18:59:57 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 18:59:57 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v8 20/22] KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
Date:   Tue, 24 May 2022 14:59:05 -0400
Message-Id: <20220524185907.140285-21-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524185907.140285-1-mjrosato@linux.ibm.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bgRdmDw8d9NppdYj5J82bZBInLWD4bnb
X-Proofpoint-GUID: 0BwXaCbv72HiyQ_B1BZbkfsIRLezxZCu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015 mlxlogscore=955
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
hardware-assisted virtualization features for s390x zPCI passthrough.
Add the first 2 operations, which can be used to enable/disable
the specified device for Adapter Event Notification interpretation.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 46 ++++++++++++++++++
 arch/s390/kvm/kvm-s390.c       | 16 +++++++
 arch/s390/kvm/pci.c            | 85 ++++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h            |  2 +
 include/uapi/linux/kvm.h       | 32 +++++++++++++
 5 files changed, 181 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4a900cdbc62e..321571ca6e56 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5645,6 +5645,52 @@ enabled with ``arch_prctl()``, but this may change in the future.
 The offsets of the state save areas in struct kvm_xsave follow the contents
 of CPUID leaf 0xD on the host.
 
+4.135 KVM_S390_ZPCI_OP
+--------------------
+
+:Capability: KVM_CAP_S390_ZPCI_OP
+:Architectures: s390
+:Type: vm ioctl
+:Parameters: struct kvm_s390_zpci_op (in)
+:Returns: 0 on success, <0 on error
+
+Used to manage hardware-assisted virtualization features for zPCI devices.
+
+Parameters are specified via the following structure::
+
+  struct kvm_s390_zpci_op {
+	/* in */
+	__u32 fh;		/* target device */
+	__u8  op;		/* operation to perform */
+	__u8  pad[3];
+	union {
+		/* for KVM_S390_ZPCIOP_REG_AEN */
+		struct {
+			__u64 ibv;	/* Guest addr of interrupt bit vector */
+			__u64 sb;	/* Guest addr of summary bit */
+			__u32 flags;
+			__u32 noi;	/* Number of interrupts */
+			__u8 isc;	/* Guest interrupt subclass */
+			__u8 sbo;	/* Offset of guest summary bit vector */
+			__u16 pad;
+		} reg_aen;
+		__u64 reserved[8];
+	} u;
+  };
+
+The type of operation is specified in the "op" field.
+KVM_S390_ZPCIOP_REG_AEN is used to register the VM for adapter event
+notification interpretation, which will allow firmware delivery of adapter
+events directly to the vm, with KVM providing a backup delivery mechanism;
+KVM_S390_ZPCIOP_DEREG_AEN is used to subsequently disable interpretation of
+adapter event notifications.
+
+The target zPCI function must also be specified via the "fh" field.  For the
+KVM_S390_ZPCIOP_REG_AEN operation, additional information to establish firmware
+delivery must be provided via the "reg_aen" struct.
+
+The "pad" and "reserved" fields may be used for future extensions and should be
+set to 0s by userspace.
 
 5. The kvm_run structure
 ========================
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b8dd1587c125..af96b613d7e7 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -618,6 +618,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_PROTECTED:
 		r = is_prot_virt_host();
 		break;
+	case KVM_CAP_S390_ZPCI_OP:
+		r = kvm_s390_pci_interp_allowed();
+		break;
 	default:
 		r = 0;
 	}
@@ -2633,6 +2636,19 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = -EFAULT;
 		break;
 	}
+	case KVM_S390_ZPCI_OP: {
+		struct kvm_s390_zpci_op args;
+
+		r = -EINVAL;
+		if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
+			break;
+		if (copy_from_user(&args, argp, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+		r = kvm_s390_pci_zpci_op(kvm, &args);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 29166683998f..a7d4d8fbfc3c 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -590,6 +590,91 @@ void kvm_s390_pci_clear_list(struct kvm *kvm)
 	spin_unlock(&kvm->arch.kzdev_list_lock);
 }
 
+static struct zpci_dev *get_zdev_from_kvm_by_fh(struct kvm *kvm, u32 fh)
+{
+	struct zpci_dev *zdev = NULL;
+	struct kvm_zdev *kzdev;
+
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	list_for_each_entry(kzdev, &kvm->arch.kzdev_list, entry) {
+		if (kzdev->zdev->fh == fh) {
+			zdev = kzdev->zdev;
+			break;
+		}
+	}
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+
+	return zdev;
+}
+
+static int kvm_s390_pci_zpci_reg_aen(struct zpci_dev *zdev,
+				     struct kvm_s390_zpci_op *args)
+{
+	struct zpci_fib fib = {};
+	bool hostflag;
+
+	fib.fmt0.aibv = args->u.reg_aen.ibv;
+	fib.fmt0.isc = args->u.reg_aen.isc;
+	fib.fmt0.noi = args->u.reg_aen.noi;
+	if (args->u.reg_aen.sb != 0) {
+		fib.fmt0.aisb = args->u.reg_aen.sb;
+		fib.fmt0.aisbo = args->u.reg_aen.sbo;
+		fib.fmt0.sum = 1;
+	} else {
+		fib.fmt0.aisb = 0;
+		fib.fmt0.aisbo = 0;
+		fib.fmt0.sum = 0;
+	}
+
+	hostflag = !(args->u.reg_aen.flags & KVM_S390_ZPCIOP_REGAEN_HOST);
+	return kvm_s390_pci_aif_enable(zdev, &fib, hostflag);
+}
+
+int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
+{
+	struct kvm_zdev *kzdev;
+	struct zpci_dev *zdev;
+	int r;
+
+	zdev = get_zdev_from_kvm_by_fh(kvm, args->fh);
+	if (!zdev)
+		return -ENODEV;
+
+	mutex_lock(&zdev->kzdev_lock);
+	mutex_lock(&kvm->lock);
+
+	kzdev = zdev->kzdev;
+	if (!kzdev) {
+		r = -ENODEV;
+		goto out;
+	}
+	if (kzdev->kvm != kvm) {
+		r = -EPERM;
+		goto out;
+	}
+
+	switch (args->op) {
+	case KVM_S390_ZPCIOP_REG_AEN:
+		/* Fail on unknown flags */
+		if (args->u.reg_aen.flags & ~KVM_S390_ZPCIOP_REGAEN_HOST) {
+			r = -EINVAL;
+			break;
+		}
+		r = kvm_s390_pci_zpci_reg_aen(zdev, args);
+		break;
+	case KVM_S390_ZPCIOP_DEREG_AEN:
+		r = kvm_s390_pci_aif_disable(zdev, false);
+		break;
+	default:
+		r = -EINVAL;
+	}
+
+out:
+	mutex_unlock(&kvm->lock);
+	mutex_unlock(&zdev->kzdev_lock);
+	return r;
+}
+
 int kvm_s390_pci_init(void)
 {
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index fb2b91b76e0c..0351382e990f 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -59,6 +59,8 @@ void kvm_s390_pci_aen_exit(void);
 void kvm_s390_pci_init_list(struct kvm *kvm);
 void kvm_s390_pci_clear_list(struct kvm *kvm);
 
+int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args);
+
 int kvm_s390_pci_init(void);
 void kvm_s390_pci_exit(void);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6a184d260c7f..39ca2a9acad2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1152,6 +1152,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DISABLE_QUIRKS2 213
 /* #define KVM_CAP_VM_TSC_CONTROL 214 */
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
+#define KVM_CAP_S390_ZPCI_OP 216
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2068,4 +2069,35 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_ZPCI_OP */
+#define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd0, struct kvm_s390_zpci_op)
+
+struct kvm_s390_zpci_op {
+	/* in */
+	__u32 fh;               /* target device */
+	__u8  op;               /* operation to perform */
+	__u8  pad[3];
+	union {
+		/* for KVM_S390_ZPCIOP_REG_AEN */
+		struct {
+			__u64 ibv;      /* Guest addr of interrupt bit vector */
+			__u64 sb;       /* Guest addr of summary bit */
+			__u32 flags;
+			__u32 noi;      /* Number of interrupts */
+			__u8 isc;       /* Guest interrupt subclass */
+			__u8 sbo;       /* Offset of guest summary bit vector */
+			__u16 pad;
+		} reg_aen;
+		__u64 reserved[8];
+	} u;
+};
+
+/* types for kvm_s390_zpci_op->op */
+#define KVM_S390_ZPCIOP_REG_AEN                0
+#define KVM_S390_ZPCIOP_DEREG_AEN      1
+
+/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
+#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
+
+
 #endif /* __LINUX_KVM_H */
-- 
2.27.0

