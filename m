Return-Path: <kvm+bounces-4825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 287B0818B33
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 16:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE598B24E18
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68F41CA92;
	Tue, 19 Dec 2023 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fOdLkEN6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EB41CA83
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbd73a8b4d4so258124276.0
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 07:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702999561; x=1703604361; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NchLShD2hgLmbctHMk6jeJYyanAjb3bVNkH/vi4RQjQ=;
        b=fOdLkEN6Uw9DJiTlPsLPGqB4UN7qDr7HUyynuoeVMHTyK8XXiEi6zYXqINP6dZwRSc
         MSvdpbbf9qz8F48wIarEvxKJXCm5hUEJS28bgrpnTx4g8SJQT9//zC7VWTmBQMWxUUmB
         LM0QHwqqqcsgDue993S/LyoeZTtajSBMUAfbFUVYXPsVKo8m/P8VzfwN3GE4X+SWNhGC
         Mg8Xaei4XQuvI6JwlqP8rHFRIo8VF0LQOt+hRRUYlJ8e3GNOXEdb6RldaaP0HEAvDXzo
         ZzqFaC0y/0BJKBjDAlE8h/+Z2pWVswhqlLCM8StA1XD4c+1xHPTqUwWocqE7RVOVwT/N
         l0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702999561; x=1703604361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NchLShD2hgLmbctHMk6jeJYyanAjb3bVNkH/vi4RQjQ=;
        b=lVZghsfEQMmB2U6BE4LR207T0NKXrhTEG/yNiQjAWmN16ySiMjlWOxR7FnujYxciub
         OUtidAtb9HMhwYgtu9tb4T/m4PyALzjDjmzH+qVgHc27SKTmzSzcqNenFFyACbCes1da
         CovUhCCAkTfOcgpEbeHZAAT3TQJorr62gh+7M+5vuxctfhzx+atGeR4Pu5HSHmwhLk1m
         6hXYG2RBMffqcJqHFm5WteAx29z5N5ikKUv523nQIym+yaIoQD5A+nuV+gRUD/Z2axa4
         CSGy087koz2rCMTv3bQ7nYJWFzDza8RpU9peLoIKNQqCqSh9Ux+aq4qEswWpm2YVqhJp
         Q99w==
X-Gm-Message-State: AOJu0Yy5F99qTTawHgJrfQKnBLGf6OmPSDQOPOrBWNsTzUA76rrll5fO
	pRn8Yfitc5GKZgTzjIOonbPelNSyCO0=
X-Google-Smtp-Source: AGHT+IFe8yf9PXXd7Y/ZYqWD6OCo3rRZmRaDopu9f1++IOKu+CwVY6yz5UGrIuAsjHdiGYRQHPJpNXNwSiE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ef0c:0:b0:dbc:d4b6:1c3b with SMTP id
 g12-20020a25ef0c000000b00dbcd4b61c3bmr255514ybd.13.1702999561553; Tue, 19 Dec
 2023 07:26:01 -0800 (PST)
Date: Tue, 19 Dec 2023 07:26:00 -0800
In-Reply-To: <ZYFPsISS9K867BU5@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com> <ZYBhl200jZpWDqpU@google.com>
 <ZYEFGQBti5DqlJiu@chao-email> <CALMp9eSJT7PajjX==L9eLKEEVuL-tvY0yN1gXmtzW5EUKHX3Yg@mail.gmail.com>
 <ZYFPsISS9K867BU5@chao-email>
Message-ID: <ZYG2CDRFlq50siec@google.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Jim Mattson <jmattson@google.com>, Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, 
	pbonzini@redhat.com, eddie.dong@intel.com, xiaoyao.li@intel.com, 
	yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 19, 2023, Chao Gao wrote:
> On Mon, Dec 18, 2023 at 07:40:11PM -0800, Jim Mattson wrote:
> >Honestly, I think KVM should just disable EPT if the EPT tables can't
> >support the CPU's physical address width.
> 
> Yes, it is an option.
> But I prefer to allow admin to override this (i.e., admin still can enable EPT
> via module parameter) because those issues are not new and disabling EPT
> doesn't prevent QEMU from launching guests w/ smaller MAXPHYADDR.
> 
> >> Here nothing visible to selftests or QEMU indicates that guest.MAXPHYADDR = 52
> >> is invalid/incorrect. how can we say selftests are at fault and we should fix
> >> them?
> >
> >In this case, the CPU is at fault, and you should complain to the CPU vendor.
> 
> Yeah, I agree with you and will check with related team inside Intel.

I agree that the CPU is being weird, but this is technically an architecturally
legal configuration, and KVM has largely committed to supporting weird setups.
At some point we have to draw a line when things get too ridiculous, but I don't
think this particular oddity crosses into absurd territory.

> My point was just this isn't a selftest issue because not all information is
> disclosed to the tests.

Ah, right, EPT capabilities are in MSRs that userspace can't read.

> And I am afraid KVM as L1 VMM may run into this situation, i.e., only 4-level
> EPT is supported but MAXPHYADDR is 52. So, KVM needs a fix anyway.

Yes, but forcing emulation for a funky setup is not a good fix.  KVM can simply
constrain the advertised MAXPHYADDR, no? 

---
 arch/x86/kvm/cpuid.c   | 17 +++++++++++++----
 arch/x86/kvm/mmu.h     |  2 ++
 arch/x86/kvm/mmu/mmu.c |  5 +++++
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 294e5bd5f8a0..5c346e1a10bd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1233,12 +1233,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 *
 		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
 		 * provided, use the raw bare metal MAXPHYADDR as reductions to
-		 * the HPAs do not affect GPAs.
+		 * the HPAs do not affect GPAs.  Finally, if TDP is enabled and
+		 * doesn't support 5-level paging, cap guest MAXPHYADDR at 48
+		 * bits as KVM can't install SPTEs for larger GPAs.
 		 */
-		if (!tdp_enabled)
+		if (!tdp_enabled) {
 			g_phys_as = boot_cpu_data.x86_phys_bits;
-		else if (!g_phys_as)
-			g_phys_as = phys_as;
+		} else {
+			u8 max_tdp_level = kvm_mmu_get_max_tdp_level();
+
+			if (!g_phys_as)
+				g_phys_as = phys_as;
+
+			if (max_tdp_level < 5)
+				g_phys_as = min(g_phys_as, 48);
+		}
 
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 60f21bb4c27b..b410a227c601 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 	return boot_cpu_data.x86_phys_bits;
 }
 
+u8 kvm_mmu_get_max_tdp_level(void);
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c844e428684..b2845f5520b3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5267,6 +5267,11 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 	return max_tdp_level;
 }
 
+u8 kvm_mmu_get_max_tdp_level(void)
+{
+	return tdp_root_level ? tdp_root_level : max_tdp_level;
+}
+
 static union kvm_mmu_page_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				union kvm_cpu_role cpu_role)

base-commit: f2a3fb7234e52f72ff4a38364dbf639cf4c7d6c6
-- 

