Return-Path: <kvm+bounces-29149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF6109A37B9
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 09:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D4761C259A1
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E1318CC15;
	Fri, 18 Oct 2024 07:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="bacZkfUE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bZ8f1Rbi"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC1A18CBE6;
	Fri, 18 Oct 2024 07:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729238076; cv=none; b=XQ9VNbdv5nkFpJTLVz5h39iHX203hsc1gzXo7zO/+5E7/xjiQe+oWfoj/LnFce3lJYTCJl9TcfzxFUfmTjFxnX+YuiP3d+TpXTGhn44SqWCYNpBuB+iyZYsXkdWHFDnkN8NDroQTzsHkjMhgAOzsUs9LHKLVAc+KRgkihItvfOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729238076; c=relaxed/simple;
	bh=X8haYsb381neW+dETbhktpqU3lK2inRGLWQPz8R0D4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gDghC8YwKO/34H3aSLkBY9ZDNEHyQ6vVQRcvsr4B8SuQjL+dwePsvjLogs1udhFjRsUGZ+SfZ+xJqYnBlxp88DqDRNsbMMPYOyCWz8hYLKDYQNOKRzp16s1GZ4Ir2x7covHuODOGT6FMMvLzt1l2NT/yPDsi4WHyiUjI//JZbn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=bacZkfUE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bZ8f1Rbi; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 008361140215;
	Fri, 18 Oct 2024 03:54:33 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Fri, 18 Oct 2024 03:54:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1729238072; x=
	1729324472; bh=u3sl/1PSnM1FXF1JtFpDhiIVcuz0H5aAevpo8M62y+o=; b=b
	acZkfUESHOkaEH95Kb7E0jPX2oI01YdsE9t0+ZzxzzVcRhdx15ViFRaDh2qBxx8I
	fTMTdvOAK/b1x71ljVoR24R+xvMy0TBgZAtgsfznZ5tmm5OqElFGPRbndfW6rsGm
	WBjw0yVlzcVMwfb2rHd7ai1sq23lzqcUH5ENur+E+XMetcWL3cqsJh+ya/knSGNW
	duDpOd5N6ctIKQzBrzCZWs9X1hAVATPCHeV2m2DJwXPUjdzsNzwSHivUwy1TQzuN
	OUXkDAEx844sgphrJpr9+SsbIbLgvYkCbifpLeV4EU/yfrEKjDsiTyqQjobVcfyd
	FEe7TC9330pP3leiz4cuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1729238072; x=1729324472; bh=u3sl/1PSnM1FXF1JtFpDhiIVcuz0
	H5aAevpo8M62y+o=; b=bZ8f1Rbi5jkgG6AyOWA7eO6wMvuteXAArTJBMC/G1nLf
	shHMG7U4mqcFnRwjMcNbC8AlYty1CfsNxOcVReYy08nqXMVi+d20puL6f9wFdQ6r
	NbqMqIS6okHeiv/+6kNIBoUpdOUHkHiWyfY1GEpQP5JJ2MvxiUesExLueuydaWTH
	avn2Mw4FsDK1g8pQT9SlsmIWr+uBg8HXPSKZH7iEWMlsByYRgcOjIq/fCcaeUijA
	DISWjDKHbRjRNSkzCSIjzfeIVmJjnYQ9WtIHj7+LRYR6jx3MbIkKjBgSFTWIDQUq
	1GPV41XvzuqaBAlW18DExHHQe7OynT/l2SN90lygiA==
X-ME-Sender: <xms:OBQSZ1ICxP0tAZFaRJoIgnxiMqYhTGlya_unY5NXPQV-9zDbzAKq-w>
    <xme:OBQSZxLFGK4Yl9-t_N4Owgjy8LDjCYtYp1skZJiNLKvJUMCXvElCc9l7YL90q8C-s
    B4e6bKvFw8kaRjr__I>
