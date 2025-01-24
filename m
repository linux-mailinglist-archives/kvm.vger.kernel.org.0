Return-Path: <kvm+bounces-36524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A0B84A1B719
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15FC47A5703
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F241459E0;
	Fri, 24 Jan 2025 13:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BwCmoqOJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892A67080B
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725967; cv=none; b=okh45gQViET7nEqZ0NZat/irDjWkn9Ymx/dW/FEgEvwq1oCnTPaVlI8xiC43RP6ybkw/EMUAYJEt02TJLrs7vRWmp5BymQNQbBTuhY6+7uonX8l4LSdJf6Y2kFmJ+rtJ8PK9SivU0Yutbl7LrcGcUB7mApTFoQJawGbfjCv8zT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725967; c=relaxed/simple;
	bh=Td2pdCuaEFQpSTTH/BdQkkMIQipWLW2UwdU/17m7eU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aFIcsC8a5YwDJMbah+1MmVY56Wo4NBRNoDTxvI9jzJ3Tc84q6qnt8Oyhf0a3swXYRV9uDI26XAAf/eo5jeDue9emPC/0Q01mAItAQHpk5pwlgIu/rSkZmFcE1V4r3S1McOlmMFwlYZzFFDWtgO/m6yGY+hBkxRLhffhxaIvQ3S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BwCmoqOJ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725966; x=1769261966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Td2pdCuaEFQpSTTH/BdQkkMIQipWLW2UwdU/17m7eU4=;
  b=BwCmoqOJGUjtQ9qrpYOdKeWSr7TpOw/aZrOdeUodWJG+ovBLU2Sywb35
   m8Qur8JpgstIGEmX1aFd/4Ll6Oqf7sKukhKW3kmWfN3hPxaat/Bh27XnR
   u0QVaNZudHHk52/wP+kohnZlyQxhP06BO65O67jL6KJUSMlu9Yfvw8+q8
   Q7nhtJnOZ1nys6uCeTABo7oythO72MGkThP5D3dqNF1L7khljvGmky4Un
   ExShJN1tQtbVDNiwUbrCtN7YDQKwe3/aVOZuwV396/Rl7GsvM17pkG+2S
   A0VC+PmFPjJM611DXvhoRmlWBT1xTtB3Ljvup4dpBgAqFQ0ZRUecrhFTe
   Q==;
X-CSE-ConnectionGUID: o2ZXdML/T/+n38zRhlKQtA==
X-CSE-MsgGUID: 7ZOfi9v1TG2kak8+HcCMLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246530"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246530"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:26 -0800
X-CSE-ConnectionGUID: XGn4NuL3ROK2pqBS1b63dw==
X-CSE-MsgGUID: W1io1APpQqeNn+HtZxbpRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804428"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:21 -0800
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
Subject: [PATCH v7 38/52] i386/apic: Skip kvm_apic_put() for TDX
Date: Fri, 24 Jan 2025 08:20:34 -0500
Message-Id: <20250124132048.3229049-39-xiaoyao.li@intel.com>
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

KVM neithers allow writing to MSR_IA32_APICBASE for TDs, nor allow for
KVM_SET_LAPIC[*].

Note, KVM_GET_LAPIC is also disallowed for TDX. It is called in the path

  do_kvm_cpu_synchronize_state()
  -> kvm_arch_get_registers()
     -> kvm_get_apic()

and it's already disllowed for confidential guest through
guest_state_protected.

[*] https://lore.kernel.org/all/Z3w4Ku4Jq0CrtXne@google.com/

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/kvm/apic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 757510600098..a1850524a67f 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -17,6 +17,7 @@
 #include "system/hw_accel.h"
 #include "system/kvm.h"
 #include "kvm/kvm_i386.h"
+#include "kvm/tdx.h"
 
 static inline void kvm_apic_set_reg(struct kvm_lapic_state *kapic,
                                     int reg_id, uint32_t val)
@@ -141,6 +142,10 @@ static void kvm_apic_put(CPUState *cs, run_on_cpu_data data)
     struct kvm_lapic_state kapic;
     int ret;
 
+    if(is_tdx_vm()) {
+        return;
+    }
+
     kvm_put_apicbase(s->cpu, s->apicbase);
     kvm_put_apic_state(s, &kapic);
 
-- 
2.34.1


