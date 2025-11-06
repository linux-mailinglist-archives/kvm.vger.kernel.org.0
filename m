Return-Path: <kvm+bounces-62233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F792C3CE28
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 18:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F264A4F3399
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 17:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7483234F253;
	Thu,  6 Nov 2025 17:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="qderbo3h"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C76019D07E;
	Thu,  6 Nov 2025 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762450581; cv=none; b=KDNcUeW5KXGfuHkySsKG2s44feCT2aomf92DeVEuvXQsFwiBVxoHeRxOfRWOPlUilGa7yzJvRb5vsuLoCZUanmbsp+QLd2LlG6Bwwsyg1OHcllyHl0vlm1K7fDut65D9ix9e0Qerd4ow4fVq6Q8b5wVrGiVhqwhxz9UfIF3+yZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762450581; c=relaxed/simple;
	bh=a5hetV/RGzRrXvVR45KZvABuomwQxaqs3PCaxKj4vKQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=I3cRepBWkwW6wd6/wyukrSCnVuyI1uL0cmpLBYLZoGr1xeJPF2e/tYc0dpCQJIG9kmKoMLu4pr3uHt7xonKGeTyEqDob89IhX6piGbrknGNDls1n36I5rMOp6kfou/gspZi2D4sFQm2wJ2nTIDYj0rBk84KmJEggDxi7GPJ2GCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=qderbo3h; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5A6HZN2c1176414
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 6 Nov 2025 09:35:24 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5A6HZN2c1176414
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762450525;
	bh=ZNXA8TEdsM5oF8ouKkrvVpMu+D9FhagmmSfId25Z3RE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=qderbo3hrDf0QFnlNbvQhYxzN8cbALlvWhJYZAB34Iu+W0Or+C2FB1qnYYyINtLOx
	 N7GElzwB51Bl4WPD+LDlPgr9wgw5hNyzaC7avJZt9y/Z9SqctMPCjBx/tgreZGYn5R
	 WCk3xxqB1GPzAuq4GGyTvG1FWwam1AWT0cdKhu/oCVZ7NXhc7fQBTuhkdq5wz2BsqA
	 WjkvNI3TYOpX5r6Khahk3v6ChLK20o6OBRI+x8PqnPAB4yQHiu60Fe4qzdIQId0Qlk
	 JXIqfTlg2rfmHDtD4bY+LtlMFq8CcAa75wwRryz/aetJPhxL645SiL8bpv/Bzv0ID/
	 VLuZ/NLOb90jg==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v9 00/22] Enable FRED with KVM VMX
From: Xin Li <xin@zytor.com>
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
Date: Thu, 6 Nov 2025 09:35:13 -0800
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, chao.gao@intel.com, hch@infradead.org,
        sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <9EF391B5-71E8-4A9C-BD55-B78B5DEE5638@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
X-Mailer: Apple Mail (2.3864.200.81.1.6)


> On Oct 26, 2025, at 1:18=E2=80=AFPM, Xin Li (Intel) <xin@zytor.com> =
wrote:
>=20
> This patch set enables the Intel flexible return and event delivery
> (FRED) architecture with KVM VMX to allow guests to utilize FRED.
>=20
> The FRED architecture defines simple new transitions that change
> privilege level (ring transitions). The FRED architecture was
> designed with the following goals:
>=20
> 1) Improve overall performance and response time by replacing event
>   delivery through the interrupt descriptor table (IDT event
>   delivery) and event return by the IRET instruction with lower
>   latency transitions.
>=20
> 2) Improve software robustness by ensuring that event delivery
>   establishes the full supervisor context and that event return
>   establishes the full user context.
>=20
> The new transitions defined by the FRED architecture are FRED event
> delivery and, for returning from events, two FRED return instructions.
> FRED event delivery can effect a transition from ring 3 to ring 0, but
> it is used also to deliver events incident to ring 0. One FRED
> instruction (ERETU) effects a return from ring 0 to ring 3, while the
> other (ERETS) returns while remaining in ring 0. Collectively, FRED
> event delivery and the FRED return instructions are FRED transitions.
>=20
>=20
> Intel VMX architecture is extended to run FRED guests, and the major
> changes are:
>=20
> 1) New VMCS fields for FRED context management, which includes two new
> event data VMCS fields, eight new guest FRED context VMCS fields and
> eight new host FRED context VMCS fields.
>=20
> 2) VMX nested-exception support for proper virtualization of stack
> levels introduced with FRED architecture.
>=20
> Search for the latest FRED spec in most search engines with this =
search
> pattern:
>=20
>  site:intel.com FRED (flexible return and event delivery) =
specification
>=20
>=20
> Although FRED and CET supervisor shadow stacks are independent CPU
> features, FRED unconditionally includes FRED shadow stack pointer
> MSRs IA32_FRED_SSP[0123], and IA32_FRED_SSP0 is just an alias of the
> CET MSR IA32_PL0_SSP.  IOW, the state management of MSR IA32_PL0_SSP
> becomes an overlap area, and Sean requested that FRED virtualization
> to land after CET virtualization [1].
>=20
> With CET virtualization now merged in v6.18, the path is clear to =
submit
> the FRED virtualization patch series :).

Sean, what is the plan for the FRED patch series?

A good news is that we have got acks on all 3 common x86 patches.

Thanks!
Xin

>=20
> Changes in v9:
> * Rebased to the latest kvm-x86/next branch, tag =
kvm-x86-next-2025.10.20-2.
> * Guard FRED state save/restore with guest_cpu_cap_has(vcpu, =
X86_FEATURE_FRED)
>  in patch 19 (syzbot & Chao).
> * Use array indexing for exception stack access, eliminating the need =
for
>  the ESTACKS_MEMBERS() macro in struct cea_exception_stacks, and then
>  exported __this_cpu_ist_top_va() in a subsequent patch (Dave Hansen).
> * Rewrote some of the change logs.

