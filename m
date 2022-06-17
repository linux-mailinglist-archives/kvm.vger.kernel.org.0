Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA17654F9A4
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 16:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382997AbiFQOsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 10:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382969AbiFQOsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 10:48:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CA1186DD;
        Fri, 17 Jun 2022 07:48:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8ezECQesM/drHrMsR/wAdaDMbrRlTxfg49oTIhdmdRxzkAeEpA1EuWBjpHkh1MTTSswB9RfE/EJDW32BFRVc2pWGqQLSk0tFa7abuAKjfJWqTU6x4/LW47oxqDGgEbUYfstEG639m4lvVbW+yQzNUPgHAqKnyreq4HQ3xlezBI6VgKPnIJxOorg/c4ETqsELtDOVHPub/3oMknKV1XoKynzL1aj/REeUPuIhG7O4RRtGfgDvZq5hkzMThoTU8kA9580mdQ78VVVPDXxF8Jzt4l5WStFykQIY46XBTCU0wG7fAi3sF2oKmJSZmJunMXcYqjELIkSmcMAAS5y7PE4CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hff/11NKQZI7kIfvdw5OrwNQVotovQZBD5vquLwkayE=;
 b=GivNh2dxtEj6kznsHhYxUc/xZdMILWs+mUBVGztdov9Tq5Rj7ICv7J8JVSLr0xg6zdSLcNYNtmi1sPRnQtYchlvSHltp6SgQIzCeSRWifjsEDgh2jn03gdP9ocdeAVniW5Ete9nUHfP3DKSvum9KlCYP3OLmAR1PEw5YcKgTZ+oVf0LDY7pY3dx1P7AC2lrsvF4zejnb0diJIuKph4nbHvx+Xwuu7nkO8Kq5tnMLlC8GVZID0hca+HhLWBQ3Cx97zyXTWlI8Xs1TNM00aILTGE5FbPlp+QatJDWmN6NEoWa2fvu+7c8KQV6dHHG8+SCGWxAcPeh7MuFChQma48FwdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hff/11NKQZI7kIfvdw5OrwNQVotovQZBD5vquLwkayE=;
 b=WWibCoIKWVH1/2rxmQKPWoJ7gS0W6VycdsQq471oALJBto6wz917xCrmipTnuE8Wzp71ZLTr5X9i9dqN8dQ3MDGoeq2l3K0HnkSLCVVpvXEGZj4Taq2OeUH7FjNGzvGLRrVXB+HsXg73wJXH1fxyvHms2bcsC+O4e05CQw7CC2w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CY4PR12MB1879.namprd12.prod.outlook.com (2603:10b6:903:125::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Fri, 17 Jun
 2022 14:48:39 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 14:48:39 +0000
Message-ID: <fcf79616-ccbe-1137-6080-57d00773ff83@amd.com>
Date:   Fri, 17 Jun 2022 20:18:27 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
Content-Language: en-US
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
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
In-Reply-To: <91c551a2-11fc-202f-2a8f-75b6374286b6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0183.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::8) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 362d61d5-afdc-4cdb-c7bd-08da5070772c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1879:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1879D94EE2E097A00E255A4387AF9@CY4PR12MB1879.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WDfZx0zlRaQjIZbRNDI2RqlNVVlnsGOR6wGp7jpRY9V9cO88v5gQ/8tfA3jmgr17Z95zyK14aBi16rIIpctBgtcWQefSA7vITCgMbvgrCUDJGo+W4Us8gQ2xlCaW0slajgq032nr1Hh3f9QDaS0mz9lfswD6rtKcezFsB4Mbgbk/kl+DqU2gv+XETh11iYkcwD1n/AxZ/aExVaiujjDCOD03vqCZtRptXgMw6vIjZFNEv8DelQE+GA/kqZtsgdI/d9EYBL/7x2RrJ2Zsc7qhv9CJ9GLWoLeIy/5FXncFonyl3bwUp1cXc6No6Pimaqv5XBiPgPWiHSFUMuvcBLvOJXIwM+FiN4nkA4HpYcr5pQFVYufXV4XG1/uAbLXwpMdAng19mjATMEGdK3+mgahbYYCC0PrVZrQDbvckYAf3BfqiR2ubh5Hbwdece1mp0hNF4TTo9QvwI0VLqyyG5egamb5Pi1pZvBBeLZWT5xp/khSTrDQN+KrEwYJNSOQecLL5IVcJW9TUBs4K7kodTNI2dVlrwRaw1vy/FV9Zh92K8IIAzZvIMRWMisYrhBHOK9AuXxRyIU0et+rZHmiGSvXSm6eE8Z2dpOG9iaShPJBmBwDs8CGECubC37tMHP2wf7g12L5/8CCUlpqyOegg/h6foeoJYYLdxFvcxVnLQPs+GJeSuhLzWYYu622GrCYwz5ktlcUROAip6rUGXD4qvruslXA2mo0LhZFvNO4S6h4XwIACv1v/9asCnVcY4aszkZRC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(54906003)(316002)(8936002)(2616005)(36756003)(498600001)(31696002)(5660300002)(66476007)(66556008)(6486002)(4326008)(66946007)(8676002)(83380400001)(6506007)(6666004)(110136005)(31686004)(186003)(53546011)(86362001)(2906002)(38100700002)(26005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWtPUGtNTVZKeGdsN25FRkZkN0tINjlSdGorRlZJVEFTN09jbjh0d0JUeGZC?=
 =?utf-8?B?M2JVT21CWTdOdzBFNmw0alNOOVpZR3JMTTNoSFpycVFUSExWMmNob1dEK3p1?=
 =?utf-8?B?YjN3eEJmdlJiSGc2VnJBcmVNNTB4bGxUamJaSXlhNmpMUHR0OUZhLzBOMldt?=
 =?utf-8?B?UGwyZ0xIdnJHLzA0WU0zTXg5RitjZXlUcDN5Z0oxTi9DbEV2QzA1bnlvL1ov?=
 =?utf-8?B?ZUlFYWYrNHphOVpkaDlBUFh0OFg3Z3ljUHRvcTBJWmxEMDBJUzdtQmgxbm14?=
 =?utf-8?B?ZWdOd3EvWGphb040a21pQlVlOVdGWG5MOVJEdEtPN2duZXdyeVd0a2IxVzBI?=
 =?utf-8?B?TU5iVXBPUTJqWXB3WFlFdzNRSEQ5MFNJaGJmdlFXV2xEd1JGZWRoRC82YzEz?=
 =?utf-8?B?NlBZSWg3cEkwWno1UjVTUVVaTmQ5UHFZY2cwUm1GYlFrZmRjeW83aWgvYWpW?=
 =?utf-8?B?VFExSTZUMkFhTXRnZTBKUEI0S1NkY2Z2aHB0TXJFMVJ4VzZ2V05GVTBRSS9k?=
 =?utf-8?B?aWk1a1A5VTRQRnFKRmhjcVZDdEMyR0JNZk9GUUdBeDlsb2lqWk82ejdhdEZE?=
 =?utf-8?B?WGFXamE2M3c5WUxIMUo4Q1B4T1pwVWNLL0JkOUd3ZEdTM2ZFVHh5QUI5em5n?=
 =?utf-8?B?S1NNWEZtaStiTC9ETGNORlJFdWl3VXIzdDRQREJwRkN0bTlOclBZVXBsSTRK?=
 =?utf-8?B?dFd2cG5HRGovNTRLNVY5UFgxclYyMjhpeGFkcGJRSW5GTThqemNTQmtTN0Ri?=
 =?utf-8?B?dDJNNTV4Yzl5NWVVYldCbkQ1c043QU5ZcXJBeUlUVjd0V1QxVjZvSEFQWXdo?=
 =?utf-8?B?eGFnSnZMc3MxL0ZEdjdmcDNscmo2NUZnQ1VtU0tLTHM3SWJORW5MNko2bmtF?=
 =?utf-8?B?SGVKcmxjZXpkVHRsQ3JLWXg3cGgyQVhhMThBdkhzTDNnWkQ5UWVmYkl2L0ZD?=
 =?utf-8?B?SE5DOEgxcHdHMmduWTFTT1M1TTZDRFlwaTNMY3FNbDQzTCtrVmVmMEh4SDVK?=
 =?utf-8?B?dzBiTkFVVHg5cHA3bTF0TDl5TTlmb0pmUWQ1ajV4K1orNlpuY0I0ZnQrbEs3?=
 =?utf-8?B?WWNMR2VHWDhDeUNrRUtWN2Q1NWZkVkNRUmw3NWJ2TFhycGRqS3NDa2V6bFRx?=
 =?utf-8?B?UXdKanJHa3REM0cyMzNMNXozVjFPQjRQOXYxbjVKZGZTSWJtVTRRVmh0VkZ2?=
 =?utf-8?B?bWkzK1dWQXhYRnoybVA4c09hUFkxRnUrbEV1bSszeVpuTzhCUkRacDR4b05N?=
 =?utf-8?B?M1J2cit4VXpBQWd5a0RkWnNFdG9PelphSmkyTU9hYWJnWFBQL2hsTXIzZU4r?=
 =?utf-8?B?K3BvRTZ2NFJCMHY2QnRYU2g1Y2tFVHdXOEFWNTdZSVg4ak0zbm5qdDZBNmpx?=
 =?utf-8?B?bGdYbXh1dWVEZ25QVUUyVTZvSWRmZUVQWWJqOU5hU05zK21yMGJ3Rks3cDZx?=
 =?utf-8?B?a3JBK2lYVHdCeFpXY1ZkdEh1L2xVc1hYY2lKeVEvRkE2ZHdzOGZRbjAzRDJt?=
 =?utf-8?B?WWgyY1pwWmE0WFFMVkxsL2laM2JGUEJhZFJTNUdFT1MrZm96MGpxUUZFYVdN?=
 =?utf-8?B?Rkw3SWg4UjB3N01iTGhjc0hnUVlFaS9pT3Nqa2hZZHhObldMTGpWY2V1bDZp?=
 =?utf-8?B?cExqeDJad0x4bWlDcGJtU0NsLzFGZDdOdUdmeUhsUDVRdXREVHJGR2tHcXhi?=
 =?utf-8?B?cUNXSFY3Qnk4R3pOOW9yR01SVjlrNGhZcml1d25kRmNZVDAzTnJUUnhmKzRX?=
 =?utf-8?B?WElCdkVIdGJQenRtRm5Xc3lhMThlV0dUQVYxVGJQYUpqN0d3akpDWDhZMXZC?=
 =?utf-8?B?V2pGdmxsL0xEZ2Q0aWhtNDZpM3hrTDQ1RUZTYzM3T3FkZHkrUjEzMXF4ODNy?=
 =?utf-8?B?M2pSSndtWWZrR0hFZk96Yks4K0VlZE5vL0RiRWh6SHhGZWJUL2E1UXp5Y0l5?=
 =?utf-8?B?VWxSaWZJYmgraFQ3bTVpUytlc3h0VFJ5bzJwZVpEMGlsZHhvcjVQR21hbU9N?=
 =?utf-8?B?THdXRExuNS9LeW00V09xK3VFdmVPTWhzdmV0d3I4MG9PM0NoNnNtUE53Z0Zz?=
 =?utf-8?B?L3RERllDQWtZbEloQ1BtVnYva0pCV005Q0xzaDJkc0lwTFZnSUdmYzdwTXA5?=
 =?utf-8?B?T2cxZ09hV21PVTluUTV5dDZsZEtzZzRWRzNwQVlVeWdBbU9WOGRLdWU4ZXk0?=
 =?utf-8?B?UjVpb0VuN1F0eFNNTVNvYlVWeWpQTVNoZ3FLZHpKdDJmTFlFWUtqdFEzVFhq?=
 =?utf-8?B?S3licHBVN2RENUwrV0RRcCtmSzhta05GdE53c0J0OHZrd3ZaNXNidUtyRG5L?=
 =?utf-8?B?M0ZiWWlNNHNIZnRTK1pURm1LYlk4ZlQxWC9sRzVkaG5yM0dxeU15QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 362d61d5-afdc-4cdb-c7bd-08da5070772c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 14:48:39.6246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsp92lo8xCwdZKlVKTNxx0ACOZxbKU3Zn+OqspznppM9OX7X5OO6RGOZbAnT9A3cFSrLNV3qp9VH99YiqusWAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1879
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/17/2022 8:15 PM, Shukla, Santosh wrote:
> 
> 
> On 6/7/2022 6:37 PM, Maxim Levitsky wrote:
>> On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
>>> VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
>>> NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
>>> read-only in the hypervisor and do not populate set accessors.
>>>
>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>> ---
>>>  arch/x86/kvm/svm/svm.c | 20 +++++++++++++++++++-
>>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 860f28c668bd..d67a54517d95 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -323,6 +323,16 @@ static int is_external_interrupt(u32 info)
>>>         return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
>>>  }
>>>  
>>> +static bool is_vnmi_enabled(struct vmcb *vmcb)
>>> +{
>>> +       return vnmi && (vmcb->control.int_ctl & V_NMI_ENABLE);
>>> +}
>>
>> Following Paolo's suggestion I recently removed vgif_enabled(),
>> based on the logic that vgif_enabled == vgif, because
>> we always enable vGIF for L1 as long as 'vgif' module param is set,
>> which is set unless either hardware or user cleared it.
>>
> Yes. In v2, Thanks!.
> 
>> Note that here vmcb is the current vmcb, which can be vmcb02,
>> and it might be wrong
>>
>>> +
>>> +static bool is_vnmi_mask_set(struct vmcb *vmcb)
>>> +{
>>> +       return !!(vmcb->control.int_ctl & V_NMI_MASK);
>>> +}
>>> +
>>>  static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
>>>  {
>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>> @@ -3502,13 +3512,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>>>  
>>>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>>>  {
>>> -       return !!(vcpu->arch.hflags & HF_NMI_MASK);
>>> +       struct vcpu_svm *svm = to_svm(vcpu);
>>> +
>>> +       if (is_vnmi_enabled(svm->vmcb))
>>> +               return is_vnmi_mask_set(svm->vmcb);
>>> +       else
>>> +               return !!(vcpu->arch.hflags & HF_NMI_MASK);
>>>  }
>>>  
>>>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>>>  {
>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>>  
>>> +       if (is_vnmi_enabled(svm->vmcb))
>>> +               return;
>>
>> What if the KVM wants to mask NMI, shoudn't we update the 
>> V_NMI_MASK value in int_ctl instead of doing nothing?
>>

V_NMI_MASK is cpu controlled meaning HW sets the mask while processing
event and clears right after processing, so in away its Read-only for hypervisor.

>> Best regards,
>> 	Maxim Levitsky
>>
>>
>>> +
>>>         if (masked) {
>>>                 vcpu->arch.hflags |= HF_NMI_MASK;
>>>                 if (!sev_es_guest(vcpu->kvm))
>>
>>
