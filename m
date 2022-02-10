Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47544B0431
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 05:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiBJEFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 23:05:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiBJEFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 23:05:36 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81C124587;
        Wed,  9 Feb 2022 20:05:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBBf2y7eCPOVTgLPhFZD03rPsP9qLpUoOxVRvfBx6FplxD8487Asb+bNWQD5gVqFu9DRShDrCNlgqfp7/kHkMktUrfD/IxgDvpUGPPc4RxsYXhLk0SuXLLfgNEeye9j0HRwTpfy+GHDqLiHVriCuM9Gq3Fa18vKngwox1vcoE4fJO2jYLgElYy9ELwcLM+M78XMclDY6G0DvSrXpd3TvJ0RZeFRez4P78BYbRgwlmtj0miQGHXixuivCA2euxE24+7c7wc6sPO9DE9DSsxIsou6G6Wf5dQV0de9Sy4G/frgfIwjgkkchRcsJB+oBGGhCQRteX0S/CHOAZ6XKKUda6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPEbk0GEyGFK2OnX2YBloU7KJeBJZeL4uV68PeVQzXs=;
 b=lbVs5TXnvjqzh3BFGN/F78yCXEoszNwdbnpPcYS7s1Ud6FTwc2Sy8N/RGCHWZQ1pNIx5SMgzZ6bI2Jc9jVDsZxqzPwFJAt6GYcGyHv/JdXM/j6Bhib6/yaNlAF1wVUKygSjw6Fagwn0kwy5rNXj6+2X2yBQA10ddknCST3qWOodTaxcbJ8tAguRRCr/C7aVB8gi7hDT0USWpitOnq5Vh0/bkdZP7EcMTBCWt9eIdxPpZv+dBPG4n5Y9KKqIHIlsV5/XWz5ay/Bx0a/O+/5lO5Ftia5TeFXdTFHewCS8sI+9kbNgePuJ5i0WUzfiQkkh29dy8KRql2G9blcmUGvQo6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPEbk0GEyGFK2OnX2YBloU7KJeBJZeL4uV68PeVQzXs=;
 b=Aiahy36VbP5JV+AClPTDTCCoY1ZDqS+20nVMMk0F8CvSYBDjEq8l6/qmLV11hE3uDi3YoDZkm1jXA6PYZkRPqEH2IMcWxnvAZsybOWKUUc30l7EPdCD0kh0NKqH9FPHI/pV+T+znDoXMEc6xC8Fdrz8PSzXHfA5Jm3IBboK0SQg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by BYAPR12MB3174.namprd12.prod.outlook.com (2603:10b6:a03:133::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 04:05:34 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b%4]) with mapi id 15.20.4975.012; Thu, 10 Feb 2022
 04:05:33 +0000
Message-ID: <b775ab2d-c293-d8f0-a436-1ec19c6315d8@amd.com>
Date:   Thu, 10 Feb 2022 09:35:14 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v3] perf/amd: Implement erratum #1292 workaround for F19h
 M00-0Fh
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     like.xu.linux@gmail.com, jmattson@google.com, eranian@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        mingo@redhat.com, alexander.shishkin@linux.intel.com,
        tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com, Ravi Bangoria <ravi.bangoria@amd.com>
References: <fe53507b-9732-b47e-32e0-647a9bfc8a80@amd.com>
 <20220203095841.7937-1-ravi.bangoria@amd.com>
 <YgO4vn2w5kT43HGh@hirez.programming.kicks-ass.net>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <YgO4vn2w5kT43HGh@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0079.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::19) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 385bd1a9-22d0-4257-bd93-08d9ec4a9580
