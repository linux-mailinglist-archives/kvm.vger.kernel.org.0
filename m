Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC626381F2
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 01:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiKYAp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 19:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiKYAp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 19:45:26 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEC417E0C;
        Thu, 24 Nov 2022 16:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669337125; x=1700873125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vOjgatRkmKoWU0bbDyjcg88au5jvl6SKVcHoI8HdMgk=;
  b=BQlrGwh05gxDwFCnGDxSTxXSXBYRNMFk4TCzKHPpCj9m301JVTLZ29vw
   VRd6geZv81lvap5H4JfU+yNuYV2OgCB/sQBTbFSDRyxoXSg45mUFyYrnq
   51BaX8MIgPcUkOm8Z+7+NUikNCnXPeMfEmUBwLXllms4hiqK7X/alc6K9
   tyjZW4m3PcWh+lFoudWzBs90YGC1wHw9/+7MwMIWlFFBwL14gpVBse0pE
   BRcdmIXWxwzFjL6ecnesTglSNtoGxLf/zYFAobvK5uXQbDqPGJ1pVkVeu
   kUVWpIAuqLDYyv6T+lDmDfz3Dg4Sh8hOJcpN4sl1nxt8onMAw6mCcfk5C
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="301954973"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="301954973"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 16:45:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="642536283"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="642536283"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 16:45:09 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 24 Nov 2022 16:45:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 16:45:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 16:45:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSE4+uo7OBSBKM7uFGBnKze+JTvkBj0wbCG3ezjXgikmFcObksFtHrw++Z0CRopStE41c6cAvKl/IgbNOglF72MIp5RcRN6vV+xPZqkcJuegxmuwpGH40mn+70xE1IsvvcbcFqbMoTmtlP6QTaZnpqYtCw4AaNDtLv/Q8bV2BkBZgYYui+toPTX6Y2j06+VyHidiXBObj0hzccK5OOGr6tn9Xqi7GM4j9bjaAxv/iB4A1/jeUIQpLBtGi0fi4yCbMTlkN2JWeYaEs2pw21K1SPfyoeJitP2UXVsgl/quV08x+bbX3Smqb4egemsr/6+R1fOM2s4F12EBhRRjI6v60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOjgatRkmKoWU0bbDyjcg88au5jvl6SKVcHoI8HdMgk=;
 b=akaNJ3ZmG//0RN1DZiAFhxtazgdhmyLWhokoeGpcSUKMxr+KR37QkhFWR9gZxXJyTRqj84qkaonNYlejZlXDhABXrGppCKQWf8sMairHt8vFM4lIxJKvDW+C8xWr6RCZX2JU8YUvfy5zDiSjRc21uY65Wxj4inFyF3GKMDOiVlwX8MnnRKzIzXSI5d+T5atZganCbnWFbHAmt7GOf03yzV4fs7SeJqm3YXFM4DrMGAcOeS+/op0d0aJF2ydG6zE1e1LYeaLzHuheZwnkhQ6blzDuNcOcbsQK5p+4FU2amvznHxfmgcCoZB3qgLiM0xZVdlZdBjP4IQ6c9gnmhgUCxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5097.namprd11.prod.outlook.com (2603:10b6:806:11a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 00:45:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 00:45:01 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Topic: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Index: AQHY7ChybP3VDS//1EK2niE1cyNWwq5KVsuAgASWdoD///+UAIAACSUA
Date:   Fri, 25 Nov 2022 00:45:01 +0000
Message-ID: <8e14a7732a2d873846d07c4ec467fb7c48b2307f.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
         <Y3wvhWyIKNzczFov@yzhao56-desk.sh.intel.com>
         <887a77acc9bf96f7c7bea519ab7ebdd27fb67985.camel@intel.com>
         <Y4AIYGGEU3BdrQgV@yzhao56-desk.sh.intel.com>
