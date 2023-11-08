Return-Path: <kvm+bounces-1284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D41CC7E5F9E
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 22:06:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D6462815C9
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9DAE374D2;
	Wed,  8 Nov 2023 21:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MIi89LhX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BDF16411
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 21:06:20 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F02EA
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 13:06:19 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40838915cecso514485e9.2
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 13:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699477577; x=1700082377; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0gztfFNC2K6ENVPcDCfNrMnAPC03V0pTeFdfhUcWBmI=;
        b=MIi89LhXdPAjFynlH9CoE+FCH2RtQWfLr5JTW0HS/73WRM5XI7XFSGkGPtvq8vTnNO
         jVJ8RHxiDvn5iYkSvPjYHdMxkVx3BlBRKoOPdi2aFJl1Qr+gc+NnNEwkQ7Y8pEFH4NIp
         9l0MMuUnwAUQlL8FCtMuidqbqR/N/WjopuuixKFWGAVUdGHR28WxzW+OjRfRoG6Zo1uQ
         HXcQdWoOjA2z3Aq4tuYq+wkZQ1EnbIVB3uxSWpwBtuUpyYavRVi/wKYXjiWogJ6INRT0
         Syq0PhLLPE9oEZfQP9a+7JIFFRgl2syzip24RsjQG+9pkWjca1CwYa/4XGLtNaWZ+DLJ
         3pZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699477577; x=1700082377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0gztfFNC2K6ENVPcDCfNrMnAPC03V0pTeFdfhUcWBmI=;
        b=xJvFP/SkEWYdZQWjAMKEc/wUMICxsTA/Np5n+H6nNcO9y4HjAqIYWCNB1p7rRmmq0a
         L95zR3i/Qi3g+Xr3yjCUtjLoMOXVD0O6CzwvVcrVlieqH0zR41sC4V+E7DcJrXdxKsuy
         9GU+IMqxeF/Y/P3iNVG4GE+GkfpTeEVtcz90vh+44cIGJ431HzJAXlTGUJazCFYrJfmK
         dqW19a2OjfH/nk8CaS3Dipqj7YY3obA+ATbFC6abNYbmxA/6ak9RNbukYzPlkzc/+K9q
         0ls8NhVdg1fIcUk6pmQhxGWPbWINxHFYzKcwTljEz+A0DhHI2a1ntGIkHOSSBGrKA3RK
         a2qw==
X-Gm-Message-State: AOJu0YzHUdWiuN3/OFf2s5ez9GOL6PFoScXWFWSu4B+NfPH5oFSP4JjR
	efkiUviYkg4l89bnijtjdmEqjQvNYnstTL3uzq5N/w==
X-Google-Smtp-Source: AGHT+IFnpYl8RaF32nFa+ts2kPzXv3YviQ/xJxk5dOPDqSVq8XW0K1HWk96aCCsYFnk2pnQURr41bTTlziwAWzD9NS0=
X-Received: by 2002:a5d:6151:0:b0:31a:d9bc:47a2 with SMTP id
 y17-20020a5d6151000000b0031ad9bc47a2mr2338519wrt.53.1699477577544; Wed, 08
 Nov 2023 13:06:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
 <ZUqn0OwtNR19PDve@linux.dev> <CALzav=evOG04=mtnc9Tf=bevWq0PbW_2Q=2e=ErruXtE+3gDVQ@mail.gmail.com>
 <ZUrj8IK__59kHixL@linux.dev> <CALzav=dXDh4xAzDEbKOxLZkgjEyNs8VLoCOuJg4YYrD0=QzvGw@mail.gmail.com>
 <ZUvGpmk680nBKwOE@x1n> <ZUvrJz42KXPsffJH@google.com> <CAJHvVci60RiftHmQ1TDDeZRHK_A8QHdqreWDFbaBOE1QbXNeqA@mail.gmail.com>
In-Reply-To: <CAJHvVci60RiftHmQ1TDDeZRHK_A8QHdqreWDFbaBOE1QbXNeqA@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 8 Nov 2023 13:05:49 -0800
Message-ID: <CALzav=c3qpKnqU+a6g5DC0M9RtP=M+3ptLg035BBLZUTyTWthw@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 8, 2023 at 12:47=E2=80=AFPM Axel Rasmussen <axelrasmussen@googl=
e.com> wrote:
>
> On Wed, Nov 8, 2023 at 12:10=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Nov 08, 2023, Peter Xu wrote:
> > > On Wed, Nov 08, 2023 at 08:56:22AM -0800, David Matlack wrote:
> > > > Thanks for the longer explanation. Yes kvm_read_guest() eventually
> > > > calls __copy_from_user() which will trigger a page fault and
> > > > UserfaultFD will notify userspace and wait for the page to become
> > > > present. In the KVM-specific proposal I outlined, calling
> > > > kvm_read_guest() will ultimately result in a check of the VM's pres=
ent
> > > > bitmap and KVM will nnotify userspace and wait for the page to beco=
me
> > > > present if it's not, before calling __copy_from_user(). So I don't
> > > > expect a KVM-specific solution to have any increased maintenance
> > > > burden for VGIC (or any other widgets).
> > >
> > > The question is how to support modules that do not use kvm apis at al=
l,
> > > like vhost.  I raised the question in my initial reply, too.
> > >
> > > I think if vhost is going to support gmemfd, it'll need new apis so m=
aybe
> > > there'll be a chance to take that into account, but I'm not 100% sure=
 it'll
> > > be the same complexity, also not sure if that's the plan even for CoC=
o.
> > >
> > > Or is anything like vhost not considered to be supported for gmemfd a=
t all?
> >
> > vhost shouldn't require new APIs.  To support vhost, guest_memfd would =
first need
> > to support virtio for host userspace, i.e. would need to support .mmap(=
).  At that
> > point, all of the uaccess and gup() stuff in vhost should work without =
modification.
>
> Does this imply the need for some case-specific annotations for the
> proposed KVM demand paging implementation to "catch" these accesses?
>
> IIUC this was one of the larger downsides to our internal
> implementation, and something David had hoped to avoid in his RFC
> proposal. Whereas, I think this is a point in UFFD's favor, where all
> accesses "just work" with one centralized check in the fault handler
> path.

Yes this is definitely a point in UFFD's favor. The KVM-specific
solution would require adding hooks in KVM in the core routines that
KVM uses to access guest memory, or in the gfn-to-hva conversion
routine.

But the number of hooks needed is small, and this isn't exactly a new
problem. KVM already needs similar hooks so that it can manually keep
the dirty log up-to-date. Most of the pain we've experienced in our
internal implementation is because (1) it's not upstream so it's easy
for changes to slip in that don't go through the core routines (e.g.
see record_steal_time() which hand-rolls its own guest memory access
via user_access_begin/end()), and (2) we used to manually annotate all
guest memory accesses instead of hooking the core routines.

It's still possible for there to be correctness bugs (more likely than
UFFD), but I think it's about as likely as KVM missing a dirty log
update which I haven't noticed being a major source of upstream bugs
or maintenance burden.

But again, yes this is definitely a point in favor of a
page-table-based approach. :)

