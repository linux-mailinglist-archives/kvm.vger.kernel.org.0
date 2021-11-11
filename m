Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4944DCF5
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 22:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhKKVSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 16:18:09 -0500
Received: from mail-bn7nam10on2077.outbound.protection.outlook.com ([40.107.92.77]:33088
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231825AbhKKVSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 16:18:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjhAbCkIfqfrkId4eeg9dK2v7iOekHVcJ6gQYC/963vsFkxJluu/F2iLBZsItaho6/sFFstAfu/3nV8cLKRoTdUqIbBGfFdSQqNbareTy/3wM4dvhpXxyXzVvPa35A7th636hzyniEzo45eoMMh86XHQe1Lbysn9e1iftMMrhb5euGBlSRKMVKhW7+OW9+3U/e+ra+uYZx7LiYiw0Nr+pkJ5wwjt6snPT66Qtdqg/MyFZ8JFwX+xNnVogB2IN9uckI/L60YtCSRLBVyw4jvtEesygh2Ka1S5fVdDDp8NsPqGBFQP6WQqYQamCXD1DhVMBhftg0ddoX3v268esESOnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ww9079yW4ro1j6LHe7Rm54Wtk4riw2mxl+ebUzdBlO4=;
 b=WPlEJ+zrQ1N46hTZm+US0u84D5/h7mQvBD2A7zwILPE/E6ptCKRI9HMmD+nnLCnPopbuN8EjchTGtRDUxvAIqoSwfJjUHebVYNEJpIFvhPMPycjp+5ljk0Nk3QM2+p80aW5PcjKBTQ9mjoiQfDCM6faxaiBrTIQdAW01+vkZWgVxfTkHV9UegKYNbS2IXjB8BeOrDa6iT8Rj2HTm5Fcl4IJ9lGWclQdDZlMWz2+pKh1HIGJEEkuFW6H1fb76nTjT0yN38SuUIf2/UXievfWxpTJnWG5WXPzHu4nkZ8KaVm22tFfMUBJrT6FvrOHm+TrzWGCa1+Wbbdb/LhxUTh3i7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ww9079yW4ro1j6LHe7Rm54Wtk4riw2mxl+ebUzdBlO4=;
 b=jUNkhZhZpG3QbggqAuxyBfhDL++v5Cy4w0d+ONET8smyDouGPi/4KTY4VV+WaigTYHcAemKy7hAyqLO6MD6rfk2WWQ76sRDKrrVgbdnUObHYoumlTp8DfMdZOQllhOwIwY+jHTBLI+zGmpDrVlP09kddtKuBw52uBjbaYI0D94A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1424.namprd12.prod.outlook.com (2603:10b6:300:13::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 21:15:16 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::f0e1:d37b:e4ca:395e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::f0e1:d37b:e4ca:395e%3]) with mapi id 15.20.4690.020; Thu, 11 Nov 2021
 21:15:15 +0000
Subject: Re: [kvm-unit-tests PATCH] access: Split the reserved bit test for
 LA57
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <163666439473.76718.7019768408374724345.stgit@bmoger-ubuntu>
 <6538605a-0df0-a30f-b30c-7361113cae86@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <2b70073e-6b5b-83f2-31f9-16680835b4a0@amd.com>
