Return-Path: <kvm+bounces-72083-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KDRJECtoGlulgQAu9opvQ
	(envelope-from <kvm+bounces-72083-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 21:29:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F6DB1AF234
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 21:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB27031AB5FD
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76ABB472782;
	Thu, 26 Feb 2026 20:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="t17APBLU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2084657D8;
	Thu, 26 Feb 2026 20:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772137391; cv=none; b=GnFDitXRkRUbmThWmyiLQjuMuEu6dcoWRyMaAC33e2KSFk6s9Ib1ZBHPMTck5xBu+tQgojVRyN9nUCCmRxyw+9fhcsk0FF/6Dcett0aqMGIBQ92tLxL/8uyBay8wXE+JTM19O5pyzHV0hiwuV4qPPOFAI5c57FROZf/63c0DQ8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772137391; c=relaxed/simple;
	bh=+hmoajerUjgkOA+GtpR1T1dbzFW+mfYacHuqhuEefzI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNLIJQbQUJvQyJgiO9GayeJSMQnefsebJQFOcrH92IFQ1HVmHn3FW12LRErppHUrtQYeX6KkHLNHqo2kRQe0NwXP9eQaCaT2QfXjge07ipgzL2899F4s+e4iw5HMauwIIiM0Uq/Wcme/nr03FSD6+VOAbEH1zfOOqFzurKpqWgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=t17APBLU; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QHCNlC1891453;
	Thu, 26 Feb 2026 12:22:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=p4qhrvMfn67SpV2MVw3xZIKd+Em4yb7TrPNhhwEdCuo=; b=t17APBLUkTAk
	TDuePMsscDzk42nuhHQNYT0Ki9+g8Oujt9ATD+FfxXKRDT60ed/9WX3gaUBplyy2
	fSjJujdpp4NS1Lx8xS2FqUn+HB5s9kXIi7sGmhq+lqyXvA+bTvLxf/tpoKK9J6tT
	7I/Tt7Yqh9nq/XeWw+0A9rLu03x5hNDqL2r6dHEZVaAL83A4ZKS4z3enT0B1UzOZ
	MbHJ4iymy1uc6P+q2CZVwKVjzqtDg9lkgekr22GzajmPdRvb6b3knhJ+ieSPp2IK
	EEWopxC53+arEgXjQw1rq0Fp97can/60jIqgOjoyTHAEug+LzUEVZaLiegznYTcl
	L846ch1Vbw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4cjmp9dnm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 26 Feb 2026 12:22:57 -0800 (PST)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.35; Thu, 26 Feb
 2026 20:22:56 +0000
From: Matt Evans <mattev@meta.com>
To: Alex Williamson <alex@shazbot.org>, Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
        Mahmoud Adam
	<mngyadam@amazon.de>,
        David Matlack <dmatlack@google.com>
CC: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Sumit Semwal
	<sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?=
	<christian.koenig@amd.com>,
        Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal
	<ankita@nvidia.com>,
        Pranjal Shrivastava <praan@google.com>,
        Alistair Popple
	<apopple@nvidia.com>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linaro-mm-sig@lists.linaro.org>,
        <kvm@vger.kernel.org>
Subject: [RFC PATCH 6/7] vfio/pci: Add mmap() attributes to DMABUF feature
Date: Thu, 26 Feb 2026 12:22:02 -0800
Message-ID: <20260226202211.929005-7-mattev@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226202211.929005-1-mattev@meta.com>
References: <20260226202211.929005-1-mattev@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: tLZAnEt99yhMVR7DzzedwG1Q3dqkNAqK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE4NiBTYWx0ZWRfX15eKNzaG/OmP
 JFo3cdA2DKdUsgi8aH90lXhs5OMcRD7XzA97n5hdziEdEWmdyrYdnxdK0PJZdQVyzJ/XLBHIMwj
 qJL6SlcuMCuHgiQ0/TuqPlBY4fFt2hp183lpHN591XieNyxFQfOrTQZ8+6ZoZ/rOddth5U7N/TD
 FjTA+V8Rp7vXPfToGi40TmaPianF5D9K9vBtl5zVS1KnchMnIX1ghgZwNogwYfFovthbdct58yx
 BWqCfP0qLO2p+iGbx/xGiHLh3AE/dK5SUka6uin+x+GffqNXNtcWXL+K8U/vrBfwunu3Busiu3Z
 an0F0I+9k5EPQRFdpk2IubbFH1IP68nTkHva23hF49VRObMu0ZBG2ZvY5bQUFQWxHsdM8MOjE/b
 zLUgmyACMGwhWlnkCEcgti7VcRXe3sGQGi8Zdnm4esYA0feklcvHPLeDWYfatBi8a4/Nerd0HHb
 xZeiBGylNYCFg65TbWA==
X-Proofpoint-ORIG-GUID: tLZAnEt99yhMVR7DzzedwG1Q3dqkNAqK
X-Authority-Analysis: v=2.4 cv=abZsXBot c=1 sm=1 tr=0 ts=69a0aba1 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VabnemYjAAAA:8 a=dDaxl782XL0KO6pWJDcA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_FROM(0.00)[bounces-72083-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mattev@meta.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[meta.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,meta.com:mid,meta.com:dkim,meta.com:email]
X-Rspamd-Queue-Id: 3F6DB1AF234
X-Rspamd-Action: no action

A new field is reserved in vfio_device_feature_dma_buf.flags to
request CPU-facing memory type attributes for mmap()s of the buffer.
Add a flag VFIO_DEVICE_FEATURE_DMA_BUF_ATTR_WC, which results in WC
PTEs for the DMABUF's BAR region.

Signed-off-by: Matt Evans <mattev@meta.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 18 ++++++++++++++----
 include/uapi/linux/vfio.h          | 12 +++++++++---
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index af30ca205f31..d66a918e9934 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -28,6 +28,7 @@ struct vfio_pci_dma_buf {
 	struct dma_buf_phys_vec *phys_vec;
 	struct p2pdma_provider *provider;
 	u32 nr_ranges;
+	u32 attrs;
 	enum vfio_pci_dma_buf_status status;
 };
 
@@ -286,13 +287,15 @@ static int vfio_pci_dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *
 		return -EINVAL;
 
 	vma->vm_private_data = priv;
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (priv->attrs == VFIO_DEVICE_FEATURE_DMA_BUF_ATTR_WC)
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
 	/*
 	 * See comments in vfio_pci_core_mmap() re VM_ALLOW_ANY_UNCACHED.
-	 *
-	 * FIXME: get mapping attributes from dmabuf?
 	 */
 	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
 		     VM_DONTEXPAND | VM_DONTDUMP);
@@ -402,6 +405,12 @@ static int validate_dmabuf_input(struct vfio_device_feature_dma_buf *dma_buf,
 	size_t length = 0;
 	u32 i;
 
+	if ((dma_buf->flags != 0) &&
+	    ((dma_buf->flags & ~VFIO_DEVICE_FEATURE_DMA_BUF_ATTR_MASK) ||
+	     ((dma_buf->flags & VFIO_DEVICE_FEATURE_DMA_BUF_ATTR_MASK) !=
+	      VFIO_DEVICE_FEATURE_DMA_BUF_ATTR_WC)))
+		return -EINVAL;
+
 	for (i = 0; i < dma_buf->nr_ranges; i++) {
 		u64 offset = dma_ranges[i].offset;
 		u64 len = dma_ranges[i].length;
@@ -446,7 +455,7 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 	if (copy_from_user(&get_dma_buf, arg, sizeof(get_dma_buf)))
 		return -EFAULT;
 
-	if (!get_dma_buf.nr_ranges || get_dma_buf.flags)
+	if (!get_dma_buf.nr_ranges)
 		return -EINVAL;
 
 	/*
@@ -490,6 +499,7 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 	priv->vdev = vdev;
 	priv->nr_ranges = get_dma_buf.nr_ranges;
 	priv->size = length;
+	priv->attrs = get_dma_buf.flags & VFIO_DEVICE_FEATURE_DMA_BUF_ATTR_MASK;
 	ret = vdev->pci_ops->get_dmabuf_phys(vdev, &priv->provider,
 					     get_dma_buf.region_index,
 					     priv->phys_vec, dma_ranges,
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ac2329f24141..9e0fbf333452 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1487,7 +1487,9 @@ struct vfio_device_feature_bus_master {
  * etc. offset/length specify a slice of the region to create the dmabuf from.
  * nr_ranges is the total number of (P2P DMA) ranges that comprise the dmabuf.
  *
- * flags should be 0.
+ * flags contains:
+ * - A field for userspace mapping attribute: by default, suitable for regular
+ *   MMIO. Alternate attributes (such as WC) can be selected.
  *
  * Return: The fd number on success, -1 and errno is set on failure.
  */
@@ -1501,8 +1503,12 @@ struct vfio_region_dma_range {
 struct vfio_device_feature_dma_buf {
 	__u32	region_index;
 	__u32	open_flags;
-	__u32   flags;
-	__u32   nr_ranges;
+	__u32	flags;
+	/* Flags sub-field reserved for attribute enum */
+#define VFIO_DEVICE_FEATURE_DMA_BUF_ATTR_MASK		(0xf << 28)
+#define VFIO_DEVICE_FEATURE_DMA_BUF_ATTR_UC		(0 << 28)
+#define VFIO_DEVICE_FEATURE_DMA_BUF_ATTR_WC		(1 << 28)
+	__u32	nr_ranges;
 	struct vfio_region_dma_range dma_ranges[] __counted_by(nr_ranges);
 };
 
-- 
2.47.3


