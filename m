Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406FA43D8EB
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 03:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhJ1Bwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 21:52:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:26204 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhJ1Bwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 21:52:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="230252740"
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="230252740"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 18:50:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="597601921"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 27 Oct 2021 18:50:18 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 18:50:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 18:50:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 27 Oct 2021 18:50:17 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 27 Oct 2021 18:50:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lU/E0bIzGQMQINmi0nk42Rr+ET/xfGo0yp2c4iB2iBcceaivQPMFx/qgMTaq2TgxufwRLs0vBSi/sHxlfeDSt5ep6BAx02yn5/6uXDHcs/gDjjoOw9xSacuRgwWNbEvYNCE2FuvYT6f43AVvKWV/ZQ7ytkPSArLHvCaNc4es7gdiO3ufVv8DVh9TwFBuGdf1p8/ohiz+kVX3ejt5tDlqc4oI0TTydUQbdJIypbprS8R6qK/1L6XRCk53BhO0fdj2eGa3iJT716/anmM/HZsIPMMYQ+91MjEZFpWck0iGBhDM1Wm1dlpZSa/g1hnDQesTfmkcMv2GchKpXqOB5eDE1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Xb6N1V3XpJezre9cLrTlwUKTRO6B/aNxTOpxu4Bof8=;
 b=gQWhILjJFy4Qm1nwOD/zbNlTJlXNTLoZnKIy6oCiaF4nTQPznRidgm//hBGMRxQiOPapkhQ+8w6t3tcFSFl9OIld+BfG8622C30+pUpL1gxZfxd5b7nqzXr5fctU3Ro3FecYEFBQWW6FsCppeFK/qs+UcU5KPGQgFWpfAK+kqOpBL6HvoUITk2nW0lSOOmdS4WcLHsEnOn8vdeBoZKMxKGgLke8mi1qstuX3ZX7nOzUBNTBKw5qtcs1puyt0h5kh0aB3LKEMO/XcYY0zIyfl1ogk2ZCcI6JvlKeDHItrSfHxi9XWHzvsTqVNq+OthNn6gmLtMtfJDZJe4hMEjaB3dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Xb6N1V3XpJezre9cLrTlwUKTRO6B/aNxTOpxu4Bof8=;
 b=Gp1fFSta3HDVJQEItKOAZGE6vev6NsvYhy6FsFi2iTtDrtPNX/eqbQyww54bL7YfbFSTvj5+aOoT7bd5omMuNLqjBFEKWRCorccvBPCs5iJMRqPBgRSl/ZpVFqgQtevZ9MFtnXwzmm/dhPap3OXkMjdUu/vwambkp4O1UrVCqdU=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5417.namprd11.prod.outlook.com (2603:10b6:408:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 01:50:16 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81%7]) with mapi id 15.20.4649.014; Thu, 28 Oct 2021
 01:50:16 +0000
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
Thread-Index: AddSzQ97/vJYfIW8Gke3qF5WyXyLcQBL2ymAAKTbxpAAKSt7gAAHpf9wAB1YcAAAAm5sgAAA1YgAAADonIAAAEmcgAABzCaAAAHbfwAAAYTsAAAEeLUAAAiRJwAAFF14gAAPozMAAABMSwAAA0bJgAAVeTBAAAlp0QAABjX0AAAAf0IAAABWuQAAAD8IgAAAOC4AAABA0oAAAn0sgAAbQLqAAHzsuQAAHTjUgAALKb+AAAEAJgAACpEpAAAAd4EAAB0JvoAAAK4MgAAFtYKAAAV6DAAAAHyTAAABOkSAG2x1K8AACkXWAAAf+/xw
Date:   Thu, 28 Oct 2021 01:50:15 +0000
Message-ID: <BN9PR11MB5433E055932A5C41463ED5E38C869@BN9PR11MB5433.namprd11.prod.outlook.com>
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
 <BN9PR11MB5433B2E25895D240BA3B182B8C859@BN9PR11MB5433.namprd11.prod.outlook.com>
 <861c6a1f-a68d-85fc-e6d2-1cd90f32f86a@redhat.com>
