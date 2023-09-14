Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6077A113E
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 00:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjINWrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 18:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjINWrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 18:47:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D177A26B7;
        Thu, 14 Sep 2023 15:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694731624; x=1726267624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nTNrjza1iksvr4e+omfyUIQNP56R/MKZD/lBNSASmoc=;
  b=nvgTgDlrQqkZW3pZCm5HcFr7yEQmBHXVGGhexW8EvThM0cRWQ1+Xikul
   lZPhpyTHLwnNvSc6NfvkbbU82xe37S0y3cxsPVxQjmegsePuDRLtxqQEW
   Nbw6wxD2DVKSKtmQZiyeJ105TOWByZqzSNsMWoDimiA8dGioKKPp2vb/4
   CCg3nIvuLWvnNJgGzozxIjIIQJNXAhjBRz+7oYmjgF+PYxOdEKqpOTvkY
   cbpeR4N0bYDw8qQhI4KNZ9Lr1wTRGn+dgSnFPeImhymCyk+9ojG9Ewao2
   k7jCEdofY0nMr5Ju3+q+XE6JaXSPGBNhJhybS32u2GebCCUTd2QGrdZrE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="376434058"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="376434058"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 15:45:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="721457117"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="721457117"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 15:45:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 15:45:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 15:45:52 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 15:45:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3rOkN6ww4wEAUggArZ3eUCMx84S8uXSImrSt4gVTkqoVLjeUfqsseSjO+ZIrF28VtOAQdnMD+fGB1WP7TUVkfrKEr5ceeLVTbKcL0Qv/7h6e4OdYUJkkFxdHehiM5oVEHMWRwpaFS8iSuUxsqkpRPAxSWdan2Hu1/e4ecIGlTLK6zY2AS7zW4NpmEj/Ljr9e+vfiGEqeKNtMVhmdqp+Gb3H51A033ZQQ/fjHY/iTql4jzH77pEm6TQlI3IN9lcNuNp2XYAj8pwG+IeiUUqMQ8BfaVUzFvZaBPX4gZbJQQMG0FcO4TMdbgwt9Jk0SYGXyU+hf8UWl303RhA6QDNbRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTNrjza1iksvr4e+omfyUIQNP56R/MKZD/lBNSASmoc=;
 b=kCout+Or2t/udL57nHu/bad3mogLV7skHavSTfTLUmyRTlWiTSTKhaVqFT9SYzPSL62HiY1hUcFYg44WX9619mgMC1KLlWSDYBOyQpZGTUBI3mXTI7LBtwmqQDS0pnySsAyROhxkXvUVKDSobJxh91vBYGGX3T5kVBaLY6VMCawlDx8vXREyA7d/DOOVH5HgpDbsefwfJDFc9b7cw10nxSCFLEmj1t3CB9fZC17Kqto3x/MAk+y5wyQWNlyJOK/vrcsSQJvp9xN+QnR5HsDO0HJelig3WbWl8ZtnBfqNjNFrRphs6Ze6kLkSdeYVYWkPn7xlUA3q1iWgsLOwY13mcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Thu, 14 Sep
 2023 22:45:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Thu, 14 Sep 2023
 22:45:50 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
Subject: Re: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation
 size calculation
Thread-Topic: [PATCH v6 02/25] x86/fpu/xstate: Fix guest fpstate allocation
 size calculation
Thread-Index: AQHZ5u85jsakadGf40+tOzEQaa/IwbAa7IMA
Date:   Thu, 14 Sep 2023 22:45:50 +0000
Message-ID: <d05a91f12cbce9827911c23afcfa5fdaf2acb5cf.camel@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
         <20230914063325.85503-3-weijiang.yang@intel.com>
