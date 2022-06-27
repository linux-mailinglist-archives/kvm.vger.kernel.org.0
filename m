Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B6655E22C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbiF0QRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235713AbiF0QRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:17:41 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BF618B17;
        Mon, 27 Jun 2022 09:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1656346659; x=1687882659;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=USxLX1hhBixQIrWe2JRk26WbQIpHEUrB18xFgZhH74s=;
  b=AEgoPJ7+VsOyrvO1wKlydr4J21BuVveM2+xSBNqfnUgrKJfHwlc/Gtue
   9euZcFZOEXD5a2WBjFdxEnESS52fJ0oNaWFHCqFJLH7JE3gR1t0CzYpkO
   UxpVI01V97DO+Caiqp9LkSI7q8Z2wk2TAb2xNsgd87Owb6Y5yvKVzVKSY
   c=;
X-IronPort-AV: E=Sophos;i="5.92,226,1650931200"; 
   d="scan'208";a="102349472"
Subject: RE: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Thread-Topic: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-7dac3c4d.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 27 Jun 2022 15:56:51 +0000
Received: from EX13D32EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-7dac3c4d.us-east-1.amazon.com (Postfix) with ESMTPS id 8C15DA37DA;
        Mon, 27 Jun 2022 15:56:46 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC003.ant.amazon.com (10.43.164.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 15:56:45 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Mon, 27 Jun 2022 15:56:45 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Sean Christopherson <seanjc@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Thread-Index: AQHYhhnGr94/Tz5Zr06wX+PVouePzq1bgNUAgAAEIQCAB+LOUIAAB6YAgAAA80A=
Date:   Mon, 27 Jun 2022 15:56:45 +0000
Message-ID: <e4711fc9017246978a0b452f1b5ca868@EX13D32EUC003.ant.amazon.com>
References: <20220622092202.15548-1-pdurrant@amazon.com>
 <YrMqtHzNSean+qkh@google.com>
 <834f41a88e9f49b6b72d9d3672d702e5@EX13D32EUC003.ant.amazon.com>
 <0abf9f5de09e45ef9eb06b56bf16e3e6@EX13D32EUC003.ant.amazon.com>
 <YrnSFGURsmxV2Qmu@google.com>
In-Reply-To: <YrnSFGURsmxV2Qmu@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-12.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: 27 June 2022 16:52
> To: Durrant, Paul <pdurrant@amazon.co.uk>
> Cc: x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Pa=
olo Bonzini
> <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li=
 <wanpengli@tencent.com>; Jim
> Mattson <jmattson@google.com>; Joerg Roedel <joro@8bytes.org>; Thomas Gle=
ixner <tglx@linutronix.de>;
> Ingo Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave Hans=
en
> <dave.hansen@linux.intel.com>; H. Peter Anvin <hpa@zytor.com>
> Subject: RE: [EXTERNAL][PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc=
 info) sub-leaves, if present
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open
> attachments unless you can confirm the sender and know the content is saf=
e.
>=20
>=20
>=20
> On Mon, Jun 27, 2022, Durrant, Paul wrote:
> > > -----Original Message-----
> > [snip]
> > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > index 00e23dc518e0..8b45f9975e45 100644
> > > > > --- a/arch/x86/kvm/x86.c
> > > > > +++ b/arch/x86/kvm/x86.c
> > > > > @@ -3123,6 +3123,7 @@ static int kvm_guest_time_update(struct kvm=
_vcpu *v)
> > > > >       if (vcpu->xen.vcpu_time_info_cache.active)
> > > > >               kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_inf=
o_cache, 0);
> > > > >       kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
> > > > > +     kvm_xen_setup_tsc_info(v);
> > > >
> > > > This can be called inside this if statement, no?
> > > >
> > > >         if (unlikely(vcpu->hw_tsc_khz !=3D tgt_tsc_khz)) {
> > > >
> > > >         }
> > > >
> >
> > I think it ought to be done whenever the shared copy of Xen's vcpu_info=
 is
> > updated (it will always match on real Xen) so unconditionally calling i=
t here
> > seems reasonable.
>=20
> But isn't the call pointless if the vCPU's hw_tsc_khz is unchanged?  E.g =
if the
> params were explicitly passed in, then it would look like:
>=20
>         if (unlikely(vcpu->hw_tsc_khz !=3D tgt_tsc_khz)) {
>                 kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
>                                    &vcpu->hv_clock.tsc_shift,
>                                    &vcpu->hv_clock.tsc_to_system_mul);
>                 vcpu->hw_tsc_khz =3D tgt_tsc_khz;
>=20
>                 kvm_xen_setup_tsc_info(vcpu, tgt_tsc_khz,
>                                        vcpu->hv_clock.tsc_shift,
>                                        vcpu->hv_clock.tsc_to_system_mul);
>         }
>=20
> Explicitly passing in the arguments probably isn't necessary, just use a =
more
> precise name, e.g. kvm_xen_update_tsc_khz(), to make it clear that the up=
date is
> limited to TSC frequency changes.
>=20
> > > > > +{
> > > > > +     u32 base =3D 0;
> > > > > +     u32 function;
> > > > > +
> > > > > +     for_each_possible_hypervisor_cpuid_base(function) {
> > > > > +             struct kvm_cpuid_entry2 *entry =3D kvm_find_cpuid_e=
ntry(vcpu, function, 0);
> > > > > +
> > > > > +             if (entry &&
> > > > > +                 entry->ebx =3D=3D XEN_CPUID_SIGNATURE_EBX &&
> > > > > +                 entry->ecx =3D=3D XEN_CPUID_SIGNATURE_ECX &&
> > > > > +                 entry->edx =3D=3D XEN_CPUID_SIGNATURE_EDX) {
> > > > > +                     base =3D function;
> > > > > +                     break;
> > > > > +             }
> > > > > +     }
> > > > > +     if (!base)
> > > > > +             return;
> > > > > +
> > > > > +     function =3D base | XEN_CPUID_LEAF(3);
> > > > > +     vcpu->arch.xen.tsc_info_1 =3D kvm_find_cpuid_entry(vcpu, fu=
nction, 1);
> > > > > +     vcpu->arch.xen.tsc_info_2 =3D kvm_find_cpuid_entry(vcpu, fu=
nction, 2);
> > > >
> > > > Is it really necessary to cache the leave?  Guest CPUID isn't optim=
ized, but it's
> > > > not _that_ slow, and unless I'm missing something updating the TSC =
frequency and
> > > > scaling info should be uncommon, i.e. not performance critical.
> >
> > If we're updating the values in the leaves on every entry into the gues=
t (as
> > with calls to kvm_setup_guest_pvclock()) then I think the cached pointe=
rs are
> > worthwhile.
>=20
> But why would you update on every entry to the guest?   Isn't this a rare=
 operation
> if the update is limited to changes in the host CPU's TSC frequency?  Or =
am I
> missing something?

No, I am indeed forgetting that there is no offset to update (there once wa=
s) so indeed the values will only change if the freq changes... so I'll dro=
p the caching.

  Paul
