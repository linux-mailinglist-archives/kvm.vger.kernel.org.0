Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F78863A371
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiK1IuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiK1IuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:50:10 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4202E13D6A
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:50:08 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id z24so12313686ljn.4
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d8cFrTuqpybHjcLlJGVLVIXpcVGudopruUC7moy2owk=;
        b=VcVymauxkDfiJWVo4bvxaS0Dh7MPVxYWDuA9JGgSqFnZjnq5RDt2F7lg6vsqJvNE4L
         p9HNlIRksuaGBxmFFbgkA6/a6+b1xHQUYbO2RwSJbfSGYtfNDfQ8h4EVm0xnPVw+rMq1
         YvBp9PAbPCXWhHct9uk10KA1lWh/yfUgUTBJVAIZEnasVtUBjFPnyCCo/NDeMD70ZT3s
         IzbZxS7pKfpgzzJNfFAqoLVI0bLQVUNd0yVUGs4hwh7lwUUBuy5DHRjLWkNwKM5XrdgM
         0HS0a88Kd71QsNGso9aJti7Xt3mv7dVyLb0c9DSOkgDp5IVGfIq48APVy8dn9TBiO5D0
         XJdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d8cFrTuqpybHjcLlJGVLVIXpcVGudopruUC7moy2owk=;
        b=gz8f028uTTPjHU6r5glm7GbArExbpEAotT+4saLFg/tAllh+JO20HuYWd4mBli4U6g
         w2p/FkkXuMEYObNVhRBjEtgq0mLlPy4HP5e9bYIRr9cKb1dRYaPO9YOoKuVjhxt/qIYv
         /SWHAQW1vDcRJ4BdY2dfhGHpxMAqJ0GanHS0SR6ywOaV43SWYhFFQiNo0iWj/Y57rXF6
         t0+ayR8DDSl0UWckcmExCMqkJn94MQ/2LcKwImGiOBfom4BKs/gfLCP4kzLMqEXOwvT2
         s4TNXgc5XVCCC5DKjsqK4qKcRCHkRN+6OF1X7HLyQnNlU00VKoc2XeY9JcZKISdouxRQ
         F7gw==
X-Gm-Message-State: ANoB5plZc0b3CxABFDdLxUrGhOlMUCOVh2OUsACjBkbcyw4Bcer09NXP
        nTqUmRZM7Q+T13ufw9PzT7GMVTyi5XIpWCA4GyH1nM9+zili8w==
X-Google-Smtp-Source: AA0mqf7O18BYIa1LIB6rc5pui0vCBkBx6NoG330HDmgY3hcyee09aTJW1rrwRJ42PZpqx2uqkLkE7yjBklRCxNu8Dw8=
X-Received: by 2002:a2e:9256:0:b0:279:823d:77c7 with SMTP id
 v22-20020a2e9256000000b00279823d77c7mr6100733ljg.92.1669625406300; Mon, 28
 Nov 2022 00:50:06 -0800 (PST)
MIME-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com> <20221115111549.2784927-9-tabba@google.com>
 <Y39PCG0ZRHf/2d5E@monolith.localdoman> <CA+EHjTx6JRODjncxMz6pBO43S2gAFZt4vDibG=Zwbr7TkbiFeQ@mail.gmail.com>
 <Y3+meXHu5MRYuHou@monolith.localdoman> <CA+EHjTwgg+Cu=A3msmWLNEHmkJhOn-8+MeJULOHzF6V99iHk1A@mail.gmail.com>
 <Y4CnPcHyt5IPAoF/@monolith.localdoman>
In-Reply-To: <Y4CnPcHyt5IPAoF/@monolith.localdoman>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 28 Nov 2022 08:49:29 +0000
Message-ID: <CA+EHjTzf5-Rsi9-hzfMiYPUB8_C9UmkJuJiZpD8VSe9CNt2_aw@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 08/17] Use memfd for all guest ram allocations
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

First I want to mention that I really appreciate your feedback, which
has already been quite helpful. I would like you to please consider
this to be an RFC, and let's use these patches as a basis for
discussion and how they can be improved when I respin them, even if
that means waiting until the kvm fd-based proposal is finalized.

