Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3427355F5
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 13:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjFSLh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 07:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjFSLh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 07:37:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5878ABF;
        Mon, 19 Jun 2023 04:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687174647; x=1718710647;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yDMEisa67oZffL5f6mOl/PdiU9B1jUJcdfEwROQA3HU=;
  b=SGYCHTstiTtaFbMrSqN1JU+rSuyjHqqOHxtDWCDaqDI74IM9fwhXBa83
   v5hxENjPSYnbSdT9fs2lQdYPYkHMpzhJUJeMZPrCp0maR5tPKHeHavuID
   1oexK7fSUm8KLRr7hTf3xo1y75WipmXd/jjKcN/YcttMR7PE7oRaQCICp
   kToN6iCQRNTTovd8NjHO7QwMyVSJ4AqDohw3i9FyhyjU/+VteQtI2CeMN
   6scuSF7/OCnVCSCAoLHSEA4u97lCueZ8IF0NoVPD8tVkQ9dWIhKwWSU1s
   lHU9T/FisNj/0i4d925+Ytaneq7u6txnPVobOlWEcn3wxSozpHukq+kQm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="344354852"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="344354852"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 04:37:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="743424616"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="743424616"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 19 Jun 2023 04:37:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 04:37:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 04:37:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 04:37:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFAWK0VYwdbKJTpDjIL+KjOaavw2//nS2igLkBTq6ko5Vl4Jch3Ti6HP2OCe38aCO+t36ixwvSK1XVek1o9sspwo8ctVGdEpV2NTidoE+h/doR0bAqwlqY1Vn4EdIur37pAfOEYl9vda8sZPIzZsc0Wblwexb5DrHEnVRMqK9Jz+0Ai2sIlN08aHdsyJc5oCl8uBhV8+laNxOnhRGy3GBrp9z1lWnUK67J9W3E/e3DIKGMntO2yfNM0JIj7lA7zgU7Ug0GS5yyIwElcX2gw9oT3nHTiedoMmz00lmieTukl/aWEtbSkfw5rNM/0Y72H8jZV0jCHIanCpEBqkJr4YLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDMEisa67oZffL5f6mOl/PdiU9B1jUJcdfEwROQA3HU=;
 b=VEzn15tmDKVC6m5r7ZGor6FEKmItE1t4DxtfP1KUQ0eagF2NGUsOVV73b0aUgvu5lH10YIU1XsjryQ7/vZejj3tnCLnEHzry9uXUxbN3nT8Ur5TJ5LhefwUMfkJcAtPPNgzPc+5itbGSPqsMCMA8PFY+W4xhkLJt6dgaqyeXwtNlHydbdosvmpd7G5MmJYAG87j+7DZF5FV3W7h5cz26x6Kqq8X+5kiZlxg7ynuZlWfj92C3wZb/tS8YpHKOViQxB9Y5T6CZoeesi7+d0LaoKftqWtU6UcFeBXI0MeHQ42R4KhsENrwy8DBsKyflKxCVTV7NocHAnn1YrvrnYCNzsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5524.namprd11.prod.outlook.com (2603:10b6:610:d7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 11:37:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 11:37:22 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
Thread-Topic: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine
 check erratum
Thread-Index: AQHZlu+rViPY+CkNoE2o6SSiJzjZxK9/Z0QAgACNrwCAEiH8gA==
Date:   Mon, 19 Jun 2023 11:37:21 +0000
Message-ID: <15a06a50557335e0bbdb5edf228de6f8acb13513.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
         <bf797bc6-e264-02b0-12ee-c2ebf7c92d22@intel.com>
         <9cb242a0f5a6638770753b24ebd09e09ca047766.camel@intel.com>
In-Reply-To: <9cb242a0f5a6638770753b24ebd09e09ca047766.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5524:EE_
x-ms-office365-filtering-correlation-id: 3160c11c-3c3e-41e1-67da-08db70b98bc4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sKukUN6ox+//ke8s7hH6SH0QStgQpl2HTx/oopi3318GPaGYbZ5EbuFAoPvlRDvCAg2hvCe9Ntb+3L9UpTDYNjUyVneQd4/6Vgdmd+cektIRPWaHniAjkzZxBdlMN80nrX0JLi7+X3RrkAABTBT5XTj6JOZ+tSmRNDT7h3EtdvL9Zz7dU3GQc1oyPmcRKhU1f3GP8hdyTKmxveGeMtWO6jCvrGOL5K3fBiHcsyRaeuTe1IiQzGJVZw3dCFp2ahu9T/OQSrvkeMs3biFuj5BLq9FSJocwv3lUxPwzqKIXcajOA5k7PsvJESruRNN+M+wSYyCzRaF7HP+pfKJJ8eCKiZEGd5BVJ7w1ZfceEdNIUxpO/hmaYoKy+FXeiiCNA40IA6Ey7mAwzwyJH8U9aEzwai9dGsYHp942jDEMf44VMQ3mXv0mYA1sZYPtGX3j3vRE7oQ/NwD0X5wWAdQ8EG4DNqWi00ycfwgx33GBdjAZRCLV7FDAQO9yjJjKrXQhWK7Y5nbsl/ZQ6u/w/4eRv+I09/PDrMjpd9VaaYOy1QJhx+c63uCOIAGl2F6WRTDmXkJwnUferMP/isEkz2ZUV2k+Nw30r+MWntjNkHGg+XgvxL5A/oqsIkZGuQR75mISvbe8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199021)(41300700001)(5660300002)(7416002)(8936002)(8676002)(2906002)(38070700005)(36756003)(86362001)(53546011)(478600001)(26005)(6506007)(6512007)(54906003)(110136005)(186003)(71200400001)(6486002)(122000001)(64756008)(76116006)(66946007)(66556008)(66446008)(66476007)(91956017)(4326008)(38100700002)(316002)(82960400001)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzRRdGJlSkhTdERibFloMVp5WEFUbnlLN245STYzSEh2WWx6amNDY2EvWWNM?=
 =?utf-8?B?cnIxcEZidmRRdlRudmlVNmNTOGloeUh0RjBTSlZOQzk1MWVBYVlZcEZ0UjZY?=
 =?utf-8?B?b2JMamJ5SmI2UDNxMEk0dmN6Qm5GUmxPNXdRNzU1dkNQTjY4OFBtdFhyNGYr?=
 =?utf-8?B?ZDdWZC9RUWVpZDhmWkVkTW5XUm1yVXQ4Zzdjb3VLdGpHbzl5R0lDMmFXUFoy?=
 =?utf-8?B?YXpzQjU1WnlubFFXZEtRQk80UG00dVo4RTFwVDhzVGV4ZXllRDY2VlNwbGox?=
 =?utf-8?B?RkovYU5yNitveWpiRG5qbThwMVdvKy9JWjAySmkxbFNvYTd3VUZGTURUVlFG?=
 =?utf-8?B?MmxQUE5BVnhpK2E4TUhvamdhRHhGNnJvUm12U3ZtT1RLTWxaYU83Slk3OW1w?=
 =?utf-8?B?R3FSRjczQ2VONWNaSWVJSTlFNlhKS1l2Ly9ob0tzUHc1bldtN1AyT3RWUCtW?=
 =?utf-8?B?QVM1czY3Sm1DVmRaTXBJWGRURGxCelFqZTlKM0dqSnQxTkhKLzFTTzdncHpn?=
 =?utf-8?B?M3hEbHQwSjE4d1RCd0dYOS9LdGwxNHQ4WU9MZFFzM1FzTUUzU1UwM3R0Wm9o?=
 =?utf-8?B?eHkrYlp1ai9MMWNPd1pUUTdtRmdKdlNiMFV6SjdSTE14am5CY1BtRUxabFlX?=
 =?utf-8?B?K3QxNWVxZ0dXRUJ4WTgzdXM5Y0U1TkJyM0ppcUsva0ZtOXRFZzZiaS8vMkpI?=
 =?utf-8?B?YVRkK3orQzJpcS9zcmlzdlhxblEzOS9ySjJTbWNVVEk0Q0VrcmFjdUtCa2w1?=
 =?utf-8?B?bFRpZENXdHhiVE1BcFFIY3NhMzlqL2VieTdSVFgxUDNEYWlqWERRRkpRUXZZ?=
 =?utf-8?B?T2pMWEFJSlFLUlNUcUR0bUFTUWFoWmh1Q2RuTlJCNldqSGQvQ0JCRCtEemdN?=
 =?utf-8?B?WGw0enhRaDY4ZldXb0ZrRWJ4WmZwOWdFSXVHeWFlc3RJT2d0L3I4RjZWRWtE?=
 =?utf-8?B?SU5XNXFBb1lEeFdIWVNmaVQvOTgwUUVYTHQ3dmxwUU10QythWTNoTjAxQ1Zu?=
 =?utf-8?B?blV6VEVIWm0xeFM1cG9sUlQ1U2xESW9OaSt5UlNjSzNWdThBN0QyR0VyYVBw?=
 =?utf-8?B?djhLdkpST2FlRXVuRlU0MGM1d3NwMWlLdktsNXU4VStVWjVJZnlhKzFVZHRu?=
 =?utf-8?B?RDZibUxBU21DNEx0SkVkWW9OWXRiWHVqUE92WldYNlFoWnhrT2dQTlM4Q0sw?=
 =?utf-8?B?b1NBY0QyYk00a0ZFMFdIL3J2WllVK2hCUm5SRjBha2V2cFQ5bCttNFFVOHUy?=
 =?utf-8?B?RTV5VzBrTUYrZ3ZlS3VkakVKYkUyM0FKeCs4R1Mrd243SzJYc1VadUlYRW1v?=
 =?utf-8?B?NXV1dmZWVW15OGZ5ZUJ4K1k2V25JN3JCMzNvTFVJTmVVNmg1ZmJlNVhPMnVv?=
 =?utf-8?B?dmxZOUN5UXBSRlNseGo1aThJSlhHWmRiK1d0bWtEVGovVkV0QXBUb1FXdUJJ?=
 =?utf-8?B?OHlId3pIZkM2eWpDQ0ZUVkdER0JaT1VQaGhQc1RrV0VxTWdaWXowSGp4T2dR?=
 =?utf-8?B?c2ttTndpdGZiNEhZMVZDcmc5L0E0K1FiRThLZDZEMWFBamhZa3F6ZGNBT3Z0?=
 =?utf-8?B?TzhNc2tzSGF2UzFDdGRJQndtZ0NvalB5ck5tcXdPRXhYaldyTHVDam85Ynhn?=
 =?utf-8?B?OXhtM2dvOVk4MjNIQjYwNXJnS2ZnaUhIODB3aGVvUWxsYU9DOVRFWlowQm1r?=
 =?utf-8?B?U2twM1hkNS9ad0U4VWJWKzdFb3d3QkFRSmZOWUdGdkFEd2VLWmpERVN2Y0pj?=
 =?utf-8?B?SjRVaGN1OVdxU00wNm13Q290ckJqVVIyVVJEeDJjK3ZZVFR3cEFvbGJ2MXJJ?=
 =?utf-8?B?WlRRdUhpNGpZY015WVB2djZKVVllelowTXVhd3hFTzlTMDdiaHh2djhRTnJH?=
 =?utf-8?B?SWNoSFVVM1A3bE8vY0Z5S01EME51bitiZmJPejZvTzFiRVg0ME90ZkpUbHpq?=
 =?utf-8?B?akhsWU5xYUh5K1RhbFpPcUR2ajZjb0FXNEhWWldrcTk5N2RFVTJhMG9IcmdI?=
 =?utf-8?B?M3pFNEtuR0NoYXZLNkgvSVpodjJHMHZKalFmWVVKMWtFYklKVDk0c3RERU85?=
 =?utf-8?B?eDJ5YkQ3SkdsWGJuQlgvVXFCVTJPWTZlcHY0SVIzMG5DTlcycXlIa0lnZlhE?=
 =?utf-8?Q?8d31vuE6pxTsU2ZeC2GcICHdz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <13298B020392F84CAC7036640B638F67@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3160c11c-3c3e-41e1-67da-08db70b98bc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 11:37:21.9047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GMjjOtLjK017y7BL3g9Wya8GLd6lJo6Rgnbmd2OQJg8BlpGO1tnEEz9ikFpqUGaRVemdgNxbO6wv6rv5xA3sYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5524
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDIyOjQzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBXZWQsIDIwMjMtMDYtMDcgYXQgMDc6MTUgLTA3MDAsIEhhbnNlbiwgRGF2ZSB3cm90ZToNCj4g
PiBPbiA2LzQvMjMgMDc6MjcsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+IFREWCBtZW1vcnkgaGFz
IGludGVncml0eSBhbmQgY29uZmlkZW50aWFsaXR5IHByb3RlY3Rpb25zLiAgVmlvbGF0aW9ucyBv
Zg0KPiA+ID4gdGhpcyBpbnRlZ3JpdHkgcHJvdGVjdGlvbiBhcmUgc3VwcG9zZWQgdG8gb25seSBh
ZmZlY3QgVERYIG9wZXJhdGlvbnMgYW5kDQo+ID4gPiBhcmUgbmV2ZXIgc3VwcG9zZWQgdG8gYWZm
ZWN0IHRoZSBob3N0IGtlcm5lbCBpdHNlbGYuICBJbiBvdGhlciB3b3JkcywNCj4gPiA+IHRoZSBo
b3N0IGtlcm5lbCBzaG91bGQgbmV2ZXIsIGl0c2VsZiwgc2VlIG1hY2hpbmUgY2hlY2tzIGluZHVj
ZWQgYnkgdGhlDQo+ID4gPiBURFggaW50ZWdyaXR5IGhhcmR3YXJlLg0KPiA+IA0KPiA+IEF0IHRo
ZSByaXNrIG9mIHBhdHRpbmcgbXlzZWxmIG9uIHRoZSBiYWNrIGJ5IGFja2luZyBhIGNoYW5nZWxv
ZyB0aGF0IEkNCj4gPiB3cm90ZSA5NSUgb2Y6DQo+ID4gDQo+ID4gUmV2aWV3ZWQtYnk6IERhdmUg
SGFuc2VuIDxkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gDQo+IA0KPiBUaGFua3Mh
DQoNCkhpIERhdmUsDQoNClRoYW5rcyBmb3IgcmV2aWV3aW5nIGFuZCBwcm92aWRpbmcgdGhlIHRh
Zy4gIEhvd2V2ZXIgSSBmb3VuZCB0aGVyZSdzIGEgYnVnIGlmIHdlDQp1c2UgZWFybHlfaW5pdGNh
bGwoKSB0byBkZXRlY3QgZXJyYXR1bSBoZXJlIC0tIGluIHRoZSBsYXRlciBrZXhlYygpIHBhdGNo
LCB0aGUNCmVhcmx5X2luaXRjYWxsKHRkeF9pbml0KSBzZXRzIHVwIHRoZSB4ODZfcGxhdGZvcm0u
bWVtb3J5X3NodXRkb3duKCkgY2FsbGJhY2sgdG8NCnJlc2V0IFREWCBwcml2YXRlIG1lbW9yeSBk
ZXBlbmRpbmcgb24gcHJlc2VuY2Ugb2YgdGhlIGVycmF0dW0sIGJ1dCB0aGVyZSdzIG5vDQpndWFy
YW50ZWUgZGV0ZWN0aW5nIGVycmF0dW0gd2lsbCBiZSBkb25lIGJlZm9yZSB0ZHhfaW5pdCgpIGJl
Y2F1c2UgdGhleSBhcmUgYm90aA0KZWFybHlfaW5pdGNhbGwoKS4NCg0KS2lyaWxsIGFsc28gc2Fp
ZCBlYXJseV9pbml0Y2FsbCgpIGlzbid0IHRoZSByaWdodCBwbGFjZSBzbyBJIGNoYW5nZWQgdG8g
ZG8gdGhlDQpkZXRlY3Rpb24gdG8gZWFybGllciBwaGFzZSBpbiBic3BfaW5pdF9pbnRlbCgpLCBi
ZWNhdXNlIHdlIGp1c3QgbmVlZCB0byBtYXRjaA0KY3B1IG9uY2UgZm9yIEJTUCBhc3N1bWluZyBD
UFUgbW9kZWwgaXMgY29uc2lzdGVudCBhY3Jvc3MgYWxsIGNwdXMgKHdoaWNoIGlzIHRoZQ0KYXNz
dW1wdGlvbiBvZiB4ODZfbWF0Y2hfY3B1KCkgYW55d2F5KS4NCg0KUGxlYXNlIGxldCBtZSBrbm93
IGZvciBhbnkgY29tbWVudHM/DQoNCisvKg0KKyAqIFRoZXNlIENQVXMgaGF2ZSBhbiBlcnJhdHVt
LiAgQSBwYXJ0aWFsIHdyaXRlIGZyb20gbm9uLVREDQorICogc29mdHdhcmUgKGUuZy4gdmlhIE1P
Vk5USSB2YXJpYW50cyBvciBVQy9XQyBtYXBwaW5nKSB0byBURFgNCisgKiBwcml2YXRlIG1lbW9y
eSBwb2lzb25zIHRoYXQgbWVtb3J5LCBhbmQgYSBzdWJzZXF1ZW50IHJlYWQgb2YNCisgKiB0aGF0
IG1lbW9yeSB0cmlnZ2VycyAjTUMuDQorICovDQorc3RhdGljIGNvbnN0IHN0cnVjdCB4ODZfY3B1
X2lkIHRkeF9wd19tY2VfY3B1X2lkc1tdIF9faW5pdGNvbnN0ID0gew0KKyAgICAgICBYODZfTUFU
Q0hfSU5URUxfRkFNNl9NT0RFTChTQVBQSElSRVJBUElEU19YLCBOVUxMKSwNCisgICAgICAgWDg2
X01BVENIX0lOVEVMX0ZBTTZfTU9ERUwoRU1FUkFMRFJBUElEU19YLCBOVUxMKSwNCisgICAgICAg
eyB9DQorfTsNCisNCiBzdGF0aWMgdm9pZCBic3BfaW5pdF9pbnRlbChzdHJ1Y3QgY3B1aW5mb194
ODYgKmMpDQogew0KICAgICAgICByZXNjdHJsX2NwdV9kZXRlY3QoYyk7DQorDQorICAgICAgIGlm
ICh4ODZfbWF0Y2hfY3B1KHRkeF9wd19tY2VfY3B1X2lkcykpDQorICAgICAgICAgICAgICAgc2V0
dXBfZm9yY2VfY3B1X2J1ZyhYODZfQlVHX1REWF9QV19NQ0UpOw0KIH0NCg0K