In-Reply-To: <20230914063325.85503-3-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7134:EE_
x-ms-office365-filtering-correlation-id: 0f2a1e00-b76f-4e49-dbdf-08dbb5745886
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V3DA++Mqk3lOYTPVbLPG2gsbn1Q6K/LZWxdgMtxxS/9uMe5tW/ed4tmCDRigixrv57wUe+KVkBt520DTy2ZACyZ5vlBCBXiRpKPZ+AVEgLvL0fjW4XTZLrpUBnMeTe6/iPa01s/zlEY7R+X15yf416Mm8nAtpqTNcsWfbH/KAf2RzhCnlR7Pqa4MKyjdbu2ukRRDoF4qL+fEU5bnBksJjRX3BxeHSNVNy4b2D78ngA6dR7L+y5oFocc088jLXgs9QX3XU3HmIPhwPT3h7hHV/sbTal0SJEoPx9pFEGCJXDtft6Y8JJ/eVVMTcktaajpCjisHP0tByiDgkoGPU3XGvvAkA0Ju7D252lskHV3fYuWTXhEX0ufjjsiC8YvjCYKzR1Le0i6CgiZNmrlYoP0FaB+GhxLzatrr7vKm5q5ytjUBf2o0SZDF+xKFA6lK3eNbMvjQBv4so6eJFThH0PDhOLdvw2SdxFrHmnVt0hh51IIQ3THd+NFI91Hx8RMg1DmwC/HW51Lgb9BPqUeEPbV7NDj7wJe+TzfOxFlw94cUnwhotT9h79LrLZ8a1jm6bukHukVyU+Ufc6FKguiItypdvhcsCetnXQ4+VY9sDKnX9iyQOmTtgaUMRuldQVSEqQXv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(366004)(396003)(136003)(186009)(1800799009)(451199024)(122000001)(38100700002)(38070700005)(82960400001)(86362001)(36756003)(91956017)(110136005)(6512007)(316002)(478600001)(71200400001)(5660300002)(6506007)(76116006)(8676002)(66946007)(4744005)(64756008)(54906003)(66476007)(4326008)(66556008)(41300700001)(66446008)(8936002)(6486002)(2906002)(26005)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXlna1NLeWVkZHJrMG1xUlc3bHNSa1FneEhOUHVBMlVOTWcycFpmL0d1Q0dr?=
 =?utf-8?B?cUV6NEhVYWNOaWFJWDNKOEV3dDZUa3ZpWmd0U1FZOFZOejRsQUFwdWVvMWcw?=
 =?utf-8?B?N0lKcUtEQlBkQUlDYU1TNU9HSis4Q2J1QkhmaGdsbkcrT0o4c21PU1R4Wm9j?=
 =?utf-8?B?MTM4UUhmUkdFQXNZWDJ5Um9ETENUQnJoVkdyUU9QcG0wd28vTXNhUTFDbzBm?=
 =?utf-8?B?TU0zR2RlRzI1Vzd2bm5oS2E4ODVyanNraVFDbS9GdC9tL2U5MG1PSHhqVGhT?=
 =?utf-8?B?Z1h2K1BxSmVkNnhsZnNNY0x3UkNQR2ZxTVlBSVFjUkpMVHdmQ2JrekJRdTlS?=
 =?utf-8?B?S3dHdTRuNUJyWGxKZGFPUVR5bklWeXJ2Q3pMRVYydXhlcGJsVTR1WlF0M0VM?=
 =?utf-8?B?NEgxRUU5dkxMazFzdDdsSVpyUWN5N3FKN0ovYTJYdUtmcnd6ZWZZeTJzRzJT?=
 =?utf-8?B?VlMrNEdVRlZCdGlYNzlYbFd6K2l3ZUxaQ2tnL2lyUk9za2tOMUxwbTk4cmlS?=
 =?utf-8?B?R3VZT0o4YStiSk1HVkk3dmlBNnJETTVuR2VVb0szd01wcnhQWUJXdS9zUCs0?=
 =?utf-8?B?RnR3d2NxcktTSmZRZmFTd0xzdkhtcFErQkxLaGFUZTNNU3R1L3Nwc21nQ050?=
 =?utf-8?B?NUJaRUZPT2NlMWhvSHQzUUh4aU4zVDlvYmRvRXRES3dUYmlHcWtoT3BuS1M0?=
 =?utf-8?B?QTBGVS80dDNzdjlXRkVJOWxTMGdaTnNuZjdQV3hxQkFYVTR2OTUrRXB0QXN5?=
 =?utf-8?B?dVI4Y3E0SG5ybVF2cE9EUE5vMTd6MDNsV0FPamVyQ05Fb0ttcnlxNXg1czdG?=
 =?utf-8?B?Ny9LdmxWSUJFYVNGUTRLR2V0MldIMFBndmkzQmhJWXV2QjB0enhtQ0RONW1t?=
 =?utf-8?B?RmZ1YnRYY05CeGhZNlpTVnVtU09tclVERFoxZWYvVGRVS082aDBZQ1BYMG9v?=
 =?utf-8?B?SUFuVW1RYXdHQWFwdW9EQmlzcmY1VE1PNlBsVzdFc3hRV2VsNW01ckM4NXBn?=
 =?utf-8?B?ajhueU9KMWtDSDJybXlpY2xBYkdCbVR2cXRuUmRaSWFhZG8yeFlWZ2FvRGZa?=
 =?utf-8?B?SWVyRFhDMHgxZ2hSS1JNemowTllFTVdXWDNFdkFiOVdJWE9YZ201MW5pbEJI?=
 =?utf-8?B?SkJDNWNPRWt6S1ZVYi9aRUJSOG8xZFVsdVFldjJIaFQzQmhINWFOYWlRNUlE?=
 =?utf-8?B?RnZwSjR0OGcxUnVEZjNBbGhGTVN3RjZILzdlbStURGtWRThTeUR0RFA0T3FN?=
 =?utf-8?B?T3UwMFlFdWoyeEZqUFhUUkVqT2ZTTE8wOXNHaW5Dek1IU0JRVEFoMjhCUG5N?=
 =?utf-8?B?c2p0d2ZVeGJKaWlXUlJtQ21GL3RqU1ZKZlRKeEhlR3ZWbi9wN0hucjlRUDYz?=
 =?utf-8?B?bFBONUR1aWs5Qy82MDJLVXlCZTYzOWtVQ3RVb3c2OHNlUXN1Z2JOaDdGb0tT?=
 =?utf-8?B?SDFxZmdJT3A3c1hicHZvSUl5NFRsUmZJZDlKZ2owUDR4bGtIcXJwNnI5Z3dH?=
 =?utf-8?B?YWRyTzJjcHNsNVVlQjhtLzQ1TXdRNzR6cmFDRXQ5NW5DUXBndU96T05ma0xT?=
 =?utf-8?B?MzJpZ1dsVzQ1QStkTE8yMGNrM3Z5RUxkTW9BMWgrNkR5amRPTHZ3RmZMMUpm?=
 =?utf-8?B?cWZzaXZCcndiMDRwNElBNDlJRlY3Sk15Q2I4NkJidXBnZjcyVlU0ZndiTC84?=
 =?utf-8?B?emoxT3dDY0ZOaCtkbUJqemF6M3BNY09RZnZlL0czc210Y1g3dHh3YWs1K0Rr?=
 =?utf-8?B?STA5QmpYaHdtV295WUdqYjY2K09iR1VYc0JHTGVTZ29GS1RCRHR4K3psVHlV?=
 =?utf-8?B?TmhXckQvNHc4L0xIOG5EaVNkdEtWdVdVMDZHd0U4RTBaY2FRMW44RnBEMlJw?=
 =?utf-8?B?OWtyejIrZHFROXFDdHlsOENKbHRYZm5wcHRmNnlBMDRHR1ZYeTVrdDZxNmhU?=
 =?utf-8?B?cEpyODNLWkVOWmNBODZBRVlUaGhyMGN4NEJUa0lYMmhXVTNWNTNjYXNSNzdJ?=
 =?utf-8?B?WjB4YTZrR2NoQWszcExWWUFsS2VLY05waUJHb2VBQkhKbzNyc2NKelJtRkg0?=
 =?utf-8?B?bmFsaEQrbWZYT2pFNzN0U0cvOUZ5QWtLb2hMYlFxRkQrMWtuT2RuUnVZQy80?=
 =?utf-8?B?VXl4ZExpU0JnMS9DNW9ZWS84RENEWEJROFhpK0lId3Myd0xQMElKbElIajBv?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2C52F59E205FC4BA357194FF226D22D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2a1e00-b76f-4e49-dbdf-08dbb5745886
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2023 22:45:50.8815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 207aPS94tJwpKbe4pLcXJ8Q+GNlefn9DAbX59crGydcXQ0/u5MZq+ddHN6MkaIMoJYcnMUAPor1uXGyb2Qkx36peEbCYaSMfS2VBQB6SHAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7134
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA5LTE0IGF0IDAyOjMzIC0wNDAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBGaXggZ3Vlc3QgeHNhdmUgYXJlYSBhbGxvY2F0aW9uIHNpemUgZnJvbSBmcHVfdXNlcl9jZmcu
ZGVmYXVsdF9zaXplDQo+IHRvDQo+IGZwdV9rZXJuZWxfY2ZnLmRlZmF1bHRfc2l6ZSBzbyB0aGF0
IHRoZSB4c2F2ZSBhcmVhIHNpemUgaXMgY29uc2lzdGVudA0KPiB3aXRoIGZwc3RhdGUtPnNpemUg
c2V0IGluIF9fZnBzdGF0ZV9yZXNldCgpLg0KPiANCj4gV2l0aCB0aGUgZml4LCBndWVzdCBmcHN0
YXRlIHNpemUgaXMgc3VmZmljaWVudCBmb3IgS1ZNIHN1cHBvcnRlZA0KPiBndWVzdA0KPiB4ZmVh
dHVyZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBZYW5nIFdlaWppYW5nIDx3ZWlqaWFuZy55YW5n
QGludGVsLmNvbT4NCg0KVGhlcmUgaXMgbm8gZml4IChGaXhlczogLi4uKSBoZXJlLCByaWdodD8g
SSB0aGluayB0aGlzIGNoYW5nZSBpcyBuZWVkZWQNCnRvIG1ha2Ugc3VyZSBLVk0gZ3Vlc3RzIGNh
biBzdXBwb3J0IHN1cGVydmlzb3IgZmVhdHVyZXMuIEJ1dCBLVk0gQ0VUDQpzdXBwb3J0ICh0byBm
b2xsb3cgaW4gZnV0dXJlIHBhdGNoZXMpIHdpbGwgYmUgdGhlIGZpcnN0IG9uZSwgcmlnaHQ/DQoN
ClRoZSBzaWRlIGVmZmVjdCB3aWxsIGJlIHRoYXQgS1ZNIGd1ZXN0IEZQVXMgbm93IGdldCBndWFy
YW50ZWVkIHJvb20gZm9yDQpQQVNJRCBhcyB3ZWxsIGFzIENFVC4gSSB0aGluayBJIHJlbWVtYmVy
IHlvdSBtZW50aW9uZWQgdGhhdCBkdWUgdG8NCmFsaWdubWVudCByZXF1aXJlbWVudHMsIHRoZXJl
IHNob3VsZG4ndCB1c3VhbGx5IGJlIGFueSBzaXplIGNoYW5nZQ0KdGhvdWdoPyBJdCBtaWdodCBi
ZSBuaWNlIHRvIGFkZCB0aGF0IGluIHRoZSBsb2csIGlmIEknbSByZW1lbWJlcmluZw0KY29ycmVj
dGx5Lg0K
