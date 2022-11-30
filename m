Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D0663DC7D
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 18:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiK3Rzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 12:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiK3Rzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 12:55:48 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EAB4A076
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 09:55:46 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id a19so6019870ljk.0
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 09:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrjLymDPbqj8c6B8djKqePJ5ePQrTTHiop97PzH3pJ8=;
        b=BjFwMdZxH4tLxGOiVgx5Gkpz9FySYzy6yTkJ/12R5uiggjmHCkflg8tXZXzairWdJv
         6637l8gHptJedMw3WX/IfMM9cDUZCV9URMT2fmiixcG2pDbtmH+17ZYbPxdqrsailWXc
         /uxhlcCjedziA/eOInMr3Y13xDU7lMP/5e3wXuuEtqHoJenbHto+9imwZaH+Zh5MCZ9I
         g22XQjFaR/HeWvuUPhvATLRjJFGBy1xxJ7xC8vSDIPCwgT/gIN3V6kYMw/qy6FtyZSjO
         mAYnJ1ONTxyqf9H3mT8xKDDtUTJgmdfG65i/tSkZpOk21xK6mJqej1ehfU8feowklhEk
         is8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OrjLymDPbqj8c6B8djKqePJ5ePQrTTHiop97PzH3pJ8=;
        b=0eb848oc7nU0gQ83TPmwdKk6FJqqUQdVZOSe0dzeeLE/k4DONkUIp+XrcLgr2ywHmu
         ppdgQgGlRkxAUmbwvQ/kl2/5sPiNP4UGNcBXMERVgdG2/wcLanZoLLOGqaOD22J6Arft
         fTKdASFt8s/TNx7z0KTsw1Jvp3OgU+7eQ9VvXNr+tjPIfQcu+QkSv0vbka9Tjal+19du
         +MwMoQKSa+FuWK+otdcqcQLqDOV9U6z3/Kqyrs/LMMufZDAv80SS2TA3TGKYPdoe18nw
         ArgV62cJ+mEKWyh0oXdMIvrC5Q8Ny3Sb12ksVkSj/jfOevz0JLFre9AqOOEqBHRQqg68
         zjKg==
X-Gm-Message-State: ANoB5pn60cv+WkmDTm/mcRWbVoM5kz81faZTctWVwqjvMP3d9OJVjyfd
        t/x1kR/6HQF6Q/BeuDEidvd1SFU1jpcpaofYvHgGUg==
X-Google-Smtp-Source: AA0mqf6rc19RMQWJvnpafzAVKxxzNkdUtPwlB61Nu/wIAsOhjPz+ik7m/Z/RxbjMB5XeD/CYy0uq1PlK8r4O41KtJy4=
X-Received: by 2002:a05:651c:c99:b0:277:2b10:bf60 with SMTP id
 bz25-20020a05651c0c9900b002772b10bf60mr21458780ljb.159.1669830944774; Wed, 30
 Nov 2022 09:55:44 -0800 (PST)
MIME-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com> <20221115111549.2784927-9-tabba@google.com>
 <Y39PCG0ZRHf/2d5E@monolith.localdoman> <CA+EHjTx6JRODjncxMz6pBO43S2gAFZt4vDibG=Zwbr7TkbiFeQ@mail.gmail.com>
 <Y3+meXHu5MRYuHou@monolith.localdoman> <CA+EHjTwgg+Cu=A3msmWLNEHmkJhOn-8+MeJULOHzF6V99iHk1A@mail.gmail.com>
 <Y4CnPcHyt5IPAoF/@monolith.localdoman> <CA+EHjTzf5-Rsi9-hzfMiYPUB8_C9UmkJuJiZpD8VSe9CNt2_aw@mail.gmail.com>
 <Y4ZK9sNbWDIOYe++@monolith.localdoman>
In-Reply-To: <Y4ZK9sNbWDIOYe++@monolith.localdoman>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 30 Nov 2022 17:54:00 +0000
Message-ID: <CA+EHjTxb2mOOTE-CTFmfQFqkA0JrKuA9byaTxGgUiG0c7j7u=A@mail.gmail.com>
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

