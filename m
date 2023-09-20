Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131A77A8A8A
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjITRZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 13:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjITRZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 13:25:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD76B4;
        Wed, 20 Sep 2023 10:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695230725; x=1726766725;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HnsJ6gEOmNnvj/71iTWup15VcRue1W537zLLPwS1Xog=;
  b=NdeFKKUVUtciioFuTBjy2ChBn7YifH0iv/cfJbyUnu4PKRTfUduNPciB
   cT2CyHJNOWjDYrdYMrpotWgqBuMkv4T1l3kYdzzlq1gfiwqk6V1QAyE2j
   y7KP4GC0EtdiPGkpyGQm1tQxL4JV2AV6eem04IpyuovTNBYy6VWZudedF
   Q19oFlI7Icw08XbZEoNfAMsa4nHssK6rYWiEe0RJ3Hz4MV6dWNxFqIP+E
   jGohnlb4VzxFbAgZ+Q/qg2A/9EY5ac1WTraw76Ow3o/Tl//Tta8/JlBmf
   0bSajchggisi1ig1t/OSDkUNZdAE0+EVwenLQg8AnXKyeRrANS94UoCeH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="411235436"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="411235436"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 10:25:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="750005306"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="750005306"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Sep 2023 10:25:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 10:25:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 20 Sep 2023 10:25:24 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 20 Sep 2023 10:25:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEZkxLsy+/FtV7Gd61jl4NpgMRe1e2n4/HUsFXebsMIyZsOUiEC58GXRUsM2QdA353VVof2KWhjpupF+MRJZ2T6mcEbcQDL51r3e73xRaai6F23o14Bvv70j7IEeXXBty6otYVNGQuUfOotCQY06901JfX7D5o6p2VHTscQ+dpVh9iiOAjo/GVG3WHEJ9Mkx6vuhGAGJEEwpEzmjYyarJkV8UhYvxn8tCIHeW4IDTAsXjsjL+lIpqhGlG/D1P8PJRAWX+FTNEa6iu8KxMGuA8BOLhWKBPi43A9CRoY8tFNhNuLc2eQKaOoMFgPklEIbDhZoCtcOGCOo9u/6tHqIGZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HnsJ6gEOmNnvj/71iTWup15VcRue1W537zLLPwS1Xog=;
 b=PXvZupnhJnWDtMq4PVjqXEZQU1EcoLW4qK7IcGoivD/WQFG5vp/3Zm16qmFtijzB24KgC2bCHILA7GmPje/EZRDu3+Z9gFUuMBeLcUU+nqg2V66wLxlpGeGTyZvw7whp1HgpOB0nepMbP7rl6SBAm4QXhEbPe7qZwCYbfPcXayYr+p/btiOXDayHchVLkaQXDi16XSlaaoZJ7isDajFemmuG7cdDxcGVydTC4Mz0MTvoBdsV3ql7B3H1D30SNqMHmcIIelSCjUcT6AW/A/xg03tFQb4Xlhr3oG21lzLiYrhiYqarFdTanSDhlNQLVnZbPjtNn9Qbyp+QI6yVpH1kFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SN7PR11MB7420.namprd11.prod.outlook.com (2603:10b6:806:328::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Wed, 20 Sep
 2023 17:25:21 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%5]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 17:25:21 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Nikolay Borisov <nik.borisov@suse.com>,
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
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 13/38] x86/cpu: Add X86_CR4_FRED macro
Thread-Topic: [PATCH v10 13/38] x86/cpu: Add X86_CR4_FRED macro
Thread-Index: AQHZ5ss+SatJUnh9UkGHEM3ubXu/u7AjkxCAgABt1KA=
Date:   Wed, 20 Sep 2023 17:25:21 +0000
Message-ID: <SA1PR11MB6734F4A44B17516178ECD31CA8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-14-xin3.li@intel.com>
 <085176da-924e-8d6d-1c56-8bfc9d457b0b@suse.com>
