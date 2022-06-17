Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20EDD54F977
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 16:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382433AbiFQOpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 10:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbiFQOpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 10:45:14 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E6D338A4;
        Fri, 17 Jun 2022 07:45:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrTY+29E1ePlxsaqlVvAtcxTCgpsEC6k8gpe8eEcRH3vqVIfxi3Dh559CpcYIXrpCK6Iu+wo8Mto0AZvWED5HgprljbMnauSB00vV4dL8bMxRwl0rXl5D3vE7HKQcmrSUkzYF3zcKuP4XWT781eE0ZknPfHjx6xqM5qMH27aAEGlehdsYKdEEHxuTciZ4kQpUw19Pw2rZDu1fuDoeBBCx+5puBnlekvcJfJkHfnZxPXHfz85VNDy0NfbXKxxjhM4fWSRTmp3HRBr/+ipDuYzM0hUZP8z9HdIydLhvWnVZba/grtfaP118jeTVbcD3TWzUqSURzhqUHwXMRPgJX6/hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KTQ4lS7DmPVEjLfhPBqvteeofEm2D/PCYKTCWICoPg=;
 b=gcmv4YvFccFavZWgEUcZykmPLbS8oYGG8AqB2LajqLGETzNpO3VZa0y963BAV+Co1MFZ62cR1qZRJm7euO6He+lxBGj9/Q1T8hn/RgIcdhEXEDbNh/f+HyZdQ7IBVm4PgewbrerNJ5Ptaovi9fZYNSXYvpJHj36oEvIK4jZAdU0eDXWA1mQTvjV5Qe4ENM+13yw66g7c5snKmBepJlDYAwr9Vg9yXNcv9xa/VI5G12VGXP3vHqYdevFYsIuFNYmXYBfTg/3Ly/q4KspZ44zonXyJK/fKK+ZXfvGW4myPTaUZDUuPqKFCzVKKPXdpIU6xeB0rXQIXKyD8AaEmfygj6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KTQ4lS7DmPVEjLfhPBqvteeofEm2D/PCYKTCWICoPg=;
 b=aZZgjwWz2ug1qSCkdRQ+p7DfQvebYzoj52Q6kq63bPpMbzNmsrPpbq7A0taDaaC13xt5GIGFbssulRar3LEkNRvT9M+4prSyDoBiBgjP6ip4Aco/Y9fnAaUNkqhJoD/0WR0HKtWOKaNv7XhB4W2DolsAgijkIeLe2+b30RDzKwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CH2PR12MB4069.namprd12.prod.outlook.com (2603:10b6:610:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Fri, 17 Jun
 2022 14:45:12 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 14:45:12 +0000
Message-ID: <91c551a2-11fc-202f-2a8f-75b6374286b6@amd.com>
Date:   Fri, 17 Jun 2022 20:15:00 +0530
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
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <d3f2da59b5afd300531ae428174c1f91d731e655.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0080.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::25) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5581e406-00ea-477b-8269-08da506ffb7c
X-MS-TrafficTypeDiagnostic: CH2PR12MB4069:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4069A1ABAA2842A416B0C61387AF9@CH2PR12MB4069.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4KsenL2E5IUxca+z0T7yGiJQEFwBw1trnDu7o1OeuK5JPWmHyl2rrfmXdh7C1LkvbXgj2rNusH/uD/sGTeLQpA+btU6BaPX1fCJLlJbXHZsTXHKsGGWdkVO426DhhlKwag9MrBoPZnPtAICG0EFAocyMDZNlU4B+Y0w6DdBk2hgMRFel20d+Sq1GWAeiykUOQS1FhijdmobppfV1f+o2mwbu4YigeQBX4BdaqAr0Nv19V8qIPAGr3mW05JIytwu+S+oM5d2VVVVYiJQiTcZbPxxdddDLnNnnOKzGBgZovfjWvhy3lQgC7ni0LeGJUp6SKZKQ/rlny0lHRX3velT9X6zKOrBfDj3U+VhZQDvr0CQ6lM441q4ZasPuoPHQ5eO9z0CIuA/BWyMOBJEG2XqFvkhFqp3JuV2sBzAfEx5vthSWslppXbW9pRv4NY3Mqv83pv/+gtUeeiGsTgaAzjkzmXliBeFdZ7YM8pMKfRuGBfkrClkvBJfstT5SPUSMUWQkY+dIuGJ05bW70vsYIHtLbJKjQLSRjbRVa2FJ2RNaxIoWIFzNij/heSTETHNRhQG1aOlcWWzVDU+Sosdaj513nA6BVwAz+qMI1PYL7Wt1ZGkg+fcXuJBvGoh9BKSwCpMkAbJGxmgub2BFjRIO791bNjzbxi25cEaBthG/V+mY83qjpVecPfQbnSUtAao07Kg+NTBq6WRYYB1ZqlDFAI262I3jxJprh2PwprH+mDaviU80ySmk45XuEJfgmX1pSWm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(186003)(5660300002)(31696002)(2906002)(83380400001)(36756003)(2616005)(38100700002)(86362001)(6512007)(6486002)(6666004)(31686004)(498600001)(26005)(316002)(66946007)(8936002)(54906003)(66476007)(4326008)(66556008)(110136005)(53546011)(6506007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXcyTGY3UWswZ2YyalNDZldMQnRFWURSREFoR1hFbzQvcHNBdVlQdEVXSkkx?=
 =?utf-8?B?TmFTUlBkWU9JZjdCUnpJUjFWUEpycGk3UlFkOGRGMjZSV2hHN3dYL3NkekNz?=
 =?utf-8?B?SUJMcThSWEc2Y2ZpbFpnUnNsbWUwU0J3NWNiR1BBTkhVMjJnS0dlTzZZbDlE?=
 =?utf-8?B?MXgrTVhtZkVUaUFsYjlSaGxUVkt3NDk2MFR4S1RqS3hjWDdOU20zNEh6VFV0?=
 =?utf-8?B?S0dPekM1NDRPWnhOL2lNQzFFRkFlZjB5ZEFSSkQyODRobUVkekhOeFVWSUFJ?=
 =?utf-8?B?NzFCL3NsWFVQbjVDQTkwQVpQTUFZc3NrY0s4Z1l3V2VyMFBRcCttNi8xc2xs?=
 =?utf-8?B?US81K3loREFVRnpqUGsvRGYwRVhmYlQwMWdBdWlGcDhaRkVYQ3FiU1B0Y0Vt?=
 =?utf-8?B?Nm5saXBaM1dsK0ljYnhCazR1YTRpZk9GQWVXelN5OTRHQmwrbTViSUJOdE1k?=
 =?utf-8?B?eDFVbVdJK3A5cUh4R3FzaWVGeENFOWkxY0Q1Ky92Z1pMbEhZWmxkQUxIUkNW?=
 =?utf-8?B?MHAwNS9HaWh0c05VdXYwaUFnVUI2TTV0bmxYR3Vkb0xKM1JoanJ0eWpwdkYx?=
 =?utf-8?B?ODdHSU9EYjMvMEZxRGNLWm16RitlcEVuTmNObjlnUFRjSmpLVTQwWnZZSjJO?=
 =?utf-8?B?d0ZodzczN1FVS2JEalZTeENyS3lKczJTSStLa2x3Tk9pOU1ydUNobHJuRHp4?=
 =?utf-8?B?cjBtU3VRK2V2YUxqUUZ2THl4QjY3aXhoVmNEcHZicnVOWGpjczZDTk9hditY?=
 =?utf-8?B?YVIvZEVOanBxZ08xclNEeUQyc2pZaDdONEVxNkJJK0ZETFBQTEJpU1ZPdm5w?=
 =?utf-8?B?OTh6ZGRlMktTbVZIcGRsR0JoNDJsdjRWTlY0SS9JTnQwamdBRWlLV3NnNit5?=
 =?utf-8?B?bUNDRVViOWdDMGVuLzR0WHZra0ZkSjVMQUxheW96WnhVTVhBaVlXa0F0TVht?=
 =?utf-8?B?UmtmRENFQlZWYjhOOGpvT2Y0ZGtFV2I0UFNaYnNNVUdwRmF3TWZWWFpkOElm?=
 =?utf-8?B?Mm5GeUZQQlM2SUZaaTI2Uk5saFhRUEIzZ0xVMm5OdzE5eVIzMkZtWlpaNVpu?=
 =?utf-8?B?VFFZOEVEUUhXWHpGWWozOUwvdWlhWkg0YkNyL3dic3psTzhuZTNRTVFmR1l6?=
 =?utf-8?B?b09BOHRrTWQwVllveFBCMDhSRU5ZNnBzK3dIS3RmNmowVGk2NzNrRVBWQW5V?=
 =?utf-8?B?L0xGWW9DREpWd0U1Tzh2VHFZNGhRMkNTV0FTMnNxVVRHMFBwT21KNkhkOGRt?=
 =?utf-8?B?RGdSYTNVNkxnaTNRUEZkUlhuMVpxM3VZd2xoZEhGRTZtdmh6clVOTzVwWkFD?=
 =?utf-8?B?Y1JpTzZQRW1ET0cvMkd1c0RiWk1XYnE2MkVTN1JCTnlRVmtRTzVic0lBYno2?=
 =?utf-8?B?RitUTWw1R1p3d1d1QTc5dkIzNEJWN3RkMytFTEgvK0J3d0kya241bWFIVysz?=
 =?utf-8?B?cjNGYlpwVC8zOXhLWGF3aGJFMGk4SkpLY2xCVE56RlVObC9vSVkzbFppM0dO?=
 =?utf-8?B?Q1RWVU5nL0tYcENVM0lhUXh4aWd3OWRUdVYzTTdLczlvMnpIYk0rdDVTTWdV?=
 =?utf-8?B?cGdhNlFzNkJiWWFybXhoMm02QzFCb05rdTJySHpHWDRheTY2ZExhNW8zcXhs?=
 =?utf-8?B?M29ZVkM0WWhTRkZ2UjZYSUhDOW11VW94R3ZsRmJETERLTXo1Q2ZpdkkwWktO?=
 =?utf-8?B?Vll0TUowc3p5SStkYXVIcjROQUpSeHA5MDgzcnZmVVhFaGsvNVlEVGdvVisr?=
 =?utf-8?B?Nk1jQVFueHpOTXViK0p4VGlSTStEeVhFTXYxa1hzMk1adGFFN0gyeXUvaUNN?=
 =?utf-8?B?OXlBVTNxOENvbEFCWXFQa2RtUFJBSlA0VVd4Z2pxWmNZR2dvY3pnZTkrN2Q5?=
 =?utf-8?B?U25zUkRSY2plNXlZVDJlL3NWK1JHa3RYcjI1bTFOZXZMYjBxZlZaUEdEVm14?=
 =?utf-8?B?a25vUDlBZGNhaHVRb2ZkZVU2dXpQMlhuMlRJSkRMK0E4YUZHWnJ4bTN5STdD?=
 =?utf-8?B?TzdNNitwK0NOSHNOTXBrbUYxNDZUSFhQcnJxWTRFaUswek92S002S1hWVGlv?=
 =?utf-8?B?UVVGUUN0cUZ3TXRrVHdjVHBjb1Y2QUdyVFROMUplaGtRT0J5S0pPdlk2bzdp?=
 =?utf-8?B?UVgzOVJkVDQrR2x5VUJONUZxcXdSQ1NPblNtVWYyaDlEdGZORU1BZ05Ma3pC?=
 =?utf-8?B?TTlZaUFvc0ZnOEhibmZZSDRhOUEzWGJCNENkdWE5ZmpnRktGVUxiSHRHaGtU?=
 =?utf-8?B?M2ZQc1ovTlJsRllsQTBod001N1QxUjJ6Tm5rQWpYaFd4cWxMRCtNQWUyNElo?=
 =?utf-8?B?anNWZ1NGbTZ1RXBldjlCT00wdkQzY05tQUV6VVphL3cxNzFrbXlUZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5581e406-00ea-477b-8269-08da506ffb7c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 14:45:12.0641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vYpCidK6d3dmtjaYb4G9oOUMpxstRm+WMQUMYTuI+anTEY/aiyT1qiVorRHf7Orvk1oaCFBqX0G3fZtMBW2N/A==
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



On 6/7/2022 6:37 PM, Maxim Levitsky wrote:
> On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
>> VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
>> NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
>> read-only in the hypervisor and do not populate set accessors.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 20 +++++++++++++++++++-
>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 860f28c668bd..d67a54517d95 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -323,6 +323,16 @@ static int is_external_interrupt(u32 info)
>>         return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
>>  }
>>  
>> +static bool is_vnmi_enabled(struct vmcb *vmcb)
>> +{
>> +       return vnmi && (vmcb->control.int_ctl & V_NMI_ENABLE);
>> +}
> 
> Following Paolo's suggestion I recently removed vgif_enabled(),
> based on the logic that vgif_enabled == vgif, because
> we always enable vGIF for L1 as long as 'vgif' module param is set,
> which is set unless either hardware or user cleared it.
> 
Yes. In v2, Thanks!.

