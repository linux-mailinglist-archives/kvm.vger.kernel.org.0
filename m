Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E4554F9D6
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 17:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382956AbiFQPFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 11:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382711AbiFQPFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 11:05:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED15127155;
        Fri, 17 Jun 2022 08:05:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IO4RfffbwoG/sdf8cKJUpJ/rBnQJKuz3ACt3cdlZzI5NCcN9u4jCjqoDM3nRwIsq9QhD2k8TUmWYTMtOGUnUZxWcP7JgXt/Y0zRA7BsdizERD0tcThYIAy8Xm58yP8qG7bwZ0ArsUA2G4hJxede+o8yOJ/GBu9DW7qUv0gjc1YqGnWtkbaz9lG/hSrrbqKLvRQ9H1hFmdfZpBb2g6oAzSdHAt4nBCAi3wDRJwjDEmLCGBovlmxjwvvmt4cydymVbO5GfZHxm59J9CtziZYSP/BsfstJc5JRkczqyzTXbGpiiYonZY+o9yHPrzKUV7nlU9P6LeAnY935tx9gQbw22ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+h8v2jN9hXXdEn0EUhGFghZ35M5qItCLHAsV/RsVeFM=;
 b=GBn9JteKyKzWnsoheCkoaMvvRcyPHO1Ak5WhmvqpWnkmtb6FM/kXcZ7hgyjE2DLLZy7ujIQDDUvnoRkzZKoKfsDtWMoKBlvwTV39oFiLRej80jy9tfEkhTTJ1/nrnW0FyUFP4Kw9YakKCKyFiB0h3L1ZLSkJLTzUzLYRvzwZX1a/7gpEx20DE3HtgmK4H//ew1niWF5SAlRrFruk8IKz8VWvY3OLBtlcs5XyMuvYSIaRpQHw54Me/91MxSG8Ql+urLErzenJ/tUwLvcj9kAym53/4u0aXbFLrhU6caF/VrJc2RbZyMIWxVNnpHoFMLBIdUt5eNkuxBfoKDkqaOtY7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+h8v2jN9hXXdEn0EUhGFghZ35M5qItCLHAsV/RsVeFM=;
 b=RSYmys8H4NSLkFTOEzLiLep6JEunXH7+b5q1QDQZojZsFiwNWdBV4Yy886hq1MsJtbMGDByfm1ZHg1Paic6CzZ750E4DqORyqnmKTV8g95YZup/2U0v8QHpXog6kKM7y3AhurZ33zMzMIUXoFPgPYn0dSFK8jOZZ5q5EjfmEnpU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by BN8PR12MB4593.namprd12.prod.outlook.com (2603:10b6:408:aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 17 Jun
 2022 15:05:33 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 15:05:33 +0000
Message-ID: <0981fd1c-b4b4-84ad-27e9-babcfa2524db@amd.com>
Date:   Fri, 17 Jun 2022 20:35:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5/7] KVM: SVM: Add VNMI support in inject_nmi
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
 <20220602142620.3196-6-santosh.shukla@amd.com>
 <dfc2ce68a10181b1ac6c07ca3927d474e13ca973.camel@redhat.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <dfc2ce68a10181b1ac6c07ca3927d474e13ca973.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0026.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::17) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0f62dcb-f325-4f04-fb15-08da5072d346
