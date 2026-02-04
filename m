Return-Path: <kvm+bounces-70260-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AMkEGcuPg2lCpQMAu9opvQ
	(envelope-from <kvm+bounces-70260-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:28:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A13EBA3C
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8AC72300C5AC
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 18:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED6DD42315F;
	Wed,  4 Feb 2026 18:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wcb85d7v"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B3E254AFF
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 18:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770229622; cv=none; b=VqeirUX4+c+WDkYfud86SEiGANhxqkif/tySFJHOCwZ2HvHx7/ZEMZ9lFA3qvEKU8dqxftBceYAu5bnfcJvz+1bOobtEu75SEZjhydHQW/Hq/Q9J1uPmceD2HY54r98ENWNUaMGuY0GGXT/wUgiRdLE4O33ymMBojx1+ZI6sRUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770229622; c=relaxed/simple;
	bh=8P8G0/zKwgf2IDB+ADVcqz69tEXPTnuUp1z94KOCHJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=np12I7gmZ34sIFWkbQuMfWfJM2rI6Xwu5u9zXVN8tUaTFQKNIrcUFpKJdhijFIYSSs0LpGSo0syaiyAnuhPr1NkXb3wWLLMz/1uc4cPAxI9AUzW45MScz3NOKdGRLWMm7qC3a540KFMGADcSEVyLZP/aQ90zXTF7vsU78sTJlQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wcb85d7v; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 4 Feb 2026 18:26:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770229620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x4c3xbCcmz3+eEq4KYIEWC5hFRk2mUDLis3KT1gmtm8=;
	b=Wcb85d7vYJRWSLqc9FltynxbFHPvMpNJb65iigRI6j4yq/9+POINyzHdNilVexMDs9Oizz
	c456EVKK06it6F5WNMFS0/EkePDljiDZGaxNCFjmWRGPPhcjLhUngieCmqb0XxRogVD1tP
	Vl7NIY7nqsAYYOtJVhVbtBuiJSl5z0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: nSVM: Rename recalc_intercepts() to clarify
 vmcb02 as the target
Message-ID: <zqaboykgmtuknbmlvcl3cl7b2i6pbngwqasjgdvh5w2v4ygxhg@o3e2qqxrw7ab>
References: <20260112182022.771276-1-yosry.ahmed@linux.dev>
 <20260112182022.771276-3-yosry.ahmed@linux.dev>
 <aYOF0LNp173xAEsy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYOF0LNp173xAEsy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70260-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,linux.dev:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A2A13EBA3C
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 09:45:52AM -0800, Sean Christopherson wrote:
> On Mon, Jan 12, 2026, Yosry Ahmed wrote:
> > recalc_intercepts() updates the intercept bits in vmcb02 based on vmcb01
> > and (cached) vmcb12.
> 
> Ah, but it does more than that.  More below.
> 
> > However, the name is too generic to make this
> > clear, and is especially confusing while searching through the code as
> > it shares the same name as the recalc_intercepts callback in
> > kvm_x86_ops.
> > 
> > Rename it to nested_vmcb02_recalc_intercepts() (similar to other
> > nested_vmcb02_* scoped functions), to make it clear what it is doing.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c |  4 ++--
> >  arch/x86/kvm/svm/sev.c    |  2 +-
> >  arch/x86/kvm/svm/svm.c    |  4 ++--
> >  arch/x86/kvm/svm/svm.h    | 10 +++++-----
> >  4 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 2dda52221fd8..bacb2ac4c59e 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -123,7 +123,7 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
> >  	return false;
> >  }
> >  
> > -void recalc_intercepts(struct vcpu_svm *svm)
> > +void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
> >  {
> >  	struct vmcb *vmcb01, *vmcb02;
> >  	unsigned int i;
> 
> Drat, I should have responded to the previous patch.  Lurking out of sight is a
> pre-existing bug that effectively invalidates this entire rename.
> 
> The existing code is:
> 
>   void recalc_intercepts(struct vcpu_svm *svm)
>   {
> 	struct vmcb *vmcb01, *vmcb02;
> 	unsigned int i;
> 
> 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);  <======= not vmcb01!!!!!
> 
> 	if (!is_guest_mode(&svm->vcpu))
> 		return;
> 
> When L2 is active, svm->vmcb is vmcb02.  Which, at first glance, _looks_ right,
> but (the *horribly* named) recalc_intercepts() isn't _just_ recalculating
> intercepts for L2, it's also responsible for marking the VMCB_INTERCEPTS dirty
> (obviously).
> 
> But what isn't so obvious is that _all_ callers operate on vmcb01, because the
> pattern is to modify vmcb01 intercepts, and then merge the new vmcb01 intercepts
> with vmcb12, i.e. the "recalc intercepts" aspect is "part 2" of the overall
> function.

I think the 4th law of thermodynamics is that any piece of nSVM code has
a bug if you look at it long enough.

> 
> Lost in all of this is that KVM forgets to mark vmcb01 dirty, and unless there's
> a call buried somewhere deep, nested_svm_vmexit() isn't guaranteed to mark
> VMCB_INTERCEPTS dirty, e.g. if PAUSE interception is disabled.
> 
> It's probably a benign bug in practice, as AMD CPUs don't appear to do anything
> with the clean fields, but easy to fix.
> 
> As a bonus, fixing that bug yields for even better naming and code.  After the
> dust settles, we can end up with this in svm.h:
> 
>   void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm);
> 
>   static inline void svm_mark_intercepts_dirty(struct vcpu_svm *svm)
>   {
> 	vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_INTERCEPTS);
> 
> 	/*
> 	 * If L2 is active, recalculate the intercepts for vmcb02 to account
> 	 * for the changes made to vmcb01.  All intercept configuration is done
> 	 * for vmcb01 and then propagated to vmcb02 to combine KVM's intercepts
> 	 * with L1's intercepts (from the vmcb12 snapshot).
> 	 */
> 	if (is_guest_mode(&svm->vcpu))
> 		nested_vmcb02_recalc_intercepts(svm);
>   }
> 
> and this for nested_vmcb02_recalc_intercepts():
> 
>   void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
>   {
> 	struct vmcb_ctrl_area_cached *vmcb12_ctrl = &svm->nested.ctl;
> 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
> 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
> 	unsigned int i;
> 
> 	if (WARN_ON_ONCE(svm->vmcb != vmcb02))
> 		return;
> 
> 	...
>   }
> 
> with the only other caller of nested_vmcb02_recalc_intercepts() being
> nested_vmcb02_prepare_control().

I think this looks good. Definitely an improvement over what we
currently have :)

