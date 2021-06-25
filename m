Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0223B41A1
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 12:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhFYK3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 06:29:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:2042 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231182AbhFYK3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 06:29:43 -0400
IronPort-SDR: lqRI/r9ZcPRSAyFRL49qy4qBMCt0THREGYb8oRO6f+KSVo+1IoCKW9XVeBkJ+fU/XiTwF97UR6
 gcLBqIZIX2Hw==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="187335146"
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="187335146"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 03:27:23 -0700
IronPort-SDR: Yaq4/4GniU5CBWwS3niN5m5jjTitDm4SoJ1dgiJJ6x4dPjq0z6EbCn2IaSmI3++YHkBB3ksiYT
 bOEWeB+Kf8eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="424392973"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 25 Jun 2021 03:27:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 25 Jun 2021 03:27:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 25 Jun 2021 03:27:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 25 Jun 2021 03:27:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GT/MlDVOcxFZCzWZFEeTG5uRwv3S/UrtO73zTZBzF3rrh9ZSsCZrKdn8Dew4H5JQzB35dXvEtp+m0yIIQU8lcEhrbstqKQlizPOFBMqusgTzWf+bnkUc2G7lOFq6voD9wno9bM490xshafzQ7qmpwM55HiqQSRiaBu2WibiHy6U0dSdkisdB0RGH763rUtSTE0cTzve7ffSmX/aNnFNLqhta6yA232WgIYrLRRvtrUtHq2QK3Yc/IszC8odU7YelAGNuemGisgh71lMzGPfiF794dXMO4NTMXwivQEF4jMrtmOR2EY5uTqUK5xY3aS4pJjHlPlrGJ0DpR3FPq3F76Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=971DWR3nJOCx1/LD3p3lq/xs7B66xwOpXjITuyp5Kg4=;
 b=fM9Dxwz2PfevQIFBZErbc69wzw3QsijL2WNNsoRgq4gGs9zDRf1VHajdRy4VwO7f4JyJS5W//qufTGtaEEs8CUD0LUZwO8Gq/EFm8bxWd9di+gXzay3hMAqXikbd6/aTWzOMgM/6ANqGTDdYtMbUBhK3Vwsmf9shvsc4ydRO270mi19PpimTDZF5TiVITfk4LzIYiKc40uuxHktuVghJlwqcW54lQdZvFRFUyLBoGbMijNCZHFPyuWuSUeN+vrWhU4r/ixssdUvSBIRcTWjwSi6R9FWKIf+kuirbrkuXuyjQyf13FwWVdcvHqzJ1NAr7jzjbKdNJOvACZCBUtNC+XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=971DWR3nJOCx1/LD3p3lq/xs7B66xwOpXjITuyp5Kg4=;
 b=fu9e7H2EAJOQCH95yJNDHSvAlwfhx6Sl8ixIq6gXX8je93/yQNgsuwL/azTyj9AtTAnBR7oGCotn0mXaVqjD5PjJpRefrBXhNZ604g2VCdZ0NmtJroXtKyc42EAXJBMxGGrixcHVNUkW4+QTcVErU2fB+DVACuNFNxWIYLyn7UA=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3763.namprd11.prod.outlook.com (2603:10b6:408:8e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.22; Fri, 25 Jun
 2021 10:27:19 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a%5]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 10:27:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Joerg Roedel <joro@8bytes.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "David Gibson" <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAA0n7GAAAYKlwAADDvuAAAgbLGAAF6lSYAABO0WAAATSRtQAB5ymYAAEyKHQAAmZhSAAAo/ocAAK16TAAAGdqAAACJdiVAAA3a7AAEa314A
