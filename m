Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D74743283
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 04:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbjF3CHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 22:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjF3CGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 22:06:45 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986914223;
        Thu, 29 Jun 2023 19:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688090775; x=1719626775;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wu4ku1EzjNTAIDTAB9s0KvvIo8HWgmFvDxfa3IC3c58=;
  b=HZ5kv/slUw8VDvhlFA4JQWVVM5fEC+CUrjt6ynB4tr6wTqvZuD1EzPeK
   rHUkcwGYvghI5DjNWStL5wwzurGNGn8DLnTXH5vGO3ex4pv22oSMDvEmo
   /F+uO2SB1qWoMCna2h4IBkJrTC0z0ee5XjZjaqDSwha6OhopQEsox7/DL
   s8Nsnq+L/SRYwDGGFHxVTragg/bnNWwjzujpEeBIiNQpg6KMantwFkBKm
   +rzcFzcDlFezRx5AXRlzm3W2oF5KJkQbyvWNtRG18B3CYVJQJvAYy/0kP
   k62UJEYn6zn5L8n6xFQ+l5qAbEAfEKKOw8tIz4ejXqxGH0JbzfJ4Q/gR5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="352109239"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="352109239"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 19:06:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="782911320"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="782911320"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jun 2023 19:06:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 19:06:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 19:06:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 19:06:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZctTsjoPw/hPHXWeHM/3AZvmea4ddrUYfESFk0vHq4ApC18LNgbqwRk489ntJaoHfPOr1SLgb5p1YvGF8oLbtfN5OXl8rOXWUwQ9YlCfLPhkYawHfWnMY9wP2CzTwAds0lPmCc7R0z89bS/fw3BiX7tf6DT0g8yCx5oZeGESbKbPzNlPzsgujopzSrsNxYhh/E4IiFnnhRqeQ6HmVk6QtFYglKcy7c6oZEjqiXTY2h296Mm5gRl2kj+NXzgdOtYFaBEyIEvJqdLP6a3GYk4LKPtSss+r44/qHMSjg2qWWbpRIzg5wySBKj8YCH20AUpZpe8VAdQVY5aat6t/VgmPaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgzMh/cLCBHcaN8Er1zwjNezl2UO296D9YLpW8KHCJ8=;
 b=Qp5sM9hIQIp7fSX53svxLu5emiW+fmu2I7/rjq+FwS1N98RLh8vs/m5TyGwHeWQleI16xQMVQXUTORXInn8JNCeUut9D9rYrRj9w7XRIIhuRfgKnaQAmKiIKYdrfReWrSSljijGU1N4M0/aJzmkDd1dXxie/71/Jwmh6X7l/kxjFjED7u7/zDU72D2xNcNMentVT51S69ATdMAwcmxp37Y0aVa1gXDArNvT9gvvsUQVqqjD4iM+6dmNQqbc3wEHIZfQKrHiINMO580W/aeBve7cuKDgLC0DqN5ezaVYyP0n/CnhFnt45AV0/iWLKOekdti06iOa6UeinsG0h/H2rTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA2PR11MB4841.namprd11.prod.outlook.com (2603:10b6:806:113::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 02:05:59 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6544.012; Fri, 30 Jun 2023
 02:05:59 +0000
Message-ID: <77c97dd7-a692-4881-e87c-373ad1bfa044@intel.com>
Date:   Fri, 30 Jun 2023 10:05:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 4/4] KVM: selftests: Add test case for guest and host LBR
 preemption
To:     "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-5-xiong.y.zhang@intel.com>
 <b4dac7d8-06d7-6d16-117d-5953cd37c34f@intel.com>
 <MW4PR11MB5824984347876F9D3DCB710FBB25A@MW4PR11MB5824.namprd11.prod.outlook.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <MW4PR11MB5824984347876F9D3DCB710FBB25A@MW4PR11MB5824.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0032.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA2PR11MB4841:EE_
