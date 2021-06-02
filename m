Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5DF397EDD
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 04:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhFBCWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 22:22:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:19425 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhFBCWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 22:22:13 -0400
IronPort-SDR: zra2UMzrS+101ZFrcutKPGX+1ezTdYUCmUAemT4kfSIJ/p3QkMyNz/7RwweXXrYUlkr9N/W5ww
 XQFI+7EtTSTQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="264865217"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="264865217"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 19:20:24 -0700
IronPort-SDR: QFxGMBdpdsVHhXxWJLaP3hnc/gh2ez3wgfrr9WhWpG5pT7SOdsGeESuAD01qsTPoHYaVVKCuIe
 l2vyQ9ob5ibg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="635701392"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jun 2021 19:20:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 19:20:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 1 Jun 2021 19:20:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 1 Jun 2021 19:20:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLm92Udy0Yuzsve/zq/HiRJ+66ABn9Ei2gjmH0s0p0SZ6GJWjm7MgGbOn4Kg5/TQQRSrZNOtxlOa829boHO4rkvHiMjMNt2p+qpAdp8hggwoKuMV9NZBXLUUKxOMZB1OCINZ43o5ZWtA3WsMzC7iBbe85swSnj/FcPMfi6nRwg6+Jh4rqQtmyG6abC6bmTTAU1Gl2u+cooHDXnlDAlsTr5k02VXi5JSWFCB8gUV+ty4zILpl3xDEVHmLi3OanoIC4I7e7tsS5DzkoG6FMs+wxppRhpn372xmkbQ710PMG7gsCIYkv4pEDUi01lJPQksJMlczQYzlFQN1p531LWPnJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHz2rXXuBo5nuATjYwNDRFg+d+Uy7tRsBT1BWU9FNGY=;
 b=JDkLwYG9V+0pRny4E4ZYMF6vFXltB4VKq9Ehx6VrPIl5QICiuYrccQED6YwZBTP5nwZNXBKc5D7ccdvXaAIR3NXDTMDvM5jx+0Cd6+9bJcIep8+sgBkQT/IFfNA2bi5ldbRSWbapELPQniX9+nR4EtcL/g6D0oBY9nYeSq05xFpWcD9Znri9W3L00KI71hXX+Ws3F77oSnErrG5AOC4ASWC93QcV7Rn7Ml55ETJnp6wnqQLg7owdPxFSg8uLeUWciG7tIVGwSNMxMqfoFNRXL+c5G3bFYb6AbsHutihPT6XfQecXS76D2jkULhvQ3agkT6jip/NNv5XJ7Q9/aeTEJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHz2rXXuBo5nuATjYwNDRFg+d+Uy7tRsBT1BWU9FNGY=;
 b=vJ422YpTn1uG8moVSgRoZObbHPomswelHiib+jtygjnfcz6cuAua4JZx6HDyuELHMMDaMj4NSmyfMiu8I04GQsAuCIeu3XgwBQd66U3Ir/0E5wwGMG7O7y48vyDWUxrZZIMiXlUn5Mgg+D5q6oJ2NIBFYXzBhdn6QLadz9W60sM=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB2061.namprd11.prod.outlook.com (2603:10b6:300:28::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Wed, 2 Jun
 2021 02:20:16 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 02:20:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpAAKSt7gAAHpf9w
Date:   Wed, 2 Jun 2021 02:20:15 +0000
Message-ID: <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210528200311.GP1002214@nvidia.com>
        <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601162225.259923bc.alex.williamson@redhat.com>
In-Reply-To: <20210601162225.259923bc.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22ef22f8-370d-42cb-82df-08d9256cf5ac
x-ms-traffictypediagnostic: MWHPR11MB2061:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB2061942772E873D7F271F0A78C3D9@MWHPR11MB2061.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b5wFDploVEzgKAkF3MTLtYL2UlkLeS+uM0fPfpPsC9uyRMvpjnXftsN1V9zdB4LjXWNHcWkez4ky77VRKx2KDhpNox0tVG0yc0l1eNCiGdDQRv4iw8RHwrANHzu2S4dKcM6Xag3Drh3XW7NqNOJjTlhVsYO9qQ6lk4SfVg2pFcJwhfIrMQzIKCKlaAtNjF2F4b15yO8if24Uvu05u9YyjJG0FkAxHsqsFXF2r712hgIsIzwLstPYmmudB+eFaePhq8NGQUFi48/ZnfolRG4NBaofOoyWeqGSpWbrqCVV4f7i4eK8SpNwR7bQFmKR8Mbu/zmyOzk0egna3gB83srDei8qO8jKlFAo1/ChzfMlFIH+MXJDSNIiFS8SW814VDz4VNMTJtLj1EPRjwrB5+pa6IZK6yAKCS/rSwtcPRCisNZTmeNPt6yNz6m7TvXDzCyUszX/tAcZu8X94lf/Wiv0/O9rHgamZ8tIOFjdNvnf/Ao2IrGEVn4gteHpOSzxM5j6hBsuCfI8VExJKr4q+dCBMw1LqCwqwtz1A0Ishlyi0ypAjP64uWvqcA3JA19piSVKdaBtmDHNFPbiyJijQPHywBaoTHJ85i59pJ2IdiAJHY8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(396003)(39860400002)(5660300002)(186003)(55016002)(26005)(66946007)(6916009)(478600001)(8676002)(122000001)(54906003)(7416002)(7696005)(66446008)(64756008)(66556008)(66476007)(76116006)(38100700002)(4326008)(2906002)(71200400001)(86362001)(316002)(8936002)(9686003)(6506007)(52536014)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eUYyM1hGQUdXeFJ3cE9JSjBLY1dZTU5WNm1uVys3emJ5OGloaGp0YUxVZEs5?=
 =?utf-8?B?Z1U4QU53cTdacTRBNWFqZmhZa2IySUtOOEdSeHdYSzNueFVzYUNBdm1zOG5C?=
 =?utf-8?B?SW1GTThMb0E2a1NQa0hVKzd0Rm0yZ1pDTjhla3JwQWRISE5aUlNhWXliTHZH?=
 =?utf-8?B?T0pQaE4wRjZycGlhSElENElOQXFPcDRhdUd1MDBBTzlpR203bUFieHR6WEJU?=
 =?utf-8?B?WCtaeUNUOEhVbEtJS1J2cEFaYk1mMkJFWmZGOW5qTnlRWXlZMm1wVWU4SURu?=
 =?utf-8?B?d2RpMnJmaXJzQWVpa1RVOHFQcUJwV0Q3a2oxTEpuM1RtUE5iV2NsQ2VDckJn?=
 =?utf-8?B?M3NNWnNObDZWcTd3TUk5S0hPRlJuZDVHaWJuQWMrd2w0QndDZGk2QjdQOHV0?=
 =?utf-8?B?dFZoUTZhbnNycTg1SVF3Tk1BaWRzWDNCT0ZLL0RlUklac2JWVXp3bWErd2ly?=
 =?utf-8?B?bnhLd0hQSG96OFhqRDJra3ZNS2lzTElIOS8yRU5NaWFJYStFM1JDQ3ovM0wy?=
 =?utf-8?B?YUNqam5aa3VHb093d2xZVTc0ZGw3OXZaTWZoQnc2U0dlaDExYVl6YURPa3k5?=
 =?utf-8?B?Y09abGhkcythaWkxOEtkNnAyRW5OS01wYkQrRDhpVnE3VVVEL0FrVUFSSWNl?=
 =?utf-8?B?bHNSbGNuNlZvZkoyeDBKMXhlZ1pLeisyeDRRSUxqWVhjV3pUV3pBNjRFR3F3?=
 =?utf-8?B?WVFraTJJV3dNSjZraGwvR2xSR1lXdTdLL1BOdjlzdUJhWjdLaFRkKytBUjgv?=
 =?utf-8?B?YlpQZWVzTEJPWTRGdG8wYWhFSExBZlh1VDYxK0o5QVJNUG9JWXQ3RmFhKzlI?=
 =?utf-8?B?QTRubjNlQU5yNWhRTXY3ZS9kSTkrUXlnL2pSNHd3bEd2c21MTVNMZWpVSnAv?=
 =?utf-8?B?S0o5aVYyWGs2eVNmeDlJc0Z2N05MUzdiTEs3aDZxdlh6YWVEd1RITHJsVk8y?=
 =?utf-8?B?SE5jbWtMVTZhd1FPaWJXQldxMWlQTzhBU3gwc3BEb0NnbHd1dTBpdis5NVZw?=
 =?utf-8?B?TlprOHh6T2xoWkdab2VYeE1sQzJqY0k4WjM0c24rTGRGRXBVVUZxTGU5clBy?=
 =?utf-8?B?RDBrZkVTWWFMdjFZbVcxR3ZBYzlDc0NaVE5jU1podk9Nc0RpWjhKcjd6Slpw?=
 =?utf-8?B?Si9FV29sMEVOR1V2bEd6WEtQT1J3dzNHWmY3U0RGTTNiZFpzUmM2VW5MUW5r?=
 =?utf-8?B?NHM2NmlkbHQzSVMzK0dNZ1R2QU9CUEdObXFGdTNweW5uajREVGdTd0hSNWJi?=
 =?utf-8?B?NWFDeG5lbno2UWJhNmpYWURiUVFJem1Uc2J6Nm8wM0Q0SzZhYkpGK1dsWllk?=
 =?utf-8?B?ckFzSjV1RnErdGhrcnVrRWp4VUlvc1FCdEpUYlFhY0JxNmVlSktpeG1FQ2cx?=
 =?utf-8?B?cnpXaklSR3V5REdIQ3dWM0VpVWZnMjlYV2llNFpFeXY2aG5LZGkwSjRtQldL?=
 =?utf-8?B?bHBFeS9wdTFuMFRsMFY5SUpxSGd4VCs1OEE3WnJ3Vmt3c2s5Y2pHQjdCYitV?=
 =?utf-8?B?SG5vV1lhR3doRGFYNWhoUjVsNUllVm1GdmFkZGtNb2o2MFMvVjFFSzlmTVFM?=
 =?utf-8?B?bzZNTWluV003Nmh6MWFUak9GeHFNRDVQZkxQcHlIbjNEOW55NmdmZUVidzdK?=
 =?utf-8?B?dkZRQjZoWmNkcGJkTFcxSGtRbHJtVGRpa3UzeExDVDZNMEFKQlFON25TTkE1?=
 =?utf-8?B?ZExUc1FzbnBibnFOUjBvUHhmY3FKOUlMU0MwdHNjUWk0cVF5SFBIY1JOd1hx?=
 =?utf-8?Q?1mXMwVmbxcI+rSvdsStiVf1UQhakA2Jjq7QjeT7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ef22f8-370d-42cb-82df-08d9256cf5ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 02:20:15.7285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UNeVBOA2JtGzj5Xbj4h8A7iVyETckB28efjbVESiCFujiZazngX1CpTCXw1Y/8YDcEe0XrGCzsMnr42AD7RQdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2061
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIEp1bmUgMiwgMjAyMSA2OjIyIEFNDQo+IA0KPiBPbiBUdWUsIDEgSnVu
IDIwMjEgMDc6MDE6NTcgKzAwMDANCj4gIlRpYW4sIEtldmluIiA8a2V2aW4udGlhbkBpbnRlbC5j
b20+IHdyb3RlOg0KPiA+DQo+ID4gSSBzdW1tYXJpemVkIGZpdmUgb3BlbnMgaGVyZSwgYWJvdXQ6
DQo+ID4NCj4gPiAxKSAgRmluYWxpemluZyB0aGUgbmFtZSB0byByZXBsYWNlIC9kZXYvaW9hc2lk
Ow0KPiA+IDIpICBXaGV0aGVyIG9uZSBkZXZpY2UgaXMgYWxsb3dlZCB0byBiaW5kIHRvIG11bHRp
cGxlIElPQVNJRCBmZCdzOw0KPiA+IDMpICBDYXJyeSBkZXZpY2UgaW5mb3JtYXRpb24gaW4gaW52
YWxpZGF0aW9uL2ZhdWx0IHJlcG9ydGluZyB1QVBJOw0KPiA+IDQpICBXaGF0IHNob3VsZC9jb3Vs
ZCBiZSBzcGVjaWZpZWQgd2hlbiBhbGxvY2F0aW5nIGFuIElPQVNJRDsNCj4gPiA1KSAgVGhlIHBy
b3RvY29sIGJldHdlZW4gdmZpbyBncm91cCBhbmQga3ZtOw0KPiA+DQo+IC4uLg0KPiA+DQo+ID4g
Rm9yIDUpLCBJJ2QgZXhwZWN0IEFsZXggdG8gY2hpbWUgaW4uIFBlciBteSB1bmRlcnN0YW5kaW5n
IGxvb2tzIHRoZQ0KPiA+IG9yaWdpbmFsIHB1cnBvc2Ugb2YgdGhpcyBwcm90b2NvbCBpcyBub3Qg
YWJvdXQgSS9PIGFkZHJlc3Mgc3BhY2UuIEl0J3MNCj4gPiBmb3IgS1ZNIHRvIGtub3cgd2hldGhl
ciBhbnkgZGV2aWNlIGlzIGFzc2lnbmVkIHRvIHRoaXMgVk0gYW5kIHRoZW4NCj4gPiBkbyBzb21l
dGhpbmcgc3BlY2lhbCAoZS5nLiBwb3N0ZWQgaW50ZXJydXB0LCBFUFQgY2FjaGUgYXR0cmlidXRl
LCBldGMuKS4NCj4gDQo+IFJpZ2h0LCB0aGUgb3JpZ2luYWwgdXNlIGNhc2Ugd2FzIGZvciBLVk0g
dG8gZGV0ZXJtaW5lIHdoZXRoZXIgaXQgbmVlZHMNCj4gdG8gZW11bGF0ZSBpbnZscGcsIHNvIGl0
IG5lZWRzIHRvIGJlIGF3YXJlIHdoZW4gYW4gYXNzaWduZWQgZGV2aWNlIGlzDQoNCmludmxwZyAt
PiB3YmludmQgOikNCg0KPiBwcmVzZW50IGFuZCBiZSBhYmxlIHRvIHRlc3QgaWYgRE1BIGZvciB0
aGF0IGRldmljZSBpcyBjYWNoZSBjb2hlcmVudC4NCj4gVGhlIHVzZXIsIFFFTVUsIGNyZWF0ZXMg
YSBLVk0gInBzZXVkbyIgZGV2aWNlIHJlcHJlc2VudGluZyB0aGUgdmZpbw0KPiBncm91cCwgcHJv
dmlkaW5nIHRoZSBmaWxlIGRlc2NyaXB0b3Igb2YgdGhhdCBncm91cCB0byBzaG93IG93bmVyc2hp
cC4NCj4gVGhlIHVnbHkgc3ltYm9sX2dldCBjb2RlIGlzIHRvIGF2b2lkIGhhcmQgbW9kdWxlIGRl
cGVuZGVuY2llcywgaWUuIHRoZQ0KPiBrdm0gbW9kdWxlIHNob3VsZCBub3QgcHVsbCBpbiBvciBy
ZXF1aXJlIHRoZSB2ZmlvIG1vZHVsZSwgYnV0IHZmaW8gd2lsbA0KPiBiZSBwcmVzZW50IGlmIGF0
dGVtcHRpbmcgdG8gcmVnaXN0ZXIgdGhpcyBkZXZpY2UuDQoNCnNvIHRoZSBzeW1ib2xfZ2V0IHRo
aW5nIGlzIG5vdCBhYm91dCB0aGUgcHJvdG9jb2wgaXRzZWxmLiBXaGF0ZXZlciBwcm90b2NvbA0K
aXMgZGVmaW5lZCwgYXMgbG9uZyBhcyBrdm0gbmVlZHMgdG8gY2FsbCB2ZmlvIG9yIGlvYXNpZCBo
ZWxwZXIgZnVuY3Rpb24sIHdlIA0KbmVlZCBkZWZpbmUgYSBwcm9wZXIgd2F5IHRvIGRvIGl0LiBK
YXNvbiwgd2hhdCdzIHlvdXIgb3BpbmlvbiBvZiBhbHRlcm5hdGl2ZSANCm9wdGlvbiBzaW5jZSB5
b3UgZGlzbGlrZSBzeW1ib2xfZ2V0Pw0KDQo+IA0KPiBXaXRoIGt2bWd0LCB0aGUgaW50ZXJmYWNl
IGFsc28gYmVjYW1lIGEgd2F5IHRvIHJlZ2lzdGVyIHRoZSBrdm0gcG9pbnRlcg0KPiB3aXRoIHZm
aW8gZm9yIHRoZSB0cmFuc2xhdGlvbiBtZW50aW9uZWQgZWxzZXdoZXJlIGluIHRoaXMgdGhyZWFk
Lg0KPiANCj4gVGhlIFBQQy9TUEFQUiBzdXBwb3J0IGFsbG93cyBLVk0gdG8gYXNzb2NpYXRlIGEg
dmZpbyBncm91cCB0byBhbiBJT01NVQ0KPiBwYWdlIHRhYmxlIHNvIHRoYXQgaXQgY2FuIGhhbmRs
ZSBpb3RsYiBwcm9ncmFtbWluZyBmcm9tIHByZS1yZWdpc3RlcmVkDQo+IG1lbW9yeSB3aXRob3V0
IHRyYXBwaW5nIG91dCB0byB1c2Vyc3BhY2UuDQo+IA0KPiA+IEJlY2F1c2UgS1ZNIGRlZHVjZXMg
c29tZSBwb2xpY3kgYmFzZWQgb24gdGhlIGZhY3Qgb2YgYXNzaWduZWQgZGV2aWNlLA0KPiA+IGl0
IG5lZWRzIHRvIGhvbGQgYSByZWZlcmVuY2UgdG8gcmVsYXRlZCB2ZmlvIGdyb3VwLiB0aGlzIHBh
cnQgaXMgaXJyZWxldmFudA0KPiA+IHRvIHRoaXMgUkZDLg0KPiANCj4gQWxsIG9mIHRoZXNlIHVz
ZSBjYXNlcyBhcmUgcmVsYXRlZCB0byB0aGUgSU9NTVUsIHdoZXRoZXIgRE1BIGlzDQo+IGNvaGVy
ZW50LCB0cmFuc2xhdGluZyBkZXZpY2UgSU9WQSB0byBHUEEsIGFuZCBhbiBhY2NlbGVyYXRpb24g
cGF0aCB0bw0KPiBlbXVsYXRlIElPTU1VIHByb2dyYW1taW5nIGluIGtlcm5lbC4uLiB0aGV5IHNl
ZW0gcHJldHR5IHJlbGV2YW50Lg0KDQpPbmUgb3BlbiBpcyB3aGV0aGVyIGt2bSBzaG91bGQgaG9s
ZCBhIGRldmljZSByZWZlcmVuY2Ugb3IgSU9BU0lEDQpyZWZlcmVuY2UuIEZvciBETUEgY29oZXJl
bmNlLCBpdCBvbmx5IG1hdHRlcnMgd2hldGhlciBhc3NpZ25lZCANCmRldmljZXMgYXJlIGNvaGVy
ZW50IG9yIG5vdCAobm90IGZvciBhIHNwZWNpZmljIGFkZHJlc3Mgc3BhY2UpLiBGb3Iga3ZtZ3Qs
IA0KaXQgaXMgZm9yIHJlY29kaW5nIGt2bSBwb2ludGVyIGluIG1kZXYgZHJpdmVyIHRvIGRvIHdy
aXRlIHByb3RlY3Rpb24uIEZvciANCnBwYywgaXQgZG9lcyByZWxhdGUgdG8gYSBzcGVjaWZpYyBJ
L08gcGFnZSB0YWJsZS4NCg0KVGhlbiBJIGZlZWwgb25seSBhIHBhcnQgb2YgdGhlIHByb3RvY29s
IHdpbGwgYmUgbW92ZWQgdG8gL2Rldi9pb2FzaWQgYW5kDQpzb21ldGhpbmcgd2lsbCBzdGlsbCBy
ZW1haW4gYmV0d2VlbiBrdm0gYW5kIHZmaW8/DQoNCj4gDQo+ID4gQnV0IEFSTSdzIFZNSUQgdXNh
Z2UgaXMgcmVsYXRlZCB0byBJL08gYWRkcmVzcyBzcGFjZSB0aHVzIG5lZWRzIHNvbWUNCj4gPiBj
b25zaWRlcmF0aW9uLiBBbm90aGVyIHN0cmFuZ2UgdGhpbmcgaXMgYWJvdXQgUFBDLiBMb29rcyBp
dCBhbHNvIGxldmVyYWdlcw0KPiA+IHRoaXMgcHJvdG9jb2wgdG8gZG8gaW9tbXUgZ3JvdXAgYXR0
YWNoOiBrdm1fc3BhcHJfdGNlX2F0dGFjaF9pb21tdV8NCj4gPiBncm91cC4gSSBkb24ndCBrbm93
IHdoeSBpdCdzIGRvbmUgdGhyb3VnaCBLVk0gaW5zdGVhZCBvZiBWRklPIHVBUEkgaW4NCj4gPiB0
aGUgZmlyc3QgcGxhY2UuDQo+IA0KPiBBSVVJLCBJT01NVSBwcm9ncmFtbWluZyBvbiBQUEMgaXMg
ZG9uZSB0aHJvdWdoIGh5cGVyY2FsbHMsIHNvIEtWTQ0KPiBuZWVkcw0KPiB0byBrbm93IGhvdyB0
byBoYW5kbGUgdGhvc2UgZm9yIGluLWtlcm5lbCBhY2NlbGVyYXRpb24uICBUaGFua3MsDQo+IA0K
DQpvay4NCg0KVGhhbmtzDQpLZXZpbg0K
