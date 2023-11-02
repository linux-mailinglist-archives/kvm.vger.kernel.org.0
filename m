Return-Path: <kvm+bounces-387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC7E87DF456
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 14:53:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A6E41C20E81
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 13:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5D8B1DA53;
	Thu,  2 Nov 2023 13:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="puJ1+etw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668CA1DA22
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 13:53:04 +0000 (UTC)
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F15188
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 06:53:01 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-66d0ea3e5b8so5837816d6.0
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 06:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698933181; x=1699537981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8MiH+OD80Lz6N2WkoQWVzzSH5wdFrVwABmyWNvMjndg=;
        b=puJ1+etwmG1T9jWC97a5D1hZmH3E7zo8G+dkgE6ehm7uZxvMFernk9/nmUG201fqhM
         L0dTDeR0LgHpkAOVOYzE2x9qhC8h6zX3vgvuZDlxCx1aj7SzmQl1ub1s01z+0mmQMkAj
         jGhdLpgZpiEkiBjfD0UXKVOP3AKUkZACWhu+XpYTGmKtXUNjom5hzruY8f0Xss7UdqnX
         LHKHO33djXgPrvLgdZ9ZVMibV/bvkTDp0aBvAdpDzYiG1O03h4WoasCfyySf0942UtQv
         NTOIvK3Xrv/eRKBwsuvQoNcXIwNzQ5sL+8fQ5EplF5RrEzG2ENRo9DAUcQKl21B8IaR+
         GcPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698933181; x=1699537981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8MiH+OD80Lz6N2WkoQWVzzSH5wdFrVwABmyWNvMjndg=;
        b=mVLEC7pnBBQKnne3PmxtsQlEhVfPPljXs21DNyIwRAGz48XTz9VAbVVPR53arq9Z5m
         0cvDRgnSJuhjrdunj6dvuN9IvL8/J8syf5goPjsec6kyGr2nsINPYV2+UsjP0YT3Pp5o
         NycVes4d+RusTvdjvip+OJb6m/CTIl6c9lICebcS1ym7tAA/fUtXTu034w5rOyvOIsfU
         Dz1Re2XDVkUjF8GWfFp2/SftIYpeEIPQ8JdlDoK9mJLodRVT6rHwHWBNJDC6+1IMN5zK
         CBPCc0gxDsFINdUIYapdcv2Qfpedc82M12I5UEAtZ1DwNt8oywPdzIW0iB2HMD62X4+V
         H1zg==
X-Gm-Message-State: AOJu0Yyuc8N1qrQjT1Y2dZOXIcY7g+10uzyacN6wZyqLzrJN+uqE7DlT
	NBXGeOYWvVq7v67L1doYtl4n0QhiP/b+B6gDQPKY9Q==
X-Google-Smtp-Source: AGHT+IHABEQi7q2gF4GYbu+6KWyVOhp4LTc7vcuWRR/ds6omy7P2Nr93O+4ItCwG4g8ZUZhgbGUZVOPe8u3aj0mVGQs=
X-Received: by 2002:ad4:5761:0:b0:672:4e8c:9aa5 with SMTP id
 r1-20020ad45761000000b006724e8c9aa5mr14682447qvx.47.1698933180583; Thu, 02
 Nov 2023 06:53:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
 <CA+EHjTzj4drYKONVOLP19DYpJ4O8kSXcFzw2AKier1QdcFKx_Q@mail.gmail.com>
 <ZUF8A5KpwpA6IKUH@google.com> <CA+EHjTwTT9cFzYTtwT43nLJS01Sgt0NqzUgKAnfo2fiV3tEvXg@mail.gmail.com>
 <ZULJYg5cf1UrNq3e@google.com>
In-Reply-To: <ZULJYg5cf1UrNq3e@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 2 Nov 2023 13:52:23 +0000
Message-ID: <CA+EHjTzGzXnfXHh0m5iHt9m3BxerkUS56EVPDA_az6n2FRnk3w@mail.gmail.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 1, 2023 at 9:55=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Nov 01, 2023, Fuad Tabba wrote:
> > > > > @@ -1034,6 +1034,9 @@ static void kvm_destroy_dirty_bitmap(struct=
 kvm_memory_slot *memslot)
