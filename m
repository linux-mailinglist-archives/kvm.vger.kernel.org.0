Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576C35A40B8
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 03:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiH2BhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 21:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiH2BhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 21:37:21 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4522DABF;
        Sun, 28 Aug 2022 18:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661737040; x=1693273040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4/FjezoaiXHprcEjMc9+twx5LJUrFxPWG3o0/MuhRrI=;
  b=GQaLCqpS+rGFIRdbJmURVqvZ2pmPM57Gsu6xkIdgCXvnZEI6HlUUHu7m
   GmoQrb0PcIK6pkhgLcXKMR2qGiFNv6eEnVit8nNyjwxxr/jq4VTIrhm2h
   xWFZEXyIxcKbY3fWA/rtJJPBh3v7THh8XKxQSCZA1VgiERTSAW0rtlqip
   E25bR/LKytdDEj3tBeXBIcAQwDynabIJTjc5Ca1EoYhK14AfpScDBMGIN
   nmx7bddGuGHvbQb1hGjqn4b7JSdcosyhZYs1ZdWnN2q/1uQuJ5AppjAtV
   5MvkRXx7AIjAd6U2f4D6CpzVCte6uCGaJuJjCraJyz58H6QfJyzsyv+tP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="293530604"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="293530604"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 18:37:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="856560441"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 28 Aug 2022 18:37:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 18:36:56 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 18:36:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 18:36:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 18:36:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFphGBAMLL8ezfEfFEpHq8d1iWtYq/zrY22rKr4561YpMq+bigo442cQwHwwTjPuObL3Bs9YMDGmGYHTOpFrgn6pL5OLc9Lena3k+eFoCsIv+ojBZ1BcmKikaL7EKYnEskZVuouPIkEYSQcAEbT20SQQ6QziWMLMKOyTtvN46wdIMgaPP0NgZJJAti8q9WMT50aFvde74Yi7slf3wmzo13WwPhaAGfU3brVGMPioXrlwMyuZ5OSahy7Y72ZQAnkVJNoeGzYTTYBb/iVL4hZJ/VzzoxKc/fNoLN0mqfOgt22/YPrfh8k9dCCLsg8LA0BUH0VdySu7hVX5QyTor6z5wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/FjezoaiXHprcEjMc9+twx5LJUrFxPWG3o0/MuhRrI=;
 b=Ocefg/1VgdGUUX08sFUd0QSEYZtfY97yjxdApGrlCvqP3RGi8H7c+s6oNGlPGbyYtQf2DoadLTX+w/WKW23gFmSGvF31EJSYnx7qizCIhDT7pYPzZ5pvZVUhl6rpl/HQEYHw6rPw0y7J4q39NZ2KMXUzzsr5uohkrC0ym91tSl/lN/NYVJ4PbreK1mYAg/qqPSQrriAuIbfT7tTswhFun7ADQ7QlzXdh4oPg9o5YZkJpaZRjWpPQSYBm2+sQktCnd3z4Vz4PtiybNh5mW7F1HhvibYfPQOCkcvtZuwUK930gCmTnzzptjK5hJC8yqNs5QwxZ6uYQ3/g3NsETnll2Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MWHPR1101MB2335.namprd11.prod.outlook.com (2603:10b6:300:73::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Mon, 29 Aug
 2022 01:36:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%9]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 01:36:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function to
 KVM guest
Thread-Topic: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Thread-Index: AQHYsqvDhJ5ikbiH/kmiVdBjKSRam62+/3eAgADHRoCABWOMAA==
Date:   Mon, 29 Aug 2022 01:36:53 +0000
Message-ID: <6d6c25b24cd49dfa5901f37f24df854e9125cd16.camel@intel.com>
References: <20220818023829.1250080-1-kai.huang@intel.com>
         <YwbrywL9S+XlPzaX@kernel.org> <YweS9QRqaOgH7pNW@google.com>
