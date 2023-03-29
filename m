Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9216CF68E
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 00:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjC2Wq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 18:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjC2Wq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 18:46:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BF8DF
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 15:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680130016; x=1711666016;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F+ebnH5ta0bhrrRFN5uZSXgn3P8VnaJ6Jzn12b8Gk38=;
  b=KxRKaqCcuS1S/ew+3HBrzDG09XBFe/K1u+MtMVUCgEaBPmH149N4/iaW
   tUaFXHbh5MjaaDhWIt35gtfFWWHpBX+rKxN50JaqjNKgRRigCv0DSngyc
   02LdCgFkClmdEUkpReH3F2H0TPTQGZbX3QDHBwYc2QJd6QkDHM8+iS0Dn
   IWvShYtvXlSyvvlwqAunNk/GVEm2M7lS1m4ZN8Xx66+uDBMeyBJQqakVv
   GzIRyyn37zOpNvEZq28uiBXhLKcwR81O+hfJ61rSsDdk0ofUZ/NjQgP91
   iJr61n0S1Z7FzaDzZKQKLWiJk/C48HQXHl5y4ORyqXUa0EkbhJJkBI0aH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="339739289"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="339739289"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 15:46:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="687004677"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="687004677"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 29 Mar 2023 15:46:43 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 15:46:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 15:46:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 15:46:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFNMZAtALsCXl9xYmG/LOawTk7JS4mhlwTioiidCLN6eBAbys5mQpwyEs57hGytoFrO6gMhbmzINscTxsMTj7vY9qQMEpXGsy2VjnPwTii0VIgZkWh8RfoIbBCM7L6k3r8XVLWPozHFW9QimBDGbK/Wg/d+adTkRG1FAO1bdcoDABE5DJUn1YkZ2dKxD5X1HIMeWzk41VfOaMhhAAHGF9YjmfjMFwsAkFKmhuVZpORyWUwqtpaFzusOrRVsCyVrsjAJ2mjoK9cqEPbM1Nx2fHqTiseOUc5iryBdyMrn6T8p1j6wNIU6OrKlHqub2u0nNvaLaFkeGXd6QFuN0S3T8eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+ebnH5ta0bhrrRFN5uZSXgn3P8VnaJ6Jzn12b8Gk38=;
 b=WRRif511cUlxE7rJV/8iNy2T83w7HRLYR7rfVjydphV5MvGLEf54JeG1t3+G27nYcjyn+P0Ewihe3FJKVW4sPPRjgCrM/9Cm02JpWjMDiLzko44dUXbMNYAJHmCyHhppPL1Ti9sja7BN10gxhozcOwV4TwSV0yd6mxcAgWQ6Ges1Qrg14CNHmxlAIrlkM8CpSOD+A0SYfIPsmMEg2pDumbI/lT4nx8rJFNVtOaM87ilyQjJmSgVQF/KEf0qbfnK+7Rns90yE6a8kFS37GQFkfXZf0gXtMgGvwjbDm218ZiUz+S8wLM+JZSftGi+Th6gGrm4tn9UFTvWGOu8PuSbDKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6918.namprd11.prod.outlook.com (2603:10b6:806:2bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Wed, 29 Mar
 2023 22:46:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%6]) with mapi id 15.20.6178.038; Wed, 29 Mar 2023
 22:46:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Topic: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Index: AQHZWj/xX+6sX0Ji9kGqSs4peyRxha8DnNOAgAIo0ACACyFUgIAAH6+AgAAKWgCAAAFNgIABArSAgABXIQA=
Date:   Wed, 29 Mar 2023 22:46:39 +0000
Message-ID: <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
         <20230319084927.29607-3-binbin.wu@linux.intel.com>
         <ZBhTa6QSGDp2ZkGU@gao-cwp> <ZBojJgTG/SNFS+3H@google.com>
         <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
         <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
         <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
         <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
         <ZCR2PBx/4lj9X0vD@google.com>
