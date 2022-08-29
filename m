Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197C85A40B7
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 03:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiH2BhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 21:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiH2BhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 21:37:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695002DA83;
        Sun, 28 Aug 2022 18:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661737039; x=1693273039;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RMln3EguAmkSo57eUoDmmjdNoviYPTMGaHy4MDI282A=;
  b=LtnkbbTve1wUh00f0jPRJzJbfk60hrZ75MD23Ji+Di5XNW7uBYD4w1DY
   28JHcpm80bBpDfKno6swmkmdTU+byz83FgO7Sd3rwmAdOeRcBLzXJUSZ4
   U/XV41c59ayRxxp/qShCyS0MH9ya+rcD8XVKCSTpKB5D0JczjQASFMvSy
   9Vlk3W2+Zprr8mIK80/Cu7yCXX2Viidzpa1tp7TgHq8E1o6AJT0knO9eb
   AFsS9DxPbSRPNLsd00Y8OnvG8t4XjpJW3HF5UAHqDGzAEeuEGEXZx5Kd8
   PSEV58Ad7iPNd0vBfrVH0q6htYD80WdYEf7hPlyYYrOGkV8uFoSn0GhaJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="296060569"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="296060569"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 18:37:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="644254157"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 28 Aug 2022 18:37:18 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 18:37:18 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 18:37:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 18:37:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 18:37:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRtP1E3Eo8RgHrwVvCw8Qvy8URqBiIGcSN9ao5EKRsRQ9LaizAm8zScp9y4gphDYS8WiyoWtHlqtswFH0hvYhvX/m6r/NO8+25MrO6ZMuMbbl1rEpBh/tCovilO+dgFohlN5164U+mRFYrAO/wSrL0i50vt2W3WQHkWZEoEgSXB3NWBGVFiAbqBbH6C03ZueAhkxIhyHkv414vMGs8hr9G5j5z7MFiccyt6HD32bY0Bjm28OsO5+xNtWlDjN4IwhF5TIY8XAhARaEneCZpIUkSOzCjLWkhJPRWjDNpj6V6oaXR4g9YL4Z8Gvyiq8l0yjjtzxsIjKf363IrvnO6LkJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMln3EguAmkSo57eUoDmmjdNoviYPTMGaHy4MDI282A=;
 b=A6+FrswhFAN3nOxkEZ0IlDjcu4XdJzx31RaU+x2N75KfshZAlnlzjzQCDGKFEmojHppPnEb1XatyfvvcVua4/M0I0AZUXZeTyumoza2yZYG5bHnsVG9CDCRJQzxtmzNOasCQm9LKNLKv36ejnWxqDZRS2pDCVmWn3bdEYcq3m6+tNh0owftTX4zntnCSK1v9mqHXTbGgGb4Kmqm/riRlu+9WXfEJArgdYnQbSaSqMUmtWsCIzh1BWLRe5p8HiIV1jgut9LaKimF6YyWalTB9qrrFrWPkDUsYNxsLhHN8RbiTtTiNHfrBVQ7W2UxL6HiVMX18nEUb2cle49SVsTwd4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MWHPR1101MB2335.namprd11.prod.outlook.com (2603:10b6:300:73::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Mon, 29 Aug
 2022 01:37:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%9]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 01:37:14 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function to
 KVM guest
Thread-Topic: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Thread-Index: AQHYsqvDhJ5ikbiH/kmiVdBjKSRam62+/3eAgADHRoCAAAb/gIAAAXwAgAA854CABR5DgA==
Date:   Mon, 29 Aug 2022 01:37:13 +0000
Message-ID: <6ae8a6ede768315c43f3dd224d339c4c41c3e445.camel@intel.com>
References: <20220818023829.1250080-1-kai.huang@intel.com>
         <YwbrywL9S+XlPzaX@kernel.org> <YweS9QRqaOgH7pNW@google.com>
         <236e5130-ec29-e99d-a368-3323a5f6f741@intel.com>
         <YweaEl48I7pxKMm8@google.com> <YwfNKePFxyeRtscl@kernel.org>
