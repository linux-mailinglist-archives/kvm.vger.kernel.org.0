Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230747A8FBC
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 01:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjITXKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 19:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjITXKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 19:10:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED53A3;
        Wed, 20 Sep 2023 16:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695251431; x=1726787431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kBcnxzNYWizXmc7YAUEPT5ExgluuwvJK+IEqtUpDNCY=;
  b=CGQsJ8tQB2OWkMB5f5UEE0nh5n+2wh2gjCIlEgj720Lxsql6IQUguy8N
   2jTOoPG94OHVlRwOcA/bOx2HhF3oLBVtja/kWdC2xVfucqH1OzTCIo3Ev
   gNVp/59BBs77p/h0Vcf01vhpS3OVAzrLR4p5gdZdkM9mXvzPnMYMPSj2V
   nxu+LfEtukgAsJjH8Nt4gz5IFiQgQTVDkJm65xaLxJTl0P6T2ABxn06k8
   EzvKMvgh+SpcZmgzRLPkmQ4GwtiKJ2p9HIkLcQJWw6XrXpA7e7aZhwVsv
   xIKhA8W4up2NFuPi9ZFaVZCYSlUE3QVvwFAzbbW3J9+KfNFWTCxJh0fGn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="370681001"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="370681001"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 16:10:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="723500382"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="723500382"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Sep 2023 16:10:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 16:10:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 20 Sep 2023 16:10:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 20 Sep 2023 16:10:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfxjTU2HqFMenpMtfz+8mwAiNFrS9H3UMXopj4AyYfUwmZMjE5sFpnYuTIXcEfLPyj1YFHLJZHsX4ajquijcmUdKLn31tR+iY+Imy3Yo8aTZrIT9f/hAlbcsXvKmFV6i52fNdnYOS2dnjza7bNriNQki/feUIsxSYg0pcvPJlETPAcQXmpaXbO3gUSh7ugQENWsrPR8fZjqtCJYcElcyA3QSxTpKtRFJ5oKgxMCwuw6tdU+NRUI84xy6Y1QMBuf+zZ/7aBCfWZps2ueoE6GD5GXnECDbGZJKINl2iWwGBGvINlXBZmXj6tUmcubIOF56HWVzlyhwc4wy35xPc4gJ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBcnxzNYWizXmc7YAUEPT5ExgluuwvJK+IEqtUpDNCY=;
 b=A6KCax7G8emxApzl2L5lTNABDRf5a1cho4tQyFqDFgkwUgNtaeXw/bNF9aEh+ZDslcMoot1H6UytFg20Mw1ggKRowr7LsIvQsFCfbp/F1VUREvLtezFB5mIpGncWm6Z7WQTfiQ+QDb4bPdOaZLYuDen3CtdJDY8+ugievR99LGvWZLn0EpJpAzWf5876u48JUogM6ifU6WYbjwJ2PbGfdcNe0wQLE7ZD3lbgXBHOxyU001r0Jq9nao7UQdmsCHgEKaHTZ7d61Eb6sJPnr3PkSb+I5qide0vcsAv6avmWkBMfvyhMqceQ6zytF6AeiXD9xh/izcjhpAVGfbbzjmUhuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.19; Wed, 20 Sep
 2023 23:10:24 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%5]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 23:10:23 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
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
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 33/38] x86/entry: Add fred_entry_from_kvm() for VMX to
 handle IRQ/NMI
Thread-Topic: [PATCH v10 33/38] x86/entry: Add fred_entry_from_kvm() for VMX
 to handle IRQ/NMI
Thread-Index: AQHZ5stu3Ky8BNMeNUmgCzRftfqUcrAkCYAAgABH7XA=
Date:   Wed, 20 Sep 2023 23:10:23 +0000
Message-ID: <SA1PR11MB6734FED6128A0D32243DB118A8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-34-xin3.li@intel.com>
 <facdf62c-d0b4-597d-a85d-5772ecaa2b86@redhat.com>
