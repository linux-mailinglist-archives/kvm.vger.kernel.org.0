Return-Path: <kvm+bounces-30660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B530A9BC59E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E76C01C2134A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1931FE103;
	Tue,  5 Nov 2024 06:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y6OLUQ4s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB8D1FE109
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788696; cv=none; b=U0Hn8nSE3opy8DKnI+MEvolyikXEy2QbGbQDhVmAjJUK4AaXQlt17SzlLycqFSkOUPNXHn+qqUcFlDUdGFn6uPf+AzgHINjrVbgZ2Zmp5zqLoomgVOaK0uGfdhurphb3Op9lzl0mAVEtndiJY792VwarK6ACUBhfq2+N75tpzaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788696; c=relaxed/simple;
	bh=lKT4R+z384ZnSwuZplcbwrI7VIz8YVlbaPogqTQylkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IbtjOlOi2pd7TW6HbvZiNhuQwv1breaugyjmstJAvHZTF70bj9cetOu8+kg7h8V1sdgobFCgXT6arVEnkowxtyrYUGlvXumaqg9yPyEQzh6BH1q+Y7R7EPZHwOQhoEZhUiZEDu85r63GmCQ9fFcWSRbVgnzDFDDtP7Bt6wirDMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y6OLUQ4s; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788695; x=1762324695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lKT4R+z384ZnSwuZplcbwrI7VIz8YVlbaPogqTQylkI=;
  b=Y6OLUQ4sc9CzBSTwewK7zbm7tsgL+oC0xhvI84+qWxebab0gYoQLVWbV
   Dms0NTqMeFTd4Fq8Qj2S8iV7u0ayo5aQHlZIDRskBlmcFhVgJya7tCG+Y
   DulWoAFX/MtreGNbBWtlV3zasMYPyGRONpimfjEDuR0RnFg63qar9etWG
   Um5kJOETultcjN50tB4i/RQJTWlaKt92YRZiKpGklDAVB4i+pvb1g2vPV
   s+iPUa/+KnZm5WFhF+e9ipdAAJ1HG3T+2F9oayKLwMYGTuWgF6LW7CwdU
   jgfJIotaCBmllsa8teETkw8ol4z0R07kWjwtuos4mvLe7GfYkhN7csgpf
   g==;
X-CSE-ConnectionGUID: I6SX2NRvRkOGES2nHqeRhA==
X-CSE-MsgGUID: LM/vXntPSqWqqWbvbS+4bA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689590"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689590"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:15 -0800
X-CSE-ConnectionGUID: fMPbZ0l5SYCOMqH44oNg1w==
X-CSE-MsgGUID: ghpoWLs8SMOi/kGwz41ALQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989055"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:11 -0800
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
Subject: [PATCH v6 26/60] i386/tdx: Call KVM_TDX_INIT_VCPU to initialize TDX vcpu
Date: Tue,  5 Nov 2024 01:23:34 -0500
Message-Id: <20241105062408.3533704-27-xiaoyao.li@intel.com>
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

TDX vcpu needs to be initialized by SEAMCALL(TDH.VP.INIT) and KVM
provides vcpu level IOCTL KVM_TDX_INIT_VCPU for it.

KVM_TDX_INIT_VCPU needs the address of the HOB as input. Invoke it for
each vcpu after HOB list is created.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 0a6ac62de7ff..1abca7a5be6d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -250,6 +250,22 @@ static void tdx_init_ram_entries(void)
     tdx_guest->nr_ram_entries = j;
 }
 
+static void tdx_post_init_vcpus(void)
+{
+    TdxFirmwareEntry *hob;
+    CPUState *cpu;
+    int r;
+
+    hob = tdx_get_hob_entry(tdx_guest);
+    CPU_FOREACH(cpu) {
+        r = tdx_vcpu_ioctl(cpu, KVM_TDX_INIT_VCPU, 0, (void *)hob->address);
+        if (r < 0) {
+            error_report("KVM_TDX_INIT_VCPU failed %s", strerror(-r));
+            exit(1);
+        }
+    }
+}
+
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
@@ -282,6 +298,8 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
 
+    tdx_post_init_vcpus();
+
     for_each_tdx_fw_entry(tdvf, entry) {
         struct kvm_tdx_init_mem_region region;
         uint32_t flags;
-- 
2.34.1


