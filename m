Return-Path: <kvm+bounces-18386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8550F8D4916
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 12:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B07B1F248B4
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 10:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A77A176190;
	Thu, 30 May 2024 10:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RrIOqPNT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A41D6F2FB
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 10:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717063259; cv=none; b=hubbAjXHDptWeyC0HMK0xW4kTYtA3h5M3XjX66ncacUzyPgrE9OGkLs3LZWdUQpNB6YNZi9UyfYJuD8+g66zOR0zSEF88WHRuKarPXsPpXGWt5T75vXzJ0g5ZHUfY6jWvvRXvFvOytEqzTnLiZZS1uq4UwgCMK2sJ69sZ890Uzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717063259; c=relaxed/simple;
	bh=znO68kctoXTm05SXOnOkWCHEq8CPUvXamn9nrKcDybU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mi4f6hIQ/i1Vtq+Fa0n7OZvJoA/36bqp6HatE2bThKqycKu7xopoK9uyz6M2b9tuz/yae0k54XbIjhyK7tE5ETmMSF1xYKKCPAt4OjsZBXhE7QaYTfVmdGEWXN8GfMHEW3C/ZtSK6s+Vb1DK1rGviyudegEdzFEroeTE7KaYc3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RrIOqPNT; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717063258; x=1748599258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=znO68kctoXTm05SXOnOkWCHEq8CPUvXamn9nrKcDybU=;
  b=RrIOqPNTjm+L32+qqQrMmRb8ASiYdwqAf8sOxJRqxWQ68Kr2xcgR0uAS
   02WLHEznnDdyf23/LCvpxT+jiN0WL0TY3Uy/XxJBN7N4IikD87ItmrPfn
   8zXS5vjaxs+/2t5FBJZ0svt8Y7smLvphSOhrbPZrvpk4+1gBjYWIz7dL9
   M30YE/dm7Up0MBXV68IgudmFeczt7BJbfyxRnd8fWfhpt5Bs4MC4zHdOp
   aEYY/mVfszM62pAxf+z5aDff2ZQzix8nH8wWE+JOwGp0MowQkRJSNSXPz
   KXWBFha2gM19KbelJ7GWL0nS+/wbM1uUJEFNiJ1WOOQPHcvQQivoThgMV
   Q==;
X-CSE-ConnectionGUID: VIyekKxhTqGl1o7w+255Ow==
X-CSE-MsgGUID: Lt/liS93Tkik+CMu31MgyQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="31032598"
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="31032598"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 03:00:58 -0700
X-CSE-ConnectionGUID: neXIx/biQuuMsRJXYFHhLw==
X-CSE-MsgGUID: vImgdb6DR5m+pUdi65nqSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,201,1712646000"; 
   d="scan'208";a="35705138"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 30 May 2024 03:00:53 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 6/7] i386/pc: Support cache topology in -smp for PC machine
Date: Thu, 30 May 2024 18:15:38 +0800
Message-Id: <20240530101539.768484-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530101539.768484-1-zhao1.liu@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/pc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 7b638da7aaa8..2e03b33a4116 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1844,6 +1844,9 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     mc->nvdimm_supported = true;
     mc->smp_props.dies_supported = true;
     mc->smp_props.modules_supported = true;
+    mc->smp_props.l1_separated_cache_supported = true;
+    mc->smp_props.l2_unified_cache_supported = true;
+    mc->smp_props.l3_unified_cache_supported = true;
     mc->default_ram_id = "pc.ram";
     pcmc->default_smbios_ep_type = SMBIOS_ENTRY_POINT_TYPE_AUTO;
 
-- 
2.34.1


