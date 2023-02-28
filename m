Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7859B6A589B
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 12:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjB1LxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 06:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbjB1LxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 06:53:10 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43272A5F6;
        Tue, 28 Feb 2023 03:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677585185; x=1709121185;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eN/JWIuVPoixJ1sNUdikZZAkYyW9hwWwzzhoBDGSGns=;
  b=VcOc5RQJS8gBkiqqhoPfPFSmrZm+4RewxB5lJLD7BZIkseMKl3epnkXt
   R3+skLW1MsYOWydO8xQl3mR0Rc13hp9pv8lPoLQk6Opy5BIeAKvoTDy9g
   XJdSGfpzZtRoKRSIhyqDMwQ6+oU3vuHgjGfazxMo6HxKOyc7SlOag4OjO
   bBunzjfK0Mczya8FT43oXTHBQSq6sWyIZDg4s5y8XaSRjOApuoX4UQ8Qx
   oT7sW7GK/EQEXCvfCTKUVM7XnhE9SFBFLNCESGB4vvenCsLPqabM1ZLrJ
   XsD+xRjfnAQqOAM5qjGhdI+qObdFk94ReXG4s33qjkNeMjv96anRb3rOv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="332842464"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="332842464"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 03:53:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="783808655"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="783808655"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 28 Feb 2023 03:53:02 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 03:53:02 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 03:53:02 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 03:53:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbOyoyQNcyrXRlCw+QJ2V5jNXZoVligC+b+MParYGTb6Qb4GgxHRERGdbOBRXdGGDuPDZCrzR5Kbu0+J6XLrPC4KEiuCVWKF9RuAHO9W0Jn9ZqimmTgRLkr8/1679baBconlcVA8riafn/kVuOv60WY2aDv+RBwD9OrmnEPM2J7o8FZ+K9VVioNTBZl13L1sXF69ZVpjCMkVUEvvMYf/JaHfHamXY70TWPOKemphz7BQ8rgZQaYoLXTToFBj7rpwfjf9fmHPvQxRpH5Iw1TCywUPG7lWdyN+uVA/mCiA9gchQvSCnpKlgi1P6efONqJhyeyWUmMgpFFkuyDuEcZHZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eN/JWIuVPoixJ1sNUdikZZAkYyW9hwWwzzhoBDGSGns=;
 b=ZVVMWZXetfmMNPtAs+emTcUi/QV3NvxNnnzyn/3tB9/pCDs5vKRf1tGyfzgC8E7CF20GTqjwZ5C+6T/JAdwsoMUu7+weGD6urCyBLKdoSUDyLnHPv0nY625hpk/D9pvR5rta8968Ptg5rI22U5y0x+hFcGXZr7SRITegIFIk0wDZHAIZ9/HnQxVaxCnmTHKJXH+JUeGAb6Te1cWPHcxRI2jUEatJpVlljGwuD3SM+J7G1Zn3fRNwRvJpvmcXmhY5/91DMU1WS8ZntFh3/1JnqJkI4dfcOhbR30VHVtxnWAhjo3sU09bXDG7y29VrqGnByNE3dXzTY56XJ+LiAQ3ZXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6186.namprd11.prod.outlook.com (2603:10b6:930:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 11:53:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 11:53:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Thread-Topic: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Thread-Index: AQHZJqT+Gmb2zZevo06P/V36G5cIjK6k8UOAgD+K4ACAAAz4gA==
Date:   Tue, 28 Feb 2023 11:52:59 +0000
Message-ID: <7dd3b2a9406bdfd574ae12f0f4651e3fe6c4b82a.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
         <76cd219cadf3f5e06eb10b592de121ed0db056eb.camel@intel.com>
         <20230228110632.GV4175971@ls.amr.corp.intel.com>
In-Reply-To: <20230228110632.GV4175971@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6186:EE_
x-ms-office365-filtering-correlation-id: 8ed1c26d-4ee5-4817-34cc-08db1982570d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HBsGfSTFPleNgqFJoi/+qPXRbDlyaa/9GHjFxleIqLAv71xRHVIzhiZiUPGSG2MunhNCz6u1uvCxDfBSXI67sJbM5wbwp6afOnc2p1OqPtqM1Hc2NDIr80G6C0kiwvziSnSmWyKyPu0yBonJjwv5Mo15UDxqpGSrgnvQRl+Ci3WiLH9uMHXoYHisfTY3G92rxpZ7YRpgtc66H8/I/ctikUrJ6mbsefWhVRpl/XDJivSS9W77G8iByOfFTfBF1+ay0T5ggD6ZfThAoLEcsjIWTMdphR4/yefvx5Dch0odq5GRt5dNclzJI9WNAjvuVmmU8Oo833FVySTvUELv7t4mUaFxTlCUFM/778QKBv9mpmiFhgKpuwmHMuFR+DwnwnJ24LG1mfG5aqqbPAYuG+wlfkVAKjSTrC9IAiqWP9J+AGoOTl9NTUhFXYgZtlVlFl+nhfsqGqBM7Kv3I+cZD1Vm2qU1k+HG/MXqPKNTcg9x133yaiRaaG/bEoGtrx38umvuBf1XEwljCNKPw8BXcgs/eWJvfZZBbkLpmp9De8rbF2qh5YHbwei0fvctLpVSk2cg8qFXtFUgJWSYH9O6a1+6WNWkfhCKyUr47i9N2zdApgkYSVUcPP1SZlYXJal/zxTvClPdlmCgLNUn9p+JH8mPA0LZjDWj7ywb5ukzF3QxkRiIy4K3WkZ7xxqzHvKmNwDWEy/8sKrWdQ1C466rzuHcKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199018)(5660300002)(41300700001)(8936002)(6916009)(316002)(54906003)(86362001)(91956017)(8676002)(4326008)(66556008)(66476007)(66446008)(76116006)(66946007)(64756008)(36756003)(2906002)(6506007)(6512007)(82960400001)(186003)(26005)(83380400001)(38100700002)(2616005)(478600001)(122000001)(38070700005)(6486002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3VuN2VBZlVpaEE4L1BGQnNUQUxVazRTektBSzR0cFV6YkpyN0VXeTJST3FE?=
 =?utf-8?B?V05McTdqQ0huMSs3U2JMa3F4Nmw0bzc3TUVRRDluUVVQRTVuMTIwT3dmVm83?=
 =?utf-8?B?djYzc0hFQTV3UHpJMm1qcHIrSXBZRmR6T2Nna1JvYlIwbXMxb3FqZnJkL3Va?=
 =?utf-8?B?dmlyWVd6WXpvM1pMbnZCYWJ0Q0l0S0xSOVhpWTVENDJDc0Y2UktXMlJpcDdi?=
 =?utf-8?B?SUpkNERzMUJ2bTl5bENNdVRqUVlsVUxCTlh2cU5iRnZ5T1hOTVdJVUpkMTZN?=
 =?utf-8?B?LytFVXArMWFLYjFPdFhwMHFvTCtOSjlwR0NGUmpIcnVPQm1jdmdQbG9yaDJu?=
 =?utf-8?B?cXZLSlplOHVuOEdBZkdIY2lnd3pMZjd3ZXVMck41MEJIdEpJOGc5M1VuU3k5?=
 =?utf-8?B?YWZhOVlGTllqVTB5djltZ1cwSzN1eXphZTVBSkxIYStIaThINEZCMGd3dVV3?=
 =?utf-8?B?VzZ2RVdiaHdDL29jOW9IV3Zqa3NObGdIbjdLTk1DUlN0OGh3OWV4WUZ6Si9J?=
 =?utf-8?B?OG13RG9DTXJLakgvYTZhdTl4N1hsbnFBMUVxV0NrZlU4Q3lxN0lhTHE2YnVV?=
 =?utf-8?B?ZTUrTlNHSTl3d2ZvL1ZYMFdxYk1WakYzVWhkSGpLVWZQOHdqc2VKWFBQMk9D?=
 =?utf-8?B?MjVEeWN4RldvMU83OEVsNCtsWEVMdU1xSWplNXMzS0dUOEhIL0xXZlFDRkFJ?=
 =?utf-8?B?bVk0WUNNanZzTlJ5SjVtVmtNa2tNNy9UMEpnS0NWQUhFUzJBZHEzVWdzRkVD?=
 =?utf-8?B?UkhEQ3pCRU5tVXlOZW9MRHAzbDhuZlVKTC9uMjU2bnZiYlJ1bUVDN2gxa1Fp?=
 =?utf-8?B?MmdQS0FtTXJlYXdTdGE2aE1qeTRFTUM4YXptNG0vM3BqQjU5WjU2Z2Z0ZFlZ?=
 =?utf-8?B?UlphVDdXenQzWTdORXdNR0l5OXE3TDc1M2VvVTBTVzl0V3dQbTdqOUdTdXFm?=
 =?utf-8?B?TkJEWXFnakM4OVo4QVFWdnY3SHIzV0E4MXZCZTIzWmtDaEpiUitRTVM3MlNw?=
 =?utf-8?B?cERQTko1YmRITTY1UHdBNENaaUV6VytJYkdNVUovT2RoRVBOaVk0TTkxVERZ?=
 =?utf-8?B?TlV0Z2podE5PYVhlODNyRXBPM21jcVlWcnVCYWU0eXlpeDVRSzVmcURPZ1Vs?=
 =?utf-8?B?UVVNSWNOR1N3NGJUVXF6SnZGWGpjbXRGai9wdDdnTEdpbkNESHMzTm4yWEN4?=
 =?utf-8?B?aUtCalB0MUw4Zm9WWDVJMGVxb0RzN1FNTGVGbXhPTFJpbzdxSDkrZ2ZjSWhZ?=
 =?utf-8?B?enJQVUJ3dGI3dTV4UGZOaVRBMXdJL0lxTTlyMWNneDdod1ZiL1VvUzYxcFBB?=
 =?utf-8?B?b2pzNWdJbldGN0JkYWY0WDRIejFNOUUxdnhmNVFoM0Nha2diZCtpRXM0SFo3?=
 =?utf-8?B?d081SGt6dEZvV2QrU1ZNRzJFcVJxQXZSNEUzU01CZC9JOFAzS3owdXQyRVhs?=
 =?utf-8?B?MU1uSVZKaEJEN1ptNFdtN1Q1MW9EM1hLVjJIb21LN0ZucGFMN1FJc0ZDbFIr?=
 =?utf-8?B?cnZzeUIyZk8rZnpjQ2F6TTdkYUxKWE9MdDZwVUxzUDhrMnpLYXJwZ1BWVnhS?=
 =?utf-8?B?N2VnelpDR0ZZZmk1WEs5WkVyZCttR01HcmJFQS9wd0czWDhwWHpNVDJHazhr?=
 =?utf-8?B?OGFBaXlpOUlwTG0wWlMwMmpvM3NEaGZnN2tyV0dmNjNZWmJ6eTRTbmxWRGlH?=
 =?utf-8?B?Y3NqUXRtbFhKU0syejdDaFZHVkR6Um44YURXYk5MUlBhcVRSYlpQeU1pR3po?=
 =?utf-8?B?eTNlVm5pRmIvWGVXeXJzS3JEWXh6d3JtcS9BdW00ZjNJOG0rK01rRzgyUXJq?=
 =?utf-8?B?ZzRLUStMWjRtUmsyYWJldGR6YWVISnEwK3ArRGtoSkc2SWY5NXhuM1U4TXFT?=
 =?utf-8?B?ZW02UGtob1BOd1RRMGFXR0tZN0hpWDduKy9XeTJtbXJRMDQ5RkljcEMvTzZx?=
 =?utf-8?B?Z0dqN3VjN2pBOUlGbVJzcW1DUzlzZmhpZ0VrMkdWNStvTyt5QStoUW0wL2tP?=
 =?utf-8?B?M0t6SWsxR05QZTVoWjJsYkRoZnRIbzdhUTg3TDVwODB6bnZGVXRNT2o0bTls?=
 =?utf-8?B?aHU0TVI1SGl3WVdkcERBanMva0tZNm8zbFdIQlE2V2NwQ3dPb1ZUQzB2REhj?=
 =?utf-8?B?Y1NwdXRGTGRGYUh5QzQ0QW12a3l3V0ViUWs1VTlaZzUzQi9LZEVFMHJHRmh0?=
 =?utf-8?B?N2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <701F31CF5449B64CBDEEDB9DEA5A43C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed1c26d-4ee5-4817-34cc-08db1982570d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 11:52:59.9827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wUqg835G2dLdT+oKuclNnAz1YOunOwjR9qlDLxAJ0g9b8UON2DpEvxt2ZVyBpq9B/Fi3YHNazbOv4t+QQ3BcIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6186
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTI4IGF0IDAzOjA2IC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiA+ICsJaWYgKCFlKQ0KPiA+ID4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ID4gPiArCSplwqAg
PSAoc3RydWN0IGt2bV9jcHVpZF9lbnRyeTIpIHsNCj4gPiA+ICsJCS5mdW5jdGlvbiA9IDEsCS8q
IEZlYXR1cmVzIGZvciBYMkFQSUMgKi8NCj4gPiA+ICsJCS5pbmRleCA9IDAsDQo+ID4gPiArCQku
ZWF4ID0gMCwNCj4gPiA+ICsJCS5lYnggPSAwLA0KPiA+ID4gKwkJLmVjeCA9IDFVTEwgPDwgMjEs
CS8qIFgyQVBJQyAqLw0KPiA+ID4gKwkJLmVkeCA9IDAsDQo+ID4gPiArCX07DQo+ID4gPiArCXZj
cHUtPmFyY2guY3B1aWRfZW50cmllcyA9IGU7DQo+ID4gPiArCXZjcHUtPmFyY2guY3B1aWRfbmVu
dCA9IDE7DQo+ID4gDQo+ID4gQXMgbWVudGlvbmVkIGFib3ZlLCB3aHkgZG9pbmcgaXQgaGVyZT8g
V29uJ3QgYmUgdGhpcyBiZSBvdmVyd3JpdHRlbiBsYXRlciBpbg0KPiA+IEtWTV9TRVRfQ1BVSUQy
Pw0KPiANCj4gWWVzLCB1c2VyIHNwYWNlIFZNTSBjYW4gb3ZlcndyaXRlIGNwdWlkWzB4MV0gYW5k
IEFQSUMgYmFzZSBNU1IuwqAgQnV0IGl0DQo+IGRvZXNuJ3QNCj4gbWF0dGVyIGJlY2F1c2UgaXQn
cyBhIGJ1ZyBvZiB1c2VyIHNwYWNlIFZNTS4gdXNlciBzcGFjZSBWTU0gaGFzIHRvIGtlZXAgdGhl
DQo+IGNvbnNpc3RlbmN5IG9mIGNwdWlkIGFuZCBNU1JzLg0KPiBCZWNhdXNlIFREWCBtb2R1bGUg
dmlydHVhbGl6ZXMgY3B1aWRbMHgxXS54MmFwaWMgdG8gZml4ZWQgMSwgS1ZNIHZhbHVlIGRvZXNu
J3QNCj4gbWF0dGVyIGFmdGVyIHZjcHUgY3JlYXRpb24uDQo+IEJlY2F1c2UgS1ZNIHZpcnR1YWxp
emVzIEFQSUMgYmFzZSBhcyByZWFkIG9ubHkgdG8gZ3Vlc3QsIGNwdWlkWzB4MV0ueDJhcGljDQo+
IGRvZXNuJ3QgbWF0dGVyIGFmdGVyIHZjcHUgY3JlYXRpb24gYXMgbG9uZyBhcyB1c2VyIHNwYWNl
IFZNTSBrZWVwcyBLVk0gQVBJQw0KPiBCQVNFDQo+IHZhbHVlLg0KPiANCg0KQ29udHJhcnksIGNh
biB3ZSBkZXBlbmQgb24gdXNlcnNwYWNlIFZNTSB0byBzZXQgeDJBUElDIGluIENQVUlELCBidXQg
bm90IGRvIHRoaXMNCmluIEtWTT8gIElmIHVzZXJzcGFjZSBkb2Vzbid0IGRvIGl0LCB3ZSB0cmVh
dCBpdCBhcyB1c2Vyc3BhY2UncyBidWcuDQoNClBsdXMsIHVzZXJzcGFjZSBhbnl3YXkgbmVlZHMg
dG8gc2V0IHgyQVBJQyBpbiBDUFVJRCByZWdhcmRsZXNzIHdoZXRoZXIgeW91IGhhdmUNCmRvbmUg
YWJvdmUgaGVyZSwgY29ycmVjdD8NCg0KSSBkb24ndCBzZWUgdGhlIHBvaW50IG9mIGRvaW5nIGFi
b3ZlIGluIEtWTSBiZWNhdXNlIHlvdSBhcmUgbmVpdGhlciBlbmZvcmNpbmcNCmFueXRoaW5nIGlu
IEtWTSwgbm9yIHlvdSBhcmUgcmVkdWNpbmcgZWZmb3J0IG9mIHVzZXJzcGFjZS4NCg==
