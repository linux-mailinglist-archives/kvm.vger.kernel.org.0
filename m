Return-Path: <kvm+bounces-1087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CECA07E4AC0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 22:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CB62B2107A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FE42A1DF;
	Tue,  7 Nov 2023 21:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FcbWt8Bn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918D52A1D2
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 21:35:06 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEFE10C9
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 13:35:05 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-32fd7fc9f19so1375653f8f.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 13:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699392904; x=1699997704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WrJOfcwca+5A0/wUN9Sb2ZvvKZ78Hn2PZw9wIMYEGTo=;
        b=FcbWt8BnKjPaF0zM+4QP109HZNnFBGboHDayODXObEjdicRJ6ACzO6TKn9Ca2K+Oy9
         Y2Co1YiADqG97Rg01N2Je50tn2bQdvXBRC1mYxFKTCH15/cRgnpgsKubvJk4+9wjqbQd
         VUHlUEhjjutKME5plvj13XjogZNV6tkC5kWXTNpRwktZIUNPNRx8wM4z7lPhP+XKJG1S
         IWgjnmyQU7zzIFyX/CfiKvcszNFmiWL7sVFYAwXTAdVc0c/YZK3GpeOHBFZQaiLO9uZ2
         HD99/AtspMN/vYTzB88P9IYPDOSpghuZRujElRPtUDgibKlF7MRIMqv99B6LysV145aZ
         Jmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699392904; x=1699997704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WrJOfcwca+5A0/wUN9Sb2ZvvKZ78Hn2PZw9wIMYEGTo=;
        b=dbTrmqLNO1GycmNH3NK3g/Ds2WCXlUR0WEAuCgV2/8xyshH2okc8OT0utxMKyTz1vT
         1jlr0xaMiMZhyXyO1yIQp6Yf39xANs92RP1haguOia2y1cwuUdbT3FHiKnXVFT0otFta
         xjujzRmEorDQpTj76EXBCPfNabm1FDCv25vzFuLY/ekVgdyLhwxeHSt6b6v+2+gOat9W
         OtigDlApDkVo1cHqU6bpUiOxnI8BWUZYbsCJ1Ei2cNKG38dByAmfM18Evurm3sTlFLjV
         SQ2WdChbUMzIT18GwFNR9jFZstVa4Je46v+RaoISOeautfiTp0E/50ZwN53m/cPWaFay
         s/MQ==
X-Gm-Message-State: AOJu0Yy5sx5ag2CVhO8AXEy6qPpQEDVbNQ7KQmL9oyLKJdZSREj+HMt1
	J4H3b1wxhld/S+/9WFUl2cUJzmSDaF33F7sPuUCpVA==
X-Google-Smtp-Source: AGHT+IFqNq7JokX9lWD/s74mg3meIDDnK0vrGEHr8kxBqh7iE1TLJmC+FxFxBR1RAdMWsd/2g8aXUaTO2e8RQT+Rg8E=
X-Received: by 2002:a05:6000:18a2:b0:32f:7f02:daca with SMTP id
 b2-20020a05600018a200b0032f7f02dacamr26967wri.13.1699392904041; Tue, 07 Nov
 2023 13:35:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com> <ZUqn0OwtNR19PDve@linux.dev>
In-Reply-To: <ZUqn0OwtNR19PDve@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Tue, 7 Nov 2023 13:34:34 -0800
Message-ID: <CALzav=evOG04=mtnc9Tf=bevWq0PbW_2Q=2e=ErruXtE+3gDVQ@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 1:10=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Tue, Nov 07, 2023 at 12:04:21PM -0800, David Matlack wrote:
> > On Tue, Nov 7, 2023 at 8:25=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.c=
om> wrote:
>
> [...]
>
> > >  My
> > > gut feeling even without reading everything was (and it was confirmed
> > > after): I am open to merging some specific features that close holes =
in
> > > the userfaultfd API, but in general I like the unification between
> > > guest, userspace *and kernel* accesses that userfaultfd brings. The f=
act
> > > that it includes VGIC on Arm is a cherry on top. :)
> >
> > Can you explain how VGIC interacts with UFFD? I'd like to understand
> > if/how that could work with a KVM-specific solution.
>
> The VGIC implementation is completely unaware of the existence of UFFD,
> which is rather elegant.
>
> There is no ioctl that allows userspace to directly get/set the VGIC
> state. Instead, when userspace wants to migrate a VM it needs to flush
> the cached state out of KVM's representation into guest memory. I would
> expect the VMM to do this right before collecting the final dirty
> bitmap.

Thanks Oliver. Maybe I'm being dense but I'm still not understanding
how VGIC and UFFD interact :). I understand that VGIC is unaware of
UFFD, but fundamentally they must interact in some way during
post-copy. Can you spell out the sequence of events?

>
> If UFFD is off the table then it would appear there are two options:
>
>  - Instrument these ioctls to request pages not marked as present in the
>    theorized KVM-owned demand paging interface
>
>  - Mandate that userspace has transferred all of the required VGIC / ITS
>    pages before resuming on the target
>
> The former increases the maintenance burden of supporting post-copy
> upstream and the latter *will* fail spectacularly. Ideally we use a
> mechanism that doesn't require us to think about instrumenting
> post-copy for every new widget that we will want to virtualize.
>
> > So in the short term we could provide a partial solution for
> > HugeTLB-backed VMs (at least unblocking Google's use-case) and in the
> > long-term there's line of sight of a unified solution.
>
> Who do we expect to look after the upstreamed short-term solution once
> Google has moved on to something else?

Note, the proposed long-term solution you are replying to is an
extension of the short-term solution, not something else.

