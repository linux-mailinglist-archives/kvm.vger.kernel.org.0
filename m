Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224AF420457
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 00:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhJCWhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Oct 2021 18:37:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:22037 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhJCWhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Oct 2021 18:37:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="225558148"
X-IronPort-AV: E=Sophos;i="5.85,344,1624345200"; 
   d="scan'208";a="225558148"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2021 15:35:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,344,1624345200"; 
   d="scan'208";a="566664825"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga002.fm.intel.com with ESMTP; 03 Oct 2021 15:35:46 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 3 Oct 2021 15:35:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Sun, 3 Oct 2021 15:35:44 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 3 Oct 2021 15:35:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hp21bkfdV6V2J8VFSTbOeBGqvOfiB7VN9HcNn+FJ4CtnBq1RcLUULrkIDTz1uzLFImPiev9asw6NXkUpgBD8WW02D8egS1M4FdtRyhgUdIvygiQcvRMypT+zxOC4Py864nK545ea6elGYEPIUt4oNYQ6or77UsGHITH+vmui4G+AbT0K6+1eRXj67bx/958XAO4eLOM6ou8sZMflB86xrQYmdYcmc2Gc+C7pII/JNlCuiF3+S6CAEfZDO0snyOmb1EDHE4s1oFsZsFslb82xAEcxpoR4vhmGjfOBTXH3jOzVCXzyrTF0E7Di1AC7Xn8IP4965gEBdTDrPRmgouc6aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0YitedoOl7HONzHcKVCLVQaHEHz/tgXRfX/1B12i3c=;
 b=n5VMSNUbxuUQUxZLmmU7jiFtP30b6OcK8lQigaZNEEzujxsUp53qelY1e3bL0V6IUYbQgKnuw/grGPyReZfHa8iAmYK26DBrM1C3Lq7rFg9z/hPjc8rKEtYsASgJHLTMP0fJxf48/2bTWYEigyNRIEWLDhC3UpTsODGcIP4geeFQ+FFsTpWxZZvI5i/BNFd+GYaUtlyPBhSP+aLcLI3LGo0UJg4X/BohA/P9kGNtX5bR3goF6E1f9e/BRKa2k2HvtnGLkk13dsRftYD+KPhxYkqwq1jjwe5uyI4yUEVs5PK0vEci3rb8+8tAmZ6TvULr4fLWH5iawNu/KytVcNJkbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0YitedoOl7HONzHcKVCLVQaHEHz/tgXRfX/1B12i3c=;
 b=xOIi6QUCMOkZBiDldr4oaARkRHI+mHKKpJyZiWxD7VoSgvtWm9eXHfi/6iz0Xk3UsD5gyUTgZxFeVKPiOblsBjqlwlQd4BDk+ZNFT12xu4CZWcW7vcgGRnC0jFc0L2Gy4u7xc6oPhBJMsho96eFkNwhxd93OIwLQ5Cn8jDkDhRg=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB5159.namprd11.prod.outlook.com (2603:10b6:510:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Sun, 3 Oct
 2021 22:35:41 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::b427:a68a:7cb6:1983]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::b427:a68a:7cb6:1983%3]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 22:35:41 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "bp@suse.de" <bp@suse.de>, "Lutomirski, Andy" <luto@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Macieira, Thiago" <thiago.macieira@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 04/28] x86/fpu/xstate: Modify address finders to
 handle both static and dynamic buffers
Thread-Topic: [PATCH v10 04/28] x86/fpu/xstate: Modify address finders to
 handle both static and dynamic buffers
Thread-Index: AQHXmcp1WJMlC6/xvUuhc/ArilXMk6u+WTIAgAPBNIA=
Date:   Sun, 3 Oct 2021 22:35:41 +0000
Message-ID: <B7F1A300-3E61-4CB4-8BCA-316FE68B7222@intel.com>
References: <20210825155413.19673-1-chang.seok.bae@intel.com>
 <20210825155413.19673-5-chang.seok.bae@intel.com> <87ee946g45.ffs@tglx>
