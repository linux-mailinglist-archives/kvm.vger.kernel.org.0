Return-Path: <kvm+bounces-65711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E5399CB4D2B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0E0B6303C9D6
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353522C21E8;
	Thu, 11 Dec 2025 05:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j1HdGfOP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DD12C11FD
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431874; cv=none; b=RjX9zMiZNgRIitMaLceOAeIXQMvpQfZ8+DoUbb2ZnOakyDpfRfSPnwN8/1/c2Y9Z2Ed0VZfBpNEnWxCNaR5+4lMMJEuvGtb+/LcDeQqzrfnjzrUWQ+eYAvgylW80l6DP19u749NpgnX2Al87oTTFa1JKvVU5X2x/b8ofSl/PuVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431874; c=relaxed/simple;
	bh=kMqBy7CxyEmFl74t7tv9rzwXuI+1Gc0Y9duW9Lw4FqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Aid7oldG6Xdg7WWx4ghcBqLMSwCegUbORntwsYAx3OOZHHP6cYmlpISI92NHpgScYWdAAz9A326+8MNmOx83yPV9PlcNeoBEBE03yHhfqPzHQfvl9i8M+vevdtpmOfS2IlKCzrlqAQ3/7EZW6mt1vt63EYE3AXOGcFzVR8Yf5FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j1HdGfOP; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431873; x=1796967873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kMqBy7CxyEmFl74t7tv9rzwXuI+1Gc0Y9duW9Lw4FqE=;
  b=j1HdGfOPROUiNRR6vk7OuTgJBwWf8o7AMhUhiDAKLGMxxIAh6Hl/Ay3s
   9a5V2qQ4dJy3I4x9lj3V/aCiVr6+Nf4oL332NHN08TUW1xVqVrB9NhMVD
   jSgrGhNpLK/JJM1FK1x7A+hDk1E87QIJ2qJcie7D+36eyyXyDdWgOJzTk
   KbObIKq6/0DTNadZKtRaUKcY+zfquFpxzNZYjbEnvRTOl2Pv7AhZD3CGO
   QYW5Yq2hgd/PlWVh8s9UEEkbsjEhd9rC77xEpSSMZDb9hEJVshIUCzpgi
   oSODDqETKnzNtgezjwoGV7jBOyNgiP3G3nMBgmWAw6km0bu5EEDgCG8b8
   Q==;
X-CSE-ConnectionGUID: ekg0Bq21RpmLgL4141sH9A==
X-CSE-MsgGUID: WCxBW2vCQZyTpq4gixrIpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409974"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409974"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:33 -0800
X-CSE-ConnectionGUID: npxRuo/bQYKxhgAEhk0r1A==
X-CSE-MsgGUID: ULbuviDXShSRvC/7+CTZXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366231"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:29 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 18/22] i386/cpu: Mark cet-u & cet-s xstates as migratable
Date: Thu, 11 Dec 2025 14:07:57 +0800
Message-Id: <20251211060801.3600039-19-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211060801.3600039-1-zhao1.liu@intel.com>
References: <20251211060801.3600039-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cet-u and cet-s are supervisor xstates. Their states are saved/loaded by
saving/loading related CET MSRs. And there're the "vmstate_cet" and
"vmstate_pl0_ssp" to migrate these MSRs.

Thus, it's safe to mark them as migratable.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Add the flags in FEAT_XSAVE_XSS_LO.
---
 target/i386/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4d29e784061c..848e3ccbb8e3 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1484,7 +1484,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             .ecx = 1,
             .reg = R_ECX,
         },
-        .migratable_flags = XSTATE_ARCH_LBR_MASK,
+        .migratable_flags = XSTATE_CET_U_MASK | XSTATE_CET_S_MASK |
+            XSTATE_ARCH_LBR_MASK,
     },
     [FEAT_XSAVE_XSS_HI] = {
         .type = CPUID_FEATURE_WORD,
-- 
2.34.1


