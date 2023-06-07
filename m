Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52358727285
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 00:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbjFGW4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 18:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjFGW42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 18:56:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149572682;
        Wed,  7 Jun 2023 15:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686178587; x=1717714587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jDaMxNTwGn8DJpPg3ltxEv++3QmCC70mnpUJsbEPd2c=;
  b=GECkjg5h+EEVM9X+s1HRHPfnOoUx9xoFZG5+2AUVe2eO8X27wvymSN3L
   RbmsClwl+/slumIdle2/YRR8BVOM02UcSk1R4s1DvJxbzc7QhVm6RuB6o
   7X84VBd6Z266+lQrUJopQ6yzzOWT1gfeQPAhtN7USQjz9gT25T/B+YDzn
   fyn0cXStEVdFENwCIDJYlGXQ9aZBkdnLXnPct2WIPvBC2kSP4cAzZVI2p
   To/u0NiS35I70eLUVMYLKYyRqITCD3179UR9KrrF4cmMK0Fo5ld3ymoBw
   dLShlEEnPpnE+LUQdx0t8cH3i+u1Hh708vSCeZaJ1vGzWZWnQshiALlBx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="420693285"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="420693285"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 15:56:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="779641473"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="779641473"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jun 2023 15:56:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 15:56:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 15:56:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 15:56:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CR0x1iSfLRZDfvX39fbJeEvb1b/T/QBN2I7lbgnxoD3qZc5zqgm+7cvvz+6Lu2TcyXTXMFhXWgvEuqDKInvDNRyoK3Et7Vp/8LXuKDomZv9WBkC9jv6V3zgTgnEbvj/nHCR2yu35nMuKBJQVmLi4N6rbemXtRv6EymIv+iHq9dX0IENoyPKLtYEsTKB/7ONk50zX6T5vV5OpK1j+hXji1Ll9hS6txV+nkyuKwHdDzJA3QE73IE0QSrYTsSh0pQ9RIQAOk57pBE/RZL5o1e/28kxe9rLUlvwglGJ9SYWq69LWrVOfabgESzgeaRIWqzo5utTMiJhorOdGDM1Gh6N0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDaMxNTwGn8DJpPg3ltxEv++3QmCC70mnpUJsbEPd2c=;
 b=mNVUEarE7/iTe6jeZ3Q7UZYh2kFpyYOpYwii1dH5EktZnf89D7RiHSiOmYbEtvqfPk2QOqH+ZoG03+K/sESMH/G8laMH1E99g3ua8wW0UgxSXpv5cbguApSM0U6eOebXc5ZvOnI+RFjZw3RRkV9GS4f0LuAAWUBQNoe/nmb/EQ5pYtEWQYaaTiDmrWiZJzNCXE8veL0qoIJeGn+xLA+bW9ryq/wbTQWfjs2+m5GWd8iwHVIaD/zuj82zbTlfrKWZegiJ4ohyaQsTdbsxr0PCQMasZpsNotOKcQJvjO+OgfKwmg4vYcSOH5PGq+fRsBG8HPD5K9fEaPn5Prs6hwyQjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN0PR11MB5696.namprd11.prod.outlook.com (2603:10b6:408:14b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 22:56:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 22:56:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZlu+qoC4MN/glPkShb4EFlRb+MK9/aaOAgACPCQA=
Date:   Wed, 7 Jun 2023 22:56:23 +0000
Message-ID: <7fa434207dfbe2a88ac7f6f6830d2f8a0f31a253.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
         <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
In-Reply-To: <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN0PR11MB5696:EE_
x-ms-office365-filtering-correlation-id: 4b9afcde-9a42-4110-660a-08db67aa6a98
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jULQKM+tpdBZYLnF2ckCkMjBe7Vj3L1MaKQc1J683YKoQ+tUmrm3w8fT49N1tFKDzFbC1lxk7xMuSrKJYVt9gH+2q/chz1f1BT328S7nggDVyC8qnrtJ/qz/WSbMEii5YEKqQrhN+7mGquhCRuv39B3u0CsG2rMGTc4AJr0w+tD3eGWc6o7tF4ACVDPaat7PENEedKDwFv7/EVNCFgW4wVTMTiZIZaC1Me65m94YQa3O894C4zv1HALr2l4sg1xBhJEJkAi2w7frDFlzxK4Kdb9qNf3l8QhvT2jLN0JWsrj6Y5Ik5Tms/sc/FPrKkr/ZxJamJnWErj/uFYXBR7OkScNFZ5wBCYii1bcWVEAy4JZg2hVLrdv0AFstr3LakbsumYZwsUMQpFQBc14YgsKfzuTa+JYAXuM0Zls1O45lypc6cu8eXebu1rJCkdRSzEIO5JYayw76OY6FDbx3Ks9PuNWgbcsfqGRtSQ7swX1REYcLpxzKvgxf6T/DiR7T2kyAE+plU1LNSD7ArXoXspWKkxgC3dJ9liMdq/AVEkB2Bp+uogYbd5W76c3nKYPHlLbQZViEGQuY7QVxaka3YsJ9o78Q0qp4ul/GR83aeeSL5WDcKwEQMA49/M8DOx68jsaPI+aPdxf72P49Z5l3DGkUDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199021)(41300700001)(478600001)(316002)(54906003)(7416002)(122000001)(110136005)(82960400001)(5660300002)(66556008)(66946007)(64756008)(76116006)(91956017)(4326008)(66476007)(8936002)(66446008)(8676002)(2906002)(71200400001)(6486002)(38070700005)(86362001)(36756003)(2616005)(38100700002)(186003)(26005)(53546011)(6506007)(83380400001)(6512007)(13914002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blJLQXhOM2R3dFliOXFjUDAxeVE1bWpwZ01oUHBUZ3d0VngzNDBmWDZQQVE2?=
 =?utf-8?B?YmcvMDZZVXR2U0ZNZ2NpSzFpcUhCQkRRdEdRUDRiU3NyL2thVERNejB1UWhO?=
 =?utf-8?B?bkdpTUVRdWo1TUpOakRwUm45UDZ3enFUZ2dXMmlXbVA3RmxTRWczSkN6R2p6?=
 =?utf-8?B?MnZ4WTZTQzVwdlpxdGNmRzB2QnZLSllOcG9SMWx1WDNlSjhIYlZBTCtuejBM?=
 =?utf-8?B?YktGWmJ2RHM3VDRteS9EeWl1QnVsM1Ztam1RTVZJdmwwVFNnU2kwcDQ0TjQ4?=
 =?utf-8?B?bnVON3hVUi9PeG1BKzQvYURkWEN4Q0RGNERVWXErdkYzcURBK3NCaEI5cGJ2?=
 =?utf-8?B?UC9FUDA3NEFEMVQxSGMzK3RGNzB4WlQ3L1h4L3lMSjRyQU9MWm8zWWdxVE56?=
 =?utf-8?B?amxhRVA3S2VEMjhxcGI0bEMxSm0vV09leEVaRzE3eHFiR1ltbzVJL1ArYkFy?=
 =?utf-8?B?VFE4L29UWU1kdlR5K3d4T2wwaklUZVVhRGJEbjdBM2ViUElBcGh2TnZZODdC?=
 =?utf-8?B?dTJwbFRpNFI5NThleHBnUkRPdWp5M3piYWxjcGlqR2J2a20rMFBpMGx4M09z?=
 =?utf-8?B?eVBPMklsdkV2VEpqWmpmOEhaTUZ1ZkNCY2tIUzZ4dVRoRVlhaGVOakN2RTh2?=
 =?utf-8?B?KzJSbGdUQi9iTG9ISXVrTy9YWTg1U3VGRjExcHJBY2ZMcHFXR0FESHVOV0Vl?=
 =?utf-8?B?K0V1OTBXTE05N1BQVUJlVnJsU3BHVmNDSEdvazZhcVVUUlBaMWJzTW1HZ3ZR?=
 =?utf-8?B?MFpHM0ZWN2xrSndxQ1FrVTcxQy9vY2JBVVFpMHlzNFRvWXVtdmExZWV0RXFL?=
 =?utf-8?B?N21mNjJTNUtkRnVjNVBuT0lkMFI1eDBnT0YzZk92VHhiKytWdjd1a0VIV1RC?=
 =?utf-8?B?YXlQQi9RUHF2T2NwWUlSVmh3M2Y2Rnl2NG80NjNTRVhhNDlCcXRQUTBOOWp1?=
 =?utf-8?B?aHF3R2hUNVp2QllpaFAwcWd5N1hPZlR1b1ZVVHM4SHpsT3BTVTBQb096eDMy?=
 =?utf-8?B?VXJzMFlQVDk5dDVCaUhaazhoRkF6NzF5Q1lHeWM1YXZLc2R2ZWlaZmZpL3RF?=
 =?utf-8?B?VkkzWWRlMThPYmFZOHVEVGxNTnFJOUduMjJaaElYcEd1N2VNMG1rVXRTYTRi?=
 =?utf-8?B?MHRrOWFYeHdWZGdPSy9tYnVxbkJrUkZySEhqNDNNR3BkWkF1aUhzNmRMWVVH?=
 =?utf-8?B?RndBbHRHOTBUSW1zK2swVUFlZ0ZyRmF6WEZJdXdnQnVjSklqUHVHRmsxQTZP?=
 =?utf-8?B?Mi93OS9EK3RsV1JscXdxajg4ZXNWYytjaTl1K3NRdHo1RUEydk5ENHI5V2lL?=
 =?utf-8?B?cVNDM1lXUlRsWURXWWpMVEdOb2ZEZDE3aXhHa0NNeDBHQUpwMVlkcWkzZ3hI?=
 =?utf-8?B?QStNYmxqZFEzUXJLNys3TXlHWVZCeTd1OHcwVURqK0oweTByNm5XVm5pVzNy?=
 =?utf-8?B?UDkraTIyU04yWnJvaTBhTEJSQkJBbnJTTGVxVnhuSVN0emlwQjduYis5dXp4?=
 =?utf-8?B?MitZc0dNMllZNDcxY0RVeFgzV3VrUEh0SFlNMVF6V2hZSGo4RTRZTFY3WjZz?=
 =?utf-8?B?eXVoVzIzUFBYaDNSVkREWUlZUncxZ3N2NHRNWmZONGZQajJEdlI5NnhBc2Vr?=
 =?utf-8?B?blRMRkxvN05QQ3p2cEtPK1FKWG9IRFFKdGI1NGRzVXRHdkMyUzE2MlBXODFS?=
 =?utf-8?B?eC9MUTg4RGZVb3Q1RjJTQVpUeGZuczhTeUNaNXhBY1lFOWtUMUhqeno4K29E?=
 =?utf-8?B?WG1UMnBxbnFHblVRUzkrOVhYOTVvL0pUOEF3cHV4UUJHM1EzamppbGV6UnVI?=
 =?utf-8?B?U2RYT1NINXJsN1FQZm5JalpqZzZMcE5mMWxhdE9aenliT1c1U2RadEVSR3Bz?=
 =?utf-8?B?WkRSNWJ0ejhvNzB1cmZpMXc4V2xKdjNNbEcyZ0c1RjFCVjNDU3BRbDhESEJJ?=
 =?utf-8?B?cndyc0cyaWNKMkp2V2hPd3pVT1E5ektwRStLYUMxREt0K09ZZUJwREZuaHAx?=
 =?utf-8?B?UVRMenFoZjVLWEgyWm5RV292SjUrMTVlUERtTWVndUkyU3U2WGJCQ0RFU0JT?=
 =?utf-8?B?VTZlbmo2bFFHRXdCNDdLN25LbTJWcDBOUS9wUlZOZTVyL3pzVzYydmZveUVE?=
 =?utf-8?Q?rEcDgLJSC3Tav7mO0GDjMIsH/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9E9FB22A8B0A145B1A8EFFCF1122597@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9afcde-9a42-4110-660a-08db67aa6a98
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 22:56:23.2946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pjj7Q4X7d0aLZefY7o4RyaZ2MXwsZT6cBKdPJhkap5BgDBkBPKkkV+4LFRdH5AKgYOM0hVUX+71zlTt2mkCtnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5696
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

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDA3OjI0IC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDYvNC8yMyAwNzoyNywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFREWCBpbnRyb2R1Y2VzIGEg
bmV3IENQVSBtb2RlOiBTZWN1cmUgQXJiaXRyYXRpb24gTW9kZSAoU0VBTSkuICBUaGlzDQo+ID4g
bW9kZSBydW5zIG9ubHkgdGhlIFREWCBtb2R1bGUgaXRzZWxmIG9yIG90aGVyIGNvZGUgdG8gbG9h
ZCB0aGUgVERYDQo+ID4gbW9kdWxlLg0KPiA+IA0KPiA+IFRoZSBob3N0IGtlcm5lbCBjb21tdW5p
Y2F0ZXMgd2l0aCBTRUFNIHNvZnR3YXJlIHZpYSBhIG5ldyBTRUFNQ0FMTA0KPiA+IGluc3RydWN0
aW9uLiAgVGhpcyBpcyBjb25jZXB0dWFsbHkgc2ltaWxhciB0byBhIGd1ZXN0LT5ob3N0IGh5cGVy
Y2FsbCwNCj4gPiBleGNlcHQgaXQgaXMgbWFkZSBmcm9tIHRoZSBob3N0IHRvIFNFQU0gc29mdHdh
cmUgaW5zdGVhZC4gIFRoZSBURFgNCj4gPiBtb2R1bGUgZXN0YWJsaXNoZXMgYSBuZXcgU0VBTUNB
TEwgQUJJIHdoaWNoIGFsbG93cyB0aGUgaG9zdCB0bw0KPiA+IGluaXRpYWxpemUgdGhlIG1vZHVs
ZSBhbmQgdG8gbWFuYWdlIFZNcy4NCj4gPiANCj4gPiBBZGQgaW5mcmFzdHJ1Y3R1cmUgdG8gbWFr
ZSBTRUFNQ0FMTHMuICBUaGUgU0VBTUNBTEwgQUJJIGlzIHZlcnkgc2ltaWxhcg0KPiA+IHRvIHRo
ZSBURENBTEwgQUJJIGFuZCBsZXZlcmFnZXMgbXVjaCBURENBTEwgaW5mcmFzdHJ1Y3R1cmUuDQo+
ID4gDQo+ID4gU0VBTUNBTEwgaW5zdHJ1Y3Rpb24gY2F1c2VzICNHUCB3aGVuIFREWCBpc24ndCBC
SU9TIGVuYWJsZWQsIGFuZCAjVUQNCj4gPiB3aGVuIENQVSBpcyBub3QgaW4gVk1YIG9wZXJhdGlv
bi4gIEN1cnJlbnRseSwgb25seSBLVk0gY29kZSBtb2NrcyB3aXRoDQo+IA0KPiAibW9ja3MiPyAg
RGlkIHlvdSBtZWFuICJtdWNrcyI/DQoNClllcyAibXVja3MiLiAgSSBiZWxpZXZlIEkgbWFkZSBz
b21lIG1pc3Rha2UuDQoNCj4gDQo+ID4gVk1YIGVuYWJsaW5nLCBhbmQgS1ZNIGlzIHRoZSBvbmx5
IHVzZXIgb2YgVERYLiAgVGhpcyBpbXBsZW1lbnRhdGlvbg0KPiA+IGNob29zZXMgdG8gbWFrZSBL
Vk0gaXRzZWxmIHJlc3BvbnNpYmxlIGZvciBlbmFibGluZyBWTVggYmVmb3JlIHVzaW5nDQo+ID4g
VERYIGFuZCBsZXQgdGhlIHJlc3Qgb2YgdGhlIGtlcm5lbCBzdGF5IGJsaXNzZnVsbHkgdW5hd2Fy
ZSBvZiBWTVguDQo+ID4gDQo+ID4gVGhlIGN1cnJlbnQgVERYX01PRFVMRV9DQUxMIG1hY3JvIGhh
bmRsZXMgbmVpdGhlciAjR1Agbm9yICNVRC4gIFRoZQ0KPiA+IGtlcm5lbCB3b3VsZCBoaXQgT29w
cyBpZiBTRUFNQ0FMTCB3ZXJlIG1pc3Rha2VubHkgbWFkZSB3L28gZW5hYmxpbmcgVk1YDQo+ID4g
Zmlyc3QuICBBcmNoaXRlY3R1cmFsbHksIHRoZXJlIGlzIG5vIENQVSBmbGFnIHRvIGNoZWNrIHdo
ZXRoZXIgdGhlIENQVQ0KPiA+IGlzIGluIFZNWCBvcGVyYXRpb24uICBBbHNvLCBpZiBhIEJJT1Mg
d2VyZSBidWdneSwgaXQgY291bGQgc3RpbGwgcmVwb3J0DQo+ID4gdmFsaWQgVERYIHByaXZhdGUg
S2V5SURzIHdoZW4gVERYIGFjdHVhbGx5IGNvdWxkbid0IGJlIGVuYWJsZWQuDQo+IA0KPiBJJ20g
bm90IHN1cmUgdGhpcyBpcyBhIGdyZWF0IGp1c3RpZmljYXRpb24uICBJZiB0aGUgQklPUyBpcyBs
eWluZyB0byB0aGUNCj4gT1MsIHdlIF9zaG91bGRfIG9vcHMuDQo+IA0KPiBIb3cgZWxzZSBjYW4g
dGhpcyBoYXBwZW4gb3RoZXIgdGhhbiBzaWxseSBrZXJuZWwgYnVncy4gIEl0J3MgT0sgdG8gb29w
cw0KPiBpbiB0aGUgZmFjZSBvZiBzaWxseSBrZXJuZWwgYnVncy4NCg0KQWdyZWVkLiAgQW5kIEkn
bGwganVzdCByZW1vdmUgdGhhdCBzZW50ZW5jZSBpZiB5b3UgYWdyZWUgd2l0aCBiZWxvdyAuLi4N
Cg0KWy4uLl0NCg0KPiA+ICsJLyoNCj4gPiArCSAqIFNFQU1DQUxMIGNhdXNlZCAjR1Agb3IgI1VE
LiAgQnkgcmVhY2hpbmcgaGVyZSAlZWF4IGNvbnRhaW5zDQo+ID4gKwkgKiB0aGUgdHJhcCBudW1i
ZXIuICBDb252ZXJ0IHRoZSB0cmFwIG51bWJlciB0byB0aGUgVERYIGVycm9yDQo+ID4gKwkgKiBj
b2RlIGJ5IHNldHRpbmcgVERYX1NXX0VSUk9SIHRvIHRoZSBoaWdoIDMyLWJpdHMgb2YgJXJheC4N
Cj4gPiArCSAqDQo+ID4gKwkgKiBOb3RlIGNhbm5vdCBPUiBURFhfU1dfRVJST1IgZGlyZWN0bHkg
dG8gJXJheCBhcyBPUiBpbnN0cnVjdGlvbg0KPiA+ICsJICogb25seSBhY2NlcHRzIDMyLWJpdCBp
bW1lZGlhdGUgYXQgbW9zdC4NCj4gPiArCSAqLw0KPiA+ICsJbW92ICRURFhfU1dfRVJST1IsICVy
MTINCj4gPiArCW9ycSAlcjEyLCAlcmF4DQo+IA0KPiBJIHRoaW5rIHRoZSBqdXN0aWZpY2F0aW9u
IGZvciBkb2luZyB0aGUgI1VELyNHUCBoYW5kbGluZyBpcyBhIGJpdCB3ZWFrLg0KPiBJbiB0aGUg
ZW5kLCBpdCBnZXRzIHVzIGEgbmljZXIgZXJyb3IgbWVzc2FnZS4gIElzIHRoYXQgZXJyb3IgbWVz
c2FnZQ0KPiAqUkVBTExZKiBuZWVkZWQ/ICBPciBpcyBhbiBvb3BzIE9LIGluIHRoZSB2ZXJ5IHJh
cmUgY2lyY3Vtc3RhbmNlIHRoYXQNCj4gdGhlIEJJT1MgaXMgdG90YWxseSBidWdneT8NCg0KLi4u
DQoNCkl0J3Mgbm90IGp1c3QgZm9yIHRoZSAiQklPUyBidWdneSIgY2FzZS4gIFRoZSBtYWluIHB1
cnBvc2UgaXMgdG8gZ2l2ZSBhbiBlcnJvcg0KbWVzc2FnZSB3aGVuIHRoZSBjYWxsZXIgbWlzdGFr
ZW5seSBjYWxscyB0ZHhfZW5hYmxlKCkuDQoNCkFsc28sIG5vdyB0aGUgbWFjaGluZSBjaGVjayBo
YW5kbGVyIGltcHJvdmVtZW50IHBhdGNoIGFsc28gY2FsbHMgU0VBTUNBTEwgdG8gZ2V0DQphIGdp
dmVuIHBhZ2UncyBwYWdlIHR5cGUuICBJdCdzIHRvdGFsbHkgbGVnYWwgdGhhdCBhIG1hY2hpbmUg
Y2hlY2sgaGFwcGVucyB3aGVuDQp0aGUgQ1BVIGlzbid0IGluIFZNWCBvcGVyYXRpb24gKGUuZy4g
S1ZNIGlzbid0IGxvYWRlZCksIGFuZCBpbiBmYWN0IHdlIHVzZSB0aGUNClNFQU1DQUxMIHJldHVy
biB2YWx1ZSB0byBkZXRlY3Qgd2hldGhlciBDUFUgaXMgaW4gVk1YIG9wZXJhdGlvbiBhbmQgaGFu
ZGxlcyBzdWNoDQpjYXNlIGFjY29yZGluZ2x5Lg0KDQo=
