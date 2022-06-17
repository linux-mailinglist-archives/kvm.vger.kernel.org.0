Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E79954F973
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 16:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382650AbiFQOnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 10:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382246AbiFQOnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 10:43:04 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B806D20F77;
        Fri, 17 Jun 2022 07:43:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmSoOljkqCD8a3gUDD2OEIRXpLxBvNnUaJTCQ6r1nxSHZMcfLjh+oUBeaM1xaelKdzKeJjqFcBtdZYpgr3C7q/XPhsMZtBFc0THQtwsjIwIHizoaQoU3g2hyHEHwCcGEuUGV252nuVDauSEPqLa/bPHBAp09mvWxBUC5A6NvumIPHgv3T52kyvCRBBt5T6wgHX3Dj+0VLy2ITaQEzlmq637gBqYXR/1KXR/G6ZxAHximUlzGeVkjsyNVA3yKTrmLQSey6WCCDc83tB/WZeukpk9mln3s/8uaUgnKqtFZCMDeD/kN50YsCLZRTxpqT2kx9WE2P07QhVqrn3Szg9qDig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ontcMLIyGdVzMs3W8EJBSqdcL1MuuMnhxPAqs3VC87E=;
 b=YUrJSDSnBAviFHzwP1gHnBRpWOdE8t3sWrON+U4QyJne7DtZjPkRT8vtysWhTijyRkIdu64gxO1GvSmxQjBVwYxfFvK2UsKzHX3jgU5RKrzOV6fwNhx7C4EJubFgn+rBNMXXR7Hfnfb2hfDmaLRCW22oZhCWcwd5w9Eu8W0AXhZob743MHldHYf6fcP4DcdmtVSGdEndEprk3nydTuapT96s3KEu7ENAx6hdsnfQZKSvi4U2X1XAVZ/qZ8AANsDiex7s3yFdyGVDiYGqgI5J5qQ3KHnNleFgNdNxbcDoCJ1gf4Ouc+oZA6CzClirGkc+UFMLJOIQGw5k2C6gXWTsSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ontcMLIyGdVzMs3W8EJBSqdcL1MuuMnhxPAqs3VC87E=;
 b=u1scGCQgLjAiyfa7l6Nsp8iRyrHvB6/AJTwDLWIMCcb9+BcoqocgXclfmBifg641H06bziYkKJBvgQCrdi1P7+ERBrKeFSl2qPYdU1Uf4x7ROs29dZMqMarv3lTRzFvTlwEC11t1Nz0odtiLsqd/93VDNXiMr5Lgb4SkrBIRjKs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CH2PR12MB4069.namprd12.prod.outlook.com (2603:10b6:610:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Fri, 17 Jun
 2022 14:43:00 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 14:43:00 +0000
Message-ID: <737d3bda-0f97-0689-53e9-21bd11ae647e@amd.com>
Date:   Fri, 17 Jun 2022 20:12:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/7] KVM: SVM: Add VNMI bit definition
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220602142620.3196-1-santosh.shukla@amd.com>
 <20220602142620.3196-3-santosh.shukla@amd.com>
 <bd37180680b3e3ecec85b5151742092b9f1ce9ff.camel@redhat.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <bd37180680b3e3ecec85b5151742092b9f1ce9ff.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::10) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c95ac4d5-1f19-4502-5b23-08da506facde
