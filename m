Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1235AA9E8
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 10:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiIBIY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 04:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbiIBIYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 04:24:55 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570096369;
        Fri,  2 Sep 2022 01:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662107094; x=1693643094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ruvPNNIoO3f75m/9saCZY0pW7Bsbr5ahwkJDiFF6/p0=;
  b=ZJ0Kg7rslQHBaBGYxDn9wQb5Kcxg2QsvsUehbcpOwJVu0137C7I5UTiG
   7BKvvUfM0/+ltqLdZXwyWk21hQQ307W4ZqZ0etb5UuTSwGSAY9QrcIw8X
   akerlatJySA2+dImBFuH41g9bYIIUYOxAxU2GCLIkuFq6MaDWpMMv/Xk9
   dnbDsq2lMNUSY0DmoIK9nHz9aME6chKgqH5wEP7bYWznwp1TYWzydRUgD
   +OXYyBOst+M0Y1/IYZ+ikLKQZkSJzehGvnlGbWkF3y6/8M0FfjvR2W3gE
   Y5spdo7Wtu8VWa83P82WVz6ATb1zMfVieIL8xxVT15hrE2qu7uOXCwzTN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="322090451"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="322090451"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 01:24:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="642824210"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 02 Sep 2022 01:24:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 01:24:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 2 Sep 2022 01:24:52 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 2 Sep 2022 01:24:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZv+8MBKWot+PtrG7rrOL9+dqy0b0De4IrC8vt/J6OnkNaVkZScKKUFAm74n4+GZcrWkEEa3az1fZh3giP7JLicEEF2Sjlssm8pDIZi4tMY/yFMv9S958R9q9L6n2SmQY4XIaedChIaTCNmk7X/LT82ccjkw7gyikfnCeFy7TolITG0WvNhZKBaaGODmElvCLqB1ALzBrl3FBJ4xwuOW7BsBWuIaHd2CB6AqC5FcjYXJPGBrLMB61ncnGCttmFQzbXgjP1Mtcvz0HhC995ENV8QejffPLNM0dBJtjL/WWXpk/+4uDDPYmlvNG36aixCBHnr25D2fwXQHnFCT8PDXRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruvPNNIoO3f75m/9saCZY0pW7Bsbr5ahwkJDiFF6/p0=;
 b=CFbx1artPBqYztJN0MJbjJIxId3FycC+imgtSos3fip4STkXrdnNtlFOjLzLtrkyVPfqSu6obvCxeXFATD0OeEPxmt2f7P0nZ9BL04UP1X6UWxNlLje3hfLgnyXe3nx3WMzJWL1cQeoqZaS7HzVppBnMXd3uokel7Jsn8ZEcc9OiX2MxAdzod/YBa5Wkoh3Dz0B2HJ549irqTQK/PhTfVKJwcLwFuWuzqDro7OHjqH25jb6GSjx5v5iG519+DsoLiCdQAhNTCD5VKTU+BjzDu8Z7pRGoNnJbhXrkfMW1yWbCdT42RXc+E2W1JykdvM+mcS/z8zw1gOCWQCbKaqRQ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3819.namprd11.prod.outlook.com (2603:10b6:5:13f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 2 Sep
 2022 08:24:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 08:24:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "lpivarc@redhat.com" <lpivarc@redhat.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: [PATCH] vfio/type1: Unpin zero pages
Thread-Topic: [PATCH] vfio/type1: Unpin zero pages
Thread-Index: AQHYvB1sFDVbddToCUSenCrGOG+xWq3LxQqg
Date:   Fri, 2 Sep 2022 08:24:51 +0000
Message-ID: <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <166182871735.3518559.8884121293045337358.stgit@omen>
In-Reply-To: <166182871735.3518559.8884121293045337358.stgit@omen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88d7b998-b2b7-4078-e3b8-08da8cbc9b42
x-ms-traffictypediagnostic: DM6PR11MB3819:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: URHRNyQnS2VWr2UyxYdaYQ9QUwYu5THHq/fFKtk7ZTO91dkHg6m/3EnuGsINTkl9YgCsJHq0SNCBxCRWBOTk3vg2f/bx088lVN+xTt+DJ6SH+73UCUKdm0ZLqkznGtxyt8mZAA2GOiE7DgqDwWa/h3WUksvElPyTdbK/bP5RIcL+/m2hazb3s3ubFKfg0QBTaGcrfT1FpdO1AwD3d+A7lJ02yFSjdTQ8pmqdpJlECrbsI9JlKo/0caWd3Vh+fktOJGdEs6F0OGLN5C3TjmiNziqjNFhLAxtXC4qUhSkEV90n94uwwQ2+/ZsAQOVjx3a60HX9TMqpvfqxWA1dJYaeZYBq3F+pJ+QoBd/n5GC5vaLIQvZDFpfBZ40QphBGr0isG3EF/xPvqhAT/eeRsDYfe6SZNQCOsoxT/z4FSfJKACTe7IQINPmPIEHTG+b5LcnFCb9xTfLEOFNwHDE7u6i6MPwfaK+YYS6Fb8zVZEA3WcuTR45/r85ztbRpw6WhZ+HkMCD68tMP1g+uvc3OBURjt7Bv8b0LoMvssjCaYgQb68QdxDoXStGWUyM7GKUTurCTkqMQttHpUYDeNxW8yxaIlAUnfDmeW6qkZ7aL9kqI8BYkwLZp+98ltpoyX0dxpF4jYTO5EXkpZ5STdLod+2BS9v5/aHuvjyw+DtJUltVgkUobb/SA1jY37eazRMKm06DOwcHpFbjlXHaK3ODUkIl52YobiCALiSr9FMeT5t96zs1xNkj9MMHTlqkwyJBwPc6XNHVV8DFfqFIqOMDz1m4Gxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(39860400002)(366004)(346002)(136003)(55016003)(9686003)(38100700002)(2906002)(122000001)(7696005)(6506007)(186003)(33656002)(83380400001)(316002)(4326008)(54906003)(6916009)(66556008)(66446008)(8676002)(66946007)(66476007)(64756008)(76116006)(71200400001)(26005)(82960400001)(8936002)(5660300002)(107886003)(41300700001)(86362001)(38070700005)(52536014)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1duK1JnQXdYd1ZLWGlVeFI2ZTc5enl2S1JYa1RLU0d5aWVVL2pQQ2dxR3or?=
 =?utf-8?B?SlNrb2cvU2lpS0RyNjRwSFRnRmR6QUtVRE1XQXlhS2Q0SWdPaVYwaHpSZ3ZM?=
 =?utf-8?B?U1ZLVFVqc0hSUHJvTkJOTGxQQnIzSUQ3cUwvSnlzbmxiSU5TTmFBSkVHTldt?=
 =?utf-8?B?M2tOOENTMWdTN0JlaVFsT09DZElNanMveTBQakUzZEl3TG5CTTlhcEIzcVQ3?=
 =?utf-8?B?akhrQ29wd2x2Q3JUZTh4OTBDSGI0aG92Nk52cXYzMDZKRDJsaytCV1oxZ0w4?=
 =?utf-8?B?TUszbVhlT3lzS1owT3NUa1RGemlFZDBZcXdBbmx4UVEvell4K3JpbHRxYk9J?=
 =?utf-8?B?RWNIbnN0QUZPRWVHaDJtTnpTaVV2VVZVTllUZUxLWU1nLzJkS3cyYmlMRkhw?=
 =?utf-8?B?aGUzU28zUzVaUnNsV05pN2dFZlp5U2IwODJhQ2VpNVdiQTdOVys0aTMyZlZC?=
 =?utf-8?B?TTdNOEdIZnNyWWpnLzZIU2NNSXlFZkVzbVhTVlFQVEpCS3BVUUs4SnBIbXVw?=
 =?utf-8?B?L0k2NUJhbUVGVithNjhkYXhnTGJ4QUtNZlJkYjVRck1KbUxvQXRHR1hKUDRI?=
 =?utf-8?B?QjI5WW9WVS9PcE5Lc3hxSTMzWDRDM3RvOW92YnlYK1Fzc3FVM0ppRnBOS2Yy?=
 =?utf-8?B?eWZVdmlrQUNFV0orUXYwcytrc1B5VndoaDBka2ZxT2VNdDF1dGtzWHY1UWhz?=
 =?utf-8?B?WTdYN09NT2s5Z3dXdE1ZY3FKcWs4VlFTdnFySTRTcDBhMVpxU2FUYXEwVHpm?=
 =?utf-8?B?SE0yWWFNUnNubEhQdHlnYlpiKzVnM1o4cCtaS3ZiRWJjWGhNQ1NDMWJCaGZs?=
 =?utf-8?B?M3NLRkhWNG11WVFPYzFzK0RYdEVETVg0ek9URDlOL3dRQjhrVVlsNEdqditV?=
 =?utf-8?B?TDF4cEdOSFdEbGk3WlV6YkJibEY2SmJLbXdzcXlJM29QUDJvVmR3TVhiNm5O?=
 =?utf-8?B?ZkRrVmFQamx1cTlsT2VhM3hzM1RpY0JBbFpJaGZab01ENzdSNGpSRitsQ2sx?=
 =?utf-8?B?b3JVY0RqNVdsTythbjhSTVhqY1hiekwzQ2QzL1lLMjBsU3dGcDNsOU9ZcUVQ?=
 =?utf-8?B?VDFTRWxQZm9SaWhzaFJaNWJQZWpWek9sTWlZWnVWNkxBR285U2pUM0RNRXB1?=
 =?utf-8?B?dWM5YkVETlFKRS95aVV6aGdyaUtJQjVBeGtqZFpjSWlZMlBseUVMakhDalR3?=
 =?utf-8?B?SEc2aHBhdVN3aU1ET0h4d1ZybFo3dUw4NEI0VExRKzlBK0NSY2FwOXZYaHZv?=
 =?utf-8?B?clNybW1UbmhQbld1NmdZSm5PQjJrRUlzWUFJeFZOVmlEYXZoSkg2Zk13eXhj?=
 =?utf-8?B?MUtaK1M1Q1h2c1F0eWJEdHRqRkd2ZDJQVWNORzFlTVdPWjJtY2sxUG5HZjdt?=
 =?utf-8?B?WUZYOFZFN0JzSVFKRU5FUW9rY1kzMVlnYmZtWkp2S2dyMTVwSEp4YjNqSWd0?=
 =?utf-8?B?SVFuYnBpV2FPaTR6R051RFN5SkV4T0lsK2RUcVdheEFnWEhUSDdrc2xYSlFX?=
 =?utf-8?B?VlVnSmt6cElLTkpHMWszMEZ3SWR3eWNUQlRkU3EyM3g1Rk1YQ0dvM3N4WE1Z?=
 =?utf-8?B?QnVLR2ZIbVVOK1ozT1JRNFo2cWxiS1BYSXlFVjZmWlN2VzdBalJuN3dtaU1G?=
 =?utf-8?B?cHgybHJFWGM5NVhnQ201QVgvMjQzdDBYVmxreUZHVjNqMW5XMUpYbEJHUWZ3?=
 =?utf-8?B?R3JZSXpNdnUyTVJ1dm5SUmV5MVYvQXNJUlMxczhQRk45SDY2ck9qTTV1NlZO?=
 =?utf-8?B?QlRjdHdCVGdhdDNVc28wdjBuc1FQVTZxN0F2MGJCVnYwMjdiV0l0V0U1U25u?=
 =?utf-8?B?R3F5UnhHVkJnRklVeEhmZGVBRHArSEFDL1A3TnkzR3FQWGF2Qm4zUkhCVE8v?=
 =?utf-8?B?UEhlUzUvOXVVaFJUUFlwWFRVUEx0OXhlNUJnUEFscVRxZzJzeXEzMTFVNmdU?=
 =?utf-8?B?dnpmQkpVMFl5WkhaUlBhWDd6QUdXTGtqL05VNHFZeVVRZnpRbXJUK3ZPUHIv?=
 =?utf-8?B?MjErRHRjVGN5bUphU21ZazNzNm5vTWRjWmZjV1ZSaHBwdU8xNXorY3FsR2ht?=
 =?utf-8?B?VUNtMUdiK0ozMytNbVRFK0p1akFtS1grZ09jcDFoUWZObkM5aUljNzQyWEps?=
 =?utf-8?Q?uL0yavMlUZL7hqSvdAWYfRO57?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d7b998-b2b7-4078-e3b8-08da8cbc9b42
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 08:24:51.2627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3XTIdRGvK9QzogbT32C7M+Q9Dy3m9QolRHolbWmTS91TEnBWKbXYlThIr1rBQfYIF2ZOxOH81eoGE8tz4h7ohw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3819
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksIEFsZXgsDQoNCj4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVk
aGF0LmNvbT4NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDMwLCAyMDIyIDExOjA2IEFNDQo+IA0K
PiBUaGVyZSdzIGN1cnJlbnRseSBhIHJlZmVyZW5jZSBjb3VudCBsZWFrIG9uIHRoZSB6ZXJvIHBh
Z2UuICBXZSBpbmNyZW1lbnQNCj4gdGhlIHJlZmVyZW5jZSB2aWEgcGluX3VzZXJfcGFnZXNfcmVt
b3RlKCksIGJ1dCB0aGUgcGFnZSBpcyBsYXRlciBoYW5kbGVkDQo+IGFzIGFuIGludmFsaWQvcmVz
ZXJ2ZWQgcGFnZSwgdGhlcmVmb3JlIGl0J3Mgbm90IGFjY291bnRlZCBhZ2FpbnN0IHRoZQ0KPiB1
c2VyIGFuZCBub3QgdW5waW5uZWQgYnkgb3VyIHB1dF9wZm4oKS4NCj4gDQo+IEludHJvZHVjaW5n
IHNwZWNpYWwgemVybyBwYWdlIGhhbmRsaW5nIGluIHB1dF9wZm4oKSB3b3VsZCByZXNvbHZlIHRo
ZQ0KPiBsZWFrLCBidXQgd2l0aG91dCBhY2NvdW50aW5nIG9mIHRoZSB6ZXJvIHBhZ2UsIGEgc2lu
Z2xlIHVzZXIgY291bGQNCj4gc3RpbGwgY3JlYXRlIGVub3VnaCBtYXBwaW5ncyB0byBnZW5lcmF0
ZSBhIHJlZmVyZW5jZSBjb3VudCBvdmVyZmxvdy4NCj4gDQo+IFRoZSB6ZXJvIHBhZ2UgaXMgYWx3
YXlzIHJlc2lkZW50LCBzbyBmb3Igb3VyIHB1cnBvc2VzIHRoZXJlJ3Mgbm8gcmVhc29uDQo+IHRv
IGtlZXAgaXQgcGlubmVkLiAgVGhlcmVmb3JlLCBhZGQgYSBsb29wIHRvIHdhbGsgcGFnZXMgcmV0
dXJuZWQgZnJvbQ0KPiBwaW5fdXNlcl9wYWdlc19yZW1vdGUoKSBhbmQgdW5waW4gYW55IHplcm8g
cGFnZXMuDQo+IA0KDQpXZSBmb3VuZCBhbiBpbnRlcmVzdGluZyBpc3N1ZSBvbiB6ZXJvIHBhZ2Ug
YW5kIHdvbmRlciB3aGV0aGVyIHdlDQpzaG91bGQgaW5zdGVhZCBmaW5kIGEgd2F5IHRvIG5vdCB1
c2UgemVybyBwYWdlIGluIHZmaW8gcGlubmluZyBwYXRoLg0KDQpUaGUgb2JzZXJ2YXRpb24gLSB0
aGUgJ3BjLmJpb3MnIHJlZ2lvbiAoMHhmZmZjMDAwMCkgaXMgYWx3YXlzIG1hcHBlZA0KUk8gdG8g
emVybyBwYWdlIGluIHRoZSBJT01NVSBwYWdlIHRhYmxlIGV2ZW4gYWZ0ZXIgdGhlIG1hcHBpbmcg
aW4NCnRoZSBDUFUgcGFnZSB0YWJsZSBoYXMgYmVlbiBjaGFuZ2VkIGFmdGVyIFFlbXUgbG9hZHMg
dGhlIGd1ZXN0DQpiaW9zIGltYWdlIGludG8gdGhhdCByZWdpb24gKHdoaWNoIGlzIG1tYXAnZWQg
YXMgUlcpLg0KDQpJbiByZWFsaXR5IHRoaXMgbWF5IG5vdCBjYXVzZSByZWFsIHByb2JsZW0gYXMg
SSBkb24ndCBleHBlY3QgYW55IHNhbmUNCnVzYWdlIHdvdWxkIHdhbnQgdG8gRE1BIHJlYWQgZnJv
bSB0aGUgYmlvcyByZWdpb24uIFRoaXMgaXMgcHJvYmFibHkNCnRoZSByZWFzb24gd2h5IG5vYm9k
eSBldmVyIG5vdGVzIGl0Lg0KDQpCdXQgaW4gY29uY2VwdCBpdCBpcyBpbmNvcnJlY3QuDQoNCkZp
eGluZyBRZW11IHRvIHVwZGF0ZS9zZXR1cCB0aGUgVkZJTyBtYXBwaW5nIGFmdGVyIGxvYWRpbmcg
dGhlIGJpb3MNCmltYWdlIGNvdWxkIG1pdGlnYXRlIHRoaXMgcHJvYmxlbS4gQnV0IHdlIG5ldmVy
IGRvY3VtZW50IHN1Y2ggQUJJDQpyZXN0cmljdGlvbiBvbiBSTyBtYXBwaW5ncyBhbmQgaW4gY29u
Y2VwdCB0aGUgcGlubmluZyBzZW1hbnRpY3MNCnNob3VsZCBhcHBseSB0byBhbGwgcGF0aHMgKFJP
IGluIERNQSBhbmQgUlcgaW4gQ1BVKSB3aGljaCB0aGUNCmFwcGxpY2F0aW9uIHVzZXMgdG8gYWNj
ZXNzIHRoZSBwaW5uZWQgbWVtb3J5IGhlbmNlIHRoZSBzZXF1ZW5jZQ0Kc2hvdWxkbid0IG1hdHRl
ciBmcm9tIHVzZXIgcC5vLnYNCg0KQW5kIG9sZCBRZW11L1ZNTSBzdGlsbCBoYXZlIHRoaXMgaXNz
dWUuDQoNCkhhdmluZyBhIG5vdGlmaWVyIHRvIGltcGxpY2l0bHkgZml4IHRoZSBJT01NVSBtYXBw
aW5nIHdpdGhpbiB0aGUNCmtlcm5lbCB2aW9sYXRlcyB0aGUgc2VtYW50aWNzIG9mIHBpbm5pbmcs
IGFuZCBtYWtlcyB2ZmlvIHBhZ2UNCmFjY291bnRpbmcgZXZlbiBtb3JlIHRyaWNreS4NCg0KU28g
SSB3b25kZXIgaW5zdGVhZCBvZiBjb250aW51aW5nIHRvIGZpeCB0cmlja2luZXNzIGFyb3VuZCB0
aGUgemVybw0KcGFnZSB3aGV0aGVyIGl0IGlzIGEgYmV0dGVyIGlkZWEgdG8gcHVyc3VlIGFsbG9j
YXRpbmcgYSBub3JtYWwNCnBhZ2UgZnJvbSB0aGUgYmVnaW5uaW5nIGZvciBwaW5uZWQgUk8gbWFw
cGluZ3M/DQoNClRoYW5rcw0KS2V2aW4NCg==