X-MS-TrafficTypeDiagnostic: BYAPR12MB3174:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3174F8A593588C1C94DD7D16E02F9@BYAPR12MB3174.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ragsX5YE8VIb06DY7+adPAAC2IESNQLUhhA5ed2HtgDjJkfKIrlO8RiVKbPHMAc4E7uRymdfAnvWEz0SJeSbQgy5T0NEVZwOa+oEvvbwmVEcR5OXDhqsSrDooKANlbAFcc4gRU1mSPi0adGraP20EzvBOdtzs8m4u8q+GalzV+/jAgbEhB7dHy+cfhJcvR616tPwwK8ty6b7NpRrnHuyEVAyHL/xHfuK4sLrepV/nt6Z3qs/ZkFOjAbEISyHO3PmiTaEgIbXagdy0OfuXuh2g8AMWXlZDIFk6P+G4x9gWtbvl2noh0kq+Zj7NGSqh5xkvUqW9HXBCKNKQjYia1tenYCMFrEQeKrrvGw3dgt/TNpnOFQNqJ6bEhUcgDb0d8dgTYShKnKRdRAI2kh2EwxhyGijG4w6i9ShooGQrlbuJEfqrK2LtUmzEAh2xp5WuJNO4TQGpB3708khsdumYSPaM4tshrLu7HxVYJnOHzwDKDDMDDBUzoLXs/1ySNjFSzHHjAPiY76IGlZ58k19Y/JONHKNoMKPK0plrCsznyKImNvMGjupKMVb7VNQ+5ZzACYo1VeCLNhWMXNGLuC2imiuzvQmksR5zg/t1Hs7z9WZEK6lKtqEBV2erhFtOAQ1KYFKOGlfVO1SZ1HhKaFdvzjXuEIGKlmxTiNjURFHgZ1/aE3ArGaE2JbExijRi8dYtS2DHczZZF6Yr2aaB73ncSx17x5rTgH628OjNTfwkuYOnt63KycJreMSF+0dlK5kFEC/ZvqDCqM1j7vDFKaCDY9VwqZxQUDqbD4CWnd0mcMSKfi+tbCdV0tbVfwCgr2U9mj3AcVT0+uUSgf050z8YorL2ohDuVe3Y0YltCno8WbpiXw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(4326008)(2616005)(66946007)(38100700002)(53546011)(6666004)(6506007)(2906002)(66556008)(66476007)(6916009)(508600001)(31696002)(6512007)(8676002)(36756003)(6486002)(8936002)(26005)(5660300002)(44832011)(31686004)(966005)(86362001)(7416002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cks3S0pjRk8yc3NHTTdnYVFTaWIrWjZRVDJnOUZZYWFvckR5am5oZ2xmbXBE?=
 =?utf-8?B?eHgvcTJKdnNlQjFaN2M2bFJENDNHdmdXdzhNSVljakRDSDlqc3FmcG9CNWZX?=
 =?utf-8?B?amVrUzJJUUdFMXJqR0ZrR1dzaGlmclRScG5mVkVlOVAyYUcwN1BiY0tjbU9R?=
 =?utf-8?B?MkxjQkZwZDBtU3R6S1hFdVpQMG5qVHpBbHN1TUdwYTB6UGdFS1RXL1F3a2t2?=
 =?utf-8?B?Zmc2SVdxdHNUaFhQMUdjbktIcERtYjVIbVR3TGN6L0Nla0NLU0tUdGEzaTdP?=
 =?utf-8?B?OUc2MmxFbVZKNzZjYjR2UmQzZTI3OGtBbngyL3B1N3hkMVdpbXAwWHMrSmZh?=
 =?utf-8?B?R1RsQjkrMEFVcXNwSzhLMklHZjRoQ0xWb2NBbU1MbEZ0R2J2cUkza080TElY?=
 =?utf-8?B?ZktiK1MyMTF2d1U5cDdMVkpZckxvVG1jamU3bTJYZXpsMUF5eGJ6MDVhd0dZ?=
 =?utf-8?B?SXFtMFRwN2x2VjRtdVQrNFAvUXJZellWT00vazl3dmdKeXFVUVp5NzJSMWRD?=
 =?utf-8?B?bEJZcmxzR2NWVXY2NlcyaS9YUk9mUitnOXhwd20wT2Yxd002TFRmd0duNVNK?=
 =?utf-8?B?eWhEQURDMnpiMlR2T0dNaHRZTW9JQlpNMVArR25NT0padW9IYkd1Q2NLdGxs?=
 =?utf-8?B?WTgwenRESGh3MFNnNGpjT3pHSVhJNTdjZFRzaU9GMnM0S1AzamJMaUZ2aHNj?=
 =?utf-8?B?NWFocnYrbjhsa2RTbklKT1FIYVU3amJWTWNEOWtzN1pUT3dsRVBEOThzNk16?=
 =?utf-8?B?VmhFenZLOThSczVKbllQMDdKSmVFLy9YUzBCUFZSZzR0VWpwOXdqYzNPQWt2?=
 =?utf-8?B?Q1EyRzFLc3RJMndWMzEyeDMzZk1MRWJRREphRXNsNUhoSGR3Y2dCaEZVV2xP?=
 =?utf-8?B?aXpuelIxTzhTUmV2NXdqNEhyaTFiWHFvNVZGVDVXMFNKMDlEN3pYV25TbWJm?=
 =?utf-8?B?RGl0M1R6eW9uckVZK0RSRkhuVG41OXNMVGowZ2Q5Mzd5YnZYSjFONUp4SnIv?=
 =?utf-8?B?QUVBMGxRTENja1E0b2tmZ29qWjN0b1oxK1BzSG0xQUxMaFpJdjlINUxKcnJL?=
 =?utf-8?B?Z01PVmdXL3JpUi9UNFRJdFV3MjBVY0ZyZ0dyWVUzbU5jOVJpVDNJMjE0bFVQ?=
 =?utf-8?B?Tk5IU1dZSlpJVDNrdHpvdUcwMFpXcUhOaWpCeEt0UHpWY1h2aXhPZ1I2d2VE?=
 =?utf-8?B?S01DSUY0SEJneEIweEs4eGtQVnhsR3FibGhDY1Z1NVVWekJwT0RldkNjUDJ0?=
 =?utf-8?B?a0pobTBlY3FzbHE4SDJuenhsNnNrSVE1eWRGT0pBekwyT3huR05YQ2Z4WGZG?=
 =?utf-8?B?eUp0MTRib1krTWNFUEJTZmFFVE16MGl0OVN5Wk1sWWFDN0xLRjJRYTRBR1I1?=
 =?utf-8?B?RTVFMlEyZytTVURxaVUwTVMvYWcyTWFtRFUzNnpvRmRhS2k1VVFQbG5FY2dV?=
 =?utf-8?B?UlNqaFB4U1F3VXNWem0zN1JkUzZVRGFJZTgwU2lVWEh5bnhFUlFQVEs3blV0?=
 =?utf-8?B?a0pFdGxURWFkaEtzUWJiOUtXY1NVdDdiQjFDSG5BVmRLVEV0S0pNQzVnU0Yw?=
 =?utf-8?B?NFg0WFdYekRzdkdPaHVrWWlhTEFjMDBSMEdDb3NjczZOQzN1N0Y0RGNYT3Zz?=
 =?utf-8?B?eDdldTMwNmdydW1rTkE0TTE4RVF5K2lMVmZBWmlsOFd0Q281RllaTEhyUFZn?=
 =?utf-8?B?NmFKL1d6RUZ3c2pBbk84d0lySGZRRkFEbm9tZFBjQUlvSzJGVEx0M1lNWUxr?=
 =?utf-8?B?KzBVRUhYbVRmT2NVa3EyaitKUE80S1NNN1psRUpQL1EzZHNVYXNtbEF0VzRO?=
 =?utf-8?B?cjhQK3FVREZvOHpWTUsxdW41bE54MGhESWN3anZycjRlVURBc2gvOFBvVWx6?=
 =?utf-8?B?Q2dVRlFHQTd6aG5NbWVsYlk0YjJsSWJRZEhmaHhML0RsVVB5cHZXcnhpOXRQ?=
 =?utf-8?B?MEtlRDZUNG1oakZiWUFoNU43Z1ZEOEQzS2svOWxjejF4S3d3KzM1UkR6VGJl?=
 =?utf-8?B?cEVnV1JBck5ORUtEOVhxeUI2ditFSE5SeS9kekhFN2JNenVjVlRYc0VldDdo?=
 =?utf-8?B?Sk9lQzFEOWtrQVdWN1RwUkpYdVV0a1hOeDQvQzdHQXA3UzIrRWppeHprbDJI?=
 =?utf-8?B?dlozMEVVdUNRK2dCdndTdXUzOGxpK3JmNXNPQzdwNGpaUU1DTkJtNWZLMXNt?=
 =?utf-8?Q?GzVwIzaRSYRef7MCIn+jNKs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 385bd1a9-22d0-4257-bd93-08d9ec4a9580
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 04:05:33.5237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kaYblSdF16dDpWhD4q42Acxy8vu7hQgeTLoqLO+TjlWB75jBIuxObnaXNoknoverhTyC+UIicdV+oT6wDrZAnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3174
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09-Feb-22 6:21 PM, Peter Zijlstra wrote:
> On Thu, Feb 03, 2022 at 03:28:41PM +0530, Ravi Bangoria wrote:
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
>>
>> [1] https://bugzilla.kernel.org/attachment.cgi?id=298241
>> [2] https://lore.kernel.org/lkml/20220117055703.52020-1-likexu@tencent.com
>>
>> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> 
> Thanks!

Peter, On subsequent tests, I found that this 'fix' is still not
optimal. Please drop this patch from your queue for now. Really
sorry for the noise.

Thanks,
Ravi
