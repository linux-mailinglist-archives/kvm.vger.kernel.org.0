Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D24E4755B0
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 11:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbhLOKCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 05:02:53 -0500
Received: from mga14.intel.com ([192.55.52.115]:58489 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236587AbhLOKCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 05:02:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639562572; x=1671098572;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lq2AGbvaIqi2jeGvwf9qxuJkeIYvPQoiSc7EEXNoAVM=;
  b=HeyuRdVplWEsI/RmROw9O+L5gl38v06/Egbc0WMZCpnmBQsl/MzHoJho
   mYlV+MUuA+EGSjfLkVyiQc8u3YbM4D/y78BcZo0IubnICI3SHn5j+9HZ0
   zZvnsrGjDkoNdiXRW5TjGin4yaC4PuwWEWmk435w8Dw0lCsMdfl16SPn2
   vukUVBOcKj0UVE61L1b7LUdzNA4kNGh+lXvCHwbGNbPIbF0CjNfe9EcmW
   415gKodb/KiLyFR5Kce3p7FZ2EdlkA1ChGmadx54hpdfLSxHsccJMd07J
   ajAatEDvHOWwXY9ug7EJUVRDAIMoyRdLyWWPwDiXu50o9iOli6kzaQgXj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="239413493"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="239413493"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 02:02:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="682429224"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 15 Dec 2021 02:02:47 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 02:02:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 15 Dec 2021 02:02:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 15 Dec 2021 02:02:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPOWSUThRww95kS2slRMVfZZqNY6NLDP0IRQMKbqhwxReZWsOCG2o5wyQhYpbRRpOIEEk04Ypyh9IU1xIRYO70G5J5Lx/ZVy9Ed/wxad8gNaNjxkiqlBW1EAEWqq2Ed2aPCAX/VislyJQXmfNts8q2S5451Lrm5kd/xupGcktE+3+5YcsJVJV7cJAu/nbTfShIJYxO/WgVKCgyy9W0l1b5tQNZ1QaU4DPYMqLUBjMqGjHhYxSjycqdA/h0046+jdQpVakRvIlAxSmgoQehVSsZcKNUceBXhWOrwG6TdbKFOMg/jPRuITBzZ4JrBiLLCZlQOIvMibIdtosdfg6X0jUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxKcTbnqbX+wG/IWjNFB99i1aYD3GlD4EA8nv5JWt9g=;
 b=MR93cAZjDhcF+6dMD2YF1MvbSaPivDcW/bN/QJfg35xW8iBskp1W0NCpLYx7906s/hDyMDNXKMNxMrvrXZ4Pual2sJcQmBKW0XsxuIJGz6gC6tBSjUfswKzeN8uGkMQPsqRzco505KASnRQ7KU81dkWxbqlQI2ynGBU34p6VMye4MA/oFAI6dtOZlk+3ZzyjFkpfCJa+1jQUPx+xjjXxfwajO7h5fBbN5s6SANaIQCOzDLZ4b1EbULxyOhYtjDqzZgCDM3GNCNyH+a470kB8qaJJFqqZFEnUnEwvNZQ2WGRX2S5E8wL91BozGRWqGngi6B9NqiR9VHVwV1Uqxca1Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1649.namprd11.prod.outlook.com (2603:10b6:405:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 10:02:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 10:02:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: RE: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
Thread-Topic: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
Thread-Index: AQHX8JVfa24MaOKR6ES6APNYc0mH4qwxeZawgABOEICAADCUgIABC9hQgABN3gCAAAJ6MA==
Date:   Wed, 15 Dec 2021 10:02:44 +0000
Message-ID: <BN9PR11MB5276D9BADF36A750ED9ACD3D8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024947.991506193@linutronix.de>
 <BN9PR11MB5276D76F3F0729865FCE02938C759@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f49f9358-a903-3ee1-46f8-1662911390ef@redhat.com> <87a6h3tji8.ffs@tglx>
 <BN9PR11MB52760A4BC211148D875D3F358C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <87bl1iry7z.ffs@tglx>
In-Reply-To: <87bl1iry7z.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a65729c-a758-47aa-66d5-08d9bfb20a21
x-ms-traffictypediagnostic: BN6PR11MB1649:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB16493EB7613B1B06AA35A8418C769@BN6PR11MB1649.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IY4T9vpnLDfMBN5kY6FgfBFQkfW+whQGBsSEV6Y4tO2CgmcWUp5cl6sMEOtOJ6c8fbDF14udZMPIltbY0tPGewAM+f8IFvlCM1Q/Z+zZp3SFf+VgXGn2UZ+G+zvPk9kExdFWq9H+wCvfq3AgRjWlz7MtgYBg0uUYqzkHzSjtEASkfSTG7b/g14MXKSO6zziRNAVexup10Ob+AkLtRzFQaZObtLBPSapsS2J0Az6uwZTM/Zx0d1AbKaT7Ornmxp35DInkHqnorAaEGMWVEVfBQEIIYzlD/bt2pd8cDAORH3w90FanKT2qOsoxlHJlrtY19NLUhDIE42Crhbjso+4WtyLL9uuq6bGqmRktEHK8Rd3orXZEHMtZArkeD2ItBcIgcmgib7p204XI3tU+8wtJrbREX3IXfhG/uSG1NjEXm7pGyDsAMnGU4cjKcqLIE5xLcwXmhMXDuzTolxa5C6XD+J9lZ16OrAlkf2AIl+72MyeVmWAcvyUIKz+10BTu+NtQE4qAV/56DFfU0edLF581VgHU3RXfj8m74Its+DmeVPSb5AdVYT7qv63M+H1imHYUYXd7jEbZxH3awXF6KxIhe9QkyODhDLk9ACnAOwea7f4zwzmzqQmMg1yzz/Ffi73wZfBYbx+CwcSVRG3GrR5rh7IUClhYgfLanrSSZS4rLYFscquEH7hFwDfdZSe0vtWGs9Cl+c4P8bFhezMxBn3Qjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(2906002)(38100700002)(8936002)(8676002)(9686003)(5660300002)(122000001)(38070700005)(66946007)(4326008)(82960400001)(508600001)(110136005)(66476007)(83380400001)(33656002)(54906003)(316002)(66446008)(76116006)(66556008)(64756008)(71200400001)(6506007)(26005)(86362001)(55016003)(186003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xODa4KhiBHdgJRJg4YCGpgLSHCxPknI8Q0k8fEDjSz1ToJTkUzLnZx+Y4kUt?=
 =?us-ascii?Q?CqZ9404tNQbI0/o249cs06TBJ/Y2k8fFVoH+47RPPIUl4cENQ0qDFVlyxj0N?=
 =?us-ascii?Q?fYe7ewsP50E5PXeaLwkO04xjC+W56hPwzV6YTZ3ajwM4q3ShtvMc34fetogB?=
 =?us-ascii?Q?W0A3uTaEQbAM5RcewgCtjHVtnu3I1bKvozfBhKxnG27Ou+y/9sDnxFFEXH/T?=
 =?us-ascii?Q?A59bHQ02MxJAJ7d9uUYZIKyAWKlawfeYa12AhO+9O8allL412wz5NMEKlXGm?=
 =?us-ascii?Q?jmbj3UasP0LT7seM0UT1TDO2XlY6+UAV5kRyFK6QW9wTAoeUR+qIIvq0DSoa?=
 =?us-ascii?Q?sVxVddKTATOlsXuZOBZUN9QMXau0PxN4/HkXMCva6HFqB2vMuxlzmPz3n8JA?=
 =?us-ascii?Q?Uus53S87o3t52Sfk4xuG6ETIop585Lv0Kqp+Ar3kxsTltiQGbv8byeFuHhJN?=
 =?us-ascii?Q?jfhlPs53SAeikc6frUoEqap4646YWoaMt2dl1nL7MuYRa+XdlyiWNcu1SXmz?=
 =?us-ascii?Q?fyhRo0UfYLrcd1sDtTzpC18DLBb+OVFOeoa8vqdLAgAZIZevKSfZmTFPQ/Ey?=
 =?us-ascii?Q?BpUGYQu6c0ernbra+omFmXfwvQ3+cBduu8itGEFjgk5LRadLz/wRlJEu0Mdg?=
 =?us-ascii?Q?gZ1QU3TnVNqwNbTb9iDGdS4NYHyYdVvdslPYXV6A9xWsHOVeOqCY16jK0jEc?=
 =?us-ascii?Q?Xu8oKw48kHBGQ1PmXE6gCguKwn9SCgPhU1oXpC9vd/DC0ilmw10OmrhWnRPq?=
 =?us-ascii?Q?JSowGUBsX0b89jgtykdLp4EiNuzXZszgBTLrxO9V7Novx1gkgKs22npJzsVE?=
 =?us-ascii?Q?dnKwXRzFyWTkrHK3EL8GGOXySNzIPUr1SKm5STdoN/JYK9KwC+zNIjPKHCPb?=
 =?us-ascii?Q?m28gSFzYUZw9+wRtCxFFMz/GJtczflxS+FH4QqoLYlu1piu0yV2xxnoJ9cQP?=
 =?us-ascii?Q?OSW4PS1DsQYESp5SobTZQS2+MkjxijjERHwEY5g47xcx8UDRs2BPF9FD+NPg?=
 =?us-ascii?Q?k6vh9J+aWKU0yE5+nOZ0IaYXexxsfOpJIO1d3j2/kJGgNWN1IbAniHaPEDNh?=
 =?us-ascii?Q?2j7Hc0Ev7j/8BxN0gegnU79mnvhuJm19hU5VkiezOf0SRQkkaNxDmc5TVsi1?=
 =?us-ascii?Q?opcvvttUD7GErWjx5O/AwqS0szWK3B4Y/9DhVdcnK6LnCvUo29ZhqbXWqf45?=
 =?us-ascii?Q?7SFEtt0bS1isU6Jyjt//NOt1MHUfqHHw9W52977p5OkY3BFc19lCZhPln/sJ?=
 =?us-ascii?Q?B2bX54fwoQzdHmPszikzmyVFE8edVMH5QUieAOP39TBBcyNQeiGQU3aGx5n4?=
 =?us-ascii?Q?ShwBOzhz4ncX2uH1kl0Vv0UFC+L/ZyzYmG6BvW4zYYXpcuCcDIRsavZ7gzYd?=
 =?us-ascii?Q?1QAm1YT/xwO8TyST+FaoVsgCCmYutyJqpg5PaR4nWjy6/TkQhFokGo0b6CMd?=
 =?us-ascii?Q?WgmJLfsBKU+FlDANHOHFPnBSzuChI2YGKcP0JgIDftllt0NpFH8/3Ptelqz+?=
 =?us-ascii?Q?OgLv2Ukn7PbczSWaJwSzgKkz+hIrGD3YT1jBaK4LxQnBqK+78U4zkz/jdCzU?=
 =?us-ascii?Q?2Rlh4Aw4BKyDBzK6ElTYLOPlwRQs31U0O3wDu9X8uPfCZHIKXKe5WF2CzHlT?=
 =?us-ascii?Q?4j5GGnuywggYV/a29SdlvQs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a65729c-a758-47aa-66d5-08d9bfb20a21
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 10:02:44.2809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +E0JOfVIhCG1bxR/HEU3K9CtIKfV0Y5iL8sOIO/AAypgR67OYmmtFNPPRqo7xWu2oB2MFM5cRpxg8ESTbD1h5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1649
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Wednesday, December 15, 2021 5:53 PM
>=20
> On Wed, Dec 15 2021 at 05:46, Kevin Tian wrote:
> >> From: Thomas Gleixner <tglx@linutronix.de>
> >> +	if (guest_fpu) {
> >> +		newfps->is_guest =3D true;
> >> +		newfps->is_confidential =3D curfps->is_confidential;
> >> +		newfps->in_use =3D curfps->in_use;
> >
> > What is the purpose of this 'in_use' field? Currently it's only
> > touched in three places:
> >
> >   - set when entering guest;
> >   - cleared when exiting to userspace;
> >   - checked when freeing a guest FPU;
> >
> > The last one can be easily checked by comparing to current fps.
>=20
> I added it for paranoia sake because the destruction of the KVM FPU
> state is not necessarily in the context of the vCPU thread. Yes, it
> should not happen...
>=20
> >> +	if (guest_fpu) {
> >> +		curfps =3D xchg(&guest_fpu->fpstate, newfps);
> >
> > This can be a direct value update to guest_fpu->fpstate since
> > curfps has already been acquired in the start.
>=20
> Indeed.
>=20

Thanks for confirmation. We'll include those changes in next version.

Thanks
Kevin
