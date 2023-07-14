Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF48754333
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 21:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbjGNT30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbjGNT3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 15:29:25 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B3D3A86
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 12:29:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56cf9a86277so17839997b3.3
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 12:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689362963; x=1691954963;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=guUJsKKG0pR15PLyRq80U4GvJh8aPVn1TOwclDIJCnc=;
        b=B4nnKf62f5A1gxwkeDk6NawhEqr4UPD5RNO39bV3d5FctdH6BNXs42W8RvOe68xxcT
         /fvobsaASC6SLwOM6KrjGXEWs45ToL6GM3+d1IJu/uk7l0gA4oBBLIRK4kl+MNCOdEqH
         +AaO0GG3fQCiuKtIFosXIaPdzFMzYapu+W7RPcU2mzIDAEYn0Aoc3kQTpNlyGYuxPwRB
         RUZ3RCm6uhOzF/MbHVgoO/EvIcKKJ0k6pbbY+NJjy8LNX++rlGWqJ/3sgkw4GL95VMkm
         z9FtmioAv6tm/CxRT/cTfHS/s9D/bWToHAsMViK3IAKuh34tvUzL5MuK5DnRupUEnMWF
         qbGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689362963; x=1691954963;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=guUJsKKG0pR15PLyRq80U4GvJh8aPVn1TOwclDIJCnc=;
        b=d9NkIaa1saRJVvAvfEa2TVpYwQH7PM5gFSljAKGVw7bTgyNOb0ji1j2ZV/n0Fx+5bi
         kAUGxj3zYB2omKWxf5zDSc15efQzLjmqf/2eISIDT2NY4x314WqfvHp2oLuuwFLMMi7l
         wKXLVXTDsO88w91O9kWTBamON7rUdaFY0sGvj7zteyQOWbHtDAqCMal5Z1GnjgPjz9b1
         Hzfd9N+1r2e0szzcKDSWjaSMobD79/8l6EzS4EaSY+4LPpvbiUYTr7QEbhHPO9fVwTXx
         /CIDXBecUrDcVotLLX6r+SjGauzxYGRyGHKDrLL5opjqJSyIJ6mT9D/e4wbL2GqWB+ad
         qpcw==
X-Gm-Message-State: ABy/qLYHajy/YGy8yUbMAHnLPxkMtg5+S5QoMJe6GM2UL7u1WT5rPyN7
        xUta2tZRYUyxISkImIOuA5tCWOAU1ms=
X-Google-Smtp-Source: APBJJlGIfOnGxINRpx8gEgbLt2kawyE/obqLqEcBB1sStx/AHZiDp0ohyz7Pg6M9uj2FqDCconMIy49acp4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d40c:0:b0:570:200:18e1 with SMTP id
 z12-20020a81d40c000000b00570020018e1mr48564ywi.3.1689362963489; Fri, 14 Jul
 2023 12:29:23 -0700 (PDT)
Date:   Fri, 14 Jul 2023 19:29:21 +0000
In-Reply-To: <diqzr0pb2zws.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <ZFWli2/H5M8MZRiY@google.com> <diqzr0pb2zws.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <ZLGiEfJZTyl7M8mS@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     Ackerley Tng <ackerleytng@google.com>
Cc:     david@redhat.com, chao.p.peng@linux.intel.com, pbonzini@redhat.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        mail@maciej.szmigiero.name, vbabka@suse.cz, vannapurve@google.com,
        yu.c.zhang@linux.intel.com, kirill.shutemov@linux.intel.com,
        dhildenb@redhat.com, qperret@google.com, tabba@google.com,
        michael.roth@amd.com, wei.w.wang@intel.com, rppt@kernel.org,
        liam.merwick@oracle.com, isaku.yamahata@gmail.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com, brauner@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > On Fri, May 05, 2023, Ackerley Tng wrote:
> >>
> >> Hi Sean,
> >>
> >> Thanks for implementing this POC!
> >>
> >> ... snip ...
> >>
> >
> > I don't love either approach idea because it means a file created in th=
e context
> > of a VM can outlive the VM itself, and then userspace ends up with a fi=
le descriptor
> > that it can't do anything with except close().  I doubt that matters in=
 practice
