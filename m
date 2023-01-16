Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222BC66BC48
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 11:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjAPK4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 05:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjAPKy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 05:54:59 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168AB1BAF7;
        Mon, 16 Jan 2023 02:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673866482; x=1705402482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZGe2/Kg2qS5HX0FXNO6h9541Gzk48QaXosqw/8V+M7s=;
  b=ViKqb39iaodXbQoBWF7l8dv3C5dVqZRYgRP50Jh1whRrFBLSJzLUoQ1I
   h+jKUnk9uxhIo4WMuzZqo2db8QCj61f7ghKoGV4rjG/b8Asig60kB5ZUZ
   gpQaNyFZIc/oBK3hXtXqHjpkTjJ68IkQ9edD7JvF2Uqrf6gI5G3uVXQZs
   /YooTZcncqXJAbLJaR+18d9bIxUnIYjLupwigXpO8gs6TvN3kjJ4tW5fl
   EeTS3+8Db50epwnsY/DrRw7mhwtFaDhf76tzy7t5Jct54hAEK5a0nKRiY
   CMQPm+fEEIVlyo3GBzXpex7YD9aefdJdRhFhoeK2c5QM8wTbCYYiTKQgw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="388934918"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="388934918"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 02:54:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="727429722"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="727429722"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 16 Jan 2023 02:54:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 02:54:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 02:54:40 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 02:54:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnZZILjc4YNN6Vpg/+aAFTUTRl/c05dJBjOci+o+2TbfduVB7SO9t2sjw57CP29I1EpIQ1kRXZ+7uLEJNojigITU08t2tWk5g1/KaNCVm6QhyTxlF49aToh/gxKI5X/dUU9Purp5dgvuIIqfUbVQGBFMBA52mLTn3ZepgPSSKGuNqKiDhdPurl0swht5irxstQkMkpf4aZn4gzYWwLzKD9LVm3IaBrv4rrrLuk41q5fKy6CFn5jOotpL0H9CEzv0mZvOu1ZVSzVJTuhLJwQo46wqIrZfmjtCo+35z//prS/cB/KnyvYYZP/m56BUxRKwoqjAIgxruH1tjtZ8YiEoCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGe2/Kg2qS5HX0FXNO6h9541Gzk48QaXosqw/8V+M7s=;
 b=mBZsJjCICR8sAEEZRFnnk495axbU53xpnbiwm6H3Yl+sPES8Diua73WQ+dGW1tIp2mQyLmYJpAQ/RfvUzqkgGO5Un8FdY5moS42V+9lk1tQ/ymO0hVdOCsgFiEhSP6V4dpsno2U8Jq/4wCOLfhp5efk5rt1IoWlh3jXejKDKhVthIbSpqi3U68+motiveN3+ek+1wnaWRgcqioKt7slzC5CX8C8PpnXCF+Ao/vwN7KVbPxBJv7jxlGou3AtiP3sejhY0sxMiLGXh2hisCVg+nOkf/0STuezuHqgxYM5gHcUIOpBeYpn5rbaF0CJ1ZERttE+/D4fC2/DHNO/ZAR7/Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5121.namprd11.prod.outlook.com (2603:10b6:303:98::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 10:54:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 10:54:35 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 031/113] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE and removed SPTE
