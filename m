Return-Path: <kvm+bounces-51874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73F5AAFDF51
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 07:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60AF31BC0FA2
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D0A26B2D5;
	Wed,  9 Jul 2025 05:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JN2Y+4/F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB333266595;
	Wed,  9 Jul 2025 05:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752039510; cv=none; b=Pva0VpFPkl0RRlklL7geZiUuMmxjx06KS3i7Sy7xChy5+F6xuoTNzfshIE+N4V28Wva5zsXVnsk/HWDqVxnSUi8txslTRC5pMLEnJkUIVZ74SnFWO5n/73/e1IUACirWxGUiGYfjkylaYJwd3fFzMRuZWKvBg5sVCbVKS4YwCsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752039510; c=relaxed/simple;
	bh=0h93S0hTCY97SJb8L8gKNmgOYmyHQokDCYl7KXSivxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IO4s2VZHFBfpZyiA16s5aFc0ZP5MKgc9OPVL/12eErMTsQ8I5E92ncqd0PUKoPR/qD+Ti9QKXTMxNviwlXs5kEzhAa7+rmUNwH0BVkjg1Dc0Y37E8wGgMEMU4LlGEDCTwkg3naIkiDbba4WahstCKOU/b2W8RA5foFkU9zWshe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JN2Y+4/F; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752039509; x=1783575509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0h93S0hTCY97SJb8L8gKNmgOYmyHQokDCYl7KXSivxc=;
  b=JN2Y+4/FkyQqCqR4856BoXna/M+LiiQuFSPeP1I99Nc3R9haWU774ROx
   sVylAsFIla7yWI6gsydfqhIfexcBYt26AErVjqEPnzSwfGZVwpqjG6IMN
   7TTZ+Icij9X55fzs2Ze4ZLN2qQJsf+LbnxvDw/Alc/qXQfBk8HkeINwkR
   Z7+te9fE10z50BVQVUMHKhO0QNzcrN5uR7oYirC+RwR0rW5za3A41lXsI
   o9WF08qPEFT0UBbAYfHjoWevDRVYQKkeLT/A8hUVI3OxC6S32tKePVWTy
   r206HnvX/xYSUaNRlBFSPjsM/4DcycVQ9g8DeiXlJsbtkzdWJxCYlo9Nb
   w==;
X-CSE-ConnectionGUID: a87UIJ2hTeCP6/xGLFGNhA==
X-CSE-MsgGUID: aLXtyCx1Q/KvC/tWIBZMtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="64871164"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="64871164"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 22:38:26 -0700
X-CSE-ConnectionGUID: hrYDO1j0SlmGD6we1AZhkw==
X-CSE-MsgGUID: tGoKvvynRJGfUkbZX6Iyug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155799370"
Received: from tjmaciei-mobl5.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.68])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 22:38:23 -0700
From: Kai Huang <kai.huang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	nikunj@amd.com,
	bp@alien8.de,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC protected guest
Date: Wed,  9 Jul 2025 17:37:59 +1200
Message-ID: <8aebb276ab413f2e4a6512286bd8b6def3596dfe.1752038725.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1752038725.git.kai.huang@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject KVM_SET_TSC_KHZ vCPU ioctl if guest's TSC is protected and not
changeable by KVM.

For such TSC protected guests, e.g. TDX guests, typically the TSC is
configured once at VM level before any vCPU are created and remains
unchanged during VM's lifetime.  KVM provides the KVM_SET_TSC_KHZ VM
scope ioctl to allow the userspace VMM to configure the TSC of such VM.
After that the userspace VMM is not supposed to call the KVM_SET_TSC_KHZ
vCPU scope ioctl anymore when creating the vCPU.

The de facto userspace VMM Qemu does this for TDX guests.  The upcoming
SEV-SNP guests with Secure TSC should follow.

Note this could be a break of ABI.  But for now only TDX guests are TSC
protected and only Qemu supports TDX, thus in practice this should not
break any existing userspace.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2806f7104295..699ca5e74bba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6186,6 +6186,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		u32 user_tsc_khz;
 
 		r = -EINVAL;
+
+		if (vcpu->arch.guest_tsc_protected)
+			goto out;
+
 		user_tsc_khz = (u32)arg;
 
 		if (kvm_caps.has_tsc_control &&
-- 
2.50.0


