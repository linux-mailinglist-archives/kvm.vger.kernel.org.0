Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA7039B3F7
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 09:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhFDHfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 03:35:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:39382 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhFDHfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 03:35:15 -0400
IronPort-SDR: tLQjE1kyqp3++ZIWh+xtOaJYVbrGUN+uJiZnwOJe4m7feUAP227KLPz9FRG9Tm8RLmbqrSQLKX
 PrwqQZYsMmRQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="202384607"
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="202384607"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 00:33:29 -0700
IronPort-SDR: 3gl77WEpy0H/UqVbQvL7mdL5DS/QpCWAoNuXV9LzCKxgzltjKyPhFGY54vz9hNU1MuVlhTmC9U
 Eyi45iqM2Bag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="483803063"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jun 2021 00:33:25 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 00:33:25 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 00:33:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 4 Jun 2021 00:33:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 4 Jun 2021 00:33:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLpqgQ1PWa4EhSCzjx75hatUsFWR8JUlFtpwHHEuqfaVY1rkO+EzxhZMauIfTnGjypV9RIIT0uvnjvl3bbS02zL6YSAYeyzc6wbrGWC7Vjx0U70MLkTYehk5ncIqJj6hvle5B66YZZlza+p158BsMY2FTcnhtc7bqUnNDxkDg2yqVFVHr9op/JHAw3m2TNbM9dWaTSKrhiTFdxQ+DE7rapZlyz3xO3anv9aiaKoCnVRl/0KYsYqQkiNeGVfuXB01XHYsJV6qr3HQpeOhAJLYRR91mPN0teD6OIb4Nu5VCJ0sdZZMQnQmq0WUB0hwWSJNnfeE2p4CTwvvuKt4uQHSog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e12Qut/SQlRJ9WhfuHopHYEVI4jeSf/yUts89KM9L4g=;
 b=Rymcrxe8SFukABUJT+d1pSMPcu5eB7rSfbCRSRlpeH+s5i7nxfl2S+3BmWB3UmXa8PSKPG62ylAvp64vNS64DWgQGJ8jjWLIcxvoYbKUBtZwyB3aE1tJ0RbMVzsoQynStk8HzrMHaLIHGIamH+eMG3yiqC90c/W85rPnMEEneqFkx9HVvDYiBT/dkfrl2oEB9uHBi2aI989Ss72Wfa7OP4i9FXB9KxVDumRksgwaPpHeIYcgv328fqm9HDic+1y/cNdkekMkqJfkt9ui987Rkv1v4t4iupG49dkhqV4xfEpcmRQU9toQsAeEIWbuiPrBiuLIJT18Lu4FdLyD3vOvdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e12Qut/SQlRJ9WhfuHopHYEVI4jeSf/yUts89KM9L4g=;
 b=hPrVXmwA7M5P0rlbU9vRie+szwvKZFEp0gFQUbsWbHL7Vxe7nAR5MDrz1Jcr3Yy3YTGbC4BqgMjDanICTPY4FxcHj+5ojmV1JdcD5C9kBOS3DLUbGMecSWkw3fps00tWMAH9NcYZ5YgLmUF1GVi82tpiM1m5ZjVn74+DBOie/4Q=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 07:33:22 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 07:33:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpAAKSt7gAAHpf9wAB1YcAAAAm5sgAAA1YgAAADonIAAAEmcgAABzCaAAAHbfwAAAYTsAAAEeLUAAAiRJwAAAHcmwAAUIS4AACbr4AA=
Date:   Fri, 4 Jun 2021 07:33:22 +0000
Message-ID: <MWHPR11MB1886FED6B716FE56FEAAF67A8C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210602111117.026d4a26.alex.williamson@redhat.com>
 <20210602173510.GE1002214@nvidia.com>
 <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <20210602224536.GJ1002214@nvidia.com>
 <20210602205054.3505c9c3.alex.williamson@redhat.com>
 <MWHPR11MB1886DC8ECF5D56FE485D13D58C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603124036.GU1002214@nvidia.com>
