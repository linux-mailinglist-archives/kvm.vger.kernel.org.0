Return-Path: <kvm+bounces-52273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C7CB038B4
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 10:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6891189B615
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 08:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608B523D2BC;
	Mon, 14 Jul 2025 08:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZgZvm7Ec"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680F723A9B1;
	Mon, 14 Jul 2025 08:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752480293; cv=none; b=fBHWBNG0ij6jdCxJfP0lBmSXsLJGFRCYnLQ28evUNgTrBCqS7Vu/dUGXvPHY+7Q2xyu+cpk9ruiNL8vtInOGdAwKxR/XIawzwiuZbxW8Qfr7VlTm5GIu28TZN46w+uDzVQFVxSebwdqsgo72+EHkzkgKYJIGJNXahyGw59a+eG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752480293; c=relaxed/simple;
	bh=H9kiQECWZOW5ov4j9VoAQjWYSxSJ36A7Y3M4vXz83Ng=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkDf3E3gMa9FLCIi3SGpLJhWzzgFYe59uxdCIcT+jo8FdiWj4BvF3M+qN07zsHDixcGeNR7YFakCUO7TLqNaQ4lHeTaOevNd4gkGJEALrinwhUiFRIQWQQuGLndgdgrllT8xVvnFVi4B+taAimMjkSdteSbgO0zyZXPEfZAIUD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZgZvm7Ec; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E3DC4CEED;
	Mon, 14 Jul 2025 08:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752480292;
	bh=H9kiQECWZOW5ov4j9VoAQjWYSxSJ36A7Y3M4vXz83Ng=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZgZvm7EcBxADHZBQMVcToBi9IJWjthwxrTPdhAE/knyvKBJkroL+lV5qMFJz3wrMA
	 A4HmA7y1rIf2i3QUgaAIRSXmQ17NnpT5FPyZD7vFLnZ26kC0OFnn43mERJBs9ofwwr
	 yOdUqvtFjlg4wqotMBl7ccKC+oxc3HTqi/dDF/o8sWlbaN9EkXlRQiEFciSxWkUj2e
	 jJ3KGix/mc3uzs3L2NXz/xJfFpFgPBgXN6sY6fu173EQiCxvi2dpQTytSHVvGfUI7x
	 oWdb7O+ohBYxSP05RYHuFCVU/FozUF11ITg+lSUa6b5aZemek9hMYIh4815xVVzdNC
	 CqzORr7Fxyliw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubEB7-00FR6s-FO;
	Mon, 14 Jul 2025 09:04:49 +0100
Date: Mon, 14 Jul 2025 09:04:48 +0100
Message-ID: <8634az9p0f.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	chenhuacai@kernel.org,
	mpe@ellerman.id.au,
	anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	seanjc@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	xiaoyao.li@intel.com,
	yilun.xu@intel.com,
	chao.p.peng@linux.intel.com,
	jarkko@kernel.org,
	amoorthy@google.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	mic@digikod.net,
	vbabka@suse.cz,
	vannapurve@google.com,
	ackerleytng@google.com,
	mail@maciej.szmigiero.name,
	david@redhat.com,
	michael.roth@amd.com,
	wei.w.wang@intel.com,
	liam.merwick@oracle.com,
	isaku.yamahata@gmail.com,
	kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com,
	steven.price@arm.com,
	quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	yuzenghui@huawei.com,
	oliver.upton@linux.dev,
	will@kernel.org,
	qperret@google.com,
	keirf@google.com,
	roypat@amazon.co.uk,
	shuah@kernel.org,
	hch@infradead.org,
	jgg@nvidia.com,
	rientjes@google.com,
	jhubbard@nvidia.com,
	fvdl@google.com,
	hughd@google.com,
	jthoughton@google.com,
	peterx@redhat.com,
	pankaj.gupta@amd.com,
	ira.weiny@intel.com
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest page faults
In-Reply-To: <CA+EHjTyJGWJ0Pj-jPjriFjy3JHpVUa0PW0vQz4o8UPdLbMV7pg@mail.gmail.com>
References: <20250709105946.4009897-1-tabba@google.com>
	<20250709105946.4009897-17-tabba@google.com>
	<865xfyadjv.wl-maz@kernel.org>
	<CA+EHjTyJGWJ0Pj-jPjriFjy3JHpVUa0PW0vQz4o8UPdLbMV7pg@mail.gmail.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderr
 in@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 14 Jul 2025 08:42:00 +0100,
Fuad Tabba <tabba@google.com> wrote:
> 
> Hi Marc,
> 
> 
> On Fri, 11 Jul 2025 at 17:38, Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Wed, 09 Jul 2025 11:59:42 +0100,
> > Fuad Tabba <tabba@google.com> wrote:
> > >
> > > Add arm64 architecture support for handling guest page faults on memory
> > > slots backed by guest_memfd.
> > >
> > > This change introduces a new function, gmem_abort(), which encapsulates
> > > the fault handling logic specific to guest_memfd-backed memory. The
> > > kvm_handle_guest_abort() entry point is updated to dispatch to
> > > gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
> > > determined by kvm_slot_has_gmem()).
> > >
> > > Until guest_memfd gains support for huge pages, the fault granule for
> > > these memory regions is restricted to PAGE_SIZE.
> > >
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: James Houghton <jthoughton@google.com>
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/kvm/mmu.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 79 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 58662e0ef13e..71f8b53683e7 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -1512,6 +1512,78 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> > >       *prot |= kvm_encode_nested_level(nested);
> > >  }
> > >
> > > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > > +
> > > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > +                   struct kvm_s2_trans *nested,
> > > +                   struct kvm_memory_slot *memslot, bool is_perm)
> > > +{
> > > +     bool write_fault, exec_fault, writable;
> > > +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > > +     enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > > +     struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > > +     struct page *page;
> > > +     struct kvm *kvm = vcpu->kvm;
> > > +     void *memcache;
> > > +     kvm_pfn_t pfn;
> > > +     gfn_t gfn;
> > > +     int ret;
> > > +
> > > +     ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     if (nested)
> > > +             gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > > +     else
> > > +             gfn = fault_ipa >> PAGE_SHIFT;
> > > +
> > > +     write_fault = kvm_is_write_fault(vcpu);
> > > +     exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > > +
> > > +     if (write_fault && exec_fault) {
> > > +             kvm_err("Simultaneous write and execution fault\n");
> > > +             return -EFAULT;
> > > +     }
> >
> > I don't think we need to cargo-cult this stuff. This cannot happen
> > architecturally (data and instruction aborts are two different
> > exceptions, so you can't have both at the same time), and is only
> > there because we were young and foolish when we wrote this crap.
> >
> > Now that we (the royal We) are only foolish, we can save a few bits by
> > dropping it. Or turn it into a VM_BUG_ON() if you really want to keep
> > it.
> 
> Will do, but if you agree, I'll go with a VM_WARN_ON_ONCE() since
> VM_BUG_ON is going away [1][2]
> 
> [1] https://lore.kernel.org/all/b247be59-c76e-4eb8-8a6a-f0129e330b11@redhat.com/
> [2] https://lore.kernel.org/all/20250604140544.688711-1-david@redhat.com/T/#u

Ah, sure. We've never seen these anyway in any situation other than
"I've mutated this kernel so badly it's closer to a hamster".

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

