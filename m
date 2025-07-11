Return-Path: <kvm+bounces-52181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85AFAB020D3
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 17:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35CF976774F
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B7CC2ED854;
	Fri, 11 Jul 2025 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRsE8SKp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259A02AE6D;
	Fri, 11 Jul 2025 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752248920; cv=none; b=glIicKLHMNQXz2gMwjbrKocTji3BBxXmfiJoydIC7YuirPQ8nF5xtW5t/63km8zFN2rTcUM5ZhuD8WEAwg4dhbtCjwVThbSr0850S+QdlR2nAziOsixlZY/qLGVYk+2pSVHqMy66T3ZNkVeMk+y/BGUA1GzjIg/NFxlB0h5spRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752248920; c=relaxed/simple;
	bh=u63lEDvAa2xXiWgVwZDeRuuCP1rwH/atFPBESKHWgbc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lvSxanpG+QGthv37L+uQy4C0MompMnX6hEfU3brJumN4n83a5CabCm4AeitFPp2/ZPWXofkF//MYFv9O+CvIfeJstI5KYlw/cpN+FIFlgGNfYgCr1sgbani1ie7FkLg5LAZXUQLM90yq9z0UNPpDsLR1os4Qqfqrht4AB7YkGvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRsE8SKp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B473C4CEED;
	Fri, 11 Jul 2025 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752248919;
	bh=u63lEDvAa2xXiWgVwZDeRuuCP1rwH/atFPBESKHWgbc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WRsE8SKpfPbjanj3BjB/2NO1pGJpohX6P/OJ7hG0D62uZ7xa92WyCZxbmWWoZWnT3
	 tk+4Y+Yl9uOS9df9S2WAL7h5TuiH3S9s70ob3U/DG/LFrRYODAjf5bxKisMW9/Hl12
	 498XPPkBcbRcjdHpTLBpu7o+YpAvXWjp8V1aStaRo8u6bh9RRHSSFBGIpT6BnlB+l3
	 XkiP+93ZKx9TFoPgwY+R1ixdhK07q3E8KvqzuqGGgIJti27m+pGBzovKonTtQfb+l5
	 j31iA052jOXmJbXDTRUHuLVAK2G64qOJgP9h/v6gTwp3qvjI8kue5rID1pmJH+bf7a
	 /yzCEJwQcCelA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uaFzI-00EvfQ-K6;
	Fri, 11 Jul 2025 16:48:36 +0100
Date: Fri, 11 Jul 2025 16:48:35 +0100
Message-ID: <867c0eafu4.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"amoorthy@google.com" <amoorthy@google.com>,
	"anup@brainfault.org" <anup@brainfault.org>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"fvdl@google.com" <fvdl@google.com>,
	"hch@infradead.org" <hch@infradead.org>,
	"hughd@google.com" <hughd@google.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"keirf@google.com" <keirf@google.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>,
	"mic@digikod.net" <mic@digikod.net>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"qperret@google.com" <qperret@google.com>,
	"quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>,
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>,
	"quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>,
	"quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>,
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"steven.price@arm.com" <steven.price@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"vannapurve@google.com" <vannapurve@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"wei.w.wang@intel.com" <wei.w.wang@intel.com>,
	"will@kernel.org" <will@kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>,
	"yilun.xu@intel.com" <yilun.xu@intel.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest page faults
