Return-Path: <kvm+bounces-33836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 853EC9F29AA
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 06:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D2551883C02
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 05:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8431C4A3D;
	Mon, 16 Dec 2024 05:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BI9gAvLO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63EA1C3F0E
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 05:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327750; cv=none; b=MfBEsxdk+UqKcER8AO+oE/AlSShS2bReSTbVXs0duKeKijpJWeNkRzXdPkes3o15ubYKFgtIosM410q/zdSFgxF7epOEe6UnK1kxkSwU99VEAQwbv4H63TrgnL0uS+8AzLWWMeR0huBiwhKKu7xTtAM9g5Jhe/qz78b2JbdROo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327750; c=relaxed/simple;
	bh=l7OjQzCOg5kgdobHrnsRAGOkUS++LtnROveC906jg94=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rxOXz/tVRid+JXzp9ZQUqiQRJdXeLD/FpMOt/sOu1qVg3ZVbVfZhhvUZfxbEwxE0y+ilE6Hjz5HbMhYCUyRTcreiMeHNBCJumQjWL/J6obr49LQIp1HOqhUOILdchAbPNUPqcn9ZZrWUsRnXj/HJ89Gp5GVe9JsJQm9CRRoT/go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BI9gAvLO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86EA4C4CED7
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 05:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734327750;
	bh=l7OjQzCOg5kgdobHrnsRAGOkUS++LtnROveC906jg94=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BI9gAvLOJM4AoiLDB/U5/H2BhAGNuF664yBGqw6SAY1OmkLHTGm94d8ZpqZRrrs5j
	 vk4kRA61iHKnNbt+DrKpCjgJLY6jFK6YSiEWN9wi+Q7NkXHVdPA/SVxd4GF8r8aZwy
	 pNpWFo79VHDyqUs8cHUeLhFLz+T2zbahvw1+5+0Ib29fkZ0j0UfuAprfR9CS+8qVCT
	 +yJ7rxB7sm4xZwNJlFVt5G7cNEOM7lxEDQfqjDKpNJp0lZtSK14ZKbBjYaRPo74VwG
	 TkFhpnR7tVhEATlSdNxqqOUzjDgrET2z30OhhaZwd+dEj6otl5IEh3cFdAo38E6Ubk
	 i1jjfpuMB8r8g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 74A77C41613; Mon, 16 Dec 2024 05:42:30 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219588] [6.13.0-rc2+]WARNING: CPU: 52 PID: 12253 at
 arch/x86/kvm/mmu/tdp_mmu.c:1001 tdp_mmu_map_handle_target_level+0x1f0/0x310
 [kvm]
Date: Mon, 16 Dec 2024 05:42:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: leiyang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219588-28872-3UuJWx01n1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219588-28872@https.bugzilla.kernel.org/>
References: <bug-219588-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219588

--- Comment #2 from leiyang@redhat.com ---
(In reply to Sean Christopherson from comment #1)
> On Wed, Dec 11, 2024, bugzilla-daemon@kernel.org wrote:
> > I hit a bug on the intel host, this problem occurs randomly:
> > [  406.127925] ------------[ cut here ]------------
> > [  406.132572] WARNING: CPU: 52 PID: 12253 at
> arch/x86/kvm/mmu/tdp_mmu.c:1001
> > tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]
>=20
> Can you describe the host activity at the time of the WARN?  E.g. is it u=
nder
> memory pressure and potentially swapping, is KSM or NUMA balancing active=
? I
> have a sound theory for how the scenario occurs on KVM's end, but I still
> think
> it's wrong for KVM to overwrite a writable SPTE with a read-only SPTE in =
this
> situation.

I spent some time for this problem so late reply. When host dmesg print this
error messages which running install a new guest via automation. And I found
this bug's reproducer is run this install case after the mchine first time
running(Let me introduce more to avoid ambiguity=EF=BC=9A 1. Must to test i=
t when the
machine first time running this kernel,that mean's if I hit this problem th=
en
reboot host, it can not reproduced again even if I run the same tests.  2.
Based on 1, I also must test this installation guest case, it can not
reporduced on other cases.). But through compare, this installation cases o=
nly
used pxe install based on a internal KS cfg is different other cases.

Sure, I think it's running under memory pressure and swapping. Based on
automation log, KSM is disable and I don't add NUMA in qemu command line.=20

If you have a machine can clone avocado and run tp-qemu tests, you can prep=
are
env then run this case:
unattended_install.cdrom.extra_cdrom_ks.default_install.aio_threads

>=20
> And does the VM have device memory or any other type of VM_PFNMAP or VM_IO
> memory exposed to it?  E.g. an assigned device?  If so, can you provide t=
he
> register
> state from the other WARNs?  If the PFNs are all in the same range, then
> maybe
> this is something funky with the VM_PFNMAP | VM_IO path.

I can confirm it has VM_IO because it runing installation case, VM is
constantly performing I/O operations

