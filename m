Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C205063B4FD
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiK1Wuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiK1Wuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:50:52 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AD531DC9;
        Mon, 28 Nov 2022 14:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669675852; x=1701211852;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OAKi0E9BH6OeWoEEik0Ynr3gJQxIawoPuIAQKXvT3fY=;
  b=OAHSkWUjg4oixR8so8ujr9mFC1dPxiynJrFi6kt7CNEnCSXDr60vL62K
   2E0PK9jJvQlUv5C2M9MPd9dqrW64eoEnrRvbfRhdiuDfCam51uTaz//wW
   +lHfPvP8W4lTUw1xowUwQ7vMBAmJ2oq72KdJ/2/M4cTqewPI/Qc7XvXvB
   es014OG+hFX9XhYQXknKauok7TMRus3rZjgJVYWatzzARaj27RonHiFWV
   1C5En3OsmlkkgS5PkBd0hkh1uD75eo1cf3wY7XIl1nr3jardclEIcaNud
   gblxDWo0yFhQ9SX3mI8KXN0+xybhIi13w8AH08h89Q6zKcUwV3ronGNJ/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="401251480"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="401251480"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:50:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="594041474"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="594041474"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 28 Nov 2022 14:50:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:50:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 14:50:50 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 14:50:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mC5SR1zCiiPsPNWiU9AgGr3hLgmCFlXmjkV6vLGTJYM+EoiwqLOSCyCJjFKfpMxEv7X+d7ipANGfBYY36+YGxvm63jJZUoQLreNt1KGrjZEXxLPYFxmXhb+1SLxOLmoHcIjmt7d+VH9VndECjHvD3Lkzz2pt065MhQxL47lTJ5HxSv1yOKk+EwagXpE7i5Bl/suqet6qi9zoo7cQ6QwH3Jko74kfPyUD2EGuPhXocW2rduO6b9lE6/5A24b0Rw/Km97m8B83guAqhOw0WioGetPyfG717mFO5wWOhngXDJiEepmgxQRC19PKZrtCpYbemXe0j4tJ5svL0DaQJvKOqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAKi0E9BH6OeWoEEik0Ynr3gJQxIawoPuIAQKXvT3fY=;
 b=VmRHeQkOBPBYqz2HIJ7hp7QEgnF8fdiNJE27C2Bg2Mq81beoAlZqaCfbN9CIoblY6+zNuk4P3m7jEXd01s/kyBXQRmz2XQEkXY1JvxEEyPY60a/Cau72lfnyGUc2nl1LBTWqVmWlB5n8jTtR7r27o0Kb4J4Pz4sgEN09adigDVENCgj3wbafSdSR/+9UpW1Tq9UOpIaCD5dG0FjPPvxlPdHY+V5x+bxXWlwvujTNkNWvO3//tVaTyTN7rYiVlzIr+MmY6G8JnB3cPOP7ul7nmVz6bYBsINB3yHfI36bxKz12IbPlTEfgehgJwSRaoBxMQgqqnAYkpk2/U57xcLS/mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6190.namprd11.prod.outlook.com (2603:10b6:8:ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Mon, 28 Nov
 2022 22:50:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 22:50:42 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY/T3ORWilVlKW4kyc0A5kdGk0eq5NGDiAgADmkYCABotngIAAaI+AgAAB1QCAAAiegA==
Date:   Mon, 28 Nov 2022 22:50:42 +0000
Message-ID: <02d2a49cbd319814a7afdf57ca3cc9809123952a.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
         <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
         <35aee96c1bb56322191ae442f3928d7dff064a92.camel@intel.com>
         <9a653cd2-70df-8c55-ac7d-5ddcb3b18b0c@intel.com>
         <60deb2ffe15e71bc91727aa04298c79f21a58c83.camel@intel.com>
         <e49829fc-e488-3a65-b6fd-f02e964bdb4a@intel.com>
