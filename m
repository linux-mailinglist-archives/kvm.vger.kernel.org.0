Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C7254F9DB
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 17:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382971AbiFQPIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 11:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236634AbiFQPIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 11:08:16 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1C330F63;
        Fri, 17 Jun 2022 08:08:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hufk4vJHnI4hA9p6FIUXJ4ZJ3dYiE863B400Q2mOvlkgkrdDaDJse2J449Kmvw7KIlxq23V9M8sc1hgM3iA+11e0dyyClFBT6EZxPxcFxBm5XKmTQ9m3MouhhkKbTC/A2xUFcUZ6LWiSPbo1WBqov1nWP3J/ziS3M8HhO1hzPOdW3XwacvQDlWD14r81hbZuryPaUHv0zp/hQDyEcUVqXb74px+7OOqj/bVnfkR3zdOLvArsInoM6JLyOluT/WM6qmXDjOT8TSfb44dx4R6rIGmDEYfT2Mk53Y7Mbpl0Ox8eZIZHIhMKqx+hkSZ8GmSiIzixAxBhBr6uiZeEc1a+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZY2+8IPGFszEBe4W18jMqVXiK2iDG0KMe1ioD+HMgM=;
 b=c2BBph1ltf8MIm+0hV17inINPjrx58FrZBmc2NqbN+ZCmbMq5uAuDU4yTMWB6QZacVwbD06f1vz9/rCPEFiRkr5ClhSTFH4v9C9mYAgDrr3VUx6KXFrXn6v1m2ZavCKjskHddjp91pa5WWv8tm+tn1C8scaPv+tevUH2ufegIrG9gr4fhHm9A2BCYAo/D+nj3CWzMphV9NWlGuaoe8ZR3iuqBmHOoMv0eueZZiGPvKITwDKdh+yzo99EyskO2FNxP0E1Dlxw4HxBnSyPanXudAYbxHroxe5XR/5oaHEcJGfns9Ucb6zjLRpbvhTlOVH4nPLsVMfs34z5EsF94NrIlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZY2+8IPGFszEBe4W18jMqVXiK2iDG0KMe1ioD+HMgM=;
 b=GyfQBx7fgHPNVgOMrnPw72JG/KvkGDVihJ7CkfHKRx47JWQ/gBuzkkFzz47q1Doefebgt9GKeA34/knhh9sYY0rnOP/qGcpbxC8TCEo/+anoIwSsplPGuSAg9+SXey+2CWcctS5ppOI7BimVObyjPO67fMIyb/Yiy5JlYPrvP9o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by BYAPR12MB2648.namprd12.prod.outlook.com (2603:10b6:a03:69::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Fri, 17 Jun
 2022 15:08:13 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 15:08:12 +0000
Message-ID: <429d5906-0ef2-c7d6-6242-2520af5163f5@amd.com>
Date:   Fri, 17 Jun 2022 20:38:01 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 6/7] KVM: nSVM: implement nested VNMI
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
 <20220602142620.3196-7-santosh.shukla@amd.com>
 <199c74446ffc18ee61939b0141f56a36142342b7.camel@redhat.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <199c74446ffc18ee61939b0141f56a36142342b7.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0215.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::8) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09d32385-c25b-4790-0522-08da5073327a
