Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C03E7795EF
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 19:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbjHKRO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 13:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjHKRO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 13:14:56 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491EB2686
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 10:14:55 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68732996d32so3504161b3a.3
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 10:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691774095; x=1692378895;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q0w9R2cbEIEQp4oFwhF1sF93MTwo7GvgbD/OinV5zIQ=;
        b=RZ9BEzL0CatBhRs+XcIsywWNw5ZRWT/1fPdEuNo11fSmywzlfvZHEsifSHwBrNxd4l
         Zk+u1JzxjM+molPKyemH3X0Zh4+tmPa93KZIFzCawCnm5NEe1C67xj7EfFesujwDKPYZ
         oVdu++Hw51rcz3BLawCOnAfwGTL/8snFHz3FqLNWI+Vvgyp6zFrtutpitTbImPArnXmy
         blRkzmLTkOhLs6FzaC7pCkFIHVedMCfZEdMzRR6rJmiN6Vph4Hpf3e6/1lf2qNwGwjh2
         S1hAAPtNVC5beWfWnhj5y3anyNaVvqUimrA2BbHFIXndLs5BGmxSkCfz4sFdrc6R8nOm
         SmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691774095; x=1692378895;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q0w9R2cbEIEQp4oFwhF1sF93MTwo7GvgbD/OinV5zIQ=;
        b=Chfupt/CsPQU8kUwasRl77p2SqIlpt3/ERiipMUXla8H8owcg6/nKJ7Z7K8+5pBZ5W
         evIgMUJyV68UIQiddhWR+K5VMHIYT0GfadRU+2YO0ONH2WQERYmkmMcqzra816BxYFCv
         m4Cx2uc7h+x55uahUHalyW1wQ2/Wk3BaK7Mn2RpWtmLRclseAa1wUp42O6w+cHoGcR+D
         uuK1EQhm3dEOYKibwonbxzjfTnDJRyHng5rzG0s8BtX2qzt7NPjRvqx6XDwjdQChutu0
         M5hKmsL9Zh2kz/xqnD32gpjm0336JYrblbJkrTKQ50JicCMxGK2Ei8IdeWK7WBjzSKsL
         KigQ==
X-Gm-Message-State: AOJu0YydNrA/eVVaA3xBSxQeOMEVS8fWcNCdTpN2AduYdbxcJnqQTE9F
        k2vkl5RfTy/fWAUr+hp7NIc+jmQp3OE=
X-Google-Smtp-Source: AGHT+IEPqdFXRLC3JnZ4cfyU42Nnk6XvzioY8NGcD3s3flYwDAgyVSQuJrJB2fmHSInRttXLi1p09HMmrMI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:17a5:b0:686:a1c7:859a with SMTP id
 s37-20020a056a0017a500b00686a1c7859amr1161323pfg.1.1691774094752; Fri, 11 Aug
 2023 10:14:54 -0700 (PDT)
Date:   Fri, 11 Aug 2023 10:14:45 -0700
In-Reply-To: <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230810085636.25914-1-yan.y.zhao@intel.com> <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn> <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn> <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
Message-ID: <ZNZshVZI5bRq4mZQ@google.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     bibo mao <maobibo@loongson.cn>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        jgg@nvidia.com, rppt@kernel.org, akpm@linux-foundation.org,
        kevin.tian@intel.com, david@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023, Yan Zhao wrote:
> On Fri, Aug 11, 2023 at 03:40:44PM +0800, bibo mao wrote:
> >=20
> > =E5=9C=A8 2023/8/11 11:45, Yan Zhao =E5=86=99=E9=81=93:
> > >>> +static void kvm_mmu_notifier_numa_protect(struct mmu_notifier *mn,
> > >>> +					  struct mm_struct *mm,
> > >>> +					  unsigned long start,
> > >>> +					  unsigned long end)
> > >>> +{
> > >>> +	struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> > >>> +
> > >>> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
> > >>> +	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
> > >>> +		return;
> > >>> +
> > >>> +	kvm_handle_hva_range(mn, start, end, __pte(0), kvm_unmap_gfn_rang=
e);
> > >>> +}
> > >> numa balance will scan wide memory range, and there will be one time
> > > Though scanning memory range is wide, .invalidate_range_start() is se=
nt
> > > for each 2M range.
> > yes, range is huge page size when changing numa protection during numa =
scanning.
> >=20
> > >=20
> > >> ipi notification with kvm_flush_remote_tlbs. With page level notific=
ation,
> > >> it may bring out lots of flush remote tlb ipi notification.
> > >=20
> > > Hmm, for VMs with assigned devices, apparently, the flush remote tlb =
IPIs
> > > will be reduced to 0 with this series.
> > >=20
> > > For VMs without assigned devices or mdev devices, I was previously al=
so
> > > worried about that there might be more IPIs.
> > > But with current test data, there's no more remote tlb IPIs on averag=
e.
> > >=20
> > > The reason is below:
> > >=20
> > > Before this series, kvm_unmap_gfn_range() is called for once for a 2M
> > > range.

