Return-Path: <kvm+bounces-5950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 28E0082913A
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF248B256A9
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0F6A52;
	Wed, 10 Jan 2024 00:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kFRcYVr4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E721F7EE
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 00:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbed8739c3aso3861979276.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 16:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704846224; x=1705451024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jX94VLx9ltQFhw3V1qWJ4WPVt8m5uqFAZ74Ysuxim9g=;
        b=kFRcYVr4x7Dxd59Xv69YEpk3apcb8vZ1CoC9RxzK+dpPy/ESW2833ogW/GcaiP9o7h
         Z3B7Qd1VbJMy65sF2kTmLO5GXCcAAX1v6sBT8y6aMs0nORsf3t4YrGIKEDjXi9O1qdcu
         r13kBhRmREvqJowZD7VMWipNwnGA4aBmRppmQpZcQ5RJRhaNNFGpbr+WkvVojekL3/FU
         FmlFXdavfWxypeq5EbREi0wEAbh4ZZVoGMwILYW2vNRoiQv1JmIYmDSpmdP/NE/GKn9O
         QyCK7Ro2m0eaISThu70U1e68f4xuI/rtFPWAF7CFDOB8kMxlCkhtRoeHhdZW2QNvK9tg
         8sAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704846224; x=1705451024;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jX94VLx9ltQFhw3V1qWJ4WPVt8m5uqFAZ74Ysuxim9g=;
        b=CzBGd0Lw6S8BsFOpJpwIPJWNwUUXMP7TMn9kDWB4dxIEjXDJ7kvTehttPYKDalVsN6
         BC5I0RtFZhwYwwoAIfdQZhIuDwYMOA5O4xBHSTCTHLYGYOI/aO1rDgFsCKES2YyKQ9tg
         iDZvBsYHE16+iUc6abKL5ZjSzV8J6BAUibtfl30hVvBay2/0eDFkhvbti+KlUZ68ywEI
         VTqU+6CZv6tF0qYpxJKcv62Lg7wZsbX24w5kJ2CLwhRKOwuSNR+KmCNrJQSR4NRwv1+X
         ftUfMZRLmLITXWWb4q/QsU+zY6cGkxDhFWrrVgS/3d9JXuFNROeuCQCujjOzUV17NvaK
         SAAQ==
X-Gm-Message-State: AOJu0YzpRNGqhZF0UmEt6o+DaR+/GWcEEeh5z0OTeMdPSjCeoJZGX/1y
	BecK/YRl/ndhntuQ0nMjKnrGivdWUXbjpauZbQ==
X-Google-Smtp-Source: AGHT+IHmGCf/Yc/5QY/OVN5dMC09KbL07TkUpA6mxvhd6FvJXWoh0NzkVtKJDTVft9fYCxrkKWPtkwJgngs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8686:0:b0:dbe:111b:8875 with SMTP id
 z6-20020a258686000000b00dbe111b8875mr6564ybk.12.1704846223913; Tue, 09 Jan
 2024 16:23:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 16:23:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110002340.485595-1-seanjc@google.com>
Subject: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support to userspace
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yi Lai <yi1.lai@intel.com>, Tao Su <tao1.su@linux.intel.com>, 
	Xudong Hao <xudong.hao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
enumerated via MSR, i.e. aren't accessible to userspace without help from
the kernel, and knowing whether or not 5-level EPT is supported is sadly
necessary for userspace to correctly configure KVM VMs.

When EPT is enabled, bits 51:49 of guest physical addresses are consumed
if and only if 5-level EPT is enabled.  For CPUs with MAXPHYADDR > 48, KVM
*can't* map all legal guest memory if 5-level EPT is unsupported, e.g.
creating a VM with RAM (or anything that gets stuffed into KVM's memslots)
above bit 48 will be completely broken.

Having KVM enumerate guest.MAXPHYADDR=48 in this scenario doesn't work
either, as architecturally guest accesses to illegal addresses generate
RSVD #PF, i.e. advertising guest.MAXPHYADDR < host.MAXPHYADDR when EPT is
enabled would also result in broken guests.  KVM does provide a knob,
allow_smaller_maxphyaddr, to let userspace opt-in to such setups, but
that support is firmly best-effort, i.e. not something KVM wants to force
upon userspace.

While it's decidedly odd for a CPU to support a 52-bit MAXPHYADDR but not
5-level EPT, the combination is architecturally legal and such CPUs do
exist (and can easily be "created" with nested virtualization).

Reported-by: Yi Lai <yi1.lai@intel.com>
Cc: Tao Su <tao1.su@linux.intel.com>
Cc: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

tip-tree folks, this is obviously not technically KVM code, but I'd like to
take this through the KVM tree so that we can use the information to fix
KVM selftests (hopefully this cycle).

 arch/x86/include/asm/vmxfeatures.h | 1 +
 arch/x86/kernel/cpu/feat_ctl.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index c6a7eed03914..266daf5b5b84 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -25,6 +25,7 @@
 #define VMX_FEATURE_EPT_EXECUTE_ONLY	( 0*32+ 17) /* "ept_x_only" EPT entries can be execute only */
 #define VMX_FEATURE_EPT_AD		( 0*32+ 18) /* EPT Accessed/Dirty bits */
 #define VMX_FEATURE_EPT_1GB		( 0*32+ 19) /* 1GB EPT pages */
+#define VMX_FEATURE_EPT_5LEVEL		( 0*32+ 20) /* 5-level EPT paging */
 
 /* Aggregated APIC features 24-27 */
 #define VMX_FEATURE_FLEXPRIORITY	( 0*32+ 24) /* TPR shadow + virt APIC */
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 03851240c3e3..1640ae76548f 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -72,6 +72,8 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 		c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_AD);
 	if (ept & VMX_EPT_1GB_PAGE_BIT)
 		c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_1GB);
+	if (ept & VMX_EPT_PAGE_WALK_5_BIT)
+		c->vmx_capability[MISC_FEATURES] |= VMX_F(EPT_5LEVEL);
 
 	/* Synthetic APIC features that are aggregates of multiple features. */
 	if ((c->vmx_capability[PRIMARY_CTLS] & VMX_F(VIRTUAL_TPR)) &&

base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0.472.g3155946c3a-goog


