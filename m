Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6C93EF2ED
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 21:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhHQTyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 15:54:53 -0400
Received: from mail-bn8nam08on2061.outbound.protection.outlook.com ([40.107.100.61]:12801
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232744AbhHQTyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 15:54:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+gX/pacdZBCtqQ/klJeig4e0iy/WR0lB+oOJw/lp92JI03S+bahhvxxFsDV23Gv5XVn8mxg6dBi1OWfdbGb9Bx6bbTdr1lfBEOeGtZSeBzxJo31RBGOWHWEN1LD+9bCAqHELHNiXM6EnKpd8c13hcLEvIidia9YmOwPUM8t6eZIPsvdbRX5cZYy6+r2t6wO/MeY5qOHDLqk4qMePCfQxd2WPvMIV96dkOsNymA9wtNWcmk9oJO6AOXrESWDRYzjbionHKpeJJ3xUdokIZh8vJ7NS5q9DbqUsL/Rqs3S+GQOQtT9XcETYephyeLkR8+/VN9NQR8XBVn2EV4LoESWTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aV+ekU9n22JKN62x26XcRG2w+lXtQMWEa+zfetvf54Y=;
 b=LdoXUUQCBskojEI/pvkkuLznqQf/citUGmUQRzKXijd4dt1fP9ybVZgz6uYrUgjKeahlY5KJkgsxA1s+Cg/Tl7Jl0nRGvronsu0oJJ3NqwsevagCO9MrssJZlmazjeMLacPIDaB5Fu/LIQAhY6PIXc8+PSIrY0z0yeHbUdkML9gDf7Is/wHrlLzx+fyyJKRgiv3lPjRHl/UrAU6XZCu6lOEY0o0J40QQb9nvxtM5corFbS5fbg6KrHXePpprzt603OOraSlb7KRQHOsnRgaztHOLddjK8ZmFEewAXK7Oh7z6ugIQhYRU3rzWSa6D29of/PkmNj9K2dkMfZ/JzuDxJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aV+ekU9n22JKN62x26XcRG2w+lXtQMWEa+zfetvf54Y=;
 b=iMUgQIR8TIItDtHhHfAIF/YltXAisGJJz2nslGO5lzYyFEi4flqi5mgCy4vszI+wpxrnm+S938zImVRIw2RAYCPseW/N69quR88ILKD9xceu8t2sxlKcHWBCyerdu3h9EIUQQgIsKKeIjYoYGO40eINQnt8gUEa0NwqMgD5KIkU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB4671.namprd12.prod.outlook.com (2603:10b6:805:e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Tue, 17 Aug
 2021 19:54:17 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 19:54:17 +0000
Cc:     brijesh.singh@amd.com, Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 0/3] clean up interface between KVM and psp
To:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210816202441.4098523-1-mizhang@google.com>
 <c66484d2-3524-d061-1e65-70dab0703cc3@redhat.com>
 <CAL715WJ4aREKC-5dOoNSuZi4qm6PqmoqYN+CVm9Y-cEwQZ7mow@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <f703fbb6-2585-95e6-9bc4-d24580d6f1f5@amd.com>
Date:   Tue, 17 Aug 2021 14:54:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAL715WJ4aREKC-5dOoNSuZi4qm6PqmoqYN+CVm9Y-cEwQZ7mow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:806:122::21) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN7PR04CA0106.namprd04.prod.outlook.com (2603:10b6:806:122::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 19:54:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc3123ad-2fc6-45ee-a93a-08d961b8cb9f
X-MS-TrafficTypeDiagnostic: SN6PR12MB4671:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4671DF5260DC0F7D273652A2E5FE9@SN6PR12MB4671.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdCH+Ky7nzS2ZYxPVCctYIsM5AJlrb6giu6prQQB5KFyIzvAkKmROmlpXxY+/3mtXYyJXgBkXMzRAHQa+zslFJLPeXZJgQTwzdwH83NRf1762fz4ze4cTXEyA/37qSYXns8oxuwbfPv1EbvSNyWXcxH7OsNau0hazPJy3qzkbK5GPSibQjqR99dNaA6AurbR25+rpJPxMb509VpJluYx0kzH6E3dCD37VkfbC9FiCWrOybMGImmvWH7xjZ1MEM38p6/14lcgKdkbsMuXObG3QUzns9LYzYf0uaU5nBkgsuaj8QiB1DKxxLUbhHgBsyMOXE9UMiUKe+/ucmp75tL32Ph4isFoMzj8J/VFgqfQ2sFdY2VPv6gliJ8xLymaD3QQszEfZgCF7RJZCrwhcdU1iwQRap+QrZGVAvmZZglO2wMDfsKQvMMoogp/D/IKt5GtWvUvvpedZrLiSesHkHekU4MYQme2w818vPQXDc8mO2Hu8vzE1FPQeZlpCcgSWLV2AotNO/xdPH9ToNjU3mIokSobiqb8nS09IFQ6KQAgtcSnmWCQkpKCUsve4sfpI9uif7+2KgIuANkK9Md4jAmYNb3Me6w4nATmJnGphytYbbZA3K0M7tKR25dpDr443wN2kQ+UKNKkXVZ4Je5Ae5uxvDJvHJ9X+AuOSkL4/WUE3rsDvxNLewxGzqFCDxd+klpTBHE4f+SphnE8iIoCrVjC4GqcCVqSOoW2Uzn+Q/T46rC2dfxSFGtvHSM1dSODXJoPJllqxNDJ8wOHcs7FahkiyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(36756003)(956004)(54906003)(53546011)(66946007)(66556008)(8936002)(2616005)(38100700002)(8676002)(52116002)(66476007)(5660300002)(38350700002)(86362001)(83380400001)(44832011)(31696002)(110136005)(16576012)(2906002)(26005)(478600001)(186003)(4326008)(7416002)(6486002)(31686004)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ayttdGwyb2FLTGR1MEt1RE91NnRtUFhSYThZTzV4ZitHNk5halAvaVREaWNM?=
 =?utf-8?B?UGtGVWRjK29JS01QSVVNYUR1ejM0MWlLWW9ENDdBanZPZVZiL3N3SE9ZTmQv?=
 =?utf-8?B?TDB0NmZDYllQcW1EakNVdzdLalVzcHlIM2RMZUJZRjhvU1p0c2ZSbVFHalMr?=
 =?utf-8?B?ZmUrd1hyY3RtZHFiamhhb2xHL0RGc2ZWeTR2RUFTMzZsVzNreEc3bkx4c0Jp?=
 =?utf-8?B?b0ZXVXZvdUJuK0N1MHlWVkdRWmlIQ21EK0phMGNvdlNYOVVzcVlhKzFDVVZ5?=
 =?utf-8?B?c25rZ0ZlQ1cyU1N4SjQ4SlhSZ3NoRG5mTTdLa0ZDZkViRUJxaG43Qk9hNUdy?=
 =?utf-8?B?QnVqUXlEMzhsRmpoOUJtZk9PTHBDZTFQZnVCSjkzOXZldlgrekZWYnl3WXkx?=
 =?utf-8?B?NnVlbjd0QmJMdDhOL3p2SUxYUWFFZmpmT0IwenJ6TklVdGlIb0k0NHp4cHhn?=
 =?utf-8?B?Zm1WeWYwdWIvOFhnY1k4aDlqcHYvTXp6OTRnRy8vbXV4dzh5cHAreW15ck8w?=
 =?utf-8?B?V3lTcVRMU1NKeWpVM0NoOFdFT29aaHNlSks0dWR6Skw3cjcwMFoxQXN2ekZV?=
 =?utf-8?B?a1hUd3RrMDZiMlRvcWNRZEdzSFRldHg0L2taNXdrVExBWHlIR0RtU1pkUkRT?=
 =?utf-8?B?U29mWlBTaEZ6ZmdzbCtYUVJ6UTlubUtYQ1ZKdWhOMHhYemFqTXIvZlhzeXBD?=
 =?utf-8?B?c3NvaU5LSG9Zcnh6WU5NWXkwYnJIV1pqbkgreFlpem14ekIwUGJiOHMvWThx?=
 =?utf-8?B?UlVCZWlDSWxmRThpRGN0c1VSMEx3MUFDZ2Y0Nm10WEJ3ZVF1K1VqK3FEYm9L?=
 =?utf-8?B?SE96OG4xWThpblliUVduV21IdEN0OUw3dFNWMmhSWWIzRDl4M3FPSnVzVmJM?=
 =?utf-8?B?cStUeHh1d010dnNuZWRDSTAyVjlGN2EwekZoV1ErYlFOb3pMTldnUVJkR2Iy?=
 =?utf-8?B?bTdGVXFIZDRGdkxOU3JSRE0zMjhKWE10RXVqMWpYeUd0YmRlUVB0c1AyVWlx?=
 =?utf-8?B?N3NGQkhoRUZaaUNLUE9tYzZLWTY3NlVmaXkrS1R6ZVV2TGF4WXdadGF6UVZk?=
 =?utf-8?B?Y1NwYjFZdFBJMUtkdDNLb09SNWVJYjA4eWttWU5ZVVBVc0Y5UmFsL2lLU1ll?=
 =?utf-8?B?ckVNTUw3U29KWksvdzd5a2U1QnR3djBnOGRBMHpBTHJoR1lXMGt6cVJuM1dS?=
 =?utf-8?B?MFZpV1ZpZlBCZ1E1RlV1WjZVellGREoxbktEZnBXNHRzazdheGVsemtGL2gy?=
 =?utf-8?B?a1R0NzJnOTUyL3pPTGVGb3lFOXhnbGIwdjFxWFE5RmlxcGRaU0l2M2xLcjd5?=
 =?utf-8?B?UzZTUGdIbU44V2lPRHMyR1E2US85a0NpYzg5Q1pteVYzRXFZY1M1b1ZKWWEv?=
 =?utf-8?B?SHFBMDIwdmxIVVhEVjQ5SWZBT3crYjJ1bVNVUXFSaW54VkRET0VVdmY2bGEw?=
 =?utf-8?B?VjduRjhHTFI3MmQ1R2Y0UU8za2JhZFQ4aFNnRzVjNS9PKytIVVlwMFN3Q3ph?=
 =?utf-8?B?d0lwQ1poQVYraU4vT1ZIdHIrRUNsWmk5NTVyVVVHZEk0S0NHYXVIWEFaTUxS?=
 =?utf-8?B?cE54VVN6aHhYKy96Z2FpZ21yRzlGTVcrRVRRWGNRbkNEVFFEbkZIbzFGeDFJ?=
 =?utf-8?B?NW04Wnhaa1J1YzJIWWExcXhTQWpaWURETm9zZUpBbzlJdzJRQzk5djlIazZp?=
 =?utf-8?B?WmxTUW01NStDQnZSMWQ3emdWK2htSDNRTmFpVlpKdURKMCtCaUFNVnRiRllq?=
 =?utf-8?Q?eRS7F/d/tA6S/ClpVVuMxTh5zJZJjkLBFYj/yNY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3123ad-2fc6-45ee-a93a-08d961b8cb9f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 19:54:16.9210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78ikbL7wadtuuL05Bqz9Ub6k1aCAgsGT0VxOkBXnfywlXWyDHK3cTytvLSOWd2yXEiZZTvMd6cWrhna5g2S4JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4671
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/17/21 1:08 PM, Mingwei Zhang wrote:
> Hi Paolo,
> 
> Thanks for the prompt reply. I will update the code and will be
> waiting for Tom and other AMD folks' feedback.
> 
> Thanks. Regards
> -Mingwei
> 
> On Tue, Aug 17, 2021 at 1:54 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 16/08/21 22:24, Mingwei Zhang wrote:
>>> This patch set is trying to help make the interface between KVM and psp
>>> cleaner and simpler. In particular, the patches do the following
>>> improvements:
>>>    - avoid the requirement of psp data structures for some psp APIs.
>>>    - hide error handling within psp API, eg., using sev_decommission.
>>>    - hide the serialization requirement between DF_FLUSH and DEACTIVATE.
>>>
>>> Mingwei Zhang (3):
>>>     KVM: SVM: move sev_decommission to psp driver
>>>     KVM: SVM: move sev_bind_asid to psp
>>>     KVM: SVM: move sev_unbind_asid and DF_FLUSH logic into psp
>>
>> No objections apart from the build failure on patch 1.  However, it's up
>> to Tom whether they prefer this logic in KVM or the PSP driver.
>>

I have no objection to move those functions in SEV drv.

With build fix

Acked-by: Brijesh Singh <brijesh.singh@amd.com>


Just for the context, SEV API commands are divided in two sets:

1. commands to provision the host (such as PDH_GEN, CSR, CERT_EXPORT, 
CERT_IMPORT ...)
2. commands to manage the guest (such as LAUNCH_START, LAUNCH_UPDATE ...)

I was trying to keep all the guest management commands functions within 
KVM because no other driver needs it. Having said that, we made 
exception for the decommission and activate so we can cleanup the 
firmware resource in non-process context.

thanks
