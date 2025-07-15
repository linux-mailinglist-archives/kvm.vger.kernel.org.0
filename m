Return-Path: <kvm+bounces-52450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6074FB05439
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:12:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6067A188A4A2
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BECC92737F3;
	Tue, 15 Jul 2025 08:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ch1jFVbj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692A726D4D8;
	Tue, 15 Jul 2025 08:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752567127; cv=none; b=RGQkj6cDnvEhU8QPlRaX1lduOEQmFFxUq+ONMNoCpT4HmirZvsJkR51B5hDl1yZh4x3Z4Nk2UzI6tKIhKa1sgpa9KboWgdXZeo+fHb9evGnW5cHPhNrk2NzOyMKWdZGpKqT/kdBwcNF/7K10Jj3ckFinnTeHqlQwHO5HdjNoXI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752567127; c=relaxed/simple;
	bh=EujtSF5v7W7AX5BDVTAJis/XOiCAixrztOTllSzkuuA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=gts4iPlBlkijnvfrzhobkTbLbQmO09LbtKjuqFXkBzqeb2TccfmjXBhU7MvAjkix5/fmPvQyjS3h8AMOIUGOOvf6CVjwgmnjSCanLAqdEkrPn0tCLtJViqEoIkE/G03qyiDW8K3g2lbl1LvY7RXWcGnkY2LKbMoL94YL8y9s5j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ch1jFVbj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752567126; x=1784103126;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EujtSF5v7W7AX5BDVTAJis/XOiCAixrztOTllSzkuuA=;
  b=Ch1jFVbjj9ZolLzcrM2siOiy+7nxW7kqz33XPI+ggKSPDJfUh8tTeWmk
   OXBNNjBtG3A/MQj3n7p5BA12ndna5k1Mj/4k8SQ3QZQCAJ8lr+fKN8qr0
   /2dX7CNRifchDtqxpIs7eFC6UJljznbpzWuHx4r3bAyNGNUf2ESYT0pG8
   gi+V+4CTC9rXtXXi1BN3zVXJCG/SSilyCxfyxauIKyrRLqyDa+n17HxI5
   fXeoUCAPAZBa675FNT+iz+vatVnMBKON/M2O2UNIqb8YLZNDjZ+nUhwff
   BwHMQzlD2zDIkDJEQtvOgKYxi9R+5ZpjBp/zdVkGUtuQG9h7G4pBk8Bb8
   Q==;
X-CSE-ConnectionGUID: Zqv2NBHSSzeveYj/PfGRUg==
X-CSE-MsgGUID: Ytq9wQQoRmiBemsvxpgviA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="66135480"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="66135480"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:12:05 -0700
X-CSE-ConnectionGUID: DU5mCpxPRceNseAZD54ZXw==
X-CSE-MsgGUID: 8FnxOn3GSX2qBv9wAmXWYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="157262754"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa007.jf.intel.com with ESMTP; 15 Jul 2025 01:12:03 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	kvm@vger.kernel.org,
	herbert@gondor.apana.org.au,
	giovanni.cabiddu@intel.com
Subject: [PATCH] vfio/qat: add support for intel QAT 6xxx virtual functions
Date: Tue, 15 Jul 2025 09:11:50 +0100
Message-Id: <20250715081150.1244466-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Małgorzata Mielnik <malgorzata.mielnik@intel.com>

Extend the qat_vfio_pci variant driver to support QAT 6xxx Virtual
Functions (VFs). Add the relevant QAT 6xxx VF device IDs to the driver's
probe table, enabling proper detection and initialization of these devices.

Update the module description to reflect that the driver now supports all
QAT generations.

Signed-off-by: Małgorzata Mielnik <malgorzata.mielnik@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/vfio/pci/qat/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
index 845ed15b6771..499c9e1d67ee 100644
--- a/drivers/vfio/pci/qat/main.c
+++ b/drivers/vfio/pci/qat/main.c
@@ -675,6 +675,8 @@ static const struct pci_device_id qat_vf_vfio_pci_table[] = {
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4941) },
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4943) },
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4945) },
+	/* Intel QAT GEN6 6xxx VF device */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4949) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, qat_vf_vfio_pci_table);
@@ -696,5 +698,5 @@ module_pci_driver(qat_vf_vfio_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Xin Zeng <xin.zeng@intel.com>");
-MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration support for Intel(R) QAT GEN4 device family");
+MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration support for Intel(R) QAT device family");
 MODULE_IMPORT_NS("CRYPTO_QAT");

base-commit: bfeda8f971d01d0c1d0e3f4cf9d4e2b0a2b09d89
-- 
2.40.1


