Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F18357C786
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 11:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiGUJ0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 05:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiGUJ0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 05:26:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D811C122;
        Thu, 21 Jul 2022 02:26:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0whYNHCz0zHywYTDPvEoX3N5HVmoB/pnGgdJghJib31BMmT1w1dgYYkS1oxxTnwBKXBsqFCim+0EyXAXUVKR3xlk3aONqdZ16C+C+1DmuxUB6pCfI1zAvQDfeCK2y+qVgWQ2BUKUIgFP+rNVZjUvS4hFVuMsLuI3a9AAAC/Xp8gv4A7/f/2Ww0cXai7qzMmK2sazE2GF2HKOy6CIXZz4LWvEyot8Lgt3zP1XhQS6tGJsC/pyWqMtXIyQ9s99ei+T5EB8//dXUPKJl/+bj3FWOPZDDN3PLEaGXw6CaLJYxav1tlAVoQ/c104rVx3gJhKiKy4mZDWUue+h2phlSL32g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JGuMly3+VbbyNg+GwLOwW75KHoOEAJiYgbtUhieMSs=;
 b=ceImxfRMZkh6su1Z4QY1pqmS2zzSe70LA/oknnlZdJrFzbAdc+qn1rWhEnenKI/mdgA6wkROZ761Zo9ynvpPgGAJYTrMU8OFQ1PJBR0L5ym0DL8V34KZfCeSx7wBkhRJBXSCVAPJZdbJAU6V1Ix10UD+2BLBoRtwXSDshykDi7UjF8JvWpos2R9paxeisARBVitm0hpj3k2YiakaDDks0vjTcmc4Ed5J5/bpSHUv16ySUk7QhcQMjOilwVTcBomj6Gm5CueqElllesxHZqnFVGIfvs0qjmZ+zTsx1t624WxSHE0BG2PlY/3b75mWudaMToFdyEY61Az18R5+mh+qxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JGuMly3+VbbyNg+GwLOwW75KHoOEAJiYgbtUhieMSs=;
 b=kz4YIQAk8bpoqFIVQRQLX0/T5ZXdy/BiWDAwymm3Xx4eTC6CmVIxWg45MminRfB7XaqoNFAK7tgGT00nkjqHb9sE4AMDfalfP498iiYoUggnVUrsZ0eJWp5OzHfbcD+bgeDdLYt1opeYaKReJRaIT1YjKsrg7xYMVxUqRgMRPbw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MWHPR12MB1423.namprd12.prod.outlook.com (2603:10b6:300:14::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Thu, 21 Jul
 2022 09:26:02 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 09:26:02 +0000
Message-ID: <fae3d3ea-4aaa-bf20-46eb-596be712f36a@amd.com>
Date:   Thu, 21 Jul 2022 14:55:50 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
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
 <20220602142620.3196-4-santosh.shukla@amd.com>
 <d3f2da59b5afd300531ae428174c1f91d731e655.camel@redhat.com>
 <91c551a2-11fc-202f-2a8f-75b6374286b6@amd.com>
 <fcf79616-ccbe-1137-6080-57d00773ff83@amd.com>
 <a0970f50d5de92917dee44c6d23dce87ad49d862.camel@redhat.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <a0970f50d5de92917dee44c6d23dce87ad49d862.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0007.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::12) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33e3374d-b135-4514-2993-08da6afb0785
