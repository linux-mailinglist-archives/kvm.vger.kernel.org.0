Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A42959F923
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 14:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiHXMNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 08:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiHXMNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 08:13:38 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C542A276;
        Wed, 24 Aug 2022 05:13:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIpRlo3u4+TP+BN7Hfx5ilE21dvEw46ZZLcM0WARA9/CBKu7xRiLkk1RbVLLQP7EimHgH0KHSfh6wFRb2ClwVbJ4Ibg/1MtXnmvkSZa2IqI5aTKJ0b1cA9h4bXdQ9kowZH0iN68M8z89QuWSZgpjZK/SWzkw8nB83bt/q1oDMrwlad9/40c9/UphQPB+xaoA4y3sSjQemFZCXnpQn1aahubkWXRGIxp+MAPn1vjOtqfiUTUKZoHYYN2fk6h1KSKFCnOOgjtqgXBvWjNn898t3+BMWP/SsUZ1ikjiq0NLDycpn8zeTeegqp7s2HLZpIiNKU3Po56XJmhTErI4FLUNrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zP6PW5+EmR/Hi0IDUViHIRdLYllwSXm+YW2Rf/6ZSg=;
 b=NNUwP/MFmQKiV+t3gVQy2fWdjhbHtIIyzsYwpZMNuD3i4kBEkm0xaGaITnWNjy0AW+UDKVWBDjxrform3ZTW0+z6j+wXZkwupMkYZrxcHAl7aZin8A0Yw5hWLyVmoc1V7+kAS6jJL544lzI0KOERld6It/a044s3zSl8dVLjnoaz938U8v58Di0BnEsAPBKeO2MF67ofhmKKTZhJlvGlrbJE0XojhahSyK2Pe56kUe5iFNhaaqZcRnPt5cEhRJctFsQKWIDRxIXEUOXOXoh8dpXFrEzR6Uj8jSexO/NI9ZJR27KlhkXvTTC/99aRr8JUem7IgmIAjyhbCaynUnREaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zP6PW5+EmR/Hi0IDUViHIRdLYllwSXm+YW2Rf/6ZSg=;
 b=Y18Re72FPKBmqsOlplqDpMcBcYBoEiMHgEfo+JI/d2PLROKjgb7VhoYr2E6baz1Bx9Ud7ajHesXp2MhnstO5D/HhZIBjsVdgIBqacLTO3w8ZESBpp35lISrcocgSyZdFTJsmhpeE7O0nTDbIEV+kHrNiuClw01JncQn96IAZCxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by BN6PR1201MB0211.namprd12.prod.outlook.com (2603:10b6:405:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Wed, 24 Aug
 2022 12:13:31 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%7]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 12:13:31 +0000
