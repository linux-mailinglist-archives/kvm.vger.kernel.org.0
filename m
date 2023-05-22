Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C1E70BF49
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 15:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbjEVNLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 09:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbjEVNL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 09:11:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7434AF4;
        Mon, 22 May 2023 06:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684761084; x=1716297084;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oFpCcTZ8Rmp5FpozhWFMJRO4MreiLTcnAGzNt/Pbg3o=;
  b=dw8VTzYPcozMdxZ3oqmPoW/bq7/rumvVNUQzFV7udo3JEZp3IYaURs1F
   iuNS5sgDCMBmjYrePAKj1j2Mj+U7Qa72AiezZiqj6/B38rIuwlX/GdMd2
   F98BHFyJj+OrZt3gWL4t99JrAaJwccFqf+++t3EMDYL07/L0nWzmFMbV3
   mQX4hwrJgUhKugtx8uOeFeW9LfPxLMGgPj4jt1Rqgo9OaVxI3zLurborJ
   pEN2DfvD/1KVzd2GiXlNmhAfgCG8ZNxln/VDx5rsXOIEwizLylyPg//lo
   iia18vTTBmBu0RbZNj7n8AuNgfHbE9WvCAaJogZpWidhRQ9eLhejR6GPw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="337504653"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="337504653"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 06:11:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="950082203"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="950082203"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 22 May 2023 06:11:21 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 06:11:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 06:11:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 06:11:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbWhbid2MtP0TmkQ9Np5ObThNO0vd6Zd+ct3WKI2dOcFnCJlfzCeQbHjwxQ9vOnFjxNil2hQUD/wAHmkUzPJw1xMecXryj3uqx7kGDit0BMf+VhbnTO08THtr4GdVrP2V/GFISZg7+L+9Zaqe5gi6DOD0kW3DOusTWIrYhb1PJETy91kSIkn7fTjEFQ/7+LlF2+FbJzMu2YUpyllMF6ZFB/EsVeduawJrdHngjPNwiUa6ffPyFyFZp5+c9g2LF4OBYSquG0V2gW2DisoklR9sXPg4Ypmae2vxlVYHjKtNVfObVIVrLmFQS9sUwsnq1AbIWb5CokprbwgWIPM9I+nLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFpCcTZ8Rmp5FpozhWFMJRO4MreiLTcnAGzNt/Pbg3o=;
 b=dACBRIskUbQDMd6e55hrCB/LrHkogqkUQCWqrQubAvxMPmxigm2lr9lPuaQWa9eHl26yGwvx0WYJLceFoeuEliuQkx6qOGUPdTJmTT1l5tAbMV4uw7wqvMFxYUdiaPJHKkJM/ih9MzcRYpm0FRKipdvMXb30tMzZbdmWf5KpnMFOXpVgUSC31DpqzdXvnT8GIN4g/aaNKN3ZLBdFys41u9Gxn3weL8z5ZEtQTHCY2Z6CfhbnHNGN+9y5jpQlec/zx35mYqdadoTidvcpCH/Je14EwE3KfgYgJDmbFd2dxo8A4/BeahFLSzA1SwBkal5hpWiyCgpe7lVjXQfgwisbUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6401.namprd11.prod.outlook.com (2603:10b6:510:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 13:11:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:11:17 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 07/18] x86/reboot: Hoist "disable virt" helpers above
 "emergency reboot" path
Thread-Topic: [PATCH v3 07/18] x86/reboot: Hoist "disable virt" helpers above
 "emergency reboot" path
