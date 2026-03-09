Return-Path: <kvm+bounces-73283-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EPB6L8+srmntHQIAu9opvQ
	(envelope-from <kvm+bounces-73283-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:19:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EF9237C87
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 26725304AC35
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 11:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4E339D6C1;
	Mon,  9 Mar 2026 11:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uc2eixKr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0A73A1A4D;
	Mon,  9 Mar 2026 11:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773055064; cv=none; b=LEewX/pW0qI6N3TpcF/s4JESMvRp0M4RZoRVNaEmaE8CC9Mv6L78v8Rwo8/4HqO6+kIYnSy6vOjjwRJePSlXsV972l7RTtvRDZT1MiiH+knJHY50tmcia1VLoL/1vq/k4WaQEM/KhTc7qs6jdDjZJlWqlpG2kQmZR43EX6mPcc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773055064; c=relaxed/simple;
	bh=OtGshxzVApu9OGSwfjeOY5QHAt1HWmJXqthR23/nz0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLSMYTFYv6T0n64xMvWfCiJfLPipkxAegm5kd7AOehCeorKPLclr/TC1x+FlvkdnOg0Ea81V5KZx5BUIm+t/szEvqwhKFA3m3ieownTj6wluMxei4aQv1uMmcfCwKhZxQB0E+GYCUUgxPizeJhqqi47Pta/18jkX7hqAqjJAnZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uc2eixKr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE39C2BCAF;
	Mon,  9 Mar 2026 11:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773055064;
	bh=OtGshxzVApu9OGSwfjeOY5QHAt1HWmJXqthR23/nz0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uc2eixKrtDMbfFAXjIrfoSv/n/itUKbdR0cZhd/Qn8caO1xEjexj6Nkiib+g9XtZc
	 hdMMmoMJh9ZZjINoWj97F0f9w3aROOZfqjR4h3EqZU2KbpJwy6i+hhSnRr64TQcmod
	 OrJCeITA0NDg8Wddphk2cg2PkE9vzAwUOWg25zl82WQytZ6vQISKLJi1u/8An7kobL
	 GE7iwQeReCYfHMvKx0onHaeeTLBVKnV5uJbMEihU64Ns9CEDpdrOAFRlTWl6cLdGQ3
	 p1HxRxOHMY1W4B3Y5c2bWhb4HJNtQirWHwv+8oN7U0HG6kDTamzS6Se+FjD4OxNrbS
	 GiwqRmmV4R3YQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 3/3] iommufd/vdevice: add TSM guest request ioctl
Date: Mon,  9 Mar 2026 16:47:04 +0530
Message-ID: <20260309111704.2330479-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309111704.2330479-1-aneesh.kumar@kernel.org>
References: <20260309111704.2330479-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 61EF9237C87
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73283-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aneesh.kumar@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.978];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,rivosinc.com:email]
X-Rspamd-Action: no action

Add IOMMU_VDEVICE_TSM_GUEST_REQUEST for issuing TSM guest request/response
transactions against an iommufd vdevice.

The ioctl takes a vdevice_id plus request/response user buffers and length
fields, and forwards the request through tsm_guest_req() to the PCI TSM
backend. This provides the host-side passthrough path used by CoCo guests
for TSM device attestation and acceptance flows after the device has been
bound to TSM.

Also add the supporting tsm_guest_req() helper and associated TSM core
interface definitions.

Based on changes from: Alexey Kardashevskiy <aik@amd.com>

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/iommu/iommufd/iommufd_private.h |  7 ++++
 drivers/iommu/iommufd/main.c            |  3 ++
 drivers/iommu/iommufd/tsm.c             | 48 +++++++++++++++++++++++++
 drivers/virt/coco/tsm-core.c            | 14 ++++++++
 include/linux/tsm.h                     | 26 ++++++++++++++
 include/uapi/linux/iommufd.h            | 23 ++++++++++++
 6 files changed, 121 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index aa1ceed924c2..7042993913dd 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -699,11 +699,18 @@ int iommufd_hw_queue_alloc_ioctl(struct iommufd_ucmd *ucmd);
 void iommufd_hw_queue_destroy(struct iommufd_object *obj);
 #ifdef CONFIG_TSM
 int iommufd_vdevice_tsm_op_ioctl(struct iommufd_ucmd *ucmd);
