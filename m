Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050B6663CED
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 10:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbjAJJcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 04:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237937AbjAJJc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 04:32:27 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A808167F7;
        Tue, 10 Jan 2023 01:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673343146; x=1704879146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=70W0glPqGGJKxv9Mdc5+3v6kz7HfosA58YZ8i3NPqNM=;
  b=iSbEhXMGWECVbSzF659Mj4dNBLiQQ2+OIzM/6Z5fy+kccFUy6MO/enzH
   FL5RO7e6lyIaZHiDLWrVUtpYWXMxbYwttZXV2/Y3YmpMWKcShZDpypinC
   KSdxmR8Di9Hp3474vOXKzzHxUE643d9mf7jhZ25mSFF7U9W1BBwQidlYe
   LrN9y7mMxEWEJRJ3W1z0e9tCMt/csQNHGAplYqb38zurKcqDfb/oYyjPY
   GAdMGMWKMFra01kKNN3F+JhABpQBFiiZMuV+iYcPzZQHvHCsTqcveRjeV
   L03ydawBVQwuI6NpI5/b8XuCMDygnLYRB9dJ+LstEs8LvlSC+uxOdJHrq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="387556254"
X-IronPort-AV: E=Sophos;i="5.96,314,1665471600"; 
   d="scan'208";a="387556254"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 01:30:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="687509014"
X-IronPort-AV: E=Sophos;i="5.96,314,1665471600"; 
   d="scan'208";a="687509014"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 10 Jan 2023 01:26:47 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 01:26:47 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 01:26:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 01:26:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWXH1cMGO98jOz24DPrVzEkowl8aDjYooRkZjZPfDPnJy0Q5EQjeoGx9xmOe9M0JnTvJLtBKyoZCHbYDBNdbN9Cx+FXC5Ddp118KiUfsMWrDy1wVdii9irg3Ujlzq5B74CmDv0jNCzxITtdesUJuUDmLt72jeAoUEyic8eBT/yFds2e25/uWEL8QeBUrOMOZsPvYGDWnCKxMm3afTlnPCno7enmS3B+P2VOxYKQvhm2Fz89yw6q+SNKiSYcwrH4c7EF8ve8fDwUsfXOkGaVEaQFXVnNZxvZX4xJF11U0Lk8TuqQQ4ZixfVjWJ3z6UeRs5YZwJSZRLul/zoPtBCeoXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTInJOKovORyhp8xJ3ygIhgFxudA+E1Nux4ncnI9TSY=;
 b=QCQTwqyR+XbgnoJZQllF58AyBn21+k6Qj9Pz5Zp5JSWRUUMELkCxboUg6e1Idwm3OxdtR5IINPY3tyx2qYCk8utL0T1VI4k4GW94LbglGNoDiCK+N0kCrWfbVJM5f3hCQgHDWbDjKofrRsicpdTmKi6cHvfILxN3n4v8pL/H6MFRdmRdzj2cdtFnuBM+n6QDofbVmYWaXW/XRhfeA6i/oqbTrhUNYGU8trh2zPh1GKrh/yMMHJg8P3XG1axW67HXNd7dKO7NCV6UOfDdcKGjbMzlg6kqFkdo5GnQPaTLBt+YdiJji75zkDXZ4bTlrhYeqWMO4430zbTB9yLBMLq/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0031.namprd11.prod.outlook.com (2603:10b6:301:69::37)
 by SA0PR11MB4605.namprd11.prod.outlook.com (2603:10b6:806:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 09:26:45 +0000
Received: from MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5]) by MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 09:26:45 +0000
From:   "Zhang, Chen" <chen.zhang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardware
 mitigations
Thread-Topic: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardware
 mitigations
