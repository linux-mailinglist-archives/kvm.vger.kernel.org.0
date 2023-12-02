Return-Path: <kvm+bounces-3213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D721C801921
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13EC31C20C9F
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFBD17D8;
	Sat,  2 Dec 2023 00:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BrsRhSBS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73C5103
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:51:57 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6cde4ac52bcso3596740b3a.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701478317; x=1702083117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qf5LyHZHuBq8ET8yZ518WK6d/Ohu8OSBvuXvyN934wU=;
        b=BrsRhSBSD3WXs1ti220jRiSqqW2dr71Ax39DiD4BQ0UNcXaNJfeQFYVrNVDHoS55zC
         y9swqZPcBZSpBtAtMPw5opqheNWr+F0k35RZ/nqH4KrLaThcGoyc1iFef3y6QLl693vn
         jWyDpf/trBqxP3W39teXhPRwhja2TgKbrUxw34gmaN7DI08CvdvsnLSGOX6hgz4kRe/j
         DLW72mZNakDaT0kEsoXs6DlkD+D0poS5Kkf4if6cxKFUy/MiR73VZ5NfQ5lZn9/neV1K
         709jINms3S19TPiA609w7wo8lw7BzN/H9RHVZ7X3u14+l/PQ5BIXvloMKS72Ofme80vN
         +r4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701478317; x=1702083117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qf5LyHZHuBq8ET8yZ518WK6d/Ohu8OSBvuXvyN934wU=;
        b=pM58Bl+SVfnx+gdH23M5g6b0KFtSwVObmyDJatMJfhbW1qpV4vrDyvj5HNLfZJribu
         KcYbC4lWWXaV7WwHRxaa1xq70un+h3ccti+b5FkUfbtPRZdiNq2foaNMamchiLt3VK3M
         m2+RhnIJ2YODWEg8PDwtmsdhwH/m3EbvFbgK0SINT0raBv1WmjoCgr9dnffNwwVaKMw3
         l+YYOVIF/S+pZpwsiPKET3qGcJOX6CteDDJ2k2XAqLX632X3smTgEgJJpD2zPkWD4oVa
         or0DQ+mZgxE59wxWMWav5PITUUETLL6kiWIoBTwqG28clLYpFr6Wqg0+32nBZfjIbL3W
         FqOA==
X-Gm-Message-State: AOJu0YwY8IIliuGuJoJ/nL0SnTaFbm4cjcx4hdpFzIBBS6bK88Hh5G8Z
	UNRkpbk/0kh1LCK+Y026iWz3VoJBLZQ=
X-Google-Smtp-Source: AGHT+IEloABSTDcKm+41L5WpzazJRfhcCVpuae9X+15kKFthyi+8YQcZOmegDR+VoF+o36yu4wG4kUpnsoo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5848:0:b0:5b8:fe99:152d with SMTP id
 i8-20020a635848000000b005b8fe99152dmr4028549pgm.7.1701478317322; Fri, 01 Dec
 2023 16:51:57 -0800 (PST)
Date: Fri, 1 Dec 2023 16:51:55 -0800
In-Reply-To: <20230918160258.GL13795@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com> <20230916003118.2540661-6-seanjc@google.com>
 <20230918152110.GI13795@ziepe.ca> <ZQhxpesyXeG+qbS6@google.com> <20230918160258.GL13795@ziepe.ca>
Message-ID: <ZWp_q1w01NCZi8KX@google.com>
Subject: Re: [PATCH 05/26] vfio: KVM: Pass get/put helpers from KVM to VFIO,
 don't do circular lookup
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>, 
	Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 18, 2023, Jason Gunthorpe wrote:
> On Mon, Sep 18, 2023 at 08:49:57AM -0700, Sean Christopherson wrote:
> > On Mon, Sep 18, 2023, Jason Gunthorpe wrote:
> > > On Fri, Sep 15, 2023 at 05:30:57PM -0700, Sean Christopherson wrote:
> > > > Explicitly pass KVM's get/put helpers to VFIO when attaching a VM to
> > > > VFIO instead of having VFIO do a symbol lookup back into KVM.  Having both
> > > > KVM and VFIO do symbol lookups increases the overall complexity and places
> > > > an unnecessary dependency on KVM (from VFIO) without adding any value.
> > > > 
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  drivers/vfio/vfio.h      |  2 ++
> > > >  drivers/vfio/vfio_main.c | 74 +++++++++++++++++++---------------------
> > > >  include/linux/vfio.h     |  4 ++-
> > > >  virt/kvm/vfio.c          |  9 +++--
> > > >  4 files changed, 47 insertions(+), 42 deletions(-)
> > > 
> > > I don't mind this, but Christoph had disliked my prior attempt to do
> > > this with function pointers..
> > > 
> > > The get can be inlined, IIRC, what about putting a pointer to the put
> > > inside the kvm struct?
> > 
> > That wouldn't allow us to achieve our goal, which is to hide the details of
> > "struct kvm" from VFIO (and the rest of the kernel).
> 
> > What's the objection to handing VFIO a function pointer?
> 
> Hmm, looks like it was this thread:
> 
>  https://lore.kernel.org/r/0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com
> 
> Your rational looks a little better to me.
> 
> > > The the normal kvm get/put don't have to exported symbols at all?
> > 
> > The export of kvm_get_kvm_safe() can go away (I forgot to do that in this series),
> > but kvm_get_kvm() will hang around as it's needed by KVM sub-modules (PPC and x86),
> > KVMGT (x86), and drivers/s390/crypto/vfio_ap_ops.c (no idea what to call that beast).
> 
> My thought would be to keep it as an inline, there should be some way
> to do that without breaking your desire to hide the bulk of the kvm
> struct content. Like put the refcount as the first element in the
> struct and just don't ifdef it away?.

That doesn't work because of the need to invoke kvm_destroy_vm() when the last
reference is put, i.e. all of kvm_destroy_vm() would need to be inlined (LOL) or
VFIO would need to do a symbol lookup on kvm_destroy_vm(), which puts back us at
square one.

There's one more wrinkle: this patch is buggy in that it doesn't ensure the liveliness
of KVM-the-module, i.e. nothing prevents userspace from unloading kvm.ko while VFIO
still holds a reference to a kvm structure, and so invoking ->put_kvm() could jump
into freed code.  To fix that, KVM would also need to pass along a module pointer :-(

One thought would be to have vac.ko (tentative name), which is the "base" module
that will hold the KVM/virtualization bits that need to be singletons, i.e. can't
be per-KVM, provide the symbols needed for VFIO to manage references.  But that
just ends up moving the module reference trickiness into VAC+KVM, e.g. vac.ko would
still need to be handed a function pointer in order to call back into the correct
kvm.ko code.

Hrm, but I suspect the vac.ko <=> kvm.ko interactions will need to deal with
module shenanigans anyways, and the shenanigans would only affect crazy people
like us that actually want multiple KVM modules.

I'll plan on going that route.  The very worst case scenario is that it just punts
this conversation down to a possibile future.  Dropping this patch and the previous
prep patch won't meaningful affect the goals of this series, as only kvm_get_kvm_safe()
and kvm_get_kvm() would need to be exposed outside of #ifdef __KVM__.  Then we can
figure out what to do with them if/when the whole multi-KVM thing comes along.

