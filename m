Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA13A396CEA
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 07:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhFAFon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 01:44:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:20518 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhFAFom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 01:44:42 -0400
IronPort-SDR: pA+RTzNVdtDpQ6E1dY7AqBknt4hIglQjkLL7YmowRIu4SWeGDHmGntKBh/SJKppTId8TZ93H3K
 cyxDrER6J0cg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="264662497"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="264662497"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 22:43:01 -0700
IronPort-SDR: QmS3R4Hn/BTcjd9GJVsPbL36GYJyCAKPbNoLymUHg/SAqoyJ9PEMvGlk//WI11EQAZEjyA8v63
 Tf56EtMp6DKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="399496212"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 31 May 2021 22:43:00 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 31 May 2021 22:43:00 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 31 May 2021 22:42:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 31 May 2021 22:42:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 31 May 2021 22:42:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/NyR9Mn7WV1lpJx72qPeWLoMHWJi6Xs4pqGk3CZyVbj40ksSSsWJ+WId6EeQn2aGWw1kjTZGRdDOc+LyWn+Yo1C9dSE6DKP/1ecOtg8djwPtKy1NieDXhfj9HWUHp7+BQnxH8i6+HMD3XylnIOKnETOx4b9XqLNonQeatcyePlBsKitllw9+MeZ+o7o9ARoCO37VC7osDMuRSCEH+IHgC3CZxfRKxZC4olqxGjkvKMUqFXDFN6C7/8grtoPtckRpyAnFyU8BAnNk554OejtkWPLBnAcgRwYQz8lwRhpV6atqh7f41VJSCMnTwiJGM4BI/C+etErTrrKYFhixjRhSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtEghAY5jZKCVX5baKvbmyzvWWYUUXv+jV12h7728Bg=;
 b=SAXLce4MEVy+sdL7NJCs2QpFprw+wgDWxQRCqvUa+mjw8YVSWvjxVXc/UnL3Ljftg+HPFaW//RqoF7TBLRHeU3yQkf/xhGhCXllf4M+8f6DjJqOa5A7GPAOVteOmO+569Jz+R9YjoFRsNqMJgpVgO09iEIeiQnN3s84WKx88LjgkJ+ECrAx/bKXp3J6sM0SDHrdLLkNiqk74FWx7xhJ7J1vuoE+DEa7p53DFN98Pm5c/Cayl7FcJAXAefDOnfYgvQpWYBDWy4snb+3A9xXvzixtAy7s89OwUSWAua1cSFYo6LP3hvro1ctG3IMDVF1RtNSB6dsVQGfnvMe4KT9O4pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtEghAY5jZKCVX5baKvbmyzvWWYUUXv+jV12h7728Bg=;
 b=SpR2gzbmysFOVMLcFD0J9zPqfaAMWOIaXyccXyGsVXSPlNYCt2OMTs7KI5N+r2JC9jKEE/c1wZFJi+SwNLIwO5NBUfZPPNpcIoHyUTX6/b/NPVLOZpkm7oiOa8knvif/vHI0Tsrjtmkj/3rasezTKW4B4Sk+/cT07hXxdSV4u+o=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:95::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 1 Jun
 2021 05:42:58 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 05:42:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu Yi L" <yi.l.liu@linux.intel.com>
CC:     "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwAm5asAAKQEygAAJY3uAAAB7iAAAANf0oAAAILVgAAAOmmAAABkvmA=
Date:   Tue, 1 Jun 2021 05:42:58 +0000
Message-ID: <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <f510f916-e91c-236d-e938-513a5992d3b5@redhat.com>
 <20210531164118.265789ee@yiliu-dev>
 <78ee2638-1a03-fcc8-50a5-81040f677e69@redhat.com>
 <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
 <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
