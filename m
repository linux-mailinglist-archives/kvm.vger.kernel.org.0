Return-Path: <kvm+bounces-67336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 674C1D00CDE
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3E0613046F95
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B5A2BD01B;
	Thu,  8 Jan 2026 03:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BodjAShk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A115B28D8E8
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841725; cv=none; b=jSvnNrSWKlmnnlOkjRma1Nw8rA+nvoKNaJA2+pL4mwQ/1PywhFUqSN7RgrZ6RoATy8C06uvwPudA4U+MUqEA1tW24/NHrd+U8SI+I/ObeNGgCjoCfSCbsHfShEK7lmK6QYPu/Bkjx6cy8hJYX6pmWg6gcCnWDPgaZ1XJD3ZNTAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841725; c=relaxed/simple;
	bh=My/GRcDksrtFiT0izM7nSn0++VR+FDIVCuKnI6KE6f0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OyDV4PEmmHaiQK3LOId0ZHSMpGKh6CxGg8bKePEvm/ATXErUijN7aZByAb+X4K0s1WpvSu+0sH6iliQuu4jVjHtrwD4C0Q1hjuCMl3inHkb7dIZMmTDn6yhfdrGp7HjNUaxbmXxQKVwiMAtuHehwlyu2DjbYMrzaqPGGBOr1wcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BodjAShk; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841724; x=1799377724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=My/GRcDksrtFiT0izM7nSn0++VR+FDIVCuKnI6KE6f0=;
  b=BodjAShktpCkMnWL8Ttxsrubg8ikOwhowblrtaTqorfzQ/DMn+rfMvp3
   Ftoov7RifzUxHyD9IWcCMSG2ok+W2FxNqNIWtc7akjIWO+Ib8/DH4gkam
   T28FsOhATSHvzQBNMM8Cl4LtMARoXy5WatHdFSlhSdrLLfQLs8pCy0Xvy
   6dChjheKS/OPm+zTWeahzOBpOrTVMSytSCYhbkIbdvOiGsXQPzM9saDbY
   haq6Ok7E8gcRIaarh8O5Mno5O4LoH2kYmyo0m6MP3WaST6GQP5agtFeFf
   T67HNbkXi0SUzJWpIFZrWnjDEYvlC2fgwj5ME50PdG+tC79w7K0XOsmq1
   A==;
X-CSE-ConnectionGUID: Gto+koE2SXi+VNxtAy2i4Q==
X-CSE-MsgGUID: zRt2OteCQtSXnebvMWnsKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877476"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877476"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:08:44 -0800
X-CSE-ConnectionGUID: Zv1AUI/OSAW+OTck5ZMlOQ==
X-CSE-MsgGUID: tkO918hkRPCB9Zo2CiWFPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202211203"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:08:34 -0800
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
Subject: [PATCH v6 20/27] hw/i386/pc: Remove deprecated pc-q35-2.7 and pc-i440fx-2.7 machines
Date: Thu,  8 Jan 2026 11:30:44 +0800
Message-Id: <20260108033051.777361-21-zhao1.liu@intel.com>
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

These machines has been supported for a period of more than 6 years.
According to our versioned machine support policy (see commit
ce80c4fa6ff "docs: document special exception for machine type
deprecation & removal") they can now be removed.  Remove the qtest
in test-x86-cpuid-compat.c file.

Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/pc_piix.c                   |  9 ---------
 hw/i386/pc_q35.c                    | 10 ----------
 tests/qtest/test-x86-cpuid-compat.c | 11 -----------
 3 files changed, 30 deletions(-)

diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index fa1025dcfd85..6f6e011d6c42 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -724,15 +724,6 @@ static void pc_i440fx_machine_2_8_options(MachineClass *m)
 
 DEFINE_I440FX_MACHINE(2, 8);
 
-static void pc_i440fx_machine_2_7_options(MachineClass *m)
-{
-    pc_i440fx_machine_2_8_options(m);
-    compat_props_add(m->compat_props, hw_compat_2_7, hw_compat_2_7_len);
-    compat_props_add(m->compat_props, pc_compat_2_7, pc_compat_2_7_len);
-}
-
-DEFINE_I440FX_MACHINE(2, 7);
-
 #ifdef CONFIG_XEN
 static void xenfv_machine_4_2_options(MachineClass *m)
 {
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 7214a4232ffc..969366df9608 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -671,13 +671,3 @@ static void pc_q35_machine_2_8_options(MachineClass *m)
 }
 
 DEFINE_Q35_MACHINE(2, 8);
-
-static void pc_q35_machine_2_7_options(MachineClass *m)
-{
-    pc_q35_machine_2_8_options(m);
-    m->max_cpus = 255;
-    compat_props_add(m->compat_props, hw_compat_2_7, hw_compat_2_7_len);
-    compat_props_add(m->compat_props, pc_compat_2_7, pc_compat_2_7_len);
-}
-
-DEFINE_Q35_MACHINE(2, 7);
diff --git a/tests/qtest/test-x86-cpuid-compat.c b/tests/qtest/test-x86-cpuid-compat.c
index 456e2af66572..5e0547e81b7b 100644
--- a/tests/qtest/test-x86-cpuid-compat.c
+++ b/tests/qtest/test-x86-cpuid-compat.c
@@ -345,17 +345,6 @@ int main(int argc, char **argv)
 
     /* Check compatibility of old machine-types that didn't
      * auto-increase level/xlevel/xlevel2: */
-    if (qtest_has_machine("pc-i440fx-2.7")) {
-        add_cpuid_test("x86/cpuid/auto-level/pc-2.7",
-                       "486", "arat=on,avx512vbmi=on,xsaveopt=on",
-                       "pc-i440fx-2.7", "level", 1);
-        add_cpuid_test("x86/cpuid/auto-xlevel/pc-2.7",
-                       "486", "3dnow=on,sse4a=on,invtsc=on,npt=on,svm=on",
-                       "pc-i440fx-2.7", "xlevel", 0);
-        add_cpuid_test("x86/cpuid/auto-xlevel2/pc-2.7",
-                       "486", "xstore=on", "pc-i440fx-2.7",
-                       "xlevel2", 0);
-    }
     if (qtest_has_machine("pc-i440fx-2.9")) {
         add_cpuid_test("x86/cpuid/auto-level7/pc-i440fx-2.9/off",
                        "Conroe", NULL, "pc-i440fx-2.9",
-- 
2.34.1


