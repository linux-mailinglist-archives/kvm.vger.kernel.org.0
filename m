Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F384C7A8A82
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 19:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjITRYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 13:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjITRYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 13:24:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D3FAF;
        Wed, 20 Sep 2023 10:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695230641; x=1726766641;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iKoow6Tdt+p1gT55GuUjOKUy4B07DzdExnBYDMgYgu0=;
  b=b8/WRUNfcDgHCesFj5SJoH3wWvTnE98NoM78eTIyGNLlZh589UxeGsvJ
   /nb88/wke42+fcLFTxNfLsi8NJkETH266vuwaS5G3MOrfLKLw/PqtSEca
   0hMwF4Kwz4IkS96HQwuhOJVZjCHGoEr7oiTfS5pkoDuj6QmSEFqBtnAmN
   bjzpyVJI8IudatjZ5OTws3KecMuJEyIO41Mzw1VsXKojAmqaQOn9lh1F0
   gSK70IwCHZTyY0i2tbjWLe8R0BkPCc8vytN0BoWEvBBBMmUpu7B+442Az
   RofyQnTk9yW0t8ctoQCjOHv2FydgwxobnEjnL7NjQtS+3Ez6/V2hxR3fQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="379174619"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="379174619"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 10:24:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="890017227"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="890017227"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Sep 2023 10:23:11 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 10:23:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 20 Sep 2023 10:23:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 20 Sep 2023 10:23:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nABNNYOjCg3uNj+88AiNEhMRcKlSJYOoeIqKo1n9YqKejbfm7bEpX+tBpFXiwuUEF6H2fl08LLaL/kPPzIMeNjRmgNRes49XAVeqmGhiD8gwKgvFUzhHJxvWCAXbbEry2xD2v3kQl53j/85AlCZALhldnNzgOVl7R7PQmG36wAKOjeK7d5GvwBZ6FtaPseNb8Nn7OkZOONl+4ljItVey6GbFsFXMqEqZJw+LXdNf45U8hSyWF4+VXNJMGeMNheUbpJzd63QKI18JxgRlrwkHPTCWqRJJKmn0fQz7H/SFRcrez4aVBitdpp2R0vuUZggrF0MLgc6RGYCXx5EwAeCKmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKoow6Tdt+p1gT55GuUjOKUy4B07DzdExnBYDMgYgu0=;
 b=c3TwP56a5c2BnPWnkp1tNKYFtb3KeoVteRFtzUeJEa0wxDLZ1aoHVKjqIaN8uC8Gnqs/s2iHZ3Wi8wLvTU5mQ2KCxxVSXEgM/em9+Pc6by8J0kKAzVctKd7pUScW4zUdy4WXiCTpOdBxUrHiZ+v/LoHkVENAfQ7KUAyLP/VNHW4JUXv0Qk0TypfLbMhgFe04JB6CQm5Ptn7xEAb3TcuEAMAsythB1zfnzY50ya60I7VvzEmcvMVZRha5TGZWCaksBU6boAO5TcpEcPGJ1c9kkNEgVWHG3RrptOQ/XFXPM/sRk58kzDyittJFHDZZf5gURJeGoV5wBfLj6AdVXM/CLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH3PR11MB7179.namprd11.prod.outlook.com (2603:10b6:610:142::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Wed, 20 Sep
 2023 17:23:48 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%5]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 17:23:48 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Nikolay Borisov <nik.borisov@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 16/38] x86/ptrace: Add FRED additional information to
 the pt_regs structure
Thread-Topic: [PATCH v10 16/38] x86/ptrace: Add FRED additional information to
 the pt_regs structure
Thread-Index: AQHZ5ss6vttMEsm+OUmXJJK/yPurx7AjtmQAgABJenA=
Date:   Wed, 20 Sep 2023 17:23:48 +0000
Message-ID: <SA1PR11MB6734182B172E9204CD11688CA8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-17-xin3.li@intel.com>
 <336f77d6-1d94-d2b7-f429-855bfbc3f271@suse.com>