This my tests used memory and CPU configured, hope it help you debug this
problem:
-m 29G \
-smp 48,maxcpus=3D48,cores=3D24,threads=3D1,dies=3D1,sockets=3D2  \

And looks like there are no other device  and no using VM_PFNMAP. Please
correct me if I'm wrong.

>=20
> The WARN is a sanity check I added because it should be impossible for KV=
M to
> install a non-writable SPTE overtop an existing writable SPTE.  Or so I
> thought.
> The WARN is benign in the sense that nothing bad will happen _in KVM_; KVM
> correctly handles the unexpected change, the WARN is there purely to flag
> that
> something unexpected happen.
>=20
>       if (new_spte =3D=3D iter->old_spte)
>               ret =3D RET_PF_SPURIOUS;
>       else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
>               return RET_PF_RETRY;
>       else if (is_shadow_present_pte(iter->old_spte) &&
>                (!is_last_spte(iter->old_spte, iter->level) ||
>                 WARN_ON_ONCE(leaf_spte_change_needs_tlb_flush(iter->old_s=
pte,
> new_spte)))) <=3D=3D=3D=3D
>               kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level=
);
>=20
> Cross referencing the register state
>=20
>   RAX: 860000025e000bf7 RBX: ff4af92c619cf920 RCX: 0400000000000000
>   RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000015
>   RBP: ff4af92c619cf9e8 R08: 800000025e0009f5 R09: 0000000000000002
>   R10: 000000005e000901 R11: 0000000000000001 R12: ff1e70694fc68000
>   R13: 0000000000000005 R14: 0000000000000000 R15: ff4af92c619a1000
>=20
> with the disassembly
>=20
>   4885C8                          TEST RAX,RCX
>   0F84EEFEFFFF                    JE 0000000000000-F1
>   4985C8                          TEST R8,RCX
>   0F85E5FEFFFF                    JNE 0000000000000-F1
>   0F0B                            UD2
>=20=20=20
> RAX is the old SPTE and RCX is the new SPTE, i.e. the SPTE change is:
>=20
>   860000025e000bf7
>   800000025e0009f5
>=20
> On Intel, bits 57 and 58 are the host-writable and MMU-writable flags
>=20
>   #define EPT_SPTE_HOST_WRITABLE      BIT_ULL(57)
>   #define EPT_SPTE_MMU_WRITABLE               BIT_ULL(58)
>=20
> which means KVM is overwriting a writable SPTE with a non-writable SPTE
> because
> the current vCPU (a) hit a READ or EXEC fault on a non-present SPTE and (=
b)
> retrieved
> a non-writable PFN from the primary MMU, and that fault raced with a WRITE
> fault
> on a different vCPU that retrieved and installed a writable PFN.
>=20
> On a READ or EXEC fault, this code in hva_to_pfn_slow() should get a
> writable PFN.
> Given that KVM has an valid writable SPTE, the corresponding PTE in the
> primary MMU
> *must* be writable, otherwise there's a missing mmu_notifier invalidation.
>=20
>       /* map read fault as writable if possible */
>       if (!(flags & FOLL_WRITE) && kfp->map_writable &&
>           get_user_page_fast_only(kfp->hva, FOLL_WRITE, &wpage)) {
>               put_page(page);
>               page =3D wpage;
>               flags |=3D FOLL_WRITE;
>       }
>=20
> out:
>       *pfn =3D kvm_resolve_pfn(kfp, page, NULL, flags & FOLL_WRITE);
>       return npages;
>=20
> Hmm, gup_fast_folio_allowed() has a few conditions where it will reject f=
ast
> GUP,
> but they should be mutually exclusive with KVM having a writable SPTE.  If
> the
> mapping is truncated or the folio is swapped out, secondary MMUs need to =
be
> invalidated before folio->mapping is nullified.
>=20
>       /*
>        * The mapping may have been truncated, in any case we cannot deter=
mine
>        * if this mapping is safe - fall back to slow path to determine ho=
w to
>        * proceed.
>        */
>       if (!mapping)
>               return false;
>=20
> And secretmem can't be GUP'd, and it's not a long-term pin, so these chec=
ks
> don't
> apply either:
>=20
>       if (check_secretmem && secretmem_mapping(mapping))
>               return false;
>       /* The only remaining allowed file system is shmem. */
>       return !reject_file_backed || shmem_mapping(mapping);
>=20
> Similarly, hva_to_pfn_remapped() should get a writable PFN if said PFN is
> writable
> in the primary MMU, regardless of the fault type.
>=20
> If this turns out to get a legitimate scenario, then I think it makes sen=
se
> to
> add an is_access_allowed() check and treat the fault as spurious.  But I
> would
> like to try to bottom out on what exactly is happening, because I'm mildly
> concerned something is buggy in the primary MMU.

If you need me to provide more info, please feel free to let me know. And if
you  sent a patch to fix this problem I can help to verified it, since I th=
ink
I found the stable reproducer.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

