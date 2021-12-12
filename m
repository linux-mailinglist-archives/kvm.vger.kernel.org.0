Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571DD4717AF
	for <lists+kvm@lfdr.de>; Sun, 12 Dec 2021 02:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhLLBu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 20:50:27 -0500
Received: from mga04.intel.com ([192.55.52.120]:18242 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhLLBu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 20:50:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639273827; x=1670809827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H/icIsMoOolD81i7mev6oxLQru2sTkjw++Jc6LR4lkk=;
  b=avqWHGh0sTdpDOfIFvkSxu5dBNd4vUyyoIjSf38WSDD9Kpvcjt3Yw8XB
   Nkj48xYeNLGRfj+Mkj/33KLlFfbVYaDY1rzYWFPulw+6AuAG3BswGfVwo
   B+1yC0a7wH1mMpH/BBJOllFVZpdnZWnSgFV1eYM9iFuiItxOpOsliZJAq
   YqSqok3cJtdBS8eYy9Zq/Z54xrGhoQjpajBNKwQk78iRWV7BdQJPnrMS8
   hWbbEzqkpwculvetlbVml6T3DBaX8a9k2pGncca/IIJnjSyb/f7/bxDqr
   UdxFQialmBVRpQJa2RtLY/Jb7YPfQV6K4zIz1/M/c+4a5Ae/W/ACUykU3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10195"; a="237306270"
X-IronPort-AV: E=Sophos;i="5.88,199,1635231600"; 
   d="scan'208";a="237306270"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2021 17:50:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,199,1635231600"; 
   d="scan'208";a="602692075"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Dec 2021 17:50:26 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 17:50:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sat, 11 Dec 2021 17:50:25 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sat, 11 Dec 2021 17:50:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDhvu+ADVC+HM7lYWyEzS4M9w561hlhnTAPlK51dPXQdR7xAfe3ifmk28pWLeL5DtRSws0+wi9JkmGbp7W7IApH7cbh+wzQwfV534WZa7gTWnd2bsXvOT4tULZJd27+qR1t78jiRtk6HdBD/YHyhFpOyyw6MJLzg5hZ6QUJAHIg7OIdizwvw0PngowAX5eHoIvOmlcohxDR9jLrr79e9OhIIu3KZc7FlvUSHQK40aKSu1R4ZtyT1hh6A9VPiSzkaMKKtwAUYFfS+47e8/8xULvG0b7q16W3X4FxFH2ZGJCOj4mh76mEdM2ZPAYTpKH8/NISYrp33pbMRjxRYg6Giyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SABnA7fB/pgN6/fxD1LUW1UiJby+tkPmG6zfjJ0PmiI=;
 b=EWh0/68Ha9iW+YWXsHYmInIPfNFRHHrUd8MtlA7RSaSGdj38NVxk0rB1oY95jEVkfmlsy8lEzVv3kiNvuK4kW3f12i18mheR2dZ3SGqhJrKKz/Fps0lh+aw4M48cxlVZAG0lRJ0OL6H4UEF6V5mZq60HFT+Z25xmLmLquHif0R47C1rn6FlkrTwXl5TWg4fpKXzBZXlVDzmhHRZDPpJ57yLt6Fsej5RMxQo5jg3KB5glwUDlJ7vDuRjN73vi5jXksmNoDH2d+Y0aN3XSTrRcax13ftkFHw76XL5sqwhrKSwNxhKSTGFP5eqdZ/IfvEyNhMeyDkIV8FbIGvDmUslhSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SABnA7fB/pgN6/fxD1LUW1UiJby+tkPmG6zfjJ0PmiI=;
 b=pODNOnntmhNEqlaHe8CvIZQuX2WZ4a8hf52IERtZEq82uu6sZr4sEmF6x1UJmXiRgrUPTT11KUrIt35CTud8HVdPZq5r1PqeM/jDQclryGJIIcnzs6+s9c0LRUjwOPnlCIyLs85kvdq+uBVYVTCs/zBkQpTL731+owhXv3XDE78=
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by BL1PR11MB5350.namprd11.prod.outlook.com (2603:10b6:208:31c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Sun, 12 Dec
 2021 01:50:22 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::345d:b67:e8c5:d214]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::345d:b67:e8c5:d214%6]) with mapi id 15.20.4778.017; Sun, 12 Dec 2021
 01:50:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Thread-Topic: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Thread-Index: AQHX63yRVs4GDusAIkqrgl6cVTrHdawscB6AgAArmbCAALN5gIAAy4bA
Date:   Sun, 12 Dec 2021 01:50:21 +0000
Message-ID: <BL1PR11MB5271FDCE84F4D25D0241D5998C739@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com> <87pmq4vw54.ffs@tglx>
 <BN9PR11MB5276DF25E38EE7C4F4D29F288C729@BN9PR11MB5276.namprd11.prod.outlook.com>
 <87zgp7uv6g.ffs@tglx>
