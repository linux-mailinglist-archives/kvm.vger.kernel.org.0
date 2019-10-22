Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A14E0D2B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 22:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388941AbfJVUQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 16:16:10 -0400
Received: from mail-eopbgr10108.outbound.protection.outlook.com ([40.107.1.108]:21054
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387769AbfJVUQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 16:16:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C64gdMUoNVBdzhk+Ms1Jre9+XZU8nIxrkNi9mHR8hnV+XJ6SGyBCGYBb7VA9xshdSuzx1nSJeIJuNG7xBXiLQQv56Tc4Ym1CfglwhtfR7SrD42yTevTv/LwLlj1GrnCiCtuBBv2aKvXQnqaL6qJ3QH2VS+quRFOBbuxWHSrMLVensBxWbOPuUqyu1s+KD/R3zA2Is4JZ/xytvTEL6jAnuIUK657M35KsAB00nw/tTANz5RTrUZklY0uIX3LngdOx8QaW4xiLfv6yLsn6t4S6kJZJzwMp4Jwdzxe14i27EaKFHnwxem7Zs6eKmqqABOvQXAE9yBroLRV9e7OJnSBobQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNlkmzqlND4Rn+U4S11qz8zkaikb1s42tPN4dJxx3Sw=;
 b=e+MlbDnDn4QvOLrctl+Yxd8KTEKbQ+rE/JsSNErw+Lu3BlBk1G48TyuA7cULZm7B/k9/sonOpIQL2OiRTrd9KNrs4LpzVkQjNBjg8toMEXfEqn66pVOvdeAHkUj3pVegiFqyejwm9o2XiOdQz03fEAyzJzIWYvFoYuPFLldVWWI+N5UO3iexzE9FsvTG+Awo7JmkREIs3MDexdJiuBJM8W4571g4Qv0KkKV1PSJGwMzJje6o/H+fmmcSGKo5HMVPYylDoF7pkAZ+TlkyMiSu+ZVcTf2mbUb37vd+K5uD1TjaYD3h/LmvpUkZpeMgkmnDnyrShabUkdfUl/gI+SNGvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNlkmzqlND4Rn+U4S11qz8zkaikb1s42tPN4dJxx3Sw=;
 b=h8tvCskx13HsaSxyrPZJ3smaMBATMzgimZfCCJ+0mfjynvwuN4+n7QE9Ov4TbS0cmVcITnzHwn2+Bqg1KY7C9/X0ZYkdgBTfpOfuvR+9i7WyQ8CjK2CsShVl29vaRS6wGz9v2oKH2g3Lh68Q/a6pw+EjuMlAd+L5R8bDSGq4M20=
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com (10.172.218.15) by
 AM4SPR00MB255.eurprd08.prod.outlook.com (10.172.222.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Tue, 22 Oct 2019 20:14:23 +0000
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89]) by AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89%12]) with mapi id 15.20.2367.022; Tue, 22 Oct 2019
 20:14:22 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V3 2/2] target/i386/kvm: Add Hyper-V direct tlb flush
 support
Thread-Topic: [PATCH V3 2/2] target/i386/kvm: Add Hyper-V direct tlb flush
 support
Thread-Index: AQHViPq9L0UIUHrgOUK3MhLOvsKcSqdnGJsA
Date:   Tue, 22 Oct 2019 20:14:22 +0000
Message-ID: <20191022201418.GA22898@rkaganb.lan>
References: <20191016130725.5045-1-Tianyu.Lan@microsoft.com>
 <20191016130725.5045-3-Tianyu.Lan@microsoft.com>
 <7de12770-271e-d386-a105-d53b50aa731f@redhat.com>
In-Reply-To: <7de12770-271e-d386-a105-d53b50aa731f@redhat.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: Roman Kagan <rkagan@virtuozzo.com>,   Paolo Bonzini
 <pbonzini@redhat.com>, lantianyu1986@gmail.com,        rth@twiddle.net,
 ehabkost@redhat.com, mtosatti@redhat.com,      vkuznets@redhat.com, Tianyu Lan
 <Tianyu.Lan@microsoft.com>,    qemu-devel@nongnu.org, kvm@vger.kernel.org