Thread-Index: AQHZhSyYk003aDd4VE6pDcma0HZOYK9mU2wA
Date:   Mon, 22 May 2023 13:11:16 +0000
Message-ID: <26f9525ca5ade60e352f280ac4723354b45ac1a2.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-8-seanjc@google.com>
In-Reply-To: <20230512235026.808058-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6401:EE_
x-ms-office365-filtering-correlation-id: 71e3dcc2-1c29-4671-753c-08db5ac606fe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CHFkxPJnwpmwOZRa9YNM1fofEqV97UGfFS36S/9fRvC+/SjF8hqdjqzlE8TBJeNmDe/SePrfwdHuWP6/iq6tb/LeGDCZSYrFpfOmGiMSvkFhM6NdjBgGU7GmZrcBegbLYt6EEjr7Y1PfoqpYicp40+2c82vZ390qVAdTj5kdr7ye4NaC/dPKMAGTFldlCU2TG1IhY10QrL2TNsaT7L4utQaC7KXGZrkFPg6Ii2YzxUl55ZqwYLgRIJsirw1MQBkvnBml4Hdwru0G/2f0dmV8SliMSAowQWYPVnZh0j9C0MZ3hTAwYy6cnTWL7aXlydqVDSGXaj4yY3oJ/hwaX428ueNZJ7ehc7vqZ2lo3Stl/odWhxfpPkvaPaf8P4TMRMq9JhyfJKwpVZtkEA+WNZdNRzHBtWh4byTmzEuVQvlhoEP9XbpDm+v3Tw55vLkUa4lZToZL7D3Rgo6dzg+pRFIJDsaYrlxTQO7mHT1GGBRdnj9lJ2+4OiYxinWHuN7yKATVJ8aaTfi0h6f7ZU3YIBLFJmMz4QCMWdCv7xdDOfoWfSS6G/Shesz+EhJmSZM8X7VCKZKYcx0/pP0hnIFReYWAq24KFdv4ORJFrS7i/zi36j+rlhSeNl7EJeAEwWvaHDwo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(2906002)(5660300002)(83380400001)(8676002)(8936002)(41300700001)(66946007)(76116006)(66476007)(4326008)(91956017)(66556008)(64756008)(66446008)(54906003)(316002)(36756003)(110136005)(71200400001)(6486002)(478600001)(2616005)(6512007)(6506007)(26005)(122000001)(86362001)(82960400001)(186003)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkxUemN0cWd6alVYMnd3VzdwLzhOOWpkdngrWWRNdENqbEw0REZNSU1uS0NB?=
 =?utf-8?B?Yys4ejk0ZzUzeCtFN3BCckE1TzFLaXhObmhkQnlCSnBBU3p6cXZzeVVjUEE2?=
 =?utf-8?B?MzRScFpWcDc5OVJ0dkdBYThlWGttdHRVc3I2aTN5ODlOd0JuTzhJMGFIWmFI?=
 =?utf-8?B?a3RhMFdmZk42WnpqNkdEUlFyRDdHYUx6R2k3WDgwN0xKSnhoYmYxeTVyM2c4?=
 =?utf-8?B?SzYycGQ3ZzR4Nlk4VnZxc09qRFdMNVVqQ0NGUVVsUStMSFFOMzhvVS9YMGxS?=
 =?utf-8?B?TEY1NDJEaUdqVk9qQzBNQVlwMnRvNTQzTHBNR01hNUZQdHFic3BwOUt3RzMr?=
 =?utf-8?B?SkxHR2hnZC9pMnBxUjAzem9mRzRzZGNaNVJzVzRnVStsdE9Xd0hQWVdrVUVk?=
 =?utf-8?B?SUhHcVBwV3B6SVRJYVYzQmRZenAvOFZCZWRFVkl2QnVwK1pHL1hkcE9MWERj?=
 =?utf-8?B?L1NyVnZvSXl0T0ZIRU51QXRaTmxLY0pHKysrTDlxSXNJRXo5emd6U1Y3U0pZ?=
 =?utf-8?B?U2lWblFweUs4NHpFWXpBWTVETDhUVmJDbEFpMHQyTHJkc0o5S0x1ZTQzZUM0?=
 =?utf-8?B?azFPM1Z4a2JrKytvN0wvVkUxdndYWDQ0VVpoUWJoNmtBSzNBdEZTYzFLMU16?=
 =?utf-8?B?WlAwNXBQU0NHZTQrZktPbVRKNzhKSEN5VTh3ZnM1MVd5R2JRWlFKSm1hYmt1?=
 =?utf-8?B?T0c4ZERmQ1ZEYzArTnhRaGtTM0FaMU0wVHBUVFprVzh0b3JyaTlMc0RqaCtW?=
 =?utf-8?B?SjlYUDhwM3NrdHJxemZqWVg4SGtHSGt0RWRGMzQ5N2l0Y3RkM1k1aWxNL3kx?=
 =?utf-8?B?RFVzczBhUkpUeW9mMGdTWVJkdy9LaGoxcVg5R1RFNi9BUEZNa1JxSXlHT0lw?=
 =?utf-8?B?amhEdHFBRStRK0ZzMjg3MWs0bDBNcCtEMmRBMklzcERRK3dwL0tIRlQxYXZy?=
 =?utf-8?B?OG9jOG1IMG5VWjhGMXV1TDFsa2dGWkI3dnlENitNZ241K09sbFpzTVh0ZmdY?=
 =?utf-8?B?UlVLZk1JZEQ3YXpBSndlK2I1cThna1U4cG1JSTI3ZzlaRlRHZVNYQmxHNDly?=
 =?utf-8?B?djVEVldJSjhJd012ajNBOC9JQXNkdlZ5d2wvYjJINklDLzZBOExOWEQvV1pP?=
 =?utf-8?B?VFluSnJvYUpXUmVPdldWa0xGaWd2TElKdW9hSFI2MVRvWDRETzhwbzh0amtH?=
 =?utf-8?B?Qmd0aEg4bEZYdU9zWU13T0Q0SnhTencrMHVnMVVhUzlvSVV3R0VyckF4ZTFM?=
 =?utf-8?B?cGY3dFdYazlhZUt3R0xUbWdXR0FMTStxZVhWY0o0RVZQbnBoU2w0Z0VESXhT?=
 =?utf-8?B?UjlXT1NOYU1CM1d0aTdRSXNiOEo3dkFNL09yUHFmYnZyaTMzY0p0enVMU1Ns?=
 =?utf-8?B?UFBLQnpPeDA1aDJRbDljVzFkbUVPNjRtb29QNzhWNWNYbHRrZjZaR1FzVkhr?=
 =?utf-8?B?dFhqMTZ1VVRodUpVVnkzdXUzdHVkMkFhNUo0YjJ4MUYxQlhqemRaalFqZUdm?=
 =?utf-8?B?aGcreFRQcDhiQzFnbEVBWHlQUmliSnMvWjVobmpuem9Bd3N4dFZjRHdVTDFl?=
 =?utf-8?B?blpaQzRNY0dDMG40YlZrOSsycy9yUGhmZGRvdlVEUFBOMWp2ZkgvQTNnSFhR?=
 =?utf-8?B?RVliUFZoNFRqTEtHMHlzUkZ5eER4aTEwdVVrOFBZVnpNeGIxQTR6VkxiSlVv?=
 =?utf-8?B?amVSVWg2dWZoRko4cnRxNTRBUjk2blJxa1IrbFNndERHZEp0THVjL1dsWGZ0?=
 =?utf-8?B?Z1pGb01Id3B6L2MwSHNYbUI4YjA4YSt4Z3p3aWdWUkl3QjBOYUt2RzRvbEMr?=
 =?utf-8?B?c3FUTkFxYi9jNWd1SjRteG1PME9vN2dBREIzSVgvUnc4ZTRpTEtvVytrYmlN?=
 =?utf-8?B?NFVON0xNaW56S2lWL2llelppTldzSlZ4T011SHZRTk5kN01GaC9aZ1p3eWVa?=
 =?utf-8?B?UUtlRHF5VDFHS2k4MWEyMjFFRll3WThOQWdBcFRVM2lBamlOcEk1VkZNU0JB?=
 =?utf-8?B?bEZCQ1N5SU9hQWNiR3lQb0tjeUhiNW9EMW5jdnVxYkZLMElkNkFINytBZm8v?=
 =?utf-8?B?clNYaytRYlBFRHljUzRZWEMzcDBSMk9zbkdINENWaWFOQU5KNTB1N3N4T2hU?=
 =?utf-8?B?ellLWWorZCs5N2ZIMTdSazFySU5yNEsrbTkxSEQ3QTlrbWUwdHdZNDJCT2Nh?=
 =?utf-8?B?QVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6710A1A0A58C324CB6A16308676342E1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e3dcc2-1c29-4671-753c-08db5ac606fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 13:11:16.9855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dmXdVb7vuw/CZKJbAjDgTcfua7X1ZwpxMumh3rK24hTvGzu+h9IMAeDiBTS/vXR5Lmrv+E8qgRe4ZnN/vC3bmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6401
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIHRoZSB2YXJpb3VzICJkaXNhYmxlIHZpcnR1YWxpemF0aW9uIiBoZWxwZXJz
IGFib3ZlIHRoZSBlbWVyZ2VuY3kNCj4gcmVib290IHBhdGggc28gdGhhdCBlbWVyZ2VuY3lfcmVi
b290X2Rpc2FibGVfdmlydHVhbGl6YXRpb24oKSBjYW4gYmUNCj4gc3R1YmJlZCBvdXQgaW4gYSBm
dXR1cmUgcGF0Y2ggaWYgbmVpdGhlciBLVk1fSU5URUwgbm9yIEtWTV9BTUQgaXMgZW5hYmxlZCwN
Cj4gaS5lLiBpZiB0aGVyZSBpcyBubyBpbi10cmVlIHVzZXIgb2YgQ1BVIHZpcnR1YWxpemF0aW9u
Lg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KUGVyc29uYWxs
eSBJIHRoaW5rIHRoaXMgcGF0Y2ggY2FuIGJlIG1lcmdlZCB0byBuZXh0IG9uZS4gIERvaW5nIHNv
IG1heSBhbHNvDQpyZXN1bHQgaW4gYSBtb3JlIHJlYWRhYmxlIHBhdGNoIGJ1dCBJIGFtIG5vdCBz
dXJlLg0KDQpBbnl3YXksDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQoNCj4gLS0tDQo+ICBhcmNoL3g4Ni9rZXJuZWwvcmVib290LmMgfCA5MCArKysrKysr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNDUg
aW5zZXJ0aW9ucygrKSwgNDUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva2VybmVsL3JlYm9vdC5jIGIvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+IGluZGV4IGZk
ZGZlYTVmMWQyMC4uNDkzZDY2ZTU5YTRmIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwv
cmVib290LmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+IEBAIC01MjksNiAr
NTI5LDUxIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBrYl93YWl0KHZvaWQpDQo+ICANCj4gIHN0YXRp
YyBpbmxpbmUgdm9pZCBubWlfc2hvb3Rkb3duX2NwdXNfb25fcmVzdGFydCh2b2lkKTsNCj4gIA0K
PiArLyogUkNVLXByb3RlY3RlZCBjYWxsYmFjayB0byBkaXNhYmxlIHZpcnR1YWxpemF0aW9uIHBy
aW9yIHRvIHJlYm9vdC4gKi8NCj4gK3N0YXRpYyBjcHVfZW1lcmdlbmN5X3ZpcnRfY2IgX19yY3Ug
KmNwdV9lbWVyZ2VuY3lfdmlydF9jYWxsYmFjazsNCj4gKw0KPiArdm9pZCBjcHVfZW1lcmdlbmN5
X3JlZ2lzdGVyX3ZpcnRfY2FsbGJhY2soY3B1X2VtZXJnZW5jeV92aXJ0X2NiICpjYWxsYmFjaykN
Cj4gK3sNCj4gKwlpZiAoV0FSTl9PTl9PTkNFKHJjdV9hY2Nlc3NfcG9pbnRlcihjcHVfZW1lcmdl
bmN5X3ZpcnRfY2FsbGJhY2spKSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJcmN1X2Fzc2lnbl9w
b2ludGVyKGNwdV9lbWVyZ2VuY3lfdmlydF9jYWxsYmFjaywgY2FsbGJhY2spOw0KPiArfQ0KPiAr
RVhQT1JUX1NZTUJPTF9HUEwoY3B1X2VtZXJnZW5jeV9yZWdpc3Rlcl92aXJ0X2NhbGxiYWNrKTsN
Cj4gKw0KPiArdm9pZCBjcHVfZW1lcmdlbmN5X3VucmVnaXN0ZXJfdmlydF9jYWxsYmFjayhjcHVf
ZW1lcmdlbmN5X3ZpcnRfY2IgKmNhbGxiYWNrKQ0KPiArew0KPiArCWlmIChXQVJOX09OX09OQ0Uo
cmN1X2FjY2Vzc19wb2ludGVyKGNwdV9lbWVyZ2VuY3lfdmlydF9jYWxsYmFjaykgIT0gY2FsbGJh
Y2spKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwlyY3VfYXNzaWduX3BvaW50ZXIoY3B1X2VtZXJn
ZW5jeV92aXJ0X2NhbGxiYWNrLCBOVUxMKTsNCj4gKwlzeW5jaHJvbml6ZV9yY3UoKTsNCj4gK30N
Cj4gK0VYUE9SVF9TWU1CT0xfR1BMKGNwdV9lbWVyZ2VuY3lfdW5yZWdpc3Rlcl92aXJ0X2NhbGxi
YWNrKTsNCj4gKw0KPiArLyoNCj4gKyAqIERpc2FibGUgdmlydHVhbGl6YXRpb24sIGkuZS4gVk1Y
IG9yIFNWTSwgdG8gZW5zdXJlIElOSVQgaXMgcmVjb2duaXplZCBkdXJpbmcNCj4gKyAqIHJlYm9v
dC4gIFZNWCBibG9ja3MgSU5JVCBpZiB0aGUgQ1BVIGlzIHBvc3QtVk1YT04sIGFuZCBTVk0gYmxv
Y2tzIElOSVQgaWYNCj4gKyAqIEdJRj0wLCBpLmUuIGlmIHRoZSBjcmFzaCBvY2N1cnJlZCBiZXR3
ZWVuIENMR0kgYW5kIFNUR0kuDQo+ICsgKi8NCj4gK3ZvaWQgY3B1X2VtZXJnZW5jeV9kaXNhYmxl
X3ZpcnR1YWxpemF0aW9uKHZvaWQpDQo+ICt7DQo+ICsJY3B1X2VtZXJnZW5jeV92aXJ0X2NiICpj
YWxsYmFjazsNCj4gKw0KPiArCS8qDQo+ICsJICogSVJRcyBtdXN0IGJlIGRpc2FibGVkIGFzIEtW
TSBlbmFibGVzIHZpcnR1YWxpemF0aW9uIGluIGhhcmR3YXJlIHZpYQ0KPiArCSAqIGZ1bmN0aW9u
IGNhbGwgSVBJcywgaS5lLiBJUlFzIG5lZWQgdG8gYmUgZGlzYWJsZWQgdG8gZ3VhcmFudGVlDQo+
ICsJICogdmlydHVhbGl6YXRpb24gc3RheXMgZGlzYWJsZWQuDQo+ICsJICovDQo+ICsJbG9ja2Rl
cF9hc3NlcnRfaXJxc19kaXNhYmxlZCgpOw0KPiArDQo+ICsJcmN1X3JlYWRfbG9jaygpOw0KPiAr
CWNhbGxiYWNrID0gcmN1X2RlcmVmZXJlbmNlKGNwdV9lbWVyZ2VuY3lfdmlydF9jYWxsYmFjayk7
DQo+ICsJaWYgKGNhbGxiYWNrKQ0KPiArCQljYWxsYmFjaygpOw0KPiArCXJjdV9yZWFkX3VubG9j
aygpOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgdm9pZCBlbWVyZ2VuY3lfcmVib290X2Rpc2FibGVf
dmlydHVhbGl6YXRpb24odm9pZCkNCj4gIHsNCj4gIAlsb2NhbF9pcnFfZGlzYWJsZSgpOw0KPiBA
QCAtNzg1LDU0ICs4MzAsOSBAQCB2b2lkIG1hY2hpbmVfY3Jhc2hfc2h1dGRvd24oc3RydWN0IHB0
X3JlZ3MgKnJlZ3MpDQo+ICB9DQo+ICAjZW5kaWYNCj4gIA0KPiAtLyogUkNVLXByb3RlY3RlZCBj
YWxsYmFjayB0byBkaXNhYmxlIHZpcnR1YWxpemF0aW9uIHByaW9yIHRvIHJlYm9vdC4gKi8NCj4g
LXN0YXRpYyBjcHVfZW1lcmdlbmN5X3ZpcnRfY2IgX19yY3UgKmNwdV9lbWVyZ2VuY3lfdmlydF9j
YWxsYmFjazsNCj4gLQ0KPiAtdm9pZCBjcHVfZW1lcmdlbmN5X3JlZ2lzdGVyX3ZpcnRfY2FsbGJh
Y2soY3B1X2VtZXJnZW5jeV92aXJ0X2NiICpjYWxsYmFjaykNCj4gLXsNCj4gLQlpZiAoV0FSTl9P
Tl9PTkNFKHJjdV9hY2Nlc3NfcG9pbnRlcihjcHVfZW1lcmdlbmN5X3ZpcnRfY2FsbGJhY2spKSkN
Cj4gLQkJcmV0dXJuOw0KPiAtDQo+IC0JcmN1X2Fzc2lnbl9wb2ludGVyKGNwdV9lbWVyZ2VuY3lf
dmlydF9jYWxsYmFjaywgY2FsbGJhY2spOw0KPiAtfQ0KPiAtRVhQT1JUX1NZTUJPTF9HUEwoY3B1
X2VtZXJnZW5jeV9yZWdpc3Rlcl92aXJ0X2NhbGxiYWNrKTsNCj4gLQ0KPiAtdm9pZCBjcHVfZW1l
cmdlbmN5X3VucmVnaXN0ZXJfdmlydF9jYWxsYmFjayhjcHVfZW1lcmdlbmN5X3ZpcnRfY2IgKmNh
bGxiYWNrKQ0KPiAtew0KPiAtCWlmIChXQVJOX09OX09OQ0UocmN1X2FjY2Vzc19wb2ludGVyKGNw
dV9lbWVyZ2VuY3lfdmlydF9jYWxsYmFjaykgIT0gY2FsbGJhY2spKQ0KPiAtCQlyZXR1cm47DQo+
IC0NCj4gLQlyY3VfYXNzaWduX3BvaW50ZXIoY3B1X2VtZXJnZW5jeV92aXJ0X2NhbGxiYWNrLCBO
VUxMKTsNCj4gLQlzeW5jaHJvbml6ZV9yY3UoKTsNCj4gLX0NCj4gLUVYUE9SVF9TWU1CT0xfR1BM
KGNwdV9lbWVyZ2VuY3lfdW5yZWdpc3Rlcl92aXJ0X2NhbGxiYWNrKTsNCj4gLQ0KPiAgLyogVGhp
cyBpcyB0aGUgQ1BVIHBlcmZvcm1pbmcgdGhlIGVtZXJnZW5jeSBzaHV0ZG93biB3b3JrLiAqLw0K
PiAgaW50IGNyYXNoaW5nX2NwdSA9IC0xOw0KPiAgDQo+IC0vKg0KPiAtICogRGlzYWJsZSB2aXJ0
dWFsaXphdGlvbiwgaS5lLiBWTVggb3IgU1ZNLCB0byBlbnN1cmUgSU5JVCBpcyByZWNvZ25pemVk
IGR1cmluZw0KPiAtICogcmVib290LiAgVk1YIGJsb2NrcyBJTklUIGlmIHRoZSBDUFUgaXMgcG9z
dC1WTVhPTiwgYW5kIFNWTSBibG9ja3MgSU5JVCBpZg0KPiAtICogR0lGPTAsIGkuZS4gaWYgdGhl
IGNyYXNoIG9jY3VycmVkIGJldHdlZW4gQ0xHSSBhbmQgU1RHSS4NCj4gLSAqLw0KPiAtdm9pZCBj
cHVfZW1lcmdlbmN5X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCkNCj4gLXsNCj4gLQljcHVf
ZW1lcmdlbmN5X3ZpcnRfY2IgKmNhbGxiYWNrOw0KPiAtDQo+IC0JLyoNCj4gLQkgKiBJUlFzIG11
c3QgYmUgZGlzYWJsZWQgYXMgS1ZNIGVuYWJsZXMgdmlydHVhbGl6YXRpb24gaW4gaGFyZHdhcmUg
dmlhDQo+IC0JICogZnVuY3Rpb24gY2FsbCBJUElzLCBpLmUuIElSUXMgbmVlZCB0byBiZSBkaXNh
YmxlZCB0byBndWFyYW50ZWUNCj4gLQkgKiB2aXJ0dWFsaXphdGlvbiBzdGF5cyBkaXNhYmxlZC4N
Cj4gLQkgKi8NCj4gLQlsb2NrZGVwX2Fzc2VydF9pcnFzX2Rpc2FibGVkKCk7DQo+IC0NCj4gLQly
Y3VfcmVhZF9sb2NrKCk7DQo+IC0JY2FsbGJhY2sgPSByY3VfZGVyZWZlcmVuY2UoY3B1X2VtZXJn
ZW5jeV92aXJ0X2NhbGxiYWNrKTsNCj4gLQlpZiAoY2FsbGJhY2spDQo+IC0JCWNhbGxiYWNrKCk7
DQo+IC0JcmN1X3JlYWRfdW5sb2NrKCk7DQo+IC19DQo+IC0NCj4gICNpZiBkZWZpbmVkKENPTkZJ
R19TTVApDQo+ICANCj4gIHN0YXRpYyBubWlfc2hvb3Rkb3duX2NiIHNob290ZG93bl9jYWxsYmFj
azsNCj4gLS0gDQo+IDIuNDAuMS42MDYuZ2E0YjFiMTI4ZDYtZ29vZw0KPiANCg0K
