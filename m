Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D313F7D2377
	for <lists+kvm@lfdr.de>; Sun, 22 Oct 2023 17:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbjJVPAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Oct 2023 11:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVPAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Oct 2023 11:00:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737E8A4;
        Sun, 22 Oct 2023 08:00:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwF3IfuH46EcuT+1D55+UM9EuZ4kcxPX10bn/fDSGINPDUuGJfq+MOktB8tBnURlBHlMzJovS1GdiNv21vJYqpyOakR2shr1A9vZuEmGRIldfWb2jG8udY7LK12p1omVzbJ5QyB9XkxzEdCVY6tn3lC+NE0jw9uT2g5+3fYzhuRua/95tjW+i0zuyVvMQpaGCqJtR3mN7ZuzHst7XRuqyf3YU8ry0WpM2FHBHNLVbtT7/wCnLacMaD8W9VH49CBBbcHmd2FP79Y8anLmuTN6jcKjxkeh878NQUsnIwnOF6LzByeyQZzH5QQPHacMfncfAkjgUMBxgxzOQ82MyfuvMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lC6ku9+ptU+GqNwTjacK7+c/zF3jg0L7sCBl/V3Sfqs=;
 b=VFt+hEopCuK6QLR3X5Lvmm06KMBo9JHeMvb24h9rPdyGXsE0hnphAWQPwe9PurJHn4CzEFY5knPaVFb8TDkYS+szx/KbYI7s+SeNlFNyrJiJo7E2os9OKeu6NQLDBXCxhv9d2rqaO8Qbb5Az/1OwGUEqPIqXKswWMUiaNCD+R6byBLqypBmedVv037rEcDTrixCdFB1nA0dqt4NDjFfsjr7mRWo5cuA1gGVa1YpeH2c7uW03RLknZsdlqZJqte2PomXURisot1FQoq0XtaiQNyFhFT0j68jlsH+E3tbAXKQU98M1pJPY7IaiMgxdaCE9ir+eRHcPjRYru/er2stc9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lC6ku9+ptU+GqNwTjacK7+c/zF3jg0L7sCBl/V3Sfqs=;
 b=na5wNjLU0QdOB1zIjZpm4OoB/HuUMnGOjNkfrVNXKO7dYjiW3iRpK6WsGYXPWKvbKaUrQ05jM27nDVxJoREPIhEuqwGGYfuYcrBPcV3rSe261abf3AOf6+fTn3wVb7wriq2xV81zKt0+8H91kq6Ukr1j/ISGkG7QNj8vVGrOXhA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by BN9PR12MB5145.namprd12.prod.outlook.com (2603:10b6:408:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Sun, 22 Oct
 2023 14:59:56 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::8da7:5c21:c023:f0cc]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::8da7:5c21:c023:f0cc%7]) with mapi id 15.20.6907.022; Sun, 22 Oct 2023
 14:59:56 +0000