On Tue, Nov 29, 2022 at 6:10 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Mon, Nov 28, 2022 at 08:49:29AM +0000, Fuad Tabba wrote:
> > Hi,
> >
> > First I want to mention that I really appreciate your feedback, which
> > has already been quite helpful. I would like you to please consider
> > this to be an RFC, and let's use these patches as a basis for
> > discussion and how they can be improved when I respin them, even if
> > that means waiting until the kvm fd-based proposal is finalized.
>
> For that it's probably best if you add RFC to the subject prefix. That's
> very helpful to let the reviewers know what to focus on, more on the
> approach than on the finer details.

I will respin this as an RFC, and I will include the patches that I
have that support the restricted memory proposal [*] for pKVM as it
stands now. I hope that would help see where I was thinking this would
be heading.

[*] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.peng@linux.=
intel.com/

<snip>

> > > > With simpler I didn't mean fewer lines of code, rather that it's
> > > > easier to reason about, more shared code. With this series, hugetlb
> > >
> > > How is all of the code that has been added easier to reason about tha=
n one
> > > single mmap call?
>
> Would be nice if this would be answered.

As I said in a reply to a different comment, for me personally, as a first =
time
kvmtool contributor, it was easier for me to reason about the memory
when the canonical reference to the memory is a file descriptor that
would not change, rather than a userspace memory address which could
change as it is aligned and trimmed.

I use the word simpler subjectively, that is, in my opinion.

<snip>

> >
> > Because we are sure that it will be fd-based, and because I thought
> > that getting a head start to set the scene would be helpful. The part
> > that is uncertain is the kvm capabilities, flags, and names of the new
> > memory region extensions, none of which I address in these patches.
>
> I see, that makes sense. My feedback so far is that you haven't provided =
a
> good reason why this change to anonymous memory makes sense right now.

I appreciate your feedback, and I hope we can continue this discussion
when I respin this as an RFC.



Cheers,
/fuad

