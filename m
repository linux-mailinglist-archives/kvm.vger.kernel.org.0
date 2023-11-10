Return-Path: <kvm+bounces-1494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D5A97E7FBB
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 18:58:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02E7A2812AE
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 17:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7973A268;
	Fri, 10 Nov 2023 17:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="gR8tRH/4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBB030334;
	Fri, 10 Nov 2023 17:58:27 +0000 (UTC)
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8088167754;
	Fri, 10 Nov 2023 09:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699639033; x=1731175033;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=99caKOHgzyDTXwWRsRksd059fQ4JKBbasT1uYz4fi50=;
  b=gR8tRH/4AimvKaVg1udaJ6UkbZwkA7vL4djAvuGw54nDXEGIhgGaMdiY
   uRrPT4yyezPIhhd0Lu5SRQpVCP9TYVtDyS57u4AnH18/D17Ycve+aleDh
   N2wjLxyppSbC4PgDKWYzmTFKroJiT1xb9espARCX4mevFCHuiFDDK4Z+o
   s=;
X-IronPort-AV: E=Sophos;i="6.03,291,1694736000"; 
   d="scan'208";a="42712469"
Subject: Re: [RFC 0/33] KVM: x86: hyperv: Introduce VSM support
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 17:56:52 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com (Postfix) with ESMTPS id 8282689E8A;
	Fri, 10 Nov 2023 17:56:51 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:31125]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.45.210:2525] with esmtp (Farcaster)
 id 62d1a24e-71c0-4a04-9bf1-9657fee25218; Fri, 10 Nov 2023 17:56:50 +0000 (UTC)
X-Farcaster-Flow-ID: 62d1a24e-71c0-4a04-9bf1-9657fee25218
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Fri, 10 Nov 2023 17:56:49 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Fri, 10 Nov
 2023 17:56:45 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Nov 2023 17:56:41 +0000
Message-ID: <CWVBQQ6GVQVG.2FKWLPBUF77UT@amazon.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <ZUu9lwJHasi2vKGg@google.com> <ZUvUZytj1AabvvrB@google.com>
In-Reply-To: <ZUvUZytj1AabvvrB@google.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Hi Sean,
Thanks for taking the time to review the series. I took note of your
comments across the series, and will incorporate them into the LPC
discussion.

On Wed Nov 8, 2023 at 6:33 PM UTC, Sean Christopherson wrote:
> On Wed, Nov 08, 2023, Sean Christopherson wrote:
> > On Wed, Nov 08, 2023, Nicolas Saenz Julienne wrote:
> > > This RFC series introduces the necessary infrastructure to emulate VS=
M
> > > enabled guests. It is a snapshot of the progress we made so far, and =
its
> > > main goal is to gather design feedback.
> >
> > Heh, then please provide an overview of the design, and ideally context=
 and/or
> > justification for various design decisions.  It doesn't need to be a pr=
oper design
> > doc, and you can certainly point at other documentation for explaining =
VSM/VTLs,
> > but a few paragraphs and/or verbose bullet points would go a long way.
> >
> > The documentation in patch 33 provides an explanation of VSM itself, an=
d a little
> > insight into how userspace can utilize the KVM implementation.  But the=
 documentation
> > provides no explanation of the mechanics that KVM *developers* care abo=
ut, e.g.
> > the use of memory attributes, how memory attributes are enforced, wheth=
er or not
> > an in-kernel local APIC is required, etc.
> >
> > Nor does the documentation explain *why*, e.g. why store a separate set=
 of memory
> > attributes per VTL "device", which by the by is broken and unnecessary.
>
> After speed reading the series..  An overview of the design, why you made=
 certain
> choices, and the tradeoffs between various options is definitely needed.
>
> A few questions off the top of my head:
>
>  - What is the split between userspace and KVM?  How did you arrive at th=
at split?

Our original design, which we discussed in the KVM forum 2023 [1] and is
public [2], implemented most of VSM in-kernel. Notably we introduced VTL
awareness in struct kvm_vcpu. This turned out to be way too complex: now
vcpus have multiple CPU architectural states, events, apics, mmu, etc.
First of all, the code turned out to be very intrusive, for example,
most apic APIs had to be reworked one way or another to accommodate
the fact there are multiple apics available. Also, we were forced to
introduce VSM-specific semantics in x86 emulation code. But more
importantly, the biggest pain has been dealing with state changes, they
may be triggered remotely through requests, and some are already fairly
delicate as-is. They involve a multitude of corner cases that almost
never apply for a VTL aware kvm_vcpu. Especially if you factor in
features like live migration. It's been a continuous source of
regressions.

