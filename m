Return-Path: <kvm+bounces-71409-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIfvK9+PmGnjJgMAu9opvQ
	(envelope-from <kvm+bounces-71409-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:46:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BEC169637
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5F5083006B77
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 16:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E54D2E5B09;
	Fri, 20 Feb 2026 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cYWqyF/m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20B91E2614
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 16:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771605971; cv=none; b=kc8heHoqjoROpfXElpm61z1s7oZGA/2kLLISZvXZ45nnBwsSLO12aC27JG+7wWwqD20f77V37l7ndND9iUtBjB/IfWM+Hney/B3o/IneKLDf7anbPn5C0bgxA5BS9/six3QHV4C7fz862k4EaOJbXD6hSdHtzpOp3vyhck/pS1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771605971; c=relaxed/simple;
	bh=RdADZ2qvOwFUII0e06TsD4htMLQmUhUg2PjK9uFPPJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FWDrJqDVqBi2hbqngnpjzukcG671cLsnPE5R32jaIiNQnBrk6elQo0JiTYg1KIFNWYwnJdx2Knrj83x46Eihfb2rkURoJsVnIU3L9TvCJEff421iBbzCT07hy0s4Jd3ZVcKzs4IwHLEbAIZaQs7TzASzIQL63D/GvXrpmMDEjP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cYWqyF/m; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a77040ede0so27844605ad.2
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 08:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771605969; x=1772210769; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2NjEt0nlzd3sSfAI7ozchxl45oY7orW7xyZnr6QEkg=;
        b=cYWqyF/mgvNrnp1ZM2SZLSWuqXeZbIEiVwXrEMzb2sbvMcAKv6NOvPJDvkyf7KJvS5
         InyEpxIutGhyHTN5Fga8wDmDfW3/8HRJLEhhIbTZTx8fIK332fBewfnvRRhbRNBAjt0g
         slND8AP4NBcsOA8mOOEs0+hvMsaSWn0Gh4N14cOmhdgG0iVXuhhpM5Sd3cwPr4+TN4Lm
         5I/RNxLoviWqZaCUM4DczB0zR9Tlf+ya0UNBKBO5VeSpcCPAYQkaX+t07QKt8GPBXDv/
         g9iUfiJpMWUhutJKzVndHxE87UgIVoHz6ICEePAArIJwVhOeUb+VsFyYXyy2eQBWJOs9
         2uMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771605969; x=1772210769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o2NjEt0nlzd3sSfAI7ozchxl45oY7orW7xyZnr6QEkg=;
        b=VnoXhYtM7ydfQdATKC8aunDr4mynBmzLaUFd/S045EaoaxC53+IUV1fnPzQn1kB6Kj
         Kj7X27yYUbmg1iTuUTDqfivIu3RWsWZimZtQp1UATZiQeGeLJZqyJ8+cUK22jMxww1aU
         i/D0SBqwIrIF/Xg+6Bp00pWGXa0dROUmnVSfNfAw2jBWcfViHkM6jU5G8hAq2VoBpJOl
         dR3+LLwEZwFNdNcIO4P+zdva2TWgS0S8le5I36EsBtT1m+lvFbLo7ISzsi5/lMzoMAO9
         ZUIhFKaANgOthXGht2H24mGbUh9EklLLo0Xy3W5PYFicaKfVSJeveuPAOkB+YE+4D6W9
         dPKA==
X-Forwarded-Encrypted: i=1; AJvYcCXQcuEubPRb5tj3/Pf4solgM+pcBgA1/FMjZXUWO/+w3kmTMyl166NkGIz0U9UriiCEfHU=@vger.kernel.org
X-Gm-Message-State: AOJu0YygFh0rBR8K0ua7GniYpjBOSdkl36FjtyzulJ1/yw2kLBQcgPva
	A5QHJP7KC652DNyzQPYc1dyYLf5GX+48pFceOlh2LwSUt4mE/xqj9AGvuPvsnuOKGS7JtKfsMiz
	i7/1v2A==
X-Received: from plma6.prod.google.com ([2002:a17:902:7d86:b0:2a9:622c:47d6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e80c:b0:2a1:388d:8ef3
 with SMTP id d9443c01a7336-2ad7444e7fcmr1749985ad.18.1771605969111; Fri, 20
 Feb 2026 08:46:09 -0800 (PST)
Date: Fri, 20 Feb 2026 08:46:07 -0800
In-Reply-To: <aZdlBkLEQyv9q5ll@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com> <20251206001720.468579-43-seanjc@google.com>
 <aZdlBkLEQyv9q5ll@google.com>
Message-ID: <aZe6UR1EGg0RcB69@google.com>
Subject: Re: [PATCH v6 42/44] KVM: VMX: Dedup code for adding MSR to VMCS's
 auto list
From: Sean Christopherson <seanjc@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71409-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 55BEC169637
X-Rspamd-Action: no action

On Thu, Feb 19, 2026, Namhyung Kim wrote:
> Hello,
> 
> On Fri, Dec 05, 2025 at 04:17:18PM -0800, Sean Christopherson wrote:
> > Add a helper to add an MSR to a VMCS's "auto" list to deduplicate the code
> > in add_atomic_switch_msr(), and so that the functionality can be used in
> > the future for managing the MSR auto-store list.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++----------------------
> >  1 file changed, 19 insertions(+), 22 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 018e01daab68..3f64d4b1b19c 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1093,12 +1093,28 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
> >  	vm_exit_controls_setbit(vmx, exit);
> >  }
> >  
> > +static void vmx_add_auto_msr(struct vmx_msrs *m, u32 msr, u64 value,
> > +			     unsigned long vmcs_count_field, struct kvm *kvm)
> > +{
> > +	int i;
> > +
> > +	i = vmx_find_loadstore_msr_slot(m, msr);
> > +	if (i < 0) {
> > +		if (KVM_BUG_ON(m->nr == MAX_NR_LOADSTORE_MSRS, kvm))
> > +			return;
> > +
> > +		i = m->nr++;
> > +		m->val[i].index = msr;
> > +		vmcs_write32(vmcs_count_field, m->nr);
> > +	}
> > +	m->val[i].value = value;
> > +}
> > +
> >  static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> >  				  u64 guest_val, u64 host_val)
> >  {
> >  	struct msr_autoload *m = &vmx->msr_autoload;
> >  	struct kvm *kvm = vmx->vcpu.kvm;
> > -	int i;
> >  
> >  	switch (msr) {
> >  	case MSR_EFER:
> > @@ -1132,27 +1148,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> >  		wrmsrq(MSR_IA32_PEBS_ENABLE, 0);
> >  	}
> >  
> > -	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> > -	if (i < 0) {
> > -		if (KVM_BUG_ON(m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> > -			return;
> > -
> > -		i = m->guest.nr++;
> > -		m->guest.val[i].index = msr;
> > -		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
> > -	}
> > -	m->guest.val[i].value = guest_val;
> > -
> > -	i = vmx_find_loadstore_msr_slot(&m->host, msr);
> > -	if (i < 0) {
> > -		if (KVM_BUG_ON(m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> > -			return;
> > -
> > -		i = m->host.nr++;
> > -		m->host.val[i].index = msr;
> > -		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
> > -	}
> > -	m->host.val[i].value = host_val;
> > +	vmx_add_auto_msr(&m->guest, msr, guest_val, VM_ENTRY_MSR_LOAD_COUNT, kvm);
> > +	vmx_add_auto_msr(&m->guest, msr, host_val, VM_EXIT_MSR_LOAD_COUNT, kvm);
> 
> Shouldn't it be &m->host for the host_val?

Ouch.  Yes.  How on earth did this escape testing...  Ah, because in practice
only MSR_IA32_PEBS_ENABLE goes through the load lists, and the VM-Entry load list
will use the guest's value due to VM_ENTRY_MSR_LOAD_COUNT not covering the bad
host value.

Did you happen to run into problems when using PEBS events in the host?

Regardless, do you want to send a patch?  Either way, I'll figure out a way to
verify the bug and the fix.

