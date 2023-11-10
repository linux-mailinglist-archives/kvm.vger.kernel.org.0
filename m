Return-Path: <kvm+bounces-1496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8C87E81EE
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 19:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D15B280FBB
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 18:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A6339878;
	Fri, 10 Nov 2023 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="QqVm33ZW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAE81DFDC;
	Fri, 10 Nov 2023 18:47:01 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1299217530;
	Fri, 10 Nov 2023 10:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699642019; x=1731178019;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=eUUQ7uJNPravSqJNpSE3V121J1GIxRJQS8MdayoT9IE=;
  b=QqVm33ZW4UoBL9yG0WHc4Md3afUWpUx2fdaNDrZhoWJ9nWYthQUgS2+9
   z6WAtBPYjwhb9SaX1zV/tvBbzqOr+MZju7dtSClv/vHFSioAo7tAkjDTB
   pc3XW59UTQq+R4tZA4vQGaqqEEfbT7xLdOEeIxO51ycdlng+SR64og+bR
   U=;
X-IronPort-AV: E=Sophos;i="6.03,291,1694736000"; 
   d="scan'208";a="362160415"
Subject: Re: [RFC 02/33] KVM: x86: Introduce KVM_CAP_APIC_ID_GROUPS
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 18:46:55 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id 2D06440E71;
	Fri, 10 Nov 2023 18:46:54 +0000 (UTC)
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:14842]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.22.222:2525] with esmtp (Farcaster)
 id 66695bcb-84df-4eee-8339-5eb6c43ea833; Fri, 10 Nov 2023 18:46:53 +0000 (UTC)
X-Farcaster-Flow-ID: 66695bcb-84df-4eee-8339-5eb6c43ea833
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Fri, 10 Nov 2023 18:46:52 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Fri, 10 Nov
 2023 18:46:48 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Nov 2023 18:46:44 +0000
Message-ID: <CWVCT1QRMRUJ.3TCT5GYO1XMZ9@amazon.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Anel Orazgaliyeva <anelkz@amazon.de>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-3-nsaenz@amazon.com> <ZUvJp0XVVA_JrYDW@google.com>
In-Reply-To: <ZUvJp0XVVA_JrYDW@google.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D033UWC004.ant.amazon.com (10.13.139.225) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Wed Nov 8, 2023 at 5:47 PM UTC, Sean Christopherson wrote:
> On Wed, Nov 08, 2023, Nicolas Saenz Julienne wrote:
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
> > the target lAPIC.
>
> Is all of the above arbitrary KVM behavior or defined by the TLFS?

All this matches VSM's expectations to how interrupts are to be handled.
But APIC groups is a concept we created with the aim of generalizing the
behaviour as much as possible.

> > The APIC physical map is also made group aware in
> > order to speed up this process. For the sake of simplicity, the logical
> > map is not built while KVM_CAP_APIC_ID_GROUPS is in use and we defer IP=
I
> > routing to the slower per-vCPU scan method.
>
> Why?  I mean, I kinda sorta understand what it does for VSM, but it's not=
 at all
> obvious why this information needs to be shoved into the APIC IDs.  E.g. =
why not
> have an explicit group_id and then maintain separate optimization maps fo=
r each?

There are three tricks to APIC groups. One is IPI routing: for ex. the
ICR phyical destination is mixed with the source vCPU's APIC group to
find the destination vCPU. Another is presenting a coherent APIC ID
across VTLs; switching VTLs shouldn't change the guest's view of the
APIC ID. And ultimately keeps track of the vCPU's VTL level. I don't wee
why we couldn't decouple them, as long as we keep filtering the APIC ID
before it reaches the guest.

> > This capability serves as a building block to implement virtualisation
> > based security features like Hyper-V's Virtual Secure Mode (VSM). VSM
> > introduces a para-virtualised switch that allows for guest CPUs to jump
> > into a different execution context, this switches into a different CPU
> > state, lAPIC state, and memory protections. We model this in KVM by
>
> Who is "we"?  As a general rule, avoid pronouns.  "we" and "us" in partic=
ular
> should never show up in a changelog.  I genuinely don't know if "we" mean=
s
> userspace or KVM, and the distinction matters because it clarifies whethe=
r or
> not KVM is actively involved in the modeling versus KVM being little more=
 than a
> dumb pipe to provide the plumbing.

Sorry, I've been actively trying to avoid pronouns as you already
mentioned it on a previous review. This one made it through the cracks.

> > using distinct kvm_vcpus for each context.
> >
> > Moreover, execution contexts are hierarchical and its APICs are meant t=
o
> > remain functional even when the context isn't 'scheduled in'.
>
> Please explain the relationship and rules of execution contexts.  E.g. ar=
e
> execution contexts the same thing as VTLs?  Do all "real" vCPUs belong to=
 every
> execution context?  If so, is that a requirement?

I left a note about this in my reply to your questions in the cover
letter.

> > For example, we have to keep track of
> > timers' expirations, and interrupt execution of lesser priority context=
s
> > when relevant. Hence the need to alias physical APIC ids, while keeping
> > the ability to target specific execution contexts.
> >
> > Signed-off-by: Anel Orazgaliyeva <anelkz@amazon.de>
> > Co-developed-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > ---
>
>
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index e1021517cf04..542bd208e52b 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -97,6 +97,8 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigne=
d long cr8);
> >  void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
> >  void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
> >  u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
> > +int kvm_vm_ioctl_set_apic_id_groups(struct kvm *kvm,
> > +                                 struct kvm_apic_id_groups *groups);
> >  void kvm_recalculate_apic_map(struct kvm *kvm);
> >  void kvm_apic_set_version(struct kvm_vcpu *vcpu);
> >  void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
> > @@ -277,4 +279,35 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *ap=
ic)
> >       return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
> >  }
> >
> > +static inline u32 kvm_apic_id(struct kvm_vcpu *vcpu)
> > +{
> > +     return vcpu->vcpu_id & ~vcpu->kvm->arch.apic_id_group_mask;
>
> This is *extremely* misleading.  KVM forces the x2APIC ID to match vcpu_i=
d, but
> in xAPIC mode the ID is fully writable.

Yes, although I'm under the impression that no sane OS will do so. We
can decouple the group from the APIC ID, but it still needs to be masked
before presenting it to the guest. So I guess we'll have to deal with
the eventuality of apic id writing one way or anoter (a warn only if VSM
is enabled?).

If we decide the APIC group uAPI is not worth it, we can always create
an ad-hoc VSM one that explicitly sets the kvm_vcpu's VTL. Then route
the VTL internally into the APIC which can use still groups (or a
similar concept).

Nicolas