In-Reply-To: <336f77d6-1d94-d2b7-f429-855bfbc3f271@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH3PR11MB7179:EE_
x-ms-office365-filtering-correlation-id: d56e26c8-a579-40b4-7b08-08dbb9fe59cc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rrrZeJhRf65aUKIytRbmdcJ6B43Uvoz3LCi2sGJiiDBaB9F7hZ83ZdGPQ+V8GLGFGWHR6zVfrtoi9WSpKWrieFByFOeXPYrYYO3rFEyieQC2ueSHYpDnKiErLOJT/Lezr6MfWkFlSISGYtXHj6c0FlY5kwbwrkeGxTBTA3HgaHZfeuIAQq8GpMnUdkGMS+fwuYcrOgdqf7DlBCXmY/i0Wv8XjzTFqRIyNuzxRpvEl2LTQ1myCkMKeyCg5mUbm6rVjt25b+wVR7NYEbVbZgKGdDiEx2teU4wnj7jl6ut8J+NCPWXAxUUCcWVydeG48JQrsMpaHPHsDq3wH01/zp2mG6fB7UubtcxHxVo7hp9nheZFXCmo7EMQ6A+nZboQMCrYCc2vSc3E6F34g/ZBSAyy0SXTURH0YQMijf08lfhEltKdeErkvwcPHBH6Fy7IWPHxutKctVCUcRhVPUNoE5d2vFU1UHfQwLiu4zdDWNkdiz2cuz2v/rbR5MzO3bHoVO32jUcR7DRdvvtIHalLi/YPE6juI8BprNkX2biWCxqXvyvGjF0KSPw7Qb4gFDaagnrvh1FoqhHzu/LaVI2ug6JENJQLcP4crpLcERLZv3SxzjQrSSFlH9WVrbc1KlO7PtMU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(376002)(396003)(39860400002)(186009)(1800799009)(451199024)(478600001)(9686003)(71200400001)(7696005)(6506007)(83380400001)(4326008)(5660300002)(4744005)(2906002)(26005)(52536014)(76116006)(316002)(54906003)(66476007)(66446008)(66556008)(64756008)(66946007)(41300700001)(8936002)(8676002)(110136005)(7416002)(55016003)(38100700002)(33656002)(38070700005)(122000001)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3JEd3RqcUhsR1ZvSFNSRFM0QUpaemt6VGJLUTU2U0lBNHRHMlU4QUNzaSth?=
 =?utf-8?B?WitiZEpYRHR3THk4WmQ4NmJPNGdGYytoUlZXSkt0VytMY3Z1UjhhZzlCNkg5?=
 =?utf-8?B?L2dweGtaR3A1S2dsdDdQeTgxaUMwRFk0Sk5WZjIrUG96cStrWWVJejVLZ1V5?=
 =?utf-8?B?SFJHVXBORHdwbG9oYitwTi96Y04zWGRqbkltQW9VaWRncDdPc2hOV0ZEOUZr?=
 =?utf-8?B?Z0NtQVNjWmppSndGdzJRbnA5RWJ6QVBUS2k2RUFFdXZDZS9EcVhwQWhSSlMz?=
 =?utf-8?B?TjRJQjNERWVaWTNOc1lSZ3dkY0hreXhwR0hSSE1XbmFrakpYY1ZKbEhhK2pO?=
 =?utf-8?B?a3A5NDErT0crSVBWRmh2N3gyZUQ0NkpLSFdwamptTHlKd2N1NGhwZ2lIOHpv?=
 =?utf-8?B?TzJNdFlHb2xkRVgyVUR1K0I5VVRTd3djSlVodTJtNXJmL2JKZDM0SnlTOFEy?=
 =?utf-8?B?aFZmMy9TVm9WR0x3L3NvN2lHVHhRaDRQMFlhYk56OWxJWTR6VDF4enEyVURU?=
 =?utf-8?B?bEp4Ym52d3VQUkNReUxlN1pZUzBCeTNpcFozTklCZmR4NDRadGFMOWxsbUZa?=
 =?utf-8?B?ZEJudXI4WWE4K1AydTU4V05UdVNjNUZlSXJGMTVUNDh3eEV5WCtFMkk3ZzlG?=
 =?utf-8?B?czRJZjZHZ2NxVm9BNkF2WHVncnRySkxaaXFGMllYeW83OVNJMFh0NjhxVUlu?=
 =?utf-8?B?Q1Qvek1KcThsb0t2VkVFbkdwR3ZaUk8yOHhBb3h3UTVjaENuN21EWG9Yd1kz?=
 =?utf-8?B?R2Z0NWhENDRuQzB5dnJrRTZWRndYa2M4VHdqV0IxcmRhZHRhNHhTTHVqbEw0?=
 =?utf-8?B?c0JTS2dYWmN4SGxWaTZieWJZU0REUTZRdTc1ZzMwWlJBYzJab0xEdnVEVUVJ?=
 =?utf-8?B?ZzAvUzFFMXRoUHdUT1d1cU1nNCtKbTNwZDN6NlRkajFvcDkxKzdKdGFDMER5?=
 =?utf-8?B?VW9FRVhHUGFpVDJleU5DNllKZFhRQlVDT1pSM2I5UVRnOU1SSVFzUGlHalAy?=
 =?utf-8?B?MHp6V2huNUNKZ3hmdXJ1RjB0bXQxd3AvZW5FeVhmclB4OEowQVZwWVZ5MWVQ?=
 =?utf-8?B?Y2FGM05ON0t0YUdLVUl2SDJZcDA5aXhlVStMQ1RIUHBESDBRRFJrSXFteld4?=
 =?utf-8?B?RVQrTThJWkZ4UnM5QWRiM2xoNVlROTlyR1NyWWxVeXN4dDdyZ0trVXRPN04v?=
 =?utf-8?B?TWpCVXRWQk5TWE02SFNRaG5LTkM1Qk5xU01Yb3hmS082ZDBZcUg1Z1RnZnMz?=
 =?utf-8?B?MXJldmhrclB4L3RsdG83S1FtSmg3SGV3d1dhb08wTDJqMmpudk1QL2RQY0ds?=
 =?utf-8?B?NFJWa2tSRGRNb1RoQU1LOXRzSzkyeSszWFk5NWhyMVpOdHdjbkMxV2F2R0N6?=
 =?utf-8?B?LzlTQVplejZiS294T2dBUTUrdDZSdEVIMkVXVDNWKzdyaGt0NnlCU1h1UEpZ?=
 =?utf-8?B?NVNDdzhnblEvVGFZSE1FSk5lNktlWWthOGlRSzIwSG04TXpoKzFZUmRxUjUz?=
 =?utf-8?B?ZzlITHBLelRtQ1NldjA3RkhseGVpK3U2Zk9YRnVCRzVpbmJEQUJ4em5zMEU1?=
 =?utf-8?B?QVY2cDFtQXBGNm1JaVJ1Qks3cFpySy9Na1dmTzJXVU9Ta2JPRUxOUnJhZEI3?=
 =?utf-8?B?OHYyYU1yVjNSMTNDViswYzVNNXU3TjhWNlpoZGRNblc0UHpiaVdUa0kzdmx6?=
 =?utf-8?B?ajVZcWc3MVNXZ1pYa2pkcS9MdnhPY0lWV3RoNFhLU1piYSttSGd3Nmx1cCti?=
 =?utf-8?B?RjQxa3NrMGVDd3pWUStSQlZhSnFjaFQ0NkdRYUVLaDJRb1BXTWppM1dzN2Mw?=
 =?utf-8?B?dkVlcHZFUTVLUUVKWmlwWWdVaWZFdFM3NmZrVWlOcG4wdTFQR1Buamc0OENE?=
 =?utf-8?B?TVNaMXpXMzR1cC9lRmp5NkxwT091UEhndkxja2t1Z01Idk92cEtuT0d0QTYw?=
 =?utf-8?B?YjNZaXQ0TlRYTFRuekdpT2kvNENSdWtZYzBqZjcwL2lyQUlZYS9iNjVHUm53?=
 =?utf-8?B?TGVpYUk1b2wyUnlLZjFoRXFUcFU4b2xEbmZjazcvTGZ2WlB0clNxd1BFcS9P?=
 =?utf-8?B?ek1nczljYVNUWGNGeTlkMjN2WGlsdVlCbDIyc000OG1ic0tTaVQvMit1V3M0?=
 =?utf-8?Q?xBa5f2vPvEFruH4JZk0WC2Sdf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56e26c8-a579-40b4-7b08-08dbb9fe59cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 17:23:48.2140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q3Wq3CF2mMJkMIG9ikbqCOAWD4a1xlLvgpYbczFv0FH7A0GzvRnQgO0Q03B9ywiGgSq3A/Wx5ElTwV+juAtYAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7179
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ICtzdHJ1Y3QgZnJlZF9zcyB7DQo+ID4gKwl1NjQJc3MJOiAxNiwJLy8gU1Mgc2VsZWN0b3IN
Cj4gDQo+IElzIHRoaXMgc3RydWN0dXJlIGNvbmZvcm1hbnQgdG8gdGhlIHJldHVybiBzdGF0ZSBh
cyBkZXNjcmliZWQgaW4gRlJFRCA1LjA/DQo+IA0KPiDigJQgVGhlIHN0YWNrIHNlZ21lbnQgb2Yg
dGhlIGludGVycnVwdGVkIGNvbnRleHQsIDY0IGJpdHMgZm9ybWF0dGVkIGFzIGZvbGxvd3M6DQo+
IA0KPiDigKIgQml0cyAxNTowIGNvbnRhaW4gdGhlIFNTIHNlbGVjdG9yLiA8IC0gV0UgSEFWRSBU
SElTDQo+IA0KPiDigKIgQml0cyAzMToxNiBhcmUgbm90IGN1cnJlbnRseSBkZWZpbmVkIGFuZCB3
aWxsIGJlIHplcm8gdW50aWwgdGhleSBhcmUuDQoNCldoZXJlIGRpZCB5b3UgZG93bmxvYWQgdGhl
IEZSRUQgNS4wIHNwZWMgZnJvbT8NCg0KTWluZSBzYXlzIGJpdCAxNiBpcyBzdGksIGJpdCAxNyBm
b3Igc3cgaW5pdGlhdGVkIGV2ZW50cyBhbmQgYml0IDE4IGlzIE5NSS4NCg0KSSBndWVzcyB5b3Ug
aGF2ZSBGUkVEIDMuMCBzcGVjLCBubz8NCg0KPiAgPCAtIE1JU1NJTkcgPiBob2xlPw0KPiANCj4g
PiArCQlzdGkJOiAgMSwJLy8gU1RJIHN0YXRlIDwgLQ0KPiA+ICsJCXN3ZXZlbnQJOiAgMSwJLy8g
U2V0IGlmIHN5c2NhbGwsIHN5c2VudGVyIG9yIElOVCBuDQo+ID4gKwkJbm1pCTogIDEsCS8vIEV2
ZW50IGlzIE5NSSB0eXBlDQo+ID4gKwkJCTogMTMsDQogDQo=