In-Reply-To: <CA+EHjTz-MWYUKA6dbcZGvt=rRXnorrpJHbNLq-Kng5q7yaLERA@mail.gmail.com>
References: <20250709105946.4009897-17-tabba@google.com>
	<20250711095937.22365-1-roypat@amazon.co.uk>
	<86a55aalbv.wl-maz@kernel.org>
	<CA+EHjTz-MWYUKA6dbcZGvt=rRXnorrpJHbNLq-Kng5q7yaLERA@mail.gmail.com>
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
X-SA-Exim-Rcpt-To: tabba@google.com, roypat@amazon.co.uk, ackerleytng@google.com, akpm@linux-foundation.org, amoorthy@google.com, anup@brainfault.org, aou@eecs.berkeley.edu, brauner@kernel.org, catalin.marinas@arm.com, chao.p.peng@linux.intel.com, chenhuacai@kernel.org, david@redhat.com, dmatlack@google.com, fvdl@google.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, isaku.yamahata@gmail.com, isaku.yamahata@intel.com, james.morse@arm.com, jarkko@kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, jthoughton@google.com, keirf@google.com, kirill.shutemov@linux.intel.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, liam.merwick@oracle.com, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, mail@maciej.szmigiero.name, mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, qperret@google.com, quic_cvanscha@quicinc.com, quic_eberman@quicinc.co
 m, quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, rientjes@google.com, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, suzuki.poulose@arm.com, vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, xiaoyao.li@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 11 Jul 2025 15:17:46 +0100,
Fuad Tabba <tabba@google.com> wrote:
> 
> Hi Marc,
> 
> On Fri, 11 Jul 2025 at 14:50, Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Fri, 11 Jul 2025 10:59:39 +0100,
> > "Roy, Patrick" <roypat@amazon.co.uk> wrote:
> > >
> > >
> > > Hi Fuad,
> > >
> > > On Wed, 2025-07-09 at 11:59 +0100, Fuad Tabba wrote:> -snip-
> > > > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > > > +
> > > > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > > +                     struct kvm_s2_trans *nested,
> > > > +                     struct kvm_memory_slot *memslot, bool is_perm)
> > > > +{
> > > > +       bool write_fault, exec_fault, writable;
> > > > +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > > > +       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > > > +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > > > +       struct page *page;
> > > > +       struct kvm *kvm = vcpu->kvm;
> > > > +       void *memcache;
> > > > +       kvm_pfn_t pfn;
> > > > +       gfn_t gfn;
> > > > +       int ret;
> > > > +
> > > > +       ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > > > +       if (ret)
> > > > +               return ret;
> > > > +
> > > > +       if (nested)
> > > > +               gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > > > +       else
> > > > +               gfn = fault_ipa >> PAGE_SHIFT;
> > > > +
> > > > +       write_fault = kvm_is_write_fault(vcpu);
> > > > +       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > > > +
> > > > +       if (write_fault && exec_fault) {
> > > > +               kvm_err("Simultaneous write and execution fault\n");
> > > > +               return -EFAULT;
> > > > +       }
> > > > +
> > > > +       if (is_perm && !write_fault && !exec_fault) {
> > > > +               kvm_err("Unexpected L2 read permission error\n");
> > > > +               return -EFAULT;
> > > > +       }
> > > > +
> > > > +       ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > > > +       if (ret) {
> > > > +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > > > +                                             write_fault, exec_fault, false);
> > > > +               return ret;
> > > > +       }
> > > > +
> > > > +       writable = !(memslot->flags & KVM_MEM_READONLY);
> > > > +
> > > > +       if (nested)
> > > > +               adjust_nested_fault_perms(nested, &prot, &writable);
> > > > +
> > > > +       if (writable)
> > > > +               prot |= KVM_PGTABLE_PROT_W;
> > > > +
> > > > +       if (exec_fault ||
> > > > +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > > > +            (!nested || kvm_s2_trans_executable(nested))))
> > > > +               prot |= KVM_PGTABLE_PROT_X;
> > > > +
> > > > +       kvm_fault_lock(kvm);
> > >
> > > Doesn't this race with gmem invalidations (e.g. fallocate(PUNCH_HOLE))?
> > > E.g. if between kvm_gmem_get_pfn() above and this kvm_fault_lock() a
> > > gmem invalidation occurs, don't we end up with stage-2 page tables
> > > refering to a stale host page? In user_mem_abort() there's the "grab
> > > mmu_invalidate_seq before dropping mmap_lock and check it hasnt changed
> > > after grabbing mmu_lock" which prevents this, but I don't really see an
> > > equivalent here.
> >
> > Indeed. We have a similar construct in kvm_translate_vncr() as well,
> > and I'd definitely expect something of the sort 'round here. If for
> > some reason this is not needed, then a comment explaining why would be
> > welcome.
> >
> > But this brings me to another interesting bit: kvm_translate_vncr() is
> > another path that deals with a guest translation fault (despite being
> > caught as an EL2 S1 fault), and calls kvm_faultin_pfn(). What happens
> > when the backing store is gmem? Probably nothin
> 
> I'll add guest_memfd handling logic to kvm_translate_vncr().
> 
> > I don't immediately see why NV and gmem should be incompatible, so
> > something must be done on that front too (including the return to
> > userspace if the page is gone).
> 
> Should it return to userspace or go back to the guest?
> user_mem_abort() returns to the guest if the page disappears (I don't
> quite understand the rationale behind that, but it was a deliberate
> change [1]): on mmu_invalidate_retry() it sets ret to -EAGAIN [2],
> which gets flipped to 0 on returning from user_mem_abort() [3].