Memory protections were implemented by using memory slot modifications.
We introduced a downstream API that allows updating memory slots
concurrently with vCPUs running. I think there was a similar proposal
upstream from Red Hat some time ago. The result is complex, hard to
generalize and slow.

So we decided to move all this complexity outside of struct kvm_vcpu
and, as much as possible, out of the kernel. We figures out the basic
kernel building blocks that are absolutely necessary, and let user-space
deal with the rest.

>  - How much *needs* to be in KVM?  I.e. how much can be pushed to userspa=
ce while
>    maintaininly good performance?

As I said above, the aim of the current design is to keep it as light as
possible. The biggest move we made was moving VTL switching into
user-space. We don't see any indication that performance is affected in
a major way. But we will know for sure once we finish the implementation
and test it under real use-cases.

>  - Why not make VTLs a first-party concept in KVM?  E.g. rather than bury=
 info
>    in a VTL device and APIC ID groups, why not modify "struct kvm" to sup=
port
>    replicating state that needs to be tracked per-VTL?  Because of how me=
mory
>    attributes affect hugepages, duplicating *memslots* might actually be =
easier
>    than teaching memslots to be VTL-aware.

I do agree that we need to introduce some level VTL awareness into
memslots. There's the hugepages issues you pointed out. But it'll be
also necessary once we look at how to implement overlay pages that are
per-VTL. (A topic I didn't mention in the series as I though I had
managed to solve memory protections while avoiding the need for multiple
slots). What I have in mind is introducing a memory slot address space
per-VTL, similar to how we do things with SMM.

It's important to note that requirements for overlay pages and memory
protections are very different. Overlay pages are scarce, and are setup
once and never change (AFAICT), so we think stopping all vCPUs, updating
slots, and resuming execution will provide good enough performance.
Memory protections happen very frequently, generally with page
granularity, and may be short-lived.

>  - Is "struct kvm_vcpu" the best representation of an execution context (=
if I'm
>    getting the terminology right)?

Let's forget I ever mentioned execution contexts. I used it in the hopes
of making the VTL concept a little more understandable for non-VSM aware
people. It's meant to be interchangeable with VTL. But I see how it
creates confusion.

>    E.g. if 90% of the state is guaranteed to be identical for a given
>    vCPU across execution contexts, then modeling that with separate
>    kvm_vcpu structures is very inefficient.  I highly doubt it's 90%,
>    but it might be quite high depending on how much the TFLS restricts
>    the state of the vCPU, e.g. if it's 64-bit only.

For the record here's the private VTL state (TLFS 15.11.1):

"In general, each VTL has its own control registers, RIP register, RSP
 register, and MSRs:

 SYSENTER_CS, SYSENTER_ESP, SYSENTER_EIP, STAR, LSTAR, CSTAR, SFMASK,
 EFER, PAT, KERNEL_GSBASE, FS.BASE, GS.BASE, TSC_AUX
 HV_X64_MSR_HYPERCALL
 HV_X64_MSR_GUEST_OS_ID
 HV_X64_MSR_REFERENCE_TSC
 HV_X64_MSR_APIC_FREQUENCY
 HV_X64_MSR_EOI
 HV_X64_MSR_ICR
 HV_X64_MSR_TPR
 HV_X64_MSR_APIC_ASSIST_PAGE
 HV_X64_MSR_NPIEP_CONFIG
 HV_X64_MSR_SIRBP
 HV_X64_MSR_SCONTROL
 HV_X64_MSR_SVERSION
 HV_X64_MSR_SIEFP
 HV_X64_MSR_SIMP
 HV_X64_MSR_EOM
 HV_X64_MSR_SINT0 =E2=80=93 HV_X64_MSR_SINT15
 HV_X64_MSR_STIMER0_COUNT =E2=80=93 HV_X64_MSR_STIMER3_COUNT
 Local APIC registers (including CR8/TPR)
"

The rest is shared.

Note that we've observed that during normal operation, VTL switches
don't happen that often. The boot process is the most affected by any
performance impact VSM might introduce, which issues 100000s (mostly
memory protections).

Nicolas

[1] https://kvm-forum.qemu.org/2023/talk/TK7YGD/
[2] Partial rebase of our original implementation:
    https://github.com/vianpl/linux vsm

