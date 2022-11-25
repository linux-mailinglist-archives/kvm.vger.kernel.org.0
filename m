Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD06387C6
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 11:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiKYKp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 05:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiKYKpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 05:45:19 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1842B4841D
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 02:45:18 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z24so4716158ljn.4
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 02:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4HxSA8JevuJ7/n/R8Iqtjw4EJlKJcsysck7vEuv1rU=;
        b=f1MTrENBZ0dEd91IpzJK+n/GfA1e0ljJOi/tXWuMLVsm/dUin88IAhXs1JgKU9LlwX
         UCpUkEM7ZRSwoYzQKj+yL/QmQp3eFsKhE3RpKBZzWPOplDvP/mPyxtxfWPuACzoEojfI
         O/jop6Ig0F8XfBU9JIK86tqnRaI9iHxBL5+Oo3Ilt/Rob5OKw5FK8wSb+dCmfLNpkruv
         Ft65pMsEaBI4JFnU0ejwC26+t5VV1/JzXUP9PJL0S/10tcTjwc97/S56c469/yNy2Ll4
         mutYN/ecWKxQyqeB4Tv96hjqxsy05SmD79BUOs/TmftFGELoRErQG/s2hLA5jPxk5Cjt
         S5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P4HxSA8JevuJ7/n/R8Iqtjw4EJlKJcsysck7vEuv1rU=;
        b=KmZTwd/4To196hux3TmGsbeaBf53TowXzvfNLeyhEHEfLQ/1JhKFu6QAmeRaIi+pbv
         BrpSRtpU9+4oWJAJJsDiOQTnQ9kAum69VRY6cdJB/LW1qi09lWm4DA5PgT9ir88+hkkT
         EL4GeTj05FND1L8sZK4LE12FHm6F91tqXWUijb0H5zMx1XM62JAEjAda76xF+9T4DluS
         Nus5aKxvS6gurbIW6LAfP1XLdA4dOsBb0zbuJVQ0Qjs3lu6wkZVeohF+QAYVnuv4jv6b
         tPlK/PUorU/xMEeU2qUAUtvAPAEyZche7dbG3hdQt0eu1PYNQzBy4T3WE8ecHjOPVg0V
         FqrQ==
X-Gm-Message-State: ANoB5plSvd9sXYlN46w8qDpE+ZBoURt98mABt3RbSP7kHQdG0+CIEKOR
        UJldQ+t6zl4tLWnOqOgl+seOwOUyZpNWxF/V05StpQ==
X-Google-Smtp-Source: AA0mqf50qvQGtpt9Jle7LKC3MSBZ77VpQZaAO8FjvzDLhhN0KgzAqEQW74f/jQAZly5LZ2rEsucWeuG2xe6jqtXFKuA=
X-Received: by 2002:a2e:a90a:0:b0:26d:ccb6:1d47 with SMTP id
 j10-20020a2ea90a000000b0026dccb61d47mr6767952ljq.199.1669373116084; Fri, 25
 Nov 2022 02:45:16 -0800 (PST)
MIME-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com> <20221115111549.2784927-9-tabba@google.com>
 <Y39PCG0ZRHf/2d5E@monolith.localdoman> <CA+EHjTx6JRODjncxMz6pBO43S2gAFZt4vDibG=Zwbr7TkbiFeQ@mail.gmail.com>
 <Y3+meXHu5MRYuHou@monolith.localdoman>
In-Reply-To: <Y3+meXHu5MRYuHou@monolith.localdoman>
From:   Fuad Tabba <tabba@google.com>
Date:   Fri, 25 Nov 2022 10:44:39 +0000
Message-ID: <CA+EHjTwgg+Cu=A3msmWLNEHmkJhOn-8+MeJULOHzF6V99iHk1A@mail.gmail.com>
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

On Thu, Nov 24, 2022 at 5:14 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Thu, Nov 24, 2022 at 03:19:34PM +0000, Fuad Tabba wrote:
> > Hi,
> >
> > On Thu, Nov 24, 2022 at 11:01 AM Alexandru Elisei
> > <alexandru.elisei@arm.com> wrote:
> > >
> > > Hi,
> > >
> > > On Tue, Nov 15, 2022 at 11:15:40AM +0000, Fuad Tabba wrote:
> > > > Allocate all guest ram backed by memfd/ftruncate instead of
> > > > anonymous mmap. This will make it easier to use kvm with fd-based
> > > > kvm guest memory proposals [*]. It also would make it easier to
> > > > use ipc memory sharing should that be needed in the future.
> > >
> > > Today, there are two memory allocation paths:
> > >
> > > - One using hugetlbfs when --hugetlbfs is specified on the command li=
ne, which
> > >   creates a file.
> > >
> > > - One using mmap, when --hugetlbfs is not specified.
> > >
> > > How would support in kvmtool for the secret memfd look like? I assume=
 there