In-Reply-To: <Y4AIYGGEU3BdrQgV@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB5097:EE_
x-ms-office365-filtering-correlation-id: 9d7cfca5-9747-4df6-dceb-08dace7e4904
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +EuN1C8zhv75tsxU4HsKJY7LqwMpGBSvubE2cJwK0rBI8N5Ms4nIpLUUyitozPY8LwyqrAs7ioXm6AUU/2KBL1EcmhZq49Fs5YMSNmJ9nH52202sLaa5GHe6aQDEaYbOGMKHgqMyhN1s4iWE28Sk3799B5NY7SZArRfeZI4X9jZPQVePO8nknAE67R9PEj/LDvAwR6/gtRiyKV5aat68nuNKUEhNnco/uchWeYkYt+P+S6sUODAwYrJ3McD6AsWtAwsxWYpbYRLM8DfEkO8jiQ/VcxDRTA9qrY6ARdyp3KCGY2kzVZO1Ych7Di6O2J8EpCSkrHi0b0DRb/De3+MmAoKOGNPml/iVbEqeLh4LLAlFYz825Ny6owvYxoLl3Y/RwDfM64FswoDQ+FCTkdi4I5THGNRVTmD6JiDewf48+R9EHmh8vgWUT9D8xZXlIk172Z9G3IFgqsl4nCgBMWtcOSVXJy9ox58G58byHgJ+EaqTh/fXEiNBtDueAPDihLc+oJqsgqiPZfQcFo2dCC2knS9XJYnpXWay2vFmxXPWJy1NXOwt2aDc4l8CA0J4bQv5wiPhfRfrRFxKZsksn3MkUqrGofJVXPNRxx4IjWYkZYPFh4cJ95XQSY460OrTUlNZ9NjCkfKOZ2Kvtv3qpLn5sCFPSDc4TTfox6cWsilJ0e4iu6Ptn4ESiqgS11PPCCJox7POQd0aPh81OeSpClb50g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199015)(2616005)(6512007)(83380400001)(26005)(186003)(38100700002)(122000001)(82960400001)(38070700005)(5660300002)(4001150100001)(6862004)(8936002)(2906002)(91956017)(478600001)(6506007)(316002)(71200400001)(6486002)(8676002)(66476007)(66446008)(66946007)(4326008)(6636002)(41300700001)(37006003)(76116006)(64756008)(66556008)(54906003)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUV2VWxMS2N2U05aaWZOVWgrQWMzWkRvenlHTjRiSklINHBZNlVJUHQrbFZo?=
 =?utf-8?B?bnNCTVdENkV1d2JCczN2WWExMktmV2JLQ0RVQlZuSTg1NkUzTWdCdzdiOC9G?=
 =?utf-8?B?MEpNVm4wZzJCcFZEOGtza1FrWW1FOFpPcit6Mm5BalhRZ2t2VXp6cVNYSFND?=
 =?utf-8?B?akc4alY4VnN0Z05yTmZGN1NtS3c1TE9nODJweTBkc1R2ajV6aXh3LzEyUFd0?=
 =?utf-8?B?WVRLV1d4SUgrL2x6Mjh2NTVhc09EdlJSUWg4Z292YlJKVUw5YnVEZ3IycXFa?=
 =?utf-8?B?azlaSTdhekhMaGRseVQrc3lDdVR6SE4yV1ZBa0k3aFpoZFAyd0REeTFsWEpt?=
 =?utf-8?B?U1EwV2o3L1A1Zzh1SmtpNzc1R3ZiVTRFMzVRR1NJZE0zT0RUL0V3eEJHYmU4?=
 =?utf-8?B?WVRlT2o0TFo2L1VMMjQ2azJweDBmNkVRTG1VTjQyRDBZQTd3SWNBenFkMFlD?=
 =?utf-8?B?NGZ4VUcrWSs0c05zUTFYaCtzb0JXQVN6amNEU3FiMGJPS0d1QUV1RnRqeEJ1?=
 =?utf-8?B?RllFSXFMM1lPZ1IzbUJlYjNBYlgvWXI1cnViZEF4M2dvOEhUc3lsLzl2bml3?=
 =?utf-8?B?RU10NDlIeFlQVmJxRFpSZkxxNC9HVEhmcEF4RlhqVUxVd2t4NXFuM21wdm1p?=
 =?utf-8?B?dE90b1lDQ1lsUHVqZDBTcU9NSjNycVNMVi8rclpSN1hZRThEczJZeHl0ZVpX?=
 =?utf-8?B?Y3ZIMisvbGorNVNVZ2daNWJ0aGswQVVhbkh0YnpPMmN4VHFaMy9JcjlvWFR5?=
 =?utf-8?B?U01EOS9RcjdraEpUQi9NbVhzUnBMWEwwK29IUldlM3UvbHFuUHR6anptQlVK?=
 =?utf-8?B?bnVIOGFsQWxTWlhCbThxWUlham9MckpaL3Ewa1FxYXU1NmJQS01vblZ1b1l5?=
 =?utf-8?B?dEowTGJReThBSTFoSWlHZVlyWFBnUFk2Y2FEWDluM081TzdXUVhmS2tHR09V?=
 =?utf-8?B?MU90TVNsR3pQTXptVEJZeFY2TExtMW85a1RzQTBNZjZLdVpUVi80dGlnQ0c0?=
 =?utf-8?B?c3JQN0ZXOENKRVV1VUJIeEw5ZXRIbldwQTQxZnp3MjNzRmdPZktxSDIwTzhG?=
 =?utf-8?B?NTZXdnRROHFWSUwxRnQyQ3gzZ1FDWG1ZVG9vcEwvWkFUTXQrSEl0N2YrTkcr?=
 =?utf-8?B?eFVGK2xhRncyOWRwS1BCeHlTcmJIZmVvdTBwdjlZcTRTRzhJblMrSHVubTRO?=
 =?utf-8?B?OVJXM0hLK3RScHppK0c1VkZrcVExbGtIM0ltNm9YVEtUeWg3elhjM2plQUEy?=
 =?utf-8?B?SjI5OUZSSVpiVkVvejBwd2FFOVdrNGhtQ0pSRi8xNHozZHE2U3FDNXFjRGxj?=
 =?utf-8?B?U2FwRU5hWkpyZEowRlR0aFlUQVRSSnY2L2RCM1FkR2orbXIrYkRQZ2VUWWxk?=
 =?utf-8?B?ZlptWlBsTzNiZ21XcUFDVWlPOTBwdTlZSlZkeFFoYVY0bWVnaDlLeE02OXRO?=
 =?utf-8?B?RFNEb25JNXlvcE5ySk1yeHFtS2J2akp4MTRFRHM5d3Fsa3dVRkJUYWVJSzVy?=
 =?utf-8?B?UXBobmVMa21pLzJ5bzBLOVpTZVlTTEZMRnIzTlo5UStGejdkME0xZHd6R0da?=
 =?utf-8?B?bFZMMEc0Tk41R0FDNFFMdk4vU2FISFpKUDNseVJ4eE03bDdXNUlqNy9OcXFv?=
 =?utf-8?B?WWdmVG53bG5yRDJqY3h1WnkrNHhqbG5sQXA1VkxVSk9Gckp1UkFDSzh0enNq?=
 =?utf-8?B?WFFwUXg0UCthV25vNm9pdTZMQXcxUVMrSjdKRWlNcUswS3pUK3htc0I0VTE0?=
 =?utf-8?B?RG9Fa1hyWWN0SUliMk9vYmRvOE9HSEZzS2E3ck4xdWhTbE8zM2ZyendsS3Q5?=
 =?utf-8?B?ZG9OY21xcVJpenBaM2VWRmltVTNiRlY2ZXFySk1hRmlVbDlpUXNsOWdYK1Z4?=
 =?utf-8?B?UC9VNVNYUnVIVW5NQ0VXY1g5OVY1bHVMZnBkaXd3TmE2Y0hqbEY1M3JrQ3BN?=
 =?utf-8?B?RWN6QldFV0g0VUk1Y0JkdlNsSGZFWndjWUs4TURsbUlTUUZaMmRCdmV0UzlX?=
 =?utf-8?B?czZLR0VTL01KTElLNHE1RTRCU3hheXA4ZS9BNG83SzNPQVM2bE9JT09hTyti?=
 =?utf-8?B?MS9zVFZmMDducmh2Q3NpL0JwOVV5TldQUEpYTXkzOVRLdzB4SHpxK0Noa0RU?=
 =?utf-8?B?eUtCaHFqYmNKWTdPeDUyTXZVSU5tc0J5WENJRnI4dXFaREpzRlAyQlZ4T09Q?=
 =?utf-8?B?c2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA826DD7663D3846854FA8F34DF0CAE6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7cfca5-9747-4df6-dceb-08dace7e4904
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 00:45:01.2290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S9UcH1KzDSVKRggrRHLShB8pKqMZAmT6rlFMAHpDHyz1iyTb6HD3ZZB3fwvh0ppo9vEJYn/Tjqv65f9eMReBQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5097
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