In-Reply-To: <YwfNKePFxyeRtscl@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aac539df-7c9f-40fb-11af-08da895efff4
x-ms-traffictypediagnostic: MWHPR1101MB2335:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ABQ/OPHRDaX0KMXZ35qtn6gROAWi1ack2BccPHy1uLEWymhAARLQ+NHY3LZ0bePTKkdh3lbGpnUnu1PIEvB0umUclV2iGuzpo/IzPmHBkPK1j+APF/gbw5yowzksIeAbz7VXRKBU3WBGWFyfDk8EGGC/4J/JPMnmmjqH39xuENgDCGT7BDzNIBMGrWFCdHyY7xL67rMWhem1cDxIwdKoeXtbZ5QKkTn6jjYGsFEu0utAtR3xpYRhFRKd76bV1QKLj2IN8npdQf2eYLIj/uOPdcyMwyc6f4Hvk2NQLyi6INVaOurEbqFFKrSM0UGw9THl8QVXiml+fqSZThDpDboA1K5229ZTh1Mniz3RfxHPg9nbLGkIxJUdY0D/kdSK5d3Jwjnzb6QQpprN/F4m4JCbPaksx1jZ85c2Nd95e8gM4DDOHNcU96RRl9l7nxzLmaMQIfSa3h21SOcbJWVanOX6O5Ov3VojJ6UPGr8moUaTdT+26AjfoOJm30tNujICV2dTR5vlUyyMRNhVrMZfn9oKbUyfBBHsEk5yFmlXiv+WNtzBGlHl2DF4e5O10WgTFl1W9tnwwrye2ig27DDo5uBM66h+3xsiZIbYyofc/3PjzW75NXgNBKwyAUnLV1JHOO3IUlYd8E8N+QPeg8kyUUcscQDc5/u5SJoS3PoOmz6bDof3ZIV3r3LNYEbW0/Jts2DsaoL/TVdi+aGZT/3naaOWm2qcTtpmfS4nIzCM3OXZalvRiP+HYnPyFYKlod966DnI+EVUsayWaV6IZxbZ5bHgIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(346002)(366004)(396003)(86362001)(53546011)(6512007)(26005)(6486002)(71200400001)(478600001)(6506007)(41300700001)(186003)(122000001)(38100700002)(82960400001)(38070700005)(83380400001)(2616005)(66476007)(66446008)(64756008)(110136005)(66946007)(5660300002)(66556008)(8676002)(8936002)(4326008)(36756003)(316002)(54906003)(2906002)(91956017)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFhiNTJ5MnRTV2hveUZtVlU0L0gwT0NTRHlTUEFrT2QzZGRFYzV3U1VNbklO?=
 =?utf-8?B?WE16R0hFQnpRR0cvTnpCYURScTJNSm90Vk56M1ViMUVEM29uUTBJTTFaT0wr?=
 =?utf-8?B?c0xKZ3MyWHd4RWd6Y0FrcXdsamRJZ2QyV0Y4aW1QVTBBdklsdzFxWTBDQTl2?=
 =?utf-8?B?MWN2WUNsWUNnTFhaY1RlU2w4WlVNa1k5SnA3U1pQcGo1OXlJaVpiWDhMTlJJ?=
 =?utf-8?B?c1NKT0s1VW1Pb3lHQmtwZ1BiZjFyMFc4L1dIY3A2NkN1T3Z4M0ZpTmhrVnBH?=
 =?utf-8?B?K2JDUFhPWlNRVkFWd3lLZlhoS2pkUlBJaVFLWktpcVRnRTEvd0FjR3VBamRF?=
 =?utf-8?B?UExTQzgvR1lQYjV0NWdjYzllTm1ONEVQWGkyVSsxY1RwSzhTTStNaDFLY293?=
 =?utf-8?B?MEVtOVVjOVQ4dHVmQ3V6Ti9JL0NwMG9nb3JTallYM3lNOFZScXdJUitlSWZQ?=
 =?utf-8?B?eUdDa244cFNKc09NN3JMTENZYVFWTFFBcjdIZldrTHlUeCtidllpVzc3c3hR?=
 =?utf-8?B?ZE1PenI4cnRVM2xFSVNVcWJLRDlPMlhHbHZpTkhzQXd5S09MUFlzcFRUaDRL?=
 =?utf-8?B?amk0NTMyM2g3Z0NFQlRGUW1SZjU0QS9hTzV0dm1Cd2JzZHdVemJ4QU9BRHc4?=
 =?utf-8?B?SUxRbHpUVlhZa2tNR0ZlZElsd0VIRDdQQUVSVDYvWENYQ2xVRXljNE1nb2lH?=
 =?utf-8?B?eXJpN0dsbWViYkp1K0ZrNW1zM0JVUzJBVlNVMmhPbmpBWFFXWXk1TzZDaVV3?=
 =?utf-8?B?SXkxZ05Wb05INitNdmF5b2ZEdGd4YVY2YVZQc2o0NU5Tbm02ZWhjRE43RkZ5?=
 =?utf-8?B?SW05dDI4T1dSOGdtMy9aU01tQkZXaEZyUHBjTmtXSXVqVEp6bVkzVU1zKzA0?=
 =?utf-8?B?VmtrNEU0TmdDcEtsWDFkNXptS28zbGM3L1c2VVdSV2RoMGxwVkpROW5SMytO?=
 =?utf-8?B?UXlzVGVDM3lNQmR6VG5FbG04ODVmNTVRRjY0R2s4SFZSWSt0RG9qZ3pZWXZj?=
 =?utf-8?B?UVhGU1F1Y2cvWFEwUTBHcDUvTDUwTXlSWVFadGxGWS85RmlKM1UySzRtZDJI?=
 =?utf-8?B?Q0duckNPYTdNdXB4N1k2Q3VOY2NnbDNSRThvOGVXNVV0ZnJyNDJ1OUlIQWp2?=
 =?utf-8?B?SHhFdG9vV0phN2xCOEJmVzZOdW12aVlxV0U4TFdmZng3WGpaOXAyMFgxMWVW?=
 =?utf-8?B?V0diMU1OeFFqemFZU3ZhQnh0UDdYNHgwUElUZVdOU0ZXYlNDUlBxd1JyTkVQ?=
 =?utf-8?B?cXBrYjNzbzhlM0V4d3IzcFpweDkwUXJvcmk5aTZhQ2pCTXdHaWx5aXdGK1J2?=
 =?utf-8?B?TVRMQ1Jpbzd2eWRPQmd5ZERrZEVZVU5TbGVuOFIzZFlaUEU5Ymk4T1A5WUpz?=
 =?utf-8?B?RkhEWVA1OXFOS1NUWGlsUHZ1b0NYcFROcndPU2ZvZlBsZmhpd1ZmOUJvYkE4?=
 =?utf-8?B?NXRBSVlwYi9JMGdseThCVkZaY2lPNW1iZ2Zpa3AzYWVWU2pDc0R6NmNxL2R3?=
 =?utf-8?B?QitpcUJMaGd3OWcvS1d6SzZDd1c1VkFEbmc0aUE4YkNTWnJ5RlhUTzNSdFE1?=
 =?utf-8?B?dVZHQndBSCtlWGNLajF2RlhOUGNNMmZYRkI1ellYN0pmMGNDWVhFWlJXekhm?=
 =?utf-8?B?amEvbFVpR1kwK0R1SWJlM3VPdk1kSzVHdlIzQm9DSzdhcnc4eFB1akUzS3cy?=
 =?utf-8?B?bXIxUDRjc0Z6T1dINkZxemU3d1FFWldKT3g5U2UyUFBTbzZDTFpmNThIbFJL?=
 =?utf-8?B?aGdSdXZNdXBEUlRSODN1UDlkVTMvbFV4L3BIYnZVUEVHSHlEODhvc3JSZHpU?=
 =?utf-8?B?ajNCMWVwRG9KbE80WmVKdmpoc1BvdTNWbWJrV0xtYlVXdHhiUXFBTWp4SjA2?=
 =?utf-8?B?ZUg5cEY0blJJNUhYRVRpNnRWdWMxT013enhjR1NKWGFrT2FDOE5ZM09aYTB3?=
 =?utf-8?B?Mm9ZZlFDWVV0ZThUYlJYTDZ0Umo0eDZteWUvNTIrbGFWbUZUbDRaditDOTNx?=
 =?utf-8?B?V3Qza0dRbDduSVZMLzRqZGdZOUh1ZTI3Y0JJVTNXZytSb2FBWHNDSXQvOXor?=
 =?utf-8?B?U0tzTFFhckMvODJuRG5Od0c2RHBGRjdIM2JlSS9iU00wUFE4SEVZUzZld29j?=
 =?utf-8?B?MzJscnlRYlcvL1JzRGhjWFdBMFJLeks1SjRYYjY1anRoZ05xZXZJNndUbnlP?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8321E3A796245F4FAB7865FDBF35C6A2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aac539df-7c9f-40fb-11af-08da895efff4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 01:37:13.9994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQ2b8xr10DDMg1PbbxeRfi6jSXhPptPUEoBgvJ6+l7EETxK/JNdn88/6UzZ0+hds9q+90w6w8A766t6jgKwRuA==
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