> > > > >  /* This does not remove the slot from struct kvm_memslots data s=
tructures */
> > > > >  static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_=
slot *slot)
> > > > >  {
> > > > > +       if (slot->flags & KVM_MEM_PRIVATE)
> > > > > +               kvm_gmem_unbind(slot);
> > > > > +
> > > >
> > > > Should this be called after kvm_arch_free_memslot()? Arch-specific =
ode
> > > > might need some of the data before the unbinding, something I thoug=
ht
> > > > might be necessary at one point for the pKVM port when deleting a
> > > > memslot, but realized later that kvm_invalidate_memslot() ->
> > > > kvm_arch_guest_memory_reclaimed() was the more logical place for it=
.
> > > > Also, since that seems to be the pattern for arch-specific handlers=
 in
> > > > KVM.
> > >
> > > Maybe?  But only if we can about symmetry between the allocation and =
free paths
> > > I really don't think kvm_arch_free_memslot() should be doing anything=
 beyond a
> > > "pure" free.  E.g. kvm_arch_free_memslot() is also called after movin=
g a memslot,
> > > which hopefully we never actually have to allow for guest_memfd, but =
any code in
> > > kvm_arch_free_memslot() would bring about "what if" questions regardi=
ng memslot
> > > movement.  I.e. the API is intended to be a "free arch metadata assoc=
iated with
> > > the memslot".
> > >
> > > Out of curiosity, what does pKVM need to do at kvm_arch_guest_memory_=
reclaimed()?
> >
> > It's about the host reclaiming ownership of guest memory when tearing
> > down a protected guest. In pKVM, we currently teardown the guest and
> > reclaim its memory when kvm_arch_destroy_vm() is called. The problem
> > with guestmem is that kvm_gmem_unbind() could get called before that
> > happens, after which the host might try to access the unbound guest
> > memory. Since the host hasn't reclaimed ownership of the guest memory
> > from hyp, hilarity ensues (it crashes).
> >
> > Initially, I hooked reclaim guest memory to kvm_free_memslot(), but
> > then I needed to move the unbind later in the function. I realized
> > later that kvm_arch_guest_memory_reclaimed() gets called earlier (at
> > the right time), and is more aptly named.
>
> Aha!  I suspected that might be the case.
>
> TDX and SNP also need to solve the same problem of "reclaiming" memory be=
fore it
> can be safely accessed by the host.  The plan is to add an arch hook (or =
two?)
> into guest_memfd that is invoked when memory is freed from guest_memfd.
>
> Hooking kvm_arch_guest_memory_reclaimed() isn't completely correct as del=
eting a
> memslot doesn't *guarantee* that guest memory is actually reclaimed (whic=
h reminds
> me, we need to figure out a better name for that thing before introducing
> kvm_arch_gmem_invalidate()).

I see. I'd assumed that that was what you're using. I agree that it's
not completely correct, so for the moment, I assume that if that
happens we have a misbehaving host, teardown the guest and reclaim its
memory.

> The effective false positives aren't fatal for the current usage because =
the hook
> is used only for x86 SEV guests to flush caches.  An unnecessary flush ca=
n cause
> performance issues, but it doesn't affect correctness. For TDX and SNP, a=
nd IIUC
> pKVM, false positives are fatal because KVM could assign memory back to t=
he host
> that is still owned by guest_memfd.

Yup.

> E.g. a misbehaving userspace could prematurely delete a memslot.  And the=
 more
> fun example is intrahost migration, where the plan is to allow pointing m=
ultiple
> guest_memfd files at a single guest_memfd inode:
> https://lore.kernel.org/all/cover.1691446946.git.ackerleytng@google.com
>
> There was a lot of discussion for this, but it's scattered all over the p=
lace.
> The TL;DR is is that the inode will represent physical memory, and a file=
 will
> represent a given "struct kvm" instance's view of that memory.  And so th=
e memory
> isn't reclaimed until the inode is truncated/punched.
>
> I _think_ this reflects the most recent plan from the guest_memfd side:
> https://lore.kernel.org/all/1233d749211c08d51f9ca5d427938d47f008af1f.1689=
893403.git.isaku.yamahata@intel.com

Thanks for pointing that out. I think this might be the way to go.
I'll have a closer look at this and see how to get it to work with
pKVM.

Cheers,
/fuad