Message-ID: <2b1c8dde-3ea5-c687-2326-e1564ca7edbf@amd.com>
Date:   Sun, 22 Oct 2023 20:29:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] KVM: SVM: Don't intercept IRET when injecting NMI and
 vNMI is enabled
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20231018192021.1893261-1-seanjc@google.com>
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <20231018192021.1893261-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0090.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::30) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|BN9PR12MB5145:EE_
X-MS-Office365-Filtering-Correlation-Id: 6145b6e3-33ad-42c2-c7bb-08dbd30f8d8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMVdXJjHiKKExN44j1RkDdX2W5k0hWKNdU7X6r9YYqmnKCEDK05+QLgz45NoD0r8V7yZ55WUb/JXOga1ARj1kYBHHZEPe0hvkBvu0jQTJRgnxhD7uSQ7DmSGgzriGCXlFHg/T+AvSKuWo9i1MJMocPclZGOz51PMlHiJzf38sitZFCDVvh5PfiIIF56VCm+dVt+kJ0PSZWeR3+pG4wE+aH0oVXCElzcVNk4LOAQOSzHnWFAQG1Q2vcBf28dH44Etfqp6kIjoxmkzklKmuqirNFrIoU/YXaTqfXh3VTJZEp0xgeyA1mBfmLK748ArSa5AduBnzlXOP2lpYDQ47ZoQWA6svbYPghdj0fu0RWb1dEw8DMCW91nd1qqx6+dReOhtccPZLCrCBmhbOsiV3mW88gVgnsWgpTN4sSsWncF93nE/+TpsySRXN2zUwSVBVPSd62JTiEa27HfaCT5gqCDGUMrau89S+Mpwpk2cYaX7b24SH6LHEkACysIG1Ah5HNkAdFvfubF4JntozzteSPdpeCY9oL8VWFUG2c8GNzr8Y+Kf0tXWfSNI2Eo47heZaPnvn4PuwUjc/TvXa7IR1NGVesXgD4X1nzPSMtuvOfsmc5q2fEPv2/fvHmsuQd1+K30ZE3WCukk8deKszIOf2eGQ08pvFKXuX4V5JSOlOVpAp1QhqDTd2uM3xV9uQvjCVmmI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(346002)(39860400002)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(31686004)(31696002)(83380400001)(5660300002)(44832011)(38100700002)(4326008)(41300700001)(53546011)(8676002)(6512007)(26005)(6506007)(2616005)(2906002)(36756003)(86362001)(8936002)(966005)(6486002)(66556008)(316002)(66476007)(110136005)(478600001)(66946007)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWpEZzIweVB3N3lRdkRKYjJnNWFNcEJ5UWpHZ3RYY3FaeFczZnVEVVhqUXBV?=
 =?utf-8?B?ZXF3dFloUE9tUDY5NldzOCtFbHgrY1BMMGR6L01OSnc3TDNFWTdwOTJ1RTBH?=
 =?utf-8?B?NExEb0FVK0RCV2JweG0xcUNrTUlJRzhXUjExaCtZTy94eWMrbVlZVWR3OWlQ?=
 =?utf-8?B?T0RtYUx2NFI4OXJicldtQTcwSHdjUmduOWtwTzN0K2JFeThVQmtLbytJL2VN?=
 =?utf-8?B?aGVVNGZmSmxmcUhQdW01aHNacTAyd1VHZFdxQSt3MlN4NktzT1k3MEhXeExC?=
 =?utf-8?B?RlAxSW5iMVNYUW9rN3NJTnptaWpDbUJML3VOTWsvUTgwQnVJSnN1N3ZBdnND?=
 =?utf-8?B?MGxzazNGQWxub3FZMTEwWVc3WVRPSjVZNzU0MDZJOUYwRitrKy9VZDdRVVhu?=
 =?utf-8?B?MzdzV2x0TVVpVFVKamhMVzI2MzlHM0R0TmQxaHBZbGprRmd1azBiQWozbldy?=
 =?utf-8?B?VlQxTEdUY2VQa2JnUU12M0VZTGVpWEtIZnFiU2ZDNG9CYlhMY29iWUtZNy9t?=
 =?utf-8?B?WHBIclZWMDJxWUxvSUllNFdtWm9wYlE1NnhEVGpNeVR2WC9JYno2d2VNSlJI?=
 =?utf-8?B?enBaUlZ2MnA4bnZBTjhHZTEvcXpia2M0QmdvQ3hyUGx1bFNYdnJhMGc4blNR?=
 =?utf-8?B?aldWNDhDamZ6QVZQcW1aQlkyNlNmVWY1VmZrb3M2QmhsbS9wTU1mRnJwWVFw?=
 =?utf-8?B?elFIRTdoWndBbVlVUklrbDRZQmhCQWp0ekYzajhCbk9VdTlnZHFWdVZaeTM0?=
 =?utf-8?B?VHNYMnhXQnNvQWxSWTE5ZFBtTG1jb0gxSEhnOXFsNUUzTDA0aHA0NTVlcXFu?=
 =?utf-8?B?S0FlOFpuR3hXZ2N4eCtpcnRKN2ZNQk1GVjd6UEZleUxDcVl1b2xsQnc4bFVY?=
 =?utf-8?B?WFpXTVM5MU9mem9jcCtSRHd5N1pTdHlvMjk2dXVXM2UyMTFSL0FLNEFRcmZC?=
 =?utf-8?B?cUZwbVlmOVlJQnVNajVWOVFLb29yb3h2TWp0a1h4YkhwdlBheENSaHNVL2Va?=
 =?utf-8?B?cFRkWTJSVWE2bjFTcVlzVjZoYjVmOVFjeTEyUlpmSEdLNUwwTXJvNHQxM09n?=
 =?utf-8?B?dWNlTlFEbUJNaDFUUTVuUGhXWldmMnNESUtrUms1dmhVbW1pTWJzcU9pcE1z?=
 =?utf-8?B?VmN3MExER3U3RkM3ek9ubElFMmMyNTdRcS9VcnpwY3NpMGUyazVoVlZtcTA3?=
 =?utf-8?B?aG9LbXlPS3g4OXExMk1oYzNpK21oeThoRk0rd2FuMXFBUFZidUdSZ3l4ajJn?=
 =?utf-8?B?ZnJIdWhmQW1hSUxGYVhRTUxFb0hFSmtmb1gxZEdldEptcUJNWmNhMkxhYk9n?=
 =?utf-8?B?K0w2QTRKbUtieGk5bEIxcXYyM2szUVlZNUFxSUJxY2g5dWVJK0dWdWlKajMy?=
 =?utf-8?B?TThMM0VLU1ZuMmUxeXE4RlRSUlZQTE43cmdJMWVTNVRYdHcyNDI2UjNuOWQw?=
 =?utf-8?B?SmV0MGc1dVl4akdLb3lBb1NlZ0FjU3c0K1NZM1ltYm5yYWhnZldBUlFUR1ZD?=
 =?utf-8?B?clhTbVhOUldVRDliWUJQam9lSnNUU0dXMmhPTlRiQW1tVDVYZk8xbG83emw5?=
 =?utf-8?B?OFU4S3NPTTdJM0ZSbEUxK0NsbStjYzVOUlMyVG5pSUxORVhPYndnWlJEZTl6?=
 =?utf-8?B?aC9lOWlucVkzQUx6M2pMMzNjdzdSM1YzWklnNTlFNlByVzB4OWZlUHRlKzFv?=
 =?utf-8?B?TmpXUjdyQ3VWSHpPLzZnWmJaYlRrSnBWQTFNZ3p1dW93QjA5Z2JWWkQzajFw?=
 =?utf-8?B?V0xIK2NoTUJNZGZ5U0pTWmQvbEJxUW52NEovV1J4TURrazFGL1hmdVYxQU95?=
 =?utf-8?B?emx3RUhFUkpjdWJsaWIrMjgzc3hkR05mVEtrWGVxbE4zaXJPK3ZndHlpNVRN?=
 =?utf-8?B?Sk43OU9sSE5sSENjTHYzR3B6emczWEVGT3NQRWJESkwyNWlXTjc1b1Q5czV1?=
 =?utf-8?B?bWpJQUpXNDRVSkNUYWR5K21mcDJtNGVDRTduajZLcytSdnNrRjB5ZjV0d3pP?=
 =?utf-8?B?ZFhxdVpVQmkvZ0tRdllKRVh3Z3FTbHBUTEgxTmJOVGdSbUR0VXN3OUpLcFBn?=
 =?utf-8?B?YUVkUEFFb3h0MWgxMm1uN094Q1h0bEcxU0hkaCtxRUhTOTdsNE9uL05GRzg0?=
 =?utf-8?Q?WUdO/1Ym4FoRYslduPPg6yJf8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6145b6e3-33ad-42c2-c7bb-08dbd30f8d8d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2023 14:59:56.0304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7/JnBw5xrAwg3umj9ToGjcQKUbP1+NkTrqSCcg7H3A41lRfufKPA8XCFcZnDCG/GXbhIXS/g8qIIUmL9R/lBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5145
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/19/2023 12:50 AM, Sean Christopherson wrote:
> When vNMI is enabled, rely entirely on hardware to correctly handle NMI
> blocking, i.e. don't intercept IRET to detect when NMIs are no longer
> blocked.  KVM already correctly ignores svm->nmi_masked when vNMI is
> enabled, so the effect of the bug is essentially an unnecessary VM-Exit.
> 
> KVM intercepts IRET for two reasons:
>  - To track NMI masking to be able to know at any point of time if NMI
>    is masked.
>  - To track NMI windows (to inject another NMI after the guest executes
>    IRET, i.e. unblocks NMIs)
> 
> When vNMI is enabled, both cases are handled by hardware:
> - NMI masking state resides in int_ctl.V_NMI_BLOCKING and can be read by
>   KVM at will.
> - Hardware automatically "injects" pending virtual NMIs when virtual NMIs
>   become unblocked.
> 
> However, even though pending a virtual NMI for hardware to handle is the
> most common way to synthesize a guest NMI, KVM may still directly inject
> an NMI via when KVM is handling two "simultaneous" NMIs (see comments in
> process_nmi() for details on KVM's simultaneous NMI handling).  Per AMD's
> APM, hardware sets the BLOCKING flag when software directly injects an NMI
> as well, i.e. KVM doesn't need to manually mark vNMIs as blocked:
> 
>   If Event Injection is used to inject an NMI when NMI Virtualization is
>   enabled, VMRUN sets V_NMI_MASK in the guest state.
> 
> Note, it's still possible that KVM could trigger a spurious IRET VM-Exit.
> When running a nested guest, KVM disables vNMI for L2 and thus will enable
> IRET interception (in both vmcb01 and vmcb02) while running L2 reason.  If
> a nested VM-Exit happens before L2 executes IRET, KVM can end up running
> L1 with vNMI enable and IRET intercepted.  This is also a benign bug, and
> even less likely to happen, i.e. can be safely punted to a future fix.
> 
> Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
> Link: https://lore.kernel.org/all/ZOdnuDZUd4mevCqe@google.como
> Cc: Santosh Shukla <santosh.shukla@amd.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> v2: Expand changelog to explain the various behaviors and combos. [Maxim]
> 
> v1: https://lore.kernel.org/all/20231009212919.221810-1-seanjc@google.com
> 

Tested-by: Santosh Shukla <santosh.shukla@amd.com>

Thanks,

