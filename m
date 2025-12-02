Return-Path: <kvm+bounces-65125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 044C5C9C148
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84E5D3A80F2
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222682820A4;
	Tue,  2 Dec 2025 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B5i9IucO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FF72765C4
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691459; cv=none; b=ZPowLO/X/aVN7li+mUG3DeyBt9v5zllRvgUUCggbHkWed60Fc/QuoFokp5w2LBzmV9FaESkPvbtG5cFydKf56C9fr3FXFdsQK06RT5zHxoiVjPmUw4Odhy/vhG0JKsW+AsnN/Vmw2YYuOxS/3I9sAZmqIeKPinf2JP5Y6BjKaDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691459; c=relaxed/simple;
	bh=FRrmV+SoZHgUnSI+cKxq36vwXjmiwjc/fhyRjGjnn8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m95awz+Lsro+SjPmc1B2rCsH5TgAzjdhuz+S+UKFs/f7NxovUS9JtEu0mcOKoUL90DnZq04WHasIFqsnfhNKEbqPUywRpfEKH4q7yZuj7xWq+CMMzDz+Wkz5NnKMR+pFp6D6OXysB42fGbAY1WxbTmUBxZd/uBtMSHdaOxJL6xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B5i9IucO; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691458; x=1796227458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FRrmV+SoZHgUnSI+cKxq36vwXjmiwjc/fhyRjGjnn8o=;
  b=B5i9IucOQ7TrWImHsgexaE9gALd3vN85E2NbFayNJxo+8JqPEYNd/wZg
   N+QmZgNreI39nWcRayprkYcRqP4mTkLMLE2CUgjfHKpQNg6T1e1GZ3Mqc
   RNwWZZ7cuhxJGQvU2DEwz2R74HBOVidxmmS07oI7vESmLJx8mDQJ5PesH
   jOyG161TYAxZsplZG61UP+mctp2HXZq6FanJciBiNJcxqp3D31W2Nnvg+
   oKSf7iRKH9g5cClt0okXxQi0XDhvIP5dJ7sQb1ymA4tlgalar8axPWNOg
   yr4hBm1W/2Pv24dHlGdHJwZrHpINQrKLDiR86QI5gbNjl9+1UR2O/99JR
   g==;
X-CSE-ConnectionGUID: +HksNYPsTt+KTkQKMxZDhQ==
X-CSE-MsgGUID: MUHK1cpNTzSxt41Q6Z29MQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142230"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142230"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:04:17 -0800
X-CSE-ConnectionGUID: 0S0hPeOORAazOXg5pbjX5w==
X-CSE-MsgGUID: 5BNztvnKSCiMJIGY7vHGmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199536907"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:04:08 -0800
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
Subject: [PATCH v5 01/28] hw/i386/pc: Remove deprecated pc-q35-2.6 and pc-i440fx-2.6 machines
Date: Wed,  3 Dec 2025 00:28:08 +0800
Message-Id: <20251202162835.3227894-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251202162835.3227894-1-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
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
deprecation & removal") they can now be removed.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/pc_piix.c | 14 --------------
 hw/i386/pc_q35.c  | 14 --------------
 2 files changed, 28 deletions(-)

diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 7b3611e973cd..4628d491d5b5 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -733,20 +733,6 @@ static void pc_i440fx_machine_2_7_options(MachineClass *m)
 
 DEFINE_I440FX_MACHINE(2, 7);
 
-static void pc_i440fx_machine_2_6_options(MachineClass *m)
-{
-    X86MachineClass *x86mc = X86_MACHINE_CLASS(m);
-    PCMachineClass *pcmc = PC_MACHINE_CLASS(m);
-
-    pc_i440fx_machine_2_7_options(m);
-    pcmc->legacy_cpu_hotplug = true;
-    x86mc->fwcfg_dma_enabled = false;
-    compat_props_add(m->compat_props, hw_compat_2_6, hw_compat_2_6_len);
-    compat_props_add(m->compat_props, pc_compat_2_6, pc_compat_2_6_len);
-}
-
-DEFINE_I440FX_MACHINE(2, 6);
-
 #ifdef CONFIG_XEN
 static void xenfv_machine_4_2_options(MachineClass *m)
 {
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 6015e639d7bc..0ae19eb9f1e4 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -681,17 +681,3 @@ static void pc_q35_machine_2_7_options(MachineClass *m)
 }
 
 DEFINE_Q35_MACHINE(2, 7);
-
-static void pc_q35_machine_2_6_options(MachineClass *m)
-{
-    X86MachineClass *x86mc = X86_MACHINE_CLASS(m);
-    PCMachineClass *pcmc = PC_MACHINE_CLASS(m);
-
-    pc_q35_machine_2_7_options(m);
-    pcmc->legacy_cpu_hotplug = true;
-    x86mc->fwcfg_dma_enabled = false;
-    compat_props_add(m->compat_props, hw_compat_2_6, hw_compat_2_6_len);
-    compat_props_add(m->compat_props, pc_compat_2_6, pc_compat_2_6_len);
-}
-
-DEFINE_Q35_MACHINE(2, 6);
-- 
2.34.1


