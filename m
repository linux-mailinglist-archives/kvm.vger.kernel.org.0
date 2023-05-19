Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4524708D2B
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 03:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjESBHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 21:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjESBHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 21:07:51 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9A2E72
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 18:07:48 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-7575fc62c7aso268216385a.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 18:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684458467; x=1687050467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ShpVRoLx2yuZQEh5Oa8VlRwMbFO5/1uX0O7lleIq/ac=;
        b=cocTURKwNfIosKU3hcLYkK4xIp3+2QXu88CJ3E8cWB9Uh/PVZwmzB08Q/OkRfalPDq
         LGmHCntuptqdgbdp6pbiZRzBndUrNjd0fBkzqRWItWlSYmB0dWjvUcQW/KhARoegtqH3
         pqEta1v9ZHiAAR1ID41v+FuR/Rra77fCQi0PBHpLp1ohFwMKv53HVtGyhCUaZQB4KQ2X
         o/3Q5das7C2xufnwqZJzQGFh3Yeez2h8NXxLz/v1F0AewGSov0erw9uF/Db/5LBZnOqt
         zK+Ebp6/ymfuEr3JwYxd3RIKvViMJKrAAHRn+wfS1A1Mcn3/4ZYuJ/Yh6JEBaE28ibL4
         Jtew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684458467; x=1687050467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ShpVRoLx2yuZQEh5Oa8VlRwMbFO5/1uX0O7lleIq/ac=;
        b=bEC68GVmCgMPrDrlxggxppD9Mpg1oM71eXVoTU/d2FwH6qqIfxnLv189BZkkHy9Jq7
         8nyfQUaL3vHEV0fzIjastzJrasWMdTvQxS2TPEyLzRFP1pJP4NoVv7B2ynZZvHiy/pLp
         8N3OeWVr6q4mZAyUndDwVgTQw9+TW0ya/cHHmpOLY6iJXTmoFOjE5m7YPGRiCcH9FXcu
         IkEgWkdB3WhBtGnEzSoG2NkzykKoijDCwEP1fWKEqZOE/K1mXo5YA5oN7RBfeKTXFJkr
         m7XTbWr+qcJuIdGzr+ytGx/WyDEoYaX+eQNqC8KA3pRPtmlPD94n8ytFXcu8TfA0wdRg
         0vwg==
X-Gm-Message-State: AC+VfDxmLES+6sLisNIT7URDqXOxzfb2YRZHGVuTAUNpu9wiI2hMjObv
        LwKZxhBLAwiyJdU66M3GEZxf1hYX/pOxHAfEdikY6Q==
X-Google-Smtp-Source: ACHHUZ6hbJVg8k+ym3Y6f8JpHjSIABCLMheeU/pZuiiIfxNOllV4Xy5gjeJ5oiMqS1HX2M5YJI+Iy2L/NxfbfD2cMlE=
X-Received: by 2002:ad4:5ecc:0:b0:623:7707:5650 with SMTP id
 jm12-20020ad45ecc000000b0062377075650mr1894478qvb.15.1684458467209; Thu, 18
 May 2023 18:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com> <CAGtprH_+bF4VZg2ps6CM8vjJVvShsvSGAvaLfTedts4cKqhSUw@mail.gmail.com>
 <ZFwPBqGeW+d9xMEs@google.com> <CAGtprH8jUAM015h4eEhbdAv6Oq2UNbX3P5Z-VCVbcrHtnATJwQ@mail.gmail.com>
 <ZF1Oh5qrgcNNZ7Jc@google.com>
In-Reply-To: <ZF1Oh5qrgcNNZ7Jc@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Thu, 18 May 2023 18:07:36 -0700
Message-ID: <CAGtprH_H1afUJ2cUnznWqYLTZVuEcOogRwXF6uBAeHbLMQsrsQ@mail.gmail.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 1:22=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> ...
> Ah, you're effectively suggesting a hybrid model where the file is the si=
ngle
> source of truth for what's private versus shared, ad KVM gets pfns throug=
h
> direct communication with the backing store via the file descriptor, but =
userspace
> can still control things via mmap() and friends.
>
> If you're not suggesting a backdoor, i.e. KVM still gets private pfns via=
 hvas,
> then we're back at Kirill's series, because otherwise there's no easy way=
 for KVM
> to retrieve the pfn.
>

Yeah, I was hinting towards using the backdoor, where KVM still gets
private pfns via HVAs.

> A form of this was also discussed, though I don't know how much of the di=
scussion
> happened on-list.
>
> KVM actually does something like this for s390's Ultravisor (UV), which i=
s quite
> a bit like TDX (UV is a trusted intermediary) except that it handles faul=
ts much,
> much more gracefully.  Specifically, when the untrusted host attempts to =
access a
> secure page, a fault occurs and the kernel responds by telling UV to expo=
rt the
> page.  The fault is gracefully handled even even for kernel accesses
> (see do_secure_storage_access()).  The kernel does BUG() if the export fa=
ils when
> handling fault from kernel context, but my understanding is that export c=
an fail
> if and only if there's a fatal error elsewhere, i.e. the UV essentialy _e=
nsures_
> success, and goes straight to BUG()/panic() if something goes wrong.
>
> On the guest side, accesses to exported (swapped) secure pages generate i=
ntercepts
> and KVM faults in the page.  To do so, KVM freezes the page/folio refcoun=
t, tells
> the UV to import the page, and then unfreezes the page/folio.  But very c=
rucially,
> when _anything_ in the untrusted host attempts to access the secure page,=
 the
> above fault handling for untrusted host accesses kicks in.  In other word=
s, the
> guest can cause thrash, but can't bring down the host.
>

