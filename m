Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D104A6BD9
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 07:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244814AbiBBGwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 01:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242573AbiBBGwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 01:52:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20629.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F24C061771;
        Tue,  1 Feb 2022 22:32:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AocUUFB1ovmkjmyp5lqxlX2HocwLjDdtn7uLvr7Vqc1bnfJHbIMkzhlIwu7XE1pCauckElHGF/Fkf6mcTZPhfByg4mYHXcW2isssNW0U+hKT4h593NTZ/5586evZ1wTRmUPw216j4vagKQ2+wfGjJKICw2cdA8A4odWe6u7YxdeDz+Xl2EdchXnITHZXuAkbhKQR3QCdxp3yWFHCXsWA+J4XD3a96HOqqq3+tAgHmn9mMUU5SdBMFvMpSzT0FSVAcJJXQ6wLFd4/PkE+UdpWsHO9DPMkdPCm8DzejJ4+LDgIEEqpgd1JaD5McOmRYtQXucmE/PU/sYvH3a5BhMXVHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBgbCMApwUupetq8hl1SB+E4sHJ5i5YWAqJHO5QLBjo=;
 b=Fon0gAA6Jks30cfuzkwrE2LSfFHnd7H8x6dqmDAnuVRnv+V+Z+u/qtZqVe66iaMz90lPm+uErAaJeUDDRX7r7tu1XyAVg+bylDOROWf2gEJ/qKIjz+WZ9WS2UYvJdPseSNxeCATNRZW2mIl5IavGvbDvJboKB/qHW2RW8Ucc13NSIvUNovxjQcybwvwwukoTb6jD0UYnjmAjTeb25fQ4nCFYkwAOPAnnfF1tiJNVUQCoOLNPcP4BO7xTu2wRQMwnJTSxflgxLYJbVZeOBL7iUJv5G8Z3vdfWmZHUn8j7qwYXyr0lrnllxvgt+tPE/EcOQQ/xRiNwvlScuYnDveyJ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBgbCMApwUupetq8hl1SB+E4sHJ5i5YWAqJHO5QLBjo=;
 b=xRYnLyIRpuc1KewgBIuk3Pp+wn5LzmgYb+pkc1bdvX/YsttzNgA8MwKxDWCfZJJ4RPv9V3z49MN7/cASjRYElt2vRt1ITA5Zl3beMJBus+pNb2P+j6daCpwO9IJGpnzTHCKxqQHhSk5/OX3ueUXKNd/aaMSNqWmKZ1QMTCBbdb8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by MN2PR12MB3024.namprd12.prod.outlook.com (2603:10b6:208:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Wed, 2 Feb
 2022 06:32:48 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc%5]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 06:32:48 +0000
Message-ID: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com>
Date:   Wed, 2 Feb 2022 12:02:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] perf/amd: Implement errata #1292 workaround for F19h
 M00-0Fh
Content-Language: en-US
To:     Stephane Eranian <eranian@google.com>
Cc:     like.xu.linux@gmail.com, jmattson@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        peterz@infradead.org, mingo@redhat.com,
        alexander.shishkin@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com, Ravi Bangoria <ravi.bangoria@amd.com>
References: <20220117055703.52020-1-likexu@tencent.com>
 <20220202042838.6532-1-ravi.bangoria@amd.com>
 <CABPqkBQOSc=bwLdieBAX-sJ0Z+KwaxE=4PGXuuyzWyyZKf2ODg@mail.gmail.com>
 <4662f1dd-d7dc-ea19-82dc-f81e8f3dcf1a@amd.com>
 <CABPqkBQXvkqArcrXKVweWCobcaQZBRV6t3AhFuW8X28MBRkqBg@mail.gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <CABPqkBQXvkqArcrXKVweWCobcaQZBRV6t3AhFuW8X28MBRkqBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0028.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::14) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a39f697-e017-4f71-8060-08d9e615d40f
