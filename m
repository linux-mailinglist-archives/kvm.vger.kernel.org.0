Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28857697F7
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 15:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjGaNrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 09:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjGaNra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 09:47:30 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C442F1722
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 06:47:27 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-63d058b9cafso30656796d6.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 06:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690811247; x=1691416047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysw1GJ5iZ7+m9LB1vMcTeerNVDEGAKXkHz9rft3ciOM=;
        b=u9OhuV2WeoVUb538U+P/2QFmsHVbKcdA/KLYVytDxihcyMcOvBA0XVLiSr5cHMTN7D
         ikj7mVuN1iyhE73lkkm8FfLEjE5ponkqPZ1y3+LCm2IQAtu7oocrn6C54yzZ80W11Wvd
         rTxv00vYMpAR9z70F7m74ztY1F98dotGILfOawWW2zQkC0L0yO2AbJIKpEccIjfjgMtN
         rNOX3yDynA64SAgdgBRMMmYQcMR8X+2qNSp+2Yj5dtqRRJG2EoqS4Y/SRDVJ6nLIVtfR
         4bdQAAHnMSoPJgm+FGVRTm8lI3EITt2Y96aOx0NZdkMIARTZMJb3A2kQXkT2avpiLvYZ
         6BKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690811247; x=1691416047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ysw1GJ5iZ7+m9LB1vMcTeerNVDEGAKXkHz9rft3ciOM=;
        b=aKfiz7/axjcbtmj+bBkmy5K/4TB+fCnxN29cjJWwQXXzmKf5mt0l5RKwAi8coQxywJ
         oVLPRABEblULWkxhF3Gsbzfiq5vLyvHqO4+4JX0yPzkQwPLQPMyRgPFezZ5mZGOxdlng
         J1xKS4WE35sDJZjP26pNfAHmahr4H4RoBlAkAdmUqWcccPf3X/pmi2NfsYDybpiR8Jms
         wSkE89+pziKcyVtlmmRHUCSpczQbNqNYdQ8ZTtiexAAWKnomWbzixOPUU5BXa6zWy2AX
         WoPxHVRFBU13nssF2lSa0p/j+K2FuSZpmpAUh267Mojh9kGkVZAAtb27zJh7CiZNOZu3
         aHxg==
X-Gm-Message-State: ABy/qLYZ9ykDX4H5QqpAFvErgBOWToL6WSjltEcQS31Ke+o6WfwLwGfo
        qULwxl6kwE/9MUZJNIk8TxZxmDNLM9LjKHNgGu8DHA==
X-Google-Smtp-Source: APBJJlF7tr3MB9wkYayUG07mtX0571x6EwPIiCT72OesCKkjWW/DHZdN3DzN9958IW7gK2WOAN/2LmnIZ4GFimGLnSQ=
X-Received: by 2002:ad4:5884:0:b0:632:2e63:d34b with SMTP id
 dz4-20020ad45884000000b006322e63d34bmr9450921qvb.14.1690811246768; Mon, 31
 Jul 2023 06:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-13-seanjc@google.com>
 <CA+EHjTzP2fypgkJbRpSPrKaWytW7v8ANEifofMnQCkdvYaX6Eg@mail.gmail.com> <ZMKlo+Fe8n/eLQ82@google.com>
In-Reply-To: <ZMKlo+Fe8n/eLQ82@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 31 Jul 2023 14:46:50 +0100
Message-ID: <CA+EHjTzySXapdQbv8ocueboBR4LnM9WGV4bLOAfipB1saQ6OjQ@mail.gmail.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Thu, Jul 27, 2023 at 6:13=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jul 27, 2023, Fuad Tabba wrote:
> > Hi Sean,
> >
> > <snip>
> > ...
> >
> > > @@ -5134,6 +5167,16 @@ static long kvm_vm_ioctl(struct file *filp,
> > >         case KVM_GET_STATS_FD:
> > >                 r =3D kvm_vm_ioctl_get_stats_fd(kvm);
> > >                 break;
> > > +       case KVM_CREATE_GUEST_MEMFD: {
> > > +               struct kvm_create_guest_memfd guest_memfd;
> > > +
> > > +               r =3D -EFAULT;
> > > +               if (copy_from_user(&guest_memfd, argp, sizeof(guest_m=
emfd)))
> > > +                       goto out;
> > > +
> > > +               r =3D kvm_gmem_create(kvm, &guest_memfd);
> > > +               break;
> > > +       }
> >
> > I'm thinking line of sight here, by having this as a vm ioctl (rather
> > than a system iocl), would it complicate making it possible in the
> > future to share/donate memory between VMs?
>
> Maybe, but I hope not?
>
> There would still be a primary owner of the memory, i.e. the memory would=
 still