In-Reply-To: <87zgp7uv6g.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 717c237d-8fa7-4a87-20b5-08d9bd11c21c
x-ms-traffictypediagnostic: BL1PR11MB5350:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL1PR11MB5350BBB0BE173949217BE7808C739@BL1PR11MB5350.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U7Vs9FxY3gdCJPsexDzMDHM2EWtMbjqHbu/wkVNtIXPEmn1ZXhvK6IrhltpGzds97mEuFTNoE3q/ucOXUs/qCL9DkmLxMUjZ1wSdUmRIDugBx84bRwRL3sgng0QRvexLr2Kmg+c93eOncmoBoXKZl1WZ0zQ6Ud2rdyO8NHHNAsmYlvd2ytS88nSv1Ez1tNmoFNWHChGaAuWvU2bR+gxK4zFq3r5YaSR0T4YNmW6h0652wpVQrFqER71vzPP5OUgvyKL0L1EYmXcv2t7WOEF19qHiYU84sT0PyvNmLliXyWlk3cqc2WnEnyXHmaU8D3N7U8xBYrE8KipW74bV0LyLAyGjwYAdJ4TJtxuJIb53wzl1yKrW7iC6kfArUDdSbU65mfxlaR/Zy54D72oANl6aYOznAAKiI5ULiJepxWoyCQqeuBWztGv4sLXN89BmfPJxt4/t2saTJfEYi18p/hGd7wFGo9khJnSzvdsYkQvXmlveVGPjLo8BwRH0vjcSEdvGio49njqCS0SmAg7pa4SLcYKJ7Ry18SbhUPoUD+xeYltiXk797IizJ1a2JV6G2xVJz+sfEH6bf7uHQUSnRUGAbx5xyDTNEtPgrRlFaVmOOeseTtm7LnhYssXGp9XPeVaCL6Ub6zfyQ7/LIQgYylq0l2i+E9ZG6HTe0a+LX0nIlnden4hpGTMhmr5l7bDmFMZB0uiDpye9tIhVw/6Ic/mxU/ghB3hPk2EJ5X2e52e7jVs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(6506007)(9686003)(52536014)(26005)(86362001)(8936002)(8676002)(186003)(508600001)(33656002)(921005)(110136005)(2906002)(71200400001)(316002)(66946007)(122000001)(38070700005)(64756008)(66556008)(38100700002)(66446008)(76116006)(5660300002)(66476007)(82960400001)(4326008)(55016003)(7416002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8iyoanFS/sfgdISO6LTwPk8vaP1lrlNRFCu+Iy4yaKpmItTfoG8QKJu6AnM9?=
 =?us-ascii?Q?VLwhJKYGVCq4rBFYzc5ELKzUYD7juDdVSOhcBHSNhb69VSS0BikYB6DLXhlC?=
 =?us-ascii?Q?sy9qLNmeVXjCs6bkH9+8XYTp98ryXzo6C8waQF0ffOneeUQB3D2on0tRC+8A?=
 =?us-ascii?Q?AapvGXIEuEAfXeRbgH+np2zWignM7x63XW9C6A8c3WtdLkCtTOy/uS9CXPF0?=
 =?us-ascii?Q?7MJlAvUm3Ro2YUIPm4w5GMwFHi5ca8SdLH2PVwHY5n64je3wit9j7SebctZH?=
 =?us-ascii?Q?zIFjkKAaZ4UF1Pbc2aj15pXwI4kA4SMtVbt69d86mqTTH+FVClmeEVoQE1Hv?=
 =?us-ascii?Q?RvkvohrqLamWyIyID9pqXnH8bqjFrYi2dDkwjutrLOEXSXbdN5rfN1PynbPv?=
 =?us-ascii?Q?7mFtXnXvoW1SQb9CFBiapzHCyvt8aAaHxwsUZaPSpbIuI37A8sZRT7WxDetS?=
 =?us-ascii?Q?2CVEoxb1iDKaq/eMHZ1i/AwcKdAXvnV8L0SyxKw/AsgwNmk/KrMP6MtVzzJj?=
 =?us-ascii?Q?GOYZPkHXo+iDJDUtQxDozLqv74Dl6WqN5pT783sxIvu6FYt+pbAQSmOOKpI0?=
 =?us-ascii?Q?IcrzUxjZzKCk8BaGtcPnXars4G+tQA4tQhvxu3z5h07pUytrxg5V/5ZBT5+E?=
 =?us-ascii?Q?xpnc7utRyXCxjjPHDQBv9QPTZuAU+srk4si6KjFjon3VYi/Bp69u8xxq/c8n?=
 =?us-ascii?Q?/geqsK+11tJIP19uqWGAI2rI1NNIxhvY4xp+kBAVToohy9InphzcbwPf5I5X?=
 =?us-ascii?Q?Rk3bD4pnorUtc2hePFETZQ5kezX4cPbVHjKme5rJzhGKQOeKESPAHDd4gYyo?=
 =?us-ascii?Q?OA4xkhQFem4lrUJxKhYJOCJ4cb2yq7EUuxYsS9tt62cJ3p3qmX5A0zBwq1Nq?=
 =?us-ascii?Q?/oOdssfXIC5vOA45Ne+WZsTZ8KnYsQsMEckz6qZOPuR78/EDZkKaCQM3/Ml/?=
 =?us-ascii?Q?3INRaqBMzvft34WmAKqVmjWoKCx/uG3Org8Ih7LsTiOp8CPpSiSszzmkKN7I?=
 =?us-ascii?Q?0fnHfp/fnoUANSHII7p2sm05xmQ0SSFEm2GdFgPZ3Tqne2bRQVLmCmOEGBlH?=
 =?us-ascii?Q?y4fX+VneMcDkYq88KF3n81FkRwSdexQ5rsbjStoxILbqu7EXUKJMzpo9mJp/?=
 =?us-ascii?Q?L52gz5CArLmBs5G3xSn+vcuzoRfNdHPMPKi9RZiGL9KmqlITiL8okb/ipavT?=
 =?us-ascii?Q?l8UKs24ZSqbA6JCMqdgfk3Jj8vRYXBfWDO/t4BHyQzdynk1EY+YgyelmB/h6?=
 =?us-ascii?Q?iSukPi6W37/slGdUqz/vYnGCMOQgAYlCIxEs0KBRHC2VWdQABa80Zf41pXbZ?=
 =?us-ascii?Q?rAc4YZZ5xYYI+w0KmugSsfGvmBlBb5KQEi9zVoOP5FSnk+9RbWL8TJ4XL31r?=
 =?us-ascii?Q?n0A80zgWKTUBkoDfKhFUMNkGzDMuLdIR7J8XAoFfuwOgcF21i2QZGqj4QGJ6?=
 =?us-ascii?Q?dyGfydWM9ILp2hRWiLs2O5oTyRrAzbP0qMWX79ijHPC3/4j1w1/dLoQaffdR?=
 =?us-ascii?Q?sifIgeppHXzOZyT8rWBRAY1u8yYWkeUgElx3pty9j9IAw30PuEbO/VUJtG7x?=
 =?us-ascii?Q?dHkU5uWfZ0UEtHLczbs8NNWTWuM/mYBM0yH6erB3aWHiOeFsaa5kCzXmA0K4?=
 =?us-ascii?Q?Xw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 717c237d-8fa7-4a87-20b5-08d9bd11c21c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2021 01:50:21.6790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s48k5qzOCkKiw8HejgHHsG2n8Nzr0r/an/0omQyVYQH8uBlpQ6e/ntzy3rIwgIWg163Q3olQXHHIlsIE39eshw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5350
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Saturday, December 11, 2021 9:29 PM
>=20
> Kevin,
>=20
> On Sat, Dec 11 2021 at 03:07, Kevin Tian wrote:
> >> From: Thomas Gleixner <tglx@linutronix.de>
> >> #NM in the guest is slow path, right? So why are you trying to optimiz=
e
> >> for it?
> >
> > This is really good information. The current logic is obviously
> > based on the assumption that #NM is frequently triggered.
>=20
> More context.
>=20
> When an application want's to use AMX, it invokes the prctl() which
> grants permission. If permission is granted then still the kernel FPU
> state buffers are default size and XFD is armed.
>=20
> When a thread of that process issues the first AMX (tile) instruction,
> then #NM is raised.
>=20
> The #NM handler does:
>=20
>     1) Read MSR_XFD_ERR. If 0, goto regular #NM
>=20
>     2) Write MSR_XFD_ERR to 0
>=20
>     3) Check whether the process has permission granted. If not,
>        raise SIGILL and return.
>=20
>     4) Allocate and install a larger FPU state buffer for the task.
>        If allocation fails, raise SIGSEGV and return.
>=20
>     5) Disarm XFD for that task
>=20
> That means one thread takes at max. one AMX/XFD related #NM during its
> lifetime, which means two VMEXITs.
>=20
> If there are other XFD controlled facilities in the future, then it will
> be NR_USED_XFD_CONTROLLED_FACILITIES * 2 VMEXITs per thread which
> uses
> them. Not the end of the world either.
>=20
> Looking at the targeted application space it's pretty unlikely that
> tasks which utilize AMX are going to be so short lived that the overhead
> of these VMEXITs really matters.
>=20
> This of course can be revisited when there is a sane use case, but
> optimizing for it prematurely does not buy us anything else than
> pointless complexity.

I get all above.

I guess the original open is also about the frequency of #NM not due=20
to XFD. For Linux guest looks it's not a problem since CR0.TS is not set=20
now when math emulation is not required:

DEFINE_IDTENTRY(exc_device_not_available)
{
	...
	/* This should not happen. */
	if (WARN(cr0 & X86_CR0_TS, "CR0.TS was set")) {
		/* Try to fix it up and carry on. */
		write_cr0(cr0 & ~X86_CR0_TS);
	} else {
		/*
		 * Something terrible happened, and we're better off trying
		 * to kill the task than getting stuck in a never-ending
		 * loop of #NM faults.
		 */
		die("unexpected #NM exception", regs, 0);
	}
}

It may affect guest which still uses CR0.TS to do lazy save. But likely
modern OSes all move to eager save approach so always trapping #NM
should be fine.

Is this understanding correct?

Thanks
Kevin
