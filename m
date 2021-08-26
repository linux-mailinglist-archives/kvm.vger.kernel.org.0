Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9B73F81C1
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 06:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhHZEcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 00:32:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:1789 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhHZEcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 00:32:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="217384491"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="217384491"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 21:31:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="598348658"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 25 Aug 2021 21:31:14 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 21:31:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 21:31:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 21:31:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gx5sKygnKuARPcQ5fFfAQP1FzxVo5TSfEajkKvNnIhdh43NP1EduYxeYsZErnRO73j2RTgeN0XMktgUKbdIrLax52ZLxA/rL6k2d+We7i1uWN3JUpwbr8SKxETy2Ih1ns0iscBvyiY+Es+Ui/55AUTyrnfMJbHv61a90OCNeBwzw1MzxuX5tRyFVtQ6mfpus5gNrvm8b5uEutoazOvkTiXLAIHOh4WQbJ22+veHBqBBIaRen2svv86rRt0E+2+ys7Za/LH07Vtv2puATNkUNMp4OUlABf2/4CQFdPVi73nFL9ONKYG4OtcXaOhkNbmDif8/IfzjhnlDkRJXMdqakWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RauJNvzvYzcuL5FAkjCL76OIMDDUi+uTRhPitm3qT80=;
 b=iCjN2yqdzjuiRrCSaShByNW9Ur8qZe8l8bMUC180UNfaUnT08jCC0JWhMm//JIBkftkLE0JCrfW6tVzlQ4ixWnhraw4dPRMUGCvQa+16y8fzdg7ucSEQDfnybUQFdd+Z6V9mYkipa/zSqZx3kt2SbFjaBDm/tWZKNhJ055ZWPamiVFnnsMY6eFAg6vz4RL2xYPsHGhIwLB8cDUeJu1HXN6GWKk6gk+GeOL568Cio5g1woDaOnKymAr3PctotDrLh6ljRp3PADd/eTO3L6da1bQmAZ2xyRtuFYfqNH537ifzw38nCP7WLcNr/N3V6rz1jMt9NpQY/9pvICYIjkkbrrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RauJNvzvYzcuL5FAkjCL76OIMDDUi+uTRhPitm3qT80=;
 b=EfV0eTPXy5zlpjgCsNjBo7dyaR1Lz78nmaj22FqAwss8mLBfrxapkCpgIM1eIBa8/GWpH+2Sezyjvx2AxZwWvdttR7zC8VuLWqCR0QD2pgeDCbCjd0Vu3jf2gbRSaIfovXPvt+ldoyvlGTFUq3w7dstHiUUQIaW7B5qMyJEy2WM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3601.namprd11.prod.outlook.com (2603:10b6:408:84::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 04:31:12 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 04:31:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 13/14] vfio/iommu_type1: remove the "external" domain
