Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338665AAAE9
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 11:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiIBJJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 05:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiIBJJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 05:09:54 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28AA272C;
        Fri,  2 Sep 2022 02:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662109793; x=1693645793;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E5haCV1PRDFc6w3g36qui3mqK2ik85MJHnw9iaICbXo=;
  b=Ojv8sZ4m3uKHFQrdeYt5PMTuZFCu1kdqzzwApEZQd5+96JmTAhSA9bMI
   +v6yydJ8tYS7wXZawiDtwwCI7yTN49vxy/5KHCPqL/pe8wZtYqieOHFDq
   HH4BZI/5JhJx6LlMtfXXfC7944EsRYEqYFovSJ+EGNvvhT1ILqslHdXUU
   UiMT2LfdL5sBQrtWRZOEROEnbySMSIOIdr0N8e75LQRoNM9d//P1Wi6Ou
   RAvTlM5ZBJkljdLRaKssyFWr2h5BZPVmzBpfqMv8NmKHtcHo5Vb2kDOrL
   DsCeLfmLSCpLO8mLovB85xKGmRFltzcv0wOSkdsGiFmD1jLQc88he3GbI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="295946829"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="295946829"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 02:09:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="788597883"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 02 Sep 2022 02:09:49 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 02:09:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 2 Sep 2022 02:09:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 2 Sep 2022 02:09:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QN3n7UfQeQ6v4+4e805i1B3SluVsyrRe0hH4gP2EZ94PnQoRWGDYs+33raEGOXIRlLlVZ3k6TaaGjpaHF4WHXTu/pKz/hI1Falaj7fcZq7O56uEjQ6Gu+so30tcCUxeoUpPYtSDUX9J8GZ0QaBYzyY5RyI4zuvJzh1W2GGIQsoNExekn4iOV10BdCWFfzqcD0SB4Wt8npvKMbAwis6YwM/DncA6wGnLRBXPBcWor9NNhh4FnmfP36+1NMFdvKtOAettulxAfHNh1mKTdnO90Dv7ik9s0QZJ3O2zW5NGQTHtglesS4XdTsJRmuWQY1oB5PtJ+aYpIfVycGmvp3HUgdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5haCV1PRDFc6w3g36qui3mqK2ik85MJHnw9iaICbXo=;
 b=KTDVz5MkJJ/1+OMVBt+jqZmG+vmTnjjRXj+IZ9U5h08a0a8SbED2apVgJ1UGHa79GJfpynAAiXORTacpiuOMi1GUNoPFERp4aetEFlCoHG29Pp9AmKG/Lpalbsq+yOuVxK5IovAZkhEC+ftQG3A4vCjPyC0cytWw4SfpBle6V3wOsRczRmrBtvd3eSh8hHyzFaohTHdu3fgJlKL4EQoJNfpoP9K1/w9/TPlkMc9wJg7lyoLMt1NAgXjAv+KNigccBRZl51CyDLTZ1QUJuhBuZ2k4Hmdc9yMAZUvr6JEZ69x3yYw2xnk7mw9KdX+teifGlQLx6bfSPdzmOcLRAOWMKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3819.namprd11.prod.outlook.com (2603:10b6:5:13f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 2 Sep
 2022 09:09:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 09:09:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lpivarc@redhat.com" <lpivarc@redhat.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: [PATCH] vfio/type1: Unpin zero pages
Thread-Topic: [PATCH] vfio/type1: Unpin zero pages
Thread-Index: AQHYvB1sFDVbddToCUSenCrGOG+xWq3LxQqggAAPrICAAANsYA==
Date:   Fri, 2 Sep 2022 09:09:24 +0000
Message-ID: <BN9PR11MB5276DD07EC06631237354D678C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <166182871735.3518559.8884121293045337358.stgit@omen>
 <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
In-Reply-To: <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b25e3002-cf22-412b-dd53-08da8cc2d465
x-ms-traffictypediagnostic: DM6PR11MB3819:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0toWt8CJCZCK38+Aejg64HIZv5YktFvqnkwQBwa4rLCkvQz6EcUK4HDOt2Pd8E9gPICf/5IOI+utjIrLSX5jq9Qx+w91xSme5QBmnB2NsWUmoe+jIQgirNNp6uJwc6Es1jMg9+MxLYmXbqo0ggKZa+tMvvIYtVPh3xRT1g7BJcxeebu19wnmVK5Y4IlAETX3B1emZFfrZ/ISxxrbKLgJvBdDS+VD+f/6XfLihE+wpZbBrQVsTugzXCUv4zfivjFSzObDYkhL2nlWtxAa8VIjGVFHkEgn6LwHDlLD3ZLusyXfmFDUOAffMkPLyZHB3Y6dRMjIEBx06re9BgezKxcg3iqaO/qd7UU80FOBbOZqxh9T86m13tlH7FqxZU8uPPQBhCMPnrsQmOHIq63Go1cQWaYvoa9e3pwEQDJ+4/E1xMZpugBCZUTfD9cHaoqEz9pzBK95CatF7aquEYgfpv/kj1eSdTzDzC3pJfFfpEgB+tI/+7+5ksF6WnZsrsclVZsvyS7KCbWQQ5lNR8lg/8xaB/tOe3cAABKpv5wEx0w9x/8KHpgkeA9zFOiqJwc46Q9DTdzVcvzV9pX8Ve5XtCWfNPSHJgaIlDeIjC43/xA0PXVjshVGQzbF3tCqQONLi6yRg+VCzjWsSjcDNhrpiMmL+993JOnYK3EOsamp9RiX980MCidsVla3HnTbdXfmS0pdlUgnGCq8Rih9PmKgn2IefM9rmBnXr1iRGy1ZH6V4Iqo+Y+btMxPqBqvycyZleRi/TWdsDLOiOkTYsdj7xYiY6v9D8JUcUIfyhq34qxK3SLU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(366004)(376002)(396003)(5660300002)(107886003)(82960400001)(8936002)(66946007)(8676002)(66446008)(966005)(66476007)(66556008)(54906003)(4326008)(316002)(26005)(71200400001)(76116006)(64756008)(110136005)(52536014)(38070700005)(478600001)(86362001)(41300700001)(7696005)(122000001)(6506007)(9686003)(55016003)(53546011)(2906002)(38100700002)(33656002)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWdJY09jR1c4OXRqZTBDdlY3UjVUc2pPRHVLY2tsSFgxV0JyWUZ3QTNYNXRv?=
 =?utf-8?B?Zk5WeW9hc3J0SGoyZWlCdWxIS01vMHkvNjFqZ1lCcitKUDAzOHBrdlJCbVNM?=
 =?utf-8?B?RG5vaFYyMGUwNy9yRlRNZ0tEWHIvL21kMUtZa1JkZ1NLemVPMWhNS0hjdVhn?=
 =?utf-8?B?QkRZc1NxUDFreDJGQnB4RWJDWDJMZDVxRUl0SVBUR3llT3dXaDdrMkJHL0RU?=
 =?utf-8?B?Z3prK1NVTkpvNDFHNUZSRjVIZFhSYmdtU3ViR3Z6dzZ3WUNTdk92c0NaQ2VZ?=
 =?utf-8?B?dGVjd0FJTCtCK0hNVGsvRWlMZzBNUWl5MVJzbzd3ZFUvSElIZXp5a2Qwc1JV?=
 =?utf-8?B?dWx3QkZyUklJTEdiOFkzVU9WZ29yN1dUUG96SU50RFBURjFxZXJNblJVOW1j?=
 =?utf-8?B?cExkRWY3SEViR0NsTEVTb1FNZ2FpbW1hTDVrWE16dVhOek5OdHFaeE42TzR3?=
 =?utf-8?B?T2NXM3hMYktWQUNTbzd1M2lvSWdoRHU1MjhsMmNpK3ZXWmtmWEgvVEMyOWtE?=
 =?utf-8?B?R25aVVlmWWEzZ1h1VnZrRVpnOG9xTzFHN1JRR1hWdklWOVhTUTNwMWNxb2FR?=
 =?utf-8?B?ay85Z0FGMm4rUEJTWmVzcUZQVmo1ZmR0c2pCMXNzSEIyWUNBQTVldTFhNjdm?=
 =?utf-8?B?TEh3bkl3TCtNQ2toVERtWFNNNWV2NHA3OW1BOHN4bm9zRGtUWkVVdUg4K0Fs?=
 =?utf-8?B?VHh6R29aSGptaG9nUDZJOXRlL290c3lRUnJSNHhIaG11RXI1Uys2STRBVGo2?=
 =?utf-8?B?ekxxY3l3Zjd0UkFaMWZnVDREVXNua2JzWXV1a0Qxdno4bk5nY2hrRFh2K3JD?=
 =?utf-8?B?SnQ0OXErWEFyWDQyd3VIQm5vMGZhbHpIN0doRjNuaXozS1ZYNk5oWUFYbGFn?=
 =?utf-8?B?cG5odkNrRVRjaG5ZblY4SmJtVXorNm05THZqYjV1bDZuT041Z3NjemZLRTlG?=
 =?utf-8?B?cnJ6c0NFUGlwVlRvNHlhYkhCUzNFU010VEtkTGM4aHJRQWZ5M0R1aXBPQTNQ?=
 =?utf-8?B?ZFROTzFEdS9nbDB4ZExDZUo3VXplUE1ja0JYdUhIUExHU0NMUmZWRC9sZDJM?=
 =?utf-8?B?NWtMVkd0b1VJaG1NVUs4MzlVc0h6b0paeGZ5VUF4NmNEcGZkOHpwdzZCeEJm?=
 =?utf-8?B?R3g3aWo2SDR3R3M0NmQrUFBBd3RrZE80NjBJbXB3M3NESDJLak16bnVDVjRq?=
 =?utf-8?B?elNvWXM3cUk5cUJPVHJ6azA0NkpRTEtHL3RSNjVROFBjTlBpQ1pYcU9CMldw?=
 =?utf-8?B?Z1EyL21mRDVad0RWK24vZVJ1NGVTNUZheDZYOFpPWHBwcDc4NlN1UG9uVFl5?=
 =?utf-8?B?NHAyeFgwRUlZV0gvMENpc3AwTjd1Z1o3bEdNMVVJT1ltaGRtWTc5ZmpIWjBC?=
 =?utf-8?B?UmI1VmJPSTVYZkF2SXhhWnY5alhJaDlJWGxwVDdsSkUzUU1VL05leGpKOFF0?=
 =?utf-8?B?MnlmVjJER1Z5VDZ0V0hCSUtjYTd3dWlqOXM2Y081VDVRVFJ1emhyT3hFdjcx?=
 =?utf-8?B?d3JWQjFpb01laVFwUXoybmVtMTRmVXZSUGE2MWNQcExkd3hyVUFzQlo4WTZH?=
 =?utf-8?B?VFU3ZnduSGpVcVlaSFYxSFVNd2tsWWNkQUpWRFdGRUVsb1g4R3pjRGxmejJr?=
 =?utf-8?B?ZjdyQ3Z5dEtTV3JOeTQxbDVaNGsrSmxwOUpPdlBkSlVCVHRRZHlYa1FzcnpJ?=
 =?utf-8?B?RmZCK2d6NFFmcW1scHVPSmRjOEozSXpBQjBFcW56Ukk1QlcrS1N5amNNQkdB?=
 =?utf-8?B?SXZ2UHJqcE1hdllPazM3eS9kSmpZU25INjhqeFUxMTRJS1NWYlQ5dEFZWjZs?=
 =?utf-8?B?WlJaS0NLRWYvQjI3SE9zb3JJV2FKaVozNGd5MVUxdjhDNkpOVDNMa015ZFJM?=
 =?utf-8?B?anlQR0dQcjlTOXdBcHV5V0Q3ZUVKUWtWakV5TGxRL2xjQzFFbmhsTVRGTS9r?=
 =?utf-8?B?QjMzQ3JpdUk3cVl3UFlRYzE2SXg5VUNwV2lNYTFkRTZwUkNjUXJkVHVmYSsy?=
 =?utf-8?B?M2ZVZVl0bTdXU2NMS3l2MlhjZzl0bzRVTCs1eXZwSE9lTXJkUTZ1VEVMRStt?=
 =?utf-8?B?VHVsUEkxemk3Vyt2WmVDK1NoUnZwQ2ZlTENsblEyM21YMEtDaGliMjMvTk9i?=
 =?utf-8?Q?tCQ9/uLdZmG5HNhv8aDyNPFrR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b25e3002-cf22-412b-dd53-08da8cc2d465
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 09:09:24.0711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SHXeZ6GjzeQ6fxh2LhmIAL8288ejfWtlb4fY/g7PxGAtbFXvwmDK7jeq3gMi9Bnqn/QlD/cphVHmeDovG63Xxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3819
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4NCj4gU2VudDogRnJp
ZGF5LCBTZXB0ZW1iZXIgMiwgMjAyMiA0OjMyIFBNDQo+IA0KPiBPbiAwMi4wOS4yMiAxMDoyNCwg
VGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gSGksIEFsZXgsDQo+ID4NCj4gPj4gRnJvbTogQWxleCBX
aWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPj4gU2VudDogVHVlc2Rh
eSwgQXVndXN0IDMwLCAyMDIyIDExOjA2IEFNDQo+ID4+DQo+ID4+IFRoZXJlJ3MgY3VycmVudGx5
IGEgcmVmZXJlbmNlIGNvdW50IGxlYWsgb24gdGhlIHplcm8gcGFnZS4gIFdlIGluY3JlbWVudA0K
PiA+PiB0aGUgcmVmZXJlbmNlIHZpYSBwaW5fdXNlcl9wYWdlc19yZW1vdGUoKSwgYnV0IHRoZSBw
YWdlIGlzIGxhdGVyIGhhbmRsZWQNCj4gPj4gYXMgYW4gaW52YWxpZC9yZXNlcnZlZCBwYWdlLCB0
aGVyZWZvcmUgaXQncyBub3QgYWNjb3VudGVkIGFnYWluc3QgdGhlDQo+ID4+IHVzZXIgYW5kIG5v
dCB1bnBpbm5lZCBieSBvdXIgcHV0X3BmbigpLg0KPiA+Pg0KPiA+PiBJbnRyb2R1Y2luZyBzcGVj
aWFsIHplcm8gcGFnZSBoYW5kbGluZyBpbiBwdXRfcGZuKCkgd291bGQgcmVzb2x2ZSB0aGUNCj4g
Pj4gbGVhaywgYnV0IHdpdGhvdXQgYWNjb3VudGluZyBvZiB0aGUgemVybyBwYWdlLCBhIHNpbmds
ZSB1c2VyIGNvdWxkDQo+ID4+IHN0aWxsIGNyZWF0ZSBlbm91Z2ggbWFwcGluZ3MgdG8gZ2VuZXJh
dGUgYSByZWZlcmVuY2UgY291bnQgb3ZlcmZsb3cuDQo+ID4+DQo+ID4+IFRoZSB6ZXJvIHBhZ2Ug
aXMgYWx3YXlzIHJlc2lkZW50LCBzbyBmb3Igb3VyIHB1cnBvc2VzIHRoZXJlJ3Mgbm8gcmVhc29u
DQo+ID4+IHRvIGtlZXAgaXQgcGlubmVkLiAgVGhlcmVmb3JlLCBhZGQgYSBsb29wIHRvIHdhbGsg
cGFnZXMgcmV0dXJuZWQgZnJvbQ0KPiA+PiBwaW5fdXNlcl9wYWdlc19yZW1vdGUoKSBhbmQgdW5w
aW4gYW55IHplcm8gcGFnZXMuDQo+ID4+DQo+ID4NCj4gPiBXZSBmb3VuZCBhbiBpbnRlcmVzdGlu
ZyBpc3N1ZSBvbiB6ZXJvIHBhZ2UgYW5kIHdvbmRlciB3aGV0aGVyIHdlDQo+ID4gc2hvdWxkIGlu
c3RlYWQgZmluZCBhIHdheSB0byBub3QgdXNlIHplcm8gcGFnZSBpbiB2ZmlvIHBpbm5pbmcgcGF0
aC4NCj4gPg0KPiA+IFRoZSBvYnNlcnZhdGlvbiAtIHRoZSAncGMuYmlvcycgcmVnaW9uICgweGZm
ZmMwMDAwKSBpcyBhbHdheXMgbWFwcGVkDQo+ID4gUk8gdG8gemVybyBwYWdlIGluIHRoZSBJT01N
VSBwYWdlIHRhYmxlIGV2ZW4gYWZ0ZXIgdGhlIG1hcHBpbmcgaW4NCj4gPiB0aGUgQ1BVIHBhZ2Ug
dGFibGUgaGFzIGJlZW4gY2hhbmdlZCBhZnRlciBRZW11IGxvYWRzIHRoZSBndWVzdA0KPiA+IGJp
b3MgaW1hZ2UgaW50byB0aGF0IHJlZ2lvbiAod2hpY2ggaXMgbW1hcCdlZCBhcyBSVykuDQo+ID4N
Cj4gPiBJbiByZWFsaXR5IHRoaXMgbWF5IG5vdCBjYXVzZSByZWFsIHByb2JsZW0gYXMgSSBkb24n
dCBleHBlY3QgYW55IHNhbmUNCj4gPiB1c2FnZSB3b3VsZCB3YW50IHRvIERNQSByZWFkIGZyb20g
dGhlIGJpb3MgcmVnaW9uLiBUaGlzIGlzIHByb2JhYmx5DQo+ID4gdGhlIHJlYXNvbiB3aHkgbm9i
b2R5IGV2ZXIgbm90ZXMgaXQuDQo+ID4NCj4gPiBCdXQgaW4gY29uY2VwdCBpdCBpcyBpbmNvcnJl
Y3QuDQo+ID4NCj4gPiBGaXhpbmcgUWVtdSB0byB1cGRhdGUvc2V0dXAgdGhlIFZGSU8gbWFwcGlu
ZyBhZnRlciBsb2FkaW5nIHRoZSBiaW9zDQo+ID4gaW1hZ2UgY291bGQgbWl0aWdhdGUgdGhpcyBw
cm9ibGVtLiBCdXQgd2UgbmV2ZXIgZG9jdW1lbnQgc3VjaCBBQkkNCj4gPiByZXN0cmljdGlvbiBv
biBSTyBtYXBwaW5ncyBhbmQgaW4gY29uY2VwdCB0aGUgcGlubmluZyBzZW1hbnRpY3MNCj4gPiBz
aG91bGQgYXBwbHkgdG8gYWxsIHBhdGhzIChSTyBpbiBETUEgYW5kIFJXIGluIENQVSkgd2hpY2gg
dGhlDQo+ID4gYXBwbGljYXRpb24gdXNlcyB0byBhY2Nlc3MgdGhlIHBpbm5lZCBtZW1vcnkgaGVu
Y2UgdGhlIHNlcXVlbmNlDQo+ID4gc2hvdWxkbid0IG1hdHRlciBmcm9tIHVzZXIgcC5vLnYNCj4g
Pg0KPiA+IEFuZCBvbGQgUWVtdS9WTU0gc3RpbGwgaGF2ZSB0aGlzIGlzc3VlLg0KPiA+DQo+ID4g
SGF2aW5nIGEgbm90aWZpZXIgdG8gaW1wbGljaXRseSBmaXggdGhlIElPTU1VIG1hcHBpbmcgd2l0
aGluIHRoZQ0KPiA+IGtlcm5lbCB2aW9sYXRlcyB0aGUgc2VtYW50aWNzIG9mIHBpbm5pbmcsIGFu
ZCBtYWtlcyB2ZmlvIHBhZ2UNCj4gPiBhY2NvdW50aW5nIGV2ZW4gbW9yZSB0cmlja3kuDQo+ID4N
Cj4gPiBTbyBJIHdvbmRlciBpbnN0ZWFkIG9mIGNvbnRpbnVpbmcgdG8gZml4IHRyaWNraW5lc3Mg
YXJvdW5kIHRoZSB6ZXJvDQo+ID4gcGFnZSB3aGV0aGVyIGl0IGlzIGEgYmV0dGVyIGlkZWEgdG8g
cHVyc3VlIGFsbG9jYXRpbmcgYSBub3JtYWwNCj4gPiBwYWdlIGZyb20gdGhlIGJlZ2lubmluZyBm
b3IgcGlubmVkIFJPIG1hcHBpbmdzPw0KPiANCj4gVGhhdCdzIHByZWNpc2VseSB3aGF0IEkgYW0g
d29ya2luZy4gRm9yIGV4YW1wbGUsIHRoYXQncyByZXF1aXJlZCB0byBnZXQNCj4gcmlkIG9mIEZP
TExfRk9SQ0V8Rk9MTF9XUklURSBmb3IgdGFraW5nIGEgUi9PIHBpbiBhcyBkb25lIGJ5IFJETUE6
DQo+IA0KPiBTZWUNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzU1OTNjYmI3LWViMjkt
ODJmMC00OTBlLQ0KPiBkZDcyY2VhZmZmOWJAcmVkaGF0LmNvbS8NCj4gZm9yIHNvbWUgbW9yZSBk
ZXRhaWxzLg0KDQpZZXMsIHRoaXMgaXMgZXhhY3RseSB3aGF0IEknbSBsb29raW5nIGZvciENCg0K
PiANCj4gDQo+IFRoZSBjb25jZXJucyBJIGRpc2N1c3NlZCB3aXRoIFBldGVyIGFuZCBBbGV4IG9m
ZmxpbmUgZm9yIFZGSU8gaXMgdGhhdCB3ZQ0KPiBtaWdodCBlbmQgdXAgY2hhcmdpbmcgbW9yZSBh
bm9uIHBhZ2VzIHdpdGggdGhhdCBjaGFuZ2UgdG8gdGhlIE1FTUxPQ0sNCj4gbGltaXQgb2YgdGhl
IHVzZXIgYW5kIG1pZ2h0IGRlZ3JhZGUgZXhpc3Rpbmcgc2V0dXBzLg0KPiANCj4gSSBkbyB3b25k
ZXIgaWYgdGhhdCdzIGEgcmVhbCBpc3N1ZSwgdGhvdWdoLiBPbmUgYXBwcm9hY2ggd291bGQgYmUg
dG8NCj4gd2FybiB0aGUgVkZJTyB1c2VycyBhbmQgYWxsb3cgZm9yIHNsaWdodGx5IGV4Y2VlZGlu
ZyB0aGUgTUVNTE9DSyBsaW1pdA0KPiBmb3IgYSB3aGlsZS4gT2YgY291cnNlLCB0aGF0IG9ubHkg
d29ya3MgaWYgd2UgYXNzdW1lIHRoYXQgc3VjaCBwaW5uZWQNCj4gemVyb3BhZ2VzIGFyZSBvbmx5
IGV4dHJlbWVseSByYXJlbHkgbG9uZ3Rlcm0tcGlubmVkIGZvciBhIHNpbmdsZSBWTQ0KPiBpbnN0
YW5jZSBieSBWRklPLg0KPiANCg0KRm9yIG5vdyBJIGJlbGlldmUgbmF0aXZlIFZGSU8gYXBwbGlj
YXRpb25zIGxpa2UgZHBkayBkb24ndCB1c2UgUk8gbWFwcGluZy4NCkZvciBRZW11IHRoZSBvbmx5
IHJlbGV2YW50IHVzYWdlIGlzIGZvciB2aXJ0dWFsIGJpb3Mgd2hpY2ggaXMgaW4gMTAwJ3Mga2ls
by0NCm9yIHNldmVyYWwgbWVnYS1ieXRlcy4gDQoNCkFuZCBmb3IgZnV0dXJlIFFlbXUgaXQgbWF5
IGltcGxlbWVudCBhbiBvcHRpb24gdG8gc2tpcCBhZGRpbmcgUk8NCm1hcHBpbmdzIGlmIE1FTUxP
Q0sgbGltaXQgYmVjb21lcyBhIGNvbmNlcm4uIFNvIGZhciBJIGhhdmVuJ3Qgc2Vlbg0KYSByZWFs
IFZGSU8gdXNhZ2UgcmVxdWlyaW5nIHN1Y2ggUk8gbWFwcGluZ3MgaW4gRE1BIHBhdGgsIHByb2Jh
Ymx5DQp1bnRpbCBjcm9zcy1WTSBwMnAgd2hlcmUgdGhlIGV4cG9ydGVyIFZNIHdhbnRzIHRvIHJl
c3RyaWN0IHRoZSBhY2Nlc3MNCnBlcm1pc3Npb24gb24gdGhlIGNlcnRhaW4gTU1JTyByYW5nZSBh
Y2Nlc3NlZCBieSB0aGUgaW1wb3J0ZXIgVk0uDQpCdXQgaW4gdGhhdCBjYXNlIGl0J3Mgbm90IGFi
b3V0IG1lbW9yeSBoZW5jZSBubyBpbXBhY3Qgb24gTUVNTE9DSw0KbGltaXQuIPCfmIoNCg0KVGhh
bmtzDQpLZXZpbg0K
