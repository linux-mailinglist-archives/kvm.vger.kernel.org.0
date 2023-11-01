Return-Path: <kvm+bounces-341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F05597DE830
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 23:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CB811C20E26
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 22:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8335414F6E;
	Wed,  1 Nov 2023 22:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ThI/rqRz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3ED101EF
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 22:40:34 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A27B12C
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 15:40:28 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-407c3adef8eso2477625e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 15:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698878427; x=1699483227; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXPZ3AcawcA1W4QGM/w77ZoUKpuqMyLV5hPTKCTAkfk=;
        b=ThI/rqRzJm4yDpQeM6djriciwcQQIoE+r0sQNqmxxtc+jKECEhFMs8lIxYHdnDy3tv
         CUZ1qoeMXZeGeR344wXHoKYgdNEk5JxHcfyzkDTbMIL3d5LKl0fbi/lTtYYKWD0CwZ9H
         uS1R8LoNDd4NqMnp3ayw2JkOrdZRZi0PGtbFR8YMZ6lYdktnAQPRMWkNe+i9m8RrSRlt
         k4whKxwlMSnwwAC7ztmZsP/pOPb39nPSX8NYITcJOcp06QFQpqPMpaAg3L6cMf+GPuxQ
         6g1lJrU5p9tVnVWMGCOqa29Uws44oLvKNXN4aOVn+H2oQNoUtMoQACx88doxFeq3o9t5
         vP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698878427; x=1699483227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXPZ3AcawcA1W4QGM/w77ZoUKpuqMyLV5hPTKCTAkfk=;
        b=pkWdsr6ryFRdndMD41lA8SswR46gJl3lHPf3YIjUqHhoueFj4RNaHID/+1cGFZmWBR
         MaorHTMnupYM3xaeWLRZ8MJ0PEea0M4wyaHSH9xQ0oY7d0Z9jZFViBP2ki61qP4NjBc9
         V2/GIi2eEe8pwy/H1nO9VkMB51NrMqV39GZQlNTKE0yraHoGU2cXpSzWgytEhIfQhhnS
         GcDaYVhBS3mridbpLuvdRBLrwuARalvMEYHnSEOverDEIX6Y/q5joU4o834ZUV3QDZG0
         OKwwrwq+6BuY2/scAO895VVRji1JZfGlTY76+krcBHh8ZihvLBW9VL2ZzAee/48V7h1j
         9uFg==
X-Gm-Message-State: AOJu0Yy6aJGYqGW6xFfpsQXvFkfMeTnWX3ydwkewqUYQEieH5GEbTfvB
	PY+KXz+uv6R66l23MFSkU9X+k3i4LzUi9veMYRc0Cw==
X-Google-Smtp-Source: AGHT+IGBIOI+1EwOPVneFxq7kiG8a/BAOPw8eWi65SiYX1SAEvO0e8gGOY7yFbmBjlohmXQzTCcPfGpIau9B57/jY+U=
X-Received: by 2002:a05:600c:a4c:b0:409:6737:326b with SMTP id
 c12-20020a05600c0a4c00b004096737326bmr183202wmq.11.1698878427291; Wed, 01 Nov
 2023 15:40:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <ZULLNdp6XKD6Twuc@google.com> <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
In-Reply-To: <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 1 Nov 2023 15:39:58 -0700
Message-ID: <CALzav=ccmnY1kb3KatbSuYtXzGjsh7xFSKzmfv10pAOGJV3g7Q@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Anish Moorthy <amoorthy@google.com>
Cc: Sean Christopherson <seanjc@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 1, 2023 at 3:26=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> On Wed, Nov 1, 2023 at 3:03=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, Nov 01, 2023, Anish Moorthy wrote:
> > > On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > >
> > > > Eh, the shortlog basically says "do work" with a lot of fancy words=
.  It really
> > > > just boils down to:
> > > >
> > > >   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_O=
N_MISSING
> > >
> > > Proposed commit message for v6:
> > >
> > > > KVM: Implement KVM_CAP EXIT_ON_MISSING by checking memslot flag in =
__gfn_to_pfn_memslot()
> > > >
> > > > When the slot flag is enabled, forbid __gfn_to_pfn_memslot() from
> > > > faulting in pages for which mappings are absent. However, some call=
ers of
> > > > __gfn_to_pfn_memslot() (such as kvm_vcpu_map()) must be able to opt=
 out
> > > > of this behavior: allow doing so via the new can_exit_on_missing
> > > > parameter.
> > >
> > > Although separately, I don't think the parameter should be named
> > > can_exit_on_missing (or, as you suggested, can_do_userfault)-
> > > __gfn_to_pfn_memslot() shouldn't know or care how its callers are
> > > setting up KVM exits, after all.
> >
> > Why not?  __gfn_to_pfn_memslot() gets passed all kinds of constraints, =
I don't
> > see how "I can't handle exits to userspace" is any different.
>
> Well the thing is that __gfn_to_pfn_memslot() is orthogonal to KVM
> exits. Its callers are just using it to try resolving a pfn, and what
> they do with the results is up to them.
>
> Put more concretely, __gfn_to_pfn_memslot() has many callers of which
> only two (the stage-2 fault handlers) actually use it to set up a KVM
> exit- how does a parameter named "can_exit_on_missing" make sense to
> its callers in general?

"exit" is shorthand for "return_to_userspace" and all KVM code runs in
the context of ioctls (which eventually return to userspace). So I
think it makes sense in general.

And FWIW I found the MEMSLOT_ACCESS_ enum hard to read and agree a
boolean would be simpler.