In-Reply-To: <facdf62c-d0b4-597d-a85d-5772ecaa2b86@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH0PR11MB4790:EE_
x-ms-office365-filtering-correlation-id: 8a676b44-425b-4eaf-e7d1-08dbba2ec4fa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6gFPOhPhrdNPZwpt5TXGuUx/OyvyhjPaUZKUda0iPH+jcPUK7KkEO3IxzTINdFuY0ABXYX6oYhavwLlbwgveNPXIy3cQlo4GOff3EPwCjzePkdrWKHtFLmkS0Ua6IfWL08o+dN4oMPQWxjRWuEDcTEQoOTDh9DcDeNmMqPZex1YxbdfGRHo56pk/44QlAhiEothQNzQBfv07TiM//la1bdR3wFGTOjYMEO4SHYYX4e+nmYq0WrVpz1vcvWEJFgXHy4A7aQ0VBPTXskKLrchocSNvQ0+oyOw92HV71SLpG8mcwPplPo3TGoOfQ5sDYQooybYOtmXGHmqCZYh33M3jV39FUqsma5P4uV6zDYErVZjnAp9HGEjxua/i7psEv8sxrsDkyCZGlpeYRMdUcecERubILVaNGhYUTkNqRb8BSpztdEJxfstmLkmOSCg7ewFuivfqtI436Jvzdkyq0UAM3R38q4ZU3DBvOs2yaX9LlNB877VAM12CyH9V/isVl1XXoaX9W7u1cGW3D7dmQfbjoZ4QijLpK1CbwRyLS8zzjGY7Dp4hHV71MUrRQZlpVNMoSnqbb36eO4GE2Z06x8LtCN+qLCXdCyRGNjULjKDGaAPd6N++2eOui+FpE3bVAMus
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(39860400002)(366004)(136003)(186009)(451199024)(1800799009)(55016003)(5660300002)(41300700001)(26005)(7416002)(2906002)(4744005)(122000001)(33656002)(82960400001)(86362001)(38070700005)(4326008)(38100700002)(8936002)(8676002)(7696005)(478600001)(6506007)(9686003)(52536014)(110136005)(316002)(66946007)(66556008)(66446008)(66476007)(76116006)(64756008)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjQ3MUplSUJqUnRrNzZhMkY4cHFqbUp1SVIzUUtpbUc0ZWcwLzdaY1BvbFpW?=
 =?utf-8?B?aEdVbFkrU1JFQkpORExXblA3dVBIQzczZFNtZDFPTWZCWmZsNDRBTGNiVUpx?=
 =?utf-8?B?NjNBZ04vN1ZLVmw2cnZySnRuVE9Cb3FFazI5WFkxTFZnM2ozUGdONjdOdDRy?=
 =?utf-8?B?S3NFeE4rYnZaaDFnL1dJOWpoUExXMWRUOHVLY0xLN215NjVPN1k2RmJUUFk0?=
 =?utf-8?B?V0JkQ2trOW5NT3d0dFFXS3FDMStvSXVBK3VxeWRld2dPdWFKNWdIWjJUeUtO?=
 =?utf-8?B?VUx6MUJ3dHlFRUY1bldHbHp3Snc0TnEvRXRqcXFwbno0VnVhaDVWSmJtUHVO?=
 =?utf-8?B?bTF3ZFljeTZqay9nUHZRdXc3RGtvR2VldjRjaUxoaW5VS1N4VjNCT0I0SEdx?=
 =?utf-8?B?bW5HUW9wd3NrQUhrUWlOdjdrb00rZmY3WXpyaHN5N3JGMDVBblhTbmJ2M2Zy?=
 =?utf-8?B?NGFsMWZkQUlhUTdtdC9kWHIrZ1lyNFlYVE5POGFrQTUxWEZHZEZuenc5R0tl?=
 =?utf-8?B?WnJEOFhpbjFGaXVaWkVEVHMzOGk2UE01RGNvcmQ1d0RhZm1nRUoyMDA2N2tr?=
 =?utf-8?B?T2kyMUcyTU1yamluTHRWZ1JjN3o4YkRISWZMSmNDZUw4QmtoUE5uemZQQjZE?=
 =?utf-8?B?ZUQwbEIxRlg1elpoUGp5Y0dUOUlUQWJBN0ZhSHFoa1ppZUovbHBsUXZmKzN2?=
 =?utf-8?B?bWozZk5lMEo4c0hTTEdCT2NGK005ZUdhditRUVFoWk00QXBSTTU3VzBWM0dJ?=
 =?utf-8?B?T1VuNEc2dGF6WmhKL1ZVcVZQQ3FvakkycG1PaFpzakk4OE9rbXpwam1qWUpO?=
 =?utf-8?B?VlU0NU5lTmgxZzhNMTFmMDhTbTNlT2w1UlVwY2ZJN084UndvNTZHVjdsdnV1?=
 =?utf-8?B?bXpBbGJlOGZEcEdIcmZMR1BzL1JkcFFIejYxUjBrQjUrMWxQSll0T2N1aUl3?=
 =?utf-8?B?ckc2S1RtU3BKOGRaNHpsTkFZSlJKWGVhK0RYT0RUUXlnYTFZWERjNmJ1TjZl?=
 =?utf-8?B?djJWS0JLMHBSKzYvVXFhZE1rL3ZWdWlzV3RlSHlZbXVpYlhJWGx6NExtQUdT?=
 =?utf-8?B?dEk2cEtBTlRqRG1McEFyMnhsQXBNOHQyM21MTzBJNHN5RGJmelhydGNZMG50?=
 =?utf-8?B?UThMaDEwVUw3WDFMZFZDOUxsaVFyZjNxTHN2Rkdjd2FqTjZqSXNONkxFUW8x?=
 =?utf-8?B?U1FDV0lVVEt0M05iNmN4WUU1L1JVKyswYjFsMWM2ZEZPN0V6REo1MS9uMS9B?=
 =?utf-8?B?UjliemxocHUvT28vUkQwbzJLR210Y3gzMyt3VzJOYlloUFlPRmVtZG1GL1Rr?=
 =?utf-8?B?QWp6L0U3QTB5NHNKSVBxY01oRUszRXhoV3B3aXAzUmw5NlNHQk14VFZCZUlk?=
 =?utf-8?B?U2dxYkNoSS96Sm0wRmFuZjhIbG9PdjZjVVhteFZsL3B1U05XVlRETVhrWGhr?=
 =?utf-8?B?c3M3L09DL3FtMmhOcHRsSXEwQUs1NmpTN25VZVk3WGU5eFpjb3NYR1ZuQjRV?=
 =?utf-8?B?aFM3RTN3Mk56ZjI1NnVERUtYeWhTOWNzNnVUWjlOMHpXQzByckgwMDhjZ1du?=
 =?utf-8?B?RUE5OGF6TU0rSm5iUWZjNUJaMHlzU3ZVUG1oaTFaRWVUMkk3N2JCYkd3SDR0?=
 =?utf-8?B?cXpSQzg1aHVIS09yOXZCU1E4V1J4WVlUaU5NMDIvMUlnYzlzbTZqYVc5WkRU?=
 =?utf-8?B?YXBUeGZILzMvc1dNMnk3azRWb0NTUy9MMVRHU0E5L0d3MVBkZmhLNWdEUExS?=
 =?utf-8?B?UU9Ja01PdElPMXNKSHRsRS9URGNBY3lXalZHQzFnOWNDLy9rVkw0SnlFUkF1?=
 =?utf-8?B?QlpsVi9GOEsvQ2htTVJ3SFVJRFVaZHQrT2h4RVI1Y0NHQkxiTWFjYjl4eitB?=
 =?utf-8?B?QXBxM29Yd2M1VjZZaFcxWmlqT1VQd0QxWjFqMHVLclQyMU93UzBCV0V1dEYr?=
 =?utf-8?B?Y08vZ0Yzc05BQVNaaVI0eXB2Ylp4MG1ReU11WjRtZnlWaVlBVm05ZmUwb20x?=
 =?utf-8?B?ZU5vVk4xL09TenJENk1PeVlMSmdXcjAwb1dTQjEvZitVenFUOEVKeDZ0dkVJ?=
 =?utf-8?B?SUVJUEptWUIyQmYrejg5RXhFTlo3bjZyMjlDenZ1M3J4ZWxVMWhqWjUwcWxh?=
 =?utf-8?Q?V74o4bM+Jmyuub0ULjFUxv/bP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a676b44-425b-4eaf-e7d1-08dbba2ec4fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 23:10:23.8926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J3BWrONtoB8mLnOewBT+ZdFGZk15EUT76mBeUgiEe7y979qmI+ywJXF0WMtqyGjE8E/AW6ePEtC3JH2rgNTh2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
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