Now to answer your question...

<snip>

> > My reasoning for allocating all memory with memfd is that it's one
> > ring to rule them all :) By that I mean, with memfd, we can allocate
> > normal memory, hugetlb memory, in the future guest private memory, and
> > easily expand it to support things like IPC memory sharing in the
> > future.
>
> Allocating anonymous memory is more complex now. And I could argue than t=
he
> hugetlbfs case is also more complex because there are now two branches th=
at
> do different things based whether it's hugetlbfs or not, instead of one.

The additional complexity now comes not from using memfd, but from
unmapping and aligning code, which I think does benefit kvmtool in
general.

Hugetlbfd already had a different path before, now at least the other
path it has just has to do with setting flags for memfd_create(),
rather than allocating memory differently.


> As I stands right now, my opinion is that using memfd for anonymous RAM
> only adds complexity for zero benefits.
> >
> >
> > > >
> > > > Moreover, using an fd would be more generic and flexible, which all=
ows
> > > > for other use cases (such as IPC), or to map that memory in userspa=
ce
> > > > when appropriate. It also allows us to use the same interface for
> > > > hugetlb. Considering that other VMMs (e.g., qemu [2], crosvm [3])
> > > > already back guest memory with memfd, and looking at how private
> > > > memory would work [4], it seemed to me that the best way to unify a=
ll
> > > > of these needs is to have the backend of guest memory be fd-based.
> > > >
> > > > It would be possible to have that as a separate kvmtool option, whe=
re
> > > > fd-backed memory would be only for guests that use the new private
> > > > memory extensions. However, that would mean more code to maintain t=
hat
> > > > is essentially doing the same thing (allocating and mapping memory)=
.
> > > >
> > > > I thought that it would be worth having these patches in kvmtool no=
w
> > > > rather than wait until the guest private memory has made it into kv=
m.
> > > > These patches simplify the code as an end result, make it easier to
> > >
> > > In the non-hugetlbfs case, before:
> > >
> > >         kvm->arch.ram_alloc_size =3D kvm->ram_size + SZ_2M;
> > >         kvm->arch.ram_alloc_start =3D mmap_anon_or_hugetlbfs(kvm, kvm=
->cfg.hugetlbfs_path, kvm->arch.ram_alloc_size);
> > >
> > >         /*
> > >          * mmap_anon_or_hugetlbfs expands to:
> > >          * getpagesize()
> > >          * mmap()
> > >          */
> > >
> > >         kvm->ram_start =3D (void *)ALIGN((unsigned long)kvm->arch.ram=
_alloc_start, SZ_2M);
> > >
> > > After:
> > >         /* mmap_anon_or_hugetlbfs: */
> > >         getpagesize();
> > >         mmap(NULL, total_map, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS,=
 -1, 0);
> > >         memfd_alloc(size, htlbfs_path, blk_size);
> > >
> > >         /*
> > >          * memfd_alloc() expands to:
> > >          * memfd_create()
> > >          * ftruncate
> > >          */
> > >
> > >         addr_align =3D (void *)ALIGN((u64)addr_map, align_sz);
> > >         mmap(addr_align, size, PROT_RW, MAP_PRIVATE | MAP_FIXED, fd, =
0);
> > >
> > > I'm counting one extra mmap(), one memfd_create() and one ftruncate()=
 that
> > > this series adds (not to mention all the boiler plate code to check f=
or
> > > errors).
> > >
> > > Let's use another metric, let's count the number of lines of code. Be=
fore:
> > > 9 lines of code, after: -3 lines removed from arm/kvm.c and 86 lines =
of
> > > code for memfd_alloc() and mmap_anon_or_hugetlbfs_align().
> > >
> > > I'm struggling to find a metric by which the resulting code is simple=
r, as
> > > you suggest.
> >
> > With simpler I didn't mean fewer lines of code, rather that it's
> > easier to reason about, more shared code. With this series, hugetlb
>
> How is all of the code that has been added easier to reason about than on=
e
> single mmap call?
>
> > and normal memory creation follow the same path, and with the
> > refactoring a lot of arch-specific code is gone.
>
> Can you point me to the arch-specific code that this series removes? As f=
ar
> as I can tell, the only arch specfic change is replacing
> kvm_arch_delete_ram with kvm_delete_ram, which can be done independently =
of
> this series. If it's only that function, I wouldn't call that "a lot" of
> arch-specific code.