X-MS-TrafficTypeDiagnostic: BN8PR12MB4593:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB45933397C152A93106B1D4EB87AF9@BN8PR12MB4593.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pdYDMyKZQuTKGTbfZtu06fEZ92xD8hfdVyHRZpMf+wxPjn9G9tNHRIHcRTlxTXAjsBk7YMz3bmWRTbf3AWxakb4N72GSjA5Tgl1x38J6blC+st3R2EaYciM3xbsQLsrskRf/dD8AFk0uOAaU1kEpdxQpAVesO3FQeZWn7YDi+ibh2P5gq9+r2AcH4sd/xjqmXLIJiYfo+xCQHo5Hiee4X67H5piabxibJoiDm4FZJov+8zJp94zuG5J072wPPD0VEqtg5jvrgR/hUk8v16WtSOn5sC1xrvs7ZFt89GzsHLlRBy91veFuT8wijCfZ1M8M8dFnq9rqsGZKfthTDI33Qg+3yXmML+8WcQoLQtnJHyj6QcnDiV+zZtAo0wU1Y52OivurgNLADaXqY3U+pq9dZo8kJ7tuuMztVw0RzTc9tS47mOOGKg4Nhcx5rINuSv4NCVLdUiZ8qNdE1Z1jfTQwQZbHRuKuPv9UO95kXFYYjNMogM2tLCV4JxEZWJs06DcS7c4UAxJFxLKwygh0rzkraShP7we/lx9eMwtnatDcihl+HqVO5Nkp1mPWQXLjRdhISk/5q00iek8LtFB95ldPCrHyDAO5h7AiITCPOhNLArnaQuTaIgKegHkq/3MfKo11brfweIuj583zKf42klYhdJHqcFa176d5naLYR0GxPdOgJtU+FN3lp6zEVmgwCW8D3t4xScn5kNVBsxtJZ3BkbgEbY0gAqKqAX8vfVd1Q8xQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(36756003)(316002)(498600001)(4326008)(31686004)(8676002)(2906002)(8936002)(83380400001)(6666004)(86362001)(66946007)(2616005)(6512007)(66556008)(31696002)(54906003)(110136005)(26005)(53546011)(6506007)(66476007)(38100700002)(186003)(5660300002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEhhanB1R0hhNkFjQkh1ZmdTdW5UZjQwSjE5WVN5WFozZzFiUDAwTFp6R3VY?=
 =?utf-8?B?OXdoY0UyajdudElSYVNXWE5NbytuQ3NNQUZwd3VYZVR2dTQ2aHlna1RlMDdX?=
 =?utf-8?B?ZDJ4UzJ5YitEek9DTGFibEJOMVR5aGJGZG9DNEJrNlhiNW44UDExbGx6WW9F?=
 =?utf-8?B?SlZuc0ZhcGVFTWhtUjJUbkdPTis5RlB1Y0YzeWtuemhqaUtQMVdGbFhNNE8r?=
 =?utf-8?B?T3ZVWEkzK0NFNHBUejdTRHRTMlNLVVYvclllV09NM01pR0trMm5YNFQ4czNx?=
 =?utf-8?B?eU8wVTB5QzZ4UXUxVjRqclc4ZWNMajgxRjl2Ky85RjRnUm56QTdVTzJnMVlM?=
 =?utf-8?B?MkFHdUNlYmxXUm56cXQ5QnE3NUlrSzU4ckRmVjZFSldia1p0R0NhZUtpTmNJ?=
 =?utf-8?B?bFpoWmJMMFc1RCtMaFlYK1pmdmpITm0yQmRPdXdhTE00dXQ1V1JUS3BFOWJu?=
 =?utf-8?B?b3F5MnQ4NndBaEhYVldKV0lIQWJiN3ZGNncrWVMvaG5ieUZ0VW5Qc1lyOUl3?=
 =?utf-8?B?NFJUdFhDczRTTVQzS2JvOVhaTDVmNWpRNFA4QlA0RUlSbFRIZlVHQ2RBb1hz?=
 =?utf-8?B?WEdqMTQxM3UwNy9mVk92a3YzdlpYK205am5qSkJEcU5IbVNCb0ZWNmdBdEhU?=
 =?utf-8?B?Qk1sTldaS29hNjFqNVRETFhCeWE5QjhCcTJibGZYcWlLb1g4OGo3Ty9tUVlv?=
 =?utf-8?B?NXFUaWNtUlJLOHBtaVFNa1p5RGRkMnJYczUrdVpSckRsOG9ocVppbWQxbU1s?=
 =?utf-8?B?NEFBMnpYVzRPcENlSU9UaExiRVlQY0M4azlJaVdpQmM4d1k4eFRXOUtZVEpP?=
 =?utf-8?B?QW1yY2xDTWlzNWovN0VlTXR2UWQyOFNiN1VRaXBBUFB5WVd4UmRPVjRjSmhs?=
 =?utf-8?B?b254dld5UldJYTJFSlhCL3VlV3FHSVdYbGNiV2ZyMTJYSFFzTGpKMGFuYlBG?=
 =?utf-8?B?OXd1b09Bdi9DVlNuQzRybXdnV0oyaytUYzBWNksvTVlsRDJHQWViUmM2blBo?=
 =?utf-8?B?a05MdHNPRVdMZGZyUGlWQ1hrOWhnN3hLQlg5Y2tBUlJES0Z4M1JIQUFuRkkw?=
 =?utf-8?B?OUs5eWVCQ2lGRm41NktlQUxLMkNpRG9pU3RQMXoyWG5Sa2JOM3pJZWM4ZklY?=
 =?utf-8?B?UlhMTHBwQ2IrVzdNZ1MvOUxRakFQRjJob0pmeVZPRVpBOWtTU3dRVnJPTWNr?=
 =?utf-8?B?M3ZtZVE0dVNOWGZuRkZRTTNmYmlKRDNKL0VGeUIvQ09Od0ExKy9DbndtU0JQ?=
 =?utf-8?B?T0VZN2NsQTk3ZHNZZVZOTVJmbnpZNThkQ251ZGFRVmNHYjN1d2M5UFlLUzQ5?=
 =?utf-8?B?eGkxWmZubS93cXliVjhuUnNZTDYrWVBQSXk3T3ovb3RlY0U0ZjhvZXFlNy9v?=
 =?utf-8?B?TDlXS1pRbitjZVhrMERvM1dKblpZZk4wWDZpbDlTVFN0N1R3ZHEyTUV1V0N5?=
 =?utf-8?B?dHBaZGMxVlB6UGRPNkQxaERpaHBPUjlEU2xncnhKVVErWTV5cHM4ZXVHZnBt?=
 =?utf-8?B?VEVieEdWMkpKOHI1K1cySTExSE42WDJSTW4yR1lRSmF2UFpxbm1mQnk4N2tG?=
 =?utf-8?B?L3VJb2dZdGx6MlZEeFJ2UjVJNXB4Qm10T1NRWXVDVTB5ejdBNWdoWDFaclp3?=
 =?utf-8?B?SFNpOElXN3ZXWEFNUnNZSlREOTRJUDlqZUF3bnl1Tit4ZDRXY2NhTlBmM2RC?=
 =?utf-8?B?MThEc1pCSE4yaG5aREM4RGVRbXZxQ0svSUEwT3NHd0JNYmFXVlBXaGExWUxW?=
 =?utf-8?B?R3FWRDBidkJ2eDdreEpJaXkzQWFhM1hRaFFub3VvNmF2S3pEUTFYcE1acW5w?=
 =?utf-8?B?TTJ6ckNBZ3JnWGorVHRiOWcwRnFKZHZ1c2FZaU5mbVNURlVGcEREbzZTSWJE?=
 =?utf-8?B?WXltTXFydVZESmZ3bXhMVWppOU11Z3pEYjdkREdxK096bnRRbmhJNkpyaHFQ?=
 =?utf-8?B?K1JDKzlhUVBNQ1NhSXJ2dGxvSUh3SCsrNlZLTlhTM2hrTXlDbDFmaWQ0a0VC?=
 =?utf-8?B?dHJKa29FNVFISTY5V3U1bFJ0MTRvWUowazFwZm43T1JJSjN5WlBmS2liTm42?=
 =?utf-8?B?eitTSXM5ZUlVSFhYWHdnSEFxcGtacGVxSG1TS2I3YVpWUzJQN2F0eGVJT0J0?=
 =?utf-8?B?Q1dIVm9zZDE2OGZ1QnRpWGRNQldQUVVabEluY254K3U2dGVyb0tYbGhrMFhK?=
 =?utf-8?B?WlRGT3pvVW92enVjRXoxNzhzTHBmMjV0bEI2RHgvb0Q4UUw3SHJZLzVFRjdh?=
 =?utf-8?B?T0h0RWRWajlxeVBXTUFBN2JFb093UGFIak9YRmhpalVWNEFJd2gzUEtQaG9L?=
 =?utf-8?B?ekNLNDZoZytrMHF2SkhOTHM3eHJMS0xOTExqZUFwc1cvcFlJZlo5QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f62dcb-f325-4f04-fb15-08da5072d346
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 15:05:33.2015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tsDiXRrV2gsEeXOj0Vb6HDsxwhVCyzq30PggSV8CBiRfMC2ysKhqeAW9EpAVdn5GgY9ZFIELUvQSl4By7xCTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4593
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/2022 6:44 PM, Maxim Levitsky wrote:
> On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>> will clear V_NMI to acknowledge processing has started and will keep the
>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index a405e414cae4..200f979169e0 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3385,11 +3385,16 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>  {
>>         struct vcpu_svm *svm = to_svm(vcpu);
>>  
>> +       ++vcpu->stat.nmi_injections;
>> +       if (is_vnmi_enabled(svm->vmcb)) {
>> +               svm->vmcb->control.int_ctl |= V_NMI_PENDING;
>> +               return;
>> +       }
> Here I would advice to have a warning to check if vNMI is already pending.
> 
Yes, in v2.

> Also we need to check what happens if we make vNMI pending and get #SMI,
> while in #NMI handler, or if #NMI is blocked due to interrupt window.
>

V_NMI_MASK should be saved as 1 in the save area and
hypervisor will resume the NMI handler after handling the SMI.

Thanks,
Santosh
 
> Best regards,
> 	Maxim Levitsky
> 
> 
>> +
>>         svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
>>         vcpu->arch.hflags |= HF_NMI_MASK;
>>         if (!sev_es_guest(vcpu->kvm))
>>                 svm_set_intercept(svm, INTERCEPT_IRET);
>> -       ++vcpu->stat.nmi_injections;
>>  }
>>  
>>  static void svm_inject_irq(struct kvm_vcpu *vcpu)
> 
> 
