Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA4250197E
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 19:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243318AbiDNRFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 13:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244877AbiDNREZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 13:04:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C91FDE1C
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 09:42:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeVBJk3Li4VXODhab8jFwAkMJERHQLIKWApPJAXB5/5ZSRIYlYml6yt8QPHDS3BRHU7iXGphHK6Axkto8SRrBQu1U+oGrX9Z7OAEMkhz4ICIESVMg75TVgR/vED7b/F59133euWDt6S9tV4J3HLRIIyahUn0X/WA9y7R+oCdgThxKdHo14by9aP6O2RThBhiZE/ofNAoZN8zniAjckzfM0fXlIoCK5P8a8F0vjX41HfAZnSXj64MqDIyQ8BlcK/lT3D2S1aZoLWXfL5/65l5dMgkGDFByxBg2mNu+BUrFYDPYPVBS/W6PMNxnLd8UolEn6xiYjp5VJjfwmDAh9khPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNaNQeguq7Wf4M2qooPlbmK+W0vG56meR8QznjDKqP0=;
 b=Jj6rWlZastJ45Uu/yl2PJOOyfkrP/uo4viCkWTEHb8jp19J2lfydHPcRVCDc6wdyM8stjzlPoxS9WEwEN6I1ntuRoC3Asrygxp1LQoPYXIzT8D/d6cr9BL2HIjGXV0mnDKraiFqG1sME0UG29PpOGdvLeOCVbazxoYzubeyvpFp8ik133jNzJu7LWEUBUM6H8D/V/1JmrojRSgZ6UsproCPR4iCCOXwPh35jRK9OB3cARkJwUua0INlZceKmb/ug+XGiqPAr9q87vUp/YRkZZJn3iaNbMca7IDdOoTY1duMd1T5886+6xZ1DMXzP+38WawrUahPhx11wF1ePYgrf/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNaNQeguq7Wf4M2qooPlbmK+W0vG56meR8QznjDKqP0=;
 b=dGyQmIzvTWTr75V2udxzfaF6lfCVpUwGA2Q50PcS3GwE6ylhDMSL694GDg75R8LZvCZuL7wwOPuda7TAZIcAKVLvCNfQICpQnNRDvZCAGvZgtaL319Mp32nga6JjBiuXByztSCq6E02waiAb97bxX8zCjRngi8PMcwtN6ZE3zGo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by BYAPR12MB3415.namprd12.prod.outlook.com (2603:10b6:a03:d5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 16:42:34 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::acb0:6f4c:639d:705f]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::acb0:6f4c:639d:705f%7]) with mapi id 15.20.5164.018; Thu, 14 Apr 2022
 16:42:34 +0000
Message-ID: <99f48dcb-7424-519b-e9b3-a606f8c99f57@amd.com>
Date:   Thu, 14 Apr 2022 22:12:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH v2 1/4] x86: nSVM: Move common
 functionality of the main() to helper run_svm_tests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220324053046.200556-1-manali.shukla@amd.com>
 <20220324053046.200556-2-manali.shukla@amd.com> <Ylcyghve/NZ2jlwx@google.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <Ylcyghve/NZ2jlwx@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0076.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::11) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8913b7e0-529a-440e-5918-08da1e35c6a5