X-MS-TrafficTypeDiagnostic: MWHPR12MB1423:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y+NbF0+RBQC2rBYBtdhfAwAm4n165JYL+fHb6+AEDqWK80GQHnk2dzabHW6wYOB+W4xkPgRQ+UQKD5NwzY7LzcL+A4YLe+jC+ueHj/zS6kIVa11D8YVlaEEy6PXGK5fsk8mUbuMuGCqhJ7ytkzDyyn+UjBR/6J8fWWkVk4LWAMD13j4cmmvOZkXFRygdJRm1haUEGa5Jw99Xty2BkCWZuOX9/6GSEO7QObYjNmgkkQstjnHavgGftRn8S2xK7/HEhcddL0sjv+jBdlsDBbHOjegw8+SaaNwF4LB6UmyauD/FckSK4bTyCRpdIt1NgaVWzwh7U0FKCYg78UOnFS9X1iEwVXGU2is5c5IhtJ+uVvYCngLpQUjSbe5K1V4TVY1HLiAR7VUHtEYfhLjJXD7R7ONlnxY2b6XT9nPC/e7LwlVELB4Lk+SRcmztqso2Mq6REq/aK8ur2orNVhSnhAyYl40DviwwwBh9CYs1Oj6kX2qoRPBvumgfcqDi2Eq73kW/i6Pjq0Soetzf9OPPWon2l0D/C7JGfy/Rrvc50z2YMNyS6y7zzIdlw1NqeF0xPWvkUElPBCpCykUHh3/wmAGbVqKe3+wsnI5LHnHcE3UQGq8R1bR/pZEd90pPMWSqbCgkaQqURtnb+3JklGQZL8kQIjxGy4KZTlMiAHyMUJgKNk+TjM6sokngMzJZAlLuoGR0WDDNGidh4q/bvkJzNDRyC4ybPXPXRLyIQPqh4jEa8Fkzn0awDIYU9NAUzo3O60p/SnXaEHYSKhLbuMyUWEOHuOLQrTwJ9FNWhdKk/kZlhzFFkkSKj1/nh82Z7Q1wtlgLIOY0bTL3bPuOALJcEuqcPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(8936002)(66556008)(8676002)(66946007)(5660300002)(4326008)(66476007)(2906002)(83380400001)(38100700002)(31696002)(86362001)(26005)(6512007)(478600001)(2616005)(36756003)(54906003)(31686004)(316002)(6486002)(53546011)(6666004)(41300700001)(186003)(110136005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHlMWUw1ZlBrcDlYMThkM3Y5YzY0cVU4TWFuNjh0YWFjejEyM2FwS2x2MExr?=
 =?utf-8?B?ek03RGZDWXlIMWZEY21tQ2FMYnRmd2dLTlZwVU5tMTBkcG5iWVVSU09jNjE4?=
 =?utf-8?B?Y0pGcTR5WE4xdFg3K0xoeUt4dVpZR3dYckorRGo4Ni9vSUZpOUc4dHZ4N1NC?=
 =?utf-8?B?QzVTQU1CblhKdXRLMi9JV3E4N0hCanVXQXZsaEpjdUs1VGljeXVSL2dMT3V1?=
 =?utf-8?B?ay9FSVVnNHFIREVkTW1zOFF1SXpQK05CREtUZ2MvdU52dDFCUW9SeGZPVXBw?=
 =?utf-8?B?Z01TaXkzeHBVK3drQ3J4dW1LbytmRlJKSFU3Q3oreWJNZUNaQXF3bGlIR01D?=
 =?utf-8?B?VVE3R3JESzdPTnlyMHBWUlA1SjlmQlZPSWRyQlhkMDVaYmFuTDhUbE8vdGNG?=
 =?utf-8?B?MmtXaU9KQkp2dTRKencyOFMzWGw0NXFSZnFQQ1NNUU80aUpOUjVGSWIxT2NW?=
 =?utf-8?B?MFppWURMSWx2Rm9hcmJTcTRvaGVjSmJoZnovZC9jM1UxZkZISUs2Y2cyaXdI?=
 =?utf-8?B?Yk1lWkNsZXJCV05KUnFxanBTNEpYTWVZRmMwaDhpU09zMTY0TEpTbm03Vk5j?=
 =?utf-8?B?YWozY2V1T2s2OEU1U2s5ajBVUGFIMlR4VWJwUldLSFZLMjB6R0krdHZxNE5x?=
 =?utf-8?B?ZzBtNjNRTTdwRG9DR2VGdk8xMHpYRC95UFpzUHZRL2VUeDVNalAvTVV1eVNT?=
 =?utf-8?B?bWRFaytaajA3Wks5cFhtbGFCVkRWZ2NYSXduNnU3MDRXVGpaV2hrRTJneGJH?=
 =?utf-8?B?cVdYbTVpSEZ6bE1RUGNlV2tJcWR2Y3oyUDV4ZVpPVi9TdWFmT0dodVd5SXpv?=
 =?utf-8?B?OS91d1Q4UlgrQ0FiYmdPYitFQkVDRzJuM0pMZlpQay96MUN0aTQrRmt3SXpW?=
 =?utf-8?B?ci9mcGNNS2tMN21IMHB6KzFDT1puL0hQQU5qSWRDWi9yNnZRRVVoN091bWd6?=
 =?utf-8?B?bklua09jUmhwenhRSkRvSHpXdTNYTktCZXZGTlNWMGpMSDJlQlZOa3lnbjJk?=
 =?utf-8?B?d013alZzNzQzTVBWSVNFaVhZdFlLUTVPMC94WEViK0tnUzN6S1hITng2Tisw?=
 =?utf-8?B?eDhSZ1BFT0w4Q0dMVUYzN0tsQU5tSXpJS042MlF6TUNjQ3hycDR2M2VhVmVT?=
 =?utf-8?B?L0k0YTVFSTY2MEh1WDBSNjl0aGN0dlJJamxKYm5IN1pCVWE4aXMreFQrejlP?=
 =?utf-8?B?dElBTWNTdzhDMXpZS2FxYllyeWMzZURtYisycFhHcTROS0pTa3liVEM0bXVZ?=
 =?utf-8?B?WlZCRHN4U3l5clAvNDNpdjF1SjA3bW5Pa25QZ1gxK2NTUnVndktJT1RVVGox?=
 =?utf-8?B?cWcwTS9HUnQ2dGUvZW9nNDE1Y0pIOHVNcjJVRjgzRnpTRTRmRFgyZ3lhRDZF?=
 =?utf-8?B?YVByRFozZU8rZlJ2WVN2Wk5NbW1BZWhHeUlIVWx6Q3ZBNDdKYWgyQ1M1Q0E2?=
 =?utf-8?B?WkxjZ3RDMGtobDRjOU5MZWtmVDVFUUh6Z0Zxa3cvNVZwUkFiR3c1c0RLVTM4?=
 =?utf-8?B?RWNHaUpkdUZHNlBrWG01L3BSaG1hTlpIWHVkTFB0UGhaUFJucGx4TGpBeER4?=
 =?utf-8?B?dFR6R2ZmZnpYOE1oa09BaVF6VjIwRlpQQUlFclBDalZ4dHFZdDdWUlRrN0ZP?=
 =?utf-8?B?cmM0QTZWSktwZEhNc1VCazAva05ORzBLMks5SGZnclA5MVpPcHJteUhuZFY1?=
 =?utf-8?B?QVVJUStDSHl3Q2hjU3k1U0VkSmxkbFlRbVZ5MS9nOE5oM1U1TnNHVlVuVkE5?=
 =?utf-8?B?M0tRenNVUGJjZnMxdkxoQXdOVWxpTTh5VlZCWXpyUUxpb0RZSlBYMDVZLzF5?=
 =?utf-8?B?R3hJNWNndHNFZ0kyQlR6K1NLajRDSVg1M2VhZnF6TC8rbHBwejg1WlJPRE12?=
 =?utf-8?B?Y2tLNnBUd1BKODRSV2huMWE3SVl2d0VnRFkxUVpiZGFOb3lUZFZaT3FpOGQ2?=
 =?utf-8?B?QWtWMG1Ca2tmaTRzamxNdE9pN3hkSkZBcEtyc0MzVWVoK0tFbEVZU09YUTNs?=
 =?utf-8?B?Z253MWtCa0E2bU9jWXA2cWJUREZ3UFFkMzZ6S3dXMkszcDFVeHhLVlBnL1ph?=
 =?utf-8?B?R1A1TXBRcmFha1VpTnlFVkRnMW56enNjaHlvbDdGSVhSSzBLUUhLNzkwVnhD?=
 =?utf-8?Q?BdDOYeEv/wfJPEk9K+PuRTu+v?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e3374d-b135-4514-2993-08da6afb0785
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 09:26:02.4985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQSms01pXnRQt8t5I21/Ds45z4/KBdKvH4+icokNm7zHnxbel+OkypePV0sJgp1YVSEi9JwaAA042H0xUeN9nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1423
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/10/2022 9:39 PM, Maxim Levitsky wrote:
> On Fri, 2022-06-17 at 20:18 +0530, Shukla, Santosh wrote:
>>
>> On 6/17/2022 8:15 PM, Shukla, Santosh wrote:
>>>
>>> On 6/7/2022 6:37 PM, Maxim Levitsky wrote:
>>>> On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
>>>>> VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
>>>>> NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
>>>>> read-only in the hypervisor and do not populate set accessors.
>>>>>
>>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>>> ---
>>>>>  arch/x86/kvm/svm/svm.c | 20 +++++++++++++++++++-
>>>>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>> index 860f28c668bd..d67a54517d95 100644
>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>> @@ -323,6 +323,16 @@ static int is_external_interrupt(u32 info)
>>>>>         return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
>>>>>  }
>>>>>  
>>>>> +static bool is_vnmi_enabled(struct vmcb *vmcb)
>>>>> +{
>>>>> +       return vnmi && (vmcb->control.int_ctl & V_NMI_ENABLE);
>>>>> +}
>>>>
>>>> Following Paolo's suggestion I recently removed vgif_enabled(),
>>>> based on the logic that vgif_enabled == vgif, because
>>>> we always enable vGIF for L1 as long as 'vgif' module param is set,
>>>> which is set unless either hardware or user cleared it.
>>>>
>>> Yes. In v2, Thanks!.
>>>
>>>> Note that here vmcb is the current vmcb, which can be vmcb02,
>>>> and it might be wrong
>>>>
>>>>> +
>>>>> +static bool is_vnmi_mask_set(struct vmcb *vmcb)
>>>>> +{
>>>>> +       return !!(vmcb->control.int_ctl & V_NMI_MASK);
>>>>> +}
>>>>> +
>>>>>  static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
>>>>>  {
>>>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>>>> @@ -3502,13 +3512,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>>>>>  
>>>>>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>>>>>  {
>>>>> -       return !!(vcpu->arch.hflags & HF_NMI_MASK);
>>>>> +       struct vcpu_svm *svm = to_svm(vcpu);
>>>>> +
>>>>> +       if (is_vnmi_enabled(svm->vmcb))
>>>>> +               return is_vnmi_mask_set(svm->vmcb);
>>>>> +       else
>>>>> +               return !!(vcpu->arch.hflags & HF_NMI_MASK);
>>>>>  }
>>>>>  
>>>>>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>>>>>  {
>>>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>>>>  
>>>>> +       if (is_vnmi_enabled(svm->vmcb))
>>>>> +               return;
>>>>
>>>> What if the KVM wants to mask NMI, shoudn't we update the 
>>>> V_NMI_MASK value in int_ctl instead of doing nothing?
>>>>
>>
>> V_NMI_MASK is cpu controlled meaning HW sets the mask while processing
>> event and clears right after processing, so in away its Read-only for hypervisor.
> 
> And yet, svm_set_nmi_mask is called when KVM wants to explicitly mask NMI
> without injecting a NMI, it does this when entering (emulated) SMI.
> 
> So the KVM has to set V_NMI_MASK here, becaue no real NMI is injected,
> and thus the CPU will not set this bit itself.
> 

Yes, we will handle smm case in v3.

Thanks,
Santosh

> Best regards,
> 	Maxim Levitsky
>>
>>>> Best regards,
>>>> 	Maxim Levitsky
>>>>
>>>>
>>>>> +
>>>>>         if (masked) {
>>>>>                 vcpu->arch.hflags |= HF_NMI_MASK;
>>>>>                 if (!sev_es_guest(vcpu->kvm))
> 
> 
