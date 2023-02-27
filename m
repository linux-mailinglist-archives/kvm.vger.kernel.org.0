Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C07E6A3A30
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 05:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjB0EtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 23:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0EtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 23:49:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32D5E07C;
        Sun, 26 Feb 2023 20:48:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/WSmbT1rToi/x1TTtXTsO7wooqh1Op9Kqnu3cNf+N1GnBDZZNZ1TRPl3PdceBU0iidP5oHYowZMuf3Zi3eCgsP0aaS28wNf+l+1WPWeBLjXXeXkPHJsjBzqSoN8QZK21U4yCmIN6qdalWTI/+AXNQVvjh/nCHvnmgeKws9FYC04L8/tU4RfRj153LNTHo1G9AccSF/T6mMcyXO4WyGGaC5kNdkHFSSXHYXoptDSCGZcJ0Pth1J4Kh0wWSKfQ58gVnq2FqNWj11fvq4/0mVuKRBO5JbXVmijJYuE73e6/ZSVJhonrf8WpukgUi7kTjTR9Cz57+2h/AJ8fXAyZVcoIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gP5JSg2K15+7va1tKR169qYpIWhp283+cmvH+ShgHgU=;
 b=BXjkC8ZmZxtdskFce59EQGzhQekmNm9YLcmX3kwa8I6HZBSjygV2LfNPHZB018Hmo2fZIDmZ4gruSMoV/4Xg+Ww+FgNI//sGhZeti8mOSb+CQ+T/8ptP06rUij7wOBO8aHHsfens88moxikIxLlSlyVNGXYs98YQARQF6eR+45npprigQvcy4XyqLOysPcZaAiqa98M9kXkk6i99AtCDz/v0zA6KM9ZoLYg/x4O7HsDOsyrvrIDNvaXGfIh6jraL4JxP4nyrGypL6KV6elqPD3elaZj5YYryuI+xffn+KKm8T0S27aLMJXsXIBVNmgRtai8JcT/UYoiLb4GyhHfaTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gP5JSg2K15+7va1tKR169qYpIWhp283+cmvH+ShgHgU=;
 b=jcNV4CtvScDDkBwxJJ8z8r4R8cFczr+/frTl3tROnAJJNoqheSvqe864H4XpEWuiroqG0iB5YvJJJVUnTU/ZwAQAwedz9ODQGfu/WLy3PJShgwea7uEtWLULSzoZ9A3uO+XJv4/7jRaO6GXyHbIqbQ0oOaUNAXRMOMLhoYKybow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by SN7PR12MB8001.namprd12.prod.outlook.com (2603:10b6:806:340::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 04:48:57 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f%4]) with mapi id 15.20.6134.024; Mon, 27 Feb 2023
 04:48:57 +0000
Message-ID: <0d272ca4-a96c-9ee0-47b0-9434687b8dc9@amd.com>
Date:   Mon, 27 Feb 2023 10:17:10 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCHv3 00/10] SVM: virtual NMI
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     kvm@vger.kernel.org, seanjc@google.com
Cc:     pbonzini@redhat.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, mail@maciej.szmigiero.name,
        mlevitsk@redhat.com, thomas.lendacky@amd.com, vkuznets@redhat.com
