Return-Path: <kvm+bounces-338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC147DE816
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 23:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BA72B211AB
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 22:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5240A1C2A7;
	Wed,  1 Nov 2023 22:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hxe+bHtp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AFE1BDF0
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 22:25:56 +0000 (UTC)
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B747512C
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 15:25:54 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6ce327458a6so163368a34.1
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 15:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698877554; x=1699482354; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=294ol75obltyYqEqfl+9y62VRvfSAWQRBPN9Wezacbg=;
        b=hxe+bHtpIEDGl1mY4LssfmnrHb0m/30lUUeg5ENyHokBE0JmCLm55+M7E6MiAYzwXz
         8mg9ng2lOGQOJKw/hxHMINFKWEhmcPySS8Idboflo3ZWF4TvZZiqvqJBjxR+ITDhX1gr
         t2fdN4/bn5rh5dPI2KvFM4EUVkgvLxl01T0aApoXcS38suE9/kln4yp9PQS3ZudO2KPA
         Ryh+xZNf/+pLcucVzEYXPT6HR0ni2yvoT9NDNqEroj23/N90xO9+B/14yG4ez0SXBLG0
         /AN4jp8ts6X59Tjqugh1DClAhulohREASFLL4qzqd+xHgWeKZlCNTGtyU/lOVcw126uK
         h3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698877554; x=1699482354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=294ol75obltyYqEqfl+9y62VRvfSAWQRBPN9Wezacbg=;
        b=c4HM3/01EGk0YoV/13u5FipTgiH0tQmKOtFJZ/2+PK26nBUKTtt39OU6ZFyxyo0U4C
         3Gbv6SVY3KNXOCSb2/DS3fTR1kAKrZ7kKhkBFhp1fLj00RtruhgDW5FNPVWkgkZ8Jbzr
         b2eoBcGflok1GM7PFPncXEMpc5Ki2aFrCc/rKKyVS8zW9Oq5c/kmBLCxaOWWsR/shk+k
         Oi9JCaNNVJEJpmyVi9Ucd+KxSh36x0esnR0Zf+1ykWq3c9tDjho0Oa1vv3/4N6mXBAx/
         tVV7lpfGMbSNHRVItZgZl6yafFxjYF6WEhlisz0Ou5Q/spU9Z230o7/TNMjVickMQsHp
         1GRQ==
X-Gm-Message-State: AOJu0YwxToQxbNGhNyzZdBMzddMql4TJqnv6uCjbWXwS6wJzumEofMc4
	p0UldQTBHd3Wx2xrJfCyf5tPlikIGAtDWQGBBJHzTg==
X-Google-Smtp-Source: AGHT+IEz52TIIahqocPRQHTgpnNRkVELhbb8QsFoXnxMsUeqH1qkZEFXxONxXhy1tVdwDNDCy4jVR8qXcK82xhTcmaY=
X-Received: by 2002:a05:6830:3149:b0:6bd:62c1:65c with SMTP id
 c9-20020a056830314900b006bd62c1065cmr2188470ots.18.1698877553954; Wed, 01 Nov
 2023 15:25:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <ZULLNdp6XKD6Twuc@google.com>
In-Reply-To: <ZULLNdp6XKD6Twuc@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 1 Nov 2023 15:25:17 -0700
Message-ID: <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 1, 2023 at 3:03=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Nov 01, 2023, Anish Moorthy wrote:
> > On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > Eh, the shortlog basically says "do work" with a lot of fancy words. =
 It really
> > > just boils down to:
> > >
> > >   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_=
MISSING
> >
> > Proposed commit message for v6:
> >
> > > KVM: Implement KVM_CAP EXIT_ON_MISSING by checking memslot flag in __=
gfn_to_pfn_memslot()
> > >
> > > When the slot flag is enabled, forbid __gfn_to_pfn_memslot() from
> > > faulting in pages for which mappings are absent. However, some caller=
s of
> > > __gfn_to_pfn_memslot() (such as kvm_vcpu_map()) must be able to opt o=
ut
> > > of this behavior: allow doing so via the new can_exit_on_missing
> > > parameter.
> >
> > Although separately, I don't think the parameter should be named
> > can_exit_on_missing (or, as you suggested, can_do_userfault)-
> > __gfn_to_pfn_memslot() shouldn't know or care how its callers are
> > setting up KVM exits, after all.
>
> Why not?  __gfn_to_pfn_memslot() gets passed all kinds of constraints, I =
don't
> see how "I can't handle exits to userspace" is any different.

Well the thing is that __gfn_to_pfn_memslot() is orthogonal to KVM
exits. Its callers are just using it to try resolving a pfn, and what
they do with the results is up to them.

Put more concretely, __gfn_to_pfn_memslot() has many callers of which
only two (the stage-2 fault handlers) actually use it to set up a KVM
exit- how does a parameter named "can_exit_on_missing" make sense to
its callers in general? If it were __gfn_to_pfn_memslot() itself that
was populating the run struct in response to absent mappings then I
would agree that the name was appropriate- but that's not what's going
on here.

(side note, I'll assume that aside from the current naming discussion
the commit message I proposed is fine)