Message-ID: <e10b3de6-2df0-1339-4574-8477a924b78e@amd.com>
Date:   Wed, 24 Aug 2022 17:43:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv3 5/8] KVM: SVM: Add VNMI support in inject_nmi
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com
References: <20220810061226.1286-1-santosh.shukla@amd.com>
 <20220810061226.1286-6-santosh.shukla@amd.com>
 <bf9e8a9c-5172-b61a-be6e-87a919442fbd@maciej.szmigiero.name>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <bf9e8a9c-5172-b61a-be6e-87a919442fbd@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0224.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::19) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8afe0860-66de-4809-af2c-08da85ca0ed7
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N7H4Os+EmwpKKHYK2wF7KNV/PsCPSwdXMktBtoqXrG4kU++6bYRVrzVZhDUxhyKsurDMVNiJOwkUxRR82eub+4eJ2lGyUPGHtBRNl84mwVgXAQCqODlEL3VpThRhIebVGW3CBFhqUm+yqmYFU4B9RoUoklxe3mszLFiCtmQqNYaqjbfvTLzcrohogS/Jz0ZqgfY7ZePiz+iuoY+Gp1RLVr1Hm8Lg7JlNCGvc1Vgyec0dhvgl8QowfMY622wXT4TWzkhbmoEp9rFjhaOjtC9cT1yyDUEzjBfpLXEwqMOLhglLZhkYlSTT20JY0/MyXjNWRa/gdYh6LVbAwO8sBtFfjAouI1K8vU9HwfejOgHedHSKdhNlnWhh2jxI3+ePCJzuaML/rvqq0LHUBXpLWEGC2mZkCg53R5V3MkZ0n3ud4JnpXOWnCUE0lipqXRAex9DkGFwSGr6m+4b1FOvUoBGLdJLm71cJkEpp3rcVYFtV4y5TwSLGyNQ5NrM0v3yonUTC9AnP6Lu4TcNxLraucQYgVDURzYvTTMDLZLGM8+eov248f5Xoe3pc3dwBJCmq3hAc61F98Uo3pKNy3iXhLZ6tdvAVPzCv+JfwiJw8iuqju3uXwtLd83Vo4CWE4jydZ8Pl4C1bcHGAGtcs+9NY++TwxqMvjdDu1wHlIsqTO08hzaBb6udNqiwFZWhp5WqqXnvna9LCskbBwkaT2+j311vemGSqimic5JdrihecMXp9flSl8uc19gCVNOGK+tV32Cs9yJJaPoYXR5J1wyZwY04gq2Udga4D3w44uSeCDF8vsic=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(8936002)(110136005)(54906003)(41300700001)(6486002)(36756003)(5660300002)(4326008)(316002)(8676002)(31686004)(66476007)(478600001)(66556008)(66946007)(6666004)(2616005)(53546011)(6512007)(26005)(31696002)(6506007)(86362001)(2906002)(186003)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVFZb3JnMzVPaTNtei9lcFZIQUVXRlhyV2QrSkNzcnF1bDlJQkF5RFpRWnVR?=
 =?utf-8?B?cEVJdUxld0hlWEZKMzlqdU9CM3dzTHhCaXhpK01tdXR2V0hEY0tzQ1Vsd01w?=
 =?utf-8?B?TEdaektrd1ZMODcyeVA0a2R4cDU5ZG41bFdaS3JJcC9ySTJrZTA3Q2RVdDlT?=
 =?utf-8?B?THlRdVR5WHJiOVVZTFcrVjJIUU52N3Z6VUlWTnR1VUtDdVRzYXVnNlJmOUQv?=
 =?utf-8?B?d3NQRlNFVHliYzRzRFVENjg4dFZIL0pQTThNUCtObEtnbldGcWpZZFNidXdx?=
 =?utf-8?B?SE1BeU5XSmFyMUtEN3Y5aXpOQjNvYUlCNXFXU1dodithdzNmNDAwaEEvc01G?=
 =?utf-8?B?OEllQVRrcnd5bW4xREhZVmgrMnk5ZllDSVlCb3V0bFJuWG4xL0drN1ozdXRD?=
 =?utf-8?B?VXZucHFlaFkwWW5MdTlrZ3o4TlNoa3ZhWWVLbk1GOERsMGhsT3NVd2pzeFBk?=
 =?utf-8?B?enZnZXlYN2hnRkEzb1dkL2dzNWNaaGoveGlSUzFkWkVkWXpQU3BFaVR5bllX?=
 =?utf-8?B?N21oNXZ0bzVNQXZQYkJYeHlTR3k3Q2R4aEk0Y0JrVVU0QkVCUldLYjdsdU1P?=
 =?utf-8?B?YWY0S3paVTR4NTRxV0FzVWsvZDM2SGF4VWw4YWoxRGt1S1UzTlgyNEFGUGtP?=
 =?utf-8?B?VjNJem5vT3BHT1ZYUzJLN2pTbDhCTlJmeXB4bWlXeVI3WXloUkNNTWVrUUtM?=
 =?utf-8?B?bjgzU3EzUG5vWEY1dHk3aDY5QVFYNUIxQ3dGcmFPL2xDZEZaNlpYdkFvcDFJ?=
 =?utf-8?B?VTdOMFdsMlNBOVVES0lXbGYwNVRXODU5Z3Iwd2NUc1NIZ1oyS25LSTRXc0tk?=
 =?utf-8?B?eWtkcnpHQzdrZEpnOTFDbGZFZGo4T1dFRUcrSkR4MERSZ3c3akVMb2ZlWUUy?=
 =?utf-8?B?RGUwWEVsNStqSXo2dTkzT01DU2VYT21rQmxmTXJoaFdGS0t4WFlQcDVuMXRo?=
 =?utf-8?B?ZGFpNmhMOEFpZlBxV01uc3dSRXQzeTIxNjZPNnVOSXNLbXdnUlNHQkFaOGoz?=
 =?utf-8?B?MXpKd3pjVThZVElGck0ralUxMWJBdnIrS3Bob2lFKyszMGphRVY1VHZzSDIx?=
 =?utf-8?B?c0lQUzdVSDBIdkFmOVZjUmI3RzJENlg5bGZVd1VDSXUxNWV3MDJ4ZWxrTVBM?=
 =?utf-8?B?b2J3MHk1YVFvOVBTd21zSGdLaGdCWmxiZVVXeHZDQzhTMVg3eE9EdkxHRGIz?=
 =?utf-8?B?NE5mVW9SSEtQV2dUNEVWblpBbUlwKzNRYXNiQisrM0IyQkNXUEVjTm5FKzNB?=
 =?utf-8?B?Vzl1Y3RaWGFyREMvaFYyYWsyRVBuLyt5WEFtUTVnQ1NZWWgrRUUyL1BaeHIy?=
 =?utf-8?B?cm5RekN1bFRURUxabEh2RkJQRzUzL2o1M3ljaFJpeUJSVVlHYjdNYnZTM0Vs?=
 =?utf-8?B?UUIzQlBGUHRDLzkrRk5iM0RpMGNpS2VsY3BvTUdnVm15cVE5bHV3V0xmbjVj?=
 =?utf-8?B?aUZWVVdNdkQzSjhlb1c1YXF0cUZPcnpNWVIvemxsRmZWb01DZ2RJbHFpUHll?=
 =?utf-8?B?NS9ITlhaUzZxRGRIVHBmblo4N0xkRERGWlF5MWd5UE14bktaT01SUVYxSWMz?=
 =?utf-8?B?L3ZHNnFWbjU2Y25qdThuQmFxZmtDYUx2TTduYUFTN1VUUXJ4YUxRRmtua1BU?=
 =?utf-8?B?VXhoenpwU0N2NVBSQlh5aWlMejQ1QWh5MWhjOHZsZ2xubmhRUDIvd2l4R2dD?=
 =?utf-8?B?MU1PTzNjMmYwZHFwWjgvUUowbk4zWUMrZFV1VjllSmN2anZyV3F0TWM3T3Zh?=
 =?utf-8?B?UUUxLzQyRXQ4Q1JiUkt5ZTdRUmtjcTV5MUhDUHZwUXM3ZzNiUzRIbk1ETEY0?=
 =?utf-8?B?LzVJdm9JZkJ3cnNYZW50Vy9uZmMwZUE3aU1RenlPaWQ0STZ5ZXJEdy9ITmRp?=
 =?utf-8?B?MEZkaklubHZzWVBsOHhJWmFHOUNnSmFDK1JjYUpEajlEWDdSM1BDTmZmTzdF?=
 =?utf-8?B?bFo3K1l0RE1HbGNEaEJoSER6OWxlTU5NNFdJMWhWaXE4aGNaQjZNTitlUmx0?=
 =?utf-8?B?ZkEzd2JVZEsvZTJKanJaMGZYVnlDbDZVZlVQRWdXb25xWW9BRFhlT2NZNFN6?=
 =?utf-8?B?ZFAzZXhBa2FSM1pTanF6Mm5uZDJFYjVjekZWQ05PWGRLZEU0Qi9scW4wQmQv?=
 =?utf-8?Q?STsrvHj6wHsZQ8KPbjYQlgZLJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afe0860-66de-4809-af2c-08da85ca0ed7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 12:13:30.8999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIXFln3ZTdM5hW74R7em3aij+VWxQx2aWBAu7ZyAUEnU8IywX0dotnQfh+bEr5Hn+H+xyI9At6qGioyH5m9VBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maciej,

