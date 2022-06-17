Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CF254F9BE
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382966AbiFQO75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 10:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382433AbiFQO74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 10:59:56 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5EA393F0;
        Fri, 17 Jun 2022 07:59:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJLp5+1l6C4ejiOzuRRuc4hhk+i77gyebX5uu33/K74MN0VgI2jHvQPAehINCtETY9l39vF6CEZQwpo40oqF0n0sln18odgu0xNDDiO+B3g2QHBIWPDbdNBA72uT7BJJS1ZIHVVM1Wwi8EM5gpG2tZlXiaojE+6BoYxKdAjIMP8khCNtqqlAkKv4kfL2fIlH9qS3fOx6gBEUQl+wsHzRRucP+RczkRQYeK8Hr0t3LUwO+XlQRpg1TGsA77ECXqDLd7bVFARFgSZtmqtzoOnkbOTp3j2gBSN9utHEHoSuzBYIUl0bes7VAZzLiLQE7NBRJ6+WQVKnpni9zA2Aw3gQlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zW09Wdt8WzH2uUCr75lcWh70Nw/Qgrr1e60sMNL8VEU=;
 b=bpXA09ivw5/g7UaVQClpYsX8cT424B5LOZDrGLkIe+RFNyw847x4x+GysfiMpbiOz8Hd205iKAPJ/sC5KDFcXMoCPtUoCv4ooz7477M6e5paGiSut1EuF4GJ3sSLsHlMeI86m/xrk9Z0SkrRK9VQ6X1lCNk7xlRnkBgIreHnO9NGSHLRlGt16UMVIPQPyr8LW9oI/f95apCghoTOHqJUjn26iJmz4cyUI1SRwqlwwSpfxIGpLYTFl82oA8f4LLs8D6epXBc1Uxx3ZPsyH7JXC9TLyuxErflC4JiVhEhMYj1ms032uOje+Xc5RrB5JTnMM9FgpJCix2U+Wye03JGEog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zW09Wdt8WzH2uUCr75lcWh70Nw/Qgrr1e60sMNL8VEU=;
 b=IcLTTAcJLRPLU7P7ZQdbsoxbjxpN4GaneZr9K3JmjU3vpsDcXpo3WE4nRXtFJHJrVOI7wwzzwqJxZAN42Xwl3IVMBmNefDJygBuY26vhFZIqvJ3Da7n3nRfix9boj/YYrpUBdqvvkGVZhzm3blr54DZWmMjXco+FviBr85OcqYQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DM6PR12MB3276.namprd12.prod.outlook.com (2603:10b6:5:15e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 14:59:53 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::29ce:b5ab:bd97:8a89%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 14:59:53 +0000
Message-ID: <ac67da62-a0c0-27a4-df81-90734382ffdf@amd.com>
Date:   Fri, 17 Jun 2022 20:29:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
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
 <20220602142620.3196-5-santosh.shukla@amd.com>
 <da6e0e9375d1286d3d9d4b6ab669d234850261eb.camel@redhat.com>
 <45e9ccafcdb48c7521b697b41e849dab98a7a76c.camel@redhat.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <45e9ccafcdb48c7521b697b41e849dab98a7a76c.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0221.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::17) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c3a81a8-445d-4be4-88f0-08da507208ac
