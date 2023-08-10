Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA2F776D65
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 03:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjHJBNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 21:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjHJBNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 21:13:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9757D1982;
        Wed,  9 Aug 2023 18:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691629978; x=1723165978;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/nAufynBZRyBgfUmD4dTXkv4pt+JgALQ0I2KxmVtz1I=;
  b=eJtCnKwTFFWfyVi+Wjc/fi+1PzuqfQILMtuu2FWguBFqQNFa1ASZ8pdz
   3Zkdv1nA9+RUGONCE8eAP8U32ajmNpOlRcLLF2fAuED3w2YsqNPC9yFTQ
   FT6mHQzUFbQTGjkCdxlpFW58b3lhiM/hv5+0wrT4fwNDsnR2UEgNNwlbb
   YaFZbN2+GYMlDGs66YbuUcEuvVPF654pIP3hxepnJcQ7XYG8cDtl0lZPP
   atqR7u7Gm/BKMqITRpzYqlHVchM24FyNSSJLbTPQoh4QuciLkz72dI8t+
   WMpQmHqWD35v7QZX4ieAqQmr+s945uXEmPoooSy97aAwvF9iHEz4MQ3pa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="402228561"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="402228561"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 18:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="801967758"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="801967758"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 09 Aug 2023 18:12:57 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 18:12:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 18:12:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 18:12:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRKyLyDuHCFzIpLOHeZaFnCg+B54b0tw7Qok69uKSUCboJjK5W1LvsOhCowxbJwc+FMSTY5usg7pDPnaA2WKjava0J5h2KdhKSJDKR1A+HirKmlQMehBmmTW5iY93x5Za24UU6W3OwWMa5WcyXcEWUrkVr8N/3NxYP/gC6zHVCCANLe3Pno1x7udD7p/pP+9tPuRimlRWGm1eyKrux9zOP0SpQqslghPE8XB2ig2A8M2n/pr6F/b9kErdYByGKS8beR0t8dKnBRbuuYosCsmSbVIi+S/N75Fy56Gbzb19lds+E3kchF8FPRBuwsZZ+sIQaYRTJu5MBKABjhfWJvR3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmhFEd5OlAYyBtyFZaDK1HTwjEiA8tzXFyZgMy33nuQ=;
 b=lTm4A5Ve24DUOS4M3dyVKn259I8mAZPYshilLDXA1p2xOifb37lel+G1YZsfT1nq9sjs5VI9iT5rWAqEG8QxseWCmPKBmKDuiE/ntwbr0o5sSW5ydyDve00eNPeMU9xMRS8LC2mIMYDgoZicZnKt43e9BDm/E7vs5RuO1j0NLzlslBdjchLL12NECT3ynB1688Bov4M5x/s23z5DI63IcxOq4P7Zip7dDZcRU06KDv9zeenxigrC9Wkww4crkFQX5huITIqkCb5XqBwkiYap+Lf0E3aINoDLBFENQ74McnohlRRmUB7Cl/pEHeJfobQ4GPBKyEfK5qj9UdvM9RQ1Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7778.namprd11.prod.outlook.com (2603:10b6:930:76::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 01:12:54 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.028; Thu, 10 Aug 2023
 01:12:54 +0000
Message-ID: <839913af-a511-19fe-919e-733f080196ea@intel.com>
Date:   Thu, 10 Aug 2023 09:12:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <chao.gao@intel.com>, <binbin.wu@linux.intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-5-weijiang.yang@intel.com>
 <ZM1C+ILRMCfzJxx7@google.com>
 <0655c963-78e5-62c9-50af-20d9de8a1001@intel.com>
 <CABgObfbvr8F8g5hJN6jn95m7u7m2+8ACkqO25KAZwRmJ9AncZg@mail.gmail.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <CABgObfbvr8F8g5hJN6jn95m7u7m2+8ACkqO25KAZwRmJ9AncZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0065.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::29) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7778:EE_
