Return-Path: <kvm+bounces-33834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D2049F27CE
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 02:36:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D0AC164EE9
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 01:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F6717C8D;
	Mon, 16 Dec 2024 01:36:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmtu5ljy1ljeznc42.icoremail.net (zg8tmtu5ljy1ljeznc42.icoremail.net [159.65.134.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D2A8BE8;
	Mon, 16 Dec 2024 01:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.65.134.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734312966; cv=none; b=TvNKZgzUdvf1UY0PuYCzHv8JG7iOmrzM5zErltT60cIvPHHHAlHSGYPSSFFJQixJ0nXLXUFhfMo9ZOF9ys/2bQYrRepmKt3Kmhko7yNgmZrlf7am/E+FJVIyp7yrbnjJfTa804akzHaJ1nD9dA0q0fJyCFQktp2oFpf76LVNgFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734312966; c=relaxed/simple;
	bh=eWgUJAmz47HFCOh4aIEmrxNlaOSMz0Zxku7oakMFQ3E=;
	h=From:To:Cc:Subject:Date:Message-Id; b=iates0D4nEFstfFD97K8qow7YvAnQEr+rEKXkoPw+lQbM+z1/UFfN8Aqi8zNCT+2hFI1eMIEBoamxomyi+vdc6m66he6HrNRYc8U3WoDK7r+uQgKzARGTQF8FB5GCxX7PHMGyU+A9EMKJBMhfo0EwIYg6qgbcaJaR90OGRgDRTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=159.65.134.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from ubuntu18.eswin.cn (unknown [10.12.192.151])
	by app1 (Coremail) with SMTP id TAJkCgDXG6Xsg19nlw8DAA--.14605S4;
	Mon, 16 Dec 2024 09:35:41 +0800 (CST)
From: zhangdongdong@eswincomputing.com
To: alex.williamson@redhat.com
Cc: bhelgaas@google.com,
	zhangdongdong@eswincomputing.com,
	yishaih@nvidia.com,
	avihaih@nvidia.com,
	yi.l.liu@intel.com,
	ankita@nvidia.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v2] PCI: Remove redundant macro
Date: Mon, 16 Dec 2024 09:35:36 +0800
Message-Id: <20241216013536.4487-1-zhangdongdong@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:TAJkCgDXG6Xsg19nlw8DAA--.14605S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww1DKFyUJF17uFWUtrWkJFb_yoW8ury8pr
	s8Ca4xGr45XF4Y9a1qya45A3W5Xa9xAryI93y7u343KFy3tw10vrWFyr42kryagrWxAF45
	JrsY9r90gF9F93JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBq14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw2
	8IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4l
	x2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrw
	CI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI
	42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z2
	80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbknY7UUUUU==
X-CM-SenderInfo: x2kd0wpgrqwvxrqjqvxvzl0uprps33xlqjhudrp/1tbiAgENCmdfBKsMWAABsG
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Dongdong Zhang <zhangdongdong@eswincomputing.com>

Removed the duplicate macro `PCI_VSEC_HDR` and its related macro
`PCI_VSEC_HDR_LEN_SHIFT` from `pci_regs.h` to avoid redundancy and
inconsistencies. Updated VFIO PCI code to use `PCI_VNDR_HEADER` and
`PCI_VNDR_HEADER_LEN()` for consistent naming and functionality.

These changes aim to streamline header handling while minimizing
impact, given the niche usage of these macros in userspace.

Signed-off-by: Dongdong Zhang <zhangdongdong@eswincomputing.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 5 +++--
 include/uapi/linux/pci_regs.h      | 3 ---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index ea2745c1ac5e..5572fd99b921 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1389,11 +1389,12 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
 
 	switch (ecap) {
 	case PCI_EXT_CAP_ID_VNDR:
-		ret = pci_read_config_dword(pdev, epos + PCI_VSEC_HDR, &dword);
+		ret = pci_read_config_dword(pdev, epos + PCI_VNDR_HEADER,
+					    &dword);
 		if (ret)
 			return pcibios_err_to_errno(ret);
 
-		return dword >> PCI_VSEC_HDR_LEN_SHIFT;
+		return PCI_VNDR_HEADER_LEN(dword);
 	case PCI_EXT_CAP_ID_VC:
 	case PCI_EXT_CAP_ID_VC9:
 	case PCI_EXT_CAP_ID_MFVC:
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 1601c7ed5fab..bcd44c7ca048 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1001,9 +1001,6 @@
 #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
 #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
 
-#define PCI_VSEC_HDR		4	/* extended cap - vendor-specific */
-#define  PCI_VSEC_HDR_LEN_SHIFT	20	/* shift for length field */
-
 /* SATA capability */
 #define PCI_SATA_REGS		4	/* SATA REGs specifier */
 #define  PCI_SATA_REGS_MASK	0xF	/* location - BAR#/inline */
-- 
2.17.1