X-MS-TrafficTypeDiagnostic: BYAPR12MB2648:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB26482685E52083E9E8F92D7E87AF9@BYAPR12MB2648.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGIi69ODH6qibQQn+VNbHJUcFXcANDdGaR59Kw4OTYbpglIgJQOrnr4r8uvesINfhfUh9fjIgQY+EnK02PTf3vmsaGTV+KDEep4DVx+n6JbqCY4UKbODTjR9OSsK+EivSMr5XQVhFBRz/Qmyt1j7z81a4WXpTq8hPryUu9QT/67Uea06DVvfreLsfR1/ayjhaSEnHea/dtoI5WSaDmQfn2Z7LgkXCQIyUMLZPMF1luQO+CWua0uki450JhziEJYrGlnmw2ocOMnsIB9HLKumjfwqBzGjZnFTijcAwIaR36FTU2GiX/A+UhRPKxRClTEEhrVW5T6Whrc6MXsyU6+lF8xP4rvyHdAiF4cbjc9/Q4g1hJ3VPdvCBVX/qlpGujcL+T70j1ay1KSa2z2sF1DV9gsoytF7rPogg6tu8ubm5QeA7zPbescfwBrPXn36mdY0giLRuFzGLErpY6neXA4LBYzVR7QReR3oMYjR11Ua69ua9nS+7Xru7udHCJ9r4+xgUJRBdzlHm9BQ/bEm2J7mVbolPwhThHhrYQO2JuhBJ8tlaHItjncItqaSNtK7P5A9gmpcI8sQDvP3sgxN1cZsVGnGk8O38aqrDNVlJBn4KeJ8UI5wroojkSptsrFvjojMkRm/g1T1gbiKwP89dRAPFr0sHQ2yX9DJVIedtboG1jIrhzVBrvBo4PXJ43yEW5Kr6xGCKwaBy3UGbIk4l8SrWBS/Tu/DJpGj3xBMYqXjigBaa2+NcgnE8layb22LGIOR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(53546011)(31696002)(186003)(6506007)(8676002)(66556008)(66476007)(66946007)(86362001)(38100700002)(4326008)(8936002)(110136005)(54906003)(498600001)(5660300002)(6666004)(2616005)(6512007)(6486002)(36756003)(26005)(316002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ykw0Q1pobERYM3dUeWRadWRLWkQzNVhFMHYweUgySTE1ZXBmanpva3dzWmhs?=
 =?utf-8?B?dEJpVHZwZDZ6WTV4cUJDS3FjNXJoNW53eXhzN0RhL1VSVm9mQVZLaWlDNE0v?=
 =?utf-8?B?Z1p1SjBxM0dUTE1tK0FkN2xIVERYRFB3YWRMWWt5QWphQkYwWnRqeFkyaE5D?=
 =?utf-8?B?UE5HeDJmL3hhVVNUc3ZIOWw0c1UvVWt3QnltNkRtM2xjYWdyQTlac0FHT1h0?=
 =?utf-8?B?YjF1L1AwenN3aGg3cVlTVVRtRUJ3aXZSS0VBWWhHeFNhelNrNFowSktpSVJP?=
 =?utf-8?B?WFNEUThudFVBUzdQQWxlb3htN09hNi9EQ3BwV0tBRjNVY1FiRVZGR0J2TEdH?=
 =?utf-8?B?Vk45Z0g0STRub1hISUxwTjR2TjRFWFI3N3ZuTlM0SXZRbTE3cDRtQitudGVM?=
 =?utf-8?B?enlGUU1tVzhEVm15YmdTVmNqNHN4ZTZYQ1krRGthNkYzaXNXOGlsa1d3YUtI?=
 =?utf-8?B?TkRsWmx5YmpTREo2UlJFMG1NZ2I4K21xeGN3bEo4b3NLVTVRTjRxU1ZDTWRO?=
 =?utf-8?B?d0lVaW5ubCtFV0crN21pRnBmMnFBTGNleGUrb3FPaFlEYVRsdS9aN0FUNCtT?=
 =?utf-8?B?NW55SEpXdWpVNU5FbXJQTTRwY0MybzJ3Z0QzZE5YSVBlbXZBUG1tTDJhQkth?=
 =?utf-8?B?MjlzankzTmdtZmUvb0t5ay9NVFdxbkl2cytzVmlzZDNvSFY5dm53UDFSOGxr?=
 =?utf-8?B?UkpvajBqeWRrcldLODJpMDU2cU1rU2RLcHJ0M1Q2anNUUTl1UFk5NVBKUGhV?=
 =?utf-8?B?Z3lRbE5DYkhNK3NHUHA2RVpWZS8xS1lRdkVSWGZUQzBZVFUvWnpXYVA5bUFs?=
 =?utf-8?B?djRYZkQzRjQ4Q1RaalhiMVVTUHcyUERzSUI5eFBod3lEU1owTXE3dGhqNEU5?=
 =?utf-8?B?VWJzdU1rOFppV2hZSVFSVVhuT2tIYTZDdTBLOE8yb2dSYnVKbjZVVEZYM01h?=
 =?utf-8?B?cDNKenBmQXlBSXg1RjJEVHdXby9zVFN6UXJuOE92SUR3KzFkbTk2Q3JOdnJZ?=
 =?utf-8?B?TXBLRFJRWjJWeHVoSGg1ZTk5V0l1RHlmM3cxMmlJcE5XNS83MVI1TjdXSC9L?=
 =?utf-8?B?RkVoTXpWaTZMN0I1OCtZN2srSFpOd2w2SmdFWituVFgwdGd0T2VtRFdUN3Zu?=
 =?utf-8?B?VDlHcnY0RFlEL2lEb0NqenhWTGxJWGtwdXJMV0lPMjgwalI2WUJ6c3QyQU8v?=
 =?utf-8?B?cDFuS0hSTFRSTjVaby9yMlVzWHpjUm5pN0c0SG5yRXdaYkFwbG4vZ3huV0lQ?=
 =?utf-8?B?R3RqMCtERjBFKzhCL2J1Q01EaEZWVERKYUhRS25CNnBBOTduZjQranJQUFBt?=
 =?utf-8?B?YWhRTjlNdjRPWmN1QmkrVE5oRFNRR3FyYVgrMUtuNSs1ZmEzMElmWWFtWkdR?=
 =?utf-8?B?VnN1ZUx1amtWQ0Qxem42MDlieG12SUxyVVc1NTljM2JwMEI0MWluc2NwNXdp?=
 =?utf-8?B?WS9FcTRoVFZ5RDEyZDA1RnhWa2l1bVBzdXFOb2wrQUFvU3ZjNUZ2SFFBWldx?=
 =?utf-8?B?TklEb24wWnBIbWxsc2Vqb01mcnV4azduT1NUcVdaSkdYSzNsamk4NXlENWo0?=
 =?utf-8?B?K1BiTW5zRmQ4bjlPclFwZnZLc05GY2RreWdqc3Avck0yK1JjcWpoUGhtZW1w?=
 =?utf-8?B?eGYva29GUmZtUE03aG10bFF0aE9MejlYUEF3a3h4MDNTZ3lFc1pQWXlHMUJl?=
 =?utf-8?B?cHEwWFpOZHQzNGdGdGJ0Wlg4c3BFTWpUTVRUTXd2TEUwaXpOQktFenhPNVk3?=
 =?utf-8?B?TEtJS1R6KzhkbnZVYko2OGlGaGdSVjg2TXNiUTZwb29KbWp3QVl0SjkyYy9U?=
 =?utf-8?B?RFFqdzdEV0E5MysvRzZCMkI3S3lNcmJVTkYvMWtWZVQzbVpYT1ExRzNPUDlM?=
 =?utf-8?B?QklBaDF4YXdhd1NSczY3N1FCcndEMXpZNmxaZmxGdDJROVhIdlZZbDFDVnQz?=
 =?utf-8?B?MnQxMjAxWndWSUM5L3RWMXZEai9aU3lsZVhUUk1SdUNkZUladlpKMlVjdG5J?=
 =?utf-8?B?c0R4MUlubnl2N2tFV2w2VllqN2RMMVphR1lzNEYvbHQ5MDhyWkw3NlVzTDFx?=
 =?utf-8?B?ZkFQQ0h3a3U2Z3h6cWJYMUYxVHhMaTR4OVhVRmJFYWVIb2lHYjFEUVhKc3Nk?=
 =?utf-8?B?Qy9JdkJUdFQ1cmdQQ21SdU9DNWNPdzBmblhlWDJSdXAxTGdma3BPN1laM2xk?=
 =?utf-8?B?eW5BTXEvRlBTUUlkTnlZK1VMb0Z0c0FsazVQdSthZ3lOM1hGTVRyQVNGU2hv?=
 =?utf-8?B?SUJ3Z2ZCTnFzWVNUc0xrT205UWIxV2tlZ1RSa0VaQmRVNzluZWd4aVd4RXlz?=
 =?utf-8?B?aUdTNlEvZWgzU0ttWGJQUmdzek5JeXVGak1teGJ6WjF3VS9PUE5rZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d32385-c25b-4790-0522-08da5073327a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 15:08:12.8258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnEEMYHgakQ0KsvDWZP9HPoFcxRU/H0eHMspfx9ZsIWK6JSMHedUXblZNojDs1+MGPmP81tpBLYt0oAWGObHBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2648
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/2022 6:52 PM, Maxim Levitsky wrote:
> On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
>> Currently nested_vmcb02_prepare_control func checks and programs bits
>> (V_TPR,_INTR, _IRQ) in nested mode, To support nested VNMI,
>> extending the check for VNMI bits if VNMI is enabled.
>>
>> Tested with the KVM-unit-test that is developed for this purpose.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>>  arch/x86/kvm/svm/nested.c | 8 ++++++++
>>  arch/x86/kvm/svm/svm.c    | 5 +++++
>>  arch/x86/kvm/svm/svm.h    | 1 +
>>  3 files changed, 14 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index bed5e1692cef..ce83739bae50 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -608,6 +608,11 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>>         }
>>  }
>>  
>> +static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
>> +{
>> +       return svm->vnmi_enabled && (svm->nested.ctl.int_ctl & V_NMI_ENABLE);
>> +}
>> +
>>  static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>>  {
>>         u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
>> @@ -627,6 +632,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>>         else
>>                 int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
>>  
>> +       if (nested_vnmi_enabled(svm))
>> +               int_ctl_vmcb12_bits |= (V_NMI_PENDING | V_NMI_ENABLE);
> 
> This is for sure not enough - we also need to at least copy V_NMI_PENDING/V_NMI_MASK
> back to vmc12 on vmexit, and also think about what happens with L1's VNMI while L2 is running.
> 
> E.g functions like is_vnmi_mask_set, likely should always reference vmcb01, and I *think*
> that while L2 is running L1's vNMI should be sort of 'inhibited' like I did with AVIC.
> 
> For example the svm_nmi_blocked should probably first check for 'is_guest_mode(vcpu) && nested_exit_on_nmi(svm)'
> and only then start checking for vNMI.
> 
> There also are interactions with vGIF and nested vGIF that should be checked as well.
> 
> Finally the patch series needs tests, several tests, including a test when a nested guest
> runs and the L1 receives NMI, and check that it works both when L1 intercepts NMI and doesn't intercept NMIs,
> and if vNMI is enabled L1, and both enabled and not enabled in L2.
> 
> 

In V2.

Thank-you Maxim for the review comment.
Santosh.

> Best regards,
> 	Maxim Levitsky
> 
>> +
>>         /* Copied from vmcb01.  msrpm_base can be overwritten later.  */
>>         vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
>>         vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 200f979169e0..c91af728420b 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4075,6 +4075,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>  
>>         svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
>>  
>> +       svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_V_NMI);
>> +
>>         svm_recalc_instruction_intercepts(vcpu, svm);
>>  
>>         /* For sev guests, the memory encryption bit is not reserved in CR3.  */
>> @@ -4831,6 +4833,9 @@ static __init void svm_set_cpu_caps(void)
>>                 if (vgif)
>>                         kvm_cpu_cap_set(X86_FEATURE_VGIF);
>>  
>> +               if (vnmi)
>> +                       kvm_cpu_cap_set(X86_FEATURE_V_NMI);
>> +
>>                 /* Nested VM can receive #VMEXIT instead of triggering #GP */
>>                 kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>>         }
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 21c5460e947a..f926c77bf857 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -240,6 +240,7 @@ struct vcpu_svm {
>>         bool pause_filter_enabled         : 1;
>>         bool pause_threshold_enabled      : 1;
>>         bool vgif_enabled                 : 1;
>> +       bool vnmi_enabled                 : 1;
>>  
>>         u32 ldr_reg;
>>         u32 dfr_reg;
> 
> 