> > though, e.g. when the VM dies, all memory can be freed so that the file=
 ends up
> > being little more than a shell.  And if we go that route, there's no ne=
ed to grab
> > a reference to the file during bind, KVM can just grab a longterm refer=
ence when
> > the file is initially created and then drop it when KVM dies (and nulli=
fies gmem->kvm).
> >
> > ... snip ...
> >
> > My preference is to make it a VM-scoped ioctl(), if it ends up being a =
KVM ioctl()
> > and not a common syscall.  If the file isn't tightly coupled to a singl=
e VM, then
> > punching a hole is further complicated by needing to deal with invalida=
ting multiple
> > regions that are bound to different @kvm instances.  It's not super com=
plex, but
> > AFAICT having the ioctl() be system-scoped doesn't add value, e.g. I do=
n't think
> > having one VM own the memory will complicate even if/when we get to the=
 point where
> > VMs can share "private" memory, and the gmem code would still need to d=
eal with
> > grabbing a module reference.
>=20
> I=E2=80=99d like to follow up on this discussion about a guest_mem file
> outliving the VM and whether to have a VM-scoped ioctl or a KVM ioctl.
>=20
> Here's a POC of delayed binding of a guest_mem file to a memslot, where
> the guest_mem file outlives the VM [1].
>=20
> I also hope to raise some points before we do the first integration of
> guest_mem patches!
>=20
> A use case for guest_mem inodes outliving the VM is when the host VMM
> needs to be upgraded.

Translation: to support intra-host migration, a.k.a. KVM_CAP_VM_MOVE_ENC_CO=
NTEXT_FROM

> The guest_mem inode is passed between two VMs on the same host machine an=
d
> all memory associated with the inode needs to be retained.
>=20
> To support the above use case, binding of memslots is delayed until
> first use, so that the following inode passing flow can be used:
>=20
> 1. Source (old version of host VMM) process passes guest_mem inodes to
>    destination (new version of host VMM) process via unix sockets.
> 2. Destination process initializes memslots identical to source process.
> 3. Destination process invokes ioctl to migrate guest_mem inode over to
>    destination process by unbinding all memslots from the source VM and
>    binding them to the destination VM. (The kvm pointer is updated in
>    this process)
>=20
> Without delayed binding, step 2 will fail since initialization of
> memslots would check and find that the kvm pointer in the guest_mem
> inode points to the kvm in the source process.
>=20
>=20
> These two patches contain the meat of the changes required to support
> delayed binding:
>=20
> https://github.com/googleprodkernel/linux-cc/commit/93b31a006ef2e4dbe1ef0=
ec5d2534ca30f3bf60c
> https://github.com/googleprodkernel/linux-cc/commit/dd5ac5e53f14a1ef9915c=
9c1e4cc1006a40b49df
>=20
> Some things to highlight for the approach set out in these two patches:
>=20
> 1. Previously, closing the guest_mem file in userspace=C2=A0is taken to m=
ean
>    that all associated memory is to be removed and cleared. With these
>    two patches, each memslot also holds a reference to the file (and
>    therefore inode) and so even if the host VMM closes the fd, the VM
>    will be able to continue to function.
>=20
>    This is desirable to userspace since closing the file should not be
>    interpreted as a command to clear memory.

100% agreed.  However, after more thought since we first discussed this, I =
think
that a deferred binding is the wrong way to solve this particular problem. =
 More
below.

>    This is aligned with the
>    way tmpfs=C2=A0files are used with KVM before guest_mem: when the file=
 is
>    closed in userspace, the memory contents are still mapped and can
>    still be used by the VM. fallocate(PUNCH_HOLE) is how userspace
>    should command memory to be removed, just like munmap() would be used
>    to remove memory from use by KVM.
>
> 2. Creating a guest mem file no longer depends on a specific VM and
>    hence the guest_mem creation ioctl can be a system ioctl instead of a
>    VM specific ioctl. This will also address Chao's concern at [3].

