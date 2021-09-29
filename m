Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A215F41C14B
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 11:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244993AbhI2JHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 05:07:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:49956 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244800AbhI2JHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 05:07:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224552114"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="224552114"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 02:05:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="707191996"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 29 Sep 2021 02:05:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 29 Sep 2021 02:05:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 29 Sep 2021 02:05:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 29 Sep 2021 02:05:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfTvrgMMee8mGv8rZ0VtTp9FbJuDOLlX6+rotyAaKscgTwZSGI5gkeW06ncS4Nf4MJT4S2/aFJakSXyn91NKuS3kxiBmzrXZ6gw9h2nwU+2j0Cl5uqYS5zbgOPPPig6Mfm7rPmGabrmL5icvAMi7ZVMT9x7Mx0RzR1UDjzMbVLQG+eal7xqYdb29K3b/3kegNMd4/RiM0TmZ59KvJdFTlddD8QnGJ8S9kVwasuZVgJgPWVEuyjsh3E7gsVtIWcIiFKPuFBOc0sejTiQVGH76cnQqxEFgatJQRSu5G0hHuoDnqO+3bHg6Xd0QBLY7mt8+2EU+wU7ediZ9RKKQvzjTlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=C4CqakT9oowe1htYtN8YnRLBmfqNH3bb+X686bytfBc=;
 b=oOLtSVJfpNKLZ67sPpivTaU3LePW95vh9mrxVV6i4/eVXefzZQhUYO6tRpw6Lp/yeobwwHuQh9aBfyyU2LaP4aGXxsWjJbjHgRldvOStU2yFMMmIi/oucL+Ztj/K7Vfmsi/E0Zkre5M9DLAZAx13XMDA0nKj9H7ZpGMM1WfVyHPauOFyPkpfs9e72JFQ7h6Twy7OHt0FtRMDa2cGEuNPsjpTX3sSfosF4BvFbszU9hqKX9MYUX5WUH2lPpZ3W/EdTCL5I6K2Ak6Z62C91np7hZ79ByGVl6Wj/7BTV/hX4WWF+J698kYxd77X0/Vmv0qvqfSl48ERKgZOMUqOdshpdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4CqakT9oowe1htYtN8YnRLBmfqNH3bb+X686bytfBc=;
 b=MUl/J555lfDVTHuyLcudoRGux5Hs3TUfvrt5ldCniD+nCfVvYWd0U81GEwB3gU7DKxIRaljQCyIzH4Cy+2bbHltMbWZKf/pFw6wQT4HzKTwUtXnSh+q3QeVrm8yhxZG8Y26Xzf3pRlpa5L5ycsvq95O8bejbfILYJy7Y35URGBM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5417.namprd11.prod.outlook.com (2603:10b6:408:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 09:05:54 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 09:05:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Topic: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Index: AQHXqhc5lUNcPisp4UyTMpTu0c9BsKu6db8wgABPxQCAAAa9IA==
Date:   Wed, 29 Sep 2021 09:05:54 +0000
Message-ID: <BN9PR11MB54338A0821C061FEE018F43E8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB5433DDA5FD4FC6C5EED62C278CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <2e0c062947b044179603ab45989808ff@huawei.com>
In-Reply-To: <2e0c062947b044179603ab45989808ff@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf1777d7-6160-4aa2-66db-08d9832857dc
x-ms-traffictypediagnostic: BN9PR11MB5417:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB5417FD51AF558E667E9DE9DD8CA99@BN9PR11MB5417.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lm5HTaLNMmUe+hUXnZ3Ki9SMqdZhc5l787+l5OSQuKq8gWYX3U9tcZgUZ6LeweaUh4UosWyuF8DFfrGIpzOl1m6Y/l9hVoacx3MGn1+k5QSO4XeOldUKq5Xa8h537OmKEep1HJ+ns5nQgqvJzE+2s3SZ3ky0sWj3N1uXicN/SGT5lFgBUNtwAIp+uiqIfunBBa8asz/KDLYkCxpWlWy5bGRxFzgJbEF8YFb1w6Jv30Wr70czjVpz2Nab3K3dF0fHKQIrSXvYD8wS3ovx9+VjMyg+YRGNyiW48MGI8VlqiuVZOOpGLN9XDiQjr6g6MfkVzgmCwcLQvOPcQNTxZR9uFqyTZH07dEXH6d3xDWHnGR5NnzxWMYWOtCfZOpsm+PcDfCOdEcHMY46OL4qFRhZfclOEof8PnyTpwNNt2mERycBn0CRI6r6dHPMnvnGwO/4sNe/mpp1cyOWZIWeY/g8ZbpQru/u6pG/l7BfZTWX8esgzaiI/pxE2hlM/MhVQxxsfATrNktnEjEDggGVBKv3xvmEwukBaLCa73CuXdjsVVISLP7dWghwfqQ24t0tQM7u1RtFwVhP6PJkOqAp1Q6ock6rKEUISNN9jCfz7hNvjpGxfEIiuXHU8TA4MUcNsAXVEObmOKurxstrGYhT7vcLzuylS8M1W9JfI1ac4tuib9yXMlOK3y0MFXFGe4+IDcO4ExUrJ7tFZbgBk1pBxHM6a+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(8936002)(8676002)(64756008)(7416002)(186003)(52536014)(122000001)(38070700005)(71200400001)(38100700002)(86362001)(66446008)(66556008)(66946007)(33656002)(76116006)(66476007)(83380400001)(55016002)(6506007)(110136005)(26005)(7696005)(54906003)(2906002)(316002)(107886003)(508600001)(9686003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2NiS3ZjOGtGbTlYVDJ4T01MYXdCMDdZSC83VU1udDB0ZU55UFRyNCsybWNt?=
 =?utf-8?B?WlNwdnFLS3FzUEhaNXF0R2VwQU5Fd2M2YlRyZlVhSk1WQmRUWENMRUQrdmpT?=
 =?utf-8?B?T245MGFZMXUxUWRGR0JEYXZJbEtQeDVqNGdFblhSVmk2aUFBdms3UDA5TC9s?=
 =?utf-8?B?Q1ZjbnU5TmtZak9vamFjUDMrUFF4V2RhQkNZdW1yN0pZZFhVOVFObUJhY2d2?=
 =?utf-8?B?R0RDdVAwek9EWE9FNkJKSFBDdzNkajVVSXRKdXBZT2svSkZ2aWFVTlVmVUZp?=
 =?utf-8?B?KzNMTTlmRnc1V2ovVjJ6bnpXK3lFMVBBNlkwZE5MbXM0THNmVm5ndDh0MXZY?=
 =?utf-8?B?M1lkWGpHYjFWT2c3cHVRYzloRWdMRWtpSDBhQmRiamZBUWl6K2RaRm9kdUFS?=
 =?utf-8?B?L203MlVzWGNQRTJuZEg4T21GYVc1czBreE5tbjI1clh6WXlCMjZub3E1aDVD?=
 =?utf-8?B?U3lvWXB6MjJMNWhxSmVzeTMvck1PU3lBYW9jdzVUWWE5M2J5MEFHY1BYQnR2?=
 =?utf-8?B?Q3lyMmMxZTB1TEN2dnhGeUQyR2dveUJSV1YwRnE4UmxYaHJvVE42T3Z6Mko3?=
 =?utf-8?B?dy90aVU0bThPazI3aG5BNWRHbHJJSDl6TDNBSVY2QkxZYU5mSTB1ZTkwZlhx?=
 =?utf-8?B?U2ZqQmliaExiMG9BOEF3TGdsdVVNYnhSbWVqTmRFWVJZK01tTHUwdDlHRTRL?=
 =?utf-8?B?N1pSaFpqRjg3d3J1UC9Ha09yZVNxV1l5d1dIZzh5WUFGZ0lIZmF1UGg4Vmxt?=
 =?utf-8?B?SHI5WEgyam5tcEdLMHp0YWpJcFhwemYramxpSzd2OFV5eUgzZUFpN2JNNG5D?=
 =?utf-8?B?cGtXclZUaVhtWW41ZXZZMTJ2T09SWmdMdTlmYmdiZXowVVd1TkRYK3k1V0Zp?=
 =?utf-8?B?eGxtVjFta2pUakNMdkV1dUV1Zk90c05DeDlNM0NPZ29Ga1d6WElobFNzK3JT?=
 =?utf-8?B?QWtHNm00anlmbkNBNmNrOUw0VGgycjhjVG5IQm5TUnJnc1BlYnJoQ3AzU3Ni?=
 =?utf-8?B?TzdzbzZiM09JY2xsWDFKM3pNbjU4cHpWT1FQaFMya3pocDdFTDFaUWprRjZK?=
 =?utf-8?B?U2JueUt3VitORDRZMHFpWlMzYnlRWVhWUHpRQk1HTEZXZWxWcjJ1Z2pIOUpV?=
 =?utf-8?B?RXNTT0NMeFlibGxWei9haytGblJVejVaeElmUWhab1U3Qno3RDgxcll0b1hC?=
 =?utf-8?B?TWF1ZDZFWlpMZjFNMWErVEVNd00yZWVaMlZKVjV5NkltQnJldmIzK3RjUCtw?=
 =?utf-8?B?Q1YrRXVQRko2QXBrRVdQR2ZLbGpoQUxLUlZYWCtGZ1hJQ3F0VVQyelIxWmNE?=
 =?utf-8?B?UytlVmxYNENwdTJ4VzEySWlUNGptckx2K0NUcHRCdkJaeGxrcEhLZGZSUERW?=
 =?utf-8?B?dHFIVXR4aWZHd1RvTTRDM0VOQ3VzcDJRSmhJSmpnNUt2NHhKT3hhd1NaT1J5?=
 =?utf-8?B?eEtqbVNwV0NQVmdkMXVPRVJUNldjK2FwdWV2NjNuUUxTMTZvWmRGdkZlQlJY?=
 =?utf-8?B?V3FtemxaZHp0ZUtiUHNPelc0NzJDYituck1nTTJScXhiMHg1T21VWEZnWDRI?=
 =?utf-8?B?RmlMR2ZKYnBUM0VaWEF3azc5TitFWXhqV2d4dHlVUHJQS3RUOFBoa0ZPazF4?=
 =?utf-8?B?WmRoYkY0Q1JzR1ViR1N4Tmg0dzVjRFRwSzhRSXBXeWswMHhmSC96V05WQzRO?=
 =?utf-8?B?M2hzT0ZHTUZjbGw0UXI4UE80ZWlTaFg3VWthOVVvWjJaMzcyZTFhVlVkNEN5?=
 =?utf-8?Q?xBLlsCxe/Kv+sd5ZN6JzQGPGZX1tvoPWPCIx9dq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf1777d7-6160-4aa2-66db-08d9832857dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 09:05:54.4742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jAC3T2jkEp6ktWqxLhx7r+DvGkDL22md3L/1llG1+2Q7JbGhOTluzS3NHaJMav8PThyGrou7bPDWKoruX7OBlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5417
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpDQo+IDxzaGFtZWVyYWxpLmtvbG90aHVt
LnRob2RpQGh1YXdlaS5jb20+DQo+IA0KPiBIaSBLZXZpbiwNCj4gDQo+ID4gRnJvbTogVGlhbiwg
S2V2aW4gW21haWx0bzprZXZpbi50aWFuQGludGVsLmNvbV0NCj4gPiBTZW50OiAyOSBTZXB0ZW1i
ZXIgMjAyMSAwNDo1OA0KPiA+DQo+ID4gSGksIFNoYW1lZXIsDQo+ID4NCj4gPiA+IEZyb206IFNo
YW1lZXIgS29sb3RodW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4g
PiA+IFNlbnQ6IFdlZG5lc2RheSwgU2VwdGVtYmVyIDE1LCAyMDIxIDU6NTEgUE0NCj4gPiA+DQo+
ID4gPiBIaSwNCj4gPiA+DQo+ID4gPiBUaGFua3MgdG8gdGhlIGludHJvZHVjdGlvbiBvZiB2Zmlv
X3BjaV9jb3JlIHN1YnN5c3RlbSBmcmFtZXdvcmtbMF0sDQo+ID4gPiBub3cgaXQgaXMgcG9zc2li
bGUgdG8gcHJvdmlkZSB2ZW5kb3Igc3BlY2lmaWMgZnVuY3Rpb25hbGl0eSB0bw0KPiA+ID4gdmZp
byBwY2kgZGV2aWNlcy4gVGhpcyBzZXJpZXMgYXR0ZW1wdHMgdG8gYWRkIHZmaW8gbGl2ZSBtaWdy
YXRpb24NCj4gPiA+IHN1cHBvcnQgZm9yIEhpU2lsaWNvbiBBQ0MgVkYgZGV2aWNlcyBiYXNlZCBv
biB0aGUgbmV3IGZyYW1ld29yay4NCj4gPiA+DQo+ID4gPiBIaVNpbGljb24gQUNDIFZGIGRldmlj
ZSBNTUlPIHNwYWNlIGluY2x1ZGVzIGJvdGggdGhlIGZ1bmN0aW9uYWwNCj4gPiA+IHJlZ2lzdGVy
IHNwYWNlIGFuZCBtaWdyYXRpb24gY29udHJvbCByZWdpc3RlciBzcGFjZS4gQXMgZGlzY3Vzc2Vk
DQo+ID4gPiBpbiBSRkN2MVsxXSwgdGhpcyBtYXkgY3JlYXRlIHNlY3VyaXR5IGlzc3VlcyBhcyB0
aGVzZSByZWdpb25zIGdldA0KPiA+ID4gc2hhcmVkIGJldHdlZW4gdGhlIEd1ZXN0IGRyaXZlciBh
bmQgdGhlIG1pZ3JhdGlvbiBkcml2ZXIuDQo+ID4gPiBCYXNlZCBvbiB0aGUgZmVlZGJhY2ssIHdl
IHRyaWVkIHRvIGFkZHJlc3MgdGhvc2UgY29uY2VybnMgaW4NCj4gPiA+IHRoaXMgdmVyc2lvbi4N
Cj4gPg0KPiA+IFRoaXMgc2VyaWVzIGRvZXNuJ3QgbWVudGlvbiBhbnl0aGluZyByZWxhdGVkIHRv
IGRpcnR5IHBhZ2UgdHJhY2tpbmcuDQo+ID4gQXJlIHlvdSByZWx5IG9uIEtlcWlhbidzIHNlcmll
cyBmb3IgdXRpbGl6aW5nIGhhcmR3YXJlIGlvbW11IGRpcnR5DQo+ID4gYml0IChlLmcuIFNNTVUg
SFRUVSk/DQo+IA0KPiBZZXMsIHRoaXMgZG9lc24ndCBoYXZlIGRpcnR5IHBhZ2UgdHJhY2tpbmcg
YW5kIHRoZSBwbGFuIGlzIHRvIG1ha2UgdXNlIG9mDQo+IEtlcWlhbidzIFNNTVUgSFRUVSB3b3Jr
IHRvIGltcHJvdmUgcGVyZm9ybWFuY2UuIFdlIGhhdmUgZG9uZSBiYXNpYw0KPiBzYW5pdHkgdGVz
dGluZyB3aXRoIHRob3NlIHBhdGNoZXMuDQo+IA0KDQpEbyB5b3UgcGxhbiB0byBzdXBwb3J0IG1p
Z3JhdGlvbiB3L28gSFRUVSBhcyB0aGUgZmFsbGJhY2sgb3B0aW9uPyANCkdlbmVyYWxseSBvbmUg
d291bGQgZXhwZWN0IHRoZSBiYXNpYyBmdW5jdGlvbmFsaXR5IHJlYWR5IGJlZm9yZSB0YWxraW5n
DQphYm91dCBvcHRpbWl6YXRpb24uDQoNCklmIG5vdCwgaG93IGRvZXMgdXNlcnNwYWNlIGtub3cg
dGhhdCBtaWdyYXRpb24gb2YgYSBnaXZlbiBkZXZpY2UgY2FuIA0KYmUgYWxsb3dlZCBvbmx5IHdo
ZW4gdGhlIGlvbW11IHN1cHBvcnRzIGhhcmR3YXJlIGRpcnR5IGJpdD8NCg0KVGhhbmtzDQpLZXZp
bg0K
