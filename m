Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D993F6D6536
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbjDDOZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235852AbjDDOZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:25:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8503C3B;
        Tue,  4 Apr 2023 07:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680618312; x=1712154312;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=45UKnwUKRlVju5BVlEg8W3a9eO7GtWnWzOhHvopD2Pc=;
  b=UEBgrbic2UBRL37+4FN2pxcgOR6wv9vNQDcyx5dHhmKk9kFCv79qTN5J
   BHjx1qD3NU6JFefTy/TdaLWHYPooeMQ9cneqJzUCE84Zv287/azayh/0c
   rHKE6kq5MGVT4ZZGtyV9yhazx34Oz7OGe+ZqrE75zFMtq6Y+/LS7yEwJ2
   qySSPM4AJH/b7y9cBbIehZ2xJl7w0B57pE+gtf8AebPbOP41/3mSiXp+h
   6qqN5VPb5Oq7IrSbhrsEt6lzyK4IpFOAm5MSLuO4h8OI/vpIDP8E7BCUb
   erJW0X+qwPdkcj+2jn06jYCUHg7paBRX3bzPHVwFPiuXjRK7EwuTHUIwU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="340928977"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="340928977"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 07:24:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="636523816"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="636523816"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 04 Apr 2023 07:24:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 07:24:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 07:24:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 07:24:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 07:24:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfN1I/TSdWALiVuDlIIfOo9+fanPvOqF3odFaq6an3o1j54mBRc5e3DGR0fSPWjqJ8n3JDmjPCQadelxyTJNG33dd5Sm0FOBZxXOAUuCqewh6A0LZ0V/vkqT5/xxHBiXYdcqm4Tfin2ZPIsfermLnWVCOSCHtLW8NRMr8k0vhSER+jXAXevs7fwYGd7bQELcUhrPRiIbO/aQLIZ+ZIij2Ck1lI1CHa5GbZDM/5vCsXwSGH150sr8cFex++ux293+/3X1od8nu1uLMKd3749qt+EyWjUiU8HNVG5JZRbZ/BInIG0ilCsZstN7qEYOhGAN4izk2dn3nn2eubT0ZuspUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45UKnwUKRlVju5BVlEg8W3a9eO7GtWnWzOhHvopD2Pc=;
 b=mfLdsKMTCIZfBQ7mK5QZowRvcEZZ6xHhGyDJbADaSxTcHJLeK5mYppyy6wVjuIEXyhT48ZghqCwyZwsN647uUqqT1wD1Vq+89hEPdZJHv5tQCikkbA5DP99I0FpO8ESttVPHzUR0TkWWmE2BT3P39u+Fe+m0s33Jkkx/tf+/B3N+JfrIHLeIsJ41gkBLI86fBqc4yQexiqJFnWp4u8fYJkewSxtYpNx/SRcgejMPj4bv+gIing1FTGk0EYee+0nd0cvFVBnWxIPdG+iQ1g7WVudIQWEVzDLeKcOumf8MZ/AU6pdrJcTsx3xE5Fx4jGjcNTaWpehMkf8lkVCy1WlvNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB4996.namprd11.prod.outlook.com (2603:10b6:303:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 14:24:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 14:24:44 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 03/12] vfio/pci: Move the existing hot reset logic to
 be a helper
Thread-Topic: [PATCH v3 03/12] vfio/pci: Move the existing hot reset logic to
 be a helper
Thread-Index: AQHZZKh7YHL3l+azMUOnW2bR+I0WXa8bMgqAgAAGg6A=
Date:   Tue, 4 Apr 2023 14:24:44 +0000
Message-ID: <DS0PR11MB75291459BF0860F8AC4E5778C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-4-yi.l.liu@intel.com>
 <4bc269aa-f2b9-d8ac-82bf-2205d05e4b11@redhat.com>
