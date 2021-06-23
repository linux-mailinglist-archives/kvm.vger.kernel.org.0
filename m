Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A433B13D2
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 08:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFWGSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 02:18:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:39826 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhFWGSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 02:18:41 -0400
IronPort-SDR: HKpPVY9UMKsoz+KFIUIClL2f/xQ0pNTqHOe90ObMAfVCJEjCQSjMOsgsaOwHu4Q6clqDPw7iWq
 67zLQEgUljIQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="204194731"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="204194731"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 23:16:24 -0700
IronPort-SDR: 9Wpjf4dH45vV3Snpk5A1KevF1nc7DzL1R8Fi8K2uMQ0tJmRQAupzT/MijxEleMDIpVGQnLZPMq
 Ju9l0oMtSizg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="556034215"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 22 Jun 2021 23:16:24 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 22 Jun 2021 23:16:23 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 22 Jun 2021 23:16:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 22 Jun 2021 23:16:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 22 Jun 2021 23:16:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abI7N1AF/vTmAx0wd0ddXWmhTvjDgepz4SRIVXZgYIHZfXT+OQEURuwMt2f2WsGt6+r/jm9SimM3X2nGTMUl61WTR4vJzmUu2sksooIUFH/QwLL2BHu6l/pQ0tw98gEQWFLfgvWJpgetw5plWPDEv2ONS5sCsd1b928RxwrmtZzc2DuaUCxSUAa52Z/n8lOPibmIOqjJMi6e1K/7azQciCEojI0s1CpZmFMXmsVKsUhoZVhyvCoV8VnZXdgiAk5bMKkKfZ8apOJyVTQTYU4H22+vK/Qlu8RLf5MDmDW0G2MhRgRdoOnyQsjKu8mEMFKLW/8jo3cl2y65hwwFtHcJYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hw4KMW+vbxbec2abwm8xnJPD3B9Jv27YP/2GirnZjmM=;
 b=nr1+Sgt9Mj+Wx47UuUnkQFRc7dgGc/moEEZmBhu5V8dDMosTojrFLOxYRE/NYY8BLepxnYZLDyChAte07G+aw0ipEKAcPTSdd3pDqtcW0Yo1dOfEW7JduefyLKtPQKw/TlpIrkKRjgU+eqlIVa0KQSxhNzdfeui9DVM9QEdPnMrOha/Cti15c1JFOonXwEXLo600m6lyoLnex68GcXw1KRko/DCNlJusiaW+1tnlV5bU4Hh3cd4S1AtuMedTz0nTUBzEuvEf8wHqmlu6hU/7OAZBAhXGIh6PyiJe3J7MFOhrKyJGNxgrN6sN4gy2y+9y2kRwHhVa2lSesEOVYRj6aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hw4KMW+vbxbec2abwm8xnJPD3B9Jv27YP/2GirnZjmM=;
 b=XHVxJq5nqWdGcsSJws4oNcKORlvVGnncvLBdyuP0If9oEKH4pIL2+AtyqybOa3P4OnZKZk3G3537d63yq4poyxItSXWsve2N4+ueS4FMzGxiBnFCpxA6c0mrhrDE1PqdAfiJmdNkMVLN3f82qenbqC4DhIWkpCORj6GRvsYIXgM=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Wed, 23 Jun
 2021 06:16:21 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Wed, 23 Jun
 2021 06:16:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Jiang, Dave" <dave.jiang@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
Thread-Topic: Virtualizing MSI-X on IMS via VFIO
Thread-Index: AddnMs7+4GfLhTceT8q8tdV8716lmQAS5HoAAB4UQZA=
Date:   Wed, 23 Jun 2021 06:16:20 +0000
Message-ID: <MWHPR11MB18866BECBE73EFD1386C247E8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB188603D0D809C1079F5817DC8C099@MWHPR11MB1886.namprd11.prod.outlook.com>
 <76c02ea6-f1c5-2772-419f-5ceb197fe904@intel.com>