No, it's potentially called once per 1GiB range.  change_pmd_range() invoke=
s the
mmu_notifier with addr+end, where "end" is the end of the range covered by =
the
PUD, not the the end of the current PMD.  So the worst case scenario would =
be a
256k increase.  Of course, if you have to migrate an entire 1GiB chunk of m=
emory
then you likely have bigger problems, but still.

> > > After this series, kvm_unmap_gfn_range() is called for once if the 2M=
 is
> > > mapped to a huge page in primary MMU, and called for at most 512 time=
s
> > > if mapped to 4K pages in primary MMU.
> > >=20
> > >=20
> > > Though kvm_unmap_gfn_range() is only called once before this series,
> > > as the range is blockable, when there're contentions, remote tlb IPIs
> > > can be sent page by page in 4K granularity (in tdp_mmu_iter_cond_resc=
hed())
> > I do not know much about x86, does this happen always or only need resc=
hedule
> Ah, sorry, I missed platforms other than x86.
> Maybe there will be a big difference in other platforms.
>=20
> > from code?  so that there will be many times of tlb IPIs in only once f=
unction
> Only when MMU lock is contended. But it's not seldom because of the conte=
ntion in
> TDP page fault.

No?  I don't see how mmu_lock contention would affect the number of calls t=
o=20
kvm_flush_remote_tlbs().  If vCPUs are running and not generating faults, i=
.e.
not trying to access the range in question, then ever zap will generate a r=
emote
TLB flush and thus send IPIs to all running vCPUs.

> > call about kvm_unmap_gfn_range.
> >=20
> > > if the pages are mapped in 4K in secondary MMU.
> > >=20
> > > With this series, on the other hand, .numa_protect() sets range to be
> > > unblockable. So there could be less remote tlb IPIs when a 2M range i=
s
> > > mapped into small PTEs in secondary MMU.
> > > Besides, .numa_protect() is not sent for all pages in a given 2M rang=
e.
> > No, .numa_protect() is not sent for all pages. It depends on the worklo=
ad,
> > whether the page is accessed for different cpu threads cross-nodes.
> The .numa_protect() is called in patch 4 only when PROT_NONE is set to
> the page.

I'm strongly opposed to adding MMU_NOTIFIER_RANGE_NUMA.  It's too much of a=
 one-off,
and losing the batching of invalidations makes me nervous.  As Bibo points =
out,
the behavior will vary based on the workload, VM configuration, etc.

There's also a *very* subtle change, in that the notification will be sent =
while
holding the PMD/PTE lock.  Taking KVM's mmu_lock under that is *probably* o=
k, but
I'm not exactly 100% confident on that.  And the only reason there isn't a =
more
obvious bug is because kvm_handle_hva_range() sets may_block to false, e.g.=
 KVM
won't yield if there's mmu_lock contention.

However, *if* it's ok to invoke MMU notifiers while holding PMD/PTE locks, =
then
I think we can achieve what you want without losing batching, and without c=
hanging
secondary MMUs.

Rather than muck with the notification types and add a one-off for NUMA, ju=
st
defer the notification until a present PMD/PTE is actually going to be modi=
fied.
It's not the prettiest, but other than the locking, I don't think has any c=
hance
of regressing other workloads/configurations.

Note, I'm assuming secondary MMUs aren't allowed to map swap entries...

Compile tested only.

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 11 Aug 2023 10:03:36 -0700
Subject: [PATCH] tmp

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/huge_mm.h |  4 +++-
 include/linux/mm.h      |  3 +++
 mm/huge_memory.c        |  5 ++++-
 mm/mprotect.c           | 47 +++++++++++++++++++++++++++++------------
 4 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 20284387b841..b88316adaaad 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -7,6 +7,8 @@
=20
 #include <linux/fs.h> /* only for vma_is_dax() */
=20
+struct mmu_notifier_range;
+
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
@@ -38,7 +40,7 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned l=
ong old_addr,
 		   unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd);
 int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		    pmd_t *pmd, unsigned long addr, pgprot_t newprot,
-		    unsigned long cp_flags);
+		    unsigned long cp_flags, struct mmu_notifier_range *range);
=20
 vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)=
;
 vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)=
;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2dd73e4f3d8e..284f61cf9c37 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2478,6 +2478,9 @@ static inline bool vma_wants_manual_pte_write_upgrade=
(struct vm_area_struct *vma
 	return !!(vma->vm_flags & VM_WRITE);
=20
 }
