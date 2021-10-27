Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CB843C2CF
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 08:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbhJ0GVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 02:21:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:49605 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236251AbhJ0GVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 02:21:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="316288806"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="316288806"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 23:18:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="447413126"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 26 Oct 2021 23:18:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 26 Oct 2021 23:18:58 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 26 Oct 2021 23:18:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 26 Oct 2021 23:18:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 26 Oct 2021 23:18:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzRO1YwF5hA97GPdhAdj52JnlcN+oN76CIfEtLwpfTVU6vUl9UlyFE/DLDmmuAyC4zRCHzGDSy7bfpyxGrRKNK9ykxAYXQvFJUrsWWGLNFEehhARGZr0hP7xPmt+a1gPiey25Slov7EyoYlxflfOXRimaVPn7drsp/bJCquc4q01vVmyClAYRdrYnGv+dI+JyEw/UsI5K2/+95wkJRsDsHerQW7tuU2BDazL8CkLpqY1QG+1HEi/xmwvuCIBMiC/c0WwiBogbxeA3e12IsSg6d1K6+ckRBk9EcAKt11uuy+dUIKDANm/nqe8fmHi9Azpv/TGxG5kYxRnEJuzjMw1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZvJSwuVqeBmoqCB0y+AdMYZIhgVLpFIZE44E2ihZOBk=;
 b=kTREqFSfQtD39U1mFmXj690VmdUuivP66UaquccacRscQ1QMihU2EpUglxVhb23bvl17I1Cgw+dXR67TLr7CAnSux/9rlIaG03ZeLcrJVj7DvYuugyYLiJBxHNwhcImjVE25Ke7V0/83Sh8Xblby/VJs+3KTZ4E9gf/0L6uYWbo+lNPUdilAQg9jtkqHW2Ior3LPmOTTqtBCPxs0EJ6Vc/9bfDHrNPgzdHa8zs2e71+6fy5J9pOP+M4o0IuN85zQ+/Nmu4R2r4GsZZrtQZTUAgot9YZE+bL0+CSAhICSSTDMx7iXffFynsuMe8PGKtMVp5EMB20WtoOiiBDVQF1trA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvJSwuVqeBmoqCB0y+AdMYZIhgVLpFIZE44E2ihZOBk=;
 b=LeqbEHgksy8CCZWkG4V7Yra608kka/7nG1isB/lFi3dqDO6kxP7tspzhKbAMmwkzG7AOPqPpUqtwSffqU1OxR/dxuQA43b9oUSPkvXMmFkDNJKO1WmD925koNOdzoRRG3S45VF+p/XGcd8wLz+9lV+DAqUZuKjvQ2XczT/rTe10=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1617.namprd11.prod.outlook.com (2603:10b6:405:f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 06:18:55 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81%7]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 06:18:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
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
Thread-Index: AddSzQ97/vJYfIW8Gke3qF5WyXyLcQBL2ymAAKTbxpAAKSt7gAAHpf9wAB1YcAAAAm5sgAAA1YgAAADonIAAAEmcgAABzCaAAAHbfwAAAYTsAAAEeLUAAAiRJwAAFF14gAAPozMAAABMSwAAA0bJgAAVeTBAAAlp0QAABjX0AAAAf0IAAABWuQAAAD8IgAAAOC4AAABA0oAAAn0sgAAbQLqAAHzsuQAAHTjUgAALKb+AAAEAJgAACpEpAAAAd4EAAB0JvoAAAK4MgAAFtYKAAAV6DAAAAHyTAAABOkSAG2x1K8A=
Date:   Wed, 27 Oct 2021 06:18:55 +0000
Message-ID: <BN9PR11MB5433B2E25895D240BA3B182B8C859@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <20210608190022.GM1002214@nvidia.com>
 <ec0b1ef9-ae2f-d6c7-99b7-4699ced146e4@metux.net>
 <671efe89-2430-04fa-5f31-f52589276f01@redhat.com>
 <20210609115445.GX1002214@nvidia.com>
 <20210609083134.396055e3.alex.williamson@redhat.com>
 <20210609144530.GD1002214@nvidia.com>
 <b9df3330-3f27-7421-d5fc-3124c61bacf3@redhat.com>