In-Reply-To: <ZCR2PBx/4lj9X0vD@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6918:EE_
x-ms-office365-filtering-correlation-id: de205f30-d276-411a-1b39-08db30a77597
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9PELXodCTH8zWP5V9qdXZrHYCu9Q1XvcdUhnlO1meGsCn3BWzhcYPMK1IluxKUGmrHHbIunxjjJnx7qbKmbTLeolL0KLvUWyxIlAKTJyR6BGhdvmOfLo2d7JhVyAv5OiiML+kKoMiDHeBBGfUkvwcjMBE9TD+hswquAkWeJkYSU4q1sw4bMn3oDgNqYPWA7e71wBbFynoukOQSYKfWWLmjzKRp7KslmqSOUxeXd2U9nMZPevsjSogWhc28Wrhl7wxdaawNsfQ3dZVzyJQhOD7xak6F6yI7emC1TE9/MJASd8rxUrZKMNEHcDcxcbvrkd6qVbSj5RuNMTZi2oeuhad6HYTuFXx6pDZ4QhBfY40qWs1jvgMPLTAW5nkzjkQJ0aFlgTElsvNw7p9bNUvxPb3sTSvBS1vvUj0Wx0JvFxzu4tsFSUwf3VDmiaI4V93tQfsGEdX0DGHoQrN9tXV/lt9DUltrb6wJ+hS4rfW+RKrCbEjUXqRmL9QMF918wC4/vL6k3ILK1ET90HZChIKz9XDdbAwrHLUUQ+XAN7uNoAJOXf6iedM8BKbVqfeaw3Yuh7gfIqWI8DCARwuLdUwdsY8hVBSZl3C0HwYxxyawQ8rYsyyh+s3dR3wFbeNbocwC9WEsc8UZoT4hOBWLlhAWkOcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199021)(6486002)(478600001)(71200400001)(36756003)(2616005)(86362001)(38070700005)(82960400001)(122000001)(38100700002)(6506007)(6512007)(53546011)(26005)(186003)(8936002)(41300700001)(8676002)(5660300002)(2906002)(54906003)(110136005)(91956017)(316002)(64756008)(66446008)(4326008)(76116006)(66556008)(66946007)(66476007)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VktHZVQ4VmYyTjVmN1V3WEpaRXJoUDZ4K3JJNHJMSTJqWDhOMFNqQk84TXJG?=
 =?utf-8?B?TmR5WExRY2JGcURaUVJOZXZ5YkZUalpETXlnMjhoQ2FvS3YxUU9PamMzYXhB?=
 =?utf-8?B?L042ZWh0djRmc29pelkyeERURkVpbWlYZWZSR1U3bDdKVzVnWnE2TXNTU0tn?=
 =?utf-8?B?TktXTGl2TDYwWTZUWTlMNVBBVXJtVDdKVmhvM21vbnVtc29hdisySC8xdkFo?=
 =?utf-8?B?U3l3ZCttQnZwZUM5RmRmZHJvSXhZOVhRY0pxZ2pjNHRMRmVLaTBJbjhGaVVT?=
 =?utf-8?B?QUVjTVpYSVE4Z1BiYy9vWm5PMlRsYjBMQ0RReHFac2dNbU9RcXhsSXdFaTBG?=
 =?utf-8?B?R2U5ZHNOWUJEaUZaUXpBQlhKRlBWYjRtWjhYTkxsTmZrUWRvaUpEUXJ2MG1Q?=
 =?utf-8?B?M3JqcVFBbU9vK1dWQy9xMzNkRG5XZ3hQWHp6N0VxenZBWHp5UitFUTY5R0JM?=
 =?utf-8?B?ODFST08wNFZSOGRjRUY3N2NSanA3VCt6UFI4c0RVVDZMdVI5emJrRDZUMVJm?=
 =?utf-8?B?VktEVWhOU3E4bnlUeE1YRys3d0xtSFJYODdKR013TEUyeTdRQ3B2VkFsOUZy?=
 =?utf-8?B?UHdLUVJScEFiNjRKdFluQ0V1UXYzYWQ5enJWN0NvR0ZFQUVMVDBVTTU0VlFS?=
 =?utf-8?B?NUc3UEtIaG9iRkJLT0szeDlORXZSNzBockVWZ2Nlb3Ywelp2UmtBU0QxRGV1?=
 =?utf-8?B?eVBtSWFMejVldXlUY2RjQmFKRGpmVE5WOE5JL1NFY3FVbHJKaDhudkZUeURv?=
 =?utf-8?B?VTNkZHN5NWZnM0xYRDVlSy9CZlBCVU90MW9DUEtmNVBwUXdITjVPWUdDMzhs?=
 =?utf-8?B?T1M2VExUOTZwVTIzL0I5RmpvMDBpdmNNaU5HN0orcmpvUG1JekVOT216OGlY?=
 =?utf-8?B?WEh0UkRNRFZWZFU4OUpWbHdpQVN1OXlwdkVwTm55ZVVrc2RFbEc1dGlTMkl4?=
 =?utf-8?B?K25PMHNtYVhJTnlFTWhNeHpUSE81bW05MEJTTlN5b1ZsWHJKdUo1NVFqUkVF?=
 =?utf-8?B?QTZqQVpYTW81eVdvV2FweTZHSUtwRWRrVk5xaE1OUGEwalljY2lwU3pmalNh?=
 =?utf-8?B?SzN4dExtZ3FGdUpjd1lhTHRsbGNMN25JSDVMbTg4QjBRM245dGs3Y1R0SEth?=
 =?utf-8?B?VTlMZDhNTGxFeWU0UzFqWjdZZWRkN2h4SWpabjdjT3k3clpBdnNqNTJDdlds?=
 =?utf-8?B?N05TWkxEdHpDWStxeGpXSjNQOE9WM1kvTnpkRUtMUkZySU9icTJFczdsYjIv?=
 =?utf-8?B?MEM4WlpwVHhZaHlRcHpjWWkxR0Z5U3dNZnZadHNaOHpQTC9TTGh6blRsbStD?=
 =?utf-8?B?SzQvemhYQjE2d1RoY29lVkw0YWhOcHBQR20rNGxNYlBtd1ZLL0RxeWlHcFAz?=
 =?utf-8?B?TmlXNWlURUZmT2g2UFhCQ1J1eTE2MEU1b3I4WTBLUytQckg3d3NUbVFuWUdD?=
 =?utf-8?B?U1BiNlVZdW1OZFo2b3h3Z2JybTQ3RlBidklJeUtuemoycHRFL1FtR0JROXRv?=
 =?utf-8?B?MUtYemExeVdyMHFTM3c3MjR6MVFzcE9MbEZDL3JabG9Fd01pUlJ4Z0N2VmEy?=
 =?utf-8?B?MEZSZVV0UnV2bjB6Rk9USXNZVE83Y3lUMkJSSk9TNkt2ZUFvbFRwcW9WVnB4?=
 =?utf-8?B?bmhZZlhGQ0paNjZOeGJaTFh2RUhZKzFwZjJlaXBvMmEzZktDTzU4djZGRDB3?=
 =?utf-8?B?T0w5ejBseVhOc0dBVExDTXlWYm1tM3dTNURtei9WcUFzUElvK243YmhYeklW?=
 =?utf-8?B?YlBUTzJ0cVFzWStJRFlZcGV2bkx4WkFCTHI4aklQdC93UzZ5d3dwdXdTWWVX?=
 =?utf-8?B?NnErUndRWFovKy9TWTR6N3RockxicUZaektEMklSK3BURmUxU21SSUh1ZEIx?=
 =?utf-8?B?YjBTZXpKNzlqVk96MEtNUE1wd0s5dkdFaHZnWVlCVHo1bUdKWkg2WHI4d2Zt?=
 =?utf-8?B?V1lybkcyZ3puRHlNTDFDa2ZENUZGNE9PaXp5VllrS1oyMkEveVAvR3pyRGh6?=
 =?utf-8?B?Tmg0R0tMZ0lkUmpMTmh5Q3VUOXZNTG13QXZIaFpzQUs2NzRkcnFQbWdNVVpB?=
 =?utf-8?B?cmhNNlJaaE5HVEpJR1pHanJOY2tFc2hxcEQvbFhHWUw0TWhycEdtNDJZQTli?=
 =?utf-8?Q?un6vPAcrWahzVYV/4Q+QFBjb/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30A4A3ADC9C1284B9D9EF04D6CA6BFAD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de205f30-d276-411a-1b39-08db30a77597
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 22:46:39.3253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fsx52y8XPuJ62g7RldvD9mPyGf417dde2FDniN1WS0x+iMLgTpnSooSQkyp9eKSP2yleoMh51+JG76q/n0mnhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6918
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTI5IGF0IDEwOjM0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1hciAyOSwgMjAyMywgQmluYmluIFd1IHdyb3RlOg0KPiA+IA0KPiA+
IE9uIDMvMjkvMjAyMyAxMDowNCBBTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IE9uIFdlZCwg
MjAyMy0wMy0yOSBhdCAwOToyNyArMDgwMCwgQmluYmluIFd1IHdyb3RlOg0KPiA+ID4gPiBPbiAz
LzI5LzIwMjMgNzozMyBBTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gPiBPbiBUdWUsIDIw
MjMtMDMtMjEgYXQgMTQ6MzUgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4g
PiA+ID4gPiBPbiBNb24sIE1hciAyMCwgMjAyMywgQ2hhbyBHYW8gd3JvdGU6DQo+ID4gPiA+ID4g
PiA+IE9uIFN1biwgTWFyIDE5LCAyMDIzIGF0IDA0OjQ5OjIyUE0gKzA4MDAsIEJpbmJpbiBXdSB3
cm90ZToNCj4gPiA+ID4gPiA+ID4gPiBnZXRfdm14X21lbV9hZGRyZXNzKCkgYW5kIHNneF9nZXRf
ZW5jbHNfZ3ZhKCkgdXNlIGlzX2xvbmdfbW9kZSgpDQo+ID4gPiA+ID4gPiA+ID4gdG8gY2hlY2sg
NjQtYml0IG1vZGUuIFNob3VsZCB1c2UgaXNfNjRfYml0X21vZGUoKSBpbnN0ZWFkLg0KPiA+ID4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IEZpeGVzOiBmOWViNGFmNjdjOWQgKCJLVk06IG5W
TVg6IFZNWCBpbnN0cnVjdGlvbnM6IGFkZCBjaGVja3MgZm9yICNHUC8jU1MgZXhjZXB0aW9ucyIp
DQo+ID4gPiA+ID4gPiA+ID4gRml4ZXM6IDcwMjEwYzA0NGI0ZSAoIktWTTogVk1YOiBBZGQgU0dY
IEVOQ0xTW0VDUkVBVEVdIGhhbmRsZXIgdG8gZW5mb3JjZSBDUFVJRCByZXN0cmljdGlvbnMiKQ0K
PiA+ID4gPiA+ID4gPiBJdCBpcyBiZXR0ZXIgdG8gc3BsaXQgdGhpcyBwYXRjaCBpbnRvIHR3bzog
b25lIGZvciBuZXN0ZWQgYW5kIG9uZSBmb3INCj4gPiA+ID4gPiA+ID4gU0dYLg0KPiA+ID4gPiA+
ID4gPiANCj4gPiA+ID4gPiA+ID4gSXQgaXMgcG9zc2libGUgdGhhdCB0aGVyZSBpcyBhIGtlcm5l
bCByZWxlYXNlIHdoaWNoIGhhcyBqdXN0IG9uZSBvZg0KPiA+ID4gPiA+ID4gPiBhYm92ZSB0d28g
Zmxhd2VkIGNvbW1pdHMsIHRoZW4gdGhpcyBmaXggcGF0Y2ggY2Fubm90IGJlIGFwcGxpZWQgY2xl
YW5seQ0KPiA+ID4gPiA+ID4gPiB0byB0aGUgcmVsZWFzZS4NCj4gPiA+ID4gPiA+IFRoZSBuVk1Y
IGNvZGUgaXNuJ3QgYnVnZ3ksIFZNWCBpbnN0cnVjdGlvbnMgI1VEIGluIGNvbXBhdGliaWxpdHkg
bW9kZSwgYW5kIGV4Y2VwdA0KPiA+ID4gPiA+ID4gZm9yIFZNQ0FMTCwgdGhhdCAjVUQgaGFzIGhp
Z2hlciBwcmlvcml0eSB0aGFuIFZNLUV4aXQgaW50ZXJjZXB0aW9uLiAgU28gSSdkIHNheQ0KPiA+
ID4gPiA+ID4ganVzdCBkcm9wIHRoZSBuVk1YIHNpZGUgb2YgdGhpbmdzLg0KPiA+ID4gPiA+IEJ1
dCBpdCBsb29rcyB0aGUgb2xkIGNvZGUgZG9lc24ndCB1bmNvbmRpdGlvbmFsbHkgaW5qZWN0ICNV
RCB3aGVuIGluDQo+ID4gPiA+ID4gY29tcGF0aWJpbGl0eSBtb2RlPw0KPiA+ID4gPiBJIHRoaW5r
IFNlYW4gbWVhbnMgVk1YIGluc3RydWN0aW9ucyBpcyBub3QgdmFsaWQgaW4gY29tcGF0aWJpbGl0
eSBtb2RlDQo+ID4gPiA+IGFuZCBpdCB0cmlnZ2VycyAjVUQsIHdoaWNoIGhhcyBoaWdoZXIgcHJp
b3JpdHkgdGhhbiBWTS1FeGl0LCBieSB0aGUNCj4gPiA+ID4gcHJvY2Vzc29yIGluIG5vbi1yb290
IG1vZGUuDQo+ID4gPiA+IA0KPiA+ID4gPiBTbyBpZiB0aGVyZSBpcyBhIFZNLUV4aXQgZHVlIHRv
IFZNWCBpbnN0cnVjdGlvbiAsIGl0IGlzIGluIDY0LWJpdCBtb2RlDQo+ID4gPiA+IGZvciBzdXJl
IGlmIGl0IGlzIGluIGxvbmcgbW9kZS4NCj4gPiA+IE9oIEkgc2VlIHRoYW5rcy4NCj4gPiA+IA0K
PiA+ID4gVGhlbiBpcyBpdCBiZXR0ZXIgdG8gYWRkIHNvbWUgY29tbWVudCB0byBleHBsYWluLCBv
ciBhZGQgYSBXQVJOKCkgaWYgaXQncyBub3QgaW4NCj4gPiA+IDY0LWJpdCBtb2RlPw0KPiA+IA0K
PiA+IEkgYWxzbyBwcmVmZXIgdG8gYWRkIGEgY29tbWVudCBpZiBubyBvYmplY3Rpb24uDQo+ID4g
DQo+ID4gU2VlbXMgSSBhbSBub3QgdGhlIG9ubHkgb25lIHdobyBkaWRuJ3QgZ2V0IGl0w6/Cv8K9
IDogKQ0KPiANCj4gSSB3b3VsZCByYXRoZXIgaGF2ZSBhIGNvZGUgY2hhbmdlIHRoYW4gYSBjb21t
ZW50LCBlLmcuIA0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMg
Yi9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jDQo+IGluZGV4IGY2M2IyOGY0NmE3MS4uMDQ2MGNh
MjE5Zjk2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jDQo+ICsrKyBi
L2FyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMNCj4gQEAgLTQ5MzEsNyArNDkzMSw4IEBAIGludCBn
ZXRfdm14X21lbV9hZGRyZXNzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdW5zaWduZWQgbG9uZyBl
eGl0X3F1YWxpZmljYXRpb24sDQo+ICAgICAgICAgaW50ICBiYXNlX3JlZyAgICAgICA9ICh2bXhf
aW5zdHJ1Y3Rpb25faW5mbyA+PiAyMykgJiAweGY7DQo+ICAgICAgICAgYm9vbCBiYXNlX2lzX3Zh
bGlkICA9ICEodm14X2luc3RydWN0aW9uX2luZm8gJiAoMXUgPDwgMjcpKTsNCj4gIA0KPiAtICAg
ICAgIGlmIChpc19yZWcpIHsNCj4gKyAgICAgICBpZiAoaXNfcmVnIHx8DQo+ICsgICAgICAgICAg
IFdBUk5fT05fT05DRShpc19sb25nX21vZGUodmNwdSkgJiYgIWlzXzY0X2JpdF9tb2RlKHZjcHUp
KSkgew0KPiAgICAgICAgICAgICAgICAga3ZtX3F1ZXVlX2V4Y2VwdGlvbih2Y3B1LCBVRF9WRUNU
T1IpOw0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIDE7DQo+ICAgICAgICAgfQ0KPiANCj4gDQoN
Ckxvb2tzIGdvb2QgdG8gbWUuDQoNCj4gVGhlIG9ubHkgZG93bnNpZGUgaXMgdGhhdCBxdWVyeWlu
ZyBpc182NF9iaXRfbW9kZSgpIGNvdWxkIHVubmVjZXNzYXJpbHkgdHJpZ2dlciBhDQo+IFZNUkVB
RCB0byBnZXQgdGhlIGN1cnJlbnQgQ1MuTCBiaXQsIGJ1dCBhIG1lYXN1cmFibGUgcGVyZm9ybWFu
Y2UgcmVncmVzc2lvbnMgaXMNCj4gZXh0cmVtZWx5IHVubGlrZWx5IGJlY2F1c2UgaXNfNjRfYml0
X21vZGUoKSBhbGwgYnV0IGd1YXJhbnRlZWQgdG8gYmUgY2FsbGVkIGluDQo+IHRoZXNlIHBhdGhz
IGFueXdheXMgKGFuZCBLVk0gY2FjaGVzIHNlZ21lbnQgaW5mbyksIGUuZy4gYnkga3ZtX3JlZ2lz
dGVyX3JlYWQoKS4NCg0KQWdyZWVkLg0KDQo+IA0KPiBBbmQgdGhlbiBpbiBhIGZvbGxvdy11cCwg
d2Ugc2hvdWxkIGFsc28gYmUgYWJsZSB0byBkbzoNCj4gDQo+IEBAIC01NDAyLDcgKzU0MDMsNyBA
QCBzdGF0aWMgaW50IGhhbmRsZV92bXJlYWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgICAg
ICAgIGlmIChpbnN0cl9pbmZvICYgQklUKDEwKSkgew0KPiAgICAgICAgICAgICAgICAga3ZtX3Jl
Z2lzdGVyX3dyaXRlKHZjcHUsICgoKGluc3RyX2luZm8pID4+IDMpICYgMHhmKSwgdmFsdWUpOw0K
PiAgICAgICAgIH0gZWxzZSB7DQo+IC0gICAgICAgICAgICAgICBsZW4gPSBpc182NF9iaXRfbW9k
ZSh2Y3B1KSA/IDggOiA0Ow0KPiArICAgICAgICAgICAgICAgbGVuID0gaXNfbG9uZ19tb2RlKHZj
cHUpID8gOCA6IDQ7DQo+ICAgICAgICAgICAgICAgICBpZiAoZ2V0X3ZteF9tZW1fYWRkcmVzcyh2
Y3B1LCBleGl0X3F1YWxpZmljYXRpb24sDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBpbnN0cl9pbmZvLCB0cnVlLCBsZW4sICZndmEpKQ0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gMTsNCj4gQEAgLTU0NzYsNyArNTQ3Nyw3IEBAIHN0YXRpYyBpbnQg
aGFuZGxlX3Ztd3JpdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgICAgICAgIGlmIChpbnN0
cl9pbmZvICYgQklUKDEwKSkNCj4gICAgICAgICAgICAgICAgIHZhbHVlID0ga3ZtX3JlZ2lzdGVy
X3JlYWQodmNwdSwgKCgoaW5zdHJfaW5mbykgPj4gMykgJiAweGYpKTsNCj4gICAgICAgICBlbHNl
IHsNCj4gLSAgICAgICAgICAgICAgIGxlbiA9IGlzXzY0X2JpdF9tb2RlKHZjcHUpID8gOCA6IDQ7
DQo+ICsgICAgICAgICAgICAgICBsZW4gPSBpc19sb25nX21vZGUodmNwdSkgPyA4IDogNDsNCj4g
ICAgICAgICAgICAgICAgIGlmIChnZXRfdm14X21lbV9hZGRyZXNzKHZjcHUsIGV4aXRfcXVhbGlm
aWNhdGlvbiwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGluc3Ry
X2luZm8sIGZhbHNlLCBsZW4sICZndmEpKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICByZXR1
cm4gMTsNCj4gDQoNClllYWgsIGFsdGhvdWdoIGl0J3MgYSBsaXR0bGUgYml0IHdpcmVkIHRoZSBh
Y3R1YWwgV0FSTigpIGhhcHBlbnMgYWZ0ZXIgYWJvdmUNCmNvZGUgY2hhbmdlLiAgQnV0IEkgZG9u
J3Qga25vdyBob3cgdG8gbWFrZSB0aGUgY29kZSBiZXR0ZXIuICBNYXliZSB3ZSBzaG91bGQgcHV0
DQp0aGUgV0FSTigpIGF0IHRoZSB2ZXJ5IGJlZ2lubmluZyBidXQgdGhpcyB3b3VsZCByZXF1aXJl
IGR1cGxpY2F0ZWQgY29kZSBpbiBlYWNoDQpoYW5kbGVfeHh4KCkgZm9yIFZNWCBpbnN0cnVjdGlv
bnMuDQo=
