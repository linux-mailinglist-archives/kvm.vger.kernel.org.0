Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E3E4A6BD2
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 07:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244876AbiBBGwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 01:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244789AbiBBGwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 01:52:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2937C061749;
        Tue,  1 Feb 2022 22:03:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5hm/cSdXxAH52vUiR0YCQrsmuxkjWioywEo/SAvi2/TDqgXJu/nW0cN0vBNPrKIHg0mAs1VfgMFEQ4PP5hgdObFQcZVS0kOI5d5yyDIZDVQaQFqwSrpqr0AWr941PPlBwWrEZMP82rjeTOomwn0+8wk1doT03n0emmvn3Aju2e12A44DIOoRBjvMufTsdPRYwSlr/K0jSLRzYebVYzM6tl/6kCsn/NQcmjIehlrZ5y8x1Um28iUIz5fWg8CxbNSkNjEQirXUnxVt50f/NFC6LG2pGPijAp9heiDFWKi9jCNIUxVmZ+uJ30QyKNtjB+TKXbw1Vh/N7Zhyh9TJmah7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9NiZj2YCPKX4wzccuYgLL47N3iNBGD1VEVtjHQLN2E=;
 b=oKbdhnltItaB6Eh0nmInOwDADSndi25bpi04QvDplcsS4t8x5Q5OokTnRZWTOdzSw9pswUrmba3sMRTZzFZT+H2wgTqHpQNvPPWQo3Vj7J2fWIuHQqbHwxh6CDsE6jm9ALVC7LEqjBVz2sT0Wh3TgvfHFJc1M+AL3HrqddmFPNgfJUvXLNoKDmsQrP/wvcUEAnGsA8ZVvij983gxLm8d5dSYTH56NX923NImTlk5iWAdBbNefx2ii/0yELtdVcrXLoTerxb6wnsrkzrYzaQ92SNUYUCfJ7kPauHhf5TnY8RMyi/tfiMIuNl/QY44ZQ/2jYqgisauVBuTMpnCOR9gXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9NiZj2YCPKX4wzccuYgLL47N3iNBGD1VEVtjHQLN2E=;
 b=QvFt/cxRL0nKTF5QJWIYQEhiC+kUMTJKVuDoeM6Xbcy9GocKRAcxc4Rl7ZxA4WXnJ+s9awGuhtLFyprm2L+JldD09+aTahas9nyoI+MDTRklReWrA6FVGQ8L/uYIZWoM3X0Gr7OnEm+LvXCQAJNbZFsNJWQMXJjDclJ/EcT1PDs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (20.178.241.216) by
 BY5PR12MB3956.namprd12.prod.outlook.com (10.255.138.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Wed, 2 Feb 2022 06:03:10 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc%5]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 06:03:10 +0000
