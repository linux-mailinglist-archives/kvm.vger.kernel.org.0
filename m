Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87D963B573
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 00:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiK1XAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 18:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiK1XAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 18:00:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF5329803;
        Mon, 28 Nov 2022 15:00:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhRNWkL6sRO3NPMtc8Rj1iFjaIVKwGhab3JpyDcEdZEBEAmG/b3nJmpIkdBOdZVs+Zwkk5w6u7/dlXgRlxqyvZxErbunIXKvWWIlk6tXM5aI5cAzXLm0/KNOLXjVO5vLzhfCc/dWvSnGkCVFLQr6DFKXKatUUEv462QzakaWAZg0UrQrfaNQas9FaR4wlKVE+xSeeflHBP1WkVAuJ4bO9HZ1cL6GyAEcW311VpI4xqKhqtb/2EUzBlLKWC8ZGo3urje9GbbLyioHpN/NK0nJY4z6qqPuLItw0o9Awqqw1r2aw6iKa3ODmJGTGCp7M0MeCIMzD4UgZrm2kcRnuaN3IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSlpPgYCMzHJ80NDQTfg3f3/ZoO6lfULyGSla7eFKXY=;
 b=mbrM8II5fHCYFHUIo++FDpPpKlUJXB136l1Qt9pnmHWEA+1T9Rzwvu0X6Yk8GR/fhBMnUXpepWTdF4QaLbdOG3x/m5wbZtLao2yubBxiz38KsIpXIymcw4vzmkrzboVOyCLFDlkQlYCYzU45e+ak2Wd+hFxpc9d2m1fQODJZBw2OvelANNs2lvaQbM7aN8+fFcapw+TFi4oGz7mrd5ZeG/pY/t4aacJgSNa44igD/gGzo2s5DNCpB5CmZeCqMc1QAQJceEk1JOfo2GLOqn4R0SHMctSf1OQNDDpP0gad5pRV0ZZZgmmONTNDbvLu6ROMPv74G9KQqBrrm7SnZnkRRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSlpPgYCMzHJ80NDQTfg3f3/ZoO6lfULyGSla7eFKXY=;
 b=TuUhG1Q3c9vfsN5Vi81jTG4xPQ+FA5/UTXms6duZdadbuR412kvxZX9HE3Jm5tsoWVIoaXZkTi1Eq31B36pO/ewUtBMVbODkYmyGUXNtq1TmjbsLfigBF8IlxC6bpPEEHTndC5DzwuvdQhRPi5Tu2Ord6+dCru2Mnb1UO16lhoc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 DS7PR12MB6285.namprd12.prod.outlook.com (2603:10b6:8:96::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.22; Mon, 28 Nov 2022 23:00:47 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:00:47 +0000
Message-ID: <849464c8-476a-9a14-afdb-cb8793dd6064@amd.com>
Date:   Mon, 28 Nov 2022 17:00:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221124000449.79014-1-kim.phillips@amd.com>
 <20221124000449.79014-2-kim.phillips@amd.com> <Y39qUnlRx05eaGeb@zn.tnic>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH v2 1/2] x86/cpu, kvm: Use CPU capabilities for
 CPUID[0x80000021].EAX