X-MS-TrafficTypeDiagnostic: DM6PR12MB3276:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB32760F5E447C4A592964F0E287AF9@DM6PR12MB3276.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bl+oWLTdiQDgf7VW360nCWjOErJyukODJNvRJcQFaM0QXbvg208zUhJf+criStws9wcE3EjDpiBJc8lvLCpKMZqjkdYxhFy0UioK2jOysIDELrANtcCn9AXjoJDZu0xYLQFXvgpKN/bU+FP2MKH9//OPkbhMpl6/YTXfe3RgSLSgbWUVYR0A9GLor60erfdIiqJEe9XT+djjzS/t07fCdlCqYQB1s9WH5NgLhrTgucC+PN01oe7bZvypxbOD6HWMjj/Go3MyyDHqqAJ/6bNLsgnJRQGKwVNVHfOsIGSatvXlVq80RCm1141Fzmogxw+bEzxgPLXhZmL/x5q1GRhm5sgMXMYDqz+swmCv0NS3hLuaoQULqutSACYtI2po16wH3xW4ho7L1fHsydQtAc0DuOYMZoqJqXm3laX0woY1gbwH5bdHa1QkTdlh7oOo+Tb5WQ8dpDnyUsHjsPd0BwhCB3btHtHp1sil5AhW8tYreykSHQf+ZDkDp/Khxnfv2EwLT9TxeukPlsX7xg+KaeYo12clC8u1tDHEQopPpAqNgyA2EwxW3BYRYPlJpACqYG47xTKRrSlXVs0+jkpFdK7/ImP6JLevtJNrAeMjGIZXVKTDwFtW1k9dxPRfjbR3cNXOHjeQ5ErJYn9BzTFR8dTkgab2v4Gzo1PXpTx2/0aYZeF+Rk63EjGAosD5gYNdLVAiPElu8b527kzqr0axKa2iV8jeTUgAMdE5FnKMeAt3h3O9OXM/UTT8K4V3wcV+IMqf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(66476007)(31696002)(186003)(86362001)(54906003)(316002)(66946007)(110136005)(36756003)(8676002)(2616005)(38100700002)(66556008)(31686004)(4326008)(6512007)(26005)(6666004)(2906002)(8936002)(5660300002)(498600001)(6486002)(83380400001)(53546011)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0trL1dXdkRvclpjMFBkVm5LUFZ3a0tNa3FIZWRaUGZoTlA5KzI4Y1BCQVJI?=
 =?utf-8?B?R2pMMFBjVkJ2WDMxQUo1RG9Dd1ZyMmdvT0VHKzBhNExhMUY5UWhsc3VnVWpL?=
 =?utf-8?B?QkxybitkVlFKcnBWNFZFWHcrSm90UXQ0Y0ZoNWdLV2Z6RWtwMGZUcWdUN1li?=
 =?utf-8?B?dU95azRoK0RtWHMvQWEyWThxcWNWOFF3WmUvM0NOVXNIUzBOeHlmT01XeXdi?=
 =?utf-8?B?Skl1Y0E5UU42cVNYV3dpUUhESnJtYVFIQjVtOWJqU3JwUUhNV0dSK2hsYlN0?=
 =?utf-8?B?bWdXclhaQVBCYnA5aVpuL01JSEdKOC9ORjNzblBzMXlZTEtaMW9CQXFnamRE?=
 =?utf-8?B?dlpHZzlObFE1UFVqRFZhcllvUFVJRUZER1BKMFJ0VExzUnBqZzA4ZTQyUEU1?=
 =?utf-8?B?THk4NmtNelNWZVRDcG1uNVNIWGJDOXR3RVpzS1VQdEcyTllHVm1mbjhlb01R?=
 =?utf-8?B?UzhJcC96NjZGMWlBTGczSDBocTQrcXp2eXNpVkhSQzRlUkpSZE9wL2h6VGNp?=
 =?utf-8?B?Q1dHd0w0SVNIVlFUc3k1QlA1ejBnY21xaWpBQU8xY210L3ZDOUJNMnBnTlYw?=
 =?utf-8?B?aWFnV1YwYTk5WWlpTnJMZzlJdWNrVTEwWkZ6dkVjd1NrK2xabFBEQWozZjhp?=
 =?utf-8?B?N3JtZlE5djVTVlZCVHNsTTZFVENIaW9yT1dSWXB0N2VGYWxsVmpmdTB1VU96?=
 =?utf-8?B?d1ZMSVNwV3g3VmhYQmxaSStvazU1ZHlSWEpOQlhBYkFTUUtQOGt0anEyNEM1?=
 =?utf-8?B?MGlkQ3Fqb2ZHSGRHRjVjTVIycUpSZDBkWHlTanRzQ1lucGpYRFhjS1ZOdGt0?=
 =?utf-8?B?ZkFKdDk0NW1FNXR0UHdTQkRuT1RCaEJ3WDQ2Q29xbTdqb0RVOUV2eHFkUWxQ?=
 =?utf-8?B?TnZUdGd0TWRjMUlUWlJVSEZodWcwQzRSd3Z3VkZJcUJjaS9seWM0VUg0ZkhZ?=
 =?utf-8?B?VEkzbGRWc0pUMXBwbDJxdERZMXJHN01xSEc0cEt6Y2h4UVhQNzlaOS83QXhD?=
 =?utf-8?B?bzBqekNQVHorNFBHTmczWEROT3ArUzY5bDRSV3JDNVFiNUpEOUsrZWNpRGtG?=
 =?utf-8?B?OS9kODdtRlB4TEYzSHVZU2RwL29WU05NbEFKdWd6SVdsaDgzTE1Ga0RxWDNX?=
 =?utf-8?B?UnZSR2laOFh0WTRsb1R6MXRhTzhmUmVyU3htL1ZJTkwvbEhGUDdoQWJ3ck1u?=
 =?utf-8?B?RGZtaWFPSFNIbmRkQUJ3Z1BUalo0RFIreHgzaElrWHpmZ0xmbHNoM0E1MVlT?=
 =?utf-8?B?VTVyYXRQaXVOVk5INTRXeHNKaTlrT1U1WFRCQmFzSlppSWFJMjk1Qk9CQmoy?=
 =?utf-8?B?MVpnTkxZTDFkZHp5bEdPSnJNZS9hVEJMbmJKcExoTWNGckNySnArRHZsMFB5?=
 =?utf-8?B?SlBiRFhMN214TWJweUNwM2J0cG8zS0MyeGszTzl6dkhiTDFEa1dWTDJpbGt5?=
 =?utf-8?B?bHo0bjVTRzlOb3hpS0FhN3RDQ3dNS1Y3cHB6ZTVEOG1yK2NTMUM5a25KUVV2?=
 =?utf-8?B?Sm10M1Rhc3NqZFNTaDNkWE1yWjM2Wkh3VXRKaVlra1dSZlcvNnYrZXZESWV6?=
 =?utf-8?B?RUk4TDdlRmd2Z3hEdmJuc0NyOW5FNlkybGlLNE9lWU5qckpjUmU1Y3ppNVBz?=
 =?utf-8?B?QXlEaDZhY1hpOTE5UUFTMWYvVTFOenlOQ2wwNm9jUE9NNkZKdUY4Ymo2MkJm?=
 =?utf-8?B?WUJJcjZHcmlNd0lZbDZZakIvU0dTZ2gvOWkwWFpkNlI1MFpTUUR2Y0YvSDh5?=
 =?utf-8?B?MWlodmJrRFRXN2dSN1dvR3FyZ0ltaGZFbzdlN2tUNHR5cXZWSEhxNHd0WGZX?=
 =?utf-8?B?bmZlbU5qQjNyOW56MXJ3TERKTW1oSFlvM2xET0ZzK2hvQ240bW5GbzFKWkla?=
 =?utf-8?B?aWZFdnpPK1NuRzJvM2RFcGJMbDBEZGlNSUhiMUdUVnAwWXBlNDByd0lhcXA3?=
 =?utf-8?B?ZEtNS2lxM2loYWlzOFhTdVlUUUFjRkNCWmV1emppNkdtbE05VjNPeWt1UGR2?=
 =?utf-8?B?M1cyeEpwQ2p1UmNOOVFLeFQxSGNmWENlVjl1WWg1Wjk0YllFdCt1Z2NTbGpB?=
 =?utf-8?B?OTBsbURJb3p1ZUZZYnRUU1NKbGJGeHVBbm9FSjBweGdBVmFvMmRzL3NyQ3hZ?=
 =?utf-8?B?SnFHZnB1eFFZNkFocGxGNS9ZWDQ5VzZFcGxURzdjcENtckFQMVcyRENSMzI0?=
 =?utf-8?B?TFVxallrdHhQN1hGbnhnWVcwcXRaMkMrT1RBNk43bjNEUFJDVmFWeElqZkRD?=
 =?utf-8?B?NkdhSDQxVzhwc3ljT0VsSEx6SVpyNU1Hb1ROZGpZNTZ0bk5Nc3loVU9nVFZ5?=
 =?utf-8?B?S0dRajRrWit3STdDRkRrejZGeiszTUE5NGxrV2pSMGNYZS84K09xZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3a81a8-445d-4be4-88f0-08da507208ac
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 14:59:53.1802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22UEEeAdEY0nQXTPvw/t5DKVTlH82LVnOzQ8GRcxXK3MuZ2ed789U2LDS/LWaOyv8r5w05If6t4tmeTZdlrX8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3276
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/2022 6:42 PM, Maxim Levitsky wrote:
> On Tue, 2022-06-07 at 16:10 +0300, Maxim Levitsky wrote:
>> On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
>>> In the VNMI case, Report NMI is not allowed when the processor set the
>>> V_NMI_MASK to 1 which means the Guest is busy handling VNMI.
>>>
>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>> ---
>>>  arch/x86/kvm/svm/svm.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index d67a54517d95..a405e414cae4 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -3483,6 +3483,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
>>>         struct vmcb *vmcb = svm->vmcb;
>>>         bool ret;
>>>  
>>> +       if (is_vnmi_enabled(vmcb) && is_vnmi_mask_set(vmcb))
>>> +               return true;
>>
>> How does this interact with GIF? if the guest does clgi, will the
>> CPU update the V_NMI_MASK on its own If vGIF is enabled?
>>
Yes.

>> What happens if vGIF is disabled and vNMI is enabled? KVM then intercepts
>> the stgi/clgi, and it should then update the V_NMI_MASK?
>>
No.

For both case - HW takes the V_NMI event at the boundary of VMRUN instruction.

>>
>>
>>
>>> +
>>>         if (!gif_set(svm))
>>>                 return true;
>>>  
>>> @@ -3618,6 +3621,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>>>  {
>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>>  
>>> +       if (is_vnmi_enabled(svm->vmcb) && is_vnmi_mask_set(svm->vmcb))
>>> +               return;
>>
>> This might have hidden assumption that we will only enable NMI window when vNMI is masked.
> 
> Also what if vNMI is already pending?
> 
If V_NMI_MASK set, that means V_NMI is pending, if so then inject another V_NMI in next VMRUN.

Thanks,
Santosh

> Best regards,
> 	Maxim Levitsky
>>
>>
>>
>>> +
>>>         if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
>>>                 return; /* IRET will cause a vm exit */
>>>  
>>
>>
>> Best regards,
>>         Maxim Levitsky
> 
> 
