Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041A35B17C3
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 10:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiIHIxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 04:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbiIHIxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 04:53:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A04E6B8B;
        Thu,  8 Sep 2022 01:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662627196; x=1694163196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FRmCjh/b9YzRHsqnPdGrl8dnuEX1V3S20jwyZ5qzZu8=;
  b=ZplBILGmA4zaxw1ZJtOgkZ97qgAWrq0rScYr6K0gOsTxTdnaExN1sqXG
   v8qjc+u7Mmo4lFR0bCftYnGp6x37hLYpOSZEP06OJ06UY6V1Z25Dawki3
   /ght79sDxuhQdKq62TaZaM5/U5ANRnMJRQeXWyXv4QrYfKhkZFxQmAu7s
   flsjHTs7xZtGfimaPCoouU1em4da6T9chU7Qu4MyGE1vr9NtYt/ei5jgE
   lXWui2BH5WDLrNuDwBTcabyRLmcGwwD0c8jsY17cKKWVUs0ZsP7JOWq3/
   64+yN85DoOVdAElZ3Oaz6id1CKwfXJkZN7Vbut9xR/dizD6fm0LqZW/kz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="298450933"
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="298450933"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 01:53:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="703933665"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Sep 2022 01:53:14 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 01:53:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 01:53:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 01:53:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k71KVItOQTZTNJxjXjlRIu2AWoNiOh/oQbuB5i1XIAQi1uR4rt49+DKmO2C0znXf+/oYXNrxbL7qmZ3P10QsUIGYjVsLrFx5m+DEcax/Z7/n66/BA0NOj90O2PApyj9uPpRsd66yB/PFNEGEndTpx/IMahWufUG0dti76opztpm2HigDghJXwxR6uxMsc0Bt7KZOTWINcHvCfnJQXxxIKNBJgPhFxdnhPW+95ZsOakjSF9Kv2BVoJqAuo1CoJuX8g/5Frrz5q3GIAx7SicDA+B9+wkU/8rDvlXNbhZWxjFppyFnMgs9eaDHaXwdjzjqADWzrr+5RydUJcoDLoJafiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRmCjh/b9YzRHsqnPdGrl8dnuEX1V3S20jwyZ5qzZu8=;
 b=U0ZqVsXb5HZMKj5p6OSkOt0QrE+jU4QjdrlgDc8i/hurC4tbT3BQrgLzV8Xbr1lNymgICki0y1xAiXXMXF4XlScm8kEm9k+oe4ns+bN3DxZNBuyjge2smn8Sn48kmwUm2582GFcpwnngXEzCLv7+PPgMv2FmvT9n6LX4ijWQAIIez9IsjhwlN8hjIF+I3uabULdRqFEfsKxVRjuXJqVhu2UNKYUTNVgBelzozIXZWmlX+GSdkIGsQozYMlBez9BUl3Bd/ZkLzQKZfNXFHq+sH8RT7j9GUre5h+GeU52Ng2eKQnNJ9c1+zYJdT/1/+KYivpRfmM4hcKyQ+rc5eX1L9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6365.namprd11.prod.outlook.com (2603:10b6:930:3b::5)
 by MWHPR11MB1664.namprd11.prod.outlook.com (2603:10b6:301:c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 08:53:07 +0000
Received: from CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::4016:8552:5fb1:e59]) by CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::4016:8552:5fb1:e59%8]) with mapi id 15.20.5566.015; Thu, 8 Sep 2022
 08:53:07 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Topic: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Index: AQHYuGCfKwYxaXR4306din/WULaC4K3Fff5wgA+5pQCAABPgMA==
