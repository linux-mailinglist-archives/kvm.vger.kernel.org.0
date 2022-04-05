Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591104F21D8
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 06:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiDEClL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 22:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiDEClC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 22:41:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13392DAB79;
        Mon,  4 Apr 2022 18:45:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5uPNm0NsXOqrlyQU5yMxp2R5Os3E2ah/3bxv/N7zysBR9W/GeOFzBEi3CZounmPhdiy+9+C7KwFHQiHd1e6pwkGk36iwpxkOtP9+4ze9iWRSARqUTduN+b/6XYrXjIcOBBypaCsYy58s4u8TFklPweNIAZ2IaDyilIUagAq+cSAH0CmaHhz8J2I+gMoOlIDJ9GzO7+8/Q06mWc7amedT0qT7u+0m5cJaSpGbyjPq/ygraeU6MF6+OFc2OCR+tu9PF+UKRVP5QM9+58Hf+MvcAHuhZfMY5F9bHTrCOgxV8OVjorBUnh9NuSTCbsNK32eZ9lrl6EsSuk8nDy+sENiJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yssaQe82YE/8e7yHgHqW6heukohuw+edBBWW0wYAEI=;
 b=LafSeLDjNnZbSZhrzymlihx3ibueSi0OZeUrfobU8HqVF/IUh4EjfMgHQH1JDb6P6U/j32ZqmXKnISMLA55DTlrzro3fdqF2k+6NNfwHNrzDvYaWcsDEmncuz+9AaqQJMWQPtWCrko6Pv7Do7MEg2215T1eZHmpSzvN5+Gp7S0d0tmDtxW6RG8SswHwg5mA/g9uoxR3gFYgPUAEx29kZEuKB2O1hBXtrNAZthGTUVhCyKi02ql00NoNkbwmWk+R5M3paSJ8kaHGydhyJSK6BKxk5XBqDJIgNlGK+nwKg0Ey/iwKdXafcyyUAZ9poHodfaxpXLgwVPGIbXIFpTQG3XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yssaQe82YE/8e7yHgHqW6heukohuw+edBBWW0wYAEI=;
 b=PM9/HAqtkRe1cbWzs2bM+DksCf1RTGUCB6QJCnf9dBlIXGqYWWNDHObpACBdFKgwPgbNedUuvy8AkGIR3XjgMWeywvH2405h50JBm5eRWGuyYCU+69p3nIb7hsSBvh3HQevPWK4xs4s/4rJEa2JS9vKA7gNS9wP0fHs7A5IG6Bw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MN0PR12MB5980.namprd12.prod.outlook.com (2603:10b6:208:37f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 01:45:16 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 01:45:16 +0000
Message-ID: <7f47ea7f-73ee-9010-df8c-9c6c1fefc98d@amd.com>
Date:   Tue, 5 Apr 2022 08:45:07 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFCv2 PATCH 08/12] KVM: SVM: Adding support for configuring
 x2APIC MSRs interception
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
 <20220308163926.563994-9-suravee.suthikulpanit@amd.com>
 <426b70a407b774627187e64b011a64bfb7214b36.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <426b70a407b774627187e64b011a64bfb7214b36.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0003.apcprd06.prod.outlook.com
 (2603:1096:4:186::14) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45939695-2ccc-413a-7332-08da16a5ef17