X-ME-Received: <xmr:OBQSZ9tskqFEwAPXB2spEnV-a15HKRb3SHKi2N5QECsiU5_mqNgkGdN64KVmifJ82xeDkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehvddguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdfstddttddv
    necuhfhrohhmpedfmfhirhhilhhlucetrdcuufhhuhhtvghmohhvfdcuoehkihhrihhllh
    esshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrfgrthhtvghrnhepleetudegtdfghedu
    udfhteelieeuvddtheeijeejudefjeefgeettedutdeggfdunecuffhomhgrihhnpehkvg
    hrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtoh
    epudekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehnvggvrhgrjhdruhhprggu
    hhihrgihsegrmhgurdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhi
    gidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpdhrtghpthhtoh
    epuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthho
    pehthhhomhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepnhhikh
    hunhhjsegrmhgurdgtohhmpdhrtghpthhtohepshgrnhhtohhshhdrshhhuhhklhgrsegr
    mhgurdgtohhmpdhrtghpthhtohepvhgrshgrnhhtrdhhvghguggvsegrmhgurdgtohhm
X-ME-Proxy: <xmx:OBQSZ2aH7OElaZOw_Lsf04fZZWI4icLv32MEBcDf3x6YCII9hwO8-Q>
    <xmx:OBQSZ8YOpzXCyIibgQi02yGr9IpJol_i55ENYACo6x7gA9kCotlWqg>
    <xmx:OBQSZ6DK1cK53_dVxciIjYwRpdWCeejle6sBS-jrNjstHGdWKrZgVg>
    <xmx:OBQSZ6aXMAf3pWLKIWih1sFHTcKSHu5Fo3bPUC7UpVVyxAGj5EuTig>
    <xmx:OBQSZ5SO6YCoLqpWYY5n9EJqv1_FivC85uvxF6FhtxjOnDHJmdlhkWoo>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Oct 2024 03:54:26 -0400 (EDT)
Date: Fri, 18 Oct 2024 10:54:21 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com, 
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de, 
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org, 
	seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
Message-ID: <ramttkbttoyswpl7fkz25jwsxs4iuoqdogfllp57ltigmgb3vd@txz4azom56ej>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
 <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>

