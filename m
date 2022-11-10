Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8BA6240AB
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 12:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiKJLEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 06:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiKJLEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 06:04:34 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0804D6DCC2;
        Thu, 10 Nov 2022 03:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668078273; x=1699614273;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2Hg2p5FyJjDqt0selGz8htEExiF74kGar/51m3ennlw=;
  b=gZcePp9n4QXs7PIo2qiTFVIBQ59KeTKg4MxbnMD02v7Y+wqdyL3VoKKn
   fQWRAX9JamxDs49ofCO04oMiLR4bnBMU2FnIB2ebPCmawzcBcKdtywC2I
   RC9K75Nz2DuzWoTLdZC4z4BHEu9s2yEPumTVmoL3Es81yM36vHe7GdVIT
   qpjrE+KF9VMKgWiV2d+yhWQ0YubsYdcRnfAu8iQ9FHTlWjHOlYulmptZl
   CcSlxdW96bRHL2NWzLJ2drde6kOSx6mLBD9C9o8fBMTdpnBxFVSw3M0PI
   ErsE+NENbWbl+Niq50Y8kpHF8Stch1mB28XctqyJFYlHT8TqdkF8SkQwW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="312415128"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="312415128"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 03:04:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="811999626"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="811999626"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2022 03:04:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 03:04:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 03:04:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 03:04:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4bkVPF6zV3LIsr07lMb2tMANBJ5qpsxZ14JEyUdrujs5EY5kFOWXdFSw/A/QZap2sB/UXzDUBGY0hoc88Zw/jbUMEC30IXz3097TpcBIqiEi5g2NvxecEzim7OzLwHbwvEyVh63iUg4U+lHSviS/V98vZBD0rEbvNQ3j3wRIKeG4bjag6+iDScO8F2mdASfDl0LSLyd5eLwwwmKn8mlAigPjBQOv46AlpSrQzZCsTxjcwiBrN3oFta5+324BsGY3uoJWcdjncYnUOifKE9oTAyOJPwYx73d2pkE4eyBbXPggqWHZglBEi2DPNlTCZelcOccOjPjSgntoCuVxWCiBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Hg2p5FyJjDqt0selGz8htEExiF74kGar/51m3ennlw=;
 b=RCReOiuwxPkhEg2Be1MgJoXJGOSCOnKbGogtf4L3Sse9rCfNRZ/ebPq1uvVfY9Zhqn/2wBgQyuSTQWrqlU0UnGsNDQ244lgMRVq++EzQIblsaGZTjTjm4q2b+0g/MuHoaIpZ+w+wGYm+1+ncr2u1KeltrXmUldVCfo9GOY6e0gVq/oByXUjRar5Kd92w0q60Q5Xc8l6mfdZTVAPKTGkNFwSwPwvZNtlrhxiC6tgb5si40NiPfk49O3FnME3xrCNJtSxgQRdqwiq2MY4KHFxqG1uMEfbDEIMEB8u9LvAFliJKyG/UiQGXGacX0CWyJPMMOWEB4y3jZin3w5bae9QXfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6502.namprd11.prod.outlook.com (2603:10b6:8:89::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Thu, 10 Nov 2022 11:04:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 11:04:25 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
Thread-Index: AQHY7Cg0fNKRCf/kl0i/60xxQWvSTK44EBEA
Date:   Thu, 10 Nov 2022 11:04:25 +0000
Message-ID: <c3deef412933070932f565af8639d15aef00ea1c.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6502:EE_
x-ms-office365-filtering-correlation-id: 6f735590-6738-4d1b-b600-08dac30b5495
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qV04yIWYLcPGONhXPRQIh1d06lOEr3BVbs9M5mBnBnNWjVtRD7o+d0/V8CMMaBAdY2Ygp9FIpfs4CzNow3/7+DETBhNawirasZfAbFV0T1LtKRxwPS5+lSvYRnHPgb/s9xddP/6I7xuw/LCgVVNbvKA1DxNQOJ/a0pAg6d05K02XVXJlmC7RVi4IjZvOyCsNF9TAqlP7FoSfXMgUf5YvpKwQvJ3AzkHyfvan6+s04FTbo/neWD+xPXk15czFR6np0rqKCSwWqDKYaOIWWJZ9mfBpVeSXG98mqPHs4h5M7EjYTqpicDvjiKO+xflXZM3PX+vHnLv+n6yv8vU29Kzdz9CG2nrGqRZipvVbqx46B4ibSbmZW7jjqteL525OMqMJqmFJ1IP8xSNhRmGq93/v8PgRws56ZLQSAmPFrkErJZ4e0DaGht1yqFhYxSLnYFmla0Nft1Q7ttf1d9l9SLJYg0n/U1VRN3eUChWnFZoN0pewEICgWFhH4soi6Z4BAYnOMQJHlkw09gXsDIPo38h8Gin1qc2tfFoQia1Fm7v0uXZKtB6rbfeuxsubs61Xxae5QgHcACqzzsQa0hf6nqkOpUvlTwqbQ0qWphhPDdUXxhmancZuMoVk9LPHu7Ocqy2yrMqT3Gn5tb0pOtlSwysSS2eROoKmoGmHZy4/bhnxB1GMaU66bGk3BakAq/KaRFUGena7nCynyz+Bz5gVuietrtvqWNBcC9qc9mcPVpjrWwoGmJ65fBvT6YqdOxaJkYAwrqWTiN4FKlIyexiGbLA/Bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199015)(71200400001)(6486002)(478600001)(6636002)(54906003)(110136005)(64756008)(66446008)(8676002)(6512007)(2906002)(4001150100001)(4326008)(66556008)(38070700005)(316002)(26005)(66946007)(66476007)(91956017)(76116006)(41300700001)(6506007)(2616005)(36756003)(186003)(8936002)(5660300002)(122000001)(82960400001)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUhtejRONzF0bVRjTjZ3VzFaMXdHaVQ3azlHQnVQOTlCQ0pTY2hybmZrcmVM?=
 =?utf-8?B?d3ZEdjJjdXdFQ3hZVXFNQjlsWTlCWHZ3NGF0TWJjd3VvcW9MY3lWbEtrOHNM?=
 =?utf-8?B?bkx2c3p0UFJGWUxwdGxtc0hyaVVkKzRuTms4dVN3L3ZSZk1QSzBpOVd2MklR?=
 =?utf-8?B?ZU9WUllGR2liL2lZa1R4WjZaclRsdmZ4YXhBR1JmYXlzWXlCQ3BURFpmZWdF?=
 =?utf-8?B?QkJPNE1NWmU5TDhwQ1JVZGRHVmFQL1JYenVzek03TVRmdTcrYi9MdDEya01l?=
 =?utf-8?B?MFJCOTZOZEdTOFd3Wm5tQk0yRlBtUTc0T2RRWVhzZUUwTnB5V2tnWXNHYy9L?=
 =?utf-8?B?YXRGSm9sUUovNWo2RXhpUlVKSVlEcEJqY3drdHFJay9pTnVVOW43Rm1xcWNM?=
 =?utf-8?B?cE1uNlJBZVh3QVc5amJXK2lRT3g0L3hHa2o1SmltMzE3aXlaOG1KTWdCZG05?=
 =?utf-8?B?Qm0wU3Q5ajZoNXdxbUdkWjJWK0I5TzI5Tys2dUp0aWF1NGtuaHBzY0lkdUh3?=
 =?utf-8?B?UlExVGwwVU5iSzFOYkpVMDVKY3IrdDRyRFlzT0gvbUpCVjlBQmJjMmJXM1k5?=
 =?utf-8?B?TUJLUzRyUFZTcm84aU13MkRoM3VtU1luUXdyWk9Dd0dTeDR1cDZaMkhDK1pJ?=
 =?utf-8?B?blloc0JBLzA0WmR3QS90anVkcU5yRTl3NktRdnpCWk5VYWxtQ29zdXlMd2F5?=
 =?utf-8?B?MUVwK2ZtY3h4L1FzNXBCaFhxSFpUSVVHQWhNN2E2M0xCSXdsU0orQmlRNzdN?=
 =?utf-8?B?eTZaZkUyMEF0MkNnbDIyZnMyejR6SkNpOHhjVmUveEwydElrWUdSSUQ3SGV0?=
 =?utf-8?B?WXdwUURiK3hqazRyNGdQYjBpVlVFazdEbXdCdlZ1N0VSaHdJdUNoN2J6d0JY?=
 =?utf-8?B?NmNpT3ptWWxKc0NLZVJYVERLb2pEOG11U1JKeVkrckRHNWNGQ2NJWTc5M2g3?=
 =?utf-8?B?cHFNNGlBTTh3NlMxcVp5VHE0ai9PNnV4MXFtZTZ3VlJ5bEYyVmdGMEMreU9m?=
 =?utf-8?B?N3hDVE1UVWJJeTJtd3hqTTFuaHNrZ0h1WndZL3dGMFNwZnk4TkxzRkU0N25m?=
 =?utf-8?B?WVlYb1c2dnQxaGRxR1dHdk1TeUY2ckRFMEVWV1NzMjRuTkVGejdXOGtKMklo?=
 =?utf-8?B?OUM5NEwyT2xkMnlzOVRkeHpXS0lyMEhta3ppUHZ3U3VxNzQ4TnRaZk0zZ213?=
 =?utf-8?B?N2hSdjU1OWV6QVRoY2thUXUvdm9Qc0V0ZmpGd2hscnYxbGhuRTA1bk5GeFA5?=
 =?utf-8?B?bHVxSmpHUGlmcnpuWS9teXBSZ3VHdzFURHd0bExxelVLTENhUjV1aE5IRjF0?=
 =?utf-8?B?N05rTVNDYTFuK3ZyNXdnU2Q4dU82dXNJNUt3MGR3cWZhc3B0ZEZUREdSUThS?=
 =?utf-8?B?U3VCZjh4blR5WVJyd29kcXRaQlFZMVFXYjJMbk5aZ1F1cWZJV0dNVXNxa21s?=
 =?utf-8?B?WE9IK3JXU1UxS1dFbWJVMzY1ejRqcFR4WURQSC9teWRBY0owZllZdkpwY0tv?=
 =?utf-8?B?MW1SZjJmTUdaTDRJWW9VNWo1TmNuZ0tKR0I3VG5mWmNlYWY2bkFZWkpBeDAr?=
 =?utf-8?B?OGQ3bGJ2Q1ZvMjZvdGI4US9wM251cFBXeVRMY2VCS0thb0RTZTA3TSszV3NX?=
 =?utf-8?B?TFR3MVJ4RjBrZi9hRVJIazJTY05wZDZocTBhc1JJNzNyRFNoeFlmMG13aWdF?=
 =?utf-8?B?UU14WGtJZDl3bFFtSTF2bWVGYVRFb3d2THFuZHBQS1J0dTBnV1o0UW5mWWN2?=
 =?utf-8?B?K0hsV2xqWG9rTUZjT0tMZDI1Q0VBNG1EcnlOWEhsTHJCTURDZm02YjZLdVVS?=
 =?utf-8?B?M2tRRjRJLzIyZ3Nmb0ZqVWx4d3B4VWhCUjc2WUpPNTQ3L2ZtV3NCZkVOOWFH?=
 =?utf-8?B?bWhjOVNzZExqdkY4Tm91d2R4UGxsQ3ZaOGRyRzBZcS85WjJjNlErTlc0N1dQ?=
 =?utf-8?B?YVlVQnhxU1NqQXVwQzhLU0I2SUNhYkZGR1BhbnhrYTIwZlR3Qms1WW9GUWRV?=
 =?utf-8?B?SVp6dnJKQ1gvL1JMTWFNeG55aytFM2x2K0hkcnh0OEJvYnBDbWV2dzNKZkJm?=
 =?utf-8?B?UGZnWlZKanZ6cWxIb3JRd0ZDdHZoalJGeUU2QUwvYVRBQmUwOStSQVhtUFRr?=
 =?utf-8?B?K2JGQ3l2d0xZaGFOMXMwMHdlb0NLZzRVK0VkbVdudDluQ0dKNGFraGZCZ3du?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CD60F52A0C5974A97444FCB4FA353E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f735590-6738-4d1b-b600-08dac30b5495
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 11:04:25.7031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e04cRtqdApcoTys2l5NKEs2atT5Cp4npLAv+idndtccEZaI6FOC7zcGj5FSrvqcNc2CUwLz0iVL9wW7kczoFmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6502
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ID4gRnJvbTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9w
aGVyc29uQGludGVsLmNvbT4NCj4gPiANCj4gPiBBcyB0aGUgZmlyc3Qgc3RlcCB0byBjcmVhdGUg
VERYIGd1ZXN0LCBjcmVhdGUvZGVzdHJveSBWTSBzdHJ1Y3QuICBBc3NpZ24NCj4gPiBURFggcHJp
dmF0ZSBIb3N0IEtleSBJRCAoSEtJRCkgdG8gdGhlIFREWCBndWVzdCBmb3IgbWVtb3J5IGVuY3J5
cHRpb24gYW5kDQo+ID4gYWxsb2NhdGUgZXh0cmEgcGFnZXMgZm9yIHRoZSBURFggZ3Vlc3QuIE9u
IGRlc3RydWN0aW9uLCBmcmVlIGFsbG9jYXRlZA0KPiA+IHBhZ2VzLCBhbmQgSEtJRC4NCj4gPiAN
Cj4gPiBCZWZvcmUgdGVhcmluZyBkb3duIHByaXZhdGUgcGFnZSB0YWJsZXMsIFREWCByZXF1aXJl
cyBzb21lIHJlc291cmNlcyBvZiB0aGUNCj4gPiBndWVzdCBURCB0byBiZSBkZXN0cm95ZWQgKGku
ZS4ga2V5SUQgbXVzdCBoYXZlIGJlZW4gcmVjbGFpbWVkLCBldGMpLiAgQWRkDQoJCQkJIF4NCgkJ
CQkgSEtJRA0KDQpJdCdzIGJldHRlciB0byB1c2UgY29uc2lzdGVudCB3b3JkcyB0aHJvdWdob3V0
IHBhdGNoL3NlcmllcyBJIGd1ZXNzLg0KDQo+ID4gZmx1c2hfc2hhZG93X2FsbF9wcml2YXRlIGNh
bGxiYWNrIGJlZm9yZSB0ZWFyaW5nIGRvd24gcHJpdmF0ZSBwYWdlIHRhYmxlcw0KPiA+IGZvciBp
dC4NCj4gPiANCj4gPiBBZGQgYSBzZWNvbmQga3ZtX3g4Nl9vcHMgaG9vayBpbiBrdm1fYXJjaF9k
ZXN0cm95X3ZtKCkgdG8gc3VwcG9ydCBURFgncw0KPiA+IGRlc3RydWN0aW9uIHBhdGgsIHdoaWNo
IG5lZWRzIHRvIGZpcnN0IHB1dCB0aGUgVk0gaW50byBhIHRlYXJkb3duIHN0YXRlLA0KPiA+IHRo
ZW4gZnJlZSBwZXItdkNQVSByZXNvdXJjZXMsIGFuZCBmaW5hbGx5IGZyZWUgcGVyLVZNIHJlc291
cmNlcy4NCg0KUGVyaGFwcyBleHBsaWNpdGx5IGNhbGwgb3V0IHRoZSBob29rIGlzIHZtX2ZyZWUo
KSBhbmQgd2h5IHRoZSBleGlzdGluZw0Kdm1fZGVzdHJveSgpIGhvb2sgY2Fubm90IG1lZXQgVERY
J3MgcHVycG9zZSwgc28gdGhhdCBwZW9wbGUgY2FuIHVuZGVyc3RhbmQNCmVhc2lseSB3aHkgeW91
IG5lZWQgdm1fZnJlZSgpLg0KDQpbLi4uXQ0KDQo+ID4gK3N0YXRpYyBpbmxpbmUgdm9pZCB0ZHhf
aGtpZF9mcmVlKHN0cnVjdCBrdm1fdGR4ICprdm1fdGR4KQ0KPiA+ICt7DQo+ID4gKwl0ZHhfa2V5
aWRfZnJlZShrdm1fdGR4LT5oa2lkKTsNCj4gPiArCWt2bV90ZHgtPmhraWQgPSAtMTsNCg0KV2h5
IC0xPyBDYW4gaXQgYmUgc2V0IHRvIDAsIHdoaWNoIGlzIHRoZSBpbml0aWFsIHZhbHVlIHdoZW4g
a3ZtX3RkeCBpcyBhbGxvY2F0ZWQNCmFueXdheT8NCg0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0
aWMgaW5saW5lIGJvb2wgaXNfaGtpZF9hc3NpZ25lZChzdHJ1Y3Qga3ZtX3RkeCAqa3ZtX3RkeCkN
Cj4gPiArew0KPiA+ICsJcmV0dXJuIGt2bV90ZHgtPmhraWQgPiAwOw0KPiA+ICt9DQo+ID4gKw0K
PiA+ICtzdGF0aWMgdm9pZCB0ZHhfY2xlYXJfcGFnZSh1bnNpZ25lZCBsb25nIHBhZ2UpDQo+ID4g
K3sNCj4gPiArCWNvbnN0IHZvaWQgKnplcm9fcGFnZSA9IChjb25zdCB2b2lkICopIF9fdmEocGFn
ZV90b19waHlzKFpFUk9fUEFHRSgwKSkpOw0KPiA+ICsJdW5zaWduZWQgbG9uZyBpOw0KPiA+ICsN
Cj4gPiArCS8qDQo+ID4gKwkgKiBaZXJvaW5nIHRoZSBwYWdlIGlzIG9ubHkgbmVjZXNzYXJ5IGZv
ciBzeXN0ZW1zIHdpdGggTUtUTUUtaToNCj4gPiArCSAqIHdoZW4gcmUtYXNzaWduIG9uZSBwYWdl
IGZyb20gb2xkIGtleWlkIHRvIGEgbmV3IGtleWlkLCBNT1ZESVI2NEIgaXMNCj4gPiArCSAqIHJl
cXVpcmVkIHRvIGNsZWFyL3dyaXRlIHRoZSBwYWdlIHdpdGggbmV3IGtleWlkIHRvIHByZXZlbnQg
aW50ZWdyaXR5DQo+ID4gKwkgKiBlcnJvciB3aGVuIHJlYWQgb24gdGhlIHBhZ2Ugd2l0aCBuZXcg
a2V5aWQuDQo+ID4gKwkgKg0KPiA+ICsJICogVGhlIGNhY2hlIGxpbmUgY291bGQgYmUgcG9pc29u
ZWQgKGV2ZW4gd2l0aG91dCBNS1RNRS1pKSwgY2xlYXIgdGhlDQo+ID4gKwkgKiBwb2lzb24gYml0
Lg0KDQpEb2VzIHRoaXMgaGFwcGVuIG9ubHkgd2hlbiB0aGVyZSdzIHBvdGVudGlhbCBrZXJuZWwg
YnVnPw0KDQo+ID4gKwkgKi8NCj4gPiArCWZvciAoaSA9IDA7IGkgPCBQQUdFX1NJWkU7IGkgKz0g
NjQpDQo+ID4gKwkJbW92ZGlyNjRiKCh2b2lkICopKHBhZ2UgKyBpKSwgemVyb19wYWdlKTsNCj4g
PiArCS8qDQo+ID4gKwkgKiBNT1ZESVI2NEIgc3RvcmUgdXNlcyBXQyBidWZmZXIuICBQcmV2ZW50
IGZvbGxvd2luZyBtZW1vcnkgcmVhZHMNCj4gPiArCSAqIGZyb20gc2VlaW5nIHBvdGVudGlhbGx5
IHBvaXNvbmVkIGNhY2hlLg0KPiA+ICsJICovDQo+ID4gKwlfX21iKCk7DQo+ID4gK30NCj4gPiAr
DQo+ID4gK3N0YXRpYyBpbnQgdGR4X3JlY2xhaW1fcGFnZSh1bnNpZ25lZCBsb25nIHZhLCBocGFf
dCBwYSwgYm9vbCBkb193YiwgdTE2IGhraWQpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB0ZHhfbW9k
dWxlX291dHB1dCBvdXQ7DQo+ID4gKwl1NjQgZXJyOw0KPiA+ICsNCj4gPiArCWRvIHsNCj4gPiAr
CQllcnIgPSB0ZGhfcGh5bWVtX3BhZ2VfcmVjbGFpbShwYSwgJm91dCk7DQo+ID4gKwkJLyoNCj4g
PiArCQkgKiBUREguUEhZTUVNLlBBR0UuUkVDTEFJTSBpcyBhbGxvd2VkIG9ubHkgd2hlbiBURCBp
cyBzaHV0ZG93bi4NCj4gPiArCQkgKiBzdGF0ZS4gIGkuZS4gZGVzdHJ1Y3RpbmcgVEQuDQo+ID4g
KwkJICogVERILlBIWU1FTS5QQUdFLlJFQ0xBSU0gIHJlcXVpcmVzIFREUiBhbmQgdGFyZ2V0IHBh
Z2UuDQo+ID4gKwkJICogQmVjYXVzZSB3ZSdyZSBkZXN0cnVjdGluZyBURCwgaXQncyByYXJlIHRv
IGNvbnRlbmQgd2l0aCBURFIuDQo+ID4gKwkJICovDQo+ID4gKwl9IHdoaWxlIChlcnIgPT0gKFRE
WF9PUEVSQU5EX0JVU1kgfCBURFhfT1BFUkFORF9JRF9SQ1gpKTsNCj4gPiArCWlmIChXQVJOX09O
X09OQ0UoZXJyKSkgew0KPiA+ICsJCXByX3RkeF9lcnJvcihUREhfUEhZTUVNX1BBR0VfUkVDTEFJ
TSwgZXJyLCAmb3V0KTsNCj4gPiArCQlyZXR1cm4gLUVJTzsNCj4gPiArCX0NCj4gPiArDQo+ID4g
KwlpZiAoZG9fd2IpIHsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIE9ubHkgVERSIHBhZ2UgZ2V0cyBp
bnRvIHRoaXMgcGF0aC4gIE5vIGNvbnRlbnRpb24gaXMgZXhwZWN0ZWQNCj4gPiArCQkgKiBiZWNh
dXNlIHRoZSBsYXN0IHBhZ2Ugb2YgVEQuDQo+ID4gKwkJICovDQo+ID4gKwkJZXJyID0gdGRoX3Bo
eW1lbV9wYWdlX3diaW52ZChzZXRfaGtpZF90b19ocGEocGEsIGhraWQpKTsNCj4gPiArCQlpZiAo
V0FSTl9PTl9PTkNFKGVycikpIHsNCj4gPiArCQkJcHJfdGR4X2Vycm9yKFRESF9QSFlNRU1fUEFH
RV9XQklOVkQsIGVyciwgTlVMTCk7DQo+ID4gKwkJCXJldHVybiAtRUlPOw0KPiA+ICsJCX0NCj4g
PiArCX0NCj4gPiArDQo+ID4gKwl0ZHhfY2xlYXJfcGFnZSh2YSk7DQo+ID4gKwlyZXR1cm4gMDsN
Cj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCB0ZHhfYWxsb2NfdGRfcGFnZShzdHJ1Y3Qg
dGR4X3RkX3BhZ2UgKnBhZ2UpDQo+ID4gK3sNCj4gPiArCXBhZ2UtPnZhID0gX19nZXRfZnJlZV9w
YWdlKEdGUF9LRVJORUxfQUNDT1VOVCk7DQo+ID4gKwlpZiAoIXBhZ2UtPnZhKQ0KPiA+ICsJCXJl
dHVybiAtRU5PTUVNOw0KPiA+ICsNCj4gPiArCXBhZ2UtPnBhID0gX19wYShwYWdlLT52YSk7DQo+
ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGlubGluZSB2b2lkIHRk
eF9tYXJrX3RkX3BhZ2VfYWRkZWQoc3RydWN0IHRkeF90ZF9wYWdlICpwYWdlKQ0KPiA+ICt7DQo+
ID4gKwlXQVJOX09OX09OQ0UocGFnZS0+YWRkZWQpOw0KPiA+ICsJcGFnZS0+YWRkZWQgPSB0cnVl
Ow0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCB0ZHhfcmVjbGFpbV90ZF9wYWdlKHN0
cnVjdCB0ZHhfdGRfcGFnZSAqcGFnZSkNCj4gPiArew0KPiA+ICsJaWYgKHBhZ2UtPmFkZGVkKSB7
DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBURENYIGFyZSBiZWluZyByZWNsYWltZWQuICBURFggbW9k
dWxlIG1hcHMgVERDWCB3aXRoIEhLSUQNCj4gPiArCQkgKiBhc3NpZ25lZCB0byB0aGUgVEQuICBI
ZXJlIHRoZSBjYWNoZSBhc3NvY2lhdGVkIHRvIHRoZSBURA0KPiA+ICsJCSAqIHdhcyBhbHJlYWR5
IGZsdXNoZWQgYnkgVERILlBIWU1FTS5DQUNIRS5XQiBiZWZvcmUgaGVyZSwgU28NCj4gPiArCQkg
KiBjYWNoZSBkb2Vzbid0IG5lZWQgdG8gYmUgZmx1c2hlZCBhZ2Fpbi4NCj4gPiArCQkgKi8NCj4g
PiArCQlpZiAodGR4X3JlY2xhaW1fcGFnZShwYWdlLT52YSwgcGFnZS0+cGEsIGZhbHNlLCAwKSkN
Cj4gPiArCQkJcmV0dXJuOw0KPiA+ICsNCj4gPiArCQlwYWdlLT5hZGRlZCA9IGZhbHNlOw0KPiA+
ICsJfQ0KPiA+ICsJaWYgKHBhZ2UtPnZhKSB7DQo+ID4gKwkJZnJlZV9wYWdlKHBhZ2UtPnZhKTsN
Cj4gPiArCQlwYWdlLT52YSA9IDA7DQo+ID4gKwl9DQo+ID4gK30NCj4gPiArDQoNCg0KSSBhbSB3
b25kZXJpbmcgd2h5IHRoaXMgJ3N0cnVjdCB0ZHhfdGRfcGFnZScgaXMgbmVlZGVkPw0KDQpJdCBh
cHBlYXJzIHRoZSBwYWdlLT5wYSBpcyB1c2VkIGJ5IFNFQU1DQUxMcyBhbmQgcGFnZS0+dmEgaXMg
dXNlZCBieQ0KdGR4X2NsZWFyX3BhZ2UoKSBhcyBNT1ZESVI2NEIgbmVlZHMgYSB2aXJ0dWFsIGFk
ZHJlc3MuDQoNCkJ1dCBzaW5jZSBHRlBfS0VSTkVMX0FDQ09VTlQgaXMgdXNlZCBpbiBtZW1vcnkg
YWxsb2NhdGlvbiwgc28geW91IGNhbiBhY3R1YWxseQ0KanVzdCBnZXQgdGhlIHBhIGFuZCB2YSBm
cm9tIHRoZSBwYWdlIGVhc2lseSAodXNpbmcgcGFnZV90b19waHlzKCkgYW5kIF9fdmEoKSkuDQpB
bHNvIGl0J3MgNjQtYml0IGtlcm5lbCBzbyB5b3UgZG9uJ3QgZXZlbiBuZWVkIHRvIGNvbnNpZGVy
IEhJR0hNRU0uDQoNCkFsc28sIGl0IHNlZW1zIHBhZ2UtPmFkZGVkIGNhbiBiZSByZXBsYWNlZCB3
aXRoIHNpbXBseSBjaGVja2luZyB3aGV0aGVyIHBhZ2UgaXMNCk5VTEwsIGNvcnJlY3Q/DQoNCkJ0
dywgSSB0aGluayB0aGUgaW50cm9kdWNlIG9mICdzdHJ1Y3QgdGR4X3RkX3BhZ2UnIGFuZCB0aGUg
bmV3ICdzdHJ1Y3QNCnRkeF90ZF9wYWdlIHRkcicgdG8gJ3N0cnVjdCBrdm1fdGR4JyBzaG91bGQg
Y29tZSB0b2dldGhlciB3aXRoIHRoaXMgcGF0Y2gsIGJ1dA0Kbm90IGluIHRoZSBwcmV2aW91cyBw
YXRjaCAiS1ZNOiBURFg6IFN0dWIgaW4gdGR4Lmggd2l0aCBzdHJ1Y3RzLCBhY2Nlc3NvcnMsIGFu
ZA0KVk1DUyBoZWxwZXJzIi4gVGhpcyBtYWtlcyB0aGUgY29kZSByZXZpZXcgZWFzaWVyLg0KDQpU
aGUgImFjY2Vzc29ycyIgY2FuIGJlIGludHJvZHVjZWQgaW4gbGF0ZXIgcGF0Y2ggd2hlbiB0aGV5
IGFyZSBuZWVkZWQgLS0gaXQNCmRvZXNuJ3Qgc2VlbSBhbnkgb2YgdGhlbSBpcyB1c2VkIGluIHRo
aXMgcGF0Y2g/DQoNCg0K
