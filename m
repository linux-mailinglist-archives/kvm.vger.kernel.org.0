Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D5949245B
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbiARLLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:11:35 -0500
Received: from mail-mw2nam10on2065.outbound.protection.outlook.com ([40.107.94.65]:6273
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234061AbiARLLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:11:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGUJZ/L70Q+qRTh3lAmXBh1I/N0U0D9SFWC3t3M8jHV2L1fbCNV7FeXUclMs4PMlMsQh1p6s9l0mUVzoiIBbGxL6p0Z5HwcDPn/I+yw0dXHjTSLgJIiz3DD5FUrhJMS3AsD+g1swsP4vH6uKP5aEXtxsdrvLxBMNFyEYUjAVAp72RExd0dgJrScdJIwQ0uzCxX79SQaI7B18I/Xm56mmsa3tfacpmaWugjkCela/Enauk3FY+hAtt5kJV+7oknTgycWJBfedBFbiNNGi7TYvaWRPorAy3r9GKFwrx8ZImID2FJ0+dPGa3KRgbCGifTsdG/8lmAsgOl6EQq85WJG9Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tl1pa7Sm/HW98b2Gif9DHedW63B7JRSaHCYvmjzXzEs=;
 b=BAW5Ky64IhMwvvR7LWoFmykqc5F/78c4Sxjj7RiXZjrAkDWtFA6Od9DkJYmS3mgcBt6urMk/Ub9fu78BFiCe1fyUkUTpTv+7UPagvx4jbsyv999R0TYu/e923ljsjunpMkSlpRN3BOP13ZA8oOTYFWAu/f5NQiceeqiYGw7N5P3FLXQSDlGXzZ4qB4/3HqrXCj7YsvJZDLEt7j7o6AAw71DiUroJa+DyTQTiDIFSRNWTjsb/1hv3+yNdwaCAfcYuVc/Jg73D7QlBvMxSCPuIC14kSABX5rOh6nY/j6EiP+RymwG7fE4G4WnNg6OXSRmHUOfiSusFBWPIoSKMQF5NGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tl1pa7Sm/HW98b2Gif9DHedW63B7JRSaHCYvmjzXzEs=;
 b=hU7q6oSPATdi4KvSAAuY7yYU/7TP+vE9nKXExxjCz14Bmcf84cIVER9LyPsCwHtEvaKHG64Re8KJhUl3Hio2nM+6CUVXxkhtnsSd7XN7xXH0NBxBV/8KD1tmehZfBq8W+t5rOBU+rJm7pCI97hcHnSBu0t/giIKMVD2Nax7DzGI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by BN9PR12MB5242.namprd12.prod.outlook.com (2603:10b6:408:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 18 Jan
 2022 11:11:30 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::802f:ed0d:da05:5155]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::802f:ed0d:da05:5155%6]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 11:11:30 +0000
Message-ID: <aaf59b12-4537-8f3e-6c7d-de2571630806@amd.com>
Date:   Tue, 18 Jan 2022 16:41:16 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [kvm-unit-tests PATCH 0/3] Add L2 exception handling KVM unit
 tests for nSVM
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Cc:     kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        pbonzini@redhat.com
References: <20211229062201.26269-1-manali.shukla@amd.com>
 <Yd9ITZv48+ehuMsx@google.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <Yd9ITZv48+ehuMsx@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0013.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::9) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4efd9651-a218-4cdd-85cf-08d9da73473e
