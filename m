Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CE673DB5B
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 11:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjFZJ1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 05:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjFZJ1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 05:27:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A269210D3;
        Mon, 26 Jun 2023 02:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687771501; x=1719307501;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZEFgj2GT9SvuTt4f2CCvAnnbwnAbRBIS9T+c0jd08YI=;
  b=Mqc6LLSS+IHf58oCXfWIyUg5rdMRst56k9pek25cjOP9g1Jwtv18YyGa
   ai0hYjt2bLOJk4Io94cURj5QYo3JgBr3zIe2P8w62dkHQP3StjIi9C8OB
   PcHYhm2nmno8izG4XtkkOTvG729RTEB69JHpxAEIYmmPht3mAVJ74fti3
   Wl2wkjVNUzMziCn760nAARhuXCH/Y7T8ZHWreZm2BvgC5KMY8VYDA61t4
   G4TQxhO3SZALJw54aBNrCWVCTapZd04e9uaFQRJOddpLXSe6rUhfFB7BS
   5g2SJDBvla/HqmxosMLdQDKCP0RkMo1YdMj+xNnQq/w8MOFpMYQs8x9hb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="361265504"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="361265504"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 02:24:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="786086799"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="786086799"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jun 2023 02:24:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 02:24:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 02:24:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 02:24:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2ER5adJHjD5E2rP5uht7CpeNPXcJ9MyryKw6BwR4s10PEdDq/i2k4Jj5LUW9aQOW/nZFfOVUxYKdejrBPYrwaMf4BQjIXSHZXWkWJL07rlih4ylGH4nHjs3C1bmyaFeDeWq0OJjLe/5fac2WKuPBdzYGdwS046KandLDiGyzuTWk9XcLVWDF3hufkb8VO7gaDg2YpWZF+HClWIP7BcjbfryTlufITuiqBY0JYpDKLHQ3kU/8GXva5EG+ZkOiEsK0dUNUNbm+FBrE8v3LCI6qoKJ7JmQm+ES7UO/7VsW2VPmFUgFnXp+FjSn5O1D4tDexFfkmsIdVoA4DNQ/B8z2Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WpBIX8FEo+4uQg0Ns0y6+J6XiAwSKHjiZC2RuUfc4MY=;
 b=jcfOumMiLq6TqTRR/YFC1WpkN8WK64wd8ST00yUTypVRKO+Vy3hWLrrVf2npFGOO+EyhC1SW0qbxiQJtkJJOAnvVyprvodgLVLw1sB1Cxp5jU+4DDSJOd4xdg76EgOhUIm5Kf6vo6Ol++E8+ZROeaNGbY2+kL76GOc5x3mUutu/LJhook80H/FOOaAX7ix80LNEJK7MWU+SoFyHhpkQxhElJH9PIgyiZd7pvgvJt8PUMtInUCnmw27VumLrJCusR756u/EyacUsjUKKzKwK/jQzoz0TxLVs73mE5Ygjy450TNufXw/fZaLgKaP+4vUmS0QrouoTATOp2AdX+XYulTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB7720.namprd11.prod.outlook.com (2603:10b6:510:2b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 09:24:47 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Mon, 26 Jun 2023
 09:24:47 +0000
Message-ID: <c44811f3-e158-32e4-98d0-a0833e44e2bf@intel.com>
Date:   Mon, 26 Jun 2023 17:24:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 07/21] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-8-weijiang.yang@intel.com> <ZG77wu4PyBn1z587@chao-email>
 <23169e5f-9793-9486-fd5f-287e3317b837@intel.com>
 <ZHXnP5bEvxPrDg3m@chao-email>
 <6e1e9de9-8def-46c3-a238-c1b4ef52e331@intel.com>
 <ZIuitcH7P1JpkzFH@google.com>
 <f2708ad5-494c-c91e-cf5a-09f6e2d81e15@intel.com>
 <ZJYo6aDtt0DQ5Tjv@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJYo6aDtt0DQ5Tjv@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB7720:EE_
