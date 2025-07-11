Return-Path: <kvm+bounces-52166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59941B01E3C
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CCFF1CA71E1
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794712D8378;
	Fri, 11 Jul 2025 13:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ex0NQL1v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9656B210F53;
	Fri, 11 Jul 2025 13:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752241802; cv=none; b=Vg4k10njNvbhY/Ac2a/HJxKC9jHHPUmrh34ff74Oz+T3GsaVM3WJ9Dp3OimefWFU/kP19mFQv2g/3l0hrR6C9wocRgADwQV1qnYwCovzxzcUIhBYIg6dzHUwyYACei0bPGbhWinsHxYjowUdNtoe9Bd+/LZRAP2qWm6esQlvaGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752241802; c=relaxed/simple;
	bh=Q9f2v4IJA+QGsJHQoinYJy5bvAk8yXzuvhOFwXDXv4o=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q+TO6zAiTbrMDuwMRJN7S1tj4A7QYU2+4vcjBP8iXBRaX7Vz+JOF86c7KvzoxrR2EfDmBXV7PdZX557MkcbHz3LJsA338a9t6Vu0lSYkUg0cYd37jI4FnSFec74hjBV8t4PDQU2dYl9RGpv7FqiDvUOALEO0HMhfxDycbaGL5dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ex0NQL1v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45ABC4CEF0;
	Fri, 11 Jul 2025 13:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752241802;
	bh=Q9f2v4IJA+QGsJHQoinYJy5bvAk8yXzuvhOFwXDXv4o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ex0NQL1vDhdncgmiYXCmU3DpofZgoGGw6WTDF5RxZE365iiYnABDMrI9dBtvTOeap
	 EKpYixCy2oRwA+dAD22F2baw9hJnxCvQ/2Yg9RmKVWN3xbZvXr+ip6k3OpT+C4QE8C
	 I6bnQEF0ColAZ0V2qDktz0DiAMUae8l0V6XsWz7n52LLK1JHmbNq9a9J6U3qIiQmcH
	 5PpAE0BDJaO1wd9KA11DtoHUYWe/x+rjhT3c2VkXwEPkyenoGojQEWkybS4cpEzJNN
	 ayGOQpWP06L/0hoOrUPBCG7U4iD/rjZ/TZneO9vjZfTKkfC5hytOZUPpDV31FOVDIC
	 pVndZ3UqPtGeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uaE8U-00EtR4-Ty;
	Fri, 11 Jul 2025 14:49:59 +0100
Date: Fri, 11 Jul 2025 14:49:56 +0100
Message-ID: <86a55aalbv.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: "Roy, Patrick" <roypat@amazon.co.uk>, "Fuad Tabba" <tabba@google.com>
Cc: 	"ackerleytng@google.com" <ackerleytng@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"amoorthy@google.com" <amoorthy@google.com>,
	"anup@brainfault.org"
	<anup@brainfault.org>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"catalin.marinas@arm.com"
	<catalin.marinas@arm.com>,
	"chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>,
	"chenhuacai@kernel.org"
	<chenhuacai@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"fvdl@google.com"
	<fvdl@google.com>,
	"hch@infradead.org" <hch@infradead.org>,
	"hughd@google.com" <hughd@google.com>,
	"ira.weiny@intel.com"
	<ira.weiny@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
	"james.morse@arm.com"
	<james.morse@arm.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>,
	"jhubbard@nvidia.com"
	<jhubbard@nvidia.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"keirf@google.com" <keirf@google.com>,
	"kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>,
	"kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"mail@maciej.szmigiero.name"
	<mail@maciej.szmigiero.name>,
	"mic@digikod.net" <mic@digikod.net>,
	"michael.roth@amd.com"
	<michael.roth@amd.com>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"palmer@dabbelt.com"
	<palmer@dabbelt.com>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"pbonzini@redhat.com"
	<pbonzini@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"qperret@google.com" <qperret@google.com>,
	"quic_cvanscha@quicinc.com"
	<quic_cvanscha@quicinc.com>,
	"quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>,
	"quic_mnalajal@quicinc.com"
	<quic_mnalajal@quicinc.com>,
	"quic_pderrin@quicinc.com"
	<quic_pderrin@quicinc.com>,
	"quic_pheragu@quicinc.com"
	<quic_pheragu@quicinc.com>,
	"quic_svaddagi@quicinc.com"
	<quic_svaddagi@quicinc.com>,
	"quic_tsoni@quicinc.com"
	<quic_tsoni@quicinc.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"steven.price@arm.com"
	<steven.price@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"vannapurve@google.com" <vannapurve@google.com>,
	"vbabka@suse.cz"
	<vbabka@suse.cz>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"wei.w.wang@intel.com" <wei.w.wang@intel.com>,
	"will@kernel.org"
	<will@kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>,
	"yilun.xu@intel.com"
	<yilun.xu@intel.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest page faults
