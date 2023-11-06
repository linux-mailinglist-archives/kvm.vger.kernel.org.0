Return-Path: <kvm+bounces-782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 034357E292D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32B231C20C22
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3ED28E34;
	Mon,  6 Nov 2023 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jfgAGp2H"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A8918644
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 15:56:08 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AACC13E
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 07:56:06 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d99ec34829aso5356461276.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 07:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699286165; x=1699890965; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2j2Mtk4lW9HEtWavGEnwteIJF5J/7dhiq9rSq3IBx+E=;
        b=jfgAGp2HE5/xK9g4UWhCfe0wF8pepGfMwluQ7Me8zjfyk6kURtfjawQkzEKUL79x23
         GA7yRpH7oYJ7PauF34lFwNQOzPOo074h3+rK5Nbw9zxFiNBJVL7dPbJmt303qnicGXhF
         nEfy/sj/763fXTU7n9f9aw4t+i+ogT4UuEHWx8nRxxHclr16shV25An5cvb61i6Now6A
         HZvr0t1B/eWzYe7LBjBhD2PvN13RVPGJ0vCSFvcA0giqJQMP2Ia9JWL28QQRK4AcKjCE
         yKF3NGLMBB0N+rtxWhEtTE6umISScKcM05FoJLvnyi5f4Ogi9MTGBHt+4K6q2C36ozTG
         krEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699286165; x=1699890965;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2j2Mtk4lW9HEtWavGEnwteIJF5J/7dhiq9rSq3IBx+E=;
        b=UhcySQpTfx8qaGoMKwOSMMTBSfSM3pa217RqfRhp8NKVVRQ/a4xbRTPyspmJRTQ5Oz
         qTkX63JiWWKafZMTzUMfdZvxzMf3rU+pq4+nTw+qwP01uWGxBxxTKVpivoCMApK9rPPB
         f2CZNvFGNKS3LnLbNzE7WtxhGRxJX/cNbB/oYYkN+NgH83mUs+TRSSndpE6MrX32iWq4
         27YFnXU/nQRo696y3X6lhHv7SanR2Pqevmgb/+vb0Gf/4ayheTA1ccuTKSocP4an8V+u
         VJuGimUAu9vWFqZOGJqQ8Tg1NgtdPCeCn8D0ceorvcpL9Uu7xdZrK7pLwC81+GUCB+1N
         e4Iw==
X-Gm-Message-State: AOJu0Yy+WbDeMG6EF3kdnXJm1Oi5NGNdL5D9BMpKpkqJ9FuOy2GjBAOh
	/MQvpWDKXFjEKfJo1WPVvULxGhZjj/0=
X-Google-Smtp-Source: AGHT+IERk2b/M7d3G4J3vDGzrJ+T8jAsirv4bBIzvQT8OzuTMUe5AwPvC/SZu8YyGY6aMLoBT08jDOLmS/Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:d9a:c3b8:4274 with SMTP id
 v3-20020a056902108300b00d9ac3b84274mr683795ybu.7.1699286165114; Mon, 06 Nov
 2023 07:56:05 -0800 (PST)
Date: Mon, 6 Nov 2023 07:56:03 -0800
In-Reply-To: <ZUjqJjz0Epf7ii8F@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-21-seanjc@google.com>
 <ZUeSaAKRemlSRQpO@yilunxu-OptiPlex-7050> <CABgObfb1Wf2ptitGhJPM6VcmkCG9haMoQj2BsttjeoV=9F0O9Q@mail.gmail.com>
 <ZUjqJjz0Epf7ii8F@yilunxu-OptiPlex-7050>
Message-ID: <ZUkMk6b6vZe2ANkK@google.com>
Subject: Re: [PATCH v13 20/35] KVM: x86/mmu: Handle page fault for private memory
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
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
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 06, 2023, Xu Yilun wrote:
> On Sun, Nov 05, 2023 at 05:19:36PM +0100, Paolo Bonzini wrote:
> > On Sun, Nov 5, 2023 at 2:04=E2=80=AFPM Xu Yilun <yilun.xu@linux.intel.c=
om> wrote:
> > >
> > > > +static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcp=
u,
> > > > +                                           struct kvm_page_fault *=
fault)
> > > > +{
> > > > +     kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> > > > +                                   PAGE_SIZE, fault->write, fault-=
>exec,
> > > > +                                   fault->is_private);
> > > > +}
> > > > +
> > > > +static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> > > > +                                struct kvm_page_fault *fault)
> > > > +{
> > > > +     int max_order, r;
> > > > +
> > > > +     if (!kvm_slot_can_be_private(fault->slot)) {
> > > > +             kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > > > +             return -EFAULT;
> > > > +     }
> > > > +
> > > > +     r =3D kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &f=
ault->pfn,
> > > > +                          &max_order);
> > > > +     if (r) {
> > > > +             kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > > > +             return r;
> > >
> > > Why report KVM_EXIT_MEMORY_FAULT here? even with a ret !=3D -EFAULT?
> >=20
> > The cases are EFAULT, EHWPOISON (which can report
> > KVM_EXIT_MEMORY_FAULT) and ENOMEM. I think it's fine
> > that even -ENOMEM can return KVM_EXIT_MEMORY_FAULT,
> > and it doesn't violate the documentation.  The docs tell you "what
> > can you do if error if EFAULT or EHWPOISON?"; they don't
> > exclude that other errnos result in KVM_EXIT_MEMORY_FAULT,
> > it's just that you're not supposed to look at it
>=20
> Thanks, it's OK for ENOMEM + KVM_EXIT_MEMORY_FAULT.
>=20
> Another concern is, now 3 places to report EFAULT + KVM_EXIT_MEMORY_FAULT=
:
>=20
>   if (!kvm_slot_can_be_private(fault->slot)) {
> 	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> 	return -EFAULT;
>   }
>=20
>   file =3D kvm_gmem_get_file(slot);
>   if (!file)
> 	return -EFAULT;
>=20
>   if (fault->is_private !=3D kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> 	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> 	return -EFAULT;
>   }
>=20
> They are different cases, and seems userspace should handle them
> differently, but not enough information to distinguish them.

For the first, the memory_fault exit will inform userspace that the guest w=
ants
to map memory as private, and userspace will see that the memslot isn't con=
figured
to support private mappings.  Userspace may not even need to query memslots=
, e.g.
if the gfn in question has been enumerated to the guest as something that c=
an only
be mapped shared.

For the second (no valid guest_memfd file), userspace put the last referenc=
e to
the guest_memfd file without informing the guest or creating a memslot.  Th=
at's
firmly a userspace bug.

For the third and last, userspace will see that the guest is requesting a p=
rivate
mapping but the gfn is configured for shared mappings.

In all cases, userspace has the necessary information to resolve the issue,=
 where
"resolving the issue" may mean terminating the guest.  If userspace isn't t=
racking
memslots or the private attribute, then userspace has far bigger problems.

