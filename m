Return-Path: <kvm+bounces-71421-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Dn9I8CymGkVLAMAu9opvQ
	(envelope-from <kvm+bounces-71421-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 20:15:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A1316A4D9
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 20:15:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3C0B7305B94C
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 19:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C847366DDE;
	Fri, 20 Feb 2026 19:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dl4K9twK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBE53176EB;
	Fri, 20 Feb 2026 19:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771614892; cv=none; b=UsoMjsufmU9U0DM13AgMSwDAjTd6GN8ZcxKGHXPw15Tkg8PYD9qGZKz9LrD+aK9HTrOUeizrf74WHh8WygOodoetwh2A0Ft9q3X5bxdQV/oTgTJrtUIV2fPVQVenGmNpMw9VtyREoU3409LY5Q7XUZAQEz6+0zIUsDCb1/2UTmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771614892; c=relaxed/simple;
	bh=N/dul5YjHzDXPfrduHVCi4Yg6lOyDfk2HzDDWaV+YQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHkru+qcOA7XTY9aTxcw1oOesaN4Qm60W5/mcxnC8ELNN3kZH8e6o4MgHEJm48X7XbYs9yeODMeslRoJ2CXw1BXqyRNqFeQ8XdSeSdCLMalTfK6i7aerg/I9REYCggWvdjrPC5zA3w7hCzDBG/tsTrHEvlf3dpGmBrgjD6EO9Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dl4K9twK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA755C116C6;
	Fri, 20 Feb 2026 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771614892;
	bh=N/dul5YjHzDXPfrduHVCi4Yg6lOyDfk2HzDDWaV+YQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dl4K9twKTKk+64XuV3tx697p+tSKE4KpQAY+Nm3YF1p4RQ05z2krCL7vET+svQbq5
	 VG8ENPLrxvLm/+whZxz7wR4sSkpTeUfkYv0ng1u1YVUiDdnp8o8K/ltQpAb0sRhhOy
	 rXgnEi1fxdVV7wKy6o/+ac2dBU905VE6WwRTURFE2/UJPkevi35wRQJ3wcx8pxvJL3
	 qH7yoJBL8zTJatIySTsfhPDUB1BBxBRzyo1NKjJzbcnEssXaEJKTQi0Oye1uhAaXPh
	 P3BILrh7CooTpzS9Xd2cs8bvXzY3zgzfP1rVyzHWfNebJK+Q3V4jNuZh9AQyF9VNxU
	 mNL8AGmVqa1wA==
Date: Fri, 20 Feb 2026 11:14:49 -0800
From: Namhyung Kim <namhyung@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Mingwei Zhang <mizhang@google.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v6 42/44] KVM: VMX: Dedup code for adding MSR to VMCS's
 auto list
Message-ID: <aZiyqcd2V6Ncm6wY@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-43-seanjc@google.com>
 <aZdlBkLEQyv9q5ll@google.com>
 <aZe6UR1EGg0RcB69@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZe6UR1EGg0RcB69@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_MATCH_TO(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71421-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[namhyung@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E8A1316A4D9
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 08:46:07AM -0800, Sean Christopherson wrote:
> On Thu, Feb 19, 2026, Namhyung Kim wrote:
> > Hello,
> > 
> > On Fri, Dec 05, 2025 at 04:17:18PM -0800, Sean Christopherson wrote:
> > > Add a helper to add an MSR to a VMCS's "auto" list to deduplicate the code
> > > in add_atomic_switch_msr(), and so that the functionality can be used in
> > > the future for managing the MSR auto-store list.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++----------------------
> > >  1 file changed, 19 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 018e01daab68..3f64d4b1b19c 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -1093,12 +1093,28 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
> > >  	vm_exit_controls_setbit(vmx, exit);
> > >  }
> > >  
> > > +static void vmx_add_auto_msr(struct vmx_msrs *m, u32 msr, u64 value,
> > > +			     unsigned long vmcs_count_field, struct kvm *kvm)
> > > +{
> > > +	int i;
> > > +
> > > +	i = vmx_find_loadstore_msr_slot(m, msr);
> > > +	if (i < 0) {
> > > +		if (KVM_BUG_ON(m->nr == MAX_NR_LOADSTORE_MSRS, kvm))
> > > +			return;
> > > +
> > > +		i = m->nr++;
> > > +		m->val[i].index = msr;
> > > +		vmcs_write32(vmcs_count_field, m->nr);
> > > +	}
> > > +	m->val[i].value = value;
> > > +}
> > > +
> > >  static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> > >  				  u64 guest_val, u64 host_val)
> > >  {
> > >  	struct msr_autoload *m = &vmx->msr_autoload;
> > >  	struct kvm *kvm = vmx->vcpu.kvm;
> > > -	int i;
> > >  
> > >  	switch (msr) {
> > >  	case MSR_EFER:
> > > @@ -1132,27 +1148,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> > >  		wrmsrq(MSR_IA32_PEBS_ENABLE, 0);
> > >  	}
> > >  
> > > -	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> > > -	if (i < 0) {
> > > -		if (KVM_BUG_ON(m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> > > -			return;
> > > -
> > > -		i = m->guest.nr++;
> > > -		m->guest.val[i].index = msr;
> > > -		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
> > > -	}
> > > -	m->guest.val[i].value = guest_val;
> > > -
> > > -	i = vmx_find_loadstore_msr_slot(&m->host, msr);
> > > -	if (i < 0) {
> > > -		if (KVM_BUG_ON(m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> > > -			return;
> > > -
> > > -		i = m->host.nr++;
> > > -		m->host.val[i].index = msr;
> > > -		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
> > > -	}
> > > -	m->host.val[i].value = host_val;
> > > +	vmx_add_auto_msr(&m->guest, msr, guest_val, VM_ENTRY_MSR_LOAD_COUNT, kvm);
> > > +	vmx_add_auto_msr(&m->guest, msr, host_val, VM_EXIT_MSR_LOAD_COUNT, kvm);
> > 
> > Shouldn't it be &m->host for the host_val?
> 
> Ouch.  Yes.  How on earth did this escape testing...  Ah, because in practice
> only MSR_IA32_PEBS_ENABLE goes through the load lists, and the VM-Entry load list
> will use the guest's value due to VM_ENTRY_MSR_LOAD_COUNT not covering the bad
> host value.
> 
> Did you happen to run into problems when using PEBS events in the host?

No, I just found it by reading the patch.

> 
> Regardless, do you want to send a patch?  Either way, I'll figure out a way to
> verify the bug and the fix.

Sure, will do.

Thanks,
Namhyung


