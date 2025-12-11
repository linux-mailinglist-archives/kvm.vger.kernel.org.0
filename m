Return-Path: <kvm+bounces-65713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 96019CB4D0A
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9A94A30019EC
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012F32D24B6;
	Thu, 11 Dec 2025 05:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aweClT4O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB3A2C158E
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431882; cv=none; b=p7avLsWKFTAmN95Mq9izMSwx64VqjsNdL1fuqJtcvGpXXO0JM8U0dWzOwZP0NuNEKCqUfShIaDEFZCRZilQ1NHTq23MVSLWlYHaRf7x94scuq0hFP8d7g+BuLsZt6PJc216byZEBtXrJldy+IgtEnx4Xu+c3pDTpJDjSFbgxYZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431882; c=relaxed/simple;
	bh=3n7M74aqCkbEbKfoKd8BocgrGmHYDsrLyL1GwMNnx9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nhKa02MPTwtgyBRE0iSWP6rmJEG0fi+y7wpLXpZj0BIz9FUjZHbE47GFXiZ+Es9CwRoplKpR7Z7lVTAbIQlO0cLa9PBiLWEV110Zyi5F7/cKgh5L2HNXdAKJI/SOewDqV3sKYggwgSr84V1xldC5yzSvC64RZm9NRHnkzSaCX1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aweClT4O; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431881; x=1796967881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3n7M74aqCkbEbKfoKd8BocgrGmHYDsrLyL1GwMNnx9I=;
  b=aweClT4OKedhEe4djcjYinnR2hetdVXdGKgxC8A1RXdFjcDHIFcTeDd3
   UupDE886pWmfcILY0jCo/YfrWwlbviLy7Gzof5AMJXT4wp/pFMpDijNJG
   mokn4cIXT/S0tH47KS3+1trSb2i1+YcJMMYf7ZmWeQGz8i6Jz0uye2Y2J
   QWdOXllF4+Ap4UZlEpoNTiG25GRFEe+81DstzTFKl0osJZh/LjkyifvKs
   AoKTzk/M9IEgm+akMH0VbUKgDuPlzPCMAfIAHixhEeOqGcKAawef/i8Gu
   12RKxmRciT/ydU8u/GRI2h1X8ZaPClAiXeY/jR2jqvJzBrG/0p+wQSdpt
   A==;
X-CSE-ConnectionGUID: SqLzIcOZTzyzHB/WfvXjkQ==
X-CSE-MsgGUID: LkGOQW38Qo+5w+AROpXH6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409999"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409999"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:41 -0800
X-CSE-ConnectionGUID: To8OqnNtTYG1g9TZoEtznA==
X-CSE-MsgGUID: kSE9/iCvSb6AEMrKXA5BMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366241"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:37 -0800
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
Subject: [PATCH v5 20/22] i386/cpu: Enable cet-ss & cet-ibt for supported CPU models
Date: Thu, 11 Dec 2025 14:07:59 +0800
Message-Id: <20251211060801.3600039-21-zhao1.liu@intel.com>
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


