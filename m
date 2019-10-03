Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850F0C9EE1
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 14:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbfJCMwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 08:52:53 -0400
Received: from mail-bgr052101131032.outbound.protection.outlook.com ([52.101.131.32]:39553
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729086AbfJCMww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 08:52:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3dxoCwKnakPX/cHiy5q7cCRX7526ywWOvOoja8ykhqbMgn1vml4boUeAT902XyvisWbcul2wIRojUXViINQw8RroMkwxOF1SLREbIHnGA+fSLWkKvnd24Mrwh08aKjrMJDwlD3sfRtCxw/dbjo9m4j24vDAjaH7oB5GQAqUtXFWnsf9YUc0oaE7919LThfNDULlFnJbFBJLNS9nhbUgy4BaaTifInN3lbwKoGhXlhnLH/Xq9SDifHR0jE9sSc27/vPbBQgZr2n0CH+LGSZB6wor+aC/g/woRIPAgG508t4rvL0bbYA0Y5+FZi0ZSJ6NOB64BI5eRPeAtJslfbQIRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFMB/SKgwhjXozDHCjtqyx342Yknn75zOMDN2A2bwM0=;
 b=iDGWAkd13fGGceQMnfHu9JNTWPjL6isiU6URHsrP2qBGTs5wB2a8RpTPX7kQtarpIZYM93Ij59GSd40jbd3+8seC+TBEu5Y2iYnLKSnhWURLS7oXGMmhzkjep2iACprOxvknbwPso7hQPPZdCETzZHsffhaFyMgzW9ST7LxzJAkI6RXGNbgzolPdy+qRQcG+Waw5Wpwb9V8eTVD+/ZWXv9nr0Bo7Xr4ujOFmSWM+FZzOww2ubF+VHtNR3Qa7xjca3LeYx6DWWp7MmsucU+6X8sMyIQAkmVeZOUTUacasRrpIaafN8SD2WdcMcGRPZ7s23Gpx8VG4QaJ3ZW2WTyE6Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFMB/SKgwhjXozDHCjtqyx342Yknn75zOMDN2A2bwM0=;
 b=fQyfTiqGw3tWNaTEhPsSPk5YsqEB2N0X+lh4yNmDswAto/76XEVmRype0FRuK6abr1yy4HWizPuv9Ldoajbq7XQH47Q/fbcDXLyBw1nQM3S5dKNj5zKZfjfeUCYHZqAFZiM0OnoFzcnvGGnsy//+JB7GBthC7yhwgZ9wWPzyGdc=
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com (20.179.36.87) by
 AM0PR08MB4321.eurprd08.prod.outlook.com (20.179.33.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 12:52:39 +0000
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3]) by AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 12:52:39 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Joerg Roedel <jroedel@suse.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86/hyperv: make vapic support x2apic mode
Thread-Topic: [PATCH v2] x86/hyperv: make vapic support x2apic mode
Thread-Index: AQHVeQrgrl6z6kaUqkyr6D3zFBAn2KdIv6eAgAAhHwA=
Date:   Thu, 3 Oct 2019 12:52:39 +0000
Message-ID: <20191003125236.GA2424@rkaganb.sw.ru>
References: <20191002101923.4981-1-rkagan@virtuozzo.com>
 <87muei14ms.fsf@vitty.brq.redhat.com>
