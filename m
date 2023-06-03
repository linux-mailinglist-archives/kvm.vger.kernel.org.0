Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6C77211DB
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 21:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjFCTUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 15:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjFCTUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 15:20:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF5EA9;
        Sat,  3 Jun 2023 12:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685820003; x=1717356003;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8wDvX768zQIu61+Qmjw3KJ6yB8gUbSLLqXO2LSM4WWk=;
  b=BzH6P01QFud4Mqa+qES4RePHF1WLp4b3g/5OmOTL34Mu1sv2xfAQarlg
   oMxGxO6lvqxJ+cEWEjZTpxf57o+AFZ3X6ak1HX0KGessPKN7sw2oGtYuL
   fK82PB44P7uiwyNa/x8pHcYa7K63JCHLy3O9/6x+uPvaZfR0q14/rVJ82
   4hny8UQ/T9r0gwkRvDSGUDa5VQRp6PB7ntsJ5hSau9jYRtGEt7L2Ymunj
   C412xiAY5dGJuy9dMuT9eCjoYAnys1gWXJiXbNLwL3i4hemxGQA3du+Y0
   xMX11cVGnpJ1NKH0TvEjGypeizPjHTj6XG7kch6NYLYfC21g4ZPdyhVYU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="354958815"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; 
   d="scan'208";a="354958815"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2023 12:20:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="778076393"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; 
   d="scan'208";a="778076393"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 03 Jun 2023 12:20:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 3 Jun 2023 12:20:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 3 Jun 2023 12:20:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 3 Jun 2023 12:20:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8Jl9VB8+kPPyrWJcFap6zvaAvZd05eE0FVDgdMhz/KL3gjdeHfsrJqJZEM+fCXmH5KAbouOzzl6l7EkzB+dcYP7zQ5/4J2gtx7etuQ0yHp40TjqzQSLENObjohr4k7x0v8swadLREyCi3ptCTYcyHCla10IQZDCEXYFc4rhbvh9yqCua8fA0d4cPvQFpjfUwN6oW9S1k4UDjtt6bNBmI4HssAmBK+ceEMcOBZi+6+kHM0sYO0qlaPPrH9V5MopPPNF3fCMtKJ27sFAAhQAH0tq68xkvsB8bRCrLALE6HC+xetjgpnkruLbOfrK9Vs3fA4xN76SWsLsdse5iWlD5lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wDvX768zQIu61+Qmjw3KJ6yB8gUbSLLqXO2LSM4WWk=;
 b=fVErYo2VES2VjuHCr1kTkFYL0HljqrgavpbIXqXqpC9LZUsqqaR5rZoKGbSmvI+JZnmLie3TnoHj2cWhCQe6kz42bbV7Mve588Tnq9+39UfOK3rvQ8YKyCms6Dh8ROdNBIQxTZ069SObi3YLZP+65L4ZCc113EpFklfGeLGoa4EQAqriX5kpbVNfIt3jog8YNeJvgCvs3eiL3aG5owQ1yiq8dk2szyxBt8Ef6Fs6DMv6WmEZZA3bEeZCxHdnSog2qPCPiHr1j1MPNIKfrJMz07qdFoaa2+8baNNCrdp89ZYCR+clEqT9VT4xZ8rBkwpQ6w/TGQ9x1h4JNQLN/NDq8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SJ2PR11MB7454.namprd11.prod.outlook.com (2603:10b6:a03:4cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 19:19:59 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4%3]) with mapi id 15.20.6455.027; Sat, 3 Jun 2023
 19:19:59 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>,
        "Lutomirski, Andy" <luto@kernel.org>
Subject: RE: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Topic: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Index: AQHZa4g62amPAW2/oE6/VfNOqnc7za9O37YAgCri6yA=
Date:   Sat, 3 Jun 2023 19:19:58 +0000
Message-ID: <SA1PR11MB6734DB9D958F9F859A0B354AA84FA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com>
 <20230507115934.GCZFeSpqnO5pPkAzwB@fat_crate.local>
