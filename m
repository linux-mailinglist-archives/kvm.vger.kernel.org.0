Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A7D6954EA
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 00:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjBMXnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 18:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBMXnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 18:43:51 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A5F1259D;
        Mon, 13 Feb 2023 15:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676331830; x=1707867830;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hk0zneLm7MambHIoC7lrG7V87R3CURvqYFihVeKNslY=;
  b=d87QaFlh1aRfFgaxXZ7WF9ALMa03ihPm6hKUECW9sUIH/5/GNCrh5AfF
   fE+VQ1HqLesW4DwVyoYrvt3wumT44tZH42tGs+zckeXucja5zQIdOe/sj
   70QGcw79Es2OCVMAZqYVNGxPF9K6exKX2FbuO1yV/x4CjMTGRe8hRVujO
   cz2PxrwKUACpyDkjYrjuiaBmd5a/gV87QehmUOI22mfcb2tMgLxZpgubZ
   SHuZ4QDQCkQPcbtVFw7rjKkk67zD2LdaNvHK4ZpsAFxMLpGzbsHYzQkgI
   yoVqeWFTCo4YQ4fxGuAnQjFZT28n8wRP+uMZRcT015ttuhLpsrrBLrTTi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="358435577"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="358435577"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 15:43:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="668963908"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="668963908"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 13 Feb 2023 15:43:48 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 15:43:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 15:43:46 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 15:43:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvWACiCzbsyQXvgs70Onm+4A0B9EC1deUEteas2eQAKwz+4rv0artbYvVDzRo7WBdTkwRNT34NoG6rOReDaUMi2y1CGGM7TathslFcZbe+pGV/G4CoPHZ4vrak/peZtn+4cjTM2blyKrEa+Txnbe3ZEG+a0M5UAc266V98odxQFL5OzP2NMd7jMtNY+bmTTIXuRyp9HiDGBkHq7/5Vx02eXW6Y5S7TVi6ddI3kDeAUBj8HwSA+GUiuTrKq6+HIBq9ndx71sIV1WNCaFI37l3KgzGdvhlx+mTdFmMW4ss+QvqcHq7H/WcfhQpwtPqHK8SpRzKDHyisBZWq/WcMsj9hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hk0zneLm7MambHIoC7lrG7V87R3CURvqYFihVeKNslY=;
 b=fAlSZ00VTCcmaQGTBIhrfpaAdZOJfHmU8naZgwnnXqvNQXHk503wQ9NBJFAHsit40j8EqtwFANR3xV/rGJCsaWYdSmKa6yqsG4ZXQ6yhrEQJEhKLWjIXxy3XIkyEGPLkjxsf+QpC12rLTKctlpk4coqdlvqX5KDnsi/Jxz6DSUI0z8F0DuPoZwN9LMaaI9pAJ2oYji8tam2fCFzKBKDKs3g+TwtxKB5VenTvS+U3igIAboZEMQTtAFY8W3PensRgBg1nt7c42ASt6gOTdAi0mC7nl+820LwapBMzLj3VR7nb/UHr8nHLJ9V9wgktthjDQ/CVTlD6ggMvCx3mdm5eug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by PH7PR11MB6553.namprd11.prod.outlook.com (2603:10b6:510:1a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 23:43:43 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::25e9:aacd:36bc:b5e6]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::25e9:aacd:36bc:b5e6%4]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 23:43:42 +0000
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
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Topic: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Index: AQHZP5uucDbGOLsVDEixmYuAvdZDZ67NLNsAgAAwVbCAABingIAAFPCA
Date:   Mon, 13 Feb 2023 23:43:42 +0000
Message-ID: <8e9238bbcccedfa00e2dbec87e1d77d370911846.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
         <2d9172c5-e1e7-bf94-c52b-0e9bc5b5b319@intel.com>
         <BL1PR11MB5978F562548EA22BFFD13970F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
         <2d7141b1-1d76-4e67-60d2-471a524c372e@intel.com>
