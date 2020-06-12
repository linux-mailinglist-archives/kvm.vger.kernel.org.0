Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E121F737A
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 07:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgFLF3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 01:29:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:43067 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgFLF3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 01:29:06 -0400
IronPort-SDR: kQ5/xVd+HwFPEYvU49MBkUw0y8EE+LolCyzFeDZCsF6XQXJmwAMcCrb3pGzZ5HelwceHEi54S6
 milsEbPC4oKw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 22:29:03 -0700
IronPort-SDR: eespABzOofUCCqG3vYDiId1lDbj0omEtFvX/z6b+FnWFjWg+/siz31qszLA9BEWIb5+n/H5twa
 z0a2EFp1ooRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="259800548"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jun 2020 22:29:02 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jun 2020 22:28:51 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX126.amr.corp.intel.com (10.22.240.126) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jun 2020 22:28:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jun 2020 22:28:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCnG0A4ho5mFHaKPugpOOub2Ey/oY9yED8BoSqVMQq5Ye4hRCqk4RfJRpFOttxJAQlXrBV6dun5TkmBnPVFEvCclr0W2BmioAuPd6N/WaH7n+DT8l+nw6SSCeOkAmQXnrTUeVlg/aUT22qjJQJ9kkq0RAExvMO0vpVdovgyyZeB3wKhTftsr3Iguo+PQl3WLJ4W1m7TOoDUY/5dmLcP8E2FFeaGfcUsQObLm2KwSiQZ4p+2pwz8Zhbrv2jBQxoKOAARj7YmsTetpmRX9EK1NfyGSum4jxuNKim5iVo9La5yYguvsSmQPLKVvKYHtB6EewDgqWTjSAX5PhdBF8n1MSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zV8JpowmJRCqHGQU/9zJR19MeK+t/heeK7QBZxaPEM=;
 b=cM64IMrkXfrHFosGHPWEPYzpgV0MGR2A/uTg5Yu7D2zWmqPybReQte3gZJNG5QsIqvFWqxGAYW5LTrEmGZ6FJ/3dgo9zeVG4MMYxLxLNz+TBtOWxFUjSNHNhR52X03/SXkBD92HQ2oKSk3QuVpgW2C3Id2YyXXvgcqlQ7alzDyq/TvDLXUs99lCqQSolO49+g+FfbI1Xi6wb9F6bBkCa3k/7wN5nnyse5pA7ni/Arf/V8Jg3QDQSgOBdFy9PKR1AYte9sbaV7eUoSvERQyGXuWawkW4kXOz2gRgZxe8gVi3ZM03+dWMcsB9HX/1CTFOcJbc23ylNYowOt6Y/q02j1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zV8JpowmJRCqHGQU/9zJR19MeK+t/heeK7QBZxaPEM=;
 b=BPvu1/gxFwUZ845lFSfLJk1UgGxKX789WnZq8u7ITCqrxHINqhCvSQiPGgQIbMlhMWIiw2FSTZzJdrxbWIK1Z4QpJK9YxI58jUpuOKuYoej/ZVQy6obBpUxTb8qOAXluZhK12vEPt66MrvMDyCoshkFAF9ARyWBlNlOuV24EEtw=
