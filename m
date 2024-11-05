Return-Path: <kvm+bounces-30673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B7E9BC5AB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CFF72832D8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33EF61FE0E0;
	Tue,  5 Nov 2024 06:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dc+6YsvU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF061FDFA3
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788751; cv=none; b=pmgKGdZLurB07F+GE03mkkxWBw/LvT6daSKZzwCPEY/ymYt0CG2wVk6XAZUpRSIUnW3D3X/KkMdMvedcZRJVOcCxvpleg25SEem69f+rA456zMBAVyAgrTXIvxx26VNIrLt0KD8btOSy4mpc0515tyDJA6HvV/bIgcWFiDrqNs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788751; c=relaxed/simple;
	bh=ETTKI5+hacWoJJE2C+uh6AGfusJHWOqz7xoddYnIUoE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hQT3fyawgKAxpQYKLdTYD0I0Gbe/ARm5IDlpdERm+pc9FVknTsaCrxB/d33Amc1Z/JgpAKBgU+r89+lrmTF5kKQzuk6qjMeLl+q+Yu5ExZP8IL1OrvSx/OrAE96UVxblSu0zphivUQzLYNmJjKNnVfY5Ym/IBJArVXecC3/3pro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dc+6YsvU; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788750; x=1762324750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ETTKI5+hacWoJJE2C+uh6AGfusJHWOqz7xoddYnIUoE=;
  b=Dc+6YsvUflwWrzCC3KHTnckWUUjzLl+gqmFKxxiDIozvGbYyoGlkNR5F
   bkPcVT4VVQsWt8t/EP109SYQOG0zQ1zkURlZceWOeEx/FHDRgfAZ0uoyO
   iCPipHMf7x3Z3toyDmbIjLuJe9RSMc0CJXlqjBnGsIkcLB+BcvJ8/pgpi
   4vt4puUXy1mNYUNLQhnQULBARYuSOivUI1HA91UN433n6PowKc2Av+Fvf
   2NZsdcUUtbrSXVJhAJ9He/cu4XdiuZ5vl2J52+EN5ndVMeJK28fZ+xbLR
   +HZWlpmEWxjsNQhx6uiqbCkE9xh+noOJLAQ1yDOV4rgSmAsH+KPT8Q5M6
   g==;
X-CSE-ConnectionGUID: RrmD8pycQSyP3Tpo1JW98g==
X-CSE-MsgGUID: VKID7HB4R8acpjR+z1+6cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689750"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689750"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:10 -0800
X-CSE-ConnectionGUID: aHXP1H8NQpSpWutRAMliPQ==
X-CSE-MsgGUID: 8S17/192T7WLzQnztIR5qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989534"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:06 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 39/60] i386/tdx: Disable PIC for TDX VMs
Date: Tue,  5 Nov 2024 01:23:47 -0500
Message-Id: <20241105062408.3533704-40-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy PIC (8259) cannot be supported for TDX VMs since TDX module
doesn't allow directly interrupt injection.  Using posted interrupts
for the PIC is not a viable option as the guest BIOS/kernel will not
do EOI for PIC IRQs, i.e. will leave the vIRR bit set.

Hence disable PIC for TDX VMs and error out if user wants PIC.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 68d90a180db7..9ab4e911f78a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -369,6 +369,13 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -EINVAL;
     }
 
+    if (x86ms->pic == ON_OFF_AUTO_AUTO) {
+        x86ms->pic = ON_OFF_AUTO_OFF;
+    } else if (x86ms->pic == ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM doesn't support PIC");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.34.1


