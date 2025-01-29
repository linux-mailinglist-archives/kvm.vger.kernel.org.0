Return-Path: <kvm+bounces-36829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A104DA21A97
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 005E13A30F1
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E349B1B6547;
	Wed, 29 Jan 2025 09:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wo+JrTvO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1401B0F11;
	Wed, 29 Jan 2025 09:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144795; cv=none; b=NmxJEk3kZqBbqht2cFdW/cv1F4g8QC5oA5u5ARff/8K1CjLRT/P5BWTRKGrUuq6kjxwBqoKg3h8ya1NGFTGvHP1TBxjZZRTHj6ZoPu13wyf/2I1ip2sTjFp3+89ll7B+EYHVSl5zWYJClABywF3sQVc89uVunPsFr2dVg+N06yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144795; c=relaxed/simple;
	bh=4W+k7F8rltEb7FRA6LdbCMzAnGGInrQETpdXbUzNK9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRHqI0ceDknIW+lWohmzcnA9jJX9AJSBMiUkFi3U0oYkejPSS09Vvc1SYm5lCRQfXlafBASjmviHJOKQI5psabhgYHvMdGU8iZCj7waVHGzpnrXLI6CmFV/PVAT/51u79e7HVxGPQWGYci+BMR27Wc3QuKP+AImiKzTr9LZ8CNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wo+JrTvO; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144793; x=1769680793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4W+k7F8rltEb7FRA6LdbCMzAnGGInrQETpdXbUzNK9Y=;
  b=Wo+JrTvOyLPCn5Xu20ipfdR6ydwKgbaAKNQl7DYSDOY0qi8DcMTaK80C
   0rdE1RT62JN3BvVjTCF6tOEK5rP6xtGxs00O8b1H+yZgV7w93Fa+Q+mKK
   W4V4Z5W1kveihXxppvrRq65lflRxiB2v0hVkL0VLm2bQNlelC0TiMiSyJ
   EiZq/qDNM6XfRCG3E9FCB6KBKJNgIoSvHbNq3z1kwkLo/4G0Du2X+a1mP
   U2XnKbG9Oju0Jcp5k6SbSSoUJoXhuaDABdscDE6XIGjJAAOj2XtExC5Uu
   eL5RD6nGq4rWVsPyMBckCVytbwN4zvYzgrw1OU5eSHr/ZU44aV2u1lAVJ
   A==;
X-CSE-ConnectionGUID: FoJpwTEHSBOnXbfe/MM+cg==
X-CSE-MsgGUID: HffDNfJCQUK6UWz3GX6eYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50035998"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50035998"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:34 -0800
X-CSE-ConnectionGUID: szEJzDk5SiKPB192iHX+Cw==
X-CSE-MsgGUID: t8CTpE0ZTxWEjW71TcckMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262663"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:29 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH V2 03/12] KVM: TDX: Set arch.has_protected_state to true
Date: Wed, 29 Jan 2025 11:58:52 +0200
Message-ID: <20250129095902.16391-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129095902.16391-1-adrian.hunter@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

TDX VMs have protected state. Accordingly, set arch.has_protected_state to
true.

This will cause the following IOCTL functions to return an error:

	kvm_arch_vcpu_ioctl()	case KVM_GET_SREGS2
	kvm_arch_vcpu_ioctl()	case KVM_SET_SREGS2
	kvm_arch_vcpu_ioctl_get_regs()
	kvm_arch_vcpu_ioctl_set_regs()
	kvm_arch_vcpu_ioctl_get_sregs()
	kvm_arch_vcpu_ioctl_set_sregs()
	kvm_vcpu_ioctl_x86_get_debugregs()
	kvm_vcpu_ioctl_x86_set_debugregs
	kvm_vcpu_ioctl_x86_get_xcrs()
	kvm_vcpu_ioctl_x86_set_xcrs()

In addition, the following will error for confidential FPU state:

	kvm_vcpu_ioctl_x86_get_xsave ()
	kvm_vcpu_ioctl_x86_get_xsave2()
	kvm_vcpu_ioctl_x86_set_xsave()
	kvm_arch_vcpu_ioctl_get_fpu()
	kvm_arch_vcpu_ioctl_set_fpu()

And finally, in accordance with commit 66155de93bcf ("KVM: x86: Disallow
read-only memslots for SEV-ES and SEV-SNP (and TDX)"), read-only
memslots will be disallowed.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
TD vcpu enter/exit v2:
 - New patch
---
 arch/x86/kvm/vmx/tdx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ea9498028212..a7ebdafdfd82 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -553,6 +553,7 @@ int tdx_vm_init(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
+	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
 
 	/*
-- 
2.43.0


