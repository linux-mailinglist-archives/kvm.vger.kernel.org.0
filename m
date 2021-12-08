Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F7A46CE57
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 08:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244502AbhLHH0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 02:26:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:49707 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240685AbhLHH0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 02:26:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="235287395"
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; 
   d="scan'208";a="235287395"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 23:23:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; 
   d="scan'208";a="502946986"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 07 Dec 2021 23:23:22 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 23:23:22 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 23:23:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 7 Dec 2021 23:23:22 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 7 Dec 2021 23:23:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guxqnNUYM33L/SsGSzZaKYB52ygo+PZelG3txC9O6Q1TlahKEbZLO/3HJYcFNlRX6yxdQNPei6bQ6+ZnRZ/JC4LL2Z62JytkYoRlytbPJmg2p7tzl9FIstw7Ej5Dvr3D6mMQRFAj4RnsAtELg0UE3vg4qRZAoIK7fWSDn4RS3rdDwL4hrEfCBNA79qLKh+BO+D0LzLXKolN31t4dV55DT3LCagUgNCiiL1VZJ/E7ZICT+x6SDWWjECAaSzjLOWFIvNKVHY4s27he5VJ/RNKyTXXzraFLePiZxUVD5IzZPnt61ZBFoe2pJ0dg0LQYpe0RpXoxyAb9tmSxsqCf64JqBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oW1MqK6DEt0tcYpeXvm37Y5mKkdKqSPPkuPW/RPWNIM=;
 b=XEbmTm65fTs25m/mcCTZq/rzL1FoDU/0iu4LqVxfoAg1zftXVAeEcksIDOL7lL+5JpaY0/VqLPYRmkbxvHRiP0WHke+Hn6lSdTENsOPxXFit/oZ7TCPKoWPsHokGymxF3hbAo2tQLDKjJ7QnPZlEGJ3n+0/jS0/mOFBaWq+CR5niUnbl0qhht5So41IcXmcmB6PDxVrUYeUAiyOr3V9Mm3+m1uzyu58waBORLhcWGeGf7mO2p1MDUEw0ERWrTTM1rQuSSf4WhlH56/klgWfnczagKBRteBaYwzv8Nd1exP1kSxTUul5C1t8VZpOdHYJQwYzorTzy1jAn4lQhHFUC7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oW1MqK6DEt0tcYpeXvm37Y5mKkdKqSPPkuPW/RPWNIM=;
 b=e4e+X29k1LlA9bGbYJxExI2pCXGdp4JBFgf8Nc4wPmpsGXo30gWnUd/eq3Xl5Uw/PYYWRYMwPz182ysCj8aELl6eVKKIFAfRj933nB6ySPck6tKuiEqCfx+SmwTI35ROBUhIfSpUFgx3daTuHt9QAQ/GlIDY5JRqhPDNS7fHaR8=
Received: from MWHPR11MB1245.namprd11.prod.outlook.com (2603:10b6:300:28::11)
 by MWHPR11MB1600.namprd11.prod.outlook.com (2603:10b6:301:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 8 Dec
 2021 07:23:18 +0000
Received: from MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::9dd3:f8f0:48a8:1506]) by MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::9dd3:f8f0:48a8:1506%12]) with mapi id 15.20.4755.023; Wed, 8 Dec 2021
 07:23:17 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>
Subject: RE: [PATCH 13/19] kvm: x86: Disable WRMSR interception for IA32_XFD
 on demand
Thread-Topic: [PATCH 13/19] kvm: x86: Disable WRMSR interception for IA32_XFD
 on demand