In-Reply-To: <861c6a1f-a68d-85fc-e6d2-1cd90f32f86a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 139e7912-3e58-4b3d-fe41-08d999b54a26
x-ms-traffictypediagnostic: BN9PR11MB5417:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB541748DBCBCB621904DA1FAD8C869@BN9PR11MB5417.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CNNNZRpeInYyvIdGj24ingtwfSBIPOJEZWNefMYDTwFcPTBK+8CxqlxfLG8Eqn5cgc0eGFZDrdg6cfiOP+QGVvv1IQQwKfmuhQwB13mjBEtESLSP0SS7K1RpcK+ZlcOnGVKw9vFEYj3N69swtNOU2eXXbl1oEWxqL0GVuwuK2V/bAHTWWuSEUqteuyi+mmCn/7lPOqTgy0BdX6j0Ooi/1lgQ7n4XWBNuL/fdIo/SvxvQSJuJLNxbjLkKgfxP/TeNZmELv6ufUJgjRPN37u+RpHZcbgENTDBkBMlsssC098EAO8/mXCNYIFyzZLSfHjfiieWyAhpUE7jj0rkxMffV3eCim5uEjx30BU/3hHpbgywOYKb0LXZvEbbPtU5UOEob57tvY3RShsd+JAp/GLMJwc0wUqeaYxwlUJM2tcVeT5SXDLdgQlU5+6yd/23dW5VTw2qKceQh7GCDfZI3zPhFclBfQ84bfwCyyeSVygjnohnRglqiDzDhEDFzCJizH9/1YV2V+FzF9sCb6+6bvSh/2cbXCpP9KfD3MORppLadoqxQrcPef3GKwrtBje1hHsSmwrSkKPyWc7strBXst2FaZVtwRkwEtozTQP+Y77pwHU6/bFdhPqOF1vnUUvbap6M+4FjmlT1tSypIf1HM4LE5s+bAs15HJEOWEfF6+lBwhuIgjJTlsYY6RHazxutlAVOa1dNkCwaGPKv+fzv03kJ8sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(83380400001)(7696005)(71200400001)(2906002)(86362001)(6506007)(53546011)(7416002)(26005)(82960400001)(186003)(66476007)(66946007)(55016002)(66556008)(8936002)(122000001)(66446008)(316002)(4326008)(64756008)(38070700005)(76116006)(9686003)(110136005)(52536014)(508600001)(8676002)(54906003)(38100700002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDJvSy9TUnV3bStQaWR4K2FVT2tBL3BTUlkyeEpLcmV1anhzQ2J3QjlYUXRM?=
 =?utf-8?B?Y0k3ZUs4OGNKamYzdTVPaUl3K0c4cmlIUjRGemxJZFRMY0RUVTVTV1FCTEl2?=
 =?utf-8?B?Q3NrK1VYNlRZWXMxWE1tb2hsanJMWHN3RHJVbkJIQXJiZTBRc0RnSUFRNkh3?=
 =?utf-8?B?NEY4ZHhsSHBtUkFPaEd2T1BobzJ6SkZhQUwwaEVOQ3BJZjd1NW1PSm9xSmU1?=
 =?utf-8?B?M0RYKzRJeHdSdkEvNUhBdTV1YUhQb1dHTzRUMHZ2UjFWa2pJVzVEMzErYUxL?=
 =?utf-8?B?cENNTGNmM1B4VHNENEp0ckN3R2t2QVRoek5jV1h2Q29hWEtiTUdtbmgzeGlJ?=
 =?utf-8?B?Nnc5TWp5TUlzZkNpZVNudnNTUTh1aHQzdEh2UzlnMzdhSlg1YkpOdmVVY2ZK?=
 =?utf-8?B?YmpMcVNqL0ZxYW9KcTFXcW5kd1hKaXd2N3d0U0duVFpITFBBQ0VRSUxCOE1N?=
 =?utf-8?B?WklpdmN5SnF1M1FONU9PTVpzTUxKMzQxb2VuZ0RZRG5QM2w4WVA4YytNNDNu?=
 =?utf-8?B?dlByNG5wNmk5VzJxUHJJaGVKWGd2dSs1M1BnVTlGMUdRRTV1dW5SVE9Ja1F0?=
 =?utf-8?B?R3ZqM3ZabWkyd2Y2WUl0M3NqQ1Zma1g1TlBuNlFoM3p0a2JiNTY2RlZReUlZ?=
 =?utf-8?B?S3NRcTdEYkJ5SC9Xc2tselBGN0pLT3F1U3poRjBMb0o0S3FvQ0VGTW9YVnlx?=
 =?utf-8?B?RE8rNHlGN2pCbDc2YlYvWHptL1BSeTg2bEYwaXlER2lGV1FzeTcxS1NJMW4z?=
 =?utf-8?B?TVBlZ2gzUlJlMGNRWGNUd0R5MHJTeTJ4clVpWTcxZmxaNGsvbHhhVzJySWhM?=
 =?utf-8?B?dHBiS2ZHbmxad1JuTnlCU2FWdGhXdy9jSzk1b1pNVkRwQ1Z2MzZFVmo1K0U0?=
 =?utf-8?B?MlRQbE1IRHlUdHVVZGg2MUE5Q2g5Q3dVYWNaZC9iV0NGa213QWl4eHRVMjFr?=
 =?utf-8?B?RC9VblptQzdsZW9CeTVFQi95Z3daSFpjemRTcHhzZ3JQQWpNY05EaHJna3pM?=
 =?utf-8?B?dllsWVpOWjcvM1BSQTlzVWJYZkxDOGNJM2Nha1RVSzZzQ1ZYMUp3VzZOQTRY?=
 =?utf-8?B?TmhJTXMrTkJuOXFVdGthMC8vVTFVeWtibXVmQlNxd0tRRXIzZ2c4UFhSZ3BF?=
 =?utf-8?B?djNIK1hCVC9Fd2RWeDhXa2tsNmJqMWZhd1p1TSs4Q0V0Tno4WTZTY3RsR0ds?=
 =?utf-8?B?OHZWNm1pZTVseSsrY3crNlpjT0phLytDMkRBY0M1a2Fmc2Z5a1JxQnVwTnZr?=
 =?utf-8?B?c1VEeVpaNEFDY3ZVL0h2bDJxSnFCc05KTFRaL21EYTJwUlVUMk5YcTJseGR1?=
 =?utf-8?B?RmNkSkZya3phMk0rMGFUWUFYVzIvM2RGMjlrNzNMUW5HQWtTTDBCQUdkRytk?=
 =?utf-8?B?RlhROXpKQUF5UktZRmJSQngxbXZRbVF0dXdISlkzWktJbDRwVXdjTWVONDBI?=
 =?utf-8?B?U1Z0QXlVM0Q0dUVncm0rMzJxWUhhTTBJem8yQVBuQ2ZRM3ppSUpDT0JhaWhq?=
 =?utf-8?B?dEVCejVsTWcrZ3RUMTQ1OC83V0pCQk5neUZNNDVubW04dVlYZ2x2OFk0WHdI?=
 =?utf-8?B?T2VMSkF4Q1VrblFDY29Fdy9zRCtKWUdBcE8raFZGUW9RWmlLUnBReFN5cWpw?=
 =?utf-8?B?NG91TXZvK25PMTJSRXBucDNQZC9qSEYyUGV6ZmZPQ3VtR3J6bXk4blV3dGZr?=
 =?utf-8?B?T1liNkxEYlJJWVFSRkZva3d5MFUya3A0WVV1TUxSU0NGK3VqNlZYT3dkZXdj?=
 =?utf-8?B?UGZwOG5KcEFLWG9JOWNEOGlUUWhsV0dZZml1dXF3cDRmRm95MlQ5cFVVN2tW?=
 =?utf-8?B?WFY3OEVjN3ZSdUFyNG1sZjRod1RDS201NXF0YkhzNzFNUG04QmwyU1hLdEd4?=
 =?utf-8?B?aGR0R3VtbWM5SWNMUWQ2aDRiaDdlTFFBOWlwcnRTTUdXckwwWnJKOTg2bStr?=
 =?utf-8?B?dG8relQ5QitWYTZRMGEwcDVUVHR2TmJudDdPdVk5bmlmOTZqMHNqd1pBWXFn?=
 =?utf-8?B?SXE1MFhLS2VRMXNyUHozVlNPc2djUkF0cnZPKzRtS2s3YWlpTFNuZUhxeThE?=
 =?utf-8?B?UmZsclpLc2psa0xpeUE2RXZQbmZjMXBuQ2FpL0RTQm52TnlXbkx6cGNsaVY2?=
 =?utf-8?B?ajNOQkhYYTlwRTRiRkREcDJEVFFyTmlJZW02dndwTmVzeVVJU2twSUhVOWxH?=
 =?utf-8?Q?GDWGLqsbG1GgsFv5AWQX9Cc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 139e7912-3e58-4b3d-fe41-08d999b54a26
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 01:50:16.0153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J+YdJpbKJ0etvltdpg0pIWDcaBqf4DMSL0c3EBnsy43BXgBqBVIRXBNgLXOe+9o69ion1O3alqPFedNQIxCu/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5417
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIE9jdG9iZXIgMjcsIDIwMjEgNjozMiBQTQ0KPiANCj4gT24gMjcvMTAvMjEgMDg6MTgs
IFRpYW4sIEtldmluIHdyb3RlOg0KPiA+PiBJIGFic29sdXRlbHkgZG8gKm5vdCogd2FudCBhbiBB
UEkgdGhhdCB0ZWxscyBLVk0gdG8gZW5hYmxlIFdCSU5WRC4gIFRoaXMNCj4gPj4gaXMgbm90IHVw
IGZvciBkaXNjdXNzaW9uLg0KPiA+Pg0KPiA+PiBCdXQgcmVhbGx5LCBsZXQncyBzdG9wIGNhbGxp
bmcgdGhlIGZpbGUgZGVzY3JpcHRvciBhIHNlY3VyaXR5IHByb29mIG9yIGENCj4gPj4gY2FwYWJp
bGl0eS4gIEl0J3Mgb3ZlcmtpbGw7IGFsbCB0aGF0IHdlIGFyZSBkb2luZyBoZXJlIGlzIGtlcm5l
bA0KPiA+PiBhY2NlbGVyYXRpb24gb2YgdGhlIFdCSU5WRCBpb2N0bC4NCj4gPj4NCj4gPj4gQXMg
YSB0aG91Z2h0IGV4cGVyaW1lbnQsIGxldCdzIGNvbnNpZGVyIHdoYXQgd291bGQgaGFwcGVuIGlm
IHdiaW52ZA0KPiA+PiBjYXVzZWQgYW4gdW5jb25kaXRpb25hbCBleGl0IGZyb20gZ3Vlc3QgdG8g
dXNlcnNwYWNlLiAgVXNlcnNwYWNlIHdvdWxkDQo+ID4+IHJlYWN0IGJ5IGludm9raW5nIHRoZSBp
b2N0bCBvbiB0aGUgaW9hc2lkLiAgVGhlIHByb3Bvc2VkIGZ1bmN0aW9uYWxpdHkNCj4gPj4gaXMg
anVzdCBhbiBhY2NlbGVyYXRpb24gb2YgdGhpcyBzYW1lIHRoaW5nLCBhdm9pZGluZyB0aGUNCj4g
Pj4gZ3Vlc3QtPktWTS0+dXNlcnNwYWNlLT5JT0FTSUQtPndiaW52ZCB0cmlwLg0KPiA+DQo+ID4g
V2hpbGUgdGhlIGNvbmNlcHQgaGVyZSBtYWtlcyBzZW5zZSwgaW4gcmVhbGl0eSBpbXBsZW1lbnRp
bmcgYSB3YmludmQNCj4gPiBpb2N0bCBmb3IgdXNlcnNwYWNlIHJlcXVpcmluZyBpb21tdWZkIChw
cmV2aW91cyAvZGV2L2lvYXNpZCBpcyByZW5hbWVkDQo+ID4gdG8gL2Rldi9pb21tdSBub3cpIHRv
IHRyYWNrIGRpcnR5IENQVXMgdGhhdCBhIGdpdmVuIHByb2Nlc3MgaGFzIGJlZW4NCj4gPiBydW5u
aW5nIHNpbmNlIHdiaW52ZCBvbmx5IGZsdXNoZXMgbG9jYWwgY2FjaGUuDQo+ID4NCj4gPiBJcyBp
dCBvayB0byBvbWl0IHRoZSBhY3R1YWwgd2JpbnZkIGlvY3RsIGhlcmUgYW5kIGp1c3QgbGV2ZXJh
Z2UgdmZpby1rdm0NCj4gPiBjb250cmFjdCB0byBtYW5hZ2Ugd2hldGhlciBndWVzdCB3YmludmQg
aXMgZW11bGF0ZWQgYXMgbm8tb3A/DQo+IA0KPiBZZXMsIGl0J2QgYmUgb2theSBmb3IgbWUuICBB
cyBJIHdyb3RlIGluIHRoZSBtZXNzYWdlLCB0aGUgY29uY2VwdCBvZiBhDQo+IHdiaW52ZCBpb2N0
bCBpcyBtb3N0bHkgaW1wb3J0YW50IGFzIGEgdGhvdWdodCBleHBlcmltZW50IGZvciB3aGF0IGlz
DQo+IHNlY3VyaXR5IHNlbnNpdGl2ZSBhbmQgd2hhdCBpcyBub3QuICBJZiBhIHdiaW52ZCBpb2N0
bCB3b3VsZCBub3QgYmUNCj4gcHJpdmlsZWdlZCBvbiB0aGUgaW9tbXVmZCwgdGhlbiBXQklOVkQg
aXMgbm90IGNvbnNpZGVyZWQgcHJpdmlsZWdlZCBpbiBhDQo+IGd1ZXN0IGVpdGhlci4NCj4gDQo+
IFRoYXQgZG9lcyBub3QgaW1wbHkgYSByZXF1aXJlbWVudCB0byBpbXBsZW1lbnQgdGhlIHdiaW52
ZCBpb2N0bCwgdGhvdWdoLg0KPiBPZiBjb3Vyc2UsIG5vbi1LVk0gdXNhZ2Ugb2YgaW9tbXVmZCBz
eXN0ZW1zL2RldmljZXMgd2l0aCBub24tY29oZXJlbnQNCj4gRE1BIHdvdWxkIGJlIGxlc3MgdXNl
ZnVsOyBidXQgdGhhdCdzIGFscmVhZHkgdGhlIGNhc2UgZm9yIFZGSU8uDQoNClRoYW5rcyBmb3Ig
Y29uZmlybWluZyBpdCENCg0KPiANCj4gPiBidHcgZG9lcyBrdm0gY29tbXVuaXR5IHNldCBhIHN0
cmljdCBjcml0ZXJpYSB0aGF0IGFueSBvcGVyYXRpb24gdGhhdA0KPiA+IHRoZSBndWVzdCBjYW4g
ZG8gbXVzdCBiZSBmaXJzdCBjYXJyaWVkIGluIGhvc3QgdUFQSSBmaXJzdD8gSW4gY29uY2VwdA0K
PiA+IEtWTSBkZWFscyB3aXRoIElTQS1sZXZlbCB0byBjb3ZlciBib3RoIGd1ZXN0IGtlcm5lbCBh
bmQgZ3Vlc3QgdXNlcg0KPiA+IHdoaWxlIGhvc3QgdUFQSSBpcyBvbmx5IGZvciBob3N0IHVzZXIu
IEludHJvZHVjaW5nIG5ldyB1QVBJcyB0byBhbGxvdw0KPiA+IGhvc3QgdXNlciBkb2luZyB3aGF0
ZXZlciBndWVzdCBrZXJuZWwgY2FuIGRvIHNvdW5kcyBpZGVhbCwgYnV0IG5vdA0KPiA+IGV4YWN0
bHkgbmVjZXNzYXJ5IGltaG8uDQo+IA0KPiBJIGFncmVlOyBob3dldmVyLCBpdCdzIHRoZSByaWdo
dCBtaW5kc2V0IGluIG15IG9waW5pb24gYmVjYXVzZQ0KPiB2aXJ0dWFsaXphdGlvbiAoaW4gYSBw
ZXJmZWN0IHdvcmxkKSBzaG91bGQgbm90IGJlIGEgd2F5IHRvIGdpdmUNCj4gcHJvY2Vzc2VzIHBy
aXZpbGVnZSB0byBkbyBzb21ldGhpbmcgdGhhdCB0aGV5IGNhbm5vdCBkby4gIElmIGl0IGRvZXMs
DQo+IGl0J3MgdXN1YWxseSBhIGdvb2QgaWRlYSB0byBhc2sgeW91cnNlbGYgInNob3VsZCB0aGlz
IGZ1bmN0aW9uYWxpdHkgYmUNCj4gYWNjZXNzaWJsZSBvdXRzaWRlIEtWTSB0b28/Ii4NCj4gDQoN
CkFncmVlLiBJdCdzIGFsd2F5cyBnb29kIHRvIGtlZXAgc3VjaCBtaW5kc2V0IGluIHRob3VnaHQg
cHJhY3RpY2UuDQoNClRoYW5rcw0KS2V2aW4NCg==