x-originating-ip: [2a02:2168:9049:de00::6b9]
x-clientproxiedby: HE1PR0701CA0053.eurprd07.prod.outlook.com
 (2603:10a6:3:9e::21) To AM4PR0802MB2242.eurprd08.prod.outlook.com
 (2603:10a6:200:5f::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea16e9b8-1e12-4c13-4afe-08d7572c6d84
x-ms-traffictypediagnostic: AM4SPR00MB255:
x-microsoft-antispam-prvs: <AM4SPR00MB2559512519F9CE277BDBF63C9680@AM4SPR00MB255.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(39850400004)(366004)(376002)(189003)(199004)(76176011)(446003)(52116002)(54906003)(11346002)(1076003)(71200400001)(25786009)(46003)(186003)(6116002)(81156014)(8936002)(81166006)(8676002)(5660300002)(99286004)(316002)(58126008)(102836004)(386003)(476003)(6506007)(53546011)(486006)(7736002)(305945005)(229853002)(66476007)(66946007)(6916009)(66556008)(33656002)(2906002)(86362001)(14444005)(36756003)(478600001)(14454004)(4326008)(71190400001)(64756008)(66446008)(256004)(6436002)(6512007)(6486002)(9686003)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM4SPR00MB255;H:AM4PR0802MB2242.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vM9HIxsFQSNlxxoqXA8gqM9KC3r/66tY4soRwYV6yBlrBSCtnd9vi86Ll8017O5bLUusLv/g8ly0GkhQC+kORuQtilpJBqDR9mH8ZY9ysGzJt3u/UPgRhwq9BIRa2baTwq6kl4/2kzy8RbajPflBonbiLDov48AZ4JiQoDpIgzASu/7sTraqQZ1hThLNx68NAFQsmKdTiN3xDF6MCk52GOLWjI+JLMz45kMUD+dj7yMPN0MbMCGqPfdBn2xTnJ10yL3L+JVb85gTArBcOHGWCD9OxC0UgRT4IgBs8p29LVKi6hdGFtvoujOgNqIxRSw8xxApPgg8w/h+fxt+jQFcEj50NJG4hWA4qgwYS2LjSuJUtArcxtyDfhuzpnLZBkNZCtbtTfBd9B1DzfZVeLx3A2Ef6oWwx9RGAXP3uqTeIYgHt/rlKUKE42n1VhCdMF27
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6901AD42C8F614395399F7AABD9A5AF@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea16e9b8-1e12-4c13-4afe-08d7572c6d84
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 20:14:22.7806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OyzuNzglEiO9ZEg7iIXRQEZcqX4c1aykIAQvDLziaw+gQ1E9E2SZo04Kuqz4b/FNZMj8vKOldGr3GwEJ0oU+rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4SPR00MB255
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 07:04:11PM +0200, Paolo Bonzini wrote:
> On 16/10/19 15:07, lantianyu1986@gmail.com wrote:

Somehow this patch never got through to me so I'll reply here.

> > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > 
> > Hyper-V direct tlb flush targets KVM on Hyper-V guest.
> > Enable direct TLB flush for its guests meaning that TLB
> > flush hypercalls are handled by Level 0 hypervisor (Hyper-V)
> > bypassing KVM in Level 1. Due to the different ABI for hypercall
> > parameters between Hyper-V and KVM, KVM capabilities should be
> > hidden when enable Hyper-V direct tlb flush otherwise KVM
> > hypercalls may be intercepted by Hyper-V. Add new parameter
> > "hv-direct-tlbflush". Check expose_kvm and Hyper-V tlb flush
> > capability status before enabling the feature.
> > 
> > Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > ---
> > Change sicne v2:
> >        - Update new feature description and name.
> >        - Change failure print log.
> > 
> > Change since v1:
> >        - Add direct tlb flush's Hyper-V property and use
> >        hv_cpuid_check_and_set() to check the dependency of tlbflush
> >        feature.
> >        - Make new feature work with Hyper-V passthrough mode.
> > ---
> >  docs/hyperv.txt   | 10 ++++++++++
> >  target/i386/cpu.c |  2 ++
> >  target/i386/cpu.h |  1 +
> >  target/i386/kvm.c | 24 ++++++++++++++++++++++++
> >  4 files changed, 37 insertions(+)
> > 
> > diff --git a/docs/hyperv.txt b/docs/hyperv.txt
> > index 8fdf25c829..140a5c7e44 100644
> > --- a/docs/hyperv.txt
> > +++ b/docs/hyperv.txt
> > @@ -184,6 +184,16 @@ enabled.
> >  
> >  Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
> >  
> > +3.18. hv-direct-tlbflush
> > +=======================
> > +Enable direct TLB flush for KVM when it is running as a nested
> > +hypervisor on top Hyper-V. When enabled, TLB flush hypercalls from L2
> > +guests are being passed through to L0 (Hyper-V) for handling. Due to ABI
> > +differences between Hyper-V and KVM hypercalls, L2 guests will not be
> > +able to issue KVM hypercalls (as those could be mishanled by L0
> > +Hyper-V), this requires KVM hypervisor signature to be hidden.
> > +
> > +Requires: hv-tlbflush, -kvm
> >  
> >  4. Development features
> >  ========================
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 44f1bbdcac..7bc7fee512 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -6156,6 +6156,8 @@ static Property x86_cpu_properties[] = {
> >                        HYPERV_FEAT_IPI, 0),
> >      DEFINE_PROP_BIT64("hv-stimer-direct", X86CPU, hyperv_features,
> >                        HYPERV_FEAT_STIMER_DIRECT, 0),
> > +    DEFINE_PROP_BIT64("hv-direct-tlbflush", X86CPU, hyperv_features,
> > +                      HYPERV_FEAT_DIRECT_TLBFLUSH, 0),
> >      DEFINE_PROP_BOOL("hv-passthrough", X86CPU, hyperv_passthrough, false),
> >  
> >      DEFINE_PROP_BOOL("check", X86CPU, check_cpuid, true),
> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index eaa5395aa5..3cb105f7d6 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > @@ -907,6 +907,7 @@ typedef uint64_t FeatureWordArray[FEATURE_WORDS];
> >  #define HYPERV_FEAT_EVMCS               12
> >  #define HYPERV_FEAT_IPI                 13
> >  #define HYPERV_FEAT_STIMER_DIRECT       14
> > +#define HYPERV_FEAT_DIRECT_TLBFLUSH     15
> >  
> >  #ifndef HYPERV_SPINLOCK_NEVER_RETRY
> >  #define HYPERV_SPINLOCK_NEVER_RETRY             0xFFFFFFFF
> > diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> > index 11b9c854b5..043b66ab22 100644
> > --- a/target/i386/kvm.c
> > +++ b/target/i386/kvm.c
> > @@ -900,6 +900,10 @@ static struct {
> >          },
> >          .dependencies = BIT(HYPERV_FEAT_STIMER)
> >      },
> > +    [HYPERV_FEAT_DIRECT_TLBFLUSH] = {
> > +        .desc = "direct paravirtualized TLB flush (hv-direct-tlbflush)",
> > +        .dependencies = BIT(HYPERV_FEAT_TLBFLUSH)
> > +    },
> >  };
> >  
> >  static struct kvm_cpuid2 *try_get_hv_cpuid(CPUState *cs, int max)
> > @@ -1224,6 +1228,7 @@ static int hyperv_handle_properties(CPUState *cs,
> >      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_EVMCS);
> >      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_IPI);
> >      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_STIMER_DIRECT);
> > +    r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_DIRECT_TLBFLUSH);