kvmtool is an old and well established project. So I think that being
able to remove the memory-alignment code from the arm and riscv kvm.c,
two fields from the arm and riscv struct kvm_arch, as well as
kvm__arch_delete_ram from all architectures, is not that little for a
mature project such as this one. I agree that this could have been
done without using memfd, but at least for me, as a person who has
just posted their first contribution to kvmtool, it was easier to make
these changes when the tracking of the memory is based on an fd rather
than a userspace address (makes alignment and unmapping unused memory
much easier).

>
> >
> > >
> > > > allocate and map aligned memory without overallocating, and bring
> > >
> > > If your goal is to remove the overallocting of memory, you can just m=
unmap
> > > the extra memory after alignment is performed. To do that you don't n=
eed to
> > > allocate everything using a memfd.
> > >
> > > > kvmtool closer to a more consistent way of allocating guest memory,=
 in
> > > > a similar manner to other VMMs.
> > >
> > > I would really appreciate pointing me to where qemu allocates memory =
using
> > > memfd when invoked with -m <size>. I was able to follow the hostmem-r=
am
> > > backend allocation function until g_malloc0(), but I couldn't find th=
e
> > > implementation for that.
> >
> > You're right. I thought that the memfd backend was the default, but
> > looking again it's not.
> >
> > > >
> > > > Moreover, with the private memory proposal [1], whether the fd-base=
d
> > > > support available can be queried by a KVM capability. If it's
> > > > available kvmtool would use the fd, if it's not available, it would
> > > > use the host-mapped address. Therefore, there isn=E2=80=99t a need =
for a
> > > > command line option, unless for testing.
> > >
> > > Why would anyone want to use private memory by default for a
> > > non-confidential VM?
> >
> > The idea is that, at least when pKVM is enabled, we would use the
> > proposed extensions for all guests, i.e., memory via a file
> > descriptor, regardless whether the guest is protected (thus the memory
> > would be private), or not.
>
> kvmtool can be used to run virtual machines when pKVM is not enabled. In
> fact, it has been used that way for way longer than pKVM has existed. Wha=
t
> about those users?

This does not affect these users, which is the point of these patches.
This allows new uses as well as maintaining the existing one, and
enables potentially new ones in the future.

> >
> >
> > > >
> > > > I have implemented this all the way to support the private memory
> > > > proposal in kvmtool [5], but I haven=E2=80=99t posted these since t=
he private
> > > > memory proposal itself is still in flux. If you=E2=80=99re interest=
ed you
> > >
> > > Are you saying that you are not really sure how the userspace API wil=
l end
> > > up looking? If that's the case, wouldn't it make more sense to wait f=
or the
> > > API to stabilize and then send support for it as one nice series?
> >
> > Yes, I'm not sure how it will end up looking. We know that it will be
> > fd-based though, which is why I thought it might be good to start with
> > that.
>
> If you're not sure how it will end up looking, then why change kvmtool no=
w?

Because we are sure that it will be fd-based, and because I thought
that getting a head start to set the scene would be helpful. The part
that is uncertain is the kvm capabilities, flags, and names of the new
memory region extensions, none of which I address in these patches.

Cheers,
/fuad

> Thanks,
> Alex
>
> >
> > Cheers,
> > /fuad
> >
> >
> >
> > > Thanks,
> > > Alex
> > >
> > > > could have a look on how I would go ahead building on these patches
> > > > for full support of private memory backed by an fd.
> > > >
> > > > > Regarding IPC memory sharing, is mmap'ing an memfd file enough to=
 enable
