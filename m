Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4805838FE
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 08:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiG1Gun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 02:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbiG1Guh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 02:50:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592DD5B074
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 23:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658991036; x=1690527036;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ap0EH449E2Gh/GXN99zOXEkIh9I6h0Uljs5nRhyd6Sk=;
  b=g9KyXmgckypyv8eSBlyVw6WnmB1nax8agJv/r4QkoXkOr3MbmGlVTMXD
   nVKAQFn9HvuefSDdSKFSvFNyOFGjhklL4J+0nlwFLwNby227YX498Et+g
   WaON5PpCyoGqx4OaQ4QZrw2JQhepxbLLKbq784zI1IDEO0xBm+vvDtDw1
   xwOACHSZ6F9S6zm3m5EjWjxPcWsVNYlzuA6l6gcHwKePNJ7OYggex+5gd
   hV7ef3qdXNSyHuEWjupsblc49c/jD661b/o68+41xETqOLEHHQarhUDUy
   SV9e73K98XaaOVppFcXQ35bR9K02MZoBDs2cGDws86u2i3uPetF3PpAEm
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="285986034"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="285986034"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 23:50:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="576326307"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 27 Jul 2022 23:50:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 23:50:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 27 Jul 2022 23:50:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 27 Jul 2022 23:50:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DC9YN9c9MZFFdcSWNnmGmoBGJt9wDH6xrdsBIdFElO5VctFSOAu2BcUiwbgywAbYkMTDwSaK1iEdYV73+M/+W+pG2pfCWPEBRmxjxIqGFj5buo3NbICI+cBLSvmlgPocsQi57aYvA+upFeR9yat0RaR5uzCl8VRhFQAgpbLbFrSmUK8kcrTTlYvtLUqoGxQYXxv6JpCpW3MNlZcMZBkiLvjZstGfueeq9QgAdyxNVBFvIvp4pfDG5WWSz+HPCElGZhxw/AYyci00v8cxNesjnqJ3Ti+cteTC3qf4LvGqyf/9aIzI7ZPkovghCjH9GLR5JUg1JJCeqHnZHCraRCRZEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbHfpkIKFtr7diGTtQKTQF1oDnXP2OjLx0TFKVUa9Wk=;
 b=VA4xXwGv8GVeOqfrM+SvOZOv9xyun4TTPl1eL/2hvLaW+yg08qSMO9p9Lfe9PdCtcsq3PA4N3pH61uySBO1eOkvy1cWuWkbxb2080tPFZYyFWQKHtEYQrRhQAN8nD5bZQvLOtPZbQB5qNFd+8npnduoCBMJ70Ow9wprn0NfqivXl5ZkZi+5g3e25MNhEDgVi8b+lvSjVfSPmqLj1HgGvd8nLX4lverbKPlLCcID45AKKagF+MsaAPAyVwFfI6GW0qEVRGQWAWjalAW0ukSGvTcb7Pirvygrfh8RSt/9dd7yjWyilH2iZkuRojOny5x6Wuqo+hLqQKd9IkkQZsuXkqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3870.namprd11.prod.outlook.com (2603:10b6:208:152::11)
 by BN6PR11MB1907.namprd11.prod.outlook.com (2603:10b6:404:105::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 06:50:31 +0000
Received: from MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::dd55:c9f5:fbc7:8a74]) by MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::dd55:c9f5:fbc7:8a74%3]) with mapi id 15.20.5458.025; Thu, 28 Jul 2022
 06:50:31 +0000
Message-ID: <f191e472-1fc8-6577-af77-412a73c59a97@intel.com>
Date:   Thu, 28 Jul 2022 14:50:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 33/89] KVM: arm64: Handle guest stage-2 page-tables
 entirely at EL2
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
CC:     Will Deacon <will@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, <kernel-team@android.com>,
        <kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-34-will@kernel.org>
 <Yoe70WC0wJg0Vcon@monolith.localdoman>
 <20220531164550.GA25631@willie-the-truck>
 <bf7dffb8-55d2-22cb-2944-b90e6117e810@intel.com>
 <YuEMkKY2RU/2KiZW@monolith.localdoman>
