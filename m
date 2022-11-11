Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550346260D6
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 19:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiKKSGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 13:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiKKSGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 13:06:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E03C2E0;
        Fri, 11 Nov 2022 10:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668189976; x=1699725976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a7GngMWyUz//daiwZlqlVk6YDnts1/mQj/vTB3HxXt0=;
  b=Kooa9Jyu0cGTgsRbHoXrrFA/ilz+iziCc0InkSIgqc/ICHDIB58hH38b
   e70+uNlq0hSCuY8W3fokIf0eokd/YbL1VdX/qAv4M41PeE684/Z/44dlG
   Q8HssZyxjOGFZ77xcscMUGCdCJ7cJ4cKORLac42LK4vBl+/Ut27h5iHGt
   ks1f7K6+l1YxfKdoHe6Ke+Wom7SZX6oW6knbB5xb+Md94TTfYaVpfS4U6
   XtKnF7qD8s7a/eO7+642MBTUp977mTISBXN3RDuqMgB05GM3C8ELJqHS0
   CdJnG97DVDsfuN6+jY8k2n4pW1L2C8xSZYpJAMsQOtIJVb8tWT7Bdq7WS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="292046477"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="292046477"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 10:06:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="743358972"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="743358972"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 11 Nov 2022 10:06:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 10:06:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 11 Nov 2022 10:06:15 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 11 Nov 2022 10:06:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOrDa2PwEGZJ4VuZLRGD2zsBp6Rx2U3Nz/o3I0j9VXDWGFhgfDBJtFKqI9we4ND31xwKlHTv5bAeE4iM1XpDadx20jZheCjCCeS2hJHYu8oX/Y6P4nFQ1CsP0OcuX5iu+JDmI0r0/Pqp05BHMnmyJzt+Cwpk0Odu6VsF0VkD44+i7nYi+SF9RVbhjdiASPcOsUw0Aq4BLUdwCp6bdAERAibqIydb0Emrf4+ZeoPeZ/Ha7KqjBrBES+3yb5z3bh1dHbLPPHvHxRgKM1Xvdf1IwruFr161kR92jaVRzuflK3i80yVLbBBk1NyzTN5fco/AHUymes7h1hTR4Nsh3I/Ngw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7GngMWyUz//daiwZlqlVk6YDnts1/mQj/vTB3HxXt0=;
 b=O7V8G8lztYfn+knZtZ4IpoBC9B3w4O6b6m7pzJu7AmiOGwOlqC0wqcsfcupqEUrFH46kciAOrj4KOSHc7umSK0cA4+SjRO9eFNeHOXwysdxx6xzV+XMqHeu3WQ+O+Uh+pyDDtp7rqov3W0Wg6DqfIHQjXh44WzeIA4rW/sqHqVQ/a2QF2Pe5MvmTQcOectI3Wmg4MZE0C7WZRFfu0D/1EFFyiFdVUJ0YazwLDZR7q1agI2aQYbuheZmKojE4U77MHW5LCrUpwuwNbTeibDaq+veB0Vp5Jco1wmE/vEG4iybNwq/hLyZAGOT5IOmuzh0uaUUQORJIET04/dVAvnWvyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by CH0PR11MB5459.namprd11.prod.outlook.com
 (2603:10b6:610:d2::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 18:06:12 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.015; Fri, 11 Nov
 2022 18:06:12 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9M9YytlyKV7ob0GK/oJbeBhPY6433PwAgACmfxCAAO8aAIAAL0qAgAAENoCAAAgUAIAAGnuAgAA1qHA=
Date:   Fri, 11 Nov 2022 18:06:12 +0000
Message-ID: <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
In-Reply-To: <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|CH0PR11MB5459:EE_
x-ms-office365-filtering-correlation-id: 7d3b82af-c25c-4acf-f4c1-08dac40f6ae9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YjERbPsyzx0bi+jE5mvqBlX8UF7neX/MAwm55/Pj4LMjUU3v8nQxacnkczsOS+mud9mSlmXVEsmQGlKEoHj1rQVJb0+9EIOr/POgchrmnZdJqEECbEa1L9lGDcOtY4n1COlr6AKsdwUnZHj0ZlvBKx0vZkbsw2IVwfVmZ/UF1ap6ADwo0ZSCFVe4C9VIgZtMYzK+6QAJVv0WsaNRmQQmENcQZZrMwBArZSR8ijMfCxEhDe7AVhfI6Hc6g6v8UG0UbCaCq2M08TLPp4kUMI/Xdiv/SY0LDAMCI75CKc7+0LEeP4kPx4WOqr26VwQ380gD6Q0hncbnwgHjjP/mQckjApqrnUtueD02a0YpPldkK650HiW/Q2w8a4mBVUgJ9liTTf9wb74YWniOGdBpNSKa4gvB2OMkX/9cELaKejy2Km/D3vQYNAlaB7g6A25upf6A8MpHTDXuNRWLNf4fUwUwXU50n4SUWlQmiWe3sQNJczCKi8C4UyDOoBwF3ZBmrmtXcNY6xLx3pPZDuOBvOqZicEovypDNXwZ3da5rO6QFmbqT+K9f/G5vHmggfKRp/Avclbnj0kgLRJ/eO/0anjO8ivFn6vD7kwEmC7RkeZ6TyggwuBcBzxhw+SvuxTmu2ieeupx0JtJlF2m4o3wvtZenybA/EmcCeZQOCCMZ3vF+UP1PwYqWNjz1lqujyr8udAyOiKVaQfY5Bor8sjMxZ5Paupis68LLCG0azvABF9tOAFB0DcTryAH19HUPmYX+M+XzKnxHtb0rnOr7f2x2KSnlMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199015)(316002)(110136005)(54906003)(122000001)(86362001)(66946007)(66446008)(76116006)(66556008)(66476007)(186003)(64756008)(8676002)(38100700002)(4326008)(2906002)(7416002)(478600001)(9686003)(8936002)(52536014)(33656002)(71200400001)(41300700001)(82960400001)(38070700005)(83380400001)(26005)(5660300002)(55016003)(53546011)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUpHRERYMEx5c0JBYnR0MEdlekZyOThPN0FvWHpJY2d2SmdhLzlNcXUza0gz?=
 =?utf-8?B?NkN5YjBFK2tNN1d4SEc4dDBJUXh2eE96UEFBVkVLRkVBay9jTjc3Ymk2Um1m?=
 =?utf-8?B?UWlNUnhJSFpOeEdydGI0ZlJReTBLa1VPZnBsYVhHTk9BL3QwYkljYUNsL292?=
 =?utf-8?B?TWt6a1BuL1JGcWUrMjMralpIREs3Y3dBN09UcXVTVEd1andLZnE1OTl1RXJh?=
 =?utf-8?B?bFIremtlVXpkVVEvdGxwQUdwUDdGOXNmTUlPbnY5bzMyYTlSZzRzNi93Q2Mw?=
 =?utf-8?B?T3dRTnRud0JnOW0wUUp5MFNpaGh2ekpiYTduOWJHSWNINDhISmZHZzVQNVI0?=
 =?utf-8?B?QTBCU2JEVjVpWlFUODZJL0lZWVFKTGxiSGtqMllFRS9FR0dnbWJKajVaclY4?=
 =?utf-8?B?U09abFhiTU0xOXJKOGNXZG9YNFJkdlkxbWZWbWhuK2pWWWNERnZSM1M4K1pT?=
 =?utf-8?B?bGs5Z0hscEsrUDhkNUNVOXloekRpRmJuZS9jcTl0YmxTV0xiMTVvVEUxeWg1?=
 =?utf-8?B?N2dRNEhXbmdza21YODN5UmljZkdVdE9JdWJDTVZpUXUveHRkS3JBYjVVWU1Q?=
 =?utf-8?B?OFVYY0daZG1uVkRiNTVZSlhhcWJTbzJGbnhNakMzSm9jVjdSSHNFT3hBUitt?=
 =?utf-8?B?MGFjRlB1dFJnVkh6V1hpdEhDdEtGdUFZQkxsSkJxdGoxUExBb2lCMVVBS0tp?=
 =?utf-8?B?djZjREg0a0lKYnhoSTllcTBLODNuaktKZ2E3Z0pEMFFOcEtXcGIwTHVIM083?=
 =?utf-8?B?OGRXV1lsek5BK2hwVENQekREeThzUGdrVFNGOUZZNTdxeXh0WlJjYU4rdzhZ?=
 =?utf-8?B?aGtNTTBTS2kxbXhlVWlScVJRT2N5Q1NGckNialE2dzZpb3dkTGNnNXcwaUxS?=
 =?utf-8?B?cWE0WWFFQVlRRS9jV1B3bkJkVDNGY2hMeE4vbmZEcktBcjVFWXhFZHYzUHVU?=
 =?utf-8?B?Z3JIaGtpWk9yckJpNXlLTTdEbCtJOUo1VmI5VGtQRWZMdzJJRlBzUk5oT0NY?=
 =?utf-8?B?N3FqRU1kdld3NDk5Q0xNMXI4QituZEQrNDJLeGZVbWYxNWpmNmlOSGtFbHBa?=
 =?utf-8?B?WDZOSEcybEs3SkpjeVJGdHBLelZTNmZ1czdUTlZKWHZYNHFFZ1FiMEI2VjMv?=
 =?utf-8?B?M1M2d3BhRXZzZVJmV3I3dk1zY000dTVhaWsrZlhhOHkzdmgydW1zTmJLL3Zw?=
 =?utf-8?B?Tlp6NE9YZU56UHFrVmc4ditOLzNOZXkwcGZERW5OU1gvRHM2QStIWm1TbHBo?=
 =?utf-8?B?SHBDQ3dwSHlTNEQzTEZuSmFoNlRmaXRwZURmRzZlZTBnZDZTNGExMkNkS28x?=
 =?utf-8?B?SGRPUldFRnh2bzUyWDA1elgwUXc0ZmZ3NDBpcjBaLytLbWdRRjZiWjJXTmxM?=
 =?utf-8?B?WnQ1RVBCc2laS1ZQNU8yR1ByZ0xTdmVNN1lwVHc0b3FrZXRLNzY2ZEZWeDJv?=
 =?utf-8?B?VWx4aWhtWjNZSlZ6RXFxaXJOcmdEalgxSzFEelJlUC9qTHFyZm8wd3N5SkN0?=
 =?utf-8?B?a2puWksxS3J0VDJlNWR2UGxza0duQjQ3SjVralRKdDMrNmttWVBsRTJweVNQ?=
 =?utf-8?B?Z1VXSFZ1VkJiM3lvMks1NjBOTnB1ZlZxRDd1T2ZseUJadGFSK1ozd0h2aity?=
 =?utf-8?B?V3VJVGFPSm05ZHJIdHFvR1NTNUlhMXFwdzJyYmEwTzZDTzRDVEc5UDAvcDNn?=
 =?utf-8?B?eW40b2RJNkZRV0JMQmZIV2Q3NXZjdUZlZkZMR29wMHdWVUk1WkFkbE5CYnhF?=
 =?utf-8?B?eS8rNFhuSnhMWEZHNlNxQ2ZSMk1vQzlNRGQ2UU56eEdhelJVQ0lraUhJQlVL?=
 =?utf-8?B?cFdEa01sWmR0SHI5RjY5NXhSUDRzNTZrTzd5bUxyRlN4UmVja05iVGFNenBv?=
 =?utf-8?B?aDhlNlE1dDFYb2xjUWJZNTZmOHhYdFFuL28yTWVOaWlsV1hWOVUvZmtGV1Rm?=
 =?utf-8?B?bFVtSzV5S3ArTnhYWTB4eWZXWVF4YTViVEVjS2ZYdFd2Mi84bVUrRS9tdWFw?=
 =?utf-8?B?UnoySjFMWFlzMkxtWjViZ0l5bVZmR1NoOThQbE5RYzRjVVdZeVQzQWFrdm1G?=
 =?utf-8?B?N2R3QzkydExPNDY4MW1sOHRpYXNZUk8vb0V6RjhMOVBZOHFCTXp6azY0azFs?=
 =?utf-8?Q?x0m8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3b82af-c25c-4acf-f4c1-08dac40f6ae9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 18:06:12.3148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKoznyolCWRbMzozdY2HUlg/iM4nxBYz33GAkr8TTxZZD5u7oxwukRykaobkxiS0EOtAU4XD1214hEUxkpD7KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5459
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBGcmksIE5vdiAxMSwgMjAyMiBhdCAwMTo0ODoyNlBNICswMTAwLCBQYW9sbyBCb256aW5p
IHdyb3RlOg0KPiA+IE9uIDExLzExLzIyIDEzOjE5LCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4g
PiA+IE9uIEZyaSwgTm92IDExLCAyMDIyIGF0IDAxOjA0OjI3UE0gKzAxMDAsIFBhb2xvIEJvbnpp
bmkgd3JvdGU6DQo+ID4gPiA+IE9uIEludGVsIHlvdSBjYW4gb3B0aW9uYWxseSBtYWtlIGl0IGhv
bGQgb250byBJUlFzLCBidXQgTk1JcyBhcmUNCj4gPiA+ID4gYWx3YXlzIGVhdGVuIGJ5IHRoZSBW
TUVYSVQgYW5kIGhhdmUgdG8gYmUgcmVpbmplY3RlZCBtYW51YWxseS4NCj4gPiA+DQo+ID4gPiBU
aGF0ICdvcHRpb25hbGx5JyB0aGluZyB3b3JyaWVzIG1lIC0tIGFzIGluLCBLVk0gaXMgY3VycmVu
dGx5DQo+ID4gPiBvcHRpbmctb3V0Pw0KPiA+DQo+ID4gWWVzLCBiZWNhdXNlICJJZiB0aGUg4oCc
cHJvY2VzcyBwb3N0ZWQgaW50ZXJydXB0c+KAnSBWTS1leGVjdXRpb24gY29udHJvbA0KPiA+IGlz
IDEsIHRoZSDigJxhY2tub3dsZWRnZSBpbnRlcnJ1cHQgb24gZXhpdOKAnSBWTS1leGl0IGNvbnRy
b2wgaXMgMSIgKFNETQ0KPiA+IDI2LjIuMS4xLCBjaGVja3Mgb24gVk0tRXhlY3V0aW9uIENvbnRy
b2wgRmllbGRzKS4gIElwc2UgZGl4aXQuICBQb3N0ZWQNCj4gPiBpbnRlcnJ1cHRzIGFyZSBhdmFp
bGFibGUgYW5kIHVzZWQgb24gYWxsIHByb2Nlc3NvcnMgc2luY2UgSSB0aGluayBJdnkgQnJpZGdl
Lg0KPiANCj4gKGltYWdpbmUgdGhlIG5vbi1jb2MgY29tcGxpYW50IHJlYWN0aW9uIGhlcmUpDQo+
IA0KPiBTbyBpbnN0ZWFkIG9mIGZpeGluZyBpdCwgdGhleSBtYWRlIGl0IHdvcnNlIDotKA0KPiAN
Cj4gQW5kIG5vdyBGUkVEIGlzIGFyZ3VhYmx5IG1ha2luZyBpdCB3b3JzZSBhZ2FpbiwgYW5kIHBl
b3BsZSB3b25kZXIgd2h5IEkNCj4gaGF0ZSB2aXJ0Li4uDQoNCk1heWJlIEkgdGFrZSBpdCB3cm9u
ZywgYnV0IEZSRUQgZG9lc24ndCBtYWtlIGFueXRoaW5nIHdvcnNlLiBGcmVkIGVudHJ5DQpjb2Rl
IHdpbGwgY2FsbCBleHRlcm5hbF9pbnRlcnJ1cHQoKSBpbW1lZGlhdGVseSBmb3IgSVJRcy4NCg0K
WW91IHJlYWxseSByZWFsbHkgZG9uJ3QgbGlrZSB0aGUgY29udGV4dCBob3cgVk1YIGRpc3BhdGNo
ZXMgTk1JL0lSUXMgKHdoaWNoIGhhcw0KYmVlbiB0aGVyZSBmb3IgYSBsb25nIHRpbWUpLCByaWdo
dD8NCg0KQXMgeW91IHNhaWQsIHdoYXQgaWYgd2UgZG8gbm90IGNhbGwgREVGSU5FX0lEVEVOVFJZ
XyooZnVuYykgYnV0IHRoZSBpbnRlcm5hbA0KSVJRIGhhbmRsZXJzIF9fZnVuYz8gIFRoYXQgd2F5
IHdlIHRha2Ugb3V0IHRoZSBzZXR1cCBmb3IgUkNVL2xvY2tkZXAvZXRjLg0KDQo=
