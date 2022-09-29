Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D535EEB53
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 03:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiI2B4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 21:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiI2B4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 21:56:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C617AD9
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 18:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664416598; x=1695952598;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pob95SoRNOeSYEdQ9nGbYhK3E991a9H79/1sKkXS6+I=;
  b=Ds/NiyFXElCfjBKyA7DYsnLc9U++THz9AgzPgCn4w8l1TizswnOICxEf
   jnN8GROOjd8RSxi1Ic5Rwd5A0BA0dQ77jBnrjg0l0dfp0HJIQlhPdPVSI
   zUiiDSjtfDP0uxHgDAdlfcrpsP9bwU8DwP8uxKKm138+1oArvTd55i4M9
   UX9wZ96cUXAu/H3uSacXHKxAIDP40AYJ3LnztX1Ytb90zssXXN1v5l+uj
   1uyfFhhMFjwV3CGZlmqbm5AsA36P1tydyokQcAZbpV7oHziiXYt9naYem
   nGQ3fmQPZJvhEjSCQnQ39b+8uXkI3ppNf1Q8tyEEz6zy79xVGm1jmcQhM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="328138860"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="328138860"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:56:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="797372467"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="797372467"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 28 Sep 2022 18:56:37 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 18:56:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 18:56:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 18:56:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2U+XmsBGRMwCq0kIT5IGUYFE9rTMlUvLxV01Kp8YQu6k/ZAyAFP79jRLbEmdhPpnATV1xoEzhAUUmfWP4FlG6VuZxoYwkGMtk0yTlkSbbmCmI2PvTYlaKSU2SJglLUbIiikyTJbkn0kGZeRUuBqBSQgQHY4mNRqHdC6DLMFTV7XxGaEi4ZlKfeA/H9oxa8/1HkSFK8vUod6AMcCRRVHZUMQuEAKj1KWpQvEVqIUGO++X1lE7Liukiv20QKIw5leGGoaBfsiRTM1BFJcuvkksYBvk1CZGwaArHzHfP+BBd/ldmwCWbg59HTnDYA7gsOfhpCbNLbwcojQEzLOjkIlcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pob95SoRNOeSYEdQ9nGbYhK3E991a9H79/1sKkXS6+I=;
 b=GZeuYCJopaj0swfVZoN06qLzn8jqOlO3j6QqagkeDbMAxidhHtz/xJwUiPATx6JGd6YGa/HWr7P2/efTAWqXdqVY0YF4/XoZRDIx62FlbkR1bpcdMPh64Xd38JW5dXtu2gAv0sDlIj4r54BzaDsyp/FTIVU6s1hxo6+/uoKBa16sX7lNUv4HEVcZRlhQtx+H4lSc2mZcPMHJipesHEcUJryUuzY2uR6LFSe/q/UpR+oaTxJb/H1GG9WXj3W20+gvR7EYcChLPeIKoPb6q5cXYyKcFaF+9PROXNYf2e25y5BNVQtNA5eKATXyaL2r2FYF7R8wdN9KX1mxH89AuWYNSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6293.namprd11.prod.outlook.com (2603:10b6:8:97::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Thu, 29 Sep
 2022 01:56:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 01:56:35 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "dmatlack@google.com" <dmatlack@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Topic: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Thread-Index: AQHYzeClAoVSdFoVkE6IUn79IeyfMa3zCMQAgABz3YCAAFLRAIAB4jQA
Date:   Thu, 29 Sep 2022 01:56:35 +0000
Message-ID: <303a851067a04de2d78e3c52cde7055a53c39da3.camel@intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
         <20220921173546.2674386-2-dmatlack@google.com>
         <1c5a14aa61d31178071565896c4f394018e83aaa.camel@intel.com>
         <CALzav=d1wheG3bCKvjZ--HRipaehtaGPqJsDz031aohFjpcmjA@mail.gmail.com>
         <fde43a93b5139137c4783d1efe03a1c50311abc1.camel@intel.com>
In-Reply-To: <fde43a93b5139137c4783d1efe03a1c50311abc1.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6293:EE_
x-ms-office365-filtering-correlation-id: ddfde401-c313-45ba-fdd4-08daa1bdd6e9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XOghY5tOt8srbCKGHs06Atqu6ZzngALIlzPyUgMOch52k19uZ7/oDOgU4Vr4cnMzFGgF/76WHpGyU3553ceDQb2ifF93atm/YMueqp3aZOitzIJUO8ZgKkac77AfnFBUaCG2SxqNddUQPrD0EYOSMLrMFmTBWzLjoArRV1roLjU/Pom0GQ7NUktVGT+uw7CJZwkW/CWuFJ/s8G1J1+9hD8V/OSt5R1p0BQeDilU7qfIxhN8wGve4bhaHI6HjP9vqAmoSdqLshvCSJs/3Ro4/jXW89u99zwQk1KG1gz8qBSgZvKNxgQAvcYBXiKVEZLH5PeVDUGE7Q7h4h3uyzJ3ddnnaEB5qNyVqgOifoJD0RJHrL0kFqbwND0lZSfScgF2dU+r3swNkptlLdNX4AHbQz7XEOE5Wkwgz08ql2bL66IIQHj2B/oz+9GKBGT+3LM2MqtPcW1ViuLiRv2Mtsj1JXk5yvMiXXHiQuuu1ukbIW3UKJDr5ACU93AonrGLVmF60ypzO+/XeM7tsAVvZXNTlN6d340gHHjTHvI4zNwHunSNBSzKMuBgvproGLV+W8MnziS7tuPMq2Df175+utLYq5+9JvDWGQWFeLMfoT3xhjuY5NnGfjokq19pv2qyO84LMud3l0DYQTQy+8cwrHfO0LjnqcZvLyI8YqF/5/ZQEmpASCRcHwrgYxrS2AfORnHkKLtObUMqZ/Jfx9NEbNWNb5P1GRUjRTTbiqHK85nEDH1ve6JsHU4v9uJMIJLIgi1nEVXVnK8RA2H5T2v8O5AvR4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(366004)(376002)(346002)(451199015)(316002)(6512007)(53546011)(54906003)(6916009)(186003)(86362001)(26005)(5660300002)(66946007)(2906002)(76116006)(8936002)(8676002)(4326008)(66556008)(66446008)(91956017)(66476007)(2616005)(41300700001)(36756003)(558084003)(64756008)(122000001)(71200400001)(6486002)(6506007)(82960400001)(38070700005)(478600001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3dEZk53cDNlTkhpaXJHTVhuTExFNkRDaVl4RTlhSjZrNnluZ3JmaUtZTXEr?=
 =?utf-8?B?T25pcytVRnpLVkp6WUVoL0gyM3p0RFpZTmVQWlJaYll0eFlYSkYyQnFDODVv?=
 =?utf-8?B?WDJ3eGl3cXFiL3RGUU5pNUwvVVdnbkNqRTlOSWpLVTc3L1djc21PQStEK3BS?=
 =?utf-8?B?NXJZcXFVRDRkTkI5dTBrSWZMWitTOTdOdVJBR2JZMCtSVWxsR1FQckZOSzlB?=
 =?utf-8?B?Qm9FclpoQlg1WS9ML3F2ZDM3aUFKbHRoUGtyS3dPY0pVbmo1UEhTQktGOUt4?=
 =?utf-8?B?NjFibDdFU2FZSEpnY2FiYzNnL2l3R3puSWpkSVFTd3l0eG0xQ1pvaFY0bllu?=
 =?utf-8?B?Qk91UXI4bXhRaFNlVmlGem5HL1NaeXBqRVFxaTAzcUNYYU5kcE8wTWhZVUpo?=
 =?utf-8?B?N3FwbkV1Rmw4b1lmaXVhSWVHTjBqRzBQdHhNeG9qOTVDQ3BpRSt3dDlqRW0z?=
 =?utf-8?B?Q2l3RXh2SG5HaUMxcGhSRXJKYVQ4L2F5ZUUzaHZvdmh3VFNwdTJpNGxzYmp0?=
 =?utf-8?B?Qkp6UE94c2N2VU5hSkpXK2crQWgxQVlPekMwcmRjekJWdnVoNlJ3SWFlYjBx?=
 =?utf-8?B?RmowUXcwV3JQMjVTSTJDa2xTTTJDRDQ5dEpZSVFBMTIvU2dEdWR3cnZEMGhr?=
 =?utf-8?B?c25RbWtQaWY3bHNRdkZ6UEp3T3RjeHluZ29mbi9OWHJJSjhVSWVUcDNpcTI4?=
 =?utf-8?B?NHdvTnJhUjJIMlNMNWNaVnlsQzZ0WGhWM3dWVVdqOE00TXVicXpTaGF5V1Vr?=
 =?utf-8?B?d25lek5xVHdmZFBXY1NadHIvTndRNnMxcitRUnVXc2ZVY3NlYkZlZGk5WEtN?=
 =?utf-8?B?SHJhRWpUMXNzR3prUzV0REFvVXcrME9JZVJvYW9iRVI2MFpjQ2ZLWlpGWTdn?=
 =?utf-8?B?djUxZG1UM3pmZjBRUnBXVjNMRnZLT3F6TjEvV1AzV0Jza05oNUlBMTVUSU9C?=
 =?utf-8?B?cFpzVWpyNW8rbFpJaGRua2VaOXdRM2FZeXc1M2JsVWR2Qm05cWdHbjE2T1RG?=
 =?utf-8?B?cytZSDAwQVJCT3VBUllKR01DMVJjNEIxWXcrY0s2cWgrWEwvV20zMEx4aXpD?=
 =?utf-8?B?MWZEclYwYTluRnVEWHEvM0VoSmRnSUpTWmFJaWJqM0ZGUk5jeC9adGg3MlFW?=
 =?utf-8?B?VzluckF1VXpuSVZXb2N1UStTZTZQMVlNczIvVGVWOVFIakl6U0o3bWJIVFNj?=
 =?utf-8?B?aFI2MHZJTThkZ2pYZTRVSkNsbjd6WTJFb1J6b0JKd21XYXo4OXRXWVY4cWc0?=
 =?utf-8?B?Y1orSjVPa1FxcTFxdnFTUHc1YVMxcGNlVVZWb2V2ZG03ZmNFQlhoQzNKbjRk?=
 =?utf-8?B?RzVrYjBEOTc2Vm1zTm1mS2VjQ1ExNWoxajJQclFkbHVzdzYzamJ0MjhSMkpy?=
 =?utf-8?B?QTBwb203Mks0a3JUWTZDSmpEanNEK1llNmYwNkZOOGt6UlNhTTFZckJMeVZ3?=
 =?utf-8?B?dUNKcDQ0ejgvNkNGSFhMVWhIeVY3cHJIcS9aVmh2MGhMNUhJVE16SEYrTDI0?=
 =?utf-8?B?K0x6UHZ6dVFCSzlaRlZkaVg5YURnbzI0ckM1MzBvVUxHclVXblJYTTVEUTc4?=
 =?utf-8?B?US8yazVRMnBBYVJMdDlSMzkwdUFxT2h2RGxyOFpwdVdxL3NkdFUxMmlVTjRH?=
 =?utf-8?B?UDF3dWEvNFBKMjVYOWFsUEt5VVN2a0xVUHZEbFA5bFMwcUtiKzgrd0tjKzZq?=
 =?utf-8?B?WDc3WDZzMUExZmR1dlRsWkdyRmIxT2wvWkhoekUxN1htakprWUVBUFZ5cU4y?=
 =?utf-8?B?Y3B2a0lieklHVXZ1eUh2YWtMTmsxVlJndVF5WmRKN0Uwb1hlb1JIZ0NtSDhQ?=
 =?utf-8?B?emdJTmpLdGhaQUJYYXgxTTRsYkUyTHlCM2tPQXZ5UmVGQ2VIU29oWnBoeEI3?=
 =?utf-8?B?ZHFBemM3aHovM2FDVS8xTUNBVHNpQ1AycGZGdUZHdkhENEpBamNHcDFQRmF5?=
 =?utf-8?B?VFZGNkc4bTlybVdJeEd1WS9WRm8wSnZTeXJvR2o2d2NrM244eDdRUEh6UEdp?=
 =?utf-8?B?Q081SEtsVlJLb0pIaXlPR0Vldy9VTWZPRllFMGtrQURFY2dOcjgwankrcG8y?=
 =?utf-8?B?QXc2U2ZLNVBsdUJ3cHJjbzgxUVg1Y2ZlYVZkd1RlYXlkNDFiWDVzN3VxeFk0?=
 =?utf-8?B?NUtadW0rNGRxQ0QrbWltUFJ1Z2RZZ01yUHhKTDIvbUxIWTZNcUJ4Z0F4NlpQ?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9D84EF5A004A742BD731F7757FC384E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddfde401-c313-45ba-fdd4-08daa1bdd6e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 01:56:35.2271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c3vVN+uGEKJNDHH2jBywsg8VmI+LwKuZmggneET1dFfZiubb54hJNTwudhdKefBfbkX2FSyJw2yK23erizNZ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6293
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTA5LTI3IGF0IDIxOjEwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUdWUsIDIwMjItMDktMjcgYXQgMDk6MTQgLTA3MDAsIERhdmlkIE1hdGxhY2sgd3JvdGU6DQo+
ID4gT24gVHVlLCBTZXAgMjcsIDIwMjIgYXQgMjoxOSBBTSBIdWFuZywgS2FpIDxrYWkuaHVhbmdA
aW50ZWwuY29tPiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiArYm9v
bCBfX3JvX2FmdGVyX2luaXQgdGRwX21tdV9hbGxvd2VkOw0KPiA+ID4gPiArDQoNCk5pdDogaXQg
YXBwZWFycyB0aGlzIGNhbiBiZSBzdGF0aWMuDQoNCi0tIA0KVGhhbmtzLA0KLUthaQ0KDQoNCg==