X-MS-TrafficTypeDiagnostic: MN0PR12MB5980:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB5980E1DF971CC967365B3F7BF3E49@MN0PR12MB5980.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ayM2isVRTE/xaVKtOvEQzb+m+TigCnhOGOJT4iWVzAj1So4kem5ivC8omFBSQ+yq4ucSKSjfVAT+xuNzhYBz9BlP+hllEN/bjyRA1xw4nboti5lor2gX9qCqkK2UsWCkKiuUia49ORtLguheHvQ50X8oaxQhMC3tK6IypHSCQypiypuZYi/DDdTgd7+TKaCJMQ2j0SSpzKNL/mJioAS7G9igH5CRR5gfH1OpZgB4kz5Vnc+NTmm17rP9gKj2GuYtWM2gw0KzNsX+b+O9U0oNFJn4QN8TdNGk8le4SeqQzRXHt8vPVKRG9lfXNNFzlZ5z9JoVSxvYvvUBItMmaiXwuy5gJCLtRG6xs2NmJxLU1mT5TsHWQyr8GAKt6+CckwGzqDFEnUcDNsjDGN6eqbjV5pL3ZhNhfU1KXaw7z2Y4zDQmV++eh4qGy0mcyr/qqNadRZAxEIEgOHo4zuUlMu4WGyB75nZEHHKLX+26fRsEp2FcekM62L2kn0L6Yt/iaI4nEeKrH4M63GvMf/NWd5G/3lXuoJGRF7zJo249Vyl0U/VFmGVgspTujAwgaOD43e/S3gZE5krgKy0grCeBjShWPF6frG5Gbb2txh/OzB+VF2tIY+3CGNGZ/qPzeDkGB+a4iMwFnfNvLf99Dw9mpMF5fdcfz0NbcKsvrc+mhuYfT+SmDGxIxn0Huxeo3ILX/kyP2zrwlqoYKAjfJ/wAhTq24+ODNr3JQEmV6UVGStr4hU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(44832011)(508600001)(86362001)(6506007)(6486002)(31696002)(2616005)(31686004)(36756003)(5660300002)(2906002)(186003)(8676002)(83380400001)(6666004)(6512007)(316002)(38100700002)(66556008)(66476007)(66946007)(4326008)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmE4eDZaZVl4QWttYkN4RjZ1R29CSWRzNUo1MnNBZmF4a2lKS292OTdLMmc3?=
 =?utf-8?B?UFBsS2pwVHhRWHlVSXZzZUZsdUY5am84ZmxTRW1uUHNxalN0Qjl1YzliWXRB?=
 =?utf-8?B?R1JkalRSbEZ6YVdkR2RUWFc1MFk2VjVGVDRQTGNBNmpQVFlLTVNVMnBDWC9F?=
 =?utf-8?B?azNLMWJZQkNOd3FTYlBmVVpBK1I5Sld3VjJ0Z3U5eWZEN2VzUURMeU5hK1Jx?=
 =?utf-8?B?MkNqSWh1WFNKQk1ZTk51bXRzYVlZVkRGTlNXY2hNQXc1MWxKY0VWVTJUMHpQ?=
 =?utf-8?B?aDBQbnNwdmxzT0hlZ3pBRVhYbU40enRWY29GOFArK2ZwV3VBNmZsQ2dHOVhp?=
 =?utf-8?B?VEJQNTN6U29tcXozV21oZHlueG9DMTh3RUxLak9ROFZLcytHYlRUU2pwQTY0?=
 =?utf-8?B?MGZSYzZ6MGJLay9ZS2krNnY3TEdVYXhrS0VCdERZRzRxOGV2R0FUQkxmbHJ6?=
 =?utf-8?B?U0d6UDl6UEp2cnlteFUyQS9vR3VJU2lDWGlvNEttRVEzcXUvVFArdVJZSWhx?=
 =?utf-8?B?QTB3U3cxN2VsVnJ5SkZNRjk0MXZkdmg1eFVtT3cwclZQTExrbzNDWDJSS1hn?=
 =?utf-8?B?QlhFNWdnRU95ZXIxY2F2U2RKYUxIWFZlaDJOcFFvb09reVoyWEI1SEF1bCt5?=
 =?utf-8?B?TlNiRG1vK3g3a1JlbHR2TkdUTVNjOGk5WWxVakpyWW5qdC83S0ppODBrckxX?=
 =?utf-8?B?MW1USGt3L3NDV0tVSW1NZlJCMTlMMGFFaGdEd2wvNGd5NE9aaU1YamVPWmth?=
 =?utf-8?B?T1Y3eDBxLzFaSkVocG4ydE1Gd29wS3VkSlU4bGFOQjNEcVZhUTdDOTZuUHpn?=
 =?utf-8?B?dklaVytpcnhqYXdJSk5pNHUyRVZ3VTgzelRFb3MrUGtISmUyYUV3bVUvb3lt?=
 =?utf-8?B?bkt4SXVsaWlOa05RbnJNMDF2QVdMd0hGMlV1WUYxekNnZ0pNUjRYaDRqOS8y?=
 =?utf-8?B?YjhXRkhaQVNtcTNQQUVpWThFbm80K3J5ek9oQlVheDhKRDcxNnNqM1JZR2ds?=
 =?utf-8?B?c0hVUkVJMFpnSVJEd2tFYnMwRVlwcitIOUI2bGhTQUhTVXc3c1Ird3Q1dm9I?=
 =?utf-8?B?ZWJ4aUFCSXBUakEwVGZDaVUvS29vb1dWcm1DWmJWUXFhSWNiWnhEVDQ0WGg4?=
 =?utf-8?B?S3RHYjl3L1BmeUNSU3E3REhaQ2d6dUdJQWVhaURnQ0xmN0Y1UHFGaVM0NTJr?=
 =?utf-8?B?Uk5ndFg4SjVtT1BDK0FaVjdnNWpiUGRXMjJqNWlkMGR2MmgxdXFxVEM5bzhn?=
 =?utf-8?B?dzV5eGtTVUhOTUQyYXZPclp0K1Q1YzZIUlF0MmV6UFJxUytaZVI2Mk9ZckpK?=
 =?utf-8?B?akprcVU5VnZJc3QrSVFRWGFwVVVITFVFeWlpTDIzeWN3RzRncktVbURMMGlD?=
 =?utf-8?B?WUNGZ0dTMURDcm0wOThlaXE3cHkvY2kxVVg1N0JCdndoNjFiaGlPUGVKOHV1?=
 =?utf-8?B?NlV0Rkt4UGphb2hGVjNlUHQ3RHQyVGtRM1V0NzV2eDlaaHE0b2JtV1FQd1lC?=
 =?utf-8?B?M096c2V1amd3aDBXbjNVWDNlZG1xT0MzRDJBWnBDeGhaNlR2RzFxVEwzNlYz?=
 =?utf-8?B?bUFPTlRnczFkaWJzQ2U0Wk5MT3NwNWRRS1lzT0hIcWtxNWYwU2VJbGNuVmtN?=
 =?utf-8?B?NFlhSkY4MUwzSW1Lenl1WEdkMHl1YzE1czNzckJmY251TFlzbm1LYlVvOTdZ?=
 =?utf-8?B?aG41RGh0SlhPSmZGNVlLYUtiMDZLcWlqcmxDR0dOcWVtMk1jK3JzQzI0Tmt0?=
 =?utf-8?B?ZmwzY1R6d2JkejhxcEFxZEFmNjRIY2wzNjRUOFB6SXJHTnhiUHRxYmd0aFUx?=
 =?utf-8?B?UFpIdWk3UXErV2FjcmpUSjA5ZHlXa0s0UWphRjUwcXNJYkoybVVvRVFpYVhY?=
 =?utf-8?B?Z2hocW4yNDVoemxNVElvNFBCOGpySUZOS2VNaXB6VXlBOXZHOVVTMC8zY2hk?=
 =?utf-8?B?elFjSGZoTTNqc0lVcjJVUTBTeTJqMVp1ZTdPYVlTTHRhRXpFVVJDQ016UTBt?=
 =?utf-8?B?b0lqeGFwOGtWSEl1MGJNR2pOVnR4UExhbmdyZXg5Vko2dDdNNHNiODdLYnNP?=
 =?utf-8?B?Zk43bkw1V3hpSVlON0Jvc0FQRll2VDQxNUVNRFBHUzRzMlk1TU9tRWl6d2VW?=
 =?utf-8?B?RGhqR2RiQ0tpMDVnZ2d4MmpiaE5uSDJCQmpXSmpIS2FpK1ZyWFY1WFIxOWVt?=
 =?utf-8?B?c1lQOFEwR2hrblZrMWhERHhSTWhmWEx4UWdwOC9OanlBT1lIUVI0dzVicG94?=
 =?utf-8?B?VStleHBiM0ZTbkEyMjhTOE1Ka05VMjlKUzdFUS8vTVB1OVFlbCtCSGp0eGRx?=
 =?utf-8?B?V2tib0hmSE9GbEljVkNPWUR2VDVMcFMyQUVROFJBQ2FvTTJScjlNMGxpVnBG?=
 =?utf-8?Q?PF6g0Ffe7vGjll/9zZK1le2hPhTZUnAqFu4vV23Z0xbZC?=