> Note that here vmcb is the current vmcb, which can be vmcb02,
> and it might be wrong
> 
>> +
>> +static bool is_vnmi_mask_set(struct vmcb *vmcb)
>> +{
>> +       return !!(vmcb->control.int_ctl & V_NMI_MASK);
>> +}
>> +
>>  static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
>>  {
>>         struct vcpu_svm *svm = to_svm(vcpu);
>> @@ -3502,13 +3512,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>>  
>>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>>  {
>> -       return !!(vcpu->arch.hflags & HF_NMI_MASK);
>> +       struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +       if (is_vnmi_enabled(svm->vmcb))
>> +               return is_vnmi_mask_set(svm->vmcb);
>> +       else
>> +               return !!(vcpu->arch.hflags & HF_NMI_MASK);
>>  }
>>  
>>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>>  {
>>         struct vcpu_svm *svm = to_svm(vcpu);
>>  
>> +       if (is_vnmi_enabled(svm->vmcb))
>> +               return;
> 
> What if the KVM wants to mask NMI, shoudn't we update the 
> V_NMI_MASK value in int_ctl instead of doing nothing?
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
>> +
>>         if (masked) {
>>                 vcpu->arch.hflags |= HF_NMI_MASK;
>>                 if (!sev_es_guest(vcpu->kvm))
> 
> 
