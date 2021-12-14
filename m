Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE9D473D79
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 08:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhLNHQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 02:16:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:46964 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229752AbhLNHQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 02:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639466175; x=1671002175;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=WXQq2T8cvENvJ3hFmd4JWoicxVfk0zG5SVgOKF+WskE=;
  b=F+eex1DhAj1UqOSKKaFt3Z4GV1OR7xt95uRf+Ny1VJQ2PO7mNAOIMOmY
   Vs+1NbNz59Brg8HPzknioq+ZRakp6NNFR4qCyWRjnwIwgUDqhPs0be2LY
   ZNeNt9PWv+XqyCnhl+mdb2xUnYJ8mo5BwqrxYT8Rjhwv3SIKFJweutxTz
   A5pKI50P9VAQXB0FylBDnM+MHh4kXYUJVOiYpdnEyfkmMROTKxBE0hCin
   CIN/iTbdx1geNRvyUuHdkqgJyfXJFTKuvR65IyEYG75+/NU591fFDVLYu
   Zc+VmGMi/k8ybT3esaH+cLymcbRXUqO8V0kAMQuzOBJFpPqn+8bc6k+Dk
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="325190630"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="325190630"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 23:16:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="754733435"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 13 Dec 2021 23:16:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 23:16:14 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 23:16:14 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 23:16:14 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 23:16:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJqZnvqVmeusDXkJGNL4Tomw8n0+Iv6K2RcCqJwtJ98HShDKOtdkIKsI6rfwuq0suZmcMKIPtdiwe65nqRYRisaUTh7ev/zAsUf4Zfm0XaIyo5goT/iGTuWlpPz0ByM9UlWwhuNadsXAHAAMNFPXZfPLf5DP0JyGvwRlq/oxnLi79hq7HfjEZOT4V46nyUaY60c5/Lb4JpboSiGvAEztWT3zrhvevKuxvBQy2mQ8T+wO40uB4N69o520O0mEp2Agg0c2HihQiv2cXLva4BcQD94cByNy28h1MXv0b9va0VZuyCzLVeGdoqlKJi0bu6KYrvd+xRXWjsdqBWYFCB9Ulw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXQq2T8cvENvJ3hFmd4JWoicxVfk0zG5SVgOKF+WskE=;
 b=VhDqcimd6bKUbDUr/+JPa/E1hHEngl1tD99pUEUlCSvMcRS+JiNC/bawKjvh80gBoNE3bjHEPmSUrKKUEpnSYtooe8TdIlKShVkFXdS5J359M9J6AWJOiocuL48PRtPd8FzUGId6v8D4sU7cxiENsqXwJJmYS9LVDQOaIC2F0x6G+SwrAwXqdRyGOZ5DE88+ud0ILIch7MBLZs2ctTyuy0726I9fONs8SUpaurYdUjVHGN0aqfEBDWNfUm8NML0eEa22EUl8y8SeGimiYbfkLKVmsiCAVZ04R0YOsPjodlk62R48iMxK3px3K75VRxE70uv+cUoFGuNw++PDdcva5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXQq2T8cvENvJ3hFmd4JWoicxVfk0zG5SVgOKF+WskE=;
 b=IfcvlXjHNP6vqesJkCuY1SUKG/bL3v8nDfDb+YRhpnJRKxWhxrJBNGCgP3vdT/7XeC+ZxSOHGfZ9J5hLLjKhnhx38mMwHherUxmagZEd6Gd/AiJhM4X4iSHtcVGJmCkc5GPySSFKXHgwrr0Etvg2DL43H0mBVb9ejDR/PXacYD0=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3572.namprd11.prod.outlook.com (2603:10b6:408:82::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 07:16:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 07:16:07 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: RE: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Thread-Topic: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Thread-Index: AQHX63yA8U4G90h41U2WCcqe267j0qwwjwEAgABOGACAABs9AIAApPFA
Date:   Tue, 14 Dec 2021 07:16:06 +0000
Message-ID: <BN9PR11MB5276CA6A8D1CF84F196C40598C759@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
 <022620db-13ad-8118-5296-ae2913d41f1f@redhat.com> <87y24othjj.ffs@tglx>
 <87r1agtd11.ffs@tglx>
In-Reply-To: <87r1agtd11.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1a0b39d-5ada-4dfc-f00a-08d9bed198cf
x-ms-traffictypediagnostic: BN8PR11MB3572:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN8PR11MB35725614E2887AB5D037F12A8C759@BN8PR11MB3572.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JJKBCmbihTEu/KQ2Ak0/bomWP+PFxnTfPaWKNyoL28UdqfV4R/tWHnVRm9U//8KWUHLpGqVUoIZpcHDQ6ofKxu7F5EbjQRKPWpt2EA6QDPqu9xPhj7IulBxjBaxFNWntYoBZaUg58EuwerryM2a5OqwPprgXjVX8Cy+VvpRHJTHZmE1JdqHXjPI+fgWfSs3KDp0NDZSUWV7Uy6EAA5wEsFtFly6gmslw06iuCugaX9erJgOIwnKUqGRhmVGbbEj12qUTguq4ja1z6yVV7YpIlSWQG1vnufyEOsbsXI8o92mVUMgHfFEHhQjX6/vw64DtxQh7cH50nXKkMHvFbdnCH/QhElhWn2X/RIrCSh+L0UfEGHeqajev6yriivtJCDToS1TwpZNEBU6b2JjdhXt0axDffeAaBGkwiGvQQhqa2LdzrsnLIXwGBBJT91dpJyJaUWVH1ctu8EGZsmxYCXedL81vPkI4Q0X0aDtNfKG6B8CxvdsbTKB4P8JmF890aoYAyRnQNjNt9ZoHeJ889btKhOolf78DhKN99e2IPhMgWHGG2OZalQRn6W7MZH7B1v+ZBKPwZqJ3TGs7DCG+MPXdjuj/OoaR5EjYYLA/hjD4ESU9g2U6AP/Qf7z2NezqvbL9v2O0x8onDV1QnIGKbpWgozrXs1xogOgh9O0Yqq8WuIgWItdxGT9g9At8y4DO5lFA23x0PqPd3r25ROMkK6u3eRsOqlaXfznf6sz+gQ+CC18=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(71200400001)(110136005)(186003)(38100700002)(921005)(64756008)(66556008)(9686003)(33656002)(2906002)(76116006)(26005)(66946007)(66476007)(83380400001)(66446008)(508600001)(6506007)(55016003)(82960400001)(122000001)(7696005)(8676002)(52536014)(86362001)(5660300002)(8936002)(4744005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3CSt5KXSfvy6egeUF0cVN7i1VT3/JZ5obQfOOns72iQwS3lMP9PuggqqbUiP?=
 =?us-ascii?Q?DrTOMz+g9t/WQxOAgNr7E5mhAMqFJAmmA2YWOi1oEDEUC6ClTQnVmHp16Tvh?=
 =?us-ascii?Q?vqoKuZT/wEnEOtMcwX+1qag4O5+LTamV1gMzBUQar76+EUeZ++ppVLTxYH2H?=
 =?us-ascii?Q?I+zzlAebe0G49T6YNPjxLHqN0cFHOkQ9liO8l2e0JsAYwuGfyTcii6QbqIRO?=
 =?us-ascii?Q?NQP2k66PqN9+KbbrG/tLkK3OFfYfVflAlbYe2oAYidk1iWRdcyDWeZHZoNbU?=
 =?us-ascii?Q?hLZS7CniXSyPyx4+3HZoz3C2vpm4Wq5lU9lc75u6l3xZA06z8luVPW0IZpMN?=
 =?us-ascii?Q?3wBCtc2/gSD8A6+2JeQ0rAc05O4jPr2a/sN8gU3Saqrne5jXulUsi//SS3dW?=
 =?us-ascii?Q?sb1CYUkQ+WZS8qqe2+OvhU36f2v/f+FFwkmBTIQOCDMzvMC2ndHSU3sbCzIh?=
 =?us-ascii?Q?MCBdLSsUsXMFM/emXtRdnLSsHCLOkOltv3RjIJxFchTJbmXNj1SnZCTpqU8X?=
 =?us-ascii?Q?HKWIylp3L0BpLD537jX8VspukeF9vvQM41Mi28rX04sqW3DdwL0X1cXugfee?=
 =?us-ascii?Q?YXyw1RPlCErXW7aWEpVxI5EDAxN3yt61jes+rQZGIU89GJVRnFbHpqHWdVlI?=
 =?us-ascii?Q?pGavvh53Z2Z+Aw3RAtNaQJWRwHrfoU2/dS9L0oePPTysgo4CYsPms4H65AZU?=
 =?us-ascii?Q?SmeNyQeUbshnFJjZM9q4n/UDhKqzYuh6ExPg62LvRGJTCn+8JRFlTV5Bf1X8?=
 =?us-ascii?Q?NFSCKmD465hsvWxHeIVTmYzef5hvZYBqhmGlUVMMKIBZ9I9rFC5wpqHFluE1?=
 =?us-ascii?Q?YbOb7atcYa9TIuf2C+LjdS0o3Su34ZLdtM2Nap36VutHUghFoAqI3qQQIXG6?=
 =?us-ascii?Q?pJt1RbD48FGL0GLiVaSqR/aNKxNzyoMEBBnur7XeGZ6H3GhWIdtM+kjTOenU?=
 =?us-ascii?Q?j25uIM9xJErDUXh6kbfaaZYyB1gqlTQcb4oyzjorgcpxvT331Ijj6YVdnBlv?=
 =?us-ascii?Q?HNMH46gi/mqlww773M5ZF/uyan+nummor3fiwjUc8RGGf3Fit1g4vUi3Fe5g?=
 =?us-ascii?Q?SiDOLv8EzmoSKN5NMPBOWfgz1EK0d68ZjVlUMsdYhqGb+L+NQ04kqOGYFaWt?=
 =?us-ascii?Q?SAS89H+mGkhq0oIRq65IfBac2keokleitcfOAHCWqmLdXtq0fWb9H5S5UD4D?=
 =?us-ascii?Q?a8zhQg3TKhWL0gwKBl5uQjwozB2jFaj2pP6VyX6d01iy2oPRBas1IUsT56yK?=
 =?us-ascii?Q?dwUHvCeDB2I0N4u5UC3lOieazjJpAtsno6Sw6lkS79mJJG3xQfi25KEL9qvR?=
 =?us-ascii?Q?boibgaa8Ld1ekwt4cEQYCUdQ39JvIIxlUYbo6iURYg7S6MZmt1kEdCrY7opk?=
 =?us-ascii?Q?nfZ/Ewu4ZwH7WWq+hTxVr27SfMVNSgNOAl6pxTiyn2+wQGzuuSgEoCrJ5jwN?=
 =?us-ascii?Q?D1IUjp5aMORxlPHnfrJGUyk70rhoD+wc1IQ0KTyj6kNqVvqXCzLL3sR/k3lr?=
 =?us-ascii?Q?AqIZ3IcbrhkKtcmxaO+fzWzj83ibg5dbPqy3p+zhrBQlCMyiVByq7Nk92mwA?=
 =?us-ascii?Q?TnNcBXpKqxXZ8ggaByYWEWZNdhvDBFf/5KY1oWJTO9nJZPsUa1CQJ29jbPME?=
 =?us-ascii?Q?CPlvkej8Q2dUmFon5C0RD8g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a0b39d-5ada-4dfc-f00a-08d9bed198cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 07:16:06.9976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hIb1677l8cfJfwylWwo6IqC9O0SGjyat0rHwnvMMoDUagsno5o/+eTr6rln5cz9sRFNUbN8MXpFGrEL0K0dybA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3572
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Thomas,

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Tuesday, December 14, 2021 5:23 AM
>=20
> Paolo,
>=20
> On Mon, Dec 13 2021 at 20:45, Thomas Gleixner wrote:
> > On Mon, Dec 13 2021 at 16:06, Paolo Bonzini wrote:
> >> That said, I think xfd_update_state should not have an argument.
> >> current->thread.fpu.fpstate->xfd is the only fpstate that should be
> >> synced with the xfd_state per-CPU variable.
> >
> > I'm looking into this right now. The whole restore versus runtime thing
> > needs to be handled differently.
>=20

After looking at your series, I think it missed Paolo's comment
about changing xfd_update_state() to accept no argument.

Thanks
Kevin
