Return-Path: <kvm+bounces-33487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48AA39ED0F1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 17:12:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE90928F265
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 16:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137C61DD526;
	Wed, 11 Dec 2024 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eWP8K67v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1FF1DB933
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733933535; cv=none; b=nnNw17dC4U4gowbrk02BAZ97UWcVOO+90Gar/Jc40BfBHUt1U8HHmHsbsMhakR/wjzt8dfhS3upecikLQd1591gxD972/uTj5WMdzwnOlQ9gN9fQvc7gSz5GhXmaRGa2qkLuIRYQRVeRnl6GuMsNH1HDebnNPwiIEf0RUtisN/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733933535; c=relaxed/simple;
	bh=qKP/+FCxwB6yUfzOD256SYaGwM3RdiDXqzgfHFBwVDw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dRTQ8fDXFnKF+I3tD5YYU2oj+rJFAcTH6bHAhlb+sK5Homd/mIym6ly5magwJ4f8pESXBTVDGWjqi2i9tay3Hq0pmpkEgGf20GQTlx7k7yvljd31ILMviWux4V56Uq4oDVHVl3N9wgTSEtquC78/+vzrVCMXL29208ikGVg88OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eWP8K67v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFB4FC4CEDD
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 16:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733933534;
	bh=qKP/+FCxwB6yUfzOD256SYaGwM3RdiDXqzgfHFBwVDw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eWP8K67vukFFJ29sHZZbo7qKbcx8RCZKKuCgMLOLcWcb0v5Ft3+A0cW0Jwh+LWyTY
	 dVS3ko1DGYO3X3zk615KX8WvMlpdZVOO5PUMuTHQ8VSow2H5SU3tIhBzwapJlEzP7T
	 9sZuhui+MQpXZ2mirTygRIQpxsNkeCEcHsbzHV6BNs8D/XfpJHX1jGy4X9fK2cQMF+
	 B7opDlreMZhm6C/P8DxPHh3l9cnpG6vVM4tf2lM/ilL5ZvU2S45dDAVxWb3yGCj8Sf
	 9A0xF21x6SlRb7i9KJuImw0YUyZSKtoW6Tylivw5KkcbsKWnuBxY/35NP1fbfQIGHV
	 F84K2E/Zn9SPA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B1507C41615; Wed, 11 Dec 2024 16:12:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219588] [6.13.0-rc2+]WARNING: CPU: 52 PID: 12253 at
 arch/x86/kvm/mmu/tdp_mmu.c:1001 tdp_mmu_map_handle_target_level+0x1f0/0x310
 [kvm]
Date: Wed, 11 Dec 2024 16:12:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219588-28872-nV9i5FgZJ2@https.bugzilla.kernel.org/>
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

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Wed, Dec 11, 2024, bugzilla-daemon@kernel.org wrote:
> I hit a bug on the intel host, this problem occurs randomly:
> [  406.127925] ------------[ cut here ]------------
> [  406.132572] WARNING: CPU: 52 PID: 12253 at arch/x86/kvm/mmu/tdp_mmu.c:=
1001
> tdp_mmu_map_handle_target_level+0x1f0/0x310 [kvm]

Can you describe the host activity at the time of the WARN?  E.g. is it und=
er
memory pressure and potentially swapping, is KSM or NUMA balancing active? I
have a sound theory for how the scenario occurs on KVM's end, but I still t=
hink
it's wrong for KVM to overwrite a writable SPTE with a read-only SPTE in th=
is
situation.

And does the VM have device memory or any other type of VM_PFNMAP or VM_IO
memory exposed to it?  E.g. an assigned device?  If so, can you provide the
register
state from the other WARNs?  If the PFNs are all in the same range, then ma=
ybe
this is something funky with the VM_PFNMAP | VM_IO path.