Thread-Index: AQHX63yGGH5XLxNQFUm1O2KZf2XoyawoKZ6w
Date:   Wed, 8 Dec 2021 07:23:17 +0000
Message-ID: <MWHPR11MB1245DFEAEBDC57298ED4E073A96F9@MWHPR11MB1245.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-14-yang.zhong@intel.com>
In-Reply-To: <20211208000359.2853257-14-yang.zhong@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea2c1918-33ba-4315-bee0-08d9ba1b9b23
x-ms-traffictypediagnostic: MWHPR11MB1600:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB1600E7FDB82B2C6158F91966A96F9@MWHPR11MB1600.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ERwep9qOmgrM2m9IUusJyC5bcZMYYWLIPx4VApvqlcQ8L6K09VhxmNmiHDp0UyT5FqbaW3a9JnvY+Y8FhIJ6hzFdCRt39G+91XfIPcm1AkKiIa9VimhDDOlctVAsaDG49mlN+OWDhlyNX86PcJABcODXJaXbNmVZn2TlPD//756QcUnZudDgn1+TQ2P0L/Ov7gqSxjE9CQPeZIxqvdsb6FUi50G5Pxzc+LMpWpfBGEFyG3PCI1q9rCrjVou1TvF+gYOmBHgsRhScdlpNdHF6Cnfbtj9WntfVBJ/qxRqyO0PK+/DmuJqHkuuA4917MxnWIon7HlJ1LU17v2rBFiq4nOqueIhGTHew47vopNWKRbYc0GVRK5TkDcAzhclKUsYodwo2otd0o8o/Fm10uPkvlGk2djXDSRBwU3tXxPVn4qj8vXaA5ZVBDkyKs6pkx7fXPq1elBUI+/oIDMb822goj9aP4SOAeOS1jABnzO6o4E4oHqubxRU3pQ/+v/kjwu+40y3SB61NUXBau/DMGW0EqT4ZGnZgbK8/UlYU92p5z504H6tqgSHy4l6ToqdV6fb9cJXvmda7vqPKOvYJ6nulWXEPTBYv9fVwkYEpnGSe/WjS5smmmzjpLGKb8TDB6Tx7W6QYhMwFP2tIh/mXsKBXix1eIp3bsew5HYtnPLAL4h2G7UcDjHMhdxWZdEBF8wD0AStbYx+FHIO3e72Bz/XnE7IP6PXds3a5IS3iDhKgkqU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1245.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016003)(2906002)(8676002)(82960400001)(316002)(9686003)(26005)(5660300002)(7416002)(53546011)(6506007)(66476007)(71200400001)(54906003)(38070700005)(76116006)(86362001)(7696005)(33656002)(508600001)(83380400001)(64756008)(66556008)(122000001)(66446008)(52536014)(8936002)(110136005)(921005)(66946007)(38100700002)(186003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HAh3XZnFhjuDKEXKB3EkLoZa/ctXADb415rCxzMJu2aLwXzg5FROwQIWccZb?=
 =?us-ascii?Q?FDunNcv4sbuNwavZI3ENdpJy78snXCQtTyk62ISzuCxI4MdkpKfURNPw3zmA?=
 =?us-ascii?Q?6XI4dAncCU2xj5k2bI192GkC0kE6Obkgnes56T4ts/x1lAgKsZZn2aSb0TRj?=
 =?us-ascii?Q?VfG72X7MARYvZOZm4wDZFJs1qmBYD8qcHAEmN0UGWq4spbNZPkT0zUV0WTpg?=
 =?us-ascii?Q?Kr5Vtw912j2mAeannOozIaAIuPz0gO1C/l5DLW2eVd/nv8j/DOo+wFemjHwh?=
 =?us-ascii?Q?ahG4YDOcIn6Qdrtu+bDs59IFi0remvltdb74n4ZbH9VFX7Yjc14fzpnoGFlT?=
 =?us-ascii?Q?I05LwQI48mIqmIdb0figxVKSZ3J46Dw2D7cCJypv3X+XlzSw6YK7Ix37g5V6?=
 =?us-ascii?Q?F49DDLlMHxG2+hLfcDFYOoax4NeWn5fbl0Q5Ki6or9nf6hQipzvO4zZbyYFt?=
 =?us-ascii?Q?00xA9VmjJbISl6nEKK12b5JRxQau9LMcCs8n4MddFkwsUYxJBeqJ8s1nAP8o?=
 =?us-ascii?Q?7nClcABUD1ghMyci6sTQHjVZhvEDnD11ZH8G7GQMd90tZkeVdMx1HpyeKYw0?=
 =?us-ascii?Q?2rQnHcxV1D+1gqlFsCIRkTEVy1fb3OL/AJZ/PQ5sTcLHIms41hiuyjBbXmd0?=
 =?us-ascii?Q?MeLNDwaMVu3xHQ32KflmOT7COmwJhhIxfS4oHp4yowKxrVs1ZVa1vuT9wWkH?=
 =?us-ascii?Q?c7cM42v9st7zPZPTbZimR0pjSncslun5tbKhIoWwMIk+HnMdurbD2zF1PT5k?=
 =?us-ascii?Q?4wuoI9jNQXUrG4E/ivuE39tjzmRqHuFTROGQ4kd9c94Rb+6soi30e+ylVlDO?=
 =?us-ascii?Q?fxHtF6XnNLInwEKvK2y3yFzr6OFSMN+SSyL9zXqUPxnLjPY8r2dsmNhoj7qk?=
 =?us-ascii?Q?JEJvpr//H749AojA6X6jjYl+Usk9ndke0c5sCquJHzzGGYW8YOWwtA2BLpzP?=
 =?us-ascii?Q?tVqibQP3ebDS+hSID+Qy7gh/EyXfxUeeHl5I3eKYTLbtlLMli9bWBkdM4bNN?=
 =?us-ascii?Q?CYAxTMGELtWhBMqO4W8NtkR54ns9cho8qioca1qbeK4uqLvRzKNxFZVGBLyH?=
 =?us-ascii?Q?msKcR2SsSBeD1bwgcHiHGs6TlcguLxIMrDQYemLX447UGaI9lLIg9Ai9Vcwk?=
 =?us-ascii?Q?gwC0bTpGBEJBhk2watDGaZU2a4XCl2ZoU+zytIF2bOqt2dls3skmUE9Bu3aB?=
 =?us-ascii?Q?QdgFoAj7PufIpfAjgqasjJqANI/QlaffaN70MlgITjnqzlgMFz6TG2ssl6t7?=
 =?us-ascii?Q?ntEvvgT/9Oj5kS7NGGpS5lGqTNeoHeu0qSEzhTmbDoq44JffG6juRurORB4L?=
 =?us-ascii?Q?utPHK+Po8quHwa4NJhiPbc9ZbSMgcx/vt299xmANr5PqIWxoUcbZQn0OKact?=
 =?us-ascii?Q?lspP/IzYArXqg11FvQGCob3fFFYlq2P5Y/v90xnTUJdBZaffZxMAsJ0HRLNo?=
 =?us-ascii?Q?zOg0flGRHsomhugU/myzwVu89N1wG0Sx+r46AgY/jdAJ8q3imaJWKtiZaEFA?=
 =?us-ascii?Q?WkcqwrXB3AfNsWVdD1ar0WEtI4F78/pCSAjCAfJGSe04p+MfDbFthhpnDhIs?=
 =?us-ascii?Q?DCDNR8HibRe6vRHIi1FKOPo7SOx/ke2YNg5li3JkdfduLCW2oZnrWpVvspss?=
 =?us-ascii?Q?1A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1245.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2c1918-33ba-4315-bee0-08d9ba1b9b23
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 07:23:17.4462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gvEo3iZnlNa+XQYVA0ZxlX0dBZ9AOvKweI3JS+U7e01niix6TXAu9Cg/3j0J3SoPgwtiDld2Q7pW3rcEYdlc/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1600
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/8/2021 8:03 AM, Yang Zhong wrote:=20
> From: Jing Liu <jing2.liu@intel.com>
>=20
> Always intercepting IA32_XFD causes non-negligible overhead when this
> register is updated frequently in the guest.
>=20
> Disable WRMSR interception to IA32_XFD after fpstate reallocation is
> completed. There are three options for when to disable the
> interception:
>=20
>   1) When emulating the 1st WRMSR which requires reallocation,
>      disable interception before exiting to userapce with the
>      assumption that the userspace VMM should not bounch back to
>      the kernel if reallocation fails. However it's not good to
>      design kernel based on application behavior. If due to bug
>      the vCPU thread comes back to the kernel after reallocation
>      fails, XFD passthrough may lead to host memory corruption
>      when doing XSAVES for guest fpstate which has a smaller size
>      than what guest XFD allows.
>=20
>   2) Disable interception when coming back from the userspace VMM
>      (for the 1st WRMSR which triggers reallocation). Re-check
>      whether fpstate size can serve the new guest XFD value. Disable
>      interception only when the check succeeds. This requires KVM
>      to store guest XFD value in some place and then compare it
>      to guest_fpu::user_xfeatures in the completion handler.

For option 2), we are considering that fpstate->size can be used to indicat=
e
if reallocation is successful. Because once one of the XFD features (today,
it's AMX) is enabled, kernel need reallocate full size, otherwise, KVM has =
no
chance to reallocate for other XFD features later since it's non-trapped (t=
o
avoid WRMSR VM EXITs due to guest toggling XFD).=20

Then KVM doesn't need to store guest XFD value in some place. And kernel
fpu core may need an API to tell guest permitted size for KVM.

Thanks,
Jing

>=20
>   3) Disable interception at the 2nd WRMSR which enables dynamic
>      XSTATE features. If guest_fpu::user_xfeatures already includes
>      bits for dynamic features set in guest XFD value, disable
>      interception.
>=20