> > > would need to be some kind of command line parameter to kvmtool to in=
struct it
> > > to use the secret memfd, right? What I'm trying to figure out is why =
is
> > > necessary to make everything a memfd file instead of adding a third m=
emory
> > > allocation path just for that particular usecase (or merging the huge=
tlbfs path
> > > if they are similar enough). Right now, the anonymous memory path is =
a
> > > mmap(MAP_ANONYMOUS) call, simple and straightforward, and I would lik=
e some more
> > > convincing that this change is needed.
> >
> > This isn't about secret mem, but about the unified proposal for guest
> > private memory [1].  This proposal requires the use of a file
> > descriptor (fd) as the canonical reference to guest memory in the host
> > (i.e., VMM) and does not provide an alternative using a
> > straightforward anonymous mmap(). The idea is that guest memory
> > shouldn=E2=80=99t have mapping in the host by default, but unless expli=
citly
> > shared and needed.
>
> I think you misunderstood me. I wasn't asking why kvmtool should get
> support for guest private memory, I was asking why kvmtool should allocat=
e
> **all types of memory** using memfd. Your series allocates **all** memory
> using memfd. I never said that kvmtool should or should not get support f=
or
> private memory.

My reasoning for allocating all memory with memfd is that it's one
ring to rule them all :) By that I mean, with memfd, we can allocate
normal memory, hugetlb memory, in the future guest private memory, and
easily expand it to support things like IPC memory sharing in the
future.


> >
> > Moreover, using an fd would be more generic and flexible, which allows
> > for other use cases (such as IPC), or to map that memory in userspace
> > when appropriate. It also allows us to use the same interface for
> > hugetlb. Considering that other VMMs (e.g., qemu [2], crosvm [3])
> > already back guest memory with memfd, and looking at how private
> > memory would work [4], it seemed to me that the best way to unify all
> > of these needs is to have the backend of guest memory be fd-based.
> >
> > It would be possible to have that as a separate kvmtool option, where
> > fd-backed memory would be only for guests that use the new private
> > memory extensions. However, that would mean more code to maintain that
> > is essentially doing the same thing (allocating and mapping memory).
> >
> > I thought that it would be worth having these patches in kvmtool now
> > rather than wait until the guest private memory has made it into kvm.
> > These patches simplify the code as an end result, make it easier to
>
> In the non-hugetlbfs case, before:
>
>         kvm->arch.ram_alloc_size =3D kvm->ram_size + SZ_2M;
>         kvm->arch.ram_alloc_start =3D mmap_anon_or_hugetlbfs(kvm, kvm->cf=
g.hugetlbfs_path, kvm->arch.ram_alloc_size);
>
>         /*
>          * mmap_anon_or_hugetlbfs expands to:
>          * getpagesize()
>          * mmap()
>          */
>
>         kvm->ram_start =3D (void *)ALIGN((unsigned long)kvm->arch.ram_all=
oc_start, SZ_2M);
>
> After:
>         /* mmap_anon_or_hugetlbfs: */
>         getpagesize();
>         mmap(NULL, total_map, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1,=
 0);
>         memfd_alloc(size, htlbfs_path, blk_size);
>
>         /*
>          * memfd_alloc() expands to:
>          * memfd_create()
>          * ftruncate
>          */
>
>         addr_align =3D (void *)ALIGN((u64)addr_map, align_sz);
>         mmap(addr_align, size, PROT_RW, MAP_PRIVATE | MAP_FIXED, fd, 0);
>
> I'm counting one extra mmap(), one memfd_create() and one ftruncate() tha=
t
> this series adds (not to mention all the boiler plate code to check for
> errors).
>
> Let's use another metric, let's count the number of lines of code. Before=
:
> 9 lines of code, after: -3 lines removed from arm/kvm.c and 86 lines of
> code for memfd_alloc() and mmap_anon_or_hugetlbfs_align().
>
> I'm struggling to find a metric by which the resulting code is simpler, a=
s
> you suggest.

With simpler I didn't mean fewer lines of code, rather that it's
easier to reason about, more shared code. With this series, hugetlb
and normal memory creation follow the same path, and with the
refactoring a lot of arch-specific code is gone.

