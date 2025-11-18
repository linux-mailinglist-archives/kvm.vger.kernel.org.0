Return-Path: <kvm+bounces-63481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A75E0C671F8
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9D9E23624ED
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E84324B39;
	Tue, 18 Nov 2025 03:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="er1KAPDx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2291D329C59
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436093; cv=none; b=sXnXG/BEiT5qRzltpYK+1IRN9MEPQsI9CMH4sITOMkz+M8vE5xQVusysAVmUI+KuwLhCLX2vrSWGfTwvVmaiHBO+SgEtqcLrIsV6bJUdYZ6MwodtL46h07D9RW4Bt/7qJQdR+6lShZZ9xdZCmR48vWi1EHn4ebzT5/o+qeIlyYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436093; c=relaxed/simple;
	bh=3n7M74aqCkbEbKfoKd8BocgrGmHYDsrLyL1GwMNnx9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HNurzNqyklMa1IWUia4NvyfIdDSkuKeVxW5iAsFeYuilJd30lnwxIs0WTWCXTbTHgb+cgVGxvHNdL1ff3kkCpvWLL9H1QLUfgxbF17+9Tf631kVtreJ8QLAOP+G87JFLVEiVmvLFdlMb0zlKU/YcXVqgxYh7HBlS42TqFw3VZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=er1KAPDx; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436091; x=1794972091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3n7M74aqCkbEbKfoKd8BocgrGmHYDsrLyL1GwMNnx9I=;
  b=er1KAPDxTw2+1xYjpP0O+JdA4HOXwk6uRZl9zF49wrqe4LMGZKEOz3v3
   yQrdlWBuZqePQ4SaB3LtuByYcZl/df9cAH1b8j2F1XzG/7ApXgo6Jv2hh
   iBUTDeb/Ag/iRyy9Qlo2rUWZxFI5/6JpyK5kzGPC+G2RfAwyhYQit/Zzc
   /0w5hSTz5iZ6en6a2HMS/uILI75kXw4gGLjFCRInI+XuYchi4o9OFtkZJ
   W5FKAeGLG/wYj6Cxuq8lb2xbhTLqiK1OF0EZY69g8eOPDus70JFmNvWkC
   vqqKvn/AQ8LrzGVUAVA1RqbI7CwBWI6UWr1JeUl8FW7BeZ0VKQsS71Zpk
   A==;
X-CSE-ConnectionGUID: z6OMiMTtQAePmo4nqRFO0g==
X-CSE-MsgGUID: kvpNVuA5S4aVRmamAWnoPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053936"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053936"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:31 -0800
X-CSE-ConnectionGUID: dWUJl04IQ1Wf6hyxk9tglg==
X-CSE-MsgGUID: dCgs5ufoR1mpahbrR5ykWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537425"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:21:27 -0800
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
Subject: [PATCH v4 21/23] i386/cpu: Enable cet-ss & cet-ibt for supported CPU models
Date: Tue, 18 Nov 2025 11:42:29 +0800
Message-Id: <20251118034231.704240-22-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118034231.704240-1-zhao1.liu@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add new versioned CPU models for Sapphire Rapids, Sierra Forest, Granite
Rapids and Clearwater Forest, to enable shadow stack and indirect branch
tracking.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index a65fd4111c31..84adfaf99dc8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5166,6 +5166,17 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ },
                 }
             },
+            {
+                .version = 5,
+                .note = "with cet-ss and cet-ibt",
+                .props = (PropValue[]) {
+                    { "cet-ss", "on" },
+                    { "cet-ibt", "on" },
+                    { "vmx-exit-save-cet", "on" },
+                    { "vmx-entry-load-cet", "on" },
+                    { /* end of list */ },
+                }
+            },
             { /* end of list */ }
         }
     },
@@ -5328,6 +5339,17 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ },
                 }
             },
+            {
+                .version = 4,
+                .note = "with cet-ss and cet-ibt",
+                .props = (PropValue[]) {
+                    { "cet-ss", "on" },
+                    { "cet-ibt", "on" },
+                    { "vmx-exit-save-cet", "on" },
+                    { "vmx-entry-load-cet", "on" },
+                    { /* end of list */ },
+                }
+            },
             { /* end of list */ },
         },
     },
@@ -5482,6 +5504,17 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ },
                 }
             },
+            {
+                .version = 4,
+                .note = "with cet-ss and cet-ibt",
+                .props = (PropValue[]) {
+                    { "cet-ss", "on" },
+                    { "cet-ibt", "on" },
+                    { "vmx-exit-save-cet", "on" },
+                    { "vmx-entry-load-cet", "on" },
+                    { /* end of list */ },
+                }
+            },
             { /* end of list */ },
         },
     },
@@ -5617,6 +5650,17 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .model_id = "Intel Xeon Processor (ClearwaterForest)",
         .versions = (X86CPUVersionDefinition[]) {
             { .version = 1 },
+            {
+                .version = 2,
+                .note = "with cet-ss and cet-ibt",
+                .props = (PropValue[]) {
+                    { "cet-ss", "on" },
+                    { "cet-ibt", "on" },
+                    { "vmx-exit-save-cet", "on" },
+                    { "vmx-entry-load-cet", "on" },
+                    { /* end of list */ },
+                }
+            },
             { /* end of list */ },
         },
     },
-- 
2.34.1