In-Reply-To: <20250711095937.22365-1-roypat@amazon.co.uk>
References: <20250709105946.4009897-17-tabba@google.com>
	<20250711095937.22365-1-roypat@amazon.co.uk>
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
X-SA-Exim-Rcpt-To: roypat@amazon.co.uk, tabba@google.com, ackerleytng@google.com, akpm@linux-foundation.org, amoorthy@google.com, anup@brainfault.org, aou@eecs.berkeley.edu, brauner@kernel.org, catalin.marinas@arm.com, chao.p.peng@linux.intel.com, chenhuacai@kernel.org, david@redhat.com, dmatlack@google.com, fvdl@google.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, isaku.yamahata@gmail.com, isaku.yamahata@intel.com, james.morse@arm.com, jarkko@kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, jthoughton@google.com, keirf@google.com, kirill.shutemov@linux.intel.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, liam.merwick@oracle.com, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, mail@maciej.szmigiero.name, mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, qperret@google.com, quic_cvanscha@quicinc.com, quic_eberman@quicinc.co
 m, quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, rientjes@google.com, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, suzuki.poulose@arm.com, vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, xiaoyao.li@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 11 Jul 2025 10:59:39 +0100,
"Roy, Patrick" <roypat@amazon.co.uk> wrote:
> 
> 
> Hi Fuad,
> 
> On Wed, 2025-07-09 at 11:59 +0100, Fuad Tabba wrote:> -snip-
> > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > +
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                     struct kvm_s2_trans *nested,
> > +                     struct kvm_memory_slot *memslot, bool is_perm)
> > +{
> > +       bool write_fault, exec_fault, writable;
> > +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > +       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +       struct page *page;
> > +       struct kvm *kvm = vcpu->kvm;
> > +       void *memcache;
> > +       kvm_pfn_t pfn;
> > +       gfn_t gfn;
> > +       int ret;
> > +
> > +       ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (nested)
> > +               gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > +       else
> > +               gfn = fault_ipa >> PAGE_SHIFT;
> > +
> > +       write_fault = kvm_is_write_fault(vcpu);
> > +       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > +
> > +       if (write_fault && exec_fault) {
> > +               kvm_err("Simultaneous write and execution fault\n");
> > +               return -EFAULT;
> > +       }
> > +
> > +       if (is_perm && !write_fault && !exec_fault) {
> > +               kvm_err("Unexpected L2 read permission error\n");
> > +               return -EFAULT;
> > +       }
> > +
> > +       ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > +       if (ret) {
> > +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > +                                             write_fault, exec_fault, false);
> > +               return ret;
> > +       }
> > +
> > +       writable = !(memslot->flags & KVM_MEM_READONLY);
> > +
> > +       if (nested)
> > +               adjust_nested_fault_perms(nested, &prot, &writable);
> > +
> > +       if (writable)
> > +               prot |= KVM_PGTABLE_PROT_W;
> > +
> > +       if (exec_fault ||
> > +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > +            (!nested || kvm_s2_trans_executable(nested))))
> > +               prot |= KVM_PGTABLE_PROT_X;
> > +
> > +       kvm_fault_lock(kvm);
> 
> Doesn't this race with gmem invalidations (e.g. fallocate(PUNCH_HOLE))?
> E.g. if between kvm_gmem_get_pfn() above and this kvm_fault_lock() a
> gmem invalidation occurs, don't we end up with stage-2 page tables
> refering to a stale host page? In user_mem_abort() there's the "grab
> mmu_invalidate_seq before dropping mmap_lock and check it hasnt changed
> after grabbing mmu_lock" which prevents this, but I don't really see an
> equivalent here.

Indeed. We have a similar construct in kvm_translate_vncr() as well,
and I'd definitely expect something of the sort 'round here. If for
some reason this is not needed, then a comment explaining why would be
welcome.

But this brings me to another interesting bit: kvm_translate_vncr() is
another path that deals with a guest translation fault (despite being
caught as an EL2 S1 fault), and calls kvm_faultin_pfn(). What happens
when the backing store is gmem? Probably nothin

I don't immediately see why NV and gmem should be incompatible, so
something must be done on that front too (including the return to
userspace if the page is gone).

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

