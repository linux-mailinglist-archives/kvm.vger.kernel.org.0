Return-Path: <kvm+bounces-36536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 421DDA1B72B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F7D4165461
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C518B13CA97;
	Fri, 24 Jan 2025 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ujy2HHyh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC4743ACB
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737726012; cv=none; b=RXY+bPA143B6jIGEWdnAhM25fa6PYX4aLwGts+jhX1yo6FAv+5ci/PoAr5h8MJE9D2K75DjOajuTa9p5zZgRGVt2sOx7Vq3rsBrjS2cca6rfMI52oK0x0BewItuEuHI4LNdBiutZbLqoWxQvJxUfx+5terPiF/kA6sjdJuwyo+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737726012; c=relaxed/simple;
	bh=JEfor+KFxyDwdyWlWCn598DxuZ06/MpImTaZ99/kE0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UTeyzLEAFzFZbyTEAlhyDyVhMTUN4khQwUcnEAjMSQmPhifMLE9Cxht4Ha7o1/9MS/BGfmUSFLX3N+KUddlkR0Jw0SJ4moERCfrQvcWA6817At2NwZ+E7IcrCzTugjzwpazzGVxQnSlmUzsVL8zVaUXGa18RuL46/ppkQgLW7qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ujy2HHyh; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737726010; x=1769262010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JEfor+KFxyDwdyWlWCn598DxuZ06/MpImTaZ99/kE0M=;
  b=Ujy2HHyhW5EnLS5tkrHhCPVcZmip/ha6lIi9UgteAkydmWxxAp6zTK8U
   3HLIWXa2bUfrWqgM1aIw8vQON5wtbQSgNOOxthZsUKDRBwNiSGwstC6RL
   EH1sVIddS9Rr5GRKQGPTzjEE4TEMKRV8kKV6/5CUXlPWGzWQZ1WM5FVTc
   58FAMaAm6doLQVG5i9RRrjye7pQMkEXO+r0ejo1KWcfQwlTm7r7rfnbbX
   6QKMYepUsY3VeaSGgrkancTgBNvjMJxClNCLHBLvwWX7BAtn+1M5Gd01o
   DyqzWnjyE3a5pzL4kNjVsz+EFFUyWuUA75tB2b05VN23LkgPane8IeCrn
   A==;
X-CSE-ConnectionGUID: 35d2XMSuQxiag62msoih3Q==
X-CSE-MsgGUID: LFo+9KNtTd2ZlDRncYtvBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246650"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246650"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:40:10 -0800
X-CSE-ConnectionGUID: EOPIaBMERm+SQz+cyBhuXg==
X-CSE-MsgGUID: iOiNQdTETdqBQ0Emci0mmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804490"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:40:06 -0800
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
Subject: [PATCH v7 50/52] i386/tdx: Make invtsc default on
Date: Fri, 24 Jan 2025 08:20:46 -0500
Message-Id: <20250124132048.3229049-51-xiaoyao.li@intel.com>
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

Because it's fixed1 bit that enforced by TDX module.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 58ea6a4d3156..bb75eb06dad9 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -439,6 +439,9 @@ static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
 
     object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
 
+    /* invtsc is fixed1 for TD guest */
+    object_property_set_bool(OBJECT(cpu), "invtsc", true, &error_abort);
+
     x86cpu->enable_cpuid_0x1f = true;
 }
 
-- 
2.34.1


