Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6780F785D1C
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237496AbjHWQSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 12:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbjHWQSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 12:18:11 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2058.outbound.protection.outlook.com [40.107.96.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46BAE74;
        Wed, 23 Aug 2023 09:18:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaiUhBQj/k6XFxxF5kXov1x3kCYcElon0BDW3yJLAxnXWo1kZ+sHoznDcfFeHIiAjExo6MRgp9XOLEX55HVFWrhaVMO6WQwl+7jE5jZnTlWjX9j5pFRv23gLOwu6/AJuo+r5fWvAL0eD89HmIlHyW0PnlY3EubYczzYqhruZPIQ/vYS5pmQOxf565UfipGHcXEWPUzc8jq1XtoY5qPngoy/chzUWste9QKoHJs8qq+r6fimUplZF+63WHjcFpZbL1kbSdnEwnPe/dRXfsDXkKi9Sk3AVJFpjQ1Nu8aJ7Bt4kvK1sT4bIr5M18+15NgUR1QRdAocvtBJmjj/tjjfZjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0jkNUhKJyHOfeiZ/nsbApLIWbtqlOA9PSUIDW3wznM=;
 b=nyiZaRjmOod0Mbdho0591mpk3vLKZHEI+8iybPaRbPo9+s7IMKYcZmGgKJjxI6ELgJpL6UuNOVPtkLAxZ8ijG5+0SrsNyGFGjX/r/Cjkn53nBGb0oLrk1bHKrjy6fSp+hK9vILUaKlxxvsCvNO0SpWcLJm7DX22SJo2/N5wkoFulBJXoxnxNpSaPHDxHC9Ryjq7QHlG0L4mVstEHkodo2bve4TaQZFZAAoPohm5BzGCwIt0hp9i84V62lKrI3tRc6QHrybPfwfYDoeAAgXTMjN1gBf+nhL6sRzJAy+S4it6nKQhWrVKIDYDuHBbDyMeojSvtfQqjw8mMhWgHuj/CmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0jkNUhKJyHOfeiZ/nsbApLIWbtqlOA9PSUIDW3wznM=;
 b=L+7CZFDZrDv81BGRdMREOGAlQ4xMprCF3+rawctJ0RJZ11XZJscSicsSuPaZbLUIFJgz2Sb3bkKap5/d5ZbW8uwzwyxXD4iHnMazMpFmVImuC4ta4vXXTsx7hAL0mkmiYCyQ/yYwNYjumQvpdqgP7PaX7xaYrbrwQUwtu5asqF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MW4PR12MB6998.namprd12.prod.outlook.com (2603:10b6:303:20a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Wed, 23 Aug
 2023 16:18:07 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6699.026; Wed, 23 Aug 2023
 16:18:07 +0000
Message-ID: <d183c3f2-d94d-5f22-184d-eab80f9d0fe8@amd.com>
Date:   Wed, 23 Aug 2023 11:18:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/2] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
References: <20230810234919.145474-1-seanjc@google.com>
 <bf3af7eb-f4ce-b733-08d4-6ab7f106d6e6@amd.com> <ZOTQ6izCUfrBh2oj@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZOTQ6izCUfrBh2oj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0101.namprd11.prod.outlook.com
 (2603:10b6:806:d1::16) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MW4PR12MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: 676087e0-c16a-45a6-44ec-08dba3f488fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Hs0E3MNNaL5r71mpV1jnA9bavPqrsuKrjtXJrAnPer3i9nhshQawfZfGCq6PQSPAlJNiThx/DiQTiTsLv7dpawrZsLdW7UnB0WFaNiFnlXdyvaNuM2WcuW72vwd937UQtvljcGLFYm8gq2cKunJKeoHoT1QqXqMOlX6VRQb/e8CCwDI/KMMDgK2q3l49Z74BEnVaivESwdLVjNoeZsDdF65gZgYgi7La4VLY9aSyIYg66hW5CcSvVPBu87+D+MUww75IXvOmYvWULotOv8JcIGTfq+iGgprIi//lciJRs+Bt+wQ2PkstZ2tgSz5wxpCOZdadilbR5cIUHPQwCPJuh62i/ZOxfkQfQqtPoV7eD8xCP370hM/+s0OLRs0MQtLtScndI6+glzxcPPRI/6Cxjl78W5P2XntFu0hi/amiQmgqJ0iZmMhnxLg3t5faf2cea7wLJlx1T8P3/P78PtlBgf9mdgjo89WF+MhXmGtGM1URhxsoBNHC0OInJRU3A/BX/S3EuktciE6GbQdU9n9LcvUvwEWXPFCUO4SLyBA4fdU8vwO84PaOWIfIiHJsI8rF6C01BWyXNKwpj3180ID78orht/ufoHk1+A1A3gOalPl5jjFBhSbecxkggLMuTGdfsM7AQEJNUCRjC0aBYhEiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(346002)(366004)(39860400002)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66946007)(6512007)(316002)(66556008)(8676002)(8936002)(2616005)(4326008)(36756003)(41300700001)(478600001)(6506007)(38100700002)(53546011)(6486002)(83380400001)(2906002)(31686004)(31696002)(86362001)(5660300002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjhIemlKbXo4eGVRZVMrMWpmVlhXclkrKzgrQm9jYUsvcDM4M2ZQc0hKQnlp?=
 =?utf-8?B?eDQycDJseFc4aDdqZkpvelBjaFR3RFM1aUJhT3hMQ241N0w4MFNhTDdNcGp6?=
 =?utf-8?B?dnVYbkYvRHhPSUFqNVExUTAwWEU5cXFRTlVONUgyaWxZTGU1SWI1cTFySkR2?=
 =?utf-8?B?VWlvdmJKTjZrU3BMVWtJczh3VmVLYU9BQmZIalQ2T1lwa05xNTZJT1dISUQr?=
 =?utf-8?B?a2xvSm5tQmRyekZSQkc4TGlnZGtIWjZTckplZ1pnMGZrclc2QzBmQVlWci9U?=
 =?utf-8?B?L2puUG1KMDRoUVpRWElodDNVRDBkaW01MkYybTluRTFaYmZjWFhPRDE3dVc2?=
 =?utf-8?B?U1dCaEhuc0Iwa1pXSVZhT2RlekRXam1kYVJFSld5UnVuekhLVWxYb3ROZVk1?=
 =?utf-8?B?UkFPZDBqdkZIS0RJSlBjYW1pTUg1WW5iV1d4OWVqTWwwUC9TY1hKZG55dEdL?=
 =?utf-8?B?a05uTFZFbXQ0eFFWcDZPR01QMXh0NDI1OUZxY0pTUWxVVTRBYWdCSGRwSlZB?=
 =?utf-8?B?YnhCVlZWM2dTRm9mTmxGZWEwTklUbVNJQ0NnQ2ttYWx2UUV6dXRTQXlaVHZI?=
 =?utf-8?B?RXZJQ05QYXZKRUVlRXBwR2pMekhJKzdNZnkxNUNjVW5BNlBhby9XMG5GQXFI?=
 =?utf-8?B?NWNyaGdhMm1ia1Y1d3ZuMHlFaTVnNVF5cmJPeFZWWVphZlpXeDJCeVUwNEN6?=
 =?utf-8?B?WWd1Y1pIUnFxRXczYytNZ0tEUTBibFVPbXd0MUx5a2JYWFRxNkJUYWVtRloz?=
 =?utf-8?B?NFR5clRnTEhoMWZadlpxWm9OUFZMYXdBSTkrTWdzZE50a0R2aitBenhKclhG?=
 =?utf-8?B?Ty9HK3c0Y0RqMEtGOXZINkdKTFl5MW9lUmtudTYrYjJVc0RlMEtiNjRKNGpa?=
 =?utf-8?B?RFpvdDlERzJLS2JQSG44V3hGTTU1VmFrSlpMNHRGTkNSemVyQk9vMTcwclJL?=
 =?utf-8?B?bk5mY3U3Y0hFY3BVNlBFcWtMQzl4NGJGbFBHZEtDTWd5Y3luN1N3bmpZZnZT?=
 =?utf-8?B?aUxRZmsxMnk3RXVmQjZTeFlxalMrUDNaRHh1ZzlWNHBkeXU1L2s4bjhkNjBa?=
 =?utf-8?B?U1VXNTZkczd3QU56Ly8vczh1aElsSk5pUUdmSHN4MERTVE1wMEorMFZZQ0xo?=
 =?utf-8?B?cU5RSmViOEVpRHRiSmdQRFI5aC9TYi93S1FhZTNDK2xLejRMYXJjUU1sSnV4?=
 =?utf-8?B?ZzYxNmNsdlErNkdCbGZVNUhWalo1NFJ3L09hWVFhcW9DTVZveGxobzh6SDg2?=
 =?utf-8?B?dFQ4bnFnY0lBSm1uelgzUko3MmN0SjhVU0hHdHYyWHN5dmI4dGM1TGhCcTlZ?=
 =?utf-8?B?eEMyMlJpUHVYa2tWc1c0cjNEdjkvaHRHK2pFTHE3MlEvSWY4MHdJUXhNcjBV?=
 =?utf-8?B?OUtaZGUrVWRZdFBjUFVXOU5ndkRFWDA1M0I2MGlGdno1R0U3djFmSTRlcjRK?=
 =?utf-8?B?Y3VVdnFRZFZ1Rnora3VUalNZb2F0b3ZCcUxJYjMxTmpRNHFJbzVsMVdqdDZU?=
 =?utf-8?B?TW9UKzBTN2pTbVNlOU1VQXZzbWo0MTNuMlZDbkdJbUN5YXcxUVJ1TUFrR0ZF?=
 =?utf-8?B?OWNYWC9SaFA1ZEw5akhkdU5ySDlzTGluUmFnbElGRDhTYTNJckVYQlkyNlJr?=
 =?utf-8?B?aFk3NXYrUzh2eW91dmtlbVpwK05HNlJ6ZFNlUkNkeGpIMXVYYi8rU05CL0JW?=
 =?utf-8?B?N1o4VmpSZlFEV3ZINzRJOE0xVTZOT1FJZldtcE0vdENFUGNDWXhnLzcrTWdC?=
 =?utf-8?B?dUwwaEZmUFJPOHVQdjNUbXNWWVB5d0NQK1k2eUQzL0x6VEJ0ZitUaE1QZDdt?=
 =?utf-8?B?OFhPQkVxbWRlQjNqZ2pBY1BOUURBMldyZ0d4cElwMjI0bXRMck9SalcxRWZz?=
 =?utf-8?B?YVdnNDVuTG4vUXlzMWtZQkJ4V0svVjZYKzFBNkNhdGJ1SFB0aFpNWWlGQStz?=
 =?utf-8?B?U0RHZzFtN1dpOERQaWdTZ2tKb3g0UUxEbURqUU5rbHNWRGpFZWhKR3ptcUVR?=
 =?utf-8?B?Z05OaXBxM042ckpYSkR4VllQRTlhdG0xREllMTdxcVllZ2M0dFhKNDNkcEdn?=
 =?utf-8?B?R2M2K0hxODROeDdtcG9yMzZITVdJSnFJTFpVSFY2b3B4dEpsU3FLV0x3NklK?=
 =?utf-8?Q?j1G9eckzJFNy1Au22EgNZmK5Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676087e0-c16a-45a6-44ec-08dba3f488fa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2023 16:18:07.0494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TfbcrVjkx9WcC8eTsmKswribbt0PmmnA+wPKUnpyW3NIdGrQA8ON9vT8NyQNylw7TnbJVUVQoC6Ru+jjJGe/NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6998
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/23 10:14, Sean Christopherson wrote:
> On Tue, Aug 22, 2023, Tom Lendacky wrote:
>> On 8/10/23 18:49, Sean Christopherson wrote:
>>> Fix a bug where KVM injects a bogus #UD for SEV guests when trying to skip
>>> an INT3 as part of re-injecting the associated #BP that got kinda sorta
>>> intercepted due to a #NPF occuring while vectoring/delivering the #BP.
>>>
>>> I haven't actually confirmed that patch 1 fixes the bug, as it's a
>>> different change than what I originally proposed.  I'm 99% certain it will
>>> work, but I definitely need verification that it fixes the problem
>>>
>>> Patch 2 is a tangentially related cleanup to make NRIPS a requirement for
>>> enabling SEV, e.g. so that we don't ever get "bug" reports of SEV guests
>>> not working when NRIPS is disabled.
>>>
>>> Sean Christopherson (2):
>>>     KVM: SVM: Don't inject #UD if KVM attempts emulation of SEV guest w/o
>>>       insn
>>>     KVM: SVM: Require nrips support for SEV guests (and beyond)
>>>
>>>    arch/x86/kvm/svm/sev.c |  2 +-
>>>    arch/x86/kvm/svm/svm.c | 37 ++++++++++++++++++++-----------------
>>>    arch/x86/kvm/svm/svm.h |  1 +
>>>    3 files changed, 22 insertions(+), 18 deletions(-)
>>
>> We ran some stress tests against a version of the kernel without this fix
>> and we're able to reproduce the issue, but not reliably, after a few hours.
>> With this patch, it has not reproduced after running for a week.
>>
>> Not as reliable a scenario as the original reporter, but this looks like it
>> resolves the issue.
> 
> Thanks Tom!  I'll apply this for v6.6, that'll give us plenty of time to change
> course if necessary.

I may have spoke to soon...  When the #UD was triggered it was here:

[    0.118524] Spectre V2 : Enabling Restricted Speculation for firmware calls
[    0.118524] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.118524] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
[    0.118524] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[    0.118524] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.2.2-amdsos-build50-ubuntu-20.04+ #1
[    0.118524] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.118524] RIP: 0010:int3_selftest_ip+0x0/0x60
[    0.118524] Code: b9 25 05 00 00 48 c7 c2 e8 7c 80 b0 48 c7 c6 fe 1c d3 b0 48 c7 c7 f0 7d da b0 e8 4c 2c 0b ff e8 75 da 15 ff 0f 0b 48 8d 7d f4 <cc> 90 90 90 90 83 7d f4 01 74 2f 80 3d 39 7f a8 00 00 74 24 b9 34


Now (after about a week) we've encountered a hang here:

[    0.106216] Spectre V2 : Enabling Restricted Speculation for firmware calls
[    0.106216] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.106216] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl

It is in the very same spot and so I wonder if the return false (without
queuing a #UD) is causing an infinite loop here that appears as a guest
hang. Whereas, we have some systems running the first patch that you
created that have not hit this hang.

But I'm not sure why or how this patch could cause the guest hang. I
would think that the retry of the instruction would resolve everything
and the guest would continue. Unfortunately, the guest was killed, so I'll
try to reproduce and get a dump or trace points of the VM to see what is
going on.

Thanks,
Tom