AFAICS this will turn HYPERV_FEAT_DIRECT_TLBFLUSH on if
hyperv_passthrough is on, so ...

> >  
> >      /* Additional dependencies not covered by kvm_hyperv_properties[] */
> >      if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC) &&
> > @@ -1243,6 +1248,25 @@ static int hyperv_handle_properties(CPUState *cs,
> >          goto free;
> >      }
> >  
> > +    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) ||
> > +        cpu->hyperv_passthrough) {

... the test for ->hyperv_passthrough is redundant, and ...

> > +        if (!cpu->expose_kvm) {
> > +            r = kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_DIRECT_TLBFLUSH, 0, 0);
> > +            if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH) && r) {

... , more importantly, this will abort QEMU if
HYPERV_FEAT_DIRECT_TLBFLUSH wasn't requested explicitly, but was
activated by ->hyperv_passthrough, and setting the capability failed.  I
think the meaning of hyperv_passthrough is "enable all hyperv features
supported by the KVM", so in this case it looks more correct to just
clear the feature bit and go ahead.

> > +                fprintf(stderr,
> > +                    "Hyper-V %s is not supported by kernel\n",
> > +                    kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
> > +                return -ENOSYS;
> > +            }
> > +        } else if (!cpu->hyperv_passthrough) {
> > +            fprintf(stderr,
> > +                "Hyper-V %s requires KVM hypervisor signature "
> > +                "to be hidden (-kvm).\n",
> > +                kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
> > +            return -ENOSYS;
> > +        }

You reach here if ->expose_kvm && ->hyperv_passthrough, and no
capability is activated, and you go ahead with the feature bit set.
This doesn't look right either.

So in general it should probably look like

    if (hyperv_feat_enabled(HYPERV_FEAT_DIRECT_TLBFLUSH)) {
        if (kvm_vcpu_enable_cap(KVM_CAP_HYPERV_DIRECT_TLBFLUSH)) {
            if (!cpu->hyperv_passthrough) {
                ... report feature unsupported by kernel ...
                return -ENOSYS;
            }
            cpu->hyperv_features &= ~BIT(HYPERV_FEAT_DIRECT_TLBFLUSH);
        } else if (cpu->expose_kvm) {
            ... report conflict ...
            return -ENOSYS;
        }
    }

[Yes, hyperv_passthrough hurts, but you've been warned ;)]

Thanks,
Roman.