>
> > allocate and map aligned memory without overallocating, and bring
>
> If your goal is to remove the overallocting of memory, you can just munma=
p
> the extra memory after alignment is performed. To do that you don't need =
to
> allocate everything using a memfd.
>
> > kvmtool closer to a more consistent way of allocating guest memory, in
> > a similar manner to other VMMs.
>
> I would really appreciate pointing me to where qemu allocates memory usin=
g
> memfd when invoked with -m <size>. I was able to follow the hostmem-ram
> backend allocation function until g_malloc0(), but I couldn't find the
> implementation for that.

You're right. I thought that the memfd backend was the default, but
looking again it's not.

> >
> > Moreover, with the private memory proposal [1], whether the fd-based
> > support available can be queried by a KVM capability. If it's
> > available kvmtool would use the fd, if it's not available, it would
> > use the host-mapped address. Therefore, there isn=E2=80=99t a need for =
a
> > command line option, unless for testing.
>
> Why would anyone want to use private memory by default for a
> non-confidential VM?

The idea is that, at least when pKVM is enabled, we would use the
proposed extensions for all guests, i.e., memory via a file
descriptor, regardless whether the guest is protected (thus the memory
would be private), or not.


> >
> > I have implemented this all the way to support the private memory
> > proposal in kvmtool [5], but I haven=E2=80=99t posted these since the p=
rivate
> > memory proposal itself is still in flux. If you=E2=80=99re interested y=
ou
>
> Are you saying that you are not really sure how the userspace API will en=
d
> up looking? If that's the case, wouldn't it make more sense to wait for t=
he
> API to stabilize and then send support for it as one nice series?

Yes, I'm not sure how it will end up looking. We know that it will be
fd-based though, which is why I thought it might be good to start with
that.

Cheers,
/fuad



> Thanks,
> Alex
>
> > could have a look on how I would go ahead building on these patches
> > for full support of private memory backed by an fd.
> >
> > > Regarding IPC memory sharing, is mmap'ing an memfd file enough to ena=
ble
> > > that? If more work is needed for it, then wouldn't it make more sense=
 to do
> > > all the changes at once? This change might look sensible right now, b=
ut it
> > > might turn out that it was the wrong way to go about it when someone
> > > actually starts implementing memory sharing.
> >
> > I don=E2=80=99t plan on supporting IPC memory sharing. I just mentioned=
 that
> > as yet another use case that would benefit from guest memory being
> > fd-based, should kvmtool decide to support it in the future.
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.peng@li=
nux.intel.com/
> > [2] https://github.com/qemu/qemu
> > [3] https://chromium.googlesource.com/chromiumos/platform/crosvm/
> > [4] https://github.com/chao-p/qemu/tree/privmem-v9
> > [5] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/fdm=
em-v9-core
> >
> >
> >
> > >
> > > Regarding IPC memory sharing, is mmap'ing an memfd file enough to ena=
ble
> > > that? If more work is needed for it, then wouldn't it make more sense=
 to do