In-Reply-To: <Y39qUnlRx05eaGeb@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0296.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::31) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|DS7PR12MB6285:EE_
X-MS-Office365-Filtering-Correlation-Id: b21cf0d1-d879-49a5-e5b0-08dad1946327
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b4y0tKvgJr0GR6ihYu7ei7K7BfA9xKwTeBby8rvXULAKaAhdRzRpW/iXWrbtohKWJaa0P2S3x35YeSBNBz+dWizPrZ+q2b4cYKZjqbC9qXahKS1NsOMuqEpxMXaqW5tJvZ0lFcpXjy07qC5HRJDIf/hUWqvrchfkrKqjBq3QiFFLUhBk+uV+UHtogLAuKLdS9JKpwDPv2PaQstLK0DlP0uUTzVJsyrzvS98jqsY2zrs7TGrAo6XFyewLsM9MvaqGkiCTNA2MN9iWt2GjELm7b1m8E5DFO/w2BZ8ROv159BrCaqXtd7rsF9ox3Cw2VNFcAag1PizVFUIiN09+b/7Rsl6Fzc5lonwUZ3rhtRVwcGM7LUCW3TAhnHtZdjy1GGykKDVANJWMWHeDD4c1cVTWiHEULz+0lJT6OrcJnks+5GFSOKVyq2xZT8vvM7d+3UVIxDnAn0smmuVVzGwz9kd08CneJxciNbj6cdGP+vn6YFbHC3fDxue9ZI19fCI22F9os57TeaZ1KE3Lc8+XjcLHTY26QbWovQK7br9KAbD9P5Y6Q/+SrE59UFc+sIah13+z0of+ACGLfli9jYM5uT/PeurjYJRioc6Gk4X8xxdhQjjD542a0WeplWG09nZkkeZU7D7JKkg/AFA+2WdCRa0xc7NH3xWB3cHJTntSHWCuAnrAG23x1ifcfafDx+KTnbFx0StQIMhE0G3CmlMTRvlumwlCtMNxs9yOL+G82MNMGlQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(31686004)(6486002)(2906002)(83380400001)(478600001)(53546011)(6506007)(38100700002)(316002)(6916009)(54906003)(36756003)(6512007)(66556008)(66946007)(66476007)(26005)(7416002)(6666004)(8676002)(41300700001)(44832011)(5660300002)(2616005)(186003)(86362001)(4326008)(31696002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cS9xNzdQMXFTaUd6K1dudVJrT0pSckVrUEdxMUtuNzhxUC9PMVpsSFdZSERw?=
 =?utf-8?B?TDJ6cStpaWRyNktHVXJsUmZ3QVNQSjMySzlJMFVUWHdkNmxpVEQrSlVtN1NZ?=
 =?utf-8?B?OHFwVEhMWkx4Rlh5Y1l2NVp1dFlLL3B2MnJyTnUwZkxNR0JaYlJFZWVobmp3?=
 =?utf-8?B?UnpOcC91cStHZXVJa0t3TEhyZ3Y1N3RVZTRxM01wQndkaS9TakVHaWRIYXZY?=
 =?utf-8?B?VGtCNTFacHdzZHdBMlVsQjdZZk93aXU4b0ZIa1VpMUx2U2ZoYXliQkJxRjV3?=
 =?utf-8?B?TEFEVzRWTC9jTElxeVlUZm9FS29uMGZpeDNRNXQrTjkyTDRhTFYydVFqLzE4?=
 =?utf-8?B?SVhqM3BKY1pRN2pPYjBHeGNUOS81bVRCVkZpanZyck5DWGVJZnRoRE1CZDY2?=
 =?utf-8?B?UGJGY0lJODhrQk0ySk5qYnI0V09qMGlFM090c1U5MElsVTVIM0dvMm5CRTRE?=
 =?utf-8?B?dDhZeFZ5dXFVbDF5MFpPVkVaK01uM0hmeFQ0SGNxKzM2Zi81NWJFRFo0dzlz?=
 =?utf-8?B?aWcrUG1mVUQ3MHZNeUttVVJqc2g1YmtWUWlRU2JuTEVPMmpWc3Z3Q1htMmpo?=
 =?utf-8?B?bUtnZ3paMzhsMVcwai93RjUzOGMya3ZZTlRUQndSSGpjbHpxTnpkaDdjN2hT?=
 =?utf-8?B?Y082QlB5WnM4MWxrU1Fxbkx1dlowdGRqdkdQU1lEZUN5U3Y5ajg5NE1zY2tn?=
 =?utf-8?B?azRwQVdrcHBnZG5BUVlDV0FjUG8vRXdydlFVZTFtcU5kZVJ1T3RHQ3VzNWdY?=
 =?utf-8?B?aHEzOE9udUtkVEVBbXg1WTNxTkcyYUdaVVQzVGRsL0cvaTNVZG4ySHplMG4z?=
 =?utf-8?B?V2NVQjFvL2tYa2l2dnpZMVZXa3BXeWpEY2hhcjFmWCszVC93NnM3TmtIenZO?=
 =?utf-8?B?a2lYaCtuaEgxd1FldURpWWkrZVgzR3J4WHJFVnUxd3B0MzFRZ0pOTWlnL282?=
 =?utf-8?B?SVd6R25nUXEvSlZHZTNwaTNOQ3A3WlhOYU84SzB1blpGbnovRDFqS0RPeWtU?=
 =?utf-8?B?RGN5elo1dUI1YnhqbzY3T2NXZjZ1eDhEelFJQnpzRWJYZVdBdXRnQUJTS0Qy?=
 =?utf-8?B?VTA0SVF3MGN1Y1NIcVgzbm1yZEVUMGdnWTc1M2NNUWZUaGczMXhBcnFxQStJ?=
 =?utf-8?B?WDVJVmNOdlIrMTZnQlhUQjdVcStmQ056ZTlpb3hGazNOa3pPaFFvaXYvZUk2?=
 =?utf-8?B?cmRwQ1phYmsydm5EMWQ4ajRWRjhOZVRCdFlMRzhSUExKSmxCTDFiakNuOHVP?=
 =?utf-8?B?c0h3S3Vhc0NqcU5tY2hvOUhiM3JCTGR6S1NiT2t4bFZsS21BM3hBcUUvcEF5?=
 =?utf-8?B?dGM1dlYxSmN5WFcycFR1cmxCWjBOUDdIS0kzZWJPeE5kVnN4cUhPdEF4V1dB?=
 =?utf-8?B?WWowakVBcm55QzBIckVhd293RXA2TE1RMlNOYzJyMzlNdVpoSUdBTU5wVmdr?=
 =?utf-8?B?TUs0a0diYXpzeXdDb1ozUjByTFk3ODRiTU52Qkg4NmlYbU1KTDN1cU9KQnBi?=
 =?utf-8?B?d295SEtIQmFRdlZCODliVjBYOEhTbHQwODFiV3VLTjZwK3hyOE1rY2MrbFBZ?=
 =?utf-8?B?UGZMRXFPTmVuRCtBdW0wZkU1WlNENFl1YUFYdkZJeHl3SUNrVmdlZjZlNnps?=
 =?utf-8?B?amI4VUtmbFJlOUw4QUk1emNCRExKcDk5UTRTSHgzRW9hb2J4TUVuci8yUWZP?=
 =?utf-8?B?OTdTVVdCZlVJNU5ZOWpVOTdUTm9kdFFZRmlsankvcjUwUGE5K2EzL3RUWlpP?=
 =?utf-8?B?NDZYbENCWEVZNVFtYUFIK2gxb2NjNzhzQjl2WnlNTVZsMjlIMU5FODF2YW9U?=
 =?utf-8?B?b051WUZ5SGlhckUxOHMwR29icDFiSmFaTkhEMU5raVd5Um9YYkJrUytBV21X?=
 =?utf-8?B?SGYvbUcxSXl3c0xFYjJXM1A4SHBMVEVmU3lIUWVLaTViMmV6c1VnWG84dFZI?=
 =?utf-8?B?WXdNakg2a0pwNHIzc1labUVqZXVHWWN0dTNqOGJzSG92NURNeW8rVGJwN0U3?=
 =?utf-8?B?RC80cEpUc1I3NUU3VDJZK25YL3ZCTHh2NFdHcWFHRzA0YURvYmJSa3crTUVh?=
 =?utf-8?B?ZWdGZmpPbG9wM2VwVjYrYW5ndFcwbDd5VHFoWlRLcjVkWjlaYlBXdDVtbnM3?=
 =?utf-8?Q?h0nGfubTekan+cUkVx0mNt6eE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b21cf0d1-d879-49a5-e5b0-08dad1946327
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:00:47.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sAP9BWmjx/DGdJ1rJxbcWu0CUWf4F7/ByWeX1N2mcdD6KKhUThoUJNqwUAvNj+qffuHvEY44nmOBkfMw7bSMRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6285
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/22 6:57 AM, Borislav Petkov wrote:
> On Wed, Nov 23, 2022 at 06:04:48PM -0600, Kim Phillips wrote:
>> The AMD Zen4 Automatic IBRS feature bit resides in the 0x80000021 leaf,
>> for which there is already support for exposing Zen3 bits to the guest.
>>
>> Add AMD AutoIBRS feature bit support, including for the other bits,
>> using scattered/synthetic bits.
>>
>> Add the corresponding word to KVM's feature machinery so that AutoIBRS
>> gets advertized into the guest too.
>>
>> Co-developed-by: Babu Moger <Babu.Moger@amd.com>
> 
> verify_tags: WARNING: Co-developed-by Babu Moger <Babu.Moger@amd.com> hasn't signed off on the patch!

OK, I'll add his signed-off-by.

>> Co-developed-by: Borislav Petkov <bp@suse.de>
>> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> 
> ...
> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index c92c49a0b35b..61cd33a848cc 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -730,6 +730,25 @@ void kvm_set_cpu_caps(void)
>>   		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
>>   		F(SME_COHERENT));
>>   
>> +	/*
>> +	 * Pass down these bits:
>> +	 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
>> +	 *    EAX      2      LAS, LFENCE always serializing
>> +	 *    EAX      6      NSCB, Null selector clear base
>> +	 *    EAX      8      Automatic IBRS
>> +	 *
>> +	 * Other defined bits are for MSRs that KVM does not expose:
>> +	 *   EAX      3      SPCL, SMM page configuration lock
>> +	 *   EAX      13     PCMSR, Prefetch control MSR
>> +	 */
>> +	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX,
>> +				   SF(NO_NESTED_DATA_BP) | SF(LFENCE_RDTSC) |
>> +				   SF(NULL_SEL_CLR_BASE) | SF(AUTOIBRS));
>> +	if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
>> +		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
>> +	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>> +		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
> 
> So this looks backwards:
> 
> if X86_FEATURE_NULL_SEL_CLR_BASE is set, then X86_BUG_NULL_SEG should
> not be.