In-Reply-To: <085176da-924e-8d6d-1c56-8bfc9d457b0b@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SN7PR11MB7420:EE_
x-ms-office365-filtering-correlation-id: 7c171b03-49db-4e67-3c16-08dbb9fe9180
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HJs1+AcZJEF0t7AsF2NzfL5vsBM8Xvp3Y0aMZ+k9CjdjwzAbprc90B1Swx9tDN0H3AfRBMAyNpQmmWkAXz4fkw75NwG3Ws6rO49dHcTiK8CMdqIhMFltxYodYPrNMdaEMzn/Ib66MjpYQsAJOniWy4YkCy0YINy47rw90XJRGKKIAOHkxzgUgPgSXIBrotGTKRNhrCkfYiKWQvGnk4o+mirLRZzQmPOni6ophqogj032Gk/rU3bJaDLXx9UVQAzWnr9lrWLYunTKUH+PArbgt8zEyYux1zBLw7Wc9ONnoRgaVVLrR425K2ikclL0bpe856j+nkN8Wl+b3rqkmxkluLgYijzH5xw0IEFOWrfKVGTkShdtNyUHbdDpkqtWLpKdTt1xICy8Jl4HTMuGOuXe3555Jdjj7pCMHfe/HvXln54D0Zb0i/Y1mysifIzFt8VzhggMQaRhB8Uv9vWXlCT5CdPsB1E4esIPHY+mQ0Lq3hya+0HjrEb+zXwhhQFp5cWnniYOLJtpplgIAPFXUcCLY/owlf2W43j8olhRakbQh4/gov8982GLvoqtybh0vbbFLdTR4w1K3OdIluhdHZzRaAFl1J1smWOFls5advPl3oeY95r/WpwIP2EuqzfdMm2a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(136003)(39860400002)(186009)(451199024)(1800799009)(7696005)(6506007)(478600001)(71200400001)(9686003)(54906003)(64756008)(26005)(4744005)(2906002)(316002)(66446008)(76116006)(66946007)(66476007)(66556008)(7416002)(4326008)(110136005)(8676002)(8936002)(52536014)(5660300002)(41300700001)(38070700005)(86362001)(38100700002)(82960400001)(33656002)(122000001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWJZRGFTSlFlMGdEUHllakl5S2d0THl6cE1WYmtzTmhZVlhKc2tuVksvL3d3?=
 =?utf-8?B?UWZxRFZOMlBCdHJmM2x2WmFnQjduQzVEMXljbWNxd0JNeFpCdXBIMndFWU1N?=
 =?utf-8?B?SzFzb2VoN0VoYW9IRTdnQTRsdXdncFZHQ3J6NFF1NWN5WVViL0NSMEhyZDkz?=
 =?utf-8?B?V2I2ZlIwaEtMQWdpNFZST1RiblA0TzhuSzQySlZNc2tQTEd0NllHcnhQNmZ1?=
 =?utf-8?B?YTZ4RU82UERqRW13WlZWN1Rqcm9rQkdDRTl2ZlpQK0lManI5YnpyRmlyZUNZ?=
 =?utf-8?B?WGxUYUhtWUI4aDZ0K1BXVURmZ0VVbytxM3FkNGtIVXhjZ1dtL1ZELzlvMUZ2?=
 =?utf-8?B?dk1YM290OUFtRi9iRW9nTVBGRmdxbmFUYktQeHQwSjdnc0hWSjBQUEl1cFRU?=
 =?utf-8?B?MlFjMnhBZUhhQ1F4bWtON2VlSThYb1Y4dlRmb0NKL1BPcFYxMHBtYWoxOENs?=
 =?utf-8?B?WkJlWTZ4TDZJUTlDcVY3QUJ1RVVtNzl1VTVDVWxwSDhMZEE3NWp1MEJ1d01r?=
 =?utf-8?B?SURBaU04bEdXRGQ0MkpPZ05ydkFVTHFCRjBYckxrcm81Q3JTUm1jSnNnamdT?=
 =?utf-8?B?VEZYbTJKVVNYNDk2bXhZdXJJMVIycTRWVEVid1hVaklSM0tHM21IKzRaVkpN?=
 =?utf-8?B?SStqVkoreGdJQkpIaTN4U0d0YVZYVkcrRG0wR0F4cDkrU3c5MVJqOENyTE1Z?=
 =?utf-8?B?QWxMQUNJTmU0UVNhNXJjaUxaRWJ0dXRPeS9LQm1rNE4wcWQzNllLTTJuTjFW?=
 =?utf-8?B?UHR5T1VYZVhtVDRVWjBWL0hocjZLVklQdWs1VzZ2OFVnNlY0ZXNFYUVzYm9U?=
 =?utf-8?B?RkZNM1ZnVWpNdzlZYlplbWVQSnRZSjdrSFd2RVdEek9SbGxaY0Q1VDkrdjcx?=
 =?utf-8?B?THZydERVUjQ2bVIvYlg5Uzh6NnA1T0dyeEI3WUNnaWVOL2Z1cnZNb01tWjRm?=
 =?utf-8?B?alFSTEU0WWUxMkRJSlRuZFZZMUZGeXhDOHYvVlJQTHNPczJBbThNVnJKQ2Qw?=
 =?utf-8?B?Y2lLZXE1eVE4TzdMbTNIQlJHbDhYSFc0bVY4NnkrZVRKNnl0OXZBMUdieWFN?=
 =?utf-8?B?cFZBdHl3UlRkNjUzaUJQL3p4VDIySmZNUHJham8rQ3doRmJhbW1iR1FqUFZD?=
 =?utf-8?B?VERHVVJKRkdCM2NUVGw0dTUvRUx2R2JQSjBkQnh5K1MvcWlUKzh5T0RpU1lP?=
 =?utf-8?B?eDNDNkxpNnVWQWNzUWFFbG1iMnJwOGhZTFVXWUlFOC9vNW1ibTNCcnhzUDRj?=
 =?utf-8?B?alV1aDZhQW1pRG54U1pFRk82d0hDVDFXcU0xWVZFTUFoVk01QWVFK01oQWto?=
 =?utf-8?B?OHJZQjRsMEowbzd5Z0ZlYWNhRWsvUVNkUC85T0lGQllSTFpjVTQwbkZrZXRU?=
 =?utf-8?B?RWxRcGc4dkZaeFRYVkhiWE10alZ4cnRVMmpOZkpiT1RpT21OWFllNVZzd3c3?=
 =?utf-8?B?YmRqUzh0MnBUNkgxSnprOWR5ZSs3Rzk3ZUZhTjdzaWVsVDE5dEFLUXpNM0dw?=
 =?utf-8?B?RUN0KzUzc29HTTBqaVdJdFpldmdyQUlaeHprNEZvWjg4NXBCazdZU1lJUUtN?=
 =?utf-8?B?N09wWStHQksvclNCTXdDbUZnM0RiL1B4RXpoczQwb3dKZWNHTHhJY2IyT2VW?=
 =?utf-8?B?NCs3OW1rWU9sL1ZJSm1uNk95VnFMWlVVdTN5eUlMOE1tUnpKZUNzaTBNOG1a?=
 =?utf-8?B?T09CSG8za2RXR0JhN3lHbXQ4NFh3aVFPN0dabzdORWRyV0VoOWVJWjBUbmUx?=
 =?utf-8?B?MFU1ZURDSWNQeGxMVXRuSXc3Zm9EQU9zVGJycVA4Y1JnOThZSkpwbW5LL2hW?=
 =?utf-8?B?WGRmMXlBNE1scW9rOTN2ZHRZSzhKY2R2RFJ6bm1NZDA5Umw4Y24vZ1pxUVJp?=
 =?utf-8?B?SFVRbU1WVEs5Tndaek9rRnBKcjdhOVFhcEpqQ3hQbEJiWGdlYmI1L1praHIx?=
 =?utf-8?B?QkhhaHlZdWw0dGpqWkhUdHRzdUhqblJMek44Q0pZNWJEVm05eFZNdjFaS3B0?=
 =?utf-8?B?RzVndVl6RmNaZW50RUtVeWR2TUpSaDNScHJuSHc4YXZBVkR5bGZRdWYxbTA0?=
 =?utf-8?B?SEY1WW5paWgwTUZaZ0RaS0xSbWh3QTJEUGttYW9PRVptaXo4RERmZXdiVVhS?=
 =?utf-8?Q?q5TPutQYgHVcl1EZNaC5UQ9Pf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c171b03-49db-4e67-3c16-08dbb9fe9180
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 17:25:21.6722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TnFMPI/bxUCYLZQBlUROthuR+cyZhhGH5R8TH1ocvL7ajHoAxdV8LevZ4QWkSHz3WMwHbU03ju/9IfjsrltMwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7420
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

PiA+ICsjaWZkZWYgX194ODZfNjRfXw0KPiA+ICsjZGVmaW5lIFg4Nl9DUjRfRlJFRF9CSVQJMzIg
LyogZW5hYmxlIEZSRUQga2VybmVsIGVudHJ5ICovDQo+ID4gKyNkZWZpbmUgWDg2X0NSNF9GUkVE
CQlfQklUVUwoWDg2X0NSNF9GUkVEX0JJVCkNCj4gDQo+IG5pdDogcy9CSVRVTC9CSVRVTEwgSSBn
dWVzcyBpZiBfX3g4Nl82NF9fIGlzIGRlZmluZWQgdGhlbiB3ZSBhcmUNCj4gZ3VhcmFudGVlZCB0
aGF0IHVuc2lnbmVkIGxvbmcgd2lsbCBiZSBhIDY0IGJpdCwgYnV0IGZvciB0aGUgc2FrZSBvZg0K
PiBjbGFyaXR5IEknZCByYXRoZXIgaGF2ZSB0aGlzIHNwZWxsZWQgb3V0IGV4cGxpY2l0bHkgYnkg
dXNpbmcgQklUVUxMDQo+DQoNClVMIGlzIGJldHRlciBiZWNhdXNlIENSNCBpcyBhIG1hY2hpbmUg
d29yZC4NCg0KPiANCj4gDQo+ID4gKyNlbHNlDQo+ID4gKyNkZWZpbmUgWDg2X0NSNF9GUkVECQko
MCkNCj4gPiArI2VuZGlmDQoNCg==