In-Reply-To: <87ee946g45.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aad807c1-36e0-4965-6596-08d986be21d0
x-ms-traffictypediagnostic: PH0PR11MB5159:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5159C55E96A12C4C6A0B7A74D8AD9@PH0PR11MB5159.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 39RSugluqKDWuNYswZVsjsIpicN5nqm/GTcbuLktVE6unMo0u2acijhG+zJ65VGQkXB8vdJOYHSIE6mlnpMeRuQWAe98xSzcmqRSRaXOsRmbpbyGn0gc7/IyNHgVtZJrYlDajUfLmLs1D6ToDINRn05T/vuBceRgGKfN0Ky/KJPJKQFUVim5xwDDhn6ZXP5xTfeDJsqWiL7kWRiZubwe3ZOtBUEExYWdtrLh4HYFS74zheWTuixp+w+IyQ2Fk71bpOZONZHrtFP16xjjlzd3D8bvEexjE+2VqIzfVaDntwONKvrHmsGb2yC4e3GH06w6RB+qkghRsyba5ZiIfzgIZK0QiFmkJ9jbeH/nJeqrGl2Mv8wQgfxGb3ONn8ox9RnlHysrfxLLCrS0gk1h2LknfZIp6VfORkUYeOQJkbB9GpVFEQmwmcnr9PRXCTfWYEI/HgVviwLUXzddlEN6hApW04SZJqdKH7prSiiMCPb6V85wPSoSHDicZLYMA3HKl27knZkfCVz++1d4cGfFC1B4vuI9+pwukFqysT0Dj4gByj3q/7EqKpRXnhYX/yZ7VctbmWqfzLbWEVSA7e1DH8Cc6VVDwNS3NCwP/div62oXUKtppe0Kd5iHLMWTPwE82uFBYQw9qYOZzZod65Ai0ZK5vYo6hgwB53pZDQMV/eOdzWRfF/wNUsPofTdDeQ0Rj7qKTWcOdlws6i+unNOIPNJwKmcq4WtPWUxW9NbUGli+UXKrJyq2W1Z53unyLDEXaGdaJP6q+TAZIOYovmeP9uzrly6UjnazYwetEKy2e1ecxlLcyWMZVC+AVIZB6jR5qFX3MXFmm2bCYhbOvQ2Q/XL9vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(186003)(76116006)(86362001)(4326008)(6916009)(71200400001)(26005)(6486002)(2616005)(38070700005)(2906002)(508600001)(966005)(5660300002)(6512007)(316002)(8936002)(66476007)(66556008)(64756008)(54906003)(38100700002)(8676002)(36756003)(66946007)(53546011)(6506007)(122000001)(33656002)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?am8rK01GeFpDR21MenBIOFo0N2NqdzdCc080OEpoVURBdTVqcGQ1VjVBQjk0?=
 =?utf-8?B?S0wzbVN4QWF4V1RERzVrSzQ0cDJnTHROQXJTdE9vbGgrdUJFVXJKQktTMk5p?=
 =?utf-8?B?YnZMdEIrMnJaSVJuVkRDTFVCbi8zZHo5d3BmR1FDc1VlODhZWlRWSmRROWJN?=
 =?utf-8?B?aWxSenlaRFVGRmhhcGxCWXEvUFRUME1VNFpJYTBXbVdiRWY5bm00VDc0cmhD?=
 =?utf-8?B?UjFVNE5YOFRkNWpMejZnTWpmRGsycjZuYi9qM0V1S1ErbWVQckg2aktDbW5o?=
 =?utf-8?B?RG1PYklFWUNENlh0Q1Y0Zmhlc1pVRHVJcGt6bG9USzBJSWVqRU40cDdGR3Bn?=
 =?utf-8?B?OGdiN25HWG0rZWYxU1BudTZPUVJESUd0eTVMSjZOek9lVUZxV0VST1grZ0cv?=
 =?utf-8?B?VE1hTXRUdXMzb2R6R29rWFZsZnozSFd6SEtEcmJwWUtwT1ptS1F0Zng0U0RX?=
 =?utf-8?B?M2tKM2lQYmMrc2RmbXRrZDVDS0pEZlk3OURrRVpDMzJYanR3THphS1p0OUtD?=
 =?utf-8?B?SFhtbk9NTVJ5b0tidDBxQ1IyajNTb1dLTEtUUjVVelNlUlJpK3M1U2hiUUtk?=
 =?utf-8?B?MDZTcUdJU2d3SHVhSlcxQXZzTUtYeHJnOWZXVDlQZDFWMk9aMTM5aTMzM2lG?=
 =?utf-8?B?elV6bElPUVZrNXY0Q3pmN05tbXQxSkx5dHViRVJSNjJWblZGUEw5OFRGNStI?=
 =?utf-8?B?TTRPMHF1dkExOHc1cG04c1ZtaXg5ajV2dlhEYVBuTnExOGZwbWh3T1QydktW?=
 =?utf-8?B?NDQyWFlYUGg3RFRhZGRUYkt0L0h1dWxubGhVMWVmdkJJb1c5ZG5tU01IL1Z1?=
 =?utf-8?B?bE9oZHh3U0U4MUtNUjY2QTErNjczODV4V1Mxei8yTG1sUGJ3R0pvaGRTS1hR?=
 =?utf-8?B?cnFRSUtkd1Bob0diek1QNit6Y2JDVWlSYnh1YXo2aHNHNWlEU095UDdsUDRk?=
 =?utf-8?B?Q2Y5SHNBdEpvbnQ5WWhWZ3NzdUgrVDNoMEg1SWh1dmN1QVlYa2lqSjRSNUQ3?=
 =?utf-8?B?ekx4UWkza0RsV3doRTVyaEVjWjNUakNZcWZPL2x2SzVINUZKZGFQcmxDblhn?=
 =?utf-8?B?UzdHUG9Xam9WcXU4UG4zQnRVQ3NZbThMMXkwbDJ0dkhxcG1PL3VFOTBqMVA1?=
 =?utf-8?B?S3FhdTBYRDVSS0QzekE4WjNuamNyKzc4L3UxaExZZWZYK2ZWNENwamJMTGZm?=
 =?utf-8?B?MVZyN0c5NngzczZLQURQNjI0MTRuTk5xZytMdXNGbS9pM0Z2OXhLWjRmTnRX?=
 =?utf-8?B?Q28zSnc2VjcrQU5XQURmRi9pMU01Rk04YVEyWWs2dWVwVW15Wk9ZVnhBbVVU?=
 =?utf-8?B?NWZPVWVmQjVVdFVvaENGYmJkZzVUMFJJa1BsRjRQK2Y2OCtxU0NPbG9uMXhK?=
 =?utf-8?B?N0lTZ2lkTE9WSS9UZnRyZTlpVTFkZUNWTE9jM1RCejJyT1BPUTlLQ3hnNW1j?=
 =?utf-8?B?cmx2cTUxTDg0b1BNREFVcEdTVVFwOGdQOXZOTEdpWUdlMDUza0FXSW9DVXIr?=
 =?utf-8?B?L0I1dVBURGpwQ3lGTHdMeGFvZXQxemlabVJuTU5SeStrYXF0TE9QRVJUU0pD?=
 =?utf-8?B?em9KTC9VN2hrS254U2E0T3JYT0NZcEZva0lFRW9jL2dJYy9acE9DQUpnLzBv?=
 =?utf-8?B?UHh3bGdLeXoyLzZoa1owN3diV1J5QjZObnZXL3VmazJObVNZcXdXOFFrcWhJ?=
 =?utf-8?B?Yll0R2hZYUxocTBHREJXTEpmSk84QUNyelVFVVpBczVBTXNUdWd1UHBzd0JS?=
 =?utf-8?Q?YV2+uRkWhE/Q2RV3LYuSzKYhLvA2GBA2P84SNFz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0647FE579C2D774BBFD0206590B4E7D1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad807c1-36e0-4965-6596-08d986be21d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 22:35:41.7425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 70YFlmqXRNd/IJBeBD9TEdY7NYg+VQOR32hkS/tOyqzvH1PUetnbblUp/BiebONy2xgeInfonCpCPB68Pfqu5d6cjBYj5nTRHZ/eeitoZ/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5159
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gT2N0IDEsIDIwMjEsIGF0IDA2OjE1LCBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25p
eC5kZT4gd3JvdGU6DQo+IE9uIFdlZCwgQXVnIDI1IDIwMjEgYXQgMDg6NTMsIENoYW5nIFMuIEJh
ZSB3cm90ZToNCj4gDQo+PiBIYXZlIGFsbCB0aGUgZnVuY3Rpb25zIGZpbmRpbmcgWFNUQVRFIGFk
ZHJlc3MgdGFrZSBhIHN0cnVjdCBmcHUgKiBwb2ludGVyDQo+PiBpbiBwcmVwYXJhdGlvbiBmb3Ig
ZHluYW1pYyBzdGF0ZSBidWZmZXIgc3VwcG9ydC4NCj4+IA0KPj4gaW5pdF9mcHN0YXRlIGlzIGEg
c3BlY2lhbCBjYXNlLCB3aGljaCBpcyBpbmRpY2F0ZWQgYnkgYSBudWxsIHBvaW50ZXINCj4+IHBh
cmFtZXRlciB0byBnZXRfeHNhdmVfYWRkcigpIGFuZCBfX3Jhd194c2F2ZV9hZGRyKCkuDQo+IA0K
PiBTYW1lIGNvbW1lbnQgdnMuIHN1YmplY3QuIFByZXBhcmUgLi4uDQoNCkhvdyBhYm91dDoNCiAg
ICAiUHJlcGFyZSBhZGRyZXNzIGZpbmRlcnMgdG8gaGFuZGxlIGR5bmFtaWMgZmVhdHVyZXMiDQoN
Cj4+ICsJaWYgKGZwdSkNCj4+ICsJCXhzYXZlID0gJmZwdS0+c3RhdGUueHNhdmU7DQo+PiArCWVs
c2UNCj4+ICsJCXhzYXZlID0gJmluaXRfZnBzdGF0ZS54c2F2ZTsNCj4+ICsNCj4+ICsJcmV0dXJu
IHhzYXZlICsgeHN0YXRlX2NvbXBfb2Zmc2V0c1t4ZmVhdHVyZV9ucl07DQo+IA0KPiBTbyB5b3Ug
aGF2ZSB0aGUgc2FtZSBjb25kaXRpb25hbHMgYW5kIHRoZSBzYW1lIGNvbW1lbnRzIHZzLiB0aGF0
IE5VTEwNCj4gcG9pbnRlciBvZGRpdHkgaG93IG1hbnkgdGltZXMgbm93IGFsbCBvdmVyIHRoZSBw
bGFjZT8NCj4gDQo+IFRoYXQgY2FuIGJlIGNvbXBsZXRlbHkgYXZvaWRlZDoNCj4gDQo+IFBhdGNo
IDE6DQo+IA0KPiAtdW5pb24gZnByZWdzX3N0YXRlIGluaXRfZnBzdGF0ZSBfX3JvX2FmdGVyX2lu
aXQ7DQo+ICtzdGF0aWMgdW5pb24gZnByZWdzX3N0YXRlIGluaXRfZnBzdGF0ZSBfX3JvX2FmdGVy
X2luaXQ7DQo+ICtzdHJ1Y3QgZnB1IGluaXRfZnB1ID0geyAuc3RhdGUgPSAmaW5pdF9mcHN0YXRl
IH0gX19yb19hZnRlcl9pbml0Ow0KPiANCj4gYW5kIG1ha2UgYWxsIHVzZXJzIG9mIGluaXRfZnBz
dGF0ZSBhY2Nlc3MgaXQgdGhyb3VnaCBpbml0X2ZwdS4NCj4gDQo+IFBhdGNoZXMgMi4uTiB3aGlj
aCBjaGFuZ2UgYXJndW1lbnRzIGZyb20gZnByZWdzX3N0YXRlIHRvIGZwdToNCj4gDQo+IC0JZnVu
KGluaXRfZnB1LT5zdGF0ZSk7DQo+ICsJZnVuKCZpbml0X2ZwdSk7DQo+IA0KPiBQYXRjaCBNIHdo
aWNoIGFkZHMgc3RhdGVfbWFzazoNCj4gDQo+IEBmcHVfX2luaXRfc3lzdGVtX3hzdGF0ZSgpDQo+
ICsJaW5pdF9mcHUuc3RhdGVfbWFzayA9IHhmZWF0dXJlc19tYXNrX2FsbDsNCj4gDQo+IEhtbT8N
Cg0KT2theSwgYSBOVUxMIHBvaW50ZXIgaXMgb2RkIGFuZCBpdCBhcyBhbiBhcmd1bWVudCBzaG91
bGQgYmUgYXZvaWRlZC4gRGVmaW5pbmcNCmEgc2VwYXJhdGUgc3RydWN0IGZwdSBmb3IgdGhlIGlu
aXRpYWwgc3RhdGUgY2FuIG1ha2UgZXZlcnkgZnVuY3Rpb24gZXhwZWN0IGENCnZhbGlkIHN0cnVj
dCBmcHUgcG9pbnRlci4NCg0KSSB0aGluayB0aGF0IHRoZSBwYXRjaCBzZXQgd2lsbCBoYXZlIHN1
Y2ggb3JkZXIgKG9uY2UgWzFdIGlzIGRyb3BwZWQgb3V0KSBvZiwNCiAgICAtIHBhdGNoMSAobmV3
KTogYSBjbGVhbnVwIHBhdGNoIGZvciBmcHN0YXRlX2luaXRfeHN0YXRlKCkgaW4gcGF0Y2gxDQog
ICAgLSBwYXRjaDIgKG5ldyk6IHRoZSBhYm92ZSBpbml0X2ZwdSBnb2VzIGludG8gdGhpcywgYW5k
IA0KICAgIC0gcGF0Y2gzLTU6IGNoYW5nZXMgYXJndW1lbnRzIHRvIGZwdSwNCiAgICAtIHBhdGNo
NiAobmV3KTogZmluYWxseSBwYXRjaCA2IHRvIGFkZCAtPnN0YXRlX21hc2sgYW5kIC0+c3RhdGVf
c2l6ZS4NCiAgICDigKYNCg0KVGhhbmtzLA0KQ2hhbmcNCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xrbWwvMjAyMTA4MjUxNTU0MTMuMTk2NzMtMi1jaGFuZy5zZW9rLmJhZUBpbnRlbC5j
b20vDQoNCg==