> > > > > that? If more work is needed for it, then wouldn't it make more s=
ense to do
> > > > > all the changes at once? This change might look sensible right no=
w, but it
> > > > > might turn out that it was the wrong way to go about it when some=
one
> > > > > actually starts implementing memory sharing.
> > > >
> > > > I don=E2=80=99t plan on supporting IPC memory sharing. I just menti=
oned that
> > > > as yet another use case that would benefit from guest memory being
> > > > fd-based, should kvmtool decide to support it in the future.
> > > >
> > > > Cheers,
> > > > /fuad
> > > >
> > > > [1] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.pen=
g@linux.intel.com/
> > > > [2] https://github.com/qemu/qemu
> > > > [3] https://chromium.googlesource.com/chromiumos/platform/crosvm/
> > > > [4] https://github.com/chao-p/qemu/tree/privmem-v9
> > > > [5] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba=
/fdmem-v9-core
> > > >
> > > >
> > > >
> > > > >
> > > > > Regarding IPC memory sharing, is mmap'ing an memfd file enough to=
 enable
> > > > > that? If more work is needed for it, then wouldn't it make more s=
ense to do
> > > > > all the changes at once? This change might look sensible right no=
w, but it
> > > > > might turn out that it was the wrong way to go about it when some=
one
> > > > > actually starts implementing memory sharing.
> > > > >
> > > > > Thanks,
> > > > > Alex
> > > > >
> > > > > >
> > > > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > > >
> > > > > > [*] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p=
.peng@linux.intel.com/
> > > > > > ---
> > > > > >  include/kvm/kvm.h  |  1 +
> > > > > >  include/kvm/util.h |  3 +++
> > > > > >  kvm.c              |  4 ++++
> > > > > >  util/util.c        | 33 ++++++++++++++++++++-------------
> > > > > >  4 files changed, 28 insertions(+), 13 deletions(-)
> > > > > >
> > > > > > diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> > > > > > index 3872dc6..d0d519b 100644
> > > > > > --- a/include/kvm/kvm.h
> > > > > > +++ b/include/kvm/kvm.h
> > > > > > @@ -87,6 +87,7 @@ struct kvm {
> > > > > >       struct kvm_config       cfg;
> > > > > >       int                     sys_fd;         /* For system ioc=
tls(), i.e. /dev/kvm */
> > > > > >       int                     vm_fd;          /* For VM ioctls(=
) */
> > > > > > +     int                     ram_fd;         /* For guest memo=
ry. */
> > > > > >       timer_t                 timerid;        /* Posix timer fo=
r interrupts */
> > > > > >
> > > > > >       int                     nrcpus;         /* Number of cpus=
 to run */
> > > > > > diff --git a/include/kvm/util.h b/include/kvm/util.h
> > > > > > index 61a205b..369603b 100644
> > > > > > --- a/include/kvm/util.h
> > > > > > +++ b/include/kvm/util.h
> > > > > > @@ -140,6 +140,9 @@ static inline int pow2_size(unsigned long x=
)
> > > > > >  }
> > > > > >
> > > > > >  struct kvm;
> > > > > > +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
> > > > > > +void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char=
 *htlbfs_path,
