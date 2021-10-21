Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE2E436612
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhJUP0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232042AbhJUP01 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:27 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEBIgQ022324;
        Thu, 21 Oct 2021 11:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VbQ/mJuCdGyC9racNtzwgMXvwCvv5nztjkVzM3JKDFc=;
 b=GilyY4YpUEDDbvknH3PakyEQHyzC39oNqZ+ZAAOXlunqg/qYzYdhob4F3h3jct0OYep0
 Ij1xJsl2wiQjW/xW7xVsIBI61Z02luGsXc6eUDv6Aelb04RdeLCUUtM0sbh4YrS9Auic
 9cGmR0oP/et5CdRncof4HQi1jG2RwfJ1+cJvxDh9ZNRyV5/WcvNDCICEuYeqX9mh5SCL
 dQdf5TZ4Vv0NrB8VdGqz8EEm5/k2mghiZsGtG8mwKYTMW8rtKqCiZ5IK3ge3Dy55OEfa
 Nwuv2ugMf5wJirnBPRrN52DaqqtQuJdJS9n04zhSAW3ic/LvX8Zz2Ppd+MtdmvzRIryo zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bty9eqs4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:10 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LFEsd0018289;
        Thu, 21 Oct 2021 11:24:09 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bty9eqs42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:09 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF42IY009616;
        Thu, 21 Oct 2021 15:24:08 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 3bqpccfqqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:24:08 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFO7d119989052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:24:07 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A229BE05B;
        Thu, 21 Oct 2021 15:24:07 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC32FBE051;
        Thu, 21 Oct 2021 15:24:04 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:24:04 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 08/15] s390/vfio-ap: keep track of active guests
Date:   Thu, 21 Oct 2021 11:23:25 -0400
Message-Id: <20211021152332.70455-9-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fOP7575zIzd1O7jp5y4EwFbM5yQ0QO9h
X-Proofpoint-GUID: Wr_NL-PjEdJsapzS7D36c3J-pK9gWaE5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_ap device driver registers for notification when the pointer to
the KVM object for a guest is set. Let's store the KVM pointer as well as
the pointer to the mediated device when the KVM pointer is set.

The reason for storing the KVM and mediated device pointers is to
facilitate hot plug/unplug of AP queues for a KVM guest when a queue device
is probed or removed. When a guest's APCB is hot plugged into the guest,
the kvm->lock must be taken prior to taking the matrix_dev->lock, or there
is potential for a lockdep splat (see below). Unfortunately, when a queue
is probed or removed, we have no idea whether it is assigned to a guest or
which KVM object is associated with the guest. If we take the
matrix_dev->lock to determine whether the APQN is assigned to a running
guest then subsequently take the kvm->lock, in certain situations that will
result in a lockdep splat:

