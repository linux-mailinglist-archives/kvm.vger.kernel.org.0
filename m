Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D3B7943B9
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 21:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbjIFTSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 15:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241774AbjIFTSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 15:18:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F6B1993;
        Wed,  6 Sep 2023 12:18:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SprWjnbj5Jo4dlU2oAEYKwEHx+gm5hfTTYNbtkFWDopSefO2xrEiH9hpIS2Bem3qFIq2aIg6G05tzjSZTdGg7D/KdGbhQBCvW1TUxAiUBQ/9VmcUidriAtDGwoMgvKT647XDdDaFBRTgDq/FTtFhzcvGSozNoDchTqC4dJ5bKu/7WnNP7M4XPc+3EXQhZ4xqU6EAYxjjLHRdGNhmuxgYEmO1+8Sb+BzdhG08zVAf4pq7izSwkCiKVa3YhrMddgYThtukMOR8bTa587cSiL64XItFIsTvOS950CiONHf+KnI+Om1JyTmz4wmKSCgGosz9iqrFh9bxoAVhNixPtjAuPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwaT+EYqNDKGFfJN4Z60heoFv5zxPYiXs0SjcZKyf9A=;
 b=gwf1dc3b4cyoHIw29dhlOrcqSEl2Il7OOSiiv5UMW1/ZS/Wmc0oO33s6WJig7LeYhGQbOs6rnTCBcFlcp9kp7GYXT8BLL1WcTET8dcYioPJf7s7gS3xpdcrvv/voVr0NQW4A6oKc1CILIclWpfIpzowUBigYrSXJLA7lFiC4tmLcZybB+B19CuwjniTGYImN70wVFksACpiTbI2zS9LekGhWJOhvxv6+YLErxcKQrwXVUe+VuTc+Cphtic/NyEvNF0MjISLWM3ZcsqF2RAnZCT2cr/SoGM7aCjob+q7p/0vM6wniosqTnV/AETroh4TBbmiA9cSGXxuVy1xijblIHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwaT+EYqNDKGFfJN4Z60heoFv5zxPYiXs0SjcZKyf9A=;
 b=sXkZpFOEsHcJto2PnKf90UqZfhSmjlbXIeQY3O2KxZQPzDPCcB0yaJ1CgokxwtRthlZaQTZ+zIa+r7qegyxnUAz4aD+pErFvVL1YBzlRt/mQq/yTF9tdWHA3eo2JragNHluwaoTQewRAd8oVbsBEAZO5uNv/fxg3GS7fUTiISlQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by LV2PR12MB5965.namprd12.prod.outlook.com (2603:10b6:408:172::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Wed, 6 Sep
 2023 19:18:23 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6745.030; Wed, 6 Sep 2023
 19:18:23 +0000
Message-ID: <68a44c6d-21c9-30c2-b0cf-66f02f9d2f4e@amd.com>
Date:   Wed, 6 Sep 2023 14:18:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH V2] KVM: SEV: Update SEV-ES shutdown intercepts with more
 metadata
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230906151449.18312-1-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230906151449.18312-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:806:122::21) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|LV2PR12MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: c922162d-4946-468c-b492-08dbaf0e09f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7sGamFmNj9RgOnsMevwAHtVpwrU2JdIjk8qUvzoflsY7FoxkwppewbnUPK+GAVylYdZgco77X07X7QBVLfoEAjFrUVG5OnEHJHS3XWpmE0tU0oGkhTyITk61pEsXS0dDxE2Wr+p69G+peyv2EKAWTFz7BA/TQLqVTKr9xnbfX6Dr+RdMU7lzGQFQMOnsExv73QLQi/nLirdb6IJ9xhmvDFyMxxiyzKHAuc8D9t9zoHOtRPtAYzE3phG9BhuCMNesRXdayz77hv2MTvvArqMag7K1DsN6oW7ju/1HsVZfHaq5U33FGDJoH8lQlyKNFI+OO8/E617eJk7pBi0ltM7uxQGZPDeYvOotsqjCPZ5i3hvAcp5F0mLgSYUTr47w4WBQsdAMp5nYSL+C+kTWJIDEHwlrXDPlnynmi4dwxsQWjUX1/n09iVsHkL2lrZMKa0K5tI0gGdwTRxDYIqYAaXoig56aWVHoq+5EvTp7a+Ifjt7mR+oz6I9oe1CfvTAFjH4iEwDTPsGF6OAuky02xF/qF1l72MbDzEnvfv45+Xo/lPlPDzcCasH7ET/Wn3oQtSyCWO2riZ/xStit3SZ0lb5pSsZbDawv59IC1wSMYwe3qf2ga96vw26VKakjyNfrSW94MvngrRBNvJDJHxQrCm1VUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(376002)(366004)(39860400002)(451199024)(186009)(1800799009)(6486002)(6506007)(53546011)(6512007)(478600001)(83380400001)(26005)(2616005)(2906002)(15650500001)(66476007)(66556008)(316002)(66946007)(54906003)(41300700001)(5660300002)(4326008)(8676002)(8936002)(38100700002)(31696002)(86362001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEpaaW53cnQ1NkFZdHFVdjMyNTczZ1ZwSVZoc0QzZ2FmMEhYcVp6Y2orZWFq?=
 =?utf-8?B?eW5kTlBFODQydE4xMlc5L0FxRTFJNTBMOWVDcFIwd0dBQWlMdjR6WTF5ZDN6?=
 =?utf-8?B?Ti9mMkVjVGVRdTlJL1lNREFYY3hDTjdyQ2tPSURhNGJ4dkFFZE5SeGhOQllv?=
 =?utf-8?B?QkZBYkRqRTZIZnlsNCtUNCtIUkpxRmdFWmVQbDNTKzFod04veGVPOXhDRFVw?=
 =?utf-8?B?QXFkNTdYVFg4dkN0NjE5b0JPeDNpNHNkY1FtWFdoa2xKMWl5TW45NU5rTkhX?=
 =?utf-8?B?d0Y5VU95TGgrNWZRWEF6bm1mL2NLZVBGVTZjYVUxZGFadC8ydUgzY3lSbGVy?=
 =?utf-8?B?Uk1OcDNTN0duWWJUQUNvcGs5cnF3Y1Q0NFpuK3I0R1diNHZMalFWVUJJWkNC?=
 =?utf-8?B?OXhIY053Q0prN2pJQjB6Z3Y0ZVVmQk5yS29pNTdrRVlmUDBuUlZhQ0VWVEt2?=
 =?utf-8?B?MTZMMjZscDg0RWtLVjR4K3Y2Z0dlM2NGSTZrOWVlZ1YrVXpQYS9PLy8xdzdr?=
 =?utf-8?B?TTV6cHJ4M0RLd3RMS05oRnl6S21iVGp4UFZqeml5aGpVMVA0YWZ0b1ZLcFJT?=
 =?utf-8?B?SXJNalp2VkFuV3d0K09CLzd4eVRLNzdPMmkvNFJlZmtBMnhyYkpGZ3kxWWNC?=
 =?utf-8?B?cXQ0TVo4dGNJYk41L2U0Rmg2Y3RJME41Nms5cGhZTE5UWlU3aThWTGRMRGRG?=
 =?utf-8?B?OUpHaUxwejhPaE1OelBWR2krZCtCK3NVaFFXUXVRMGRiamhpQjBJdVlEajFk?=
 =?utf-8?B?dE5OcEE0bWNIL2hxZ1dwT3BnUkd3NlI4QnY2WVhXbGZNYkg0RGY0YUJjRno4?=
 =?utf-8?B?eEdmZkQ0ZEsxcTNualkvTGxLZUdBU1RRMVIxTmkyQVpZTnV4RDN1VVh1Sk1P?=
 =?utf-8?B?M3VjaWg3MXRxQTlxQTJPTWwwcHJFOXdyTVVHYWF0ZWhhQkdQQkI0WGJnMHRj?=
 =?utf-8?B?ajYxMkFscU1ibjVGR2ZtZi8xeCtYNEpqNWhPUms4YyszRHpPWTV3QnVhQkNX?=
 =?utf-8?B?aFExcXM3ZW1NN0V4aW9YK1c5L2lRUC9LQUllQVZ3SWllZ3hVbUliUzNsVG5B?=
 =?utf-8?B?K3ZTb0hCWXd3YUhtc29FOFhJYUF5SkFpRDA4cUR6bFJJTzhnbEJVV3U1T2NE?=
 =?utf-8?B?UVRPNGFUWW9qaFFPd2xDYnpXY01QRFBBNjNCQzArU2FMTTdkakhoNXF2a1lv?=
 =?utf-8?B?UE9NWjJsS3dVVnlXRGRmZVdvWHowOWV4OFZXZi9EbC96dUl1UE5TRHN6Q0ND?=
 =?utf-8?B?eEIwNDMxTVFrNUhLb2NyWVZaT0hvU0kxV2VlcmVUZjNmc05RRURVMWFEWmNO?=
 =?utf-8?B?dmMyUGY3Tm1qeTdZRGhBcmUrWkdHU1BmQksyU3kxSWIrRzkrSjVZYUsrSVZR?=
 =?utf-8?B?Ly9YSDBPYTZWOEhoUVNQKzdVYjRXVHYwSkY4V1Y5a0ZiSXdpdUpVNmhCS1Jm?=
 =?utf-8?B?d3RwZTVuRWZwdVNlQmZ0T3NyVS9ObEpteGxSbzlCYjU2TEFEejFobTY0cEhF?=
 =?utf-8?B?a3RtOTJ0UlZTdVB5QUdlTjVYMlIvT0t0Y0pvWTE3bWlwTmdyeUc3eVlmRDRx?=
 =?utf-8?B?bHhOeWsxMmJpTlNwLzZoZVU3RW0wKzhTVzQwZCtUNVVUeFZEelpLRm5RMEpi?=
 =?utf-8?B?WS9QRVNLdjBRK2lmNFY3bU1ZL2x5TVhpTzZkTmc2TGtvNCsrQVEvNXJRV29Y?=
 =?utf-8?B?NnFtbHAvWSt4MHg2NHVRUWNoZzJ0Y2JUNFo4cjAyaWFkZWgxRTVEaVYzYkpZ?=
 =?utf-8?B?aGZFc3U0TG43YnlvU05wbE03WFBMYVErSHZVUmlMQ1lsOFlxWWxxSWtweDJQ?=
 =?utf-8?B?Nkx0M1hHWDhEWmdUKzJDcE9OMkVsNitTTTlGNVV3ajBLbVM1ZDVoWTh5aktR?=
 =?utf-8?B?VmV4MjB3Q1diUkNCWGdOWXR4U0FsMVNGYVNaemhPSlJlM1FHcXhyVXU0RkdF?=
 =?utf-8?B?cks4Zjlrd1pnanpTOW1Lc3FiQ2ZpaHJWSGhxejgrVnpETzJFREhtczk1MzNj?=
 =?utf-8?B?ZGpDZDRtK29PMWdIdmU2b25rWGdsVHowbU81T0M5VHVCQjcxaUE4Y2ZpUU8w?=
 =?utf-8?B?dUR6N1psc0hlSk9FdC9aSEtaVkV5NkpKYU9mcFNTbjQxMGcxOW9UUWo3TmN4?=
 =?utf-8?Q?RhjNg3yiOCnbRqdhstgwRd8+X?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c922162d-4946-468c-b492-08dbaf0e09f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 19:18:23.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJcqRce6evtsNKrD3B/H7GrJGjjn4CC91lQVyyrsmDmYxONpQb7+c3RxbsbFIxBt1S1mdhesD7KyaR3Sf7T0lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5965
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/23 10:14, Peter Gonda wrote:
> Currently if an SEV-ES VM shuts down userspace sees KVM_RUN struct with

s/down userspace/down, userspace/

> only the INVALID_ARGUMENT. This is a very limited amount of information
> to debug the situation. Instead KVM can return a
> KVM_EXIT_SHUTDOWN to alert userspace the VM is shutting down and
> is not usable any further.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> ---
>   arch/x86/kvm/svm/svm.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 956726d867aa..cecf6a528c9b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2131,12 +2131,14 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
>   	 * The VM save area has already been encrypted so it
>   	 * cannot be reinitialized - just terminate.
>   	 */
> -	if (sev_es_guest(vcpu->kvm))
> -		return -EINVAL;
> +	if (sev_es_guest(vcpu->kvm)) {
> +		kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
> +		return 0;
> +	}

Just a nit... feel free to ignore, but, since KVM_EXIT_SHUTDOWN is also 
set at the end of the function and I don't think kvm_vcpu_reset() clears 
the value from kvm_run, you could just set kvm_run->exit_reason on entry 
and just return 0 early for an SEV-ES guest.

Overall, though:

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks,
Tom

>   
>   	/*
>   	 * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
> -	 * the VMCB in a known good state.  Unfortuately, KVM doesn't have
> +	 * the VMCB in a known good state.  Unfortunately, KVM doesn't have
>   	 * KVM_MP_STATE_SHUTDOWN and can't add it without potentially breaking
>   	 * userspace.  At a platform view, INIT is acceptable behavior as
>   	 * there exist bare metal platforms that automatically INIT the CPU
