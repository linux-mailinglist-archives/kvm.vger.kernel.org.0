Return-Path: <kvm+bounces-542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B4917E0BE2
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85C86B214FA
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B364D250ED;
	Fri,  3 Nov 2023 23:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DJiNVCHf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105B4219E7
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 23:07:27 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71A7D64
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 16:07:26 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a839b31a0dso53311647b3.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 16:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699052846; x=1699657646; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s8W+2NWvl/ISsintIOYFdBFqIf7YRn8uJS46S8vZKyM=;
        b=DJiNVCHfhlws+G3Kh7DP6drG8ncPDVimfU6Tmx7GxbsE3kMq850h4r7f6q4HE1XHEY
         +yl2W8537K0Nfmw2kwI0Av+BGjd+j4cuui86QBpBeQBaZ4wvG3Ck4YMDnpHWkpqNMqp2
         82iB4APXJeNorY94VOFzkXTexGpclyIsciuoTmaoKVExI9rqTopwn0izNzdKKVJP9Tn/
         gkGE7eyyazYniQHHqE/u1xDOQ618CWc6/NWJ9Jjj+UAbEdN8Ya4bHZD/y5oxe9Khgdsu
         5RtUkO5WcHsMO7nKnp1ZAjjkRuhaULDZ41fAL76VV+09QQuHZn63AAYHEx7DA+fdwPZ+
         34yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699052846; x=1699657646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8W+2NWvl/ISsintIOYFdBFqIf7YRn8uJS46S8vZKyM=;
        b=PJTax+kpAHM6XON4Knv3KcagSFRT8OjdKykc01kRqJBdu6G+Q46ocMvVQEi1dl99w7
         JkvdTvkRE52ipkKI/zJDWUhcbFwyhgVa/1kPKGe9WEjFiyQ5O0VC/QNuq/kYli42s4pp
         pAU1DPc7JKATjA7uNLU6sioqT9wIyQ9WCjqedHjjaadFsyrB4uQtDZ/B7F1BBvD7yF1B
         80y5ZgJ1F+AfGf4d4yfwhWBNYZOnFxaBA7habHTiOJks5UPymiO659qOsknrcjplgBjs
         PkMzri3yuZFkuWLIn2tfa9uUO90S5BkU6W7wL4PFFvyV3gs2yPPgF/RhNh77MrreNFqF
         2iuw==
X-Gm-Message-State: AOJu0YwEZDzBDPfXHqwHHyK5FMUiubTsdwUW62ctsrcJq2/qEXUkrJHo
	x+1T4uGDivB6++eLubscCfMwZZkBsrI=
X-Google-Smtp-Source: AGHT+IEv4++Q1C9rcXoxdGG3JIifTGRCIs+wlQdOev8bn3mrnbSFdi3zO0Emju/7xXl8DljXTq0hIYtkEwM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e204:0:b0:59b:ccba:1249 with SMTP id
 l4-20020a0de204000000b0059bccba1249mr78883ywe.10.1699052845958; Fri, 03 Nov
 2023 16:07:25 -0700 (PDT)
Date: Fri, 3 Nov 2023 16:07:24 -0700
In-Reply-To: <734ac3e7-9fc4-47a4-9951-2fa04e10fe7d@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-3-paul@xen.org>
 <ZUGNkCljRm5VXcGg@google.com> <734ac3e7-9fc4-47a4-9951-2fa04e10fe7d@xen.org>
Message-ID: <ZUV9LMM8FhQD8ycD@google.com>
Subject: Re: [PATCH v7 02/11] KVM: pfncache: add a mark-dirty helper
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Paul Durrant wrote:
> On 31/10/2023 23:28, Sean Christopherson wrote:
> > On Mon, Oct 02, 2023, Paul Durrant wrote:
> > > diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> > > index 0f36acdf577f..b68ed7fa56a2 100644
> > > --- a/virt/kvm/pfncache.c
> > > +++ b/virt/kvm/pfncache.c
> > > @@ -386,6 +386,12 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
> > >   }
> > >   EXPORT_SYMBOL_GPL(kvm_gpc_activate);
> > > +void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)
> > > +{
> > 
> > If there's actually a reason to call mark_page_dirty_in_slot() while holding @gpc's
> > lock, then this should have a lockdep.  If there's no good reason, then don't move
> > the invocation.
> > 
> > > +	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
> > > +}
> > > +EXPORT_SYMBOL_GPL(kvm_gpc_mark_dirty);
> > 
> > This doesn't need to be exported.  Hrm, none of the exports in this file are
> > necessary, they likely all got added when we were thinking this stuff would be
> > used for nVMX.  I think we should remove them, not because I'm worried about
> > sub-modules doing bad things, but just because we should avoid polluting exported
> > symbols as much as possible.
> 
> That in a separate clean-up patch too, I assume?

Yes, but feel free to punt that one or post it as a standalone patch.  For this
series, please just don't add more exports unless they're actually used in the
series.