In-Reply-To: <20230507115934.GCZFeSpqnO5pPkAzwB@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SJ2PR11MB7454:EE_
x-ms-office365-filtering-correlation-id: b9165ee7-61ac-4dbd-75ff-08db64678595
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: giQFaBPYRVlURlPl0Ivy93tIzIZROcA24kVZFGyphrOIu63RIJR7xjv0wgA6E3hF6lpV8SjUS/wl8OvER+KwvDvJCjeAyIZI6RnhR1hAalLrqbop4y4eIUkCzVWTZvTfgKEfH4xb8wjmyxcD61oCGWq1DjoIMaxLAv5JBVBgFS3beGq/RQ1oGKeCae3XtsrMXYqZ6Iqyzs2JMMi9NMaLJAzleVixTbipntAZrcE/BL03aVw/AHbbKNPo/KFuEVqz4oMBvQw3nhqWjRHq3GDMsB+2sABshADX61h9+D3EoJ27lRTb1MSyJaYD2jXjDsKx5Vq7P2nBwSv2mXhiYPRUfqJTos1h1jof1WBGLCKkCx7g7nqZh/P7FqGCIaw4r71QLK5YThpHRMbj93W+508ex6h6jc+q1aDTT8/NgDBnL8JQ7B9juQHi9jli/5lU9CK92PMi+JiErrVeKX3V/Y9Tn9hrceFh6HhCO8DVDlz3EFTkiPgZQlBSXLR0pnEd5/ViaSgXY2Hq94igwtyMPoYOmUfHRioaiB8GZLHd12oKNzOdEkjKnlzgzcFGizb2Kie/XoxI52T7Gs/6gH7oInMDLJSFoGNV86ldL94OrlY5BeR/qy6AucDV0YA5XR/oWwoP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199021)(7696005)(38070700005)(71200400001)(9686003)(26005)(55016003)(6506007)(33656002)(186003)(86362001)(38100700002)(82960400001)(122000001)(7416002)(54906003)(5660300002)(52536014)(316002)(41300700001)(8936002)(8676002)(4326008)(66446008)(66556008)(64756008)(66476007)(6916009)(76116006)(66946007)(478600001)(4744005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RStwNUgwYzVrUm5oTURwTmVYOTd3TGNLVGFidzhEaUJEOHlBK1ZjY0w3V01H?=
 =?utf-8?B?K1lKSUhEUjNBeUk1YWZPcWNqWktXMkJSYXdNd3JsUVVaaEdEYVMzRmNWRnYv?=
 =?utf-8?B?NnMxaEtmRVFNM0tYS0lkbVVUWWFmUUhwakNZS0d6VXFEVGpVTkZKU3hwM09j?=
 =?utf-8?B?Uzk0djVoOUFHRHkyblhmL2xHVExNVUN5Wmd2VzdqNlMyUlJDNHdORXAySllW?=
 =?utf-8?B?d1RYQXJoclAvL3lMWjVGdHo4YkRvQVpzTm9WenZJa0RBNDZhQnhreWp0dHNP?=
 =?utf-8?B?Uk9rRmRYakxqZ2phdlFJalBoZWJYdGVYc1dRdG5tU09nb216NXBHZHlzK0Zy?=
 =?utf-8?B?c0NLZTNzYzgrODRoemQ5Zm5Kc2tVdHFEOWRieGIxbWw2SmNjTURob0pGQ3U2?=
 =?utf-8?B?eEF0SmVKRUZzdUpqcStpL2FzMTBkaGFjMjhEbWVMOXdWYjRiR3pUSGFQWkIx?=
 =?utf-8?B?RjIwZUVHMy9KcUkrNUt1UGxEaXZDQlJKRlJBdkdNdHRRR0I0SmtUVEs5aVdm?=
 =?utf-8?B?UmZJMUErVDFCVW5xZjh3d2w5elJQZzQwNUFrZVByaXZlbWhPVHJqTnlkbnRo?=
 =?utf-8?B?V1BjT1p2aTBHQ0x1WUdPS0lpc3pyZWpjbjlEUitsRDUvVFJwS3JZclpUeDYy?=
 =?utf-8?B?eUJqOFdBaXpUVDBOZ0I3K3F1b1hjQVMwRzJhOW5relp1enc5T0RGSWJDdEFJ?=
 =?utf-8?B?VVB1L2lGMVAxVVF4SHNzSEdEYzZiNFBSZ3RJRnYwUWxRK0ZwY2hsZTNzNE16?=
 =?utf-8?B?UmRRL2o3bEdNVWpJeDdTUVMvY3cwYnlVYjJCR0d6SkN3UHVZVStoV2dHSjAw?=
 =?utf-8?B?Q2c4MmFFaVpMVVFoeFh6WHc4TEx1aitjRk00NzZjeGxhQlI1eFBzbkRFYzRz?=
 =?utf-8?B?OERvaFlyeTR1WUZwRFdBbk9SUll5U3pSSGw3cm9RemF1ZnBoUVlFTFNldFZ6?=
 =?utf-8?B?SUdQdGtZaThwVFFWd0hJYjdxa1JaVndFNkhDbUF6NkJJTmtEQmNHODBua3Az?=
 =?utf-8?B?UUhlOE9hNkRhZ21CaTB1bWJYeXFWTVFOMTNySm94czZMSWVCUk5JRmpGVkR0?=
 =?utf-8?B?MzdzZTJ0VTFxSXR6VkFiOTQzamlpa0dtd0lrZko5ZXorL0tGOHJ1ck5LTTUw?=
 =?utf-8?B?QXo1R0M4bXNXZDdSU2ltWHRoVVpiN1RLOGtYRUNoeDNjZXhkcjA2Vm1GNFpv?=
 =?utf-8?B?Vm94djd4QmVIT0Q5U1g2WkJ5OXR4UmdZdkpTZ3hzOEN2MGJ3TkRVSS9qdmx2?=
 =?utf-8?B?QW5BeVFvQkc5b2tVQkEzUEhQRVNUTXhSVGZ6cTlKZWNHUDZSMFR1dENRalNv?=
 =?utf-8?B?M3pYN3BXR3ZpRXJybWZRdmdVV0ltTk9pbW9rT3pGVDVWa1V4OVlkMWtuZlg4?=
 =?utf-8?B?L1dZREEzTjBDb3dUZ0pENVh2SVR5aUExMXBwRmVTRDVCRkZQUjUvTnFBb1Qv?=
 =?utf-8?B?RjdVWGw3dFRzbHVtNjdYbW5ETnk4NFQyOVNBSm9ock5ZS2h4ME1aaTBZVW9N?=
 =?utf-8?B?Rmh3Q1pCdnZTOStva05zY0xvTnBsYXV0M2s3QjZpbllqSFhBVzRkRWJOZmtO?=
 =?utf-8?B?ZVZJY28wblVoZ0hneEZ4NjNHTzVhcTZCYytEeEdscWJ6a0JQQmRJU05rWlh0?=
 =?utf-8?B?ZnE1em9FeVpQT0lhSHZZRjhjcFo1d0g5bWxlcjBuVVRFL1ovVEIyWmNHclNT?=
 =?utf-8?B?RGRaSHYwNUdSam5Kby92Ylk1YzV3V3ltTzRBSUZvR2FaVzBjWnJMNHFtZXd6?=
 =?utf-8?B?bDc4TlIrQVJFYUVpOU54cHdoZzBTV3VGTHduY2c1NUYxbzl6UXptNWNPWWdI?=
 =?utf-8?B?VlNJV1NpNEFDK2lySjNxTXdJaWtydUJjcXNiSXFRWGFlM2g1bk14Y1F1dmVB?=
 =?utf-8?B?QjEzSzVhYlVPK1FTWmtDZXhHZlhhZ1V2UmJQVkxpZld6bnppMHcxS0l0MlF6?=
 =?utf-8?B?VU56WmlVbkxhRkJTcW0vaVFuaW9ZUU9KUGw3RWdnbVlESFUzUTZKaCtDQUNj?=
 =?utf-8?B?TG16K3hJNStFeHJEYXJscjFvRTBSTTBRNjZ5TFJtK1JHUFd5Nk9VeXN2Y0h0?=
 =?utf-8?B?all1QmFkQnFYOHdVNmxRdFhxb1o1M0dpcnNyVU1iREEweHZETCtZZjdnRUNK?=
 =?utf-8?Q?MUFc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9165ee7-61ac-4dbd-75ff-08db64678595
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 19:19:58.8254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CCYpYjtA/uzDVRegJEvTjVjbzMZXCjjqveY4ceBNaXrmtw5XXC3YX053j/I7MhN5fuz0CjPobfq6drjSpRFj3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7454
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IElSUV9NT1ZFX0NMRUFOVVBfVkVDVE9SIGlzIHRoZSBvbmx5IG9uZSBvZiB0aGUgc3lzdGVt
IElSUSB2ZWN0b3JzIHRoYXQNCj4gPiBpcyAqYmVsb3cqIEZJUlNUX1NZU1RFTV9WRUNUT1IuIEl0
IGlzIGEgc2xvdyBwYXRoLCBzbyBqdXN0IHB1c2ggaXQNCj4gPiBpbnRvIGNvbW1vbl9pbnRlcnJ1
cHQoKSBqdXN0IGJlZm9yZSB0aGUgc3B1cmlvdXMgaW50ZXJydXB0IGhhbmRsaW5nLg0KPiANCj4g
SSdtIG1pc3NpbmcgaGVyZSB0aGUgIndoeSI6DQo+IA0KPiBJIGNhbiBnbyBmb3J3YXJkIGludG8g
dGhlIHNldCBhbmQgc2VlIHRoYXQgeW91J3JlIHNwbGl0dGluZyB0aGUgaGFuZGxpbmcgYmFzZWQg
b24NCj4gdmVjdG9yIHR5cGVzIGFuZCB0aGVyZSdzIGV2ZW50IGNsYXNzaWZpY2F0aW9uIGFuZCB0
aGUgbG93ZXN0IHByaW8gdmVjdG9yIGlzIG5vdA0KPiBnb2luZyB0byBiZSBoYXJkd2lyZWQgdG8g
MHgyMCwgeWFkZGEgeWFkZGEuLi4NCj4gDQo+IGJ1dCBzb21lIG9mIHRoYXQgc2hvdWxkIGJlIGlu
IHRoZSB0ZXh0IGhlcmUgc28gdGhhdCBpdCBpcyBjbGVhciB3aHkgaXQgaXMgYmVpbmcgZG9uZS4N
Cg0KUGVyIERhdmUncyBhc2ssIEkgYW0gYWRkaW5nIGRldGFpbHMgYWJvdXQgdGhlIGJlbmVmaXRz
IHRoYXQgRlJFRCBpbnRyb2R1Y2VzLA0KYW5kIHRoZW4gd2h5IHdlIG1ha2UgdGhlc2UgY2hhbmdl
cywgd2hpY2ggc2hvdWxkIG1ha2UgaXQgY2xlYXJlci4NCg0KVGhhbmtzIQ0KWGluDQo=