In-Reply-To: <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a684106-08be-4d5b-2241-08d924c01ce3
x-ms-traffictypediagnostic: CO1PR11MB5154:
x-microsoft-antispam-prvs: <CO1PR11MB5154B9497E036624852B3A5B8C3E9@CO1PR11MB5154.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8JaoRZ7De5CG2xJut1K7aS8lyabkkQ8vHQjeThBZEXCeNNGyQQgf2bDMBAWGWYfU9Sl1d4IKubpxyw/g/qiENPrWNhQTvZxaXOLP45KDvy+yV3Q2pNbmgct1I87R6Wk0UmI68LOFlhpc2laXUl2clFLifKLQz7Jxxd6CLYL1KLxlkfVJXTco9ufuHRumFBjW3f08GhUTB+BSNV5D1hR4cq8lxCU9AEKDmH8PCYeOtMyPQRSE5fXad4na9zD2PvekXISeqNEPzTXSXVa1xaqeNoEFD6XfDvQadYgFJ6I8XkTUqsoFnMbBbVlSLQkO76bwj9PBgUWFMbamp6udaVHFZQWuqNB+NZhGGQ5Uoy5vVtD5rFkTss24wsiPrtxdi7Kbp+rWbJK1EA5Pb0RNQ0iFaUPyzgzCjQiWR45jW71/T2ylFpXCatXvJxHBc6KaO2tGMQcIlKFMFGjqdt4Dw/So5NILPPGq9g8th6Xp4dTq9hRBcgVIvPzzhtlhXrhQGJGU/te2xUU/jMFdoRrLGKmTBbB9fF4yusLYEVlLKwr/DG3EKjH1sbEDABJqhLZPKbWjKzINK8jXxxA1pRick43mRE0IYsB8umtv9nsLqojS2s4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(136003)(366004)(76116006)(8936002)(5660300002)(52536014)(26005)(122000001)(33656002)(6506007)(53546011)(316002)(38100700002)(54906003)(9686003)(7416002)(8676002)(86362001)(55016002)(110136005)(2906002)(186003)(66446008)(71200400001)(66946007)(66476007)(66556008)(64756008)(7696005)(478600001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?amlBdDJpM0tJLzgySGZ0VmFOSzdpTEE0QzNTSVJ6VHM3TEJYaXBac1RsN3V1?=
 =?utf-8?B?L25TK2Jud0pCSDhYbHRUd2djbVlJdDdIRmVnS2tNUmJUdU9qMTZMWjQ0ZHJ3?=
 =?utf-8?B?ZjJPbVRackhZNC9jY1BLbWlZRkpOc2ZoN1Y2ZVVwL2g3RGRGNStnejYram1t?=
 =?utf-8?B?MitUSitSdlROa29wdzhZUmluSXc3bFMyb21SZUZrWFZrU2QrMDFtR2x3WHBL?=
 =?utf-8?B?SkNyQXZXR1FTVGhWTFhCOEJpenMyZDJjbEdZUDlkYVZ1NXpuRks4MTRWNGVa?=
 =?utf-8?B?NEJObStsRTVmZ3A2a1BsQUdpUExwUnV6aWRWNWczRlEweVdyYzZ6M2F3SEJE?=
 =?utf-8?B?TGlQOEJtVXg3eElJK2o5NjkrQllRZlBWcUNRcHc3M1pCeC9SYVlWUWd2cE5Z?=
 =?utf-8?B?VVRua2RKWXpNNlJPSzNlb2ZKaVpWaUh3U0dwVkp0UUdNdVhsUDNwa2RIdUF0?=
 =?utf-8?B?SkN0Q2J6TGQxekkzNGlBOWNRZ2hiWjhKMm1aaDlIaW1PWUZRaGNGWjc3UlNi?=
 =?utf-8?B?N2t3TTkxZkNIWXFobnU5N0hxVTJDUC9KZi9LbEpwd05NREMwR1ZPVDFLb0pH?=
 =?utf-8?B?YUYrRUhDRTQzeHdJa0hXTEUvRXIrZkhuQWhCT3BrL21KSUE5MVZ1ci9DYTVN?=
 =?utf-8?B?bkpJLzVrd3dyWGNaWTNzZytlQzlpTUtrWXdFZWxqV3JCeVE0M0FZTWdRV3Bw?=
 =?utf-8?B?bUNyZGZpUU5teDR2QUNEYzJTY1FqdXg4NWN2T295alNXaVNPSFZncmVXam1o?=
 =?utf-8?B?UDZPNjB2Y1VoYklwMXEveVQ2ekc4bGVHS2lheTRpNm5IK0NMa0l1QXBOR21X?=
 =?utf-8?B?VmtXMUR4SnBtRVQyMWI2dzE4OXR4MHZhbUpMV3hSZWsxU0swYzRkWHZwalVE?=
 =?utf-8?B?L1hvYzJmZEpWdGhFbEJWVm95TFhtaTc1YnExclhORXJETk1UcGNBbW1RYTg2?=
 =?utf-8?B?TFgwZHNQZ2Qxc3FFUlVwMW9hdU5SZk5VdlRkZEhZTXlUNCt5K0U5YUVGVjFI?=
 =?utf-8?B?YUhRcUhpMytndklIOFFheGZFT3UrY2VXR05TOGRrNUNkUG9FK2RBbURSMzcx?=
 =?utf-8?B?R0RTNUo4bDREeWNCU1VPdEYrSHM0aEJsM01XcitKTk8yVW1yRnQ3Um9uK24v?=
 =?utf-8?B?dUZveWtLcGs2dXZGZnZjSVMrK0ViU0ZnVEljUU8vU1luZEt5SldqWlBTRzR6?=
 =?utf-8?B?TjE0L3pFcmI5anJBeWNZbE9Nc051dFVHcHhvSitVMmJnYmRXTmJUaVRDNjd5?=
 =?utf-8?B?dnZUV0laOTY4bmw4TXcvcU5kV3NLb0xHdUdEN2RGY25CM3ZBbkRSUmJmcW9R?=
 =?utf-8?B?VzV3Qy9tNXc2d2lTQmVRVWNsNnFtUmpEVXhmcGgzRUIrRFdyTWRxc3BiRXlP?=
 =?utf-8?B?Y3ZISW81dys5VXYyNWYvbDNKdGxRQzNNd3pHcjNrVm1mSHkrYmNZRGhMNlA1?=
 =?utf-8?B?ejFlUVZNRFpzVlZydkI2U25hbE9Fdkd4endpSXJoTWRreCtPa3FCeFRjTGxU?=
 =?utf-8?B?M2ttU2ZaalZIZUVpOXJPNnVvN1NHV1lldzArWmR3eWoreGNPQyt2MzdINUJT?=
 =?utf-8?B?UWZSUDhWQ0d5bWhXUDhDOWJtc2FkUGhybXRrbUYrMmpzMGZZdngzQ1I0clgv?=
 =?utf-8?B?OHFDMzhBbHp1cEZMK0x1bFUwa1VlV1l4Z1A4Z1R2NHNSZ1pOSFR3SjJBZUVo?=
 =?utf-8?B?SHhjSW9udkJ0V0RYb05nQVQ2dHVHY0VlYTc2MFRHU21WSHIyOW4yS09yK1Vx?=
 =?utf-8?Q?Lc5CAlQMopuYUR8WVWnomE1AjUkhzW1UIhIg9lX?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a684106-08be-4d5b-2241-08d924c01ce3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 05:42:58.5834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LYkXg6nCohrHo/QOtixi7mOjsQ48uNjHKPYqx/wn/D4xZ/B7xvmMuIIbbYY0gjNgPOrariMk/If+RNJj9lCEqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5154
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nDQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMSwgMjAyMSAxOjMwIFBN
DQo+IA0KPiDlnKggMjAyMS82LzEg5LiL5Y2IMToyMywgTHUgQmFvbHUg5YaZ6YGTOg0KPiA+IEhp
IEphc29uIFcsDQo+ID4NCj4gPiBPbiA2LzEvMjEgMTowOCBQTSwgSmFzb24gV2FuZyB3cm90ZToN
Cj4gPj4+PiAyKSBJZiB5ZXMsIHdoYXQncyB0aGUgcmVhc29uIGZvciBub3Qgc2ltcGx5IHVzZSB0
aGUgZmQgb3BlbmVkIGZyb20NCj4gPj4+PiAvZGV2L2lvYXMuIChUaGlzIGlzIHRoZSBxdWVzdGlv
biB0aGF0IGlzIG5vdCBhbnN3ZXJlZCkgYW5kIHdoYXQNCj4gPj4+PiBoYXBwZW5zDQo+ID4+Pj4g
aWYgd2UgY2FsbCBHRVRfSU5GTyBmb3IgdGhlIGlvYXNpZF9mZD8NCj4gPj4+PiAzKSBJZiBub3Qs
IGhvdyBHRVRfSU5GTyB3b3JrPw0KPiA+Pj4gb2gsIG1pc3NlZCB0aGlzIHF1ZXN0aW9uIGluIHBy
aW9yIHJlcGx5LiBQZXJzb25hbGx5LCBubyBzcGVjaWFsIHJlYXNvbg0KPiA+Pj4geWV0LiBCdXQg
dXNpbmcgSUQgbWF5IGdpdmUgdXMgb3Bwb3J0dW5pdHkgdG8gY3VzdG9taXplIHRoZSBtYW5hZ2Vt
ZW50DQo+ID4+PiBvZiB0aGUgaGFuZGxlLiBGb3Igb25lLCBiZXR0ZXIgbG9va3VwIGVmZmljaWVu
Y3kgYnkgdXNpbmcgeGFycmF5IHRvDQo+ID4+PiBzdG9yZSB0aGUgYWxsb2NhdGVkIElEcy4gRm9y
IHR3bywgY291bGQgY2F0ZWdvcml6ZSB0aGUgYWxsb2NhdGVkIElEcw0KPiA+Pj4gKHBhcmVudCBv
ciBuZXN0ZWQpLiBHRVRfSU5GTyBqdXN0IHdvcmtzIHdpdGggYW4gaW5wdXQgRkQgYW5kIGFuIElE
Lg0KPiA+Pg0KPiA+Pg0KPiA+PiBJJ20gbm90IHN1cmUgSSBnZXQgdGhpcywgZm9yIG5lc3Rpbmcg
Y2FzZXMgeW91IGNhbiBzdGlsbCBtYWtlIHRoZQ0KPiA+PiBjaGlsZCBhbiBmZC4NCj4gPj4NCj4g
Pj4gQW5kIGEgcXVlc3Rpb24gc3RpbGwsIHVuZGVyIHdoYXQgY2FzZSB3ZSBuZWVkIHRvIGNyZWF0
ZSBtdWx0aXBsZQ0KPiA+PiBpb2FzaWRzIG9uIGEgc2luZ2xlIGlvYXNpZCBmZD8NCj4gPg0KPiA+
IE9uZSBwb3NzaWJsZSBzaXR1YXRpb24gd2hlcmUgbXVsdGlwbGUgSU9BU0lEcyBwZXIgRkQgY291
bGQgYmUgdXNlZCBpcw0KPiA+IHRoYXQgZGV2aWNlcyB3aXRoIGRpZmZlcmVudCB1bmRlcmx5aW5n
IElPTU1VIGNhcGFiaWxpdGllcyBhcmUgc2hhcmluZyBhDQo+ID4gc2luZ2xlIEZELiBJbiB0aGlz
IGNhc2UsIG9ubHkgZGV2aWNlcyB3aXRoIGNvbnNpc3RlbnQgdW5kZXJseWluZyBJT01NVQ0KPiA+
IGNhcGFiaWxpdGllcyBjb3VsZCBiZSBwdXQgaW4gYW4gSU9BU0lEIGFuZCBtdWx0aXBsZSBJT0FT
SURzIHBlciBGRCBjb3VsZA0KPiA+IGJlIGFwcGxpZWQuDQo+ID4NCj4gPiBUaG91Z2gsIEkgc3Rp
bGwgbm90IHN1cmUgYWJvdXQgIm11bHRpcGxlIElPQVNJRCBwZXItRkQiIHZzICJtdWx0aXBsZQ0K
PiA+IElPQVNJRCBGRHMiIGZvciBzdWNoIGNhc2UuDQo+IA0KPiANCj4gUmlnaHQsIHRoYXQncyBl
eGFjdGx5IG15IHF1ZXN0aW9uLiBUaGUgbGF0dGVyIHNlZW1zIG11Y2ggbW9yZSBlYXNpZXIgdG8N
Cj4gYmUgdW5kZXJzdG9vZCBhbmQgaW1wbGVtZW50ZWQuDQo+IA0KDQpBIHNpbXBsZSByZWFzb24g
ZGlzY3Vzc2VkIGluIHByZXZpb3VzIHRocmVhZCAtIHRoZXJlIGNvdWxkIGJlIDFNJ3MgDQpJL08g
YWRkcmVzcyBzcGFjZXMgcGVyIGRldmljZSB3aGlsZSAjRkQncyBhcmUgcHJlY2lvdXMgcmVzb3Vy
Y2UuDQpTbyB0aGlzIFJGQyB0cmVhdHMgZmQgYXMgYSBjb250YWluZXIgb2YgYWRkcmVzcyBzcGFj
ZXMgd2hpY2ggaXMgZWFjaA0KdGFnZ2VkIGJ5IGFuIElPQVNJRC4NCg0KVGhhbmtzDQpLZXZpbg0K