X-MS-Exchange-AntiSpam-MessageData-1: 0/dprPUbu46awg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45939695-2ccc-413a-7332-08da16a5ef17
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 01:45:16.8676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q43sVZzqerqo6gUTPWzlmRBZSh4nThBkwfuQCN9iTJaHb40CVjyd1y6HJfvBBMJMdEwVH50HSL+3g/VN0O6qvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5980
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On 3/24/22 10:19 PM, Maxim Levitsky wrote:
> I did some homework on this, and it looks mostly correct.
> 
> However I do wonder if we need that separation of svm_direct_access_msrs and
> direct_access_x2apic_msrs. I understand the peformance wise, the
> direct_access_msrs will get longer otherwise (but we don't have to allow
> all x2apic msr range, but only known x2apic registers which aren't that many).
> 
> One of the things that I see that*is*  broken (at least in theory) is nesting.
> 
> init_msrpm_offsets goes over direct_access_msrs and puts the offsets of corresponding
> bits in the hardware msr bitmap into the 'msrpm_offsets'
> 
> Then on nested VM entry the nested_svm_vmrun_msrpm uses this list to merge the nested
> and host MSR bitmaps.
> Without x2apic msrs, this means that if L1 chooses to allow L2 to access its x2apic msrs
> it won't work. It is not something that L1 would do often but still allowed to overall.
> 
> Honestly we need to write track the nested MSR bitmap to avoid updating it on each VM entry,
> then with this hot path eliminated, I don't think there are other places which update
> the msr interception often, and thus we could just put the x2apic msrs into the
> direct_access_msrs.
> 
> Best regards,
> 	Maxim Levitsky

Good point. I will fix this.

Suravee