In-Reply-To: <20210603124036.GU1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb76e3b9-a99e-4e59-be2d-08d9272b0835
x-ms-traffictypediagnostic: MW3PR11MB4587:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB458775071799409F0F5810AB8C3B9@MW3PR11MB4587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Aw9FHRYnmCiEcWxFXRkT3pETDc6gOfoKMy8R+4x4M/0apR7OL2TDYdFdor62OUBbwiC21CPip4+/T6CRCiK/mF21QFO3z/CCNjTmQz1SCtTXP1Tzl+7fvqA6G0Cjop2Q9vxS1tlBAYegj61jOuVQBIDLwi+JvjUjgT3kg0eoPAJegbzro4lP67kqEy2JaGjtHvtcIMtRW/3vFJekLRPuSSIda1ZTieDQNCLn/czCEJpegwn+kHp3Oox+EPgEsSpvut9uu9M1mTrw0NZW/5phWkL7peOO8LMuaeLCZKTlVyebUbhkvKIRubiy22cU78wAjoEn7jRuffsJobHruvob7rY/J9dqlIoNr33/2Ley8iPrvIlF4vqUwcvjF18E2JL5mSUaU+0ywD4KUPcmRpgsAQ35AMMw5rBTfagsl4alPxSPHumkQoqjupfM4VdNvDchLDFp0zTwjtsgmqnV6WARKRa/4bIJIDVnUaniYa133BlW4k6Akb6wl+NVldiS0lTSS4QCIrvpzgGGUJOf7sx3HjdNEZCT8KIrU5OhnCnN/mXZ1C0L+MqOuCZrAKGbd9ur13KMNINBN8cx3S0+rRwSlv5BLYhxHUsk+AYL0ghFKWY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(39860400002)(136003)(8936002)(186003)(71200400001)(6506007)(55016002)(26005)(9686003)(7696005)(8676002)(52536014)(38100700002)(33656002)(478600001)(122000001)(4326008)(5660300002)(2906002)(7416002)(66556008)(54906003)(66446008)(66946007)(64756008)(66476007)(76116006)(6916009)(316002)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UytuQVRXc1plZmdRSGNIeFlGajBicERGL2hOa0JJczVJRm1mZ3cvZlh2NEdB?=
 =?utf-8?B?SVJYMHJSRkx0cVpvZ2dZUnRsSjFQdTlMSmJIR3pmOVJtNmpkRzlSVUEyRTVo?=
 =?utf-8?B?YXUzbmJRY2ZxZVpFR2VyeUNwUzkzRldRa201MkZtOXV0UHZ5UmtqUGdLTlI1?=
 =?utf-8?B?VjJnUUdmV1pSSWxJNUVSVUx4UWpmOXZla25KcjFEU2NDdGxUWVp0citFU1N4?=
 =?utf-8?B?cFJrQnc1b05nZ3lBd2VTRkQxYzBvY0NYNkE3WVlEcWNJcFBKakNBMkppN09m?=
 =?utf-8?B?c2RrQUZGNGdJTzlpU1JsL3R0ZjVjVWR6bGx1NXIxcnlaNXZDTWFDTVJpWEtB?=
 =?utf-8?B?ZE15TG5XMVVoRkRSS3pINEpLZkNXSWc1SHFENm1Ob2hUaGt3VHY1WDJUaE5a?=
 =?utf-8?B?NTlkT3RVeGFwdWN3VU5QdlY2dTVSdFI4VFRxUkVCOXUvY3RvVkUyQW1GbVJi?=
 =?utf-8?B?SEVnZWt4MS9hY2w5UE85VjJXZE1DaDd2dnpzTjlINFZZVkw1KzJLUC9KWW9r?=
 =?utf-8?B?Rnk3OTUxb3g0Qk1ObzdGWHZCbkRRMEtkRndtd25XbHQ3RXZPd0s1WEdMc0o1?=
 =?utf-8?B?cGZsNm1pUHVCdzJPZUVoajNlQnZXb3pDaHV2TSsxRzdEd2VyTG1BT1Q1ZDFn?=
 =?utf-8?B?RHc2MWMzZlV4YjdMeVRYRmQzQTFxcEp3TzNNSWllQnlBZ05qbVpVejdPSHds?=
 =?utf-8?B?WFpidmgxRzh5amZRczFvck5CNXFmOGlYc3UxWlhzakZQTDI1STl2cW9OVTVT?=
 =?utf-8?B?dGk5NWhUUlBOSjFmeFNpTTJSWmFhYVdySE1ybEpwSUJ1VkJCMCtMaTNkUVNS?=
 =?utf-8?B?b1dwZDlGUVdaMkowVHlNaWtKelZpcDNRdHJsU1VTSzFUU2lUdGlxdUJLK2Y1?=
 =?utf-8?B?ckhCSXplYUFmRGx0azRlaUtvL3V6dGk2OGdZejlucEVWaTZtNmdlbFNMZHYr?=
 =?utf-8?B?UEJnS3BPc3hWYXdjQU5rMzExZFJ4OGs3UXJLdzRUaDRFazlibGRNUitYS2lJ?=
 =?utf-8?B?K2JOQkxYbjJ1ZFpsR2tjQ21JNUdHd3BZcUZILzhWZnNON0dtaElaZ3ZzMFpx?=
 =?utf-8?B?cVhKb09CelZRU1JaODBPRmFMS3gzZ3NYVVZobnNud09OcDJoVjRlcENjZ3JG?=
 =?utf-8?B?OG1xemQra3I5U1hvYXp1bzJlMVdmSThQUWdycDlhbjdWTkYxemZ5a2x6cmlx?=
 =?utf-8?B?dVhldWVTR2dORzRxNURLbm1BOUd0R0gwR3NlVElPaWpySWlmY25zZVhFdVJk?=
 =?utf-8?B?SUE1OVltd2F5U0kvQWhhMzRqTEh2QWhkdFQ5NWgvT3RrN1FLVjFvUzRzbG03?=
 =?utf-8?B?UEZOZTN2VFVmTUtCdGFOSTBKRlJJOTlwVUpMZGdZQmhKdTVKUkpUQzlmV0p5?=
 =?utf-8?B?VS8wZml6ZDkrTjlMcW9kOHA0SmYvOGVuOHBZb3BWYkttWGpiT1VFSGxwZFh6?=
 =?utf-8?B?VDlIV0sxQS94VkNjbTJVNmtFVVRRRHpQM2htOWpZY0M2MVkweWtCbThVcHZ6?=
 =?utf-8?B?SFB4V2FaQ0JndTBCVEJ4aWowcC9pNGtUV0ZIR2xRVERzdFRCcE9kZzFrSEFp?=
 =?utf-8?B?S2R3SVZHRmtuaWJCM2hueFRqb3NCWUFYVHhjYjM5cE4xMzN4L1RiOEMrNlZ4?=
 =?utf-8?B?RGpMVUY3Ukc0dXhKWDFBS1NybWprZ2VDR01sbU9wTlRkZDJ3RGtxRld5ckgv?=
 =?utf-8?B?VEhjUjE5enBaZUFmRXVqZE0zcVRscXJOOE5TdEtWSFFqSFJ0RnlYL0Zpcmps?=
 =?utf-8?Q?ih7j9K/WMCyXK1Y2G1uNZ8uxHVJOsWr/ioG1uSZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb76e3b9-a99e-4e59-be2d-08d9272b0835
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 07:33:22.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atefeg9SLC0a+esb6Std0qA+0iOhIsgz+2Ns4EZE+C0md2Manwb5uwXzkVJOC0sWit9/4R9/1aiUV/mMyvHFxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgSnVuZSAzLCAyMDIxIDg6NDEgUE0NCj4gDQo+ID4gV2hlbiBkaXNjdXNzaW5nIEkvTyBwYWdl
IGZhdWx0IHN1cHBvcnQgaW4gYW5vdGhlciB0aHJlYWQsIHRoZSBjb25zZW5zdXMNCj4gPiBpcyB0
aGF0IGFuIGRldmljZSBoYW5kbGUgd2lsbCBiZSByZWdpc3RlcmVkIChieSB1c2VyKSBvciBhbGxv
Y2F0ZWQgKHJldHVybg0KPiA+IHRvIHVzZXIpIGluIC9kZXYvaW9hc2lkIHdoZW4gYmluZGluZyB0
aGUgZGV2aWNlIHRvIGlvYXNpZCBmZC4gRnJvbSB0aGlzDQo+ID4gYW5nbGUgd2UgY2FuIHJlZ2lz
dGVyIHtpb2FzaWRfZmQsIGRldmljZV9oYW5kbGV9IHRvIEtWTSBhbmQgdGhlbiBjYWxsDQo+ID4g
c29tZXRoaW5nIGxpa2UgaW9hc2lkZmRfZGV2aWNlX2lzX2NvaGVyZW50KCkgdG8gZ2V0IHRoZSBw
cm9wZXJ0eS4NCj4gPiBBbnl3YXkgdGhlIGNvaGVyZW5jeSBpcyBhIHBlci1kZXZpY2UgcHJvcGVy
dHkgd2hpY2ggaXMgbm90IGNoYW5nZWQNCj4gPiBieSBob3cgbWFueSBJL08gcGFnZSB0YWJsZXMg
YXJlIGF0dGFjaGVkIHRvIGl0Lg0KPiANCj4gSXQgaXMgbm90IGRldmljZSBzcGVjaWZpYywgaXQg
aXMgZHJpdmVyIHNwZWNpZmljDQo+IA0KPiBBcyBJIHNhaWQgYmVmb3JlLCB0aGUgcXVlc3Rpb24g
aXMgaWYgdGhlIElPQVNJRCBpdHNlbGYgY2FuIGVuZm9yY2UNCj4gc25vb3AsIG9yIG5vdC4gQU5E
IGlmIHRoZSBkZXZpY2Ugd2lsbCBpc3N1ZSBuby1zbm9vcCBvciBub3QuDQoNClN1cmUuIE15IGVh
cmxpZXIgY29tbWVudCB3YXMgYmFzZWQgb24gdGhlIGFzc3VtcHRpb24gdGhhdCBhbGwgSU9BU0lE
cw0KYXR0YWNoZWQgdG8gYSBkZXZpY2Ugc2hvdWxkIGluaGVyaXQgdGhlIHNhbWUgc25vb3Avbm8t
c25vb3AgZmFjdC4gQnV0DQpsb29rcyBpdCBkb2Vzbid0IHByZXZlbnQgYSBkZXZpY2UgZHJpdmVy
IGZyb20gc2V0dGluZyBQVEVfU05QIG9ubHkgZm9yDQpzZWxlY3RlZCBJL08gcGFnZSB0YWJsZXMs
IGFjY29yZGluZyB0byB3aGV0aGVyIGlzb2NoIGFnZW50cyBhcmUgaW52b2x2ZWQuDQoNCkFuIHVz
ZXIgc3BhY2UgZHJpdmVyIGNvdWxkIGZpZ3VyZSBvdXQgcGVyLUlPQVNJRCByZXF1aXJlbWVudHMg
aXRzZWxmLg0KDQpBIGd1ZXN0IGRldmljZSBkcml2ZXIgY2FuIGluZGlyZWN0bHkgY29udmV5IHRo
aXMgaW5mb3JtYXRpb24gdGhyb3VnaCANCnZJT01NVS4NCg0KUmVnaXN0ZXJpbmcge0lPQVNJRF9G
RCwgSU9BU0lEfSB0byBLVk0gaGFzIGFub3RoZXIgbWVyaXQsIGFzIHdlIGFsc28NCm5lZWQgaXQg
dG8gdXBkYXRlIENQVSBQQVNJRCBtYXBwaW5nIGZvciBFTlFDTUQuIFdlIGNhbiBkZWZpbmUNCm9u
ZSBpbnRlcmZhY2UgZm9yIGJvdGggcmVxdWlyZW1lbnRzLiDwn5iKDQoNClRoYW5rcw0KS2V2aW4N
Cg==