> > > > > > +                                u64 size, u64 align);
> > > > > >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlb=
fs_path, u64 size);
> > > > > >
> > > > > >  #endif /* KVM__UTIL_H */
> > > > > > diff --git a/kvm.c b/kvm.c
> > > > > > index 78bc0d8..ed29d68 100644
> > > > > > --- a/kvm.c
> > > > > > +++ b/kvm.c
> > > > > > @@ -160,6 +160,7 @@ struct kvm *kvm__new(void)
> > > > > >       mutex_init(&kvm->mem_banks_lock);
> > > > > >       kvm->sys_fd =3D -1;
> > > > > >       kvm->vm_fd =3D -1;
> > > > > > +     kvm->ram_fd =3D -1;
> > > > > >
> > > > > >  #ifdef KVM_BRLOCK_DEBUG
> > > > > >       kvm->brlock_sem =3D (pthread_rwlock_t) PTHREAD_RWLOCK_INI=
TIALIZER;
> > > > > > @@ -174,6 +175,9 @@ int kvm__exit(struct kvm *kvm)
> > > > > >
> > > > > >       kvm__arch_delete_ram(kvm);
> > > > > >
> > > > > > +     if (kvm->ram_fd >=3D 0)
> > > > > > +             close(kvm->ram_fd);
> > > > > > +
> > > > > >       list_for_each_entry_safe(bank, tmp, &kvm->mem_banks, list=
) {
> > > > > >               list_del(&bank->list);
> > > > > >               free(bank);
> > > > > > diff --git a/util/util.c b/util/util.c
> > > > > > index d3483d8..278bcc2 100644
> > > > > > --- a/util/util.c
> > > > > > +++ b/util/util.c
> > > > > > @@ -102,36 +102,38 @@ static u64 get_hugepage_blk_size(const ch=
ar *htlbfs_path)
> > > > > >       return sfs.f_bsize;
> > > > > >  }
> > > > > >
> > > > > > -static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbf=
s_path, u64 size, u64 blk_size)
> > > > > > +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
> > > > > >  {
> > > > > >       const char *name =3D "kvmtool";
> > > > > >       unsigned int flags =3D 0;
> > > > > >       int fd;
> > > > > > -     void *addr;
> > > > > > -     int htsize =3D __builtin_ctzl(blk_size);
> > > > > >
> > > > > > -     if ((1ULL << htsize) !=3D blk_size)
> > > > > > -             die("Hugepage size must be a power of 2.\n");
> > > > > > +     if (hugetlb) {
> > > > > > +             int htsize =3D __builtin_ctzl(blk_size);
> > > > > >
> > > > > > -     flags |=3D MFD_HUGETLB;
> > > > > > -     flags |=3D htsize << MFD_HUGE_SHIFT;
> > > > > > +             if ((1ULL << htsize) !=3D blk_size)
> > > > > > +                     die("Hugepage size must be a power of 2.\=
n");
> > > > > > +
> > > > > > +             flags |=3D MFD_HUGETLB;
> > > > > > +             flags |=3D htsize << MFD_HUGE_SHIFT;
> > > > > > +     }
> > > > > >
> > > > > >       fd =3D memfd_create(name, flags);
> > > > > >       if (fd < 0)
> > > > > > -             die("Can't memfd_create for hugetlbfs map\n");
> > > > > > +             die("Can't memfd_create for memory map\n");
> > > > > > +
> > > > > >       if (ftruncate(fd, size) < 0)
> > > > > >               die("Can't ftruncate for mem mapping size %lld\n"=
,
> > > > > >                       (unsigned long long)size);
> > > > > > -     addr =3D mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
> > > > > > -     close(fd);
> > > > > >
> > > > > > -     return addr;
> > > > > > +     return fd;
> > > > > >  }
> > > > > >
> > > > > >  /* This function wraps the decision between hugetlbfs map (if =
requested) or normal mmap */
> > > > > >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlb=
fs_path, u64 size)
> > > > > >  {
> > > > > >       u64 blk_size =3D 0;
> > > > > > +     int fd;
> > > > > >
> > > > > >       /*
> > > > > >        * We don't /need/ to map guest RAM from hugetlbfs, but w=
e do so
> > > > > > @@ -146,9 +148,14 @@ void *mmap_anon_or_hugetlbfs(struct kvm *k=
vm, const char *htlbfs_path, u64 size)
> > > > > >               }
> > > > > >
> > > > > >               kvm->ram_pagesize =3D blk_size;
> > > > > > -             return mmap_hugetlbfs(kvm, htlbfs_path, size, blk=
_size);
> > > > > >       } else {
> > > > > >               kvm->ram_pagesize =3D getpagesize();
> > > > > > -             return mmap(NULL, size, PROT_RW, MAP_ANON_NORESER=
VE, -1, 0);
> > > > > >       }
> > > > > > +
> > > > > > +     fd =3D memfd_alloc(size, htlbfs_path, blk_size);
> > > > > > +     if (fd < 0)
> > > > > > +             return MAP_FAILED;
> > > > > > +
> > > > > > +     kvm->ram_fd =3D fd;
> > > > > > +     return mmap(NULL, size, PROT_RW, MAP_PRIVATE, kvm->ram_fd=
, 0);
> > > > > >  }
> > > > > > --
> > > > > > 2.38.1.431.g37b22c650d-goog
> > > > > >
