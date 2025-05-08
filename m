Return-Path: <kvm+bounces-45955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDE6AAFF15
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86CEC7BEA76
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B7227F730;
	Thu,  8 May 2025 15:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LDmZb5bj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE37128851B
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716857; cv=none; b=NTL2sLtODn/u5fiEZCHuOY92unD6THmnrnaUiFv3UDh8wd2lxfU+iTlHbewtANNBVwg70WjRqJJbOMXKPc+TaYwQ0J2z9bo+Cu9chd4kVLkREK7hL7dI7i4smbPCFWVBTsDsF1CV1jfdVd8eE6TUCvMAIryf5NtDVebe+Cs2t/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716857; c=relaxed/simple;
	bh=b1SbeFmnllB8wUgT5dzRNfABN3PxHQ5LHq5YrQk93vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVaWQB/leHIS95FTFVdbVS2SC/d5WaLtQNZpKMCgXbPAAz+gh0sW0ouI5fZz8rmwbJm+E1G1wpg46qihzzovfwHxA298biUjpGQfOS9CX/ycdPyhZcBR6R1tdvgr32NxMPaS6h6Bco5xQZZ482HktsRDYzEcM7ZIY10r2h+kuLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LDmZb5bj; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716856; x=1778252856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b1SbeFmnllB8wUgT5dzRNfABN3PxHQ5LHq5YrQk93vk=;
  b=LDmZb5bjaVsfLVx05NGqNyM5GGpylajGJPQoyH7DGnwMVqhhoxM3yYP8
   IpBk9CLeF7xbqZUgrmlYoXZdsDg9suXYh2qxxbskns5mU8nDWQguNtlyn
   yr/TPvl+i1TncG0yxg2py3jZL0FuwFn8+vYe5z53rpXTxYHVT0YJ2JL8L
   VvJDSDcB8MS52c+ve5qtUcJ6BqF6nOUgl5y5L63zxZBGEB+sDeVCfpCed
   9oOg5eJYgzdknrv4RuH7ByBITTW5zFCuUFLG6yIz2epZs02DUiKBd9pTJ
   m8CdniOugoFUDvNxXVtdux0akwTpf0OlfVDvdpHzASSCepezPBxHu+GOc
   A==;
X-CSE-ConnectionGUID: bkaod0SzSwSYbPvbBXdpTA==
X-CSE-MsgGUID: 7TsXSxMbQYObfv3jML6zkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58716552"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="58716552"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:36 -0700
X-CSE-ConnectionGUID: eKOy1hEIQEef4f1/Gas8og==
X-CSE-MsgGUID: ABm/70Z8T+C7RvPtmtfJsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440560"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:33 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 52/55] i386/tdx: Don't treat SYSCALL as unavailable
Date: Thu,  8 May 2025 10:59:58 -0400
Message-ID: <20250508150002.689633-53-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Intel CPU, the value of CPUID_EXT2_SYSCALL depends on the mode of
the vcpu. It's 0 outside 64-bit mode and 1 in 64-bit mode.

The initial state of TDX vcpu is 32-bit protected mode. At the time of
calling KVM_TDX_GET_CPUID, vcpu hasn't started running so the value read
is 0.

In reality, 64-bit mode should always be supported. So mark
CPUID_EXT2_SYSCALL always supported to avoid false warning.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
 - Add commit message;

Changes in v7:
 - fix CPUID_EXT2_SYSCALL by adding it to actual;
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index aa1bab644352..e9c680b74040 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -852,6 +852,19 @@ static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
             continue;
         }
 
+        /* Fixup for special cases */
+        switch (w) {
+        case FEAT_8000_0001_EDX:
+            /*
+             * Intel enumerates SYSCALL bit as 1 only when processor in 64-bit
+             * mode and before vcpu running it's not in 64-bit mode.
+             */
+            actual |= CPUID_EXT2_SYSCALL;
+            break;
+        default:
+            break;
+        }
+
         requested = env->features[w];
         unavailable = requested & ~actual;
         mark_unavailable_features(cpu, w, unavailable, unav_prefix);
-- 
2.43.0


