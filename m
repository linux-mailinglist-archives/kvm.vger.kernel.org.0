Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED726D1322
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfJIPlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 11:41:51 -0400
Received: from mail-eopbgr820107.outbound.protection.outlook.com ([40.107.82.107]:2148
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729471AbfJIPlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 11:41:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6825v05wRq2WV/gUrzMvlQl/sEF4JB8VJ1O3kmkOO7gvm8k5X/o2VzuIByWIAoGk4Nff8o7eAIRAOrjRTVmeNWcx6GdTlCAGyTM6/Luw3qk81wNJ2/wthuobl8Dk0JNKs+P8VCMTLXpHEnBLXd7tap3N3iMM+X26xD2Co0V90zzUEIXOm3cEqmduvHTnmIWQgkrTxRbFZZ2poE+qvJ8nvcQEIw1ZTZI/PliOft7aPuCmIHcNvT9YFMW8HXL1u6WLdPBmranEdWGJ6gUJPCYidHyR1HgMFwNuw8ErlibQHF4bcpuZJa9ZIAMON705a2QcSGSQWdNDogT6RRLfNTqhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZvdziPe6+cKDNWWFX7y0SFniLkFt2qvM5ncTzsvFfo=;
 b=SV/7HkpKLQUlJDn1UBlabHdF3NNZVpd60qEj6qJ3XHI+h8Wos+1G2q3AOjjEeR02x1khDg1z56hfBuZLXmqO1mW9XweK8taYtX14jfQj5oJ6/MJ5Z1jEVKEvdIWYUlh3Z2/p1QLuUZAOPmLBY3JVqxyR6y/BZ7BV+TRTdC9PFfbyizKK+1UF5GV6bdjWDEmazVLGWCEnHTPrjL+g/sTVJCmATgbF/ZPGDYuAf4NzdotKdrMal3hW3hcNaaCubTwi2fUkLOm0Uj1CNUXrXoJTqCAud8JjvHll6HyxfFng7SMKJ4yXR1wQsaMpKGhZ9jXmPtftvOOrdaNpAo5P5qP4Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZvdziPe6+cKDNWWFX7y0SFniLkFt2qvM5ncTzsvFfo=;
 b=LDcvTEGgB1i1WQpok5mOqznZNG5aXuAW1MFgBcDD56EzaJSSwgeH3/Cm1BHARJ7exPtKdgMb/TCH4e9onmDAGtdrKoQgEfcPniaHcbPzHL3Npn8Uk/nAF5TEdR85AOHGsurTiI1NZHpXpC7l+J54A3mX1hLhTC2H8aoAxPrnmYY=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0778.namprd21.prod.outlook.com (10.173.172.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.4; Wed, 9 Oct 2019 15:41:47 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e%11]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 15:41:47 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>, Roman Kagan <rkagan@virtuozzo.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Joerg Roedel <jroedel@suse.de>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] x86/hyperv: make vapic support x2apic mode
Thread-Topic: [PATCH v3] x86/hyperv: make vapic support x2apic mode
Thread-Index: AQHVfrDkN3MUr0xlFEms4FiPcOct8adSbqIAgAADTaA=
Date:   Wed, 9 Oct 2019 15:41:46 +0000
Message-ID: <DM5PR21MB0137FF88DDA803A2A383B20BD7950@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <20191009145022.28442-1-rkagan@virtuozzo.com>
 <87r23mx7lh.fsf@vitty.brq.redhat.com>
