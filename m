Return-Path: <kvm+bounces-30691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEF19BC5BF
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDD721C20B89
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44151FEFBD;
	Tue,  5 Nov 2024 06:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hQteR0xV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C731FDFBB
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788827; cv=none; b=JfUx1Jl72DtRFiBmSy5BVPw8ohKGzCZd2A/qsSOuwcOkajYQy5B5pP9QRr51DavyflZOMdfW8086nfv1tZfVzYiodGlaeGd2N0h3spNE2+aiZvQpeqxIChYDdWc+vsgsSn6XZVmQG6ZDWyC50MmjwVjcw2UllSVj8rfZYIHID6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788827; c=relaxed/simple;
	bh=NKlDvzzDpP7N59sc27fzM1CZSPqI8zTcm+9UeKAwP8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fSC0wrGJSfzEHls+aGvynG2/gdmM6s0ER4VSoIx0Myc3Frs06Ov+4LmGAOXAklJ+pq2CeZZwwYIHG1bDmTV/IqsOfO5xTH83wuVpCkGmoURIbuc0UMqJ9oJcS7xFtEPFBajN/Mx7bgppTGpI3g14IkDD93PGBRsI2eIOC8st8sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hQteR0xV; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788826; x=1762324826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NKlDvzzDpP7N59sc27fzM1CZSPqI8zTcm+9UeKAwP8w=;
  b=hQteR0xV+v/PX5w7rjfNCQxUR5dXghCGA18Ma0973F6ZpUBUlR4AAW98
   YsWx3Z/CHZLYWetLE5/lb0avWbO1QyCpHjf0UmADstRr4vAOmL3HlYF41
   nV0kVg4DwyL95RUFW9+/9W4XxdaGdU2jYWa5d+inYdHNEUf7ZN9DlSo0b
   57LqmqNB4QwsYyhN0z0J4kVXIEMTDn7K7d+UYMTb7V3OdHRIpvjoOJ7u8
   qv1qdJ7JgzFGM1mVvYBR4A0Gut6XhgaVv7w8B9fdt2iQWMvx4vRwGFdaL
   hfgDhG37CKKfkXTxooNx2Ieq+nh6NZkSc0XGZXS1ZRwZq9CLl7zD3M0Rk
   w==;
X-CSE-ConnectionGUID: P6yX3spURx+clIjiSlNtRg==
X-CSE-MsgGUID: HPQFBOxiSECXJSUM1IetFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689938"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689938"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:40:26 -0800
X-CSE-ConnectionGUID: fMooDLw8TVGkCNYMWGss5g==
X-CSE-MsgGUID: Is1f+4fSQ9Kp08bHbbfQaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83990085"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:40:22 -0800
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
Subject: [PATCH v6 57/60] i386/tdx: Make invtsc default on
Date: Tue,  5 Nov 2024 01:24:05 -0500
Message-Id: <20241105062408.3533704-58-xiaoyao.li@intel.com>
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

Because it's fixed1 bit that enforced by TDX module.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 05475edf72bd..4cb1f4ac3479 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -430,6 +430,9 @@ static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
 
     object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
 
+    /* invtsc is fixed1 for TD guest */
+    object_property_set_bool(OBJECT(cpu), "invtsc", true, &error_abort);
+
     x86cpu->enable_cpuid_0x1f = true;
 }
 
-- 
2.34.1