T24gVGh1LCAyMDIyLTA4LTI1IGF0IDIyOjI3ICswMzAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
DQo+IE9uIFRodSwgQXVnIDI1LCAyMDIyIGF0IDAzOjQ5OjM4UE0gKzAwMDAsIFNlYW4gQ2hyaXN0
b3BoZXJzb24gd3JvdGU6DQo+ID4gT24gVGh1LCBBdWcgMjUsIDIwMjIsIERhdmUgSGFuc2VuIHdy
b3RlOg0KPiA+ID4gT24gOC8yNS8yMiAwODoxOSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+ID4gPiA+IFRoaXMgcGF0Y2gsIGFsb25nIHdpdGggeW91ciBwYXRjaCB0byBleHBvc2Ug
QUVYLW5vdGlmeSBhdHRyaWJ1dGUgYml0IHRvDQo+ID4gPiA+ID4gPiBndWVzdCwgaGF2ZSBiZWVu
IHRlc3RlZCB0aGF0IGJvdGggQUVYLW5vdGlmeSBhbmQgRURFQ0NTU0Egd29yayBpbiB0aGUgVk0u
DQo+ID4gPiA+ID4gPiBGZWVsIGZyZWUgdG8gbWVyZ2UgdGhpcyBwYXRjaC4NCj4gPiA+ID4gRGF2
ZSwgYW55IG9iamVjdGlvbiB0byB0YWtpbmcgdGhpcyB0aHJvdWdoIHRoZSBLVk0gdHJlZT8NCj4g
PiA+IA0KPiA+ID4gVGhpcyBzcGVjaWZpYyBwYXRjaD8gIE9yIGFyZSB5b3UgdGFsa2luZyBhYm91
dCB0aGUgY291cGxlIG9mIEFFWC1ub3RpZnkNCj4gPiA+IHBhdGNoZXMgaW4gdGhlaXIgZW50aXJl
dHk/DQo+ID4gDQo+ID4gSSB3YXMgdGhpbmtpbmcganVzdCB0aGlzIHNwZWNpZmljIHBhdGNoLCBi
dXQgSSB0ZW1wb3JhcmlseSBmb3Jnb3QgdGhlcmUgYXJlIG1vcmUNCj4gPiBwYXRjaGVzIGluIGZs
aWdodC4gIEl0IHdvdWxkIGJlIGEgYml0IG9kZCB0byBoYXZlIGVmZmVjdGl2ZWx5IGhhbGYgb2Yg
dGhlIEFFWC1ub3RpZnkNCj4gPiBlbmFibGluZyBnbyB0aHJvdWdoIEtWTS4NCj4gPiANCj4gPiBT
byB3aXRoIHNob3J0bG9nL2NoYW5nZWxvZyB0d2Vha3MsDQo+ID4gDQo+ID4gQWNrZWQtYnk6IFNl
YW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiANCj4gd2l0aCBzdWJzeXN0
ZW0gdGFnIGNoYW5nZSAoU2VhbidzIHZlcnNpb24pOg0KPiANCj4gQWNrZWQtYnk6IEphcmtrbyBT
YWtraW5lbiA8amFya2tvQGtlcm5lbC5vcmc+DQo+IA0KPiBCUiwgSmFya2tvDQoNClRoYW5rcy4g
IFdpbGwgc2VuZCBvdXQgYSBuZXcgdmVyc2lvbiB3aXRoIHVwZGF0ZWQgdGl0bGUgYW5kIGNoYW5n
ZWxvZy4NCg0KLS0gDQpUaGFua3MsDQotS2FpDQo=
