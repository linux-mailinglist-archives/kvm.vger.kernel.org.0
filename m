Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B6F64D1B2
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 22:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiLNVXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 16:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiLNVXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 16:23:16 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D1F36C64;
        Wed, 14 Dec 2022 13:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671052996; x=1702588996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aM62atZM/lpX+Ikhmz1kzD8g2SQZbQONAAOhrWBWptU=;
  b=RIV/9TXdR3mx7iEnGv/vb7nz2yC9uS7ueTNr1n5DgR3IKBG2v022ehCA
   g0NIBuODSvxb5QXXcO0PPzW4wtVVBRCP+1i94BI6G/XjCOKRIPoMUpZox
   N18JU+FMKlU0KIVLzAyKDAOzzMZyjMTsbRjFn0aHTVRXNPYKaekFx0OWN
   zXySvZGfIhLATFdyCvfyyzlbv4odIlNshsKswAKiVhOfcCakXAku2DnX0
   NRsULHrGs22iulcx+dYFN0ouvAggsk9brbRBJjyWjXOFkSgJ275aYURPV
   GDammjcb6iGTc14XtSr9nZjEX3vvYWx0XmxveMSobvKerdVx3/6ZiDfTN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="320372422"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="320372422"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 13:23:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="717756459"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="717756459"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2022 13:23:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 13:23:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 13:23:14 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 13:23:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJAPrduFxGy6FfjnSwpwy7QldImfi26YhvXpBHsIrdJr2ZUeI+foXc2RJLv4dveZaSWX11UvD6kHqfzAThQ0He394eBHRcCCIejgtf7uncYb3hGGJBn/5ee0tS55BNYz5+wHdZKx+1yc8mzFX86ClhlBLZ92NHoqVCP41CmU29ub5JqJ6oCVEoxQw/b80z4OBvflD9KRaq9Ey1MeHEgmI59T03iRQOQOC/9mVEapJ3sDL0+nAzdb/V6n2Rt4jp5+OXGnYyYKASKBUlBofS/rRlo1AoLr6qF/4Z/NaJZKp6bNJMuWOBpObWmDR47JOSsa5T/y3Y0PbX/hc2/KkPFnAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aM62atZM/lpX+Ikhmz1kzD8g2SQZbQONAAOhrWBWptU=;
 b=Wo4Wbbvf7oHu5RsfNFCXBTCZGoMU3eboTw4PLQY3fwW2TljLQYhLsoJGyk777djxQVJ2pEoo9Rfay4aauIrS/A2Lb9RO1bplVpNeNC6gmIIXjH1E7Oh8T7ZsoUvhI0G/1wn6xrcw6FbTqMtj2iuPSzcptPIMBxwDmPj2tapVB6lBY7Z+yEk279A9WXoJoNCWxl3v0P0FwaAY/sNt4jDmN73wNfhtpfwFvBlBre0aCMXtQ29NRf4u0k9gYiUUHFryhHM7H60KvHH0oqF29acY2bDZRbpqurpVsecQfLjroVkYuSnry+wa4e8THVnpRPR0P1ZY9Om61VUcYk8O2ot1fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by PH0PR11MB7521.namprd11.prod.outlook.com
 (2603:10b6:510:283::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 21:23:06 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130%6]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 21:23:06 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH 6/7] KVM: VMX: Provide separate subroutines for invoking
 NMI vs. IRQ handlers
Thread-Topic: [PATCH 6/7] KVM: VMX: Provide separate subroutines for invoking
 NMI vs. IRQ handlers
Thread-Index: AQHZDrmN5sCXvT6vVk+HmM53wIVCP65t5D5w
Date:   Wed, 14 Dec 2022 21:23:05 +0000
Message-ID: <BN6PR1101MB2161B2CB247273CDD85F4C19A8E09@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221213060912.654668-1-seanjc@google.com>
 <20221213060912.654668-7-seanjc@google.com>
