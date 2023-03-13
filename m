Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEF06B7C0F
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 16:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCMPhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 11:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjCMPhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 11:37:09 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF98D3346C;
        Mon, 13 Mar 2023 08:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678721828; x=1710257828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MTVTHVJ/jz8v56j5qWlFje7/kwXxBxhmiU8ER1vfN2c=;
  b=i14uIn4LIw0cw5vTUNjax3JlQ17jQPCkCzPa76f7i7KZTfshlUkRAfSf
   jswXl3QA9HGFP37H0ruflprKsR6mh2KlNCDiCyjv4MfyEyt7gW4sQjaQi
   tB/88mwgEBUYVG+/RAIeqhCR8DyF150ciJsSFv6Lo/UvpaVKFHOhUrh1a
   U3xSMR2jISIH1zxix5wUYX306ey+Gu6m4oqMRqVADvSf8N1wnAtZOTMdr
   BuN5lVngTBNeoM7AgA39wlyVRl3LZPzpB+VgdxBjZ2QaGNvIAAkjjkghB
   Iaci9gOGKLppH96NoCshcjukHu07BfOBTYQkDG++3eeW6Yf9xB1lzAzAk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="334652772"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="334652772"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 08:37:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="681074906"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="681074906"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 13 Mar 2023 08:37:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 08:37:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 08:37:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 08:37:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWb+W+4nMDU71cdR7iAbMCl7SDITEJG01fpZVZytjASOsqGFpGrCGjPjKrTfFZBFZ+IXl/eVZJXF2LtO/pdPUfVKGIugJvnhrd6W7bc/GxWyQkpd8LzM6uy1ASMD09WsAQDe1fO33TFfnRvTquUIsCflWjlw+Q470qAe88XleV/qDC4D28o0t/dgcvDE1x6yATD9imwPPclLx9a0nH7HuEjF7VDzHsSgpy+zWTn9fJYRz3G9bj2rgImtqyo9jNlI/g9fPcEO9AkjStnzoutRNSY4ttu9JhAWe/GUmUUYUd8Bz6isKKdK7Zz3iLzVG6+JugXRkL904KasK7AwtP0wHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTVTHVJ/jz8v56j5qWlFje7/kwXxBxhmiU8ER1vfN2c=;
 b=iF72Jx8B9F8ED/otgKr2SdV8qRqiS9asUbTQxmdgwibfUg6skRRVgg0mCgtTMafub+Ibt+3diFSJvcp+Si7iSD9UAAl1f5AyKurUvaiOclsF9iMgS1Za1PopEg7HCNUIGx6rHK3CshnTWZPkY2UPr2slBhPCFD2M2jFKjR0uAn5qbBQyTJ45ip4tgeOXrtmrYaWTtWHy831x3saIEx7HxLp9Brz/9xNkg18teFslD6DQWvt2WocLXzqjeANxWexo60Su8aVxJik692/1jJAbAzkvuMQJUeWzU/Wbpqe6hhhCU3iuWZ2znDogHebf4IvQ2MYQuqklEEgzi6gqqT3BDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 CY5PR11MB6461.namprd11.prod.outlook.com (2603:10b6:930:33::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 15:37:05 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6178.023; Mon, 13 Mar 2023
 15:37:05 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: RE: [PATCH v2 02/27] KVM: x86/mmu: Factor out helper to get max
 mapping size of a memslot
Thread-Topic: [PATCH v2 02/27] KVM: x86/mmu: Factor out helper to get max
 mapping size of a memslot
Thread-Index: AQHZU6+3k40YPk15gku1JV2dOECbPa741X1A
Date:   Mon, 13 Mar 2023 15:37:05 +0000
Message-ID: <DS0PR11MB6373DA9C535E2EAA54E38AADDCB99@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-3-seanjc@google.com>
In-Reply-To: <20230311002258.852397-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|CY5PR11MB6461:EE_
x-ms-office365-filtering-correlation-id: 7db151d5-6658-46da-d585-08db23d8cc60
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0UO4uXLAQ/CMHijgPOS22TF7wlyxNoPmfz+WyyyV0h8XFFERasHbtkJpEUQ9zwGEzXub/XbCuQTCI42lR2yAbKqezBlpJThCPgpMF9/46obkVzjEXG9LLqboHyJCAjAiTTjb6CoEYMdjQij3Kuz8l/C8RvTrl7Gx+eISsAQNVgifTB6VpASkOeYiNJv4efLWRSFycpH+zaaxV4D6BPiL3stMlXYrzFWzNp6LQqH+C8liY3mRhVlq8P2GahfjijXbD1nI97EmK5fAv6o2PMnmZVUmnglVeT+f4jrEfkt3SAwfLJesw49hG218CZm9QQF5tX5D9CZ3Xu5XyhY8ZJhOb+knNCf+vHpChFdltZ/h3wH2Pb1DA9aXLaM/pb25NaAPRnSfNL48Cm2T+p5VoAqKOdKDr2h4Iw1OXFW9tLMl09tM4M6/njJUBszBfmnCeZiy942AQ/6XbJBFOoUojaWME/YuvtXrav8J4fBGBLDJpxgW8B2/SIgpjHsaXn7739SJHZpBRc6pmlhPThmTo+itbJH7fzuLsn8dOXIYwtUgLveoixXrn8m9ELZcWhy3ZPKhki9OiNMlVoXo6kIKNw/r0Eg4I+mo+LAvdrSqvNZVy1omEFNomsndxJGz5Db6DUhqbUbkFnYQSlchkpgdE0Q/IETEilziNXniK/u6gachAtDsyJ3TFfvDay4Rr3OE3QOuUKv9ByMn2W6gtcWcVCRknA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199018)(8936002)(2906002)(41300700001)(66476007)(66946007)(5660300002)(66446008)(66556008)(4326008)(64756008)(8676002)(76116006)(52536014)(316002)(478600001)(83380400001)(54906003)(110136005)(6636002)(7696005)(71200400001)(6506007)(26005)(53546011)(186003)(9686003)(55016003)(33656002)(82960400001)(122000001)(38100700002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTRTRTk1QUZCa0xRL2VBU1BvNGJCNnJJYTZwcGNObUR3djErczF4R1pxdHNo?=
 =?utf-8?B?V1pWMWViaVRZbWJTcGJzQ0JNTHBSbEZXV3JqYWNrU29YM001ZGN6ckFKUVNR?=
 =?utf-8?B?MENDOWZ4QXR2NU5OVk5IeXFPN2pOUXV1Mm02U3B0dy94VmlGVFovNzkxM0F4?=
 =?utf-8?B?dFZRQ0lxSnhwbWtUR0dnTHFjN21tUXY2TWVkT3lzNjRWNStjODFuaWU2elRv?=
 =?utf-8?B?cyt5eU5wKzhndjlBcVUwbFV4Rmg5UG1waHIyODZhKzRjMGFWY3YxU21oQVRC?=
 =?utf-8?B?V1BtUmdkakl2aHlwcEp3cGN6dDBuTG53cUdSVWtEQjJ6bEo3eGduR3lMRk1k?=
 =?utf-8?B?Y05BVmVqekhYL25WR2p0dVZLWi9sZFRMZmFPTHR4VzJlVnF3V2ZoNTRRZml3?=
 =?utf-8?B?Q0k0bWZNZ21MZ09zN3JadEV6UlpxeStOQ0l5UUxkV1R4QU1oeFVReEVwNEcr?=
 =?utf-8?B?WWE1amtiT1FuTXArcUw4YW4vSGM3N2ZCQnFnQTg1eFJVK0pGdDA0Tk1oejJt?=
 =?utf-8?B?TEdGK3A4WWNYbzVQZGJVL1p2MnNhanZRZ3dLTEw0eTlMYWp2TTU4Qm90a2JL?=
 =?utf-8?B?MFNYd1ltU3NlbGtzcW53WTRQeVNrQnNHMTdzeXNJRE5hQzEwRlZES25USkNI?=
 =?utf-8?B?Wmd1V3c0UmNjbklBRENyaXAyOHhmcHRrR2dnSXVUOVFKRjFxekZEN1ZKQ3dt?=
 =?utf-8?B?QUpuZ2E3RmNqcjhMNHRsRDVZaGJwYnk2eDRXMkRmUWNoZWl3cDEyeDFabHhv?=
 =?utf-8?B?TXN1SzZmQm5oRVYxSHJ5RGQycnVBV1A5MUw0L0hXSEZtUVR5cWNPcktvVTd6?=
 =?utf-8?B?dWJhL000QTExeXVtQ0dqRG5nRUhMU3JJV3RPbkpaZ3hBUzdIdWQySnFxN0dW?=
 =?utf-8?B?UWJSbVJxRkNhd2pDZkFYTXhCRzJQU1hURGRDMlRnRWk2emtpMWNrZUZnK3pS?=
 =?utf-8?B?WE1Gd0hWY25uMG5MbDJmVmpIZHBUZmVvTDVsWExDREhpYnlneGJPUmwyWGlI?=
 =?utf-8?B?aE5MWHVqb1p0Y3JVME1pb1VVMytjQmRrTG9mWjBKMHFoSEJCMWNHRWdDTmNL?=
 =?utf-8?B?aUNRakdZUlNHeFVxZ2FtSmhNaGhaQ1UwMkd2TGhsTzFiZko5SGowYXJCbmJK?=
 =?utf-8?B?OEVlYW5TOG0yVjlIWXU5S1dCQ05VbkpTS2YwRmZHNE9zYUZDZEczVU9uc2xX?=
 =?utf-8?B?bjJMNEVjQm43NFlVVG5RMDV2T0RaaVR3cWxSYzdrdjkzUkVJZU84N0IyNWRH?=
 =?utf-8?B?SG5Hb1paeFJ2bWZSaTZNNzFRVVFETWFld2ZlTkZFc0swS2owbHFSaXFrUlR5?=
 =?utf-8?B?TlVFTENkN2tNeVhYTDJuaDFJcSttOXhKdXN6TnA3UXpnak1paTgvVE0rU3k4?=
 =?utf-8?B?clZGQm9rY0k0MnA3NWlnaHgzNm8ySnVHa003ZUNqRUpRZmovekJSdEllcG84?=
 =?utf-8?B?UFZKdTVuV1pjMVRVTFRWbW45cjI5V2d6UDJoK3pRQ1pwME1vRnlhZElBa3Vt?=
 =?utf-8?B?SmlEbmJVRGNHV0JIL0hDK3dyWGlJcWJBTDgxWHJ5eG9iSVFsbDVDcDBzanhC?=
 =?utf-8?B?czU5Sm1tUXR0RDdMRW05azU1WjIwYmtwT1k5UTVnMGlWSzV4WFN5eUF3d0pt?=
 =?utf-8?B?OHJ6MTJDcjlCbUluc3pWZjhtS2ZUdVRKTFZtNWUweGN6SEYybDJ6WFpmZk90?=
 =?utf-8?B?S2ZPQUMyalF2cE9vck5oU0czenMwTTdSbng3Rlh1YmpCOEg5Yzk0KzFiSVc0?=
 =?utf-8?B?VzUxMVJlc1NNTGJPSDRKQ09Ec3hBWWRrNDZWUm1lN2NqYnNMb0N0V0RDNHF4?=
 =?utf-8?B?K0kycFlES0hRS0J3Z1pISXJrTnB2bTZPUkZiV2ZZMUZzTVZhL0V2RWM4YWlo?=
 =?utf-8?B?SVoxa2wzRHRzcVNUM3RNOXV4N0hiZldYS29semYrVjlWNEQ0b1ZLbzFaZE1U?=
 =?utf-8?B?d2l6QVhCdDZ5Vm5rYnBZZXRqUmR4bHlzbndhTXpiSVl2WjYvVmpvZTFTOXcx?=
 =?utf-8?B?WjZCMURzZUdFYzV3Ni8xcmpWMDhsL1R0ZmJJOStjUENBV0d2ZkdzUTdMcEhM?=
 =?utf-8?B?Ukd0ZXdScHU4dTV2WXFXY0lmYTFVZXY4alZBZkVkM3Bmb00waTdJZTVmS25q?=
 =?utf-8?Q?FBgiMNuKo22zj3q/Pa4FcALr4?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db151d5-6658-46da-d585-08db23d8cc60
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 15:37:05.1551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GqYR2wZGfQZqZ/iiIljL3/s1yaYvknzpcVrVJlxvqtR5JBn8QG7MKweJUjZhDbraDQucHB+4dsDV3rAhPYAZWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6461
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0dXJkYXksIE1hcmNoIDExLCAyMDIzIDg6MjMgQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+IEV4dHJhY3QgdGhlIG1lbXNsb3QtcmVsYXRlZCBsb2dpYyBvZiBrdm1fbW11X21h
eF9tYXBwaW5nX2xldmVsKCkgaW50byBhDQo+IG5ldyBoZWxwZXIgc28gdGhhdCBLVk1HVCBjYW4g
ZGV0ZXJtaW5lIHdoZXRoZXIgb3Igbm90IG1hcHBpbmcgYSAyTWlCDQo+IHBhZ2UgaW50byB0aGUg
Z3Vlc3QgaXMgKGRpcylhbGxvd2VkIHBlciBLVk0ncyBtZW1zbG90cy4NCj4gDQo+IE5vIGZ1bmN0
aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3Rv
cGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL21tdS9t
bXUuYyAgICAgICAgICB8IDIxICsrKysrKysrKysrKysrKy0tLS0tLQ0KPiAgYXJjaC94ODYva3Zt
L21tdS9tbXVfaW50ZXJuYWwuaCB8ICAyICsrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDE3IGluc2Vy
dGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L21tdS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMgaW5kZXgNCj4gYzhlYmU1NDJjNTY1
Li40Njg1YzgwZTQ0MWIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4g
KysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiBAQCAtMzA4MywyMCArMzA4MywyOSBAQCBz
dGF0aWMgaW50IGhvc3RfcGZuX21hcHBpbmdfbGV2ZWwoc3RydWN0IGt2bQ0KPiAqa3ZtLCBnZm5f
dCBnZm4sDQo+ICAJcmV0dXJuIGxldmVsOw0KPiAgfQ0KPiANCj4gK2ludCBrdm1fbW11X21heF9z
bG90X21hcHBpbmdfbGV2ZWwoY29uc3Qgc3RydWN0IGt2bV9tZW1vcnlfc2xvdCAqc2xvdCwNCj4g
KwkJCQkgICBnZm5fdCBnZm4sIGludCBtYXhfbGV2ZWwpDQoNCkl0IHNlZW1zIG1vcmUgY29tbW9u
IHRvIGJlIG5hbWVkICJrdm1fbW11X3Nsb3RfbWF4X21hcHBpbmdfbGV2ZWwiDQood2UgaGF2ZSBv
dGhlciBrdm1fbW11X3Nsb3RfKiBmdW5jdGlvbnMgZGVmaW5lZCBhbHJlYWR5KQ0KDQoNCj4gK3sN
Cj4gKwlzdHJ1Y3Qga3ZtX2xwYWdlX2luZm8gKmxpbmZvOw0KPiArDQo+ICsJZm9yICggOyBtYXhf
bGV2ZWwgPiBQR19MRVZFTF80SzsgbWF4X2xldmVsLS0pIHsNCj4gKwkJbGluZm8gPSBscGFnZV9p
bmZvX3Nsb3QoZ2ZuLCBzbG90LCBtYXhfbGV2ZWwpOw0KPiArCQlpZiAoIWxpbmZvLT5kaXNhbGxv
d19scGFnZSkNCj4gKwkJCWJyZWFrOw0KPiArCX0NCj4gKwlyZXR1cm4gbWF4X2xldmVsOw0KPiAr
fQ0KPiArDQo+ICBpbnQga3ZtX21tdV9tYXhfbWFwcGluZ19sZXZlbChzdHJ1Y3Qga3ZtICprdm0s
DQo+ICAJCQkgICAgICBjb25zdCBzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpzbG90LCBnZm5fdCBn
Zm4sDQo+ICAJCQkgICAgICBpbnQgbWF4X2xldmVsKQ0KPiAgew0KPiAtCXN0cnVjdCBrdm1fbHBh
Z2VfaW5mbyAqbGluZm87DQo+ICAJaW50IGhvc3RfbGV2ZWw7DQo+IA0KPiAgCW1heF9sZXZlbCA9
IG1pbihtYXhfbGV2ZWwsIG1heF9odWdlX3BhZ2VfbGV2ZWwpOw0KDQpCZXR0ZXIgdG8gYWxzbyBo
YXZlIHRoaXMgbWluKCwpIG1vdmVkIHRvIHRoZSBoZWxwZXI/DQpFLmcuIGlmIG1heF9odWdlX3Bh
Z2VfbGV2ZWwgaGFzIGJlZW4gNEtCLCBubyBuZWVkIHRvIGNoZWNrIGludG8gbHBhZ2VfaW5mbyBp
biB0aGUgaGVscGVyLg0K
