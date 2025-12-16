Return-Path: <kvm+bounces-66093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 50349CC539D
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 22:36:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D7B8B30671D1
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 21:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A51533C507;
	Tue, 16 Dec 2025 21:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GLO7rFC1"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE47D325709;
	Tue, 16 Dec 2025 21:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765920918; cv=none; b=C9hDuUNQotABHJJvWQzbf/UaKl+cKSkMLuyedBw5yfgpkm7a6Iw1DHMrf1ftYskPl9cP0yWwTE+69t7g91gjFLFMOoFmeAr1DTPFvA+rq/7DXFrt4xovEldXyGzQ8x+JfWxKcBLYkItLFvpTpiwVk7itXYNaMH0HW1o66+SDUWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765920918; c=relaxed/simple;
	bh=jwdZ16Bo48bauDgtwzIV0I0eFRkyS2UvhlUPaYmhbVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jV3Xo4vtU6DTUqQ6fwfGN4PMG0lCBmWUUtp5WCPdJHuz9XAcTx4Qwaz/OE6KRQi+8EH3d5lfpBp1pjqSgE3yq84wu9kzFfcNvSLk89DwFXYzLZNRTb/XF7U57bLTrerC6SwYjHXcvLLMCU8trxP3DJOscgJHcJhkDvxhdQYRwmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GLO7rFC1; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 16 Dec 2025 21:34:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765920904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJRO2dQpGvZA59OENdKzmTC9Ddv5eSkJipIeZZu7aSo=;
	b=GLO7rFC1u7cq5WSocQorwwNuYymwfV/1uC2GqLEktpoJ4VItTGUzz9ZmCZp5VJPoHKl59F
	P5G7gOjT0Yy/T0px6RDe4Rz7jiCtLDIMNaw0eOUGJH3zrCAoWI20gfdPeSdLuSJDw8PCAf
	tWLNzT1sBqcyuHiZuI87Deqj/m5HSOw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 24/26] KVM: nSVM: Restrict mapping VMCB12 on nested
 VMRUN
Message-ID: <timpvklyyl5juo5ajjzuxwazc5w2t6ffcx7llnv6f2a5qzot3b@hnj3wqwtla6c>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
 <20251215192722.3654335-26-yosry.ahmed@linux.dev>
 <oims37p6hfw4d2ufyinvi44scy3rhmbvibsmi66cde4e4pnidb@ugwhcwtalghf>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oims37p6hfw4d2ufyinvi44scy3rhmbvibsmi66cde4e4pnidb@ugwhcwtalghf>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 16, 2025 at 04:35:04PM +0000, Yosry Ahmed wrote:
> On Mon, Dec 15, 2025 at 07:27:19PM +0000, Yosry Ahmed wrote:
> > All accesses to the VMCB12 in the guest memory on nested VMRUN are
> > limited to nested_svm_vmrun() and nested_svm_failed_vmrun(). However,
> > the VMCB12 remains mapped throughout nested_svm_vmrun().  Mapping and
> > unmapping around usages is possible, but it becomes easy-ish to
> > introduce bugs where 'vmcb12' is used after being unmapped.
> > 
> > Move reading the VMCB12 and copying to cache from nested_svm_vmrun()
> > into a new helper, nested_svm_copy_vmcb12_to_cache(),  that maps the
> > VMCB12, caches the needed fields, and unmaps it. Use
> > kvm_vcpu_map_readonly() as only reading the VMCB12 is needed.
> > 
> > Similarly, move mapping the VMCB12 on VMRUN failure into
> > nested_svm_failed_vmrun(). Inject a triple fault if the mapping fails,
> > similar to nested_svm_vmexit().
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 55 ++++++++++++++++++++++++++++-----------
> >  1 file changed, 40 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 48ba34d8b713..d33a2a27efe5 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1055,23 +1055,55 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm, struct vmcb *vmcb12)
> >  		kvm_queue_exception(vcpu, DB_VECTOR);
> >  }
> >  
> > -static void nested_svm_failed_vmrun(struct vcpu_svm *svm, struct vmcb *vmcb12)
> > +static void nested_svm_failed_vmrun(struct vcpu_svm *svm, u64 vmcb12_gpa)
> >  {
> > +	struct kvm_vcpu *vcpu = &svm->vcpu;
> > +	struct kvm_host_map map;
> > +	struct vmcb *vmcb12;
> > +	int r;
> > +
> >  	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
> >  
> 
> Ugh I missed leave_guest_mode() here, which means guest state won't be
> cleaned up properly and the triple fault won't be inject correctly if
> unmap fails. I re-introduced the bug I fixed earlier in the series :')
> 
> Should probably add WARN_ON_ONCE(is_guest_mode()) in
> __nested_svm_vmexit() since the caller is expected to
> leave_guest_mode().

Although none of the selftests or KUTs failed because of this, running
them again now I noticed a couple of WARNs firing, which is reassuring
because the problem is detectable. Namely:

In nested_svm_vmexit(), the WARN introduced earlier in the series:

	WARN_ON_ONCE(svm->vmcb != svm->nested.vmcb02.ptr);

In vcpu_enter_guest():

	/*
	 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
	 * update must kick and wait for all vCPUs before toggling the
	 * per-VM state, and responding vCPUs must wait for the update
	 * to complete before servicing KVM_REQ_APICV_UPDATE.
	 */
	WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
		     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));


Not sure why the latter fired, but probably due to is_guest_mode()
returning the wrong thing in some code path.

Anyway, with the following diff no WARNs are produced with the selftests
or KUTs:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7af701e92c81..58e168e8c1ee 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1039,6 +1039,8 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm, struct vmcb *vmcb12)
        struct vmcb *vmcb01 = svm->vmcb01.ptr;
        struct kvm_vcpu *vcpu = &svm->vcpu;

+       WARN_ON_ONCE(is_guest_mode(vcpu));
+
        svm->nested.vmcb12_gpa = 0;
        svm->nested.ctl.nested_cr3 = 0;

@@ -1075,6 +1077,8 @@ static void nested_svm_failed_vmrun(struct vcpu_svm *svm, u64 vmcb12_gpa)

        WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);

+       leave_guest_mode(vcpu);
+
        r = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
        if (r) {
                kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);


Sean, I will wait until you get a chance to look through the series, at
which point let me know how you want to proceed. I assume it'll depend
on whether or not other patches require a new version.