In-Reply-To: <87muei14ms.fsf@vitty.brq.redhat.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: Roman Kagan <rkagan@virtuozzo.com>,   Vitaly Kuznetsov
 <vkuznets@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,    Michael
 Kelley <mikelley@microsoft.com>,       Lan Tianyu <Tianyu.Lan@microsoft.com>,  Joerg
 Roedel <jroedel@suse.de>,      "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang
 Zhang <haiyangz@microsoft.com>,        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,        Thomas Gleixner <tglx@linutronix.de>,   Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,     "H. Peter Anvin"
 <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1PR08CA0078.eurprd08.prod.outlook.com
 (2603:10a6:7:2a::49) To AM0PR08MB5537.eurprd08.prod.outlook.com
 (2603:10a6:208:148::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19f560dd-35aa-4b00-2c85-08d7480092a5
x-ms-traffictypediagnostic: AM0PR08MB4321:|AM0PR08MB4321:|AM0PR08MB4321:
x-microsoft-antispam-prvs: <AM0PR08MB43210ED23AC679D787FD5137C99F0@AM0PR08MB4321.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(376002)(396003)(366004)(136003)(346002)(39830400003)(189003)(199004)(86362001)(102836004)(76176011)(7416002)(6246003)(8936002)(4326008)(66066001)(25786009)(305945005)(14454004)(8676002)(229853002)(9686003)(6512007)(6436002)(6486002)(478600001)(81166006)(81156014)(6916009)(7736002)(256004)(66556008)(66476007)(66446008)(36756003)(66946007)(33656002)(64756008)(2906002)(486006)(316002)(58126008)(54906003)(99286004)(6116002)(3846002)(14444005)(5660300002)(1076003)(476003)(52116002)(11346002)(26005)(386003)(6506007)(71190400001)(71200400001)(186003)(446003)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:AM0PR08MB4321;H:AM0PR08MB5537.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-transport-forked: True
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TjI9/LbzaqUTXFMH4NOopvw23+sX445Vf1pikL2i2QIYPqvV1kzO2lL/owH1z+SQpa9ieHkkzQ4xAOYUG1cHUxyJCapaf4Y5qSMpaPiRA2BVXeqomzCadxVN9b4C9ICSjwcWXw0NOKx0BzV+nlq10I4WeCQMxHXd5DcxWbL46AYAuyCPjQBsiI9vi9Ium2V8/Bbcc5Ce0mFPW8HfVQyps4jW0VEvAfMv/JZECvFNNzWfBWDEOyzjren92vIMW9Dy1IFncFOijvb5wRYSQq7Amu5sek7nKTr0yNp1tJQehTWrN3TJ0wZvE9gYxAKQWFonvAgxicIbhuPITA3ggIcVMGYx12/B5krvAreAwrv3Ywt5n1kD4tl1HwDHfHvGU+UE7AKXMujXnRTkiNTtLGBsVRQCIoJFX1BnA10CNje9+VvSlCaqADCIeZc9csxtaNYI758kzT4+Q8FqUHc/zazszlKJKtleIHvhyj66ll3StpANy0+UcPlkx2JPgQk+6V71
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7B19018AE6A6374F866DBB575EF2F96F@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f560dd-35aa-4b00-2c85-08d7480092a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 12:52:39.6601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TmPezP5kS/FtM2Js+H2BsnnZm2AOW7e5mTFMgZ/Exow+x2pK2ZodNlbUo97feS9GpHbr+vzADHue/Z6j5YUa+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4321
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 03, 2019 at 12:54:03PM +0200, Vitaly Kuznetsov wrote:
> Roman Kagan <rkagan@virtuozzo.com> writes:
> 
> > Now that there's Hyper-V IOMMU driver, Linux can switch to x2apic mode
> > when supported by the vcpus.
> >
> > However, the apic access functions for Hyper-V enlightened apic assume
> > xapic mode only.
> >
> > As a result, Linux fails to bring up secondary cpus when run as a guest
> > in QEMU/KVM with both hv_apic and x2apic enabled.
> >
> > I didn't manage to make my instance of Hyper-V expose x2apic to the
> > guest; nor does Hyper-V spec document the expected behavior.  However,
> > a Windows guest running in QEMU/KVM with hv_apic and x2apic and a big
> > number of vcpus (so that it turns on x2apic mode) does use enlightened
> > apic MSRs passing unshifted 32bit destination id and falls back to the
> > regular x2apic MSRs for less frequently used apic fields.
> >
> > So implement the same behavior, by replacing enlightened apic access
> > functions (only those where it makes a difference) with their
> > x2apic-aware versions when x2apic is in use.
> >
> > Fixes: 29217a474683 ("iommu/hyper-v: Add Hyper-V stub IOMMU driver")
> > Fixes: 6b48cb5f8347 ("X86/Hyper-V: Enlighten APIC access")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Roman Kagan <rkagan@virtuozzo.com>
> > ---
> > v1 -> v2:
> > - add ifdefs to handle !CONFIG_X86_X2APIC
> >
> >  arch/x86/hyperv/hv_apic.c | 54 ++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 51 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> > index 5c056b8aebef..eb1434ae9e46 100644
> > --- a/arch/x86/hyperv/hv_apic.c
> > +++ b/arch/x86/hyperv/hv_apic.c
> > @@ -84,6 +84,44 @@ static void hv_apic_write(u32 reg, u32 val)
> >  	}
> >  }
> >  
> > +#ifdef CONFIG_X86_X2APIC
> > +static void hv_x2apic_icr_write(u32 low, u32 id)
> > +{
> > +	wrmsr(HV_X64_MSR_ICR, low, id);
> > +}
> 
> AFAIU you're trying to mirror native_x2apic_icr_write() here but this is
> different from what hv_apic_icr_write() does
> (SET_APIC_DEST_FIELD(id)).

