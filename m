Return-Path: <kvm+bounces-57073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E3E6B4A86C
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5ADEA16C3BB
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44943081DC;
	Tue,  9 Sep 2025 09:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hh45fLlz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83102D6409;
	Tue,  9 Sep 2025 09:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410804; cv=none; b=qzwCpjedTtuOVWazn3Be/BWuDRTazpg2W8+7HIXQ7hjR1Jda/ao40XmqHEiX8JExQq0ZWyQ3FuIzv8j5uV4ZJSb0opCxjTNjab1F97jciuW01ZG3+QAOnN0KPfidj9tuEw9NdyXMwdF/uhhQtxMoiSyJ+JyTa10cVaFVlFdFb3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410804; c=relaxed/simple;
	bh=VP1WTWQxCS9TlgJCKb39srQIObO767Az9EF/mk/4CHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB9zfLK1ERb73d/tqEfnO61V2jIcY2JhZ4/jwC3W4RBOP3PrUVQMhy0EIhlKGysZGm8e/MJHt32emBFKmnUDwEwZIiKvdOlpLc0Si/FmPnR3+c9lLl9IiPLAL3e7nFQx6PdUKTGzO4w35ecmgnR+GcIvxGl0vcbCQ0XPileE3pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hh45fLlz; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410802; x=1788946802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VP1WTWQxCS9TlgJCKb39srQIObO767Az9EF/mk/4CHo=;
  b=hh45fLlzpM0RhQYHVsdxPf25Nwg8YWikdbgkizuLkoBVLyNYU/swu6nd
   G0vx5ompGMxwaI8xdgeJf5IyLBAcsDy5iUK7P0M47LIIZiT55CYgM58xF
   bzRuDFFA1qESSL0xvzWzLIlM5Iex0+zv2c+CHCr6y/OXrGW5uA9An2ZG1
   4IQ/5AgubhN30L/58tx95z2tozG9hgizt/Kc6z72FFx1s7iC4OnGXNVOM
   zedtaxwTIGxf6AZNfxwzfR5OJZHNkUKqvGKeyOEH225clDjWgGf2QrZAW
   MqvBRQkBWHmsrZsqmI4PxQeTyPX9FCKxry7+QQcJToDAOqZuqo6Mzps8/
   A==;
X-CSE-ConnectionGUID: MGta7htzTXe/ITcovlOzbw==
X-CSE-MsgGUID: fA7suPK5RJuz2JA1CoakEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307254"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307254"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:55 -0700
X-CSE-ConnectionGUID: 7w3l5ey9R++hR0k1hPWWAg==
X-CSE-MsgGUID: 9wwOur5jT6i+eAk4YN+tcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207412"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:56 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 09/22] KVM: VMX: Introduce CET VMCS fields and control bits
Date: Tue,  9 Sep 2025 02:39:40 -0700
Message-ID: <20250909093953.202028-10-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Control-flow Enforcement Technology (CET) is a kind of CPU feature used
to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
style control-flow subversion attacks.

Shadow Stack (SHSTK):
  A shadow stack is a second stack used exclusively for control transfer
  operations. The shadow stack is separate from the data/normal stack and
  can be enabled individually in user and kernel mode. When shadow stack
  is enabled, CALL pushes the return address on both the data and shadow
  stack. RET pops the return address from both stacks and compares them.
  If the return addresses from the two stacks do not match, the processor
  generates a #CP.

Indirect Branch Tracking (IBT):
  IBT introduces instruction(ENDBRANCH)to mark valid target addresses of
  indirect branches (CALL, JMP etc...). If an indirect branch is executed
  and the next instruction is _not_ an ENDBRANCH, the processor generates
  a #CP. These instruction behaves as a NOP on platforms that have no CET.

Several new CET MSRs are defined to support CET:
  MSR_IA32_{U,S}_CET: CET settings for {user,supervisor} CET respectively.

  MSR_IA32_PL{0,1,2,3}_SSP: SHSTK pointer linear address for CPL{0,1,2,3}.

  MSR_IA32_INT_SSP_TAB: Linear address of SHSTK pointer table, whose entry
			is indexed by IST of interrupt gate desc.

Two XSAVES state bits are introduced for CET:
  IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
  IA32_XSS:[bit 12]: Control saving/restoring supervisor mode CET states.

Six VMCS fields are introduced for CET:
  {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
  {HOST,GUEST}_SSP: Stores current active SSP.
  {HOST,GUEST}_INTR_SSP_TABLE: Stores current active MSR_IA32_INT_SSP_TAB.

On Intel platforms, two additional bits are defined in VM_EXIT and VM_ENTRY
control fields:
If VM_EXIT_LOAD_CET_STATE = 1, host CET states are loaded from following
VMCS fields at VM-Exit:
  HOST_S_CET
  HOST_SSP
  HOST_INTR_SSP_TABLE

If VM_ENTRY_LOAD_CET_STATE = 1, guest CET states are loaded from following
VMCS fields at VM-Entry:
  GUEST_S_CET
  GUEST_SSP
  GUEST_INTR_SSP_TABLE

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/vmx.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cca7d6641287..ce10a7e2d3d9 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -106,6 +106,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_LOAD_CET_STATE                  0x10000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -119,6 +120,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_CET_STATE                 0x00100000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
@@ -369,6 +371,9 @@ enum vmcs_field {
 	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
 	GUEST_SYSENTER_ESP              = 0x00006824,
 	GUEST_SYSENTER_EIP              = 0x00006826,
+	GUEST_S_CET                     = 0x00006828,
+	GUEST_SSP                       = 0x0000682a,
+	GUEST_INTR_SSP_TABLE            = 0x0000682c,
 	HOST_CR0                        = 0x00006c00,
 	HOST_CR3                        = 0x00006c02,
 	HOST_CR4                        = 0x00006c04,
@@ -381,6 +386,9 @@ enum vmcs_field {
 	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
 	HOST_RSP                        = 0x00006c14,
 	HOST_RIP                        = 0x00006c16,
+	HOST_S_CET                      = 0x00006c18,
+	HOST_SSP                        = 0x00006c1a,
+	HOST_INTR_SSP_TABLE             = 0x00006c1c
 };
 
 /*
-- 
2.47.3


