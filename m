Return-Path: <kvm+bounces-45100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77740AA602B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3857E9A3B6A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 14:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167C51F1513;
	Thu,  1 May 2025 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHpvrZUg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFAD33F7
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 14:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746110528; cv=none; b=U3P9AvO3lYSpMQc84zChet93Ywcryl2mF/how1mG96PZRE1LQWG90FardyP9+tSt+++34CrgO0STY09eukbYVGKMYBQ+F7TVGK1i2by50YKDoO9lgDjRT6/On35mPw3gMj1RNCAEZTgKFy1g380CjyG3deOzT+FVC2KOUx1cWzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746110528; c=relaxed/simple;
	bh=CKKVWAVOpdkXV9xBdNek9Smi17tNvKo45omjuBNSNxo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t4vEUww+VD0DSaqv+XI0qpeITlFeOAAGcMhvJXYGiQ+GJ2OiQXxz8QN84T68gMg7YjyMBxExr8WIzMGqw0iBo7XC2vzoS+gON3nwLA35u5ctqNZwbXm+oJ/weyFwWNyROmZzoPFNmPyvXt0/KkLwVmMZVrN3VFV6sQZMJktXaQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHpvrZUg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC5BFC4CEED
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746110527;
	bh=CKKVWAVOpdkXV9xBdNek9Smi17tNvKo45omjuBNSNxo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FHpvrZUgTdeHmSedjQ5SFnw68sc/wnERdDRtMW+4y/rpt3N9Rvll4RhMEpHGgF8kn
	 rX1EfH9GoknjqbJshmOvLSSi+EbTnMdlaN60qE5wrTtk2OxNns3j4tbeGyE72wIl2s
	 /1sPWS5uEE+6QkrvGwPXgT8dET0lfGEup+xXOfWNsn7VTivUdH5xQ8L2QktavqmqcF
	 pv6DG3QVrPWbPE0aZ9CmNFRF5CVMp9VgJ0HvE+dy4/Ze3re7KBhPz1n4y01fehCjch
	 55HKQnFqhyHzL+t6rCd5ZpSdmycIU3NAgoRpe+kezsoqejwwuPQkf6TVBiCGL9gfiP
	 ctCgT/9MHmX8Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A6076C3279F; Thu,  1 May 2025 14:42:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Thu, 01 May 2025 14:42:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-SKb2todkZo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #40 from Alex Williamson (alex.williamson@redhat.com) ---
The vfio_pci_mmap_huge_fault logs with order >0 and ending in 0x800 are nor=
mal,
they're indicating we can't create the huge page mapping due to alignment
requirements, 0x800 is VM_FAULT_FALLBACK (ie. fallback to a smaller mapping=
).

However, there are three instances of:

May 01 10:01:37 pve QEMU[1972]: error: kvm run failed Bad address
May 01 10:01:37 pve QEMU[1972]: error: kvm run failed Bad address
May 01 10:01:37 pve QEMU[1972]: error: kvm run failed Bad address

And three instances of:

May 01 10:01:37 pve kernel: vfio-pci 0000:01:00.0:
vfio_pci_mmap_huge_fault(,order =3D 0) BAR 1 page offset 0x3798: 0x1
May 01 10:01:37 pve kernel: vfio-pci 0000:01:00.0:
vfio_pci_mmap_huge_fault(,order =3D 0) BAR 1 page offset 0x3710: 0x1
May 01 10:01:37 pve kernel: vfio-pci 0000:01:00.0:
vfio_pci_mmap_huge_fault(,order =3D 0) BAR 1 page offset 0x3688: 0x1

0x1 is VM_FAULT_OOM, so likely at some point in trying to insert the pte, we
got an -ENOMEM.

The system has 128GB of RAM, 98GB of which is dedicated to 1G hugepages.  T=
his
VM is configured for 32GB.  What happens if fewer hugepages are reserved?

Also note that if we were able to populate the MMIO mappings using huge pag=
es,
which would occur if the VM BIOS had placed the mappings within the DMA
mappable range of the IOMMU (ie. the VFIO_MAP_DMA failures), we'd be using
fewer page table entries than even the previous code (ie. less memory).  The
issue might simply come down to the fact that previously we attempted to fa=
ult
in the entire MMIO mapping on the first fault, at that time memory was
available, but now we fault on access with the expectation that we're fault=
ing
less due to huge pages, but the latter is not coming to fruition due to the=
 bad
VM configuration.

I think we're going to need to figure out if/how Proxmox enables setting
guest-phys-bits=3D39 or the host needs to free up some memory from hugepage=
s.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