Message-ID: <4662f1dd-d7dc-ea19-82dc-f81e8f3dcf1a@amd.com>
Date:   Wed, 2 Feb 2022 11:32:47 +0530
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
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <CABPqkBQOSc=bwLdieBAX-sJ0Z+KwaxE=4PGXuuyzWyyZKf2ODg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::11) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19070653-1288-43b9-19ef-08d9e611b03d
X-MS-TrafficTypeDiagnostic: BY5PR12MB3956:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB39568CA90860779CB282826AE0279@BY5PR12MB3956.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9kJwpxRNCuajctBjKIcW1+wt/A8LY81S76SeEerEWcr+50k5gvXQwqxEQcHPlHfHd5WxOfbASzA51xa8Dk2MVA1ckSIrwEpBPvMRFDrC64uJ2A73M3q8j2JeHhfBtZ/cotQy2PTDv4ifqcQvR5b4v8kvta+DCUUhOHf/G9a0xX+TT3QMGTfT1vkiVAb5lTzlsVyxtMN1UGFR2Kv6FONJ1WX9N0x55DGR4aSrjeWtZdGJ3LjO2F2xyEgHVKS94vS1+GcDzQbpwPLckBcg6Ld7+jJ9NMDIHYAUUYEXHBVE2niC+1YeP8ikAf+nRh01//w6ZqN0Ww4ogNqrCepjp+SVrfdhES44A3ubVSzx4rVCf6+nGipRy2TuBGFTRG2uIlAikEmJIrp3+XJJlOYONQA2nnkYrOPLpqOIiU6d/bAta2omTIsvYoxlytusgZo/EWjtqEoRquxgpUXRd4rqRAz01eoKdiYjcZ6d4tLw4Xj7KA16KAY6adAda6QrJ2gBdPGGS1Ns2PS/wOo6UpjWJZFIE4yGG5dKieXeclv0ib1mkJmRg3FXTtJPNoDBDt1hN9ozW1Yp0KxhscztZDIw780FpAf1HG3ZPuXtt5IjRK3MSfc24sBKS6Ibi5VHQPkRVnRO6Dum37QHnEQCMZRFjcPl7f8zdZZS1LIsbAWoT7Kro1Jkb5PDZpOWsV+mCv7ERzQHLRiZmvC3TbndzcJnVMbSxhLkeXMi1+TMSEa8Fy2C/ik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(44832011)(5660300002)(6512007)(6666004)(316002)(7416002)(2906002)(53546011)(6506007)(26005)(8676002)(6486002)(508600001)(36756003)(4326008)(8936002)(6916009)(2616005)(186003)(66946007)(66476007)(66556008)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rnpva3FTQmV5S3hRaXZEMTc3V3I4N1B1clBDWEduUDlUOGgreS9UWCtyc0Nu?=
 =?utf-8?B?WGM3SlF6ZXFTcklPRUd4ODUyaVJ2SzNuRW5naVh1SHZzVnpBWjdpcHZpMXoz?=
 =?utf-8?B?Tk9tWVJUbUtCOGd3ZkVDMHhpNzZVN0J0ZnRObjk5WXFTNFhJWU5WREIzb0pm?=
 =?utf-8?B?cEtYTGs1ZDVGeGRicDVJbk5qdk9IWStTeDloL1NXTmtlM2oyTWh4ejdCd1g3?=
 =?utf-8?B?RXBVMUN5ZnJXNEdsUnlFaTErVEFSV0F2UlpKSzQ1TktKVnRrNFJSSUdCamVJ?=
 =?utf-8?B?b1hyYXFiNitsSW9FMjJ4Zkg0Z25NQ29aMXRnL1NHOEpYMW1RTllEdGg0S0h5?=
 =?utf-8?B?THlQWVk0ZEoybHRpRDZFYzgyOGxwaStEa0pVRzNKcVBIUGQxeUw1Vmt0MnVt?=
 =?utf-8?B?RnlIc21wNWFSTEQvU256dGVYNlVJKzZkU3hFWXFTUUJXeXVHQ1lHU0ZXSGdU?=
 =?utf-8?B?YldESHFXbTY0SWhlQllTWk5Qc0tVRVpBcjNNRjZ1QW13RnBuTjNOQWFTbmt3?=
 =?utf-8?B?Z3h4S1M0cC9tQXpxSnNlN09DUGI1K1k0ZHpJb3M2anBlRndza3FBclRrejVJ?=
 =?utf-8?B?ZUJIZTlLSkRBSGlGTUlVb3NjN29zQmhXK1JVWUREakthVW8wYjVPa3czem5Q?=
 =?utf-8?B?UmdJV3Y2TE8zSEJ3MnFPMnBBMjZhVG1Ta3lRSE00ZCs5OUx3VVN5dEl6Rmc3?=
 =?utf-8?B?VGEyMDlFa3N3WHdKMDlScDZOQ3VOSEx1WnFFZlFVbTIrSmZuazFrY2tGOHFL?=
 =?utf-8?B?WHlhdEwzUU9iZXBYcWZJVlBqQVZIb2h1V0IyZTB3RlNsd2EweExtRDdmcDh3?=
 =?utf-8?B?QTNJNlhBR0lwRUpyNHNlVU9hV0J3aDFPRVVuaXZhNTZEUTlTd0RtR1BrdVpM?=
 =?utf-8?B?RzNERTdRN0tYMnowT2xNN3NOYUlFcnM2Mzl1Y0p5S2JGR1JWb2VGMGxuRHg1?=
 =?utf-8?B?T1NkMzRPSXoreHdiOEJML21UejJZMnlQL2FCSG1EMkQ1azBuRmJZOWc0QmVl?=
 =?utf-8?B?c1RJTklnRkZRSnVPQU9PcHcyM2NyaGd0UVYrY1YzNHRJL1hLSXRLanh0SUpv?=
 =?utf-8?B?QWozS0lLam1NVmhPY0VVdnVpTWhWVGRxeThBRVNvRlhvYlZ4aWlqTmhEMWV0?=
 =?utf-8?B?QWhzaWx1cVBmMjdqc3kwcDZFS0R4WGJSMzd1VEN6TE9vWGdBbThlaFZIUWF4?=
 =?utf-8?B?b09GVVNmb2paKzdwQUtIdWl6SUU4S1ZmWSs2cC9neE9jd05QN2x6NTEraHlQ?=
 =?utf-8?B?c1ZMRnZaNTVHUVJvVUtlVDVQZmpZbVVCYXZZNDFCNHhxUm1BSmxscWJCdmQ3?=
 =?utf-8?B?a2o0Y01JM0JrcjZ2cjk4b1ZmN1h2Qy9BYjFVb0Zwb3ZWWnlPV3dBd0NhWUVZ?=
 =?utf-8?B?azI2UGIrTVhFb092QnRQS3VRKzZtU1h0ajZRMmR6clJPL3dPQTFrbjhucFJi?=
 =?utf-8?B?Z1pMTlMyNWpGMklHUnExaDI1S3VIZ2dhYmpKT3pDZzBZa2dQZkYvcTIzdy9Q?=
 =?utf-8?B?Tm1oM2huNEVYa0tpMmxXcDhRZmQ1VGUwRzZHdnBTZ0I0dG5uNHoyalhhU2Jr?=
 =?utf-8?B?V1J2VkxHUzFGN1B0eXdOMnpOT0F5Y2tuMzhrVFZmeXArN0pLL1NMSVdkSTVH?=
 =?utf-8?B?U0xyMGR6MGdoUm1KNlBzMTkwbzBxMDZ4TzNodElDTU1GYng3N1BYalZVcmlS?=
 =?utf-8?B?L2Z4VXVTNmRFY0NBMFROUVYra083dHpQbUxyMWNLL1VEUWx1WndacVljY0lk?=
 =?utf-8?B?bm9GSG1BZGIyQk8vU3JXaFJQRit5bi9QMy9iUEVoNWc0bjVFaVp6TzNVTy9l?=
 =?utf-8?B?UFNPdWs4QTJURStIRTNQSm41T24zZWtBZE9RTUw4V2J0bkNqQ09zK0tqakhP?=
 =?utf-8?B?cVJlZlJmOVlpdVFTUVlSNFlmdytrRnJnRTRaWkkvdDNORmo5cmFzMGhUWE5B?=
 =?utf-8?B?RUIwQWJvQnpsTG5LajlhYnJIdTNFd2E5eTIvRmhkckEweGg1VDVVYU5KSmNL?=
 =?utf-8?B?Y2VGamM2d0gvcnpPeWlMYy9uQitUQnNtNCtJa1NwU1IxRWdoUXRNU3NYNHBy?=
 =?utf-8?B?a2JOU1pqb0pHLzdwMVBVSHpxQjNvcmI4MFJvOC8zc3N5TDlLd0N6ZGprVDh6?=
 =?utf-8?B?d0RIVnY3ZTJGOXdOaHptYjNDQ29Fc2U1MXlwTFN3Y2tBc1ZTYlBmayt4SFVM?=
 =?utf-8?Q?btYmsckLRx32P7QMqjNHnxE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19070653-1288-43b9-19ef-08d9e611b03d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 06:03:10.0106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nr64zJ73m6XXxuqnjbWDuWpc2qxsCvTn3JpAvyAEOJH7ap1g3GGr6+P5EwqetzcMxHKczWfN7aqELZjBgXe8Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3956
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Stephane,

On 02-Feb-22 10:57 AM, Stephane Eranian wrote:
> On Tue, Feb 1, 2022 at 8:29 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
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
>> Above workaround suggests to clear PERF_CTL2[20], but that will disable
>> sampling mode. Given the fact that, there is already a skew between
>> actual counter overflow vs PMI hit, we are anyway not getting accurate
>> count for sampling events. Also, using PMC2 with both bit43 and bit20
>> set can result in additional issues. Hence Linux implementation of
>> workaround uses non-PMC2 counter for sampling events.
>>
> Something is missing from your description here. If you are not
> clearing bit[20] and
> not setting bit[43], then how does running on CTL2 by itself improve
> the count. Is that
> enough to make the counter count correctly?

Yes. For counting retire based events, we need PMC2[43] set and
PMC2[20] clear so that it will not overcount.

> 
> For sampling events, your patch makes CTL2 not available. That seems
> to contradict the
> workaround. Are you doing this to free CTL2 for counting mode events
> instead? If you are
> not using CTL2, then you are not correcting the count. Are you saying
> this is okay in sampling mode
> because of the skid, anyway?

Correct. The constraint I am placing is to count retire events on
PMC2 and sample retire events on other counters.

Thanks,
Ravi