PiA+ICsJLyoNCj4gPiArCSAqIERvbid0IGNoZWNrIHRoZSBGUkVEIHN0YWNrIGxldmVsLCB0aGUg
Y2FsbCBzdGFjayBsZWFkaW5nIHRvIHRoaXMNCj4gPiArCSAqIGhlbHBlciBpcyBlZmZlY3RpdmVs
eSBjb25zdGFudCBhbmQgc2hhbGxvdyAocmVsYXRpdmVseSBzcGVha2luZykuDQo+IA0KPiBJdCdz
IG1vcmUgdGhhdCB3ZSBkb24ndCBuZWVkIHRvIHByb3RlY3QgZnJvbSByZWVudHJhbmN5LiAgVGhl
IGV4dGVybmFsDQo+IGludGVycnVwdCB1c2VzIHN0YWNrIGxldmVsIDAgc28gbm8gYWRqdXN0bWVu
dCB3b3VsZCBiZSBuZWVkZWQgYW55d2F5LA0KPiBhbmQgTk1JIGRvZXMgbm90IHVzZSBhbiBJU1Qg
ZXZlbiBpbiB0aGUgbm9uLUZSRUQgY2FzZS4NCg0KSSB3aWxsIGluY29ycG9yYXRlIHRoaXMgY29t
bWVudC4NCg0KSSB0aGluayBhIFZNWCBOTUkgaXMga2luZCBvZiBsaWtlIGEgdXNlciBsZXZlbCBO
TUksIGFuZCB3ZSBkb24ndCBuZWVkDQp0byB3b3JyeSBhYm91dCBuZXN0ZWQgTk1Jcy4NCg0KPiAN
Cj4gPiArCSAqIEVtdWxhdGUgdGhlIEZSRUQtZGVmaW5lZCByZWR6b25lIGFuZCBzdGFjayBhbGln
bm1lbnQuDQo+ID4gKwkgKi8NCj4gPiArCXN1YiAkKEZSRURfQ09ORklHX1JFRFpPTkVfQU1PVU5U
IDw8IDYpLCAlcnNwDQo+ID4gKwlhbmQgJEZSRURfU1RBQ0tfRlJBTUVfUlNQX01BU0ssICVyc3AN
Cg0K