Not sure I follow.  That code (originally from commit f144c49e8c39
("KVM: x86: synthesize CPUID leaf 0x80000021h if useful") doesn't
negate that: the code is saying that if we don't have the bug, then
set the feature bit that says we don't have the bug.

> Which means, you'd have to update check_null_seg_clears_base() too.

Like this?:

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 73cc546e024d..bbe96d71ff5e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1682,11 +1682,6 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
         if (!IS_ENABLED(CONFIG_X86_64))
                 return;

-       /* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
-       if (c->extended_cpuid_level >= 0x80000021 &&
-           cpuid_eax(0x80000021) & BIT(6))
-               return;
-
         /*
          * CPUID bit above wasn't set. If this kernel is still running
          * as a HV guest, then the HV has decided not to advertize
@@ -1700,11 +1695,13 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
         }

         /*
+        * Zen3+ CPUs advertise Null Selector Clears Base in CPUID.
          * Zen2 CPUs also have this behaviour, but no CPUID bit.
          * 0x18 is the respective family for Hygon.
          */
-       if ((c->x86 == 0x17 || c->x86 == 0x18) &&
-           detect_null_seg_behavior())
+       if (cpu_has(X86_FEATURE_NULL_SEL_CLR_BASE) ||
+           ((c->x86 == 0x17 || c->x86 == 0x18) &&
+            detect_null_seg_behavior()))
                 return;

         /* All the remaining ones are affected */


> Which means, you should make the X86_FEATURE_NULL_SEL_CLR_BASE bit
> addition a separate patch because this one is clearly doing too many
> things at once.

OK.

Thanks,

Kim