* see commit 0cc00c8d4050 ("Fix circular lockdep when setting/clearing
  crypto masks")

* see commit 86956e70761b ("replace open coded locks for
  VFIO_GROUP_NOTIFY_SET_KVM notification")

The reason a lockdep splat can occur has to do with the fact that the
kvm->lock has to be taken before the vcpu->lock; so, for example, when a
secure execution guest is started, you may end up with the following
scenario:

        Interception of PQAP(AQIC) instruction executed on the guest:
        ------------------------------------------------------------
        handle_pqap:                    matrix_dev->lock
        kvm_vcpu_ioctl:                 vcpu_mutex

        Start of secure execution guest:
        -------------------------------
        kvm_s390_cpus_to_pv:            vcpu->mutex
        kvm_arch_vm_ioctl:              kvm->lock

        Queue is unbound from vfio_ap device driver:
        -------------------------------------------
                                        kvm->lock
        vfio_ap_mdev_remove_queue:      matrix_dev->lock

This patch introduces a new ap_guest structure into which the pointers to
the kvm and matrix_mdev can be stored. It also introduces two new fields
in the struct ap_matrix_dev:

struct ap_matrix_dev {
        ...
        struct rw_semaphore guests_lock;
        struct list_head guests;
       ...
}

The 'guests_lock' field is a r/w semaphore to control access to the
'guests' field. The 'guests' field is a list of ap_guest
structures containing the KVM and matrix_mdev pointers for each active
guest. An ap_guest structure will be stored into the list whenever the
vfio_ap device driver is notified that the KVM pointer has been set and
removed when notified that the KVM pointer has been cleared.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  2 ++
 drivers/s390/crypto/vfio_ap_ops.c     | 44 +++++++++++++++++++++++++--
 drivers/s390/crypto/vfio_ap_private.h | 10 ++++++
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 5255e338591d..1d1746fe50ea 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -98,6 +98,8 @@ static int vfio_ap_matrix_dev_create(void)
 
 	mutex_init(&matrix_dev->lock);
 	INIT_LIST_HEAD(&matrix_dev->mdev_list);
+	init_rwsem(&matrix_dev->guests_lock);
+	INIT_LIST_HEAD(&matrix_dev->guests);
 
 	dev_set_name(&matrix_dev->device, "%s", VFIO_AP_DEV_NAME);
 	matrix_dev->device.parent = root_device;
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 6b40db6dab3c..a2875cf79091 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1086,6 +1086,20 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
 	NULL
 };
 
+static int vfio_ap_mdev_create_guest(struct kvm *kvm,
+				     struct ap_matrix_mdev *matrix_mdev)
+{
+	struct ap_guest *guest;
+
+	guest = kzalloc(sizeof(*guest), GFP_KERNEL);
+	if (!guest)
+		return -ENOMEM;
+
+	list_add(&guest->node, &matrix_dev->guests);
+
+	return 0;
+}
+
 /**
  * vfio_ap_mdev_set_kvm - sets all data for @matrix_mdev that are needed
  * to manage AP resources for the guest whose state is represented by @kvm
@@ -1106,16 +1120,23 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
 static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 				struct kvm *kvm)
 {
+	int ret;
 	struct ap_matrix_mdev *m;
 
 	if (kvm->arch.crypto.crycbd) {
+		down_write(&matrix_dev->guests_lock);
+		ret = vfio_ap_mdev_create_guest(kvm, matrix_mdev);
+		if (WARN_ON(ret))
+			return ret;
+
 		mutex_lock(&kvm->lock);
 		mutex_lock(&matrix_dev->lock);
 
 		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 			if (m != matrix_mdev && m->kvm == kvm) {
-				mutex_unlock(&kvm->lock);
 				mutex_unlock(&matrix_dev->lock);
+				mutex_unlock(&kvm->lock);
+				up_write(&matrix_dev->guests_lock);
 				return -EPERM;
 			}
 		}
@@ -1127,8 +1148,9 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 					  matrix_mdev->shadow_apcb.aqm,
 					  matrix_mdev->shadow_apcb.adm);
 
-		mutex_unlock(&kvm->lock);
 		mutex_unlock(&matrix_dev->lock);
+		mutex_unlock(&kvm->lock);
+		up_write(&matrix_dev->guests_lock);
 	}
 
 	return 0;
@@ -1164,6 +1186,18 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void vfio_ap_mdev_remove_guest(struct kvm *kvm)
+{
+	struct ap_guest *guest, *tmp;
+
+	list_for_each_entry_safe(guest, tmp, &matrix_dev->guests, node) {
+		if (guest->kvm == kvm) {
+			list_del(&guest->node);
+			break;
+		}
+	}
+}
+
 /**
  * vfio_ap_mdev_unset_kvm - performs clean-up of resources no longer needed
  * by @matrix_mdev.
@@ -1182,6 +1216,9 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev,
 				   struct kvm *kvm)
 {
 	if (kvm && kvm->arch.crypto.crycbd) {
+		down_write(&matrix_dev->guests_lock);
+		vfio_ap_mdev_remove_guest(kvm);
+
 		mutex_lock(&kvm->lock);
 		mutex_lock(&matrix_dev->lock);
 
@@ -1191,8 +1228,9 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev,
 		kvm->arch.crypto.data = NULL;
 		matrix_mdev->kvm = NULL;
 
-		mutex_unlock(&kvm->lock);
 		mutex_unlock(&matrix_dev->lock);
+		mutex_unlock(&kvm->lock);
+		up_write(&matrix_dev->guests_lock);
 	}
 }
 
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 6dc0ebbf7a06..6d28b287d7bf 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -26,6 +26,11 @@
 #define VFIO_AP_MODULE_NAME "vfio_ap"
 #define VFIO_AP_DRV_NAME "vfio_ap"
 
+struct ap_guest {
+	struct kvm *kvm;
+	struct list_head node;
+};
+
 /**
  * struct ap_matrix_dev - Contains the data for the matrix device.
  *
@@ -39,6 +44,9 @@
  *		single ap_matrix_mdev device. It's quite coarse but we don't
  *		expect much contention.
  * @vfio_ap_drv: the vfio_ap device driver
+ * @guests_lock: r/w semaphore for protecting access to @guests
+ * @guests:	list of guests (struct ap_guest) using AP devices bound to the
+ *		vfio_ap device driver.
  */
 struct ap_matrix_dev {
 	struct device device;
@@ -47,6 +55,8 @@ struct ap_matrix_dev {
 	struct list_head mdev_list;
 	struct mutex lock;
 	struct ap_driver  *vfio_ap_drv;
+	struct rw_semaphore guests_lock;
+	struct list_head guests;
 };
 
 extern struct ap_matrix_dev *matrix_dev;
-- 
2.31.1