Thread-Topic: [PATCH v11 031/113] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE and removed SPTE
Thread-Index: AQHZJqV2usp9+MKAeke87rC4mRQsEq6g5IgA
Date:   Mon, 16 Jan 2023 10:54:35 +0000
Message-ID: <f7fa8e9f35a451a045fd8e07c00ec2d5bb0dbfcb.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <d193421197cb7699d5eee09b72e6ba92e9978a7b.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <d193421197cb7699d5eee09b72e6ba92e9978a7b.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5121:EE_
x-ms-office365-filtering-correlation-id: 9f709ac3-8292-4a15-64c8-08daf7b00e61
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ll75JFiywgHJgk2UWpf+xYp0zD3J3Jg7mJaG1TEw76OM87E22HUeTvX29Ix2hfz5+p/xLxZzNi9BUXz1Ixa7LCAJJ3NGypAtPExVLsQtAWjOJJFwE65XP+6kYzqLinpdrZlNtd8yN2z8QF4X7zt362cj/X3cqHbjo8TE3OciSupZMm/aRs8Py3fulyqkbz3hqwULX/INdvnbzELHU1RXk+l6YT+pwxkUhXz7M+u2WbxgyLT4yPLxiBhy0jlXajOfaDWdeOEkknfCt8jNkHps281UNXTNTdvMTEAXp9NyJ08XeOFueFqOYG9ezpqvFpvS7x+RL25xk3DIJSR/YMtRb0BWYtxq5+CHDrYMMuEnhAa0aReTFHcDi4VtJWmobkKtGMnRxeeJFTCU39Ib8SXIcQ5MYGVL+wa1EzC0IkdvqtoHi/cUDZHL5V9Go39y12WMghtRblg1pzuLs/gtjuDmCTsG65Y8mCAIABB/As3So5krZDFtQI5q2rABbp+OMCKsbCmsHuIi0RmOcilRbdrPQox3u9rpfbvsh5HdAsRr5L2R8F7MBzS9LdgMqvOGkJ1RSeI4MrLJCDkBCPbpQUQsCuQrplGN4BM/j+WE/bSwQT0kB1vHYHFKXp0ku/i+sUmh7ZBvj2y9ftmEtCARfNdycq9yXY+nIxj7NRt51tXpWjhov8AObZKYBTQBOkadXT49z85lkrCxE+kMoNXaV3mFvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(91956017)(86362001)(6512007)(8676002)(186003)(64756008)(4326008)(26005)(66556008)(66946007)(76116006)(41300700001)(2616005)(66476007)(66446008)(316002)(71200400001)(6506007)(110136005)(54906003)(6636002)(478600001)(6486002)(122000001)(38100700002)(2906002)(38070700005)(82960400001)(83380400001)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enJGMVN6T2dmYnYvNytXOTUrdnpJeFVXNFF0aExtM3p4a1lpU0VHVGJ2TlNm?=
 =?utf-8?B?c3VyWFF6YTBWeGpENjlkOVpKRHpIOXBIdTU2eWZPODhJekZHT2NsLzBBa2JT?=
 =?utf-8?B?YU0xUXFVK2FRaE5pb0FDZVFuWWhETkxidVVmWTRPOTZzK3pYbmlscWdSSTg1?=
 =?utf-8?B?a3BFUFhjVHpMTHlmd1A2Mll5S1g2RUVXQnlqKzFlUFVDSlRqMmNCbHl0SVpH?=
 =?utf-8?B?NnhBYXpZdVZVc2pUQTZjMS9Dbm4xT2k5U0l0dVNJNUNQMDFxNDZjVVNHcGFp?=
 =?utf-8?B?NG5rL1B4MXdMTzJiMjJsNzNGSDB6SkNGWFdyNkVDSTdyVmtwNmdNd2xSRERm?=
 =?utf-8?B?NzRhaVNlOXNkTkt6U3hJeTRlVEhOVTZ2Z1JSUWp3ZCs5MUJ6bEVkSWZqRXhT?=
 =?utf-8?B?cWpaRU40bEUyVGxaV21XcjV3VU5xVGJ6SnE4RW0zYTYxY0dHWlpPTnNhUmY5?=
 =?utf-8?B?WiswTzBubmdRbUpnUUxQVERzejlJc05mbml1aTFucVVRN3BJY3g4cVQvYVdq?=
 =?utf-8?B?QWVWRldCN2xNVDF2SXlCa0FXdFdTejBvMGtRcDVKTlBZbi9hTEVPKzA4cUo0?=
 =?utf-8?B?aW5RZE1qa1FhVmNHME9lN00reS9RZTg4bDI3MER5dEdxQVB3S0V3Qk5lODY2?=
 =?utf-8?B?NHg4cGxieEhyK3prOUlJWGRPQnRuLzJPeVNGYXljbDdNcE5uQXhjVlVoV1Yv?=
 =?utf-8?B?RnZsQVErME11UXdRUDJBUXdldmNiMmpMUFV4bHZKK2tmMjlJMzA3ZFRGWlox?=
 =?utf-8?B?NWRyOFVRN2xwTUNtUTI1OGcybGhXVmRCKysyUS9Xd3BZcHNLTVEzTGE2VDlk?=
 =?utf-8?B?ei9qV20vQXBFSHpWTHlIUHE2dW91OFRVcVRueEV2TTNoNXpISlhUdVBOS0lQ?=
 =?utf-8?B?VXUrS04zRUc4ODNqbkh4T3RrbjJ0QXVtY01nNTQ2WndySWk5cTU0MmJNTWll?=
 =?utf-8?B?ZG1CRDNsMmVqMGFMTHp3c2dyeXkrQWZPMFRtc0RKbWIxeS9QaExuTjNtc045?=
 =?utf-8?B?bkNHSTcrM214dytqdmlKdUVIQVd3Z1R5OGZNQllwN1ZyOVowNjZyVzRURjRu?=
 =?utf-8?B?UHorZXRiMVNOV0U1KzM1UUFmZXJncGVuWmFBSXhZclhFM0ZVemhxd0hYN1hu?=
 =?utf-8?B?bGpuZXRGQlpvN2MzL245VWNWVCsyK0hTNzZmOUsxcE5Rbk9uU2pzRCtBeTRt?=
 =?utf-8?B?RGRTYnRhNG9GUTR4SGlUYTI0M2Z3N29aVVhvaitXRkdjVlF6UGdMeUR4K01S?=
 =?utf-8?B?cHJ1UEdmTkluTTdiZDFvY0Z1d3B1eXBBc1ZOWDUwUktSVXhZOGphSkZrYzdm?=
 =?utf-8?B?ODM5UzdrOGQrVzhaaFlxN3Ntbm4rdEpjT3ZHNEg1NlpqTkxZQ0V2b3FFYVFw?=
 =?utf-8?B?VGNIU2NPVEhTNGthblNJZ05NRC9zcHJVRnc5U0VZVnlQVGJ4Y3EzUUEyQW5T?=
 =?utf-8?B?d3JwM2F4KytRQUp5bkxTaXVSdWxrdUJhNytxT3pjWWFaYSt2SGY4ZDZqZW9Y?=
 =?utf-8?B?T2NIdlNia1d4cTFEL2VaT1h5MjZ3ditpcGpYakw0NEU5WmkxYlhLUmxhc05t?=
 =?utf-8?B?enhtUWRpd1YvWis3Y3NrU0lQaGtJelQ3aUY1d0ZoeGlzRUJzMUxBdXFLemlu?=
 =?utf-8?B?cjZva1p0OGlDMnh2L2ZJU0RXNk4zN3VZbkpaTnVQRy9hNGdGaXphQWRyNHJ0?=
 =?utf-8?B?bEtFK1JQRllMeDdaMWhzb2pTbllzVXppTzVQbHJrSDlFVkZSTHA3dGlDVkIr?=
 =?utf-8?B?THdLYitjMnZRU3pQQk9pTHFQR29GSzNjSXppa2Jka3NvbllTd1J0OTJFTEcv?=
 =?utf-8?B?VjdUZjNmam03QVM0M2dtSlpvMEZxUWIzZ1JCWXV5SXYvNnpQNnpQdmluYW0y?=
 =?utf-8?B?VVgzdWVnNlE3Qis2ZGdINFhnYjV0N2J4UURSMGpDeXV1VUhMR3dwSGhnNG9v?=
 =?utf-8?B?Y05KZGV0cjAybVFteUl4b29yWlMrMlo5TndZakJHN3lwbDN6eFNURThBWXpw?=
 =?utf-8?B?OEtYUTYxSG0wMEZDNW9iM3h6QWhneHZqS1N6ejZGdXFFT3ByblVCMngyZFNW?=
 =?utf-8?B?Y0ZTWGFVQUgxSm9iK1Q3c2d5OXRjbG9hTWJBSWgvQnlKTWFaa0VKZ3B6NE1x?=
 =?utf-8?B?VDlDR2NzZXhqTGhJUjg3Q05OcDhya0RSVnIwdEJtQmVwMEMwMHVCN2lGTmpI?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC5D0E0A9A2D5D42AB246E64D27D3D40@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f709ac3-8292-4a15-64c8-08daf7b00e61
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 10:54:35.3602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /TiWbxd+EKOd5aE0ICyMy3rq+N5kwC6LE/uzJWRUAjhJ2JwUMgw0xJDUUzbTMCJx0INOpFNwA3nSk95ewdvVgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5121
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhl
cnNvbkBpbnRlbC5jb20+DQo+IA0KPiBGb3IgVEQgZ3Vlc3QsIHRoZSBjdXJyZW50IHdheSB0byBl
bXVsYXRlIE1NSU8gZG9lc24ndCB3b3JrIGFueSBtb3JlLCBhcyBLVk0NCj4gaXMgbm90IGFibGUg
dG8gYWNjZXNzIHRoZSBwcml2YXRlIG1lbW9yeSBvZiBURCBndWVzdCBhbmQgZG8gdGhlIGVtdWxh
dGlvbi4NCj4gSW5zdGVhZCwgVEQgZ3Vlc3QgZXhwZWN0cyB0byByZWNlaXZlICNWRSB3aGVuIGl0
IGFjY2Vzc2VzIHRoZSBNTUlPIGFuZCB0aGVuDQo+IGl0IGNhbiBleHBsaWNpdGx5IG1ha2UgaHlw
ZXJjYWxsIHRvIEtWTSB0byBnZXQgdGhlIGV4cGVjdGVkIGluZm9ybWF0aW9uLg0KPiANCj4gVG8g
YWNoaWV2ZSB0aGlzLCB0aGUgVERYIG1vZHVsZSBhbHdheXMgZW5hYmxlcyAiRVBULXZpb2xhdGlv
biAjVkUiIGluIHRoZQ0KPiBWTUNTIGNvbnRyb2wuICBBbmQgYWNjb3JkaW5nbHksIGZvciB0aGUg
TU1JTyBzcHRlIGZvciB0aGUgc2hhcmVkIEdQQSwNCj4gMS4gS1ZNIG5lZWRzIHRvIHNldCAic3Vw
cHJlc3MgI1ZFIiBiaXQgZm9yIHRoZSBub24tcHJlc2VudCBTUFRFIHNvIHRoYXQgRVBUDQo+IHZp
b2xhdGlvbiBoYXBwZW5zIG9uIFREIGFjY2Vzc2luZyBNTUlPIHJhbmdlLiAgMi4gT24gRVBUIHZp
b2xhdGlvbiwgS1ZNDQo+IHNldHMgdGhlIE1NSU8gc3B0ZSB0byBjbGVhciAic3VwcHJlc3MgI1ZF
IiBiaXQgc28gdGhlIFREIGd1ZXN0IGNhbiByZWNlaXZlDQo+IHRoZSAjVkUgaW5zdGVhZCBvZiBF
UFQgbWlzY29uZmlncmF0aW9uIHVubGlrZSBWTVggY2FzZS4gIEZvciB0aGUgc2hhcmVkIEdQQQ0K
PiB0aGF0IGlzIG5vdCBwb3B1bGF0ZWQgeWV0LCBFUFQgdmlvbGF0aW9uIG5lZWQgdG8gYmUgdHJp
Z2dlcmVkIHdoZW4gVEQgZ3Vlc3QNCj4gYWNjZXNzZXMgc3VjaCBzaGFyZWQgR1BBLiAgVGhlIG5v
bi1wcmVzZW50IFNQVEUgdmFsdWUgZm9yIHNoYXJlZCBHUEEgc2hvdWxkDQo+IHNldCAic3VwcHJl
c3MgI1ZFIiBiaXQuDQo+IA0KPiBBZGQgInN1cHByZXNzICNWRSIgYml0IChiaXQgNjMpIHRvIFNI
QURPV19OT05QUkVTRU5UX1ZBTFVFIGFuZA0KPiBSRU1PVkVEX1NQVEUuICBVbmNvbmRpdGlvbmFs
bHkgc2V0IHRoZSAic3VwcHJlc3MgI1ZFIiBiaXQgKHdoaWNoIGlzIGJpdCA2MykNCj4gZm9yIGJv
dGggQU1EIGFuZCBJbnRlbCBhczogMSkgQU1EIGhhcmR3YXJlIGRvZXNuJ3QgdXNlIHRoaXMgYml0
IHdoZW4NCj4gcHJlc2VudCBiaXQgaXMgb2ZmOyAyKSBmb3Igbm9ybWFsIFZNWCBndWVzdCwgS1ZN
IG5ldmVyIGVuYWJsZXMgdGhlDQo+ICJFUFQtdmlvbGF0aW9uICNWRSIgaW4gVk1DUyBjb250cm9s
IGFuZCAic3VwcHJlc3MgI1ZFIiBiaXQgaXMgaWdub3JlZCBieQ0KPiBoYXJkd2FyZS4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNv
bkBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1h
aGF0YUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdm14LmggfCAg
MSArDQo+ICBhcmNoL3g4Ni9rdm0vbW11L3NwdGUuaCAgICB8IDE1ICsrKysrKysrKysrKysrLQ0K
PiAgYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMgfCAgOCArKysrKysrKw0KPiAgMyBmaWxlcyBj
aGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdm14LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92bXgu
aA0KPiBpbmRleCA0OThkYzYwMGJkNWMuLmNkYmYxMmMxYTgzYyAxMDA2NDQNCj4gLS0tIGEvYXJj
aC94ODYvaW5jbHVkZS9hc20vdm14LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdm14
LmgNCj4gQEAgLTUxMSw2ICs1MTEsNyBAQCBlbnVtIHZtY3NfZmllbGQgew0KPiAgI2RlZmluZSBW
TVhfRVBUX0lQQVRfQklUICAgIAkJCSgxdWxsIDw8IDYpDQo+ICAjZGVmaW5lIFZNWF9FUFRfQUND
RVNTX0JJVAkJCSgxdWxsIDw8IDgpDQo+ICAjZGVmaW5lIFZNWF9FUFRfRElSVFlfQklUCQkJKDF1
bGwgPDwgOSkNCj4gKyNkZWZpbmUgVk1YX0VQVF9TVVBQUkVTU19WRV9CSVQJCQkoMXVsbCA8PCA2
MykNCg0KSSBkb24ndCBrbm93IHdoZXRoZXIgeW91IHNob3VsZCBpbnRyb2R1Y2UgdGhpcyBtYWNy
bywgc2luY2UgaXQncyBub3QgdXNlZCBpbg0KdGhpcyBwYXRjaC4NCg0KPiAgI2RlZmluZSBWTVhf
RVBUX1JXWF9NQVNLICAgICAgICAgICAgICAgICAgICAgICAgKFZNWF9FUFRfUkVBREFCTEVfTUFT
SyB8ICAgICAgIFwNCj4gIAkJCQkJCSBWTVhfRVBUX1dSSVRBQkxFX01BU0sgfCAgICAgICBcDQo+
ICAJCQkJCQkgVk1YX0VQVF9FWEVDVVRBQkxFX01BU0spDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rdm0vbW11L3NwdGUuaCBiL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5oDQo+IGluZGV4IGYxOTBl
YWY2YjJiNS4uNDcxMzc4ZWU5MDcxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3Nw
dGUuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuaA0KPiBAQCAtMTQ4LDcgKzE0OCwy
MCBAQCBzdGF0aWNfYXNzZXJ0KE1NSU9fU1BURV9HRU5fTE9XX0JJVFMgPT0gOCAmJiBNTUlPX1NQ
VEVfR0VOX0hJR0hfQklUUyA9PSAxMSk7DQo+ICANCj4gICNkZWZpbmUgTU1JT19TUFRFX0dFTl9N
QVNLCQlHRU5NQVNLX1VMTChNTUlPX1NQVEVfR0VOX0xPV19CSVRTICsgTU1JT19TUFRFX0dFTl9I
SUdIX0JJVFMgLSAxLCAwKQ0KPiAgDQo+ICsvKg0KPiArICogTm9uLXByZXNlbnQgU1BURSB2YWx1
ZSBmb3IgYm90aCBWTVggYW5kIFNWTSBmb3IgVERQIE1NVS4NCj4gKyAqIEZvciBTVk0gTlBULCBm
b3Igbm9uLXByZXNlbnQgc3B0ZSAoYml0IDAgPSAwKSwgb3RoZXIgYml0cyBhcmUgaWdub3JlZC4N
Cj4gKyAqIEZvciBWTVggRVBULCBiaXQgNjMgaXMgaWdub3JlZCBpZiAjVkUgaXMgZGlzYWJsZWQu
IChFUFRfVklPTEFUSU9OX1ZFPTApDQo+ICsgKiAgICAgICAgICAgICAgYml0IDYzIGlzICNWRSBz
dXBwcmVzcyBpZiAjVkUgaXMgZW5hYmxlZC4gKEVQVF9WSU9MQVRJT05fVkU9MSkNCj4gKyAqIEZv
ciBURFg6DQo+ICsgKiAgIFREWCBtb2R1bGUgc2V0cyBFUFRfVklPTEFUSU9OX1ZFIGZvciBTZWN1
cmUtRVBUIGFuZCBjb252ZW50aW9uYWwgRVBUDQo+ICsgKi8NCj4gKyNpZmRlZiBDT05GSUdfWDg2
XzY0DQo+ICsjZGVmaW5lIFNIQURPV19OT05QUkVTRU5UX1ZBTFVFCUJJVF9VTEwoNjMpDQo+ICtz
dGF0aWNfYXNzZXJ0KCEoU0hBRE9XX05PTlBSRVNFTlRfVkFMVUUgJiBTUFRFX01NVV9QUkVTRU5U
X01BU0spKTsNCj4gKyNlbHNlDQo+ICAjZGVmaW5lIFNIQURPV19OT05QUkVTRU5UX1ZBTFVFCTBV
TEwNCj4gKyNlbmRpZg0KPiAgDQo+ICBleHRlcm4gdTY0IF9fcmVhZF9tb3N0bHkgc2hhZG93X2hv
c3Rfd3JpdGFibGVfbWFzazsNCj4gIGV4dGVybiB1NjQgX19yZWFkX21vc3RseSBzaGFkb3dfbW11
X3dyaXRhYmxlX21hc2s7DQo+IEBAIC0xOTUsNyArMjA4LDcgQEAgZXh0ZXJuIHU2NCBfX3JlYWRf
bW9zdGx5IHNoYWRvd19ub25wcmVzZW50X29yX3JzdmRfbWFzazsNCj4gICAqDQo+ICAgKiBPbmx5
IHVzZWQgYnkgdGhlIFREUCBNTVUuDQo+ICAgKi8NCj4gLSNkZWZpbmUgUkVNT1ZFRF9TUFRFCTB4
NWEwVUxMDQo+ICsjZGVmaW5lIFJFTU9WRURfU1BURQkoU0hBRE9XX05PTlBSRVNFTlRfVkFMVUUg
fCAweDVhMFVMTCkNCg0KVGhpcyBjaHVuayBiZWxvbmdzIHRvIHRoZSBwcmV2aW91cyBwYXRjaC4N
Cg0KPiAgDQo+ICAvKiBSZW1vdmVkIFNQVEVzIG11c3Qgbm90IGJlIG1pc2NvbnN0cnVlZCBhcyBz
aGFkb3cgcHJlc2VudCBQVEVzLiAqLw0KPiAgc3RhdGljX2Fzc2VydCghKFJFTU9WRURfU1BURSAm
IFNQVEVfTU1VX1BSRVNFTlRfTUFTSykpOw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21t
dS90ZHBfbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiBpbmRleCA5Y2Y1ODQ0
ZGQzNGEuLjYxMTFlM2U5MjY2ZCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL21tdS90ZHBf
bW11LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMNCj4gQEAgLTcwMCw2ICs3
MDAsMTQgQEAgc3RhdGljIGlubGluZSBpbnQgdGRwX21tdV96YXBfc3B0ZV9hdG9taWMoc3RydWN0
IGt2bSAqa3ZtLA0KPiAgCSAqIG92ZXJ3cml0ZSB0aGUgc3BlY2lhbCByZW1vdmVkIFNQVEUgdmFs
dWUuIE5vIGJvb2trZWVwaW5nIGlzIG5lZWRlZA0KPiAgCSAqIGhlcmUgc2luY2UgdGhlIFNQVEUg
aXMgZ29pbmcgZnJvbSBub24tcHJlc2VudCB0byBub24tcHJlc2VudC4gIFVzZQ0KPiAgCSAqIHRo
ZSByYXcgd3JpdGUgaGVscGVyIHRvIGF2b2lkIGFuIHVubmVjZXNzYXJ5IGNoZWNrIG9uIHZvbGF0
aWxlIGJpdHMuDQo+ICsJICoNCj4gKwkgKiBTZXQgbm9uLXByZXNlbnQgdmFsdWUgdG8gU0hBRE9X
X05PTlBSRVNFTlRfVkFMVUUsIHJhdGhlciB0aGFuIDAuDQo+ICsJICogSXQgaXMgYmVjYXVzZSB3
aGVuIFREWCBpcyBlbmFibGVkLCBURFggbW9kdWxlIGFsd2F5cw0KPiArCSAqIGVuYWJsZXMgIkVQ
VC12aW9sYXRpb24gI1ZFIiwgc28gS1ZNIG5lZWRzIHRvIHNldA0KPiArCSAqICJzdXBwcmVzcyAj
VkUiIGJpdCBpbiBFUFQgdGFibGUgZW50cmllcywgaW4gb3JkZXIgdG8gZ2V0DQo+ICsJICogcmVh
bCBFUFQgdmlvbGF0aW9uLCByYXRoZXIgdGhhbiBURFZNQ0FMTC4gIEtWTSBzZXRzDQo+ICsJICog
U0hBRE9XX05PTlBSRVNFTlRfVkFMVUUgKHdoaWNoIHNldHMgInN1cHByZXNzICNWRSIgYml0KSBz
byBpdA0KPiArCSAqIGNhbiBiZSBzZXQgd2hlbiBFUFQgdGFibGUgZW50cmllcyBhcmUgemFwcGVk
Lg0KPiAgCSAqLw0KPiAgCV9fa3ZtX3RkcF9tbXVfd3JpdGVfc3B0ZShpdGVyLT5zcHRlcCwgU0hB
RE9XX05PTlBSRVNFTlRfVkFMVUUpOw0KPiAgDQoNCkkgZG9uJ3QgcXVpdGUgdGhpbmsgdGhpcyBw
bGFjZSBpcyB0aGUgZ29vZCBwbGFjZSB0byBleHBsYWluICJzdXBwcmVzcyAgI1ZFIiBiaXQNCnN0
YWZmLiAgVGhlcmUgYXJlIG90aGVyIHBsYWNlcyB0aGF0IHNldHMgbm9uLXByZXNlbnQgU1BURSB0
b28uICBQZXJoYXBzIHB1dHRpbmcNCnRoZSBjb21tZW50IGFyb3VuZCB0aGUgbWFjcm8gJ1NIQURP
V19OT05QUkVTRU5UX1ZBTFVFJyBpcyBiZXR0ZXIuDQo=