> need to be allocated in the context of a specific VM.  And the primary ow=
ner should
> be able to restrict privileges, e.g. allow a different VM to read but not=
 write
> memory.
>
> My current thinking is to (a) tie the lifetime of the backing pages to th=
e inode,
> i.e. allow allocations to outlive the original VM, and (b) create a new f=
ile each
> time memory is shared/donated with a different VM (or other entity in the=
 kernel).
>
> That should make it fairly straightforward to provide different permissio=
ns, e.g.
> track them per-file, and I think should also avoid the need to change the=
 memslot
> binding logic since each VM would have it's own view/bindings.
>
> Copy+pasting a relevant snippet from a lengthier response in a different =
thread[*]:
>
>   Conceptually, I think KVM should to bind to the file.  The inode is eff=
ectively
>   the raw underlying physical storage, while the file is the VM's view of=
 that
>   storage.

I'm not aware of any implementation of sharing memory between VMs in
KVM before (afaik, since there was no need for one). The following is
me thinking out loud, rather than any strong opinions on my part.

If an allocation can outlive the original VM, then why associate it
with that (or a) VM to begin with? Wouldn't it be more flexible if it
were a system-level construct, which is effectively what it was in
previous iterations of this? This doesn't rule out binding to the
file, and keeping the inode as the underlying physical storage.

The binding of a VM to a guestmem object could happen implicitly with
KVM_SET_USER_MEMORY_REGION2, or we could have a new ioctl specifically
for handling binding.

Cheers,
/fuad


>   Practically, I think that gives us a clean, intuitive way to handle int=
ra-host
>   migration.  Rather than transfer ownership of the file, instantiate a n=
ew file
>   for the target VM, using the gmem inode from the source VM, i.e. create=
 a hard
>   link.  That'd probably require new uAPI, but I don't think that will be=
 hugely
>   problematic.  KVM would need to ensure the new VM's guest_memfd can't b=
e mapped
>   until KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM (which would also need to verify=
 the
>   memslots/bindings are identical), but that should be easy enough to enf=
orce.
>
>   That way, a VM, its memslots, and its SPTEs are tied to the file, while=
 allowing
>   the memory and the *contents* of memory to outlive the VM, i.e. be effe=
ctively
>   transfered to the new target VM.  And we'll maintain the invariant that=
 each
>   guest_memfd is bound 1:1 with a single VM.
>
>   As above, that should also help us draw the line between mapping memory=
 into a
>   VM (file), and freeing/reclaiming the memory (inode).
>
>   There will be extra complexity/overhead as we'll have to play nice with=
 the
>   possibility of multiple files per inode, e.g. to zap mappings across al=
l files
>   when punching a hole, but the extra complexity is quite small, e.g. we =
can use
>   address_space.private_list to keep track of the guest_memfd instances a=
ssociated
>   with the inode.
>
>   Setting aside TDX and SNP for the moment, as it's not clear how they'll=
 support
>   memory that is "private" but shared between multiple VMs, I think per-V=
M files
>   would work well for sharing gmem between two VMs.  E.g. would allow a g=
ive page
>   to be bound to a different gfn for each VM, would allow having differen=
t permissions
>   for each file (e.g. to allow fallocate() only from the original owner).
>
> [*] https://lore.kernel.org/all/ZLGiEfJZTyl7M8mS@google.com
>