X-MS-Office365-Filtering-Correlation-Id: 9af9a13f-5539-4b55-399f-08db790e8c47
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jBAb0stlRJJ2riROCgzxOF1z5TKiL9lNxTTZ8wGSA9LGmXW0fc4HbvMExpecFsyi3mEWQC4jvoRzMh8WQbX0dYZpBhCgI7u4ag6jO9ibNgtBCHnes/aHs9b7sefBKnZftePLoPHWPSpYgPP8oDfxObz3s+TkhR7Qxhq7Mx14AGOq/zSzuNOew82d/JlykLGjlvlv/q9kk1JkE0tWmM/8PFx9XAOLTvRkDS1TMEBIFvSuRIuqjssxiCZtk41fMdqEL7KsMb9t1W4oOFlhzCTcc8XESVIUcsErmfvpb4RJSmoCMD+cQ9Zpogdl+EtHOqVepNgRFw0w6c6iWLHTYqYxxn+jMDo1Tm5k/3VABf3l7xcCuYREVlSl9Vdma3QxkFd4VpCzlutxDjViZZwA6gJw4YW4nek4DZ/O6bOw2rWzbyaGWtQTCuiQkVV3C9iU1Crhm6lGEohMNpnq4DZMpNkNWjDBRiYKOVIssc9T+Msn6t2jFZhnNtugicXLihvbEwTNq468yhF7JPMWS/Mt19TGrUY8IIHbst1uGFijHEiu7YoC4/s6+WkcWGSMRRxVIq239FzvZo+fGeieHqP2tR4ZxiZdp+wGjWuEz/sXmnfqiqhjYmXTSsF4tcYauZyfNXLWq2UoyiN9EdRljfPkVzs3dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199021)(6486002)(478600001)(6666004)(6512007)(186003)(26005)(53546011)(6506007)(2616005)(83380400001)(36756003)(82960400001)(38100700002)(86362001)(31696002)(6636002)(4326008)(66946007)(66556008)(66476007)(2906002)(316002)(5660300002)(8936002)(8676002)(31686004)(41300700001)(6862004)(37006003)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3RvaVd2STBLQTMvVXRRdFJaclJ5dUpJMzg3cDV6VkRvZ1pIaUlUQUJIVG9C?=
 =?utf-8?B?WXVPZ3FaSzZCVHlCQWF6aERrSEFleFd4eVJuNTN4Q0o3VVNiamdIcXhXb0da?=
 =?utf-8?B?Y1M1Q2p0elFWOU5FNStXQ1VwSmFnc2EvdFlObjB6cVdpaDAwY1k4Vm9tRmVw?=
 =?utf-8?B?ajY2UzJPcGxqRkJ0RWN3QVd3cEdGSGNndmw5SHpVOFRXNEZsNGo1UWMzRFlu?=
 =?utf-8?B?bzNCdmNYbVo3NEs2dENSbFpvRFUrc2xoWDZSVDArUDgwSjVpZHVCYmkyS1lW?=
 =?utf-8?B?MzFhekp3YkUvNXFDTVlsMlNKTVZHT1Ntd3FLU2xVWWRYMVdmMHJYWUIvNFVT?=
 =?utf-8?B?WGovMGZ0dzNaUEhaQlRwVVZhclA4bmI4dTk3azBpWmZBb013U01GdUozMHMz?=
 =?utf-8?B?a2twL1JNTEs2clpEQ0JVbE8xbldlck4yNUF2a1B1VkJIRG5lM3BwaWluL2pL?=
 =?utf-8?B?V3FyVjYvTkFBSkh1TTQydGhuTnhPSjhORVVLWkZCSzZDSzJRV2Jib2c5VkNh?=
 =?utf-8?B?K01XL1c4bmFRSDJ6RjZac0ZFejFUZWRzUlUvaXpmdmRWejlmU0VFV3dtUDRR?=
 =?utf-8?B?QU1yUERUcEFBVzVSV1NmTE1WT3BaRjAwM05WSWpHS2JPV1BkR2hQbHhaQ2pB?=
 =?utf-8?B?L0ZINlF1NTdSMHNmNWkxWC9IQ2JhTVJnSkFhVUNUeGVBQ1pIY0tJdlN1czNx?=
 =?utf-8?B?M3RrKzFaUHloLzJ6eWNoellOL3VRVHY1SnpDSUN5bmhvZ1JaNEpxZk03MmRG?=
 =?utf-8?B?ak5zdFBDL0N5SXNIR0xqOVowcmd0MDVoa0loM215NDRtcmdjYWVPcnAxZXZt?=
 =?utf-8?B?VGx3Z0pteUt4ckV4Uzh0N000TXNPNC91ekY4dCtvZy9TZG5zK1hGbks2R3dw?=
 =?utf-8?B?SENXdmkxYURRaFp4eUVVMFJuazdqNjFVOU1lWU9RbGs2aXZZMEthNStTekJ4?=
 =?utf-8?B?NWM4RHEwa0dXdFF6TW9Ta0tDei9GcmJKLzRhYzR3aUdOZXBtU0JoQnJ3OGIr?=
 =?utf-8?B?N2Rvdk5VQU5jeWR2c1JrdzB2MmRFcXEzRFpGMUphZEt3bmRNb0djbFNRVFI2?=
 =?utf-8?B?T2ZZTWNlQ3hSNDkvVllPMWVaL3dQcjljUVdpM1hTbExKYU5hWC9HMXdwZkxs?=
 =?utf-8?B?UzdVaVYyNjJQM1VBUEV5L2pyWDZnK0VaSFhjakNOVHA1a0ZmRVdsK0JCSTV2?=
 =?utf-8?B?eDRtSUxJVTRZRS9TcWswQzdNYjBhanhuSGZkM1ZydXNiQmMvdGY0MytaSU92?=
 =?utf-8?B?Y1dYbExSQmRod1pwRWVDUmlZTkhCajJwS1dpSTE4WmR0SnFuSWlnNU02MERH?=
 =?utf-8?B?SStlUnF6SGY3Y2NtV3BaR2J0MEhiWm03WVhxemtSektCNUNtdUhZdVlUSWNi?=
 =?utf-8?B?eUJqRWg5R045ay82SzNsVklXV0l3NWhCdlVFVThrcEQxVGgralNJQi9MSEgy?=
 =?utf-8?B?bkxTT1VpaEwraHNXM1ZYNG9hZG94d2c0UW05UE9NR2FSZGVPZGNnd1dYeGpP?=
 =?utf-8?B?NnY2ZVhmR2xNbVJXUkV1V2V5aGtSeWphRTEzRXQwUUF2alJqUW9ZbXp2UCtv?=
 =?utf-8?B?U0VJdHQ3L3pFTnN0YkZUMUZqRTFNVDkwL2h3Um9ZT21JdCs3SFVSRGZBK2hK?=
 =?utf-8?B?cW9RNWM5cmw5VDVWa0NhUGRlVy9jWDlObytiSCtIcXFyQzREL0JMczN4dWZp?=
 =?utf-8?B?NldZUkpaN0tXZGlEcy93TklNdXZXVWFPY1dXVWFYN2Z1MWx5Y1dlandxWGhN?=
 =?utf-8?B?azRuWVFDZlphTW5xSnF0ejEvWHRPODJ6VnRIMDQreUNwUVRhcFZzLzhUdWlT?=
 =?utf-8?B?bEozSkx4eEk2d2xFODBBZExiZzFxb2NBaTBvb0tGUEpIZzB1YUpFZU9VbmFz?=
 =?utf-8?B?Z3M0YnhYSzdYa0tFTjk1U1UwdkJZWGtNbmFGaElJS1BLcEd5UjQwek0xTG8y?=
 =?utf-8?B?MUs5eVM2d3ZNbUtDNTQ1Q01IalNmTDNwQnB6Z0pnYm5zaWs5RmVYaEN3MGxR?=
 =?utf-8?B?NGxlRnlSeDYvVmFDL3IxeVV1TGgxa3EybGNkb3p3MWdiNWFzVEJpZmRDRzRZ?=
 =?utf-8?B?TnhBSTJ6RDVvOUg4WlF4OVoxM0JkQzhOay9xbUYyTmtyUDIxekI5VVUrNzcx?=
 =?utf-8?B?WjY2UjBzeEhpMEJaNmFNcU5kRHE3cElQQ05mQnY0N1pCSFlaYzhMdFRUNjhk?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af9a13f-5539-4b55-399f-08db790e8c47
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 02:05:59.6084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrV0ZCIjT4W90Wg+QNrdoQ6+Sd5SWdgxAvLC8rzBYIq56xIdNv7oH1DjSbQ3hMgS3u084ZcKB8ykhjxxDGiYeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4841
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/29/2023 10:52 AM, Zhang, Xiong Y wrote:
>> What kind of issues you expect this selftest to find?
>>
>> IMO, it verifies the generic perf schedule rules but cannot find specific issues.
> Current vLBR event break the generic perf schedule rule. So I write the fix commits and selftest to avoid future broken again.