+int iommufd_vdevice_tsm_guest_request_ioctl(struct iommufd_ucmd *ucmd);
 #else
 static inline int iommufd_vdevice_tsm_op_ioctl(struct iommufd_ucmd *ucmd)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int
+iommufd_vdevice_tsm_guest_request_ioctl(struct iommufd_ucmd *ucmd)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct iommufd_vdevice *
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index d73e6b391c6f..7f4bbdd0bda5 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -433,6 +433,7 @@ union ucmd_buffer {
 	struct iommu_vfio_ioas vfio_ioas;
 	struct iommu_viommu_alloc viommu;
 	struct iommu_vdevice_tsm_op tsm_op;
+	struct iommu_vdevice_tsm_guest_request gr;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
@@ -496,6 +497,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 struct iommu_viommu_alloc, out_viommu_id),
 	IOCTL_OP(IOMMU_VDEVICE_TSM_OP, iommufd_vdevice_tsm_op_ioctl,
 		 struct iommu_vdevice_tsm_op, vdevice_id),
+	IOCTL_OP(IOMMU_VDEVICE_TSM_GUEST_REQUEST, iommufd_vdevice_tsm_guest_request_ioctl,
+		 struct iommu_vdevice_tsm_guest_request, resp_uptr),
 #ifdef CONFIG_IOMMUFD_TEST
 	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
 #endif
diff --git a/drivers/iommu/iommufd/tsm.c b/drivers/iommu/iommufd/tsm.c
index 401469110752..6b96d0aef25f 100644
--- a/drivers/iommu/iommufd/tsm.c
+++ b/drivers/iommu/iommufd/tsm.c
@@ -65,3 +65,51 @@ int iommufd_vdevice_tsm_op_ioctl(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(ucmd->ictx, &vdev->obj);
 	return rc;
 }