> > > all the changes at once? This change might look sensible right now, b=
ut it
> > > might turn out that it was the wrong way to go about it when someone
> > > actually starts implementing memory sharing.
> > >
> > > Thanks,
> > > Alex
> > >
> > > >
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > >
> > > > [*] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.pen=
g@linux.intel.com/
> > > > ---
> > > >  include/kvm/kvm.h  |  1 +
> > > >  include/kvm/util.h |  3 +++
> > > >  kvm.c              |  4 ++++
> > > >  util/util.c        | 33 ++++++++++++++++++++-------------
> > > >  4 files changed, 28 insertions(+), 13 deletions(-)
> > > >
> > > > diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> > > > index 3872dc6..d0d519b 100644
> > > > --- a/include/kvm/kvm.h
> > > > +++ b/include/kvm/kvm.h
> > > > @@ -87,6 +87,7 @@ struct kvm {
> > > >       struct kvm_config       cfg;
> > > >       int                     sys_fd;         /* For system ioctls(=
), i.e. /dev/kvm */
> > > >       int                     vm_fd;          /* For VM ioctls() */
> > > > +     int                     ram_fd;         /* For guest memory. =
*/
> > > >       timer_t                 timerid;        /* Posix timer for in=
terrupts */
> > > >
> > > >       int                     nrcpus;         /* Number of cpus to =
run */
> > > > diff --git a/include/kvm/util.h b/include/kvm/util.h
> > > > index 61a205b..369603b 100644
> > > > --- a/include/kvm/util.h
> > > > +++ b/include/kvm/util.h
> > > > @@ -140,6 +140,9 @@ static inline int pow2_size(unsigned long x)
> > > >  }
> > > >
> > > >  struct kvm;
> > > > +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
> > > > +void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *ht=
lbfs_path,
> > > > +                                u64 size, u64 align);
> > > >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_p=
ath, u64 size);
> > > >
> > > >  #endif /* KVM__UTIL_H */
> > > > diff --git a/kvm.c b/kvm.c
> > > > index 78bc0d8..ed29d68 100644
> > > > --- a/kvm.c
> > > > +++ b/kvm.c
> > > > @@ -160,6 +160,7 @@ struct kvm *kvm__new(void)
> > > >       mutex_init(&kvm->mem_banks_lock);
> > > >       kvm->sys_fd =3D -1;
> > > >       kvm->vm_fd =3D -1;
> > > > +     kvm->ram_fd =3D -1;
> > > >
> > > >  #ifdef KVM_BRLOCK_DEBUG
> > > >       kvm->brlock_sem =3D (pthread_rwlock_t) PTHREAD_RWLOCK_INITIAL=
IZER;
> > > > @@ -174,6 +175,9 @@ int kvm__exit(struct kvm *kvm)
> > > >
> > > >       kvm__arch_delete_ram(kvm);
> > > >
> > > > +     if (kvm->ram_fd >=3D 0)
> > > > +             close(kvm->ram_fd);
> > > > +
> > > >       list_for_each_entry_safe(bank, tmp, &kvm->mem_banks, list) {
> > > >               list_del(&bank->list);
> > > >               free(bank);
> > > > diff --git a/util/util.c b/util/util.c
> > > > index d3483d8..278bcc2 100644
> > > > --- a/util/util.c
> > > > +++ b/util/util.c
> > > > @@ -102,36 +102,38 @@ static u64 get_hugepage_blk_size(const char *=
htlbfs_path)
> > > >       return sfs.f_bsize;
> > > >  }
> > > >
> > > > -static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_pa=
th, u64 size, u64 blk_size)
> > > > +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
> > > >  {
> > > >       const char *name =3D "kvmtool";
> > > >       unsigned int flags =3D 0;
> > > >       int fd;
> > > > -     void *addr;
> > > > -     int htsize =3D __builtin_ctzl(blk_size);
> > > >
> > > > -     if ((1ULL << htsize) !=3D blk_size)
> > > > -             die("Hugepage size must be a power of 2.\n");
> > > > +     if (hugetlb) {
> > > > +             int htsize =3D __builtin_ctzl(blk_size);
> > > >
> > > > -     flags |=3D MFD_HUGETLB;
> > > > -     flags |=3D htsize << MFD_HUGE_SHIFT;
> > > > +             if ((1ULL << htsize) !=3D blk_size)
> > > > +                     die("Hugepage size must be a power of 2.\n");
> > > > +
> > > > +             flags |=3D MFD_HUGETLB;
> > > > +             flags |=3D htsize << MFD_HUGE_SHIFT;
> > > > +     }
> > > >
> > > >       fd =3D memfd_create(name, flags);
> > > >       if (fd < 0)
> > > > -             die("Can't memfd_create for hugetlbfs map\n");
> > > > +             die("Can't memfd_create for memory map\n");
> > > > +
> > > >       if (ftruncate(fd, size) < 0)
> > > >               die("Can't ftruncate for mem mapping size %lld\n",
> > > >                       (unsigned long long)size);
> > > > -     addr =3D mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
> > > > -     close(fd);
> > > >
> > > > -     return addr;
> > > > +     return fd;
> > > >  }
> > > >
> > > >  /* This function wraps the decision between hugetlbfs map (if requ=
ested) or normal mmap */
> > > >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_p=
ath, u64 size)
> > > >  {
> > > >       u64 blk_size =3D 0;
> > > > +     int fd;
> > > >
> > > >       /*
> > > >        * We don't /need/ to map guest RAM from hugetlbfs, but we do=
 so
> > > > @@ -146,9 +148,14 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, =
const char *htlbfs_path, u64 size)
> > > >               }
> > > >
> > > >               kvm->ram_pagesize =3D blk_size;
> > > > -             return mmap_hugetlbfs(kvm, htlbfs_path, size, blk_siz=
e);
> > > >       } else {
> > > >               kvm->ram_pagesize =3D getpagesize();
> > > > -             return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, =
-1, 0);
> > > >       }
> > > > +
> > > > +     fd =3D memfd_alloc(size, htlbfs_path, blk_size);
> > > > +     if (fd < 0)
> > > > +             return MAP_FAILED;
> > > > +
> > > > +     kvm->ram_fd =3D fd;
> > > > +     return mmap(NULL, size, PROT_RW, MAP_PRIVATE, kvm->ram_fd, 0)=
;
> > > >  }
> > > > --
> > > > 2.38.1.431.g37b22c650d-goog
> > > >