On Fri, Oct 18, 2024 at 08:03:20AM +0530, Neeraj Upadhyay wrote:
> Hi Kirill,
> 
> On 10/17/2024 1:53 PM, Kirill A. Shutemov wrote:
> > On Fri, Sep 13, 2024 at 05:06:51PM +0530, Neeraj Upadhyay wrote:
> >> Introduction
> >> ------------
> >>
> >> Secure AVIC is a new hardware feature in the AMD64 architecture to
> >> allow SEV-SNP guests to prevent hypervisor from generating unexpected
> >> interrupts to a vCPU or otherwise violate architectural assumptions
> >> around APIC behavior.
> >>
> >> One of the significant differences from AVIC or emulated x2APIC is that
> >> Secure AVIC uses a guest-owned and managed APIC backing page. It also
> >> introduces additional fields in both the VMCB and the Secure AVIC backing
> >> page to aid the guest in limiting which interrupt vectors can be injected
> >> into the guest.
> >>
> >> Guest APIC Backing Page
> >> -----------------------
> >> Each vCPU has a guest-allocated APIC backing page of size 4K, which
> >> maintains APIC state for that vCPU. The x2APIC MSRs are mapped at
> >> their corresposing x2APIC MMIO offset within the guest APIC backing
> >> page. All x2APIC accesses by guest or Secure AVIC hardware operate
> >> on this backing page. The backing page should be pinned and NPT entry
> >> for it should be always mapped while the corresponding vCPU is running.
> >>
> >>
> >> MSR Accesses
> >> ------------
> >> Secure AVIC only supports x2APIC MSR accesses. xAPIC MMIO offset based
> >> accesses are not supported.
> >>
> >> Some of the MSR accesses such as ICR writes (with shorthand equal to
> >> self), SELF_IPI, EOI, TPR writes are accelerated by Secure AVIC
> >> hardware. Other MSR accesses generate a #VC exception. The #VC
> >> exception handler reads/writes to the guest APIC backing page.
> >> As guest APIC backing page is accessible to the guest, the Secure
> >> AVIC driver code optimizes APIC register access by directly
> >> reading/writing to the guest APIC backing page (instead of taking
> >> the #VC exception route).
> >>
> >> In addition to the architected MSRs, following new fields are added to
> >> the guest APIC backing page which can be modified directly by the
> >> guest:
> >>
> >> a. ALLOWED_IRR
> >>
> >> ALLOWED_IRR vector indicates the interrupt vectors which the guest
> >> allows the hypervisor to send. The combination of host-controlled
> >> REQUESTED_IRR vectors (part of VMCB) and ALLOWED_IRR is used by
> >> hardware to update the IRR vectors of the Guest APIC backing page.
> >>
> >> #Offset        #bits        Description
> >> 204h           31:0         Guest allowed vectors 0-31
> >> 214h           31:0         Guest allowed vectors 32-63
> >> ...
> >> 274h           31:0         Guest allowed vectors 224-255
> >>
> >> ALLOWED_IRR is meant to be used specifically for vectors that the
> >> hypervisor is allowed to inject, such as device interrupts.  Interrupt
> >> vectors used exclusively by the guest itself (like IPI vectors) should
> >> not be allowed to be injected into the guest for security reasons.
> >>
> >> b. NMI Request
> >>  
> >> #Offset        #bits        Description
> >> 278h           0            Set by Guest to request Virtual NMI
> >>
> >>
> >> LAPIC Timer Support
> >> -------------------
> >> LAPIC timer is emulated by hypervisor. So, APIC_LVTT, APIC_TMICT and
> >> APIC_TDCR, APIC_TMCCT APIC registers are not read/written to the guest
> >> APIC backing page and are communicated to the hypervisor using SVM_EXIT_MSR
> >> VMGEXIT. 
> >>
> >> IPI Support
> >> -----------
> >> Only SELF_IPI is accelerated by Secure AVIC hardware. Other IPIs require
> >> writing (from the Secure AVIC driver) to the IRR vector of the target CPU
> >> backing page and then issuing VMGEXIT for the hypervisor to notify the
> >> target vCPU.
> >>
> >> Driver Implementation Open Points
> >> ---------------------------------
> >>
> >> The Secure AVIC driver only supports physical destination mode. If
> >> logical destination mode need to be supported, then a separate x2apic
> >> driver would be required for supporting logical destination mode.
> >>
> >> Setting of ALLOWED_IRR vectors is done from vector.c for IOAPIC and MSI
> >> interrupts. ALLOWED_IRR vector is not cleared when an interrupt vector
> >> migrates to different CPU. Using a cleaner approach to manage and
> >> configure allowed vectors needs more work.
> >>
> >>
> >> Testing
> >> -------
> >>
> >> This series is based on top of commit 196145c606d0 "Merge
> >> tag 'clk-fixes-for-linus' of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux."
> >>
> >> Host Secure AVIC support patch series is at [1].
> >>
> >> Following tests are done:
> >>
> >> 1) Boot to Prompt using initramfs and ubuntu fs.
> >> 2) Verified timer and IPI as part of the guest bootup.
> >> 3) Verified long run SCF TORTURE IPI test.
> >> 4) Verified FIO test with NVME passthrough.
> > 
> > One case that is missing is kexec.
> > 
> > If the first kernel set ALLOWED_IRR, but the target kernel doesn't know
> > anything about Secure AVIC, there are going to be a problem I assume.
> > 
> > I think we need ->setup() counterpart (->teardown() ?) to get
> > configuration back to the boot state. And get it called from kexec path.
> > 
> 
> Agree, I haven't fully investigated the changes required to support kexec.
> Yes, teardown step might be required to disable Secure AVIC in control msr
> and possibly resetting other Secure AVIC configuration.
> 
> Thanks for pointing it out! I will update the details with kexec support
> being missing in this series.

I think it has to be addressed before it got merged. Or we will get a
regression.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