+
+/**
+ * iommufd_vdevice_tsm_guest_request_ioctl - Forward guest TSM requests
+ * @ucmd: user command data for IOMMU_VDEVICE_TSM_GUEST_REQUEST
+ *
+ * Resolve @iommu_vdevice_tsm_guest_request::vdevice_id to a vdevice and pass
+ * the request/response buffers to the TSM core.
+ *
+ * Return:
+ *  -errno on error.
+ *  positive residue if response/request bytes were left unconsumed.
+ *    if response buffer is provided, residue indicates the number of bytes
+ *    not used in response buffer
+ *    if there is no response buffer, residue indicates the number of bytes
+ *    not consumed in req buffer
+ *  0 otherwise.
+ */
+int iommufd_vdevice_tsm_guest_request_ioctl(struct iommufd_ucmd *ucmd)
+{
+	int rc;
+	struct iommufd_vdevice *vdev;
+	struct iommu_vdevice_tsm_guest_request *cmd = ucmd->cmd;
+	struct tsm_guest_req_info info = {
+		.scope = cmd->scope,
+		.req   = {
+			.user = u64_to_user_ptr(cmd->req_uptr),
+			.is_kernel = false,
+		},
+		.req_len = cmd->req_len,
+		.resp    =  {
+			.user = u64_to_user_ptr(cmd->resp_uptr),
+			.is_kernel = false,
+		},
+		.resp_len = cmd->resp_len,
+	};
+
+	vdev = container_of(iommufd_get_object(ucmd->ictx, cmd->vdevice_id,
+					       IOMMUFD_OBJ_VDEVICE),
+			    struct iommufd_vdevice, obj);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	rc = tsm_guest_req(vdev->idev->dev, &info);
+
+	/* No inline response, hence we don't need to copy the response */
+	iommufd_put_object(ucmd->ictx, &vdev->obj);
+	return rc;
+}
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index f0e35fc38776..317fcb53e4bf 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -259,6 +259,20 @@ int tsm_unbind(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(tsm_unbind);
 
+ssize_t tsm_guest_req(struct device *dev, struct tsm_guest_req_info *info)
+{
+	ssize_t ret;
+
+	if (!dev_is_pci(dev))
+		return -EINVAL;
+
+	ret = pci_tsm_guest_req(to_pci_dev(dev), info->scope,
+				info->req, info->req_len,
+				info->resp, info->resp_len, NULL);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tsm_guest_req);
+
 static void tsm_release(struct device *dev)
 {
 	struct tsm_dev *tsm_dev = container_of(dev, typeof(*tsm_dev), dev);
diff --git a/include/linux/tsm.h b/include/linux/tsm.h
index 9f2a7868021a..5231d5abf84d 100644
--- a/include/linux/tsm.h
+++ b/include/linux/tsm.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/uuid.h>
 #include <linux/device.h>
+#include <linux/sockptr.h>
 
 #define TSM_REPORT_INBLOB_MAX 64
 #define TSM_REPORT_OUTBLOB_MAX SZ_16M
@@ -131,6 +132,24 @@ void tsm_ide_stream_unregister(struct pci_ide *ide);
 int tsm_bind(struct device *dev, struct kvm *kvm, u64 tdi_id);
 int tsm_unbind(struct device *dev);
 
+/**
+ * struct tsm_guest_req_info - parameter for tsm_guest_req()
+ * @scope: scope for tsm guest request
+ * @req: request data buffer filled by guest
+ * @req_len: the size of @req filled by guest
+ * @resp: response data buffer filled by host
+ * @resp_len: for input, the size of @resp buffer filled by guest
+ *	      for output, the size of actual response data filled by host
+ */
+struct tsm_guest_req_info {
+	u32 scope;
+	sockptr_t req;
+	size_t req_len;
+	sockptr_t resp;
+	size_t resp_len;
+};
+ssize_t tsm_guest_req(struct device *dev, struct tsm_guest_req_info *info);
+
 #else
 
 static inline int tsm_bind(struct device *dev, struct kvm *kvm, u64 tdi_id)
@@ -142,6 +161,13 @@ static inline int tsm_unbind(struct device *dev)
 {
 	return 0;
 }
+
+struct tsm_guest_req_info;
+static inline ssize_t tsm_guest_req(struct device *dev,
+				    struct tsm_guest_req_info *info)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* __TSM_H */
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 653402e7048a..b0d1ecd81638 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -58,6 +58,7 @@ enum {
 	IOMMUFD_CMD_VEVENTQ_ALLOC = 0x93,
 	IOMMUFD_CMD_HW_QUEUE_ALLOC = 0x94,
 	IOMMUFD_CMD_VDEVICE_TSM_OP = 0x95,
+	IOMMUFD_CMD_VDEVICE_TSM_GUEST_REQUEST = 0x96,
 };
 
 /**
@@ -1367,4 +1368,26 @@ struct iommu_hw_queue_alloc {
 	__aligned_u64 length;
 };
 #define IOMMU_HW_QUEUE_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HW_QUEUE_ALLOC)
+
+/**
+ * struct iommu_vdevice_tsm_guest_request - ioctl(IOMMU_VDEVICE_TSM_GUEST_REQUEST)
+ * @size: sizeof(struct iommu_vdevice_tsm_guest_request)
+ * @vdevice_id: vDevice ID the guest request is for
+ * @scope: scope of tsm guest request
+ * @req_len: the blob size for @req_uptr, filled by guest
+ * @resp_len: the blob size for @resp_uptr, filled by guest
+ * @req_uptr: request data buffer filled by guest
+ * @resp_uptr: response data buffer
+ */
+struct iommu_vdevice_tsm_guest_request {
+	__u32 size;
+	__u32 vdevice_id;
+	__u32 scope;
+	__u32 req_len;
+	__u32 resp_len;
+	__aligned_u64 req_uptr;
+	__aligned_u64 resp_uptr;
+};
+#define IOMMU_VDEVICE_TSM_GUEST_REQUEST _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VDEVICE_TSM_GUEST_REQUEST)
+
 #endif
-- 
2.43.0