T24gRnJpLCAyMDIyLTExLTI1IGF0IDA4OjEyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
RnJpLCBOb3YgMjUsIDIwMjIgYXQgMDg6MTM6NDhBTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBUdWUsIDIwMjItMTEtMjIgYXQgMTA6MTAgKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0K
PiA+ID4gQWxzbyBtYWtlIGVuYWJsZV9tbWlvX2NhY2hpbmcgdG8gYmUgYSBwZXItVk0gdmFsdWU/
DQo+ID4gPiBBcyBpZiB0aGUgc2hhZG93X21taW9fdmFsdWUgaXMgMCwgbW1pb19jYWNoaW5nIG5l
ZWRzIHRvIGJlIGRpc2FibGVkLg0KPiA+IA0KPiA+IElmIEkgcmVjYWxsIGNvcnJlY3RseSwgU2Vh
biBzYWlkIHdlIGNhbiBkaXNhYmxlIFREWCBndWVzdHMgaWYgbW1pb19jYWNoaW5nIGlzDQo+ID4g
ZGlzYWJsZWQgKHdlIGFsc28gd2lsbCBuZWVkIHRvIGNoYW5nZSB0byBhbGxvdyBlbmFibGVfbW1p
b19jYWNoaW5nIHRvIHN0aWxsIGJlDQo+ID4gdHJ1ZSB3aGVuIG1taW9fdmFsdWUgaXMgMCkuDQo+
ID4gDQo+ID4gU0VWX0VTIGhhcyBzaW1pbGFyIGxvZ2ljOg0KPiA+IA0KPiA+IHZvaWQgX19pbml0
IHNldl9oYXJkd2FyZV9zZXR1cCh2b2lkKQ0KPiA+IHsNCj4gPiANCj4gPiAJLi4uDQo+ID4gDQo+
ID4gICAgICAgICAvKg0KPiA+ICAgICAgICAgICogU0VWLUVTIHJlcXVpcmVzIE1NSU8gY2FjaGlu
ZyBhcyBLVk0gZG9lc24ndCBoYXZlIGFjY2VzcyB0byB0aGUgZ3Vlc3QNCj4gPiAgICAgICAgICAq
IGluc3RydWN0aW9uIHN0cmVhbSwgaS5lLiBjYW4ndCBlbXVsYXRlIGluIHJlc3BvbnNlIHRvIGEg
I05QRiBhbmQNCj4gPiAgICAgICAgICAqIGluc3RlYWQgcmVsaWVzIG9uICNOUEYoUlNWRCkgYmVp
bmcgcmVmbGVjdGVkIGludG8gdGhlIGd1ZXN0IGFzICNWQw0KPiA+ICAgICAgICAgICogKHRoZSBn
dWVzdCBjYW4gdGhlbiBkbyBhICNWTUdFWElUIHRvIHJlcXVlc3QgTU1JTyBlbXVsYXRpb24pLg0K
PiA+ICAgICAgICAgICovDQo+ID4gICAgICAgICBpZiAoIWVuYWJsZV9tbWlvX2NhY2hpbmcpDQo+
ID4gICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+IA0KPiANCj4gV291bGQgZW5hYmxpbmcg
bW1pbyBjYWNoaW5nIGluIHBlci1WTSBiYXNpcyBiZSBiZXR0ZXI/DQo+IA0KDQpXZSBuZWVkIFBh
b2xvL1NlYW4gdG8gZGVjaWRlLg0KDQpUaGUgdGhpbmcgaXMgVERYIGd1ZXN0cyBhbHdheXMgcmVx
dWlyZSBtbWlvX2NhY2hpbmcgYmVpbmcgZW5hYmxlZC4gIEZvciBWTVgNCmd1ZXN0cywgbm9ybWFs
bHkgd2Ugd2lsbCBhbHdheXMgZW5hYmxlIG1taW9fY2FjaGluZyB0b28uICBTbyBJIHRoaW5rIHBl
ci1WTQ0KYmFzaXMgbW1pb19jYWNoaW5nIGlzIG5vdCB0aGF0IHVzZWZ1bC4NCg==
