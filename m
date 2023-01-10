Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB96663FFF
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 13:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbjAJMMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 07:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjAJMLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 07:11:53 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B711631D;
        Tue, 10 Jan 2023 04:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673352567; x=1704888567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v9h96wArr1M9IAJzVrj/12Y2m8LrBAqWXcpzPCajedA=;
  b=Wrb+Hi8VnpjP3WJvS/HK2dYk7KqWQZ51HX5XMaTu8Wvagu0RvpYBzmza
   Vl5YXWZDWMvg1iaH1lx1DSk9cMxcT267aIojiy8GubkvH3wA51+zC0jKR
   JH3geLMOYRQexRYBA32ULMKS1o9QbRCcxnObs5dBebzFLpp1r3Hu6O3uI
   Ajv7rVkhcnGBSR0B2/EN5XXOAwqeVX3LTQ8m+bKG54TPiP7yN3P+bXqqw
   KLLuqt18Wk2CZqVyV5mciZx4Tev6pbPVwvhEZrtE3YYvhCdhiW6x2b5i4
   McfXxliKn73//WrvjaeZz/zH8SDPmumEWY21VZdipfw1kSzzaDW3CXLC4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="387581075"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="387581075"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 04:09:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="781048934"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="781048934"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 10 Jan 2023 04:09:25 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 04:09:24 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 04:09:24 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 04:09:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcFeVo6s7/NH2a34WWWubFd3vSgVn7nXyfsGWv5oNVkUGBiE4uKNsfGO8qu9f0tvbSGGMlulHtD0qw7y0w8BW0W0kH9f2UHClSpIqZRXdvkkLJAQr92S1/HoP/K+bbDwXD/7Iwr/PPEAFGQF3Q0wp59haoBSGh1paWDs73YqIFxjdYKvKbXaz/y+FAevU9F4XA27p+7woAlLDf+HkerKRc0fFoYQfrESK2dfjbz65wd2iKdk1Xikp7puavQCYrStU5TZLEwCvZO4HCOZkC3U4X0zWraOFyXiIY0XxTfXzrIwT92DFRho/7H5qdkUo+XzMiZXA6PQFKmCesCg8tDOyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9h96wArr1M9IAJzVrj/12Y2m8LrBAqWXcpzPCajedA=;
 b=oE1B2h0TTeDjiYUF8xEX0D2kgXk35mapGN82kEk1BHZZz8EjnaTuigiHKNznbgzXs1Dp1LgY1yQ2guMfL3iLNCt4jy1AkKFxvnvE+i2Xtt0dAWF6IvCVhDYqforDypEumMGeN/4YXPic3TTdltWH53k2L7sEI3B6kvMUglZLwK01ZZeJ++KpD3/wKsjt0wFJ8ouY1siKrnYVQ32viB51jFpIXGV29W7hVbo1IxSDY+f0cI7Fc/cL2FGClbRnWEwyvoMzBS9Plu5GxL0V9n0ZSqdS4wl1S3C11YV4CCI/SUDuZvY3hg2mkvN38JRDcCWd3+kcQe56SM2vg6LgmlYmsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB7473.namprd11.prod.outlook.com (2603:10b6:a03:4d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 10 Jan
 2023 12:09:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 12:09:20 +0000
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZC5gLiOnJQQKFB0CM7X30zcZDS66R31QAgARKC4CAAFSjAIABQ4mA
Date:   Tue, 10 Jan 2023 12:09:20 +0000
Message-ID: <a5d4de8b074b6d1a34bd3d424c5c4f0d677ec15f.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
         <e7b682a1-abdf-ce73-f262-8b7ce946e78e@intel.com>
         <bc11552572428c3b29b67852b062c387ecd7be45.camel@intel.com>
         <e02fd75d-e9d4-15f1-eb9c-31cf3cc9ddc1@intel.com>
In-Reply-To: <e02fd75d-e9d4-15f1-eb9c-31cf3cc9ddc1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB7473:EE_
x-ms-office365-filtering-correlation-id: 7903efca-d87e-4d56-4e99-08daf303815b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LNI7uSL5qWjDnJcwAE052pV52RexoIZrC3X4tGTrK6zi+UpDBymf0BWt3RfT0EE5Z+xY5WbC8MTKdNDnY8Wk6nO+19BSo3d2RH3PA9sIuwkofbhLJDJ4MPMATFurVudh8cP3mN2B6svQl5NCSy5QaIUQtlrLmFud9BsU3BqrGulYa5yc3GEGOHXaT92xujRZwMolXn/Owi/bYuYaQu1+yHwkOVBH2LAuxcJuwSsG1TzJXUHPCE5l8xxVv/xEMq48mbjkiWHHLh+Nc/s+YCCVozvoc/TM7lZwLCWn9464aaIlMSe1o5tQ2RSmPzJeat1i+i7g5gDr9K2Q5TUnENFpBwCFAP+VfGpyx3dTXmb8fVCeYnDXuUdRMX/e7dEvva17hrf0oyEXg8G6p/bep7HuMm979noPfFfDY/gStrRraMUS8DC0FFEUWhY6k9AwnqjM4sEs60srik/MWR/fI1lgdA/jMyDdZKw9iyxqwMVwXoKp90nj5X4Qb0mZ/aL66iJzpL0Vm2Z48V/3g20aFpHLMaZaV9X51nrUyvO/tYsl1xuuPabFjjiLAYuT9ZZri1Z4BgqvfV8RUkjPr+noQLmK3z1ahI1lX1M5UZwQuoceFo+x8GFbADQ56MeBKAlaNhGKdQEeGFJUzphUaUdDyqQ/r7pyFxTHlRZ5BVpmMao0hjwvvWy0YcOhZm7GJ9g7FAJJWFpbqpNawCOpp5E8Oz0bXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199015)(66899015)(36756003)(54906003)(64756008)(4326008)(38100700002)(76116006)(91956017)(66476007)(66946007)(66556008)(38070700005)(110136005)(41300700001)(82960400001)(66446008)(86362001)(122000001)(8676002)(53546011)(186003)(71200400001)(6512007)(6486002)(26005)(7416002)(2906002)(478600001)(8936002)(6506007)(316002)(2616005)(5660300002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NG56RnNWdndaak44cU1aWFp4RWVKZlhWaldtUmJiVS9BRm9HQnFQRXcraUJV?=
 =?utf-8?B?TERiNVlrWlpXUjRpMlo4bVNvbC9SZ3hITDFOV0kwa1R1M0ZEYXFFckdKMTN2?=
 =?utf-8?B?a3dDbFhnelp1YjN3N0dhVkV2VlpwTXphRVZuRUN0Y0YvZk0zWWtEYWprSldI?=
 =?utf-8?B?VGEycWtwZXpoeXFCVXVNdDZxRFVFRDR2M2NTenhMUVR4Nk1vdW40cW9BM0FO?=
 =?utf-8?B?aUgyNjF4R1F6Y0xWSlFjK2RFalRSZmp0YWxDTG1hVkZDbFZBMlZTN1p2WVky?=
 =?utf-8?B?bmtzeGg3NWVnRW5JSmhGUXZhTG1naERQeitpVnJoeXF0K2JqY2JPN0UxVUJN?=
 =?utf-8?B?RGt4d3pXSllFU2ZPajhSakw0Zm5QSElRQU9QMGFQZGVTcnRiREswZEQwd2xU?=
 =?utf-8?B?STlTVFNqS0V4SkM4WktLWVN3SmQ0SllLNmtFVzY5ek5KUnF1UHpCRE0rczJp?=
 =?utf-8?B?ejlxbVA5cjYwaHE1UmpMdWtCS2VWc3ErSHJpMEhrblRsVndndENJRWVNdURk?=
 =?utf-8?B?cmFTZEVPOTVyakMveDJ6emdWY0pUNmNjM3BwcTNrdzRDcXdGbHE5R2hoOGZI?=
 =?utf-8?B?dGxWek5vOXZiUzlnQmhyQ3FJanZoajVjOXIxd2duamtWejh2ZFdZZWcyUVJI?=
 =?utf-8?B?TVdEQndzb09IRDkra0ZJenRKMnhmVXNGWGtIV0NwS0pNOWphZkxka01STUdo?=
 =?utf-8?B?YkVzSnA4Qm5jNDB6RXBrUnBFU0k1OTM4Wm95ZUVVUW14SXZySEd6emlkaEp5?=
 =?utf-8?B?Mi85NURQdjBvQmFkWWNKT1RDYVczQ2JyR3JrWll3YUtPRld0VnVKVm5CVTdJ?=
 =?utf-8?B?bzgzQk8zWlAxdVZsQStOamxxOEg4N2pPVmdYRlVOUFJaN0UzSnhadWw0RlQ3?=
 =?utf-8?B?RUpUNEVDMTdkSk0rRVMvaml1eDJVU2hqeUFEQnhhbXZiYlEvWmY1eHRyaTlD?=
 =?utf-8?B?R1hjUVF6WC9EVVpoZE1IU0FaOHdZcUJGUDR1c2ZmSEEvaE1YenpiM1M5b0pa?=
 =?utf-8?B?S0JuVXNMV0x0eXZuZy9uQ2tlU1NLdStOT1k0QnVYc1dISlh4SmNaem1zSVg4?=
 =?utf-8?B?Ny9OYXhsVFNzOUpNUi9ZWE9IVExPZ2l3cVB0UjVZVnNvb3ZCZzJZQVlLdlM5?=
 =?utf-8?B?L2tsay9yN1AvL2VkVXQzelgvdTM1OEdEVGxSVVhnMjgwcVVVNzUxcy82YlZK?=
 =?utf-8?B?NTEwTnFFaXZUSFRKTG1CTGU1RzJhMjV0QVJiTkZHTWkybzBvelgzYzZNN3FG?=
 =?utf-8?B?N3FqdVVVcUVFZXA3bWtaT3Q4L3pPZ3NPb2JXVDZ5cHQ5WWhTZnI3QmFWcGww?=
 =?utf-8?B?Ynh4UzczSXMvcmZuTmwvVUdIQVBRcGQvamxJNnNNNHk3RHhvRVlrK09YTGJE?=
 =?utf-8?B?aWRYV0pMNjZoZW0yVGJXU3RNSGxGWTM0YXNVdXdNWERNaGxDM1lISW4vT0F0?=
 =?utf-8?B?aHBqYlM1bVpCekVBblROY0tqQ0UzU0pmWm9jMysrSVVMUGJlY01Xcjl3Mjg4?=
 =?utf-8?B?TFB0RUdJVW5iZFRjc3RKd0tqUWxVUFpCRUs0MDBCSDlCclF4aXUwWkR6RXVQ?=
 =?utf-8?B?blhRMkh4TnhyWFZOa1g0MnZYMlBsZUFPVXdxR3Q1WVYxZHR6RnhlWGFhY25o?=
 =?utf-8?B?YVBOa1FPTkJXdXNmVFRTcXZ4UzZ4T3hnQmZVRWd4bHQ3Sjc1MmxnbmljZisz?=
 =?utf-8?B?YXl2SDZWcE1ZQWZ1TFptdlVhTm5ybktEeWFOR2VYOHhZWVpDUU16WTdHQUZF?=
 =?utf-8?B?YUpEZEQrK2NKQXk2TXJqcjB0RzREZDB3dTQ5cjV1aWxMaXVKYW12c29EU3ZE?=
 =?utf-8?B?a2FnMUJhZXBEL24vVmxHeEtPM3VFWTVuS0tvbjUyS2hmSWZCckVRMnkvNXN4?=
 =?utf-8?B?enZWWmwyamlyYUVWWUhDb2FEM1diQ3gvcThoYXRWZnIwZU8zVjk1Ui9QemRD?=
 =?utf-8?B?Ym9iWDB0ekNjV0lnNGkrN1RQcHVOQm9OUFZhVXZwVU9sZ3RJV3l5dnhPMVQz?=
 =?utf-8?B?bjJwNEpKYUVEakkvcC9Bc1c2ekxvWTM3VlpPKzcxbU9NRjJkTXVmVkthQnpU?=
 =?utf-8?B?dnpoUVE5WW1KM1hROWlXeHlaUStIakVwVncxMGpDMVdKU2lheEQvSnBjU3J4?=
 =?utf-8?B?VXNKaFpkQ3BIUE1weXFPdXpERVExSm5PRlRybDJld0Q0bk8wLzJWMXlIdkdF?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21874B9A8494B740963EFBA08707CBC0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7903efca-d87e-4d56-4e99-08daf303815b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 12:09:20.6886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wNiAgtMKM6vxNUKcWJGpJm+gGPn/MsTltO04tNTV64TR3+wdAQ5QtsMWCya4cp0r/3muZe2r6qVAoYttgvfUaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7473
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAxLTA5IGF0IDA4OjUxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMS85LzIzIDAzOjQ4LCBIdWFuZywgS2FpIHdyb3RlOg0KPiAuLi4NCj4gPiA+ID4gPiA+IFRo
aXMgYXBwcm9hY2ggd29ya3MgYXMgaW4gcHJhY3RpY2UgYWxsIGJvb3QtdGltZSBwcmVzZW50IERJ
TU1zIGFyZSBURFgNCj4gPiA+ID4gPiA+IGNvbnZlcnRpYmxlIG1lbW9yeS4gIEhvd2V2ZXIsIGlm
IGFueSBub24tVERYLWNvbnZlcnRpYmxlIG1lbW9yeSBoYXMgYmVlbg0KPiA+ID4gPiA+ID4gaG90
LWFkZGVkIChpLmUuIENYTCBtZW1vcnkgdmlhIGttZW0gZHJpdmVyKSBiZWZvcmUgaW5pdGlhbGl6
aW5nIHRoZSBURFgNCj4gPiA+ID4gPiA+IG1vZHVsZSwgdGhlIG1vZHVsZSBpbml0aWFsaXphdGlv
biB3aWxsIGZhaWwuDQo+ID4gPiA+IA0KPiA+ID4gPiBJIHJlYWxseSBkb24ndCBrbm93IHdoYXQg
dGhpcyBpcyB0cnlpbmcgdG8gc2F5Lg0KPiA+IA0KPiA+IE15IGludGVudGlvbiBpcyB0byBleHBs
YWluIGFuZCBjYWxsIG91dCB0aGF0IHN1Y2ggZGVzaWduICh1c2UgYWxsIG1lbW9yeSByZWdpb25z
DQo+ID4gaW4gbWVtYmxvY2sgYXQgdGhlIHRpbWUgb2YgbW9kdWxlIGluaXRpYWxpemF0aW9uKSB3
b3JrcyBpbiBwcmFjdGljZSwgYXMgbG9uZyBhcw0KPiA+IG5vbi1DTVIgbWVtb3J5IGhhc24ndCBi
ZWVuIGFkZGVkIHZpYSBtZW1vcnkgaG90cGx1Zy4NCj4gPiANCj4gPiBOb3Qgc3VyZSBpZiBpdCBp
cyBuZWNlc3NhcnksIGJ1dCBJIHdhcyB0aGlua2luZyBpdCBtYXkgaGVscCByZXZpZXdlciB0byBq
dWRnZQ0KPiA+IHdoZXRoZXIgc3VjaCBkZXNpZ24gaXMgYWNjZXB0YWJsZS4NCj4gDQo+IFRoaXMg
aXMgeWV0IGFub3RoZXIgY2FzZSB3aGVyZSB5b3UndmUgbWVjaGFuaWNhbGx5IGRlc2NyaWJlZCB0
aGUgIndoYXQiLA0KPiBidXQgbGVmdCBvdXQgdGhlIGltcGxpY2F0aW9ucyBvciB0aGUgdW5kZXJs
eWluZyBiYXNpcyAid2h5Ii4NCj4gDQo+IEknZCB0YWtlIGEgbW9yZSBtZXRob2RpY2FsIGFwcHJv
YWNoIHRvIGRlc2NyaWJlIHdoYXQgaXMgZ29pbmcgb24gaGVyZS4NCj4gTGlzdCB0aGUgc3RlcHMg
dGhhdCBtdXN0IG9jY3VyLCBvciBhdCBsZWFzdCAqb25lKiBleGFtcGxlIG9mIHRob3NlIHN0ZXBz
DQo+IGFuZCBob3cgdGhleSBpbnRlcmVhY3Qgd2l0aCB0aGUgY29kZSBpbiB0aGlzIHBhdGNoLiAg
VGhlbiwgZXhwbGFpbiB0aGUNCj4gZmFsbG91dC4NCj4gDQo+IEkgYWxzbyBkb24ndCB0aGluayBp
dCdzIHF1aXRlIHJpZ2h0IHRvIGNhbGwgb3V0ICJDWEwgbWVtb3J5IHZpYSBrbWVtDQo+IGRyaXZl
ciIuICBJZiB0aGUgQ1hMIG1lbW9yeSB3YXMgIlN5c3RlbSBSQU0iLCBpdCBzaG91bGQgZ2V0IGNv
dmVyZWQgYnkgYQ0KPiBDTVIgYW5kIFRETVIuICBUaGUga21lbSBkcml2ZXIgY2FuIHN0aWxsIGdv
IHdpbGQgd2l0aCBpdC4NCj4gDQo+ID4gPiA+ICpIb3cqIGFuZCAqd2h5KiBkb2VzIHRoaXMgbW9k
dWxlIGluaXRpYWxpemF0aW9uIGZhaWx1cmUgb2NjdXI/DQo+ID4gDQo+ID4gSWYgd2UgcGFzcyBh
bnkgbm9uLUNNUiBtZW1vcnkgdG8gdGhlIFREWCBtb2R1bGUsIHRoZSBTRUFNQ0FMTCAoVERILlNZ
Uy5DT05GSUcpDQo+ID4gd2lsbCBmYWlsLg0KPiANCj4gSSdtIGZyYW5rbHkgbG9zdCBub3cuICBQ
bGVhc2UgZ28gYmFjayBhbmQgdHJ5IHRvIGV4cGxhaW4gdGhpcyBiZXR0ZXIuDQo+IExldCBtZSBr
bm93IGlmIHlvdSB3YW50IHRvIGl0ZXJhdGUgb24gdGhpcyBmYXN0ZXIgdGhhbiByZXNlbmRpbmcg
dGhpcw0KPiBzZXJpZXMgZml2ZSBtb3JlIHRpbWVzLiAgSSd2ZSBnb3Qgc29tZSBpZGVhcy4NCg0K
TGV0IG1lIHRyeSB0byBkbyBteSB3b3JrIGZpcnN0LiAgVGhhbmtzLg0KDQo+IA0KPiA+ID4gPiA+
ID4gVGhpcyBjYW4gYWxzbyBiZSBlbmhhbmNlZCBpbiB0aGUgZnV0dXJlLCBpLmUuIGJ5IGFsbG93
aW5nIGFkZGluZyBub24tVERYDQo+ID4gPiA+ID4gPiBtZW1vcnkgdG8gYSBzZXBhcmF0ZSBOVU1B
IG5vZGUuICBJbiB0aGlzIGNhc2UsIHRoZSAiVERYLWNhcGFibGUiIG5vZGVzDQo+ID4gPiA+ID4g
PiBhbmQgdGhlICJub24tVERYLWNhcGFibGUiIG5vZGVzIGNhbiBjby1leGlzdCwgYnV0IHRoZSBr
ZXJuZWwvdXNlcnNwYWNlDQo+ID4gPiA+ID4gPiBuZWVkcyB0byBndWFyYW50ZWUgbWVtb3J5IHBh
Z2VzIGZvciBURFggZ3Vlc3RzIGFyZSBhbHdheXMgYWxsb2NhdGVkIGZyb20NCj4gPiA+ID4gPiA+
IHRoZSAiVERYLWNhcGFibGUiIG5vZGVzLg0KPiA+ID4gPiANCj4gPiA+ID4gV2h5IGRvZXMgaXQg
bmVlZCB0byBiZSBlbmhhbmNlZD8gIFdoYXQncyB0aGUgcHJvYmxlbT8NCj4gPiANCj4gPiBUaGUg
cHJvYmxlbSBpcyBhZnRlciBURFggbW9kdWxlIGluaXRpYWxpemF0aW9uLCBubyBtb3JlIG1lbW9y
eSBjYW4gYmUgaG90LWFkZGVkDQo+ID4gdG8gdGhlIHBhZ2UgYWxsb2NhdG9yLg0KPiA+IA0KPiA+
IEtpcmlsbCBzdWdnZXN0ZWQgdGhpcyBtYXkgbm90IGJlIGlkZWFsLiBXaXRoIHRoZSBleGlzdGlu
ZyBOVU1BIEFCSXMgd2UgY2FuDQo+ID4gYWN0dWFsbHkgaGF2ZSBib3RoIFREWC1jYXBhYmxlIGFu
ZCBub24tVERYLWNhcGFibGUgTlVNQSBub2RlcyBvbmxpbmUuIFdlIGNhbg0KPiA+IGJpbmQgVERY
IHdvcmtsb2FkcyB0byBURFgtY2FwYWJsZSBub2RlcyB3aGlsZSBvdGhlciBub24tVERYIHdvcmts
b2FkcyBjYW4NCj4gPiB1dGlsaXplIGFsbCBtZW1vcnkuDQo+ID4gDQo+ID4gQnV0IHByb2JhYmx5
IGl0IGlzIG5vdCBuZWNlc3NhcmlseSB0byBjYWxsIG91dCBpbiB0aGUgY2hhbmdlbG9nPw0KPiAN
Cj4gTGV0J3Mgc2F5IHRoYXQgd2UgYWRkIHRoaXMgVERYLWNvbXBhdGlibGUtbm9kZSBBQkkgaW4g
dGhlIGZ1dHVyZS4gIFdoYXQNCj4gd2lsbCBvbGQgY29kZSBkbyB0aGF0IGRvZXNuJ3Qga25vdyBh
Ym91dCB0aGlzIEFCST8NCg0KUmlnaHQuICBUaGUgb2xkIGFwcCB3aWxsIGJyZWFrIHcvbyBrbm93
aW5nIHRoZSBuZXcgQUJJLiAgT25lIHJlc29sdXRpb24sIEkNCnRoaW5rLCBpcyB3ZSBkb24ndCBp
bnRyb2R1Y2UgbmV3IHVzZXJzcGFjZSBBQkksIGJ1dCBoaWRlICJURFgtY2FwYWJsZSIgYW5kICJu
b24tDQpURFgtY2FwYWJsZSIgbm9kZXMgaW4gdGhlIGtlcm5lbCwgYW5kIGxldCBrZXJuZWwgdG8g
ZW5mb3JjZSBhbHdheXMgYWxsb2NhdGluZw0KVERYIGd1ZXN0IG1lbW9yeSBmcm9tIHRob3NlICJU
RFgtY2FwYWJsZSIgbm9kZXMuDQoNCkFueXdheSwgcGVyaGFwcyB3ZSBjYW4ganVzdCBkZWxldGUg
dGhpcyBwYXJ0IGZyb20gdGhlIGNoYW5nZWxvZz8NCg0KPiANCj4gLi4uDQo+ID4gPiA+ID4gPiAr
ICAgICAgIGxpc3RfZm9yX2VhY2hfZW50cnkodG1iLCAmdGR4X21lbWxpc3QsIGxpc3QpIHsNCj4g
PiA+ID4gPiA+ICsgICAgICAgICAgICAgICAvKg0KPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAg
ICAqIFRoZSBuZXcgcmFuZ2UgaXMgVERYIG1lbW9yeSBpZiBpdCBpcyBmdWxseSBjb3ZlcmVkIGJ5
DQo+ID4gPiA+ID4gPiArICAgICAgICAgICAgICAgICogYW55IFREWCBtZW1vcnkgYmxvY2suDQo+
ID4gPiA+ID4gPiArICAgICAgICAgICAgICAgICoNCj4gPiA+ID4gPiA+ICsgICAgICAgICAgICAg
ICAgKiBOb3RlIFREWCBtZW1vcnkgYmxvY2tzIGFyZSBvcmlnaW5hdGVkIGZyb20gbWVtYmxvY2sN
Cj4gPiA+ID4gPiA+ICsgICAgICAgICAgICAgICAgKiBtZW1vcnkgcmVnaW9ucywgd2hpY2ggY2Fu
IG9ubHkgYmUgY29udGlndW91cyB3aGVuIHR3bw0KPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAg
ICAqIHJlZ2lvbnMgaGF2ZSBkaWZmZXJlbnQgTlVNQSBub2RlcyBvciBmbGFncy4gIFRoZXJlZm9y
ZQ0KPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAqIHRoZSBuZXcgcmFuZ2UgY2Fubm90IGNy
b3NzIG11bHRpcGxlIFREWCBtZW1vcnkgYmxvY2tzLg0KPiA+ID4gPiA+ID4gKyAgICAgICAgICAg
ICAgICAqLw0KPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgIGlmIChzdGFydF9wZm4gPj0gdG1i
LT5zdGFydF9wZm4gJiYgZW5kX3BmbiA8PSB0bWItPmVuZF9wZm4pDQo+ID4gPiA+ID4gPiArICAg
ICAgICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsNCj4gPiA+ID4gPiA+ICsgICAgICAgfQ0K
PiA+ID4gPiA+ID4gKyAgICAgICByZXR1cm4gZmFsc2U7DQo+ID4gPiA+ID4gPiArfQ0KPiA+ID4g
PiANCj4gPiA+ID4gSSBkb24ndCByZWFsbHkgbGlrZSB0aGF0IGNvbW1lbnQuICBJdCBzaG91bGQg
Zmlyc3Qgc3RhdGUgaXRzIGJlaGF2aW9yDQo+ID4gPiA+IGFuZCBhc3N1bXB0aW9ucywgbGlrZToN
Cj4gPiA+ID4gDQo+ID4gPiA+ICAgICBUaGlzIGNoZWNrIGFzc3VtZXMgdGhhdCB0aGUgc3RhcnRf
cGZuPC0+ZW5kX3BmbiByYW5nZSBkb2VzIG5vdA0KPiA+ID4gPiAgICAgY3Jvc3MgbXVsdGlwbGUg
dGR4X21lbWxpc3QgZW50cmllcy4NCj4gPiA+ID4gDQo+ID4gPiA+IE9ubHkgdGhlbiBzaG91bGQg
aXQgZGVzY3JpYmUgd2h5IHRoYXQgaXMgT0s6DQo+ID4gPiA+IA0KPiA+ID4gPiAgICAgQSBzaW5n
bGUgbWVtb3J5IGhvdHBsdWcgZXZlbiBhY3Jvc3MgbXV0bGlwbGUgbWVtYmxvY2tzIChmcm9tDQo+
ID4gPiA+ICAgICB3aGljaCB0ZHhfbWVtbGlzdCBlbnRyaWVzIGFyZSBkZXJpdmVkKSBpcyBpbXBv
c3NpYmxlLiAgLi4uIHRoZW4NCj4gPiA+ID4gICAgIGFjdHVhbGx5IGV4cGxhaW4NCj4gPiA+ID4g
DQo+ID4gDQo+ID4gSG93IGFib3V0IGJlbG93Pw0KPiA+IA0KPiA+ICAgICAgICAgLyoNCj4gPiAg
ICAgICAgICAqIFRoaXMgY2hlY2sgYXNzdW1lcyB0aGF0IHRoZSBzdGFydF9wZm48LT5lbmRfcGZu
IHJhbmdlIGRvZXMgbm90IGNyb3NzDQo+ID4gICAgICAgICAgKiBtdWx0aXBsZSB0ZHhfbWVtbGlz
dCBlbnRyaWVzLiBBIHNpbmdsZSBtZW1vcnkgaG90cGx1ZyBldmVudCBhY3Jvc3MNCj4gPiAgICAg
ICAgICAqIG11bHRpcGxlIG1lbWJsb2NrcyAoZnJvbSB3aGljaCB0ZHhfbWVtbGlzdCBlbnRyaWVz
IGFyZSBkZXJpdmVkKSBpcw0KPiA+ICAgICAgICAgICogaW1wb3NzaWJsZS4gVGhhdCBtZWFucyBz
dGFydF9wZm48LT5lbmRfcGZuIHJhbmdlIGNhbm5vdCBleGNlZWQgYQ0KPiA+ICAgICAgICAgICog
dGR4X21lbWxpc3QgZW50cnksIGFuZCB0aGUgbmV3IHJhbmdlIGlzIFREWCBtZW1vcnkgaWYgaXQg
aXMgZnVsbHkNCj4gPiAgICAgICAgICAqIGNvdmVyZWQgYnkgYW55IHRkeF9tZW1saXN0IGVudHJ5
Lg0KPiA+ICAgICAgICAgICovDQo+IA0KPiBJIHdhcyBob3BpbmcgeW91IHdvdWxkIGFjdHVhbGx5
IGV4cGxhaW4gd2h5IGl0IGlzIGltcG9zc2libGUuDQo+IA0KPiBJcyB0aGVyZSBzb21ldGhpbmcg
ZnVuZGFtZW50YWwgdGhhdCBrZWVwcyBhIG1lbW9yeSBhcmVhIHRoYXQgc3BhbnMgdHdvDQo+IG5v
ZGVzIGZyb20gYmVpbmcgcmVtb3ZlZCBhbmQgdGhlbiBhIG5ldyBhcmVhIGFkZGVkIHRoYXQgaXMg
Y29tcHJpc2VkIG9mDQo+IGEgc2luZ2xlIG5vZGU/DQo+IEJvb3QgdGltZToNCj4gDQo+IAl8IG1l
bWJsb2NrICB8ICBtZW1ibG9jayB8DQo+IAk8LS1Ob2RlPTAtLT4gPC0tTm9kZT0xLS0+DQo+IA0K
PiBGdW5reSBob3RwbHVnLi4uIG5vdGhpbmcgdG8gc2VlIGhlcmUsIHRoZW46DQo+IA0KPiAJPC0t
LS0tLS0tTm9kZT0yLS0tLS0tLS0+DQoNCkkgbXVzdCBoYXZlIG1pc3NlZCBzb21ldGhpbmcsIGJ1
dCBob3cgY2FuIHRoaXMgaGFwcGVuPw0KDQpJIGhhZCBtZW1vcnkgdGhhdCB0aGlzIGNhbm5vdCBo
YXBwZW4gYmVjYXVzZSB0aGUgQklPUyBhbHdheXMgYWxsb2NhdGVzIGFkZHJlc3MNCnJhbmdlcyBm
b3IgYWxsIE5VTUEgbm9kZXMgZHVyaW5nIG1hY2hpbmUgYm9vdC4gIFRob3NlIGFkZHJlc3MgcmFu
Z2VzIGRvbid0DQpuZWNlc3NhcmlseSBuZWVkIHRvIGhhdmUgRElNTSBmdWxseSBwb3B1bGF0ZWQg
YnV0IHRoZXkgZG9uJ3QgY2hhbmdlIGR1cmluZw0KbWFjaGluZSdzIHJ1bnRpbWUuDQoNCj4gDQo+
IEkgd291bGQgYmVsaWV2ZSB0aGF0IHRoZXJlIGlzIG5vIGN1cnJlbnQgYmFyZS1tZXRhbCBURFgg
c3lzdGVtIHRoYXQgaGFzDQo+IGFuIGltcGxlbWVudGF0aW9uIGxpa2UgdGhpcy4gIEJ1dCwgdGhl
IGNvbW1lbnRzIGFib3ZlIHNwZWFrIGxpa2UgaXQncw0KPiBmdW5kYW1lbnRhbGx5IGltcG9zc2li
bGUuICBUaGF0IHNob3VsZCBiZSBjbGFyaWZpZWQuDQo+IA0KPiBJbiBvdGhlciB3b3JkcywgdGhh
dCBjb21tZW50IHRhbGtzIGFib3V0IG1lbWJsb2NrIGF0dHJpYnV0ZXMgYXMgYmVpbmcNCj4gdGhl
IGNvcmUgdW5kZXJseWluZyByZWFzb24gdGhhdCB0aGF0IHNpbXBsaWZpZWQgY2hlY2sgaXMgT0su
ICBJcyB0aGF0DQo+IGl0LCBvciBpcyBpdCByZWFsbHkgdGhlIHJlZHVjZWQgaG90cGx1ZyBmZWF0
dXJlIHNldCBvbiBURFggc3lzdGVtcz8NCg0KTGV0IG1lIGRvIG1vcmUgaG9tZXdvcmsgYW5kIGdl
dCBiYWNrIHRvIHlvdS4NCg0KPiANCj4gDQo+IC4uLg0KPiA+ID4gPiA+ID4gKyAgICAgICAgKiBC
dWlsZCB0aGUgbGlzdCBvZiAiVERYLXVzYWJsZSIgbWVtb3J5IHJlZ2lvbnMgd2hpY2ggY292ZXIg
YWxsDQo+ID4gPiA+ID4gPiArICAgICAgICAqIHBhZ2VzIGluIHRoZSBwYWdlIGFsbG9jYXRvciB0
byBndWFyYW50ZWUgdGhhdC4gIERvIGl0IHdoaWxlDQo+ID4gPiA+ID4gPiArICAgICAgICAqIGhv
bGRpbmcgbWVtX2hvdHBsdWdfbG9jayByZWFkLWxvY2sgYXMgdGhlIG1lbW9yeSBob3RwbHVnIGNv
ZGUNCj4gPiA+ID4gPiA+ICsgICAgICAgICogcGF0aCByZWFkcyB0aGUgQHRkeF9tZW1saXN0IHRv
IHJlamVjdCBhbnkgbmV3IG1lbW9yeS4NCj4gPiA+ID4gPiA+ICsgICAgICAgICovDQo+ID4gPiA+
ID4gPiArICAgICAgIGdldF9vbmxpbmVfbWVtcygpOw0KPiA+ID4gPiANCj4gPiA+ID4gT2gsIGl0
IGFjdHVhbGx5IHVzZXMgdGhlIG1lbW9yeSBob3RwbHVnIGxvY2tpbmcgZm9yIGxpc3QgcHJvdGVj
dGlvbi4NCj4gPiA+ID4gVGhhdCdzIGF0IGxlYXN0IGEgYml0IHN1YnRsZS4gIFBsZWFzZSBkb2N1
bWVudCB0aGF0IHNvbWV3aGVyZSBpbiB0aGUNCj4gPiA+ID4gZnVuY3Rpb25zIHRoYXQgYWN0dWFs
bHkgbWFuaXB1bGF0ZSB0aGUgbGlzdC4NCj4gPiANCj4gPiBhZGRfdGR4X21lbWJsb2NrKCkgYW5k
IGZyZWVfdGR4X21lbWxpc3QoKSBldmVudHVhbGx5IGNhbGxzIGxpc3RfYWRkX3RhaWwoKSBhbmQN
Cj4gPiBsaXN0X2RlbCgpIHRvIG1hbmlwdWxhdGUgdGhlIGxpc3QsIGJ1dCB0aGV5IGFjdHVhbGx5
IHRha2VzICdzdHJ1Y3QgbGlzdF9oZWFkDQo+ID4gKnRtYl9saXN0JyBhcyBhcmd1bWVudC4gJ3Rk
eF9tZW1saXN0JyBpcyBwYXNzZWQgdG8gYnVpbGRfdGR4X21lbWxpc3QoKSBhcyBpbnB1dC4NCj4g
PiANCj4gPiBEbyB5b3UgbWVhbiBkb2N1bWVudCB0aGUgbG9ja2luZyBhcm91bmQgdGhlIGltcGxl
bWVudGF0aW9uIG9mIGFkZF90ZHhfbWVtYmxvY2soKQ0KPiA+IGFuZCBmcmVlX3RkeF9tZW1saXN0
KCk/DQo+ID4gDQo+ID4gT3Igc2hvdWxkIHdlIGp1c3QgbWVudGlvbiBpdCBhcm91bmQgdGhlICd0
ZHhfbWVtbGlzdCcgdmFyaWFibGU/DQo+ID4gDQo+ID4gLyogQWxsIFREWC11c2FibGUgbWVtb3J5
IHJlZ2lvbnMuIFByb3RlY3RlZCBieSBtZW1vcnkgaG90cGx1ZyBsb2NraW5nLiAqLw0KPiA+IHN0
YXRpYyBMSVNUX0hFQUQodGR4X21lbWxpc3QpOw0KPiANCj4gSSBkb24ndCB0aGluayBJJ2QgaGF0
ZSBpdCBiZWluZyBpbiBhbGwgdGhyZWUgc3BvdHMuICBBbHNvICJwcm90ZWN0ZWQgYnkNCj4gbWVt
b3J5IGhvdHBsdWcgbG9ja2luZyIgaXMgcHJldHR5IGdlbmVyaWMuICBQbGVhc2UgYmUgbW9yZSBz
cGVjaWZpYy4NCg0KT0sgd2lsbCBkby4NCg0KPiANCj4gPiA+ID4gSSB0aGluayBpdCdzIGFsc28g
d29ydGggc2F5aW5nIHNvbWV0aGluZyBoZXJlIGFib3V0IHRoZSBoaWdoLWxldmVsDQo+ID4gPiA+
IGVmZmVjdHMgb2Ygd2hhdCdzIGdvaW5nIG9uOg0KPiA+ID4gPiANCj4gPiA+ID4gICAgIFRha2Ug
YSBzbmFwc2hvdCBvZiB0aGUgbWVtb3J5IGNvbmZpZ3VyYXRpb24gKG1lbWJsb2NrcykuICBUaGlz
DQo+ID4gPiA+ICAgICBzbmFwc2hvdCB3aWxsIGJlIHVzZWQgdG8gZW5hYmxlIFREWCBzdXBwb3J0
IGZvciAqdGhpcyogbWVtb3J5DQo+ID4gPiA+ICAgICBjb25maWd1cmF0aW9uIG9ubHkuICBVc2Ug
YSBtZW1vcnkgaG90cGx1ZyBub3RpZmllciB0byBlbnN1cmUNCj4gPiA+ID4gICAgIHRoYXQgbm8g
b3RoZXIgUkFNIGNhbiBiZSBhZGRlZCBvdXRzaWRlIG9mIHRoaXMgY29uZmlndXJhdGlvbi4NCj4g
PiA+ID4gDQo+ID4gPiA+IFRoYXQncyBpdCwgcmlnaHQ/DQo+ID4gDQo+ID4gWWVzLiBJJ2xsIHNv
bWVob3cgaW5jbHVkZSBhYm92ZSBpbnRvIHRoZSBjb21tZW50IGFyb3VuZCBnZXRfb25saW5lX21l
bXMoKS4NCj4gPiANCj4gPiBCdXQgc2hvdWxkIEkgbW92ZSAiVXNlIGEgbWVtb3J5IGhvdHBsdWcg
bm90aWZpZXIgLi4uIiBwYXJ0IHRvOg0KPiA+IA0KPiA+ICAgICAgICAgZXJyID0gcmVnaXN0ZXJf
bWVtb3J5X25vdGlmaWVyKCZ0ZHhfbWVtb3J5X25iKTsNCj4gPiANCj4gPiBiZWNhdXNlIHRoaXMg
aXMgd2hlcmUgd2UgYWN0dWFsbHkgdXNlIHRoZSBtZW1vcnkgaG90cGx1ZyBub3RpZmllcj8NCj4g
DQo+IEkgYWN0dWFsbHkgd2FudCB0aGF0IHNuaXBwZXQgaW4gdGhlIGNoYW5nZWxvZy4NCg0KV2ls
bCBkby4NCg0KW3NuaXBdDQoNCg==
