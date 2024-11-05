Return-Path: <kvm+bounces-30671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F5909BC5A9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F94DB227A2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E621FDF99;
	Tue,  5 Nov 2024 06:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GTkkfB6i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAF81FDF96
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788743; cv=none; b=XuKtjYW94IxWnM4dWyDL4A4+S7G52vZPU2edJIunoI/oRht3Wb82rG7FxFa7IRTS6zo+g/F8zmuK1uyF8oyyNsxgDVD8cJfBvDfe5Z2XUdaNZSi+zMsQrnZ/FlVrgjBbrykvEVBRvXK3ML6LM7fvQvFBlbnLPtlvvc8K7+AEIuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788743; c=relaxed/simple;
	bh=mgYnaE32reSGuV7hHoP0EJIpwxMG8v5/dHOATY3+4xU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PZ4knF2y5F2w0l6UpbMQxFpLH17LThH5fJufL94uOGL735HuhWjLWmEz9Yu+QxbQp4Jo4rawnJDbFg68iQKVFpdFvJQVkiJWzXjuUOLk/k3GsE5TSARUAnOXMyibfWatHcSpoZgImL2uD0AFb68pVYPpJ/LmDPLtQrrWKBvTzpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GTkkfB6i; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788742; x=1762324742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mgYnaE32reSGuV7hHoP0EJIpwxMG8v5/dHOATY3+4xU=;
  b=GTkkfB6ih45rGuyu/NYjCZp26wSKro2/VSu9TBniUV3fe8Mx5aBrzPOU
   p1UZgJietI6RHeSV/Raml9sKhn8BtXHQVf5pVtMKnKErTJc+tZ7HElBw3
   DS8nITa1W1HYqJMhft2tsCNmv3Vsoi3WYRPojg/lQqj3zve8wVNIde3nl
   OPo5J0TJIOXQCgIreRu8Oe79NwRNK4iHDt0ogS1HcK17uEf1orRE7eqTD
   Adqz3/8WB9b6aBvrVfpiUWefwdvoixPevpOEXosb/Xah4aiQkaD1XbOQn
   JM8dNlGQGCbiqU3+7ZqP+YAwlBSM64cUIq70e6+MnZgpgbv6wKKQ/+ucq
   A==;
X-CSE-ConnectionGUID: 0+55poALRGCuKLSQcuRtVg==
X-CSE-MsgGUID: ySKmbfx9SDONc04wVycKGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689727"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689727"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:01 -0800
X-CSE-ConnectionGUID: OxDsKalzR/SUCZQoWpLyNQ==
X-CSE-MsgGUID: PurmE+u2Sx2SqBVZbB/RpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989457"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:57 -0800
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
Subject: [PATCH v6 37/60] i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
Date: Tue,  5 Nov 2024 01:23:45 -0500
Message-Id: <20241105062408.3533704-38-xiaoyao.li@intel.com>
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

TDX only supports readonly for shared memory but not for private memory.

In the view of QEMU, it has no idea whether a memslot is used as shared
memory of private. Thus just mark kvm_readonly_mem_enabled to false to
TDX VM for simplicity.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 19ce90df4143..00faffa891e4 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -372,6 +372,15 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -EOPNOTSUPP;
     }
 
+    /*
+     * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
+     * memory for shared memory but not for private memory. Besides, whether a
+     * memslot is private or shared is not determined by QEMU.
+     *
+     * Thus, just mark readonly memory not supported for simplicity.
+     */
+    kvm_readonly_mem_allowed = false;
+
     qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
 
     tdx_guest = tdx;
-- 
2.34.1


