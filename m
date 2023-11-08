Return-Path: <kvm+bounces-1281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CC67E5F75
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:48:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91E011C20CCD
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4395D374C7;
	Wed,  8 Nov 2023 20:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wdBE7J7Q"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B280F374C4
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:47:55 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDAB213A
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 12:47:54 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9e2838bcb5eso30114066b.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 12:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699476473; x=1700081273; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hge9P6+Dhk21jkwXSSMI5Y6i7O5AaRYzFky/v455NsA=;
        b=wdBE7J7Qbecqmzsw+jjtjjoV8Kn+iWZ8CW+lMDmUdq+jCYQDtrPs4chH2DsE1QRRdv
         nLyMdCW+aWBErob6A5/FyPvhwuYAW3x9NbSUgDKvSFcI6893+Mo6LrnUsTYi5G0GIEF4
         cTvm9qw+ljlGPUy3AIpsF0BE/mPDc2ZIbEg0SOtqLZcreQV/xzEqw8UkEg5EHuMS0a+W
         Tg/QNgzPyY1ZABtq/1HeWgWLUnUcwKkRgNO13j4Z/3881tSDfHCnbBNa2zJEB5ybIUJl
         KhNIazynhIxeAFZlol+HK5LqNWK3Xb2LxS3tUuDRCzF+2ZHhTGN2/w8Sd+yKxPVsLHCM
         M5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699476473; x=1700081273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hge9P6+Dhk21jkwXSSMI5Y6i7O5AaRYzFky/v455NsA=;
        b=DpTB+/6uTgryMLmnY8PYGYv56ZxxUZxrgtIN0YWjLf3gRj+9cOSGzpZcf9PlqgGH9K
         fIISk+e6vXAdDmqPzTk1PYx3OXTpTHi1QO5mrWBmX5UVYbIW1uhNJLggM7iumPwae7at
         5pdjIqmqXisjR0AqcMdMs63KylfessU1wF1OWWm+ay2HuA7Y8Ci4IvYUmntTQsqReCDo
         NVSqvSCUMjXKLdjmVpfkEFU/M4oFF8oGY+feNuMoXPm1T0XVTi7mRU3c7cKP9xwKDcX9
         eeCSd+FJp1Ti/PRhcu6mFRL8Ds/A273vCbAbjJH0HfUPxkB9gq4MNemSLYGUu+1XkdAV
         VmSg==
X-Gm-Message-State: AOJu0Yw3wycizcz/tu7FvQVoRfhKgTDHMI2uq79BUkAGAzyF1YYaeU+1
	Enr6gr6uGxLh4QAE8b2VZssjoPYfUi+kMUSc2Nei1Q==
X-Google-Smtp-Source: AGHT+IEBzWns0yMYHciLXYy9RMbGO0dgrkYKKRU9QIu3ck4tIzZNpKXzehGf+WO4AnIsUYHP1DakJfNInP6cxtNDH54=
X-Received: by 2002:a17:907:86a7:b0:9dd:902a:797d with SMTP id
 qa39-20020a17090786a700b009dd902a797dmr2443358ejc.1.1699476473151; Wed, 08
 Nov 2023 12:47:53 -0800 (PST)
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
 <ZUvGpmk680nBKwOE@x1n> <ZUvrJz42KXPsffJH@google.com>
In-Reply-To: <ZUvrJz42KXPsffJH@google.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Wed, 8 Nov 2023 12:47:14 -0800
Message-ID: <CAJHvVci60RiftHmQ1TDDeZRHK_A8QHdqreWDFbaBOE1QbXNeqA@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Xu <peterx@redhat.com>, David Matlack <dmatlack@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 8, 2023 at 12:10=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Nov 08, 2023, Peter Xu wrote:
> > On Wed, Nov 08, 2023 at 08:56:22AM -0800, David Matlack wrote:
> > > Thanks for the longer explanation. Yes kvm_read_guest() eventually
> > > calls __copy_from_user() which will trigger a page fault and
> > > UserfaultFD will notify userspace and wait for the page to become
> > > present. In the KVM-specific proposal I outlined, calling
> > > kvm_read_guest() will ultimately result in a check of the VM's presen=
t
> > > bitmap and KVM will nnotify userspace and wait for the page to become
> > > present if it's not, before calling __copy_from_user(). So I don't
> > > expect a KVM-specific solution to have any increased maintenance
> > > burden for VGIC (or any other widgets).
> >
> > The question is how to support modules that do not use kvm apis at all,
> > like vhost.  I raised the question in my initial reply, too.
> >
> > I think if vhost is going to support gmemfd, it'll need new apis so may=
be
> > there'll be a chance to take that into account, but I'm not 100% sure i=
t'll
> > be the same complexity, also not sure if that's the plan even for CoCo.
> >
> > Or is anything like vhost not considered to be supported for gmemfd at =
all?
>
> vhost shouldn't require new APIs.  To support vhost, guest_memfd would fi=
rst need
> to support virtio for host userspace, i.e. would need to support .mmap().=
  At that
> point, all of the uaccess and gup() stuff in vhost should work without mo=
dification.

Does this imply the need for some case-specific annotations for the
proposed KVM demand paging implementation to "catch" these accesses?

IIUC this was one of the larger downsides to our internal
implementation, and something David had hoped to avoid in his RFC
proposal. Whereas, I think this is a point in UFFD's favor, where all
accesses "just work" with one centralized check in the fault handler
path.

