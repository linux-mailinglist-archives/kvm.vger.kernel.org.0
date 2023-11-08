Return-Path: <kvm+bounces-1204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9E037E584C
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 15:04:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B5AFB20CA1
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 14:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67BF199C0;
	Wed,  8 Nov 2023 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="K2vYMmVh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CF4199AE;
	Wed,  8 Nov 2023 14:04:23 +0000 (UTC)
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489B91FC1;
	Wed,  8 Nov 2023 06:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699452263; x=1730988263;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:subject:from:to:references:in-reply-to;
  bh=n/fcIpJPxsvkMrkN5JCr1sc8goxOAlksFWX+lQfVhd0=;
  b=K2vYMmVhOcrDyyWQFw3uzcPtkzWLy1uxIJzSvo4vkdoWj5NbsDgJof0/
   8XlRk+3+gAH5UiUdA1yXzTaiWDIKlNTBXhbpQhrhVg/s9b/Xvl46XYrvo
   lFQsary9e8OypQsEK5AvmOiXgir9eBvi5h/rbG6G0bTMiju0yNUMIJfjA
   c=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="42004932"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 14:04:21 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id E40B740E6D;
	Wed,  8 Nov 2023 14:04:20 +0000 (UTC)
Received: from EX19MTAEUB001.ant.amazon.com [10.0.43.254:47054]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.4.34:2525] with esmtp (Farcaster)
 id 8feaa2c9-f99b-4f53-b35b-31556835030c; Wed, 8 Nov 2023 14:04:20 +0000 (UTC)
X-Farcaster-Flow-ID: 8feaa2c9-f99b-4f53-b35b-31556835030c
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 14:04:19 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 14:04:15 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 8 Nov 2023 14:04:11 +0000
Message-ID: <CWTHJMKS9HC9.PWYKN1IZX4EZ@amazon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <decui@microsoft.com>,
	<x86@kernel.org>, <linux-doc@vger.kernel.org>
Subject: Re: [RFC 09/33] KVM: x86: hyper-v: Introduce per-VTL vcpu helpers
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Alexander Graf <graf@amazon.com>, <kvm@vger.kernel.org>,
	<anelkz@amazon.com>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-10-nsaenz@amazon.com>
 <2a8fddbb-d1d9-4639-a79d-0d32c06d309e@amazon.com>
In-Reply-To: <2a8fddbb-d1d9-4639-a79d-0d32c06d309e@amazon.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D033UWC002.ant.amazon.com (10.13.139.196) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Wed Nov 8, 2023 at 12:21 PM UTC, Alexander Graf wrote:
>
> On 08.11.23 12:17, Nicolas Saenz Julienne wrote:
> > Introduce two helper functions. The first one queries a vCPU's VTL
> > level, the second one, given a struct kvm_vcpu and VTL pair, returns th=
e
> > corresponding 'sibling' struct kvm_vcpu at the right VTL.
> >
> > We keep track of each VTL's state by having a distinct struct kvm_vpcu
> > for each level. VTL-vCPUs that belong to the same guest CPU share the
> > same physical APIC id, but belong to different APIC groups where the
> > apic group represents the vCPU's VTL.
> >
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > ---
> >   arch/x86/kvm/hyperv.h | 18 ++++++++++++++++++
> >   1 file changed, 18 insertions(+)
> >
> > diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> > index 2bfed69ba0db..5433107e7cc8 100644
> > --- a/arch/x86/kvm/hyperv.h
> > +++ b/arch/x86/kvm/hyperv.h
> > @@ -23,6 +23,7 @@
> >  =20
> >   #include <linux/kvm_host.h>
> >   #include "x86.h"
> > +#include "lapic.h"
> >  =20
> >   /* "Hv#1" signature */
> >   #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
> > @@ -83,6 +84,23 @@ static inline struct kvm_hv_syndbg *to_hv_syndbg(str=
uct kvm_vcpu *vcpu)
> >   	return &vcpu->kvm->arch.hyperv.hv_syndbg;
> >   }
> >  =20
> > +static inline struct kvm_vcpu *kvm_hv_get_vtl_vcpu(struct kvm_vcpu *vc=
pu, int vtl)
> > +{
> > +	struct kvm *kvm =3D vcpu->kvm;
> > +	u32 target_id =3D kvm_apic_id(vcpu);
> > +
> > +	kvm_apic_id_set_group(kvm, vtl, &target_id);
> > +	if (vcpu->vcpu_id =3D=3D target_id)
> > +		return vcpu;
> > +
> > +	return kvm_get_vcpu_by_id(kvm, target_id);
> > +}
> > +
> > +static inline u8 kvm_hv_get_active_vtl(struct kvm_vcpu *vcpu)
> > +{
> > +	return kvm_apic_group(vcpu);
>
> Shouldn't this check whether VTL is active? If someone wants to use APIC=
=20
> groups for a different purpose in the future, they'd suddenly find=20
> themselves in VTL code paths in other code (such as memory protections), =
no?

Yes, indeed. This is solved by adding a couple of checks vs
kvm_hv_vsm_enabled().

I don't have another use-case in mind for APIC ID groups so it's hard to
picture if I'm just over engineering things, but I wonder it we need to
introduce some sort of protection vs concurrent usages.

For example we could introduce masks within the group bits and have
consumers explicitly request what they want. Something like:

	vtl =3D kvm_apic_group(vcpu, HV_VTL);

If user-space didn't reserve bits within the APIC ID group area and
marked them with HV_VTL you'd get an error as opposed to 0 which is
otherwise a valid group.

Nicolas

