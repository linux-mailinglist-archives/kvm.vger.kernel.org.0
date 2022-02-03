Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CBB4A7EE5
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 06:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbiBCFSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 00:18:47 -0500
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:19366
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231860AbiBCFSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 00:18:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLk2poUs1MbvDs/J0Uenoq+BXZezYcAqaksfmbe+jAPRgWK2yI1pH8CQudIDpQa04SLab+R6SUhjiJ/D4L7OB3AD/prpt7B9B6Ur5241vdaJGeo9LqiR2GImfzLWY8sGQ18EN9nYbisv6wWZWZk9XFMhfUtn8Uk+ExmrFVSXQC+/Vvgkoztae0xyHroSs3ldy+1Fd67gHB5cZ5Zr4BaRuZXiJtAwvG7IyCMWjpRYXNAFfkOKyk4rXPFYytsEmClg+DIr2ij+3yftQH+yh1hp9tTZo+tTuxX424ZoWutoLSjCDF981XaAGI4At3rkguK0WmVA/UxX701RIrLRnO1hzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YXM/pApOkDoB6JC1W7lZkAzJQKietQ/UQ+I3mCBtDs=;
 b=hNfdrKxK4VO0FVCPvwG4iD4YMT5zhWNQIdVrw91BKrhRsO1/4yiux3yIyRpAdcm8rOT07HEcnPCWHjeprM41h+/GFo7JvOGdhm0GuvMxkcMcFdU0Yq00cq6n1VVazMQllS7K4mwBNlOd0UzR45T0ehEjtEo7hKbLXnNbnh3JuDv8GYLF6xheVrzV+50+nTUdHHfsDeCZwH0yMp6T8iz0iEZAytN96oJ+p0AN/ShT24YUqGPw8L2CZqB4Xk7BSVmLyCg15fnM2axqPG7tGId0QyHNaTyL5Qi4507u7iyEcg6qRHRrWVYiS6gQTp16l52m3ON42qxLDYvPrvSoPiIHEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YXM/pApOkDoB6JC1W7lZkAzJQKietQ/UQ+I3mCBtDs=;
 b=G3y6p+wjjWPzIfo6L81ig3G850P4fe/7a10oAPgSP2yHAGoL90RqBU1b8Ci1FXWkj3GAzitbtqcVZJWehSvrm8yissbIu+hloNX9InIpKB9zgyxcqoL9m48iLiSRzprQz+653MYr4PERvkdr1Xz56lYSxYpumuY6XwOLxfGK0XY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by BYAPR12MB3208.namprd12.prod.outlook.com (2603:10b6:a03:13b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Thu, 3 Feb
 2022 05:18:43 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc%5]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 05:18:43 +0000
Message-ID: <3c97e081-ae46-d92d-fe8f-58642d6b773e@amd.com>
Date:   Thu, 3 Feb 2022 10:48:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2] perf/amd: Implement erratum #1292 workaround for F19h
 M00-0Fh
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     like.xu.linux@gmail.com, eranian@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        peterz@infradead.org, mingo@redhat.com,
        alexander.shishkin@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com, Ravi Bangoria <ravi.bangoria@amd.com>
References: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com>
 <20220202105158.7072-1-ravi.bangoria@amd.com>
 <CALMp9eQHfAgcW-J1YY=01ki4m_YVBBEz6D1T662p2BUp05ZcPQ@mail.gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <CALMp9eQHfAgcW-J1YY=01ki4m_YVBBEz6D1T662p2BUp05ZcPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::25) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95bab9d5-ec64-4ffe-4e3f-08d9e6d4a57c
