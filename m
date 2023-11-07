Return-Path: <kvm+bounces-1056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A557E48F5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A4DE2813FE
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1A636AE0;
	Tue,  7 Nov 2023 19:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CSBuPGu4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B825F3158C
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 19:09:07 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4AB119
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 11:09:06 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-41cb7720579so35531cf.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 11:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699384146; x=1699988946; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YhcwXqGMVwPmhL1tfP1jSNN5dX5h1gFcuiMS/F+f0fY=;
        b=CSBuPGu4SedABlGRuclpKptnl7p41TEBDv8oRDVa9ez9BOqgVLoqmjl4FA2DC2wX3I
         FINal/p8zoydYEKX8L5n1eAmDYFnnGlS6oraKJA27rHNRFAFPK9BU1gfA7J2KLKvdGUE
         YA2Tz7PyvHu0K0fV0jeOvlSE2F3WTJfjveJNJ8x0hh+nVjpdjep/AM86Ko5gb+Lr6p3S
         P1dR7+b39+4hBK3IJszxfF4bOBMtsf+Qyv8voRc2TjZK4/h8pFiqjU3vzOj50yiSUMJy
         ONrvcd/lDeY1NQe+CFwavi8iKr/7R4SDftXlKu1y2BSfcloqUjF7ZTkYNPbTeXHR1VJC
         iIsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699384146; x=1699988946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YhcwXqGMVwPmhL1tfP1jSNN5dX5h1gFcuiMS/F+f0fY=;
        b=VD7rjp3v8VvgiWuFPo8zq1fcEHy2qmqRAKzuNKWjcrOxxm04/iA21ETsxc9LeCds5+
         x+SIJNEDXSv8UubDjviEZ/cbyJ26GTrhBfxiU8Tb1QfJh4LutBwKiFGvPFq85ZonqyNP
         bsNg7T6SIUIXZP6I46FGDLxO01JiqAecvaXLce1m3q9mojrX06Y1echG1rDRo+rndLr3
         ZK0QUWFNFkF7jMkKO/p2JbngsqF+eh4FCb0+6ICoLO3nC4NpM1c+xfEs9A0ibJ3EyLgR
         0Hqbp1GbRoW7lRIPQfo8A5J16gbCcZZRVH4yId+cZoszLg+++d+N+9BYcoxPJnNOf3XJ
         7NZg==
X-Gm-Message-State: AOJu0YyArY7b94BWwE6CUoOTDinDZLjx5NTT8mAbhOqY1iYKq5AISewz
	LqrukJ651t1LPlaGMWQWEtUZix4yQ8DGWf7p/QZeJA==
X-Google-Smtp-Source: AGHT+IEqQ2y3oH9DB+lNB4xwV8Osk7mEsIxGJyTBMdaszRCM/H7BUnsIS+Lm76d27AuPPI4BAuXZ7H9bzLz9fFdjqnk=
X-Received: by 2002:ac8:4253:0:b0:41e:2bad:f3c5 with SMTP id
 r19-20020ac84253000000b0041e2badf3c5mr394540qtm.9.1699384146009; Tue, 07 Nov
 2023 11:09:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <CAJHvVciC3URbJJMwhU0ahhzq6bomr7juuWqPdpczV6Qgb8OUuQ@mail.gmail.com>
 <ZUlw163pvpJ+Uue8@x1n> <CALzav=d=sAJBK7fBeJwi3BVJ+4ai5MjU7-u0RD4BQMGNRYi_Tw@mail.gmail.com>
 <ZUpIB1/5eZ/2X+0M@x1n> <CADrL8HUHO12Bxrx94_VoS8AsN5uEO1qYM2SCF7Tgw-=vsRUwBA@mail.gmail.com>
 <ZUpyzWOuhFDTXiAW@x1n>
In-Reply-To: <ZUpyzWOuhFDTXiAW@x1n>
From: James Houghton <jthoughton@google.com>
Date: Tue, 7 Nov 2023 11:08:28 -0800
Message-ID: <CADrL8HWRh6kySNn=vAB9qvH4Ekq=9d8ceJkWA8hiXTbRUSJukQ@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Peter Xu <peterx@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Oliver Upton <oupton@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 9:24=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Nov 07, 2023 at 08:11:09AM -0800, James Houghton wrote:
> > This extra ~8 bytes per page overhead is real, and it is the
> > theoretical maximum additional overhead that userfaultfd would require
> > over a KVM-based demand paging alternative when we are using
> > hugepages. Consider the case where we are using THPs and have just
> > finished post-copy, and we haven't done any collapsing yet:
> >
> > For userfaultfd: because we have UFFDIO_COPY'd or UFFDIO_CONTINUE'd at
> > 4K (because we demand-fetched at 4K), the userspace page tables are
> > entirely shattered. KVM has no choice but to have an entirely
> > shattered second-stage page table as well.
> >
> > For KVM demand paging: the userspace page tables can remain entirely
> > populated, so we get PMD mappings here. KVM, though, uses 4K SPTEs
> > because we have only just finished post-copy and haven't started
> > collapsing yet.
> >
> > So both systems end up with a shattered second stage page table, but
> > userfaultfd has a shattered userspace page table as well (+8 bytes/4K
> > if using THP, +another 8 bytes/2M if using HugeTLB-1G, etc.) and that
> > is where the extra overhead comes from.
> >
> > The second mapping of guest memory that we use today (through which we
> > install memory), given that we are using hugepages, will use PMDs and
> > PUDs, so the overhead is minimal.
> >
> > Hope that clears things up!
>
> Ah I see, thanks James.  Though, is this a real concern in production use=
,
> considering worst case 0.2% overhead (all THP backed) and only exist duri=
ng
> postcopy, only on destination host?

Good question. In an ideal world, 0.2% of lost memory isn't a huge
deal, but it would be nice to save as much memory as possible. So I
see this overhead point as a nice win for a KVM-based solution, but it
is not a key deciding factor in what the right move is. (I think the
key deciding factor is: what is the best way to make post-copy work
for 1G pages?)

To elaborate a little more: For Google, I don't think the 0.2% loss is
a huge deal by itself (though I am not exactly an authority here).
There are other memory overheads like this that we have to deal with
anyway. The real challenge for us comes from the fact that we already
have a post-copy system that works and has less overhead. If we were
to replace KVM demand paging with userfaultfd, that means *regressing*
in efficiency/performance. That's the main practical challenge:
dealing with the regression. We have to make sure that VMs can still
be packed to the appropriate efficiency, things like that. At this
moment *I think* this is a solvable problem, but it would be nice to
avoid the problem entirely. But this is Google's problem; I don't
think this point should be the deciding factor here.

- James

