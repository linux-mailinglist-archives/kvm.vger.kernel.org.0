Return-Path: <kvm+bounces-33716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEAE9F0855
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:46:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DD45188C7B1
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7EBB1B4F02;
	Fri, 13 Dec 2024 09:46:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4251B3937;
	Fri, 13 Dec 2024 09:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734083194; cv=none; b=bkRyea4evrqUZ6zlN3hT2vOXtlCPcw2HyO01IRkD9NmpNjYra6NTVWdUzhUWvKa4iYvzjqBQyoTUf9XHlLxDYjT1/JaNY+xd4TnJ0g9wsjiydCplX7oGY6JcpP7kwPUxRJmEaUh6f9+CbsZEMWseKiA2wWDo4KtKpzybf4cppZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734083194; c=relaxed/simple;
	bh=hLBnV4IZYkZgCuhCpJqYMpTk2eeDR/CYwEsx3jyoaGs=;
	h=From:To:Cc:Subject:Date:Message-Id; b=K8pwWB/5V4JW2gGodzraUuIvJ1xERIV3OpymBvGnKn2nzNmHtZMVLT2xOlh2v5wtqAZkvdoT2c0aflmj+Mp8gvXOkuOx/jx/TU+ksibGDNU7/3Hhk842YVHo/Cqd2lrEqCJKwlBhkPrfkxBA0XqzWYY2HOgJ9LfWlrezhOZTOnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from ubuntu18.eswin.cn (unknown [10.12.192.151])
	by app1 (Coremail) with SMTP id TAJkCgDXG6VrAlxnCBICAA--.9990S4;
	Fri, 13 Dec 2024 17:46:20 +0800 (CST)
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
Subject: [PATCH] PCI: Remove redundant macro
Date: Fri, 13 Dec 2024 17:46:17 +0800
Message-Id: <20241213094617.1149-1-zhangdongdong@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:TAJkCgDXG6VrAlxnCBICAA--.9990S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJrykCw4rWFy7JryUCr4Uurg_yoW8WryfpF
	s5Ca4xGrWrXFWFka1vya45AFn8XasxZrWI93y7uw13Ka43t3yIvrWYyr42yry2grWIyF45
	XrsYkr98WFyjqaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBS14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw2
	8IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4l
	x2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrw
	CI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI
	42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z2
	80aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUO73vUUUUU
X-CM-SenderInfo: x2kd0wpgrqwvxrqjqvxvzl0uprps33xlqjhudrp/1tbiAgEKCmdbECsaiwAEsR
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Dongdong Zhang <zhangdongdong@eswincomputing.com>

Removed the duplicate macro definition PCI_VSEC_HDR from
pci_regs.h to avoid redundancy. Updated the VFIO PCI code
to use the existing `PCI_VNDR_HEADER` macro for consistency,
ensuring minimal changes to the codebase.

Signed-off-by: Dongdong Zhang <zhangdongdong@eswincomputing.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 3 ++-
 include/uapi/linux/pci_regs.h      | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index ea2745c1ac5e..c30748912ff1 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1389,7 +1389,8 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
 
 	switch (ecap) {
 	case PCI_EXT_CAP_ID_VNDR:
-		ret = pci_read_config_dword(pdev, epos + PCI_VSEC_HDR, &dword);
+		ret = pci_read_config_dword(pdev, epos + PCI_VNDR_HEADER,
+					    &dword);
 		if (ret)
 			return pcibios_err_to_errno(ret);
 
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 1601c7ed5fab..7b6cad788de3 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1001,7 +1001,6 @@
 #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
 #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
 
-#define PCI_VSEC_HDR		4	/* extended cap - vendor-specific */
 #define  PCI_VSEC_HDR_LEN_SHIFT	20	/* shift for length field */
 
 /* SATA capability */
-- 
2.17.1


