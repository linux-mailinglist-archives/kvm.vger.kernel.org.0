Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E959BE1C7F
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 15:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391233AbfJWN0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 09:26:04 -0400
Received: from mail-eopbgr1320121.outbound.protection.outlook.com ([40.107.132.121]:26257
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391469AbfJWN0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 09:26:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYDF56ImENrWi4eVN9oB1zATE0JXgSUL0i87bUy1z3oDdLGqhi9hPfDPuekI4LDOwl+YBlZiWrzkCHgnzgb2KKjrvP2kuL/MpsXzYiZWU8TZblNh3gwIxvS5spD6/2/rGAioG49Bs/X2tENt9g1zIcZlsTISujXhcyXdPv3rz67f6D1AYHRa8Z/Cf/C8Eay9SULyJXJXAHkEYElcRQRBvPzFYtG3+spdEpgSvdafbuV8KmG5HXuV6+LlZSXRWhi6PSTC3umMZF4+Am7+6XOhXqEL2Qi0FpshIJEjj9dnUtc42cDlZfKGns1JWtjTy9oOsxsgqk6mOmT5hSw6EMp3Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuCTl0L66823f1Lehai2X+Gn62TXazwAx3k2Qt36mpI=;
 b=W1vctnuDUpsB1fX52n0T3KysmQsRGMOw32e1QPIm/nmueadwzI09AiVuW2fDl75rNe4vT6kQoHoIWIw0Lc5K1A4zHHJUYiLHMtwDCOWJC+Y8yXmVZJb5vk6Qiwew89lNOUWlE77fzE7IJTgUpe72o0HbWryBzNg4WTP9Ic5jrPOxgJt2BfCby1c7u/9MnbzjB70vCKX6mqH8obvktTL3Z+eDEE2OsM/9hwg28ujQvaxikU2E5pVRLQYtHB925ONnZaWb1Vr/tOskZEvkhLdvUXolKUrcl06k+xfwxWmyGxJ1dGSn1MeNZnjOql8PV9dsAm8zhB3M4sQxkbT1CTlP7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuCTl0L66823f1Lehai2X+Gn62TXazwAx3k2Qt36mpI=;
 b=gIZ3lb0Kw939gR7TYQQwjHbYw6W5ZKfauNiLVPSq5WRPg/qFnXsFssj/q5zicyZjgNdzaH3B7Rr4RGxNsqD0u6QtwXZ6yUX7XucEGE1xhpo+CaOLMiZrWA7JHYLpRBR8AKl8VnQw9wDFQjo57rDrViC2tPWmowdumnGo5gt2DVM=
Received: from PS1P15301MB0299.APCP153.PROD.OUTLOOK.COM (10.255.66.148) by
 PS1P15301MB0298.APCP153.PROD.OUTLOOK.COM (10.255.66.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.6; Wed, 23 Oct 2019 13:25:58 +0000
Received: from PS1P15301MB0299.APCP153.PROD.OUTLOOK.COM
 ([fe80::41ac:69c6:b45f:9e73]) by PS1P15301MB0299.APCP153.PROD.OUTLOOK.COM
 ([fe80::41ac:69c6:b45f:9e73%6]) with mapi id 15.20.2408.008; Wed, 23 Oct 2019
 13:25:58 +0000
From:   Tianyu Lan <Tianyu.Lan@microsoft.com>
To:     Roman Kagan <rkagan@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V3 2/2] target/i386/kvm: Add Hyper-V direct tlb flush
 support
Thread-Topic: [PATCH V3 2/2] target/i386/kvm: Add Hyper-V direct tlb flush
 support
Thread-Index: AQHVhCK0uxv/9s0vSUWBV7AJKT8CTKdm7S2AgAA1IwCAAMytgA==
Date:   Wed, 23 Oct 2019 13:25:58 +0000
Message-ID: <PS1P15301MB0299744D5DFF0CFE36A85BB8926B0@PS1P15301MB0299.APCP153.PROD.OUTLOOK.COM>
References: <20191016130725.5045-1-Tianyu.Lan@microsoft.com>
 <20191016130725.5045-3-Tianyu.Lan@microsoft.com>
 <7de12770-271e-d386-a105-d53b50aa731f@redhat.com>
 <20191022201418.GA22898@rkaganb.lan>
In-Reply-To: <20191022201418.GA22898@rkaganb.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=tiala@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-23T13:25:52.4312605Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fa76710c-c371-4237-9564-7310c56b470a;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tianyu.Lan@microsoft.com; 
x-originating-ip: [167.220.255.55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d7039d9d-89b9-46e2-43b6-08d757bc8aa9
x-ms-traffictypediagnostic: PS1P15301MB0298:|PS1P15301MB0298:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PS1P15301MB02986C232941681992AEE7ED926B0@PS1P15301MB0298.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(5660300002)(4326008)(66066001)(8990500004)(52536014)(10090500001)(2906002)(86362001)(71190400001)(53546011)(256004)(14444005)(33656002)(71200400001)(9686003)(6246003)(55016002)(25786009)(6436002)(229853002)(6116002)(3846002)(486006)(8676002)(7696005)(102836004)(26005)(74316002)(76176011)(76116006)(8936002)(64756008)(446003)(66946007)(81166006)(476003)(81156014)(11346002)(186003)(66476007)(54906003)(66556008)(66446008)(478600001)(10290500003)(99286004)(305945005)(7736002)(14454004)(22452003)(6506007)(316002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:PS1P15301MB0298;H:PS1P15301MB0299.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NgI4oBmk4HYZyGhA4ew2bgdOcnlvrJIF+srL/benqYtHWVlzdePZ1On+P3p2rNHpnVvYi/uHI2zGvsZ3Hph5aBDnxfVd71RGxOPIpTFpkODvQxmRBDGPsmZCxCietwciyeNrHGL94P9yk+C1qi9tzB8950Eo7nGAA22fH9B9J+RgI8KejTLvYqeCDcIMEkfCpVE4nrORKpY5JJ2TjFk5IjcFeGouC4TEkjYFlCPELKkaIvkLXakCgeHDxaMmqsYwhKDzbTZAO7TnZ4R1MAMucJp3yPaD8aGvucQM4eh1uvFkqaoox5sKIeMofS8o71Ev/hyEf7brQ2SN5v5MDj3UjR+Jp13VAYzwztGfwdNbTURCim/ejVrsERjwrUYYqinmKTP9Ans+j8j5MtFVLZss4wJj8nnU8jy6BWWD2vbjOzeHwQ0vpYh88+T3yai/ll+7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7039d9d-89b9-46e2-43b6-08d757bc8aa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 13:25:58.3823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w5w7NuJxy5zKCushpWDzHgeRn5fVRNM6Uxsh9G+VaYy2QafCkWYxl+eRoIgxYBBLOSb3ef28C/M99Sf7uj8Z5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1P15301MB0298
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Roman:
	Thanks for your review.

> From: Roman Kagan <rkagan@virtuozzo.com>
> Sent: Wednesday, October 23, 2019 4:14 AM
> To: Paolo Bonzini <pbonzini@redhat.com>
> Cc: lantianyu1986@gmail.com; rth@twiddle.net; ehabkost@redhat.com;
> mtosatti@redhat.com; vkuznets <vkuznets@redhat.com>; Tianyu Lan
> <Tianyu.Lan@microsoft.com>; qemu-devel@nongnu.org;
> kvm@vger.kernel.org
> Subject: Re: [PATCH V3 2/2] target/i386/kvm: Add Hyper-V direct tlb flush
> support
>=20
> On Tue, Oct 22, 2019 at 07:04:11PM +0200, Paolo Bonzini wrote:
> > On 16/10/19 15:07, lantianyu1986@gmail.com wrote:
>=20
> Somehow this patch never got through to me so I'll reply here.
>=20
> > > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > >
> > > Hyper-V direct tlb flush targets KVM on Hyper-V guest.
> > > Enable direct TLB flush for its guests meaning that TLB flush
> > > hypercalls are handled by Level 0 hypervisor (Hyper-V) bypassing KVM
> > > in Level 1. Due to the different ABI for hypercall parameters
> > > between Hyper-V and KVM, KVM capabilities should be hidden when
> > > enable Hyper-V direct tlb flush otherwise KVM hypercalls may be
> > > intercepted by Hyper-V. Add new parameter "hv-direct-tlbflush".
> > > Check expose_kvm and Hyper-V tlb flush capability status before
> > > enabling the feature.
> > >
> > > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > > ---
> > > Change sicne v2:
> > >        - Update new feature description and name.
> > >        - Change failure print log.
> > >
> > > Change since v1:
> > >        - Add direct tlb flush's Hyper-V property and use
> > >        hv_cpuid_check_and_set() to check the dependency of tlbflush
> > >        feature.
> > >        - Make new feature work with Hyper-V passthrough mode.
> > > ---
> > >  docs/hyperv.txt   | 10 ++++++++++
> > >  target/i386/cpu.c |  2 ++
> > >  target/i386/cpu.h |  1 +
> > >  target/i386/kvm.c | 24 ++++++++++++++++++++++++
> > >  4 files changed, 37 insertions(+)
> > >
> > > diff --git a/docs/hyperv.txt b/docs/hyperv.txt index
> > > 8fdf25c829..140a5c7e44 100644
> > > --- a/docs/hyperv.txt
> > > +++ b/docs/hyperv.txt
> > > @@ -184,6 +184,16 @@ enabled.
> > >
> > >  Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
> > >
> > > +3.18. hv-direct-tlbflush
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > > +Enable direct TLB flush for KVM when it is running as a nested
> > > +hypervisor on top Hyper-V. When enabled, TLB flush hypercalls from
> > > +L2 guests are being passed through to L0 (Hyper-V) for handling.
> > > +Due to ABI differences between Hyper-V and KVM hypercalls, L2
> > > +guests will not be able to issue KVM hypercalls (as those could be
> > > +mishanled by L0 Hyper-V), this requires KVM hypervisor signature to =
be
> hidden.
> > > +
> > > +Requires: hv-tlbflush, -kvm
> > >
> > >  4. Development features
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > > diff --git a/target/i386/cpu.c b/target/i386/cpu.c index
> > > 44f1bbdcac..7bc7fee512 100644
> > > --- a/target/i386/cpu.c
> > > +++ b/target/i386/cpu.c
> > > @@ -6156,6 +6156,8 @@ static Property x86_cpu_properties[] =3D {
> > >                        HYPERV_FEAT_IPI, 0),
> > >      DEFINE_PROP_BIT64("hv-stimer-direct", X86CPU, hyperv_features,
> > >                        HYPERV_FEAT_STIMER_DIRECT, 0),
> > > +    DEFINE_PROP_BIT64("hv-direct-tlbflush", X86CPU, hyperv_features,
> > > +                      HYPERV_FEAT_DIRECT_TLBFLUSH, 0),
> > >      DEFINE_PROP_BOOL("hv-passthrough", X86CPU, hyperv_passthrough,
> > > false),
> > >
> > >      DEFINE_PROP_BOOL("check", X86CPU, check_cpuid, true), diff
> > > --git a/target/i386/cpu.h b/target/i386/cpu.h index
> > > eaa5395aa5..3cb105f7d6 100644
> > > --- a/target/i386/cpu.h
> > > +++ b/target/i386/cpu.h
> > > @@ -907,6 +907,7 @@ typedef uint64_t
> FeatureWordArray[FEATURE_WORDS];
> > >  #define HYPERV_FEAT_EVMCS               12
> > >  #define HYPERV_FEAT_IPI                 13
> > >  #define HYPERV_FEAT_STIMER_DIRECT       14
> > > +#define HYPERV_FEAT_DIRECT_TLBFLUSH     15
> > >
> > >  #ifndef HYPERV_SPINLOCK_NEVER_RETRY
> > >  #define HYPERV_SPINLOCK_NEVER_RETRY             0xFFFFFFFF
> > > diff --git a/target/i386/kvm.c b/target/i386/kvm.c index
> > > 11b9c854b5..043b66ab22 100644
> > > --- a/target/i386/kvm.c
> > > +++ b/target/i386/kvm.c
> > > @@ -900,6 +900,10 @@ static struct {
> > >          },
> > >          .dependencies =3D BIT(HYPERV_FEAT_STIMER)
> > >      },
> > > +    [HYPERV_FEAT_DIRECT_TLBFLUSH] =3D {
> > > +        .desc =3D "direct paravirtualized TLB flush (hv-direct-tlbfl=
ush)",
> > > +        .dependencies =3D BIT(HYPERV_FEAT_TLBFLUSH)
> > > +    },
> > >  };
> > >
> > >  static struct kvm_cpuid2 *try_get_hv_cpuid(CPUState *cs, int max)
> > > @@ -1224,6 +1228,7 @@ static int hyperv_handle_properties(CPUState
> *cs,
> > >      r |=3D hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_EVMCS);
> > >      r |=3D hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_IPI);
> > >      r |=3D hv_cpuid_check_and_set(cs, cpuid,
> > > HYPERV_FEAT_STIMER_DIRECT);
> > > +    r |=3D hv_cpuid_check_and_set(cs, cpuid,
> > > + HYPERV_FEAT_DIRECT_TLBFLUSH);
>=20
> AFAICS this will turn HYPERV_FEAT_DIRECT_TLBFLUSH on if
> hyperv_passthrough is on, so ...
Yes.
>=20
> > >
> > >      /* Additional dependencies not covered by kvm_hyperv_properties[=
]
> */
> > >      if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC) && @@ -1243,6
> > > +1248,25 @@ static int hyperv_handle_properties(CPUState *cs,
> > >          goto free;
> > >      }
> > >
> > > +    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) ||
> > > +        cpu->hyperv_passthrough) {
>=20
> ... the test for ->hyperv_passthrough is redundant, and ...
>=20
> > > +        if (!cpu->expose_kvm) {
> > > +            r =3D kvm_vcpu_enable_cap(cs,
> KVM_CAP_HYPERV_DIRECT_TLBFLUSH, 0, 0);
> > > +            if (hyperv_feat_enabled(cpu,
> > > + HYPERV_FEAT_DIRECT_TLBFLUSH) && r) {
>=20
> ... , more importantly, this will abort QEMU if
> HYPERV_FEAT_DIRECT_TLBFLUSH wasn't requested explicitly, but was
> activated by ->hyperv_passthrough, and setting the capability failed.  I =
think
> the meaning of hyperv_passthrough is "enable all hyperv features supporte=
d
> by the KVM", so in this case it looks more correct to just clear the feat=
ure bit
> and go ahead.
>=20
> > > +                fprintf(stderr,
> > > +                    "Hyper-V %s is not supported by kernel\n",
> > > +
> kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
> > > +                return -ENOSYS;
> > > +            }
> > > +        } else if (!cpu->hyperv_passthrough) {
> > > +            fprintf(stderr,
> > > +                "Hyper-V %s requires KVM hypervisor signature "
> > > +                "to be hidden (-kvm).\n",
> > > +
> kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
> > > +            return -ENOSYS;
> > > +        }
>=20
> You reach here if ->expose_kvm && ->hyperv_passthrough, and no
> capability is activated, and you go ahead with the feature bit set.
> This doesn't look right either.
>=20
> So in general it should probably look like
>=20
>     if (hyperv_feat_enabled(HYPERV_FEAT_DIRECT_TLBFLUSH)) {
>         if (kvm_vcpu_enable_cap(KVM_CAP_HYPERV_DIRECT_TLBFLUSH)) {
>             if (!cpu->hyperv_passthrough) {
>                 ... report feature unsupported by kernel ...
>                 return -ENOSYS;
>             }
>             cpu->hyperv_features &=3D ~BIT(HYPERV_FEAT_DIRECT_TLBFLUSH);
>         } else if (cpu->expose_kvm) {
>             ... report conflict ...
>             return -ENOSYS;
>         }
>     }
>=20
> [Yes, hyperv_passthrough hurts, but you've been warned ;)]

Yes, you are right, I ignore HYPERV_FEAT_DIRECT_TLBFLUSH bit was set in the=
 hv_cpuid_check_and_set(().
Will update in the next version. Thanks.


>=20
> Thanks,
> Roman.
