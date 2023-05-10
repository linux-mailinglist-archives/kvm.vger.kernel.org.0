Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EC76FDD53
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 14:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbjEJMAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 08:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236713AbjEJL75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 07:59:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50877AA9;
        Wed, 10 May 2023 04:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683719994; x=1715255994;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Y1+VbWDq3bZ3hMT5+OPr5sXlQ507d/sPprEHO3nDdp8=;
  b=acNgrMcNHHrnqI+waM16fYLYqrVkQqxx1gmxAqpW3VIZ0EB0SlDQZj1k
   vShqpHFEYML3q1g9gswDebwfQ4SDxjT2sp+cAiM52d9h4ia++emRQZMIp
   m4fH+2m0ypPgLMasdEJbyH9tn3i+a56JmkFp+DUjTkX6oy7ArN+Ty8Jnn
   7IU9oqpUZ7AbfyZsNdJ7eByZKgOlkOdvbvU1FviP/TmHV81jwSDVEkZWp
   +ZwN3TTtQaYtoqBzHS5ElUNL5lU8tK+PmzabnHRiA1YvNwria8nTXQwqE
   VNm7QloE2P56VHHJEkBQpnhqIlU8NzcTIXtr7QEMd23+gNAdPZRh4pt4V
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="436517674"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="436517674"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 04:59:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="649716906"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="649716906"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 10 May 2023 04:59:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 04:59:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 04:59:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 04:59:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nY6oC9SYKcKJT9+mZGsigU7/ZnQGQHl1djzIWkfcOoFtbiD9sjG08J5K/5HVcFXiKhhTDuhsKCQ7tKl8GOvHbO2mv2+KxtPrea6aW5ESVuE8TmRldSb2JqvC82n1VMh1n/7pxKKXxFDBSMKP145F3toJSA7iWazSX/3Enuk9Cp6A521AY5hBB5MmDZE45mpYdpf93ufM1ttnOofOcAO1K2VP2xSIA/9Wk/u6w5huFcbPM1s6fFv0oKf9mK53WSrjHwT8yGA3s04JLaeJTJXuo5ZELMA46ulHsYsyH+CHTPiVSsukkfDS5oH5GfT27PRhqWW920GzndLjo++dzGGttQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1+VbWDq3bZ3hMT5+OPr5sXlQ507d/sPprEHO3nDdp8=;
 b=KDOB6MOdJBwjR085b7u0m9yQzGzwsYS6FPJw5L6RknDTkkIE91pQp0k4FWK9v+bm/FhBF7sDvvsLpulEuDusRdM0t/dTggFcV5EzhV5yYKEQe/46U7/sBa1kgwyeawN4iC7BAQcGcOS9kYZKV1CgN+FX/msw1JXPRDG1OXN9H7c/BV1ZeQjYalC9eqYAXBAW/CNZLHYcMRfLLroIZKIITFvEtqvRopVHxzmaafwf1+YbrvVeB1tOKX5iBEYjud6KhVadx3FGkCDxi3lUdDVlydSoW0Jfqo0HOtVdMWabji+AuvUtXct2H1/fUXWrXMKnNnkdbD9/S5dYAeLuUPJlhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB8295.namprd11.prod.outlook.com (2603:10b6:a03:479::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 11:59:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 11:59:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v8 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v8 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZgwWdaSeZz3Y/zEmvBzh0TUaxBq9TZ8oA
Date:   Wed, 10 May 2023 11:59:50 +0000
Message-ID: <1c47677bfde89d05264bf874286a899ff644986b.camel@intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
         <20230510060611.12950-4-binbin.wu@linux.intel.com>
In-Reply-To: <20230510060611.12950-4-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB8295:EE_
x-ms-office365-filtering-correlation-id: 3ca4d5bb-2ed4-45aa-e68a-08db514e0f2e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wyxTQXVuDuc9JlGHoKgL3v7xDKhQ3RLZ00q9/EvWNYLJb7Qn+HovYrxXNnZTm/6cMLGULWdv72cEpIYk/Pv79uOedP7Lce1GtcWhgOzUeOFR/+9CjQal79/UScZWuPOUhuaHjzgPNmkH2MGY4a1qxTyL59KF0NAP60s4wAAXqW/4kkpvEDRvocLU+IF2hxzdyzQ7jGiD/zA9/SHTJLfuBk8UfO2kq69wa6by9sKYyqJvOGFp9kgEhW1Y8JEREmN5qf8c0XcFzSj40V7ZyNllA3/SL+8XpHoJqPPoCC2h8jHhqUVBYvmeqh6mEMoa3gYsJ0hKEg7hWzTNWGn1nBCwNz063fUMyamrpzjre5vytqC/PFJvTO4b5xvmqsEUO9c7B3gXjIZ7+kvscaGAGgkETjZd9gMuG5eI43uXyDR7bEtmdRldU3DHRWTPabt+5SRIooC0ET9bwPUECBv12otkBfBsjSea6PlfDlxYju//3mO7gteOaA7odAlNu/O0u7CYZmXRb46YE2zIP4wlFIQNzp8AYp38xjYtlsuRoVZ8cCCE1WY6E5KR1TnvopyzPa6BiAthfmeD1h4WYNUQAMU7yZ9sER6PGikMCTzhj3jFWJA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199021)(36756003)(966005)(91956017)(71200400001)(4326008)(110136005)(2616005)(478600001)(6486002)(54906003)(6506007)(26005)(6512007)(186003)(2906002)(66446008)(66476007)(38100700002)(82960400001)(83380400001)(64756008)(122000001)(66556008)(76116006)(66946007)(41300700001)(86362001)(5660300002)(316002)(38070700005)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OE5PcFlGRWJXOVBKTm5sdWc1YXR3UG5nZDRuemNmM2pTUElTa2lYdUdMckNW?=
 =?utf-8?B?WVdZU3BvblVBazFJSXVrd2xHWWJNR09hbGtNUDVsY0ViaTlXUFJhcWxCU3RC?=
 =?utf-8?B?VWtqZWp5UVpEMmdwc2w5TmJ0VzJMd2tDZlZCeFRhdmtYWTlGUzY2WkIrWHBB?=
 =?utf-8?B?ZklBNk1xY0JQRjVVV1JEM3FJQU1aV05TSGFTQTlKUWNETjRlcG12M2ZZRmJ2?=
 =?utf-8?B?cXV1aEorVjU4c3BGQzcrMFJ4Uytvend4alVoSEY5OTZ6UUEvbmtRV1FLRTlq?=
 =?utf-8?B?YnRaZUFyT0xIRXhMTVI5UEx0NEh2Q1kwaUtPcTlOY3VKZm5TZWhKUlFHK043?=
 =?utf-8?B?TjNBSVhQdHM3VHl3dE5icDRhZnF0QUNaZEJoZjltQ2JCbWd4ZldRZis2ak45?=
 =?utf-8?B?QXNIdk4vK0lJK2dSWWFuTWo2a0svMzZ6aS9jRUVCNUd4Q2Y1d1JDVVhYWkkz?=
 =?utf-8?B?cTJ5dUtrMkc5Wkc1N1lrb0U2VDVBQWQzWEVIYXF2U1lLRnhwV0thR0NSVEdG?=
 =?utf-8?B?YXNSbVNQK2NZTTNHbGEvRFU4ckJTR085SVFFamVwbSsreXluTkdaV21PeWtj?=
 =?utf-8?B?UVVjM2VoWG9qQitRNitreU1tcUNtRk5ZSnRxcXVVUUkrd3hHRDFRTFdjd3px?=
 =?utf-8?B?S0RqVjZSL3Nyc0Nud0N2R3hTYnpiQkdhMys1ZnBoVFRhenZYYXFRNXNDYTlF?=
 =?utf-8?B?eVdsN01iekJHUVZ5MWRtN3pnQ3dvdXpnc2dTck1wT2ZCOG91cERLazZtc1BS?=
 =?utf-8?B?MkN5TUQzaFYxVWtiUVlNK29kZXhaQjNvd0ZsOWlqbENzWjh1NjlwUDFmQlla?=
 =?utf-8?B?eDJyY3YwRDFLWGd4b1hhZFg1M2pBNGFCbklrMjAva3RmMzB1bml5SnYwOTZi?=
 =?utf-8?B?bGsxbnBMSk9lYkVENldqRzNjUFhMZTVVS2NqdUVnSi9aV0lnaldzVTBhUHpM?=
 =?utf-8?B?dGJ5MTA5K0Fma21FaTVhVi9GODRFQW9rZit3UEx6cmZYWC9KUkJyUnhrWThC?=
 =?utf-8?B?d011SklPSlEvY0VQb3czd0FLRWtaUitBZDBlOW9Gd0F6T1VqWk9jT2FjSHBJ?=
 =?utf-8?B?V0FZODhMK202dDNLdUlRZVRteUxhcEJVRjNubkljbnlVVy92ZmUwUzF6OXl4?=
 =?utf-8?B?RWRUMzNzcnFRdnRqQXd2bmhidy9ybnRwYUhwS0FaQzFGV01ldDlMdk8yQVlv?=
 =?utf-8?B?V0twdStKRzFmdUJXMjRRTXk3dWZlMWpmYVh5TTVGY3F1T0dtcXdjeGxQSWU0?=
 =?utf-8?B?UjFPT0NGWGpGNlpyMUdwVEFTRHdRUW9EMWdoVUxzWnhTZFJhSC9ra1dscThO?=
 =?utf-8?B?cjNFV1J4d0t5cGI1ZTBmWlpGelJzQnN6d1pNc2pGdTU1dlNWTVV4bENOMlhi?=
 =?utf-8?B?cHhXY2VidkE1elRZSWpaZFJCalRBNlBLNGVONWxHMENQZElWS0Q2ZUM3Y0ZG?=
 =?utf-8?B?ZG1QNGpFTFhzK1Vpd0FjUXROd2hMb3MzTGwzL1lRVTIyRVhhK2NpQ3dpOHNn?=
 =?utf-8?B?UlpaTFFWSlBVUUlKRGpwN0VSay8raVpOM1hoS2UwMkxEcjh4K1VBbTZ3eHZ3?=
 =?utf-8?B?dDVlQlNwZHpFTzkra3V3eTg5Y1Z0eVhvbm1FaU1UZEhJbkFOK2taOHFrUWQz?=
 =?utf-8?B?WU5RVFVmVmUvQ0oxSTdySko1RTA3WUpObmgySTh1MEhnVWVPc2VMWTE3ejZm?=
 =?utf-8?B?L095a1hTZ0dWaVR0Q01nOUI3aVVvSTIyRGVNZk1IbVVoa0VHVTVaSnR4K1ds?=
 =?utf-8?B?NHVXdVlBTnFCK2dTRG1Sb1g4MnlBMlhlMGJWTU9aQVpyRmZQTmN5bjJ4TlFO?=
 =?utf-8?B?RTFBWDZ1SzA5aCtrRFVjRE1oWVM1K2t0VDdXT3lUWG5kNTBNQzR2cTJZQlIv?=
 =?utf-8?B?RHdaTmMrcUxtSVk2YjNkYng4Rkl0L2xvYm5tcVdFc3hTTnVXVzZEM2xPd2lw?=
 =?utf-8?B?dHlab3Z5Y3BrZDNwNVFJTVRkSXBOUUl5dWFKVTlrQjJjaUhSamFPL096azFq?=
 =?utf-8?B?UDRVanYzNzJFT0lZU1RFVy9KejFzN3F0M2FuQUpxb21acnJ1Vm82UndPQXQ2?=
 =?utf-8?B?NDJDT2RCYmFIQ3JDdjJOZVNrM0FIMFNheFAwczBDNUY3eFdJS1E2TGFiR2V3?=
 =?utf-8?Q?aLiXcAsdxTKhzXESOt5goi0fH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <284789388C58E148A03C4E662A256E24@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca4d5bb-2ed4-45aa-e68a-08db514e0f2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 11:59:50.6515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GaCQsmOjozYwg00taeIKoVFrOLYQzPU9t7qKjNiTcENUmu/nCDjHnQ4kKdwGD2+PXFmMjZpyR6Wl93Buc0Ej+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8295
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTEwIGF0IDE0OjA2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEZy
b206IFJvYmVydCBIb28gPHJvYmVydC5odUBsaW51eC5pbnRlbC5jb20+DQo+IA0KPiBBZGQgc3Vw
cG9ydCB0byBhbGxvdyBndWVzdHMgdG8gc2V0IHR3byBuZXcgQ1IzIG5vbi1hZGRyZXNzIGNvbnRy
b2wgYml0cyBmb3INCj4gZ3Vlc3RzIHRvIGVuYWJsZSB0aGUgbmV3IEludGVsIENQVSBmZWF0dXJl
IExpbmVhciBBZGRyZXNzIE1hc2tpbmcgKExBTSkgb24gdXNlcg0KPiBwb2ludGVycy4NCj4gDQo+
IExBTSBtb2RpZmllcyB0aGUgY2hlY2tpbmcgdGhhdCBpcyBhcHBsaWVkIHRvIDY0LWJpdCBsaW5l
YXIgYWRkcmVzc2VzLCBhbGxvd2luZw0KPiBzb2Z0d2FyZSB0byB1c2Ugb2YgdGhlIHVudHJhbnNs
YXRlZCBhZGRyZXNzIGJpdHMgZm9yIG1ldGFkYXRhIGFuZCBtYXNrcyB0aGUNCj4gbWV0YWRhdGEg
Yml0cyBiZWZvcmUgdXNpbmcgdGhlbSBhcyBsaW5lYXIgYWRkcmVzc2VzIHRvIGFjY2VzcyBtZW1v
cnkuIExBTSB1c2VzDQo+IHR3byBuZXcgQ1IzIG5vbi1hZGRyZXNzIGJpdHMgTEFNX1U0OCAoYml0
IDYyKSBhbmQgQU1fVTU3IChiaXQgNjEpIHRvIGNvbmZpZ3VyZQ0KPiBMQU0gZm9yIHVzZXIgcG9p
bnRlcnMuIExBTSBhbHNvIGNoYW5nZXMgVk1FTlRFUiB0byBhbGxvdyBib3RoIGJpdHMgdG8gYmUg
c2V0IGluDQo+IFZNQ1MncyBIT1NUX0NSMyBhbmQgR1VFU1RfQ1IzIGZvciB2aXJ0dWFsaXphdGlv
bi4NCj4gDQo+IFdoZW4gRVBUIGlzIG9uLCBDUjMgaXMgbm90IHRyYXBwZWQgYnkgS1ZNIGFuZCBp
dCdzIHVwIHRvIHRoZSBndWVzdCB0byBzZXQgYW55IG9mDQo+IHRoZSB0d28gTEFNIGNvbnRyb2wg
Yml0cy4gSG93ZXZlciwgd2hlbiBFUFQgaXMgb2ZmLCB0aGUgYWN0dWFsIENSMyB1c2VkIGJ5IHRo
ZQ0KPiBndWVzdCBpcyBnZW5lcmF0ZWQgZnJvbSB0aGUgc2hhZG93IE1NVSByb290IHdoaWNoIGlz
IGRpZmZlcmVudCBmcm9tIHRoZSBDUjMgdGhhdA0KPiBpcyAqc2V0KiBieSB0aGUgZ3Vlc3QsIGFu
ZCBLVk0gbmVlZHMgdG8gbWFudWFsbHkgYXBwbHkgYW55IGFjdGl2ZSBjb250cm9sIGJpdHMNCj4g
dG8gVk1DUydzIEdVRVNUX0NSMyBiYXNlZCBvbiB0aGUgY2FjaGVkIENSMyAqc2VlbiogYnkgdGhl
IGd1ZXN0Lg0KPiANCj4gS1ZNIG1hbnVhbGx5IGNoZWNrcyBndWVzdCdzIENSMyB0byBtYWtlIHN1
cmUgaXQgcG9pbnRzIHRvIGEgdmFsaWQgZ3Vlc3QgcGh5c2ljYWwNCj4gYWRkcmVzcyAoaS5lLiB0
byBzdXBwb3J0IHNtYWxsZXIgTUFYUEhZU0FERFIgaW4gdGhlIGd1ZXN0KS4gRXh0ZW5kIHRoaXMg
Y2hlY2sNCj4gdG8gYWxsb3cgdGhlIHR3byBMQU0gY29udHJvbCBiaXRzIHRvIGJlIHNldC4gQW5k
IHRvIG1ha2Ugc3VjaCBjaGVjayBnZW5lcmljLA0KPiBpbnRyb2R1Y2UgYSBuZXcgZmllbGQgJ2Ny
M19jdHJsX2JpdHMnIHRvIHZjcHUgdG8gcmVjb3JkIGFsbCBmZWF0dXJlIGNvbnRyb2wgYml0cw0K
PiB0aGF0IGFyZSBhbGxvd2VkIHRvIGJlIHNldCBieSB0aGUgZ3Vlc3QuIEFmdGVyIGNoZWNrLCBu
b24tYWRkcmVzcyBiaXRzIG9mIGd1ZXN0DQo+IENSMyB3aWxsIGJlIHN0cmlwcGVkIG9mZiB0byBl
eHRyYWN0IGd1ZXN0IHBoeXNpY2FsIGFkZHJlc3MuDQo+IA0KPiBJbiBjYXNlIG9mIG5lc3RlZCwg
Zm9yIGEgZ3Vlc3Qgd2hpY2ggc3VwcG9ydHMgTEFNLCBib3RoIFZNQ1MxMidzIEhPU1RfQ1IzIGFu
ZA0KPiBHVUVTVF9DUjMgYXJlIGFsbG93ZWQgdG8gaGF2ZSB0aGUgbmV3IExBTSBjb250cm9sIGJp
dHMgc2V0LCBpLmUuIHdoZW4gTDAgZW50ZXJzDQo+IEwxIHRvIGVtdWxhdGUgYSBWTUVYSVQgZnJv
bSBMMiB0byBMMSBvciB3aGVuIEwwIGVudGVycyBMMiBkaXJlY3RseS4gS1ZNIGFsc28NCj4gbWFu
dWFsbHkgY2hlY2tzIFZNQ1MxMidzIEhPU1RfQ1IzIGFuZCBHVUVTVF9DUjMgYmVpbmcgdmFsaWQg
cGh5c2ljYWwgYWRkcmVzcy4NCj4gRXh0ZW5kIHN1Y2ggY2hlY2sgdG8gYWxsb3cgdGhlIG5ldyBM
QU0gY29udHJvbCBiaXRzIHRvby4NCj4gDQo+IE5vdGUsIExBTSBkb2Vzbid0IGhhdmUgYSBnbG9i
YWwgY29udHJvbCBiaXQgdG8gdHVybiBvbi9vZmYgTEFNIGNvbXBsZXRlbHksIGJ1dA0KPiBwdXJl
bHkgZGVwZW5kcyBvbiBoYXJkd2FyZSdzIENQVUlEIHRvIGRldGVybWluZSBpdCBjYW4gYmUgZW5h
YmxlZCBvciBub3QuIFRoYXQNCj4gbWVhbnMsIHdoZW4gRVBUIGlzIG9uLCBldmVuIHdoZW4gS1ZN
IGRvZXNuJ3QgZXhwb3NlIExBTSB0byBndWVzdCwgdGhlIGd1ZXN0IGNhbg0KPiBzdGlsbCBzZXQg
TEFNIGNvbnRyb2wgYml0cyBpbiBDUjMgdy9vIGNhdXNpbmcgcHJvYmxlbS4gVGhpcyBpcyBhbiB1
bmZvcnR1bmF0ZQ0KPiB2aXJ0dWFsaXphdGlvbiBob2xlLiBLVk0gY291bGQgY2hvb3NlIHRvIGlu
dGVyY2VwdCBDUjMgaW4gdGhpcyBjYXNlIGFuZCBpbmplY3QNCj4gZmF1bHQgYnV0IHRoaXMgd291
bGQgaHVydCBwZXJmb3JtYW5jZSB3aGVuIHJ1bm5pbmcgYSBub3JtYWwgVk0gdy9vIExBTSBzdXBw
b3J0Lg0KPiBUaGlzIGlzIHVuZGVzaXJhYmxlLiBKdXN0IGNob29zZSB0byBsZXQgdGhlIGd1ZXN0
IGRvIHN1Y2ggaWxsZWdhbCB0aGluZyBhcyB0aGUNCj4gd29yc3QgY2FzZSBpcyBndWVzdCBiZWlu
ZyBraWxsZWQgd2hlbiBLVk0gZXZlbnR1YWxseSBmaW5kIG91dCBzdWNoIGlsbGVnYWwNCj4gYmVo
YXZpb3VyIGFuZCB0aGF0IGlzIHRoZSBndWVzdCB0byBibGFtZS4NCj4gDQo+IE9wcG9ydHVuaXN0
aWNhbGx5IHVzZSBHRU5NQVNLX1VMTCgpIHRvIGRlZmluZSBfX1BUX0JBU0VfQUREUl9NQVNLLg0K
PiBPcHBvcnR1bmlzdGljYWxseSB1c2Uga3ZtX3ZjcHVfaXNfbGVnYWxfY3IzKCkgdG8gY2hlY2sg
Q1IzIGluIFNWTSBuZXN0ZWQgY29kZSwNCj4gdG8gcHJvdmlkZSBhIGNsZWFyIGRpc3RpbmN0aW9u
IGIvdCBDUjMgYW5kIEdQQSBjaGVja3MuDQo+IA0KPiBTdWdnZXN0ZWQtYnk6IFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSG9v
IDxyb2JlcnQuaHVAbGludXguaW50ZWwuY29tPg0KPiBDby1kZXZlbG9wZWQtYnk6IEJpbmJpbiBX
dSA8YmluYmluLnd1QGxpbnV4LmludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQmluYmluIFd1
IDxiaW5iaW4ud3VAbGludXguaW50ZWwuY29tPg0KPiBUZXN0ZWQtYnk6IFh1ZWxpYW4gR3VvIDx4
dWVsaWFuLmd1b0BpbnRlbC5jb20+DQo+IA0KDQpbLi4uXQ0KDQo+IC0tLSBhL2FyY2gveDg2L2t2
bS9tbXUvbW11LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiBAQCAtMzgxMiw3
ICszODEyLDEzIEBAIHN0YXRpYyBpbnQgbW11X2FsbG9jX3NoYWRvd19yb290cyhzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUpDQo+ICAJaHBhX3Qgcm9vdDsNCj4gIA0KPiAgCXJvb3RfcGdkID0ga3ZtX21t
dV9nZXRfZ3Vlc3RfcGdkKHZjcHUsIG1tdSk7DQo+IC0Jcm9vdF9nZm4gPSByb290X3BnZCA+PiBQ
QUdFX1NISUZUOw0KPiArCS8qDQo+ICsJICogR3Vlc3QgUEdEIGNhbiBiZSBDUjMgb3IgRVBUUCAo
Zm9yIG5lc3RlZCBFUFQgY2FzZSkuIENSMyBtYXkgY29udGFpbg0KPiArCSAqIGFkZGl0aW9uYWwg
Y29udHJvbCBiaXRzIChlLmcuIExBTSBjb250cm9sIGJpdHMpLiBUbyBiZSBnZW5lcmljLA0KPiAr
CSAqIHVuY29uZGl0aW9uYWxseSBzdHJpcCBub24tYWRkcmVzcyBiaXRzIHdoZW4gY29tcHV0aW5n
IHRoZSBHRk4gc2luY2UNCj4gKwkgKiB0aGUgZ3Vlc3QgUEdEIGhhcyBhbHJlYWR5IGJlZW4gY2hl
Y2tlZCBmb3IgdmFsaWRpdHkuDQo+ICsJICovDQo+ICsJcm9vdF9nZm4gPSAocm9vdF9wZ2QgJiBf
X1BUX0JBU0VfQUREUl9NQVNLKSA+PiBQQUdFX1NISUZUOw0KDQpMb29rcyBpdCdzIGJldHRlciB0
byBtYXNrIG9mZiBub24tYWRkcmVzcyBiaXRzIGJhc2VkIG9uIGd1ZXN0J3MgaW52YWxpZCBwaHlz
aWNhbA0KYWRkcmVzcyBiaXRzLCBmb3IgaW5zdGFuY2UsIGJhc2VkIG9uIHZjcHUtPmFyY2gucmVz
ZXJldmVkX2dwYV9iaXRzLiAgQnV0IGxvb2tpbmcNCmF0IHRoZSBvbGQgZGlzY3Vzc2lvbiBpdCBh
cHBlYXJzIFNlYW4gc3VnZ2VzdGVkIHRoaXMgd2F5Og0KDQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9hbGwvWkF1UFB2OFBVRFgyUkJRYUBnb29nbGUuY29tLw0KDQpTbyBhbnl3YXk6DQoNClJldmll
d2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCg0KDQoNCg0K