Right.  In xapic mode the ICR2 aka the high 4 bytes of ICR is programmed
with the destination id in the highest byte; in x2apic mode the whole
ICR2 is set to the 32bit destination id.

> Is it actually correct? (I think you've tested this and it is but)

As I wrote in the commit log, I haven't tested it in the sense that I
ran a Linux guest in a Hyper-V VM exposing x2apic to the guest, because
I didn't manage to configure it to do so.  OTOH I did run a Windows
guest in QEMU/KVM with hv_apic and x2apic enabled and saw it write
destination ids unshifted to the ICR2 part of ICR, so I assume it's
correct.

> Michael, could you please shed some light here?

Would be appreciated, indeed.

> > +static u32 hv_x2apic_read(u32 reg)
> > +{
> > +	u32 reg_val, hi;
> > +
> > +	switch (reg) {
> > +	case APIC_EOI:
> > +		rdmsr(HV_X64_MSR_EOI, reg_val, hi);
> > +		return reg_val;
> > +	case APIC_TASKPRI:
> > +		rdmsr(HV_X64_MSR_TPR, reg_val, hi);
> > +		return reg_val;
> > +
> > +	default:
> > +		return native_apic_msr_read(reg);
> > +	}
> > +}
> > +
> > +static void hv_x2apic_write(u32 reg, u32 val)
> > +{
> > +	switch (reg) {
> > +	case APIC_EOI:
> > +		wrmsr(HV_X64_MSR_EOI, val, 0);
> > +		break;
> > +	case APIC_TASKPRI:
> > +		wrmsr(HV_X64_MSR_TPR, val, 0);
> > +		break;
> > +	default:
> > +		native_apic_msr_write(reg, val);
> > +	}
> > +}
> > +#endif /* CONFIG_X86_X2APIC */
> > +
> >  static void hv_apic_eoi_write(u32 reg, u32 val)
> >  {
> >  	struct hv_vp_assist_page *hvp = hv_vp_assist_page[smp_processor_id()];
> > @@ -262,9 +300,19 @@ void __init hv_apic_init(void)
> >  	if (ms_hyperv.hints & HV_X64_APIC_ACCESS_RECOMMENDED) {
> >  		pr_info("Hyper-V: Using MSR based APIC access\n");
> >  		apic_set_eoi_write(hv_apic_eoi_write);
> > -		apic->read      = hv_apic_read;
> > -		apic->write     = hv_apic_write;
> > -		apic->icr_write = hv_apic_icr_write;
> > +#ifdef CONFIG_X86_X2APIC
> > +		if (x2apic_enabled()) {
> > +			apic->read      = hv_x2apic_read;
> > +			apic->write     = hv_x2apic_write;
> > +			apic->icr_write = hv_x2apic_icr_write;
> > +		} else {
> > +#endif
> > +			apic->read      = hv_apic_read;
> > +			apic->write     = hv_apic_write;
> > +			apic->icr_write = hv_apic_icr_write;
> 
> (just wondering): Is it always safe to assume that we cannot switch
> between apic_flat/x2apic in runtime?

I guess so.  All apic choices are made early at __init, obviously before
the secondary CPUs are brought up, and aren't reconsidered afterwards.

> Moreover, the only difference
> between hv_apic_read/hv_apic_write and hv_x2apic_read/hv_x2apic_write is
> native_apic_mem_{read,write} -> native_apic_msr_{read,write}. Would it
> make sense to move if (x2apic_enabled()) and merge these functions?

x2apic_enabled() is too heavy for that: it reads MSR_IA32_APICBASE.  One
could probably use a read-mostly global variable instead but I'm not
sure it would make the code better.

Thanks,
Roman.