X-MS-Office365-Filtering-Correlation-Id: dbf978b5-9444-4760-ace2-08db76272ed3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j1sfVFrZFUBl2NQjp/Kpm+Xjn4xb/gTO0tG0QK87FS+c3qYWRH/PvS/5gMwnFFhc0fi+48lqD5KDQFwWLFvpPhYX1gGm1JIgHG89rIMth1Zfs0z42LGx3BsFowBnnhRc/R4ORHgt8UjApxDIPjKqxUN8JKYytXBIAbJaFICOxAbm1eX2PbpJKecqyBSbZkrp71IZC9gyfMs2RzSXMlvpPg/hDs5pkqi1Avzvaxpb93AIOd8XvA4VvLlWaLQD37h/FgmPbdx03EXJ/lGa+i60CJsAAwD8x+DMasg1pcpqn8d1b1JuJltIxUEAdcmzlpDz591VOCpaso/AjR7YjYITlDzHoiFcguMrBaQesqeowm+n6s+EyXdK7IMBoVcADQH+ArxQ+zJLvcmQKRf5HyS9hw2Fh+4AqVwh6Y3bJemXCMmu00r+ESzb7byey+5Ay3wQqFvTNI04sPlctwJV0dkFL3Odyzj7tfufvN46oXfdyDw/IGgOSGILP/7g1XKDnrAErsBSErKsk+pvdy+iHeM5gqMAfFmMdM8doDfQfpDsaMH0Ry9769GHN8DgHxO6khnVzdVSpDfhp9O0eU6SRLWt1nYZ+xadASNZMI2X7C7pYR9WfxeZTSJ4KJsXdpTH0h1Mk16qzMi2XhOznW+dtnuOIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199021)(2906002)(6486002)(6666004)(38100700002)(83380400001)(2616005)(82960400001)(6512007)(26005)(53546011)(186003)(966005)(41300700001)(54906003)(86362001)(31696002)(478600001)(36756003)(66476007)(66556008)(4326008)(66946007)(6916009)(316002)(31686004)(6506007)(5660300002)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clkxRjMvSkJ6SndMalEwRDIwK2NYUmRKOEk4cWpjRHBTYmxBZ0NDM3A1amlI?=
 =?utf-8?B?dEJSeGZuQUx4dCtzYTQrQnV0ZUM4OW1MNEJ2bVBBemw3SWZRZk45MUlQNllq?=
 =?utf-8?B?SlR6THY2amdLYlhCcWs1dEpnTmEvbVRLRCtaN0s0c05NMXlQQXU0TEtiMS81?=
 =?utf-8?B?Qm5qRTBCdG1IZXV1VzBMTEQweTFOQkVQVCtzbUxBMXk3bVFwcWRjWWg3dC9y?=
 =?utf-8?B?UU5TTGZOWDM3L2JRTFQ1enoxelVENkt4SjJLTmdEdlhYNXlmYURrQ2xBL3lC?=
 =?utf-8?B?dTA5TzRhb1JjMHhDZkJLNzFPOE5aMUViYWhTeTVLeitkRTR3NnQzTm5hN05m?=
 =?utf-8?B?Rm43MXhvcDNYSHc3V3ZDMThkZVdMMGRaSXVrNmVhRlNBOEZPMVZTUEZQS2N0?=
 =?utf-8?B?cTlkay9Wd0hXejFxR0RtbVF0cTBrL0ZZNjZZQlJWRlJKVWxFY3JNcUJ4Skg0?=
 =?utf-8?B?WCtnWjVFUk5rR1BpQXVqaDc5elhXTzVwVXVtVEV3TG51K3hOeU5QYTErWEZy?=
 =?utf-8?B?YUxuREUzRi8zUG82dEovcVZ6OUJPM0kyWDJsZHo4K1M2YkJmeEJ3QlVPOWhB?=
 =?utf-8?B?RDN2U1hoQS9VbjlPSnZJNkZhcFpCU204eUlSSTB0emMraTdPWml4ei93alFj?=
 =?utf-8?B?MXF5cUI5SE0yMXltLzlublh0azRkb21FZWdic2FJY0JJVEJPVURQdE90TDZz?=
 =?utf-8?B?Vmxia2J2UTRLMDk0WTBrSDhpWmM4VENIRmpMNDJ6cWl3SVh4TUdCWXdScXdy?=
 =?utf-8?B?d01vejY2d1VoR20yeVNHSU9RYml2bHZjOG00eVY4UUQrYktSeEpjdlJTV3Fq?=
 =?utf-8?B?OHQrMXl6cmlJVUFWSkN4bnlRZmZOWDZONUJ1OW5HVlpmYlNYYnRxQlVjZjBs?=
 =?utf-8?B?VmVFUzBMdHMwd3I2cWY1a3pINEgvVXMveE5HOW0waHpnRm9qK1NnVDBnbE9B?=
 =?utf-8?B?azRuSDlHMVBTc21qbzczc1gramtyRmtQM1MreU5GVmJ6N0dRTlZwUUZCd2tS?=
 =?utf-8?B?Zk9TQUQxOC9zRkdJbjlWaFZub0dtSi9XMCthVER0M0V2N29tY2ZZK0VJbVQx?=
 =?utf-8?B?aTcxa25HYTZJRllSdzMvYlUycERLd0hQd095SE1KMzQvWnVEajQyMDRpTFNk?=
 =?utf-8?B?Qlo4SWhyenUrRnptSXVsOHNXaFJRbmtrODBBQW5sTUp1SFo1U0UvTWZqdWJh?=
 =?utf-8?B?VEpiN3I4bi84ZlFUZUVHN2pIalYxTE5YN2x6RHlzK0t2K1pHdVZlaTRnc0o0?=
 =?utf-8?B?S2V2OEFWSTJKeTBYNldSL0ljcVZCU0p0Mi9udTYveWd0V1hvNXRSWXFrMTZk?=
 =?utf-8?B?SGtYeXB1WXBsSjBGQWk4bFRNN1M1OHVLTEY2Yk9uT1RvRFFwQm5rTmd0cWU3?=
 =?utf-8?B?RnN1R0JyQ0tma2tVdkdEK0NsSXJDYmtBYnAyVWhNdnBYSXhxZVcxdFNkcmRO?=
 =?utf-8?B?SVY2b0RRSStaTzNtamVUblpTS0lFWDlCQWJzV0RaWlF4Z1dJUWxiN0NFMWJY?=
 =?utf-8?B?a29oNmxTblMrOHRaaWtyaHVIREZvbFp0d3RtSnkreXlrTVo0Y0hRRnFkOENQ?=
 =?utf-8?B?UkV3Q3ZMdkhUclludHRVVCs0dXQ0RnpGckxDUG1vWTF3VFpRc0lobktyckpy?=
 =?utf-8?B?NkdWT0pwTEpLQnQ3c1ZncDdrL3k3U1FJaUpoM1ZpK0xRRVA3L2R3RjlyT2dj?=
 =?utf-8?B?Z0lvMXF3N1dkVXI0eSt4MUg3V2lQYUY4cDFWL0NneFJNZUtwdUVwVTl3Y2Q0?=
 =?utf-8?B?SVUrMzk2TnlKSy9iaFMxYXB2Q2xTS1oyNWF6Y0dtSWZtMTJiZm5SZXBWeG1o?=
 =?utf-8?B?TGhOL2k5cmRJbElkMXhjekdJOGRiQ2pOeXY2QWlCbmcwNjFYRHEyZXpwdWo2?=
 =?utf-8?B?STEzeFNub2NaMWc0WVlMNDJmck10TDhXSUo1QklMZGYyd1JNb2cySVZTQWNY?=
 =?utf-8?B?SCs5V00xcStXTk9xZDlDMnBqbU9uVlFCcHdINjR0WG91L0wyMEZIMFdrd3c3?=
 =?utf-8?B?YWRBOFJjRXE0WXdRSDBPU1FtWUpwWGVUbmh6dmp3WTFxZjlwMUpKY0xKMnQ1?=
 =?utf-8?B?UTlPR005bm5pYnRKeVpTc2Q2TTkyT0dsSXI5ZFZKSDVFb0FTTElSWS85Skp0?=
 =?utf-8?B?UmtZd3RRdTIya2Z5VkdIQnZ6cnR5N0h2L1pIbzMyK0JxOFM0Z3Z0MjdnZjVU?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf978b5-9444-4760-ace2-08db76272ed3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 09:24:46.9553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVJSHyOJpVxzQZmlj0FIjGUQBQGbrDB3WKYy6KvURzp+cNyNRbFrYza+Det3ey/MCYiMfsQuD5hfTgng01D82g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7720
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/24/2023 7:21 AM, Sean Christopherson wrote:
> On Fri, Jun 16, 2023, Weijiang Yang wrote:
>> On 6/16/2023 7:45 AM, Sean Christopherson wrote:
>>> On Wed, May 31, 2023, Weijiang Yang wrote:
>>>> On 5/30/2023 8:08 PM, Chao Gao wrote:
>>>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>>>> @@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>>>>>> 		 */
>>>>>>>> 		if (data & ~kvm_caps.supported_xss)
>>>>>>> Shouldn't we check against the supported value of _this_ guest? similar to
>>>>>>> guest_supported_xcr0.
>>>>>> I don't think it requires an extra variable to serve per guest purpose.
>>>>>>
>>>>>> For guest XSS settings, now we don't add extra constraints like XCR0, thus
>>>>> QEMU can impose constraints by configuring guest CPUID.0xd.1 to indicate
>>>>> certain supervisor state components cannot be managed by XSAVES, even
>>>>> though KVM supports them. IOW, guests may differ in the supported values
>>>>> for the IA32_XSS MSR.
>>>> OK, will change this part to align with xcr0 settings. Thanks!
>>> Please write KVM-Unit-Tests to verify KVM correctly handles the various MSRs related
>>> to CET, e.g. a test_cet_msrs() subtest in msr.c would do nicely.  Hmm, though testing
>>> the combinations of CPUID bits will require multiple x86/unittests.cfg entries.
>>> Might be time to split up msr.c into a library and then multiple tests.
>> Since there's already a CET specific unit test app, do you mind adding all
>> CET related stuffs to the app to make it inclusive? e.g.,ï¿½validate constraints
>> between CET CPUIDs vs. CET/XSS MSRs?
> Hmm, that will get a bit kludgy since the MSR testcases will want to toggle IBT
> and SHSTK on and off.
>
> Actually, I take back my suggestion to add a KUT test.  Except for a few special
> cases, e.g. 32-bit support, selftests is a better framework for testing MSRs than
> KUT, as it's relatively easy to create a custom vCPU model in selftests, whereas
> in KUT it requires handcoding an entry in unittests.cfg, and having corresponding
> code in the test itself.
>
> The biggest gap in selftests was the lack of decent reporting in guest code, but
> Aaron is working on closing that gap[*].
>
> I'm thinking something like this as a framework.
>
> 	struct msr_data {
> 		const uint32_t idx;
> 		const char *name;
> 		const struct kvm_x86_cpu_feature feature1;
> 		const struct kvm_x86_cpu_feature feature2;
> 		const uint32_t nr_values;
> 		const uint64_t *values;
> 	};
>
> 	#define TEST_MSR2(msr, f1, f2) { .idx = msr, .name = #msr, .feature1 = f1, .feature2 = f2, .nr_values = ARRAY_SIZE(msr_VALUES), .values = msr_VALUES }
> 	#define TEST_MSR(msr, f) TEST_MSR2(msr, f, <a dummy value?>)
> 	#define TEST_MSR0(msr) TEST_MSR(msr, <a dummy value?>)
>
> With CET usage looking like
>
> 	static const uint64_t MSR_IA32_S_CET_VALUES[] = {
> 		<super interesting values>
> 	};
>
> 	TEST_MSR2(MSR_IA32_S_CET, X86_FEATURE_IBT, X86_FEATURE_SHSTK);
>
> Then the test could iterate over each entry and test the various combinations of
> features being enabled (if supported by KVM).  And it could also test ioctls(),
> which are all but impossible to test in KUT, e.g. verify that supported MSRs are
> reported in KVM_GET_MSR_INDEX_LIST, verify that userspace can read/write MSRs
> regardless of guest CPUID, etc.  Ooh, and we can even test MSR filtering.
>
> I don't know that we'd want to cram all of those things in a single test, but we
> can worry about that later as it shouldn't be difficult to put the framework and
> MSR definitions in common code.

OK, I'll add a new selftest app which initially only includes CET MSRs 
testing but practice

the above ideas.

>
> [*] https://lore.kernel.org/all/20230607224520.4164598-1-aaronlewis@google.com
