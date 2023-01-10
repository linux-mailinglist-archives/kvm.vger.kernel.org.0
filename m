Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC383663E91
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 11:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238117AbjAJKtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 05:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjAJKsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 05:48:39 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2802D5BA21;
        Tue, 10 Jan 2023 02:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673347718; x=1704883718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T9gTM2yJPyhTBT+d8Pe8GK1IwmuSCHpllzQix3/W5rQ=;
  b=IwlICMsFadnbFgDWmbhS2LytECBRoHbKcdBGxSmYFcW2X8ye6zjD2a9z
   h4Y11kDPrRfMhmQPZ6ip9fI18xFk/AquJPfueJqQ6y9FnSbKJMtm0ELZp
   f5Fn7G4JOl9vXFjL4PO2xiJHBqgyyPLwxobeTfqrgfmq9565zL9ZQGKwO
   ddrTwR6+pmUaWPO/ycT+MJRKVJa20wUUc4opg35ewOy6A//ej1Y7OvFvZ
   N6bJYTw5ktGt60oDFRPUtudoBnBWkj1uPiGUC0O3RMBJY2qHj6mTuFfsX
   tdEFXnzQPKyXArRgEUlHtSFq1R4yhdZ1LBifdYi8CKbeam8FCk3FD+L7o
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="385420094"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="385420094"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 02:48:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="650320352"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="650320352"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 10 Jan 2023 02:48:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 02:48:35 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 02:48:35 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 02:48:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksmnfEKRtL46JAwDmhyFgq92knA6lhNQtIctHplJK+lOvTPXUY/99klMjyRWcZ2YoWsL/DXNtLWVvWgSaQJAguk3xpDsSf93R10XzNbfJXDdpck6PTNRk4YoSU4RlXyGsL/ecWLTOsbCS7/V0Eyo+o7mpvZ3PpztY9PUzywRC1U0zyTkgtCS4DTmg3XJADd41Oq13qUiNoWT61D7msJq1j4/2ypEWjcRrV+uIwMmDffFH+CvJ9zggldYR6G82FqMZ0t/GKEgweJ76+YaqMiBQ1UPlVSjVsUpsNnczgADg7B4Z6EaNybUk2kE1N8RRYuja8x53nUobzxytl72iay1Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9gTM2yJPyhTBT+d8Pe8GK1IwmuSCHpllzQix3/W5rQ=;
 b=Ftq/DsKW/NU+zUig2YYChHiuOdeud15CYc6+xxGsYn/IMyCXXYzRm/Orn405i5DMlCq+nmvs0mwN3yjGKt37GJkkL7FnEQAy037bB9U6LHqWSXj5U1tp0NiVtcO2VE2k5tGAg7XjJUH70clzBO+2ANYvl+qyjKaxIHW8nvd5QXCkyPUz83zBwbJz9dnyiqQyrW17A3tviFRgHrRxFmuP16uI/ylD6W69DTGWXSt967jo7NnODXVPLHeAMMdRcxCeOHW3EKF8e4IXN7s1eUSFimBMAnPMgWpdbmhMPjekX5vuN80o+jVyFO9eNpdf2vze9rMweea01HwmolMA2J3xBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7378.namprd11.prod.outlook.com (2603:10b6:208:432::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 10:48:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 10:48:26 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
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
Subject: Re: [PATCH v8 12/16] x86/virt/tdx: Designate the global KeyID and
 configure the TDX module
Thread-Topic: [PATCH v8 12/16] x86/virt/tdx: Designate the global KeyID and
 configure the TDX module
Thread-Index: AQHZC5gREJAXmgz0iUOlZePgAM3Era6SIyCAgAWH0AA=
Date:   Tue, 10 Jan 2023 10:48:26 +0000
Message-ID: <748adb0e8df5f804371f0587ed8fef1184177484.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <d7b01f396908da796644e58298a34c1f8a140be7.1670566861.git.kai.huang@intel.com>
         <e1a55f50-efc0-5098-1a2d-f0eaa0b51a82@intel.com>
In-Reply-To: <e1a55f50-efc0-5098-1a2d-f0eaa0b51a82@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7378:EE_
x-ms-office365-filtering-correlation-id: 4e735eb1-8e03-49ea-f565-08daf2f833cf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CiYy/aVvtfZsjKPlshJBEbKx/OwusbUx0wXFAMccdoj8irNB7ucdE7t0RrA7DINEx5znj+fzKsL4fD17bvX0HBeGaRFRs+DTiv+kg2LBiiHz72f6sTveUbMjLV1AJsmmi6ia0vLCOR5mzqstYQVRvUVm6DBAJ9KJgjOM2SxHKbLP8Gchec1D4l8Q8avPO6a56sSqDC5ri8n89w+U4wRZBj/tgfqm2w31dMQrdIDZCQWPAguG66ZHK6JsdS5N4d8UMCMc/LXyP0EOevf2fAns+oq/G4y0PZjDA9L9kyqtSDnGQVQ+aRwzresRXJRUkROVwUXhDT9fRIuvDK942k+naS5zFVXvKeOfg7L/mG2X2BxMv5CEiq0i5Nvr1r+rWIwVzn8yuHh+kmY4xfEj+gyJf7UjAyczgAFC7yTUWx3RNY4eAWgRXW3Pb9uwHwoZHdbxTaFekicyqAdhBIIoH58x84ul7wyBEfWlTM8i2ZmXnUC8W6mACh7bmkCpoIjMRG2ulwS2/Dmf3GEcjai+KqtzyGBTCtX5462PB/3U83zMAfnYjUmaJz0r4gnLgJt116APPtDBA8aNOVDLHyDXm5Wcv5/mElYYqaLVBRCgFiDW8TGh82v11/sYPHNxrmGWCcb4qG7LB9c1HyQb5YSoJfswQShJyOwJmYn59eaAUU2zDS4T7504iwJe1OuqI6EZPQiW6ANHTSlm3Nc+2kdGF7Q91g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(136003)(366004)(39860400002)(451199015)(7416002)(2906002)(41300700001)(5660300002)(8936002)(36756003)(66946007)(66476007)(76116006)(66556008)(66446008)(91956017)(4326008)(83380400001)(64756008)(8676002)(86362001)(54906003)(2616005)(71200400001)(26005)(38100700002)(6512007)(53546011)(6486002)(110136005)(38070700005)(478600001)(186003)(82960400001)(316002)(6506007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTZ2Ri83KzZOTEM5VGtHUnhvQ2UxUTR1Y0NTYjlyUXQ4UTQrR3REMVB3c0Q3?=
 =?utf-8?B?VzJZcy9CUHRFWDBiT2x3Snd5cVdObG50R2YyVlBZVEp4bitEZ3M3b3VMT2FL?=
 =?utf-8?B?WC9mbEk0empRQ0Jjd1pPUm5sN2UvRjR2UDlGMVc2c2dSRlVTY2I3d0R2TjRU?=
 =?utf-8?B?VUpUS1EydjNua0FpaktEVUoyVWhVTVo0RGw3SVBSajRDTS82MEMzRFNjcm9D?=
 =?utf-8?B?c0o2MExUYjE5eWk1QVBTVUxwRGFMcEJ1Q0tXL1ZXZ1VGNmVJbkoxeW5wcTJE?=
 =?utf-8?B?czQxK0Z0aVk0dTZGbUVjTEVPUi95ZEtDcTI5T0dPazZBcHRwUXMxM2pwZUJs?=
 =?utf-8?B?RHYySjdtRS9uaXhtenI5WnNZaUpKRjhxYmxYWWJkVi9PUFdVbGRxR3NuOGlP?=
 =?utf-8?B?VzFZT1ZwUDRKbUNJSm0yai9TSkVlcTA4RjF3c0dHRlA4Q25qSVA4d1VNYTBE?=
 =?utf-8?B?bXZ6K05QeFhXMUJlaFFQUlBPbmdKNG9IWHljYnV2NGcwb28vTFlySG5ud0ND?=
 =?utf-8?B?dTZQeEc4NE01T0RmencySGNZNStuVEhjb3FmbUpUNGZlcytMeVFwWHY2R2RL?=
 =?utf-8?B?aTI3NEpzdXNaTGpyMER5QVFmTzEzL0RBMHhEMlZQMzBOUHRKMWJ1TGlYQWFk?=
 =?utf-8?B?bG1PRXVqMUNpTHcxcHhYZXMvNUhMQ0xkNW1OTnltMmkzWmNMamhwSWNKU1c1?=
 =?utf-8?B?cEh5SHJldDRBbmFTREtYdkkxMnVacVFJSk9xYSttRHNUUGh4akF0SFVCSmZn?=
 =?utf-8?B?aTR6K1l0LzVGdUQwUzNQdnkvK0Y0dS92VXJUdGpzOHBMbFZQekpwcnREZWs5?=
 =?utf-8?B?d0M3VlFTSTdPdk5mOGl0U2wyQ2tPZzZzczlMUHloZWlWd3p3UHhRQ25VOFNn?=
 =?utf-8?B?UEtud0x0VUtsZS9yVXIzSkdNTStsMkxSRTZ1bGNNd1k0UGoyblErK3EraVFV?=
 =?utf-8?B?dDJZSmdsUmVGQUxBNWR2MnhkdHNRMDVrOVp5bFVxMjB1Nm1YZWhSMTlPME5T?=
 =?utf-8?B?NldRR1JOeTZTZHVnRVo1S1ZSK0ZXRG9XOWhVT1llMjJHcTF4UmpzczBsMnFW?=
 =?utf-8?B?Y2NSQWVhREtzNndjMDB0dE51dTVrYStUWmduWDFhYmdmR2J4cGRCSEttdGpn?=
 =?utf-8?B?aTVwejg4VzFyU1JDTklSVkNKazJVcFVVOGI2Mk54cm03L0ZQY1pObU9QdGk5?=
 =?utf-8?B?ZDZMTVhPeWhzeUNqVVBYK2trdytQeTB2YXlyaHZzbVBCejR2QlRFM2RpVy9r?=
 =?utf-8?B?WkJxb0RvcUQ3SG5zUU00eVdvWTVoUENPTmxEUSthUFdWZ3h6WGNTNHVwTTcw?=
 =?utf-8?B?bUg1aHNlMTQ2Z1h1cFZISXQrazFGTzcybHVOcGNKVHlybVhCaDB6NzRMWDE1?=
 =?utf-8?B?bTZzU1BiL0F1cFZsNFFIWjZvMXhRSG9lMU1HQ0tuM2RETkhpckkxMXZGQkpE?=
 =?utf-8?B?RzRRRlplV0dLU0FMUWxON1c2eEt4U1YrZFRuTS9sTnlrS255WlJLWEhqYWdu?=
 =?utf-8?B?TUNzd1diWnpXc2VQRnVuSCtseDVwSFN4THZRdzkrV0dqN2cvWWtLWUpMbHp4?=
 =?utf-8?B?OEdic1JmUFdWZUdyWFZUdUV0bjRGZGpmd0trY2puK3ViSzltYWpFSTZUR0xZ?=
 =?utf-8?B?UXZiNGN3K1BhRVFqUHN0OXpZWG00VWQ5Y3VqbURCMEJVZ3ZQZ0VKb01SSWEr?=
 =?utf-8?B?VS9rakZRNk9GbzloWXc3TVZ6ck4wdVdPYXR1YzJSdk9HOTVST1lRditqblpZ?=
 =?utf-8?B?NjkzbXBaYVJTa3JtWEJxeHpGaVVXZjc0MkttMllHb1R4SS9xZkhPVmZKSlRq?=
 =?utf-8?B?QlhZVkNOZXlFd2l2Z1JVcEM4enI5dFZoS3cwamJaMloxT2VzNlkyd2tua3JQ?=
 =?utf-8?B?NHgyendFMlVMUVFjN1FubmdHVFRsWlp1bnZ6Q2FUKzdaMXMxTHcrUGZHazZw?=
 =?utf-8?B?cU5ydmhsU3BqTzA3OG9abzBrYzZBUjkzYm9LNXFMQUx3OFN1ZVZwWUltL1Fw?=
 =?utf-8?B?aEZjMHFGd3NqVk9HSDYvWGhabUlUNXB5UFVnekQvMTNPbTFScm0yejBCa0Ju?=
 =?utf-8?B?SjBZMTNXZGNwWTJvZ2xzRmpuQzZsWTFhVHN3RUVjenNaekJyTVd0UjVIaEU3?=
 =?utf-8?B?U0htN3dWRk5SYUJvVjJVMjBaYzFmVEZKT0RRMUlCS05KUmE2NzI5T0xyVFZX?=
 =?utf-8?B?WWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6422593C58AA1448B8B82111DE63518@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e735eb1-8e03-49ea-f565-08daf2f833cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 10:48:26.0955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aDX46IVgl0S8kM0Bwl6XEDyYDEQXo87jGsM7hCQzFoUU8Iyl11F8wq33icjY+U6X2KqQIuIYUYEWuZ9lDeQyDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7378
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTA2IGF0IDE0OjIxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvOC8yMiAyMjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IEFmdGVyIGEgbGlzdCBvZiAi
VEQgTWVtb3J5IFJlZ2lvbnMiIChURE1ScykgaGFzIGJlZW4gY29uc3RydWN0ZWQgdG8NCj4gPiBj
b3ZlciBhbGwgVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucywgdGhlIG5leHQgc3RlcCBpcyB0byBw
aWNrIHVwIGEgVERYDQo+ID4gcHJpdmF0ZSBLZXlJRCBhcyB0aGUgImdsb2JhbCBLZXlJRCIgKHdo
aWNoIHByb3RlY3RzLCBpLmUuIFREWCBtb2R1bGUncw0KPiA+IG1ldGFkYXRhKSwgYW5kIGNvbmZp
Z3VyZSBpdCB0byB0aGUgVERYIG1vZHVsZSBhbG9uZyB3aXRoIHRoZSBURE1Scy4NCj4gDQo+IEZv
ciB3aGF0ZXZlciByZWFzb24sIHdoZW5ldmVyIEkgc2VlICJpLmUuIiBpbiBhIGNoYW5nZWxvZywg
aXQncyB1c3VhbGx5DQo+IGdvaW5nIG9mZiB0aGUgcmFpbHMuICBUaGlzIGlzIG5vIGV4Y2VwdGlv
bi4gIExldCdzIGFsc28gZ2V0IHJpZCBvZiB0aGUNCj4gcGFzc2l2ZSB2b2ljZToNCj4gDQo+IAlU
aGUgbmV4dCBzdGVwIEFmdGVyIGNvbnN0cnVjdGluZyBhIGxpc3Qgb2YgIlREIE1lbW9yeSBSZWdp
b25zIg0KPiAJKFRETVJzKSB0byBjb3ZlciBhbGwgVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9ucyBp
cyB0byBkZXNpZ25hdGUgYQ0KPiAJVERYIHByaXZhdGUgS2V5SUQgYXMgdGhlICJnbG9iYWwgS2V5
SUQiLiAgVGhpcyBLZXlJRCBpcyB1c2VkIGJ5DQo+IAl0aGUgVERYIG1vZHVsZSBmb3IgbWFwcGlu
ZyB0aGluZ3MgbGlrZSB0aGUgUEFNVCBhbmQgb3RoZXIgVERYDQo+IAltZXRhZGF0YS4gIFRoaXMg
S2V5SUQgaXMgcGFzc2VkIHRvIHRoZSBURFggbW9kdWxlIGF0IHRoZSBzYW1lDQo+IAl0aW1lIGFz
IHRoZSBURE1Scy4NCg0KVGhhbmtzLiAgV2lsbCB1c2UuDQoNCj4gDQo+ID4gVG8ga2VlcCB0aGlu
Z3Mgc2ltcGxlLCBqdXN0IHVzZSB0aGUgZmlyc3QgVERYIEtleUlEIGFzIHRoZSBnbG9iYWwgS2V5
SUQuDQo+IA0KPiANCj4gDQo+IA0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgv
dGR4LmMgfCA0MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ID4gIGFy
Y2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaCB8ICAyICsrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwg
NDEgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5j
DQo+ID4gaW5kZXggNjIwYjM1ZTJhNjFiLi5hYjk2MTQ0M2ZlZDUgMTAwNjQ0DQo+ID4gLS0tIGEv
YXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94ODYvdmlydC92bXgv
dGR4L3RkeC5jDQo+ID4gQEAgLTkxNiw2ICs5MTYsMzYgQEAgc3RhdGljIGludCBjb25zdHJ1Y3Rf
dGRtcnMoc3RydWN0IGxpc3RfaGVhZCAqdG1iX2xpc3QsDQo+ID4gIAlyZXR1cm4gcmV0Ow0KPiA+
ICB9DQo+ID4gIA0KPiA+ICtzdGF0aWMgaW50IGNvbmZpZ190ZHhfbW9kdWxlKHN0cnVjdCB0ZG1y
X2luZm9fbGlzdCAqdGRtcl9saXN0LCB1NjQgZ2xvYmFsX2tleWlkKQ0KPiA+ICt7DQo+ID4gKwl1
NjQgKnRkbXJfcGFfYXJyYXksICpwOw0KPiA+ICsJc2l6ZV90IGFycmF5X3N6Ow0KPiA+ICsJaW50
IGksIHJldDsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogVERNUnMgYXJlIHBhc3NlZCB0byB0
aGUgVERYIG1vZHVsZSB2aWEgYW4gYXJyYXkgb2YgcGh5c2ljYWwNCj4gPiArCSAqIGFkZHJlc3Nl
cyBvZiBlYWNoIFRETVIuICBUaGUgYXJyYXkgaXRzZWxmIGhhcyBhbGlnbm1lbnQNCj4gPiArCSAq
IHJlcXVpcmVtZW50Lg0KPiA+ICsJICovDQo+ID4gKwlhcnJheV9zeiA9IHRkbXJfbGlzdC0+bnJf
dGRtcnMgKiBzaXplb2YodTY0KSArDQo+ID4gKwkJVERNUl9JTkZPX1BBX0FSUkFZX0FMSUdOTUVO
VCAtIDE7DQo+IA0KPiBPbmUgb3RoZXIgd2F5IG9mIGRvaW5nIHRoaXMgd2hpY2ggbWlnaHQgYmUg
YSB3ZWUgYml0IGxlc3MgbWVzc3k6DQo+IA0KPiAJYXJyYXlfc3ogPSByb3VuZHVwX3Bvd19vZl90
d28oYXJyYXlfc3opOw0KPiAJaWYgKGFycmF5X3N6IDwgVERNUl9JTkZPX1BBX0FSUkFZX0FMSUdO
TUVOVCkNCj4gCQlhcnJheV9zeiA9IFRETVJfSU5GT19QQV9BUlJBWV9BTElHTk1FTlQ7DQo+IA0K
PiBTaW5jZSB0aGF0IGtlZXBzICdhcnJheV9zeicgYXQgYSBwb3dlci1vZi10d28sIHRoZW4ga3ph
bGxvYygpIHdpbGwgZ2l2ZQ0KPiB5b3UgYWxsIHRoZSBhbGlnbm1lbnQgeW91IG5lZWQsIGV4Y2Vw
dCBpZiB0aGUgYXJyYXkgaXMgdG9vIHNtYWxsLCBpbg0KPiB3aGljaCBjYXNlIHlvdSBjYW4ganVz
dCBibG9hdCBpdCB0byB0aGUgYWxpZ25tZW50IHJlcXVpcmVtZW50Lg0KPiANCj4gVGhpcyB3b3Vs
ZCBnZXQgcmlkIG9mIHRoZSBQVFJfQUxJR04oKSBiZWxvdyB0b28uDQo+IA0KPiBZb3VyIGNob2lj
ZS4gIFdoYXQgeW91IGhhdmUgd29ya3MgdG9vLg0KDQpZb3VyIGNvZGUgY2FuIGFsc28gZ2V0IHJp
ZCBvZiB0aGUgYWRkaXRpb25hbCAncCcgbG9jYWwgdmFyaWFibGUuICBBcyB5b3Ugc2FpZCBpdA0K
aXMgc2ltcGxlci4gIEknbGwgdXNlIHlvdXIgY29kZS4gIFRoYW5rcyENCg0KPiANCj4gPiArCXAg
PSBremFsbG9jKGFycmF5X3N6LCBHRlBfS0VSTkVMKTsNCj4gPiArCWlmICghcCkNCj4gPiArCQly
ZXR1cm4gLUVOT01FTTsNCj4gPiArDQo+ID4gKwl0ZG1yX3BhX2FycmF5ID0gUFRSX0FMSUdOKHAs
IFRETVJfSU5GT19QQV9BUlJBWV9BTElHTk1FTlQpOw0KPiA+ICsJZm9yIChpID0gMDsgaSA8IHRk
bXJfbGlzdC0+bnJfdGRtcnM7IGkrKykNCj4gPiArCQl0ZG1yX3BhX2FycmF5W2ldID0gX19wYSh0
ZG1yX2VudHJ5KHRkbXJfbGlzdCwgaSkpOw0KPiA+ICsNCj4gPiArCXJldCA9IHNlYW1jYWxsKFRE
SF9TWVNfQ09ORklHLCBfX3BhKHRkbXJfcGFfYXJyYXkpLCB0ZG1yX2xpc3QtPm5yX3RkbXJzLA0K
PiA+ICsJCQkJZ2xvYmFsX2tleWlkLCAwLCBOVUxMLCBOVUxMKTsNCj4gPiArDQo+ID4gKwkvKiBG
cmVlIHRoZSBhcnJheSBhcyBpdCBpcyBub3QgcmVxdWlyZWQgYW55bW9yZS4gKi8NCj4gPiArCWtm
cmVlKHApOw0KPiA+ICsNCj4gPiArCXJldHVybiByZXQ7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0
YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ID4gIHsNCj4gPiAgCS8qDQo+ID4gQEAg
LTk2MCwxNyArOTkwLDI0IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ID4g
IAlpZiAocmV0KQ0KPiA+ICAJCWdvdG8gb3V0X2ZyZWVfdGRtcnM7DQo+ID4gIA0KPiA+ICsJLyoN
Cj4gPiArCSAqIFVzZSB0aGUgZmlyc3QgcHJpdmF0ZSBLZXlJRCBhcyB0aGUgZ2xvYmFsIEtleUlE
LCBhbmQgcGFzcw0KPiA+ICsJICogaXQgYWxvbmcgd2l0aCB0aGUgVERNUnMgdG8gdGhlIFREWCBt
b2R1bGUuDQo+ID4gKwkgKi8NCj4gPiArCXJldCA9IGNvbmZpZ190ZHhfbW9kdWxlKCZ0ZG1yX2xp
c3QsIHRkeF9rZXlpZF9zdGFydCk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCWdvdG8gb3V0X2Zy
ZWVfcGFtdHM7DQo+IA0KPiBUaGlzIGlzICJjb25zdW1pbmciIHRkeF9rZXlpZF9zdGFydC4gIERv
ZXMgaXQgbmVlZCB0byBnZXQgaW5jcmVtZW50ZWQNCj4gc2luY2UgdGhlIGZpcnN0IGd1ZXN0IGNh
bid0IHVzZSB0aGlzIEtleUlEIG5vdz8NCg0KDQpJdCBkZXBlbmRzIG9uIGhvdyB3ZSB0cmVhdCAn
dGR4X2tleWlkX3N0YXJ0Jy4gIElmIGl0IG1lYW5zIHRoZSBmaXJzdCBfdXNhYmxlXw0KS2V5SUQg
Zm9yIEtWTSwgdGhlbiB3ZSBzaG91bGQgaW5jcmVhc2UgaXQ7IGJ1dCBpZiBpdCBvbmx5IHVzZWQg
Zm9yIHRoZSBoYXJkd2FyZS0NCmVuYWJsZWQgVERYIEtleUlEIHJhbmdlLCB0aGVuIHdlIGRvbid0
IG5lZWQgdG8gaW5jcmVhc2UgaXQuDQoNCkN1cnJlbnRseSBpdCBpcyBtYXJrZWQgYXMgX19yb19h
ZnRlcl9pbml0IHNvIG15IGludGVudGlvbiBpcyB0aGUgbGF0dGVyIChhbHNvIGluDQp0aGUgc3Bp
cml0IG9mIGtlZXBpbmcgdGhpcyBzZXJpZXMgbWluaW1hbCkuDQoNCkV2ZW50dWFsbHkgd2Ugd2ls
bCBuZWVkIHRvIGhhdmUgZnVuY3Rpb25zIHRvIGFsbG9jYXRlL2ZyZWUgVERYIEtleUlEcyBhbnl3
YXkgZm9yDQpLVk0sIGJ1dCBpbiB0aGF0IHdlIGNhbiBqdXN0IHRyZWF0ICd0ZHhfa2V5aWRfc3Rh
cnQgKyAxJyBhcyB0aGUgZmlyc3QgdXNhYmxlDQpLZXlJRC4NCg0KW3NuaXBdDQo=