Date:   Fri, 25 Jun 2021 10:27:18 +0000
Message-ID: <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210618182306.GI1002214@nvidia.com>
In-Reply-To: <20210618182306.GI1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 474f2868-b1b2-45cd-6154-08d937c3cfaa
x-ms-traffictypediagnostic: BN8PR11MB3763:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB376374F945F256924498D25E8C069@BN8PR11MB3763.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Ear0bD5TdeyAoiCpefXiOCcGhLYzJYj8ImGcrI1IqNk190YumLyTg6INbyMYEi9oeyNspHVNVMdR7LU3uBWy6qllcG35ddVgbxJr1fo7XCfAbo2J2sKV53dbD6xdTX+hcH605f2YsZBMypxJ+/1OKCofl0KaMPGlYdzMfZIHwDpMJh3UqYplpqRaVuPzb3Y4g+YWFszmdHLSmribyNCg32aKzf2aMckOh8B2wGF5twLDp+JjF76xK5XmMNp1avBMv14rQYM0KkTVysQHy8xuXvfX0lQz/HhL5d1Op3Rttnnf2FzcplawlEMPbGlPxpZ5DZq2J/A8SosW7ou7lZwqxtXt1sfiVfpZAOtc1a5irseaWsZehe3Sunnuk5x1cRRWWru3DPbo8p8gCDVV9Ey35kQKY0vByTZMPaF9C5l2tPI9/lf/qLsaxMTpYgRizeF1WMhkwi/uDHly2wt+xu9sYvSv1Wxit2Vt5i54dTZC1jsxB8PwiwQYP1H9/9c9nPZZMgHjTbAH5Ivh9FOtk3R+9h81yR8XDQA0l+yCAeXGlBIRV7AskLQWq/1kvQ1DGWCvLw9hM5OM2CR1eMS+PZKaWv3rHHGufoFcTSeYt+f5UBy+LlB36yl7/sFQW4CmfXWh0hp0EDMxWvMwotzIW5ZqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(26005)(478600001)(4326008)(38100700002)(66446008)(64756008)(2906002)(186003)(66476007)(7696005)(8936002)(66946007)(83380400001)(76116006)(5660300002)(122000001)(66556008)(7416002)(9686003)(54906003)(52536014)(110136005)(71200400001)(8676002)(55016002)(33656002)(86362001)(316002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHA5K082elQ4QmphODQ3MExKRTZ0bm5ZQW9qc1VSbEhxNWpJZit3OHJ6d0xU?=
 =?utf-8?B?bmNSZThYOVZXR2xxUWMvZmJhVlJIZEhJNkMzQmdzQmJWbDdrblBYN1czSlM2?=
 =?utf-8?B?aTdOMFV1NjIwTHB3a05ITW5VVmdJZW1WblJOV2FKZHpPVk9kdXNLMUNVTjJG?=
 =?utf-8?B?MkIvTFY0SWhKSmVZNjFITkNHbmp1WjFXT1BGd1RpMlR5NkpybXJxWXBkYTdS?=
 =?utf-8?B?N3l6eDhnSTJCY2hHNHJNUW5PRjNFU3ZCMUovZEpZcFJSWFlxK2k1UjZXUnA3?=
 =?utf-8?B?RGdrbUh3bWZUaTBzT1pxa1VHWG5DbzF3UG0wKzl4MjhqaVI5NFF6UG44TmYy?=
 =?utf-8?B?czFKOCtVbVI5R28waVM1TUxUZ2NNWkJGcWJXeFNFRlBFajBlbDFsYllOR3Zi?=
 =?utf-8?B?Z1BrekZGOUhBUHJrWkpZTloxRnM2TmdvNElvNTVmQXhQdWxMb2RheDJsaW1S?=
 =?utf-8?B?SEc1WDZnQm9KT2tOQ2dYdnJwdnhCTkVkQ2YwODJxeGo3bTdmNTcwd01qaFBO?=
 =?utf-8?B?QmFydHpFcjNPWE1MNE1DZVRvMmdTOEtrZjBkNHZGU1Rpa3VKOG9Ha1g3bEdI?=
 =?utf-8?B?R1Z3MXpXTkVFQ2ZwcEVsOWFEOTIrOXR0ZWFqTmt3bjJZU1VicTJWbzB2ZGdi?=
 =?utf-8?B?aWhCN29VdVlQaFNxYUF4OFZxV3pQNUlpNi85dG5UVlhkU2VwNEd1NG9vSmNB?=
 =?utf-8?B?SDZQcTlVNXh1cjBnQjVxNm00OWhMaW1UMmx5S3dKaCtSUStHWStSckwweFpV?=
 =?utf-8?B?MHlmL2JMNEkwYnZYMzMzQ04vRzJkQU5QWitMdmJoZGtXbWVUazFveC9LcjFX?=
 =?utf-8?B?ZEtZUEI5Q0VrSmE5VmxLZDlTV0YyOUVPU3I0Z3dLalBwYmlYbEViR2lMRHhE?=
 =?utf-8?B?YlEzcVZRUnFCd25HV2Nqdjc1bk4wNHUzdFhtLzV5dXM5YUlaeHlja3I5TWoy?=
 =?utf-8?B?cmxXZzNwdUxRVDNmOWc2alg5WmN3Tk9uUmNiaFF5NEo4TDZCOEZkWlVlR09r?=
 =?utf-8?B?OUhVMDQwQWZKOHdsYXlSYzJNVUxYa1V5aXdTc3RHQ2p0UzY5cUFocFNISk1G?=
 =?utf-8?B?Qlp6ZDdhbERnNit1SU5aWk1SUlNpZmIvY2s5S2Nodi8vMHNYRnNoaVN4S091?=
 =?utf-8?B?TWk4enhsR0FnYnM4OTl0UEt0Szd1U1RRZXlla1doa0daemRQa0tiQk1tQzc1?=
 =?utf-8?B?a1JxNW1XS1F5eklod1dNQ1E1Ri96U0FpeEc5R09UNGwvb0VwcU8wNnU2dFRh?=
 =?utf-8?B?bm0rRnNtZ00yejZIbWpnUHJ2K3FjczRTV2J6dXZGdEo5Ny8zQjZvZlA5Kzg4?=
 =?utf-8?B?L3BIR3BXd1VtOElVNG10Rmhhd09FaXdveEluZEtlN09uKzVLbFNRUG1JVytm?=
 =?utf-8?B?MkNWR0gzbTNERjBGTlBZaHlhMnM5RHdjZjZYb1VUd1pjdGNreFZSMjMzQmNB?=
 =?utf-8?B?b3ZId3pySWQ0VU1XQXdrcUV5MEpCdTYrWjI3QWlqZ3lLMWUydTNGdlRoNjhR?=
 =?utf-8?B?QXZzZVl1WTY4V25kbG1VRWJ1WVVCQldVbWVnZHRUL0RmekNoMjVZRTdMMVcy?=
 =?utf-8?B?VzBOQWdaYW90UG1uWXZFcHd6Mmd3OGZJUXV1eDViUkVHMmY4S1I4eXlQTUUv?=
 =?utf-8?B?Q3hrMDMzTXVhSVBERXRhZUFuakxNK3pyRkdzRUtIV0cvTzQreC9yam51TzRW?=
 =?utf-8?B?R3RSNFliVHFZSE1oZk9hN1NsVlRSdW9mM0JzZW1MVVFpZWdBdjhabVNlVWZl?=
 =?utf-8?Q?4tQbFY28I0U4x6dM7n9nPuqBM7yK+57Zcn+bKd5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 474f2868-b1b2-45cd-6154-08d937c3cfaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2021 10:27:19.0113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ygRpR7XQfXTihL3slo316jB02P8vEpIocs47Y4RniIjeD6kHKiHN9YqxUBWrN+SV+zt4Y3ctiE10oyufYQe+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3763
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksIEFsZXgvSm9lcmcvSmFzb24sDQoNCldhbnQgdG8gZHJhdyB5b3VyIGF0dGVudGlvbiBvbiBh
biB1cGRhdGVkIHByb3Bvc2FsIGJlbG93LiBMZXQncyBzZWUNCndoZXRoZXIgdGhlcmUgaXMgYSBj
b252ZXJnZWQgZGlyZWN0aW9uIHRvIG1vdmUgZm9yd2FyZC4g8J+Yig0KDQo+IEZyb206IEphc29u
IEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBKdW5lIDE5LCAy
MDIxIDI6MjMgQU0NCj4gDQo+IE9uIEZyaSwgSnVuIDE4LCAyMDIxIGF0IDA0OjU3OjQwUE0gKzAw
MDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dA
bnZpZGlhLmNvbT4NCj4gPiA+IFNlbnQ6IEZyaWRheSwgSnVuZSAxOCwgMjAyMSA4OjIwIEFNDQo+
ID4gPg0KPiA+ID4gT24gVGh1LCBKdW4gMTcsIDIwMjEgYXQgMDM6MTQ6NTJQTSAtMDYwMCwgQWxl
eCBXaWxsaWFtc29uIHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gSSd2ZSByZWZlcnJlZCB0byB0aGlz
IGFzIGEgbGltaXRhdGlvbiBvZiB0eXBlMSwgdGhhdCB3ZSBjYW4ndCBwdXQNCj4gPiA+ID4gZGV2
aWNlcyB3aXRoaW4gdGhlIHNhbWUgZ3JvdXAgaW50byBkaWZmZXJlbnQgYWRkcmVzcyBzcGFjZXMs
IHN1Y2ggYXMNCj4gPiA+ID4gYmVoaW5kIHNlcGFyYXRlIHZSb290LVBvcnRzIGluIGEgdklPTU1V
IGNvbmZpZywgYnV0IHJlYWxseSwgd2hvIGNhcmVzPw0KPiA+ID4gPiBBcyBpc29sYXRpb24gc3Vw
cG9ydCBpbXByb3ZlcyB3ZSBzZWUgZmV3ZXIgbXVsdGktZGV2aWNlIGdyb3VwcywgdGhpcw0KPiA+
ID4gPiBzY2VuYXJpbyBiZWNvbWVzIHRoZSBleGNlcHRpb24uICBCdXkgYmV0dGVyIGhhcmR3YXJl
IHRvIHVzZSB0aGUNCj4gZGV2aWNlcw0KPiA+ID4gPiBpbmRlcGVuZGVudGx5Lg0KPiA+ID4NCj4g
PiA+IFRoaXMgaXMgYmFzaWNhbGx5IG15IHRoaW5raW5nIHRvbywgYnV0IG15IGNvbmNsdXNpb24g
aXMgdGhhdCB3ZSBzaG91bGQNCj4gPiA+IG5vdCBjb250aW51ZSB0byBtYWtlIGdyb3VwcyBjZW50
cmFsIHRvIHRoZSBBUEkuDQo+ID4gPg0KPiA+ID4gQXMgSSd2ZSBleHBsYWluZWQgdG8gRGF2aWQg
dGhpcyBpcyBhY3R1YWxseSBjYXVzaW5nIGZ1bmN0aW9uYWwNCj4gPiA+IHByb2JsZW1zIGFuZCBt
ZXNzIC0gYW5kIEkgZG9uJ3Qgc2VlIGEgY2xlYW4gd2F5IHRvIGtlZXAgZ3JvdXBzIGNlbnRyYWwN
Cj4gPiA+IGJ1dCBzdGlsbCBoYXZlIHRoZSBkZXZpY2UgaW4gY29udHJvbCBvZiB3aGF0IGlzIGhh
cHBlbmluZy4gV2UgbmVlZA0KPiA+ID4gdGhpcyBkZXZpY2UgPC0+IGlvbW11IGNvbm5lY3Rpb24g
dG8gYmUgZGlyZWN0IHRvIHJvYnVzdGx5IG1vZGVsIGFsbA0KPiA+ID4gdGhlIHRoaW5ncyB0aGF0
IGFyZSBpbiB0aGUgUkZDLg0KPiA+ID4NCj4gPiA+IFRvIGtlZXAgZ3JvdXBzIGNlbnRyYWwgc29t
ZW9uZSBuZWVkcyB0byBza2V0Y2ggb3V0IGhvdyB0byBzb2x2ZQ0KPiA+ID4gdG9kYXkncyBtZGV2
IFNXIHBhZ2UgdGFibGUgYW5kIG1kZXYgUEFTSUQgaXNzdWVzIGluIGEgY2xlYW4NCj4gPiA+IHdh
eS4gRGV2aWNlIGNlbnRyaWMgaXMgbXkgc3VnZ2VzdGlvbiBvbiBob3cgdG8gbWFrZSBpdCBjbGVh
biwgYnV0IEkNCj4gPiA+IGhhdmVuJ3QgaGVhcmQgYW4gYWx0ZXJuYXRpdmU/Pw0KPiA+ID4NCj4g
PiA+IFNvLCBJIHZpZXcgdGhlIHB1cnBvc2Ugb2YgdGhpcyBkaXNjdXNzaW9uIHRvIHNjb3BlIG91
dCB3aGF0IGENCj4gPiA+IGRldmljZS1jZW50cmljIHdvcmxkIGxvb2tzIGxpa2UgYW5kIHRoZW4g
aWYgd2UgY2FuIHNlY3VyZWx5IGZpdCBpbiB0aGUNCj4gPiA+IGxlZ2FjeSBub24taXNvbGF0ZWQg
d29ybGQgb24gdG9wIG9mIHRoYXQgY2xlYW4gZnV0dXJlIG9yaWVudGVkDQo+ID4gPiBBUEkuIFRo
ZW4gZGVjaWRlIGlmIGl0IGlzIHdvcmsgd29ydGggZG9pbmcgb3Igbm90Lg0KPiA+ID4NCj4gPiA+
IFRvIG15IG1pbmQgaXQgbG9va3MgbGlrZSBpdCBpcyBub3Qgc28gYmFkLCBncmFudGVkIG5vdCBl
dmVyeSBkZXRhaWwgaXMNCj4gPiA+IGNsZWFyLCBhbmQgbm8gY29kZSBoYXMgYmUgc2tldGNoZWQs
IGJ1dCBJIGRvbid0IHNlZSBhIGJpZyBzY2FyeQ0KPiA+ID4gYmxvY2tlciBlbWVyZ2luZy4gQW4g
ZXh0cmEgaW9jdGwgb3IgdHdvLCBzb21lIHNwZWNpYWwgbG9naWMgdGhhdA0KPiA+ID4gYWN0aXZh
dGVzIGZvciA+MSBkZXZpY2UgZ3JvdXBzIHRoYXQgbG9va3MgYSBsb3QgbGlrZSBWRklPJ3MgY3Vy
cmVudA0KPiA+ID4gbG9naWMuLg0KPiA+ID4NCj4gPiA+IEF0IHNvbWUgbGV2ZWwgSSB3b3VsZCBi
ZSBwZXJmZWN0bHkgZmluZSBpZiB3ZSBtYWRlIHRoZSBncm91cCBGRCBwYXJ0DQo+ID4gPiBvZiB0
aGUgQVBJIGZvciA+MSBkZXZpY2UgZ3JvdXBzIC0gZXhjZXB0IHRoYXQgY29tcGxleGlmaWVzIGV2
ZXJ5IHVzZXINCj4gPiA+IHNwYWNlIGltcGxlbWVudGF0aW9uIHRvIGRlYWwgd2l0aCB0aGF0LiBJ
dCBkb2Vzbid0IGZlZWwgbGlrZSBhIGdvb2QNCj4gPiA+IHRyYWRlIG9mZi4NCj4gPiA+DQo+ID4N
Cj4gPiBXb3VsZCBpdCBiZSBhbiBhY2NlcHRhYmxlIHRyYWRlb2ZmIGJ5IGxlYXZpbmcgPjEgZGV2
aWNlIGdyb3Vwcw0KPiA+IHN1cHBvcnRlZCBvbmx5IHZpYSBsZWdhY3kgVkZJTyAod2hpY2ggaXMg
YW55d2F5IGtlcHQgZm9yIGJhY2t3YXJkDQo+ID4gY29tcGF0aWJpbGl0eSksIGlmIHdlIHRoaW5r
IHN1Y2ggc2NlbmFyaW8gaXMgYmVpbmcgZGVwcmVjYXRlZCBvdmVyDQo+ID4gdGltZSAodGh1cyBs
aXR0bGUgdmFsdWUgdG8gYWRkIG5ldyBmZWF0dXJlcyBvbiBpdCk/IFRoZW4gYWxsIG5ldw0KPiA+
IHN1Yi1zeXN0ZW1zIGluY2x1ZGluZyB2ZHBhIGFuZCBuZXcgdmZpbyBvbmx5IHN1cHBvcnQgc2lu
Z2xldG9uDQo+ID4gZGV2aWNlIGdyb3VwIHZpYSAvZGV2L2lvbW11Li4uDQo+IA0KPiBUaGF0IG1p
Z2h0IGp1c3QgYmUgYSBncmVhdCBpZGVhIC0gdXNlcnNwYWNlIGhhcyB0byBzdXBwb3J0IHRob3Nl
IEFQSXMNCj4gYW55aG93LCBpZiBpdCBjYW4gYmUgbWFkZSB0cml2aWFsbHkgb2J2aW91cyB0byB1
c2UgdGhpcyBmYWxsYmFjayBldmVuDQo+IHRob3VnaCAvZGV2L2lvbW11IGlzIGF2YWlsYWJsZSBp
dCBpcyBhIGdyZWF0IHBsYWNlIHRvIHN0YXJ0LiBJdCBhbHNvDQo+IG1lYW5zIFBBU0lEL2V0YyBh
cmUgbmF0dXJhbGx5IGJsb2NrZWQgb2ZmLg0KPiANCj4gTWF5YmUgeWVhcnMgZG93biB0aGUgcm9h
ZCB3ZSB3aWxsIHdhbnQgdG8gaGFybW9uaXplIHRoZW0sIHNvIEkgd291bGQNCj4gc3RpbGwgc2tl
dGNoIGl0IG91dCBlbm91Z2ggdG8gYmUgY29uZmlkZW50IGl0IGNvdWxkIGJlIGltcGxlbWVudGVk
Li4NCj4gDQoNCkZpcnN0IGxldCdzIGFsaWduIG9uIHRoZSBoaWdoIGxldmVsIGdvYWwgb2Ygc3Vw
cG9ydGluZyBtdWx0aS1kZXZpY2VzIGdyb3VwIA0KdmlhIElPTU1VIGZkLiBCYXNlZCBvbiBwcmV2
aW91cyBkaXNjdXNzaW9ucyBJIGZlZWwgaXQncyBmYWlyIHRvIHNheSB0aGF0IA0Kd2Ugd2lsbCBu
b3QgcHJvdmlkZSBuZXcgZmVhdHVyZXMgYmV5b25kIHdoYXQgdmZpbyBncm91cCBkZWxpdmVycyB0
b2RheSwNCndoaWNoIGltcGxpZXM6DQoNCjEpIEFsbCBkZXZpY2VzIHdpdGhpbiB0aGUgZ3JvdXAg
bXVzdCBzaGFyZSB0aGUgc2FtZSBhZGRyZXNzIHNwYWNlLg0KDQogICAgICAgIFRob3VnaCBpdCdz
IHBvc3NpYmxlIHRvIHN1cHBvcnQgbXVsdGlwbGUgYWRkcmVzcyBzcGFjZXMgKGUuZy4gaWYgY2F1
c2VkDQogICAgICAgIGJ5ICFBQ1MpLCB0aGVyZSBhcmUgc29tZSBzY2VuYXJpb3MgKERNQSBhbGlh
c2luZywgUklEIHNoYXJpbmcsIGV0Yy4pDQogICAgICAgIHdoZXJlIGEgc2luZ2xlIGFkZHJlc3Mg
c3BhY2UgaXMgbWFuZGF0b3J5LiBUaGUgZWZmb3J0IHRvIHN1cHBvcnQNCiAgICAgICAgbXVsdGlw
bGUgc3BhY2VzIGlzIG5vdCB3b3J0aHdoaWxlIGR1ZSB0byBpbXByb3ZlZCBpc29sYXRpb24gb3Zl
ciB0aW1lLg0KDQoyKSBJdCdzIG5vdCBuZWNlc3NhcnkgdG8gYmluZCBhbGwgZGV2aWNlcyB3aXRo
aW4gdGhlIGdyb3VwIHRvIHRoZSBJT01NVSBmZC4NCg0KICAgICAgICBPdGhlciBkZXZpY2VzIGNv
dWxkIGJlIGxlZnQgdW51c2VkLCBvciBib3VuZCB0byBhIGtub3duIGRyaXZlciB3aGljaA0KICAg
ICAgICBkb2Vzbid0IGRvIERNQS4gVGhpcyBpbXBsaWVzIGEgZ3JvdXAgdmlhYmlsaXR5IG1lY2hh
bmlzbSBtdXN0IGJlIGluDQogICAgICAgIHBsYWNlIHdoaWNoIGNhbiBpZGVudGlmeSB3aGVuIHRo
ZSBncm91cCBpcyB2aWFibGUgZm9yIG9wZXJhdGlvbiBhbmQgDQogICAgICAgIEJVR19PTigpIHdo
ZW4gdGhlIHZpYWJpbGl0eSBpcyBjaGFuZ2VkIGR1ZSB0byB1c2VyIGFjdGlvbi4NCg0KMykgVXNl
ciBtdXN0IGJlIGRlbmllZCBmcm9tIGFjY2Vzc2luZyBhIGRldmljZSBiZWZvcmUgaXRzIGdyb3Vw
IGlzIGF0dGFjaGVkDQogICAgIHRvIGEga25vd24gc2VjdXJpdHkgY29udGV4dC4NCg0KSWYgYWJv
dmUgZ29hbHMgYXJlIGFncmVlZCwgYmVsb3cgaXMgdGhlIHVwZGF0ZWQgcHJvcG9zYWwgZm9yIHN1
cHBvcnRpbmcNCm11bHRpLWRldmljZXMgZ3JvdXAgdmlhIGRldmljZS1jZW50cmljIEFQSS4gTW9z
dCBpZGVhcyBjb21lIGZyb20gSmFzb24uDQpIZXJlIHRyeSB0byBleHBhbmQgYW5kIGNvbXBvc2Ug
dGhlbSBpbiBhIGZ1bGwgcGljdHVyZS4NCg0KSW4gZ2VuZXJhbDoNCg0KLSAgIHZmaW8ga2VlcHMg
ZXhpc3RpbmcgdUFQSSBzZXF1ZW5jZSwgd2l0aCBzbGlnaHRseSBkaWZmZXJlbnQgc2VtYW50aWNz
Og0KDQogICAgICAgIGEpIFZGSU9fR1JPVVBfU0VUX0NPTlRBSU5FUiwgYXMgdG9kYXkNCg0KICAg
ICAgICBiKSBWRklPX1NFVF9JT01NVSB3aXRoIGEgbmV3IGlvbW11IHR5cGUgKFZGSU9fRVhURVJO
QUxfDQogICAgICAgICAgICAgSU9NTVUpIHdoaWNoLCBvbmNlIHNldCwgdGVsbHMgVkZJTyBub3Qg
dG8gZXN0YWJsaXNoIGl0cyBvd24NCiAgICAgICAgICAgICBzZWN1cml0eSBjb250ZXh0Lg0KDQog
ICAgICAgIGMpICBWRklPX0dST1VQX0dFVF9ERVZJQ0VfRkRfTkVXLCBjYXJyeWluZyBhZGRpdGlv
bmFsIGluZm8NCiAgICAgICAgICAgICBhYm91dCBleHRlcm5hbCBpb21tdSBkcml2ZXIgKGlvbW11
X2ZkLCBkZXZpY2VfY29va2llKS4gVGhpcw0KICAgICAgICAgICAgIGNhbGwgYXV0b21hdGljYWxs
eSBiaW5kcyB0aGUgZGV2aWNlIHRvIGlvbW11X2ZkLiBEZXZpY2UgZmQgaXMNCiAgICAgICAgICAg
ICByZXR1cm5lZCB0byB0aGUgdXNlciBvbmx5IGFmdGVyIHN1Y2Nlc3NmdWwgYmluZGluZyB3aGlj
aCBpbXBsaWVzIA0KICAgICAgICAgICAgIGEgc2VjdXJpdHkgY29udGV4dCAoQkxPQ0tfRE1BKSBo
YXMgYmVlbiBlc3RhYmxpc2hlZCBmb3IgdGhlIA0KICAgICAgICAgICAgIGVudGlyZSBncm91cC4g
U2luY2UgdGhlIHNlY3VyaXR5IGNvbnRleHQgaXMgbWFuYWdlZCBieSBpb21tdV9mZCwNCiAgICAg
ICAgICAgICBncm91cCB2aWFibGUgY2hlY2sgc2hvdWxkIGJlIGRvbmUgaW4gdGhlIGlvbW11IGxh
eWVyIHRodXMgDQogICAgICAgICAgICAgdmZpb19ncm91cF92aWFibGUoKSBtZWNoYW5pc20gaXMg
cmVkdW5kYW50IGluIHRoaXMgY2FzZS4NCg0KLSAgIFdoZW4gcmVjZWl2aW5nIHRoZSBiaW5kaW5n
IGNhbGwgZm9yIHRoZSAxc3QgZGV2aWNlIGluIGEgZ3JvdXAsIGlvbW11X2ZkIA0KICAgIGNhbGxz
IGlvbW11X2dyb3VwX3NldF9ibG9ja19kbWEoZ3JvdXAsIGRldi0+ZHJpdmVyKSB3aGljaCBkb2Vz
IA0KICAgIHNldmVyYWwgdGhpbmdzOg0KDQogICAgICAgIGEpIENoZWNrIGdyb3VwIHZpYWJpbGl0
eS4gQSBncm91cCBpcyB2aWFibGUgb25seSB3aGVuIGFsbCBkZXZpY2VzIGluDQogICAgICAgICAg
ICB0aGUgZ3JvdXAgYXJlIGluIG9uZSBvZiBiZWxvdyBzdGF0ZXM6DQoNCiAgICAgICAgICAgICAg
ICAqIGRyaXZlci1sZXNzDQogICAgICAgICAgICAgICAgKiBib3VuZCB0byBhIGRyaXZlciB3aGlj
aCBpcyBzYW1lIGFzIGRldi0+ZHJpdmVyICh2ZmlvIGluIHRoaXMgY2FzZSkNCiAgICAgICAgICAg
ICAgICAqIGJvdW5kIHRvIGFuIG90aGVyd2lzZSBhbGxvd2VkIGRyaXZlciAoc2FtZSBsaXN0IGFz
IGluIHZmaW8pDQoNCiAgICAgICAgYikgU2V0IGJsb2NrX2RtYSBmbGFnIGZvciB0aGUgZ3JvdXAg
YW5kIGNvbmZpZ3VyZSB0aGUgSU9NTVUgdG8gYmxvY2sNCiAgICAgICAgICAgIERNQSBmb3IgYWxs
IGRldmljZXMgaW4gdGhpcyBncm91cC4gVGhpcyBjb3VsZCBiZSBkb25lIGJ5IGF0dGFjaGluZyB0
bw0KICAgICAgICAgICAgYSBkZWRpY2F0ZWQgaW9tbXUgZG9tYWluIChJT01NVV9ET01BSU5fQkxP
Q0tFRCkgd2hpY2ggaGFzDQogICAgICAgICAgICBhbiBlbXB0eSBwYWdlIHRhYmxlLg0KDQogICAg
ICAgIGMpIFRoZSBpb21tdSBsYXllciBhbHNvIHZlcmlmaWVzIGdyb3VwIHZpYWJpbGl0eSBvbiBC
VVNfTk9USUZZXw0KICAgICAgICAgICAgQk9VTkRfRFJJVkVSIGV2ZW50LiBCVUdfT04gaWYgdmlh
YmlsaXR5IGlzIGJyb2tlbiB3aGlsZSBibG9ja19kbWENCiAgICAgICAgICAgIGlzIHNldC4NCg0K
LSAgIEJpbmRpbmcgb3RoZXIgZGV2aWNlcyBpbiB0aGUgZ3JvdXAgdG8gaW9tbXVfZmQganVzdCBz
dWNjZWVkcyBzaW5jZSANCiAgICB0aGUgZ3JvdXAgaXMgYWxyZWFkeSBpbiBibG9ja19kbWEuDQoN
Ci0gICBXaGVuIGEgZ3JvdXAgaXMgaW4gYmxvY2tfZG1hIHN0YXRlLCBhbGwgZGV2aWNlcyBpbiB0
aGUgZ3JvdXAgKGV2ZW4gbm90DQogICAgYm91bmQgdG8gaW9tbXVfZmQpIHN3aXRjaCB0b2dldGhl
ciBiZXR3ZWVuIGJsb2NrZWQgZG9tYWluIGFuZCANCiAgICBJT0FTSUQgZG9tYWluLCBpbml0aWF0
ZWQgYnkgYXR0YWNoaW5nIHRvIG9yIGRldGFjaGluZyBmcm9tIGFuIElPQVNJRC4NCg0KICAgICAg
ICBhKSBpb21tdV9mZCB2ZXJpZmllcyB0aGF0IGFsbCBib3VuZCBkZXZpY2VzIGluIHRoZSBzYW1l
IGdyb3VwIG11c3QgYmUNCiAgICAgICAgICAgIGF0dGFjaGVkIHRvIGEgc2luZ2xlIElPQVNJRC4N
Cg0KICAgICAgICBiKSB0aGUgMXN0IGRldmljZSBhdHRhY2ggaW4gdGhlIGdyb3VwIGNhbGxzIGlv
bW11IEFQSSB0byBtb3ZlIHRoZSANCiAgICAgICAgICAgICBlbnRpcmUgZ3JvdXAgdG8gdXNlIHRo
ZSBuZXcgSU9BU0lEIGRvbWFpbi4NCg0KICAgICAgICBjKSB0aGUgbGFzdCBkZXZpY2UgZGV0YWNo
IGNhbGxzIGlvbW11IEFQSSB0byBtb3ZlIHRoZSBlbnRpcmUgZ3JvdXAgDQogICAgICAgICAgICBi
YWNrIHRvIHRoZSBibG9ja2VkIGRvbWFpbi4gDQoNCi0gICBBIGRldmljZSBpcyBhbGxvd2VkIHRv
IGJlIHVuYm91bmQgZnJvbSBpb21tdV9mZCB3aGVuIG90aGVyIGRldmljZXMNCiAgICBpbiB0aGUg
Z3JvdXAgYXJlIHN0aWxsIGJvdW5kLiBJbiB0aGlzIGNhc2UgdGhlIGdyb3VwIGlzIHN0aWxsIGlu
IGJsb2NrX2RtYQ0KICAgIHN0YXRlIHRodXMgdGhlIHVuYm91bmQgZGV2aWNlIHNob3VsZCBub3Qg
YmUgYm91bmQgdG8gYW5vdGhlciBkcml2ZXINCiAgICB3aGljaCBjb3VsZCBicmVhayB0aGUgZ3Jv
dXAgdmlhYmlsaXR5Lg0KDQogICAgICAgICBhKSBmb3IgdmZpbyB0aGlzIHVuYm91bmQgaXMgYXV0
b21hdGljYWxseSBkb25lIHdoZW4gZGV2aWNlIGZkIGlzIGNsb3NlZC4NCg0KLSAgIFdoZW4gdmZp
byByZXF1ZXN0cyB0byB1bmJpbmQgdGhlIGxhc3QgZGV2aWNlIGluIHRoZSBncm91cCwgaW9tbXVf
ZmQNCiAgICBjYWxscyBpb21tdV9ncm91cF91bnNldF9ibG9ja19kbWEoZ3JvdXApIHRvIG1vdmUg
dGhlIGdyb3VwIG91dA0KICAgIG9mIHRoZSBibG9ja19kbWEgc3RhdGUuIERldmljZXMgaW4gdGhl
IGdyb3VwIGFyZSByZS1hdHRhY2hlZCB0byB0aGUgDQogICAgZGVmYXVsdCBkb21haW4gZnJvbSBu
b3cgb24uDQoNCldpdGggdGhpcyBkZXNpZ24gYWxsIHRoZSBoZWxwZXIgZnVuY3Rpb25zIGFuZCB1
QVBJIGFyZSBrZXB0IGRldmljZS1jZW50cmljDQppbiBpb21tdV9mZC4gSXQgbWFpbnRhaW5zIG1p
bmltYWwgZ3JvdXAga25vd2xlZGdlIGludGVybmFsbHkgYnkgdHJhY2tpbmcgDQpkZXZpY2UgYmlu
ZGluZy9hdHRhY2hpbmcgc3RhdHVzIHdpdGhpbiBlYWNoIGdyb3VwIGFuZCB0aGVuIGNhbGxpbmcg
cHJvcGVyDQppb21tdSBBUEkgdXBvbiBjaGFuZ2VkIGdyb3VwIHN0YXR1cy4NCg0KVkZJTyBzdGls
bCBrZWVwcyBpdHMgY29udGFpbmVyL2dyb3VwL2RldmljZSBzZW1hbnRpY3MgZm9yIGJhY2t3YXJk
DQpjb21wYXRpYmlsaXR5Lg0KDQpBIG5ldyBzdWJzeXN0ZW0gY2FuIGNvbXBsZXRlbHkgZWxpbWlu
YXRlIGdyb3VwIHNlbWFudGljcyBhcyBsb25nIGFzDQppdCBjb3VsZCBmaW5kIGEgd2F5IHRvIGZp
bmlzaCBkZXZpY2UgYmluZGluZyBiZWZvcmUgZ3JhbnRpbmcgdXNlciB0bw0KYWNjZXNzIHRoZSBk
ZXZpY2UuIA0KDQpUaGFua3MNCktldmluDQo=
