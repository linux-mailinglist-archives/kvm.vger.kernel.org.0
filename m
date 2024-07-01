Return-Path: <kvm+bounces-20760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C566691D8E9
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:29:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F2B5280F11
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9F978C63;
	Mon,  1 Jul 2024 07:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="moDjIj4f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B3A6F076
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 07:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719818935; cv=none; b=OShsGaDx0aqApac0fsdU/rVDK52x7S25qrL9ChUEzgxZ568MkkoZXmE01/G3cFsPnsnOTkMr8w8142LOP8PvsZ0bJ4uv6MrRl8gOch4fSYXM3c8l28WLG39TdKkzRydJOPawRK6EBwoGjukq1BBRQzfW+rO2K1UQZJLcifSxnwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719818935; c=relaxed/simple;
	bh=WLgmrTY4QdDY85toOWC+nVIBypmmx5gQ9PJOsEQ2IwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGQaUpGaMHxN69z2DzPiTP+5rbWTlUm8IEOIAa/nF1b1lnKoYIzQ5B0haN+gkhpHk8IsMce6xe4aVOG7qzMbPjx0vg4niC/n3TrZYKWqX9BCOr0vKTNcobBxgPFKKqqsavuLQd4ZJeCmrxbniwBd1WOxM91MJN9FYG+CK+chxJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=moDjIj4f; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719818935; x=1751354935;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WLgmrTY4QdDY85toOWC+nVIBypmmx5gQ9PJOsEQ2IwM=;
  b=moDjIj4feLYSLUsX86oGY/C7gZlV6FWvlmIOU/kxNCfIBDXJBlPbU/uH
   1Now2ouHbdm5ttoyK0x4UkuA/AHwArJ1uR7ZthNNU97Mkw6pgDYlCPcUb
   SSJasLoYg1fEVcLUHttvhm/L7tsFbW4ozfMN1djU2NYkjlCav/MVp/P+o
   WtvV/AYOzcW1U9akEX60J/Pg6vBYGzrk4+/WChOV3ry+dPFo/ESmOOvSb
   P6dTn5lX5Kgdgd9AwrqcN+nDwL8XnjywSBkFuWDnfrNJwJxaV6LPSStQD
   3UfXFDYrwrx+GBf13gpOMUUdxzjH9GqUIxVQjVLhSSGUZg2mqk8Ig1kgB
   A==;
X-CSE-ConnectionGUID: Sg52LsGQQXS0LIQJTIsKIw==
X-CSE-MsgGUID: GmrN/WX2Tr29fJOcheD3Zg==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="34466038"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="34466038"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:28:54 -0700
X-CSE-ConnectionGUID: pBp1oYPLRJSUDgWKkC7xQw==
X-CSE-MsgGUID: jxjMQU5XQ+2zX6vv7OgKsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45520746"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:28:50 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	robert.hoo.linux@gmail.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v7 1/5] x86: Move struct invpcid_desc to processor.h
Date: Mon,  1 Jul 2024 15:30:06 +0800
Message-ID: <20240701073010.91417-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240701073010.91417-1-binbin.wu@linux.intel.com>
References: <20240701073010.91417-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move struct invpcid_desc to processor.h so that new test cases need
to do invpcid can use the definition.

Opportunistically add packed attribute, because according to C standard,
the allocation of storage unit for bit-field is implementation specific.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v7:
- New added.
---
 lib/x86/processor.h | 6 ++++++
 x86/pcid.c          | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index da1ed662..85a1781b 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -959,4 +959,10 @@ static inline void generate_cr0_em_nm(void)
 	fnop();
 }
 
+struct invpcid_desc {
+	u64 pcid : 12;
+	u64 rsv  : 52;
+	u64 addr : 64;
+} __attribute__((packed));
+
 #endif
diff --git a/x86/pcid.c b/x86/pcid.c
index c503efb8..7425e0fe 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -4,12 +4,6 @@
 #include "processor.h"
 #include "desc.h"
 
-struct invpcid_desc {
-    u64 pcid : 12;
-    u64 rsv  : 52;
-    u64 addr : 64;
-};
-
 static void test_pcid_enabled(void)
 {
     int passed = 0;
-- 
2.43.2


