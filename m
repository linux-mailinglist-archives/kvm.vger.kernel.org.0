Return-Path: <kvm+bounces-55103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F95B2D621
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 10:22:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C8D11BC66E8
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 08:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6952D2D94BA;
	Wed, 20 Aug 2025 08:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IT0jotGH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFFD2D877E;
	Wed, 20 Aug 2025 08:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755677906; cv=none; b=hdZt1ol0YclZyKQ2Ogf7tErdGgnKFvz04C4wuDoeLw3lN5VLHoUG4YIkVzRP4PiUk4EBoo/gTJ5JCX5/7SNnOj0rz0MHzGQcTfcKz8mDNGl1FsNlIRFW2X4guIzM0hCJxpJ1DTT21QUw3rjWsHdza4ZkhseUMm13p/80Z0RLTDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755677906; c=relaxed/simple;
	bh=47Dtr2C2DeyI7MxEH11hrGy5jj35R1/+Fx9hkkYLgSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeyObTEAf7rhsPaAK8VtfGssB7b8/7brG51r0j4UKbaF1Wcc4cHBIVctZ5OFGUonQJjDw6sBvv1jK+IdbIDJZ8l+2wCRSLKZQd7259mAAfdrQRMDuZxSDfOL001jd+RNMKfuRIDHb8pPrgqk0Nx6MQjKXGTwumIhGVEZZvMjkWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IT0jotGH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A15BC4CEEB;
	Wed, 20 Aug 2025 08:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755677906;
	bh=47Dtr2C2DeyI7MxEH11hrGy5jj35R1/+Fx9hkkYLgSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IT0jotGHId8B2qCArZnrtSZk4Dj/5WdHTVsAXCZV3vsY2F4scok5dy46O5eOUSbTy
	 hTExlI/b/mHGhuxj41KLnbFrCz00eDW22AO+osctC9qHjuXeljBKgoqdsaBsUPBxWx
	 J1Ow21cLdQwME1sX5aO8yhRqnL7qewrJgbRBJnZnW9hobl8G7ApmIesn1DJsBItVbN
	 u9QfEa9m/keerLHVh/fY8VQe9umL6NgSpqrKgG6h98ch16fVtkimViuT7JrN4Ug78Y
	 jmXyOqH9Zdt61rw5ERFO/9binbIzNDu0LFZB5yXx6k4py2ekJEe+P9viA9UX6sguZf
	 Gq7+Z/DYMMN8A==
Date: Wed, 20 Aug 2025 13:41:28 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, 
	"Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Mario Limonciello <mario.limonciello@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Babu Moger <babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v3 0/4] x86/cpu/topology: Work around the nuances of
 virtualization on AMD/Hygon
Message-ID: <mcclyouhgeqzkhljovu7euzvowyqrtf5q4madh3f32yeb7ubnk@xdtbsvi2m7en>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>

On Tue, Aug 19, 2025 at 01:34:47PM +0200, Borislav Petkov wrote:
> Lemme try to make some sense of this because the wild use of names and things
> is making my head spin...
> 
> On Mon, Aug 18, 2025 at 06:04:31AM +0000, K Prateek Nayak wrote:
> > When running an AMD guest on QEMU with > 255 cores, the following FW_BUG
> > was noticed with recent kernels:
> > 
> >     [Firmware Bug]: CPU 512: APIC ID mismatch. CPUID: 0x0000 APIC: 0x0200
> > 
> > Naveen, Sairaj debugged the cause to commit c749ce393b8f ("x86/cpu: Use
> > common topology code for AMD") where, after the rework, the initial
> > APICID was set using the CPUID leaf 0x8000001e EAX[31:0] as opposed to
> 
> That's
> 
> CPUID_Fn8000001E_ECX [Node Identifiers] (Core::X86::Cpuid::NodeId)
> 
> > the value from CPUID leaf 0xb EDX[31:0] previously.
> 
> That's
> 
> CPUID_Fn0000000B_EDX [Extended Topology Enumeration]
> (Core::X86::Cpuid::ExtTopEnumEdx)

Regardless of the qemu bug with leaf 0x8000001e (with >255 cores), 
section '16.12 x2APIC_ID' of the APM says:
  CPUID. The x2APIC ID is reported by CPUID functions Fn0000_000B 
  (Extended Topology Enumeration) and CPUID Fn8000_001E (Extended APIC 
  ID) as follows:
  - Fn0000_000B_EDX[31:0]_x0 reports the full 32-bit ID, independent of 
    APIC mode (i.e. even with APIC disabled)
  - Fn8000_001E_EAX[31:0] conditionally reports APIC ID. There are 3 
    cases:
      - 32-bit x2APIC_ID, in x2APIC mode.
      - 8-bit APIC ID (upper 24 bits are 0), in xAPIC mode.
      - 0, if the APIC is disabled.

That suggests use of leaf 0xb for the initial x2APIC ID especially 
during early init.  I'm not sure why leaf 0x8000001e was preferred over 
leaf 0xb in commit c749ce393b8f ("x86/cpu: Use common topology code for 
AMD") though.


- Naveen


