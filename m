Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7F4473D6A
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 08:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhLNHGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 02:06:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:53750 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231283AbhLNHGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 02:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639465604; x=1671001604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V2GAFmF54SLCRd9Eu8WIHWGrIVtNKXifLQ6qIOSRQ8U=;
  b=lUVGKxluBGCj6a3fyi7EoARX+4d5fQumwvNarzJeOCTZEMmpL/vH0KkY
   91qumrjwKD7yjG2baHBtUepFm0IMkROwAWrpQEXc8O2OBbdaw5jqzXRYl
   WQjN9DpfuZaGFttz/Jh/OZx7eecXx9jOCoDgUUHv3AzAS8V/XDP020mim
   X0CPoQOWa2wL1c1cAFf/ckHj2705vHa6gdEFOAnC7e09FfPs9eL9BFCYV
   oEi/nKoSU5Oe8TZNMQd/Jh+EQhifCS3bYWqQ49Aqfd/ePlUTRAJl70MkW
   aSn9D4/ZE1U8WeOjQ/luxRQA+Rj8wMoURSRjaTBXnEF9Yo+sRoM95manc
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="226191357"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="226191357"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 23:06:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="464960713"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 13 Dec 2021 23:06:44 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 23:06:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 23:06:43 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 23:06:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxX9oHZ/tNbESmrfqvWDyBwyt0m0jjGYNXyZjEEhv1yLxAIqMNBjKAD1aRHHGdQGc2nSWMSv7RcB9St9CjMqmWv+bjaaXVds1FskWjepxDRXDp1DAUptryi2jHfHv92J7WogIKspsIP0Bk+WjwlwShxDsiTgzYyU/1iztF7DmFvlKuIG6Y+h6UJ3vRXR2Ztx2ngxT4Z2DQczkpBDOarN+wGJIEWCrBjw9+eJk+CJFeIVgPUECWOB1w345crQvAkQjGb1cwqmhGcnJs7f8KB4SqHPWl0yNycrP5/gxgW78yNaRDH8yRLwZrjqmqnab7if62IRDNzkE4s6ssrRALgDpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2GAFmF54SLCRd9Eu8WIHWGrIVtNKXifLQ6qIOSRQ8U=;
 b=ZNVlFSmHq2UwfCCjpn00XmgEEbRwo0dV2uzvS9N9L7LT2axEtUInjO8gp8qlkrd4RuW1DKl237bZKnPgo60dIFKxU17ToBOSu+o0EBZh0//9ZTKLjPzq2PNQEJHF7PlEm2GNsNDpYK/b+vTYkatM7VYF/1SgQnlNY1/GucMZL0uPv+JbChEcRqhC5zAN2vMZUjm9QdqfYVGb8WTQUy9ZH4K+Ovjmcg3Qe2liugFSqTzNdS3Mj/JJ62t8RhuAz0BcF99HHnm/2R7oO8AwCtYG5VGfOTq/6rg2fjGVvjhilg7Zf8bmhP8WHMQDEwBi3gxYOXp0cLKFgv31UBpvtOzUOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2GAFmF54SLCRd9Eu8WIHWGrIVtNKXifLQ6qIOSRQ8U=;
 b=uEZs2DuhX5TofwCl9O48vNwHXUQ5lKv04HkvfUJ9bZyiJ1v1+7LQXvAUiXD6Dqv12ez2PcA0otypG8XqkFdEjmEsShwqgbNjCqiZEO4kKtW821s5zwnVoycnYu4FclJPsXzgpLGc3WVWPPdLAxtd4IgZ3Izr315YzQcw92I11M4=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR1101MB2130.namprd11.prod.outlook.com (2603:10b6:405:4f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 07:06:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 07:06:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>
Subject: RE: [PATCH 09/19] kvm: x86: Prepare reallocation check
Thread-Topic: [PATCH 09/19] kvm: x86: Prepare reallocation check
Thread-Index: AQHX63yAqCRfeGSRMUi4D/tAeYgczawwLT2AgAFthgA=
Date:   Tue, 14 Dec 2021 07:06:40 +0000
Message-ID: <BN9PR11MB5276416CED5892C20F56EB888C759@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-10-yang.zhong@intel.com>
 <fc113a81-b5b8-aaae-5799-c6d49b77b2b4@redhat.com>
In-Reply-To: <fc113a81-b5b8-aaae-5799-c6d49b77b2b4@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9946cb28-d406-4efd-36fe-08d9bed04703
x-ms-traffictypediagnostic: BN6PR1101MB2130:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR1101MB213081EB22CF4B7D052408968C759@BN6PR1101MB2130.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kz8+WHXLZqoChn350EqpJSK/f/f7Ci60LnzHBhINwLt8yRYH+KmgrrvCP7jlHvtWDxCr7WPV/7d36Td2vCNE413/dC+QnKOtS6OgYAHWzYqobZlO2dMnKBxI2GKRpBsy2EOe+zMX+BhH8DnmMdYksxGWq9Yy4XrW9+eyZ7X7cRa1Zn7zdkl234tw5KAtBhXASvz+6RTvExqq9qecpUlNVlQgiA/vo0RN1tV24m/9OGTh1VesdmC3vPkrhFJselCUYy0rLOMpmqNQvDxfsWwcx1qgOwLImEFgfB9BvIzXU71RTLRmMM4zRVIY3XVpDMDRblg6LDnHyRH3AJqGPzpEX1ApXbYCKFHQtxuUdyL2L5XVUFXH4VnVYKxKu5fw8jiT8OIm2rgv47McgmXq8Tg4MwPbuDZ1CNh4nz9CHbuk5oqDWaW1eyPH+/6S03UErBYl6qm3h0MhNvGZ6UIOYIx6wBxoPH9g3V4BiIWWcabMY/Mm3YEKgFRPWk363gF57Zsls5tSozEdA1OmwcY84wZwREZhztkx8M+wP4yZ9kiGYmv4YwRFS+eHTRMLeP0nA7r41eH/22DJCtpNaxZUmnykWvmPb/JPSkHB5Rt/eej2Pbl/9vz0bAuCcArZEF+e3GE5jJHNFoEg2J0KGnKHI2nKpq5vA/HXG2leOfGYsdIFk0CcDY/CZSz5m4QObj3B4rD6pSPsDm/9ntIayJLVDGyijd5EfQbiskqseNMTpop9+3s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(921005)(8936002)(7696005)(4744005)(5660300002)(186003)(2906002)(52536014)(9686003)(7416002)(38100700002)(4326008)(33656002)(54906003)(26005)(6506007)(110136005)(71200400001)(66946007)(66476007)(64756008)(316002)(8676002)(82960400001)(55016003)(66446008)(86362001)(66556008)(76116006)(508600001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlNDWm1HcTJ5dlA4SjFscEJIdnM1ZjdxUE92SzB6ODkwTWNqSWJ1VmFONGZE?=
 =?utf-8?B?VmhUSllZYURxZzRYVHhsaUxLRFI5Tis5OVpFMG0xMTBsTnFlTG5UTEQ4S0hW?=
 =?utf-8?B?bG9ucXYyTEUveElDQlpUWUNGd0U4MXJ0d3ZNNVR1eWQ3L1ZKZ3dEcFl1bFBS?=
 =?utf-8?B?RjJLdWNqZEN6QmVoSWlYWDJtZ29SSVdKM2thY1hmcTFSYSsyYVdzVXVDNTNP?=
 =?utf-8?B?TEpwa2lOZTk5VzhXWDgzWXd0VEJlVFExN0ZhWVNIaHEwaGJwREdsaFFYM2Na?=
 =?utf-8?B?QVdTem9VKzJKMllzc1NDNlhLa3BGWTljRms4Z3o1N1hlL29JTWNpOEVaUE5C?=
 =?utf-8?B?a3JhRlZmRy8wVGtub3dnNm94Sm4zNERBNXlkRWM0Smx0aUhxUEZxU2Z5Q1Zt?=
 =?utf-8?B?S1lGMFFWS1BiOTRpTVlaWjhPTExHclJZZHVsRFNQM0NXZ3ZVZ2xXQVFsZ3Jj?=
 =?utf-8?B?SjRoQmJDb2ZMNEIyR0o5THhkRkNWTVV5ZWxaV0x4Y1NXUjNLckdmUnU2ZUww?=
 =?utf-8?B?VzgzMTVraUFKUGdSSS9XYW9nQ24vU2liTmJzakd6eDZ6YW1hZjQ3djZuV0Na?=
 =?utf-8?B?NXlJdGZCdzdkZU5yWDZVUktZSE42RjhmcnlJTHNxajZoNFRsY1BsdkhtWTdC?=
 =?utf-8?B?OU54K0lVUXhUWHhKL2xEOHZrWDA5ZEJicG5ETENzOXcxbE5tdk5TK2VqZFNj?=
 =?utf-8?B?bk5TSFN4SHNqYnBQZVFrdEQ5QlFQTkF0Q1FjQ2d3cTloTEt3TXdRSDN1M1BM?=
 =?utf-8?B?TDRrMjVvVWhpQU1aaWZOV1FuR1dFbFFMVWNxS1R2NVF1SzlpWEx6dFg1OVpE?=
 =?utf-8?B?WmxrVnpWSTNzbFpVbGdjeDJrcDYwMjd2NERNNEYxdDAwSnFBOWhWcTY3Z2la?=
 =?utf-8?B?T2x0bktNY3pmWVZ3Wkl4ZlJGa3pUSDFVaTZidEc2eGhDUldwa015Uk05bFpi?=
 =?utf-8?B?VjlxZS9nRDVhcVoyUnlVblV3TDlXMHZUdmpZKzdsSXNud21OQS9LbHcvbGdm?=
 =?utf-8?B?KzFJZFUrZyt0VjBqSHVZSFFrSGZma1plZ1N6R0lnemZ2NzZ1MHZyQXNaUVdl?=
 =?utf-8?B?dGkrc3BvbnQ0dFRRNWhhaFU2eTBndHdXL1huTmRqb3VkdWI1czVjTGhlQmth?=
 =?utf-8?B?aEFxVjBNWXlRUitjM0c4SWxnMGpUanVkSzdyYjJPcHpuYzZXaFpBdys3ZjYv?=
 =?utf-8?B?bk9LUGplNExBc091SEdBS2lSaWpTVGhteWVGMnJTZ21sTG94Y3hvN3lSMWZE?=
 =?utf-8?B?S0xyMHRoZ1pUUGpiS0RISFU5UXNjQkM0QkMrTDlOcWRwSTlYcTBjT21MT1Iz?=
 =?utf-8?B?bzBubU0weGhDR0lndmRLdDUwOS9wZC9VQXN2TCs2QVBubFhqYmRVL0dUK3BV?=
 =?utf-8?B?ZlRkMXhlSHZ1YmRUWFgxZHhhVGY5N00yeldTdEZmeEZvbmFRRk9iOENGd1Nz?=
 =?utf-8?B?RUc4d1hCb2E0dS9Rcm0vSTdVKzhsUGEvUE5pRHc2RUk3MmE0WlRuOGJDWjZC?=
 =?utf-8?B?UDMxRTdJY1J6ZmNlbjhmWmZ0RUdXbmFld2FiVitTeXFqak5EWFJBaWZEckpB?=
 =?utf-8?B?Q0R2cExRUEFpMWVVVXdmVnh0UnZGRktwTGFQelFUZGgvanhjU3poZjdFV3pn?=
 =?utf-8?B?ZGdsdzU1MWVkOHZCS1Q5a0E2QllKUVQ5SEVLNmttTWVvMkFWK25RRUNsZkFE?=
 =?utf-8?B?RThkSFF4eWs4NGoxVlFhd2ZiU2hSMVFQQzRGd2tlQUZzb1c1d2lGalpaQ1Q4?=
 =?utf-8?B?bk5yVkFydVI3bTUyRHg5d1pvcXRFaHVzL3BWS0FjTEI5TmZ1VGZoQ05talBT?=
 =?utf-8?B?MktZS010azhEY1ZjamNiejhNV2xSZXpCMVRjQmpWSkNld2dyTHliS1RFWXBD?=
 =?utf-8?B?bzE0VkFNYVJvQm16VXRIdlNMdHI4NHI3eUJCYlN0VUVUYzFybDE3Zk5LcTJ1?=
 =?utf-8?B?U0lKM1IvZ3BRbEM0SWtYVGxUMTRmLzNxbFplYW1IQVZLSy9qQW1PR0tHNTFw?=
 =?utf-8?B?bkNJM2RPNTBtSjB3R2syeDJsYUxIdEtqQ2hUdkEzazgrUGJaSmNDd1drTUtO?=
 =?utf-8?B?dHRzZzNCaXFGLyt0Um9UQzFxczY4T0dTbEZHYVRHblV5NDcvNmUwdFdSditU?=
 =?utf-8?B?bXpFbkk0WmdLNVo2ZzYxZFBPOW8vRXJ4WXF0ZjFFaU1DSHRkYnFGTmxOTnZi?=
 =?utf-8?Q?oD3baSeGh8Y+nu2LcEyGRfc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9946cb28-d406-4efd-36fe-08d9bed04703
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 07:06:40.2697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 91969h3E4EBUh0Vm7XZNdu1fb9cDhQrnZpLQiXNMR+QVWWQJwEPd0jpPSaNIsGKrRN4buX+BTdf0NVCKvlDycg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2130
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pDQo+IFNlbnQ6IE1vbmRheSwgRGVjZW1iZXIgMTMsIDIwMjEg
NToxNiBQTQ0KPiANCj4gDQo+IC0gaWYgKGR5bmFtaWNfZW5hYmxlZCAmIH5ndWVzdF9mcHUtPnVz
ZXJfcGVybSkgIT0gMCwgdGhlbiB0aGlzIGlzIGENCj4gdXNlcnNwYWNlIGVycm9yIGFuZCB5b3Ug
Y2FuICNHUCB0aGUgZ3Vlc3Qgd2l0aG91dCBhbnkgaXNzdWUuICBVc2Vyc3BhY2UNCj4gaXMgYnVn
Z3kNCj4gDQoNCklzIGl0IGEgZ2VuZXJhbCBndWlkZWxpbmUgdGhhdCBhbiBlcnJvciBjYXVzZWQg
YnkgZW11bGF0aW9uIGl0c2VsZiAoZS5nLg0KZHVlIHRvIG5vIG1lbW9yeSkgY2FuIGJlIHJlZmxl
Y3RlZCBpbnRvIHRoZSBndWVzdCBhcyAjR1AsIGV2ZW4NCndoZW4gZnJvbSBndWVzdCBwLm8udiB0
aGVyZSBpcyBub3RoaW5nIHdyb25nIHdpdGggaXRzIHNldHRpbmc/DQoNClRoYW5rcw0KS2V2aW4N
Cg==