Date:   Thu, 8 Sep 2022 08:53:06 +0000
Message-ID: <CY5PR11MB6365DFC5D715E87E951A63F0DC409@CY5PR11MB6365.namprd11.prod.outlook.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <3b78a0c7-de8f-fe44-ec58-bcc4e231191b@intel.com>
In-Reply-To: <3b78a0c7-de8f-fe44-ec58-bcc4e231191b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c400911-aaca-4963-217b-08da91778c7c
x-ms-traffictypediagnostic: MWHPR11MB1664:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aPA0DVhigSFepl0z5twhpUQiUQxr0kIxZZL3FUFIz9XPnuPp0LLSTx72fT1Z2wE9R6UA+sOu1uYq9IaeNtwioYQbGM6xb51IfqF7O/bei04cDmUfqoMa09xxGXT+MrDhx5G4oPVfOWpRgT5iD6RezeW7seMBP2MIRBN1zKZ/AkkxTj54iLyyJ2iM7VqY0MHKzedfsB6yT09tIHMiRVeOX7xdZdR2xVlAbLOrZQPBlKYrM4b+moM7H8d9S4A2UK+p7iz0GNAqXh7keH4H7EhaeA5GFrniFMZSmx4YKa8lJxcx1M6twEEjkdvZJZkKcKLSx4CBWrDR+tvAspaUNIK4sXqBkzwb/TD4h/HQ9x3E1fjIyD0UYdVvHxGToBU6ub63eRQUqll0dqN+IxEi5djmOdEvR9SYzwI+XlrMARl4kKngB2kDrGETVtHNjqGvHWDuXIC4EhTfFvs0GmCoRC4aRxSNBHz4NoH2OGN90EShTB64JfgUg0G+/y3nwYFl7AHb2h0DoCbhLonJXN/ioGFnSZSz8wOpbwTU5SAzr1CxK0NGuT/4lzC2EL9Toz+8qp0etFZgWHF6WSJqKc7A+CBQTF4whqX6j76JBPpl2TPx1P4KWIm4ezuRIHGgL7esONN2snzT166qfDDcf3YOGi9c49wyJsLREQeVZqewB7iELK9/uQE9MPnvK/Z19bp4RgJPq2PtfIFEYidfqpHzQB699lubzFJ+ARccOfrk0n/nWelube5MLLO+OhklR49l14GcJGzk6WepFgmUo9Bpk8hiHBzWWi9h9e+iWCOO5PAt8Z8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6365.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(366004)(346002)(39860400002)(76116006)(54906003)(66556008)(66446008)(110136005)(478600001)(66476007)(2906002)(82960400001)(38070700005)(33656002)(122000001)(921005)(558084003)(86362001)(38100700002)(316002)(66946007)(6506007)(53546011)(7696005)(41300700001)(71200400001)(26005)(9686003)(186003)(52536014)(8676002)(4326008)(64756008)(7416002)(5660300002)(55016003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDFhbzlOZ3BPSTlqaW5NZXZVTDh5Q0xXSkw5cGZLbE9LQ080OHpaWit3dCtS?=
 =?utf-8?B?Q0tCUFN4eFRWbkppaTZQVGZOZlZzQ3R4NDFiMFZjVlBDanFDTTVOWlFydUhX?=
 =?utf-8?B?bDNCb2ViY21RWkk3enVBbDFhOVNLZVZYTEgwV2JrdUlFK2dMNlZWb1lUSU4x?=
 =?utf-8?B?VzB1eDNXaUZ3cDA2TXc2NTZPMVZjcVIzZnNSd015TVZyaitkdnY1dlRFaFgy?=
 =?utf-8?B?clE2NHBZMDNqQ21nTUNEa0NvenFqLytaaW9jUUlqTCtKRElMais0Ny9vTS9w?=
 =?utf-8?B?RjR5Y1p0SmVRcDhKRFYrcHJFcGg3UVozM3lPM29oZXRYNHQ5c09GWnRMUkJL?=
 =?utf-8?B?OUEzUlB0WTIrSHMvQjE4SVFGdkxhQ2txbHBpRk9weWl2azZLaHFMVnNjMmZX?=
 =?utf-8?B?dFpCTi9HS0kxTDExK1AyMDIzYXgzQytlb3lsdzZHRS9xcHl5TmpQb0dMRWdO?=
 =?utf-8?B?bEttTkpUWWlMb0RBSmJIeEJ0Um1TRDJaVDNXc0hOUjdNdEM1Q21QNkZBZUYz?=
 =?utf-8?B?YjJxZzBaOFRUOHRWVnBEY0h0Q29KcCtzMUpFL3BjbjlNUk1rMEdGS0VzQWlI?=
 =?utf-8?B?elgyQmZZVi9VR2JLdjNYVHpySW1LMkU1RUFPUEhYS2p3OFltV0VHZzZ1bmdv?=
 =?utf-8?B?Sks3cG05SzhtWlBEU3ZBUCtJRjdVa0VYVDBlVElSSVFMbVM3UlVQUnBieUFL?=
 =?utf-8?B?RzNFTW5sL0hxZngrTzVuZmhrSnRLc1V0cUxoMFZNeXRkdGtXTFJudTZqL3Mv?=
 =?utf-8?B?Q3NoS2tqNm9JYjBLTnJUR21uZDRERDJxOVNING1jbXJIZ3d4bXdFemsybVdk?=
 =?utf-8?B?dERHVW93NmtPMzk3dGFFckhSN01kTWR4Zm9vWW81V01XMnJyL1JWR2JVZ1h2?=
 =?utf-8?B?SEtneDhTZG11cnR4SkxseTlEZ2VrdlRHMW1mR1QxdWtOdkFZVDBTOW5CallH?=
 =?utf-8?B?dUFMN0NyTldrZlVSL1FqbEEwTkJHL3hzTEFUaXVURFRVeGh0UnI4RnBiOXF1?=
 =?utf-8?B?d3pVV3lnTE9hT1RENTRWbVNneHd1eW8xVGlybUN3ZE1yaDhpd0N6V0NZcE1R?=
 =?utf-8?B?VmlyR0FuMUNvbVdEQnZqV0YzMHFRSEkxN1pmRktBTjkvbHhFMEg3N3ZyM251?=
 =?utf-8?B?ZW4vVEg0ME4vRDM3aktyempnamE0bTVRb081V29ZcVZ6dEFUcjlnR29UWlBU?=
 =?utf-8?B?N0QweDhMK2E0RWlpYTRjcGwrWHp5MVkzUmNOaS8vQzBKNUdUUGl3eTdHYm5Z?=
 =?utf-8?B?WUFtbStvVElnM2xucjRyMjdiZlFBbTByeWxzaWlORDdEaksvcElRcTBLN2Zj?=
 =?utf-8?B?cFdVQ2REL3VNT0xkVjc3WWRFa1ZBaTFVNXNkYkVKekxvMXVOeVFqRDA1V0RU?=
 =?utf-8?B?VzlQVjFNaXJ4bVVwQlhrYTc2Tzd4U05oSFlHcXBEbWtlUUxIemJnMFU1Z1RX?=
 =?utf-8?B?eEFHZlc4bEVZd1NSQitCWDRHY05waFhDREZVaXZuY0RCNmtxVDBTam14YTdw?=
 =?utf-8?B?aDZmdEJaV1hFT2xqcDEreFNXQ24yUmNGNENRbHkwc1QvMGlVNmN1eC8vcVdq?=
 =?utf-8?B?eGpDRWNrWWg3S2JheU5ZTFlOR3BkY0xkWlA1UC9LcVhoVlFpNHBBdkMrT3Mx?=
 =?utf-8?B?U0MrdkpFc21LR094THdmalh6bmErd0VrakJjQkZySWY0b3YwaGJFQlVjZllr?=
 =?utf-8?B?c29qRTUxNnprSFdLMEdWcGlZZEpBV1lzWnJLSm1jR29JVGVLYUJKVFhBNTla?=
 =?utf-8?B?ZmlaWHdwZkNQbWU1WGRqSndpSERDd0tTRnVHb3o1VEVVM2lkcVlSbys2ZHk5?=
 =?utf-8?B?NllLakJpVDh6bDV3VXphcjZ6enV0MmJSRExFVjZVV0puVkQxZFl6Uy9jK0JH?=
 =?utf-8?B?cGFnTXRoNkFXMWtub3ZmdHVwVFN3dngySTdWM2czWEdJem1KUXR4bTV0QUh5?=
 =?utf-8?B?djRHNnlxaEFXem55eDFnaGxhaVhnYzVJYzZjZnZLSmk3cTVGVnRzS0V4QWZI?=
 =?utf-8?B?TFVkb0laYVBXWStNNWV4MVd0RlJ1RW82aGRjOHg5a0tMcFFmbDR2aGFUSjNt?=
 =?utf-8?B?Nk5oZnlkeGUvaDgvTVpicFRhNXk1YlhGZXNjMFpqV2NCU2JOUjlIZWk0aE56?=
 =?utf-8?Q?NVLQsjqtS7sSwZlijQnkgYLpG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6365.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c400911-aaca-4963-217b-08da91778c7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 08:53:06.9957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s41i9MB+Ndj0MJGMqTAP0i4AkpXU7fYfNF9l2L86adkIadxN0UhRvj5OPYWOFWomeSLUBN+efPdVe1a2Dp03DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1664
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1cnNkYXksIFNlcHRlbWJlciA4LCAyMDIyIDM6MjYgUE0sIExpLCBYaWFveWFvIHdyb3Rl
Og0KPiA+ICsNCj4gPiArc3RydWN0IHBlcmZfZXZlbnQgKnB0X2dldF9jdXJyX2V2ZW50KHZvaWQp
IHsNCj4gPiArICAgICAgIHN0cnVjdCBwdCAqcHQgPSB0aGlzX2NwdV9wdHIoJnB0X2N0eCk7DQo+
IA0KPiBXZWksDQo+IA0KPiBJJ20gbm90IHN1cmUgaWYgd2UgY2FuIHVzZSBwdC0+aGFuZGxlLmV2
ZW50IGluc3RlYWQgb3Igbm90Lg0KPiANCj4gPiArICAgICAgIHJldHVybiBwdC0+ZXZlbnQ7DQoN
ClllcywgSSB0aGluayB3ZSBjb3VsZCByZXVzZSB0aGF0Lg0K
