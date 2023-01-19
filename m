Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED27674399
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjASUlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjASUkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:40:52 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AF180178;
        Thu, 19 Jan 2023 12:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674160844; x=1705696844;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A7K1L/7Icc7pcOCzBfiLvj9IVrPgzUAitS2YoK2kyy0=;
  b=lvIkZ10T6aMaBAVVivNN063nS9BnbRSYpewNhFsZrOl0Kgi7fIHERiFu
   tarUv7ta4dJa+mi7EeNno9vsDHMVRLOKZUdUAThbYydMvmEu7UnJ9cIcv
   Z7Q1whKazlD4AespO6CH3biCmf3JqvDuLEJ42KTaif1A243YY3O/HOz2n
   0rpiM16j/1RT3Vdux0KGdaK9YkOPTJENzhgIxg96xP+rwDoQS5PvIyJRJ
   YDLQIT8Wjn/rAHqAkQMxzk4tybdjOeNuAmIT2qtMZwO9cYcIjTrT8cyJ3
   agYUraE4VlqwVD5XwtoJ2WnmyF6KrPsdu4LtiGu3KDrUlYCkcMQ9TtlGz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305089967"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="305089967"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 12:40:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="768374535"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="768374535"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 12:40:44 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 12:40:43 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 12:40:43 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 12:40:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhqCdXMu6dhxeNvZlCNIBpda2L7fjU2WwFJHAPfsWzP2r714E8ayVeEEUv8TdlKLccXfCUdpVfuJJxdLi8usJp5FKMYISGtEMrd5i3hISuEgKK2pMQekPHNvLWgHGdSAMZrWw0ikJ95/MSgTFGwEraDBmEfIYCBT1Fx9jiWUQwInbe7N3bL3LyGCrcXdcofV4rmSavehceE2QzTBNoGStMMG6jvznEoHjA2FHVCc7gLLKi3n66d6mT++qhmPrHAUaS0+UBF2FBI4ZEz4J7YTuq4Z8rbBM9d3/+Tk87wY+qtOlhbwNG9LrJjOuSqqNaozJa0EnpucphHL8kdmDHcHiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7K1L/7Icc7pcOCzBfiLvj9IVrPgzUAitS2YoK2kyy0=;
 b=W6rYUiicsNFHaGRgg0UIpl17SgOFZjQbTzL8ABqErE8a4Pwk5Xo0NDWzcsn74fP8xqZ/RAWJgp1zAs1U169d+tZCDKusv7MaWD7G+1Dc/SSC0QzPrmPEH8dstt5O2JPyjfDbmTri+jv3kU1rGbTg3b17tzyD5CFzYBP8ezFcBcW4wfw8yO00dBCNRfznTNGuNcXlrlrqEJTtB74ce4H++vpSZO3K6OwDw58gZkvoJEn3uY9ZCDdO0zXjTb7muskOL9UJl0Oecyz+/ZF67hnOGCI6Qndx02i1owMCYLgHzUKdvuMYIXbnZPbi//MNKYi90ECSJoJcrzDvGUiAHj8fwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4584.namprd11.prod.outlook.com (2603:10b6:208:264::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 20:40:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 20:40:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "dmatlack@google.com" <dmatlack@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6lHxiAgADJVYCAAFbdgA==
Date:   Thu, 19 Jan 2023 20:40:40 +0000
Message-ID: <c7c73964f56a8dcc2ee7fff3ac128b9ef9f62e35.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
         <080e0a246e927545718b6f427dfdcdde505a8859.camel@intel.com>
         <Y8lh59ZYZkq4fsOX@google.com>
