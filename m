Return-Path: <kvm+bounces-2541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A42C7FAF35
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 01:43:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BDA3281B79
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 00:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F13110B;
	Tue, 28 Nov 2023 00:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GWBB4P9e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FB11AA
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 16:43:47 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5cb6271b225so73079227b3.1
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 16:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701132227; x=1701737027; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YtTNWHQr6JsZpzzdQO0pOMuuw3cl8zP4tz9k1AzI5bE=;
        b=GWBB4P9euSf2PsqBgmptV/iKxCZAc0B6rN4VZE2kxSEKpeqXCXZGLkzx0A2rXO+wIO
         WsWPXw+Q1aGQqVParwqKkhAdlHKh/RJu0Q8IQzCypugJASVoE/L2l5womAft5DQ9BFI/
         EcesBjCL36ES7czM00JNO0AdLMUQACkLsViiZ1KW+rvZMHWHSIgHn7Cp+v5wtEMQTkgg
         hMZmtAAhDUPPzJbgyFlyXkI5xyTO70E1LnRLASmn1W1HxGsQPXEwdqJBKBsJ6DMSuC2k
         kpsu18S6UnKGAEl+N29jQCnheaJjBCLnsNEbvcklqjg/AsZfiBFH1+mMVNATAZwz9hWL
         AO7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701132227; x=1701737027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YtTNWHQr6JsZpzzdQO0pOMuuw3cl8zP4tz9k1AzI5bE=;
        b=rfiOPAf9Lx0kNpV3mgTFexph67j8nZMy0iIRxcMIdrsxydynX/5/Temc9CQpNwMIqI
         wP+aYpHJjdUTsSuvA2ysERdXA7Z8syUPKrqSolxrhS8lfsXOmzyWBu23Ex1ZZcA0++cm
         nVO3aLC9KZUBMgBV5o5m+9/fkUPzhWUHKP/uBO+GUNCB+ng8mJTjKpIGLe+VtTfVnZAK
         aqr3CRypeVNY2+Ofdsi4QrJBYw5yowf2oRBji5RM4bGZd3CV97zY007oGhDyz/vLHeui
         NHWfnX5Ju+SzUHtbyh6PKBF3Bl0iBZhxMCVK2GqFQzrsul9lsqF4gK8Oj+3wXoHFPAV2
         G8Kg==
X-Gm-Message-State: AOJu0YwocqfdIie7bBa3A0JEYlj8D5BIxX6v4IiVvTsAwmcZlI2848vT
	HbRGc+2jmlS3klkKTA4IIfwlxWrA8Ag=
X-Google-Smtp-Source: AGHT+IESjIQv6/ICyS8yn8B9IgsMw0DggQwsK7hRc4UEvPR3TCet9e6B3QXr+ibINHgZvZ05JzvqN9k3GGM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:fcd:b0:5ca:fea0:a798 with SMTP id
 dg13-20020a05690c0fcd00b005cafea0a798mr585155ywb.6.1701132226944; Mon, 27 Nov
 2023 16:43:46 -0800 (PST)
Date: Mon, 27 Nov 2023 16:43:45 -0800
In-Reply-To: <ZWBDsOJpdi7hWaYV@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com> <20231110235528.1561679-7-seanjc@google.com>
 <4484647425e2dbf92c76a173b7b14e346f60362d.camel@redhat.com> <ZWBDsOJpdi7hWaYV@yilunxu-OptiPlex-7050>
Message-ID: <ZWU3wTElmiEOUg-I@google.com>
Subject: Re: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 24, 2023, Xu Yilun wrote:
> On Sun, Nov 19, 2023 at 07:35:30PM +0200, Maxim Levitsky wrote:
> > On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> > >  static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
> > >  				       int nent)
> > >  {
> > >  	struct kvm_cpuid_entry2 *best;
> > > +	struct kvm_vcpu *caps = vcpu;
> > > +
> > > +	/*
> > > +	 * Don't update vCPU capabilities if KVM is updating CPUID entries that
> > > +	 * are coming in from userspace!
> > > +	 */
> > > +	if (entries != vcpu->arch.cpuid_entries)
> > > +		caps = NULL;
> > 
> > I think that this should be decided by the caller. Just a boolean will suffice.

I strongly disagree.  The _only_ time the caps should be updated is if
entries == vcpu->arch.cpuid_entries, and if entries == cpuid_entires than the caps
should _always_ be updated.

> kvm_set_cpuid() calls this function only to validate/adjust the temporary
> "entries" variable. While kvm_update_cpuid_runtime() calls it to do system
> level changes.
> 
> So I kind of agree to make the caller fully awared, how about adding a
> newly named wrapper for kvm_set_cpuid(), like:
> 
> 
>   static void kvm_adjust_cpuid_entry(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
> 				     int nent)
> 
>   {
> 	WARN_ON(entries == vcpu->arch.cpuid_entries);
> 	__kvm_update_cpuid_runtime(vcpu, entries, nent);

But taking it a step further, we end up with

	WARN_ON_ONCE(update_caps != (entries == vcpu->arch.cpuid_entries));

which is silly since any bugs that would result in the WARN firing can be avoided
by doing:

	update_caps = entries == vcpu->arch.cpuid_entries;

which eventually distils down to the code I posted.

> > Or even better: since the userspace CPUID update is really not important in
> > terms of performance, why to special case it? 
> > 
> > Even if these guest caps are later overwritten, I don't see why we need to
> > avoid updating them, and in fact introduce a small risk of them not being
> > consistent
> 
> IIUC, for kvm_set_cpuid() case, KVM may then fail the userspace cpuid setting,
> so we can't change guest caps at this phase.

> Or even better: since the userspace CPUID update is really not important in
> terms of performance, why to special case it? 

Yep, and sadly __kvm_update_cpuid_runtime() *must* be invoked before kvm_set_cpuid()
is guaranteed to succeed because the whole point is to massage guest CPUID before
checking for divergences.

> > With this we can avoid having the 'cap' variable which is *very* confusing as well.

I agree the "caps" variable is confusing, but it's the least awful option I see.
The alternatives I can think of are:

  1. Update a dummy caps array
  2. Take a snapshot of the caps and restore them
  3. Have separate paths for updated guest CPUID versus guest caps

#1 would require passing a "u32 *" to guest_cpu_cap_change() (or an equivalent),
which I really, really don't want to do.  It' also a waste of cycles, and I'm
skeptical that it would be any less confusing than the proposed code.

#2 increases the complexity of kvm_set_cpuid() by introducing recovery paths, i.e.
adds more things that can break, and again is wasteful (though copying ~100 bytes
or so in a slow path isn't a big deal).

#3 would create unnecessary maintenance burden as we'd have to ensure any changes
hit both paths.