> Thanks,
> Alex
>
> >
> > Cheers,
> > /fuad
> >
> > > Thanks,
> > > Alex
> > >
> > > >
> > > > Cheers,
> > > > /fuad
> > > >
> > > >
> > > >
> > > > > Thanks,
> > > > > Alex
> > > > >
> > > > > > could have a look on how I would go ahead building on these pat=
ches
> > > > > > for full support of private memory backed by an fd.
> > > > > >
> > > > > > > Regarding IPC memory sharing, is mmap'ing an memfd file enoug=
h to enable
> > > > > > > that? If more work is needed for it, then wouldn't it make mo=
re sense to do
> > > > > > > all the changes at once? This change might look sensible righ=
t now, but it
> > > > > > > might turn out that it was the wrong way to go about it when =
someone
> > > > > > > actually starts implementing memory sharing.
> > > > > >
> > > > > > I don=E2=80=99t plan on supporting IPC memory sharing. I just m=
entioned that
> > > > > > as yet another use case that would benefit from guest memory be=
ing
> > > > > > fd-based, should kvmtool decide to support it in the future.
> > > > > >
> > > > > > Cheers,
> > > > > > /fuad
> > > > > >
> > > > > > [1] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p=
.peng@linux.intel.com/
> > > > > > [2] https://github.com/qemu/qemu
> > > > > > [3] https://chromium.googlesource.com/chromiumos/platform/crosv=
m/
> > > > > > [4] https://github.com/chao-p/qemu/tree/privmem-v9
> > > > > > [5] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/t=
abba/fdmem-v9-core
> > > > > >
> > > > > >
> > > > > >
> > > > > > >
> > > > > > > Regarding IPC memory sharing, is mmap'ing an memfd file enoug=
h to enable
> > > > > > > that? If more work is needed for it, then wouldn't it make mo=
re sense to do
> > > > > > > all the changes at once? This change might look sensible righ=
t now, but it
> > > > > > > might turn out that it was the wrong way to go about it when =
someone
> > > > > > > actually starts implementing memory sharing.
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Alex
> > > > > > >
> > > > > > > >
> > > > > > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > > > > >
> > > > > > > > [*] https://lore.kernel.org/all/20221025151344.3784230-1-ch=
ao.p.peng@linux.intel.com/
> > > > > > > > ---
> > > > > > > >  include/kvm/kvm.h  |  1 +
> > > > > > > >  include/kvm/util.h |  3 +++
> > > > > > > >  kvm.c              |  4 ++++
> > > > > > > >  util/util.c        | 33 ++++++++++++++++++++-------------
> > > > > > > >  4 files changed, 28 insertions(+), 13 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> > > > > > > > index 3872dc6..d0d519b 100644
> > > > > > > > --- a/include/kvm/kvm.h
> > > > > > > > +++ b/include/kvm/kvm.h
> > > > > > > > @@ -87,6 +87,7 @@ struct kvm {
> > > > > > > >       struct kvm_config       cfg;
> > > > > > > >       int                     sys_fd;         /* For system=
 ioctls(), i.e. /dev/kvm */
> > > > > > > >       int                     vm_fd;          /* For VM ioc=
tls() */
> > > > > > > > +     int                     ram_fd;         /* For guest =
memory. */
> > > > > > > >       timer_t                 timerid;        /* Posix time=
r for interrupts */
> > > > > > > >
> > > > > > > >       int                     nrcpus;         /* Number of =
cpus to run */
> > > > > > > > diff --git a/include/kvm/util.h b/include/kvm/util.h
> > > > > > > > index 61a205b..369603b 100644
> > > > > > > > --- a/include/kvm/util.h
> > > > > > > > +++ b/include/kvm/util.h
> > > > > > > > @@ -140,6 +140,9 @@ static inline int pow2_size(unsigned lo=
ng x)
> > > > > > > >  }
> > > > > > > >
> > > > > > > >  struct kvm;
> > > > > > > > +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
> > > > > > > > +void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const =
char *htlbfs_path,
> > > > > > > > +                                u64 size, u64 align);
> > > > > > > >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *=
htlbfs_path, u64 size);
> > > > > > > >
> > > > > > > >  #endif /* KVM__UTIL_H */
> > > > > > > > diff --git a/kvm.c b/kvm.c
> > > > > > > > index 78bc0d8..ed29d68 100644
> > > > > > > > --- a/kvm.c
> > > > > > > > +++ b/kvm.c
> > > > > > > > @@ -160,6 +160,7 @@ struct kvm *kvm__new(void)
> > > > > > > >       mutex_init(&kvm->mem_banks_lock);
> > > > > > > >       kvm->sys_fd =3D -1;
> > > > > > > >       kvm->vm_fd =3D -1;
> > > > > > > > +     kvm->ram_fd =3D -1;
> > > > > > > >
> > > > > > > >  #ifdef KVM_BRLOCK_DEBUG
> > > > > > > >       kvm->brlock_sem =3D (pthread_rwlock_t) PTHREAD_RWLOCK=
_INITIALIZER;
> > > > > > > > @@ -174,6 +175,9 @@ int kvm__exit(struct kvm *kvm)
> > > > > > > >
> > > > > > > >       kvm__arch_delete_ram(kvm);
> > > > > > > >
> > > > > > > > +     if (kvm->ram_fd >=3D 0)
> > > > > > > > +             close(kvm->ram_fd);
> > > > > > > > +
> > > > > > > >       list_for_each_entry_safe(bank, tmp, &kvm->mem_banks, =
list) {
> > > > > > > >               list_del(&bank->list);
> > > > > > > >               free(bank);
> > > > > > > > diff --git a/util/util.c b/util/util.c
> > > > > > > > index d3483d8..278bcc2 100644
> > > > > > > > --- a/util/util.c
> > > > > > > > +++ b/util/util.c
> > > > > > > > @@ -102,36 +102,38 @@ static u64 get_hugepage_blk_size(cons=
t char *htlbfs_path)
> > > > > > > >       return sfs.f_bsize;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > -static void *mmap_hugetlbfs(struct kvm *kvm, const char *h=
tlbfs_path, u64 size, u64 blk_size)
> > > > > > > > +int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
> > > > > > > >  {
> > > > > > > >       const char *name =3D "kvmtool";
> > > > > > > >       unsigned int flags =3D 0;
> > > > > > > >       int fd;
> > > > > > > > -     void *addr;
> > > > > > > > -     int htsize =3D __builtin_ctzl(blk_size);
> > > > > > > >
> > > > > > > > -     if ((1ULL << htsize) !=3D blk_size)
> > > > > > > > -             die("Hugepage size must be a power of 2.\n");
> > > > > > > > +     if (hugetlb) {
> > > > > > > > +             int htsize =3D __builtin_ctzl(blk_size);
> > > > > > > >
> > > > > > > > -     flags |=3D MFD_HUGETLB;
> > > > > > > > -     flags |=3D htsize << MFD_HUGE_SHIFT;
> > > > > > > > +             if ((1ULL << htsize) !=3D blk_size)
> > > > > > > > +                     die("Hugepage size must be a power of=
 2.\n");
> > > > > > > > +
> > > > > > > > +             flags |=3D MFD_HUGETLB;
> > > > > > > > +             flags |=3D htsize << MFD_HUGE_SHIFT;
> > > > > > > > +     }
> > > > > > > >
> > > > > > > >       fd =3D memfd_create(name, flags);
> > > > > > > >       if (fd < 0)
> > > > > > > > -             die("Can't memfd_create for hugetlbfs map\n")=
;
> > > > > > > > +             die("Can't memfd_create for memory map\n");
> > > > > > > > +
> > > > > > > >       if (ftruncate(fd, size) < 0)
> > > > > > > >               die("Can't ftruncate for mem mapping size %ll=
d\n",
> > > > > > > >                       (unsigned long long)size);
> > > > > > > > -     addr =3D mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0=
);
> > > > > > > > -     close(fd);
> > > > > > > >
> > > > > > > > -     return addr;
> > > > > > > > +     return fd;
> > > > > > > >  }
> > > > > > > >
> > > > > > > >  /* This function wraps the decision between hugetlbfs map =
(if requested) or normal mmap */
> > > > > > > >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *=
htlbfs_path, u64 size)
> > > > > > > >  {
> > > > > > > >       u64 blk_size =3D 0;
> > > > > > > > +     int fd;
> > > > > > > >
> > > > > > > >       /*
> > > > > > > >        * We don't /need/ to map guest RAM from hugetlbfs, b=
ut we do so
> > > > > > > > @@ -146,9 +148,14 @@ void *mmap_anon_or_hugetlbfs(struct kv=
m *kvm, const char *htlbfs_path, u64 size)
> > > > > > > >               }
> > > > > > > >
> > > > > > > >               kvm->ram_pagesize =3D blk_size;
> > > > > > > > -             return mmap_hugetlbfs(kvm, htlbfs_path, size,=
 blk_size);
> > > > > > > >       } else {
> > > > > > > >               kvm->ram_pagesize =3D getpagesize();
> > > > > > > > -             return mmap(NULL, size, PROT_RW, MAP_ANON_NOR=
ESERVE, -1, 0);
> > > > > > > >       }
> > > > > > > > +
> > > > > > > > +     fd =3D memfd_alloc(size, htlbfs_path, blk_size);
> > > > > > > > +     if (fd < 0)
> > > > > > > > +             return MAP_FAILED;
> > > > > > > > +
> > > > > > > > +     kvm->ram_fd =3D fd;
> > > > > > > > +     return mmap(NULL, size, PROT_RW, MAP_PRIVATE, kvm->ra=
m_fd, 0);
> > > > > > > >  }
> > > > > > > > --
> > > > > > > > 2.38.1.431.g37b22c650d-goog
> > > > > > > >