In-Reply-To: <b9df3330-3f27-7421-d5fc-3124c61bacf3@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a75f544-b581-48e6-c772-08d99911a7d3
x-ms-traffictypediagnostic: BN6PR11MB1617:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB1617ECDCA256193034C7C5808C859@BN6PR11MB1617.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aWAx1TuDVFO94HtMlgyUi+fZrAZdzr3Arj3OGALuudp6+Qjy0L0h1+Wx1p51qSzBkWlOk+ssUliTV2SUvlLmzSNI8Sa3Fwk8ZU2f72oZNtNIL3OmAXEKmgMFenPvOxL31Thps2got5hhlG4d06RwJ/tgynVs9NSk5MNBtGv20lQ9pyu0kCqJniRS4fCsqOV28uhiT9jrnHdy+RjjNWy4D6Kx1P1OBb27ZWkXzLCWsCJb7Kx5AMMJi2014tjwZW7WlDw9QY9Jtr+t1u3Vw9F+An7DWEKL0QoaTCm+9caNZ1KM069eKReG87AObqwZkrgUu7kQtIN++oWS0POq/q3xhxhCpTM74nT6NoMcx7KYfGo/zFSAR7l0oFanLgqN8eVH9nYB3iNDtYzMNV5mq7j6O23oP6e8X+HbGjdp/u8WerAwA8gY/1vLzjhjMKNqUGzba6U05tHfAQhTVAkwIxL1AMW4AlAURTowGYLjS1nAnoes3nBw/Ne0ltPFVyKCwV8ur5UamFCv1gPVl5ki0ATNrrE9IeA8KZRBiYUOXrNVtE8D4pwdaZDf0lmhAZ4yHqBRyiSFNOs4Pxkbfjv5Vfjx2/oxptAsVOmFWwuPyHo3nWGIvxgL5DD14M1SdKVySwG3t5NiJvHDWSTaOYhxPQuvf9bIapmvUQNiiigyoUz/w1WgqLciuU/lmofPpzb+AmrFOCQba1CL7IgS1F0Jxsv1znBMe1I0ddoLyYE/qpWVK5r/It/2lmXH7FHruc2nKILx2Yc2Kir/AhrGWkbjj3w7jVGAojkVjhUUiFP/gtI9NRo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(186003)(7696005)(54906003)(4326008)(110136005)(66946007)(83380400001)(9686003)(38100700002)(66446008)(55016002)(66476007)(66556008)(86362001)(76116006)(2906002)(966005)(71200400001)(64756008)(122000001)(5660300002)(82960400001)(508600001)(53546011)(26005)(33656002)(7416002)(8676002)(6506007)(316002)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTh3dnlBMlU0WkhMWmk1ZVpNb3oxLzFNbXorejJlbXJLWGVTTVVZekp5YVk2?=
 =?utf-8?B?bzdaeGRHZ2VLTUpsNVFRWHBUaStKZjNtV3lqZ1R6RXBKQnZUckwxd2JWM1ov?=
 =?utf-8?B?MExaWjQ5VDZ4c1JMUlZ2blVNWHNZUWRGZTB1VU9XeVlLcFBLUjI4OEtMUC9y?=
 =?utf-8?B?KzlhK0hIbEhxM0dxMTJGamVoSnVpdjVFR1p3YXN1VHVybWpNaUR0QnB3bGFo?=
 =?utf-8?B?NWFIeEdMQkRySHJaeUUvR0hLQm9nK1Zucy9lNm14WFZNeWY5NDVIN0ZTd2FG?=
 =?utf-8?B?Q29vQTQ0UmhwaGlmemtRWElvcXJPSUZ1OWQ1dk84QU1uZGtaT3RJV21BRVd2?=
 =?utf-8?B?cFB0OXN1dEFpak1WOXkrSlUxSnNKMWNTZGZRcDBJU2pZODExUVEydmhmM1B5?=
 =?utf-8?B?T24xY2hta2xmaGtWM2l3ZFNPTTBVelBndjZZeVhFcFVDT3BCcU5HR1o5M1hY?=
 =?utf-8?B?cHRQZjZEOXAyblkybVBWMGRUNlpYeUttcWNTWVRkN3ZtR0lTUTBlaWcvY0Vz?=
 =?utf-8?B?b2J3V1pvdHVpbFBlenFBaXgzSUl2RkFyRk5wbzhGRGNHTko3TUkrT1RGNUsz?=
 =?utf-8?B?Y1MwRGYrQmY1Zzd5MzVxSEE1bnNNdjJ2NEpIU3R3UXhxQnU5M2x5enNtTmxn?=
 =?utf-8?B?ekJVb3g1NHhObTJyWE8xdWRaNW9Cenpwa1FTTlM5cEhxeSt2TldPdjZOQmE3?=
 =?utf-8?B?NGlURkVudUpHZjZ5K3NYcHdQLzVNeGRkUW1vN2JKbXRJNDZwR216QldDdzhT?=
 =?utf-8?B?NzBYMG5zOWZ2cmhmcGlpQkZENks1aUQ2ZHZTZ0FBTzVlZGltVC9GWXg2TnEw?=
 =?utf-8?B?UDRUK1hzQ05Td0lNdHVxSTUyNENZRUJnT3NEeDFUbmtZV28yMjhNSzd6d0Y0?=
 =?utf-8?B?cTZ5bklvV0ZpMmE1RkFTMU50eSs3UUc0S084bWdwaUUwOWg0cWVvMjA2YVdC?=
 =?utf-8?B?b1RkR1VrTEhzL3JPZUlZYkhQTUxBV2pxYlRxZWdRYk02Y1VncUxNOXNPb1g5?=
 =?utf-8?B?dXdGQ0NJR3F0akVZam9LMFI0ZGxBRVlXaXp1UkU1Qk1INm5KSGN3cjF1WlY2?=
 =?utf-8?B?Yk1IcVVnR3paNVF6bEhnWlkwN0JpcEJ5N29xM3hOeTBobDFCVHVJYlZMQlk4?=
 =?utf-8?B?dzRtQlZleGVpSjZLYVdKangrSUIxaDBtZ0hRWG5aaDJ0UUk5Vmp0dWVnYnpp?=
 =?utf-8?B?NC93ZDI1Q3JlRVJoSUlCLzd4SlpLTFZWWVp3RUYzRTBJa3ZtR1FWWXNJaitT?=
 =?utf-8?B?T2RtalZNdW9zKzdaanhnVFgyZHdadk8yQzJkYW1TNUhGUkpLQnZoN2xGNGdQ?=
 =?utf-8?B?MkNrZlRvZU1iUjQ5aXpSWEJpUkpya3o1TUR6b0VPRWZRMjdqS2FiS3FESTYy?=
 =?utf-8?B?cmVBZmVGb3NKYy9EQUttU3ZYdXNGenZSUmQyTFh5NFFsSTZjLytDc3kwU3hB?=
 =?utf-8?B?ZzNMREFqVUVQQkR0VVJwQXZvalFENnNhK01EMmd3cGxlbjFNeTFMZDlqWGUy?=
 =?utf-8?B?RjRXTEZWdGh0Qk5qWDlQVm84Y0wwTmhWR3BVMityRHpTSXoxcXlGMk1sK1A1?=
 =?utf-8?B?ZFRlY0hGTjYvQnJiSCtBVWRjSmtCUkxkTkZvOXR2b1oxbGM0dW1KeGJaY3A2?=
 =?utf-8?B?NGloUU5ZQkgzYmg5aHpUVjlhQkhSVVd0cVpua21RZ1dEem9kWHVyWUIzRUha?=
 =?utf-8?B?emJvWnp4cXlUSnZENXBRbUg1VzFpa2gxOVRtWTZrZjJ4cHp5N3lVYU9TVmwx?=
 =?utf-8?B?bldEVFhmY3VZS1JDcTVHK3M2UjJzM2RIclpnMlE1ckZYYUZkZVFNMW5oRmpv?=
 =?utf-8?B?QzZUV2pFWVFEQVNScW5yTmtNUGl0SnNzb2pxTmFjNDBMTzNIenRCVWpLVDVw?=
 =?utf-8?B?cWJ2MFhpaXI0bnk4am5hOG5sM2s1Z2tXY2tsRFJtcmFEZ1J4R3FEOEVyeGx6?=
 =?utf-8?B?dDhzZmNSclhMMWFXWUh0SVRoZGplRVdSc3ZtaVRDeWtpMDZnaS9LaVZ1dGlz?=
 =?utf-8?B?SVRRZy9rYmUzSS9ycmtFVTlhcWtZYkZLcnhxcDJNcWJGNUNZMzhnNkE3STJE?=
 =?utf-8?B?TnJpQk44bzhFVWtGR0hDWU5HTFYwdXpydEE3M3R1d2t5cldkS2tHemRPa1pZ?=
 =?utf-8?B?R2p5aUNrUkhIUFVheXBLUVlzckVwSTN0cU1aMmQ3UXI3MDJnbkZPTzhtYThF?=
 =?utf-8?Q?hlf4BKptbfmlvbu1WeomeMU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a75f544-b581-48e6-c772-08d99911a7d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 06:18:55.8096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7NtYZ7S33UDesttglSU6wcMTHbLWdi4+TCnBBQde+6R5YEyKhTlaWxPXHjR+nlXL/Xfdgiu4dZuhWjglL0QO+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1617
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksIFBhb2xvLA0KDQo+IEZyb206IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+
DQo+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSA5LCAyMDIxIDExOjIxIFBNDQo+IA0KPiBPbiAwOS8w
Ni8yMSAxNjo0NSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+IE9uIFdlZCwgSnVuIDA5LCAy
MDIxIGF0IDA4OjMxOjM0QU0gLTA2MDAsIEFsZXggV2lsbGlhbXNvbiB3cm90ZToNCj4gPg0KPiA+
PiBJZiB3ZSBnbyBiYWNrIHRvIHRoZSB3YmludmQgaW9jdGwgbWVjaGFuaXNtLCBpZiBJIGNhbGwg
dGhhdCBpb2N0bCB3aXRoDQo+ID4+IGFuIGlvYXNpZGZkIHRoYXQgY29udGFpbnMgbm8gZGV2aWNl
cywgdGhlbiBJIHNob3VsZG4ndCBiZSBhYmxlIHRvDQo+ID4+IGdlbmVyYXRlIGEgd2JpbnZkIG9u
IHRoZSBwcm9jZXNzb3IsIHJpZ2h0PyAgSWYgSSBhZGQgYSBkZXZpY2UsDQo+ID4+IGVzcGVjaWFs
bHkgaW4gYSBjb25maWd1cmF0aW9uIHRoYXQgY2FuIGdlbmVyYXRlIG5vbi1jb2hlcmVudCBETUEs
IG5vdw0KPiA+PiB0aGF0IGlvY3RsIHNob3VsZCB3b3JrLiAgSWYgSSB0aGVuIHJlbW92ZSBhbGwg
ZGV2aWNlcyBmcm9tIHRoYXQgaW9hc2lkLA0KPiA+PiB3aGF0IHRoZW4gaXMgdGhlIGRpZmZlcmVu
Y2UgZnJvbSB0aGUgaW5pdGlhbCBzdGF0ZS4gIFNob3VsZCB0aGUgaW9jdGwNCj4gPj4gbm93IHdv
cmsgYmVjYXVzZSBpdCB3b3JrZWQgb25jZSBpbiB0aGUgcGFzdD8NCj4gPg0KPiA+IFRoZSBpb2N0
bCBpcyBmaW5lLCBidXQgdGVsbGluZyBLVk0gdG8gZW5hYmxlIFdCSU5WRCBpcyB2ZXJ5IHNpbWls
YXIgdG8NCj4gPiBvcGVuIGFuZCB0aGVuIHJlY29uZmlndXJpbmcgdGhlIGlvYXNpZF9mZCBpcyB2
ZXJ5IHNpbWlsYXIgdG8NCj4gPiBjaG1vZC4gRnJvbSBhIHNlY3VyaXR5IHBlcnNwZWN0aXZlIHJl
dm9rZSBpcyBub3Qgc3RyaWN0bHkgcmVxdWlyZWQsDQo+ID4gSU1ITy4NCj4gDQo+IEkgYWJzb2x1
dGVseSBkbyAqbm90KiB3YW50IGFuIEFQSSB0aGF0IHRlbGxzIEtWTSB0byBlbmFibGUgV0JJTlZE
LiAgVGhpcw0KPiBpcyBub3QgdXAgZm9yIGRpc2N1c3Npb24uDQo+IA0KPiBCdXQgcmVhbGx5LCBs
ZXQncyBzdG9wIGNhbGxpbmcgdGhlIGZpbGUgZGVzY3JpcHRvciBhIHNlY3VyaXR5IHByb29mIG9y
IGENCj4gY2FwYWJpbGl0eS4gIEl0J3Mgb3ZlcmtpbGw7IGFsbCB0aGF0IHdlIGFyZSBkb2luZyBo
ZXJlIGlzIGtlcm5lbA0KPiBhY2NlbGVyYXRpb24gb2YgdGhlIFdCSU5WRCBpb2N0bC4NCj4gDQo+
IEFzIGEgdGhvdWdodCBleHBlcmltZW50LCBsZXQncyBjb25zaWRlciB3aGF0IHdvdWxkIGhhcHBl
biBpZiB3YmludmQNCj4gY2F1c2VkIGFuIHVuY29uZGl0aW9uYWwgZXhpdCBmcm9tIGd1ZXN0IHRv
IHVzZXJzcGFjZS4gIFVzZXJzcGFjZSB3b3VsZA0KPiByZWFjdCBieSBpbnZva2luZyB0aGUgaW9j
dGwgb24gdGhlIGlvYXNpZC4gIFRoZSBwcm9wb3NlZCBmdW5jdGlvbmFsaXR5DQo+IGlzIGp1c3Qg
YW4gYWNjZWxlcmF0aW9uIG9mIHRoaXMgc2FtZSB0aGluZywgYXZvaWRpbmcgdGhlDQo+IGd1ZXN0
LT5LVk0tPnVzZXJzcGFjZS0+SU9BU0lELT53YmludmQgdHJpcC4NCg0KV2hpbGUgdGhlIGNvbmNl
cHQgaGVyZSBtYWtlcyBzZW5zZSwgaW4gcmVhbGl0eSBpbXBsZW1lbnRpbmcgYSB3YmludmQNCmlv
Y3RsIGZvciB1c2Vyc3BhY2UgcmVxdWlyaW5nIGlvbW11ZmQgKHByZXZpb3VzIC9kZXYvaW9hc2lk
IGlzIHJlbmFtZWQNCnRvIC9kZXYvaW9tbXUgbm93KSB0byB0cmFjayBkaXJ0eSBDUFVzIHRoYXQg
YSBnaXZlbiBwcm9jZXNzIGhhcyBiZWVuIA0KcnVubmluZyBzaW5jZSB3YmludmQgb25seSBmbHVz
aGVzIGxvY2FsIGNhY2hlLiBLVk0gdHJhY2tzIGRpcnR5IENQVXMgYnkgDQpyZWdpc3RlcmluZyBw
cmVlbXB0IG5vdGlmaWVyIG9uIHRoZSBjdXJyZW50IHZDUFUuIGlvbW11ZmQgbWF5IGRvIHRoZSAN
CnNhbWUgdGhpbmcgZm9yIHRoZSB0aHJlYWQgd2hpY2ggb3BlbnMgL2Rldi9pb21tdSwgYnV0IHBl
ciBiZWxvdw0KZGlzY3Vzc2lvbiBvbmUgb3BlbiBpcyB3aGV0aGVyIGl0J3Mgd29ydGh3aGlsZSBh
ZGRpbmcgc3VjaCBoYXNzbGUgZm9yDQpzb21ldGhpbmcgd2hpY2ggbm8gcmVhbCB1c2VyIGlzIGlu
dGVyZXN0ZWQgaW4gdG9kYXkgZXhjZXB0IGt2bToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGttbC8yMDIxMTAyNTIzMzQ1OS5HTTI3NDQ1NDRAbnZpZGlhLmNvbS8NCg0KSXMgaXQgb2sgdG8g
b21pdCB0aGUgYWN0dWFsIHdiaW52ZCBpb2N0bCBoZXJlIGFuZCBqdXN0IGxldmVyYWdlIHZmaW8t
a3ZtDQpjb250cmFjdCB0byBtYW5hZ2Ugd2hldGhlciBndWVzdCB3YmludmQgaXMgZW11bGF0ZWQg
YXMgbm8tb3A/IEl0IGlzIA0Kc3RpbGwgaW9tbXVmZCB3aGljaCBkZWNpZGVzIHdoZXRoZXIgd2Jp
bnZkIGlzIGFsbG93ZWQgKGJhc2VkIG9uIElPQVMgDQphbmQgZGV2aWNlIGF0dGFjaCBpbmZvcm1h
dGlvbikgYnV0IGp1c3Qgc29ydCBvZiBzcGVjaWFsIGNhc2luZyB0aGF0IHRoZSANCm9wZXJhdGlv
biBjYW4gb25seSBiZSBkb25lIHZpYSBrdm0gcGF0aC4uLg0KDQpidHcgZG9lcyBrdm0gY29tbXVu
aXR5IHNldCBhIHN0cmljdCBjcml0ZXJpYSB0aGF0IGFueSBvcGVyYXRpb24gdGhhdA0KdGhlIGd1
ZXN0IGNhbiBkbyBtdXN0IGJlIGZpcnN0IGNhcnJpZWQgaW4gaG9zdCB1QVBJIGZpcnN0PyBJbiBj
b25jZXB0DQpLVk0gZGVhbHMgd2l0aCBJU0EtbGV2ZWwgdG8gY292ZXIgYm90aCBndWVzdCBrZXJu
ZWwgYW5kIGd1ZXN0IHVzZXINCndoaWxlIGhvc3QgdUFQSSBpcyBvbmx5IGZvciBob3N0IHVzZXIu
IEludHJvZHVjaW5nIG5ldyB1QVBJcyB0byBhbGxvdw0KaG9zdCB1c2VyIGRvaW5nIHdoYXRldmVy
IGd1ZXN0IGtlcm5lbCBjYW4gZG8gc291bmRzIGlkZWFsLCBidXQgbm90DQpleGFjdGx5IG5lY2Vz
c2FyeSBpbWhvLg0KDQo+IA0KPiBUaGlzIGlzIHdoeSB0aGUgQVBJIHRoYXQgSSB3YW50LCBhbmQg
dGhhdCBpcyBhbHJlYWR5IGV4aXN0cyBmb3IgVkZJTw0KPiBncm91cCBmaWxlIGRlc2NyaXB0b3Jz
LCBpbmZvcm1zIEtWTSBvZiB3aGljaCAiaW9jdGxzIiB0aGUgZ3Vlc3Qgc2hvdWxkDQo+IGJlIGFi
bGUgdG8gZG8gdmlhIHByaXZpbGVnZWQgaW5zdHJ1Y3Rpb25zWzFdLiAgVGhlbiB0aGUga2VybmVs
IHdvcmtzIG91dA0KPiB3aXRoIEtWTSBob3cgdG8gZW5zdXJlIGEgMToxIGNvcnJlc3BvbmRlbmNl
IGJldHdlZW4gdGhlIG9wZXJhdGlvbiBvZiB0aGUNCj4gaW9jdGxzIGFuZCB0aGUgcHJpdmlsZWdl
ZCBvcGVyYXRpb25zLg0KPiANCj4gT25lIHdheSB0byBkbyBpdCB3b3VsZCBiZSB0byBhbHdheXMg
dHJhcCBXQklOVkQgYW5kIGludm9rZSB0aGUgc2FtZQ0KPiBrZXJuZWwgZnVuY3Rpb24gdGhhdCBp
bXBsZW1lbnRzIHRoZSBpb2N0bC4gIFRoZSBmdW5jdGlvbiB3b3VsZCBkbyBlaXRoZXINCj4gYSB3
YmludmQgb3Igbm90aGluZywgYmFzZWQgb24gd2hldGhlciB0aGUgaW9hc2lkIGhhcyBhbnkgZGV2
aWNlLiAgVGhlDQo+IG5leHQgbG9naWNhbCBzdGVwIGlzIGEgbm90aWZpY2F0aW9uIG1lY2hhbmlz
bSB0aGF0IGVuYWJsZXMgV0JJTlZEIChieQ0KPiBkaXNhYmxpbmcgdGhlIFdCSU5WRCBpbnRlcmNl
cHQpIHdoZW4gdGhlcmUgYXJlIGRldmljZXMgaW4gdGhlIGlvYXNpZGZkLA0KPiBhbmQgZGlzYWJs
ZXMgV0JJTlZEIChieSBlbmFibGluZyBhIG5vLW9wIGludGVyY2VwdCkgd2hlbiB0aGVyZSBhcmUg
bm9uZS4NCj4gDQo+IEFuZCBpbiBmYWN0IG9uY2UgYWxsIFZGSU8gZGV2aWNlcyBhcmUgZ29uZSwg
d2JpbnZkIGlzIGZvciBhbGwgcHVycG9zZXMgYQ0KPiBuby1vcCBhcyBmYXIgYXMgdGhlIGd1ZXN0
IGtlcm5lbCBjYW4gdGVsbC4gIFNvIHRoZXJlJ3Mgbm8gcmVhc29uIHRvDQo+IHRyZWF0IGl0IGFz
IGFueXRoaW5nIGJ1dCBhIG5vLW9wLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gUGFvbG8NCj4gDQo+
IFsxXSBBcyBhbiBhc2lkZSwgSSBtdXN0IGFkbWl0IEkgZGlkbid0IGVudGlyZWx5IHVuZGVyc3Rh
bmQgdGhlIGRlc2lnbiBvZg0KPiB0aGUgS1ZNLVZGSU8gZGV2aWNlIGJhY2sgd2hlbiBBbGV4IGFk
ZGVkIGl0LiAgQnV0IHdpdGggdGhpcyBtb2RlbCBpdCB3YXMNCj4gYWJzb2x1dGVseSB0aGUgcmln
aHQgdGhpbmcgdG8gZG8sIGFuZCBpdCByZW1haW5zIHRoZSByaWdodCB0aGluZyB0byBkbw0KPiBl
dmVuIGlmIFZGSU8gZ3JvdXBzIGFyZSByZXBsYWNlZCB3aXRoIElPQVNJRCBmaWxlIGRlc2NyaXB0
b3JzLg0KDQo=
