Return-Path: <kvm+bounces-67340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A42BDD00D11
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8F0A304D87F
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5113B2BD030;
	Thu,  8 Jan 2026 03:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SB4zUbkq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3BC29D293
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841762; cv=none; b=YITpLzMaMUVx+FF0xMFNE7a/db9mTyQnkq+gJLLDgQhvLgz1Ik/GWc5DXu9GizMb4ioGGueawIt3JSl0SZl7+bPiPT/szV2EucWnjvSnFbCwb7+j1t3jRxM+wkE4N2Py6TfkBvKnHoQxbYOPRBbAa081A321Vuw0Du598A+SUD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841762; c=relaxed/simple;
	bh=WNseSskd4Z5+i2dQT6CO6EkMfVwz4wCB2PqBqxukFk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hyf72rP7kN7jLH/iL8jLadpZP106/EyWSCx0vwkiRgsRhdIByDcUpHHUFPRvbKlqDGWM/hN/kWiACCEVWrJGmlp8PKYYNYtXlF70eqev3ZVoQUU4GaN8dtFVX5mMkhTq9ARZmp4bXlltftjOx/04ANnutRXyA6vsYLMG5a3kZ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SB4zUbkq; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841761; x=1799377761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WNseSskd4Z5+i2dQT6CO6EkMfVwz4wCB2PqBqxukFk8=;
  b=SB4zUbkqdxwNtyPrJmyY9jchwPF7l9IbE6Z+R8OJMAtY1o8D6zfAaQKM
   Aw/MPogTQ82SiRFQSF9SChvmMm8xC3SyW02REWuYGMkXBgU4GmN5haNij
   uct+NAwfbmt6oafdgvAqzdYgdCixCEYP/gZYzP4B2SKREgyldrNpHB0ot
   l9IYlxlVHpYDlf3Vbr43nzs2zsiZsHqG4LYddqBwV/a8T4ZxBSXWPfMbw
   d8w0HDLFDW88EKsaOkxVfqdJomcoMYdlslzQdv5AsrMFTuqvRWMChAL6G
   8KRigSm4zqlHhSs/lf1wdu0Q6lL5xz6DZwPrIPS9jwq9XboaxWg/bQbtx
   A==;
X-CSE-ConnectionGUID: 8X6ITm9bTcqyLhmvt1F9zQ==
X-CSE-MsgGUID: rjtPlv8zRYKAcxUYt7+x3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877598"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877598"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:09:20 -0800
X-CSE-ConnectionGUID: 02g/YQOsTLO+xJw1o1M/6Q==
X-CSE-MsgGUID: pKDs+Qm2TQS/xIXH7BbTQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202211242"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:09:11 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,
	devel@lists.libvirt.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 24/27] hw/core/machine: Remove hw_compat_2_7[] array
Date: Thu,  8 Jan 2026 11:30:48 +0800
Message-Id: <20260108033051.777361-25-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108033051.777361-1-zhao1.liu@intel.com>
References: <20260108033051.777361-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philippe Mathieu-Daudé <philmd@linaro.org>

The hw_compat_2_7[] array was only used by the pc-q35-2.7 and
pc-i440fx-2.7 machines, which got removed. Remove it.

Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/machine.c        | 9 ---------
 include/hw/core/boards.h | 3 ---
 2 files changed, 12 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index b01838c88a60..d2075fe30d84 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -281,15 +281,6 @@ GlobalProperty hw_compat_2_8[] = {
 };
 const size_t hw_compat_2_8_len = G_N_ELEMENTS(hw_compat_2_8);
 
-GlobalProperty hw_compat_2_7[] = {
-    { "virtio-pci", "page-per-vq", "on" },
-    { "virtio-serial-device", "emergency-write", "off" },
-    { "ioapic", "version", "0x11" },
-    { "intel-iommu", "x-buggy-eim", "true" },
-    { "virtio-pci", "x-ignore-backend-features", "on" },
-};
-const size_t hw_compat_2_7_len = G_N_ELEMENTS(hw_compat_2_7);
-
 MachineState *current_machine;
 
 static char *machine_get_kernel(Object *obj, Error **errp)
diff --git a/include/hw/core/boards.h b/include/hw/core/boards.h
index b0e3a523a107..c7406a284fc2 100644
--- a/include/hw/core/boards.h
+++ b/include/hw/core/boards.h
@@ -879,7 +879,4 @@ extern const size_t hw_compat_2_9_len;
 extern GlobalProperty hw_compat_2_8[];
 extern const size_t hw_compat_2_8_len;
 
-extern GlobalProperty hw_compat_2_7[];
-extern const size_t hw_compat_2_7_len;
-
 #endif
-- 
2.34.1


