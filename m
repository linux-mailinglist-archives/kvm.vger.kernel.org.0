Return-Path: <kvm+bounces-38974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DC1CA41606
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 08:12:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24E083AAE16
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 07:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB7B2405FC;
	Mon, 24 Feb 2025 07:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NRaOfJUY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E51918E377;
	Mon, 24 Feb 2025 07:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740381116; cv=none; b=RjIF9gV2u5iDfG2OcCF3TquoluWqcXbJuTuptPP9ZBCpXR2XCUD92XMiUOqyJHKQbdTqDGMxrzpx57qUs/68t+h7nXtqTSVEc8O4IzMWQmOisbWT0v4lauMb8g28dCw47nKt3cXzNIA0wu8IzFpvPsYbtNNssQPvpxhDxVuLatw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740381116; c=relaxed/simple;
	bh=cJ4uvByNNo5ilZ4fOxOhJYmTbMR72vGx4TCixPoYtgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buBnKdsYPqakGp/HqDmAZZD5aThH65Bp2EoQy1yBVvc0Z6DsYS6TrwH8PN6jRrleErLoNN6qBQ9cYT1vUERBx1U7Xp/oOWepwzgfT+XC+OSEhsN3t5vlmRI3QOm6bhX/vRfAz+Xp4tj5S2WIdXlZDXHQXEkCCjMFeJnAVR9/vuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NRaOfJUY; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740381115; x=1771917115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cJ4uvByNNo5ilZ4fOxOhJYmTbMR72vGx4TCixPoYtgo=;
  b=NRaOfJUY52T/MJBL6WbwiiIMYQby+bl3FigvyYnDWsJK9yc2hLajg3/D
   zET/mIkl0NjyqjQHN5ceFVb6kxS2Estv4Hd+N5r1mAWJkORjnNsOH8nST
   Vinh4v2nqqJ1VMV0KAsA9Xf+4Oq+K/f8RgxBWVRqi1NSKuRbTTZFIVXco
   Yr+Jjxw0CtdiB9n0OksSReJJxC0KkAizzt/cp8KH0Mco6bwKZU44ECHS5
   joEo4lTVXRfqf8dDHnZ7uKwea8+muUABcOJEUFEiHEZIPOadyZ7sb2k+9
   WywHR/QoAqIXY/uCigCH75LhZeXAJ1rLdBv8JSWJWHjj+f19dUiMo2s61
   A==;
X-CSE-ConnectionGUID: BvCbHr+BTZqVg6uWli7D8w==
X-CSE-MsgGUID: wheXqi9EQzuURENlRpg78w==
X-IronPort-AV: E=McAfee;i="6700,10204,11354"; a="41035934"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="41035934"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 23:11:54 -0800
X-CSE-ConnectionGUID: XSI66b0JQteYuCL4gKjAtA==
X-CSE-MsgGUID: 39oumnEfRXuoXLvPc1IICg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="121067677"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 23:11:52 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kevin.tian@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 3/3] KVM: TDX: Always honor guest PAT on TDX enabled platforms
Date: Mon, 24 Feb 2025 15:10:39 +0800
Message-ID: <20250224071039.31511-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250224070716.31360-1-yan.y.zhao@intel.com>
References: <20250224070716.31360-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Always honor guest PAT in KVM-managed EPTs on TDX enabled platforms by
making self-snoop feature a hard dependency for TDX and making quirk
KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT not a valid quirk once TDX is enabled.

The quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT only affects memory type of
KVM-managed EPTs. For the TDX-module-managed private EPT, memory type is
always forced to WB now.

Honoring guest PAT in KVM-managed EPTs ensures KVM does not invoke
kvm_zap_gfn_range() when attaching/detaching non-coherent DMA devices,
which would cause mirrored EPTs for TDs to be zapped, leading to the
TDX-module-managed private EPT being incorrectly zapped.

As a new platform, TDX is always with self-snoop feature supported and has
no worry to break old not-well-written yet unmodifiable guests. So, simply
make the quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT invalid on TDX enabled
platforms.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 Documentation/virt/kvm/api.rst | 20 +++++++++++---------
 arch/x86/kvm/vmx/main.c        |  1 +
 arch/x86/kvm/vmx/tdx.c         |  5 +++++
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c22211c2f54c..5954c5cde33d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8165,9 +8165,11 @@ KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
                                     be set by userspace (KVM sets them based on
                                     guest CPUID, for safety purposes).
 
-KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT  By default, on Intel platforms, KVM ignores
-                                    guest PAT and forces the effective memory
-                                    type to WB in EPT.  The quirk has no effect
+KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT  By default, on Intel platforms except TDX,
+                                    KVM ignores guest PAT and forces the
+                                    effective memory type to WB in EPT. The
+                                    quirk only affects the memory type of
+                                    KVM-managed EPTs.  The quirk has no effect
                                     when KVM runs on Intel platforms which are
                                     incapable of safely honoring guest PAT
                                     (i.e., without CPU feature self-snoop, KVM
@@ -8184,14 +8186,14 @@ KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT  By default, on Intel platforms, KVM ignores
                                     map the video RAM, causing wayland desktop
                                     to fail to start correctly). To prevent
                                     breaking older guest software, KVM enables
-                                    the quirk by default on Intel platforms.
-                                    Userspace can disable the quirk to honor
-                                    guest PAT when there is no older
+                                    the quirk by default on Intel platforms
+                                    except TDX. Userspace can disable the quirk
+                                    to honor guest PAT when there is no older
                                     unmodifiable guest software that relies on
                                     KVM to force memory type to WB.  Note, the
-                                    quirk is not visible on AMD's platforms,
-                                    i.e., KVM always honors guest PAT when
-                                    running on AMD.
+                                    quirk is not visible on Intel TDX or AMD's
+                                    platforms, i.e., KVM always honors guest PAT
+                                    when running on Intel TDX or AMD.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index f586e09b5acf..1fa0364faa60 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1092,6 +1092,7 @@ static int __init vt_init(void)
 		vcpu_align = max_t(unsigned, vcpu_align,
 				__alignof__(struct vcpu_tdx));
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_TDX_VM);
+		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
 	}
 
 	/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e73c9fcf213c..7d063cacc9c9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3483,6 +3483,11 @@ int __init tdx_bringup(void)
 		goto success_disable_tdx;
 	}
 
+	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
+		pr_err("Self-snoop is reqiured for TDX\n");
+		goto success_disable_tdx;
+	}
+
 	if (!kvm_can_support_tdx()) {
 		pr_err("tdx: no TDX private KeyIDs available\n");
 		goto success_disable_tdx;
-- 
2.43.2