Thread-Index: AQHZDLMhDxurDeM6YkqaqujyHlpxN65t2QCAgAdw3ACAADdPAIABV2sAgAN1XoCAHT6AkA==
Date:   Tue, 10 Jan 2023 09:26:44 +0000
Message-ID: <MWHPR11MB00310B41B2F2681811D2DBD79BFF9@MWHPR11MB0031.namprd11.prod.outlook.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-6-chen.zhang@intel.com> <Y5oviY0471JytWPo@google.com>
 <Y6BtcutjgcgE8dsv@gao-cwp> <Y6Cb2OrkQ8X3IvW5@google.com>
 <Y6G77CTIk8CvtTLn@gao-cwp> <Y6Sin1bmLN10yvMw@google.com>
In-Reply-To: <Y6Sin1bmLN10yvMw@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB0031:EE_|SA0PR11MB4605:EE_
x-ms-office365-filtering-correlation-id: 41f5db90-b487-4abf-129e-08daf2ecca87
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YwDXdsfgqQEI5aSbwE+3DUULTX6dZS6m/1MEJVFqB7jpquNoSJ7XEgLImqheVzEW/01r7iDcRHaWo2++qX3KuEmaSaGC0sS/saKqgREwTljabhwduNJdneX9OiilfAJq0v3kFaCsQjEuFJCJbGMh4Y7NuILMNZ9Xx8MpQX2MJsfjMpCqWrrzCX/jQJgTaeIrxyp6x6BxBnJWYpx9dTr07mF7UhN7uB6VJyisUn/lgFNG/pQguksS6vPQ6iop6CQ91svX92wT1WMyNntJdrEk2ARmCLR6IYm8n0U+Vie3EsVSfkOr7Epipyb+R0RSHN39sB34wZ7oymzTFtRYO33Q0fU1O2Sfl9pa7vzNX7svDNX0DtjaQqk5snFI5rxGDgRM85P8twrePYLNaLJ1kbcYjhWZ+fhgvCFBhe2jkp1+sMN5UJ7ynDBTpGodsHOM4tQG8Xm2dwP9+gKU4ZHKoRud9a/9zdJjI0SfiIxr7+6jgbeI8EVOxZ/p57AqxUQ5OAgY38UnG66q3fkgiRSAkaxCTpuFKlkSzReg+Y1kmZ6wqWhrLfIekeoJdlON7SaFZFMXD4s4qt1XSMdaYDHs/B9QaLXFmfEIeghuzaY3dQa+K6EwHjMcYfeRTrLeJMJfmhpAWZ6Awtale/I/rK3mtlKm+q5PlZmQ5Cik2dijy4K5y+DIzTdAX4tOUoSty6is0tgFuNG+AcAE21iNgOkI/BHHvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0031.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199015)(33656002)(38070700005)(5660300002)(316002)(7416002)(7696005)(26005)(186003)(478600001)(71200400001)(9686003)(55016003)(41300700001)(6636002)(66556008)(4326008)(54906003)(110136005)(66476007)(64756008)(66946007)(8676002)(76116006)(66446008)(52536014)(8936002)(86362001)(83380400001)(53546011)(6506007)(122000001)(82960400001)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T9m1rChSLy9bkk95vGPt4jwbDqaQuhBOhnauXvZuvAFs27aFPhOS2RatGvBb?=
 =?us-ascii?Q?MIW50zOE1j6GErmv39Dzds5Mvgu1VQpL9QT1uDxLYckTdaGzddQ/yQ0g7lJq?=
 =?us-ascii?Q?sfslb9tb6qd6SbSrTzxLg+8mnV7qrQQPNez/h51txommI+PXDt0Yk0Cep1St?=
 =?us-ascii?Q?W+y6ZBIILKGAToAQV/IJygDxK03n9QVMZvXhpSQ0xf/2ADmmMO4eoiauskAL?=
 =?us-ascii?Q?vUJf1eKoQLR5UmiezV9ruPv736Y1pnn+Lc/MQjCzf+KH9SGEzqvkJS536HQH?=
 =?us-ascii?Q?K93soTEGMPl7AMlod6KK90iSYiJ3UNEFwjgcieyfqVZpCxZFY2ADXe4GRJ7J?=
 =?us-ascii?Q?BFFfqRakEaEGRJ1UNtWJ3EYMjBWxtlKMqtUSYKfxqNA7OEqNKs7oeIA670pt?=
 =?us-ascii?Q?XYuftiVvNlHMPUIO9gsPJqF2RqQqWSxsKuCsWjLr5JCUZLO7Dsb9GZlroHvZ?=
 =?us-ascii?Q?Z4T/LniwQLFA689nV64duVyhTbGJi8SDcpcL2O2GRo8BLrVKvBXe9IGGdzNJ?=
 =?us-ascii?Q?qla1JCGMVZVU0JE41OpdTqdBP54fj8Rvlpp8Ia6ijjfqYRJK2sGRPxAFD0OP?=
 =?us-ascii?Q?ZzllAraH8U5Wv+a+XPPtNzSS9rIIlYglwao93S3OCEdGVEUR1dy18YMhxsyU?=
 =?us-ascii?Q?fNFWdBFcXzjDYOl6lEE9dvSqWHIZMYxecOs7PJdizOOZPzuvj+cCJh86+oqX?=
 =?us-ascii?Q?LVm9Qq10tIh/yUNxNyJtTpbO8SPYp79LvXFS23dBajABvq/mzHCMX5vmFFcz?=
 =?us-ascii?Q?bvGRiJ4xmAOmvqIuNkSjuXkiUjXANjVJbF5fGpegDjklAzjobgMO3xNgcvPt?=
 =?us-ascii?Q?HxHy9gzoDAwKTsY8OQQSH7jIxun9saQKVanaJ/93Rdw5uDaqLpm29cOzD2BK?=
 =?us-ascii?Q?trWJrkecxkfDTj1mCVnPCbGkHRK5WSOgIskJukGQDA0ie9B9EZlqvBuotEes?=
 =?us-ascii?Q?8c/P2Hc/zSlOSJXDrwzStKJcTgxsqQistloDxjdkvHoRuacA8RG7iA25NMGu?=
 =?us-ascii?Q?Jxv71XKgOBW8Mbp9Z5m+poUWfNVnTodKYsxdT/VUcwJguzLUaX8tTNAn4GR+?=
 =?us-ascii?Q?kTNyE+P8MH+cl0NlgDWA5L+Tw0DeuKImxMMjqtCkfV+IvfwBvKpPO9LDNaEn?=
 =?us-ascii?Q?/CAc61pPWi9z4g9aG1aPxYZhMN1jtLO3AM3/VgFhO3FTcxFT8zohWlHd39FT?=
 =?us-ascii?Q?EzwC/DA6rkl525YXbagEhVG8RLO1h5qsPyFAH07cOUsZkQBAuzFyjwOnprYU?=
 =?us-ascii?Q?ApaBeJFAQK39PaoDoRwginxrGuAwoNcksuc8ESQtSexcQqx3hns3Ccc16Lx2?=
 =?us-ascii?Q?lf0hW0mxKxkhxSBUAl3IRDo1HLkV4m683w+cqDiSU5BOZ0IF7S6FWQjZR/yo?=
 =?us-ascii?Q?X/xFzV2Fcgril/EXhkPMPGTa/dk8mNmVXhvFn0P22V/HAfLTIQdhaRBBEcUq?=
 =?us-ascii?Q?NdcI/jxUNW5ovtsMKuB3KLo9ywW/Ij7iXvIqr8zXpqlLdTFnc+qB6CQ3c95R?=
 =?us-ascii?Q?XtZ/xWgZyDXh+ka5vPT0pWbJo3s7M9MG0HBJL3Gvfq/eGSUVmcK6u4U5P1hP?=
 =?us-ascii?Q?09OloBgGO3QL5/In9mra0xnQgGC2W95Ya5HmIeoN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0031.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f5db90-b487-4abf-129e-08daf2ecca87
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 09:26:44.9618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cItGtOC6Kj1f27r3u/mbnSoRbK/K3Iuf1B4vIKW10wyFsX2T/HKF9N90CkPaHWDkRVOv1FIrFd6dETwbQoIQNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4605
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Friday, December 23, 2022 2:32 AM
> To: Gao, Chao <chao.gao@intel.com>
> Cc: Zhang, Chen <chen.zhang@intel.com>; x86@kernel.org; linux-
> kernel@vger.kernel.org; kvm@vger.kernel.org; Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com>; Paolo Bonzini
> <pbonzini@redhat.com>; H. Peter Anvin <hpa@zytor.com>; Dave Hansen
> <dave.hansen@linux.intel.com>; Borislav Petkov <bp@alien8.de>; Ingo
> Molnar <mingo@redhat.com>; Thomas Gleixner <tglx@linutronix.de>
> Subject: Re: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardwa=
re
> mitigations
>=20
> On Tue, Dec 20, 2022, Chao Gao wrote:
> > On Mon, Dec 19, 2022 at 05:14:00PM +0000, Sean Christopherson wrote:
> > >On Mon, Dec 19, 2022, Chao Gao wrote:
> > >> On Wed, Dec 14, 2022 at 08:18:17PM +0000, Sean Christopherson wrote:
> > >> > To me, this looks like Intel is foisting a paravirt interface on
> > >> > KVM and other hypervisors without collaborating with said hypervis=
ors'
> developers and maintainers.
> > >> >
> > >> >I get that some of the mitigations are vendor specific, but things
> > >> >like RETPOLINE aren't vendor specific.  I haven't followed all of
> > >> >the mitigation stuff very closely, but I wouldn't be surprised if
> > >> >there are mitigations now or in the future that are common across
> > >> >architectures, e.g. arm64 and x86-64.  Intel doing its own thing
> > >> >means AMD and arm64 will likely follow suit, and suddenly KVM is
> > >> >supporting multiple paravirt interfaces for very similar things, wi=
thout
> having any control over the APIs.  That's all kinds of backwards.
> > >>
> > >> But if the interface is defined by KVM rather than Intel, it will
> > >> likely end up with different interfaces for different VMMs, then
> > >> Linux guest needs to support all of them. And KVM needs to
> > >> implement Hyper-V's and Xen's interface to support Hyper-V
> > >> enlightened and Xen enlightened guest. This is a _real_ problem and
> complicates KVM/Linux in a similar way as multiple paravirt interfaces.
> > >
> > >I never said the PV interfaces should be defined by KVM.  I 100%
> > >agree that any one hypervisor defining its own interface will suffer t=
he same
> problem.
> >
> > I am thinking there are only two options:
> >
> > 1. Intel defines the interface.
> > 2. Every VMM defines its own interface.
> >
> > Any middle ground between the two options?
>=20
> Work with other x86 hardware vendors to define a common interface?  Ask
> hypervisor developers to define a common, extensible interface?
>=20
> Maybe it turns out that it's impossible to abstract anything away and
> everything ends up being vendor-specific anyways, but not even trying to
> provide a common interace is extremely frustrating, especially since all =
this
> mitigation stuff has been going on for ~5 years.  There's been plenty of =
time to
> establish relationships and points of contact.
>=20
> > >I think having a PV interface for coordinating mitigations between
> > >host and guest is a great idea.  What I don't like is tying the
> > >interface to "hardware" and defining
> >
> > Do you think something below is better than the intel-defined interface=
?
>=20
> No, KVM doing its own thing would only exacerbate the issue.

Hi Sean,

Rethink about it and synced with Chao, we didn't think of a better solution=
 than
Intel-defined interface. If you have no more suggestions/comments here,
please review the rest of patches from this series when you have time.
I will try to address comments and push this series to RFC V2.

Thanks
Chen

>=20
> > add a new KVM_CAP_* and a KVM_FEATURE_* in hypervisor CPUID leaf to
> > enumerate the interface. And add a new virtual MSR 0x4b564dxx for
> > guest to report in-use software mitigations and assign one bit for
> > each software mitigation. On MSR write emulation, call into vmx code
> > to enable some hardware mitigations if the corresponding software
> mitigations are not effective on host.
> >
> > I am afraid it is late to switch to above approach because e.g., if
> > Hyper-V decides to support the intel-defined interface, KVM probably
> > needs to support it for Hyper-V guests.
>=20
> Hence my frustration.
