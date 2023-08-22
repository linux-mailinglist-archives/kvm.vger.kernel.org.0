Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5A784281
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 15:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbjHVNz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 09:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbjHVNz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 09:55:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D1618B;
        Tue, 22 Aug 2023 06:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1BiSVAYnst00RyhMqHeV2HeeZkWvhSl2+eG+7YGiiR63nu1J8uybvNw4JjS4gfluDRrpD4OtZTtF/Z1XRG2Df8yO6gPROtLoTterOmlw7P9oySHv17RtQ8V8a2OH/hhM6yltrViuRgyQaGUwQm4lw9vGNkux273xZWLHk/82oaomkHD6VCQrr7IMKqppxZly05gwfDlh2eL612eLQ7l6KZXKkjx7Ct75DX2AlsWoMB+oV4LaVF4+D7FGZjMb4M3Y/U17G7F05hOt+R2rd6lXG4gxJZf6NLH6YwxQR4VBiCmMfUqX24TaTD8Yo7nTWC1G4SRg9m1RdrVd85P714HWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DL/rhDzIT3gT9L/xPMo4aYUPbC+hTIxx4zv9pYg3exY=;
 b=MATjWG0bC8IwqWhrEK9wpKD+brRBdpCsqE5HxTRAxk2MN3FlDFufSM04/8H0K7a18okW7ItDtTCtjmNPCD3cXSlj0xKw9Iqx4ZBrr/8QFNiE0ahtCJdIaJEXOKGe063ggUCzyIyMzSavvUVdsSRIItT7OSdiFDwKUHquHAyZDQWT+2fXDqSdcWbcRGn4XyQYMYeE1Nv8YgLYJjxNxYLDQYIEcAazcyk2Krdu7/hbas7Q83gw0AVjVZjmS8fAC1DH0nFeIFCbxMwFSBT/2LEOQfCOT3UFC0y9XvyzTfBypEHNyDSKgh+ZxfSl1r9+dCAvNBifIdpH2Av6ngCocREbng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL/rhDzIT3gT9L/xPMo4aYUPbC+hTIxx4zv9pYg3exY=;
 b=ykNcUAGm2yXXcioLVIkx34ny6j+N70UMbyQA+T12c0OTZftuWHC6OARZVbnQkV08fENKduWRlFDbolMsy5mf/VAE5EQ22aeCaelJK0+HlmVdKgcPyFACcdfrPdaMs4tmHatnwj5ioCA5PGCzT7h+4laZTneVpzjFuykgSXBIu14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY8PR12MB7218.namprd12.prod.outlook.com (2603:10b6:930:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 13:55:23 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 13:55:22 +0000
Message-ID: <bf3af7eb-f4ce-b733-08d4-6ab7f106d6e6@amd.com>
Date:   Tue, 22 Aug 2023 08:55:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/2] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
References: <20230810234919.145474-1-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230810234919.145474-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::9) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CY8PR12MB7218:EE_
X-MS-Office365-Filtering-Correlation-Id: 343a97f9-48d4-4e94-18a5-08dba3176ddf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: clDfuN+oMM0MUPGkCGRi/0unQB5TzmQZb/CCp8DCX97SpaAiJ9EGV5YTlpSpUiQMfr/hKfg0w9t4bJB32dDcLD5muJv8yTJxh9Nxkj4wZQNJ2KkONv00XIu0oZ0UvTfUTn3R1lfodZ4L6jSs7C2dJ90n/TOpixLLzs7OAbO9jSShuPFW7TPVKQuijlK35RWLy7EvrZXG5rTdDGI+eb4XN3VKMZ1JJOK1KTCPDAt67/J+DEVuXP2g9dY5JOfshnFyWpnSiqRBAGLJzYQTj0EoTDZcIRndYye3T2euiTmpQRxSxrqN8IDaU2tQneNtSXepY2O/97LTYqeA+2qrMWqi+wCaLNTMEYzKK3iXiAFLkl54OwoHGoqJdpUqYUUCDSe/zbIQf2I733k/HzHkenS/RqhstXzbPdeifUn9T9g1OX0R7lYqkxPgXE2XTl1XfvjjdOEpK3OK5YczCcI108kJmsnWfaQPNzLsqzIH5ILJ8KS7EyDhBFDyUbBPEqFXL5Wzi2x9nPMVPB7cZAhqB8s4fg2ueINqI6dsqTIwtWeJiULtCi1aV3nEK6H/PkL3McN5brtwvtJGfhWZTc+7C/p9vLd697ZsOFW+u8x5JQ44ucejLxujr0IEo0JH7TooVR053CNv4uHQ0fV3jpfn4pYayg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199024)(1800799009)(186009)(2906002)(38100700002)(53546011)(6506007)(6486002)(83380400001)(5660300002)(26005)(86362001)(31686004)(31696002)(8676002)(2616005)(8936002)(4326008)(316002)(6512007)(66946007)(66556008)(66476007)(110136005)(478600001)(36756003)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1RlYnFxcEpEOFlvY2RHMVNaVEFYMmJvSjBiM21xL0pSWVNtZ2d4eStjK3k2?=
 =?utf-8?B?dHVQbHNEdFRSK1FxV1J1cis5d3V1WlpLcWdWNEF6dEs0QjVpWVZzYUtGK1BL?=
 =?utf-8?B?NzRQWFowMjZ5TVh5VVZlQTJFRkc4MkNZbzhQOUxCYmQ1RGM5WGFWOGlRUGtj?=
 =?utf-8?B?d0Y4eURNTGswK3l2UG5qekZlK0dPYU40YjhYU3RyQlB4bVA1OEsrNTh2SzJD?=
 =?utf-8?B?Zm5hcG9EdXJHUzVlWWZKWkxRaGtzc0ozbjJ5NExSNnlTYm5UVGZTN2JHcFNw?=
 =?utf-8?B?WXpXNHNHM25GU3BvMXpka25kMWlEODhMS2I5cGROL3VPN1hxSUxBaU9pcHdW?=
 =?utf-8?B?WGNScmhycVlaR3E2RHl0d0lOcytJWGgxN3dBRU5rL2ZZcEduOXdia2tabzYy?=
 =?utf-8?B?ZTAwUXFJWSswOHhMM1NoaEZ0SnlyaDJSdnhqWkxvYkNoenpaV1EwR0cyTkZP?=
 =?utf-8?B?ZktyVDQvTXQ4STdVSGZQYkJTbldGVDJzM0VNTG5STnFYQ0R3bHpVRlFkVFc1?=
 =?utf-8?B?YkllWXZ6d0dTNFRwZUYzSWFLRmpQWGY1VUZzTGtjRGVndy9DSXpYNUFnam1X?=
 =?utf-8?B?RTZiemlacG51c0JXRXdTUXJwVjZjZEtROFhqYk5wR1Y1Y0NIYkdhRytJeGlt?=
 =?utf-8?B?ajFCdmdTNGRNeFI0VU5JdmV6UDgyWTZwc3NNWm4vSnJ1cEt3TGNlYlRGS3pZ?=
 =?utf-8?B?VUE3QXYyNm04RTcyRHh2WGczcHN2cDFGQWN4WVJJc2piSzV3L2trdEhCcmx1?=
 =?utf-8?B?bnJqZXR6NWZvVkRmUHQ1bkpoSEgyYitKdHB3K2hIYmp6Q3pyNXVzd3k5cURN?=
 =?utf-8?B?K1hQMkZzV0pSL3hkN0JRd1BpMll4UTFKZ0xuWUNzakFxdkJqeFIrS2t3ZVNv?=
 =?utf-8?B?MW1Fb0JFMkEvMlZnQ3czRE94aTZkNk9ZbnNzZ3FKK1RIQ0tIYlZqclJXVnZw?=
 =?utf-8?B?N2lobkJWaUdWK29YaEJPcE9Ncm0yNlNJOG5RTG42S0FiWHQveTAydzJTV0tv?=
 =?utf-8?B?SXhSNFUwbGUyTVRkRWxvWjJNcjZ3UkVMN3h0N3VMZmFJZmNJYjZaY3AvQ0tB?=
 =?utf-8?B?cEI4NTYva2xCOHl4QXBPb3dFU2paU1N1VUtWYnoySFppcS8zelV5QnV5YWlu?=
 =?utf-8?B?elgrdlFGWkdIVzF0YXJuY0VyT1dxMlorU3MyS3U3MW1TV3hPK2x2VzBsZ3h0?=
 =?utf-8?B?eG1DaXhhVFBNdEpoR0pDT2JiRUdpeGlZR3hDNTdkMVNOaytkenJ6NmZuQVB4?=
 =?utf-8?B?OVRXamFGT09uWDZOWXBxdC8wdzdyTjZpcHhyV2M1UzhRaE1kVTgrU0UwUFE0?=
 =?utf-8?B?N05pY0tQMm5xQmhrVHpvdXZ3WmtOOU5JOWNjWlBCYXpqaHlEUzB1QnlmWWVl?=
 =?utf-8?B?RVdGWndvK0pLVlBFZGlVdzNqekk0YlBUQ3lVT0ZuU1dnSXZqTmMrWVVtZUpM?=
 =?utf-8?B?bkFLaHVCbGQ1VzFlZUNqNFBLUHdKQnpBTGloeENrMlBFUWx2ZnVmcmdRbFB0?=
 =?utf-8?B?SERDTUtnZEpSbkNEZUN5eDBhSXBpK2N1VlVxMllxT0RMbkJLUWU4SkZYM2hL?=
 =?utf-8?B?R09OL2QxdExFMWJzbDlrSU5JYVFJaThEOVNrbk9WR084bjYwRW5sajlnaCtI?=
 =?utf-8?B?NE1sTlhiTGtUcGQyMFJOZTd1ZXZoQlIreDU0cXR4dU04a2RUbmhoaVFQaHY5?=
 =?utf-8?B?Sm93elhpRVdMd3JFTnhMdGRwMVcrVjh3OXNva2t6a1Nyc1VmcnFDWmZuR3lm?=
 =?utf-8?B?emM2ZGlZN2sveVcrQUlIRlRyZ0M0RDBaeDUwOGgraWZwM1dKU0VVYjlPVlJs?=
 =?utf-8?B?WXBLeW44bHpxY2lVMktzeE5XTHJIN2xQZVVYaG1WOS9wbEVKNnpyVXhnY1JD?=
 =?utf-8?B?VEtSYStpQ2hQeVpFOFRSd2ZjRkRtazk4Njdpdjdzek9JajVlQnlEYytFYmly?=
 =?utf-8?B?MVZQZnRwV3VYNCs0UFVTSlVScmpLUXY5dkF5YmUzelpLdTRsVWMyZCtnRzc1?=
 =?utf-8?B?Q3ZpaWVWNjJ0MnBkY1BOUlREM0pqc1VXNjlVVXhUNDdxdkJqeVV5QllPeWdr?=
 =?utf-8?B?enhzaURyZndFQlFJQWF4cFEwWWZGeU9wbk9vWlBBcHcxOTZDc0pyQ3o0R1JM?=
 =?utf-8?Q?njFtX0dWvP3FkDQtuhmFe/exE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 343a97f9-48d4-4e94-18a5-08dba3176ddf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 13:55:22.7814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q89cDcg6XnGVRPQpJg7upKUGw8+vKaPTpFZRlVQfSLMVeo/9YUvvKMGbQ32oAvuIFb/yAE618cPcHdP4bgeGdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7218
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/23 18:49, Sean Christopherson wrote:
> Fix a bug where KVM injects a bogus #UD for SEV guests when trying to skip
> an INT3 as part of re-injecting the associated #BP that got kinda sorta
> intercepted due to a #NPF occuring while vectoring/delivering the #BP.
> 
> I haven't actually confirmed that patch 1 fixes the bug, as it's a
> different change than what I originally proposed.  I'm 99% certain it will
> work, but I definitely need verification that it fixes the problem
> 
> Patch 2 is a tangentially related cleanup to make NRIPS a requirement for
> enabling SEV, e.g. so that we don't ever get "bug" reports of SEV guests
> not working when NRIPS is disabled.
> 
> Sean Christopherson (2):
>    KVM: SVM: Don't inject #UD if KVM attempts emulation of SEV guest w/o
>      insn
>    KVM: SVM: Require nrips support for SEV guests (and beyond)
> 
>   arch/x86/kvm/svm/sev.c |  2 +-
>   arch/x86/kvm/svm/svm.c | 37 ++++++++++++++++++++-----------------
>   arch/x86/kvm/svm/svm.h |  1 +
>   3 files changed, 22 insertions(+), 18 deletions(-)

We ran some stress tests against a version of the kernel without this fix 
and we're able to reproduce the issue, but not reliably, after a few 
hours. With this patch, it has not reproduced after running for a week.

Not as reliable a scenario as the original reporter, but this looks like 
it resolves the issue.

So, for the series:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> 
> base-commit: 240f736891887939571854bd6d734b6c9291f22e