X-MS-Office365-Filtering-Correlation-Id: a2c76ee3-b37c-4b69-a4d7-08db993eecbb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cvDxLNUvk9zAaKLmhyM33tmaP6MRioA9l5LS3v9cJ7PXhmfQtO8oynTer0MUMst2Lz6Nw7yrxOlZae2wL7nXsZ5iMBpVnIfYm6LEsFJpfFUztvVZGbaXX/nbj4qIVUhdpS46ehM4YeK/vxhbm7czFbADv2w3Wr4MBT1LeCGEYd6LqKh/FFW7m/1pjxRBAB+o5ip559y/6vgUOC31nDDvqO2p2HBAndAKiiNBdsJdvW80qGB+im2wzlduHEWeSppJOf4MFquMThiAZEv0Q+NF0iC+0DXmd13f1YLHYgMmyiY3qyksk3SW0w+cAZEK+5TAALe4vjvOM/esWqjfgQdmEw68jgHDDDUI5iX0mcK7AfU4BO8zrkaGcJaPCw6C6OsSkjrBoF6glP9IQK46WJvnesy9pf7n/HREpgnH4NM3O41HCh9te+tiZdrRB+/bSPUtlKjPJufD3BZDUmLjE07mbbvl5T4tpNNUdE+cT01WXukm1lpRyYU0r+WeOwKa+5yIdXuml54YTG6KZYUtW0GbXX2aIMVb1FX0bRexKrIc7/15EsLNB31kjnPi1qMDfH99uG9Z57oPpW0DaSJCYXBNdKTift/3+jWaSVW/xXSjiQqajySYsvCzSPmdaz/y0kQUFfFY4WC7U4gintTOw5sVRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(396003)(39860400002)(136003)(1800799006)(186006)(451199021)(5660300002)(8676002)(41300700001)(31686004)(6916009)(66476007)(66946007)(4326008)(66556008)(316002)(2906002)(54906003)(8936002)(6666004)(6486002)(478600001)(6506007)(82960400001)(26005)(53546011)(6512007)(83380400001)(36756003)(2616005)(38100700002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dm5zT3BUZUNpL3lHZTRKejVrL05FMlZwZzRzbjE5M3crNExLYXh4K1BhMXB4?=
 =?utf-8?B?UzdiMC9rT3ptR1FjckRyUC9QcVZsNlY2OXRJallBV3BWUlUxZVkvSDlRVENy?=
 =?utf-8?B?Y05tTzgrWHhheG9kQmh4N2RHa3JoMVZyR25hRHNYRHBCd0ZhTXljUVhHOW5M?=
 =?utf-8?B?cm11V3RKNmNJenBra095dUE0RTB4bnl5NW1iK0tnbWlxSXNSbkhObVo1QmJz?=
 =?utf-8?B?aEFqMFM5NUtVZEplU1g2RVpndlh2SlpweDY0ZVZsWEJld3l4a2dmZ2k5NnVI?=
 =?utf-8?B?d3h4ZmM3UjVPZjhZb24ycUt6Z0lRdjlOcXMwdXNZMUNSeXU5eFJ6NTVoZld4?=
 =?utf-8?B?UWlFV3piakRzUFdLVWczRWphWGtqdlJ5dGxuTTFteXBFZFpBSzA3MmVKTGZX?=
 =?utf-8?B?WmZBd051N3JMTThUbms2L2xXU1RqS1JQeUFCVE51OWREVlkxMEhSZTErYnVC?=
 =?utf-8?B?eVphUXFYTWdnUlFpbTJLbHJOUzNqVWNmVHRYaU1DNHRYUmIwOGw3RHM4WnIx?=
 =?utf-8?B?VjB3QkJFc3pEU0dxckFrOTd4NEZ1WmJPcFR3UGR1MXFTYXNjOFI0cUpRSHk2?=
 =?utf-8?B?a3VLeWl1REZnTE5KMzlvTE93T1N5c1ptSzVXT0h6S2xrcHAwRGp1ZFFJdGNq?=
 =?utf-8?B?NFBPWnJpSFdkMXRJT2JsUmxyanJSdEF3UjJWUjc2ODhIdTZqa1NYSEsxeTls?=
 =?utf-8?B?ZVdXU0lkdk1DSDlZVVBZdjlITTdsRkJ5RFhmQVczUU5JYWg4WTVlTElhWGh0?=
 =?utf-8?B?RElvcDVVVmppVjZUdUFPZUdabVRoVzRhclRsVHdhWWxnRnNqWkJ4K2ptdUNZ?=
 =?utf-8?B?SWFYQSsrNXM1K1UyV1ZvbnMxdm83VEI2Vmdxd0UweFFiLzNhbDJsMlNUS2lD?=
 =?utf-8?B?b1RUaFk4TUxTQ2NJUXp4bFBNOFlVRjYzTXJtdWlDbVAyNTdhallYdlpIY2FO?=
 =?utf-8?B?eDJuNGhnZVF1b25uM2hqYjNaZWFoaS9DY0xnUzNUMnNpTkNLNG4zWjBtQzJF?=
 =?utf-8?B?bmxiQlFodi9GUUFqNk1sZGZNQnNvdUgxTXR2bUpZYnZrS0ZqOW8vUFJza1pV?=
 =?utf-8?B?T3hKUmtYd3dHVlEzNU96R0szR1R3QTNWVWdzMkdkVmw1YXlSWDZnYTdwakR2?=
 =?utf-8?B?d3UzWEVPZnRXUDU3amNBc3BhMWhjME5mK2FQRkNDSERMTSt1Zk9aaEx4bDJ6?=
 =?utf-8?B?NmNheDlZZDB5SDZDVS9PcERpLy9GaGZFV3F2YVptaWVFWFU2bmtYM3k3b3Fk?=
 =?utf-8?B?bHptSVB2bFNJNVA4T0hlWVdLMVJja1MwZlp6NTAzQUJYTHY5WFRETWFYZFR4?=
 =?utf-8?B?L3Vibi9HTlN5ek5LdzR2Z3p2Rm9xNmozMkI2dHF1aVdtMTZOL2swMVU2RGVj?=
 =?utf-8?B?MjlKeWlZa0cwVlY0aDYrcExaS0dnY0JhK0c1dVkzb1FBK0x0ZTRLbllYK2hx?=
 =?utf-8?B?QldFNzNMK1NEeWpKNlIyOGxvenhzVzhWREdkN0g2WS91ZWdBa1BENXZSSWVD?=
 =?utf-8?B?SkFyVVJGeW55M1Jkb2RpZm1td3V1bmVXK2hOZkVTUkpTaDc5cmZTSDNaRzAv?=
 =?utf-8?B?K2ZEY3g1ek9SMHo3ajY5RGV6QzdnaGdnVzJrcEFHckovZTF6RlRxL1E3aDVs?=
 =?utf-8?B?L2szNDZMK0ZNWWFOdHY1Z3R5UUpQY2VENEV4OEJudmtHWlBNQyt2OUZvUVVr?=
 =?utf-8?B?K1N0Y1hWVW16YWsxRXZhUkpXbUVmRkxCQ1VGQkZBRTBYVDYwQlk3aXZucjhr?=
 =?utf-8?B?Y1hKNTZ2TGNhYlByMnVyWnF5Z2NGUStmQ3o1VTROR0F1d29jQ0lwNG4wdEl1?=
 =?utf-8?B?YXpyRFkwT0s3bklGYmZYZ2EvSTZyb0VCUjgzODlFNTA2V0x6QitldG8zT0pR?=
 =?utf-8?B?S1JrVjd4ZXRuQVJxdXlPMEtadlBlRzFjOFpkRndJMGtJM2MwL0xGZXI3aDZF?=
 =?utf-8?B?Sm1hZUladFFUZ050a0ZzMUFCNXpvbVQrUW9Dd0hTbUppY0wxWVcrdGtZQ2ZO?=
 =?utf-8?B?UVA0RWxJN3pUamgxc0ZhUHN1VUcxMkhXUjk2SHlUNXUyRjRKOHRQTkNnTWNL?=
 =?utf-8?B?akluTFd0a2pzOWZoZHF2bkd3TFJxcmh5ZHJyNWd6anBjbjNRajJadStQWEs4?=
 =?utf-8?B?dE1CNGhFSG5oUGxjcUFtaERUVCs3ZFJkdGMyQ3JPTDd2OWo1NFdFa3hrb0py?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c76ee3-b37c-4b69-a4d7-08db993eecbb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 01:12:54.5527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LqIfOhkIlxiKJP1LGe8WHTMduKvmihsvbP6IXIKBI4CT4Yjp/dUPViHo/yh2JLZEmKe0lSZBCksbuejGR+Dz7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7778
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/2023 8:01 AM, Paolo Bonzini wrote:
> On Wed, Aug 9, 2023 at 10:56 AM Yang, Weijiang <weijiang.yang@intel.com> wrote:
>>> I'm pretty sure I've advocated for the exact opposite in the past, i.e. argued
>>> that KVM's ABI is to not enforce ordering between KVM_SET_CPUID2 and KVM_SET_MSR.
>>> But this is becoming untenable, juggling the dependencies in KVM is complex and
>>> is going to result in a nasty bug at some point.
>>>
>>> For this series, lets just tighten the rules for XSS, i.e. drop the host_initated
>>> exemption.  And in a parallel/separate series, try to do a wholesale cleanup of
>>> all the cases that essentially allow userspace to do KVM_SET_MSR before KVM_SET_CPUID2.
>> OK, will do it for this series and investigate for other MSRs.
>> Thanks!
> Remember that, while the ordering between KVM_SET_CPUID2 and
> KVM_SET_MSR must be enforced(*), the host_initiated path must allow
> the default (generally 0) value.
Yes, will take it, thanks!
> Paolo
>
> (*) this means that you should check guest_cpuid_has even if
> host_initiated == true.
>