+
+void change_pmd_range_notify_secondary_mmus(unsigned long addr,
+					    struct mmu_notifier_range *range);
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long add=
r,
 			     pte_t pte);
 extern long change_protection(struct mmu_gather *tlb,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a71cf686e3b2..47c7712b163e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1808,7 +1808,7 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsign=
ed long old_addr,
  */
 int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		    pmd_t *pmd, unsigned long addr, pgprot_t newprot,
-		    unsigned long cp_flags)
+		    unsigned long cp_flags, struct mmu_notifier_range *range)
 {
 	struct mm_struct *mm =3D vma->vm_mm;
 	spinlock_t *ptl;
@@ -1893,6 +1893,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm=
_area_struct *vma,
 		    !toptier)
 			xchg_page_access_time(page, jiffies_to_msecs(jiffies));
 	}
+
+	change_pmd_range_notify_secondary_mmus(addr, range);
+
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
 	 * to not clear pmd intermittently to avoid race with MADV_DONTNEED
diff --git a/mm/mprotect.c b/mm/mprotect.c
index d1a809167f49..f5844adbe0cb 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -82,7 +82,8 @@ bool can_change_pte_writable(struct vm_area_struct *vma, =
unsigned long addr,
=20
 static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
-		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
+		unsigned long end, pgprot_t newprot, unsigned long cp_flags,
+		struct mmu_notifier_range *range)
 {
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
@@ -164,8 +165,12 @@ static long change_pte_range(struct mmu_gather *tlb,
 				    !toptier)
 					xchg_page_access_time(page,
 						jiffies_to_msecs(jiffies));
+
+
 			}
=20
+			change_pmd_range_notify_secondary_mmus(addr, range);
+
 			oldpte =3D ptep_modify_prot_start(vma, addr, pte);
 			ptent =3D pte_modify(oldpte, newprot);
=20
@@ -355,6 +360,17 @@ pgtable_populate_needed(struct vm_area_struct *vma, un=
signed long cp_flags)
 		err;							\
 	})
=20
+void change_pmd_range_notify_secondary_mmus(unsigned long addr,
+					    struct mmu_notifier_range *range)
+{
+	if (range->start)
+		return;
+
+	VM_WARN_ON(addr >=3D range->end);
+	range->start =3D addr;
+	mmu_notifier_invalidate_range_start_nonblock(range);
+}
+
 static inline long change_pmd_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -365,7 +381,14 @@ static inline long change_pmd_range(struct mmu_gather =
*tlb,
 	unsigned long nr_huge_updates =3D 0;
 	struct mmu_notifier_range range;
=20
-	range.start =3D 0;
+	/*
+	 * Defer invalidation of secondary MMUs until a PMD/PTE change is
+	 * imminent, e.g. NUMA balancing in particular can "fail" for certain
+	 * types of mappings.  Initialize range.start to '0' and use it to
+	 * track whether or not the invalidation notification has been set.
+	 */
+	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA, 0,
+				vma->vm_mm, 0, end);
=20
 	pmd =3D pmd_offset(pud, addr);
 	do {
@@ -383,18 +406,16 @@ static inline long change_pmd_range(struct mmu_gather=
 *tlb,
 		if (pmd_none(*pmd))
 			goto next;
=20
-		/* invoke the mmu notifier if the pmd is populated */
-		if (!range.start) {
-			mmu_notifier_range_init(&range,
-				MMU_NOTIFY_PROTECTION_VMA, 0,
-				vma->vm_mm, addr, end);
-			mmu_notifier_invalidate_range_start(&range);
-		}
-
 		_pmd =3D pmdp_get_lockless(pmd);
 		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
 			if ((next - addr !=3D HPAGE_PMD_SIZE) ||
 			    pgtable_split_needed(vma, cp_flags)) {
+				/*
+				 * FIXME: __split_huge_pmd() performs its own
+				 * mmu_notifier invalidation prior to clearing
+				 * the PMD, ideally all invalidations for the
+				 * range would be batched.
+				 */
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
 				/*
 				 * For file-backed, the pmd could have been
@@ -407,8 +428,8 @@ static inline long change_pmd_range(struct mmu_gather *=
tlb,
 					break;
 				}
 			} else {
-				ret =3D change_huge_pmd(tlb, vma, pmd,
-						addr, newprot, cp_flags);
+				ret =3D change_huge_pmd(tlb, vma, pmd, addr,
+						      newprot, cp_flags, &range);
 				if (ret) {
 					if (ret =3D=3D HPAGE_PMD_NR) {
 						pages +=3D HPAGE_PMD_NR;
@@ -423,7 +444,7 @@ static inline long change_pmd_range(struct mmu_gather *=
tlb,
 		}
=20
 		ret =3D change_pte_range(tlb, vma, pmd, addr, next, newprot,
-				       cp_flags);
+				       cp_flags, &range);
 		if (ret < 0)
 			goto again;
 		pages +=3D ret;

base-commit: 1f40f634009556c119974cafce4c7b2f9b8c58ad
--=20