Yeah, this is very similar to what I was trying to propose. Except in
this case, the backing store i.e. guest_mem will have to let the fault
be unhandled for untrusted host accesses to private ranges of
guest_mem file.

> TDX on the other hand silently poisons memory, i.e. doesn't even generate=
 a
> synchronous fault.  Thus the kernel needs to be 100% perfect on preventin=
g _any_
> accesses to private memory from the host, and doing that is non-trivial a=
nd
> invasive.
>
> SNP does synchronously fault, but the automatically converting in the #PF=
 handler
> got NAK'd[*] for good reasons, e.g. SNP doesn't guarantee conversion succ=
ess as the
> guest can trigger concurrent RMP modifications.  So the end result ends u=
p being
> the same as TDX, host accesses need to be completely prevented.
>
> Again, this is all doable, but costly.  And IMO, provides very little val=
ue.

With this hybrid approach with the backdoor access to pfns from KVM,
do we see a scenario where host can bypass the guest_mem restrictions
and still be able to access the private ranges using HVA ranges? One
possibility is that these pages are mapped in the IOMMU (when they are
shared) and then get converted to private without getting unmapped
from IOMMU. Maybe KVM can disallow converting the ranges which are
pinned for DMA (not sure if there is a way to do that).

Few additional benefits here:
1) Possibly handle the pkvm usecase in this series without the need
for additional modifications.
2) Handling UPM for normal VMs possibly could get simpler as this
hybrid approach can allow preserving the contents across conversions.

>
> Allowing things like mbind() is nice-to-have at best, as implementing fbi=
nd()
> isn't straightforward and arguably valuable to have irrespective of this
> discussion, e.g. to allow userspace to say "use this policy regardless of=
 what
> process maps the file".
>

Agreed, having mbind supported is not a significant gain given the cost her=
e.

> Using a common memory pool (same physical page is used for both shared an=
d private)
> is a similar story.  There are plenty of existing controls to limit users=
pace/guest
> memory usage and to deal with OOM scenarios, so barring egregious host ac=
counting
> and/or limiting bugs, which would affect _all_ VM types, the worst case s=
cenario
> is that a VM is terminated because host userspace is buggy.  On the slip =
side, using
> a common pool brings complexity into the kernel, as backing stores would =
need to
> be taught to deny access to a subset of pages in their mappings, and in m=
ultiple
> paths, e.g. faults, read()/write() and similar, page migration, swap, etc=
.

In this case the backing store that needs to be modified would just be
guest_mem though.

>
> [*] https://lore.kernel.org/linux-mm/8a244d34-2b10-4cf8-894a-1bf12b59cf92=
@www.fastmail.com
>
> > > Issues that led to us abandoning the "map with special !Present PTEs"=
 approach:
> > >
> > >  - Using page tables, i.e. hardware defined structures, to track gfn=
=3D>pfn mappings
> > >    is inefficient and inflexible compared to software defined structu=
res, especially
> > >    for the expected use cases for CoCo guests.
> > >
> > >  - The kernel wouldn't _easily_ be able to enforce a 1:1 page:guest a=
ssociation,
> > >    let alone a 1:1 pfn:gfn mapping.
> >
> > Maybe KVM can ensure that each page of the guest_mem file is
> > associated with a single memslot.
>
> This is a hard NAK.  Guest physical address space is guaranteed to have h=
oles
> and/or be discontiguous, for the PCI hole at the top of lower memory.  Al=
lowing
> only a single binding would prevent userspace from backing all (or large =
chunks)
> of guest memory with a single file.
>

Poor choice of words from my side. I meant to suggest that KVM can
ensure that ANY page of the guest_mem file is associated with at max
one memslot.

> ...
> That'd work for the hybrid model (fd backdoor with pseudo mmap() support)=
, but
> not for a generic VMA-based implementation.  If the file isn't the single=
 source
> of truth, then forcing all mappings to go away simply can't work.
>
> > > #3 is also a limiter.  E.g. if a guest is primarly backed by 1GiB pag=
es, keeping
> > > the 1GiB mapping is desirable if the guest converts a few KiB of memo=
ry to shared,
> > > and possibly even if the guest converts a few MiB of memory.
> >
> > This caveat maybe can be lived with as shared ranges most likely will
> > not be backed by 1G pages anyways, possibly causing IO performance to
> > get hit. This possibly needs more discussion about conversion
> > granularity used by guests.
>
> Yes, it's not the end of the world.  My point is that separating shared a=
nd private
> memory provides more flexibility.  Maybe that flexibility never ends up b=
eing
> super important, but at the same time we shouldn't willingly paint oursel=
ves into
> a corner.

There are some performance implications here with the split approach.

This flexibility is actually coming with the cost of managing double
allocation effectively. As the granularity of mappings increases for
the shared memory, it gets difficult to cap the amount of double
allocation. So effectively it comes down to always using smaller
granularity for shared memory and also the private memory for
converted ranges. In general the performance requirements would always
try to push for higher mapping granularities depending on the scale of
usage.

In general private memory (and also the shared memory on respective
conversions) will always need to be hole punched to ensure that the
double allocation won't happen. And so, even if this is something for
the future, using hugetlbfs pages for backing private memory with the
split model effectively makes it impossible to cap the double
allocation. I am not sure if the 1G pages can be handled better with
the hybrid model but maybe it's worth checking.

Split shared/private mem approach also increases the uncertainties
around memory management in general where the same amount of memory
which was available earlier is first freed to the system and then
allocated back from the system. .e.g. Even if hugepages were around
when private memory was initially allocated, further allocations keep
increasing the possibilities of not being able to use a huge page to
back the memory even if the whole huge page is private/shared.
