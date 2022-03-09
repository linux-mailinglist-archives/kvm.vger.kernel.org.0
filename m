Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485114D281A
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 06:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiCIFML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 00:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiCIFMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 00:12:09 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2069.outbound.protection.outlook.com [40.107.236.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAA710DA7E;
        Tue,  8 Mar 2022 21:11:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FO246DVFxzKjpsx0KsjmfHAM7K6kAHlB1IwlbCJupAyrNyTpCB0pY6o7NBS6spXiZmRZeUx5reBWyaAR4yc/4rl0JpGpju2rpXVtCwARFb4w/Tq7i93GCq72ejkslcq/+eHJ1D5weCHUM1jhxAwO9Wa5uRK19Qdm8/3oJYXa+yrypzERaHAOg23QeQ5njFmwMyH+OMa5p9hStVPPf+Eb5F1f08aqFBwz9Ldw0OREBKdyeQhk0f3IO7rQ5Wj/tU7GcXfdBNUDAFHbNj1U02oH4INO+pWbZzguwMOA7HZDWGQp4zlT+Dm34RpMobPWVZNyM5gOMpWNZ2z2vx/9MtfjlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2Jm7SB/ly492A6rKvjf6Ac4YLcnfVk9MhF4OiQvBMA=;
 b=BX3MOGL87nFI6O4hNi7Uj3Z5o+BWC8kQcZv2V1FeIcAmuO5wQmCf77kwkcaoX7H8JSLDqZRS4GLsktQmnNStxFQTO+dnI5y7tt+eE9Klti5yslVba34yyQPeAMs3S2DuP0ZXCs8HxR70dnctecgMt6vECktJUgiw4s8D/eRV7n2tXqKLQGQkTs72cWFG9E56Po8KR61u06zBtLQSeFlCxZNzCptWdwiVUft9ytSjJo2VpqknLMUbsxkkh2G5V5PD/brYr6JmtptE/N6vNgW6LV1VZttPQcyj4UyzSegWEk9WN+1HkbT5pc9rBEcs5Zc8pE/2vrGVVb5ceJRARh0tqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2Jm7SB/ly492A6rKvjf6Ac4YLcnfVk9MhF4OiQvBMA=;
 b=dbtMY+qACyKCR5hj7ON0S/SEdwXmULMwsbpgSdUzmwvjOtf7xKnqPwbj3Gj22iuq2AGmR3+AmK/uWtTDDjvnDGq8Ah6mBH/YopCcSCUy0b48QQEF5havqKVcNNbLdB3PY04sF5YMikufyNIEOoxX9fu4GxThZ33HnTbPLEgQvtg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 05:11:06 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::83f:7a86:6caf:f6ab]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::83f:7a86:6caf:f6ab%4]) with mapi id 15.20.5038.029; Wed, 9 Mar 2022
 05:11:06 +0000
Message-ID: <03e87e5c-0345-5919-9a33-0bdf50285d8b@amd.com>
Date:   Wed, 9 Mar 2022 10:40:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 5/9] KVM: SVM: Implement demand page pinning
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>
References: <20220308043857.13652-1-nikunj@amd.com>
 <20220308043857.13652-6-nikunj@amd.com> <YifQbxW/NUt0HrGV@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <YifQbxW/NUt0HrGV@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0011.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:d::21) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e15790d9-fa8f-4ab6-47c5-08da018b3705