In-Reply-To: <4bc269aa-f2b9-d8ac-82bf-2205d05e4b11@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CO1PR11MB4996:EE_
x-ms-office365-filtering-correlation-id: 759b27bc-6109-44f1-db65-08db35185604
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PhN/w47VJmGGu0gwDumMinybx+dLgags7Xk+YpSxVGCfHXzTQ4LwjvcSPv0cXoWtVAnmUsRN6/1rZ0y6iuXT4P8tIKUxx5PZwvfk7UP5deEGVt2nAtdfGlZ4L3VAJxRHUlLHJPXsPJMRl0pJz8XG+py/djpjnvdFFOhsJnDbtI0H0Ixnfn+NgvNQ09wD6dHE4723S3QBQvfm4vp3OZXpuk90+ES4/Iz5EFugQ2RlBdCLYq+aUjhHfEHN8V+8mvUmipT14trsQwEX6l+a9XeyI7aHmM8nI5weku2zWpYngsQzhL2IZJpL2xtrGATzadDzPbz8o6MFmi5lvGRVh2BM6QKxK/YbuxbISS9mmtbhQBrpxeE1t+p9fU+kIOgC3lXf/1+ra1n0huj0END7KWjE4A1W2O8MggZtIkklA2vmKSPblUCjof+Cwb21t2pRWLo7TS//W4dozUW4Udx5dRjVNsjtUdSMpcY0PKHyBBpW2cNc5BkRpdR7vvP4CTocjsIfNBw/am+dwRAnyIeyXiqDIdaRvvpkvTBDRyzXo5debUyJG5tCfI7d8A3FeKY35iNjC9r87pZT0t3fw5sbFJ44160I1A0yfCYJO1V/sK2YCePP1XCCiMvlDsj6D5yKxDmjkt7GKGuBhTogA/hdN4DmqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(366004)(346002)(396003)(451199021)(38070700005)(54906003)(7696005)(71200400001)(64756008)(66476007)(66556008)(66946007)(110136005)(76116006)(41300700001)(8676002)(66446008)(4326008)(6636002)(478600001)(316002)(86362001)(38100700002)(6506007)(9686003)(53546011)(83380400001)(55016003)(186003)(82960400001)(122000001)(8936002)(2906002)(7416002)(33656002)(5660300002)(26005)(52536014)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXVTVGlnK0F1cW5FNFhoQmpMU1dzNXp5S1ByMm44WjdvT3ExVUMxR1lvUzJv?=
 =?utf-8?B?bDlqallUS0duaEMva3JzZnZabTM4R2JOMmlqQ2J5V2VhQ2hmMmVoT0dvVllj?=
 =?utf-8?B?V2ltTEhUUUZPeE5nOVZOOGFiQ0hWL1pFQkRWZzN2bGFNVzhSck93cUxEdTY0?=
 =?utf-8?B?UW5aR0JUcmZFLzNMUnVHbUhKM0duTjBUSHBGUXcxREdXOVZoNlpkVytHcEpP?=
 =?utf-8?B?Nlc4OVVhaHJNbkRkWEFJamZmZWRLQm1Fcis3RUEwcnBya1NTOUt6OHdOeEJm?=
 =?utf-8?B?ekpNU0JWRjlnMGtOL2ZWaFRiZE5Qdy9xczk2aW1EN290cGkvbm96L0NjemZG?=
 =?utf-8?B?RUVwc3lBei8vcCs0cGJWKzJTKzFhNmhGZHpwSVR1MEZBR2dIbWZ2Q1Y2aStw?=
 =?utf-8?B?dU9EZ2FoNGRaaDd3M0V0dTlsWDhIWjE0N3MvSXllK3ZEcFl2UUl1TWlYM2Mx?=
 =?utf-8?B?aHhMR0h4UldSSHFheGordmJwb2F1VXRwamFUYTNLclUzV3B5N2VIaEJpSzNu?=
 =?utf-8?B?T0NLdENPcUY2bXZMdnZUWEdCdVo1R2VTd0ZRMFdyNG9HWmdBdG1OaTRDdTFP?=
 =?utf-8?B?b1NUR0JpUHYvOEZucnRxbGFYZkZiMnJLeEg0NlJGRkRqUnlheUtKNStPN1RO?=
 =?utf-8?B?dlN1a1dJS3lGQ1N0VGRHTTVhZjJ2NGc3UUtoUmtJQ0pnQ3RrNU44VTB1SzRZ?=
 =?utf-8?B?eWl4bUVBTnAxSFowcVBCcC9QZk1uY1BScElvT3ZjTWtVeTdyMFdvTHlvaUlo?=
 =?utf-8?B?ODNqeUE5TlJqSXp0NERBdCtpN0hBZEVMc2lYOWZ2Vnptd3dOVU1objFiaU1T?=
 =?utf-8?B?dlBIUkw0RiszUVBkcmtUalRiL2VQY0MzUE95eEcvRUs2OWFHWjRBSDV4TVhW?=
 =?utf-8?B?ZjBtSUJmZ24vN2Y5WW8xSHhSdzJEdDV2VFl1QXVpamcwZGxOVmVuKzQvQVN2?=
 =?utf-8?B?SGMwaFlPMlBwTExaUUUvNk9CT0tDS3FpRjA0Tzk5NVMxWHcxVUppQzhKQlNW?=
 =?utf-8?B?bTY1eFhMdlNZUzRlSnhGSWowTmFacUx6UExzN3h2UU5MRjRqUkhBTXBvMUNS?=
 =?utf-8?B?VVJzM3RUQXlMbDRDN25tZzlHWXRBRnJkU0RSQnoxbS9XbVVZSzcveGFQaVBI?=
 =?utf-8?B?Z2ZoamdCYlJhSGNGNWpXam1oSmYyK2VwcU9SMDBxNXM2NlhxR043OWIwemhL?=
 =?utf-8?B?UWVqZFlKTXNCYUJDSmkvZVVxdG1ZNUlvYmpJUzZiU3ZYaDcxMkx4MzNHZ2U1?=
 =?utf-8?B?ZlFkZmF4amdtbS81WjRQYitKdE5sTTRlR2dMaVdURGhjcHdKVFJlaVdsQitl?=
 =?utf-8?B?NnNUanNhakRqMUZ0ZzFCbTVWdlFnL2NBQll0cC9jOS8vU1JNc0dGanowOTJ3?=
 =?utf-8?B?UWw1T1RHekhpRFgxSWcxUDVMWUZqVG9ydmhRVUJLYlpMQ1pFYTVXU1ltME5m?=
 =?utf-8?B?dE44M05iY1ZJNVNZQTYwZjBTT3c4bUlZTlVYa1k4cDN3TGl1WGNzcmtRTERX?=
 =?utf-8?B?TEJ6TWVzd3hjRndzZ0dwYlZNUnBseGNyUU1KN0ZtUTl6ek5HaVVKQktGZVV4?=
 =?utf-8?B?a3Q5V21WdVg1b3NBSVlvYkowUWZyVGcrTHBOYW1WR2Y4NG5tN1pOZzVBaDlj?=
 =?utf-8?B?bmY4VzM4RGFCRm9jRFBJakQ5T3MrUDRRQU8wUUN6Z3pwQWEyek1MY0tlVnFY?=
 =?utf-8?B?di9ZNnN5ZUhlSk85MzljQWI4YUc4MVFqMm8rd0Rnd2YyYWtrek9TcFhacVpw?=
 =?utf-8?B?c2lDYzZXUFRwZVpMYUM0akhWdHNEeEQ4cEMreThhMitOUzVEU25OMFVCSG9a?=
 =?utf-8?B?dnFvVSs5Zm85bFdCa3VKQXBHa1lTTXhDekNjMTJkQ2Vyb0g1SHZxZ2RXT01k?=
 =?utf-8?B?WE9UMjhYLzVmaFlrSDJoZi9ucUNwODc2WVY3Y0wwZlZIZUtYWm5acVIyeVR5?=
 =?utf-8?B?dXpQSzdTbjkxVjIybWhIZ2ZPL2RqSjRWbmtmOWZGMnJIMmdxYmRmSFhYR1FP?=
 =?utf-8?B?S1JLcEF2VStIY0F4YUR3ZytmWm5oeWEwTmFkK3JhQ2VLeENicmVOMUh3NVpO?=
 =?utf-8?B?TUFPVHlNT2srMkxDTGNpQ3psc0hOUWMwa0xFa1g3U2hnVWFiU01kVyttTEFj?=
 =?utf-8?Q?+1PE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759b27bc-6109-44f1-db65-08db35185604
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 14:24:44.1193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ePycxvLhQGDN4dDc99+xqjcq3QeTWrKQttYYAoKt6AzGo2PwOzubfB3W9YlsBQ+BNpy9k7+aJ7uS5KOJysEUcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4996
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIEFwcmlsIDQsIDIwMjMgMTA6MDAgUE0NCj4gDQo+IEhpIFlpLA0KPiANCj4gT24gNC8xLzIz
IDE2OjQ0LCBZaSBMaXUgd3JvdGU6DQo+ID4gVGhpcyBwcmVwYXJlcyB0byBhZGQgYW5vdGhlciBt
ZXRob2QgZm9yIGhvdCByZXNldC4gVGhlIG1ham9yIGhvdCByZXNldCBsb2dpYw0KPiA+IGFyZSBt
b3ZlZCB0byB2ZmlvX3BjaV9pb2N0bF9wY2lfaG90X3Jlc2V0X2dyb3VwcygpLg0KPiA+DQo+ID4g
Tm8gZnVuY3Rpb25hbCBjaGFuZ2UgaXMgaW50ZW5kZWQuDQo+ID4NCj4gPiBTdWdnZXN0ZWQtYnk6
IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmFz
b24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogSmFzb24gR3Vu
dGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiBUZXN0ZWQtYnk6IFlhbnRpbmcgSmlhbmcgPHlh
bnRpbmcuamlhbmdAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlpIExpdSA8eWkubC5s
aXVAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2Nv
cmUuYyB8IDU2ICsrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tDQo+ID4gIDEgZmlsZSBj
aGFuZ2VkLCAzMyBpbnNlcnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYyBiL2RyaXZlcnMvdmZpby9w
Y2kvdmZpb19wY2lfY29yZS5jDQo+ID4gaW5kZXggNWQ3NDVjOWFiZjA1Li4zNjk2YjhlNTg0NDUg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gPiAr
KysgYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYw0KPiA+IEBAIC0xMjU1LDI5ICsx
MjU1LDE3IEBAIHN0YXRpYyBpbnQgdmZpb19wY2lfaW9jdGxfZ2V0X3BjaV9ob3RfcmVzZXRfaW5m
bygNCj4gPiAgCXJldHVybiByZXQ7DQo+ID4gIH0NCj4gPg0KPiA+IC1zdGF0aWMgaW50IHZmaW9f
cGNpX2lvY3RsX3BjaV9ob3RfcmVzZXQoc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2
LA0KPiA+IC0JCQkJCXN0cnVjdCB2ZmlvX3BjaV9ob3RfcmVzZXQgX191c2VyICphcmcpDQo+ID4g
K3N0YXRpYyBpbnQNCj4gPiArdmZpb19wY2lfaW9jdGxfcGNpX2hvdF9yZXNldF9ncm91cHMoc3Ry
dWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiA+ICsJCQkJICAgIHN0cnVjdCB2Zmlv
X3BjaV9ob3RfcmVzZXQgKmhkciwNCj4gbml0IHdoeSBkb24ndCB5b3Ugc2ltcGx5IHBhc3MgdGhl
IHVzZXIgZ3JvdXAgY291bnQgYXMgZGVjb2RlZCBlYXJsaWVyLg0KPiBoZHIgc291bmRzIGxpa2Ug
YSBkdXAgb2YgYXJnLg0KDQppbmRlZWQuIG9ubHkgaGRyLT5jb3VudCBpcyBuZWVkZWQuDQoNCj4g
PiArCQkJCSAgICBib29sIHNsb3QsDQo+ID4gKwkJCQkgICAgc3RydWN0IHZmaW9fcGNpX2hvdF9y
ZXNldCBfX3VzZXIgKmFyZykNCj4gPiAgew0KPiA+IC0JdW5zaWduZWQgbG9uZyBtaW5zeiA9IG9m
ZnNldG9mZW5kKHN0cnVjdCB2ZmlvX3BjaV9ob3RfcmVzZXQsIGNvdW50KTsNCj4gPiAtCXN0cnVj
dCB2ZmlvX3BjaV9ob3RfcmVzZXQgaGRyOw0KPiA+ICAJaW50MzJfdCAqZ3JvdXBfZmRzOw0KPiA+
ICAJc3RydWN0IGZpbGUgKipmaWxlczsNCj4gPiAgCXN0cnVjdCB2ZmlvX3BjaV9ncm91cF9pbmZv
IGluZm87DQo+ID4gLQlib29sIHNsb3QgPSBmYWxzZTsNCj4gPiAgCWludCBmaWxlX2lkeCwgY291
bnQgPSAwLCByZXQgPSAwOw0KPiA+DQo+ID4gLQlpZiAoY29weV9mcm9tX3VzZXIoJmhkciwgYXJn
LCBtaW5zeikpDQo+ID4gLQkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4gLQ0KPiA+IC0JaWYgKGhkci5h
cmdzeiA8IG1pbnN6IHx8IGhkci5mbGFncykNCj4gPiAtCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiAt
DQo+ID4gLQkvKiBDYW4gd2UgZG8gYSBzbG90IG9yIGJ1cyByZXNldCBvciBuZWl0aGVyPyAqLw0K
PiA+IC0JaWYgKCFwY2lfcHJvYmVfcmVzZXRfc2xvdCh2ZGV2LT5wZGV2LT5zbG90KSkNCj4gPiAt
CQlzbG90ID0gdHJ1ZTsNCj4gPiAtCWVsc2UgaWYgKHBjaV9wcm9iZV9yZXNldF9idXModmRldi0+
cGRldi0+YnVzKSkNCj4gPiAtCQlyZXR1cm4gLUVOT0RFVjsNCj4gPiAtDQo+ID4gIAkvKg0KPiA+
ICAJICogV2UgY2FuJ3QgbGV0IHVzZXJzcGFjZSBnaXZlIHVzIGFuIGFyYml0cmFyaWx5IGxhcmdl
IGJ1ZmZlciB0byBjb3B5LA0KPiA+ICAJICogc28gdmVyaWZ5IGhvdyBtYW55IHdlIHRoaW5rIHRo
ZXJlIGNvdWxkIGJlLiAgTm90ZSBncm91cHMgY2FuIGhhdmUNCj4gPiBAQCAtMTI4OSwxMSArMTI3
NywxMSBAQCBzdGF0aWMgaW50IHZmaW9fcGNpX2lvY3RsX3BjaV9ob3RfcmVzZXQoc3RydWN0DQo+
IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiA+ICAJCXJldHVybiByZXQ7DQo+ID4NCj4g
PiAgCS8qIFNvbWV3aGVyZSBiZXR3ZWVuIDEgYW5kIGNvdW50IGlzIE9LICovDQo+ID4gLQlpZiAo
IWhkci5jb3VudCB8fCBoZHIuY291bnQgPiBjb3VudCkNCj4gPiArCWlmICghaGRyLT5jb3VudCB8
fCBoZHItPmNvdW50ID4gY291bnQpDQo+ID4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+ID4NCj4gPiAt
CWdyb3VwX2ZkcyA9IGtjYWxsb2MoaGRyLmNvdW50LCBzaXplb2YoKmdyb3VwX2ZkcyksIEdGUF9L
RVJORUwpOw0KPiA+IC0JZmlsZXMgPSBrY2FsbG9jKGhkci5jb3VudCwgc2l6ZW9mKCpmaWxlcyks
IEdGUF9LRVJORUwpOw0KPiA+ICsJZ3JvdXBfZmRzID0ga2NhbGxvYyhoZHItPmNvdW50LCBzaXpl
b2YoKmdyb3VwX2ZkcyksIEdGUF9LRVJORUwpOw0KPiA+ICsJZmlsZXMgPSBrY2FsbG9jKGhkci0+
Y291bnQsIHNpemVvZigqZmlsZXMpLCBHRlBfS0VSTkVMKTsNCj4gPiAgCWlmICghZ3JvdXBfZmRz
IHx8ICFmaWxlcykgew0KPiA+ICAJCWtmcmVlKGdyb3VwX2Zkcyk7DQo+ID4gIAkJa2ZyZWUoZmls
ZXMpOw0KPiA+IEBAIC0xMzAxLDcgKzEyODksNyBAQCBzdGF0aWMgaW50IHZmaW9fcGNpX2lvY3Rs
X3BjaV9ob3RfcmVzZXQoc3RydWN0DQo+IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiA+
ICAJfQ0KPiA+DQo+ID4gIAlpZiAoY29weV9mcm9tX3VzZXIoZ3JvdXBfZmRzLCBhcmctPmdyb3Vw
X2ZkcywNCj4gPiAtCQkJICAgaGRyLmNvdW50ICogc2l6ZW9mKCpncm91cF9mZHMpKSkgew0KPiA+
ICsJCQkgICBoZHItPmNvdW50ICogc2l6ZW9mKCpncm91cF9mZHMpKSkgew0KPiA+ICAJCWtmcmVl
KGdyb3VwX2Zkcyk7DQo+ID4gIAkJa2ZyZWUoZmlsZXMpOw0KPiA+ICAJCXJldHVybiAtRUZBVUxU
Ow0KPiA+IEBAIC0xMzExLDcgKzEyOTksNyBAQCBzdGF0aWMgaW50IHZmaW9fcGNpX2lvY3RsX3Bj
aV9ob3RfcmVzZXQoc3RydWN0DQo+IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiA+ICAJ
ICogR2V0IHRoZSBncm91cCBmaWxlIGZvciBlYWNoIGZkIHRvIGVuc3VyZSB0aGUgZ3JvdXAgaGVs
ZCBhY3Jvc3MNCj4gPiAgCSAqIHRoZSByZXNldA0KPiA+ICAJICovDQo+ID4gLQlmb3IgKGZpbGVf
aWR4ID0gMDsgZmlsZV9pZHggPCBoZHIuY291bnQ7IGZpbGVfaWR4KyspIHsNCj4gPiArCWZvciAo
ZmlsZV9pZHggPSAwOyBmaWxlX2lkeCA8IGhkci0+Y291bnQ7IGZpbGVfaWR4KyspIHsNCj4gPiAg
CQlzdHJ1Y3QgZmlsZSAqZmlsZSA9IGZnZXQoZ3JvdXBfZmRzW2ZpbGVfaWR4XSk7DQo+ID4NCj4g
PiAgCQlpZiAoIWZpbGUpIHsNCj4gPiBAQCAtMTMzNSw3ICsxMzIzLDcgQEAgc3RhdGljIGludCB2
ZmlvX3BjaV9pb2N0bF9wY2lfaG90X3Jlc2V0KHN0cnVjdA0KPiB2ZmlvX3BjaV9jb3JlX2Rldmlj
ZSAqdmRldiwNCj4gPiAgCWlmIChyZXQpDQo+ID4gIAkJZ290byBob3RfcmVzZXRfcmVsZWFzZTsN
Cj4gPg0KPiA+IC0JaW5mby5jb3VudCA9IGhkci5jb3VudDsNCj4gPiArCWluZm8uY291bnQgPSBo
ZHItPmNvdW50Ow0KPiA+ICAJaW5mby5maWxlcyA9IGZpbGVzOw0KPiA+DQo+ID4gIAlyZXQgPSB2
ZmlvX3BjaV9kZXZfc2V0X2hvdF9yZXNldCh2ZGV2LT52ZGV2LmRldl9zZXQsICZpbmZvKTsNCj4g
PiBAQCAtMTM0OCw2ICsxMzM2LDI4IEBAIHN0YXRpYyBpbnQgdmZpb19wY2lfaW9jdGxfcGNpX2hv
dF9yZXNldChzdHJ1Y3QNCj4gdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYsDQo+ID4gIAlyZXR1
cm4gcmV0Ow0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIGludCB2ZmlvX3BjaV9pb2N0bF9wY2lf
aG90X3Jlc2V0KHN0cnVjdCB2ZmlvX3BjaV9jb3JlX2RldmljZSAqdmRldiwNCj4gPiArCQkJCQlz
dHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0IF9fdXNlciAqYXJnKQ0KPiA+ICt7DQo+ID4gKwl1bnNp
Z25lZCBsb25nIG1pbnN6ID0gb2Zmc2V0b2ZlbmQoc3RydWN0IHZmaW9fcGNpX2hvdF9yZXNldCwg
Y291bnQpOw0KPiA+ICsJc3RydWN0IHZmaW9fcGNpX2hvdF9yZXNldCBoZHI7DQo+ID4gKwlib29s
IHNsb3QgPSBmYWxzZTsNCj4gPiArDQo+ID4gKwlpZiAoY29weV9mcm9tX3VzZXIoJmhkciwgYXJn
LCBtaW5zeikpDQo+ID4gKwkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4gKw0KPiA+ICsJaWYgKGhkci5h
cmdzeiA8IG1pbnN6IHx8IGhkci5mbGFncykNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiAr
DQo+ID4gKwkvKiBDYW4gd2UgZG8gYSBzbG90IG9yIGJ1cyByZXNldCBvciBuZWl0aGVyPyAqLw0K
PiA+ICsJaWYgKCFwY2lfcHJvYmVfcmVzZXRfc2xvdCh2ZGV2LT5wZGV2LT5zbG90KSkNCj4gPiAr
CQlzbG90ID0gdHJ1ZTsNCj4gPiArCWVsc2UgaWYgKHBjaV9wcm9iZV9yZXNldF9idXModmRldi0+
cGRldi0+YnVzKSkNCj4gPiArCQlyZXR1cm4gLUVOT0RFVjsNCj4gPiArDQo+ID4gKwlyZXR1cm4g
dmZpb19wY2lfaW9jdGxfcGNpX2hvdF9yZXNldF9ncm91cHModmRldiwgJmhkciwgc2xvdCwgYXJn
KTsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIGludCB2ZmlvX3BjaV9pb2N0bF9pb2V2ZW50
ZmQoc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiA+ICAJCQkJICAgIHN0cnVj
dCB2ZmlvX2RldmljZV9pb2V2ZW50ZmQgX191c2VyICphcmcpDQo+ID4gIHsNCj4gQmVzaWRlcw0K
PiBSZXZpZXdlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KDQpUaGFu
a3MsDQpZaSBMaXUNCg==