In-Reply-To: <87r23mx7lh.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-09T15:41:44.9226580Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a135cf7c-30a6-4cf5-982b-2cc681e9e102;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [2001:4898:80e8:3:8162:b7c1:8631:b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5bc5e01-158e-4d1a-1295-08d74ccf31a4
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR21MB0778:|DM5PR21MB0778:|DM5PR21MB0778:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB07786B1DAED36DF4354452ADD7950@DM5PR21MB0778.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(199004)(189003)(7736002)(5660300002)(55016002)(305945005)(99286004)(2906002)(7696005)(74316002)(6116002)(256004)(22452003)(14444005)(110136005)(54906003)(229853002)(6436002)(10290500003)(81166006)(4326008)(8936002)(8676002)(81156014)(52536014)(6246003)(316002)(9686003)(14454004)(478600001)(33656002)(66556008)(76116006)(66476007)(25786009)(186003)(102836004)(64756008)(66446008)(6506007)(66946007)(86362001)(8990500004)(7416002)(10090500001)(76176011)(71200400001)(486006)(71190400001)(446003)(46003)(11346002)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0778;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kLJoZDzPkwF70akO1h2ZajXK9wSmvwQZ0z6huEdapCSdrPpJ4cSTSNWS77q6/xNvdvMWf1H6uAjDjI/CMh/TRhRTU4+5FCWuT1wovb60cDlsaztv24RwLvlK/yWi+6F/BLP8FafqT5CAB1e7VDXOc+aVMQjOYK9xYrfQvWihDAQSC4GvvJZgTrV7VKsrdi6xAZOpjacfDgPBOovuk/XV5P+kiURIlMNe4X7OmXb7emQIKwzfR7/d+pGlJyNs8lOoooB3MbpAqCRN1GplTIH+bWcTQ7Rga2/8HiV9ifihoaoar0p1zm4nAFnbbnNNv/9wKpIALYVApp0o7fA6zqosinaZnbwouqsVSpcMtQJIOqUoeziuRGIgJsGBD/YgqlZp7vQ71ZP3wb2pgejqIKrA9mNZJGbi0fI7QN691YPDr40=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5bc5e01-158e-4d1a-1295-08d74ccf31a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 15:41:47.0242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z9bA1y3jwVWhH/fSp7H70wSSN5fcXeFRo9HiBBPEm65ETQ5uA8TNmt2Ws+43bsk+UmbAzoQQBZtdR/RP8bM/JodMcQBwcJTQ9TsQL0sJCdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0778
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Wednesday, October 9, 20=
19 8:27 AM
>=20
> Roman Kagan <rkagan@virtuozzo.com> writes:
>=20
> > Now that there's Hyper-V IOMMU driver, Linux can switch to x2apic mode
> > when supported by the vcpus.
> >
> > However, the apic access functions for Hyper-V enlightened apic assume
> > xapic mode only.
> >
> > As a result, Linux fails to bring up secondary cpus when run as a guest
> > in QEMU/KVM with both hv_apic and x2apic enabled.
> >
> > According to Michael Kelley, when in x2apic mode, the Hyper-V synthetic
> > apic MSRs behave exactly the same as the corresponding architectural
> > x2apic MSRs, so there's no need to override the apic accessors.  The
> > only exception is hv_apic_eoi_write, which benefits from lazy EOI when
> > available; however, its implementation works for both xapic and x2apic
> > modes.
> >
> > Fixes: 29217a474683 ("iommu/hyper-v: Add Hyper-V stub IOMMU driver")
> > Fixes: 6b48cb5f8347 ("X86/Hyper-V: Enlighten APIC access")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Michael Kelley <mikelley@microsoft.com>
> > Signed-off-by: Roman Kagan <rkagan@virtuozzo.com>
> > ---
> > v2 -> v3:
> > - do not introduce x2apic-capable hv_apic accessors; leave original
> >   x2apic accessors instead
> >
> > v1 -> v2:
> > - add ifdefs to handle !CONFIG_X86_X2APIC
> >
> >  arch/x86/hyperv/hv_apic.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> > index 5c056b8aebef..26eeff5bd535 100644
> > --- a/arch/x86/hyperv/hv_apic.c
> > +++ b/arch/x86/hyperv/hv_apic.c
> > @@ -261,10 +261,19 @@ void __init hv_apic_init(void)
> >
> >  	if (ms_hyperv.hints & HV_X64_APIC_ACCESS_RECOMMENDED) {
> >  		pr_info("Hyper-V: Using MSR based APIC access\n");
>=20
> This pr_info() becomes a bit misleading in x2apic mode, maybe do
> something like
>=20
> pr_info("Hyper-V: using Enlightened APIC (%s mode)",
>         x2apic_enabled() ? "x2apic" : "xapic");

Yes, I like this.  But tweak the capitalization of the message:

pr_info("Hyper-V: Using enlightened APIC (%s mode)",

>=20
> > +		/*
> > +		 * With x2apic, architectural x2apic MSRs are equivalent to the
> > +		 * respective synthetic MSRs, so there's no need to override
> > +		 * the apic accessors.  The only exception is
> > +		 * hv_apic_eoi_write, because it benefits from lazy EOI when
> > +		 * available, but it works for both xapic and x2apic modes.
> > +		 */
> >  		apic_set_eoi_write(hv_apic_eoi_write);
> > -		apic->read      =3D hv_apic_read;
> > -		apic->write     =3D hv_apic_write;
> > -		apic->icr_write =3D hv_apic_icr_write;
> > -		apic->icr_read  =3D hv_apic_icr_read;
> > +		if (!x2apic_enabled()) {
> > +			apic->read      =3D hv_apic_read;
> > +			apic->write     =3D hv_apic_write;
> > +			apic->icr_write =3D hv_apic_icr_write;
> > +			apic->icr_read  =3D hv_apic_icr_read;
> > +		}
> >  	}
> >  }
>=20
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>=20
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