Outside of gmem, racing with an invalidation (resulting in -EAGAIN) is
never a problem. We just replay the faulting instruction.  Also,
kvm_faultin_pfn() never fails outside of error cases (guest accessing
non-memory, or writing to RO memory). So returning to the guest is
always the right thing to do, and userspace never needs to see any of
that (I ignore userfaultfd here, as that's a different matter).

With gmem, you don't really have a choice. Whoever is in charge of the
memory told you it can't get to it, and it's only fair to go back to
userspace for it to sort it out (if at all possible).

So when it comes to VNCR faults, the behaviour should be the same,
given that the faulting page *is* a guest page, even if this isn't a
stage-2 mapping that we are dealing with.

I'd expect something along the lines of the hack below, (completely
untested, as usual).

Thanks,

	M.

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5b191f4dc5668..98b1d6d4688a6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1172,8 +1172,9 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
 }
 
-static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
+static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *gmem)
 {
+	struct kvm_memory_slot *memslot;
 	bool write_fault, writable;
 	unsigned long mmu_seq;
 	struct vncr_tlb *vt;
@@ -1216,9 +1217,21 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
 	smp_rmb();
 
 	gfn = vt->wr.pa >> PAGE_SHIFT;
-	pfn = kvm_faultin_pfn(vcpu, gfn, write_fault, &writable, &page);
-	if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
-		return -EFAULT;
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	*gmem = kvm_slot_has_gmem(memslot);
+	if (!*gmem) {
+		pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
+					&writable, &page);
+		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+			return -EFAULT;
+	} else {
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
+		if (ret) {
+			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
+						      write_fault, false, false);
+			return ret;
+		}
+	}
 
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
 		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq))
@@ -1292,14 +1305,14 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 	if (esr_fsc_is_permission_fault(esr)) {
 		inject_vncr_perm(vcpu);
 	} else if (esr_fsc_is_translation_fault(esr)) {
-		bool valid;
+		bool valid, gmem = false;
 		int ret;
 
 		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
 			valid = kvm_vncr_tlb_lookup(vcpu);
 
 		if (!valid)
-			ret = kvm_translate_vncr(vcpu);
+			ret = kvm_translate_vncr(vcpu, &gmem);
 		else
 			ret = -EPERM;
 
@@ -1309,6 +1322,14 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 			/* Let's try again... */
 			break;
 		case -EFAULT:
+		case -EIO:
+			/*
+			 * FIXME: Add whatever other error cases the
+			 * GMEM stuff can spit out.
+			 */
+			if (gmem)
+				return 0;
+			fallthrough;
 		case -EINVAL:
 		case -ENOENT:
 		case -EACCES:

-- 
Without deviation from the norm, progress is not possible.