In-Reply-To: <YweS9QRqaOgH7pNW@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8649fcfd-18b0-4ef3-3c87-08da895ef3b1
x-ms-traffictypediagnostic: MWHPR1101MB2335:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dy6qzq6BSdCc+GFVLQ+WLPsZAat2JiHESi11WjrapZ7ph20IqnenTU7A2A3baoC4Ww3g3otTVYaAE2kJzTxzVs9i8/kvZZUwqodtPSXe6L59skIMZ675wzpMTs6o3fZSoFsrcwvwoB7SD2KHG418LwcTdtCV/y1pb9lGDjOdgxcCsfRw1cUF4TLbUdcsrVXnLKZmcZNQiYiJSsbWBOTqppH5zkDmupkEEJ0CoESIdqLsxon27ORqDQlg9YYTAGaMPDYn4E8lCPBy6oWwfWrVSxR2iF+vgA3XFZHUIhEHtfYW1H++vryhzSKpKP+1MdTlxgGOjSuXLTkzAGgk0Oh1nmvqzecrnqVnJwdzG2HXRCvOnYWpZFGUknPMSqvsZWuwQ7Y4fTtDcvzFDCh8VrTV/2DhxBlHot+dLrBsICRL3TZF3GwxTqILsXtOhlZIjNLy0W+vC7sDMLbFFXOT4KLEKQpObIpo4EURS6kX/At3eOgPdrhryzTxWiBxTKjnCuvE1m0VwhJnxj7zWMcXduqFcet15FIqaQBBHNniDh8bpMDrt+eBwv0aqsM6w3BC5GcYqzZkEM4+dcB5Q7X5msTKmF6LeFydLAshnQrlkaIpNQSKi5qEduIAtrk/XwYeVZFcioTlhlBLekaplpImjg9UYQn3l2ZKBuyxzYwkYfMS2Z7cIB4TQMGYqVlSYjDA0/qDNjFiuKGurVG/3F9OrJhuvmKPSychriARsdqjivcQdoEYnQI9kx0LVPvObgu098qjojAVBUkFN/XDHhJKdyd8lQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(346002)(366004)(396003)(86362001)(6512007)(26005)(6486002)(71200400001)(478600001)(6506007)(41300700001)(186003)(122000001)(38100700002)(82960400001)(38070700005)(83380400001)(2616005)(66476007)(66446008)(64756008)(110136005)(66946007)(5660300002)(66556008)(8676002)(8936002)(4326008)(36756003)(316002)(54906003)(2906002)(91956017)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlE5YTRCZktjVjYwN1gyTzhXVy9FWEVYTmpMMVltUlRWdXJPY01LM2RXWVpj?=
 =?utf-8?B?Y2RRZnZEVis0Z3d1cCsva2d3RXppaHpVaFhCSDh3eGdud0RjN1NTU1hOL2Js?=
 =?utf-8?B?a0I0TWRXSnk3WVc3V0lLZWEwZFpwVHFLSmRuQ1dhS1BIblp0a0VXNU9OV2ZX?=
 =?utf-8?B?cEdnY2tIVDR1Y1RBSGlMdWhLRXk4MDQrZzhFdmx2OTIzWTRIK3pmTUdrYVFM?=
 =?utf-8?B?eGM4QlE1YVNjQVFDMFFsMTcrUTdDYVNnaENrRUFsWlJkZnFyc2E4WTBCVWVm?=
 =?utf-8?B?QVFzVS81NFdkL2ovN2trU05CWlNQcy81eHZlb1RSd1UxdDcyaWxIZVY2YXI2?=
 =?utf-8?B?R3ZXRHJ3T1FhZFQzMElTWHBFSG9zVzVNSE1jNWpMVm1nQkFiTHNoSUVwWGZZ?=
 =?utf-8?B?aVFxclR3cmlYZXduVGNZTUsweHNmNzhSQ2k3aytFVHFlNEhDZ0YrNW9YaHVo?=
 =?utf-8?B?L0dHVjdKK1V1ZDkrZnRHb3dlOWxvU0R4S1hQTFlyU0h6NllSbHRrUTZGSjd0?=
 =?utf-8?B?MFJoZDhHNXhQRUFoU0huNEJHcEhKdDR2UEZ4WVBaTGRsSm5jTFFLTmgyQmVa?=
 =?utf-8?B?cmREVkR5bk0rcklqbjE5VlNYNXBXcjdmT0hrenV3d24rV1lBNGpoSGpDWk9T?=
 =?utf-8?B?ZzJHaE5zeVppSmZ1aDhBekxIcFJIcDQ2RitiSVYwd2JJdFpidmJzc21IbU1G?=
 =?utf-8?B?K0RFMXp6emhRbk5FVkZIMksvbnZwejJSV3VvMVF1djZxMFhTRE43V25Gb05z?=
 =?utf-8?B?eDRSTDBmMVJONCtJTEdBQU1LRC96R1ZPZWMvejRNazBaY2FkQjNWYjhxeGlt?=
 =?utf-8?B?Zytpdkh0RVk2eUdMcTIwTkZ6WGx1bWFuVkNaTlYyR25HYmMyYkZtUnFDTlVD?=
 =?utf-8?B?NzVuN2VNRDB0UGpOMW41Wko4Yjh1dmNDdURWWVBlVFZXR050UGd5QkhYSGFh?=
 =?utf-8?B?YUdCa05rYWdZYkw4VHVkSk5rWk0vdllnOHNDbms4NjRvalFOV3BDMnExU2NC?=
 =?utf-8?B?K09lUjRndVljUVIvY1Y0d2t6aGVsYVkraVFqMnBPR0JKY2kwWmlqdnUzcm1k?=
 =?utf-8?B?VGhIQTQ2M0ZyY1Vka3VFN284UHhaUGE4UkVJbWcyY2NKK2ZTL1FsMHF4TEVL?=
 =?utf-8?B?OWZVY09nMzFWMXhCcmdxY2Q3Vmd0MG94VkIyays3QjdhUlRxbnBTR2pWQlBm?=
 =?utf-8?B?dUlUV3ZtYmFoNW1USnhqdXhhU2dMRklZYkhNZXB0Mys0aFBCV2NXbmxQamlo?=
 =?utf-8?B?UXl5S3FrZ2tzT1dxaG52Y1pFQ0prOE8rOE9VTDgyd3U0Q0hITW1KZ1lDbzlm?=
 =?utf-8?B?Z1JIUUlQWG1rMk5KMzBpU2Z3T3g5ZVVQNGFXM2k0NGxHSzFSSGYvVGFKWnpY?=
 =?utf-8?B?NGFRMzFXZWN0NlNPMkhqRC9vTnJvNjRsRFZkOUdlVlgrR3ZLOU00djlOck5D?=
 =?utf-8?B?VGxLWktCMVJ1RVZJLzZjaGhNWVYxRjNqd0QraEVUa05oVnkwcUtra1lEd1BQ?=
 =?utf-8?B?QktEMDI5VDJDbVdna0xHYitRd3l3WXlLdTROaXg2eG8xeGNBZkp4WVB4WHN4?=
 =?utf-8?B?UmVleUErSStUR0lrOVRMRm9lRStMcWpacEVFSkJzM3hKZE4wampSMlpTekk3?=
 =?utf-8?B?U0o3MU85aVRVV0l3dndFa2FlbWM0YzUxV2VBekkwc09jc0VzNlJvSWFuWTJN?=
 =?utf-8?B?M2U2amNJNE16NzZsRFBGRzJBUHdPbDc4d0tmcmVaTmFmTU90NkFNdTV1OXpU?=
 =?utf-8?B?WFJzTkx4dkFxakc0VTFUcFcwd3NpQU9nWEQyOFlYTmFZdEF5TDBPMUdWbm04?=
 =?utf-8?B?YzVubVRaTnA2d293b3V2bVBPU1FnL3JPRnNCbURFSHdNaFFUeGVsaEFqSWRV?=
 =?utf-8?B?cWFrS2VCNUxMQVRuY0l5V3UxcnYrMjRRd0NqZUljeE1yRmJNa3pJOWJCNnN3?=
 =?utf-8?B?MlVZTDRmdmpKb1FuN3ZyMTJlRHhhNHBTNUNSNEU5QkMyTkhhTkdaaHljNlBX?=
 =?utf-8?B?Y0R3THhuN25wenAyb0ZBckdXTEpMK1E4TkpHU1gyb0p5d1o2T2V4cVBORHdj?=
 =?utf-8?B?RmJiOFA5QXBMdi9hMW1DcjUydURISmxSTTJ3enh3YUVEWEdFVkVLdlVxUzNS?=
 =?utf-8?Q?Jvt1C/rwB7a24Th9MMYPQTkuc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F19474022CE3714095729557797734CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8649fcfd-18b0-4ef3-3c87-08da895ef3b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 01:36:53.4131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ho6MO7dibVeKz0RwGsXOxbZm6QJglta4h5+lYSXuCJD89cmOwyth1FqJsveqbtjS3sgMBljb/aFrtMWYPEmYsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2335
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTA4LTI1IGF0IDE1OjE5ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEF1ZyAyNSwgMjAyMiwgSmFya2tvIFNha2tpbmVuIHdyb3RlOg0KPiA+
IE5pdDogc2hvdWxkbid0IGJlIHRoaXMgYmUgeDg2L2t2bT8NCj4gDQo+IEhlaCwgbm8sIGJlY2F1
c2UgeDg2L2t2bSBpcyB0aGUgc2NvcGUgZm9yIExpbnV4IHJ1bm5pbmcgYXMgYSBLVk0gZ3Vlc3Qs
IGkuZS4gZm9yDQo+IGNoYW5nZXMgdG8gYXJjaC94ODYva2VybmVsL2t2bS5jLg0KPiANCj4gQnV0
IHllYWgsICJLVk06IHg4NjoiIG9yIG1heWJlIGV2ZW4gIktWTTogVk1YOiIgd291bGQgYmUgcHJl
ZmVyYWJsZSBnaXZlbiB0aGF0IGFsbA0KPiBvZiB0aGUgbWVhbmluZ2Z1bCBjaGFuZ2VzIGFyZSBL
Vk0gc3BlY2lmaWMuDQo+IA0KPiA+IE9uIFRodSwgQXVnIDE4LCAyMDIyIGF0IDAyOjM4OjI5UE0g
KzEyMDAsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+IFRoZSBuZXcgQXN5bmNocm9ub3VzIEV4aXQg
KEFFWCkgbm90aWZpY2F0aW9uIG1lY2hhbmlzbSAoQUVYLW5vdGlmeSkNCj4gPiA+IGFsbG93cyBv
bmUgZW5jbGF2ZSB0byByZWNlaXZlIGEgbm90aWZpY2F0aW9uIGluIHRoZSBFUkVTVU1FIGFmdGVy
IHRoZQ0KPiA+ID4gZW5jbGF2ZSBleGl0IGR1ZSB0byBhbiBBRVguICBFREVDQ1NTQSBpcyBhIG5l
dyBTR1ggdXNlciBsZWFmIGZ1bmN0aW9uDQo+ID4gPiAoRU5DTFVbRURFQ0NTU0FdKSB0byBmYWNp
bGl0YXRlIHRoZSBBRVggbm90aWZpY2F0aW9uIGhhbmRsaW5nLiAgVGhlIG5ldw0KPiA+ID4gRURF
Q0NTU0EgaXMgZW51bWVyYXRlZCB2aWEgQ1BVSUQoRUFYPTB4MTIsRUNYPTB4MCk6RUFYWzExXS4N
Cj4gPiA+IA0KPiA+ID4gQmVzaWRlcyBBbGxvd2luZyByZXBvcnRpbmcgdGhlIG5ldyBBRVgtbm90
aWZ5IGF0dHJpYnV0ZSB0byBLVk0gZ3Vlc3RzLA0KPiA+ID4gYWxzbyBhbGxvdyByZXBvcnRpbmcg
dGhlIG5ldyBFREVDQ1NTQSB1c2VyIGxlYWYgZnVuY3Rpb24gdG8gS1ZNIGd1ZXN0cw0KPiA+ID4g
c28gdGhlIGd1ZXN0IGNhbiBmdWxseSB1dGlsaXplIHRoZSBBRVgtbm90aWZ5IG1lY2hhbmlzbS4N
Cj4gPiA+IA0KPiA+ID4gU2ltaWxhciB0byBleGlzdGluZyBYODZfRkVBVFVSRV9TR1gxIGFuZCBY
ODZfRkVBVFVSRV9TR1gyLCBpbnRyb2R1Y2UgYQ0KPiA+ID4gbmV3IHNjYXR0ZXJlZCBYODZfRkVB
VFVSRV9TR1hfRURFQ0NTU0EgYml0IGZvciB0aGUgbmV3IEVERUNDU1NBLCBhbmQNCj4gPiA+IHJl
cG9ydCBpdCBpbiBLVk0ncyBzdXBwb3J0ZWQgQ1BVSURzIHNvIHRoZSB1c2Vyc3BhY2UgaHlwZXJ2
aXNvciAoaS5lLg0KPiA+ID4gUWVtdSkgY2FuIGVuYWJsZSBpdCBmb3IgdGhlIGd1ZXN0Lg0KPiAN
Cj4gU2lsbHkgbml0LCBidXQgSSdkIHByZWZlciB0byBsZWF2ZSBvZmYgdGhlICJzbyB0aGUgdXNl
cnNwYWNlIGh5cGVydmlzb3IgLi4uIGNhbg0KPiBlbmFibGUgaXQgZm9yIHRoZSBndWVzdCIuICBV
c2Vyc3BhY2UgZG9lc24ndCBhY3R1YWxseSBuZWVkIHRvIHdhaXQgZm9yIEtWTSBlbmFibGluZy4N
Cj4gQXMgbm90ZWQgYmVsb3csIEtWTSBkb2Vzbid0IG5lZWQgdG8gZG8gYW55dGhpbmcgZXh0cmEs
IGFuZCBLVk0gX2Nhbid0XyBwcmV2ZW50IHRoZQ0KPiBndWVzdCBmcm9tIHVzaW5nIEVERUNDU1NB
Lg0KDQpJbmRlZWQgS1ZNIGNhbm5vdCBwcmV2ZW50Lg0KDQo+IA0KPiA+ID4gTm90ZSB0aGVyZSdz
IG5vIGFkZGl0aW9uYWwgZW5hYmxpbmcgd29yayByZXF1aXJlZCB0byBhbGxvdyBndWVzdCB0byB1
c2UNCj4gPiA+IHRoZSBuZXcgRURFQ0NTU0EuICBLVk0gaXMgbm90IGFibGUgdG8gdHJhcCBFTkNM
VSBhbnl3YXkuDQo+IA0KPiBBbmQgbWF5YmUgY2FsbCBvdXQgdGhhdCB0aGUgS1ZNICJlbmFibGlu
ZyIgaXMgbm90IHN0cmljdGx5IG5lY2Vzc2FyeT8gIEFuZCBub3RlDQo+IHRoYXQgdGhlcmUncyBh
IHZpcnR1YWxpemF0aW9uIGhvbGU/ICBFLmcuDQo+IA0KPiAgIE5vdGUsIG5vIGFkZGl0aW9uYWwg
S1ZNIGVuYWJsaW5nIGlzIHJlcXVpcmVkIHRvIGFsbG93IHRoZSBndWVzdCB0byB1c2UNCj4gICBF
REVDQ1NTQSwgaXQncyBpbXBvc3NpYmxlIHRvIHRyYXAgRU5DTFUgKHdpdGhvdXQgY29tcGxldGVs
eSBwcmV2ZW50aW5nIHRoZQ0KPiAgIGd1ZXN0IGZyb20gdXNpbmcgU0dYKS4gIEFkdmVydGlzZSBF
REVDQ1NTQSBhcyBzdXBwb3J0ZWQgcHVyZWx5IHNvIHRoYXQNCj4gICB1c2Vyc3BhY2UgZG9lc24n
dCBuZWVkIHRvIHNwZWNpYWwgY2FzZSBFREVDQ1NTQSwgaS5lLiBkb2Vzbid0IG5lZWQgdG8NCj4g
ICBtYW51YWxseSBjaGVjayBob3N0IENQVUlELg0KPiANCj4gICBUaGUgaW5hYmlsaXR5IHRvIHRy
YXAgRU5DTFUgYWxzbyBtZWFucyB0aGF0IEtWTSBjYW4ndCBwcmV2ZW50IHRoZSBndWVzdA0KPiAg
IGZyb20gdXNpbmcgRURFQ0NTU0EsIGJ1dCB0aGF0IHZpcnR1YWxpemF0aW9uIGhvbGUgaXMgYmVu
aWduIGFzIGZhciBhcyBLVk0NCj4gICBpcyBjb25jZXJuZWQuICBFREVDQ1NTQSBpcyBzaW1wbHkg
YSBmYW5jeSB3YXkgdG8gbW9kaWZ5IGludGVybmFsIGVuY2xhdmUNCj4gICBzdGF0ZS4NCg0KVGhh
bmtzLiAgV2lsbCB1c2UgYWJvdmUuDQoNCg0KLS0gDQpUaGFua3MsDQotS2FpDQoNCg0K
