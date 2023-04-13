Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574BB6E0417
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 04:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjDMC1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 22:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDMC1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 22:27:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887D830C0
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 19:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681352838; x=1712888838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dfyUo4NIu+Nh9AywAYeQs+u0MN/LGS0RxK16t/gO4Mk=;
  b=avgkLFLUPCFLLts4ZzLYN36pEaf3FX1x/KOiI2xShaVorHrgiDutHm8u
   xpwT5jLUcUOWccCbaPq00eJ6zvY6AjkOoehz1M3xj2XvEFyBGYwRBKswF
   HCQZiTj3/OWsAmOHS8bcZqOUOrjJqVTDIgfzXZLH9uBmYFOz4Z3BcvQN7
   oAuwdkFoljCXjUExqjQxz6NZ0Uvucz+iS2ez3F7nJM3NesGlGV3ill0dJ
   LMsqxUjf4tqJ+l46VfkOe/Ix/8QL/SOjNSqYPrMjQDoOU4FPPE0N/vW/I
   3c9T44/5y6EP2yxTqReapQRrjqFmboVuRyMzg8RxP908UXZ5y4gvYtUn9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="409218283"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409218283"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 19:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="778523288"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="778523288"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Apr 2023 19:27:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 19:27:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 19:27:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 19:27:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dg42QmqvaAZCR9DecFviKBYXwCvyXiuORLvAoG58QJyM9oMHao+ZPa1svaSPPxBFG/MOpPPCm9aErbOchA9OKNKwtBCI7P7a5yZFRwK8fCnMToOmVBSG8bsIszyyFHaXGMaZhQms4xYrw6R2wj0LkdBEQJbnANWIUc1LIXQ7LxwkQGXg4LF3l0vTa4GHmKwV8sYBXw5qk/vK85bEE5Ly8TWYonpCoyO8oaSzvj2B0knjk47DRakhVv/Avmkq+d2wIkxVuGt0ChKArcmYd8yJsqePY5N+zBZyrk81bmYeUmjbMZBAvLtCJ8FCHjT36Rb8KE5YeEFDgWZs8K4OTMKDqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfyUo4NIu+Nh9AywAYeQs+u0MN/LGS0RxK16t/gO4Mk=;
 b=a1NabvcAoOCMF2cakMsg79t7k0GZYzJYt3iA+BP0tjcK6rUsC6/4reEx1dgUptTR5GlI8dlXUMmCoczc4PbOWxSPICH7/SPswX58Hd6EnwkG1lsfC8vE6o11HugEiWKBOIyEaQDOR/RSdYUT8LkKJI8LkyEBmsGG1qGmNy0+OOu+BylMmNi1mpcT3uVOqcRaA1B1FyEqqXYN9b/5mjYR2KLdg2riPm1srUH0+PxD00K6AQTkCBnm57DDzCQC0QxttVTPxBn7x7929NJ4Sc0kpSFumBw5LfUeJqrjE+i/uGILP3SpaMu+kLcw+AIOMSQ5ow0TdjRpYgcZZ4k8OFg6TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8202.namprd11.prod.outlook.com (2603:10b6:8:18b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 02:27:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Thu, 13 Apr 2023
 02:27:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluAgADkdoCAAA4jgA==
Date:   Thu, 13 Apr 2023 02:27:10 +0000
Message-ID: <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
         <20230404130923.27749-3-binbin.wu@linux.intel.com>
         <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
         <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
In-Reply-To: <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB8202:EE_
x-ms-office365-filtering-correlation-id: 710322f4-39ec-4685-25cb-08db3bc69596
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bb9IBpUXHaOsnCRQB1uC+baNeVXFd+Hj/vlv9c/kg5jYvTkLHfjXE5X92CQ1pFQMz3A60M9/GNd7gSI+x7vbDguFwij9Mipa+glmByosNtTc7Pv9I3JmmWd9i9a2EEbxURty0mnpgLRPzYYlvK8FsXUbU8xZP6w90f5tBRjl1ZaJAUPPe1rKKLonJjUXkKS5Dwb/o783NZ9vpQK1wktPMRjpobDBnFbEvSo7tldriYfOWiPYeoKfXB+w/zJhfB7NuXNEIW1blC4JCGP7HP5cwqerV3Eb94klySjPXbjuDdG3Hgin7/ORgX3gSEU+rlaHd/NtNEGZYxyDR8pv3eWQlj7fsVM9kGpKgC078KkUc3r2razG1cTW+bPJ0V04n4mqd4Mqy1cxxEQcUIrI00MZZQ5MVWI/w7I2PddX8uDz05JkHVDlWlVoBZ17dtkL4QyAM/jlpmm3RELoiN7RW4TQ63M8FOumOTGUgYQypsuKuOxP5S/xFtvl66hSLu+Z1RR5WWV/4qjVerOCBqWLIjT8DyBHu9D+laAkjQRWgVhnP1mFymQOfjEzISuyH6/kMEUSFBWJB27pCPiL4vFsrv8QY0YYe6Xmms9Q/e56Xa++bVIZakdVVB+x87bbceqeXB0o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199021)(64756008)(8676002)(66556008)(66476007)(66446008)(66946007)(6486002)(4326008)(54906003)(478600001)(71200400001)(41300700001)(76116006)(110136005)(316002)(91956017)(36756003)(86362001)(2616005)(6512007)(6506007)(26005)(53546011)(82960400001)(5660300002)(8936002)(38070700005)(38100700002)(122000001)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mis4Q2VUNS9iWHJ0WlVTSGNmMTByUjVWamlDbnpLR3dsUkk1VFJFWkdWZmlX?=
 =?utf-8?B?L0JBQVh4bjVTTFk2bmYyaHZiYUtQZENkd1R5cGErY2UxZVRWM1BqUGpNRWY4?=
 =?utf-8?B?OXFOUUtDMy9peTh2TFFJV0ZVL1lsZjFEeFdlcktaQ0NVb1NrVHRYc0FHYkJD?=
 =?utf-8?B?a0JRRWxMMTZZSW1hU3h3R2loUVJGMjlBa2lMbFRRWkNJeTlXcklPdDh6ZW03?=
 =?utf-8?B?ZTJhU1pFV2R0UHRyUmxJa1VIZHlWVFVpRHlKRnlOWlpXaGpxR1dsR1h3clds?=
 =?utf-8?B?c1Y5NlgzUWJJcUxHR2VLcGdkMyt4VlVJaHFwamNjU2owR3B0MDNZcXhkZ2Vw?=
 =?utf-8?B?WkNaK0RRM0l2YjFYejdTZWRIK0pEaldKM1l2UnIzTDNSSDA1dlVvdXgzVmpl?=
 =?utf-8?B?azhsU2lxcDEvSG80UStUOTlkWlREMFN0ZXhIM1FONS83R05uVjBucE9BODNW?=
 =?utf-8?B?dWdaeU1KQ1lZMFljRnNuSk55NktvSURYSk9PcXRtRlBRbjRhMEJTYUNNaWdV?=
 =?utf-8?B?U01rUE83aGNWak0xS3RUTmFsdkEwV0lJTEJqWEdMY2FvUEh6QUJPNXFKekVY?=
 =?utf-8?B?QmZ2a2hWSGNnaXE3MmFDcWJEMzFsMGZLL3lQQkwwS2lWYmpNTkE5L1ZBTVZC?=
 =?utf-8?B?ODJJZnRhYUlNRU9LUm15S1g1M3JlYnBQK2JrN3VZM2hjYUtGZ2RpS2tGWkto?=
 =?utf-8?B?OWFtaVFrVlFIc2V5djV0Y1FXOTVOL2FUOEVScHczby9wUllRS0tIeVdHbWdL?=
 =?utf-8?B?d3R5blUrWWtqTy9zM0crTUhaMXJSV05tSkxlUytyMHFZUGwwMmV6b2c2V2dI?=
 =?utf-8?B?KyswSjUwZzQzQUtLM1ZPRm9aK3J5NVBpejhlWWVmQytsRFE3NTVzTDdBcWxB?=
 =?utf-8?B?UFo2aTRvbjNtL3FHTUd2eS95bmdURm50RWZkYStiQ043dzcwVFRZR3kyZjdy?=
 =?utf-8?B?QldHa05iRUcrNnVyb2lxaVZGWnhqN1h2STRLbCtrVXZiVDNZQXdSd3MyTnRq?=
 =?utf-8?B?Y2tRWjJRNVRpMjZJWlZnZmtvR2JsN1Zna21yZDJQa3h3eXNZcGh3cXJXS013?=
 =?utf-8?B?eTcxRW4vRzdsaGRBYU51b1ZLSjRvR1Z6WDk1MzhENTJiZTY5WHZBRFRRSW1S?=
 =?utf-8?B?ZTkxeDhDcitqbFNicXFhSVR6TGZiY0F3d3ZxTjBEYzBVNlJHVEpPSlE1YXpk?=
 =?utf-8?B?cFlCYXZvT2hWOEtTWlZWTGNaN2hmQ0lRWktUeVordWxWOGZBMXZVeXh5d3BL?=
 =?utf-8?B?cGJoRGVNdFE5cjNBOFBJZVkrVlhpWEVTZVFzU2QrbWFRL1dvc2lGM0ZsZHNI?=
 =?utf-8?B?b01ET29XY1lXM1FDTzA4eHkzWFdNZkdEWTZoVVVLNTJ4R2xXOUxiem1jMVZz?=
 =?utf-8?B?WDhueE5JOTJaZFVnZS80MGVhd21rdXM0T2lWbHVvRHlGUEU5MXAvcXVyeVpS?=
 =?utf-8?B?cjhjMlVVMHhOa0YyeEtNclZMSXF3UHhVSGtwZXU1NWJLRlkraWZDMDh5MzhQ?=
 =?utf-8?B?THdDV1RhL0NoSTRFa3laVnk1cDN6dlVHZ1hxMkZkWUpqMkZIZ3p1cXA1a3pX?=
 =?utf-8?B?cWtoQ2VhZGg1UGdrMVRCMllEV3RnSmVUT0FXNDZMZklIa0FQYkFsQktxSFdw?=
 =?utf-8?B?ZDlveUFDMmgvK29jWnVrejhBakh6U2xDbHRjay96OUw1UXErbFFrbTJCTThP?=
 =?utf-8?B?VGphbU5YS2wrSE5jb2FRa3ZDektmVTQyeXEwMTMyaFBYdnJhc2ZVRXorQitz?=
 =?utf-8?B?WkRpVk93ZTIzc1Q3cG5ULzVjOWxYcmcvOWlDSFNhcjlVWGNLZmFaeXBMRzVj?=
 =?utf-8?B?ZkRZSHk1SElBcWlER3AwZkx0WlIvNy9tWXBxNkpNWTUrSmd6N05ueFJ6RXR3?=
 =?utf-8?B?MnFlcmoxVHhMcDFoWXFONTY2d2FWWUhNVld6MlVGUGZBUlNwanZjK1BLSmQ5?=
 =?utf-8?B?QkowbzhtUDB3WGNTYXdNMWltYzVsNzdxcDFhMDV3YUF6V3VwUCsxbTNPU1NN?=
 =?utf-8?B?S1FpRHdHVXREblQzaStZbStwSFBzU3k2cUhVYmFOY0RBbXlNbzZTdE4yVGJp?=
 =?utf-8?B?cUZoampORTR0VTRQczFHOW9uZzl3Q053UlI2U2Q4RHRYTjBnQWFONjh0dmJC?=
 =?utf-8?B?OUxoTU15RGVhRHVyUCs2R1llSkdubXBqTitGUGd3d1hzOFpUSnNya2wzejdl?=
 =?utf-8?B?THc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <252D53452878444382A76528C36875AC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710322f4-39ec-4685-25cb-08db3bc69596
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 02:27:10.2132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mXqP+4sMcWw8HDpgXfpCUNIj3I1sTrgR8v+LyvVGMXmB4m8/8+eKkOhwG2052cPr1UOqz05VHskbg4w3/7AHxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8202
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA0LTEzIGF0IDA5OjM2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE9u
IDQvMTIvMjAyMyA3OjU4IFBNLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gLS0tIGEvYXJjaC94
ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+ID4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20va3ZtX2hvc3QuaA0KPiA+ID4gQEAgLTcyOSw2ICs3MjksMTIgQEAgc3RydWN0IGt2bV92Y3B1
X2FyY2ggew0KPiA+ID4gICAJdW5zaWduZWQgbG9uZyBjcjBfZ3Vlc3Rfb3duZWRfYml0czsNCj4g
PiA+ICAgCXVuc2lnbmVkIGxvbmcgY3IyOw0KPiA+ID4gICAJdW5zaWduZWQgbG9uZyBjcjM7DQo+
ID4gPiArCS8qDQo+ID4gPiArCSAqIEJpdHMgaW4gQ1IzIHVzZWQgdG8gZW5hYmxlIGNlcnRhaW4g
ZmVhdHVyZXMuIFRoZXNlIGJpdHMgYXJlIGFsbG93ZWQNCj4gPiA+ICsJICogdG8gYmUgc2V0IGlu
IENSMyB3aGVuIHZDUFUgc3VwcG9ydHMgdGhlIGZlYXR1cmVzLiBXaGVuIHNoYWRvdyBwYWdpbmcN
Cj4gPiA+ICsJICogaXMgdXNlZCwgdGhlc2UgYml0cyBzaG91bGQgYmUga2VwdCBhcyB0aGV5IGFy
ZSBpbiB0aGUgc2hhZG93IENSMy4NCj4gPiA+ICsJICovDQo+ID4gSSBkb24ndCBxdWl0ZSBmb2xs
b3cgdGhlIHNlY29uZCBzZW50ZW5jZS4gIE5vdCBzdXJlIHdoYXQgZG9lcyAidGhlc2UgYml0cyBz
aG91bGQNCj4gPiBiZSBrZXB0IiBtZWFuLg0KPiA+IA0KPiA+IFRob3NlIGNvbnRyb2wgYml0cyBh
cmUgbm90IGFjdGl2ZSBiaXRzIGluIGd1ZXN0J3MgQ1IzIGJ1dCBhbGwgY29udHJvbCBiaXRzIHRo
YXQNCj4gPiBndWVzdCBpcyBhbGxvd2VkIHRvIHNldCB0byBDUjMuIEFuZCB0aG9zZSBiaXRzIGRl
cGVuZHMgb24gZ3Vlc3QncyBDUFVJRCBidXQgbm90DQo+ID4gd2hldGhlciBndWVzdCBpcyB1c2lu
ZyBzaGFkb3cgcGFnaW5nIG9yIG5vdC4NCj4gPiANCj4gPiBJIHRoaW5rIHlvdSBjYW4ganVzdCBy
ZW1vdmUgdGhlIHNlY29uZCBzZW50ZW5jZS4NCj4gDQo+IFllcywgeW91IGFyZSByaWdodC4gVGhl
IHNlY29uZCBzZW50ZW5jIGlzIGNvbmZ1c2luZy4NCj4gDQo+IEhvdyBhYm91dCB0aGlzOg0KPiAN
Cj4gKwkvKg0KPiArCSAqIEJpdHMgaW4gQ1IzIHVzZWQgdG8gZW5hYmxlIGNlcnRhaW4gZmVhdHVy
ZXMuIFRoZXNlIGJpdHMgYXJlIGFsbG93ZWQNCj4gKwkgKiB0byBiZSBzZXQgaW4gQ1IzIHdoZW4g
dkNQVSBzdXBwb3J0cyB0aGUgZmVhdHVyZXMsIGFuZCB0aGV5IGFyZSB1c2VkDQo+ICsJICogYXMg
dGhlIG1hc2sgdG8gZ2V0IHRoZSBhY3RpdmUgY29udHJvbCBiaXRzIHRvIGZvcm0gYSBuZXcgZ3Vl
c3QgQ1IzLg0KPiArCSAqLw0KPiANCg0KRmluZSB0byBtZSwgYnV0IElNSE8gaXQgY2FuIGJlIGV2
ZW4gc2ltcGxlciwgZm9yIGluc3RhbmNlOg0KDQoJLyoNCgkgKiBDUjMgbm9uLWFkZHJlc3MgZmVh
dHVyZSBjb250cm9sIGJpdHMuICBHdWVzdCdzIENSMyBtYXkgY29udGFpbg0KCSAqIGFueSBvZiB0
aG9zZSBiaXRzIGF0IHJ1bnRpbWUuDQoJICovDQoNCj4gDQo+ID4gDQo+ID4gPiArCXU2NCBjcjNf
Y3RybF9iaXRzOw0KPiA+ID4gICAJdW5zaWduZWQgbG9uZyBjcjQ7DQo+ID4gPiAgIAl1bnNpZ25l
ZCBsb25nIGNyNF9ndWVzdF9vd25lZF9iaXRzOw0KPiA+ID4gICAJdW5zaWduZWQgbG9uZyBjcjRf
Z3Vlc3RfcnN2ZF9iaXRzOw0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9jcHVpZC5o
IGIvYXJjaC94ODYva3ZtL2NwdWlkLmgNCj4gPiA+IGluZGV4IGIxNjU4YzBkZTg0Ny4uZWY4ZTFi
OTEyZDdkIDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL2NwdWlkLmgNCj4gPiA+ICsr
KyBiL2FyY2gveDg2L2t2bS9jcHVpZC5oDQo+ID4gPiBAQCAtNDIsNiArNDIsMTEgQEAgc3RhdGlj
IGlubGluZSBpbnQgY3B1aWRfbWF4cGh5YWRkcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4g
PiAgIAlyZXR1cm4gdmNwdS0+YXJjaC5tYXhwaHlhZGRyOw0KPiA+ID4gICB9DQo+ID4gPiAgIA0K
PiA+ID4gK3N0YXRpYyBpbmxpbmUgYm9vbCBrdm1fdmNwdV9pc19sZWdhbF9jcjMoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCB1bnNpZ25lZCBsb25nIGNyMykNCj4gPiA+ICt7DQo+ID4gPiArCXJldHVy
biAhKChjcjMgJiB2Y3B1LT5hcmNoLnJlc2VydmVkX2dwYV9iaXRzKSAmIH52Y3B1LT5hcmNoLmNy
M19jdHJsX2JpdHMpOw0KPiA+ID4gK30NCj4gPiA+ICsNCj4gPiA+ICAgc3RhdGljIGlubGluZSBi
b29sIGt2bV92Y3B1X2lzX2xlZ2FsX2dwYShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGdw
YSkNCj4gPiA+ICAgew0KPiA+ID4gICAJcmV0dXJuICEoZ3BhICYgdmNwdS0+YXJjaC5yZXNlcnZl
ZF9ncGFfYml0cyk7DQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS5oIGIvYXJj
aC94ODYva3ZtL21tdS5oDQo+ID4gPiBpbmRleCAxNjhjNDZmZDhkZDEuLjI5OTg1ZWViOGUxMiAx
MDA2NDQNCj4gPiA+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUuaA0KPiA+ID4gKysrIGIvYXJjaC94
ODYva3ZtL21tdS5oDQo+ID4gPiBAQCAtMTQyLDYgKzE0MiwxMSBAQCBzdGF0aWMgaW5saW5lIHVu
c2lnbmVkIGxvbmcga3ZtX2dldF9hY3RpdmVfcGNpZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+
ID4gPiAgIAlyZXR1cm4ga3ZtX2dldF9wY2lkKHZjcHUsIGt2bV9yZWFkX2NyMyh2Y3B1KSk7DQo+
ID4gPiAgIH0NCj4gPiA+ICAgDQo+ID4gPiArc3RhdGljIGlubGluZSB1NjQga3ZtX2dldF9hY3Rp
dmVfY3IzX2N0cmxfYml0cyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gPiArew0KPiA+ID4g
KwlyZXR1cm4ga3ZtX3JlYWRfY3IzKHZjcHUpICYgdmNwdS0+YXJjaC5jcjNfY3RybF9iaXRzOw0K
PiA+ID4gK30NCj4gPiA+ICsNCj4gPiA+ICAgc3RhdGljIGlubGluZSB2b2lkIGt2bV9tbXVfbG9h
ZF9wZ2Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ID4gICB7DQo+ID4gPiAgIAl1NjQgcm9v
dF9ocGEgPSB2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGE7DQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gPiA+IGluZGV4
IGM4ZWJlNTQyYzU2NS4uZGUyYzUxYTBiNjExIDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYv
a3ZtL21tdS9tbXUuYw0KPiA+ID4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiA+ID4g
QEAgLTM3MzIsNyArMzczMiwxMSBAQCBzdGF0aWMgaW50IG1tdV9hbGxvY19zaGFkb3dfcm9vdHMo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ID4gICAJaHBhX3Qgcm9vdDsNCj4gPiA+ICAgDQo+
ID4gPiAgIAlyb290X3BnZCA9IG1tdS0+Z2V0X2d1ZXN0X3BnZCh2Y3B1KTsNCj4gPiA+IC0Jcm9v
dF9nZm4gPSByb290X3BnZCA+PiBQQUdFX1NISUZUOw0KPiA+ID4gKwkvKg0KPiA+ID4gKwkqIFRo
ZSBndWVzdCBQR0QgaGFzIGFscmVhZHkgYmVlbiBjaGVja2VkIGZvciB2YWxpZGl0eSwgdW5jb25k
aXRpb25hbGx5DQo+ID4gPiArCSogc3RyaXAgbm9uLWFkZHJlc3MgYml0cyB3aGVuIGNvbXB1dGlu
ZyB0aGUgR0ZOLg0KPiA+ID4gKwkqLw0KPiANCj4gVGhlIGNvbW1lbnQgaGVyZSBpcyB0byBjYWxs
IG91dCB0aGF0IHRoZSBzZXQgbm9uLWFkZHJlc3MgYml0KHMpIGhhdmUgDQo+IGJlZW4gY2hlY2tl
ZCBmb3IgbGVnYWxpdHkNCj4gYmVmb3JlLCBpdCBpcyBzYWZlIHRvIHN0cmlwIHRoZXNlIGJpdHMu
DQo+IA0KPiANCj4gPiBEb24ndCBxdWl0ZSBmb2xsb3cgdGhpcyBjb21tZW50IGVpdGhlci4gIENh
biB3ZSBqdXN0IHNheToNCj4gPiANCj4gPiAJLyoNCj4gPiAJICogR3Vlc3QncyBQR0QgbWF5IGNv
bnRhaW4gYWRkaXRpb25hbCBjb250cm9sIGJpdHMuICBNYXNrIHRoZW0gb2ZmDQo+ID4gCSAqIHRv
IGdldCB0aGUgR0ZOLg0KPiA+IAkgKi8NCj4gPiANCj4gPiBXaGljaCBleHBsYWlucyB3aHkgaXQg
aGFzICJub24tYWRkcmVzcyBiaXRzIiBhbmQgbmVlZHMgbWFzayBvZmY/DQo+IA0KPiBIb3cgYWJv
dXQgbWVyZ2UgdGhpcyBjb21tZW50Pw0KDQpObyBzdHJvbmcgb3Bpbmlvbi4gIA0KDQo+IA0KPiAN
Cj4gPiANCj4gPiA+ICsJcm9vdF9nZm4gPSAocm9vdF9wZ2QgJiBfX1BUX0JBU0VfQUREUl9NQVNL
KSA+PiBQQUdFX1NISUZUOw0KPiA+IE9yLCBzaG91bGQgd2UgZXhwbGljaXRseSBtYXNrIHZjcHUt
PmFyY2guY3IzX2N0cmxfYml0cz8gIEluIHRoaXMgd2F5LCBiZWxvdw0KPiA+IG1tdV9jaGVja19y
b290KCkgbWF5IHBvdGVudGlhbGx5IGNhdGNoIG90aGVyIGludmFsaWQgYml0cywgYnV0IGluIHBy
YWN0aWNlIHRoZXJlDQo+ID4gc2hvdWxkIGJlIG5vIGRpZmZlcmVuY2UgSSBndWVzcy4NCj4gDQo+
IEluIHByZXZpb3VzIHZlcnNpb24sIHZjcHUtPmFyY2guY3IzX2N0cmxfYml0cyB3YXMgdXNlZCBh
cyB0aGUgbWFzay4NCj4gDQo+IEhvd2V2ZXIsIFNlYW4gcG9pbnRlZCBvdXQgdGhhdCB0aGUgcmV0
dXJuIHZhbHVlIG9mIA0KPiBtbXUtPmdldF9ndWVzdF9wZ2QodmNwdSkgY291bGQgYmUNCj4gRVBU
UCBmb3IgbmVzdGVkIGNhc2UsIHNvIGl0IGlzIG5vdCByYXRpb25hbCB0byBtYXNrIHRvIENSMyBi
aXQocykgZnJvbSBFUFRQLg0KDQpZZXMsIGFsdGhvdWdoIEVQVFAncyBoaWdoIGJpdHMgZG9uJ3Qg
Y29udGFpbiBhbnkgY29udHJvbCBiaXRzLg0KDQpCdXQgcGVyaGFwcyB3ZSB3YW50IHRvIG1ha2Ug
aXQgZnV0dXJlLXByb29mIGluIGNhc2Ugc29tZSBtb3JlIGNvbnRyb2wgYml0cyBhcmUNCmFkZGVk
IHRvIEVQVFAgdG9vLg0KDQo+IA0KPiBTaW5jZSB0aGUgZ3Vlc3QgcGdkIGhhcyBiZWVuIGNoZWNr
IGZvciB2YWxhZGl0eSwgZm9yIGJvdGggQ1IzIGFuZCBFUFRQLCANCj4gaXQgaXMgc2FmZSB0byBt
YXNrIG9mZg0KPiBub24tYWRkcmVzcyBiaXRzIHRvIGdldCBHRk4uDQo+IA0KPiBNYXliZSBJIHNo
b3VsZCBhZGQgdGhpcyBDUjMgVlMuIEVQVFAgcGFydCB0byB0aGUgY2hhbmdlbG9nIHRvIG1ha2Ug
aXQgDQo+IG1vcmUgdW5kZXJ0YW5kYWJsZS4NCg0KVGhpcyBpc24ndCBuZWNlc3NhcnksIGFuZCBj
YW4vc2hvdWxkIGJlIGRvbmUgaW4gY29tbWVudHMgaWYgbmVlZGVkLg0KDQpCdXQgSU1ITyB5b3Ug
bWF5IHdhbnQgdG8gYWRkIG1vcmUgbWF0ZXJpYWwgdG8gZXhwbGFpbiBob3cgbmVzdGVkIGNhc2Vz
IGFyZQ0KaGFuZGxlZC4NCg==