In-Reply-To: <2d7141b1-1d76-4e67-60d2-471a524c372e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|PH7PR11MB6553:EE_
x-ms-office365-filtering-correlation-id: ff972c35-184b-480a-3a69-08db0e1c23d9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cXga+vZgLJ4t6mT6dZsuQlgDF8bmtSsbLDZOWOH8r6bWFS7j2tepvyPzFbsqVZ8cj/69cv1Et/IizqPqPo2JL7uI6+mNH00Q6SQqG4I1lHhH0e62jihv5PtACMrrI6dyq9Df1ZDJPmfyUdcK3vO4wjUzPbZvBy/unpwFDPFd2ZVPVfWoC350ZD5ry4C3GI6OUiXpghq3XWYbw7tf67LiNW89/Wa7ti/W0dOtORNuiJ+P8+yAwSuIQWphwR0VWT0xLxKwpmyCJMZAtajS2rUxLy6JAUxuke/nuK6JQDsqr8Jq1twz9fHgfB7ig7J45ETqGRPZlY97lV10sB1NT7/hJKtWKyPVAXaHaIzW2aL8LPHxh6IhRKOc4Mei1j5eAMmHMowj7p4QTDbZLvHOYJs1kQ7Vo9LQcQ8fWRTnPoEbobOQBPqCBICaxxh3hjG7yAyPdRMXjoDkq68sxXoxWIO5mAEhytATKv2vIURLNjjsY4U+n+ypwM+UdnATKYKTDq5mT0gVcFYwD4Rp88KLzsn3UK9iY1QWjiUJif7wQHpXgxa991TM2/CfM2+dSdePlv1qDTS3ENL7h7FzrqzeFLrucolLcJOdVTQbSHb+CIHUiunG83YpY0IS3A0vZ32Y1AuzhMWFfhvuY2dK1gtRscBKQu0CPgdvtBfzNAntwm1M9bMj1Oz6pX51rubRcPrZpcxpVgnaZIBJXaE/keAm+/+p/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199018)(86362001)(76116006)(8676002)(4326008)(66946007)(71200400001)(122000001)(54906003)(316002)(110136005)(83380400001)(36756003)(26005)(2616005)(53546011)(6506007)(6512007)(186003)(38100700002)(38070700005)(7416002)(66556008)(41300700001)(478600001)(6486002)(2906002)(82960400001)(66476007)(8936002)(66446008)(5660300002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlZhOG5MUkVGeC9xWHF0SGM4cXk2ek8xakg2NGw4N2h2QWxkRTd1NWZldnpv?=
 =?utf-8?B?T2hmUnU3ckJvdk9GT1BxSjVQUkEzWUxFK1RoaHNxbk00QlNGUG9mVDAwTk1x?=
 =?utf-8?B?MmJZelRGMG1IR2k4RGwwbHZOWTFIS3RlL25mSHZ3NmxYY1AvTTZjaXhwWjZm?=
 =?utf-8?B?VGhYdm9rWWQrcWxsMGxyZ0ZUL1NvYmZLeHNwUHp1dzkranVyTG1EWkZPTzZM?=
 =?utf-8?B?eUdWQ29nb2Nud3dTUjhuNmpIc0I1NGxpcFhnV3N3UmhVdVRNQVNaaGNNREJJ?=
 =?utf-8?B?dDR0bnNHM3Z2QXVqdGpXaWlINVFwTS9xcmNlUkcxcFRJMmtjNmI3ejBTWG9Z?=
 =?utf-8?B?Q0F5SE9XclNrZW1DUk9kTk80RFEyNGFGRDlFZWladUFEK0FDRkUwaUEwWU5Z?=
 =?utf-8?B?bDgraFQvaVNRUEp4dnBrRWJnaW9hN2FibjdNeUQxLzJWdEhUeFhTYmoxSC9B?=
 =?utf-8?B?alZhTVBGVEhrN09kWUphTmk3RHdDRGZ0VjVoOHdoWHhtblJWWXNVdXBLeXBo?=
 =?utf-8?B?RzhoM2MvTjNBVEI2b3lCanYxZ1g0M0dNVm05Nitra1gzSU42bndtVlRMbXNF?=
 =?utf-8?B?RmZhZWNZY2NNOWIzTlBZSDVNZE1BN0FkNTlWVEdEb1p0RTR6TlYxUHFKSXhy?=
 =?utf-8?B?czNXMW9qUHd0UFUybURONStpeEM2YjFBWE9mNUNJUnJjR1krS0swbk5US2Uw?=
 =?utf-8?B?ZnVYM1YzUFJ5TEFKL1ZGREFKU1d5Sk51aTJMdjZIWlNHSDZITG9ScU9vUW5t?=
 =?utf-8?B?ZlhxanA3SXN0VW9VUVBHa2pwZVhMVDJvTkR6LzQxMER1dDZrUEthODd3YmND?=
 =?utf-8?B?R0ZXTDM0U2hUZDhIK3BSSkRVUnhtMGUyT2U1eStrbFNVemQvMUJqVjBkV3RH?=
 =?utf-8?B?Z0p2cVE3ZVNMSXVQaHl1OWYvbGRLUE8xYUZ3RnZTMGRHSWhsQnp0VXZJb0Vy?=
 =?utf-8?B?eVZUNktwNEVzMDJWeWpGTGJ3NGJFMnpmTDNwNEFBc0pYOHU3YUhWb2plRFlx?=
 =?utf-8?B?MmxUK0VzQ1BWcW80ZU1RNWYzVExreERScElvTnRhMjJiM2lYOXBNdy9TNnJX?=
 =?utf-8?B?eXlCRkJYaktQaFFaMURkbnViT05GQlpSVDNSeVpEbndTNC9PZDFrR3BUVWFR?=
 =?utf-8?B?YmpXY2Z3dDdhQXF0UUNQL1lMS1Z1d1p4WWF5S09zbUNCM05tcHlCbTJBYnIx?=
 =?utf-8?B?dXFGOTY4ZDFTMkw5TDBNeUI5V0tEYzRwQXJkTk96NUxpSFpZRVJwT0JGNFk2?=
 =?utf-8?B?WkpoUTNDSWhGazBsQm5BYnAvTDdkZlpFT3RrdklITlBrTHA4Z3RDcDNUc0RR?=
 =?utf-8?B?aDlHQUFpWkVpeWFvTEU3ZnFBTFJlN2k4Q29BaEszSWUrNm9MMUN0N0NwUlVj?=
 =?utf-8?B?WlpGS24rVWU5bm41b04zZFlldEpFNlpxRkdOTEpTL3d3WFlDMzNmdE9EQ29y?=
 =?utf-8?B?TFhzeUF6TzZHTFBlMUdoOXZDVnBWNk5zc2svRVdRL3N2cjFuUHVGdUY1RFo3?=
 =?utf-8?B?SUpnWUdra3RTbWVXWU1BOWt6OUI1aVgrdHpnaGZjOGhlaFQrcjlhck1yUzVh?=
 =?utf-8?B?SmtpdEtjVzZNTDMyR3VIeVZJMVBuRFVEajJRY3hiQnRaU2hyUU9jK1J1SDRW?=
 =?utf-8?B?c090T1pOcGM5VUdKRWRyRUVCTkQvQUxDMXdQOEN1d2ZVSDRWTWJNOU1HdnRR?=
 =?utf-8?B?R25ZUldqbVFYUUhac2NmQ0N3RTE2KzRWU1dKUklCNTJqUXN3dWtJaGhHemVM?=
 =?utf-8?B?QThvd3c1WUNzcHdzcGtCR0ZBREplc0h4QzYrdjZ3Wmt1NExKa0Y5b01VQkhR?=
 =?utf-8?B?RWpwajZpUVA4V3ZlSjhlamY4RG1EUW1td1NTNVB4VFpDajU0TDFXb3FMM1F1?=
 =?utf-8?B?UU1hY3dCTGpieCtLNFk1Q3VBcVgzNGZGU2dWZXAwNEhUUmtSM0VVVXdTdllv?=
 =?utf-8?B?cU1QcHpvaGd0QVJYa3o1bXZiNERxZFAvSDhZZE9QdGJUT1RGa2JQbjdpcHNr?=
 =?utf-8?B?YUZJK0p6d1NPUGtCdGhZOURSRU1uQjJHVExsYy95bEVXbldVK1lMUVBvSkVq?=
 =?utf-8?B?RDFsTmlsWTZ2em9acm1VbEJuT0Z5dVdEN3RLcDR4Ukt1SFJZVmRxUVByaTNs?=
 =?utf-8?B?RU0yMUUyNWkvUG9WMmhFVXE2WFppMzVNbFcrS09OVU5GbVJCbWpaam5sdDRo?=
 =?utf-8?B?L1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9407713BB449EA40BE82B740016A43E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff972c35-184b-480a-3a69-08db0e1c23d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 23:43:42.6213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2/BJke/8eOnYmxx0jxnkVeyCUdzqPTQ7W7V6QrGkLdX+p34YkFRT1+kFQp785bq59uMhD+xI76Yfisln8Po3dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6553
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

T24gTW9uLCAyMDIzLTAyLTEzIGF0IDE0OjI4IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMi8xMy8yMyAxMzoxMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBQZXJoYXBzIEkgZGlkbid0
IGV4cGxhaW4gY2xlYXJseSBpbiB0aGUgY29tbWVudC4gIEJlbG93IGlzIHRoZSB1cGRhdGVkIG9u
ZToNCj4gPiANCj4gPiAgICAgICAgICAgICAgICAgLyoNCj4gPiAgICAgICAgICAgICAgICAgICog
VGhlIHByZXZpb3VzIGNhbGwgb2YgX190ZHhfZW5hYmxlKCkgbWF5IG9ubHkgaGF2ZQ0KPiA+ICAg
ICAgICAgICAgICAgICAgKiBpbml0aWFsaXplZCBwYXJ0IG9mIHByZXNlbnQgY3B1cyBkdXJpbmcg
bW9kdWxlDQo+ID4gICAgICAgICAgICAgICAgICAqIGluaXRpYWxpemF0aW9uLCBhbmQgbmV3IGNw
dXMgbWF5IGhhdmUgYmVjb21lIG9ubGluZQ0KPiA+ICAgICAgICAgICAgICAgICAgKiBzaW5jZSB0
aGVuIHcvbyBkb2luZyBwZXItY3B1IGluaXRpYWxpemF0aW9uLg0KPiA+ICAgICAgICAgICAgICAg
ICAgKg0KPiA+ICAgICAgICAgICAgICAgICAgKiBGb3IgZXhhbXBsZSwgYSBuZXcgQ1BVIGNhbiBi
ZWNvbWUgb25saW5lIHdoZW4gS1ZNIGlzDQo+ID4gICAgICAgICAgICAgICAgICAqIHVubG9hZGVk
LCBpbiB3aGljaCBjYXNlIHRkeF9jcHVfZW5hYmxlKCkgaXMgbm90IGNhbGxlZCBzaW5jZQ0KPiA+
ICAgICAgICAgICAgICAgICAgKiBLVk0ncyBDUFUgb25saW5lIGNhbGxiYWNrIGhhcyBiZWVuIHJl
bW92ZWQuDQo+ID4gICAgICAgICAgICAgICAgICAqDQo+ID4gICAgICAgICAgICAgICAgICAqIFRv
IG1ha2Ugc3VyZSBhbGwgb25saW5lIGNwdXMgYXJlIFREWC1ydW5uYWJsZSwgYWx3YXlzDQo+ID4g
ICAgICAgICAgICAgICAgICAqIGRvIHBlci1jcHUgaW5pdGlhbGl6YXRpb24gZm9yIGFsbCBvbmxp
bmUgY3B1cyBoZXJlDQo+ID4gICAgICAgICAgICAgICAgICAqIGV2ZW4gdGhlIG1vZHVsZSBoYXMg
YmVlbiBpbml0aWFsaXplZC4NCj4gPiAgICAgICAgICAgICAgICAgICovDQo+IA0KPiBUaGlzIGlz
IHZvb2Rvby4NCj4gDQo+IEkgd2FudCBhIFREWC1zcGVjaWZpYyBob3RwbHVnIENQVSBoYW5kbGVy
LiAgUGVyaW9kLiAgUGxlYXNlIG1ha2UgdGhhdA0KPiBoYXBwZW4uIMKgDQo+IA0KDQpZZXMgMTAw
JSBhZ3JlZWQuDQoNCj4gUHV0IHRoYXQgY29kZSBpbiB0aGlzIHBhdGNoLiAgVGhhdCBoYW5kbGVy
IHNob3VsZDoNCj4gDQo+IAkxLiBSdW4gYWZ0ZXIgdGhlIEtWTSBoYW5kbGVyIChpZiBwcmVzZW50
KQ0KPiAJMi4gU2VlIGlmIFZNWCBpcyBvbg0KPiAJMy4gSWYgVk1YIGlzIG9uOg0KPiAJIDNhLiBS
dW4gc21wX2Z1bmNfbW9kdWxlX2xwX2luaXQoKSwgZWxzZQ0KPiAJIDNiLiBNYXJrIHRoZSBDUFUg
YXMgbmVlZGluZyBzbXBfZnVuY19tb2R1bGVfbHBfaW5pdCgpDQo+IA0KPiBUaGVuLCBpbiB0aGUg
J2Nhc2UgVERYX01PRFVMRV9JTklUSUFMSVpFRDonLCB5b3UgY2FsbCBhIGZ1bmN0aW9uIHRvDQo+
IGl0ZXJhdGUgb3ZlciB0aGUgY3B1bWFzayB0aGF0IHdhcyBnZW5lcmF0ZWQgaW4gM2IuDQo+IA0K
PiBUaGF0IG1ha2VzIHRoZSBoYW5kb2ZmICpFWFBMSUNJVCouICBZb3Uga25vdyBleGFjdGx5IHdo
aWNoIENQVXMgbmVlZA0KPiB3aGF0IGRvbmUgdG8gdGhlbS4gIEEgQ1BVIGhvdHBsdWcgZWl0aGVy
IGV4cGxpY2l0bHkgaW52b2x2ZXMgZG9pbmcgdGhlDQo+IHdvcmsgdG8gbWFrZSBURFggd29yayBv
biB0aGUgQ1BVLCBvciBleHBsaWNpdGx5IGRlZmVycyB0aGUgd29yayB0byBhDQo+IHNwZWNpZmlj
IGxhdGVyIHRpbWUgaW4gYSBzcGVjaWZpYyBsYXRlciBwaWVjZSBvZiBjb2RlLg0KDQpJbiAzYi4g
d2UgZG9uJ3QgbmVlZCB0byAiZXhwbGljaXRseSBtYXJrIHRoZSAgQ1BVIGFzIG5lZWRpbmcNCnNt
cF9mdW5jX21vZHVsZV9scF9pbml0KCkiLiAgV2UgYWxyZWFkeSBoYXZlIF9fY3B1X3RkeF9tYXNr
IHRvIHRyYWNrIHdoZXRoZXINCkxQLklOSVQgaGFzIGJlZW4gZG9uZSBvbiBvbmUgY3B1IGFuZCB3
ZSBjYW4gdXNlIHRoYXQgdG8gZGV0ZXJtaW5lOg0KDQoJQW55IG9ubGluZSBjcHUgd2hpY2ggaXNu
J3Qgc2V0IGluIF9fY3B1X3RkeF9tYXNrIG5lZWRzIHRvIGRvIExQLklOSVQgaW4NCgl0ZHhfZW5h
YmxlKCkuDQoNCkFuZCB0aGUgZnVuY3Rpb24gbW9kdWxlX2xwX2luaXRfb25saW5lX2NwdXMoKSBh
bHJlYWR5IGhhbmRsZXMgdGhhdCwgYW5kIGl0IGNhbg0KYmUgY2FsbGVkIGRpcmVjdGx5IGluIHRk
eF9lbmFibGUoKSBwYXRoIChhcyBzaG93biBpbiB0aGlzIHBhdGNoKS4NCg0KSSdsbCBkbyBhYm92
ZSBhcyB5b3Ugc3VnZ2VzdGVkLCBidXQganVzdCB1c2UgX19jcHVfdGR4X21hc2sgYXMgZXhwbGFp
bmVkIGFib3ZlLg0KDQooIE15IG1haW4gY29uY2VybiBpcyAiUnVuIGFmdGVyIHRoZSBLVk0gaGFu
ZGxlciIgc2VlbXMgYSBsaXR0bGUgYml0IGhhY2t5IHRvIG1lLg0KTG9naWNhbGx5LCBpdCdzIG1v
cmUgcmVhc29uYWJsZSB0byBoYXZlIHRoZSBURFggY2FsbGJhY2sgX2JlZm9yZV8gS1ZNJ3MgYnV0
IG5vdA0KX2FmdGVyXy4gIElmIGFueSB1c2VyIChLVk0pIGhhcyBkb25lIHRkeF9lbmFibGUoKSBz
dWNjZXNzZnVsbHksIHRoZSBURFggY29kZQ0Kc2hvdWxkIGdpdmUgdGhlIHVzZXIgYSAiVERYLXJ1
bm5hYmxlIiBjcHUgYmVmb3JlIHVzZXIgKEtWTSkncyBvd24gY2FsbGJhY2sgaXMNCmludm9sdmVk
LiBBbnl3YXkgYXMgbWVudGlvbmVkIGFib3ZlLCBJJ2xsIGRvIGFib3ZlIGFzIHlvdSBzdWdnZXN0
ZWQuKQ0K
