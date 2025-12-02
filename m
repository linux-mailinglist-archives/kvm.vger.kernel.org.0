Return-Path: <kvm+bounces-65130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7193BC9C169
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:05:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6A98A346CA9
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B3F2737E0;
	Tue,  2 Dec 2025 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TPpH312y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD70253B58
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691504; cv=none; b=pguHJa56dGEQB+ohXfqRNNkzia/UReMfq9SU5YCQpak2t0rM3yXo/8kf/IfTYZIb2a1hctiAVi/I6VvfYrol7AeOPztxI5RWXHMtjlRmUjl4H9sBtqupXT7lF8qXYaXy9EB6OE274UWy8WGvp00uuwaGBRhy4LPf1FVK/kwxymk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691504; c=relaxed/simple;
	bh=XlIGSj5lhO4Iz2SQI4ugiBcfuTEO7n1T8R6MNiVxNhc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yp4akYoMAIjhZTfR4zQnW2PzbUPpgQZYPG2HH4jgFprd3wmlQy7wX+1hzxiD+19NcYo7xcZesoB8ppi7TUk7ww8pVvJlyuon+7AX5q+eAVn7kuqr/ykMfEai0c3lcNRsOzNLmDgPm98//RcQuskJGjdhRIMPddeUEV+3qjyRcFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TPpH312y; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691503; x=1796227503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XlIGSj5lhO4Iz2SQI4ugiBcfuTEO7n1T8R6MNiVxNhc=;
  b=TPpH312yAnndFXG5tpLlBOMcWuDUA+OWEusxOaK5i3ruoDi2o0IAv+DL
   BUbn/45KYxBD7nug15KfcoCuaeXi3FxMJHXfQpAzOcTGCCtUJRk1sA3eR
   lxmHtSa4oGuDEjJuckPP8BtKZ/BIw9sRYwppfu60OaRvikYa1s1CuACHB
   PqDh/cWHS206v5s1M/U6zCchCp+oU/LE/t5PpKWi2iScavjmdkNVjrhHQ
   lii98/d+4VEYQRRIRQfedANO89g8g6szyQB8cTZYIjX9CVeS/oVULe0ii
   pnhqMiCXmo/8R+MrJxFqzY/bSuWTXpayi8B/RLPMgi+breW5/TYWAo61U
   g==;
X-CSE-ConnectionGUID: BUeC3Rw5R3uKZjMjyTrpdQ==
X-CSE-MsgGUID: xNPpAKoSSoyoTvUyR+2qKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142394"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142394"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:05:02 -0800
X-CSE-ConnectionGUID: rtOdz7YASjSKQ1dh7A6/bg==
X-CSE-MsgGUID: DswU6ju5RweXLybViEBGvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199537043"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:04:53 -0800
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
Subject: [PATCH v5 06/28] docs/specs/acpi_cpu_hotplug: Remove legacy cpu hotplug descriptions
Date: Wed,  3 Dec 2025 00:28:13 +0800
Message-Id: <20251202162835.3227894-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251202162835.3227894-1-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy cpu hotplug has been removed totally and machines start with
modern cpu hotplug interface directly.

Therefore, update the documentation to describe current QEMU cpu hotplug
logic.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v4:
 * New patch.
---
 docs/specs/acpi_cpu_hotplug.rst | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/docs/specs/acpi_cpu_hotplug.rst b/docs/specs/acpi_cpu_hotplug.rst
index 351057c96761..f49678100044 100644
--- a/docs/specs/acpi_cpu_hotplug.rst
+++ b/docs/specs/acpi_cpu_hotplug.rst
@@ -8,22 +8,6 @@ ACPI BIOS GPE.2 handler is dedicated for notifying OS about CPU hot-add
 and hot-remove events.
 
 
-Legacy ACPI CPU hotplug interface registers
--------------------------------------------
-
-CPU present bitmap for:
-
-- ICH9-LPC (IO port 0x0cd8-0xcf7, 1-byte access)
-- PIIX-PM  (IO port 0xaf00-0xaf1f, 1-byte access)
-- One bit per CPU. Bit position reflects corresponding CPU APIC ID. Read-only.
-- The first DWORD in bitmap is used in write mode to switch from legacy
-  to modern CPU hotplug interface, write 0 into it to do switch.
-
-QEMU sets corresponding CPU bit on hot-add event and issues SCI
-with GPE.2 event set. CPU present map is read by ACPI BIOS GPE.2 handler
-to notify OS about CPU hot-add events. CPU hot-remove isn't supported.
-
-
 Modern ACPI CPU hotplug interface registers
 -------------------------------------------
 
@@ -189,20 +173,14 @@ Typical usecases
 (x86) Detecting and enabling modern CPU hotplug interface
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-QEMU starts with legacy CPU hotplug interface enabled. Detecting and
-switching to modern interface is based on the 2 legacy CPU hotplug features:
-
-#. Writes into CPU bitmap are ignored.
-#. CPU bitmap always has bit #0 set, corresponding to boot CPU.
-
-Use following steps to detect and enable modern CPU hotplug interface:
+QEMU starts with modern CPU hotplug interface enabled. Use following steps to
+detect modern CPU hotplug interface:
 
-#. Store 0x0 to the 'CPU selector' register, attempting to switch to modern mode
 #. Store 0x0 to the 'CPU selector' register, to ensure valid selector value
 #. Store 0x0 to the 'Command field' register
 #. Read the 'Command data 2' register.
    If read value is 0x0, the modern interface is enabled.
-   Otherwise legacy or no CPU hotplug interface available
+   Otherwise no CPU hotplug interface available
 
 Get a cpu with pending event
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- 
2.34.1


