Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269F8622AE6
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 12:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiKILsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 06:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiKILsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 06:48:35 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DFF18E03;
        Wed,  9 Nov 2022 03:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667994514; x=1699530514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UP4yocwF04iYt9O0XaocIsDws9VlVYKDd8Asaf6pk+s=;
  b=W4t+HV/62xQZ+yUY+WMJl8TjoegBwq7hPS0L3+6Zmw/fvH6rmazrxVT+
   QebL5pObbpAd2/YsbhnepGgFwyKET4LtLHX6mOnPIDh/P8k3XltExLSUg
   szSzHYUzrsk4afMutqsLCs5Wt7lQ7bkg2yrYkQaMmXt6C+pTF4OAEs8ny
   9hbARoCUhWb+6FkkswTHhe6yXZCy2N6Dxw28CE4C3WMaRQ1Ie3Bm3VSBK
   QGNllXjqkT/XUDPw93rRfcxf5RbpDmq7JzhzpsQlNRqKqWMzwtw2fhkz/
   ysfWSCSMCUydnVuBMm51OTiNyfqY6gFxupIQXfRtUDarlotEpvpisvE3z
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="312118212"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="312118212"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 03:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="639171181"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="639171181"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 09 Nov 2022 03:48:32 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 03:48:32 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 03:48:32 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 03:48:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvZVHjb+XcjYr1+eOyUidnDQRPJS56OSI3bXw4uEvhGtsqRHMUSIbJAE6dGu1mBSVBbfs4VuzsbkNnRD8NfU6brrShM+VWPT3q4c+DgV3gVDLlwZFP5wsFNONzXZMH+Q9aIB048tjkjj4LYrfvzcjzJnmYTi/iaTkck0F69G58bt5nBp/+3AkUY06ugmj0aS2pnyMHCoF/NckiySzdJ6aaQ9pCKqMdrVNBwWvWIkO30Bp0gSqzjdvf3MQmVTNeqgvKkUdexsIaIcVHXg7ZntuoM8QI6JgNmcDh3wRtPG8xhek5oeZ3nwuxCvMS3iMFedUjBSS5TpJM8G5NxI7OQiDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UP4yocwF04iYt9O0XaocIsDws9VlVYKDd8Asaf6pk+s=;
 b=HrdCavTKB1MDnWqq+PNPI6FVU5UpOYbR/8xxjedzRzxUlT5jsDjtGCMDncwjUTpGUd0+6AYQWboh+1vXtdRbX3d3Zez/XuB2ukRAxGsII2QwvLQKTu0YuEbQonFY8G/LtUT87zBzoh0N221NXLQW9fzBw0ko0RDHLzrRsVsd8jOMMGCSoIUa1dSPeai7/jvg77lJgbtWSnmRyEd/eNxiecBbFc0IkBAfwWiXLzZ20BzfU4psoN9frbRJAqQqWsJazfau8Jre+u8nCEdt3CGbYnrpHj/+utNfa4Z0bpyf88JFL/L2wwHK/myqBDS/iC8vokXEWl+4yuTagJzmkhP2ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6923.namprd11.prod.outlook.com (2603:10b6:806:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 11:48:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Wed, 9 Nov 2022
 11:48:30 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 034/108] KVM: x86/mmu: Add Suppress VE bit to
 shadow_mmio_{value, mask}
Thread-Topic: [PATCH v10 034/108] KVM: x86/mmu: Add Suppress VE bit to
 shadow_mmio_{value, mask}