That concern is a non-issue for QEMU as memory backends are created after
accelerators are initialized, and AFAICT Google's VMM behaves similarly.

And _if_ there is a VMM that instantiates memory before KVM_CREATE_VM, IMO =
making
the ioctl() /dev/kvm scoped would have no meaningful impact on adapting use=
rspace
to play nice with the required ordering.  If userspace can get at /dev/kvm,=
 then
it can do KVM_CREATE_VM, because the only input to KVM_CREATE_VM is the typ=
e, i.e.
the only dependencies for KVM_CREATE_VM should be known/resolved long befor=
e the
VMM knows it wants to use gmem.

Using a non-KVM syscall would eliminate any such dependencies, but in my ve=
ry
strong opinion, that is not a good reason to go with a syscall.

> I also separated cleaning up files vs inodes in
> https://github.com/googleprodkernel/linux-cc/commit/0f5aa18910c515141e57e=
05c4cc791022047a242,
> which I believe is more aligned with how files and inodes are cleaned up
> in FSes.

I didn't take these, though I am in the process of incorporating parts of t=
he
underlying feedback (see below).

> This alignment makes it easier to extend gmem=C2=A0to hugetlb, for one.

I am not convinced that utilizing hugetlb is the best way to provide 1GiB s=
upport
in gmem.  I'm not necessarily against it, but there's a fair bit of uncerta=
inty
around the future of hugetlb, and there are fundamental aspects of hugetlb =
that
may be non-goals for the gmem use case, e.g. mapping the memory with 1GiB p=
ages
in the userspace page tables likely isn't necessariy, and might even be
undesirable.

And practically speaking, the changes aren't _that_ invasive, i.e. punting =
any=20
necessary refactoring should not substantially increase the size/complexity=
 of
hugetlb support (*if* we end up adding it).

That said, I do think we'll implement .evict_inode() very early on in order=
 to
support SNP and TDX, because (in addition to PUNCH_HOLE) that's when the ba=
cking
memory will be freed and thus reclaimed, i.e. unassigned in the RMP (SNP) /=
 zeroed
with the shared key ID (TDX).

> While working on this, I was also wondering if we should perhaps be
> storing the inode pointer in slot->gmem instead of the file pointer? The
> memory is associated with an inode->mapping rather than the file. Are we
> binding to a userspace handle on the inode (store file pointer), or are
> we really referencing the inode (store inode pointer)?

Conceptually, I think KVM should to bind to the file.  The inode is effecti=
vely
the raw underlying physical storage, while the file is the VM's view of tha=
t
storage.=20

Practically, I think that gives us a clean, intuitive way to handle intra-h=
ost
migration.  Rather than transfer ownership of the file, instantiate a new f=
ile
for the target VM, using the gmem inode from the source VM, i.e. create a h=
ard
link.  That'd probably require new uAPI, but I don't think that will be hug=
ely
problematic.  KVM would need to ensure the new VM's guest_memfd can't be ma=
pped
until KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM (which would also need to verify the
memslots/bindings are identical), but that should be easy enough to enforce=
.

That way, a VM, its memslots, and its SPTEs are tied to the file, while all=
owing
the memory and the *contents* of memory to outlive the VM, i.e. be effectiv=
ely
transfered to the new target VM.  And we'll maintain the invariant that eac=
h
guest_memfd is bound 1:1 with a single VM.

As above, that should also help us draw the line between mapping memory int=
o a
VM (file), and freeing/reclaiming the memory (inode).

There will be extra complexity/overhead as we'll have to play nice with the
possibility of multiple files per inode, e.g. to zap mappings across all fi=
les
when punching a hole, but the extra complexity is quite small, e.g. we can =
use
address_space.private_list to keep track of the guest_memfd instances assoc=
iated
with the inode.

Setting aside TDX and SNP for the moment, as it's not clear how they'll sup=
port
memory that is "private" but shared between multiple VMs, I think per-VM fi=
les
would work well for sharing gmem between two VMs.  E.g. would allow a give =
page
to be bound to a different gfn for each VM, would allow having different pe=
rmissions
for each file (e.g. to allow fallocate() only from the original owner).
