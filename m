Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764C673601F
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 01:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjFSX3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 19:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjFSX3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 19:29:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22321712;
        Mon, 19 Jun 2023 16:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687217331; x=1718753331;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cb5kM1ZSTvcuTSSPGtqqIA/QhvY4qFpfXCGntfgmRt4=;
  b=japd1hoH8b5wKQit36fv2WNzJRG/Ot2vSAVwuRHWvA1oZSwOrtXoBzS4
   T4z8VsKE7Rbyub+c0lwp8mJCT5+KImjy7XIlh+105LLXpMKsNvOzU9d4i
   HhFRhia/IZVxfXTe9KP1r4S0DDL382cgNAg0CU95Uy9E/yXBhaM/8W8+w
   XfBzDGmSIK5jQpm52QElKdEfVZIR54EklIqa/2w/dFUmXXVL1JGbfPg/+
   kXXNIdPj3iEimdnHuw5WgKz/0cbdAPRI61SlyO8m4Eo1PBOpq+Zx37p9L
   nP3aGkAW1iQc3dfO0zfPdrdGmdXkpNRTJ/UceNgPXCgazFJoPE2HbvtfV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="349455675"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="349455675"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 16:28:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="858355176"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="858355176"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jun 2023 16:28:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 16:28:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 16:28:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 16:28:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCqM5J9aBoddNg94nhCuQ4aafPIzD5p0b9sjQ/2eFft1ccPbEcpkTNjszXlWUw4z2FCBwVUo9nlUtUtVZnnAiKmcOrIZivVnVmXz87gtM8BOPappiOsnWjLH+q1oTgyaO/JR9aAAPdJAckl3DqjwdtQ+tLjqiOHAAji50eh8QlLScRmYoDHTwYzznFdCje6IkljCMHAVMSKJl8glqBRbyLlyc4gcdnjyp+ducwY6IG5IXVFX0Fw0r/B0YKVjD2GAg9tEOwJRGCIOB1PHZrv2VAkI/mq3KyG1SLNsbjaur3BvOFzuftRmrOKlNBW810YRvf98jO4QGg1a0LHuk0EjzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cb5kM1ZSTvcuTSSPGtqqIA/QhvY4qFpfXCGntfgmRt4=;
 b=ikAOqKA7XPPnTJPwzaoT+pUQ6BfK9gYgxfXkowZ75eZZbZCbMhuh+TbyFJJNBwi1ZE63VpCIfLPb08jZOd3jw/b6HozrbMz91TYMc4wfyKsFLcK3wANEbb1jNDCl13naZhaYKrkHhoMbV22j8YWvOaOYuMnDuHzNgsrVCPZ3CbT8w9FmaFyzWAGfV8gRSJPeiTwCI0qwSQZyKRWq5xyz7+EEn4eFW0HVeeeK5oJ+xHvvJLi3/f9Cfd/Z1D9j6Uw33lWZroy4Eb9c1/84jN7w653e5IiKuvVdL/lYQxagP7gvs/HG74P30YhqkhQl5s9+m1iWIGufXvUZj8IIa6puIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7841.namprd11.prod.outlook.com (2603:10b6:610:121::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 23:28:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 23:28:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZlu+wNwpF26yA2UWLC9EXmgAK/K+SMrsAgACq7QA=
Date:   Mon, 19 Jun 2023 23:28:37 +0000
Message-ID: <b7c07ef95669260be75a25307da00cee3b3ff9b1.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
         <895f7f8d-6fd2-2098-9208-6240d2655978@redhat.com>
In-Reply-To: <895f7f8d-6fd2-2098-9208-6240d2655978@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7841:EE_
x-ms-office365-filtering-correlation-id: 63dc44c9-9c7a-48cd-0466-08db711ce853
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hPimQ4zgfNdr9v5CzSBHnVFD+b8MV9nGkU/Dgtca3BeLrIZUhqf0QFjW4JBWcdb5CHG1uWhDydcfsZ6NIckin2QHX9ga+A0sPRs0sL9ILJU96X4mBv+Aqo0BsHkkU/PahUSzlipdVy/q9udvtx14g5QlMbvIFfhOBwDwj1+4/YKt2+9bRf0bJ+6A+s4WhKuQxWB8nKwNk9P5azVOozH9638ecvWIVHGd/UyCrUEpas3mxtzPIFRad89Q1BjfEXX2hq7uNsQExKSi6EOELdMvVwWk1CBk8woLdnU8Oy4CYc5/vVkSH2CEJS++KZgxsDA8FVdUHDtKz1BWMnNQw2t5JEaWbci4rj1ST30X4yoOcpapNvq8HZL8kKxxRCWqAo31GZ1kmVbONH8YsIp3jImqU30jLnYGa/7OZyrdWIk1w9gSiSFhbZNm7E/JHnYUWd1rxYZLU7/kJLq5WFS6dXi4WH7F1VbcqVywZ7WlUYn25iNND8v4EPXgZXVHaGR44pN021uBEzIJuUcZo/5Dw5N9fvp1UYsDKodDstxsKNqj1J5mhLhTRMmPbN2njSCiKU/V/ac/jhS0iescFzjyG0K+TaTzpsA3fX2lhEm5rkXKbtcxoyZwJsbsRa4Qvr8WVB7V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(53546011)(7416002)(66946007)(8936002)(8676002)(76116006)(66556008)(64756008)(66446008)(66476007)(38070700005)(26005)(186003)(6506007)(6512007)(36756003)(82960400001)(83380400001)(41300700001)(38100700002)(5660300002)(91956017)(4326008)(316002)(54906003)(2616005)(6486002)(478600001)(2906002)(122000001)(71200400001)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmNhZG82RFlXWlVzMlRqR2dWSkpxTmw2bXBtcHd0RjhDMm1kWEhsbGNaYS9o?=
 =?utf-8?B?eWtBOTNVSlVxVjB6cVEyQmhCK3BLYytZUFJ6cHZNaHhTTEQ4Myt2czMzY3Nv?=
 =?utf-8?B?b0VoejRpK3lBbUE1cnlBQjVyb1dHT1VYc2pkS204NmI4dUU0aUE0QlJJdjht?=
 =?utf-8?B?RmoxRTB0RDZRWjhEYlBBdDJFbEVzT3NndjVYM0YrbUwxL25qcDFiOHZYcGVH?=
 =?utf-8?B?R1lxTFFSYUNmeVBTcm1QTU1Ic2pCY0dzMHAyK0xrWUk4NGFrNFZsbHBpUkx1?=
 =?utf-8?B?eXo3bHhPNEdJOGZPZXllMitzVW15QjJ0RGlpTHBSVE1PdzNkdVhodmNWUHYw?=
 =?utf-8?B?NTdXY3FHUmhoeDMzRlkvaTlPU0s5K2UrbHVkaEVHbEw2c1d6c29GT1BTTWNC?=
 =?utf-8?B?VlFUQ3lwQm9HeEYrYTRwOEdYVVZWLzFtSzY3ZmpWUjIyVllCMGtUL2VadmZv?=
 =?utf-8?B?WkpWNkIrckIrc2hTTGt4Rnowd2pieXdQVTVaTlkvRlhqZXpvM2lRN1F5bnRk?=
 =?utf-8?B?aEI5ZHFCV01hM3ZEODlXTnJlb1R0ZVIvU0UvVFNYUk1VNkxYOVJjdlhBYnhU?=
 =?utf-8?B?dkVGaXBvZFZXaHJjREpld2NJaUJoTlVYSDlqa3BRdmZYTEhiakk5dHNIV2Jn?=
 =?utf-8?B?RzVnRXdML1ZucG9wdDhiemNXN3VhVHErSWhUV2dqV0pSb0JFMUViaVhteGxB?=
 =?utf-8?B?emI5UHJmYUxzSkJPck02UzhQTDJldTZTcVk5ZzMvNVhraHJjZmZuTzhFcjZK?=
 =?utf-8?B?SVFzZStJcmtnVU9RZkczeVVUR2p3M0xXYTl5bFBlUytuT3JrZ2RJV0ZzbVFy?=
 =?utf-8?B?NTMzd29JaDc5Wm55T2VuanJ1Z1h3WjQyeVhseUpoRzU3TFlaTDFmV0g4QzNn?=
 =?utf-8?B?UUlmeHMwOVRyZGdkZ0QwNU9EcCtqQzFPTUhYcXBsUWFnWXNYMThiTFN5OXc1?=
 =?utf-8?B?a2lEOGFQZnRQZnN2WFNzNk01Z2hvYUo1bU9OYk1UWmlyMzhvWjZxR043NDRO?=
 =?utf-8?B?RnAyeDdnRWo3ZGNRd0R0b0VYb3F6QktUUzVQclNWOXN4T0hLNE4zSTVueG1m?=
 =?utf-8?B?Z1N3STkxaWdKZ2RsemxncmlzdlF3N3pjTHNKbmMxMjFCWVBub0J0TTYrOUkw?=
 =?utf-8?B?UU5NbUFCc21ORWNaekhnb3loZGNvVi9WaWpKOWVSak5JS0RlUWFvTG91SHdx?=
 =?utf-8?B?aVl3U2VyM2MyZjJIS1VzOGhBQ2ZuYWVyY01XYjl5bGFPT3Q5TzJ1QzdycS9S?=
 =?utf-8?B?alB6TURCZU14YkdCRGEzN3Arb3E1V3JwM3ZYNHN1cWZ5UUttcXJyTFEzS0s4?=
 =?utf-8?B?TlJENkVHTTVBeUkreWJ5YXZ4OVBjQmw0MDRLb0x6MzBLNGkvNUt1bzhxdzc0?=
 =?utf-8?B?WDM1QnBDcDNtbkp5WlVSVEpQeCtnLzhxTXA0dWZDWUE0bkRkdEhKTElpSERs?=
 =?utf-8?B?dytlSGxpZVZpTDFvRXp6TXhSTSthcTV1V29Dc25RNTQ3UHlWL0pQN3lWbzJj?=
 =?utf-8?B?ZFQvV05XVGZVN0M5N0dNZ3BHWFd1YjZMSnJVZ2ZiREV2M0k0T1hKTGREakdX?=
 =?utf-8?B?REV5Q2kyT3lNQU9XQUhLdG9mUzhWN3hlam40RmovMkRid3RsMmdDK3ZNYTNw?=
 =?utf-8?B?L0lEYXk3WkJFcTZxNkd5eUExcUNDeHhaVjRlMHBGeDNyZXcvbXg1dE9wM0sw?=
 =?utf-8?B?d213WDVyL0w2RGFvcWhJQUZXdkZIRmx5THJlWEdBbXI2VFY4ZUpydC9oeDZX?=
 =?utf-8?B?Rnp1dVNqc3BkMXlBSlB4NmlFQVg0TDVOb0JrdWRaV0M5Wk5WeDdVNVpGRy9S?=
 =?utf-8?B?cFJkV0JFY05FOGdPZGxVSVV4RDY0bXN6QU8xYlJWMjh2Z3RkM2dTR3ZFQjkr?=
 =?utf-8?B?WWZkM2ZIdWxXdmFsZmNKSXR4ai81SjBkVEhFN0dwd1B0ZlB6a1o1bERJMkhX?=
 =?utf-8?B?cEpzeTREaTAyZjRpT3RMY1lmdDRxWTZTY3hvSWI2a01BQUk4dkNSc29WTU92?=
 =?utf-8?B?d1dNUmlmRVhZMUNGYnFLYXdTNVZNaWhXS1RNSDJNalFUd1VsREYzN0o5SmNF?=
 =?utf-8?B?Q2xEZHJ3UHlWbkNNdGRxUEFDNVVjeEZCUzRHamVFNzJpUEsvVlNVdFpmaXNF?=
 =?utf-8?Q?YPwsWraZpOQqfxz3tJAWqcuaV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CCF54F70618D14BA837FF84E8B415AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63dc44c9-9c7a-48cd-0466-08db711ce853
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 23:28:37.3237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3KMP0DncI9GbuCFgR8/yVABejOgBej/CeXTFvMgH1FshkO7pB7SSNbhNzOwCawEFRqZORgbbpVnldrLytkEONg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7841
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDE1OjE2ICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMDQuMDYuMjMgMTY6MjcsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBUbyBlbmFibGUg
VERYIHRoZSBrZXJuZWwgbmVlZHMgdG8gaW5pdGlhbGl6ZSBURFggZnJvbSB0d28gcGVyc3BlY3Rp
dmVzOg0KPiA+IDEpIERvIGEgc2V0IG9mIFNFQU1DQUxMcyB0byBpbml0aWFsaXplIHRoZSBURFgg
bW9kdWxlIHRvIG1ha2UgaXQgcmVhZHkNCj4gPiB0byBjcmVhdGUgYW5kIHJ1biBURFggZ3Vlc3Rz
OyAyKSBEbyB0aGUgcGVyLWNwdSBpbml0aWFsaXphdGlvbiBTRUFNQ0FMTA0KPiA+IG9uIG9uZSBs
b2dpY2FsIGNwdSBiZWZvcmUgdGhlIGtlcm5lbCB3YW50cyB0byBtYWtlIGFueSBvdGhlciBTRUFN
Q0FMTHMNCj4gPiBvbiB0aGF0IGNwdSAoaW5jbHVkaW5nIHRob3NlIGludm9sdmVkIGR1cmluZyBt
b2R1bGUgaW5pdGlhbGl6YXRpb24gYW5kDQo+ID4gcnVubmluZyBURFggZ3Vlc3RzKS4NCj4gPiAN
Cj4gPiBUaGUgVERYIG1vZHVsZSBjYW4gYmUgaW5pdGlhbGl6ZWQgb25seSBvbmNlIGluIGl0cyBs
aWZldGltZS4gIEluc3RlYWQNCj4gPiBvZiBhbHdheXMgaW5pdGlhbGl6aW5nIGl0IGF0IGJvb3Qg
dGltZSwgdGhpcyBpbXBsZW1lbnRhdGlvbiBjaG9vc2VzIGFuDQo+ID4gIm9uIGRlbWFuZCIgYXBw
cm9hY2ggdG8gaW5pdGlhbGl6ZSBURFggdW50aWwgdGhlcmUgaXMgYSByZWFsIG5lZWQgKGUuZw0K
PiA+IHdoZW4gcmVxdWVzdGVkIGJ5IEtWTSkuICBUaGlzIGFwcHJvYWNoIGhhcyBiZWxvdyBwcm9z
Og0KPiA+IA0KPiA+IDEpIEl0IGF2b2lkcyBjb25zdW1pbmcgdGhlIG1lbW9yeSB0aGF0IG11c3Qg
YmUgYWxsb2NhdGVkIGJ5IGtlcm5lbCBhbmQNCj4gPiBnaXZlbiB0byB0aGUgVERYIG1vZHVsZSBh
cyBtZXRhZGF0YSAofjEvMjU2dGggb2YgdGhlIFREWC11c2FibGUgbWVtb3J5KSwNCj4gPiBhbmQg
YWxzbyBzYXZlcyB0aGUgQ1BVIGN5Y2xlcyBvZiBpbml0aWFsaXppbmcgdGhlIFREWCBtb2R1bGUg
KGFuZCB0aGUNCj4gPiBtZXRhZGF0YSkgd2hlbiBURFggaXMgbm90IHVzZWQgYXQgYWxsLg0KPiA+
IA0KPiA+IDIpIFRoZSBURFggbW9kdWxlIGRlc2lnbiBhbGxvd3MgaXQgdG8gYmUgdXBkYXRlZCB3
aGlsZSB0aGUgc3lzdGVtIGlzDQo+ID4gcnVubmluZy4gIFRoZSB1cGRhdGUgcHJvY2VkdXJlIHNo
YXJlcyBxdWl0ZSBhIGZldyBzdGVwcyB3aXRoIHRoaXMgIm9uDQo+ID4gZGVtYW5kIiBpbml0aWFs
aXphdGlvbiBtZWNoYW5pc20uICBUaGUgaG9wZSBpcyB0aGF0IG11Y2ggb2YgIm9uIGRlbWFuZCIN
Cj4gPiBtZWNoYW5pc20gY2FuIGJlIHNoYXJlZCB3aXRoIGEgZnV0dXJlICJ1cGRhdGUiIG1lY2hh
bmlzbS4gIEEgYm9vdC10aW1lDQo+ID4gVERYIG1vZHVsZSBpbXBsZW1lbnRhdGlvbiB3b3VsZCBu
b3QgYmUgYWJsZSB0byBzaGFyZSBtdWNoIGNvZGUgd2l0aCB0aGUNCj4gPiB1cGRhdGUgbWVjaGFu
aXNtLg0KPiA+IA0KPiA+IDMpIE1ha2luZyBTRUFNQ0FMTCByZXF1aXJlcyBWTVggdG8gYmUgZW5h
YmxlZC4gIEN1cnJlbnRseSwgb25seSB0aGUgS1ZNDQo+ID4gY29kZSBtdWNrcyB3aXRoIFZNWCBl
bmFibGluZy4gIElmIHRoZSBURFggbW9kdWxlIHdlcmUgdG8gYmUgaW5pdGlhbGl6ZWQNCj4gPiBz
ZXBhcmF0ZWx5IGZyb20gS1ZNIChsaWtlIGF0IGJvb3QpLCB0aGUgYm9vdCBjb2RlIHdvdWxkIG5l
ZWQgdG8gYmUNCj4gPiB0YXVnaHQgaG93IHRvIG11Y2sgd2l0aCBWTVggZW5hYmxpbmcgYW5kIEtW
TSB3b3VsZCBuZWVkIHRvIGJlIHRhdWdodCBob3cNCj4gPiB0byBjb3BlIHdpdGggdGhhdC4gIE1h
a2luZyBLVk0gaXRzZWxmIHJlc3BvbnNpYmxlIGZvciBURFggaW5pdGlhbGl6YXRpb24NCj4gPiBs
ZXRzIHRoZSByZXN0IG9mIHRoZSBrZXJuZWwgc3RheSBibGlzc2Z1bGx5IHVuYXdhcmUgb2YgVk1Y
Lg0KPiA+IA0KPiA+IFNpbWlsYXIgdG8gbW9kdWxlIGluaXRpYWxpemF0aW9uLCBhbHNvIG1ha2Ug
dGhlIHBlci1jcHUgaW5pdGlhbGl6YXRpb24NCj4gPiAib24gZGVtYW5kIiBhcyBpdCBhbHNvIGRl
cGVuZHMgb24gVk1YIGJlaW5nIGVuYWJsZWQuDQo+ID4gDQo+ID4gQWRkIHR3byBmdW5jdGlvbnMs
IHRkeF9lbmFibGUoKSBhbmQgdGR4X2NwdV9lbmFibGUoKSwgdG8gZW5hYmxlIHRoZSBURFgNCj4g
PiBtb2R1bGUgYW5kIGVuYWJsZSBURFggb24gbG9jYWwgY3B1IHJlc3BlY3RpdmVseS4gIEZvciBu
b3cgdGR4X2VuYWJsZSgpDQo+ID4gaXMgYSBwbGFjZWhvbGRlci4gIFRoZSBUT0RPIGxpc3Qgd2ls
bCBiZSBwYXJlZCBkb3duIGFzIGZ1bmN0aW9uYWxpdHkgaXMNCj4gPiBhZGRlZC4NCj4gPiANCj4g
PiBJbiB0ZHhfZW5hYmxlKCkgdXNlIGEgc3RhdGUgbWFjaGluZSBwcm90ZWN0ZWQgYnkgbXV0ZXgg
dG8gbWFrZSBzdXJlIHRoZQ0KPiA+IGluaXRpYWxpemF0aW9uIHdpbGwgb25seSBiZSBkb25lIG9u
Y2UsIGFzIHRkeF9lbmFibGUoKSBjYW4gYmUgY2FsbGVkDQo+ID4gbXVsdGlwbGUgdGltZXMgKGku
ZS4gS1ZNIG1vZHVsZSBjYW4gYmUgcmVsb2FkZWQpIGFuZCBtYXkgYmUgY2FsbGVkDQo+ID4gY29u
Y3VycmVudGx5IGJ5IG90aGVyIGtlcm5lbCBjb21wb25lbnRzIGluIHRoZSBmdXR1cmUuDQo+ID4g
DQo+ID4gVGhlIHBlci1jcHUgaW5pdGlhbGl6YXRpb24gb24gZWFjaCBjcHUgY2FuIG9ubHkgYmUg
ZG9uZSBvbmNlIGR1cmluZyB0aGUNCj4gPiBtb2R1bGUncyBsaWZlIHRpbWUuICBVc2UgYSBwZXIt
Y3B1IHZhcmlhYmxlIHRvIHRyYWNrIGl0cyBzdGF0dXMgdG8gbWFrZQ0KPiA+IHN1cmUgaXQgaXMg
b25seSBkb25lIG9uY2UgaW4gdGR4X2NwdV9lbmFibGUoKS4NCj4gPiANCj4gPiBBbHNvLCBhIFNF
QU1DQUxMIHRvIGRvIFREWCBtb2R1bGUgZ2xvYmFsIGluaXRpYWxpemF0aW9uIG11c3QgYmUgZG9u
ZQ0KPiA+IG9uY2Ugb24gYW55IGxvZ2ljYWwgY3B1IGJlZm9yZSBhbnkgcGVyLWNwdSBpbml0aWFs
aXphdGlvbiBTRUFNQ0FMTC4gIERvDQo+ID4gaXQgaW5zaWRlIHRkeF9jcHVfZW5hYmxlKCkgdG9v
IChpZiBoYXNuJ3QgYmVlbiBkb25lKS4NCj4gPiANCj4gPiB0ZHhfZW5hYmxlKCkgY2FuIHBvdGVu
dGlhbGx5IGludm9rZSBTRUFNQ0FMTHMgb24gYW55IG9ubGluZSBjcHVzLiAgVGhlDQo+ID4gcGVy
LWNwdSBpbml0aWFsaXphdGlvbiBtdXN0IGJlIGRvbmUgYmVmb3JlIHRob3NlIFNFQU1DQUxMcyBh
cmUgaW52b2tlZA0KPiA+IG9uIHNvbWUgY3B1LiAgVG8ga2VlcCB0aGluZ3Mgc2ltcGxlLCBpbiB0
ZHhfY3B1X2VuYWJsZSgpLCBhbHdheXMgZG8gdGhlDQo+ID4gcGVyLWNwdSBpbml0aWFsaXphdGlv
biByZWdhcmRsZXNzIG9mIHdoZXRoZXIgdGhlIFREWCBtb2R1bGUgaGFzIGJlZW4NCj4gPiBpbml0
aWFsaXplZCBvciBub3QuICBBbmQgaW4gdGR4X2VuYWJsZSgpLCBkb24ndCBjYWxsIHRkeF9jcHVf
ZW5hYmxlKCkNCj4gPiBidXQgYXNzdW1lIHRoZSBjYWxsZXIgaGFzIGRpc2FibGVkIENQVSBob3Rw
bHVnLCBkb25lIFZNWE9OIGFuZA0KPiA+IHRkeF9jcHVfZW5hYmxlKCkgb24gYWxsIG9ubGluZSBj
cHVzIGJlZm9yZSBjYWxsaW5nIHRkeF9lbmFibGUoKS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5
OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IElzYWt1
IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gDQo+ID4g
djEwIC0+IHYxMToNCj4gPiAgIC0gUmV0dXJuIC1OT0RFViBpbnN0ZWFkIG9mIC1FSU5WQUwgd2hl
biBDT05GSUdfSU5URUxfVERYX0hPU1QgaXMgb2ZmLg0KPiA+ICAgLSBSZXR1cm4gdGhlIGFjdHVh
bCBlcnJvciBjb2RlIGZvciB0ZHhfZW5hYmxlKCkgaW5zdGVhZCBvZiAtRUlOVkFMLg0KPiA+ICAg
LSBBZGRlZCBJc2FrdSdzIFJldmlld2VkLWJ5Lg0KPiA+IA0KPiA+IHY5IC0+IHYxMDoNCj4gPiAg
IC0gTWVyZ2VkIHRoZSBwYXRjaCB0byBoYW5kbGUgcGVyLWNwdSBpbml0aWFsaXphdGlvbiB0byB0
aGlzIHBhdGNoIHRvDQo+ID4gICAgIHRlbGwgdGhlIHN0b3J5IGJldHRlci4NCj4gPiAgIC0gQ2hh
bmdlZCBob3cgdG8gaGFuZGxlIHRoZSBwZXItY3B1IGluaXRpYWxpemF0aW9uIHRvIG9ubHkgcHJv
dmlkZSBhDQo+ID4gICAgIHRkeF9jcHVfZW5hYmxlKCkgZnVuY3Rpb24gdG8gbGV0IHRoZSB1c2Vy
IG9mIFREWCB0byBkbyBpdCB3aGVuIHRoZQ0KPiA+ICAgICB1c2VyIHdhbnRzIHRvIHJ1biBURFgg
Y29kZSBvbiBhIGNlcnRhaW4gY3B1Lg0KPiA+ICAgLSBDaGFuZ2VkIHRkeF9lbmFibGUoKSB0byBu
b3QgY2FsbCBjcHVzX3JlYWRfbG9jaygpIGV4cGxpY2l0bHksIGJ1dA0KPiA+ICAgICBjYWxsIGxv
Y2tkZXBfYXNzZXJ0X2NwdXNfaGVsZCgpIHRvIGFzc3VtZSB0aGUgY2FsbGVyIGhhcyBkb25lIHRo
YXQuDQo+ID4gICAtIEltcHJvdmVkIGNvbW1lbnRzIGFyb3VuZCB0ZHhfZW5hYmxlKCkgYW5kIHRk
eF9jcHVfZW5hYmxlKCkuDQo+ID4gICAtIEltcHJvdmVkIGNoYW5nZWxvZyB0byB0ZWxsIHRoZSBz
dG9yeSBiZXR0ZXIgYWNjb3JkaW5nbHkuDQo+ID4gDQo+ID4gdjggLT4gdjk6DQo+ID4gICAtIFJl
bW92ZWQgZGV0YWlsZWQgVE9ETyBsaXN0IGluIHRoZSBjaGFuZ2Vsb2cgKERhdmUpLg0KPiA+ICAg
LSBBZGRlZCBiYWNrIHN0ZXBzIHRvIGRvIG1vZHVsZSBnbG9iYWwgaW5pdGlhbGl6YXRpb24gYW5k
IHBlci1jcHUNCj4gPiAgICAgaW5pdGlhbGl6YXRpb24gaW4gdGhlIFRPRE8gbGlzdCBjb21tZW50
Lg0KPiA+ICAgLSBNb3ZlZCB0aGUgJ2VudW0gdGR4X21vZHVsZV9zdGF0dXNfdCcgZnJvbSB0ZHgu
YyB0byBsb2NhbCB0ZHguaA0KPiA+IA0KPiA+IHY3IC0+IHY4Og0KPiA+ICAgLSBSZWZpbmVkIGNo
YW5nZWxvZyAoRGF2ZSkuDQo+ID4gICAtIFJlbW92ZWQgImFsbCBCSU9TLWVuYWJsZWQgY3B1cyIg
cmVsYXRlZCBjb2RlIChQZXRlci9UaG9tYXMvRGF2ZSkuDQo+ID4gICAtIEFkZCBhICJUT0RPIGxp
c3QiIGNvbW1lbnQgaW4gaW5pdF90ZHhfbW9kdWxlKCkgdG8gbGlzdCBhbGwgc3RlcHMgb2YNCj4g
PiAgICAgaW5pdGlhbGl6aW5nIHRoZSBURFggTW9kdWxlIHRvIHRlbGwgdGhlIHN0b3J5IChEYXZl
KS4NCj4gPiAgIC0gTWFkZSB0ZHhfZW5hYmxlKCkgdW52ZXJpc2FsbHkgcmV0dXJuIC1FSU5WQUws
IGFuZCByZW1vdmVkIG5vbnNlbnNlDQo+ID4gICAgIGNvbW1lbnRzIChEYXZlKS4NCj4gPiAgIC0g
U2ltcGxpZmllZCBfX3RkeF9lbmFibGUoKSB0byBvbmx5IGhhbmRsZSBzdWNjZXNzIG9yIGZhaWx1
cmUuDQo+ID4gICAtIFREWF9NT0RVTEVfU0hVVERPV04gLT4gVERYX01PRFVMRV9FUlJPUg0KPiA+
ICAgLSBSZW1vdmVkIFREWF9NT0RVTEVfTk9ORSAobm90IGxvYWRlZCkgYXMgaXQgaXMgbm90IG5l
Y2Vzc2FyeS4NCj4gPiAgIC0gSW1wcm92ZWQgY29tbWVudHMgKERhdmUpLg0KPiA+ICAgLSBQb2lu
dGVkIG91dCAndGR4X21vZHVsZV9zdGF0dXMnIGlzIHNvZnR3YXJlIHRoaW5nIChEYXZlKS4NCj4g
PiANCj4gPiB2NiAtPiB2NzoNCj4gPiAgIC0gTm8gY2hhbmdlLg0KPiA+IA0KPiA+IHY1IC0+IHY2
Og0KPiA+ICAgLSBBZGRlZCBjb2RlIHRvIHNldCBzdGF0dXMgdG8gVERYX01PRFVMRV9OT05FIGlm
IFREWCBtb2R1bGUgaXMgbm90DQo+ID4gICAgIGxvYWRlZCAoQ2hhbykNCj4gPiAgIC0gQWRkZWQg
Q2hhbydzIFJldmlld2VkLWJ5Lg0KPiA+ICAgLSBJbXByb3ZlZCBjb21tZW50cyBhcm91bmQgY3B1
c19yZWFkX2xvY2soKS4NCj4gPiANCj4gPiAtIHYzLT52NSAobm8gZmVlZGJhY2sgb24gdjQpOg0K
PiA+ICAgLSBSZW1vdmVkIHRoZSBjaGVjayB0aGF0IFNFQU1SUiBhbmQgVERYIEtleUlEIGhhdmUg
YmVlbiBkZXRlY3RlZCBvbg0KPiA+ICAgICBhbGwgcHJlc2VudCBjcHVzLg0KPiA+ICAgLSBSZW1v
dmVkIHRkeF9kZXRlY3QoKS4NCj4gPiAgIC0gQWRkZWQgbnVtX29ubGluZV9jcHVzKCkgdG8gTUFE
VC1lbmFibGVkIENQVXMgY2hlY2sgd2l0aGluIHRoZSBDUFUNCj4gPiAgICAgaG90cGx1ZyBsb2Nr
IGFuZCByZXR1cm4gZWFybHkgd2l0aCBlcnJvciBtZXNzYWdlLg0KPiA+ICAgLSBJbXByb3ZlZCBk
bWVzZyBwcmludGluZyBmb3IgVERYIG1vZHVsZSBkZXRlY3Rpb24gYW5kIGluaXRpYWxpemF0aW9u
Lg0KPiA+IA0KPiA+IA0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4Lmgg
IHwgICA0ICsNCj4gPiAgIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8IDE3OSArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgIGFyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHguaCB8ICAxMyArKysNCj4gPiAgIDMgZmlsZXMgY2hhbmdlZCwgMTk2IGluc2VydGlvbnMo
KykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggYi9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiA+IGluZGV4IGI0ODliNWI5ZGU1ZC4uMDNmNzQ4
NTE2MDhmIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+ID4g
KysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gPiBAQCAtMTAyLDggKzEwMiwxMiBA
QCBzdGF0aWMgaW5saW5lIGxvbmcgdGR4X2t2bV9oeXBlcmNhbGwodW5zaWduZWQgaW50IG5yLCB1
bnNpZ25lZCBsb25nIHAxLA0KPiA+ICAgDQo+ID4gICAjaWZkZWYgQ09ORklHX0lOVEVMX1REWF9I
T1NUDQo+ID4gICBib29sIHBsYXRmb3JtX3RkeF9lbmFibGVkKHZvaWQpOw0KPiA+ICtpbnQgdGR4
X2NwdV9lbmFibGUodm9pZCk7DQo+ID4gK2ludCB0ZHhfZW5hYmxlKHZvaWQpOw0KPiA+ICAgI2Vs
c2UJLyogIUNPTkZJR19JTlRFTF9URFhfSE9TVCAqLw0KPiA+ICAgc3RhdGljIGlubGluZSBib29s
IHBsYXRmb3JtX3RkeF9lbmFibGVkKHZvaWQpIHsgcmV0dXJuIGZhbHNlOyB9DQo+ID4gK3N0YXRp
YyBpbmxpbmUgaW50IHRkeF9jcHVfZW5hYmxlKHZvaWQpIHsgcmV0dXJuIC1FTk9ERVY7IH0NCj4g
PiArc3RhdGljIGlubGluZSBpbnQgdGR4X2VuYWJsZSh2b2lkKSAgeyByZXR1cm4gLUVOT0RFVjsg
fQ0KPiA+ICAgI2VuZGlmCS8qIENPTkZJR19JTlRFTF9URFhfSE9TVCAqLw0KPiA+ICAgDQo+ID4g
ICAjZW5kaWYgLyogIV9fQVNTRU1CTFlfXyAqLw0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBpbmRl
eCBlNjJlOTc4ZWJhMWIuLmJjZjJiMmQxNWEyZSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMN
Cj4gPiBAQCAtMTMsNiArMTMsMTAgQEANCj4gPiAgICNpbmNsdWRlIDxsaW51eC9lcnJuby5oPg0K
PiA+ICAgI2luY2x1ZGUgPGxpbnV4L3ByaW50ay5oPg0KPiA+ICAgI2luY2x1ZGUgPGxpbnV4L3Nt
cC5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvY3B1Lmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9z
cGlubG9jay5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvcGVyY3B1LWRlZnMuaD4NCj4gPiArI2lu
Y2x1ZGUgPGxpbnV4L211dGV4Lmg+DQo+ID4gICAjaW5jbHVkZSA8YXNtL21zci1pbmRleC5oPg0K
PiA+ICAgI2luY2x1ZGUgPGFzbS9tc3IuaD4NCj4gPiAgICNpbmNsdWRlIDxhc20vYXJjaHJhbmRv
bS5oPg0KPiA+IEBAIC0yMyw2ICsyNywxOCBAQCBzdGF0aWMgdTMyIHRkeF9nbG9iYWxfa2V5aWQg
X19yb19hZnRlcl9pbml0Ow0KPiA+ICAgc3RhdGljIHUzMiB0ZHhfZ3Vlc3Rfa2V5aWRfc3RhcnQg
X19yb19hZnRlcl9pbml0Ow0KPiA+ICAgc3RhdGljIHUzMiB0ZHhfbnJfZ3Vlc3Rfa2V5aWRzIF9f
cm9fYWZ0ZXJfaW5pdDsNCj4gPiAgIA0KPiA+ICtzdGF0aWMgdW5zaWduZWQgaW50IHRkeF9nbG9i
YWxfaW5pdF9zdGF0dXM7DQo+ID4gK3N0YXRpYyBERUZJTkVfUkFXX1NQSU5MT0NLKHRkeF9nbG9i
YWxfaW5pdF9sb2NrKTsNCj4gPiArI2RlZmluZSBURFhfR0xPQkFMX0lOSVRfRE9ORQlfQklUVUwo
MCkNCj4gPiArI2RlZmluZSBURFhfR0xPQkFMX0lOSVRfRkFJTEVECV9CSVRVTCgxKQ0KPiA+ICsN
Cj4gPiArc3RhdGljIERFRklORV9QRVJfQ1BVKHVuc2lnbmVkIGludCwgdGR4X2xwX2luaXRfc3Rh
dHVzKTsNCj4gPiArI2RlZmluZSBURFhfTFBfSU5JVF9ET05FCV9CSVRVTCgwKQ0KPiA+ICsjZGVm
aW5lIFREWF9MUF9JTklUX0ZBSUxFRAlfQklUVUwoMSkNCj4gDQo+IEknbSBjdXJpb3VzLCB3aHkg
ZG8gd2UgaGF2ZSB0byB0cmFjayB0aHJlZSBzdGF0ZXM6IHVuaW5pdGlhbGl6ZWQgDQo+ICghZG9u
ZSksIGluaXRpYWxpemVkIChkb25lICsgISBmYWlsZWQpLCBwZXJtYW5lbnQgZXJyb3IgKGRvbmUg
KyBmYWlsZWQpLg0KPiANCj4gW2Jlc2lkZXM6IHdoeSBjYW4ndCB5b3UgdXNlIGFuIGVudW0gYW5k
IHNoYXJlIHRoYXQgYmV0d2VlbiBnbG9iYWwgYW5kIHBjcHU/XQ0KPiANCj4gV2h5IGNhbid0IHlv
dSBoYXZlIGEgcGNwdSAiYm9vbCB0ZHhfbHBfaW5pdGlhbGl6ZWQiIGFuZCAiYm9vbCANCj4gdGR4
X2dsb2JhbF9pbml0aWFsaXplZCI/DQo+IA0KPiBJIG1lYW4sIGlmIHRoZXJlIHdhcyBhbiBlcnJv
ciBkdXJpbmcgcHJldmlvdXMgaW5pdGlhbGl6YXRpb24sIGl0J3Mgbm90IA0KPiBpbml0aWFsaXpl
ZDogeW91J2QgdHJ5IGluaXRpYWxpemluZyBhZ2FpbiAtLSBhbmQgcG9zc2libHkgZmFpbCBhZ2Fp
biAtLSANCj4gb24gdGhlIG5leHQgYXR0ZW1wdC4gSSBkb3VidCB0aGF0IGEgInRyeSB0byBjYWNo
ZSBmYWlsZWQgc3RhdHVzIHRvIGtlZXAgDQo+IGZhaWxpbmcgZmFzdCIgaXMgcmVhbGx5IHJlcXVp
cmVkLg0KPiANCj4gSXMgdGhlcmUgYW55IG90aGVyIHJlYXNvbiAoZS5nLiwgc2Vjb25kIGluaXQg
YXR0ZW1wdCB3b3VsZCBzZXQgeW91ciANCj4gY29tcHV0ZXIgb24gZmlyZSkgd2h5IGl0IGNhbid0
IGJlIHNpbXBsZXI/DQoNCk5vIG90aGVyIHJlYXNvbnMgYnV0IG9ubHkgdGhlIG9uZSB0aGF0IHlv
dSBtZW50aW9uZWQgYWJvdmU6IEkgZGlkbid0IHdhbnQgdG8NCnJldHJ5IGluIGNhc2Ugb2YgcGVy
bWFuZW50IGVycm9yLg0KDQpZZXMgSSBhZ3JlZSB3ZSBjYW4gaGF2ZSBhIHBjcHUgImJvb2wgdGR4
X2xwX2luaXRpYWxpemVkIiBhbmQgYSAiYm9vbA0KdGR4X2dsb2JhbF9pbml0aWFsaXplZCIgdG8g
c2ltcGxpZnkgdGhlIGxvZ2ljLg0KDQpUaGFua3MhDQoNCg==
