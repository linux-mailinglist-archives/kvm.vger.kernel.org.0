Return-Path: <kvm+bounces-1029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D977E458F
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 17:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE8F5B20F27
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11AA328B4;
	Tue,  7 Nov 2023 16:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ekvmndCj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4457F2D033
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:11:48 +0000 (UTC)
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64448D0BE
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 08:11:47 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-41ea9c5e83cso398411cf.0
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 08:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699373506; x=1699978306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92D3EfTzzdthNK7rSHmuSHVu1YwaZFfSd0BUJGI4pFk=;
        b=ekvmndCj2cf2iOFzgD6q8Udtov1agwafyzAwVH49Ynj6mXdytGiuVlb6FZcQpvpXJP
         ZfDv5xbpFNfUu56z1hZSPmndtvicAOG4KnXdOYNEBd5tROSJuyFZPvqED5vZ0mWuTk01
         jQrDgi3dUsL2wxNycNNfjTtKr9TnRD7QC2hlUSD8M1fiw+O6YBBJjYiBqUkKNJdI0slY
         z2hgkNIsqiuRF9BkCsQ28CunKUR20PVrK7UBrXpTGhrnYP2RHZ6wK9EpI3Cd8ClGVrjS
         h3w9XxKny7o1cyDhEOyWLuSGsqcb99Z6WMP6MLB84tRE6QZ15pJeud7WXq+97Pb2DcPp
         VyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699373506; x=1699978306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92D3EfTzzdthNK7rSHmuSHVu1YwaZFfSd0BUJGI4pFk=;
        b=Gf5CEBwYx4paw4SMQDRBBOFBtAVsxsTRxWzuIuMh137ZPsZZJWbfqzUGH3tfac3IzO
         3VGnuyBtSrsH2kjeAcvVNC50aktxPVO5MUQ4MrAxiQ2f2pCdcAWlUNlmrPC805XJrh0W
         SfGOg2PYzevEKNDxsBReYr8+HmcI6FQkrK3Iv93t25tuB7gAdKpNm/VKKiDrXDXa8yQe
         5BcBrS0riezwhROITe+Hkar2eUf8TN0r9EEwYqilwo7b7rNN7n4+drMDP4z683RZHMGe
         VsAWxdC5sfeCK1FxIjZT055AWf2H8Sv6naMXhuOR6o2wMtbj/EJsVf48W5zZB2aU5ulQ
         qcHA==
X-Gm-Message-State: AOJu0Yw7i0x0iMmQl/quTxsszbbddrs1/qQc/0CEXN/6mQqqBAdzm7go
	4AyF+bX3dPLXJO9Qx5w2htmZ8lOKq09BmtyiABbTBQ==
X-Google-Smtp-Source: AGHT+IH+7xEU/GbYvYhEOG364XtU5UQolnxlAD7FE+WORX88cMM8eJ39PxSED20MnOxxa3anRLFRg+jSdzFe6yl+9x8=
X-Received: by 2002:aed:2799:0:b0:41c:e312:cbd2 with SMTP id
 a25-20020aed2799000000b0041ce312cbd2mr310622qtd.29.1699373506374; Tue, 07 Nov
 2023 08:11:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <CAJHvVciC3URbJJMwhU0ahhzq6bomr7juuWqPdpczV6Qgb8OUuQ@mail.gmail.com>
 <ZUlw163pvpJ+Uue8@x1n> <CALzav=d=sAJBK7fBeJwi3BVJ+4ai5MjU7-u0RD4BQMGNRYi_Tw@mail.gmail.com>
 <ZUpIB1/5eZ/2X+0M@x1n>
In-Reply-To: <ZUpIB1/5eZ/2X+0M@x1n>
From: James Houghton <jthoughton@google.com>
Date: Tue, 7 Nov 2023 08:11:09 -0800
Message-ID: <CADrL8HUHO12Bxrx94_VoS8AsN5uEO1qYM2SCF7Tgw-=vsRUwBA@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Peter Xu <peterx@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Oliver Upton <oupton@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 6:22=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Nov 06, 2023 at 03:22:05PM -0800, David Matlack wrote:
> > On Mon, Nov 6, 2023 at 3:03=E2=80=AFPM Peter Xu <peterx@redhat.com> wro=
te:
> > > On Mon, Nov 06, 2023 at 02:24:13PM -0800, Axel Rasmussen wrote:
> > > > On Mon, Nov 6, 2023 at 12:23=E2=80=AFPM Peter Xu <peterx@redhat.com=
> wrote:
> > > > > On Mon, Nov 06, 2023 at 10:25:13AM -0800, David Matlack wrote:
> > > > > >
> > > > > >   * Memory Overhead: UserfaultFD requires an extra 8 bytes per =
page of
> > > > > >     guest memory for the userspace page table entries.
> > > > >
> > > > > What is this one?
> > > >
> > > > In the way we use userfaultfd, there are two shared userspace mappi=
ngs
> > > > - one non-UFFD registered one which is used to resolve demand pagin=
g
> > > > faults, and another UFFD-registered one which is handed to KVM et a=
l
> > > > for the guest to use. I think David is talking about the "second"
> > > > mapping as overhead here, since with the KVM-based approach he's
> > > > describing we don't need that mapping.
> > >
> > > I see, but then is it userspace relevant?  IMHO we should discuss the
> > > proposal based only on the design itself, rather than relying on any
> > > details on possible userspace implementations if two mappings are not
> > > required but optional.
> >
> > What I mean here is that for UserfaultFD to track accesses at
> > PAGE_SIZE granularity, that requires 1 PTE per page, i.e. 8 bytes per
> > page. Versus the KVM-based approach which only requires 1 bit per page
> > for the present bitmap. This is inherent in the design of UserfaultFD
> > because it uses PTEs to track what is present, not specific to how we
> > use UserfaultFD.
>
> Shouldn't the userspace normally still maintain one virtual mapping anywa=
y
> for the guest address range?  As IIUC kvm still relies a lot on HVA to wo=
rk
> (at least before guest memfd)? E.g., KVM_SET_USER_MEMORY_REGION, or mmu
> notifiers.  If so, that 8 bytes should be there with/without userfaultfd,
> IIUC.
>
> Also, I think that's not strictly needed for any kind of file memories, a=
s
> in those case userfaultfd works with page cache.

This extra ~8 bytes per page overhead is real, and it is the
theoretical maximum additional overhead that userfaultfd would require
over a KVM-based demand paging alternative when we are using
hugepages. Consider the case where we are using THPs and have just
finished post-copy, and we haven't done any collapsing yet:

For userfaultfd: because we have UFFDIO_COPY'd or UFFDIO_CONTINUE'd at
4K (because we demand-fetched at 4K), the userspace page tables are
entirely shattered. KVM has no choice but to have an entirely
shattered second-stage page table as well.

For KVM demand paging: the userspace page tables can remain entirely
populated, so we get PMD mappings here. KVM, though, uses 4K SPTEs
because we have only just finished post-copy and haven't started
collapsing yet.

So both systems end up with a shattered second stage page table, but
userfaultfd has a shattered userspace page table as well (+8 bytes/4K
if using THP, +another 8 bytes/2M if using HugeTLB-1G, etc.) and that
is where the extra overhead comes from.

The second mapping of guest memory that we use today (through which we
install memory), given that we are using hugepages, will use PMDs and
PUDs, so the overhead is minimal.

Hope that clears things up!

Thanks,
James

