Return-Path: <kvm+bounces-1282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33DEC7E5F79
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:49:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 648BF1C20D3B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E533716D;
	Wed,  8 Nov 2023 20:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n3Ve+8HJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B185232C6E
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:49:32 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B542113
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 12:49:32 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-32d849cc152so65788f8f.1
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 12:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699476570; x=1700081370; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPR+H8j0NVFbKhZTzzVlY7FsfeX3eaRngttSCBCZGgo=;
        b=n3Ve+8HJQvkZLYwxZ8jtwohVFPHnHS41ypEICDFTr2mP3wXWG3D5r/lPAdxsudfmyv
         pq0NnX5s78QtCx2KWTWq7nZk3+ymxl2RDZ2rPS3odnTqoKlg4YgO6nbGhe89RlV9Ec9m
         UTo1nzHGEaSsKNrY3lxpQ4Am706pun5y2Eb0nZIwhCU9yHl1iKx2SeZsIP8/O6+UO4W4
         V4t7XwYKgW6hv0gux14bSD3tieGhSNpDj6U+x2BWXlhECIV9cZ+Pmvtf627wsGWtb2GI
         rumaZQY1m6gcFurXLqByrTAFRx8uOf8TZULvB+2Xk+rM1XMggaPXHoc5VstVfgSHOzAc
         NaRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699476570; x=1700081370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qPR+H8j0NVFbKhZTzzVlY7FsfeX3eaRngttSCBCZGgo=;
        b=TJhWpng4//2KE0p7rT03V5FwLZsvmIEhUyjobdM6gUI5CVav6XqFsoowgL4WNBo8o6
         +rgzWpPZBl8/TExPAozgWz82iWQK3/y5Ao9f+se1XL7zeSaewck9QtG/EWttkwlOC9E4
         u69eKMw8E96Yk7s1dfimeim7YFPmjLMkUnYZBPhmWG5Bg81x7KFSS0/g0C4xdm6KNtny
         G7GRiuH64NaFHr/imjblYr8vEQaB5l0icZo13nhOAbrEUx1VZPKeCXrTJUVMoC1kO/2H
         i8PtrRmhyry3Ap9u38Ve2nxl6yrNG5i8vr8uh8fJw058ySXolf7aL6LDcD/Yi50C+6QG
         qRug==
X-Gm-Message-State: AOJu0YxWxqbe3jZhebeT/V1fW8BFITQUgpM1D9xYv1uWA9EZ+PzZYrfq
	kGodTGf+qUr4Y5z0uqgpI8jsbIBjG3rCb1l7xVzBVESXCzYXJfw5SrnPww==
X-Google-Smtp-Source: AGHT+IFoQtZ/T6QQt1OX2UXGfRhf+QZOujG/P+RoLo3CpbWL2ADhcCoER0lfzcYyoUbTzof8lWAPbvYQ7rG5ZbRlC1Q=
X-Received: by 2002:a05:6000:1845:b0:32f:7b14:89d9 with SMTP id
 c5-20020a056000184500b0032f7b1489d9mr2512962wri.9.1699476570436; Wed, 08 Nov
 2023 12:49:30 -0800 (PST)
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
 <ZUvGpmk680nBKwOE@x1n>
In-Reply-To: <ZUvGpmk680nBKwOE@x1n>
From: David Matlack <dmatlack@google.com>
Date: Wed, 8 Nov 2023 12:49:04 -0800
Message-ID: <CALzav=cOH-PSR=tXm7BHxioU73+VJ6LiHPfk2hj9G5yCf27eBA@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Peter Xu <peterx@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 8, 2023 at 9:34=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Nov 08, 2023 at 08:56:22AM -0800, David Matlack wrote:
> > Thanks for the longer explanation. Yes kvm_read_guest() eventually
> > calls __copy_from_user() which will trigger a page fault and
> > UserfaultFD will notify userspace and wait for the page to become
> > present. In the KVM-specific proposal I outlined, calling
> > kvm_read_guest() will ultimately result in a check of the VM's present
> > bitmap and KVM will nnotify userspace and wait for the page to become
> > present if it's not, before calling __copy_from_user(). So I don't
> > expect a KVM-specific solution to have any increased maintenance
> > burden for VGIC (or any other widgets).
>
> The question is how to support modules that do not use kvm apis at all,
> like vhost.  I raised the question in my initial reply, too.

Yes you are correct, my proposal does not provide a solution for guest
memory accesses made by vhost. That is admittedly a gap. Google does
not do virtio emulation in-kernel so this isn't a problem we had to
solve and I wasn't aware of it until you pointed it out.