X-MS-TrafficTypeDiagnostic: BN9PR12MB5242:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB524242657B088490B7CC66B4FD589@BN9PR12MB5242.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNpFddamrDHGI2H2Mbh9zAcYC4+kWUTWFF+BEvfbgMyeQD0Ja94a2UJUHQDdhntRqKGJBwE2tn18n9MJxV3XxIQvZJ8KIWnrVQtTcRk+yz9CdLWamdts7uNK5h66Vaxm4uYStBh/LVxMbdT1v5bi6AUjlOnYlEiLyRDJ7bmofYI0W9A3PXviPweHWVEwWNUONvDSC1c/U7xrzEfoHlfWEp7Yp6p3cGmHui+ij/sm3T439wikfWYFC7lLGiuC1/QLEbO2Q6YrY1Num0KKJS2WiYgPMTagJkSqLTrSVr1FoiAGmY+C0Ynp5lxwv88mXnXdI2pHreFWUCpKO1/1BwLUyhhbnlKciVsWedZJf9MO8r9SVAsvDfAqaFBaTkHcq9ZebyFCb9JPsPwZOFz5EmtpjdfT3g4tkBSMBTlus7wZMK5GXZxUJhO4VQ3BXOPZsoMnrxtrJ/xB0ki01ZtTBDFD8Kq8oAeIH9t8urJMj3/UWbR+VftW07f8tpYRO99oZT3iAuMWr4nJXLrNtCJUzJfft5t3pqvfRcoOYmoyKMLP5OYsbJhK3AQYHPHrp+lJkxvbRd+f4hXeKeFXVgdTbppO8XlvlrJujq7hNH6pfml2it8P0FzoLFj4NU32+Sg1wzYW79fswMfRnTSDtXJ5PxbnOyg4RKNcXGg/LCtSYedIjHWKVVg1LKZtGnpkmu4l/ApKBP5XZr01DdwHB4XUiMpQJ/1ixJBdamM6CaKxMvSVHwfgzvZlo5a7cPC5HZ+BVvm30FtQJ2tGmLs8YQN6JmkzZCZfzF3yjTPVnVA+GulFYMcrbxYmxXpWjo41ntIoHBtK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(966005)(31686004)(316002)(4326008)(110136005)(36756003)(186003)(2906002)(8676002)(6636002)(8936002)(6486002)(508600001)(6512007)(2616005)(5660300002)(53546011)(6506007)(26005)(38100700002)(66556008)(66476007)(6666004)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THgySVd3Tm4zOVJ2TlNPR1YrUGdXUXliQWVmbHdRcloxVWVPSndhbCtsb1g3?=
 =?utf-8?B?bzRoejc3VjZOekZaTWRtdXZyVGxZd1J0V1U2WHgrOU83cGxMejVNczJGUWxP?=
 =?utf-8?B?Q3FQRXpWbXFRNUovWFVFNk82MzI0RUVFT1c1ZjRkZ0tVNlF3MzdVU1F2QVhQ?=
 =?utf-8?B?UnhlNTZudGZneVQ0S21XMVp4cXdYMnBmQ2loUUtoYkpESUJSREVFMFVNSVd4?=
 =?utf-8?B?eHAxSnZoSkkwMUNubGtSQVp5RS9EY2o0VC9OcmFOK2JENzQ4TC9YNXI3M3Fw?=
 =?utf-8?B?THh5b3VzeHo5cDJ5UFI4TUE2ajhPak93Z3dub3NuWkhVaVQ0RmN1anFaM2pk?=
 =?utf-8?B?MkpZVUY2S2Z3Q2t6NG9CbGpDQXQvU1BaVTc2N3psUUU5MDhGUlpIVzVobkwz?=
 =?utf-8?B?Mkplc1Mzdi9UMHg4UDNZejJiNGtDaHVRN2tmeFpDN3Y2SjQ2NTdub1ZEZHA5?=
 =?utf-8?B?WUtOalE4UVo4bFlwN0o2UlVyVzNpTnpYSnFOenFVZHg1cHhoQ0s4MnllbFZS?=
 =?utf-8?B?U2RGUEIxZkJjUWhJSGlSbnA2d0xpUjBrbEk5ZHp5OEVVRXV1M3V4MWRhWWE5?=
 =?utf-8?B?TTBaUENOZldMcFNkczVzdHNVOXJkUWNVcUgydHI5cnNCS3c4YmNSdkVKVEND?=
 =?utf-8?B?S1FpeXU4NjBoUDAva3JLOWZPdWE1d0VYWFE5R0Q1cGp4STJFMWNJazhIS25w?=
 =?utf-8?B?dm5MZkFwR0h5NmxGdjlHUUZ6YzViZnl5LzJDRDNMc09EankrTllwaVVjT3Bm?=
 =?utf-8?B?Njh0OUNKak1hZ3hyZ2pKLzhBWjJNWlo3MUd0TkxCOE0yOVhFanZpZDNRQTVS?=
 =?utf-8?B?dTdQRkk5blUycU1Lekp3dVY1ODJjK3UwSEduSi9CcFBIcU5YNlBTeExDMWRy?=
 =?utf-8?B?WklINnJnaFFEdmVSSDlSRW1hWVV2R1h2WGh5OGllbHJFaXJOcVJPZnEvU0pQ?=
 =?utf-8?B?YUNXUGZYUklpWXZvV3AxUmxZdklKRmcrN1o1WThMZVNTcHAxL29RRlVzbmZ5?=
 =?utf-8?B?S0FGcy9BeEVqZWFSUk13Zi9qL0VRdVNkS0VST0JJMktxMXExaFBlUDFxZnVh?=
 =?utf-8?B?WTdCVTVnS3hheHo2Q0EvYmFWYUx4SGUvSjhTZjh6QUIrYnZFZS9takNCajJ4?=
 =?utf-8?B?VVdWRDlISUM1RFhMRkRwNGx1S3hIY29xODVCYk52UlNQb05DNUtRUm80Tmwz?=
 =?utf-8?B?OE5BelZKR2ovZkVUcTBiWnBzNC9MZlB0SENFU2N5Y2NCei9zdGFMQ2xSR0Fm?=
 =?utf-8?B?YWsxRHBBR1UrazErU0NGdW5PT0hPc0RWWjdKVDZNWGlKUXVXUzQyeG9DTTl3?=
 =?utf-8?B?SHdpTXVNQmw3eDIySnZ2c1NWcDBSTHV5UjVhbE9ycnJaMGxlS2FQMFFteGEy?=
 =?utf-8?B?Y0diWUY2R3JqNFVEN1piWW5sR095NWFsL2lzdmJHR0RXZjhQQ3lkdXRLYTBW?=
 =?utf-8?B?ZWgyekdidGt4NU0rZWc0SG1FY1Y1clNYb2c0RlkzbFpORDBXK3JXK3Y4ZllE?=
 =?utf-8?B?M1NoV1MrWnorTm5TcmZGU2NsYnpEVzBBQWZLU1U3UUdHUVhJSmRJYTdqWGpH?=
 =?utf-8?B?ZWx1VTBVeXNBdlZzQ040UEVTTk4raXp3VGNHQ200VGpjd1I1VmdEbjBvL0pu?=
 =?utf-8?B?M1V1Z3U2NndRK2RyNzJ0UlFaRHFSUjZKSjJjYldoUGwwRGZZaU4yUzB3TURZ?=
 =?utf-8?B?YitiQkFGeFBJeUFNRXVyK3NSYTNSZXVQRnBRdHNsNnV0M3IwdlF6cEQ5bUdC?=
 =?utf-8?B?NmxURDMvS05GSmpUL3cyS0dqbzdvcHppamRHN2J3eUJIcHJnd3A5SmFEam9y?=
 =?utf-8?B?cjY1SW5aaHpQM05IR1h1cWV3d1E3RmRTdWVvUWtMZWZxMmdWYU9aOExtb25Z?=
 =?utf-8?B?d3hwNDVyYWsrNGZpSytZZ0FsSzRJTVpWODlKSDdJcjhZaXRPUDNhTzVpV2Vw?=
 =?utf-8?B?citTYTRWMms4YW9YMjM2b1dWeG9MQ0psWkJGcUh2NFhadEF2NFk5MUFkRjNM?=
 =?utf-8?B?WTcwRUVCQ2k2S0tJRnlJbVd4MVNYT051Z3d1SDd6REpVZnoxczYxQ0JzTmxJ?=
 =?utf-8?B?VXVDNGRZc2x5RDNDUXRydFlzMllkeG1CTVhhemUvRWczZ3hwK1l5L1hhWEww?=
 =?utf-8?B?RlQ1RHE1bUcvMGRnSDIzOXgwbWZnTEkweUNjVjhwMTFocXpEcDB1UGlaYjVK?=
 =?utf-8?Q?Jz9OeHCWy3FNtmZCDi6yAPA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4efd9651-a218-4cdd-85cf-08d9da73473e
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:11:30.3821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qsokKgnAIR5ozw8ARe4FV+xfPUNHqfkBLBN/W8ewgBsoNXARs9+LSJC5vGkSZTZSrCmxPinP6Lhj5VA5RKotWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5242
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/2022 2:59 AM, Sean Christopherson wrote:
> +Aaron, and +Paolo who may or may not subsribe to kvm@ :-)
> 
> On Wed, Dec 29, 2021, Manali Shukla wrote:
>> This series adds 3 KVM Unit tests for nested SVM
>> 1) Check #NM is handled in L2 when L2 #NM handler is registered
>>    "fnop" instruction is called in L2 to generate the exception
>>
>> 2) Check #BP is handled in L2 when L2 #BP handler is registered
>>    "int3" instruction is called in L2 to generate the exception
>>
>> 3) Check #OF is handled in L2 when L2 #OF handler is registered
>>    "into" instruction with instrumented code is used in L2 to
>>    generate the exception
> 
> This is all basically identical in terms of desired functionality to existing or
> in-flight nVMX tests, e.g. vmx_nm_test() and Aaron's vmx_exception_test() work[*].
> And much of the feedback I provided to Aaron's earlier revisions applies to this
> series as well, e.g. create a framework to test intercpetion of arbitrary exceptions
> instead of writing the same boilerplate for each and every test.
> 
> It doesn't seem like it'd be _that_ difficult to turn vmx_exception_test into a
> generic-ish l2_exception_test.  To avoid too much scope creep, what if we first get
> Aaron's code merged, and than attempt to extract the core functionality into a
> shared library to reuse it for nSVM?  If it turns out to be more trouble then its
> worth, we can always fall back to something like this series.
> 
> [*] https://lore.kernel.org/all/20211214011823.3277011-1-aaronlewis@google.com

This patch has already been queued by Paolo.
I will wait till Aaron's code is merged and than do appropriate changes.
I hope this is fine.

Thank you
Manali