Thread-Index: AQHY7ChsGmvpoTBhQUO64TBjq7b4R642ig2A
Date:   Wed, 9 Nov 2022 11:48:30 +0000
Message-ID: <a0d5878b7280372fa2de49156d58f69fa07659cc.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <1c480a48c2697054b1cfe068fa073f4035648f9a.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <1c480a48c2697054b1cfe068fa073f4035648f9a.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6923:EE_
x-ms-office365-filtering-correlation-id: 047470a5-e445-4468-e48a-08dac2485273
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BncFs7nSHf0CYKbT9WZfHbSFuTSWklCPBKcSvIMD4bMgOj60RCRZSnqUfcEE9mpmt4G80sFNabulSG7v8k61xG3G08lhQj4dSv9w1pOvLG1+G7AWlRLfFlD2pq9UENkyXf+s8wMOggTn4OH0N5d1+BoMIbYxZssk0Fbp3w01sABkfFEnNKMUTHTP3pcOuQ9LfVoCmiLMarURsSCLuG5IWVqhGwk2Q24yAUw6cUE2AswsDevE+jFljE0DvLq9VY3qwsJHI1/Nfo2uBn8Agg3U5tqCXb+0X4zYG+84VlW2R7Hq8YaW+GSq75nZlAFpnXNcfWMTPdoy5KFFKVwtH3zXLZZit6T0ChNIUCkDCrgsL/gayHFnayi4zscwc7h1FGbSvOQMkmnrrM4Acfdg8l8RoPUQHwGykWFtN9ZRhJoF+oB7lHVwGORAQpDgwJx4YJt8y8rvr1mBkCsuHBw/Ya0oLETH3OU5C+zb1e9r13O/vcm6AHWEAIAZ512qC+FIAaNMVlNzWnU+oyqXGWQexYw/G+fOnYaCvqDcQklmC26DW7UP7H0xkEhfy8VQz8Ohq9uDdW/VIsy9og4d2x4iSd/3xgQ5EkuWKtvBdaKcD5Pv+vYSMIgYL3SPxjagqydUrMA+5PwkxHBIIgK/o2ynAOgSjZy+DHL6ud/a0czqEGr8GhdaP6IOK58LBvosLUpAG85tlvtY7ZZKBYIvI55yDEQpPRKxaOoqJE5CaU6FTAWRFuOFn9WBzFn7JjCmrqQRa+keioWKW3bOwwow9kenKjU70g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199015)(86362001)(186003)(91956017)(66556008)(66476007)(66446008)(8676002)(64756008)(5660300002)(66946007)(4326008)(76116006)(26005)(41300700001)(6512007)(2616005)(36756003)(8936002)(316002)(54906003)(110136005)(83380400001)(6506007)(4001150100001)(2906002)(6636002)(82960400001)(38100700002)(38070700005)(478600001)(6486002)(122000001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjVXbG9lSDV4VEZpbUJ1aE9QaGNKMDh3Q2l6aW5DQzd5Y2k1QURPZjhBTDZn?=
 =?utf-8?B?TXN4UVZUaXY0d1dpd1pKUW1CcCs5UU5zR3YvbVFXT0k1N2d1SGg4THc4YTNo?=
 =?utf-8?B?UzQyWXhIZkF2OHBGVzZHMXkySmJBeXV5UHJIdVlUeFhWUmxWbUdOMnVwUklr?=
 =?utf-8?B?dm8rcHlNb3NnM2xHM21iTnd0VklzRG42L2llWVFaYUdONllPV2h2YWh1Y2J6?=
 =?utf-8?B?TEZtSHArRFRXeXFYWnV4VUVsY0Z1Z3pvZmJXdHBaS3RpbHArdkNUZVJCdnk1?=
 =?utf-8?B?cU1vQTgybEhubWdlNjUveENWZ1JFbjBpaVdKNTRnUTBBcnprSFgxV0tIUFFC?=
 =?utf-8?B?aUFWaTZDTGtybTVYL2tZaTlTcm0zZVFPRnhJdDducXMxbE1OUTFodEVad3JJ?=
 =?utf-8?B?RkVKN0poMHluQThFdUpoaW1obHN5Z210cVVYaFk5N09PZVJ4eU13dGswOFlZ?=
 =?utf-8?B?OVBzVVpubURCa2xpelpWYkZjOC9US3lBZUlZY0RUazNRbDNYNm0rUStEenBn?=
 =?utf-8?B?WDR6aWUzT3dKZWY0WlVlNkdBKzF4U2txSzhVd3Bsc2xONnZyMEdzYjAxMkhV?=
 =?utf-8?B?STZ5MCtIZnZsNVNJR3pmY0tZMWNLNGMvRnlCbWlvWUg4cFEwd2ZyTDR6ZXNw?=
 =?utf-8?B?aWU0NEN3czlKYjgvSFJvQXJWZTJRYmdwMUhKZUlyNG5iZVAxOWZrMWREUWZw?=
 =?utf-8?B?dithMWlKb3g0RExOb0RSYUZvSW9CdlZBK1lMZnY5Tk1wQzVjNkd6MmhwQnZ0?=
 =?utf-8?B?dlExOGMwQS9vTDdXMEJGRXd3WmxZbisycXZRTVAwZWdkUUczZjBLOTNHU2lN?=
 =?utf-8?B?UWcrbTA2Q2JaRElaTzZscmhJNUZGcGxqeWFsWStza0cwYW5aUkkyY2dDVFFE?=
 =?utf-8?B?KzYvMzVsQXVjWFQxY0plWE9COXM5NU5VczYyVmxtVDMvRnU2R21oRklQQ0cw?=
 =?utf-8?B?WnpBbDFUM2hKYmhjczlmaXJabFNNWEZEczZQa2JCZjVNdW5waG1lV0xHVDd6?=
 =?utf-8?B?TmhIT1U3YytaZm5pakJnMnhmQVJxRHpnNE9tbnNRQjhnbnBaZUxhaDFMb0s0?=
 =?utf-8?B?WFFnUGErYmZPcFd4dlJlS1lzYUR1d0JXUXVyL0NhczJHQUllalNUeUpDYzJ0?=
 =?utf-8?B?ZFlPdWh3WmVmQzlIYk5IeWRKcnNubkFTdHdtNURyMEFaOE5lRlhtMU1held3?=
 =?utf-8?B?VlpPR1F3T1ZkeFpLdHhZZ2ZxS0ZOdjFOeGlON2pOb3Y0WHVLSkR2RXdqdkdD?=
 =?utf-8?B?bU10V0owZHdBdTBMYkhjTDFHcDJsa05zOU9MSHNnUkNZYWhaeHVzOHhwcWNx?=
 =?utf-8?B?bXdPM08rbmh1RE1kT2pDdVY0M3llQjFBU0hKSDUvaUExSkg2Y3M1akMreVl0?=
 =?utf-8?B?Y21qKy90a01sSlI0aDQ5a2pzbGVVY05lazh1Y3NxZFFtWkVFd1dFSDZzV3Ja?=
 =?utf-8?B?Qll6YnJ6WDVkYy9hTElRTEVYVnRmNlVQRzBnUmQrTENMUS9LN3ZObjIyZmVP?=
 =?utf-8?B?bG01RS9BbW9GanRqenE0dFlhZEs0UDAvM0tzWklEbTR1MU9yUURiOEVtL28v?=
 =?utf-8?B?ZHY0MERpdGNWVXFiMnNLUUNwVzB5R1l4OHBXVWNVMkxmOVFsVzU4dGlUTVBj?=
 =?utf-8?B?RjM4WkJ0UnRkbTFBUTNlMUJnSmpaQUlKbjdFaDVUdXhSOUJubkFxNFMrYTFk?=
 =?utf-8?B?a3BwSGFVdXovYkYzdUpSQ3pWbXFiTEllcm5GLzZqSHdvaVRhbzc5bHJMMFRx?=
 =?utf-8?B?YUpqWDBTRU1OYmFrRTBiSWY3MlhiYkNpcUh0WEduVzVnQyt3Y1g2bUdvNEx4?=
 =?utf-8?B?QkVrTVVoWXdXcElqbmkvWExYWm90RHdlSzRMczB6VUhXUmFxczY3dTlxUk9r?=
 =?utf-8?B?Wnl6TC8yNW1aNS9Wa1NMQ2VWZUJLVnRrM0NPaXhwL0F6ZEwrVkJCYmprOVRs?=
 =?utf-8?B?UEZYbGxXREsvVkpweE5qUEJlYXEvazFOOElXUVh5NUpuSGs4TENIWlRMczc3?=
 =?utf-8?B?eU15dFIyOE9kT1NxalJJeHdTcFkrdVFjb2F1eittZEN3MWt4TXErVSswZTJu?=
 =?utf-8?B?WkFjdUJCWWM2ODNsZjd5TkU2UzBZZ1pQV09OKy85WjcwdUhIMmNycG9FQUtt?=
 =?utf-8?B?aHdxWFZUZGhoK3Q2UGl5RTI2T05na1c4S2ZURUJTZkdXUVhRK3FBRU82MHBT?=
 =?utf-8?B?bFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BEFE139DF8DD64D9854A995A98DB4C4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047470a5-e445-4468-e48a-08dac2485273
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 11:48:30.2638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jrzgP2NqB7J8MwztVsSNz/5i0rvsdw0LLBCAegDE++BB/j368iyiwQXtdPw03N0kLsgyNvkehyxzW2jakgJ1eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6923
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBCZWNhdXNlIFREWCB3aWxsIG5lZWQgc2hhZG93X21taW9fbWFzayB0byBiZSBW
TVhfU1VQUFJFU1NfVkUgfCBSV1gJDQo+IHNoYWRvd19tbWlvX3ZhbHVlIHRvIGJlIDAsIG1ha2Ug
Vk1YIEVQVCBjYXNlIHVzZSBzYW1lIHZhbHVlIGZvciBURFgNCj4gc2hhZG93X21taW9fbWFzay4g
wqANCj4gDQoNClREWCBuZWVkIHRvIHVzZSBkaWZmZXJlbnQgbW1pb19tYXNrL3ZhbHVlIGRvZXNu
J3QgbWVhbiB0aGV5IG5lZWQgdG8gYmUgY2hhbmdlZA0KZm9yIFZNWCBndWVzdC4gIEkgdGhpbmsg
dGhlIHRydWUgcHVycG9zZSBoZXJlIGlzIHRvIHN0aWxsIGJlIGFibGUgdG8gdXNlIGENCmdsb2Jh
bCBzaGFkb3dfbW1pb19tYXNrIGZvciBib3RoIFREWCBhbmQgVk1YIGd1ZXN0cy4gIFNvIHBsZWFz
ZSBleHBsaWNpdGx5IGNhbGwNCm91dC4gIA0KDQoNCj4gRm9yIFZNWCwgVk1YX1NVUFBSRVNTX1ZF
IGRvZXNuJ3QgbWF0dGVyLCBpdCBkb2Vzbid0DQo+IGFmZmVjdCBWTVggbG9naWMgdG8gYWRkIHRo
ZSBiaXQgdG8gc2hhZG93X21taW9fe3ZhbHVlLCBtYXNrfS4gIE5vdGUgdGhhdA0KPiBzaGFkb3df
bW1pb192YWx1ZSB3aWxsIGJlIHBlci1WTSB2YWx1ZS4NCg0KTm90IHN1cmUgd2h5IHRoZSBsYXN0
IHNlbnRlbmNlIG1hdHRlcnMuDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRh
IDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL21tdS9z
cHRlLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9zcHRlLmMgYi9h
cmNoL3g4Ni9rdm0vbW11L3NwdGUuYw0KPiBpbmRleCAwYjk3YTA0NWM1ZjAuLjVkNWMwNmQ0ZmQ4
OSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL21tdS9zcHRlLmMNCj4gKysrIGIvYXJjaC94
ODYva3ZtL21tdS9zcHRlLmMNCj4gQEAgLTQzNyw4ICs0MzcsOCBAQCB2b2lkIGt2bV9tbXVfc2V0
X2VwdF9tYXNrcyhib29sIGhhc19hZF9iaXRzLCBib29sIGhhc19leGVjX29ubHkpDQo+ICAJICog
RVBUIE1pc2NvbmZpZ3VyYXRpb25zIGFyZSBnZW5lcmF0ZWQgaWYgdGhlIHZhbHVlIG9mIGJpdHMg
MjowDQo+ICAJICogb2YgYW4gRVBUIHBhZ2luZy1zdHJ1Y3R1cmUgZW50cnkgaXMgMTEwYiAod3Jp
dGUvZXhlY3V0ZSkuDQo+ICAJICovDQo+IC0Ja3ZtX21tdV9zZXRfbW1pb19zcHRlX21hc2soVk1Y
X0VQVF9NSVNDT05GSUdfV1hfVkFMVUUsDQo+IC0JCQkJICAgVk1YX0VQVF9SV1hfTUFTSywgMCk7
DQo+ICsJa3ZtX21tdV9zZXRfbW1pb19zcHRlX21hc2soVk1YX0VQVF9NSVNDT05GSUdfV1hfVkFM
VUUgfCBWTVhfRVBUX1NVUFBSRVNTX1ZFX0JJVCwNCg0KSXMgInN1cHByZXNzICNWRSIgYml0IHJl
cXVpcmVkIGZvciBtbWlvX3ZhbHVlIGZvciBWTVggZ3Vlc3Q/IFdoeSBhZGRpbmcgaXQ/DQoNCj4g
KwkJCQkgICBWTVhfRVBUX1JXWF9NQVNLIHwgVk1YX0VQVF9TVVBQUkVTU19WRV9CSVQsIDApOw0K
PiAgfQ0KPiAgRVhQT1JUX1NZTUJPTF9HUEwoa3ZtX21tdV9zZXRfZXB0X21hc2tzKTsNCj4gIA0K
DQo=
