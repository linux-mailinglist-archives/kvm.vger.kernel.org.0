Return-Path: <kvm+bounces-34329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F399FAB35
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 08:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFFE5160DB0
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 07:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1C618F2EA;
	Mon, 23 Dec 2024 07:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="FsKqc4ev"
X-Original-To: kvm@vger.kernel.org
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9AF185B4C;
	Mon, 23 Dec 2024 07:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734939473; cv=none; b=hUcO+5aPPOMz2+fDXi4o2kgiYovJ/OXalIl0re4q/0jo5zEk0MfF/dGNo4tjAb4S1ZBkL9z6vzRY1GIOZ+8pau03zLspeCu/Hdoo2IJ0JUQIYqFCKRx6nuGmtw1DwfOwSwLigiizcRBZA8lespWdQ+/6GZAMQzvC3q7oJYsY/24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734939473; c=relaxed/simple;
	bh=P/4242QLq3nVMegiA2aERKECD/KhF7C8dCgei73v83g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2rX691v4iABj+reD+Fx5Dp1RxTWYjLQZ+hVvbHKG4wMkqo2JyxgGC83/vbhqox/ZTiXH9DkB+phzj/ZEsddjfblIqF58vDyyDnWH3o75iEIojvRG+3lopa2tnPx4PD6tWpP7vx2qQX6vBLOqsq3MD3B6VSmEIBxGQf0ke+qviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=FsKqc4ev; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1734939469; x=1735198669;
	bh=MdDjYfT+KDtz3lpfNwxg/Y9kIsJlKMLPKSqWl9jRiEY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=FsKqc4evvDR157Lswcqd1GU5mNtXiqDCfpVTSelzK4QhkwZCMRdE+KmwU8P0jTz/n
	 VtFYGkYeTKgx+qQ4DXG1MWtCkBHBYSrphKNIIZuEvsyURdIXuLXG0pRLyuYxGKQD7l
	 dMQuTrHpH5ksdOm95NHru0E1gsLjyFc423T0+1S+byrWwVm5oMch8+vDyJkLI5S7iH
	 9gZqYTslfDViBlHf9HYk4wUwRj+7+A06clhkq8JldMNwZJEU8wJjVYewMI2no/ZokZ
	 V4baTO5UxvfM/6D//xM+JezzFWYw/3IRFSnznxNEbLpI2SMuwJdIw75h9j0+f7KCdY
	 oq5mGTZEZfbjQ==
Date: Mon, 23 Dec 2024 07:37:46 +0000
To: Bjorn Helgaas <helgaas@kernel.org>
From: Athul Krishna <athul.krishna.kr@protonmail.com>
Cc: "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>, "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [bugzilla-daemon@kernel.org: [Bug 219619] New: vfio-pci: screen graphics artifacts after 6.12 kernel upgrade]
Message-ID: <Hb6kvXlGizYbogNWGJcvhY3LsKeRwROtpRluHKsGqRcmZl68J35nP60YdzW1KSoPl5RO_dCxuL5x9mM13jPBbU414DEZE_0rUwDNvzuzyb8=@protonmail.com>
In-Reply-To: <20241222223604.GA3735586@bhelgaas>
References: <20241222223604.GA3735586@bhelgaas>
Feedback-ID: 97021173:user:proton
X-Pm-Message-ID: 95968d894a95988886d3bb7e373efb2a8c6469ac
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Can confirm. Reverting f9e54c3a2f5b from v6.13-rc1 fixed the problem.

-------- Original Message --------
On 23/12/24 04:06, Bjorn Helgaas <helgaas@kernel.org> wrote:

>  Forwarding since not everybody follows bugzilla.  Apparently bisected
>  to f9e54c3a2f5b ("vfio/pci: implement huge_fault support").
> =20
>  Athul, f9e54c3a2f5b appears to revert cleanly from v6.13-rc1.  Can you
>  verify that reverting it is enough to avoid these artifacts?
> =20
>  #regzbot introduced: f9e54c3a2f5b ("vfio/pci: implement huge_fault suppo=
rt")
> =20
>  ----- Forwarded message from bugzilla-daemon@kernel.org -----
> =20
>  Date: Sat, 21 Dec 2024 10:10:02 +0000
>  From: bugzilla-daemon@kernel.org
>  To: bjorn@helgaf9e54c3a2f5bas.com
>  Subject: [Bug 219619] New: vfio-pci: screen graphics artifacts after 6.1=
2 kernel upgrade
>  Message-ID: <bug-219619-41252@https.bugzilla.kernel.org/>
> =20
>  https://bugzilla.kernel.org/show_bug.cgi?id=3D219619
> =20
>              Bug ID: 219619
>             Summary: vfio-pci: screen graphics artifacts after 6.12 kerne=
l
>                      upgrade
>             Product: Drivers
>             Version: 2.5
>            Hardware: AMD
>                  OS: Linux
>              Status: NEW
>            Severity: normal
>            Priority: P3
>           Component: PCI
>            Assignee: drivers_pci@kernel-bugs.osdl.org
>            Reporter: athul.krishna.kr@protonmail.com
>          Regression: No
> =20
>  Created attachment 307382
>    --> https://bugzilla.kernel.org/attachment.cgi?id=3D307382&action=3Ded=
it
>  dmesg
> =20
>  Device: Asus Zephyrus GA402RJ
>  CPU: Ryzen 7 6800HS
>  GPU: RX 6700S
>  Kernel: 6.13.0-rc3-g8faabc041a00
> =20
>  Problem:
>  Launching games or gpu bench-marking tools in qemu windows 11 vm will ca=
use
>  screen artifacts, ultimately qemu will pause with unrecoverable error.
> =20
>  Commit:
>  f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101 is the first bad commit
>  commit f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101
>  Author: Alex Williamson <alex.williamson@redhat.com>
>  Date:   Mon Aug 26 16:43:53 2024 -0400
> =20
>      vfio/pci: implement huge_fault support
> =20
>      With the addition of pfnmap support in vmf_insert_pfn_{pmd,pud}() we=
 can
>      take advantage of PMD and PUD faults to PCI BAR mmaps and create mor=
e
>      efficient mappings.  PCI BARs are always a power of two and will typ=
ically
>      get at least PMD alignment without userspace even trying.  Userspace
>      alignment for PUD mappings is also not too difficult.
> =20
>      Consolidate faults through a single handler with a new wrapper for
>      standard single page faults.  The pre-faulting behavior of commit
>      d71a989cf5d9 ("vfio/pci: Insert full vma on mmap'd MMIO fault") is r=
emoved
>      in this refactoring since huge_fault will cover the bulk of the faul=
ts and
>      results in more efficient page table usage.  We also want to avoid t=
hat
>      pre-faulted single page mappings preempt huge page mappings.
> =20
>      Link: https://lkml.kernel.org/r/20240826204353.2228736-20-peterx@red=
hat.com
>      Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>      Signed-off-by: Peter Xu <peterx@redhat.com>
>      Cc: Alexander Gordeev <agordeev@linux.ibm.com>
>      Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>      Cc: Borislav Petkov <bp@alien8.de>
>      Cc: Catalin Marinas <catalin.marinas@arm.com>
>      Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
>      Cc: Dave Hansen <dave.hansen@linux.intel.com>
>      Cc: David Hildenbrand <david@redhat.com>
>      Cc: Gavin Shan <gshan@redhat.com>
>      Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>      Cc: Heiko Carstens <hca@linux.ibm.com>
>      Cc: Ingo Molnar <mingo@redhat.com>
>      Cc: Jason Gunthorpe <jgg@nvidia.com>
>      Cc: Matthew Wilcox <willy@infradead.org>
>      Cc: Niklas Schnelle <schnelle@linux.ibm.com>
>      Cc: Paolo Bonzini <pbonzini@redhat.com>
>      Cc: Ryan Roberts <ryan.roberts@arm.com>
>      Cc: Sean Christopherson <seanjc@google.com>
>      Cc: Sven Schnelle <svens@linux.ibm.com>
>      Cc: Thomas Gleixner <tglx@linutronix.de>
>      Cc: Vasily Gorbik <gor@linux.ibm.com>
>      Cc: Will Deacon <will@kernel.org>
>      Cc: Zi Yan <ziy@nvidia.com>
>      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> =20
>   drivers/vfio/pci/vfio_pci_core.c | 60 ++++++++++++++++++++++++++++-----=
-------
>   1 file changed, 43 insertions(+), 17 deletions(-)
> =20
>  --
>  You may reply to this email to add a comment.
> =20
>  You are receiving this mail because:
>  You are watching the assignee of the bug.
> =20
>  ----- End forwarded message -----
>  

