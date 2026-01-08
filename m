Return-Path: <kvm+bounces-67339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BD0DCD00D0E
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:12:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 406B7304B06C
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79462BD01B;
	Thu,  8 Jan 2026 03:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qz911bZi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82542868AD
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841753; cv=none; b=FvGkWt3U4ypiKkWtK9ELyNx950W05+HQrWed8FNJsswykGn302lB4J3UwWorNSt6RtlVatROip/XCqlzsnv8b084eOPXt6y17auOaqAiwu/GfJUYSakdkTdk9aYKVOI/+pAO5TyK1bKX7Z0rvGiWfxG+r9uej4UuuSNMhGNYkV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841753; c=relaxed/simple;
	bh=kNYkiaNSgjNxHBpmze7LKKP0q9ceZ2SXtXvlRLGlXSo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tu4fCHthh41y6AbyqfL1adKTyYn8Ob5JnZQ28pk2ILM7/ARcpzG2bnRwAPNn+m7btC4+f3NlWmL3iXeMbsL0C9fXvHq+AIywCYxfF3/2kFqKWbgv3+iz4PAZOPo1OC1t4XlVtbPyGozT89WMrz8JyMDGULcDmD8zmL1qQyTVPFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qz911bZi; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841751; x=1799377751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kNYkiaNSgjNxHBpmze7LKKP0q9ceZ2SXtXvlRLGlXSo=;
  b=Qz911bZioFpgJr7hd0O5vO/aUp3YChPTuhxmRJVhyfkZ/oP4fSK91tdO
   wpRxLYUqb9I4LgER8Mt+zp6BKKZGK42B4geULaDbI+9rV+Rx5EVV9fuYM
   /d63lYGfRsrN3lpnaILzY3830kqafha4EWuB0ZtdOTtR4Io2/tg1UAqel
   520+4b23tauQnmfTeUfSgJjwomKCGZQkVP1B8v44iuN8HTGdJWJxk+xIw
   L+UvcjPp1gs+fVjKbxOd4yGATRRUgWjwMvLO67jsf6eBj0Qg0cWRs6JRY
   eeuB5nN9/HdkDT7UeM7NSVRxniAZhL/XvhGjoy1J0oFV8fJ/Ukj1aRuth
   w==;
X-CSE-ConnectionGUID: hK6hkpKvTqKDSP7hwlQpyw==
X-CSE-MsgGUID: KJfwHJrFSdOfouXAj+7MCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877565"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877565"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:09:11 -0800
X-CSE-ConnectionGUID: tPOD766tROaPRuJG7KUpiQ==
X-CSE-MsgGUID: lx/Vopy/STe1TSWeU+qq0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202211235"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:09:02 -0800
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
Subject: [PATCH v6 23/27] hw/audio/pcspk: Remove PCSpkState::migrate field
Date: Thu,  8 Jan 2026 11:30:47 +0800
Message-Id: <20260108033051.777361-24-zhao1.liu@intel.com>
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

The PCSpkState::migrate boolean was only set in the
pc_compat_2_7[] array, via the 'migrate=off' property.
We removed all machines using that array, lets remove
that property, simplifying vmstate_spk[].

Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/audio/pcspk.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/hw/audio/pcspk.c b/hw/audio/pcspk.c
index 916c56fa4c0a..0b01544941cb 100644
--- a/hw/audio/pcspk.c
+++ b/hw/audio/pcspk.c
@@ -57,7 +57,6 @@ struct PCSpkState {
     unsigned int play_pos;
     uint8_t data_on;
     uint8_t dummy_refresh_clock;
-    bool migrate;
 };
 
 static const char *s_spk = "pcspk";
@@ -202,18 +201,10 @@ static void pcspk_realizefn(DeviceState *dev, Error **errp)
     }
 }
 
-static bool migrate_needed(void *opaque)
-{
-    PCSpkState *s = opaque;
-
-    return s->migrate;
-}
-
 static const VMStateDescription vmstate_spk = {
     .name = "pcspk",
     .version_id = 1,
     .minimum_version_id = 1,
-    .needed = migrate_needed,
     .fields = (const VMStateField[]) {
         VMSTATE_UINT8(data_on, PCSpkState),
         VMSTATE_UINT8(dummy_refresh_clock, PCSpkState),
@@ -224,7 +215,6 @@ static const VMStateDescription vmstate_spk = {
 static const Property pcspk_properties[] = {
     DEFINE_AUDIO_PROPERTIES(PCSpkState, audio_be),
     DEFINE_PROP_UINT32("iobase", PCSpkState, iobase,  0x61),
-    DEFINE_PROP_BOOL("migrate", PCSpkState, migrate,  true),
     DEFINE_PROP_LINK("pit", PCSpkState, pit, TYPE_PIT_COMMON, PITCommonState *),
 };
 
-- 
2.34.1


