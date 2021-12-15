Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09263475293
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 07:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhLOGOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 01:14:51 -0500
Received: from mga12.intel.com ([192.55.52.136]:26948 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhLOGOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 01:14:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639548890; x=1671084890;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Z6Sfpghe11E6mXkcw1Fbto2Wt66fDkhMMLAIUR0pfjg=;
  b=RK/sy8Z9pGzLLVL9fVpnV51KWamNgUpcJjzGLaL3Oo0s/XY4ZywDFdLr
   Afm76WwVGAdZctsYr8FH4RLhH7M1YwyvlmtUMv2ZB8enfI2o05a7/QLmm
   sYbcFztuH8g99msIno7LHk6UNmUbeCTl60ADPa/IboEF6IQmG1fDP1mCD
   R5OwLXDEIc/hKRil7asYGFrX26d47UUGADuVPD3EIdIwTPj62yzTHfxka
   7aTlwioSW7Ao/YV9JsNNlY3ZYIxjmOeC1xkJgTjWmKqw5rkfIaINsbhai
   5gvt76Z/eIrpiiv2Rh/ZAcaCcBqq0ozR73vMXuebtacirgOMFYSZXNG3F
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="219172645"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="219172645"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 22:14:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="464140375"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 14 Dec 2021 22:14:47 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 22:14:47 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 14 Dec 2021 22:14:47 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 14 Dec 2021 22:14:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTnkQ7s9ruVsc2Ky/FR5gdsZPqqAUEPQPdCb1B3ojFG4zt88xRPimsHtsV98mNelQefJY44GUBhArdD55a7Kq1AzaJi4eVFW5lv4WXvg1G0W38G7djhj9/jK15yO/KIMRaPnyIHWT2jfbxFxR6RcsDcfBWH8V+4k6tY3wVwA9QLy6CZPJpSYKFfxLP+gWEQi62jBbuZvmTioYh9niFd5lC0m7w9HFuBxa3o7rU99/CEx231JXpd/1KTNFUtHKUFrR7haCB5XFYC94evg7qXrUJ0I9g9uIQWwF0tIO6J5Ge+XC92BRYVkHwLh5mrWNovUnmy83XdPNyNcW3xkB/8PXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6Sfpghe11E6mXkcw1Fbto2Wt66fDkhMMLAIUR0pfjg=;
 b=HcPy2tgVHgu/izySobpdjM2roJTq07oq510068cRRmuC1GB3fYVe05BZkQIHdHWWxpOzll69IcbiNbC+sXGAtZ+Bhcs3QVyMxSsJ1JHStelRgX6KpPmOvDVs6ncPXglXofA51vBMQCwRrFhFbjedlSNSrF9kicMBaHSfaBadrvRC09DowYfX4w/S0Ej+dWWnY49OSyCU5XoQxz9gOKfM8qYDCM/fXYm2vMpr5kEdcyAZY8v3NfqXE46nPhHd4XYz4yxV6JIM1Rlxtc8n1Xj7DKtXfhp526ECUeuGR1TWGf6utBM+Pe4Z8/ZUxvYh6UgDopjQUXBuc4nQX6zdMAc0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6Sfpghe11E6mXkcw1Fbto2Wt66fDkhMMLAIUR0pfjg=;
 b=lr0vwWnaXebcuQBDq9qL87j7kHJPJQ+6jYNAhO7vTIRIYH5UV78L6ngqhL7UfJWwX9g5wAENFtTm3p4UsuLShl17oieNO03223dbuFihovjBX37VQbvxi4G5FGaIkvV4KKlygr9lFNraBdl08Qm5aCKebUdF1w3qfl130zlDDtY=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN7PR11MB2609.namprd11.prod.outlook.com (2603:10b6:406:b1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Wed, 15 Dec
 2021 06:14:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 06:14:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JViV3rUbi5iYUCgo3JeBUJUo6wxgJXAgAGTtEA=
Date:   Wed, 15 Dec 2021 06:14:44 +0000
Message-ID: <BN9PR11MB5276775D3CFD7F90B6F306F48C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9dd8542-9ccf-4f2d-d28a-08d9bf923016
x-ms-traffictypediagnostic: BN7PR11MB2609:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN7PR11MB2609811FED30BBD8DDDDA6978C769@BN7PR11MB2609.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T96VKsDNvUk1pk80cGFyfAoK5TKl49cc4uD2Lu7cZEoOr2jLFsMxcDbYvnEL1vqFyqFWdzaY7VSGIYE++jOnu5VD011NVCgvT6r3PKZ5kPRS7ktw8sTPq9QI0Aia1b1fQE/UVD+UmpTXbQNB6qUKLFO+M67gfnwalLQaEpOiWB+L/wzB7QYFtNQU085vQxk0/E3lfHdEHz5zT6uzemGXqNAsmM8ZLeCZV2/6tpYb8PyLT7yK3/SQtNEKZyzbJo8kij9zWIvFeV+pEQg12aNCYlwDAPBUg/TrB74QStpCGC0IZOMSBGG1lgR5Jnl6Ch+lWysKaaorOTeHSaRSbBjjn0volSEiU7wEAajT1TUML4v2paDLm5/kXJFSWyjKAkHB1u+XFH/IS3s6IEgx8tv7DojaITPUPar2fGMSszw5kbJYhVHYp0rOUeoS1XM6+1wFRfx6lQJuB99TGw5yBehrWCpWc7e/6zvY6IeTnPejklHskIke+bLPsMFNvDqCMZ3S5hFEfu5S/MIO8UZBRzPnoEFo7wc//cPpudWc32om4oSzZ49pQ2gOxC6sNfyxBoZUMRRARtnYtkr3GsKYTzlfYO8Gf52LDh/v0r/8rRc5kmxlznpaf9PpcxLptjvMCpevYFevidvEqwC3bdPSCAlBPYP1lzNxUHkvXC7Ee/zAGTT7pFxzyI3tFp/aCWALHPmXRr95BSGEzawqfBv4Axv7bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016003)(5660300002)(4744005)(66946007)(33656002)(66446008)(83380400001)(82960400001)(38070700005)(8676002)(186003)(38100700002)(26005)(122000001)(54906003)(66476007)(4326008)(508600001)(8936002)(71200400001)(64756008)(52536014)(76116006)(66556008)(86362001)(316002)(2906002)(7696005)(9686003)(6506007)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjF5dC9vb0hsS1J4UlQxb0JMR09mMTVSSXBQT0QvK0RwUlhmbGRyV3FIanBv?=
 =?utf-8?B?OWZ2aVBDNEpmQWRKTTh4czFGekpscU03S0JseTE1Rm51ZC9ZN3d1QzhzeGQ0?=
 =?utf-8?B?Nk5sUWk0bXBUZnZ4L2svbC9iakNkMGVvdjNNaDlZOGN0NjdXSWhRdnVnbzhO?=
 =?utf-8?B?ZXhxVEdOS0ZMWTJ5bXZGVGtpVnkxc29qdjJjZE1rTkxxMnVXTXFFM3VQMlVF?=
 =?utf-8?B?dlFTUXNKaVRVQmRvdm5NRU44NjYyRU04V2pGNlBMME4rWHRsSTBwWXJ0U0t6?=
 =?utf-8?B?cU52MlRUa0xSa2xyZHM1QjRKY0wrTjZSRFFXTy9hcHpXWUx1ZXFEdEQwcmJu?=
 =?utf-8?B?Q2x5RzlTeGRKUFJNc0xaNmRkUDQySHdOUWhvL1FGaXZReGVQdjVvVXNnOEtX?=
 =?utf-8?B?c3VaV0pneTR1OENHUDJPZXkyMXpLSHpNTUdIcFVsWlZFbFNyTFJCOXNGdytX?=
 =?utf-8?B?NFNlMnJtUHNSUTA2dmdKYlFvVU90MHVTN3pURkRNZDNSRFh3VjRGTEdJRlh1?=
 =?utf-8?B?UU50M2htVDllVWVmK1h1akNRNldKa0d3MzlDTVdCSnZVNEUvMFhmclJqUGJ4?=
 =?utf-8?B?aTh2Vk1EeDRIY1daMU5QczRrdGJJQmcrQ3VVWWlnR0JjMlp6SDVHVzluNXZl?=
 =?utf-8?B?dVQ1UTFLUktsQUllYXU0cVRsSXViVXFBcWNXOXZYdmxKWXNVek0xOUhpYUpL?=
 =?utf-8?B?VWhrUDRTcDhobld3dnZ6NjkwSHREMDBLbnJPN3BUTkd4ZU9UT29abGIrRmhU?=
 =?utf-8?B?aXhGeGw5MkZPdnV0TGNiOGlaYmtkZjYrZTUwYVh5aEc0am9FallhRDh0SXRu?=
 =?utf-8?B?SFN2eFV5MWlGQVpXbEtNZnZJVGlqTjg4aUNVUHhoZ0dQSmFXUnJrRUkwbEFp?=
 =?utf-8?B?aWluSlBzMVpqb3krS1FKYUhpdWlNeVVFQS9YbVVIbVRrVExLbWEzanNQc2lD?=
 =?utf-8?B?SUpyNktLQW1pYU9VQVUzQ3VJektFOVo5RXFuTzRUaDBCKzNjUmJUMDBJK1BC?=
 =?utf-8?B?dGFyNUZJZnppL1FWV09XRzBDTzB2QXVVczVWQ2F5elMzejFBMUY2bjFMeWY3?=
 =?utf-8?B?dXF6U1J3bVo3WXR4V3ViZmM1eFZwK0llZHNCNFpLTjZNMlZZNERGWjRZYS81?=
 =?utf-8?B?ZDVtbVNQTlhLNzhDYnQweVBlaHRXQjF4eHUwQjRqZ3pQUEh5dlk4NVBUWUFw?=
 =?utf-8?B?Y2dWK0VOQ1ovUFlIVHQyVzJRSTBGOHNJMlMwenRaSDI5VnRrY0pIMVB3Uk1L?=
 =?utf-8?B?ei9hbWw1azI4akZDR1JqYTBIR1pYZFJkeEpPQnYyR2g0bXh2Q3gzYndEek5v?=
 =?utf-8?B?MmpjeVQ3QVl3YkpkdXN6bG0vSmNNbENrWXpEREpsc05QMVFUSUFZdUNiR0dC?=
 =?utf-8?B?ZmtBMlQ3Y3JCdE15Q1hBYlNmOGRaRzZrdGk4WFEyVlpUTzE1QzlxQUlFYUUz?=
 =?utf-8?B?ZkVUZUpsU295WWFEUkp3NWs5ZlBEVlFzL28wSEk4dGtUcTZyS1A1MFdOeXFI?=
 =?utf-8?B?dU9EdFdvUEt6TkFIaUhoNE05Z0FCdjlFNDg5Z0JwSUQvZTZ6ZEJCL1J4K3hh?=
 =?utf-8?B?SWIrKzRJcEF5YjBWODBQYXBldGhaZnlyTXY3cGw5WEJidzdyVllFRGZEL1Np?=
 =?utf-8?B?Vk92T09ZeFErY29FYVErOVp3TEpwYjNwODBFcTF1dlNSQklkMWJoM1V2bnVz?=
 =?utf-8?B?OC9Gekg4R3dJZkl1V1l4ZEM1Wjl5bEdyd3BjbFFmVGxWUlZYZkFCaHhTZlJ3?=
 =?utf-8?B?anJNN1JvUW9wdVNZUnUwRWF4VWpOTXZXMzY2bzc5cDZtb2VPL3dEMGdCS3lx?=
 =?utf-8?B?RWNVeUdpS2UrTGZpZjNFYkZ5SUlSRTNOb2tTUHl0NkZQNlVnRTVHMHFRVDRM?=
 =?utf-8?B?eW5EdU5MZThqTTlodU9WNUFZZUNsblkybTVCZUJ3ZEFMK1lJSHRPVzhUNU9r?=
 =?utf-8?B?WWZsRUF2RzRkZHdXVFd0bEZ1dEpJZ1k5T0NpemFxYU50TlVLdXhsemt3TVls?=
 =?utf-8?B?d2lYSkRiejFMRDErdXhqM252NFplbmhzYmZ1cHRtRkl5eHc0bkdTRmJKdnV0?=
 =?utf-8?B?RmJjRzJUT0kwUHhvT0ZMV2pTZ290bFd3cEhoMVdReUlwUGU5RFVEekRHbnEy?=
 =?utf-8?B?R0RFN3Z5NHZTYSsxK2ppRHBKeXdJeGFmR01sNHdIK0hhSVF3WEpqMlN2V3Zr?=
 =?utf-8?Q?hiWlEQOgGL4x2CY3b2CAFaA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9dd8542-9ccf-4f2d-d28a-08d9bf923016
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 06:14:44.1582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ocT0D8OZGCGm5Buqpel2sLbTuyaoCt6ZyTNHUm4HImxq93iy9VQhwfF8+gKqZHENeoGX9rGKDyf7oHyC/q0lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2609
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAxNCwgMjAyMSAy
OjI2IFBNDQo+ID4gK3N0YXRpYyBpbmxpbmUgaW50IGZwdV91cGRhdGVfZ3Vlc3RfeGZkKHN0cnVj
dCBmcHVfZ3Vlc3QgKmd1ZXN0X2ZwdSwgdTY0DQo+IHhjcjAsDQo+ID4gdTY0IHhmZCkNCj4gPiAr
ew0KPiA+ICsJcmV0dXJuIF9fZnB1X3VwZGF0ZV9ndWVzdF9mZWF0dXJlcyhndWVzdF9mcHUsIHhj
cjAsIHhmZCk7DQo+ID4gK30NCj4gDQo+IG5vIG5lZWQgdG8gcGFzcyBpbiB4Y3IwLiBJdCBjYW4g
YmUgZmV0Y2hlZCBmcm9tIHZjcHUtPmFyY2gueGNyMC4NCj4gDQoNClRoaXMgaXMgYSBzaWxseSBj
b21tZW50LiBUaGVyZSBpcyBub3QgdmNwdSB0byBiZSByZWZlcmVuY2VkLi4uDQo=