OK, I think you need to refine the assert failure messages and give the 
users  straightforward messages showing something

wrong is happening and stop the following tests since something is 
broken, no need to trigger more errors. E.g.,

+	TEST_ASSERT(r == LBR_MSR_WRITE_ERROR,
+		    "1. Unexpected successfully read/write guest LBR_TO msr");


"1. Unexpected successfully read/write guest LBR_TO msr"
=> "Host LBR ON: Detected unexpected results when write guest vLBR MSRs. Stop testing."

Then at the end of tests, you can print a successful message showing the perf/LBR is working as
expected. This way, testers can got clear result indication of the app.

>> e.g., whether the LBR data is corrupted in some cases. If the selftest can verify
>> whether
>>
>> guest/host data is maintained correctly in a high contention env., that can be
>> better to
>>
>> sever the purpose of selftest.
> Once vLBR event is preempted, I see designing gap and guest should get wrong data, it is out of this commits scope to fix the gap and to verify the result.
> I should add this into commit message.

Yes, refine the change log of this patch to tell clear purpose of this 
app so that users know why this app is needed.

>
> thanks
>>
>> On 6/16/2023 7:33 PM, Xiong Zhang wrote:
>>> When guest access LBR msr at the first time, kvm will create a vLBR
>>> event, vLBR event joins perf scheduler and occupy physical LBR for guest usage.
>>> Once vLBR event is active and own LBR, guest could access LBR msr.
>>>
>>> But vLBR event is per process pinned event, perf has higher priority event:
>>> per cpu pinned LBR event, perf has lower priority events also: per cpu
>>> LBR event and per process LBR event.
>>> So if host doesn't have higher priority per cpu pinned LBR event, vLBR
>>> event could occupy physical LBR always. But once per cpu pinned LBR
>>> event is active, vLBR event couldn't be active anymore, then guest
>>> couldn't access LBR msr.
>>>
>>> This commit adds test case to cover guest and host lbr contend.
>>>
>>> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
>>> ---
>>>    tools/testing/selftests/kvm/Makefile          |   1 +
>>>    .../selftests/kvm/include/ucall_common.h      |  17 ++
[...]