In-Reply-To: <Y8lh59ZYZkq4fsOX@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4584:EE_
x-ms-office365-filtering-correlation-id: b03a8262-1e0d-49b4-8d93-08dafa5d6d7c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tqoFKyJbnyQVzQIZuDmIFbgW31/D3wnP48z+VNpcd59bCJCwDlwKVrVhkKs382Q7EBL4nKqg8Azedn4KyXuMXxGj9IUPuuBluyJONls9WIuhQ/NxWdvYMZO9Q29YyflWBTU+u0WVSDIm8ZubfUD+f5g36CB3KJvgPO47qYor/MXOOtMVNW+AInxY/VDn5y7fAm4ZvpHDCjVuJyxfIMEr116WyoWutjzn33BitayARL95jzEf7iLNJKp583RhI3/QcS7RluliXtB27+HVHMnY+THZO1fpso00Zh+OdVovmKNh4wQWHgvPYtDgeL/SRgMfni5D+ewX1yeykrwssz3Vyd5cJKKRsVX//hDUvCfmMdWqDUmHtULfaclOmm5GXNiMIdGNoH5KzVBYuyIlDhzt+DYFOG5rIfSa6XCOVG4p5WcoZwVIXFVMKvZS0BO/yu4BU3503WwUJ09uhG1uF7gM7lcP9/43vgeGpZNbnMti39xIWXD/pxAIgYffu3vsddfo57fW3tLT2mRmi/TWxZgYIUS/AEDNjfamJRxrBD2nHADhuMomzn5Er74HulvPnvub7H7AX8eJZQQkixvXxaLAYs01DhilXgbcA8mnRA8FS0ao2xWtIPDFgcmyXtoYu/RTqtAXo2N3U1Z1NRpnVhN6NLLjimbn6882RQ4Pk+oC4I4ZYyF7OYjWCPA9w1+yDPx0/0mz7+7Yoo+I3L3dlZsrccRuE5aHB3bTJgJxMdSovMI5VfwU3pbpjJ+5FxIKaQlr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199015)(6506007)(26005)(6512007)(186003)(71200400001)(107886003)(966005)(6486002)(122000001)(478600001)(54906003)(316002)(64756008)(66446008)(6916009)(66946007)(4326008)(66476007)(76116006)(66556008)(8676002)(91956017)(36756003)(38100700002)(2616005)(41300700001)(8936002)(2906002)(5660300002)(38070700005)(82960400001)(86362001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXRvMmF3T1ZCb2lreFVoWldJZzQyVk5uUFVnRDBEUnFJV2VwK3JqNEtCci9U?=
 =?utf-8?B?WTdtZVBzKzF0NGFSL2Y3NEdjSU5oK0FLYkpWLzV3ZGNoSUtQaCtrMmMzVXhL?=
 =?utf-8?B?b0JKd2pFbHpSK0R6cnFVQm9rSmhwYlorVmRkTWlBanptaFNhOHRiNUduQk1U?=
 =?utf-8?B?ZjJQTzlGSlRRM2tpbi9yMFYrUWx5NVNhQ1pIWERGbVJRLzh6NFNIMEZxTkU5?=
 =?utf-8?B?aFBERUp0cElyd2NMN3lJV3JMOFFuWmE0USs1OFRQY01yMHRjVGhMSHRZdktn?=
 =?utf-8?B?SytkYlNsL1p1OVAxblMwaTBNcGU1ajEyS2pibnEvVWN4OEN2eC94SjVua0Uy?=
 =?utf-8?B?NXhEdmZMZWRva0ZQd3J6aUdMWFlvRFhoMW1OQXhiVzE0cytWK25UTWNlcHow?=
 =?utf-8?B?RkNRcEpobm9HcTIvL0NjVE40Syt0NUdyR1BOb1pZUHk2TEptNDJQZVQ4eVQ5?=
 =?utf-8?B?VTBMVXpsa1V6ck8rRTUwSG9OWkJWN01Xa2YzQVhYTmVnQmhPelBVOFdUcEJV?=
 =?utf-8?B?UnBlWFBsalN4YkpzNDA1THF5UnFUVUpUQmhGL2kzWXpJclZ0ZWUvcTBWYTM1?=
 =?utf-8?B?ejVpWVB5c2tSZG9lVllPVXB1eFpKaEQwUStpNjZjZUl2T0pFSnlJY2F6L3Zy?=
 =?utf-8?B?dmJHYXA1a21CZFVsTkxycmJsSzR3N21PMzloMFZKU3A0bnNGSVpVRExwdGg5?=
 =?utf-8?B?LzUyc0NBMTFISnNuVENmZHhqNDU0WkRMVk8rb3Q5V01YeDhoK3VNbzRla3J6?=
 =?utf-8?B?NVlYeXlDOVpXQUJkQTVuZGRXTHkyallVOU1SQXZOUkdReGx3NlJhM0c2N2Zn?=
 =?utf-8?B?WW5XU09TZEo1K2NOWkpoMnhyckV5K0NXK2NHV2hycUxYZHdyV2xYM2VhQ01R?=
 =?utf-8?B?b0J5QnNoLzJEUU5oTEh6b29JZ1FRekJFKzJWNVhKUmZHam9GbUgwNCtIeDRF?=
 =?utf-8?B?M3Y3YVNwdEpvNVVGaCs1R1BCRHFybDFTS21XcnBTQ3Fjcko3TVY1cEkrT2xx?=
 =?utf-8?B?aEFTR2QyUC9FeTdNa1c0NDBKTEF2VEFhMi9UYktFdU01UEZWTmw3a1YvK21X?=
 =?utf-8?B?cVJwVmVDaFRyR2txanBsUy8wNDk5eTNTL1owV2NISUdMTHltVUthK0t2aW9L?=
 =?utf-8?B?QXR6RmlPM0xqMHFyUlJPeCtaT3dQSXk2M2Fia0xBNEcyenUwWDcrRUo3SlND?=
 =?utf-8?B?aFlDRHJlem0yYS9sQnVCSkJXcW1DUk40YkQrR29WYjNocE1vb2piZVVPUGtm?=
 =?utf-8?B?Vnh4NUJVZnc1TVA2eDFJUXU0cW95cTNzM2s5Q1hEWk1jMjV6UXBzd0tiLzd2?=
 =?utf-8?B?L1FtUk9WZXluOTBJNEMrZ0ZmdXJFc0E2WktzTldhT2FUYnRXTmFjWnVQQTRN?=
 =?utf-8?B?V0RGTWo1YlVLU25iMWlQT1hORXNLSGVVb3ZHbGFqYlJHdkdqRTI5ci9vb01q?=
 =?utf-8?B?YnZqelIyUndVSVd6VnJhdmlIcjV3SStOckJyOWcvcmRSSmd3ZWNPd2RLZ0lS?=
 =?utf-8?B?RkNSMWJwZi83NFZHcG1yc3FtTGMzbDVzVTUxWEhBdzlBWFBYa0s2ODNkczJG?=
 =?utf-8?B?UjNLaGFHTXgvbkFEa2N3ME40Q1BGR3pvWnlaaWF3eFVia294V3hMSVNMeWlQ?=
 =?utf-8?B?SWRYODB4ODZpaXRIU05PbWF1aUliYU9TOEJBL2hPUTc2MkNYSnEwdXZDNFpi?=
 =?utf-8?B?L1UvWVNuR2ticnpESkdIeUpGWm1mc1EvWDdneEJWTndLSjBEaGxoUkh2RFhO?=
 =?utf-8?B?ZjN3UnkrVmFjbzg2Zmt2VHl1aTJhdjJJeEt1ajU1K2JiNzNzUVU1cVNRRUtW?=
 =?utf-8?B?bldFRXJBdjlRVEp4S2p6cjlnZWh1Z09pNkNJMWtSdTVEOXFBOTZPVFB1bnY1?=
 =?utf-8?B?aUNYbldldis0M1J0MmlqNlNsZ1VaMmM1eXBESzFUR1lEU0dwdXNZRDI2aTFh?=
 =?utf-8?B?L0xnRHZMTWgrTkNwenQ3cXp4RTNqMUVtaHJ4QkVsNjROd3FaMFhBbjMwMEpt?=
 =?utf-8?B?THcxa0hUUXltY3R2R0ZaVytjRXZobWZEVlUwdkFDSVdQMHVzSUJzNHJTak56?=
 =?utf-8?B?bTdsaG5aRzRhYjcvd1czb0g4Y1dDKy83VzZlZVVMWWdVcS9CVmUvZVU5emhm?=
 =?utf-8?B?Mnppb25hNlhmTlVkenppOUdycXJrajlzNUtyTUFIc1hnakRGMlh5YkFGU1Z1?=
 =?utf-8?B?c1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB179DFEBE763B4ABC71D8D76FAA1EA5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b03a8262-1e0d-49b4-8d93-08dafa5d6d7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 20:40:40.1972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7FkXvMc2fLKxffM0rjm1TG0TkbFHv3TsA6if2juOrYHmy3nhhgKIPPWmr53av/2ddV3mtJggwrmeajWs/0mkIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4584
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDE1OjI5ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEphbiAxOSwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
aHUsIDIwMjMtMDEtMTIgYXQgMDg6MzEgLTA4MDAsIGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbSB3
cm90ZToNCj4gPiA+ICtzdGF0aWMgdm9pZCB0ZHhfY2xlYXJfcGFnZSh1bnNpZ25lZCBsb25nIHBh
Z2VfcGEpDQo+ID4gPiArew0KPiA+ID4gKwljb25zdCB2b2lkICp6ZXJvX3BhZ2UgPSAoY29uc3Qg
dm9pZCAqKSBfX3ZhKHBhZ2VfdG9fcGh5cyhaRVJPX1BBR0UoMCkpKTsNCj4gPiA+ICsJdm9pZCAq
cGFnZSA9IF9fdmEocGFnZV9wYSk7DQo+ID4gPiArCXVuc2lnbmVkIGxvbmcgaTsNCj4gPiA+ICsN
Cj4gPiA+ICsJaWYgKCFzdGF0aWNfY3B1X2hhcyhYODZfRkVBVFVSRV9NT1ZESVI2NEIpKSB7DQo+
ID4gPiArCQljbGVhcl9wYWdlKHBhZ2UpOw0KPiA+ID4gKwkJcmV0dXJuOw0KPiA+ID4gKwl9DQo+
ID4gDQo+ID4gVGhlcmUgbWlnaHQgYmUgYmVsb3cgaXNzdWVzIGhlcmU6DQo+ID4gDQo+ID4gMSkg
VGhlIGtlcm5lbCBzYXlzIHN0YXRpY19jcHVfaGFzKCkgc2hvdWxkIG9ubHkgYmUgdXNlZCBpbiBm
YXN0IHBhdGNoIHdoZXJlIGVhY2gNCj4gPiBjeWNsZSBpcyBjb3VudGVkLCBvdGhlcndpc2UgdXNl
IGJvb3RfY3B1X2hhcygpLiAgSSBkb24ndCBrbm93IHdoZXRoZXIgaGVyZSB5b3UNCj4gPiBzaG91
bGQgdXNlIHN0YXRpY19jcHVfaGFzKCkuDQo+IA0KPiBUaGF0IGRvY3VtZW50YXRpb24gaXMgc3Rh
bGVbKl0sIGdvIGFoZWFkIGFuZCB1c2UgY3B1X2ZlYXR1cmVfZW5hYmxlZCgpLg0KPiANCj4gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjIxMTA3MjExNTA1Ljg1NzItMS1icEBhbGllbjgu
ZGUNCg0KVGhhbmtzIGZvciB0aGUgaW5mbyA6KQ0KDQo+IA0KPiA+IDIpIElJVUMgYSBDUFUgZmVh
dHVyZSBiaXQgY2FuIGJlIGNsZWFyZWQgYnkgJ2NsZWFyY3B1aWQ9eHh4JyBrZXJuZWwgY29tbWFu
ZA0KPiANCj4gQXMgeW91IG5vdGUgYmVsb3csIHVzaW5nIGNsZWFyY3B1aWQgdGFpbnRzIHRoZSBr
ZXJuZWwsIGkuZS4gYW55IGJyZWFrYWdlIGR1ZSB0bw0KPiBjbGVhcmNwdWlkIGlzIHVzZXIgZXJy
b3IuDQoNCkFncmVlZC4NCg0KDQo=