In-Reply-To: <20221213060912.654668-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|PH0PR11MB7521:EE_
x-ms-office365-filtering-correlation-id: 2e5cf4f8-c073-4bdf-58fc-08dade1963de
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UX84he3mVuk8Y3FwLH00SbnzjSLRMysdfAopULzNWVq70H8mxwOzNJSOKkMSjNSZLLeiz2D8znCvBh5aANFtoeujuk3GjLB7AgucmqQeyTWy0ilCg0ZjUE8lr3iqySk2A6no2ODKG7ssmtO2bK9rgTcWcu3TxQ8O5O0cbPpVx/GYFyLf75Gp69glqmeuigH34rntpCTNPPHfzIb37GWWb7pJz7U0mYxmPRz7XSA/76P93N0bpF0KspWfPU8psFmo4vBOziR9C9hIfxHIvF/riOR2eR0iKRFHWk78BLd9jhYqT1CAL7SeFhLLD4/xOw5qotg0JuRdxzqcnxES0WTTScf5yT2cEp3Ot+GWHWIuuZz358fAeXE8MlLQr0rElZ88ixojAzMs56bbEh/ql3r2NRI7ubl+mz6wMKYPBGpaWoog0zvjTY4wa4TdM9+Be6s+lSpuaE1HGYzLHS5xj9VvzCuU8ms+SbfDMRDXvsqdTxtpOkEqRm7xgn5ewnA20GtcFmovKCMY9iwgd0JshpOUX+RUgt7OPxF8O6xVgnvD2B5oM9Dw3t0ZQfhgoE2wVQNoXC5AzLvKqry/NFu9Lcuk2x93A05eJaEt5x/oTw05B8B0NaJEYOsJ54WTmaCHluvP7ibL2dATLsv6vr4o+RVYj436/xWIsp/rVx8g8ddU+3NClWHuOjEzoQzLLgJrM4t0OGGwzcx7mnRIffHExcm9Aw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199015)(9686003)(76116006)(66476007)(478600001)(26005)(64756008)(82960400001)(122000001)(66446008)(8936002)(38100700002)(52536014)(66556008)(8676002)(66946007)(4744005)(54906003)(4326008)(316002)(55016003)(71200400001)(86362001)(2906002)(33656002)(7696005)(38070700005)(41300700001)(110136005)(6506007)(83380400001)(5660300002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekd6RUpQSE43eWFJbFQxQVl6cGtzVGtEVlpEUlhFK0JiSld5bU1jRmJoVmZ3?=
 =?utf-8?B?elFqaWRPVDBzT2F1SVJVQXhQTWN5c1dzVmdXL0ZOZ3RoRzViU1AyTnBSTklq?=
 =?utf-8?B?NUhLeXVWSVhIQmpEWFR0NEIxUm9zdFA1SkxYTzVGK0gyK1pQQmFpOFBMTmhM?=
 =?utf-8?B?M1Z1MlNyTGFOdWRZbDVINng3K1BXdFJYTWVaTmtITU9SeHF2RWg4Q3d3OXNY?=
 =?utf-8?B?KzdQa0ZPdGR3d1l1dE5rK0hCMVVRRzVqMWo3RzE3VFhVaW9IeFY3ak0zeU5a?=
 =?utf-8?B?R2E3b1RkTFU5a3BjZlJQdmR6QVoremNVZnF4dkhWdkpMYVQ5M2xRYXZCSFEy?=
 =?utf-8?B?TFY2a2JLZmpCemdyU1AzYk1SaXF3NEpPZ2xEcWlGQnJkb0tMY0lONW1BbEZP?=
 =?utf-8?B?RlFiTUduaE93T0tPZmFVWDhpTTUyOHcwWkE0YVBhMWlmTFFKRGtaS1p3b3Ay?=
 =?utf-8?B?RHFRdTZTWWhvN3hVTjF1cmdYSWNjVjYwV002c2ltZHp1RzI3UnZNdHUraDlr?=
 =?utf-8?B?akV6S0U5clZubXdDVXNqMnBoZjBkZFFVaEFaZjJKdGV3cnBQRGRCTVJxUVJF?=
 =?utf-8?B?aEpqS0NTN2xXRG12L2pQTjdQa3VLRlgyVW1OMGpiT3krcTdyaElMNGZQUGZs?=
 =?utf-8?B?SXNSYUJ4TVRuUmVtazVrcXoxd3pIdWNqRXNxdzU3MVE1Wko4NVR1ejMrTC8w?=
 =?utf-8?B?OE90dG1OZVkvZjk0cktrWS9hdTRlRnp4OUpEV1lGcVBibDRoYitJY21LLzVU?=
 =?utf-8?B?bDQ4VVh6a3JxcTRPUmFHLzlzdFRvS1hHM1dod2d5NEZ5NSt1eEFaRnRjajZi?=
 =?utf-8?B?a3lOYnNiU29wUTcyWmFyekR2QkVoditMWUdaOUNHUjF2a0lqaUg5d1VLcm15?=
 =?utf-8?B?dCtCZkp4WGNnTmI2bnM5emN1biswaWt2OExFNDg2bXhDWWxxWnBXVzJPeUpk?=
 =?utf-8?B?VXVyNThVdEw1V1dDK0FwVjhPbEJQN1VwcldyRlZOT01MZU84NVFWQXBkdzJ5?=
 =?utf-8?B?akZBNVZUSHRmQUNydEpLTnM5blVjVjRRdGNuOEdUdzcyakk3SHQ2UFdNKzVQ?=
 =?utf-8?B?U25rYytHSVpBa1BqNjhTbVVJc3ZnNWJWTmwzdVAxWEpETW84T0VILzVqeGNx?=
 =?utf-8?B?Rmp5eG81YWJJanR2ajE5cEg2V0hCZXBmaUNCa2V4M005amtEaytjbjVUZVBh?=
 =?utf-8?B?SEhRa1dTY3htTWFwSXB6dEdIRzhHZEdOWXd4dUcvRTNhV3FsWC9wclA1L3U3?=
 =?utf-8?B?cUMrN3NBbDhDYTRxZWFPK0lGQ0pxREtIOFFWT0xyb015Ym04VXVlaVl4TkNx?=
 =?utf-8?B?b2NXRkMrY1hNTVlpWkhEQnB5WGVHd0Y5THRIRmcvUFdkcTloWURSbk5ES3hm?=
 =?utf-8?B?RVRXRU5TdDJyNHI3L1RVSVl6VExtQktORXFhSkpFb0pVT2VKTytLVmM0TmdV?=
 =?utf-8?B?K2xJTWxlNVpFK3A5dlhtTXB2enlEaWc1ZEd4NFk2ckxwME0ycXRsZ3NKbFB0?=
 =?utf-8?B?eDNQWThON3Nuc1pXcXltOURKVEJSTWY3bmZPaDV3SUdrekRtY1k4b2hqVndw?=
 =?utf-8?B?aXkrNHgwdmpVKzcwME91N3Z2UC9sVWhtS1c3NWtsM2NibWxEL3lsa0NRSllU?=
 =?utf-8?B?VGh3b2dSWlV1ODBNUVF2N2loZWdCSDI0cUlHZ1d5MzN6dlhsb2UvMkczVEto?=
 =?utf-8?B?dUM0TzhFVXd6dzZXSHRaYTFoc3JqVnozRVlKOHlMb1I4OCtZejdpelBhMVMz?=
 =?utf-8?B?Sk9aSUNvdHQrelFPVGpMUzRYc2tjV1lQQnlQSFZqQkxBNHhZV3F0MEtUb3Js?=
 =?utf-8?B?UWVuRGFRU3FERmpONExhQWM2bXAwYkQ4Q0xzT3llQXFVTkxJbXdHVHRteXI5?=
 =?utf-8?B?dlQ2aC9menJqNDg3V0E4OXd5bitycnpqcnB2QUhKU2RCOC9xRml4enFtdXNh?=
 =?utf-8?B?b1JvSXdVNmRaUmdYS0NwTnJmS0VnMUVoMmFHY2FhczNRV0lDTG5NVFAzNjFZ?=
 =?utf-8?B?ZjUxNTVERjFwcVFaNHByK3U5SFBTczBHZExMRjRuaXRxcVFQak8yRExvMzdi?=
 =?utf-8?B?WFlXR3JtcStKUVZONUhvdmRqd0lhSzk0YXBMeFh4dFdWNTV0MWc2SkRHa2cw?=
 =?utf-8?Q?2bcvVyqFXQmT1QxpHBYo+T97T?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e5cf4f8-c073-4bdf-58fc-08dade1963de
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 21:23:05.7255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XDkn4j9pB91H70fgH+DHdJqmegvqlHYBpvdmf5Uhb/oodQWcdYnXYhCc3uP5ptk78MbKjTVLB2s0XHWGmtkwlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7521
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiArDQo+ICsJLyoNCj4gKwkgKiAiUmVzdG9yZSIgUlNQIGZyb20gUkJQLCBldmVuIHRob3VnaCBJ
UkVUIGhhcyBhbHJlYWR5IHVud291bmQNCj4gUlNQIHRvDQo+ICsJICogdGhlIGNvcnJlY3QgdmFs
dWUuICBvYmp0b29sIGRvZXNuJ3Qga25vdyB0aGUgY2FsbGVlIHdpbGwgSVJFVCBhbmQsDQo+ICsJ
ICogd2l0aG91dCB0aGUgZXhwbGljaXQgcmVzdG9yZSwgdGhpbmtzIHRoZSBzdGFjayBpcyBnZXR0
aW5nIHdhbGxvcGVkLg0KPiArCSAqIFVzaW5nIGFuIHVud2luZCBoaW50IGlzIHByb2JsZW1hdGlj
IGR1ZSB0byB4ODYtNjQncyBkeW5hbWljDQo+IGFsaWdubWVudC4NCj4gKwkgKi8NCj4gKwltb3Yg
JV9BU01fQlAsICVfQVNNX1NQDQo+ICsJcG9wICVfQVNNX0JQDQo+ICsJUkVUDQoNCkZvciBOTUks
IGFmdGVyIHRoaXMgUkVUIGluc3RydWN0aW9uLCB3ZSBjb250aW51ZSB0byBibG9jayBOTUlzLiBJ
UkVUIGluc3RlYWQ/DQoNCj4gKy5lbmRtDQo+ICsNCj4gIC5zZWN0aW9uIC5ub2luc3RyLnRleHQs
ICJheCINCg0K
