Return-Path: <kvm+bounces-3131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABE16800E86
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:25:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BAB0281AF6
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762344AF6A;
	Fri,  1 Dec 2023 15:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="I/xaCcRr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5621CD4A;
	Fri,  1 Dec 2023 07:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1701444322; x=1732980322;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=FfeiQvxbxXeqzRQdfjMLltmlruM6oJfGRqxgBK9e5cE=;
  b=I/xaCcRrPXKIjSiwt98qVbcVSMQO/hJS4Va9yaJ3VS17rMjZIz0WRwjh
   KreR3EJJmbLv4em6WG1Gzd7id73v54pViD/vw6EyXFnVedyuvmYFnjQHc
   h1IAOmDc1jAzyg+KECyQkSdy0Itj58ZD3VedwzbbaV/FrH07e+aBmO6ld
   E=;
X-IronPort-AV: E=Sophos;i="6.04,241,1695686400"; 
   d="scan'208";a="366051200"
Subject: Re: [RFC 02/33] KVM: x86: Introduce KVM_CAP_APIC_ID_GROUPS
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 15:25:19 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id D43E9A3638;
	Fri,  1 Dec 2023 15:25:16 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:15743]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.183:2525] with esmtp (Farcaster)
 id bc754cf4-d55e-458d-8bc8-0b3c97125d02; Fri, 1 Dec 2023 15:25:15 +0000 (UTC)
X-Farcaster-Flow-ID: bc754cf4-d55e-458d-8bc8-0b3c97125d02
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 1 Dec 2023 15:25:15 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 1 Dec
 2023 15:25:10 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 1 Dec 2023 15:25:06 +0000
Message-ID: <CXD3O3XBHKZO.22U5VF0HFBTC9@amazon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Anel Orazgaliyeva <anelkz@amazon.de>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-3-nsaenz@amazon.com>
 <98eee37ed7f4b7b9c16bccbe41737e47a116d1f1.camel@redhat.com>
In-Reply-To: <98eee37ed7f4b7b9c16bccbe41737e47a116d1f1.camel@redhat.com>
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Hi Maxim,

On Tue Nov 28, 2023 at 6:56 AM UTC, Maxim Levitsky wrote:
> On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> > From: Anel Orazgaliyeva <anelkz@amazon.de>
> >
> > Introduce KVM_CAP_APIC_ID_GROUPS, this capability segments the VM's API=
C
> > ids into two. The lower bits, the physical APIC id, represent the part
> > that's exposed to the guest. The higher bits, which are private to KVM,
> > groups APICs together. APICs in different groups are isolated from each
> > other, and IPIs can only be directed at APICs that share the same group
> > as its source. Furthermore, groups are only relevant to IPIs, anything
> > incoming from outside the local APIC complex: from the IOAPIC, MSIs, or
> > PV-IPIs is targeted at the default APIC group, group 0.
> >
> > When routing IPIs with physical destinations, KVM will OR the source's
> > vCPU APIC group with the ICR's destination ID and use that to resolve
> > the target lAPIC. The APIC physical map is also made group aware in
> > order to speed up this process. For the sake of simplicity, the logical
> > map is not built while KVM_CAP_APIC_ID_GROUPS is in use and we defer IP=
I
> > routing to the slower per-vCPU scan method.
> >
> > This capability serves as a building block to implement virtualisation
> > based security features like Hyper-V's Virtual Secure Mode (VSM). VSM
> > introduces a para-virtualised switch that allows for guest CPUs to jump
> > into a different execution context, this switches into a different CPU
> > state, lAPIC state, and memory protections. We model this in KVM by
> > using distinct kvm_vcpus for each context. Moreover, execution contexts
> > are hierarchical and its APICs are meant to remain functional even when
> > the context isn't 'scheduled in'. For example, we have to keep track of
> > timers' expirations, and interrupt execution of lesser priority context=
s
> > when relevant. Hence the need to alias physical APIC ids, while keeping
> > the ability to target specific execution contexts.
>
>
> A few general remarks on this patch (assuming that we don't go with
> the approach of a VM per VTL, in which case this patch is not needed)
>
> -> This feature has to be done in the kernel because vCPUs sharing same V=
TL,
>    will have same APIC ID.
>    (In addition to that, APIC state is private to a VTL so each VTL
>    can even change its apic id).
>
>    Because of this KVM has to have at least some awareness of this.
>
> -> APICv/AVIC should be supported with VTL eventually:
>    This is thankfully possible by having separate physid/pid tables per V=
TL,
>    and will mostly just work but needs KVM awareness.
>
> -> I am somewhat against reserving bits in apic id, because that will lim=
it
>    the number of apic id bits available to userspace. Currently this is n=
ot
>    a problem but it might be in the future if for some reason the userspa=
ce
>    will want an apic id with high bits set.
>
>    But still things change, and with this being part of KVM's ABI, it mig=
ht backfire.
>    A better idea IMHO is just to have 'APIC namespaces', which like say P=
ID namespaces,
>    such as each namespace is isolated IPI wise on its own, and let each v=
CPU belong to
>    a one namespace.
>
>    In fact Intel's PRM has a brief mention of a 'hierarchical cluster' mo=
de in which
>    roughly describes this situation in which there are multiple not inter=
connected APIC buses,
>    and communication between them needs a 'cluster manager device'
>
>    However I don't think that we need an explicit pairs of vCPUs and VTL =
awareness in the kernel
>    all of this I think can be done in userspace.
>
>    TL;DR: Lets have APIC namespace. a vCPU can belong to a single namespa=
ce, and all vCPUs
>    in a namespace send IPIs to each other and know nothing about vCPUs fr=
om other namespace.
>
>    A vCPU sending IPI to a different VTL thankfully can only do this usin=
g a hypercall,
>    and thus can be handled in the userspace.
>
>
> Overall though IMHO the approach of a VM per VTL is better unless some sh=
ow stoppers show up.
> If we go with a VM per VTL, we gain APIC namespaces for free, together wi=
th AVIC support and
> such.


Thanks, for the thorough review! I took note of all your design comments
(here and in subsequent patches).

I agree that the way to go is the VM per VTL approach. I'll prepare a
PoC as soon as I'm back from the holidays and share my results.

Nicolas

