Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C2B42ED73
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbhJOJWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:22:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:5749 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234769AbhJOJWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 05:22:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="228163574"
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="228163574"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 02:20:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="461512626"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 15 Oct 2021 02:20:15 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 02:20:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 15 Oct 2021 02:20:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 15 Oct 2021 02:20:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzD3SeW0n7GJGcfHd8L+0m1eimjpgV2WLrv60z0HWbQSV0iUYJyyJAqacU1rPu90JCy29mEbsDpNSlAI+N3izVC1SLyYil1FYvIeNwCHO0G01+MIiT6llsPQAZ4JGtIQOweNuJXmCnEOLW9qGPVP5/U1+P1cL0hiUirs0W4I0HlaP7f9Ob1kkBm6WtTs2RtuIh3uuxfaDmqKyfBU/MbBTFEhutH31pa8dRbgwivgq7yeP2iaL7yP+91YohT70Yoh3RFwsTyrQ6VZUMJ/LvZFiOvL1AqIQ8S27ITZy9Ev+l6vF2Vk+ZJ5eD5mcbN2uifNyjrWy4U0RyvXJMwrOFsWWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0AMNCkp6fbI6bZf9sLH6YKQnLjOWOzYSSvR48NTyAoE=;
 b=mCD7/wn43sj/gxdCCV1VUZhqEK7f8YmfriA3+bu70IqR1xr1JuVn49yifYhA3AS3hCDG4kqnywgYfDeqN/EYGbPKAENl6wD/fn+wXqmPIxzTKNpMCVUwy62h3hE24G2jbWdyzkkaPsYkR9ezYU7Nd4tPvqayBFxAAgs+qLBLp5xyNYg+ni6swEZQoKT3GThnasRgHfeWDuvCDGWidWq+VpcDGAXX2b9J+lI1XE9VeBa88xJdpGKZptUZieZgzh8WXGfyP5GBdAajUrcDQ2Sxt8qIa7T7HeXF/Q5NKhorWqB14mSNRqw9a8AgUACrZDWEtXUGnHZu7UkFOAit/M+E8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0AMNCkp6fbI6bZf9sLH6YKQnLjOWOzYSSvR48NTyAoE=;
 b=F7mLtu/pewhv5mLXurgAwnoa19IPwl72dWITYbpe00iw+nQ91lRXMm2Ezu6qCktx352NHM9lX/QDzyyMrCCA88HbbpJdKDE8ZyCGRasuZiKWWxS72Ej4D2XQ5Ls2VZ53f+Xl3DiphHBlRMnANNKVl4JWueYgreTgqD135ZFo9+c=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BYAPR11MB3029.namprd11.prod.outlook.com (2603:10b6:a03:8e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Fri, 15 Oct
 2021 09:20:13 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 09:20:13 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwIAAIoqAgABafQCAARh7AIAACH/AgAAb+oCAAFYIAIAADomAgABGxACAAOdDAA==
Date:   Fri, 15 Oct 2021 09:20:13 +0000
Message-ID: <BYAPR11MB325644EDB124F3010D7668FBA9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
 <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com> <87lf2v5shb.ffs@tglx>
In-Reply-To: <87lf2v5shb.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa835e86-f6ea-42e8-b66c-08d98fbcfeab
x-ms-traffictypediagnostic: BYAPR11MB3029:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB30297D09977AA8761F3E7FBEA9B99@BYAPR11MB3029.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZSbjDGOWRVFKi1a6Pxk+rornTK6J5AP6AMg47nUHl2WleXYSgUQiBFO6NbE4TEfyNPM7JMmLqWHUn3VlQmTa5fShtP5DG/wMv6Zqm0e3ti2djzFRFU8TdQOY/y61Ciw7IEGnq4gL8782n4jQvnoEgxVDNPinaEIBm3UTq7tgryKqLJlUY6KQKZKnDtjwb3lf3skY/O0zTkXgLBQ4hF6uvbRFbmnDHDxubNXkJR6LISQod68Px51AZI6zcYH4zSWodgx6K6hZyumMTeT1fKeXtxq/wyy5nhkxQKLg8Rmd3xqRZ5THimRLcc3q5BEIS7SLfoiOjcPmbM9qylMtCuKR/05NdStkPRqGlzZwU0U9CKdVn2eRIvY2+YFNOzaEm3sjG4qPiZd+LYLqZlKZNgHqLOXAa//oQmEDNiRYCVABnjCpllEt4rBt2MEjFPdq3cbLeTLmN7GMnJ7QGo/QBwMN1JEhPwOdfTIa6L9RPf96h/d5mW4hxC7vjKUtWSjXLy1U1UK+h6G9IXY60NgpQWF3oRD4cDVkkXnS7TENM9tTmZiztcRsWWeWIIaYtZA66Oa+qHEbtysNH9uSQxIKMD107wW6TFrP7ZNmcJQrn7NBDhUL3YcRUYHmJ0Okct/jedP7z+AEpHNQ+aloLEkXphaCf/L8J2sp1CjlcHsEK03GixDFiTcZcg0gta4kAVJH1/UK78XiqxehJhP9I53GTYoEXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(6506007)(66446008)(7696005)(76116006)(64756008)(9686003)(110136005)(38070700005)(54906003)(122000001)(316002)(66946007)(66556008)(55016002)(53546011)(7416002)(508600001)(66476007)(86362001)(33656002)(5660300002)(26005)(71200400001)(4744005)(2906002)(38100700002)(8936002)(83380400001)(4326008)(186003)(82960400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8KLgsFAS7q5pm3DHOzoiAa7NmYLjIYiamhx0Wu/yaFo/uXf9nIUzb0acsGTy?=
 =?us-ascii?Q?WEbSpAVqtbPj41a1AzW/IUt7UoLo+WN/RGOPgRsW6bEdkTkEK5unyG2TtGiK?=
 =?us-ascii?Q?XcNzN/nX83PxsZC60Rktw1XOTlvu38lNQzsjimDgabdZL5MZU2F+uAa763fo?=
 =?us-ascii?Q?BLmhxyyFOXO+lY97PRol7/DZO3Is3zRem0xnutqAuVsPLj5XikT8x49WIumI?=
 =?us-ascii?Q?gmO3T0fk69EH+tyV2XCtLf8peS/swfG8DnZ8TUhRP/vJo3RcVBndlJ1IaT1K?=
 =?us-ascii?Q?h4Zvp8/k3rc51xXIgYUAJoCicFC49/W+KkgUhxU652Sw4in1SVNLgUgw+wrK?=
 =?us-ascii?Q?W7VcMPYHQxWNzjBpbc+rJqQf1nOHqGFCA+WSXBnNTUSjBC8ma5iSLuC9q6s2?=
 =?us-ascii?Q?oI1vOdyOw7XJc+vkEglcYQ2zjwwmavs3LjHH/RppumtSL2MLUjY+uu8OpRUf?=
 =?us-ascii?Q?h6IZkqrSJ0z9VjbEgCVIMev7v0nmksSOUyUXRjwXBWNY67RI2hgSoWwBsr07?=
 =?us-ascii?Q?eMloIpx3GM5/ftU69cg9rSE3LMPHQ+1PFYSFAJWR8B8DnibcJyvEcsNjWgFP?=
 =?us-ascii?Q?huJRHyYIDIzfFsIy6TwMXfzwWZe9A90GEdNiZVNhnoB2fKhvoT1L42azfymU?=
 =?us-ascii?Q?tmQ5kZ8rFyRWPD46Gqj17L52FRIUIAR1HtdTSb1hjpLs/zLSuGfOToM2k5F7?=
 =?us-ascii?Q?rYutvpLb4Le4x98IiWiQSG6KuVvDb0u/sW97uUzmpwajPGqsbiDGuYQnn6/7?=
 =?us-ascii?Q?c/j9g6fD/JddBx92f3BaDxRVujwqNwY6VDEEPKrne7oZ2cvN3+gi1tJX4vLl?=
 =?us-ascii?Q?fdXSP7YJ7q8GrxEke3hcvqgCq5YQ7UrDwfX7r133HZckgvC7lWX689flKclI?=
 =?us-ascii?Q?1TyqYVsN21C/9jIZJq23LE8oFN/OalVW3xpaRY4K7DkmB+rJteLw3b2qQVzW?=
 =?us-ascii?Q?IeohWVuUkKweZgZY2YF0/hWgLDxMaqoMltgJy8tyLJme9k2wySKc9PybjoDl?=
 =?us-ascii?Q?qEFVi6j5HKUMWoF86n51DIlnWCV6BN761etWMvYXx4dW0utJbPsyWOarXRQF?=
 =?us-ascii?Q?ijiISL3KmYVMYXB++RIquFJO+aFeVyUUl1N7PurXBJKVN4sVZgB4S/T4ooVb?=
 =?us-ascii?Q?VLIVaXgdsDAG1Uy3dBTAyX5Oi8p7REujev39dHchChy71QkIdsIv0DK+di9+?=
 =?us-ascii?Q?Aaa7t1RAXtmrymnMzwOd99MOAIBmyhBAIMNZ837ktJtbNPXbKxxAabOKege6?=
 =?us-ascii?Q?atw2dQtiHKmeMnlDlPO+1yyu0J4IVhpn7TIOpHX9PzSXgSXysu5zavWNXqu0?=
 =?us-ascii?Q?4x7EY2oshufQy8fbwoSzjYgJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa835e86-f6ea-42e8-b66c-08d98fbcfeab
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 09:20:13.7426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e7zwDRTdIEPM+/E+J+d66OmesCuf3h4i74G97BajneG3FRMpLejgdFAZsN+gvskmtxBq3nESNNCQy4F3R6UsUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3029
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/15/2021 3:14 AM, Thomas Gleixner wrote:
> Paolo,
>=20
[...]
> >> vcpu_create()
> >>
> >>    fpu_init_fpstate_user(guest_fpu, supported_xcr0)
> >>
> >> That will (it does not today) do:
> >>
> >>       guest_fpu::__state_perm =3D supported_xcr0 &
> >> xstate_get_group_perm();
> >>
> >> The you have the information you need right in the guest FPU.
> >
> > Good, I wasn't aware of the APIs that will be there.
>=20
> Me neither, but that's a pretty obvious consequence of the work I'm doing
> for AMX. So I made it up for you. :)

Do you mean that fpu_init_fpstate_user() will be updated to add
supported_xcr0 later? :)=20

I'm thinking if guest_fpu::xfd is good to directly initialize as user's
init_fpstate.xfd. Because before guest initializes XFD, "hardware"
is reset value. So it would be better to make guest_fpu::xfd the
same so no need to reload zero before vmenter during this time.

Thanks,
Jing