X-MS-TrafficTypeDiagnostic: MN2PR12MB3024:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB30242F82BB3542A303E98FFDE0279@MN2PR12MB3024.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PrJRT0ce7B8QqCac85KQP7IK0zqoLv1awmPvF4AmvxZvTqS9by6Bbdy7i5QAB1QFtfo78zxkX9591PcBxqWGlveqttv33fbPlTvvb5IBMMQvKfFt+BGhfQ4t8RWuRLAVvZkcKjphXU0dkhsijoJol/GE4SbDip6PZn22COUlv0UhPC8pMQds/FsPcyTsrJEh78NGktwgT1yn/h6EHzwJzVWj/zIeLrA69e2ShGV2x/rOKigQ/Uhg4/oaH7d9CmIN6jzdrIjVZUwP3fces+tBxY9Qwlu8P5sRjRZ6F6B1CS9inSbqo2V9X2+xIfzIpD9hSnzE1sDV7LCXkPFc8GZ+apWT8RZjeeZG5vr5NvtGOQ6e100N9TUl3O++4rCS036l+DckUjSer/ZYkU1hX3JZxapGMwKj1E1/p/L3hGjbCygFrxFQCGD7g0bpYZ2R4tMN6TuWbf/pVuovWRL+2JotD8t5jvPwNuZ00gyjaIE5LGnr5l741MgtX2OyoNGqucBkf0v7iAHIigSEtMu7SlVRfH3bOq0pFidRKntTsdiFQ6gDesQ1uIDlmm5myEf2hBtS41P2pbe3VhMS4nMCaSs336nuvwONcDFaigQeN6Q7uN19aPFYD5aCeqaV166Q0vcBsieZI+dgRcKe4T6DZI7EDe18tYnFb0bNeZ2iTgxw8Ae4ennWZNVv9Ek1zWA0zqds5m73dZ5BEbzt8NA7FzcPTUQnnyICwwP3T4i5g6xQIY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6506007)(508600001)(86362001)(31696002)(66556008)(8936002)(66946007)(6666004)(66476007)(8676002)(4326008)(53546011)(6512007)(5660300002)(6916009)(36756003)(186003)(6486002)(316002)(7416002)(2616005)(2906002)(44832011)(26005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em1od2h2Z2tKb1JZWk9kQ0g3RWxudHF2MUVWM0xYaGxOTGNZNVlyU3A5OUxt?=
 =?utf-8?B?K3I4Tld4cXZIQmlqV2kybEVaU1JKN1BVSmFjY3hYU3A5N2FrUEwxamlicDUv?=
 =?utf-8?B?QmlhVkczbEJlTEFIMGJuZTY0VGNPTG1SUnJXKzJCSmhBTzlDZzhzbEtNRm5N?=
 =?utf-8?B?b2N2U3VrT3kwSnNDdVQwdWdWaVFYTGZrb0g4Z20vMWp5ekhwY2JjMmhCczlQ?=
 =?utf-8?B?bWM1bDF6WTVMODlYTVp1WUZMS01lbkxLZjRlNGtZREFRb3d4bzlXaFFYbVlw?=
 =?utf-8?B?MkUzekY4VTE5S2ZaM2FMUXdrN2FDR3RaUnUwTTd4eDRsTUJad0xEbUhRcmlK?=
 =?utf-8?B?ZVplZG94WC83WmY5KzBzdVc4allibWRKTkZUSUhhTks5a3BtTTRGb2xGVVky?=
 =?utf-8?B?bmUxOGJhL1BOQXlnQTdvb05PWWl6Vnd4OU1SWjVDdVVtd0xUM1RkR1ZEU3B2?=
 =?utf-8?B?c0I2VDdTUlJxblIxNGlaeGRJd1VvbXlUUW94YjdRdGFDRjhuL2IwNHd4WGlj?=
 =?utf-8?B?c0xrTS9FYjlaS3lRUmFhKzdZSEVJc0Yza2ZpemVsR3dqb0l6bjV0K2U0OVJa?=
 =?utf-8?B?cTZMbG5YUXhrNWpCL2ZEM3krbjMvbzEzZHUyTXIyT28vRlFVYm44bnB5NGVn?=
 =?utf-8?B?MExXWUpxYytBNW5velc1b055K1h3Y0Uvd3ZMMk5na25nb3BBYUZXRThmQ2M2?=
 =?utf-8?B?NHpJUHhwcXh4YjRONCtjL0hPMGowZk1mZU50dHArcGJoYzl2MnYrM1RjS2hs?=
 =?utf-8?B?b1c0NXo3QWFEeGd5TVNkMDdwMFZJcUcxekNIYUJHL0Vma3ozbllkVEpYMVYz?=
 =?utf-8?B?R09sb3FwUlFRNk8weXdmc3F2NGZCanRoWGhIaUZBTmxSVHE2UXgwZTVycmJm?=
 =?utf-8?B?bzkwUnNzQlVFSGJFN01WQVdaS1JleGQxaExqTzVVa1JBSkJQcFF6ZUxRYytI?=
 =?utf-8?B?dVUzTHgvTTVOWFdKbnBibGE4SVA1dUdnRGc3N3ZBaFBpZWpPYXJxdFZlOHdF?=
 =?utf-8?B?MlRqc0VPMjNOYjZHaGp3a1hKd3RSbHRpaUVYUUFZNmlwZmNxYk5qWFg4eU5B?=
 =?utf-8?B?NWJ1WUFRTythek5xVU5yb1lHV2srSzJVSkV4VFV1YVE2amxjUHdDSGt1ckto?=
 =?utf-8?B?cVFhdmFLbEd3Y2lIQ3Q1cmhKVXdMTDNxL0tBQmJWZzJoakFtMnVKR3F2SElN?=
 =?utf-8?B?bHJIRGtibEttK0l1SnJxeER2aitaY0tOMUJWZkRvL1docEtQWDlMZXJhUE9I?=
 =?utf-8?B?ZjRRMm1XSDNJL0gzMWF2YnA3bitNVDA3cUw3VUtGMDNuRWt2UVRPRGc3aFRj?=
 =?utf-8?B?NW5jTHRHUEVsYnUzZTBHdVJSMVBGMjl6NjQ0UCtKU2JTUXZPblFkajNuZytS?=
 =?utf-8?B?YjZiR2ZWcDZiQWtXa0pKWnhjUW14MzFJOFVvTGwrYTh4anhOSExJa242S2lT?=
 =?utf-8?B?blFKc0FBUnVEaVExWWEzUzk0TFI2dndydk9leXc5N3JhbDIzYUh1QWVvdW9j?=
 =?utf-8?B?TFp2alNNVjhvNnVQbDg3OUI2VTVyTHNwMVNYMlZUTG0zOFB1cW01bnBjdUMr?=
 =?utf-8?B?d2oybEQyNEFvdEI4WnlJQmg4cGYvY1IybVJNTHk2U1YvUEFnNUMveVpBbEpq?=
 =?utf-8?B?T3IvQUNOY1FVSlRYbDNoUVRlUUkwU1NBbjBuREI0MXJZMmwvcjM2a3I3SDRW?=
 =?utf-8?B?RjNsTTRJL2ZZTXhiWWtNMnk5RlpwT2taNFJTaysvdlpnaVpIRXlCeGR4QllZ?=
 =?utf-8?B?bk1kTDB5S0tHVXVtZHJxZjltYjlKU25DUVZvaFlRcis5NHpPQ3l3ODZpeWNZ?=
 =?utf-8?B?QmQwU0hGQWk2UURiZ0dHK2l0ZTdqZkxKazFMQm5JbXJCZ1owa3RKUXlJSkFh?=
 =?utf-8?B?YWhvSUpTOUxlQnhIdTdvSElHZ2pRUStrNmFBMmV6L2QxQkJENDZmS2ExQkM5?=
 =?utf-8?B?VUtqL3FpOUxaMnh1RWhZSnZ4d2o0RUs1OS9UNlQ1N2Fzb0hjVjNOSW5UUlk2?=
 =?utf-8?B?ZDR6Q2tZNFJJQUpMZmZZTVpVREVyd2hSVm1jNDhvbGhCL0oxNDR3UU94YURn?=
 =?utf-8?B?OFVXQ21YVlBpK21wTkczVjhBR3BPSm1QWTBuamVKWjFzcG9QMkpPMTBjMWFu?=
 =?utf-8?B?ZmtEMjVTMmUzL0N6aXhDVGRSdWRSZTQ1RVdnT050TWQwUnNoRGlXTk5tSjZM?=
 =?utf-8?Q?LmAN3Mm4T4MdsJ2XTrtN450=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a39f697-e017-4f71-8060-08d9e615d40f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 06:32:47.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELVPTyCW7IJqRQMpO2igddM0+XJrPRV+NS2+CI8oimNmd9qa6FnoSCXFAObh4xur4t2y107elVdP6I8QaWw3ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3024
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Stephane,

On 02-Feb-22 11:46 AM, Stephane Eranian wrote:
> On Tue, Feb 1, 2022 at 10:03 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>
>> Hi Stephane,
>>
>> On 02-Feb-22 10:57 AM, Stephane Eranian wrote:
>>> On Tue, Feb 1, 2022 at 8:29 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>
>>>> Perf counter may overcount for a list of Retire Based Events. Implement
>>>> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
>>>> Revision Guide[1]:
>>>>
>>>>   To count the non-FP affected PMC events correctly:
>>>>     o Use Core::X86::Msr::PERF_CTL2 to count the events, and
>>>>     o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>>>>     o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
>>>>
>>>> Above workaround suggests to clear PERF_CTL2[20], but that will disable
>>>> sampling mode. Given the fact that, there is already a skew between
>>>> actual counter overflow vs PMI hit, we are anyway not getting accurate
>>>> count for sampling events. Also, using PMC2 with both bit43 and bit20
>>>> set can result in additional issues. Hence Linux implementation of
>>>> workaround uses non-PMC2 counter for sampling events.
>>>>
>>> Something is missing from your description here. If you are not
>>> clearing bit[20] and
>>> not setting bit[43], then how does running on CTL2 by itself improve
>>> the count. Is that
>>> enough to make the counter count correctly?
>>
>> Yes. For counting retire based events, we need PMC2[43] set and
>> PMC2[20] clear so that it will not overcount.
>>
> Ok, I get that part now. You are forcing the bits in the
> get_constraint() function.
> 
>>>
>>> For sampling events, your patch makes CTL2 not available. That seems
>>> to contradict the
>>> workaround. Are you doing this to free CTL2 for counting mode events
>>> instead? If you are
>>> not using CTL2, then you are not correcting the count. Are you saying
>>> this is okay in sampling mode
>>> because of the skid, anyway?
>>
>> Correct. The constraint I am placing is to count retire events on
>> PMC2 and sample retire events on other counters.
>>
> Why do you need to permanently exclude CTL2 for retired events given
> you are forcing the bits
> in the get_constraints() for counting events config only, i.e., as
> opposed to in CTL2 itself.
> If the sampling retired events are unconstrained, they can use any
> counters. If a counting retired
> event is added, it has a "stronger" constraints and will be scheduled
> before the unconstrained events,
> yield the same behavior you wanted, except on demand which is preferable.

Got it. Let me respin.

Thanks,
Ravi