X-MS-TrafficTypeDiagnostic: BYAPR12MB3415:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3415D6917E625F81957F9A4DFDEF9@BYAPR12MB3415.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DRr1S7koeRhwewYlVQzEmSYrBpigxr501MZTPvhiOQDlQhuzRUXDWFOprq2pzSPEbifh5s78G6EUZDOWBhMPPoHh3JPeaXCGpYH+8UC5MFef1t/P7HRcWAWiUXUbuCXFug1J8jPO7PvEUvpEDws/SHVxDSQgbVTIXK5nyipDFS2E7oLp36ORFcz0Y/UhHBhQYZK7n/+nhH0/rJ+W3smlPdJk1hoeishgqJnUMaWNZ9Sd3EQJGzW4TmETVFge/Jm/SeWR2v77IU2ujZFVPu8EkkqXTh71pNkCZYiRyluD6vM6yRPduPD4YE71HeGv3KIU/fspF2dC0Io6S64XRGLc8wJX7mHHc13RJYoBQ+mQcw4OJiwWuEkMGFfMH8ZGSs7KZyKfTfs03RVKkHrFFQ/GCW7eCWjvPefEgceahEGXCYo4Hu35MqWwuMLGpa3xfQDKB9ZHt+IySGJvoAUm+QJYmfzfbB8hnMpLbVLxUUacUGscEH2UK+hALs1B/YXUBOfJ85tojt/oLHJSyRfIgL2qHR3ZnhGG9toCN/pkbZIdhvRlKt6Djf0RuLMAXdH8PozTV1epYriKibEvJ7hr9Y12ON4uYoOa3fiaK+XsozeO/TlYBdwtNTP/vCiDPCfUG5fnnBxAOzlWNfDxHFsoC/UGu5kZcBPTR1mPXiuZzp/XQm5zDxxBj4hp+IyA0Yq/eLgYRg2qMOZPDVADxHgWAm4G/8/jkIY2Iu080YOEaUwD9SM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(36756003)(6512007)(110136005)(31686004)(316002)(53546011)(66556008)(508600001)(6666004)(186003)(83380400001)(6486002)(6636002)(2616005)(6506007)(66946007)(8676002)(26005)(4326008)(38100700002)(2906002)(8936002)(5660300002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THZuQzRPMVZmdWtQb0FjR3cyVlA5eEQxbThYeThDZ2VJWko5QkxkcHkyUDlr?=
 =?utf-8?B?Y1dWUWF2TTM1NTZJc2pDU1FaWUdralVOdGs0OVlqYmkzZ25GVnJoa016UHFN?=
 =?utf-8?B?eVJEVXVZdzF4MG8yNDhhNnl3dk83amZpSXJySEY0L2RHR0c4OUpYcTVhMis3?=
 =?utf-8?B?TWRBT3BrQ1FjTnhiTXJkTEtrMWlBMUxzcnVJQ3ZPZjU0Z2F2ckJyUmx5azFo?=
 =?utf-8?B?TDVyRXl6cTJ1TllreHkvSkF4YmRpQ1NHTm9qQkYzRGVxb0QrcjBjV3NUaWlX?=
 =?utf-8?B?cjFYdjRYbVV1R1Q5ZmRoWEF6NHkwZlJXejlkREFpaUt5L3RvSklLcUFYajJs?=
 =?utf-8?B?OW5sVmlsZlpWK094akR1V1FxM29DQmxtemZCRVkwYWtzbDF6OEZKZUFSbkI0?=
 =?utf-8?B?R0dFL212TUNqS01Lbyt6RVNJRHBqNjAveVo2NVlzQjZ6ME9GRDUrdm1TT3VX?=
 =?utf-8?B?clJPVXFXSTNxd2NhWUE3V2ZGSUN1KzRQS2ZhQUc1ZWlYcm5uUUdIbmdlV3Nh?=
 =?utf-8?B?SjdBbXNTYXArOENlblJULzdSbkVWVHNjZmNZL3dja0s4eWNyTFFHMmZmUlJC?=
 =?utf-8?B?a2RQaFFKMzFqVDBMM1l0eUZIbmc0SXNWNVFqUDVVOWdtWXpLWDVqSGpzaVln?=
 =?utf-8?B?bWplKytMVFRSRFhMM1U5STRjWUh2YURqVFlvekVoVXNNNDVRU1RjaTJKRXJ3?=
 =?utf-8?B?RUduZkJCQU4zZlZrWlBFMUVIakl6TVBoRkFycnU2bXdISm1JRUxQNXNpQ3hw?=
 =?utf-8?B?Q1BHSGpaNjhTblpOTjVzeGU2djFpZFc5ZEROTitXMVJjVm5SNlZ4Wi9CSmRw?=
 =?utf-8?B?cGVGRSszMDRIR2RKNHhIdFo5bGo0YTVvUjUzdkYxMlZ0MG13emhSL2l6Q2FM?=
 =?utf-8?B?YXFqUWVCLzlzS21CejdJYnY4VWlxMHhGeXE3clRKSExrL0ppV1h3L21abVVQ?=
 =?utf-8?B?RGlRM1JrWnQ1LzROeXRkYWsybUhha2hQT2plSWNuUUQ2dEhUREdzZDE1SEd3?=
 =?utf-8?B?WVFPSEF3bVlDQStCYk5RRW85SXVMYUdVSmtSUFZVS1BSbzFNLyt5N1JuWkUw?=
 =?utf-8?B?Ui8rZ0pBYUFKTWg3blp6UnB4Tmk1VXBZUGgvOUxrOXBEdk55THFsT3NwRnU2?=
 =?utf-8?B?SER5MUR1dFZBeCtkelNUWS9WL3RrK2d0c2VVL29sUFk4TFRUaEZlYXk5ZkVz?=
 =?utf-8?B?cU9GRU5sNkRhdEhQZnNuWWVlYmxFUEZ4SFFscmlJWmtSM1FpcDRKVHBSQVJZ?=
 =?utf-8?B?TWNvU2EwYmE4VUpmODMxUE5lYk4wQnFmUFNRRSt1WWNmakJka3NjQWRlTzY3?=
 =?utf-8?B?M0UrWmtWUHA5cnF0YzNQMy9hV1k4ZHZCSTFOVG11SWJoV0grKzc3elcraUtv?=
 =?utf-8?B?RnJHZWozaldQMzBydGt6UE1sTSs5NXVRSVNRdjF3SUF3cVhWMG9HS29pSUtm?=
 =?utf-8?B?RWFHV3N1UUpsVUFNc05uUmRLemg5OWtCTTIvSEcrOXFOWEk0TkdMdGJOZFZC?=
 =?utf-8?B?VVc0WDQ4R3V1bUNkem1aU3Y1Y0hScTUrVG9wUzVweU1kSHYwNWtXd1dHTzF4?=
 =?utf-8?B?VW1BQUJ4MUdleVhGRmszQ3BBRVFxTmEwM01Fa01PbHR1RnQ1Z1RZRnRtUWZD?=
 =?utf-8?B?Tjd4QzVjODJJbWVIVTNZZTVVZW9MR0pNMTdKWnpmVU9UUjNIYVJCb1hPQ2M4?=
 =?utf-8?B?enkzVkQyZmxtQk1pRXgvN2VkQ3B5bXhiVW5NWjhzOTVUZkNvczRPdkZJbWlC?=
 =?utf-8?B?RUt2UEhmSWZCSnJCL1hTYzZIWFNjTHZFY0E0cCs5QjR1YmxGclBLNFVZTTNy?=
 =?utf-8?B?VHp4V3MrMGd5blg2UlVQbzZhaEZnOHdaSC9FWFlRVzVqbGN6dzdxMGt3V0sr?=
 =?utf-8?B?MUlVWEhFUzdYTXlsWXh2WmtzMWFQYmNicGlGM1NYeDRCeTRGQkpRYkxiandv?=
 =?utf-8?B?Wm1RUzE0RWZyMlRpTVJBQm5pRVhnU3AyV2lEQnVodEk5WDNPMnVndWhrSi9z?=
 =?utf-8?B?WnFBMDMwT1M5OFhnVXdFZlZZSkRDcmcwVlNYV21BbHBNdEhIQVIrd3FwZGh5?=
 =?utf-8?B?UUpBdTJPSTlyZi95aWhuSnNxTVliNkZjbG5DOTZYY1p5Z2lmamZleFZjN1o1?=
 =?utf-8?B?SXNkVEp4VzcyNnJnSHNCaUlxTUFKanBjU1JoT0xmUlpQdEdud2NSbHlpRGI0?=
 =?utf-8?B?OUlKMFRqNDhySmp4R3pGRlRMYjREZ215amZac3AvU1ducVorbFJIKy9uc09o?=
 =?utf-8?B?MmNXSldIRVpyME5qZTFXREloTFBSb1FvZlVDdTJPU3U5emhsOHVtOVlnMkNm?=
 =?utf-8?B?UzhzcEx6V29KckorQnFkd0FRcFcyWUhaa2ZvWkRWTDdYeUJHREpRQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8913b7e0-529a-440e-5918-08da1e35c6a5
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 16:42:34.4295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEN4TCiTeV8cbQekRDgi+Oxcbu542pNO63CQT8nrAWquwsMlzcmtD1yN/rhB6plEjo2iUM/4OgPT69rYBeM3Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3415
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/14/2022 1:58 AM, Sean Christopherson wrote:
> On Thu, Mar 24, 2022, Manali Shukla wrote:
>> nSVM tests are "incompatible" with usermode due to __setup_vm()
>> call in main function.
>>
>> If __setup_vm() is replaced with setup_vm() in main function, KUT
>> will build the test with PT_USER_MASK set on all PTEs.
>>
>> nNPT tests will be moved to their own file so that the tests
>> don't need to fiddle with page tables midway through.
>>
>> The quick and dirty approach would be to turn the current main()
>> into a small helper, minus its call to __setup_vm() and call the
>> helper function run_svm_tests() from main() function.
>>
>> No functional change intended.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>> ---
>>  x86/svm.c | 14 +++++++++-----
>>  x86/svm.h |  1 +
>>  2 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/x86/svm.c b/x86/svm.c
>> index 3f94b2a..e93e780 100644
>> --- a/x86/svm.c
>> +++ b/x86/svm.c
>> @@ -406,17 +406,13 @@ test_wanted(const char *name, char *filters[], int filter_count)
>>          }
>>  }
>>  
>> -int main(int ac, char **av)
>> +int run_svm_tests(int ac, char **av)
>>  {
>> -	/* Omit PT_USER_MASK to allow tested host.CR4.SMEP=1. */
>> -	pteval_t opt_mask = 0;
>>  	int i = 0;
>>  
>>  	ac--;
>>  	av++;
>>  
>> -	__setup_vm(&opt_mask);
>> -
>>  	if (!this_cpu_has(X86_FEATURE_SVM)) {
>>  		printf("SVM not availble\n");
>>  		return report_summary();
>> @@ -453,3 +449,11 @@ int main(int ac, char **av)
>>  
>>  	return report_summary();
>>  }
>> +
>> +int main(int ac, char **av)
>> +{
>> +    pteval_t opt_mask = 0;
> 
> Please use tabs, not spaces.  Looks like this file is an unholy mess of tabs and
> spaces.  And since we're riping this file apart, let's take the opportunity to
> clean it up.  How about after moving code to svm_npt.c, go through and replace
> all spaces with tabs and fixup indentation as appropriate in this file?
Hey Sean,

Thank you for reviewing the code.

I will work on the comments and fixing up the indentation.

-Manali

> 
>> +
>> +    __setup_vm(&opt_mask);
>> +    return run_svm_tests(ac, av);
>> +}
>> diff --git a/x86/svm.h b/x86/svm.h
>> index f74b13a..9ab3aa5 100644
>> --- a/x86/svm.h
>> +++ b/x86/svm.h
>> @@ -398,6 +398,7 @@ struct regs {
>>  
>>  typedef void (*test_guest_func)(struct svm_test *);
>>  
>> +int run_svm_tests(int ac, char **av);
>>  u64 *npt_get_pte(u64 address);
>>  u64 *npt_get_pde(u64 address);
>>  u64 *npt_get_pdpe(void);
>> -- 
>> 2.30.2
>>