The WARN is a sanity check I added because it should be impossible for KVM =
to
install a non-writable SPTE overtop an existing writable SPTE.  Or so I
thought.
The WARN is benign in the sense that nothing bad will happen _in KVM_; KVM
correctly handles the unexpected change, the WARN is there purely to flag t=
hat
something unexpected happen.

        if (new_spte =3D=3D iter->old_spte)
                ret =3D RET_PF_SPURIOUS;
        else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
                return RET_PF_RETRY;
        else if (is_shadow_present_pte(iter->old_spte) &&
                 (!is_last_spte(iter->old_spte, iter->level) ||
                  WARN_ON_ONCE(leaf_spte_change_needs_tlb_flush(iter->old_s=
pte,
new_spte)))) <=3D=3D=3D=3D
                kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level=
);

Cross referencing the register state

  RAX: 860000025e000bf7 RBX: ff4af92c619cf920 RCX: 0400000000000000
  RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000015
  RBP: ff4af92c619cf9e8 R08: 800000025e0009f5 R09: 0000000000000002
  R10: 000000005e000901 R11: 0000000000000001 R12: ff1e70694fc68000
  R13: 0000000000000005 R14: 0000000000000000 R15: ff4af92c619a1000

with the disassembly

  4885C8                          TEST RAX,RCX
  0F84EEFEFFFF                    JE 0000000000000-F1
  4985C8                          TEST R8,RCX
  0F85E5FEFFFF                    JNE 0000000000000-F1
  0F0B                            UD2

RAX is the old SPTE and RCX is the new SPTE, i.e. the SPTE change is:

  860000025e000bf7
  800000025e0009f5

On Intel, bits 57 and 58 are the host-writable and MMU-writable flags

  #define EPT_SPTE_HOST_WRITABLE        BIT_ULL(57)
  #define EPT_SPTE_MMU_WRITABLE         BIT_ULL(58)

which means KVM is overwriting a writable SPTE with a non-writable SPTE bec=
ause
the current vCPU (a) hit a READ or EXEC fault on a non-present SPTE and (b)
retrieved
a non-writable PFN from the primary MMU, and that fault raced with a WRITE
fault
on a different vCPU that retrieved and installed a writable PFN.

On a READ or EXEC fault, this code in hva_to_pfn_slow() should get a writab=
le
PFN.
Given that KVM has an valid writable SPTE, the corresponding PTE in the pri=
mary
MMU
*must* be writable, otherwise there's a missing mmu_notifier invalidation.

        /* map read fault as writable if possible */
        if (!(flags & FOLL_WRITE) && kfp->map_writable &&
            get_user_page_fast_only(kfp->hva, FOLL_WRITE, &wpage)) {
                put_page(page);
                page =3D wpage;
                flags |=3D FOLL_WRITE;
        }

out:
        *pfn =3D kvm_resolve_pfn(kfp, page, NULL, flags & FOLL_WRITE);
        return npages;

Hmm, gup_fast_folio_allowed() has a few conditions where it will reject fast
GUP,
but they should be mutually exclusive with KVM having a writable SPTE.  If =
the
mapping is truncated or the folio is swapped out, secondary MMUs need to be
invalidated before folio->mapping is nullified.

        /*
         * The mapping may have been truncated, in any case we cannot deter=
mine
         * if this mapping is safe - fall back to slow path to determine ho=
w to
         * proceed.
         */
        if (!mapping)
                return false;

And secretmem can't be GUP'd, and it's not a long-term pin, so these checks
don't
apply either:

        if (check_secretmem && secretmem_mapping(mapping))
                return false;
        /* The only remaining allowed file system is shmem. */
        return !reject_file_backed || shmem_mapping(mapping);

Similarly, hva_to_pfn_remapped() should get a writable PFN if said PFN is
writable
in the primary MMU, regardless of the fault type.

If this turns out to get a legitimate scenario, then I think it makes sense=
 to
add an is_access_allowed() check and treat the fault as spurious.  But I wo=
uld
like to try to bottom out on what exactly is happening, because I'm mildly
concerned something is buggy in the primary MMU.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