X-MS-TrafficTypeDiagnostic: BYAPR12MB3208:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3208A24CF020E3A11B3B8213E0289@BYAPR12MB3208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aBV2xEqNDtKT2wOz5vnT5tKi6Sj+DvZDbLcl82182BDCSIAGSN3lwl+2uvsVt2WgU4f+fDIPTWXFlRNhxKN/Lie5s42hz5M+e/4yyblN65t2XJC9g93/euapLzVc5uBH4DJpuk48JmWiZtb22V2ZFFOApPnffZtwg8rc6yLwAzeoK1bKmY29UrZ7v2UevWOONJ5giwCxudAthYZJbZuUiv/22/5jKNpUnQGd8IN6nXuzTz+IOCenfF8CWz3mFhLWpnjDeRj2NcNKQeY4hw8C0h4ifM4n09262PQg/xWJLMs2QUHq3uiPoITvfCBlcpm0NfhwzMM+dewUmRsJ5dk0J7IwTzmZarrfYmvYTDE0oXfEX+GCARnBirdniqAbldHEh0WXhMJgmXkR0l1hZ4LV+I1NZIJZDkXf0MpCzMMh8cb9SooSZxITQORtmKR5iwezEl8Zmk50xXThZ5KYdHx8JO5ej+DcUkd+bzBcXRVdUvP879klOuEd14TuP4SjZNX24jv0fqFCYMiSGx8xJdxBCik7HjKyh1pVYBtWpYObXFIjtSNfoaE+H01v53b+0fBy5Skj3y8OJHVh9TKTEUx7q8lwgrupWtJQRjyc+7YKbu6yv4UaMdQrH5+fyxvHn3VacOx/RGUS7TSUXW/SyGOPh7MCY2P0jBXk6NaWJfahPbkEInkBTc0cMMRHbdLUpNiQN0Z5e+OE1sfvCzB7Gu47hUg5f7w2fUaTMDW9Y+aipHE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(2906002)(186003)(316002)(38100700002)(31686004)(26005)(6512007)(53546011)(2616005)(36756003)(6666004)(6506007)(6486002)(508600001)(7416002)(8676002)(66946007)(31696002)(4326008)(5660300002)(44832011)(86362001)(83380400001)(66556008)(66476007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THcyVWVObEhUbzFaQS9lajBSYTB1WUxWUXdtbEkwaDhOS2Z0aDU3WWVlM2tl?=
 =?utf-8?B?bzJlUXZ1NnFGQkFIZlBCVVltU3BxcXBnekpuQXVkUmZzc0lDN3d0SXg3MWp1?=
 =?utf-8?B?NW5yRE5wdDBrQlFaVlUyL2lGdFhaYngyZTkxK3QwWGlVRS9TZUxZcDRXbzYw?=
 =?utf-8?B?Q3ZmWGhBNFVEbDhyeVVKL05hNzl4c2JaVElBalc5ZGMxajFZbVUvYlZUUldw?=
 =?utf-8?B?RTJPcnFlODJXMFppQURyYmZQTyt6YTRQY01ieG5KRUcwbDhTQWdmYmVUNkFX?=
 =?utf-8?B?YkRmc0lOQ0VhbHBsVnBJS3ovaFJuVGxqdFdQSWhpdnJzK3RTaUtHcmIxZzZP?=
 =?utf-8?B?cTFkdXc3eVJRcmkxSkFNdjcvQW1YSEFUV3pOaU5aOXVYTE9EWjdOR0grRG03?=
 =?utf-8?B?ZnpFUG1BVi8rbWwxWUlIWE4wb1V0bFdVWDJMUmtFSm50RzBLUGl0b1JlK2pZ?=
 =?utf-8?B?cE14TFlsL0tTY2c5anVQb0RZeVpkc0tqNURqSk50SVJocmFuZjNyNWl4bFBs?=
 =?utf-8?B?eWg3dFlFbnVmWmU3Sk9hb2hnTTJJc2ZUN0VBRWI0aG9vaU5pOWZMVFdPVTZn?=
 =?utf-8?B?UlpCU0o4RktoZ0lhbm45RytjSkw1Ny81U2JRYTF0b2VIK1JHZVBZdkxRZC8x?=
 =?utf-8?B?UUUwbnFlallFanNUNUtGMXpGeWJSZGVsYk5WbzE3RVBzcVlndytKaGMwdlJ2?=
 =?utf-8?B?dUNYTUdQVjg0eHJLbVhNbzUxczlKanRPTzVmdmlyN1pYR0EzSVF4dkFGVVRj?=
 =?utf-8?B?MlI0RjZIbHRMRFJieG5VcTNkSEkvR1JBS2VtK0VmQ2UyQWRYLzZmUzJnYkU0?=
 =?utf-8?B?Q1k4TXV1bDRDaFN5OWsrYlFBVDQ2VnVmMHBoNnZLSU1uc05jVi90VDRwdmhZ?=
 =?utf-8?B?M2lpWVNBM2hHTkRlSGtnV0ZWQ3RPWHVSeGY1UkF0NGNRWnNySjVXZGEzVElZ?=
 =?utf-8?B?VkZGWTRvZFU2UE1YYWQ0WGFjSjlhOWJnUHJuOUErZFkwN2JrSmlKQnRUcVRJ?=
 =?utf-8?B?OG12UnpSNTd6WTJGTXFEWWN1eTgvUFhoU1pIcWdSTUhmbEhycXZ3MUZNWURH?=
 =?utf-8?B?R0tKbDJwdGdiZFVFakJPWGZ2TmY4eWs4cUduenBsRE1IUmRIdFBENVNnbGY3?=
 =?utf-8?B?Zjg0aGxUUHNpSDZBTlZFeXNxOWtneXZiTFJsWVlweHFGTjRHZlFIeFV6cUVk?=
 =?utf-8?B?MHppZTZMTkRmVlErL0tyU3c4RzkrSE9LT0RFUU5kNElSZ0QvTzRDamQxMFYv?=
 =?utf-8?B?d3dvQ3R0Zm1WQWlobEtGWmhrZDRrakRPbXQ5SU1vaVJEb0w0TU0zWkJFclVK?=
 =?utf-8?B?NmRjMXgxdEJLWUxXdWc1QXZKNTRtNDBoNXRGVVJYT1hZMDI0ZVZ5RllxTUpK?=
 =?utf-8?B?Tkk0UERTcUFBUVQ1V3JoSGM4bkpRK3FkMVRocC8zSC9RNWluTkVTTUhhSEZt?=
 =?utf-8?B?MWJuaDJ5a2hiSVhDdk8yeU4yaE1Pa3RxbTNIT0poZStBTzkyZmF0MjZ1ZTc4?=
 =?utf-8?B?b0U0RzM4TklpSlhLWGgrNTRCUHJ1aWUwT09hNnpnejRDc1p6ZnprS2hTUGpR?=
 =?utf-8?B?ZzdqK1NTNmFmcmRRRDlNb2lXNnoxTytrZU5OYjdpUXFoSlJGUEN4MHVTbFlG?=
 =?utf-8?B?NlBoSHlRWW9kKzBDNWc2cXhrTXFpd01SdnBtNnovRC9hdnVSWGdzY1VOUUQz?=
 =?utf-8?B?bUpOS01oNXVVZ0UvVTd6OWZaV1RMOW9KUTVXWHdDdXN6YXhOMjFNVjlDQmln?=
 =?utf-8?B?dUgzMUs2eTZ5Z0FER1JpU2ZndDFhNWpRWE8rcE9Jd1VuSkt2Qk5NREhsbVRH?=
 =?utf-8?B?bk9VQ0VBdTExTWNDa1g1RE1IaEtCYjlmY3pKRjk4YWpQYjZtclBOOGVURnhT?=
 =?utf-8?B?cUhwNktjMDU2TXBLbi94Z001TkNLMURpbUlRZHQ5N3ljcXVoMVFITExIcFhY?=
 =?utf-8?B?bHRrMWFwOGpVMURydUNnUjZpK3JGc2hBK2xOZ1FtaG54dk5ULzJidXBLNUFi?=
 =?utf-8?B?WEppQzFyLzVwMk50STJITTQ4cE8yUTNSMW5vdHI2ekJ5RTdnUEZmRWRkUE5j?=
 =?utf-8?B?V0RTT3F4aTNYT1VsdDUxbGdUaVdudFpwTmlYcXRNakpxMzB5Z0d6ZTd1ZEtt?=
 =?utf-8?B?cHk2dlpTV2pLWEc4bnlna0hyejhIV2F2UWplRk45SDQ0MlhubDVVSU1jcUgz?=
 =?utf-8?Q?c7m5QOPp0Hpsy3zCdZMyEsI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95bab9d5-ec64-4ffe-4e3f-08d9e6d4a57c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 05:18:43.7384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9gs/T1tPD5BxR6YefsHF3oCwFZCWGMV+ni1V/al28PrHLwQWwejVD9MsWb8eVHsij3HYIB0KJhZh9YSpEIYfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim,

On 03-Feb-22 9:39 AM, Jim Mattson wrote:
> On Wed, Feb 2, 2022 at 2:52 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>
>> Perf counter may overcount for a list of Retire Based Events. Implement
>> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
>> Revision Guide[1]:
>>
>>   To count the non-FP affected PMC events correctly:
>>     o Use Core::X86::Msr::PERF_CTL2 to count the events, and
>>     o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>>     o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
>>
>> Note that the specified workaround applies only to counting events and
>> not to sampling events. Thus sampling event will continue functioning
>> as is.
>>
>> Although the issue exists on all previous Zen revisions, the workaround
>> is different and thus not included in this patch.
>>
>> This patch needs Like's patch[2] to make it work on kvm guest.
> 
> IIUC, this patch along with Like's patch actually breaks PMU
> virtualization for a kvm guest.
> 
> Suppose I have some code which counts event 0xC2 [Retired Branch
> Instructions] on PMC0 and event 0xC4 [Retired Taken Branch
> Instructions] on PMC1. I then divide PMC1 by PMC0 to see what
> percentage of my branch instructions are taken. On hardware that
> suffers from erratum 1292, both counters may overcount, but if the
> inaccuracy is small, then my final result may still be fairly close to
> reality.
> 
> With these patches, if I run that same code in a kvm guest, it looks
> like one of those events will be counted on PMC2 and the other won't
> be counted at all. So, when I calculate the percentage of branch
> instructions taken, I either get 0 or infinity.

Events get multiplexed internally. See below quick test I ran inside
guest. My host is running with my+Like's patch and guest is running
with only my patch.

  $ ./perf stat -e branch-instructions,branch-misses -- ./branch-misses
   Performance counter stats for './branch-misses':

    19,847,153,209      branch-instructions:u                                         (50.03%)
       950,410,251      branch-misses:u           #    4.79% of all branches          (49.97%)


  $ cat branch-misses.c
  #include <stdlib.h>
  
  int main()
  {
          long i = 1000000000;
          long j = 0;
  
          while(i--) {
                  switch(rand() % 20) {
                  case 0:  j += 0; break;
                  case 1:  j += 1; break;
                  case 2:  j += 2; break;
                  case 3:  j += 3; break;
                  case 4:  j += 4; break;
                  case 5:  j += 5; break;
                  case 6:  j += 6; break;
                  case 7:  j += 7; break;
                  case 8:  j += 8; break;
                  case 9:  j += 9; break;
                  case 10: j += 10; break;
                  case 11: j += 11; break;
                  case 12: j += 12; break;
                  case 13: j += 13; break;
                  case 14: j += 14; break;
                  case 15: j += 15; break;
                  case 16: j += 16; break;
                  case 17: j += 17; break;
                  case 18: j += 18; break;
                  case 19: j += 19; break;
                  default: j += 20; break;
                  }
          }
          return 0;
  }

Thanks,
Ravi