References: <20230227035400.1498-1-santosh.shukla@amd.com>
Content-Language: en-US
In-Reply-To: <20230227035400.1498-1-santosh.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0155.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::10) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|SN7PR12MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c38851-b091-422d-1c17-08db187def8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xeew86/e+naK9a9HQD37jqNOtaTphmZ75f5Uzvm9eM1hz/PHbtqzQYL4rbRKzn7MKWmHEZSVddgGagUMftA2JZs3gkk1nskn+E7GaWwMeWCWl0VCZ2g/PZGHQXS9gyHcOnM27o9ly1R9805kIO5LMX2y2hOhUlL4GC7ibJYdeEHHWJyzitcQDQZoaQHZC7r4IeThigQolctiRY3I13ZiCcFxg5T9SzZgqa5skMEQi0bO7w75fgaadkvtasrhX9hVavL9o9wOxIGujI28RjE58Ygbo7hqa0cX+89Dnd2dey/kytKG6lgvak1RC+eKbTAV3jGJ4Qt14vSnOACT6736THzJ905bVN3YwqcmrLiNk48I4U/pmBqJlIfc+J3D1AHXOOMcFHm2tOrtM1gtgJLmmR6GL4O2/icCiNt6D3GvNeHWMd5z9YS4rcZ4oRXnCq12f2eivkBe1VJaRHxAgViy+VkSvFI3ttT4PNv4xut2zCP0coch8lw/ntMwtduxTIpeEI4s+XeM8N6ZmsngWtFyGCDqONnyoQmsYJB4lbZP0xNnVpQiMPDwz2kVnJqNLIof/0oDds9KuhFcBDJtTSB8Zf68lWMX9LYE06JpdDL+NPulVlY18M3X3k4x0dFWnKJWZBnK3gfMzUieu75DVkKKHTaHmVQPQC3Ep9hvIWw0iCiuXujeH1gGNw3wmQjLBR2W3IfmS5wG9ACe4YJlgxYyphfgxYENpxCtGwIC4eiwmAQe8ArB8sC9h01aGbKon4Nz7axHRxJxxDGFuY1GNzZPSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199018)(38100700002)(83380400001)(66946007)(41300700001)(8936002)(66556008)(186003)(8676002)(66476007)(4326008)(2906002)(5660300002)(44832011)(6512007)(6506007)(478600001)(6666004)(53546011)(26005)(2616005)(966005)(316002)(36756003)(86362001)(31696002)(31686004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmxUbCtUMytKSGtjWkdYMlVvRXJ3YkR4RzBCQWdtSTlGMDNvNWRDMGRWTU12?=
 =?utf-8?B?ZWIzS2tDVlpYS2NONXBnWHNlL1ZlWHJKVU5xT3ZHa0JRTWg0R0JaN29EV3pH?=
 =?utf-8?B?c2hnNWJJQkFMdTdFRE1QMzdYNkgra2lBNzJaVmdRZTVYb0ptSUJaRXBSUUxE?=
 =?utf-8?B?OGFTaTVNWVowMmU0VlNRTnZlWkRXWWwyVjE2VVprbUd0VUJodDB4Nno5N2Vo?=
 =?utf-8?B?ek1HeGxQdEpwMjBBbFAvQjMzaVBSS2lRYkZ4R05BNG9IaWNNeW85NmhhanpZ?=
 =?utf-8?B?WEpZdWg4SmlocHFXZWJJdDRvK1E1TU1rbENoN1lGZ3dwVHZoUW0xTTlqUHo2?=
 =?utf-8?B?ZEVBcndYUUMxcVJxRzA5cTVKK3pEeXpvTGxiNFEvU3pZSWNSN0VvaWo3OWVB?=
 =?utf-8?B?M2RhbUUvR2FLYTZVSmFQRjhyajFudDUvWGQzcU1xODlGVHU3azRrTUJwL2dS?=
 =?utf-8?B?a0hhdUREa3ZPQVowZHoyalI4amd4UWhrSDBvL2RQc2hYeTdiQkZqTXB3VU5J?=
 =?utf-8?B?SUphQ3dIVnMvUzRCUDJqOUFQaWl0QWNHRGQ5Q3JzNHdWYk8vM2lOUHJYaFdC?=
 =?utf-8?B?RFp2S0wxM1N0eDh1Z3VDcXlyV3BiTlBBT1YvTktQWHhvcW80S0J6cmRmU01C?=
 =?utf-8?B?R2NNYnVJN05lYnBQSjk4VUxPQURvME4vdEhlMUcyNHNhdERzbEJBM09kOHdY?=
 =?utf-8?B?U0VGdThMUy82cE5NeU5BbmRXdkZmRlFkZnZhc09FSlY5RkJLeGJaN0N4TzJj?=
 =?utf-8?B?VVpEMmxCM0NFZE9paGRDdWJROHdvVkNkUnBiTmIzU3J4VlFCUWU4eEdkSGNq?=
 =?utf-8?B?WDRIN0poTkhZTHRJT1F1OEU1cHFBVEw0MXZteStta0wzbjR6dnBkbmtuajRp?=
 =?utf-8?B?WHpDVDV2UnFxRlNxYmZIRlZzem5mUkJyUllCbFlINlk3WktvZ2pxNDdqcFc5?=
 =?utf-8?B?Ukh0U0E4VnlmeEVRWTZJSDk5a1V3elFaVmRFMjV6Ry9YZlRMaDVtakM0dWJM?=
 =?utf-8?B?ZHZGUVpjK3k1eTFFWmdFaHhMamlBd0dEbWxXcS9IMDlqdG9Wa0pwRm9KVEJz?=
 =?utf-8?B?VmJjWHZZYS9uM0svSytoaThlMkJIb01LV2NOeExJcnFqYjJCWXZtcEdZamd5?=
 =?utf-8?B?VGw2QlhaRGprMWdSYkdlbWpDdlBDTzJsejB4RExwVktNVWhEV2ZJejhRWjVT?=
 =?utf-8?B?eUdneWdKRkhMeVV2SUQrclNiM2lEeThFT0s4bkdKQ3VHT2xKVXBBbTdxKy9L?=
 =?utf-8?B?Y0ZtbkpyaHIvUjA5dndaS1phVWJSbDNyUzhxODVFQ2JGdnFDVEh1UjVMS0xa?=
 =?utf-8?B?NTk4SzBGMm5yN01ha0FtTmFzU1FlY2ZlbzZ4MncrZm44VFFidXk4eENHUFE5?=
 =?utf-8?B?R25JblVPWWt5YTBCMTNhd1hOQXdkUG9GUFYzOVpmd3NUM0g3cmo1THY3Z0w2?=
 =?utf-8?B?RnN2S2VnWGJWY0JzdU91RGQ0S1FkY0lXS1RPVU9Jc0tUOC9xL2hyN1NhVGh5?=
 =?utf-8?B?M2VveFVRcDgxRHVDYnAwVTZLWUhscW9rWXJyeWdKMGtMRmRMdytNTHpIR05u?=
 =?utf-8?B?dW5TMkJ0RGxwWCthb1laeE5jVFFPVUdHdVc0c2s3bmJaMUlzTnpDYVplSm9q?=
 =?utf-8?B?YW96dW1zNGpwRGgyQ1M3RGRSRjZrcndiSE1nVi9YVmRoQU5WL2sxRWxqM21m?=
 =?utf-8?B?MGFJYUxic2VvY3lDcTBnb0RwMlFqSTM0T0UyL0NqQ1dQLzQ4aWQ0ZzBNQWJv?=
 =?utf-8?B?ajdkTTBWcDdES2dyVGdpNm1vM0t6bGx2T0NraFVNMW1OS1dxMjU3QTY4UjZj?=
 =?utf-8?B?Q2w0cGNVc1JHUWFabUtzSVpTMFVyTzhkRXVTbGxiYzErRFhGUXlsbkdaMlc4?=
 =?utf-8?B?c0JFN1NVRDN2TGNSZWFYeG9Ca0UvSzh3ajlFUkVNNDFnVHZOeFVWK3BEczRJ?=
 =?utf-8?B?d1Y2SzkrMXBpTUNQVzlaNDZBa3ptV09hTXQ0VEh2K240S1ZweWw5dmwwcWdP?=
 =?utf-8?B?ZnZzRmdESDI1elZlcVcyckUyRCtiT3ZRWHRIUG94dldiNmM0VVNkZnk4S3R4?=
 =?utf-8?B?Y0xwTHd3cmVCQzN6ZHJrbU12ajJ3cTYrK29rbzhWMEVSc1ZhQ0gzVjIvMDdF?=
 =?utf-8?Q?mTLMXZOo/YnX6cZKzmmc5p3n1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c38851-b091-422d-1c17-08db187def8a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 04:48:57.5278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYLQSONoIbIo2Mz0dxve3kb7a1HbKSZzjbGT3Q+TDuLSICqNqwYHTEds8JN+mo5cw3lCzR0dJpv4UQH48TGmMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/27/2023 9:23 AM, Santosh Shukla wrote:
> v2:
> https://lore.kernel.org/all/0f56e139-4c7f-5220-a4a2-99f87f45fd83@amd.com/
> 
> v3:

Pl. ignore this series, I missed out sending one additional patch in this series..
"0001-KVM-nSVM-Don-t-sync-vmcb02-V_IRQ-back-to-vmcb12-if-K.patch"
which was part of v2 review comment.. will send v4 right-away. Sorry for the noise!.,

Thanks,
Santosh

>  - 09/11: Clubbed x86_ops delayed NMI with vNMI changes into one,
>    for better readability purpose (Sean Suggestion)
>  - Series includes suggestion and fixes proposed in v2 series.
>    Refer each patch for change history(v2-->v3).
> 
> Series based on [1] and tested on AMD EPYC-Genoa.
> 
> 
> APM: ((Ch-15.21.10 - NMI Virtualization)
> https://www.amd.com/en/support/tech-docs/amd64-architecture-programmers-manual-volumes-1-5
> 
> Past history and work refer v5-
> https://lkml.org/lkml/2022/10/27/261
> 
> Thanks,
> Santosh
> [1] https://github.com/kvm-x86/linux branch kvm-x86/next(62ef199250cd46f)
> 
> 
> Maxim Levitsky (2):
>   KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
>   KVM: SVM: add wrappers to enable/disable IRET interception
> 
> Santosh Shukla (5):
>   KVM: nSVM: Disable intercept of VINTR if saved RFLAG.IF is 0
>   x86/cpu: Add CPUID feature bit for VNMI
>   KVM: SVM: Add VNMI bit definition
>   KVM: x86: add support for delayed virtual NMI injection interface
>   KVM: nSVM: implement support for nested VNMI
> 
> Sean Christopherson (3):
>   KVM: x86: Raise an event request when processing NMIs if an NMI is
>     pending
>   KVM: x86: Tweak the code and comment related to handling concurrent
>     NMIs
>   KVM: x86: Save/restore all NMIs when multiple NMIs are pending
> 
>  arch/x86/include/asm/cpufeatures.h |   1 +
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |  11 ++-
>  arch/x86/include/asm/svm.h         |   9 ++
>  arch/x86/kvm/svm/nested.c          |  73 +++++++++++++-
>  arch/x86/kvm/svm/svm.c             | 152 +++++++++++++++++++++++------
>  arch/x86/kvm/svm/svm.h             |  28 ++++++
>  arch/x86/kvm/x86.c                 |  46 +++++++--
>  8 files changed, 279 insertions(+), 43 deletions(-)
> 