On 8/11/2022 2:54 AM, Maciej S. Szmigiero wrote:
> On 10.08.2022 08:12, Santosh Shukla wrote:
>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>> will clear V_NMI to acknowledge processing has started and will keep the
>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>> v3:
>> - Removed WARN_ON check.
>>
>> v2:
>> - Added WARN_ON check for vnmi pending.
>> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
>>
>>   arch/x86/kvm/svm/svm.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index e260e8cb0c81..8c4098b8a63e 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>>   static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>   {
>>       struct vcpu_svm *svm = to_svm(vcpu);
>> +    struct vmcb *vmcb = NULL;
>>   +    if (is_vnmi_enabled(svm)) {
> 
> I guess this should be "is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2"
> since if nmi_l1_to_l2 is true then the NMI to be injected originally
> comes from L1's VMCB12 EVENTINJ field.
> 

Not sure if I understood the case fully.. so trying to sketch scenario here -
if nmi_l1_to_l2 is true then event is coming from EVTINJ. .which could
be one of following case -
1) L0 (vnmi enabled) and L1 (vnmi disabled)
2) L0 & L1 both vnmi disabled.

In both cases the vnmi check will fail for L1 and execution path
will fall back to default - right?

Thanks,
Santosh

> As you said in the cover letter, this field has different semantics
> than vNMI - specifically, it should allow injecting even if L2 is in
> NMI blocking state (it's then up to L1 to keep track of NMI injectability
> for its L2 guest - so L0 should be transparently injecting it when L1
> wants so).
> 
>> +        vmcb = get_vnmi_vmcb(svm);
>> +        vmcb->control.int_ctl |= V_NMI_PENDING;
>> +        ++vcpu->stat.nmi_injections;
>> +        return;
>> +    }
>>       svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
>>         if (svm->nmi_l1_to_l2)
> 
> Thanks,
> Maciej