X-MS-TrafficTypeDiagnostic: MN2PR12MB4206:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB42063FD8235BF2277EB0D77CE20A9@MN2PR12MB4206.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FNyDBvhjG1XZcXBLOV1ObpHw006fy0MePKTiqH97cLpXHtiVZQtz4IR6NCy9a1fYiticoLQYDpIfPLBVEAw9KRDpa4/H5iGzUgcL8dxpCK8kE1HWBd1fOXF91PqsQ0mWY5whPT8F5U2FBGMLiYidf3Z7f0qh2Z3c9dxsyRET/OHio0JMZIxBOe5F+4/38JJeC83V+GptQbfdovvwdSe2/ok0HlZaLPJ2m/RKuPyIvavAQEtPFN31Q1e+P3u+k4r4wrXOB69gw68+ZAAiR7pgEmfQf0MXAE2PSB1OnsdEGvqYO0g2QH6hZDrponlwC+70Ivtrd/IMKsK8qWWXrKD+SYjCOKDnSVcPkFswEteRR8YSosBfbCWWVnupcHV2Gcik9AMpQapLQuW76my1moISUAi3rlViOexf760fGobhG+F7GiGysOBdIxXlN9baDihhFtOU/fCWJ/hXy+aNkoB1pbfU6GluV7vTsyE0siRmlraVS7YisjnUorgZCX7fEOgw51yXhc3ywK1q4Z1ImYsrtvnkvjXuP1QEbfZU6LHAalk6jMkwyHOwA6ImUbB2h/mlHrEgzmlnc1/kWvWwTjep81j0J4l7IItA4zsD7+n46hxoaAWOmtnNj2+/Iqa+ggfKLrMkhbBaYM8b41pSuhyskiS3QNYRV/AJMrvsD6upWS6lfGRxB8tnbOlnNU3kLG+60Twv4DE0nsPM1a+Ul53KF0h+upr79XFNMfhUO9uPuh73/W2D8vP+FAJNRL4dRQRC/ZYScS4utbeoWMRJFFnHvukGR5NGHofTGStFgG6TXJ7obSvM5aA9ID6/tDsY0di6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(6486002)(966005)(5660300002)(36756003)(31686004)(4326008)(38100700002)(31696002)(66946007)(2906002)(6916009)(54906003)(8676002)(66476007)(8936002)(66556008)(7416002)(316002)(6512007)(53546011)(6506007)(26005)(186003)(2616005)(83380400001)(6666004)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXQ3MjVjSURLOUxYNWdabFB4UVBSZVBVbU1SVFNTYUcvMkVyOWVBVkdnRVVN?=
 =?utf-8?B?ZzVlTlFWTGgyUmhXWVk3VVZ5R2VuNzhWWENFd29iYnF5MFNIVVR5MCs0T3g4?=
 =?utf-8?B?dm85UHVMUC82WXNwbzduM0dndjBoUUJ6VHFtN0xzdzJleCtYb2tWWjFycU9R?=
 =?utf-8?B?ZkEweUV5YWJBaVVjQWRPVjlQc2lTckhIS0Q3blQrakNwZElqOHZLdFZuWFJn?=
 =?utf-8?B?UEhGcUVDMVVuaWdNS2sxTVViMS90TUR2ZXlOR0g3VWF4QmNmc2xQa29zWXRO?=
 =?utf-8?B?K215UUxGOGY4T202M1lmQXhSMUhTMUxuVS9abG1WZlR0Tm04Sk5VUWV0VFZ6?=
 =?utf-8?B?WmZ5bnErZUlxRTdzV0NCbzB2YUZLQ2ZvYkpXeUhFemw5N2Y1bmM1REI2eDhB?=
 =?utf-8?B?QmhCVzJFOWpPTG5yTzZhUThCaStQSXordzZWaHdNRklmeVBZZFJFS3FvcEk1?=
 =?utf-8?B?UjdKRGUrREZtaDV3c0MyWGh6clFTTlJWTi9CNFFoRkRpYVNPWGRWVWpDd2U0?=
 =?utf-8?B?a1U1OStqV3l1Z0lVa0JBVWpuUmVrbUpJMm1ueWhTeHk0a1k4cGJYQzRkL09F?=
 =?utf-8?B?MExOVnNmdkw4Vk00SXl2dUpWWFBlM2sxeElZUUtJUzFYdk1ISERMcXdSK2tK?=
 =?utf-8?B?T00rRlFFWFFheWNoaExwdWhlR2VlMUFTV3FWT2NKRWN3dGtFV0srZ3JvL042?=
 =?utf-8?B?UWl4bG5VbXVLU1FwWnl0Y3BaellRaERJZHZDK0dRNHVSYVh5Sk4xZXZpV1E3?=
 =?utf-8?B?S0Q3czF4WEFhQWlMQUFBT2xqMS9PK3JkV1Q3Sk53K0pvRFFINWMzUU1yUC9q?=
 =?utf-8?B?TG1Ic3hvcnFsMk5DcFdIZ1ovSUI1K0tjYmc5cm5lUkNFcFFKOXpyVEN5Q2xS?=
 =?utf-8?B?cTNCa2hCb1FWQ3ZxMHYwQ21UM0xudGlzTGdmSG5jSC9HY1B1dm1VRkdVZ3hR?=
 =?utf-8?B?ejdkRWNCVHdQVlNQRHorekRyY2VjTmU2UVpSd0tVMjZ5TCs3RDhnSzQ2bGR0?=
 =?utf-8?B?MHQzSm9MRHFaUDNNdVFEYThieUtsRGVpZCtiZzBkdlNTZGp0ZElTcTlteUhj?=
 =?utf-8?B?QUdvZ3l3ckgyaVA3UHlhbXZmOStmZFlGWnc0TDBXbnpWczZIYkJpR3BXVEdl?=
 =?utf-8?B?NEdJSTc3dUdQMVllc2ZrRE5OTk1mZnljd1RCOVZuLzlleG9wSHVjSGpoMC9E?=
 =?utf-8?B?N2Rnc3JJcXNSM0RPZHlJT1oxZ0dzMnU0V1g3UmFKbnp6TDZWbWJ6dmtNQmg4?=
 =?utf-8?B?eWpJRzR3ODU1Rkt6ek9zOWo5OUIrQy9aRFJnNkNaVWxYbGpkSHM5UXNlVWJI?=
 =?utf-8?B?SDdjdmxvQkV4cU50b3o1TlFhdkczMnhhQmdHempDNWtlVWVVdXE2Z3Y5TGNR?=
 =?utf-8?B?bFB0b09velRsakRHcWRpYTJ5VXBpcWF0d0R6S0tCWElOUWFFTTVqUExVN3I3?=
 =?utf-8?B?STdkWjg5SVplRU1QelNxQ0RFZENwTTZsVmhlRkp6QjdyMXQ1UXFtR2M1TUQw?=
 =?utf-8?B?RmN6M2FlUENXUEFJT1lncDU2My9VSmNlQnJGaWJTc2QxSVlZLytZZHluUnpD?=
 =?utf-8?B?MktJc0gwL1JNeDBlb1Z2b2xkZUVsWG0ralZicjZTeEdNYVlSVXdQSVluTTlX?=
 =?utf-8?B?Y2grTWdTS1BXcmJBYXl1MFE5N2ZIdkttVzlKVGdabEZrTjZ4N1FFaGN1bUov?=
 =?utf-8?B?SWVneTFwajEza0RCdzNqUElxOEJjYXVRY0hIbHJYQ3Q3TFBSakZMeUVvR0w2?=
 =?utf-8?B?Z0ZKbzlYcFpQd0ozVE9ZYW50T0orRDdHU2VFZHFFenJZRDcybGFqSVE3Nnli?=
 =?utf-8?B?T0IzVm9WWlZOWlJla0Y2OUJ3RjNtdG1veUZLWFFRMHhRdFpCdkhyWGJKYURN?=
 =?utf-8?B?YjVGQTk1WkthWnZaWEwxUGRVOVVqVUJIQm1sd2tRSW1FOFBiZHNUZkhOT0JE?=
 =?utf-8?B?cUNNMUwxaWUrUTRpcHBDOGk2UC9pRWRVMnZWUUs5a052OFdUZ25xMW5vcVU0?=
 =?utf-8?B?d0p0MkFhVDNVVDZpcVZrUGdVTHc4ZENZNUMvcWRoMXNnWXlFRCtTYmx5dGxh?=
 =?utf-8?B?dkYxRFJXZ0Q3bFNUNmphRi8zekdFc0lzbjN4N2lnWkhLK0o2Z2wrNFJJeVJw?=
 =?utf-8?B?ZitHelN5VzBXYmpRQWhxY2dRcTJQYXdIWStqdVRBZmRUbjk2VVhCYmlGVDZl?=
 =?utf-8?Q?3oZW/ICxuxbwAmJ1Gj6knJg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e15790d9-fa8f-4ab6-47c5-08da018b3705
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 05:11:06.8083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oil1AD5qV55AMrSnqvKvhyWf5/yunQXQ2uN0sTrdRq/bM60To45rkqMHAEkTyERJe3zlV37zIXd1D3pzu3wDvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4206
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/2022 3:23 AM, Mingwei Zhang wrote:
> On Tue, Mar 08, 2022, Nikunj A Dadhania wrote:
>> Use the memslot metadata to store the pinned data along with the pfns.
>> This improves the SEV guest startup time from O(n) to a constant by
>> deferring guest page pinning until the pages are used to satisfy
>> nested page faults. The page reference will be dropped in the memslot
>> free path or deallocation path.
>>
>> Reuse enc_region structure definition as pinned_region to maintain
>> pages that are pinned outside of MMU demand pinning. Remove rest of
>> the code which did upfront pinning, as they are no longer needed in
>> view of the demand pinning support.
> 
> I don't quite understand why we still need the enc_region. I have
> several concerns. Details below.

