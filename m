Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED25C736952
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 12:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjFTKbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 06:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjFTKbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 06:31:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A6C101;
        Tue, 20 Jun 2023 03:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687257081; x=1718793081;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yI4omlTXFR1UG5OHkrNrTrBKn7sxyGgA+B6jqg2g9SE=;
  b=PYDv+He16IdUm2cIiTyIAW5hWAlU7+/u5nGRLT5d3KGtbPUpfEei5GPs
   zjDfkz++qwmY7Nz7Lgje2lao7IscQwOBwb1lRkqz5WyU6IVcYYeQzAfeF
   Ds8Fjl/2JDGxXtufJlMo2vB9F2PX4LL+dy4WP4LKIdLV/yjAprNfJuVRB
   OWbgiWsQmBKHZVi6EcNqWWCbFDgcbCFRSlyHqqRyC3j3BGeHf3HLxSwVj
   NXE4AztsyWeatXE/S1eJ0HnBRU0Y1n+98NTMFLo0nBpwmIsz5jnbx1TL6
   pduSJJqhmybY2xHXBlCq+fv2VSfZ+yIW0+/I9JflylBMauhvB9OwBQ8WO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="362365525"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="362365525"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 03:31:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="803893793"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="803893793"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jun 2023 03:31:20 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 03:31:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 03:31:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 03:31:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8/gIpxzIVGTpSxrTrB4XAXITED1/mIGCP8j/R8+f5Mp8BvXMOMGx4KbqHDE+E4XAwOKG4wMhP99cBcZsUgfLY6CbjtqEDwxXt7f0Rewys+zhZGLxfM1JcY0U9Kqvs84mrTnVnq+CwLS17z3diIGvV+jvWiv8voTvwLhmk/HO8EpY91xBUUb86zkYan8xRWSFGn5aBlPfT5/pUSBsXBZJbFxdYLpnluLU4v7UJ/4Kn3IbY4jbUJklknfqAZr1eeLH2ud5sJNpTGCi3fg740ou1UsVcTqPGtGsIP7v6f7ekQXKWFm5/zy+PfifS86TmMK/h65jFodquzpraRAR35FBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yI4omlTXFR1UG5OHkrNrTrBKn7sxyGgA+B6jqg2g9SE=;
 b=IYfmhCpH+62k3M846Gnt1E0PmwsR2/F2etMv1fVPmdes24F4joXTASomLFrbIVK6bCilkh/esfhJTpEs+YcI39gMHkI79yG4zDuzmDzGdhx108bRQSk5pYFXUNdwXJQElWihDyzsxVs5szYNYxbFsnUOoDQE3S/EgG3htAfz5M2+4DXcdBOvsO5DcIFqRQ8Z7xY/UtU9OzQFW5IV+Q4GekdUBdAHaOPvw7pWbyBPsV2CBHeJGSadGrEG/QzWhvoTHt1EHvVg8TOGwcUcp3PfWR3myWfzFt8pwXlPwF5pjjWapUIBY5pZ51On/0TXWbhgez2IJzWFfgeROEdLq7IJ2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6264.namprd11.prod.outlook.com (2603:10b6:8:a5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Tue, 20 Jun 2023 10:31:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 10:31:17 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
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
Thread-Index: AQHZlu+rViPY+CkNoE2o6SSiJzjZxK+SI0uAgAFzggA=
Date:   Tue, 20 Jun 2023 10:31:16 +0000
Message-ID: <b4ad8dd3f626632776265fbb7ba78cb1dcb2fe31.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
         <723dd9da-ebd5-edb0-e9e5-2d8c14aaffe2@redhat.com>
In-Reply-To: <723dd9da-ebd5-edb0-e9e5-2d8c14aaffe2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6264:EE_
x-ms-office365-filtering-correlation-id: 288453e5-0a8e-4558-02ef-08db71797ae3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UlDLSeJKQPLSninKcnjQVBHz6epVFw6pzhBoQhTM2BWGazkWiCmMs5P8hsYGlfTlvZ2qdJy3I39NbIoMEhDkva6s95rfu73QkxJoGB8KPoPddq2CfXqeRNB6rcO8r4ORE7hstHT1fuNznYM/k+HQCNRUgNmh2T9GFdzhJVoXxzLdeebq/0V2th3DwYB4BgCQ6ukAz53d8TkBaBVKssbWajh7X7M6GhplM842U1YVu6grhMJKZTJAbp/YmRN4vY9DbYfZKJFwI7/B8Wc6/ebYWlWpBlNuRf/Mwd80zohc2/hJ+x90I+Qd8Fy0qv5zreAdZr5pXOG/+xPaG2mfXTVoa/qURE8fxPBPwZbpCcVmuDu6LRO5zKEoXqnrBcutViCkHAdvtE24ZUXl3CK9nX7KA40uv/mOCAWOnXu2WvVJT43Z67frMxawfIGw+y0Hci3f+8SUxE16tnt7rSB/U169dnbBANTq0ygxPu0a+Kcn8dbRPYh7hhwCPkg2bGjWJdkrB3OuTPmId8b9xK9N/gowoQQ9cCXzfXx3P8E3gQk8+ii/GrGJ7njgwT6wpSd+LUG+2S0L8c7ujy9GvUPmZ58rF4ZSroEb7rdXb5o66pEgB5MDFyPrpDCSl5YIundTOoM9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199021)(478600001)(2906002)(54906003)(6486002)(2616005)(110136005)(86362001)(71200400001)(122000001)(38070700005)(26005)(186003)(6506007)(6512007)(53546011)(8936002)(8676002)(66476007)(76116006)(66446008)(66556008)(64756008)(66946007)(7416002)(36756003)(91956017)(5660300002)(38100700002)(316002)(4326008)(83380400001)(82960400001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVM0Vm9aK1NITnY2Z2hTdFRueEo0UzBSUTRqTzdidDA5WWR2VFYxWmZvclBU?=
 =?utf-8?B?WHdubEV2UWE3amcxK2s5YkcydWg2MFU3K1RyWnltVTkrTUM4WVpBSExWbUND?=
 =?utf-8?B?SmE2REJsQjJPL2c2TVB4bWxpOXZtbEtDN2ZnM0JTd0NMY1IxUkRoNkVFZDYw?=
 =?utf-8?B?bzN3cjdsTnFCTjRCNFVTUVZLU25aZEFSWkR0dDRVWEloN1pKeElqVGFHME0r?=
 =?utf-8?B?VGhyODllZHF6VHpzZ3luaDh4Z2c0Q2dMU0QwbFhkTnJZVmJxQ1Z1eWFLd2wv?=
 =?utf-8?B?aGIzdzA4enBzcDNJb3pabkhyWUVyNlo5VjVzbDdXRFI2U1gzYWNQaTNhcjFC?=
 =?utf-8?B?dzUwVkM5cHNBR1hOUThINGNBd1RmWGZtRDNmT1pvOEJrSzFyajV1QVFlN2Rh?=
 =?utf-8?B?dG5HaGVCNU15UDRmeTAxTDVkV05BeHRJcVNST1RXNkNKd3B1aEtZc2cyMnFZ?=
 =?utf-8?B?RkEvNCtjZlJ0REtGaS95YnFqUzdwUTA4OUJ3TVhNZWw3WFl0dWNQak1SUjVj?=
 =?utf-8?B?NXdRT3ZyQ2dTMzhzV0pIcmxaVk5oRzd6d1JoWjlQaUNDTEl4VTJ0eGFrQ1hy?=
 =?utf-8?B?bXcxVzFmbUJkMFNHbkJ3aTJHWTNkZURxOHYzMkEzSUREQnNXT3pJT0pQQTFr?=
 =?utf-8?B?QUxBV1dyQjRIanZmQUVTOHhQa011SThteGVteGFTQTZWMkF4cEZtMmh0czVq?=
 =?utf-8?B?VmFsUEdwV1RwTzVXQnZBY0g0NmE3RzJCaFlERU9SM0NRR1VRTW4wcTM1UFky?=
 =?utf-8?B?R2poM0VjekdiSTNDMVAzcmYyWFNUL1I0THA5NU5WZnkwcE1tRWdmZ2F3S2hV?=
 =?utf-8?B?bGZmemM0ZlNSYWJOeHlydlVXbEFzdmxmTGNWb0Vuc1ZLdlFOL29hNkx4Um1P?=
 =?utf-8?B?VzBhR3c0SFQvMEM2UW40eGpkQWJFU0tPZmVJU2FNck5MT29tN1JVMkV5VFB3?=
 =?utf-8?B?eXM0UHlYVWg5b3hSMExCUDlpd1BMSngyekdUV3pkZy9lSkdLQjVGNDVpdjRR?=
 =?utf-8?B?VEtHcnh2SVlsQ1oyR2xSaU1Ba2xETlBFcnRLc0pnQUJSU1FvY05pNlJveFdj?=
 =?utf-8?B?M2ZEa2FDeWdLZHRKVk5UcWVnZ2R4U2VuOEZ0OGlVOGV4YWErS3hZYWpieVRZ?=
 =?utf-8?B?YkZmcE1JUVdEdEZhY0ZCaWNyYjcwbmR4R0doL1F3R3BpRVJIVU9ydlFxdW85?=
 =?utf-8?B?M2pnVWlGemFFQzFDeXdacDJDUGNSQTJXTzAyS2t6L3dFY0U3NmU5MWNUNjlO?=
 =?utf-8?B?Ky91RGNEQU9SM0hWcndBMFV3VVREdUlTbHkybmdxWU1DSWoyM0gvbGhDZ1Zu?=
 =?utf-8?B?eTJBWDcxeEgyS2trbHdOMHFPOVM1bkZPTkEvcEx2WEVEMU5XU1NtWXZkMEtQ?=
 =?utf-8?B?L1ZwR0liQllOdkU0QUJ3c3htOXgwVlk4QTJaWFVyenkyWURGRWlZc2RTTjY3?=
 =?utf-8?B?aG1HTm1yS3ZybHNBdGRTcURNd3JzOU1UN2pYRzJzNEdzYzhPN09IQ0dRclJG?=
 =?utf-8?B?U21ab2lCdlBJVlFSWWVaZ3lBZkFBcmdjd0Nidys0dnlHQ0NzWkxMQ1orWmgw?=
 =?utf-8?B?bXZna2ZORHJBMm4wSDF1TXJaVUkrMnk1a2cyd3lUVTdxU2xLR0ZhUnQ1am1X?=
 =?utf-8?B?TFBmL3lhUFE4Ni9abzNhRzUzSTNXci84V3FoVmtzMDNFOTNjVlRGOGdGTTZM?=
 =?utf-8?B?cUxhTmNEY3BEL1dmd29YTTMyTWc5RzdQVmFCRWJWSDd3ZlJyNjI0dWNoOXhG?=
 =?utf-8?B?VzNlL1dSSnluUElKbVNqMEFaa1JXYXAvNWxqZGZTZVJRamQvOTd6bEw5Yjh6?=
 =?utf-8?B?d2NFTDNsY3lUOVZyaGdmdjlPejlTaTVGbi80U1NST2FuR2ZwSnI1QXlKcmFY?=
 =?utf-8?B?ZjZvMFNqaytJb1dybndQNGJsenlBS1E2MVhzSDFST1V0R0dJTyt6RWduNG1v?=
 =?utf-8?B?OEhnUmY5STRBa3JsZXh1dDlRckYvdmtnMGJkSGtqTkh0cUE4WXBqYXhqWGxa?=
 =?utf-8?B?ZnZxOTdHVFVrNWRHSmdOT1VWWERnRkpOTU13VFpUV1p4NHU2KzQ2S3ZVQnNR?=
 =?utf-8?B?aXhqdVdySGt1cnh2M05pNlplWWpBYlFGSHZTMmw5VlQrTjJiVE9HQ256emdh?=
 =?utf-8?B?OUszSThyVXFOZFZrMnBHaUJ0Q2VhTkNJYUtXKzAzZ0k5VUxpSDl3bC9rOFNC?=
 =?utf-8?B?U3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39968D7A45AB1740B97E32EE26ECEBE3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 288453e5-0a8e-4558-02ef-08db71797ae3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 10:31:16.9342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CYYn1UbX8QMrapq4LbK/XVG4DrgMYz+Gwn5e5wt/9MgDYuVucecMOc0gCCWIOmc2KpecqOmbX3mP+MWGOy5XPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6264
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDE0OjIxICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMDQuMDYuMjMgMTY6MjcsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBURFggbWVtb3J5
IGhhcyBpbnRlZ3JpdHkgYW5kIGNvbmZpZGVudGlhbGl0eSBwcm90ZWN0aW9ucy4gIFZpb2xhdGlv
bnMgb2YNCj4gPiB0aGlzIGludGVncml0eSBwcm90ZWN0aW9uIGFyZSBzdXBwb3NlZCB0byBvbmx5
IGFmZmVjdCBURFggb3BlcmF0aW9ucyBhbmQNCj4gPiBhcmUgbmV2ZXIgc3VwcG9zZWQgdG8gYWZm
ZWN0IHRoZSBob3N0IGtlcm5lbCBpdHNlbGYuICBJbiBvdGhlciB3b3JkcywNCj4gPiB0aGUgaG9z
dCBrZXJuZWwgc2hvdWxkIG5ldmVyLCBpdHNlbGYsIHNlZSBtYWNoaW5lIGNoZWNrcyBpbmR1Y2Vk
IGJ5IHRoZQ0KPiA+IFREWCBpbnRlZ3JpdHkgaGFyZHdhcmUuDQo+ID4gDQo+ID4gQWxhcywgdGhl
IGZpcnN0IGZldyBnZW5lcmF0aW9ucyBvZiBURFggaGFyZHdhcmUgaGF2ZSBhbiBlcnJhdHVtLiAg
QQ0KPiA+ICJwYXJ0aWFsIiB3cml0ZSB0byBhIFREWCBwcml2YXRlIG1lbW9yeSBjYWNoZWxpbmUg
d2lsbCBzaWxlbnRseSAicG9pc29uIg0KPiA+IHRoZSBsaW5lLiAgU3Vic2VxdWVudCByZWFkcyB3
aWxsIGNvbnN1bWUgdGhlIHBvaXNvbiBhbmQgZ2VuZXJhdGUgYQ0KPiA+IG1hY2hpbmUgY2hlY2su
ICBBY2NvcmRpbmcgdG8gdGhlIFREWCBoYXJkd2FyZSBzcGVjLCBuZWl0aGVyIG9mIHRoZXNlDQo+
ID4gdGhpbmdzIHNob3VsZCBoYXZlIGhhcHBlbmVkLg0KPiA+IA0KPiA+IFZpcnR1YWxseSBhbGwg
a2VybmVsIG1lbW9yeSBhY2Nlc3NlcyBvcGVyYXRpb25zIGhhcHBlbiBpbiBmdWxsDQo+ID4gY2Fj
aGVsaW5lcy4gIEluIHByYWN0aWNlLCB3cml0aW5nIGEgImJ5dGUiIG9mIG1lbW9yeSB1c3VhbGx5
IHJlYWRzIGEgNjQNCj4gPiBieXRlIGNhY2hlbGluZSBvZiBtZW1vcnksIG1vZGlmaWVzIGl0LCB0
aGVuIHdyaXRlcyB0aGUgd2hvbGUgbGluZSBiYWNrLg0KPiA+IFRob3NlIG9wZXJhdGlvbnMgZG8g
bm90IHRyaWdnZXIgdGhpcyBwcm9ibGVtLg0KPiANCj4gU28sIG9yZGluYXJ5IHdyaXRlcyB0byBU
RCBwcml2YXRlIG1lbW9yeSBhcmUgbm90IGEgcHJvYmxlbT/CoA0KPiANCg0KTm90IGEgcHJvYmxl
bSBmb3IgdGhlIGtlcm5lbCBhcyBzdWNoIHdyaXRlIHdvbid0IHBvaXNvbiB0aGUgbWVtb3J5IGRp
cmVjdGx5LCBzbw0KaWYgdGhlIGtlcm5lbCByZWFkcyB0aG9zZSBtZW1vcnkgdGhlcmUgd29uJ3Qg
YmUgI01DLg0KDQpIb3dldmVyIGlmIFREWCBndWVzdCByZWFkcyB0aG9zZSBtZW1vcnkgKHdoaWNo
IHdhcyBwcmV2aW91cyB3cml0dGVuIGJ5IGtlcm5lbCBvcg0KdXNlcnNwYWNlKSwgdGhlIG1lbW9y
eSBpcyBtYXJrZWQgYXMgcG9pc29uIHdoZW4gcmVhZCBhbmQgI01DIGlzIHRyaWdnZXJlZC4NCg0K
PiBJIHRob3VnaHQgDQo+IG9uZSBtb3RpdmF0aW9uIGZvciB0aGUgdW5tYXBwZWQtZ3Vlc3QtbWVt
b3J5IGRpc2N1c3Npb24gd2FzIHRvIHByZXZlbnQgDQo+IGhvc3QgKHVzZXJzcGFjZSkgd3JpdGVz
IHRvIHN1Y2ggbWVtb3J5IGJlY2F1c2UgaXQgd291bGQgdHJpZ2dlciBhIE1DIGFuZCANCj4gZXZl
bnR1YWxseSBjcmFzaCB0aGUgaG9zdC4NCg0KWWVhaCB0aGUgI01DIHdpbGwgYmUgdHJpZ2dlcmVk
IGluc2lkZSB0aGUgVERYIGd1ZXN0LiAgSSB0aGluayBpbiBtb3N0IGNhc2VzIHN1Y2gNCiNNQyB3
b24ndCBjYXVzZSBob3N0IGtlcm5lbCBjcmFzaCBidXQgb25seSB0aGUgdmljdGltIFREWCBndWVz
dCBpcyBraWxsZWQuICBCdXQNCnRoZXJlIG1pZ2h0IGJlIHNvbWUgY2FzZXMgd2UgbWF5IG5vdCBi
ZSBhYmxlIHRvIGhhbmRsZSAjTUMgZ3JhY2VmdWxseSwgZS5nLiwgaW4NCnNvbWUgcGFydGljdWxh
ciBCSU9TIHNldHRpbmcuICBPbmUgZXhhbXBsZSBpcyB3aXRoIExNQ0UgZGlzYWJsZWQsIGFueSAj
TUMgd291bGQNCmJlIGJyb2FkY2FzdCB0byBhbGwgTFBzIGNhdXNpbmcgYWxsIG90aGVyIFREWCBn
dWVzdHMgcnVubmluZyBvbiBvdGhlciBMUHMgYmVpbmcNCmtpbGxlZC4NCg0KQWxzbyBxdW90ZWQg
ZnJvbSBDaGFvLCBQZW5nLCB3aG8gaGFzIGJlZW4gd29ya2luZyBvbiB0aGUgdW5tYXBwZWQtZ3Vl
c3QtbWVtb3J5DQpzaW5jZSBlYXJseSB0aW1lOg0KDQoiDQpUaGUgcHJvYmxlbSBpcyB3ZSBtYXkg
bm90IGFsd2F5cyBiZSBhYmxlIHRvIGhhbmRsZSAjTUMgZ3JhY2VmdWxseSwgaW4NCnNvbWUgY29u
ZmlndXJhdGlvbnMgKEJJT1Mgc2V0dGluZ3MpIHRoZSAjTUMgY2FuIGNhdXNlIHRoZSB3aG9sZSBz
eXN0ZW0NCnJlc2V0LCBub3QganVzdCBraWxsIHRoZSBURC4gQXQgbGVhc3QgdGhpcyBpcyB0aGUg
b3JpZ2luYWwgbW90aXZhdGlvbg0KZm9yIEludGVsIHRvIHN0YXJ0IHRoaXMgc2VyaWVzLiBJIHRo
aW5rIHRoZSBjYXNlIGlzIHN0aWxsIHRydWUgdW5sZXNzIEkNCm1pc3NlZCBzb21ldGhpbmcuIEZy
b20gS1ZNIGNvbW11bml0eSwgdGhleSBoYXZlIG1vdGl2YXRpb24gdG8gdW5tYXAgdGhlDQpwcml2
YXRlIG1lbW9yeSBmcm9tIHVzZXJzcGFjZSBldmVuIHRoZSAjTUMgaXMgbm90IGZhdGFsLCBqdXN0
IHRvIHByZXZlbnQNCnBvc3NpYmxlIHVuaW50ZW5kZWQgYWNjZXNzZXMgZnJvbSB1c2Vyc3BhY2Ug
KHRoYXQncyB3aHkgdGhleSBhc2sgQU1EIHRvDQp1c2UgdGhpcyBzZXJpZXMgZXZlbiB0aGVpciBt
YWNoaW5lIGRvZXNuJ3QgY2F1c2Ugc3lzdGVtIHJlc2V0IHdoZW4gdGhlDQpzYW1lIGhhcHBlbnMp
Lg0KIg0KDQo+IA0KPiBJIHJlY2FsbCB0aGF0IHRoaXMgd291bGQgaGFwcGVuIGVhc2lseSAobm90
IGp1c3QgaW4gc29tZSB3ZWlyZCAicGFydGlhbCIgDQo+IGNhc2UgYW5kIHRoYXQgdGhlIHNwZWMg
d291bGQgYWxsb3cgZm9yIGl0KQ0KDQpObyBhcyBtZW50aW9uZWQgYWJvdmUsIHRoaXMgcGFydGlh
bCB3cml0ZSAjTUMgaXMgZGlmZmVyZW50IGZyb20gdGhlIG9uZQ0KdHJpZ2dlcmVkIGluIFREWCBn
dWVzdCBhcyBtZW50aW9uZWQgYWJvdmUuDQoNCj4gDQo+IDEpIERvZXMgdGhhdCwgaW4gZ2VuZXJh
bCwgbm90IGhhcHBlbiBhbnltb3JlICh3YXMgdGhlIGhhcmR3YXJlIGZpeGVkPyk/DQo+IA0KPiAy
KSBXaWxsIG5ldyBoYXJkd2FyZSBwcmV2ZW50LyJmaXgiIHRoYXQgY29tcGxldGVseSAod2FzIHRo
ZSBzcGVjIHVwZGF0ZWQ/KT8NCg0KWWVzIHRoaXMgZXJyYXR1bSB3aWxsIGJlIGZpeGVkIGluIGxh
dGVyIGdlbmVyYXRpb25zIG9mIFREWCBoYXJkd2FyZS4gIEl0ICBvbmx5DQphcHBlYXJzIG9uIFNQ
UiBhbmQgRU1SICh0aGUgZmlyc3QgdHdvIGdlbmVyYXRpb25zIG9mIFREWCBoYXJkd2FyZSkuDQoN
Cg0KDQo=