Received: from DM5PR1101MB2266.namprd11.prod.outlook.com (2603:10b6:4:57::17)
 by DM6PR11MB3596.namprd11.prod.outlook.com (2603:10b6:5:13a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Fri, 12 Jun
 2020 05:28:49 +0000
Received: from DM5PR1101MB2266.namprd11.prod.outlook.com
 ([fe80::b07e:e40:d34e:b601]) by DM5PR1101MB2266.namprd11.prod.outlook.com
 ([fe80::b07e:e40:d34e:b601%6]) with mapi id 15.20.3066.023; Fri, 12 Jun 2020
 05:28:49 +0000
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
Thread-Index: AQHV8tS2uZDJ2Dgk6EqR/a2HW+9LbKg7EWeAgAAN1ICABGlOgIAANIUAgAAfgACAlQF+kA==
Date:   Fri, 12 Jun 2020 05:28:49 +0000
Message-ID: <DM5PR1101MB22667E832B3E9C1EF5389F2280810@DM5PR1101MB2266.namprd11.prod.outlook.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
 <20200309100443.GG12561@hirez.programming.kicks-ass.net>
 <97ce1ba4-d75a-8db2-ea2f-7d334942b4e6@linux.intel.com>
 <20200309150526.GI12561@hirez.programming.kicks-ass.net>
In-Reply-To: <20200309150526.GI12561@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b3a8e69-517e-4592-5bd4-08d80e917cab
x-ms-traffictypediagnostic: DM6PR11MB3596:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3596D65AE46D790EA59E37D580810@DM6PR11MB3596.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0432A04947
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /iFRD3LhqlrMY7Doz8Lww2rHGfs70O0NOY72GLhPkrt9CZ88mBPaBihrB5pTeBglNqEziHXPk/HE5oLblq6qe+4VWV2HMEx/g/JrT4yIbSYGV5cean/6F5MS1ytoOxZK3M4KVconcj076LpTTrC06ogWrXSmC18EQANTLhRUeBEBBgAR7gjdDxUbzS+QOpH/gerSo+HI027SXeu4CElQrf+XNKC1H4JzW5VYc3ibAAZpsPz2krlC+HBLcdnU56qQOeHwilDuaBgkZY1QhXrneQw+fasCOl6nSybxablg8Z/U01SYya/MP9MCEogV+SG6MS3lx30bXwsuc0GOKnFkMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(39860400002)(136003)(366004)(396003)(66556008)(52536014)(66946007)(83380400001)(76116006)(8676002)(64756008)(6506007)(71200400001)(66446008)(66476007)(55016002)(7696005)(110136005)(316002)(26005)(4326008)(2906002)(86362001)(186003)(7416002)(8936002)(5660300002)(54906003)(478600001)(33656002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 14Vs8HckNBKV54fwxY2OHSEB3YxjnTxO8xxO32OOjsG9LrNOnCp5g9A35O7ZaWU3gmgsBAZTWLbifGFghrQnJ8zbOT88TITf723VJ421g0ZA7GFKgTYX1fifOZopTlxa/+7JrllarM3p4xDrsoEpXQbuYmA7TQzM7ZpgSc9l2loFhhQlvcDqhJZLvzvngOvFYv6NWetMLeQs1ojh9f1e8cIUsc77sRkiHrMTt2sqFNmySIG5iWJUCuNosYbatpmDjI0aAi6mNHyLs5wM6Yff5c/BFMjCCv7R+U/k3VBay6Pd+zvOLCLHjh8ELc0GUzqgHuKcVDBIG0RFtC4puwNowaeA91xh68sb9V4Mkhw8H43gkJ2+NMWA15JCZC5zULMLCN5EWsfhTmb/ltDBZJRoUcJ7C/dQ035MOeuNoL4JpVjvehxyT6WpLQMRhR5mErjVYnArPoyy1X4cQR8d/E1nIXc2RfRtF49TAW7M6ZpZmZ8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b3a8e69-517e-4592-5bd4-08d80e917cab
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2020 05:28:49.4928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TVS+IArk633OhSYayytPfD1ZcDtUPReN/oESABlwAJZC9JJzEKcGk2qN4fHCYU8MSLR6pSzTSKSIrPawqfDGIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3596
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > Suppose your KVM thing claims counter 0/2 (ICL/SKL) for some random
> > > PEBS event, and then the host wants to use PREC_DIST.. Then one of
> > > them will be screwed for no reason what so ever.
> > >
> >
> > The multiplexing should be triggered.
> >
> > For host, if both user A and user B requires PREC_DIST, the
> > multiplexing should be triggered for them.
> > Now, the user B is KVM. I don't think there is difference. The
> > multiplexing should still be triggered. Why it is screwed?
>=20
> Becuase if KVM isn't PREC_DIST we should be able to reschedule it to a
> different counter.
>=20
> > > How is that not destroying scheduling freedom? Any other situation
> > > we'd have moved the !PREC_DIST PEBS event to another counter.
> > >
> >
> > All counters are equivalent for them. It doesn't matter if we move it
> > to another counter. There is no impact for the user.
>=20
> But we cannot move it to another counter, because you're pinning it.

Hi Peter,

To avoid the pinning counters, I have tried to do some evaluation about
patching the PEBS record for guest in KVM. In this approach, about ~30%=20
time increased on guest PEBS PMI handler latency (
e.g.perf record -e branch-loads:p -c 1000 ~/Tools/br_instr a).

Some implementation details as below:
1. Patching the guest PEBS records "Applicable Counters" filed when the gue=
st
     required counter is not the same with the host. Because the guest PEBS
     driver will drop these PEBS records if the "Applicable Counters" not t=
he
     same with the required counter index.
2. Traping the guest driver's behavior(VM-exit) of disabling PEBS.=20
     It happens before reading PEBS records (e.g. PEBS PMI handler, before
     application exit and so on)
3. To patch the Guest PEBS records in KVM, we need to get the HPA of the
     guest PEBS buffer.
     <1> Trapping the guest write of IA32_DS_AREA register and get the GVA
             of guest DS_AREA.
     <2> Translate the DS AREA GVA to GPA(kvm_mmu_gva_to_gpa_read)
             and get the GVA of guest PEBS buffer from DS AREA
             (kvm_vcpu_read_guest_atomic).
     <3> Although we have got the GVA of PEBS buffer, we need to do the
             address translation(GVA->GPA->HPA) for each page. Because we c=
an't
             assume the GPAs of Guest PEBS buffer are always continuous.
=09
But we met another issue about the PEBS counter reset field in DS AREA.
pebs_event_reset in DS area has to be set for auto reload, which is per
counter. Guest and Host may use different counters. Let's say guest wants t=
o
use counter 0, but host assign counter 1 to guest. Guest sets the reset val=
ue to
pebs_event_reset[0]. However, since counter 1 is the one which is eventuall=
y
scheduled, HW will use  pebs_event_reset[1] as reset value.

We can't copy the value of the guest pebs_event_reset[0] to
pebs_event_reset[1] directly(Patching DS AREA) because the guest driver may
confused, and we can't assume the guest counter 0 and 1 are not used for th=
is
PEBS task at the same time. And what's more, KVM can't aware the guest
read/write to the DS AREA because it just a general memory for guest.

What is your opinion or do you have a better proposal?

Thanks,
Luwei Kang

>=20
> > In the new proposal, KVM user is treated the same as other host events
> > with event constraint. The scheduler is free to choose whether or not
> > to assign a counter for it.
>=20
> That's what it does, I understand that. I'm saying that that is creating =
artificial
> contention.
>=20
>=20
> Why is this needed anyway? Can't we force the guest to flush and then mov=
e it
> over to a new counter?