In-Reply-To: <e49829fc-e488-3a65-b6fd-f02e964bdb4a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6190:EE_
x-ms-office365-filtering-correlation-id: a283238e-96e1-4179-5d5a-08dad192fa64
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m9udObWM3bFDFg1svuswdHYibdRl7DEAFgEu8mFelhyuGTcnEPN2CD4xK3/itVE1bB92e7ii6NBdG6p/YBV/a4D+byEGi2S+kBY4OnTs/Bzu52Sq2uQtClCc9tbtFsCaAF8c8mW/Iir9WUWAAvj49lvjJ37nMHNW7aIP4U4q5GlssrH0DzFZAvvX67xOZhK+WDex1Vxoduq90CdbUSgeVZ8dZ/DhpbfxxwVzD17lV7BlOROT5vaDPYL5Sly91mc99uNiL+i9XnxQZKgHmPE4fAfyG8/mmKow+6zPwVEdNyh1o5cSzPxatRZ++i9tVk7UkkhtYsylEnlISwLItgFyLsyGxXFQ5LDhcaAaQZgY+jWSeFULxmBOQMWBA32tj1rkqWBvmLlVhsJnaf6YEBV8xsFDHGeQFLZONELeNd6YfrTl+IVmES0eFsf3sgMwMqFYOspDjTuNYfUOOY55Y2lXFLN5GjLYpj74/VcZfY9Phq9L6thf8t6RKXK6mnv42iKAmldps++1G5Nh8VV4229Z75aToK8GEfu1dKP1CE15uwK2aOW4qZCxfM/LhflEVPhtL+uH8mjYzAasDNNBBVdU+WK0dljBU8c6vvc9nvPVK02mSOsFYKc9iNo3ipKCphqh2Y6mCez1T06UchVGXCtQH1AFrvHA6tBq2wzstbAPNJlmUjuJFBr4UA54JAzVa26bOZr3mbES+PxHj19lIZOFJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(316002)(6486002)(110136005)(54906003)(53546011)(6512007)(26005)(6506007)(4326008)(8676002)(66946007)(76116006)(66476007)(66556008)(66446008)(478600001)(64756008)(71200400001)(91956017)(4744005)(8936002)(4001150100001)(186003)(83380400001)(7416002)(36756003)(41300700001)(2616005)(2906002)(86362001)(38070700005)(122000001)(82960400001)(5660300002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFdZU2xpZm1ZSTA2WDgzYm0zK3RReHlnY1ZoRjVhSVlBWlRQMFpXS2x0cUJ5?=
 =?utf-8?B?RDY2d1FnVWhTQ1FCbWpoc2ZLeFY1WDdRTHQyUzdZNmdnWW13Zi9WTStVRTNh?=
 =?utf-8?B?eTFQdlYyWExkTExFVzBjdjg2aWM5bDZFcldZUklVamZ5ay9TMGo1YUx1UlB1?=
 =?utf-8?B?OHNFbldMUkt3YWh0Z3FrRExTeE9GQzFzbTF4TG9hUFc2VnhZOStiRFE0N3Br?=
 =?utf-8?B?eUpESlJCWGZWMmt2K3cyVHMvWG5ZZ1oyelhWUll6NXZGZFc0SExqZzVmQWdo?=
 =?utf-8?B?U25QYjZqc1l1ck93aTF6L3pWTkU5UExNUzRrcXNTV1BvWWY3V1lmSUdQSGs2?=
 =?utf-8?B?elBUZGlsQ2tVZ1pTRHh1bkgyWUk0VkQwbWEyVUhHTTZpclRzQnlmOFd3cmVI?=
 =?utf-8?B?VENQck9ITmFNV0VJU1EvSmJWcnF5MjdDYXIrdGRBMldMV2dvOFdGQjVaWnlG?=
 =?utf-8?B?L25YY3E0cEt0L2F4L0dMaTVTTmVyM01FQ1ViK1FFLzRKbW9xcUZZWFVqaERp?=
 =?utf-8?B?bFp6N2dNNDlTRWtoWkNyOENFSk9oS0Rya3hVVld5dk02UkpyN3Z4ZzNLV2Qv?=
 =?utf-8?B?TUdYOGxuRE9iSk9sREozMThoM2Y4bmtITm9SLysrUHZ3WWN5SGEzTllwazBX?=
 =?utf-8?B?a2hBbGR3b09aMnhxaTJ5VjZyMUVqYWtPTVNjdGp5YXJ1T0lZaXJ1WFVHck9y?=
 =?utf-8?B?UUZ3RWJhMGp5UTl0S3BVTWxITGVobnFjSjBXQ1pEZE5SNjBwT1hZTVhjazNB?=
 =?utf-8?B?WkhmaE1aMlZ6RU1vZDR5a0RsMFZMbkRnYkl4SjdRbTJIQkUvSW5SWHZOYWZC?=
 =?utf-8?B?SGY0VFJsMkZyUHZhLzRjQ0k0U3pVLzJ0bmdrL1ZNVmUyL1BpN1RDMGNSVmpw?=
 =?utf-8?B?MmpteUgyNFNrWmpxNlFFd0Z5NXJLZ05aT0JQSm40ekZMVE96cGVMMS8vOUNs?=
 =?utf-8?B?akYzQUhQV1JLck5kR2tpYkk2NC9qeW5HbG1zWmcyT2FRTFE4V3NPbE1YOWUx?=
 =?utf-8?B?VDV1M09LWHo4d3BsckIyaWVXNUhtYmRuaG5HczFYZURnQm5DdlRMMm43bHFD?=
 =?utf-8?B?bGZMdGFsWm0xUkdkZjg4NzNRR2ZoWTEwMWVCZUptNWo2bS9OeTVyaG9Qb2FO?=
 =?utf-8?B?bHV0a2R1cWFzK2hIVlloME5zZzVMUm53c1pLcllleExXUjRSVWFodk5pYUxy?=
 =?utf-8?B?YWpMUkg4UWJYem5ZOUJ0aHFLZUNIY2tLTUdZUkZuMDd4eElIQ3ZOYURLRDhW?=
 =?utf-8?B?cmN3bDg1R0ZLNFM2OHc5K0h4VGNHeVdMQzFGaUVmNXVYS3BvaWdqVC9aNWJI?=
 =?utf-8?B?eFJyTU5RamhhTW91aWtrc3hWZlZzTm9sM0RuRDVjWThHVDJrTzV4cW00WE9v?=
 =?utf-8?B?b1FlbDh0enpIRkdkeENXQ0d6SDNoRFdQWExHL3pwQldjVERQTG8wTUdNcmxT?=
 =?utf-8?B?VCt5dXhPamkvMjlnL3A1eVpROFpocjNuWW82cGNZT1Vkd0pmdUlwZmJkVmZx?=
 =?utf-8?B?MHlLazRLVGxPaTZCcjBRLzBIelNnWXpyUHpCdjVBeFd1NTROd0NGc1ZZSnRk?=
 =?utf-8?B?d3RYR1QvWWF0UTc1eXA5dU5OMGUrck1IZ1lmN3RsN0hGQ1dvSVgrMFQxeWZN?=
 =?utf-8?B?Yk9pbTBYU0VNTGRRWGNuOGNTY080YkFmODBYZ0NvZ01RUDYzQ01kQVkxZUZu?=
 =?utf-8?B?MHNvY3NRaTFaTlN4dVNlZHZ0MzBvREsxbXErQUxxM2x2dms2SnlJbFJUL09p?=
 =?utf-8?B?eDFOVzVOSXF2TEYrOE54NE9nTVgvSTVidzYvZGZoS2JpUCt1enh2ZUhEWWhW?=
 =?utf-8?B?ZE9DNHU4WmxqUXhNWDlveFU0RFZWRmg1UEhMdHBKcmtqcmJMMWxsTU1oRTFk?=
 =?utf-8?B?WUVtN1lRaUl1RWNGZTFLR0R4ajJiam9rZUxlUU1jcDg4M0NSWWoyNWFrODJl?=
 =?utf-8?B?WVpKOTJ2UE4wUEdyTit0UWtncFdXNVAybWw3Z1YxNVBrS1EyTmFVUkIzWXlZ?=
 =?utf-8?B?Y2ErTFowT1JxbnZHSXl0cEFzVkdmcCt1TWp4YXR1aEJ2eXdVVElWUWVINnoy?=
 =?utf-8?B?b0QzcXFDMzZ4QnlMYjR3R0pOSFE2Zjh6UzEvZHh5Rko5TmJ5YkhNVkZaMHNl?=
 =?utf-8?B?Q0FFeC9NUytvaElocE9OOElKcVY1bHl6RUpPbFhBZzd1K2xPQXVJS1QrczNV?=
 =?utf-8?B?RVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23604E40BDF5A74CB2AB7935ABA959B2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a283238e-96e1-4179-5d5a-08dad192fa64
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 22:50:42.2033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rlFhxkBdSgXWSNlUQyzjoTrnKax2ELr4NXyWJqeCBF2Qgh1ReyTnl/yHK+Aae8inl8UPKEs1l1J1Cf9fbHdkgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6190
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTI4IGF0IDE0OjE5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjgvMjIgMTQ6MTMsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gQXBvbG9naXplIEkgYW0g
bm90IGVudGlyZWx5IHN1cmUgd2hldGhlciBJIGZ1bGx5IGdvdCB5b3VyIHBvaW50LiAgRG8geW91
IG1lYW4NCj4gPiBzb21ldGhpbmcgbGlrZSBiZWxvdz8NCj4gLi4uDQo+IA0KPiBObywgc29tZXRo
aW5nIGxpa2UgdGhpczoNCj4gDQo+IHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+
IHsNCj4gCXN0YXRpYyBzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCB0ZHhfc3lzaW5mbzsgLyogdG9v
IHJvdHVuZCBmb3IgdGhlIHN0YWNrICovDQo+ICAgICAgICAgLi4uDQo+ICAgICAgICAgdGR4X2dl
dF9zeXNpbmZvKCZ0ZHhfc3lzaW5mbywgLi4uKTsNCj4gICAgICAgICAuLi4NCj4gDQo+IEJ1dCwg
YWxzbywgc2VyaW91c2x5LCAzayBvbiB0aGUgc3RhY2sgaXMgKmZpbmUqIGlmIHlvdSBjYW4gc2h1
dCB1cCB0aGUNCj4gd2FybmluZ3MuICBUaGlzIGlzbid0IGdvaW5nIHRvIGJlIGEgZGVlcCBjYWxs
IHN0YWNrIHRvIGJlZ2luIHdpdGguDQo+IA0KDQpMZXQgbWUgdHJ5IHRvIGZpbmQgb3V0IHdoZXRo
ZXIgaXQgaXMgcG9zc2libGUgdG8gc2lsZW50IHRoZSB3YXJuaW5nLiAgSWYgSQ0KY2Fubm90LCB0
aGVuIEknbGwgdXNlIHlvdXIgYWJvdmUgd2F5LiAgVGhhbmtzIQ0K