With patch 9 the enc_region is used only for memory that was pinned before 
the vcpu is online (i.e. mmu is not yet usable)

>>
>> Retain svm_register_enc_region() and svm_unregister_enc_region() with
>> required checks for resource limit.
>>
>> Guest boot time comparison
>>   +---------------+----------------+-------------------+
>>   | Guest Memory  |   baseline     |  Demand Pinning   |
>>   | Size (GB)     |    (secs)      |     (secs)        |
>>   +---------------+----------------+-------------------+
>>   |      4        |     6.16       |      5.71         |
>>   +---------------+----------------+-------------------+
>>   |     16        |     7.38       |      5.91         |
>>   +---------------+----------------+-------------------+
>>   |     64        |    12.17       |      6.16         |
>>   +---------------+----------------+-------------------+
>>   |    128        |    18.20       |      6.50         |
>>   +---------------+----------------+-------------------+
>>   |    192        |    24.56       |      6.80         |
>>   +---------------+----------------+-------------------+
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 304 ++++++++++++++++++++++++++---------------
>>  arch/x86/kvm/svm/svm.c |   1 +
>>  arch/x86/kvm/svm/svm.h |   6 +-
>>  3 files changed, 200 insertions(+), 111 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index bd7572517c99..d0514975555d 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -66,7 +66,7 @@ static unsigned int nr_asids;
>>  static unsigned long *sev_asid_bitmap;
>>  static unsigned long *sev_reclaim_asid_bitmap;
>>  
>> -struct enc_region {
>> +struct pinned_region {
>>  	struct list_head list;
>>  	unsigned long npages;
>>  	struct page **pages;
>> @@ -257,7 +257,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  	if (ret)
>>  		goto e_free;
>>  
>> -	INIT_LIST_HEAD(&sev->regions_list);
>> +	INIT_LIST_HEAD(&sev->pinned_regions_list);
>>  
>>  	return 0;
>>  
>> @@ -378,16 +378,34 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  	return ret;
>>  }
>>  
>> +static bool rlimit_memlock_exceeds(unsigned long locked, unsigned long npages)
>> +{
>> +	unsigned long lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>> +	unsigned long lock_req;
>> +
>> +	lock_req = locked + npages;
>> +	return (lock_req > lock_limit) && !capable(CAP_IPC_LOCK);
>> +}
>> +
>> +static unsigned long get_npages(unsigned long uaddr, unsigned long ulen)
>> +{
>> +	unsigned long first, last;
>> +
>> +	/* Calculate number of pages. */
>> +	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
>> +	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
>> +	return last - first + 1;
>> +}
>> +
>>  static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>  				    unsigned long ulen, unsigned long *n,
>>  				    int write)
>>  {
>>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +	struct pinned_region *region;
>>  	unsigned long npages, size;
>>  	int npinned;
>> -	unsigned long locked, lock_limit;
>>  	struct page **pages;
>> -	unsigned long first, last;
>>  	int ret;
>>  
>>  	lockdep_assert_held(&kvm->lock);
>> @@ -395,15 +413,12 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>  	if (ulen == 0 || uaddr + ulen < uaddr)
>>  		return ERR_PTR(-EINVAL);
>>  
>> -	/* Calculate number of pages. */
>> -	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
>> -	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
>> -	npages = (last - first + 1);
>> +	npages = get_npages(uaddr, ulen);
>>  
>> -	locked = sev->pages_locked + npages;
>> -	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>> -	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
>> -		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n", locked, lock_limit);
>> +	if (rlimit_memlock_exceeds(sev->pages_to_lock, npages)) {
>> +		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n",
>> +			sev->pages_to_lock + npages,
>> +			(rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT));
>>  		return ERR_PTR(-ENOMEM);
>>  	}
>>  
>> @@ -429,7 +444,19 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>  	}
>>  
>>  	*n = npages;
>> -	sev->pages_locked = locked;
>> +	sev->pages_to_lock += npages;
>> +
>> +	/* Maintain region list that is pinned to be unpinned in vm destroy path */
>> +	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
>> +	if (!region) {
>> +		ret = -ENOMEM;
>> +		goto err;
>> +	}
>> +	region->uaddr = uaddr;
>> +	region->size = ulen;
>> +	region->pages = pages;
>> +	region->npages = npages;
>> +	list_add_tail(&region->list, &sev->pinned_regions_list);
> 
> Hmm. I see a duplication of the metadata. We already store the pfns in
> memslot. But now we also do it in regions. Is this one used for
> migration purpose?

