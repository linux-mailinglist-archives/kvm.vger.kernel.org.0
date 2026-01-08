Return-Path: <kvm+bounces-67337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A95AD00CFB
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DD30301FF8C
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603D72BD036;
	Thu,  8 Jan 2026 03:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kZ2tTYqq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D4E28D8E8
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841734; cv=none; b=L3JrNCd8mfZ7/OSbeNEhlvSA+nAX+QZuEIjv01J12MtRUcHDd6ouCpaC+sZyZF1nZBTJZvVccEe/ympTOUn5+u1dU6zGa4E5WKEOj9BQpTPRRco3PlnlCvESrqmlDLlQAiEAbAFBK8Gg3EHaReqNw3vuhEH1yipCvw13igap8z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841734; c=relaxed/simple;
	bh=xejOAq+bFW6xoyJ41YFTEFZRpWNzRTBD9POBrU3YhrA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ag8iOMVilRr9DwkqNOSddnhH3KWqyFcDTGRcZZdcFCs1ZgQIgMMsyD5vKs9hlYr4cw4n6N15EKBR0bs5leyBA7WIn7KivCeIA/N2Na29BH4orfIkZusN6dnAmF/dnj4jTVTa14b5HKamh6Wtnnq6yvhVYD3/C6R5hjd2eIL5Htg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kZ2tTYqq; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841734; x=1799377734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xejOAq+bFW6xoyJ41YFTEFZRpWNzRTBD9POBrU3YhrA=;
  b=kZ2tTYqqASNTGAZI/ufTKREj9BUjRkh3ft5H8zTUNo8mrDl5YCW8h770
   NuFqcq+5MDrteyfqRBqTXsJ32d/r8evNDcgsqmgY/qOINvjtr8LRauYLx
   ESLqDyOMBM4DKLdhV9msWZoDmemPw8NC1QCXXMhelnV6HksBXGUTIDK9y
   nRd5TjOyRwhyVVh+G9LGWmX1+wwoo2SGeQQrA0MQIe+Glnw5FGFVvYEgr
   ZU3iqozv+FUN5QNU9Dz5I/JjwV8Rg/hGccV0czUwK4p5GVP1IfzXNcaw9
   O1TDPseYAjHHZ5ZPoXg8Bd1qHuvCtsd+NM9xCk91S7GLRGVBiHnR1ziCr
   w==;
X-CSE-ConnectionGUID: dFR4OrUoR4ySOqrvxJC5vA==
X-CSE-MsgGUID: rnq4wzxoTQa7rMbDICudcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877504"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877504"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:08:53 -0800
X-CSE-ConnectionGUID: QeaaR3ZcS/GCyk4pHbqDXA==
X-CSE-MsgGUID: QP/qxYHGQt2VmzYGLblkNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202211209"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:08:43 -0800
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
Subject: [PATCH v6 21/27] hw/i386/pc: Remove pc_compat_2_7[] array
Date: Thu,  8 Jan 2026 11:30:45 +0800
Message-Id: <20260108033051.777361-22-zhao1.liu@intel.com>
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

The pc_compat_2_7[] array was only used by the pc-q35-2.7
and pc-i440fx-2.7 machines, which got removed. Remove it.

Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/pc.c         | 10 ----------
 include/hw/i386/pc.h |  3 ---
 2 files changed, 13 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 4b5b7f24d7de..4dfdd040fb13 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -253,16 +253,6 @@ GlobalProperty pc_compat_2_8[] = {
 };
 const size_t pc_compat_2_8_len = G_N_ELEMENTS(pc_compat_2_8);
 
-GlobalProperty pc_compat_2_7[] = {
-    { TYPE_X86_CPU, "l3-cache", "off" },
-    { TYPE_X86_CPU, "full-cpuid-auto-level", "off" },
-    { "Opteron_G3" "-" TYPE_X86_CPU, "family", "15" },
-    { "Opteron_G3" "-" TYPE_X86_CPU, "model", "6" },
-    { "Opteron_G3" "-" TYPE_X86_CPU, "stepping", "1" },
-    { "isa-pcspk", "migrate", "off" },
-};
-const size_t pc_compat_2_7_len = G_N_ELEMENTS(pc_compat_2_7);
-
 /*
  * @PC_FW_DATA:
  * Size of the chunk of memory at the top of RAM for the BIOS ACPI tables
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 0f7d656b3f3b..5d698d024258 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -292,9 +292,6 @@ extern const size_t pc_compat_2_9_len;
 extern GlobalProperty pc_compat_2_8[];
 extern const size_t pc_compat_2_8_len;
 
-extern GlobalProperty pc_compat_2_7[];
-extern const size_t pc_compat_2_7_len;
-
 #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
     static void pc_machine_##suffix##_class_init(ObjectClass *oc, \
                                                  const void *data) \
-- 
2.34.1


