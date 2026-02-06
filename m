Return-Path: <kvm+bounces-70448-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FIWJVAChmmyJAQAu9opvQ
	(envelope-from <kvm+bounces-70448-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:01:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 04CA3FF655
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:01:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3B1623009E25
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 15:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD9F2741B5;
	Fri,  6 Feb 2026 15:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gkl6lALX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA3C5B5AB
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390077; cv=none; b=t0paQLM/QNOulR/1lTwr9q/dCzrS35KP/+MG4DsZSWHJ0ClyLu29Ddgr+Uwzt+AMLWbWS2SATdmfVT1SpyMTl8LkCAfQ1a2/sCl0TgRXR3ErNgXRvNw2mRsaWAEGVzwhi754x9cEJBlnD5wsZMrgvC3Estca5rQG59zj4l1FHrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390077; c=relaxed/simple;
	bh=+0p5/2cxZHOIH3gdTEZejCJJDcduW40PMOoDLbWCWGs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CU49oOTNMykoer/zE8ndkUnppTTJJhtaAIaUUZlH3U14bs/sjPAbMp2JGIJ8hdybLLb51barUDtO/Yt59sNiWsA83EA4a+3e3vT2Nd1RwEWBvPw7xUSXJ2v9ZThypPZtvUIp1S6/QVjF7lUYmkoFTY+A82wCt4Li2dnzLrCr2FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gkl6lALX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3545b891dd1so4801697a91.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 07:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770390076; x=1770994876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BKp8ZbACqKocuJ3VqCzgsghWr3tFDD71E/QKe7BVqwM=;
        b=Gkl6lALXo7WYp+5/So4esR4pE0JRDkL3Dn4OtjQCz33pSn+E8X1UJ2aG7Q+ERgMkRs
         Oy/i9y7pAjJLeA8LaclXLKFcf9U1m2oiD198YzQMSCruo5HRT3iXkNIfYFs4pokVwnyf
         iYAYI4unkDBt+EHqJ0poEHCWdJLAJVFhsgrrc+CIcgma88CEQOqxC3Bbg9OWiCjL5Ix8
         TQGV224Qbek3Rf1nALIAwRcdshA7v10gpW8OQi0Nj8DILcDlMKOlCJcz9MchApvoZn0u
         KjOvpg0kb+oWyVHj2j4Kposg5kDEtKQKGUy510ZaYe+SKueQH0FiF2RY/HZ113nvdw8S
         aZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770390076; x=1770994876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BKp8ZbACqKocuJ3VqCzgsghWr3tFDD71E/QKe7BVqwM=;
        b=r4c+opFHAqq/WvfqYlTANnkwHWZlIigKXsN85J8yyCeRO3ishRR2FvL9UtuME8MXjX
         UCqrEoC8k3kYdr57uEjBTfoV2PjGuoVUC3TNFnnyzQRyOmRUuAdyp5jXJqDZn9q9vd9b
         s6owVKl5B4ffXljlF8CKEVhn2tn8Zy1p0mHWhuxLfR08we+6Xc3bZQnXNJs3jHjPwiT6
         Go53K5SqNYp7zHRjN0tfS0ehyJTh4nDFfgrgTjU2EnXTUIftEv5H0VkvpS8HyQJdm5pG
         1PPpZo27sHh0k+Y+W80fYbJCWUKlO2RZFQcHSHqF5yZC7GHsW/nYJR8YT2ZLADRYFkLi
         uTzw==
X-Forwarded-Encrypted: i=1; AJvYcCULwhCLhoSohH8BN8rYglAd/K8HRqF9PVmBG4wxbcdisIW7s307rtzsvvuz0mmyKxd+t74=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiYbqvyEruw30nfjQ+SVEFx0SAjyohebfwxl8kYbZH1G8ACCkZ
	uV05j4AJZ/a7S2A4dNWbfWX1gR8tt0yRChyv7D3nh9dTb7MbtoRoyY3EmAmjp7HiOZQyjyWij89
	yUOqRCA==
X-Received: from pjvc4.prod.google.com ([2002:a17:90a:d904:b0:340:c0e9:24b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e4e:b0:341:b5a2:3e7b
 with SMTP id 98e67ed59e1d1-354b3b7d70bmr2708644a91.4.1770390076562; Fri, 06
 Feb 2026 07:01:16 -0800 (PST)
Date: Fri, 6 Feb 2026 07:01:14 -0800
In-Reply-To: <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-21-seanjc@google.com>
 <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com>
Message-ID: <aYYCOiMvWfSJR1AL@google.com>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70448-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 04CA3FF655
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yan Zhao wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 18764dbc97ea..01e3e4f4baa5 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -55,7 +55,8 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> >  
> >  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
> >  {
> > -	free_page((unsigned long)sp->external_spt);
> > +	if (sp->external_spt)
> > +		kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
> >  	free_page((unsigned long)sp->spt);
> >  	kmem_cache_free(mmu_page_header_cache, sp);
> >  }
> Strictly speaking, external_spt is not a control page. Its alloc/free are
> different from normal control pages managed by TDX's code.

Yeah, I called that out in the changelog.  I'm definitley not wedded to
tdx_{alloc,free}_control_page(), but I am very much against tdx_{alloc,free}_page().

  (arguably S-EPT pages aren't "control" pages, but they're not guest pages either)

> (1) alloc
> tdx_alloc_control_page
>   __tdx_alloc_control_page
>     __tdx_pamt_get 
>       spin_lock(&pamt_lock)   ==> under process context
>       spin_unlock(&pamt_lock)
> 
> (2) free
> tdp_mmu_free_sp_rcu_callback
>   tdp_mmu_free_sp
>     kvm_x86_call(free_external_sp)
>      tdx_free_control_page
>         __tdx_free_control_page
>           __tdx_pamt_put
>             spin_lock(&pamt_lock)   ==> under softirq context
>             spin_unlock(&pamt_lock)
> 
> So, invoking __tdx_pamt_put() in the RCU callback triggers deadlock warning
> (see the bottom for details).

Hrm.  I can think of two options.  Option #1 would be to use a raw spinlock and
disable IRQs:

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 823ec092b4e4..6348085d7dcb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2246,7 +2246,7 @@ static u64 tdh_phymem_pamt_remove(u64 pfn, u64 *pamt_pa_array)
 }
 
 /* Serializes adding/removing PAMT memory */
-static DEFINE_SPINLOCK(pamt_lock);
+static DEFINE_RAW_SPINLOCK(pamt_lock);
 
 /* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
 int __tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache)
@@ -2272,7 +2272,7 @@ int __tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache)
        if (ret)
                goto out_free;
 
-       scoped_guard(spinlock, &pamt_lock) {
+       scoped_guard(raw_spinlock_irqsave, &pamt_lock) {
                /*
                 * Lost race to other tdx_pamt_add(). Other task has already allocated
                 * PAMT memory for the HPA.
@@ -2348,7 +2348,7 @@ void __tdx_pamt_put(u64 pfn)
        if (!atomic_dec_and_test(pamt_refcount))
                return;
 
-       scoped_guard(spinlock, &pamt_lock) {
+       scoped_guard(raw_spinlock_irqsave, &pamt_lock) {
                /* Lost race with tdx_pamt_get(). */
                if (atomic_read(pamt_refcount))
                        return;

--

Option #2 would be to immediately free the page in tdx_sept_reclaim_private_sp(),
so that pages that freed via handle_removed_pt() don't defer freeing the S-EPT
page table (which, IIUC, is safe since the TDX-Module forces TLB flushes and exits).

I really, really don't like this option (if it even works).

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ae7b9beb3249..4726011ad624 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2014,7 +2014,15 @@ static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
         */
        if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
            tdx_reclaim_page(virt_to_page(sp->external_spt)))
-               sp->external_spt = NULL;
+               goto out;
+
+       /*
+        * Immediately free the control page, as the TDX subsystem doesn't
+        * support freeing pages from RCU callbacks.
+        */
+       tdx_free_control_page((unsigned long)sp->external_spt);
+out:
+       sp->external_spt = NULL;
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
--

