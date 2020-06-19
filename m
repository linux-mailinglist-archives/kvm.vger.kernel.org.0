Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743A5200504
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 11:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbgFSJaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 05:30:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:15980 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729842AbgFSJaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 05:30:10 -0400
IronPort-SDR: Y8Ca/is27NlL7lDRtMD5cP5qFeMwhYb9UfPOEfvv5r7X1+rYnfb52uzDtOUxefO6ge1a/Jo1tp
 jHNrD19z5WOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="227588177"
X-IronPort-AV: E=Sophos;i="5.75,254,1589266800"; 
   d="scan'208";a="227588177"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2020 02:30:09 -0700
IronPort-SDR: IIFx2t4iR+8bPGJhrxIWx8UKarBhwVRmadism7GHXw/sKftHXAXdHSGm7HFpk2orDtNEuVzkKd
 hcBfrDtwQZBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,254,1589266800"; 
   d="scan'208";a="318070362"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jun 2020 02:30:09 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jun 2020 02:30:09 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx158.amr.corp.intel.com (10.18.116.75) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jun 2020 02:30:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 19 Jun 2020 02:30:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkDQdjJORKJeEwyJmu4X6MNq6bs1BZDwydhcUyZCaBJIP2JZiLyKE/w7I4Uhq1muE+v0NSz8lf2m4L0crS6Z5KVAWj27zPX+j5lOKuNZQO//YreOx0/b+G2n02XSrsLmZYr3umY0LJKYfRgDOAxCYUi+L9xvH70JXARORyacfXERnZTyEnatY6wdvxRDLrNdKJ4G0yxyVUxWytU0d85Ck972Vzhf1CDoPP1L9PZfgPXl9jM5iWlNuH3wn4yI6lWpOx6CQ+Txh/O2MqSY1/IYZqdB5vT8qqs6/d+xtjBel0XYAguO+8wAhAA35fE/TQRCZh3n+7NbUIKyoQ42jJpFkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2pBI6MktaVJSUg3k2Q12oz3tR69JzTDIIMYtfqjCOg=;
 b=iX2/fQcVLGFOpF/KYLn3/5xEGpbq/dQwveLlWWN5fRyhowJHcQEKRMUP/b0y9BN4hCuOoE6Nr0CtH6eLOWEID9RlMUFLLpDl6TWadnby6FjY1bCv1nc633c+DTxy9MN9Ht3WoF2l3hPX5nTldLMtD24v1AtKflXjY8Woya6rhySEvR6UUuwmjgMhC6R3DGg4QVIZjv8s7Zxi5STMCml4mlqhMzDuX+SrAQcoREBC7mzkHjSQOT/aVtxO37OY7/CJ2sOpxwX0beffFqxTOWg8UzmesfkOi0anUUpnnvjydSb+jMg8eFhfcYbyx7DmKNHoxdOQUNcK3WMXMw2MbbKwFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2pBI6MktaVJSUg3k2Q12oz3tR69JzTDIIMYtfqjCOg=;
 b=wULh9TI0iazbXgxDwhd6DHvlRfUmF3cYqaSKVjRaNsFNtYw0B3kerNGNTPsCQcfU1rbrIX+DshzmgIWFXaOpjIoIfIN3aH6Q8/NL4anixgl1Xc2HTYq17k4lDy5tTGZFljDZaVrJgdmkBlrZBSxHolTcu9ik4qy2UA2l3PGub2g=
