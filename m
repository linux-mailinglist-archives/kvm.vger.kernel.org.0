Return-Path: <kvm+bounces-36509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E011A1B708
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D606E188FA8F
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AD178C9C;
	Fri, 24 Jan 2025 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vll+XRTN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813FC288CC
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725914; cv=none; b=mYpLP2dioRXME/MVhzuAIjP2YdiCJbgarsqZvqGP3MqA8HFOPR9axESldKHniJu88lpW2NDGi2MsK2wkLT1qwK8o1FeQQ5CmXDtF90SESj05liWP13mFh8DKTwAUbzSffxV5vPgxUT+0YYf8wwESDv+JArwQkdJfdKxH6dFwByk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725914; c=relaxed/simple;
	bh=ySWxl1vh6c7+aWwfbxhZe7lL3q132WHVTO3Gm/JVrxs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AW/xYqvJnHwK1CTye8nL3iajnVGsso/H+6yqkbRtp/qarb3fj5pcej8LJc/Xt69mqDEhgWH+lS+qkwpqxl27g+PdCemsrieH9K9hMeb1NF5JHUCriBXHg9AXEiFo8gnRHdL5psotXAAEfgcP6t/4MV32jxwpd/AImFce/Oe+4ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vll+XRTN; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725913; x=1769261913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ySWxl1vh6c7+aWwfbxhZe7lL3q132WHVTO3Gm/JVrxs=;
  b=Vll+XRTNfNLfuFgQmnKPYAZ2+UKzkNTV1hwq6tL1jrWwzdbFw2eYENBA
   LAt2pVLQ/spV00qTMiVIasf5ifpv/a8kny719cnkGJJKE0oZLqGgTUNF7
   QXQ8uG+ugh5TK4Tfb86YPiWU1I4qrnwXP++BpFWvyv4AjJiuqJ/yHpoQt
   j/GmCq75+SDiQ1AfdfhpZIH44B4FcuBxBbYz5fDsM/tazJ3C6Lp3YLMK7
   SNeevpKpCmHueRouRtS2M3AU40PgiB0mIJfXOdJDLhU2OhV9hQtnzoh6p
   VfChVmq1lBuYQJYEKyk+lY9E9zR20E2ihtTUilnMH/aJ3z9xnbYmkmok7
   w==;
X-CSE-ConnectionGUID: EIIRIBFMQUSpa2xbOf9vUw==
X-CSE-MsgGUID: eT4kQppESUS1IMeQTLvQ/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246419"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246419"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:33 -0800
X-CSE-ConnectionGUID: 5YUxK08NRQau1c6UDXrcdw==
X-CSE-MsgGUID: YYL2jKnuTC+ghi0gVglBIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804317"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:28 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 24/52] i386/tdx: Call KVM_TDX_INIT_VCPU to initialize TDX vcpu
Date: Fri, 24 Jan 2025 08:20:20 -0500
Message-Id: <20250124132048.3229049-25-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX vcpu needs to be initialized by SEAMCALL(TDH.VP.INIT) and KVM
provides vcpu level IOCTL KVM_TDX_INIT_VCPU for it.

KVM_TDX_INIT_VCPU needs the address of the HOB as input. Invoke it for
each vcpu after HOB list is created.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 08320b59b62a..99c1664d836b 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -267,6 +267,18 @@ static void tdx_init_ram_entries(void)
     tdx_guest->nr_ram_entries = j;
 }
 
+static void tdx_post_init_vcpus(void)
+{
+    TdxFirmwareEntry *hob;
+    CPUState *cpu;
+
+    hob = tdx_get_hob_entry(tdx_guest);
+    CPU_FOREACH(cpu) {
+        tdx_vcpu_ioctl(cpu, KVM_TDX_INIT_VCPU, 0, (void *)hob->address,
+                       &error_fatal);
+    }
+}
+
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
@@ -300,6 +312,8 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
 
+    tdx_post_init_vcpus();
+
     for_each_tdx_fw_entry(tdvf, entry) {
         struct kvm_tdx_init_mem_region region;
         uint32_t flags;
-- 
2.34.1


