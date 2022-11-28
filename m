Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6202C63A560
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 10:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiK1JuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 04:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiK1JuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 04:50:13 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002EB192AA;
        Mon, 28 Nov 2022 01:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669629013; x=1701165013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=terZEYg84psFFK041r6Fmf7MDz6RvqmDADHm33BoYA0=;
  b=Uz78e9N+EhFDJgFuB0/t5QhByAhE5MwUPw6UXclkGytlWacpuzJR2vlL
   m9EIV6lUkS+FnG5syKLbyc7qzDjIQjA/3MGoHmkf1nu0yBeeuMk8Xy+AD
   8Ir9Vp9TYXQMc3AcW7jmE7PyvTWrpDD5m2VeDj1sC4ao36HLguORnWtZ5
   419S0xonxTMUGfwUFlBXSjPEtkwRN/G3tXimptrK2MgFhBEKRddPUvAEG
   REvShH2I3TDccuPQpPZaRtysJRDdqz8TbjwpLhdwvLwvwlUh8Rf9NmAGo
   Ne6FQ9IoZhZnHanbcbUzmlfESdHtpwLA+W2GF0zpoyYmgXJSgWVa026WC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="295177630"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="295177630"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 01:50:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="785565510"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="785565510"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 28 Nov 2022 01:50:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:50:11 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 01:50:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 01:50:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqKawr6z/qa7NnM2mBf2FO2qeC9I/oUnGccU3KM29FKFmaPTydx1XqdYVZQNihmyJrs+t77cP3fhPYkyOR+s4lc1CZVpHlwq0II88MgpDT6+Hq9g/Q67ztyo3s0n9squeJHk8VQ9v2cicAi3BQ9Cy0KY1CL59M2ZaI4m+qzNJSdjf8+0blXU5Y3IYorLg2jila3ucXU7Y2QcCMQ84D/jrr4gR88VAwD0YYvlIO9gmgD2tQYuFkp9Ott27ZuLd1/2CGcdPDHFag5De6RDtPB5YevWFHMzvYkv9lnXnaZHL+ctZTF2LK14HS3kAAqsni+gvCUwyiA/YEVkTCcWUKx4GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=terZEYg84psFFK041r6Fmf7MDz6RvqmDADHm33BoYA0=;
 b=IlG4Hon5WXWDvbDRLr12jpjc05UONFPj0z5Ep9YFDMQ0NsVko0XxGodUBlAxqmL6UCvF0ItUuQRV3jCW7DgHoQKIR/EszxGmT+996jgtfCAFH1pHc6lTYxoNWwAz4TzKaOFSFP+RjZkUXL4FzdO90T9uNX29l4vf6PXxfQmBkJ4pQFeGfIEYsAwLQ9fb2QA+18V+Hine7gAQ8vxr5tf6GFJnVFWn/GiMFtJ8wTi9CSjRffoYMrdax/wi/9HIl0V38sm9TzJdCWZX07ywm8Drb14Pmn9Zq01w7l+KnMZ4xpi2umHF8Q49mdVuIJ16a3qJ87Sg+CH5hn1bBEwWBJXrXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5971.namprd11.prod.outlook.com (2603:10b6:8:5e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 09:50:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 09:50:06 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHY/T3KCI/2IUKL7kSgXbHXnV3Az65NU9CAgAB5pwCAAZiKgIAEqQwAgAABUwCAAAqdgIAAAY6AgAAGegA=
Date:   Mon, 28 Nov 2022 09:50:06 +0000
Message-ID: <a1bf84d6e066c94dfb6d3ad38e1f658018233268.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
         <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
         <8e8f72ad5d7a3d09be32bee54e4ebb9c280610a2.camel@intel.com>
         <361875cb-e4b3-a46f-b275-6d87a98ce966@redhat.com>
         <397ebe70bf9cede731f2f8bbd05e0df518fd3a22.camel@intel.com>
         <49ab9f26-9e23-25ab-71b4-e666c70ff77e@redhat.com>
         <8300f1098aa8fbfae711313be41ee44cb1203d62.camel@intel.com>
         <ace4f538-77e4-964e-5c71-ff09f208689b@redhat.com>
In-Reply-To: <ace4f538-77e4-964e-5c71-ff09f208689b@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5971:EE_
x-ms-office365-filtering-correlation-id: ed540fe2-7cb1-41b7-1936-08dad125ee41
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G896+503jhuuHKLvc0LeB08xo1G5WFgjotrqKsTrw8+9lbXNBhHHs5baujg2FZ0YZq4KxmuJUXkG7BCACdfi23929Qiyyjg20b1H6cGPuGm2/nERZb1EjqG3vZsaJARN2/8e4hpbkb54k6jXedM6dBaTEzkR2bFCUb0SvyQFu7Z/BrpC8zoVYi7X+PiJexHOVgRAl4OtrLVPH/fWRe4pks0UzQOM8vHF0QS1IxxvgbApf7JfywRSZ+rEriaWUlkeq9/9vPEoPmRwiLkmhc+kZkIRniUNbkM4HRbp6AvE0vsAHcUjWFsYe/JByyHBtyH6znMQ9NPXPO+MSMwsdSFOnaVdL77Pl1erqL5M6jjcJCuBCy1/f646OucXEJKE8/walT99XS7RZVi1T9a2AsjqUorgc8i9MhNh0IBDKqc2RKT4lAKG928176WEWAJoBBTZEIot23ci883UtXt94qaD57v2FWMOHPcu9UtaEP1JNwFQG72vKZxo/uLjbJ8oSzBT+eoKl37/LjNX+OcCa4VJS+8rPSJjInCIbUWg11hhjq8js+Uy3XgL22JbAo3pn1OyUrJwEToIUNo42bado87Uxmuzv84sd0Kgiacu7RxOi4aQB6mPFOiUoQAd422SsPArSI6FYjl5I27EHsnjyeURMP9aO63FDKwh9kRYCjtrBNPQISDjBXJfzmGPcbXlgzEeBRV0oCXB//EmbojiPec+Qw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199015)(71200400001)(26005)(6512007)(54906003)(36756003)(53546011)(316002)(6506007)(110136005)(122000001)(38100700002)(82960400001)(4001150100001)(2906002)(83380400001)(4326008)(8676002)(66556008)(66446008)(66946007)(66476007)(76116006)(64756008)(86362001)(91956017)(5660300002)(8936002)(2616005)(7416002)(41300700001)(186003)(38070700005)(6486002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NU9ONXFTZCs3SGZ0RXA4N2lneTNBU3ptZXo0TlBBSW5OZGxZakcwT0p4ZHZ5?=
 =?utf-8?B?cWcwb2d1MEF2YXhTMldWUVdZT29ZUWRucytkY0pjcFRaWW9ITUhPNlMvSm84?=
 =?utf-8?B?RWJUUVVIUll6VGM3QUpmaVNMT1ZSald2cmlZN3h6UUNpTU12cXdBeHI5VVk1?=
 =?utf-8?B?bjFac0pPcC9COEhUbUpDVVNlSHE3d25SYmJnTFE2d3FRS2djdFo1Yjlwdml3?=
 =?utf-8?B?M0lhaENsOHJ1YjFKeXdvOFpyNkRQdGpINlcxbHlxNUlRWWNhSWVDbVFKWFlG?=
 =?utf-8?B?Mzc2NTFCSkt5WjdGdFhtZy9PSXhDSnNuL2VnRVZwTlUzQ0RxcUI4UTNYdXlR?=
 =?utf-8?B?QU5UajlKZ3N4LyswYjIwRmJXSHkydkk5STdNN2JyWWlBdlpVZkQxeTRWeGlN?=
 =?utf-8?B?VWJMZnhJVzNnSXFib1hURjJkRU1Ma2tsdytaTElNZmpGZ0dpN3JHN1huSmZN?=
 =?utf-8?B?eUVyd2lQZCtoNHJuc3BUZ1VEeUt3eGJJcmV6NjZkRGFYYnAvZE9FeG9qUCtT?=
 =?utf-8?B?Nm1pdWJ4N2REb2kvSTYvM25DbWxqR2dxUXR3SnpFbkVVYjljTGxBYS96Nlk3?=
 =?utf-8?B?SEV1UkZVTzVGOG43K00vcmNjMHNmZFo4VHd4TkNRalBuTkZQWCtSQ1V2WUxx?=
 =?utf-8?B?cHRpVTNEaTBLQzRqRERUTk5qLysvbVBhUSs4akFFQnZlc2tuSGpiZlBrM2xB?=
 =?utf-8?B?TFRjT2txV3Y0Y3Q5UU03NlhsOC9GQllWTkhxYjJTNUwvenVXeWJJRTl1NFll?=
 =?utf-8?B?UzNub2VrZVluU0tmMjZJaGdVT2kyN0ZTYWdjRndObFdSZ2Mrbm5VOTBXK09J?=
 =?utf-8?B?RmJLNnp3Mk5uNnpNTHNYOVB6YzFobndNOGRYTjlKbWw2QnBLbk1UZlR4NVAx?=
 =?utf-8?B?eEd5ZnBMWEdJc0EvdzM0YWVPRWk4dWFJblNKVXBBczczRFFtZXpUL3ZPYXow?=
 =?utf-8?B?TUJ5ekhEL1JITHMxQXlXM002VE1OM0tLenZkN2YySm9oUTgwNTJ4WmRZMTVH?=
 =?utf-8?B?UTNqblNSUTZLVUhkd2crTitlc1FjbzY2ZzExNjBLSEJpRW1kcXJoRDZUdkUz?=
 =?utf-8?B?NUZkODNXeWdSbUlxcG5EaFhTOXhmcEV3cU0rWlN3c1A2Rk1KYTVZZFJQMjZm?=
 =?utf-8?B?ZDAzNlJSOXJTa0FvTWc4aWgyT2JoVlNrWjVmNXJXZkhoRk5McmpUU1MwZjBT?=
 =?utf-8?B?VFRLSzIvaXl3bUpZLy9qcmlwY3d3VHYraEtpd1lnYm5nTnZ6YmZvOEhVdTF5?=
 =?utf-8?B?NW5TZkNtSnVUVXhYclF4eDBOa2JWRk5DRG1tS2kwcG1RU29kK0FlVXhsRVpC?=
 =?utf-8?B?dWsxT0hTeFAvODlINVZ6emF0UFh1WXArSm1reFRSbmJJMld5Wjdhb2pPKysz?=
 =?utf-8?B?cGppOW9NUmd2d1JYTjdMY1dSRzlOUURBbVc5T2Q1TnUwZ3RWZ0hSSS9ZY05j?=
 =?utf-8?B?SWxDRUIxdEFFTzF3b3ptVzVqYnRPTUgvOTNEU1NNQ1lWdXFzdjJVQnkrYStB?=
 =?utf-8?B?ZitKL0F4czNwV1BTVW5SNnlUOVREOURZcmRDZDBhQ01FYmNweUNGckRGa0hO?=
 =?utf-8?B?MTlrQm9QZUV6aE84QjU5ZFhlMmVaYnM1V2cwVVNmT3cydU9oT1NmOVFaNVI0?=
 =?utf-8?B?ZnhqK0kzRDZEWG9tNDJiNk10RDVaeWs5Z1ZoZW1KL0pBOUNDVzJxS0M3RzVU?=
 =?utf-8?B?N2J6eTJBM0cwU1BLWEtEaFB5NktNSzIvZitMS2tsU0lQQ3lHRUhjcUZXY0o3?=
 =?utf-8?B?c0oybUtlenBDdzdNVFdVZ2dEUWJja21UcUFjU1lXSGREZi80UnZPYWpaT0Q3?=
 =?utf-8?B?WExvbXdjZjBCVTgzMzFyY1duU0Rta3hRZWhYS0ZDdE83a0hSdEwzVjloSkg3?=
 =?utf-8?B?Vk9jU1p4NEpoSng0dFZWYkV2bU1DazRzSWhlRVFKQU81V0hFbnlNMXBUUWJy?=
 =?utf-8?B?cHY4SUozTEFRNnpWTXpsd3U1Sm05UXg0SmxoTTJhaWNEK2F4di9ydUU1Y2da?=
 =?utf-8?B?YVpwNmpUVENYdHF0cDBSazlGdGVqMGM2S2IwNmZaNXdhUUJzbFRTSFpXdDBU?=
 =?utf-8?B?REUxUkZjMWwwNnA3RzdBNFduK1Q0c0tHb0FlS0NNaXgwTGQ4akJ5U3ptbE93?=
 =?utf-8?B?RnlCVjlON2ZybDdOZFQ0L3FSOVRvcHdlQXNzdW41WVRnVUJBdXJLS2ZrVzhI?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D395FDE372B93140A51D368B77E4F99A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed540fe2-7cb1-41b7-1936-08dad125ee41
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 09:50:06.7116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JGF9cdjetkLZs0/y1qEw/H3B9lC6p3PrhwVCnjn/5md3VjIIjVC4gNT0rWWwr4sP0gncan7PaeMr8neg8AcvCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5971
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTI4IGF0IDEwOjI2ICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMjguMTEuMjIgMTA6MjEsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gTW9uLCAy
MDIyLTExLTI4IGF0IDA5OjQzICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90ZToNCj4gPiA+
IE9uIDI4LjExLjIyIDA5OjM4LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiBPbiBGcmksIDIw
MjItMTEtMjUgYXQgMTA6MjggKzAxMDAsIERhdmlkIEhpbGRlbmJyYW5kIHdyb3RlOg0KPiA+ID4g
PiA+IE9uIDI0LjExLjIyIDEwOjA2LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiA+ID4gT24g
V2VkLCAyMDIyLTExLTIzIGF0IDE3OjUwIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+ID4g
PiA+ID4gPiA+ID4gICAgICANCj4gPiA+ID4gPiA+ID4gPiBAQCAtOTY4LDYgKzk2OSwxNSBAQCBp
bnQgYXJjaF9hZGRfbWVtb3J5KGludCBuaWQsIHU2NCBzdGFydCwgdTY0IHNpemUsDQo+ID4gPiA+
ID4gPiA+ID4gICAgwqDCoAl1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiA9IHN0YXJ0ID4+IFBBR0Vf
U0hJRlQ7DQo+ID4gPiA+ID4gPiA+ID4gICAgwqDCoAl1bnNpZ25lZCBsb25nIG5yX3BhZ2VzID0g
c2l6ZSA+PiBQQUdFX1NISUZUOw0KPiA+ID4gPiA+ID4gPiA+ICAgICAgDQo+ID4gPiA+ID4gPiA+
ID4gKwkvKg0KPiA+ID4gPiA+ID4gPiA+ICsJICogRm9yIG5vdyBpZiBURFggaXMgZW5hYmxlZCwg
YWxsIHBhZ2VzIGluIHRoZSBwYWdlIGFsbG9jYXRvcg0KPiA+ID4gPiA+ID4gPiA+ICsJICogbXVz
dCBiZSBURFggbWVtb3J5LCB3aGljaCBpcyBhIGZpeGVkIHNldCBvZiBtZW1vcnkgcmVnaW9ucw0K
PiA+ID4gPiA+ID4gPiA+ICsJICogdGhhdCBhcmUgcGFzc2VkIHRvIHRoZSBURFggbW9kdWxlLsKg
IFJlamVjdCB0aGUgbmV3IHJlZ2lvbg0KPiA+ID4gPiA+ID4gPiA+ICsJICogaWYgaXQgaXMgbm90
IFREWCBtZW1vcnkgdG8gZ3VhcmFudGVlIGFib3ZlIGlzIHRydWUuDQo+ID4gPiA+ID4gPiA+ID4g
KwkgKi8NCj4gPiA+ID4gPiA+ID4gPiArCWlmICghdGR4X2NjX21lbW9yeV9jb21wYXRpYmxlKHN0
YXJ0X3Bmbiwgc3RhcnRfcGZuICsgbnJfcGFnZXMpKQ0KPiA+ID4gPiA+ID4gPiA+ICsJCXJldHVy
biAtRUlOVkFMOw0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gYXJjaF9hZGRfbWVtb3J5
KCkgZG9lcyBub3QgYWRkIG1lbW9yeSB0byB0aGUgcGFnZSBhbGxvY2F0b3IuwqAgRm9yDQo+ID4g
PiA+ID4gPiA+IGV4YW1wbGUsIG1lbXJlbWFwX3BhZ2VzKCkgdXNlcyBhcmNoX2FkZF9tZW1vcnko
KSBhbmQgZXhwbGljaXRseSBkb2VzIG5vdA0KPiA+ID4gPiA+ID4gPiByZWxlYXNlIHRoZSBtZW1v
cnkgdG8gdGhlIHBhZ2UgYWxsb2NhdG9yLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJbmRl
ZWQuICBTb3JyeSBJIG1pc3NlZCB0aGlzLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IFRo
aXMgY2hlY2sgYmVsb25ncyBpbg0KPiA+ID4gPiA+ID4gPiBhZGRfbWVtb3J5X3Jlc291cmNlKCkg
dG8gcHJldmVudCBuZXcgbWVtb3J5IHRoYXQgdmlvbGF0ZXMgVERYIGZyb20gYmVpbmcNCj4gPiA+
ID4gPiA+ID4gb25saW5lZC4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gVGhpcyB3b3VsZCBy
ZXF1aXJlIGFkZGluZyBhbm90aGVyICdhcmNoX2NjX21lbW9yeV9jb21wYXRpYmxlKCknIHRvIHRo
ZSBjb21tb24NCj4gPiA+ID4gPiA+IGFkZF9tZW1vcnlfcmVzb3VyY2UoKSAoSSBhY3R1YWxseSBs
b25nIHRpbWUgYWdvIGhhZCBzdWNoIHBhdGNoIHRvIHdvcmsgd2l0aCB0aGUNCj4gPiA+ID4gPiA+
IG1lbXJlbWFwX3BhZ2VzKCkgeW91IG1lbnRpb25lZCBhYm92ZSkuDQo+ID4gPiA+ID4gPiANCj4g
PiA+ID4gPiA+IEhvdyBhYm91dCBhZGRpbmcgYSBtZW1vcnlfbm90aWZpZXIgdG8gdGhlIFREWCBj
b2RlLCBhbmQgcmVqZWN0IG9ubGluZSBvZiBURFgNCj4gPiA+ID4gPiA+IGluY29tcGF0aWJsZSBt
ZW1vcnkgKHNvbWV0aGluZyBsaWtlIGJlbG93KT8gIFRoZSBiZW5lZml0IGlzIHRoaXMgaXMgVERY
IGNvZGUNCj4gPiA+ID4gPiA+IHNlbGYgY29udGFpbmVkIGFuZCB3b24ndCBwb2xsdXRlIHRoZSBj
b21tb24gbW0gY29kZToNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gK3N0YXRpYyBpbnQgdGR4
X21lbW9yeV9ub3RpZmllcihzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLA0KPiA+ID4gPiA+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgYWN0aW9uLCB2b2lk
ICp2KQ0KPiA+ID4gPiA+ID4gK3sNCj4gPiA+ID4gPiA+ICsgICAgICAgc3RydWN0IG1lbW9yeV9u
b3RpZnkgKm1uID0gdjsNCj4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICsgICAgICAgaWYgKGFj
dGlvbiAhPSBNRU1fR09JTkdfT05MSU5FKQ0KPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgIHJl
dHVybiBOT1RJRllfT0s7DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArICAgICAgIC8qDQo+
ID4gPiA+ID4gPiArICAgICAgICAqIE5vdCBhbGwgbWVtb3J5IGlzIGNvbXBhdGlibGUgd2l0aCBU
RFguICBSZWplY3QNCj4gPiA+ID4gPiA+ICsgICAgICAgICogb25saW5lIG9mIGFueSBpbmNvbXBh
dGlibGUgbWVtb3J5Lg0KPiA+ID4gPiA+ID4gKyAgICAgICAgKi8NCj4gPiA+ID4gPiA+ICsgICAg
ICAgcmV0dXJuIHRkeF9jY19tZW1vcnlfY29tcGF0aWJsZShtbi0+c3RhcnRfcGZuLA0KPiA+ID4g
PiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgbW4tPnN0YXJ0X3BmbiArIG1uLT5ucl9wYWdl
cykgPyBOT1RJRllfT0sgOiBOT1RJRllfQkFEOw0KPiA+ID4gPiA+ID4gK30NCj4gPiA+ID4gPiA+
ICsNCj4gPiA+ID4gPiA+ICtzdGF0aWMgc3RydWN0IG5vdGlmaWVyX2Jsb2NrIHRkeF9tZW1vcnlf
bmIgPSB7DQo+ID4gPiA+ID4gPiArICAgICAgIC5ub3RpZmllcl9jYWxsID0gdGR4X21lbW9yeV9u
b3RpZmllciwNCj4gPiA+ID4gPiA+ICt9Ow0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFdpdGggbWhw
X21lbW1hcF9vbl9tZW1vcnkoKSBzb21lIG1lbW9yeSBtaWdodCBhbHJlYWR5IGJlIHRvdWNoZWQg
ZHVyaW5nDQo+ID4gPiA+ID4gYWRkX21lbW9yeSgpIChiZWNhdXNlIHBhcnQgb2YgdGhlIGhvdHBs
dWcgbWVtb3J5IGlzIHVzZWQgZm9yIGhvbGRpbmcgdGhlDQo+ID4gPiA+ID4gbWVtbWFwKSwgbm90
IHdoZW4gYWN0dWFsbHkgb25saW5pbmcgbWVtb3J5LiBTbyBpbiB0aGF0IGNhc2UsIHRoaXMgd291
bGQNCj4gPiA+ID4gPiBiZSB0b28gbGF0ZS4NCj4gPiA+ID4gDQo+ID4gPiA+IEhpIERhdmlkLA0K
PiA+ID4gPiANCj4gPiA+ID4gVGhhbmtzIGZvciB0aGUgcmV2aWV3IQ0KPiA+ID4gPiANCj4gPiA+
ID4gUmlnaHQuIFRoZSBtZW1tYXAgcGFnZXMgYXJlIGFkZGVkIHRvIHRoZSB6b25lIGJlZm9yZSBv
bmxpbmVfcGFnZXMoKSwgYnV0IElJVUMNCj4gPiA+ID4gdGhvc2UgbWVtbWFwIHBhZ2VzIHdpbGwg
bmV2ZXIgYmUgZnJlZSBwYWdlcyB0aHVzIHdvbid0IGJlIGFsbG9jYXRlZCBieSB0aGUgcGFnZQ0K
PiA+ID4gPiBhbGxvY2F0b3IsIGNvcnJlY3Q/ICBUaGVyZWZvcmUgaW4gcHJhY3RpY2UgdGhlcmUg
d29uJ3QgYmUgcHJvYmxlbSBldmVuIHRoZXkgYXJlDQo+ID4gPiA+IG5vdCBURFggY29tcGF0aWJs
ZSBtZW1vcnkuDQo+ID4gPiANCj4gPiA+IEJ1dCB0aGF0IG1lbW9yeSB3aWxsIGJlIHJlYWQvd3Jp
dHRlbi4gSXNuJ3QgdGhhdCBhbiBpc3N1ZSwgZm9yIGV4YW1wbGUsDQo+ID4gPiBpZiBtZW1vcnkg
ZG9lc24ndCBnZXQgYWNjZXB0ZWQgZXRjPw0KPiA+ID4gDQo+ID4gDQo+ID4gU29ycnkgSSBkb24n
dCBxdWl0ZSB1bmRlcnN0YW5kICJpZiBtZW1vcnkgZG9lc24ndCBnZXQgYWNjZXB0ZWQiIG1lYW4u
ICBEbyB5b3UNCj4gPiBtZWFuIGFjY2VwdGVkIGJ5IHRoZSBURFggbW9kdWxlPw0KPiA+IA0KPiA+
IE9ubHkgdGhlIGhvc3Qga2VybmVsIHdpbGwgcmVhZC93cml0ZSB0aG9zZSBtZW1tYXAgcGFnZXMu
ICBUaGUgVERYIG1vZHVsZSB3b24ndA0KPiA+IChhcyB0aGV5IHdvbid0IGJlIGFsbG9jYXRlZCB0
byBiZSB1c2VkIGFzIFREWCBndWVzdCBtZW1vcnkgb3IgVERYIG1vZHVsZQ0KPiA+IG1ldGFkYXRh
KS4gIFNvIGl0J3MgZmluZS4NCj4gDQo+IE9oLCBzbyB3ZSdyZSBub3QgYWxzbyBjb25zaWRlcmlu
ZyBob3RwbHVnZ2luZyBtZW1vcnkgdG8gYSBURFggVk0gdGhhdCANCj4gbWlnaHQgbm90IGJlIGJh
Y2tlZCBieSBURFguIEdvdCBpdC4NCj4gDQo+IFNvIHdoYXQgeW91IHdhbnQgdG8gcHJldmVudCBp
cyBnZXR0aW5nICFURFggbWVtb3J5IGV4cG9zZWQgdG8gdGhlIGJ1ZGR5IA0KPiBzdWNoIHRoYXQg
aXQgd29uJ3QgYWNjaWRlbnRhbGx5IGdldCBhbGxvY2F0ZWQgZm9yIGEgVERYIGd1ZXN0LCBjb3Jy
ZWN0Pw0KDQpZZXMgY29ycmVjdC4NCg0KPiANCj4gSW4gdGhhdCBjYXNlLCBtZW1vcnkgbm90aWZp
ZXJzIHdvdWxkIGluZGVlZCBiZSBmaW5lLg0KPiANCj4gVGhhbmtzIQ0KPiANCg0KVGhhbmtzLg0K