X-MS-TrafficTypeDiagnostic: CH2PR12MB4069:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB40692CA636DBACEAD75647B187AF9@CH2PR12MB4069.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8T04Jk3bTDHFihEWHHCrYemQAyWSGzgOSEJ6+38TeQhuFjUxHhZtEfmVIzR6o1VR0GCf9O3iRjRoFPIwcCtn2i+n6AjOpFtiKJasIjT8B2ZLO9ewfyRAaoZ5aSWOjtLRdfLH7h1JK1FuSONbmFkcRP4gHAJQWvvaK0Y83FPfdyTdNxUH11zzDrH9WyaJCp4f5DU8hsulSy2M0JYnxWsIBS8awy9FHd/PeLU31J8gOvF2O+RFqtpBaI26ddas1/O3Pwqq1NYj50s5RyObuMh4eccZCyvosPcJvyE5kN5MBbrlqbofSt49iwpGkCTByE6wmV0UAX1pVao6x5QWz/+zLjP5htAcMlGMI9DEkXpArL1y3ZEnxDh+xgT2jkZgsA8gtkh9mVlmyjy1/Qm1Zdwz/dbR9lWnvszmGcEUQ2+Kp1ByWIjgEu+2xEQ7XExTmP3UUzwtQ7i+RFl7GwQVO216VLffmEPGQlgFcpzcmBq938YCvz30Ex6HYbsuDMnGRE1J0sxlCJ0MCGN9dpygFq6ecoGOMan5JAfFIW/IWKlLTy9o6RrDbo1AXWoRVhol8ewIBigC3hR3/YBujoCAame3pXkXcer8CzsZGT4c+rw9BUS0f4xCab5SaLYd2o5nOT3vfCQj+tmIupi1IUXT2yBEc9tR/DPbhznqYP0GC1ERH2BtlgMVhBbFqInus+ObWc02hCHV12XmK57nfJCMNvAzUwOfDG+1Y0j28WXIkQfHD1cIxUpPp+w1yh1qPALDW/hY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(186003)(5660300002)(31696002)(2906002)(36756003)(2616005)(38100700002)(86362001)(6512007)(6486002)(6666004)(31686004)(498600001)(26005)(316002)(66946007)(8936002)(54906003)(66476007)(4326008)(66556008)(110136005)(53546011)(6506007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVFqU0pYRmkzbHF6NjZtQXRrTWNQdzNhYjNIbjRIY3MrRmVkV1JEQXlCWExK?=
 =?utf-8?B?VFNGNzhsQ0FZZGZHUDRiY2M2UEZRTDUxVjd4VWtqSHNyVVhyeUd1YkRxZHBH?=
 =?utf-8?B?NVJFL016QlNBY3NDVFc0Nk1BWWRyY2dRZXc5eml1V3pyMjVSQkYxM1NBK0tB?=
 =?utf-8?B?d2tHenQxc0ZGd2QzOFdPZHI5cjA4QlJPT0hPbzZhUVp3bTJZd0pqTk1qSWh4?=
 =?utf-8?B?bE1tdndmWXR3R1RzUXUwalhuN1lub0ZKK2ZzYlByWTFFMGI5VCt4OEY3S1gv?=
 =?utf-8?B?RTVlZHVEdktuRVlkK3hTd0dtL25qTUN4WHhJQ2ZkV0duZjM0ZHJ0ekJPeENW?=
 =?utf-8?B?T01ZU0lYWC9iMi9FQTBMQmFvNGNGUzRCdHV2RnJDTzZnVkgrMm8zWWtURTdt?=
 =?utf-8?B?QTAvYkUwM0x5NkxFNjJBMzYzQ0tsTmR5YXpmMWlwSXVXYXcvcWRlQnB4OTdO?=
 =?utf-8?B?dGVjVzB4WUdzYnQ3dVQ3QmxtSGZVYzM1ZHBTZFZEdEE0TE5GMUREWlZFbVph?=
 =?utf-8?B?OHlBaFdPMjhSRmJqWEZGZWs5Y2FkYjEyMkFUdndrNXBCTVNWRTlvU3htVW5l?=
 =?utf-8?B?NGdzVEsyei90MmtqVDhLMnVTMFppYkZ5L0RmenN0Uitjd2R6YTNuUG1uSjhm?=
 =?utf-8?B?dGZ5cGtEanlsSk02MmFJa0gvZFEwR1FOY0g1R3F2NlRWckNoNTVyZnQ2eEsr?=
 =?utf-8?B?UXA2cHErUjlDR2dJK2xQSmxVWFF0U0E3YlNXTllSMUU4SXVlODh0MVRDK0J3?=
 =?utf-8?B?dVFYNHA2d2o2c2JYYkpvUmhJUEI2Wk1UNUp4OGNlVWFOd1dJNER4NE1KbGxz?=
 =?utf-8?B?c1g4WWQ4VjY4Z05HbHU1NWRtem5RZW5zOHRYZmRPUXd1a3dyckZPZnA1OFdl?=
 =?utf-8?B?ZHdTTEFGZ2pPMFZvZkN2U1Fnd3IxUDF3WlJtZEFoMFFzOFR4eVF2dlorNXIw?=
 =?utf-8?B?Vjl2QkYvUVJtTTJsMm5jalFrUXRYeWJFaVRUTlZVVXF3bjZOTzNBSitDb3o4?=
 =?utf-8?B?d2paVzdwLzJsc2YrK0xsL00xVEF1MHlLb2lpUldsMmR2aG8xd2gzWVlBVkFp?=
 =?utf-8?B?ODZVdG5nbVVmSzdPZjQzRFhjUUdGeG5VZ3p4RmhuOHFDeC9JMEVraE9XeWhq?=
 =?utf-8?B?azRlU3RHTUNQekhjSVViZWRkeDBIRUVqOWRicWhPYk94NG9WWWh4bVJNZmlK?=
 =?utf-8?B?ZE83Nmc2NmhnU1JvU1dRUnZkQ01sT1l2WVNHMGFTNXJrMGpQa0VPWWJ1b1N6?=
 =?utf-8?B?WkU1N1dqY0JBM041VGxqeVI3MDRJTkZNcXp2d1p0VXFoYzBQTXBoc0RZWE1S?=
 =?utf-8?B?ODlodHI3VTZuVzJyL0tiZG05V3RpcFh0dkZSYm5GZ2VuY29NSjFZYzBKQUNr?=
 =?utf-8?B?QjlaSUdNbGxiUGhiVnZWOTE0TGdqMFFKN2ZwNy9la1h6UlphY3BqbmVmTTI5?=
 =?utf-8?B?b0VORm12dGJpYkdRNVZ2eVduQk9FbXViTm16dkk0bDRkTWZGaHA0LzZmUEVJ?=
 =?utf-8?B?alJDeGJ3M1dXMVlxTFJjcmFBeDh5eVRRZjZwOHhONXhpWlZONjJJSGZqYlR1?=
 =?utf-8?B?NTRuVnkrM3NTN0QveTV1aG41NjFYS2pRVW1VOFpxMm5sSUhrQnljK1Iwa1px?=
 =?utf-8?B?cStjdlZWNUlYSmh6dnNEbnlFUmtrTHN6VU5JYTNocnVaOHFkMEVQOWg2RHll?=
 =?utf-8?B?QXUyTytDWmJEL0tSTGNrVFlHZzNZdUZObEZNYllPd1ozbU9JS3RDZW9FT2hr?=
 =?utf-8?B?THl4b0RvYlpyNTMyRE1uRGQrU3VKYVY5OStLMnBaMTREeEphNVNmU3NuQnJS?=
 =?utf-8?B?NGxnMGJPa2FXWU54d0xCZkwwc2s3OTZqYmNabjFaa1BuWG1RZVhwbnlIbExv?=
 =?utf-8?B?Yk9FT21iWVl6TUp2ZlZsTVJYdyswaWg0TWFtWTdmd1pOYXoySjMrNXR0V3VX?=
 =?utf-8?B?eXl3anFwVEQ3R2xzd2Q3SWVtb0dMbm1RWDZDYmh1blhoTjk0U2xjdHFtQmFY?=
 =?utf-8?B?R0NoQ2ZyZjBvZXRFM3ZybmxFK1NGVXNzRWphVmlUa3BKbW1pb0ZDOVVFUisy?=
 =?utf-8?B?KzhSdk84cGdiMDdDcjNFTURMK0NXRjRHaEtnTmZaNGUwZHJwdXV2TDE3Zlk1?=
 =?utf-8?B?N1lvUUFDOTA2T1M2U3QyaGlLMkdPRjBBM0MrUml0T1E2Y01mT1VjTGhJR3Jo?=
 =?utf-8?B?c25OZ1dVbHhpelhvdHhDbXZETDVybWFacmwxb0dZRWhnOUJ6amx3QnYzeE53?=
 =?utf-8?B?R21PdkMvQUkya3RjdFA0YXRyK3o5WEhseWxHVUJ3SDZtczhSanNoU1I3VTZI?=
 =?utf-8?B?eGVlaWR5ZUQzR0taUVVHZVRNckpWSFFISm14dUJWNGNpSkJaaFE0Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95ac4d5-1f19-4502-5b23-08da506facde
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 14:43:00.2565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R6Dcy/5axoAZMvI7Hd5utrvXw6y3PjQY3soQ+vvPCOI/aUjIyuY6+52Rp1wgib73+e8C1bF3FfkFaOscQAGjBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4069
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/2022 6:25 PM, Maxim Levitsky wrote:
> On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
>> VNMI exposes 3 capability bits (V_NMI, V_NMI_MASK, and V_NMI_ENABLE) to
>> virtualize NMI and NMI_MASK, Those capability bits are part of
>> VMCB::intr_ctrl -
>> V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
> So this is like bit in IRR
> 
>> V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
> And that is like bit in ISR.
> 
> Question: what are the interactions with GIF/vGIF and this feature?
> 

Hi Maxim,

The quick answer is, that V_NMI will respect the VGIF enable controls.
More info about interaction in subsequent patch reply.

Thanks,
Santosh

>> V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.
>>
>> When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor
>> will clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
>> handling NMI, After the guest handled the NMI, The processor will clear
>> the V_NMI_MASK on the successful completion of IRET instruction Or if
>> VMEXIT occurs while delivering the virtual NMI.
>>
>> To enable the VNMI capability, Hypervisor need to program
>> V_NMI_ENABLE bit 1.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>>  arch/x86/include/asm/svm.h | 7 +++++++
>>  arch/x86/kvm/svm/svm.c     | 6 ++++++
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 1b07fba11704..22d918555df0 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -195,6 +195,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>>  #define AVIC_ENABLE_SHIFT 31
>>  #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
>>  
>> +#define V_NMI_PENDING_SHIFT 11
>> +#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
>> +#define V_NMI_MASK_SHIFT 12
>> +#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)
>> +#define V_NMI_ENABLE_SHIFT 26
>> +#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)
>> +
>>  #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
>>  #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
>>  
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 200045f71df0..860f28c668bd 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -198,6 +198,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
>>  bool intercept_smi = true;
>>  module_param(intercept_smi, bool, 0444);
>>  
>> +static bool vnmi;
>> +module_param(vnmi, bool, 0444);
>>  
>>  static bool svm_gp_erratum_intercept = true;
>>  
>> @@ -4930,6 +4932,10 @@ static __init int svm_hardware_setup(void)
>>                 svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
>>         }
>>  
>> +       vnmi = vnmi && boot_cpu_has(X86_FEATURE_V_NMI);
>> +       if (vnmi)
>> +               pr_info("V_NMI enabled\n");
>> +
>>         if (vls) {
>>                 if (!npt_enabled ||
>>                     !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
> 
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Best regards,
> 	Maxim Levitsky
> 