In-Reply-To: <76c02ea6-f1c5-2772-419f-5ceb197fe904@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41bee5dd-5e5e-4024-bf35-08d9360e6b8d
x-ms-traffictypediagnostic: CO1PR11MB5089:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB508927D0702D37E03E5D5F518C089@CO1PR11MB5089.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YlFo7QE2Nf6pJ7uyzkb3NuQ3gdYVgxqmxZNERXxR6D+6vNkZ91x6Hqrtg6C0DbbViVj+HrOTo3E+qwwxhBx/r+FJZ1E0o+d50SrK0MX3sLHi0DiGgda+lvTAW7dfmnogUvJK9fRjiCCxE2/evWYQ7s5dR9NjFyLL28THbKlgRe1eDmD/wZS/eYPEjm3mCzzgVa51m42Ik06s1DZeRYqUcjDluVYJeSc9VekmyFCrHs1yVKzptbRfSc4kC2HW6LH0U9Cx7yLw29RyKTa+vquwnw4C9JM8wR5e+Ck5VgXZhqj/eFcejqJmYXTFnVuOg8x3zWPcFzcXz9jm/Jc6LZSftwkj1nf+v1UpK6i809HXvlVXZ3sy1hhnEw3QV1SGSoQgrn5cmdyEHZzyp7fQafbwiIaICrjHFb2JJ6bFfLUnU5oLW6iBe+xEi+/ndUFgCeQZ3qxlNGJHJXtxOFRgWCfcKdMef10u8jPvPu7nczzghahh/iFWP1lXgKWJPoki/BIWLndFotoHGMS5olLYXBxrok7EOo33dEFifc8gpTxrEgel9SZMUvLBHEKtUQQbuG+AIqWC9cSw0jDSnqNFpV8bA4+zvzkNrzamKJr70whWJIPRUJ0B0EQt3BOSZ1EAsqI+Dp/+y0/pfdjKvr5oS09Jz2rPk3MSLvcunHJIEJjuEa+iqTJHxkO24Q0fyaso3KI5pKIRse2GxugE0D094F7ZM4H+goz6mwskzL7PYQgxfeOrvd6j8Y8hp3902COHnB3UReJ4nfC9NLJZj91SvtNaXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(39860400002)(396003)(2906002)(84040400003)(38100700002)(26005)(86362001)(8936002)(54906003)(5660300002)(8676002)(186003)(316002)(110136005)(66556008)(76116006)(66946007)(6506007)(33656002)(9686003)(53546011)(966005)(66446008)(122000001)(64756008)(4326008)(66476007)(7696005)(55016002)(478600001)(71200400001)(52536014)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmRHUURiZUxYNTdaRjFmc0pnclV4VmJ0eVYxa2FUT2ozRFJtM1ZQQU9GYmhE?=
 =?utf-8?B?RXFINnc5Z255ci9jbkpYbHFVMXhFR1JuT0lrakFlRTBpdkVYcDR2N0VkenNX?=
 =?utf-8?B?Z0Z4b2NpMHg0THRLbjJpZlFBb01aQ0NMckJNRkMzbGk3aUZsU09MMlg2M25V?=
 =?utf-8?B?YURDZHlsM3J5TktHVDZ4QlcxZlhGdXM4VnNUcm9oeWpTWmdLSEh6R3dUR29S?=
 =?utf-8?B?Y21UbjdyOFBXUG1XZEM0VVR4QlRHS1dhQ1BtQ0JCU3grNU43ZHV4d1cxWUpK?=
 =?utf-8?B?UHZjYUI3L2kxc1JXTmcvcnJseFFuSTZpRVpwaWNNNU9tb2dJTmFNajNNRmNQ?=
 =?utf-8?B?cnpYUlBDdWpWSHpqczg2cEZ2SWhhS0V1eHUxMk5odXpkN2RRenZab2ZkYmsw?=
 =?utf-8?B?KytwSHUrUnZVaUtlNHpzV3FvcHF4MndJL2dvMmppeFdnOEd1RG91Wkc2eVFC?=
 =?utf-8?B?bldzd3FNUHJCakg2Vjc3ZXVQcGo2Vnp5Y2pzR2hUcTZkOG5aSXJZaDQ1TTJv?=
 =?utf-8?B?UFNIa0djZ1FNYkNRcnlFSmJrLzRsV2EyckpOOG5wWExvWmVWTkZZbXRxMFJj?=
 =?utf-8?B?WitxYmpuSUI4SUc0eURFbDh3SVVTOWErNUZxeG8yK1U2eDhUeGk1dUNTV1hu?=
 =?utf-8?B?Sm03VFZWRHFScUZRRzYvNHBha0IwWXROU0Q5aWZHTXZuKzd6VzNzSDFmdDZu?=
 =?utf-8?B?Vi9EWm01aFBVazFsU1E0Q1dDNDN1TTJLZjdtRWEwc0xhTkpOemRNR3k4dXQz?=
 =?utf-8?B?MzFsdEdUMkJNZGF6UjAvcm9Bc3FTOFpDNUxtMVlxRUI4V2dVcThoZlFHMGkr?=
 =?utf-8?B?cjNQV1VDSzdzbXFPV1RFcy9jUXE5cHBMTllBTUN5UnhoZCtvblFhNXhYRzJC?=
 =?utf-8?B?ODJnSGE2NldCSnd4aWlGdnFpanl2dUlFWE10Z2pKYTNNV3NyUllUditsTzh4?=
 =?utf-8?B?MFJHMkpSZnBtRXoxZnd2NnE3NVN3c2tqYnlJNUluRXBJNnZ6Z3lTUkE0WHgx?=
 =?utf-8?B?elowaFhHWG5jUDRWWTdOM1hsOERTb0NzTmJRbFlVcHFHeWNxNXo4OWFVUkVy?=
 =?utf-8?B?NzA1SGpoUmV1bkg4RHdvQWszN1lBMG5UeUFEWGJEZWNGTlJkY1hOVStuazli?=
 =?utf-8?B?SHMvTVFHdnJxVFhqVEZFV09XbS9NVkQvcEFQdHgxb3Jhc0d5VFpFV3REMEQ3?=
 =?utf-8?B?clRwVEtoOFNiZE0vdGF5aG9KMFRraTVmWGd4TTRpWGJFNzJvWEFJaEFMakdm?=
 =?utf-8?B?d1YzeS94VFE1K3Y2V1AzSGJMSkwvN0w3TUpDbDJ1Y0Znek5WK3plaStCZ3RL?=
 =?utf-8?B?Z2hFQjhMdmpqaVdjSWJQTWhLMVZNOTBDS3dYbzFSM1A2aDJFVldQQ1R1Y0oy?=
 =?utf-8?B?djBkTXhrenpJWGQ3b3FIYm1yeVdnbUR3VmlwUk1KYVcwS0IxcDk1czNFTnZR?=
 =?utf-8?B?bkdyREJ6d2tkNVdpSFJya25ZQmcrWWY5emx0czJNYTVmWCs0dUlvKzJTUVdN?=
 =?utf-8?B?OEExa3d2VnJ4VTdEMmdSNnZBK2x0MHJsMWw5RElzZ2lQcDk3QllidEZhSEZY?=
 =?utf-8?B?d2tJWU9ZUFN2dE1nbXBxZU9LMW0xT3l0WkIwcW9aUWFLZ0VCTWRwQXRFMXh0?=
 =?utf-8?B?L1RmdXU0V1NKSll0MFBNWm94ZXYvbzVoMUVDQWFZMkUvYmV2akhvd1dPcjZD?=
 =?utf-8?B?eFRPdHZrdm9IazBMOHNlQVZ5b2U5YnVZL1hSMlpOUzk2ajNYekFrYXlOZ2Qy?=
 =?utf-8?Q?ZhhLOuxEzD4XZ0ib8GgNhgEQgnYre1ePZlU1H71?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41bee5dd-5e5e-4024-bf35-08d9360e6b8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 06:16:20.9090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V/FszU5CTndil2roAkonbHzTg6NKZjPTIII0z1rLjCSrjq0fhGjY8lZKlNefwLYwOJqHFSDPexk0sQVQqe99JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5089
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKaWFuZywgRGF2ZSA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIEp1bmUgMjIsIDIwMjEgMTE6NTEgUE0NCj4gDQo+IE9uIDYvMjIvMjAyMSAzOjE2IEFNLCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPiBIaSwgQWxleCwNCj4gPg0KPiA+IE5lZWQgeW91ciBoZWxw
IHRvIHVuZGVyc3RhbmQgdGhlIGN1cnJlbnQgTVNJLVggdmlydHVhbGl6YXRpb24gZmxvdyBpbg0K
PiA+IFZGSU8uIFNvbWUgYmFja2dyb3VuZCBpbmZvIGZpcnN0Lg0KPiA+DQo+ID4gUmVjZW50bHkg
d2UgYXJlIGRpc2N1c3NpbmcgaG93IHRvIHZpcnR1YWxpemUgTVNJLVggd2l0aCBJbnRlcnJ1cHQN
Cj4gPiBNZXNzYWdlIFN0b3JhZ2UgKElNUykgb24gbWRldjoNCj4gPiAgICAgICAgICBodHRwczov
L2xvcmUua2VybmVsLm9yZy9rdm0vODdpbTJseWl2Ni5mZnNAbmFub3MudGVjLmxpbnV0cm9uaXgu
ZGUvDQo+ID4NCj4gPiBJTVMgaXMgYSBkZXZpY2Ugc3BlY2lmaWMgaW50ZXJydXB0IHN0b3JhZ2Us
IGFsbG93aW5nIGFuIG9wdGltaXplZCBhbmQNCj4gPiBzY2FsYWJsZSBtYW5uZXIgZm9yIGdlbmVy
YXRpbmcgaW50ZXJydXB0cy4gaWR4ZCBtZGV2IGV4cG9zZXMgdmlydHVhbA0KPiA+IE1TSS1YIGNh
cGFiaWxpdHkgdG8gZ3Vlc3QgYnV0IHVzZXMgSU1TIGVudHJpZXMgcGh5c2ljYWxseSBmb3IgZ2Vu
ZXJhdGluZw0KPiA+IGludGVycnVwdHMuDQo+ID4NCj4gPiBUaG9tYXMgaGFzIGhlbHBlZCBpbXBs
ZW1lbnQgYSBnZW5lcmljIGltcyBpcnFjaGlwIGRyaXZlcjoNCj4gPiAgICAgICAgICBodHRwczov
L2xvcmUua2VybmVsLm9yZy9saW51eC0NCj4gaHlwZXJ2LzIwMjAwODI2MTEyMzM1LjIwMjIzNDUw
MkBsaW51dHJvbml4LmRlLw0KPiA+DQo+ID4gaWR4ZCBkZXZpY2UgYWxsb3dzIHNvZnR3YXJlIHRv
IHNwZWNpZnkgYW4gSU1TIGVudHJ5IChmb3IgdHJpZ2dlcmluZw0KPiA+IGNvbXBsZXRpb24gaW50
ZXJydXB0KSB3aGVuIHN1Ym1pdHRpbmcgYSBkZXNjcmlwdG9yLiBUbyBwcmV2ZW50IG9uZQ0KPiA+
IG1kZXYgdHJpZ2dlcmluZyBtYWxpY2lvdXMgaW50ZXJydXB0IGludG8gYW5vdGhlciBtZGV2IChi
eSBzcGVjaWZ5aW5nDQo+ID4gYW4gYXJiaXRyYXJ5IGVudHJ5KSwgaWR4ZCBpbXMgZW50cnkgaW5j
bHVkZXMgYSBQQVNJRCBmaWVsZCBmb3IgdmFsaWRhdGlvbiAtDQo+ID4gb25seSBhIG1hdGNoaW5n
IFBBU0lEIGluIHRoZSBleGVjdXRlZCBkZXNjcmlwdG9yIGNhbiB0cmlnZ2VyIGludGVycnVwdA0K
PiA+IHZpYSB0aGlzIGVudHJ5LiBpZHhkIGRyaXZlciBpcyBleHBlY3RlZCB0byBwcm9ncmFtIGlt
cyBlbnRyaWVzIHdpdGgNCj4gPiBQQVNJRHMgdGhhdCBhcmUgYWxsb2NhdGVkIHRvIHRoZSBtZGV2
IHdoaWNoIG93bnMgdGhvc2UgZW50cmllcy4NCj4gPg0KPiA+IE90aGVyIGRldmljZXMgbWF5IGhh
dmUgZGlmZmVyZW50IElEIGFuZCBmb3JtYXQgdG8gaXNvbGF0ZSBpbXMgZW50cmllcy4NCj4gPiBC
dXQgd2UgbmVlZCBhYnN0cmFjdCBhIGdlbmVyaWMgbWVhbnMgZm9yIHByb2dyYW1taW5nIHZlbmRv
ci1zcGVjaWZpYw0KPiA+IElEIGludG8gdmVuZG9yLXNwZWNpZmljIGltcyBlbnRyeSwgd2l0aG91
dCB2aW9sYXRpbmcgdGhlIGxheWVyaW5nIG1vZGVsLg0KPiA+DQo+ID4gVGhvbWFzIHN1Z2dlc3Rl
ZCB2ZW5kb3IgZHJpdmVyIHRvIGZpcnN0IHJlZ2lzdGVyIElEIGluZm9ybWF0aW9uIChwb3NzaWJs
eQ0KPiA+IHBsdXMgdGhlIGxvY2F0aW9uIHdoZXJlIHRvIHdyaXRlIElEIHRvKSBpbiBtc2lfZGVz
YyB3aGVuIGFsbG9jYXRpbmcgaXJxcw0KPiA+IChleHRlbmQgZXhpc3RpbmcgYWxsb2MgZnVuY3Rp
b24gb3IgdmlhIG5ldyBoZWxwZXIgZnVuY3Rpb24pIGFuZCB0aGVuIGhhdmUNCj4gPiB0aGUgZ2Vu
ZXJpYyBpbXMgaXJxY2hpcCBkcml2ZXIgdG8gdXBkYXRlIElEIHRvIHRoZSBpbXMgZW50cnkgd2hl
biBpdCdzDQo+ID4gc3RhcnRlZCB1cCBieSByZXF1ZXN0X2lycSgpLg0KPiA+DQo+ID4gVGhlbiB0
aGVyZSBhcmUgdHdvIHF1ZXN0aW9ucyB0byBiZSBhbnN3ZXJlZDoNCj4gPg0KPiA+ICAgICAgMSkg
SG93IGRvZXMgdmVuZG9yIGRyaXZlciBkZWNpZGUgdGhlIElEIHRvIGJlIHJlZ2lzdGVyZWQgdG8g
bXNpX2Rlc2M/DQo+ID4gICAgICAyKSBIb3cgaXMgVGhvbWFzJ3MgbW9kZWwgbWFwcGVkIHRvIHRo
ZSBNU0ktWCB2aXJ0dWFsaXphdGlvbiBmbG93IGluDQo+IFZGSU8/DQo+ID4NCj4gPiBGb3IgdGhl
IDFzdCBvcGVuLCB0aGVyZSBhcmUgdHdvIHR5cGVzIG9mIFBBU0lEcyBvbiBpZHhkIG1kZXY6DQo+
ID4NCj4gPiAgICAgIDEpIGRlZmF1bHQgUEFTSUQ6IG9uZSBwZXIgbWRldiBhbmQgYWxsb2NhdGVk
IHdoZW4gbWRldiBpcyBjcmVhdGVkOw0KPiA+ICAgICAgMikgc3ZhIFBBU0lEczogbXVsdGlwbGUg
cGVyIG1kZXYgYW5kIGFsbG9jYXRlZCBvbi1kZW1hbmQgKHZpYQ0KPiB2SU9NTVUpOw0KPiA+DQo+
ID4gSWYgdklPTU1VIGlzIG5vdCBleHBvc2VkLCBhbGwgaW1zIGVudHJpZXMgb2YgdGhpcyBtZGV2
IHNob3VsZCBiZQ0KPiA+IHByb2dyYW1tZWQgd2l0aCBkZWZhdWx0IFBBU0lEIHdoaWNoIGlzIGFs
d2F5cyBhdmFpbGFibGUgaW4gbWRldidzDQo+ID4gbGlmZXNwYW4uDQo+ID4NCj4gPiBJZiB2SU9N
TVUgaXMgZXhwb3NlZCBhbmQgZ3Vlc3Qgc3ZhIGlzIGVuYWJsZWQsIGVudHJpZXMgdXNlZCBmb3Ig
c3ZhDQo+ID4gc2hvdWxkIGJlIHRhZ2dlZCB3aXRoIHN2YSBQQVNJRHMsIGxlYXZpbmcgb3RoZXJz
IHRhZ2dlZCB3aXRoIGRlZmF1bHQNCj4gPiBQQVNJRC4gVG8gaGVscCBhY2hpZXZlIGludHJhLWd1
ZXN0IGludGVycnVwdCBpc29sYXRpb24sIGd1ZXN0IGlkeGQgZHJpdmVyDQo+ID4gbmVlZHMgcHJv
Z3JhbSBndWVzdCBzdmEgUEFTSURzIGludG8gdmlydHVhbCBNU0lYX1BFUk0gcmVnaXN0ZXIgKG9u
ZQ0KPiA+IHBlciBNU0ktWCBlbnRyeSkgZm9yIHZhbGlkYXRpb24uIEFjY2VzcyB0byBNU0lYX1BF
Uk0gaXMgdHJhcC1hbmQtZW11bGF0ZWQNCj4gPiBieSBob3N0IGlkeGQgZHJpdmVyIHdoaWNoIHRo
ZW4gZmlndXJlIG91dCB3aGljaCBQQVNJRCB0byByZWdpc3RlciB0bw0KPiA+IG1zaV9kZXNjIChy
ZXF1aXJlIFBBU0lEIHRyYW5zbGF0aW9uIGluZm8gdmlhIG5ldyAvZGV2L2lvbW11IHByb3Bvc2Fs
KS4NCj4gPg0KPiA+IFRoZSBndWVzdCBkcml2ZXIgaXMgZXhwZWN0ZWQgdG8gdXBkYXRlIE1TSVhf
UEVSTSBiZWZvcmUgcmVxdWVzdF9pcnEoKS4NCj4gPg0KPiA+IE5vdyB0aGUgMm5kIG9wZW4gcmVx
dWlyZXMgeW91ciBoZWxwLiBCZWxvdyBpcyB3aGF0IEkgbGVhcm5lZCBmcm9tDQo+ID4gY3VycmVu
dCB2ZmlvL3FlbXUgY29kZSAoZm9yIHZmaW8tcGNpIGRldmljZSk6DQo+ID4NCj4gPiAgICAgIDAp
IFFlbXUgZG9lc24ndCBhdHRlbXB0IHRvIGFsbG9jYXRlIGFsbCBpcnFzIGFzIHJlcG9ydGVkIGJ5
IG1zaXgtPg0KPiA+ICAgICAgICAgIHRhYmxlX3NpemUuIEl0IGlzIGRvbmUgaW4gYW4gZHluYW1p
YyBhbmQgaW5jcmVtZW50YWwgd2F5Lg0KPiA+DQo+ID4gICAgICAxKSBWRklPIHByb3ZpZGVzIGp1
c3Qgb25lIGNvbW1hbmQgKFZGSU9fREVWSUNFX1NFVF9JUlFTKSBmb3INCj4gPiAgICAgICAgICAg
YWxsb2NhdGluZy9lbmFibGluZyBpcnFzIGdpdmVuIGEgc2V0IG9mIHZNU0lYIHZlY3RvcnMgW3N0
YXJ0LCBjb3VudF06DQo+ID4NCj4gPiAgICAgICAgICBhKSBpZiBpcnFzIG5vdCBhbGxvY2F0ZWQs
IGFsbG9jYXRlIGlycXMgW3N0YXJ0K2NvdW50XS4gRW5hYmxlIGlycXMgZm9yDQo+ID4gICAgICAg
ICAgICAgIHNwZWNpZmllZCB2ZWN0b3JzIFtzdGFydCwgY291bnRdIHZpYSByZXF1ZXN0X2lycSgp
Ow0KPiA+ICAgICAgICAgIGIpIGlmIGlycXMgYWxyZWFkeSBhbGxvY2F0ZWQsIGVuYWJsZSBpcnFz
IGZvciBzcGVjaWZpZWQgdmVjdG9yczsNCj4gPiAgICAgICAgICBjKSBpZiBpcnEgYWxyZWFkeSBl
bmFibGVkLCBkaXNhYmxlIGFuZCByZS1lbmFibGUgaXJxcyBmb3Igc3BlY2lmaWVkDQo+ID4gICAg
ICAgICAgICAgICB2ZWN0b3JzIGJlY2F1c2UgdXNlciBtYXkgc3BlY2lmeSBhIGRpZmZlcmVudCBl
dmVudGZkOw0KPiA+DQo+ID4gICAgICAyKSBXaGVuIGd1ZXN0IGVuYWJsZXMgdmlydHVhbCBNU0kt
WCBjYXBhYmlsaXR5LCBRZW11IGNhbGxzIFZGSU9fDQo+ID4gICAgICAgICAgREVWSUNFX1NFVF9J
UlFTIHRvIGVuYWJsZSB2ZWN0b3IjMCwgZXZlbiB0aG91Z2ggaXQncyBjdXJyZW50bHkNCj4gPiAg
ICAgICAgICBtYXNrZWQgYnkgdGhlIGd1ZXN0LiBJbnRlcnJ1cHRzIGFyZSByZWNlaXZlZCBieSBR
ZW11IGJ1dCBibG9ja2VkDQo+ID4gICAgICAgICAgZnJvbSBndWVzdCB2aWEgbWFzay9wZW5kaW5n
IGJpdCBlbXVsYXRpb24uIFRoZSBtYWluIGludGVudGlvbiBpcw0KPiA+ICAgICAgICAgIHRvIGVu
YWJsZSBwaHlzaWNhbCBNU0ktWDsNCj4gPg0KPiA+ICAgICAgMykgV2hlbiBndWVzdCB1bm1hc2tz
IHZlY3RvciMwIHZpYSByZXF1ZXN0X2lycSgpLCBRZW11IGNhbGxzIFZGSU9fDQo+ID4gICAgICAg
ICAgREVWSUNFX1NFVF9JUlFTIHRvIGVuYWJsZSB2ZWN0b3IjMCBhZ2Fpbiwgd2l0aCBhIGV2ZW50
ZmQgZGlmZmVyZW50DQo+ID4gICAgICAgICAgZnJvbSB0aGUgb25lIHByb3ZpZGVkIGluIDIpOw0K
PiA+DQo+ID4gICAgICA0KSBXaGVuIGd1ZXN0IHVubWFza3MgdmVjdG9yIzEsIFFlbXUgZmluZHMg
aXQncyBvdXRzaWRlIG9mIGFsbG9jYXRlZA0KPiA+ICAgICAgICAgIHZlY3RvcnMgKG9ubHkgdmVj
dG9yIzAgbm93KToNCj4gPg0KPiA+ICAgICAgICAgIGEpIFFlbXUgZmlyc3QgY2FsbHMgVkZJT19E
RVZJQ0VfU0VUX0lSUVMgdG8gZGlzYWJsZSBhbmQgZnJlZQ0KPiA+ICAgICAgICAgICAgICBpcnEg
Zm9yIHZlY3RvciMwOw0KPiA+DQo+ID4gICAgICAgICAgYikgUWVtdSB0aGVuIGNhbGxzIFZGSU9f
REVWSUNFX1NFVF9JUlFTIHRvIGFsbG9jYXRlIGFuZCBlbmFibGUNCj4gPiAgICAgICAgICAgICAg
aXJxcyBmb3IgYm90aCB2ZWN0b3IjMCBhbmQgdmVjdG9yIzE7DQo+ID4NCj4gPiAgICAgICA1KSBX
aGVuIGd1ZXN0IHVubWFza3MgdmVjdG9yIzIsIHNhbWUgZmxvdyBpbiA0KSBjb250aW51ZXMuDQo+
ID4NCj4gPiAgICAgICAuLi4uDQo+ID4NCj4gPiBJZiBhYm92ZSB1bmRlcnN0YW5kaW5nIGlzIGNv
cnJlY3QsIGhvdyBpcyBsb3N0IGludGVycnVwdCBhdm9pZGVkIGJldHdlZW4NCj4gPiA0LmEpIGFu
ZCA0LmIpIGdpdmVuIHRoYXQgaXJxIGhhcyBiZWVuIHRvcm4gZG93biBmb3IgdmVjdG9yIzAgaW4g
dGhlIG1pZGRsZQ0KPiA+IHdoaWxlIGZyb20gZ3Vlc3QgcC5vLnYgdGhpcyB2ZWN0b3IgaXMgYWN0
dWFsbHkgdW5tYXNrZWQ/IFRoZXJlIG11c3QgYmUNCj4gPiBhIG1lY2hhbmlzbSBpbiBwbGFjZSwg
YnV0IEkganVzdCBkaWRuJ3QgZmlndXJlIGl0IG91dC4uLg0KPiA+DQo+ID4gR2l2ZW4gYWJvdmUg
ZmxvdyBpcyByb2J1c3QsIG1hcHBpbmcgVGhvbWFzJ3MgbW9kZWwgdG8gdGhpcyBmbG93IGlzDQo+
ID4gc3RyYWlnaHRmb3J3YXJkLiBBc3N1bWUgaWR4ZCBtZGV2IGhhcyB0d28gdmVjdG9yczogdmVj
dG9yIzAgZm9yDQo+ID4gbWlzYy9lcnJvciBpbnRlcnJ1cHQgYW5kIHZlY3RvciMxIGFzIGNvbXBs
ZXRpb24gaW50ZXJydXB0IGZvciBndWVzdA0KPiA+IHN2YS4gVkZJT19ERVZJQ0VfU0VUX0lSUVMg
aXMgaGFuZGxlZCBieSBpZHhkIG1kZXYgZHJpdmVyOg0KPiA+DQo+ID4gICAgICAyKSBXaGVuIGd1
ZXN0IGVuYWJsZXMgdmlydHVhbCBNU0ktWCBjYXBhYmlsaXR5LCBRZW11IGNhbGxzIFZGSU9fDQo+
ID4gICAgICAgICAgREVWSUNFX1NFVF9JUlFTIHRvIGVuYWJsZSB2ZWN0b3IjMC4gQmVjYXVzZSB2
ZWN0b3IjMCBpcyBub3QNCj4gPiAgICAgICAgICB1c2VkIGZvciBzdmEsIE1TSVhfUEVSTSMwIGhh
cyBQQVNJRCBkaXNhYmxlZC4gSG9zdCBpZHhkIGRyaXZlcg0KPiA+ICAgICAgICAgIGtub3dzIHRv
IHJlZ2lzdGVyIGRlZmF1bHQgUEFTSUQgdG8gbXNpX2Rlc2MjMCB3aGVuIGFsbG9jYXRpbmcgaXJx
cy4NCj4gPiAgICAgICAgICBUaGVuIC5zdGFydHVwKCkgY2FsbGJhY2sgb2YgaW1zIGlycWNoaXAg
aXMgY2FsbGVkIHRvIHByb2dyYW0gZGVmYXVsdA0KPiA+ICAgICAgICAgIFBBU0lEIHNhdmVkIGlu
IG1zaV9kZXNjIzAgdG8gdGhlIHRhcmdldCBpbXMgZW50cnkgd2hlbiByZXF1ZXN0X2lycSgpLg0K
PiA+DQo+ID4gICAgICAzKSBXaGVuIGd1ZXN0IHVubWFza3MgdmVjdG9yIzAgdmlhIHJlcXVlc3Rf
aXJxKCksIFFlbXUgY2FsbHMgVkZJT18NCj4gPiAgICAgICAgICBERVZJQ0VfU0VUX0lSUVMgdG8g
ZW5hYmxlIHZlY3RvciMwIGFnYWluLiBGb2xsb3dpbmcgc2FtZSBsb2dpYw0KPiA+ICAgICAgICAg
IGFzIHZmaW8tcGNpLCBpZHhkIGRyaXZlciBmaXJzdCBkaXNhYmxlIGlycSMwIHZpYSBmcmVlX2ly
cSgpIGFuZCB0aGVuDQo+ID4gICAgICAgICAgcmUtZW5hYmxlIGlycSMwIHZpYSByZXF1ZXN0X2ly
cSgpLiBJdCdzIHN0aWxsIGRlZmF1bHQgUEFTSUQgYmVpbmcgdXNlZA0KPiA+ICAgICAgICAgIGFj
Y29yZGluZyB0byBtc2lfZGVzYyMwLg0KPiANCj4gSGkgS2V2aW4sIHNsaWdodCBjb3JyZWN0aW9u
IGhlcmUuIEJlY2F1c2UgdmVjdG9yIzAgaXMgZW11bGF0ZWQgZm9yIGlkeGQNCj4gdmRldiwgaXQg
aGFzIG5vIElNUyBiYWNraW5nLiBTbyB0aGVyZSBpcyBubyBtc2lfZGVzYyMwIGZvciB0aGF0IHZl
Y3Rvci4NCj4gbXNpX2Rlc2MjMCBhY3R1YWxseSBzdGFydHMgYXQgdmVjdG9yIzEgd2hlcmUgSU1T
IGlzIGFsbG9jYXRlZCB0byBiYWNrDQo+IGl0LiB2ZWN0b3IjMCBkb2VzIG5vdCBnbyB0aHJvdWdo
IHJlcXVlc3RfaXJxKCkuIEl0IG9ubHkgaGFzIGV2ZW50ZmQNCj4gcGFydC4gRXZlcnl0aGluZyB5
b3Ugc2F5IGlzIGNvcnJlY3QgYnV0IHN0YXJ0cyBhdCB2ZWN0b3IjMS4NCj4gDQoNCllvdSBhcmUg
cmlnaHQuIEJ1dCBmb3IgaWxsdXN0cmF0aW9uIHNpbXBsaWNpdHksIGxldCdzIHN0aWxsIGFzc3Vt
ZSBib3RoIHZlY3Rvcg0KIzAgYW5kICMxIGFyZSBiYWNrZWQgYnkgaW1zIGluIGZvbGxvd2luZyBk
aXNjdXNzaW9uLCBzaW5jZSBwdXJlbHkgZW11bGF0ZWQNCnZlY3RvciBpcyBhbnl3YXkgb3V0c2lk
ZSBvZiB0aGlzIGNvbnRleHQuIPCfmIoNCg0KVGhhbmtzDQpLZXZpbg0K