Received: from DM5PR1101MB2266.namprd11.prod.outlook.com (2603:10b6:4:57::17)
 by DM5PR11MB1308.namprd11.prod.outlook.com (2603:10b6:3:e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.21; Fri, 19 Jun 2020 09:30:06 +0000
Received: from DM5PR1101MB2266.namprd11.prod.outlook.com
 ([fe80::b07e:e40:d34e:b601]) by DM5PR1101MB2266.namprd11.prod.outlook.com
 ([fe80::b07e:e40:d34e:b601%6]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 09:30:06 +0000
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Liang, Kan" <kan.liang@linux.intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>
Subject: RE: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a dedicated
 counter for guest PEBS
Thread-Topic: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a
 dedicated counter for guest PEBS
Thread-Index: AQHV8tS2uZDJ2Dgk6EqR/a2HW+9LbKg7EWeAgAAN1ICABGlOgIAANIUAgAAfgACAlQF+kIALdHMQ
Date:   Fri, 19 Jun 2020 09:30:06 +0000
Message-ID: <DM5PR1101MB22663D2305EAC6A3D00F239580980@DM5PR1101MB2266.namprd11.prod.outlook.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
 <20200309100443.GG12561@hirez.programming.kicks-ass.net>
 <97ce1ba4-d75a-8db2-ea2f-7d334942b4e6@linux.intel.com>
 <20200309150526.GI12561@hirez.programming.kicks-ass.net>
 <DM5PR1101MB22667E832B3E9C1EF5389F2280810@DM5PR1101MB2266.namprd11.prod.outlook.com>
In-Reply-To: <DM5PR1101MB22667E832B3E9C1EF5389F2280810@DM5PR1101MB2266.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.221]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb973f8d-d602-49e6-8905-08d814335a61
x-ms-traffictypediagnostic: DM5PR11MB1308:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB13086D80A009B849C8B9716680980@DM5PR11MB1308.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0439571D1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ey7+5jnHc3CmBclAUiUWtasaKt/olCZIIQqFRwl3Atf/GZ30gk825T8EQZxCh9VWC0M11xMa3AGZisii7fsBH63blklhEwV+njkeuveOdk5mJ9r1cI3UJ+A2UPD2fhB431ECeGT2Sd9iUNYL9+kIWiFabHDZMtGcwuoUbPtswXHpTviuh5Zrj/D49xqWq01mjqu7v1Ks6GACUGaAOw88q60p5n2pP7XIFKzyLztjLgebQazVV5Pqq45Vg+4NXnrD+8c4woIdgapEUimXciiAnVmz4EHndREHoJO9wF3Q1LvnMUTcFIq3di73T1X18363EkFZoC1Nh1jlf23Snbeelw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(66476007)(64756008)(66446008)(66556008)(33656002)(66946007)(7696005)(55016002)(8676002)(76116006)(6506007)(71200400001)(8936002)(9686003)(52536014)(54906003)(83380400001)(7416002)(86362001)(26005)(5660300002)(186003)(316002)(478600001)(110136005)(4326008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: byC3fMr48YD3CQv+ZNKsfq71lZutZqZwDX7csvTmlaX5d9t0UtbX0zVQemJg+i/FlumvzkrHrS0KhVLYpM460n88ctb3qzw1F0WDTMSQX3tZ4QVAjdIv2aoRX0koXSn/JtUbtWsYd+PwVvfZin8ieTxIWg6mR9hLf6DnNbhKxhrj3EtlFo8prmhpn5O32jqzOb3CUatdgRAILUkBIHcbs7Ax6q/BUpOSHFunV54bcTUxufMt2w9qoSs/Rue2aOYG3YlvgnoqwzFzgTmQDrp7mdD4viZAiq9x6wx2Jd6MOJnrUjMxR11cvrCjUk3v8GhcLVc2ZlKpKb+0bbHiBHC+pBVkDYT+a87sWupihI2jhl7vnt5oyJqbI43KnTZcWrWuKMLMpHPFT5W7Bxp9mGIb1cs6EdnEvhnUeSsJ3Z4H02EYBsG/Ec6U/xrOl6I2Xk9nCwO9DcdS6EDJ0ltifk/+GBpYZWPazzUEss8BPSSzBO16CjcGKWvKaEnNomsKIG9O
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eb973f8d-d602-49e6-8905-08d814335a61
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2020 09:30:06.2275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MYInDnMfSOz4gaEFn7Xdrps41D/sIp2iOExbP/9DQAFv4wcPzJc8dzMJ/UpQ++1TpNOQ8+MMV5plr9WMOLBYwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1308
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > Suppose your KVM thing claims counter 0/2 (ICL/SKL) for some
> > > > random PEBS event, and then the host wants to use PREC_DIST.. Then
> > > > one of them will be screwed for no reason what so ever.
> > > >
> > >
> > > The multiplexing should be triggered.
> > >
> > > For host, if both user A and user B requires PREC_DIST, the
> > > multiplexing should be triggered for them.
> > > Now, the user B is KVM. I don't think there is difference. The
> > > multiplexing should still be triggered. Why it is screwed?
> >
> > Becuase if KVM isn't PREC_DIST we should be able to reschedule it to a
> > different counter.
> >
> > > > How is that not destroying scheduling freedom? Any other situation
> > > > we'd have moved the !PREC_DIST PEBS event to another counter.
> > > >
> > >
> > > All counters are equivalent for them. It doesn't matter if we move
> > > it to another counter. There is no impact for the user.
> >
> > But we cannot move it to another counter, because you're pinning it.
>=20
> Hi Peter,
>=20
> To avoid the pinning counters, I have tried to do some evaluation about
> patching the PEBS record for guest in KVM. In this approach, about ~30% t=
ime
> increased on guest PEBS PMI handler latency ( e.g.perf record -e branch-
> loads:p -c 1000 ~/Tools/br_instr a).
>=20
> Some implementation details as below:
> 1. Patching the guest PEBS records "Applicable Counters" filed when the g=
uest
>      required counter is not the same with the host. Because the guest PE=
BS
>      driver will drop these PEBS records if the "Applicable Counters" not=
 the
>      same with the required counter index.
> 2. Traping the guest driver's behavior(VM-exit) of disabling PEBS.
>      It happens before reading PEBS records (e.g. PEBS PMI handler, befor=
e
>      application exit and so on)
> 3. To patch the Guest PEBS records in KVM, we need to get the HPA of the
>      guest PEBS buffer.
>      <1> Trapping the guest write of IA32_DS_AREA register and get the GV=
A
>              of guest DS_AREA.
>      <2> Translate the DS AREA GVA to GPA(kvm_mmu_gva_to_gpa_read)
>              and get the GVA of guest PEBS buffer from DS AREA
>              (kvm_vcpu_read_guest_atomic).
>      <3> Although we have got the GVA of PEBS buffer, we need to do the
>              address translation(GVA->GPA->HPA) for each page. Because we=
 can't
>              assume the GPAs of Guest PEBS buffer are always continuous.
>=20
> But we met another issue about the PEBS counter reset field in DS AREA.
> pebs_event_reset in DS area has to be set for auto reload, which is per c=
ounter.
> Guest and Host may use different counters. Let's say guest wants to use
> counter 0, but host assign counter 1 to guest. Guest sets the reset value=
 to
> pebs_event_reset[0]. However, since counter 1 is the one which is eventua=
lly
> scheduled, HW will use  pebs_event_reset[1] as reset value.
>=20
> We can't copy the value of the guest pebs_event_reset[0] to
> pebs_event_reset[1] directly(Patching DS AREA) because the guest driver m=
ay
> confused, and we can't assume the guest counter 0 and 1 are not used for =
this
> PEBS task at the same time. And what's more, KVM can't aware the guest
> read/write to the DS AREA because it just a general memory for guest.
>=20
> What is your opinion or do you have a better proposal?

Kindly ping~

Thanks,
Luwei Kang

>=20
> Thanks,
> Luwei Kang
>=20
> >
> > > In the new proposal, KVM user is treated the same as other host
> > > events with event constraint. The scheduler is free to choose
> > > whether or not to assign a counter for it.
> >
> > That's what it does, I understand that. I'm saying that that is
> > creating artificial contention.
> >
> >
> > Why is this needed anyway? Can't we force the guest to flush and then
> > move it over to a new counter?