Date:   Thu, 11 Nov 2021 15:15:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <6538605a-0df0-a30f-b30c-7361113cae86@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: BL1PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:208:256::35) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
Received: from [10.236.30.47] (165.204.77.1) by BL1PR13CA0030.namprd13.prod.outlook.com (2603:10b6:208:256::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.12 via Frontend Transport; Thu, 11 Nov 2021 21:15:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a621921-bcff-4a88-dd50-08d9a5585b26
X-MS-TrafficTypeDiagnostic: MWHPR12MB1424:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1424B86C64AB36736E2E7A3B95949@MWHPR12MB1424.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/EsPZ65UO50cz7FpsX8V+ug9tkoiBZzodZ9Gcwk6dKfjqeEaVDmkYe6Q6nP5DEI/mwgNt2PZ+5bFPvbU/RoRE34wyc6jB+c9t9yt7vbsD7lumje7WQ/sHZFskd8wV2nK6VJ5v/Z93LRlOeAavLNo7ld3Pc8kCvjAO7MUKbJiGN0uFJcng7UvlMLgMrGozrrGVwgMr9jtxYumpsgyuCGH9vH046qPjdFsmGh/NzicmRJa0vK1dBtuxYca1bGkdsMC1uvagyBLiIYeHtYYBvM9vQ4yDA5nNGa6j1DRB7buEbxbfC7eZLTr5EUzh5N6nrKsOCjWhenM2K9S5pl0OBpBg4lDi5epnT5ttBtQr2ZHVApiizEwbkMUzKO+enXh8G1SbrdxsqGA6N08sakQYoP9A6tXV9+cYTFt17/cnbqkh+pLiYoR/zxRca9PxPQyfYuYlS9ZUkTCtiO/hd+FGjWqpnsNiVm5tbZsr3smgxLmNQdaUACr6NaleNStxkbvfURYtzKowwjwJh4SaL/kkVU/86Lc+/So3ErI411Q232pPflHQC0QUF2AAskEHnxtqzsjNnsFhtPG7UKAtLUDWZCQ8uz94eutlo843yKeuCtO8zdBn7Gr/0tPas0IIwx+97XvfdaLAaltIk0G75euDQaxLT6AJlDQfO7I4VH6EZIDIgJF8KTQkv2R26+IsrOYCzuPKI5B2NfnLWCS4CHpFw6bgnjkckTa7YDH/8GVOYxY64=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(6486002)(66476007)(316002)(38100700002)(5660300002)(2616005)(83380400001)(44832011)(53546011)(508600001)(8676002)(186003)(31686004)(956004)(86362001)(66556008)(16576012)(2906002)(66946007)(8936002)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUNvdG1ma2xCaDBPeGhCRDBYdHFqQTBreGZpbXhGTjdzL1FkQ1hOTUJrS3Ex?=
 =?utf-8?B?Mm1LYVExbjFyd0s2ZU5naEd3OW9tT2ZuRFBscWRhQ2xFZ2hSZURJYUptZDc5?=
 =?utf-8?B?cWhTT0FYbnV5aHpTaWM2Y2lCdTh2YUNORzZLQVdYZDR5U09FcEk1azUxNDVj?=
 =?utf-8?B?ZUhIVTNqYXVLOEJJOUgwQ2duWWIxMXMzampPZDY0K1ZXZmlIZTFINnNTZGZn?=
 =?utf-8?B?MGVCQm5maXRVcmVFMWM1OW1HK2ZiUWFMdTFtejczU0lKMjBlOGc3Y05JMmhG?=
 =?utf-8?B?ZExwcTIrU1hQSTZPY2lIN2tOa0xQTHNoYWR3L2NrQzNPQmhycTFCd3F0M2Zz?=
 =?utf-8?B?RWZTQXdjQWRIcDZVdEdXNkNhTjZ4Wmt2WHRzZ1JKUVBtVmkwcmI3cUMybmxr?=
 =?utf-8?B?MUVDdXlqYkhCUUlwUkRFWTdCSGlYMzBFbFFmcU8zZkNtb3puMkdiUW43c0pX?=
 =?utf-8?B?RTBmNlRJczlXdjU3VzJMN3BCWkxkeDRrKzN5VDVpM1U2YVBIQmkxL3FITHVr?=
 =?utf-8?B?aUMvOTU2eVlPV1JSS1Q4cEtpK01zNnJ1NTlLenE4L2ZydkFqZDFseVU5NVh3?=
 =?utf-8?B?Wm9MbmNKUWozRGVUdCtYUnRTc2MyNmdESCt4aDgwZ1RubDE0RE83MVRzTWdx?=
 =?utf-8?B?bGFEbk5EQ0N5bTRSVnRUQXM5ZXg3SFg2Wkp3K2MxQ1VKeXdmWVp4U0NaWkRy?=
 =?utf-8?B?Tkhna2ZTeVJZaVhLUEUyTnBGM0JzV1FiQVNReU0vVkgvU0FtS2lEc25INEdq?=
 =?utf-8?B?VlJmWU5CQnJoYkxWR2lEMXhHem1CVTFXM3BqajhuN3RrVmhIcjNJSjYxWEp0?=
 =?utf-8?B?VlNEUEFINUNoUXdVRmtRSzNoZlRRUkpNRnJNOCt6dDhMMlRiUUpSS2twZGpZ?=
 =?utf-8?B?Nkp6MFBNcFJQU1ZtSVdRRHJBNFlIRmxEa0pMUGNaamZKaU9BWENGRXZOSnZk?=
 =?utf-8?B?djBFUEVyaXAwQzB2TWI4L0prcGkrd25XZmJsckgrTHlabTJXRWY5eEVMM1o3?=
 =?utf-8?B?THFRbmNuUC93ZmVibTAvWUpOYUpJNFk2SDJRVjBLS0hXbW9FK2tzZVNmdVZG?=
 =?utf-8?B?bW9ZZzYrWHZTeXNOL2lkeXNqZ2ZFSGxBRnZ5RVNEeCtBb0VTbVM4SnV6UUZS?=
 =?utf-8?B?TjJ6V3VIdDV5a1JvTGJYL05sSVhUbmVJSnp5dlA0Um1oN2ZHNThvdnorTTlS?=
 =?utf-8?B?UytiUExnaWJreWtMdGJGemY5N2ZhTFh0bklJdVFwaGFsN2g3eWNIb1pqdW9J?=
 =?utf-8?B?bzRIQTV2SXQ4aFNnUEFidW04TEVyc0ZiSEtLL2xRZ04xdTdPL3FjNHdVVDha?=
 =?utf-8?B?aE05SU5vTkJVV0dUeE9IaWpqekxsNE9KTFZWVXZrandmTTBDOElNeGpLNXhx?=
 =?utf-8?B?TkR1UEFxZFIvRG4zRml5MjRkZEpqS05FLzB2bGZYMmJZR1M1dTBNSHlNdml1?=
 =?utf-8?B?NDV3WVZtSGxlaVFENVljUldvTG5hYTFYWk9BWUxMSkY4YWpMU1UrWEcvVHJy?=
 =?utf-8?B?dHoveU51Z3JpcGJSdkxGeGJhWEoreFNpaDlKbUNadkpUbzBUcEhCczJ4RHVl?=
 =?utf-8?B?Q0JWUFlraDVmMXN3VWVsRVZDOURYeG9LNWk0NHI3SXNEb3h4dWNsSXlrM1hs?=
 =?utf-8?B?c29zYlBvUlRZaHNRQWwyb2svTjlrMHJZTmpEQ3RtQlJmTmJIejRHUjlIK1Nk?=
 =?utf-8?B?V3ZPdm9NS3gwUDFDMUc2K2tqWVN0bjM4VzFGeWliaU1tbHZjWUxJOFNweVJF?=
 =?utf-8?B?RGJNcnJoQ3FXNU1yVDdhTHEzM2N4SW1ZNDFrQ09DTnJSSmJYMVp2SmdHbHJr?=
 =?utf-8?B?UGxRd1VicjFlUjM2blZqRFRxTFZMZmEvVWhqQWdEcHdnaXprazFxN2ZYc3FY?=
 =?utf-8?B?KzdLR3g4MWFjbEg0WXk1QURheUZiOEJvZUdOZmNURUd0MjRqcEhIR2JTS2ZZ?=
 =?utf-8?B?c2VwQkpOVklucXRtdzNFb2JyeWwrRkd6cVJSZmlkWTNmd3Z4NGd0WDRoeWJM?=
 =?utf-8?B?MFA3RldDNEU3aVRMbVV1Mk1FOC9OMFVZVHF6V0JvUmVxMzlRTUE3Y09iNTFN?=
 =?utf-8?B?d0twdmJHbFlCbDV1OEhDNVFXdmVVbndGb2paUTN4OERmT0phdTRIZFR1TnVJ?=
 =?utf-8?Q?gSlk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a621921-bcff-4a88-dd50-08d9a5585b26
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 21:15:15.6466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mod19ODbXm9HvYzpIVUyeBsGjVLVhU6Ptd86ivZvp1SXLYnSXldV2Agzfk9g+HAc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1424
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/11/21 3:03 PM, Paolo Bonzini wrote:
> On 11/11/21 22:01, Babu Moger wrote:
>> The test ./x86/access fails with a timeout when the system supports
>> LA57.
>>
>> ../tests/access
>> BUILD_HEAD=49934b5a
>> timeout -k 1s --foreground 180 /usr/local/bin/qemu-system-x86_64
>> --no-reboot
>> -nodefaults -device pc-testdev -device
>> isa-debug-exit,iobase=0xf4,iosize=0x4
>> -vnc none -serial stdio -device pci-testdev -machine accel=kvm
>> -kernel /tmp/tmp.X0UHRhah33 -smp 1 -cpu max # -initrd /tmp/tmp.4nqs81FZ5t
>> enabling apic
>> starting test
>>
>> run
>> ...........................................................................
>>
>> ...........................................................................
>>
>> ..................................................................
>> 14008327 tests, 0 failures
>> starting 5-level paging test.
>>
>> run
>> ...........................................................................
>>
>> ...........................................................................
>>
>> ........................................
>> qemu-system-x86_64: terminating on signal 15 from pid 56169 (timeout)
>> FAIL access (timeout; duration=180)
>>
>> The reason is, the test runs twice when LA57 is supported.
>> Once with 4-level paging and once with 5-level paging. It cannot complete
>> both these tests with default timeout of 180 seconds.
>>
>> Fix the problem by splitting the test into two.
>> One for the 4-level paging and one for the 5-level paging.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>> Note: Let me know if there is a better way to take care of this.
>
> Aaron Lewis posted a series to separate the main() from everything else,
> so we can create two .c files for 4-level and 5-level page tables.

Ok. Sure. I will check on that. May be I will send the patches once
Aaron's patches are merged.

Also one more thing, we are running pretty close on each of these tests.
Each of these tests run about 150 seconds. Very soon we may need to reduce
number of reserved bit combinations.

I looked at it little bit but have not found better way yet.  

Thanks

>
> Paolo
>
>>
>>   x86/access.c      |   23 ++++++++++++++++-------
>>   x86/unittests.cfg |    6 ++++++
>>   2 files changed, 22 insertions(+), 7 deletions(-)
>>
>> diff --git a/x86/access.c b/x86/access.c
>> index 4725bbd..d25066a 100644
>> --- a/x86/access.c
>> +++ b/x86/access.c
>> @@ -1141,19 +1141,28 @@ static int ac_test_run(void)
>>       return successes == tests;
>>   }
>>   -int main(void)
>> +int main(int argc, char *argv[])
>>   {
>> -    int r;
>> -
>> -    printf("starting test\n\n");
>> -    page_table_levels = 4;
>> -    r = ac_test_run();
>> +    int r, la57;
>> +
>> +    if ((argc == 2) && (strcmp(argv[1], "la57") == 0)) {
>> +        if (this_cpu_has(X86_FEATURE_LA57))
>> +            la57 = 1;
>> +        else {
>> +            report_skip("5-level paging not supported, skip...");
>> +            return report_summary();
>> +        }
>> +    }
>>   -    if (this_cpu_has(X86_FEATURE_LA57)) {
>> +    if (la57) {
>>           page_table_levels = 5;
>>           printf("starting 5-level paging test.\n\n");
>>           setup_5level_page_table();
>>           r = ac_test_run();
>> +    } else {
>> +        page_table_levels = 4;
>> +        printf("starting test.\n\n");
>> +        r = ac_test_run();
>>       }
>>         return r ? 0 : 1;
>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>> index 3000e53..475fcc6 100644
>> --- a/x86/unittests.cfg
>> +++ b/x86/unittests.cfg
>> @@ -119,6 +119,12 @@ arch = x86_64
>>   extra_params = -cpu max
>>   timeout = 180
>>   +[access-la57]
>> +file = access.flat
>> +arch = x86_64
>> +extra_params = -cpu max -append "la57"
>> +timeout = 180
>> +
>>   [access-reduced-maxphyaddr]
>>   file = access.flat
>>   arch = x86_64
>>
>>
>>
>
-- 
Thanks
Babu Moger