Thread-Topic: [PATCH 13/14] vfio/iommu_type1: remove the "external" domain
Thread-Index: AQHXmdAf0WcDiq+3TkG8rqAuzUgwqquFJ+bQ
Date:   Thu, 26 Aug 2021 04:31:12 +0000
Message-ID: <BN9PR11MB5433B087F39CB9320255C8048CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-14-hch@lst.de>
In-Reply-To: <20210825161916.50393-14-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d5109d6-6c6b-4ab1-ef9b-08d9684a5596
x-ms-traffictypediagnostic: BN8PR11MB3601:
x-microsoft-antispam-prvs: <BN8PR11MB36010AF1EA1B18C70BFAA8E28CC79@BN8PR11MB3601.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vqfLfZTjodcMXL6zZXh3Hy9pQJb4jW1wOfDdUieLZ/OAy7XQ//xi6GRyXhV1ELokz4ti380vMpEkC6NpECQfdTAC3wZLg/4xCjexkAubgVsnqWmqk68XBdmGZUMv6frbhDnDlOIen8k0k2ZQD/R+y3tzaEmWIJmTTUnuYy1RIhC/iiMlxh+n9jv3UxGZW+AfjasA0juo0x2ctFka2j2JHFXs0NVEFB9mQH3F2UKNk7KjRY172wTh+lcp5ZWeDjgVy2/hHpr6pOSPNdR5W9HefJn4QKaV/mcB5w4p81lsaBNkNaLBhH/9MnXvZe1NEph2TH7jyLRiTNRqx33jNM0iNMnOCi1kwLnuzayOMdZTe66Y9b8SmAuzjonyo+itjRnr36DpJKRlxIAX3cMsr8GiuKhRVTMYyjVmlevxID4uz7wwE8x0bgugKIYEUrXdld6IsWwR3G8bZEbM0fEqfUXOG3mzdHsE8TaQGKj+fdTVYkaT2dHvfJumjIeOHFdvO7VN/6SndXU4wi8MzFDJdeCVufQGALdqSsaujvIZx7z/b5UI9azzw+7BSebiCeAxBHjvOgiDZTWNw3zJVmKpI668/aDdVu12YSFLKfYw9ZoOUFMYbJ7W3WlV+8HK4g/cTavilgmsvX8Py+yPEGMQHIhqIYn7iLinwff8jYkbRJ7/zor4/BNcMqD98oIDjmg4SF3UtpxkOwSMTTNI3ZLjjRRpiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(4326008)(2906002)(33656002)(38100700002)(83380400001)(186003)(38070700005)(26005)(54906003)(316002)(6506007)(9686003)(7696005)(86362001)(71200400001)(478600001)(52536014)(110136005)(55016002)(122000001)(8676002)(8936002)(5660300002)(66946007)(66446008)(64756008)(66556008)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWxMQ09LRzhPSGMvbXdqTWtNQ0NKTllNb3hZMXh6M045MTlkcVVwdDJQQ2wy?=
 =?utf-8?B?djUvQXM2UjZyaUJEd1NxK3Rsald1bDZpQVUvVlV5ZU1WZW9BeEJackZmZHFr?=
 =?utf-8?B?YW0vaXc4a0dsalYvbER3S1JXbEUyaVAwL3kzeHpTOXNSVm5KWHdqd3BrR0h6?=
 =?utf-8?B?ZXl2dWlwYUFOb3AyZ1RnVGJ4Z1VHd2RFQXJab0lZTHZpVElCUWd0ckpWSEkw?=
 =?utf-8?B?UzRyR0szankrNzU5cmo4UzV0Vy90SFIvdnlKdm55cHF6S2ZBNWRZMkVXVVFw?=
 =?utf-8?B?b3ZLemgybEVjZHBjM2YyREJnNzZMUDI2c2JKVW1pS3hlZWJHcFRxMGVIREhh?=
 =?utf-8?B?TEFuNjJsSXNqeWtCeTBkTU4rT1dCaXROdWh0bDR0eE51WUtWcnkveEdlU2Iz?=
 =?utf-8?B?NEZjNUJHc2RZODIxQ3BIWG4yNGRlaDAxbVVmQnducFNTL3RSNm5KSXJnWUZS?=
 =?utf-8?B?TllFOUlGSmxybXk1b1ZiRG5ZUXpzK0lmWUVlQjFNcENnMC9STkEwL0t5ZVpl?=
 =?utf-8?B?RldsNXJFWVhnbmh5dUhUVWhYdC9ucWJZSjZwdmtlRDhSbENlbzdMbjFRNmFL?=
 =?utf-8?B?QU10RlB2bEpGSmtuSjF6NUp5eCs5cFlHQjFKOU9EK3Yyc2FZS0lubFVnaDdi?=
 =?utf-8?B?RnBUZFoxSkxvV2VtTE5oZUJ4TkNuVkVoalJrVWYyVllzQTdiVUp0bi9JdERN?=
 =?utf-8?B?TWxtbVhycG4xMERvZGxSSXJWSlE4aGFsVGh4V3RzaWhQRGEyektRQ1VsRXRy?=
 =?utf-8?B?cjNjYnI3UlZHNVh4QzZTQkUrcEpndW1OYzkxZXRJTXowWW81S1BBMlNPOVRN?=
 =?utf-8?B?UkR5d0FURHc1Z01ldnN1VVRZRG5Ka3VCamhJWGNobEFrT1o5eWxPcSsxOGdS?=
 =?utf-8?B?K1BuV05ORWdBS3h4VUJ1RVJLWVZiUFpnRmRRQVZTdEw5QUxYb1pXTW9Zek9I?=
 =?utf-8?B?aDRNa1QwR2VPV3c4SXRpRTB5TSswYzAxcjRDLytpc3BnZmY2ajExRG01TTRR?=
 =?utf-8?B?Mml6T04vTVZQOEtjSXJPTWo5VUY4ZzRpa3JQNGc3TENVdlB0YzVyWE9Wcmk1?=
 =?utf-8?B?OGg2dVZtVm44bFBoT3NLMy9FaC8vK0NHaDZEZ1QzUXRGUHozVDNiT2Y0UDNQ?=
 =?utf-8?B?TklKUWIxcmFzU2NDVVlMWGcxc0luSFlxY0dhbVpxOXZMcWJpS2EyNll2V1NE?=
 =?utf-8?B?akFSdGUyTmdhMWtINXhNRHIxa2E4V0hKTGNxdnZHZ21PbnNKc2dadFJWbXR4?=
 =?utf-8?B?U3ZyU3hnRE4vRGx5UnlWZE5hZmxNNTg4eGtVejk5MDRpRlM2dUZSUDBMMjZT?=
 =?utf-8?B?ZDlQeFp1ZTZNTDNsUnkvVmlVczdZYWZSLzJncUdHVDBLWW53R1RDWGJyOEFl?=
 =?utf-8?B?NDBENHQvNjJIQnRSQlBLenVTRTl5UHU4bnZ5a2pJdVZsTGp3aUtOMEFqMUYz?=
 =?utf-8?B?Ti85amljMEozUGhkRk1ZZlNZNjhyRzBHdGMxYlpIY04vQ1BZa0VsNWwvbHJn?=
 =?utf-8?B?S3E0YVVpVk0wTEZJMG51ajFhU2FYbTh6ZVdLUFlEMVBiN3hQaWt3ZEV0aGRM?=
 =?utf-8?B?Wk53VGt6d2liY0tRS2VRcWd2S0MvUmwyMnErd1ZHalYvU3drRzNkZW91Q1lU?=
 =?utf-8?B?WE9FUWdBdXl2OGZRVTFWY1ZSd0N3TGNBUDR0b2FsdlJlb0dhYjVQaHNBVHh2?=
 =?utf-8?B?eGhBckRreC9GazBScDRYZGtXQmRLaEFleFVrL1F5THZKQlJISHZKVUNFczF4?=
 =?utf-8?Q?ssN0z+VCvVH43BDvW5Q5nyxm/J8/Cb46FwXMH7T?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d5109d6-6c6b-4ab1-ef9b-08d9684a5596
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 04:31:12.1513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CIunZOz5xDxBNKVgFbY+yaxWJ/CAus2RVR6dGzzKWa/iI9SlOGVJiGk1zwIJinjVQwiQehqQmScjiM9OM9J6LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3601
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gU2VudDogVGh1cnNkYXks
IEF1Z3VzdCAyNiwgMjAyMSAxMjoxOSBBTQ0KPiANClsuLi5dDQo+IEBAIC0yMTYzLDQ1ICsyMTY0
LDI3IEBAIHN0YXRpYyBpbnQgdmZpb19pb21tdV90eXBlMV9hdHRhY2hfZ3JvdXAodm9pZA0KPiAq
aW9tbXVfZGF0YSwNCj4gIAlzdHJ1Y3QgdmZpb19pb21tdV9ncm91cCAqZ3JvdXA7DQo+ICAJc3Ry
dWN0IHZmaW9fZG9tYWluICpkb21haW4sICpkOw0KPiAgCXN0cnVjdCBidXNfdHlwZSAqYnVzID0g
TlVMTDsNCj4gLQlpbnQgcmV0Ow0KPiAgCWJvb2wgcmVzdl9tc2ksIG1zaV9yZW1hcDsNCj4gIAlw
aHlzX2FkZHJfdCByZXN2X21zaV9iYXNlID0gMDsNCj4gIAlzdHJ1Y3QgaW9tbXVfZG9tYWluX2dl
b21ldHJ5ICpnZW87DQo+ICAJTElTVF9IRUFEKGlvdmFfY29weSk7DQo+ICAJTElTVF9IRUFEKGdy
b3VwX3Jlc3ZfcmVnaW9ucyk7DQo+ICsJaW50IHJldCA9IC1FSU5WQUw7DQo+IA0KPiAgCW11dGV4
X2xvY2soJmlvbW11LT5sb2NrKTsNCj4gDQo+ICAJLyogQ2hlY2sgZm9yIGR1cGxpY2F0ZXMgKi8N
Cj4gLQlpZiAodmZpb19pb21tdV9maW5kX2lvbW11X2dyb3VwKGlvbW11LCBpb21tdV9ncm91cCkp
IHsNCj4gLQkJbXV0ZXhfdW5sb2NrKCZpb21tdS0+bG9jayk7DQo+IC0JCXJldHVybiAtRUlOVkFM
Ow0KPiAtCX0NCj4gKwlpZiAodmZpb19pb21tdV9maW5kX2lvbW11X2dyb3VwKGlvbW11LCBpb21t
dV9ncm91cCkpDQo+ICsJCWdvdG8gb3V0X3VubG9jazsNCj4gDQo+ICsJcmV0ID0gLUVOT01FTTsN
Cj4gIAlncm91cCA9IGt6YWxsb2Moc2l6ZW9mKCpncm91cCksIEdGUF9LRVJORUwpOw0KPiAtCWRv
bWFpbiA9IGt6YWxsb2Moc2l6ZW9mKCpkb21haW4pLCBHRlBfS0VSTkVMKTsNCj4gLQlpZiAoIWdy
b3VwIHx8ICFkb21haW4pIHsNCj4gLQkJcmV0ID0gLUVOT01FTTsNCj4gLQkJZ290byBvdXRfZnJl
ZTsNCj4gLQl9DQo+IC0NCj4gKwlpZiAoIWdyb3VwKQ0KPiArCQlnb3RvIG91dF91bmxvY2s7DQo+
ICAJZ3JvdXAtPmlvbW11X2dyb3VwID0gaW9tbXVfZ3JvdXA7DQo+IA0KPiAtCS8qIERldGVybWlu
ZSBidXNfdHlwZSBpbiBvcmRlciB0byBhbGxvY2F0ZSBhIGRvbWFpbiAqLw0KPiAtCXJldCA9IGlv
bW11X2dyb3VwX2Zvcl9lYWNoX2Rldihpb21tdV9ncm91cCwgJmJ1cywNCj4gdmZpb19idXNfdHlw
ZSk7DQo+IC0JaWYgKHJldCkNCj4gLQkJZ290byBvdXRfZnJlZTsNCj4gLQ0KPiAgCWlmIChmbGFn
cyAmIFZGSU9fRU1VTEFURURfSU9NTVUpIHsNCj4gLQkJaWYgKCFpb21tdS0+ZXh0ZXJuYWxfZG9t
YWluKSB7DQo+IC0JCQlJTklUX0xJU1RfSEVBRCgmZG9tYWluLT5ncm91cF9saXN0KTsNCj4gLQkJ
CWlvbW11LT5leHRlcm5hbF9kb21haW4gPSBkb21haW47DQo+IC0JCQl2ZmlvX3VwZGF0ZV9wZ3Np
emVfYml0bWFwKGlvbW11KTsNCj4gLQkJfSBlbHNlIHsNCj4gLQkJCWtmcmVlKGRvbWFpbik7DQo+
IC0JCX0NCj4gLQ0KPiAtCQlsaXN0X2FkZCgmZ3JvdXAtPm5leHQsICZpb21tdS0+ZXh0ZXJuYWxf
ZG9tYWluLQ0KPiA+Z3JvdXBfbGlzdCk7DQo+ICsJCWxpc3RfYWRkKCZncm91cC0+bmV4dCwgJmlv
bW11LT5lbXVsYXRlZF9pb21tdV9ncm91cHMpOw0KPiAgCQkvKg0KPiAgCQkgKiBOb24taW9tbXUg
YmFja2VkIGdyb3VwIGNhbm5vdCBkaXJ0eSBtZW1vcnkgZGlyZWN0bHksIGl0DQo+IGNhbg0KDQp1
bmlmeSB0aGUgbmFtaW5nIGUuZy4gImdyb3VwIHdpdGggZW11bGF0ZWQgaW9tbXUgY2Fubm90IGRp
cnR5IC4uLiINCg0KPiAgCQkgKiBvbmx5IHVzZSBpbnRlcmZhY2VzIHRoYXQgcHJvdmlkZSBkaXJ0
eSB0cmFja2luZy4NCj4gQEAgLTIyMDksMTYgKzIxOTIsMjQgQEAgc3RhdGljIGludCB2ZmlvX2lv
bW11X3R5cGUxX2F0dGFjaF9ncm91cCh2b2lkDQo+ICppb21tdV9kYXRhLA0KPiAgCQkgKiBkaXJ0
eSB0cmFja2luZyBncm91cC4NCj4gIAkJICovDQo+ICAJCWdyb3VwLT5waW5uZWRfcGFnZV9kaXJ0
eV9zY29wZSA9IHRydWU7DQo+IC0JCW11dGV4X3VubG9jaygmaW9tbXUtPmxvY2spOw0KPiAtDQo+
IC0JCXJldHVybiAwOw0KPiArCQlyZXQgPSAwOw0KPiArCQlnb3RvIG91dF91bmxvY2s7DQo+ICAJ
fQ0KPiANCj4gKwkvKiBEZXRlcm1pbmUgYnVzX3R5cGUgaW4gb3JkZXIgdG8gYWxsb2NhdGUgYSBk
b21haW4gKi8NCj4gKwlyZXQgPSBpb21tdV9ncm91cF9mb3JfZWFjaF9kZXYoaW9tbXVfZ3JvdXAs
ICZidXMsDQo+IHZmaW9fYnVzX3R5cGUpOw0KPiArCWlmIChyZXQpDQo+ICsJCWdvdG8gb3V0X2Zy
ZWVfZ3JvdXA7DQo+ICsNCj4gKwlyZXQgPSAtRU5PTUVNOw0KPiArCWRvbWFpbiA9IGt6YWxsb2Mo
c2l6ZW9mKCpkb21haW4pLCBHRlBfS0VSTkVMKTsNCj4gKwlpZiAoIWRvbWFpbikNCj4gKwkJZ290
byBvdXRfZnJlZV9ncm91cDsNCj4gKw0KPiArCXJldCA9IC1FSU87DQo+ICAJZG9tYWluLT5kb21h
aW4gPSBpb21tdV9kb21haW5fYWxsb2MoYnVzKTsNCj4gLQlpZiAoIWRvbWFpbi0+ZG9tYWluKSB7
DQo+IC0JCXJldCA9IC1FSU87DQo+IC0JCWdvdG8gb3V0X2ZyZWU7DQo+IC0JfQ0KDQotRU5PTUVN
Pw0KDQo+ICsJaWYgKCFkb21haW4tPmRvbWFpbikNCj4gKwkJZ290byBvdXRfZnJlZV9kb21haW47
DQo+IA0KPiAgCWlmIChpb21tdS0+bmVzdGluZykgew0KPiAgCQlyZXQgPSBpb21tdV9lbmFibGVf
bmVzdGluZyhkb21haW4tPmRvbWFpbik7DQoNCmxvb2tzIHlvdXIgY2hhbmdlIG9mIGVycm5vIGhh
bmRsaW5nIGlzIGluY29tcGxldGUuIHRoZXJlIGFyZSBzZXZlcmFsIG90aGVyDQpwbGFjZXMgZG93
biB0aGlzIGZ1bmN0aW9uIHdoaWNoIHNldCB0aGUgZXJybm8gcmlnaHQgYmVmb3JlIGdvdG8uIGJl
dHRlciB0byANCmhhdmUgYSBjb25zaXN0ZW50IHN0eWxlIGluIG9uZSBmdW5jdGlvbi4g8J+Yig0K
DQpUaGFua3MNCktldmluDQo=