From:   "Huang, Shaoqin" <shaoqin.huang@intel.com>
In-Reply-To: <YuEMkKY2RU/2KiZW@monolith.localdoman>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0183.apcprd04.prod.outlook.com
 (2603:1096:4:14::21) To MN2PR11MB3870.namprd11.prod.outlook.com
 (2603:10b6:208:152::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d806bf2-9ad1-44fd-5bc5-08da70657645
X-MS-TrafficTypeDiagnostic: BN6PR11MB1907:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cogrrHGWTCMvSdJKnGAVaScgdOUBA7Kta0boQLT6Uwoe5pmmKxFlmtD2HFt4gtPv5wGZSDvTGFY46F1JXBuka7jMclIIwT1tDSga3GlwcEpHz4OVyQpSg5lodtIylFL1dkmRTrZJQlrFL2uP8x5vJkilb0A3FUmS3pxiIDCtrQRQ3FNHPumT6AT4G0smGaUpCbZViO8nsPFCOBH0+S/pGwexUEwflb7L/ktZUahvDiaaVRX3q6oACzVvIA2JMUUFZFOEotFPPkPMjf3HoMpEB3qte+e5yP7f0jTQwnwezNJKJ7K+ydtSD5vOrqMoxi+ke8zazzXGZ+9bd3fRHjbsVlAD3BD7Wlbfp8KDQEiRaeeM+ryybVWtsqs/9CqwHxrFPce8QOJh5zqePhKe2mzuA9bU/WyCqZUL2HQXEzvJBOw0NpVL9LIwtdUBdd4Z+Ug2ToVLmz2F+MrbUkrm5/MPODAGt+sE8EoCHAYAILlXMZubHRpBD6ggHsMJAldBduf3YLNBOyOsocAJEyq/VQVap+C3Dmg/iYHzdYubCiw07KqcNgTXB4Yw45Qm3zzGSUvh2vGAOdwJBdnHcMXYp3O7Xz6gBarge+I9eZsS6FIdQlu6XUfVRAxOL9HwdiiTa9ixA4Dzx2XgyO/ku95asj8Q+HLQE/DMeT689c2elBvXP/thg9AIpas013c9L/9fsGl/kd0Tr2wLtmCThICZEYqA0M4mqgQEN+uzyfG7Wq95qgvWnCpGHgwAKYYAT7S4euDJopyt9gJAKiorYzeaNMT2vdR1fOywdHnLChKcHTHO6vqiSzEyKu1PnRngpmYkYhByxlsEJRqNqv8L+4KrwODNJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(366004)(396003)(346002)(316002)(6486002)(38100700002)(86362001)(36756003)(82960400001)(31696002)(41300700001)(478600001)(6666004)(31686004)(6506007)(53546011)(54906003)(26005)(6512007)(6916009)(2616005)(4326008)(8676002)(2906002)(8936002)(66946007)(7416002)(186003)(66556008)(66476007)(83380400001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTRUSSt0dE5DSGVCKzYzWThWN2dodFNCdkVhZE9pcVMrUUdXTmVOME10S0Fq?=
 =?utf-8?B?S2ZkNG1CRi9GV1Z0Vi9lbFArRDhTTXpDZE1LRWhGZ0JDSFM4bkE5SGV4M0tC?=
 =?utf-8?B?bGhVZ1pFRXpBd21pUi90ajVLaHBQL0xvbEZ6Und2cFNBek51aXdTR0ZSRG1q?=
 =?utf-8?B?cW5YeHBvRGorZU1sOXVoT0dVSnhaaE1QaFVrNXFvcGZmT2syZ25mbHpEQy9R?=
 =?utf-8?B?dlE1ajlxTm8xUktZYU51NVBsQUFDdFFZMkZmYmFTSzRzR0RFcDE0V3dHVXVE?=
 =?utf-8?B?YSszWU05TDlWUGUrUDloU1JLSXRiWlk1ZWUzUmFESXliYWVmS1dQZjc2S2hO?=
 =?utf-8?B?YmZmYms1RzJtR01OVmJldU16b1BWeFA3Rk94Q1oxVVlWc2lPSGJneERmd29T?=
 =?utf-8?B?UU5vd0pMZTlZMzZjdWFZOVc5cFNhbjdlRnRvZDdLSkI3SEZDYXBvQ000Umtv?=
 =?utf-8?B?L2J5dmpJVk5rMkdjUTluT2twOFQ3L0hYN25GV3JDMEgrWGZOUG1MSStkcm1R?=
 =?utf-8?B?U2doUmhLOWlWNmxpWDhFNjlIRXhMMVFNVGxacHdVUVlBT2h0bDVvM3ZIV0Ro?=
 =?utf-8?B?SXpsTUQwRGYzeXZ0NzNwNm1pSDQ0dEZQK0pUOVQzd2hhT0RNYlJpK1lMVVN4?=
 =?utf-8?B?cElaUU9CbmFuSmRsUEJpS3VQM2tncXMwb3F4VTQydmFWR3NWSE1kQUNXRHd3?=
 =?utf-8?B?WDIrZ3ZoeklnemRieXdsUENDTVJaTG5WWDlWbWp2MVdtWHZQd21oL2JocjNG?=
 =?utf-8?B?ZkRpOGI3VTRwS0F4MDA3dWpxZ2JNNTlVZkJQQ2pUM1JKYi9ZbWVkQUV1Qnc3?=
 =?utf-8?B?WnJ3NUZ1ZnA1WFVkV2xjUnp3ZU9XcnpjcG8vdEVJUFkwQ25rMWdXVUd2Y0JZ?=
 =?utf-8?B?cXZtdmQ3b2JoK0RNOVBkS0R3WEpoaFAwaHB5MVV0aWhuK0ljWDM4YTJsd2VY?=
 =?utf-8?B?OVNta2o2dzk1aWZSTU5kYzhBR1RaTG8vckVtSXNPbmJ1bkJpY2VLWUVJOGNt?=
 =?utf-8?B?bkE2WFF3eVJGOHRhNVh6OGxpWjkzanVERTdoQU5pUFhaVEZjMTJZMDR3a1Qr?=
 =?utf-8?B?UUt0OTNNRjBLQndESUljRitUV3hMTTJvanFpNjBVaERaTGhHR3ZnUWhSWnJ6?=
 =?utf-8?B?VyswSWIxUHRGbHhaa3NheHR4MjNnSTVIYlBuTm50akhPMzMwdkFmTTdidFpZ?=
 =?utf-8?B?L3BLcmk3YnRLdys5cHYxT3NhQlBkdWV4ZHhpaDBxMUtZaFloQm95RnhUZ1E4?=
 =?utf-8?B?WTgrSjNKbHBDUldoZHlIV1F4MTJDUWp0ZGV4TlNTN1Fqd0hhN0FFUldSTCsx?=
 =?utf-8?B?NEVoSHVCK2kxcFQybFpmYzA3cFRlMWRjQmcrMFQrWlVFT0llQ1cwbjRDcmRn?=
 =?utf-8?B?TkZVd2xLZW5sU1FZTzRUaHJQQyt6STZlM3hhQXIxbmQrTmlXSlIwQ2Uxd3F5?=
 =?utf-8?B?dE1rMVF0SEF6a2RPNmg0eGc5eVVjWXFiUzh3QXdjQVhtMTlLS0JWQUJlRmpZ?=
 =?utf-8?B?V2QxMFIyUE1uVXlHcnpGdldFUHlQSDFsK0gwTW1JemFMVHZvL01WRm9Fekkr?=
 =?utf-8?B?Y3VFWlJzcEtzbTNHQ2ZDUWZRS25kWVp0RUdMYmJabnlMUkcwVlF4RFZ4djNj?=
 =?utf-8?B?L3k3cmoraTBvRDREbjl1MlRQSVdLM3JRMGl0OGF4dVRhcjFyVXd3dVZuT3Ny?=
 =?utf-8?B?UC9LdUNEUnlhTjdBd1BtNDNCQmtBTnZZU21BMHhieUE5UDBFSlBZeUtsLzdv?=
 =?utf-8?B?ZS9qaVV3UVB1VWhVeTlBVjhjNi9GekN0a1BHekJORzZNNk5haTNibFBMbnJr?=
 =?utf-8?B?bWtoVWdmR1JheTZ0SERLK01GRENuWHRIem43UFRYRWFkbS9USks3TjFFYlJL?=
 =?utf-8?B?eWdzb1VZd2doOG1RNExQalM2ZWFqUjFYRzZzdTd5NlNHR2hmTGE4T3Bzd1Jp?=
 =?utf-8?B?LzlQV2RSVW9Ebm5qUVhRaS9FbjM0TEVUeUhMMEtjdW52UGtqdE9DYWhjZ0VI?=
 =?utf-8?B?eXptUFdXS2IxVkpHbnlCNFNKVDNXM0VObzljeG42Z21ZaXFjeGJxN0gvSXY1?=
 =?utf-8?B?N2Z0Q0FtdEFvQ1V6YmYxbHo2LzFrLzBzT1ZvM2NZR1ZqeEg4a1g2TGsvMzF4?=
 =?utf-8?B?Unh6eE9nODZ5Q0VtTkJnVTBiK00vNExUazVHUHpHdFBlc3puRjd0dEg4c0Zh?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d806bf2-9ad1-44fd-5bc5-08da70657645
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 06:50:30.8986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yP2OU3Ma9COZwVqYSeenpVTx/uKTlJcCHv0oEkAhA7xxudeWlC5fUh34UGDWwgaAs1yEZRVudojxTM8m8E9G+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1907
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/27/2022 5:59 PM, Alexandru Elisei wrote:
> Hi,
> 
> On Wed, Jun 08, 2022 at 09:16:56AM +0800, Huang, Shaoqin wrote:
>>
>> On 6/1/2022 12:45 AM, Will Deacon wrote:
>>> On Fri, May 20, 2022 at 05:03:29PM +0100, Alexandru Elisei wrote:
>>>> On Thu, May 19, 2022 at 02:41:08PM +0100, Will Deacon wrote:
>>>>> Now that EL2 is able to manage guest stage-2 page-tables, avoid
>>>>> allocating a separate MMU structure in the host and instead introduce a
>>>>> new fault handler which responds to guest stage-2 faults by sharing
>>>>> GUP-pinned pages with the guest via a hypercall. These pages are
>>>>> recovered (and unpinned) on guest teardown via the page reclaim
>>>>> hypercall.
>>>>>
>>>>> Signed-off-by: Will Deacon <will@kernel.org>
>>>>> ---
>>>> [..]
>>>>> +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>> +			  unsigned long hva)
>>>>> +{
>>>>> +	struct kvm_hyp_memcache *hyp_memcache = &vcpu->arch.pkvm_memcache;
>>>>> +	struct mm_struct *mm = current->mm;
>>>>> +	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
>>>>> +	struct kvm_pinned_page *ppage;
>>>>> +	struct kvm *kvm = vcpu->kvm;
>>>>> +	struct page *page;
>>>>> +	u64 pfn;
>>>>> +	int ret;
>>>>> +
>>>>> +	ret = topup_hyp_memcache(hyp_memcache, kvm_mmu_cache_min_pages(kvm));
>>>>> +	if (ret)
>>>>> +		return -ENOMEM;
>>>>> +
>>>>> +	ppage = kmalloc(sizeof(*ppage), GFP_KERNEL_ACCOUNT);
>>>>> +	if (!ppage)
>>>>> +		return -ENOMEM;
>>>>> +
>>>>> +	ret = account_locked_vm(mm, 1, true);
>>>>> +	if (ret)
>>>>> +		goto free_ppage;
>>>>> +
>>>>> +	mmap_read_lock(mm);
>>>>> +	ret = pin_user_pages(hva, 1, flags, &page, NULL);
>>>>
>>>> When I implemented memory pinning via GUP for the KVM SPE series, I
>>>> discovered that the pages were regularly unmapped at stage 2 because of
>>>> automatic numa balancing, as change_prot_numa() ends up calling
>>>> mmu_notifier_invalidate_range_start().
>>>>
>>>> I was curious how you managed to avoid that, I don't know my way around
>>>> pKVM and can't seem to find where that's implemented.
>>>
>>> With this series, we don't take any notice of the MMU notifiers at EL2
>>> so the stage-2 remains intact. The GUP pin will prevent the page from
>>> being migrated as the rmap walker won't be able to drop the mapcount.
>>>
>>> It's functional, but we'd definitely like to do better in the long term.
>>> The fd-based approach that I mentioned in the cover letter gets us some of
>>> the way there for protected guests ("private memory"), but non-protected
>>> guests running under pKVM are proving to be pretty challenging (we need to
>>> deal with things like sharing the zero page...).
>>>
>>> Will
>>
>> My understanding is that with the pin_user_pages, the page that used by
>> guests (both protected and non-protected) will stay for a long time, and the
>> page will not be swapped or migrated. So no need to care about the MMU
>> notifiers. Is it right?
> 
> There are two things here.
> 
> First, pinning a page means making the data persistent in memory. From
> Documentation/core-api/pin_user_pages.rst:
> 
> "FOLL_PIN is a *replacement* for FOLL_GET, and is for short term pins on
> pages whose data *will* get accessed. As such, FOLL_PIN is a "more severe"
> form of pinning. And finally, FOLL_LONGTERM is an even more restrictive
> case that has FOLL_PIN as a prerequisite: this is for pages that will be
> pinned longterm, and whose data will be accessed."
> 
> It does not mean that the translation table entry for the page is not
> modified for as long as the pin exists. In the example I gave, automatic
> NUMA balancing changes the protection of translation table entries to
> PAGE_NONE, which will invoke the MMU notifers to unmap the corresponding
> stage 2 entries, regardless of the fact that the pinned pages will not get
> migrated the next time they are accessed.
> 
> There are other mechanisms in the kernel that do that, for example
> split_huge_pmd(), which must always succeed, even if the THP is pinned (it
> transfers the refcounts among the pages): "Note that split_huge_pmd()
> doesn't have any limitations on refcounting: pmd can be split at any point
> and never fails" (Documentation/vm/transhuge.rst, also see
> __split_huge_pmd() from mm/huge_memory.c).
> 
> KSM also does that: it invokes the invalidate_range_start MMU notifier
> before backing out of the merge because of the refcount (see mm/ksm.c::
> try_to_merge_one_page -> write_protect_page).
> 
> This brings me to my second point: one might rightfully ask themselves (I
> did!), why not invoke the MMU notifiers *after* checking that the page is
> not pinned? It turns out that that is not reliable, because the refcount is
> increased by GUP with the page lock held (which is a spinlock), but by
> their design the invalidate_range_start MMU notifiers must be called from
> interruptible + preemptible context. The only way to avoid races would be
> to call the MMU notifier while holding the page table lock, which is
> impossible.
> 
> Hope my explanation has been adequate.
> 
> Thanks,
> Alex

Thanks for your clear explanation.