We are not duplicating, the enc_region holds regions that are pinned other 
than svm_register_enc_region(). Later patches add infrastructure to directly 
fault-in those pages which will use memslot->pfns. 

> 
> I might miss some of the context here. 

More context here:
https://lore.kernel.org/kvm/CAMkAt6p1-82LTRNB3pkPRwYh=wGpreUN=jcUeBj_dZt8ss9w0Q@mail.gmail.com/

> But we may still have to support
> the user-level memory pinning API as legacy case. Instead of duplicating
> the storage, can we change the region list to the list of memslot->pfns
> instead (Or using the struct **pages in memslot instead of pfns)? This
> way APIs could still work but we don't need extra storage burden.

Right, patch 6 and 9 will achieve this using the memslot->pfns when the MMU 
is active. We still need to maintain this enc_region if the user tries to pin
memory before MMU is active(i.e. vcpu is online). In my testing, I havent 
seen enc_region being used, but added to make sure we do not break any userspace.

> Anyway, I think it might be essentially needed to unify them together,
> Otherwise, not only the metadata size is quite large, but also it is
> confusing to have parallel data structures doing the same thing.
>>
>>  	return pages;
>>  
>> @@ -441,14 +468,43 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>  	return ERR_PTR(ret);
>>  }
>>  
>> -static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
>> -			     unsigned long npages)
>> +static void __sev_unpin_memory(struct kvm *kvm, struct page **pages,
>> +			       unsigned long npages)
>>  {
>>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>  
>>  	unpin_user_pages(pages, npages);
>>  	kvfree(pages);
>> -	sev->pages_locked -= npages;
>> +	sev->pages_to_lock -= npages;
>> +}
>> +
>> +static struct pinned_region *find_pinned_region(struct kvm *kvm,
>> +					     struct page **pages,
>> +					     unsigned long n)
>> +{
>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +	struct list_head *head = &sev->pinned_regions_list;
>> +	struct pinned_region *i;
>> +
>> +	list_for_each_entry(i, head, list) {
>> +		if (i->pages == pages && i->npages == n)
>> +			return i;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
>> +			     unsigned long npages)
>> +{
>> +	struct pinned_region *region;
>> +
>> +	region = find_pinned_region(kvm, pages, npages);
>> +	__sev_unpin_memory(kvm, pages, npages);
>> +	if (region) {
>> +		list_del(&region->list);
>> +		kfree(region);
>> +	}
>>  }
>>  
>>  static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>> @@ -551,8 +607,9 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  		set_page_dirty_lock(inpages[i]);
>>  		mark_page_accessed(inpages[i]);
>>  	}
>> -	/* unlock the user pages */
>> -	sev_unpin_memory(kvm, inpages, npages);
>> +	/* unlock the user pages on error */
>> +	if (ret)
>> +		sev_unpin_memory(kvm, inpages, npages);
>>  	return ret;
>>  }
>>  
>> @@ -1059,7 +1116,8 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  		set_page_dirty_lock(pages[i]);
>>  		mark_page_accessed(pages[i]);
>>  	}
>> -	sev_unpin_memory(kvm, pages, n);
>> +	if (ret)
>> +		sev_unpin_memory(kvm, pages, n);
>>  	return ret;
>>  }
>>  
>> @@ -1338,7 +1396,8 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  e_free_hdr:
>>  	kfree(hdr);
>>  e_unpin:
>> -	sev_unpin_memory(kvm, guest_page, n);
>> +	if (ret)
>> +		sev_unpin_memory(kvm, guest_page, n);
>>  
>>  	return ret;
>>  }
>> @@ -1508,7 +1567,8 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, &data,
>>  				&argp->error);
>>  
>> -	sev_unpin_memory(kvm, guest_page, n);
>> +	if (ret)
>> +		sev_unpin_memory(kvm, guest_page, n);
>>  
>>  e_free_trans:
>>  	kfree(trans);
>> @@ -1629,16 +1689,17 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>>  	dst->active = true;
>>  	dst->asid = src->asid;
>>  	dst->handle = src->handle;
>> -	dst->pages_locked = src->pages_locked;
>> +	dst->pages_to_lock = src->pages_to_lock;
>>  	dst->enc_context_owner = src->enc_context_owner;
>>  
>>  	src->asid = 0;
>>  	src->active = false;
>>  	src->handle = 0;
>> -	src->pages_locked = 0;
>> +	src->pages_to_lock = 0;
>>  	src->enc_context_owner = NULL;
>>  
>> -	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>> +	list_cut_before(&dst->pinned_regions_list, &src->pinned_regions_list,
>> +			&src->pinned_regions_list);
>>  }
>>  
>>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
>> @@ -1862,8 +1923,7 @@ int svm_register_enc_region(struct kvm *kvm,
>>  			    struct kvm_enc_region *range)
>>  {
>>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -	struct enc_region *region;
>> -	int ret = 0;
>> +	unsigned long npages;
>>  
>>  	if (!sev_guest(kvm))
>>  		return -ENOTTY;
>> @@ -1875,101 +1935,35 @@ int svm_register_enc_region(struct kvm *kvm,
>>  	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>>  		return -EINVAL;
>>  
>> -	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
>> -	if (!region)
>> +	npages = get_npages(range->addr, range->size);
>> +	if (rlimit_memlock_exceeds(sev->pages_to_lock, npages)) {
>> +		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n",
>> +		       sev->pages_to_lock + npages,
>> +		       (rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT));
>>  		return -ENOMEM;
>> -
>> -	mutex_lock(&kvm->lock);
>> -	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>> -	if (IS_ERR(region->pages)) {
>> -		ret = PTR_ERR(region->pages);
>> -		mutex_unlock(&kvm->lock);
>> -		goto e_free;
>>  	}
>> +	sev->pages_to_lock += npages;
>>  
>> -	region->uaddr = range->addr;
>> -	region->size = range->size;
>> -
>> -	list_add_tail(&region->list, &sev->regions_list);
>> -	mutex_unlock(&kvm->lock);
>> -
>> -	/*
>> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
>> -	 * or vice versa for this memory range. Lets make sure caches are
>> -	 * flushed to ensure that guest data gets written into memory with
>> -	 * correct C-bit.
>> -	 */
>> -	sev_clflush_pages(region->pages, region->npages);
>> -
>> -	return ret;
>> -
>> -e_free:
>> -	kfree(region);
>> -	return ret;
>> -}
>> -
>> -static struct enc_region *
>> -find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>> -{
>> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -	struct list_head *head = &sev->regions_list;
>> -	struct enc_region *i;
>> -
>> -	list_for_each_entry(i, head, list) {
>> -		if (i->uaddr == range->addr &&
>> -		    i->size == range->size)
>> -			return i;
>> -	}
>> -
>> -	return NULL;
>> -}
>> -
>> -static void __unregister_enc_region_locked(struct kvm *kvm,
>> -					   struct enc_region *region)
>> -{
>> -	sev_unpin_memory(kvm, region->pages, region->npages);
>> -	list_del(&region->list);
>> -	kfree(region);
>> +	return 0;
>>  }
>>  
>>  int svm_unregister_enc_region(struct kvm *kvm,
>>  			      struct kvm_enc_region *range)
>>  {
>> -	struct enc_region *region;
>> -	int ret;
>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +	unsigned long npages;
>>  
>>  	/* If kvm is mirroring encryption context it isn't responsible for it */
>>  	if (is_mirroring_enc_context(kvm))
>>  		return -EINVAL;
>>  
>> -	mutex_lock(&kvm->lock);
>> -
>> -	if (!sev_guest(kvm)) {
>> -		ret = -ENOTTY;
>> -		goto failed;
>> -	}
>> -
>> -	region = find_enc_region(kvm, range);
>> -	if (!region) {
>> -		ret = -EINVAL;
>> -		goto failed;
>> -	}
>> -
>> -	/*
>> -	 * Ensure that all guest tagged cache entries are flushed before
>> -	 * releasing the pages back to the system for use. CLFLUSH will
>> -	 * not do this, so issue a WBINVD.
>> -	 */
>> -	wbinvd_on_all_cpus();
>> +	if (!sev_guest(kvm))
>> +		return -ENOTTY;
>>  
>> -	__unregister_enc_region_locked(kvm, region);
>> +	npages = get_npages(range->addr, range->size);
>> +	sev->pages_to_lock -= npages;
>>  
>> -	mutex_unlock(&kvm->lock);
>>  	return 0;
>> -
>> -failed:
>> -	mutex_unlock(&kvm->lock);
>> -	return ret;
>>  }
>>  
>>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>> @@ -2018,7 +2012,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>  	mirror_sev->fd = source_sev->fd;
>>  	mirror_sev->es_active = source_sev->es_active;
>>  	mirror_sev->handle = source_sev->handle;
>> -	INIT_LIST_HEAD(&mirror_sev->regions_list);
>> +	INIT_LIST_HEAD(&mirror_sev->pinned_regions_list);
>>  	ret = 0;
>>  
>>  	/*
>> @@ -2038,8 +2032,9 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>  void sev_vm_destroy(struct kvm *kvm)
>>  {
>>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -	struct list_head *head = &sev->regions_list;
>> +	struct list_head *head = &sev->pinned_regions_list;
>>  	struct list_head *pos, *q;
>> +	struct pinned_region *region;
>>  
>>  	WARN_ON(sev->num_mirrored_vms);
>>  
>> @@ -2072,8 +2067,14 @@ void sev_vm_destroy(struct kvm *kvm)
>>  	 */
>>  	if (!list_empty(head)) {
>>  		list_for_each_safe(pos, q, head) {
>> -			__unregister_enc_region_locked(kvm,
>> -				list_entry(pos, struct enc_region, list));
>> +			/*
>> +			 * Unpin the memory that were pinned outside of MMU
>> +			 * demand pinning
>> +			 */
>> +			region = list_entry(pos, struct pinned_region, list);
>> +			__sev_unpin_memory(kvm, region->pages, region->npages);
>> +			list_del(&region->list);
>> +			kfree(region);
>>  			cond_resched();
>>  		}
>>  	}
>  So the guest memory has already been unpinned in sev_free_memslot().
>  Why doing it again at here?

Guest memory that was demand pinned got freed using sev_free_memslot(). Regions that were 
statically pinned for e.g. SEV_LAUNCH_UPDATE_DATA need to be freed here. This too will be 
demand pinned in patch 9.

> 
>> @@ -2951,13 +2952,96 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>>  }
>>  
>> +bool sev_pin_pfn(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
>> +		 kvm_pfn_t pfn, hva_t hva, bool write, enum pg_level level)
>> +{
>> +	unsigned int npages = KVM_PAGES_PER_HPAGE(level);
>> +	unsigned int flags = FOLL_LONGTERM, npinned;
>> +	struct kvm_arch_memory_slot *aslot;
>> +	struct kvm *kvm = vcpu->kvm;
>> +	gfn_t gfn_start, rel_gfn;
>> +	struct page *page[1];
>> +	kvm_pfn_t old_pfn;
>> +
>> +	if (!sev_guest(kvm))
>> +		return true;
>> +
>> +	if (WARN_ON_ONCE(!memslot->arch.pfns))
>> +		return false;
>> +
>> +	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
>> +		return false;
>> +
>> +	hva = ALIGN_DOWN(hva, npages << PAGE_SHIFT);
>> +	flags |= write ? FOLL_WRITE : 0;
>> +
>> +	mutex_lock(&kvm->slots_arch_lock);
>> +	gfn_start = hva_to_gfn_memslot(hva, memslot);
>> +	rel_gfn = gfn_start - memslot->base_gfn;
>> +	aslot = &memslot->arch;
>> +	if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
>> +		old_pfn = aslot->pfns[rel_gfn];
>> +		if (old_pfn == pfn)
>> +			goto out;
>> +
>> +		/* Flush the cache before releasing the page to the system */
>> +		sev_flush_guest_memory(to_svm(vcpu), __va(old_pfn),
>> +				       npages * PAGE_SIZE);
>> +		unpin_user_page(pfn_to_page(old_pfn));
>> +	}
>> +	/* Pin the page, KVM doesn't yet support page migration. */
>> +	npinned = pin_user_pages_fast(hva, 1, flags, page);
>> +	KVM_BUG(npinned != 1, kvm, "SEV: Pinning failed\n");
>> +	KVM_BUG(pfn != page_to_pfn(page[0]), kvm, "SEV: pfn mismatch\n");
>> +
>> +	if (!this_cpu_has(X86_FEATURE_SME_COHERENT))
>> +		clflush_cache_range(__va(pfn << PAGE_SHIFT), npages * PAGE_SIZE);
>> +
>> +	WARN_ON(rel_gfn >= memslot->npages);
>> +	aslot->pfns[rel_gfn] = pfn;
>> +	set_bit(rel_gfn, aslot->pinned_bitmap);
>> +
>> +out:
>> +	mutex_unlock(&kvm->slots_arch_lock);
>> +	return true;
>> +}
>> +
>>  void sev_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>>  {
>>  	struct kvm_arch_memory_slot *aslot = &slot->arch;
>> +	kvm_pfn_t *pfns;
>> +	gfn_t gfn;
>> +	int i;
>>  
>>  	if (!sev_guest(kvm))
>>  		return;
>>  
>> +	if (!aslot->pinned_bitmap || !slot->arch.pfns)
>> +		goto out;
>> +
>> +	pfns = aslot->pfns;
>> +
>> +	/*
>> +	 * Ensure that all guest tagged cache entries are flushed before
>> +	 * releasing the pages back to the system for use. CLFLUSH will
>> +	 * not do this, so issue a WBINVD.
>> +	 */
>> +	wbinvd_on_all_cpus();
> 
> This is a heavy-weight operation and is essentially only needed at most
> once per VM shutdown. So, better using smaller hammer in the following
> code. Or, alternatively, maybe passing a boolean from caller to avoid
> flushing if true.

Or maybe I can do this in sev_vm_destroy() patch?

>> +
>> +	/*
>> +	 * Iterate the memslot to find the pinned pfn using the bitmap and drop
>> +	 * the pfn stored.
>> +	 */
>> +	for (i = 0, gfn = slot->base_gfn; i < slot->npages; i++, gfn++) {
>> +		if (test_and_clear_bit(i, aslot->pinned_bitmap)) {
>> +			if (WARN_ON(!pfns[i]))
>> +				continue;
>> +
>> +			unpin_user_page(pfn_to_page(pfns[i]));
>> +		}
>> +	}
>> +
>> +out:
>>  	if (aslot->pinned_bitmap) {
>>  		kvfree(aslot->pinned_bitmap);
>>  		aslot->pinned_bitmap = NULL;
>> @@ -2992,6 +3076,8 @@ int sev_alloc_memslot_metadata(struct kvm *kvm,
>>  		return -ENOMEM;
>>  
>>  	aslot->pinned_bitmap = kvzalloc(pinned_bytes, GFP_KERNEL_ACCOUNT);
>> +	new->flags |= KVM_MEMSLOT_ENCRYPTED;
>> +
>>  	if (!aslot->pinned_bitmap) {
>>  		kvfree(aslot->pfns);
>>  		aslot->pfns = NULL;
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index ec06421cb532..463a90ed6f83 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4661,6 +4661,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>>  
>>  	.alloc_memslot_metadata = sev_alloc_memslot_metadata,
>>  	.free_memslot = sev_free_memslot,
>> +	.pin_pfn = sev_pin_pfn,
>>  };
>>  
>>  /*
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index f00364020d7e..2f38e793ead0 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -75,8 +75,8 @@ struct kvm_sev_info {
>>  	unsigned int asid;	/* ASID used for this guest */
>>  	unsigned int handle;	/* SEV firmware handle */
>>  	int fd;			/* SEV device fd */
>> -	unsigned long pages_locked; /* Number of pages locked */
>> -	struct list_head regions_list;  /* List of registered regions */
>> +	unsigned long pages_to_lock; /* Number of page that can be locked */
>> +	struct list_head pinned_regions_list;  /* List of pinned regions */
>>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
>>  	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>>  	unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
>> @@ -621,5 +621,7 @@ int sev_alloc_memslot_metadata(struct kvm *kvm,
>>  			       struct kvm_memory_slot *new);
>>  void sev_free_memslot(struct kvm *kvm,
>>  		      struct kvm_memory_slot *slot);
>> +bool sev_pin_pfn(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
>> +		 kvm_pfn_t pfn, hva_t hva, bool write, enum pg_level level);
>>  
>>  #endif
>> -- 
>> 2.32.0
>>

Thanks for the review.

Regards
Nikunj
