Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A6757C7C4
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 11:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiGUJfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 05:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbiGUJfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 05:35:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85E6BA9;
        Thu, 21 Jul 2022 02:35:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjFVvnuKmx0COHyGkzUUrMR2venwU5oA30/uVJW+ONK7zv227FuMt8QHkVbXotRqEhfwFDiiMf7f9gtkvFZQn5072Xez177FKHg2+C+SJc7hwVJ+wmBLaGAzPkFuErKI/uVCDP85UMQOBDAk3XUnq8WuOyqD8agZixvvtaBK8zyZhH8NKGtGKIrc/RaEt+NR+gvY51z26CbKT6qQYUX0Mu7lHSZKioxlzHh4abKLRmQFZ+QmqHXdjViG33p1mmWR1cPAkIyn04ir1NZPNxyCyo25sBXs2ZbxKGRajOco/YjyuzS9Qe1E9L2w5lbPikMCl0GXjaSsO2j8AE94bLweaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MoX5tlLiYBCtFCZFooCYuNsNQrpJXOvHsbdYUsweOQY=;
 b=ZF617IiAd4yVMW1DU68Kn5jMXop09xTOKxC+CewhqX+o6DGnkj27pBnJtyZWxWBK0b27DXGrwQAd/4TJEak+4Kp1DSUtfkREQBryn1vZjcI3EOkRWSkLDdKwnLjW5cZXxklGDTRoLiU1AgeqGo8yTgk60u7cnmgL750IXb2EM2OWF13d4xbp2H01zzIGjmJglotmtBHLMu/0vLoWCXI4XOdXu71Av+N6/tD8ytC+7U84JFI8v0WgFML4IjPv8RDHH8U+rTANP9jFyOxtS6JiAXkZaW6cZf0mWH0HFD5Rz4Ii1NKFenTtr8azlZxOWiIbILJUepopxVo9b3eFPrRsgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoX5tlLiYBCtFCZFooCYuNsNQrpJXOvHsbdYUsweOQY=;
 b=4BpDsuIYGtqcDrFmxfRjao71d/qvHwz/Oie6JMqu9QIFzgMANNMUpDtbRW58XrYAsFf+vPY8KhS/MaJKg5bODGLbw1IkOumaJrx4qYsXGm/fZkjHWBLonC7HciaPrUDmPsC7SSZvErPRQA4iKlJvqRrzhc/4eHDNRwIx1fF6FIA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MN2PR12MB2895.namprd12.prod.outlook.com (2603:10b6:208:102::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 09:35:07 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 09:35:06 +0000
Message-ID: <6a1e7ce4-81af-ffb9-d193-a98375b632fd@amd.com>
Date:   Thu, 21 Jul 2022 15:04:53 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCHv2 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-4-santosh.shukla@amd.com>
 <641b171f53cb6a1e596e9591065a694fd2a59b69.camel@redhat.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <641b171f53cb6a1e596e9591065a694fd2a59b69.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0225.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::20) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57c4e5b6-b91e-4cf3-1d7d-08da6afc4bf6
X-MS-TrafficTypeDiagnostic: MN2PR12MB2895:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SWoO4BS2A2EnciRyNhwJSRuczI00YftZk3Rc1C+uGbAauVmO9B02sHSlQLpiB+GYj+e8gPIgxnVbwIcfxPUhNrD0w71t8mu+3Nzr3RVFb1cJwcnr1gw+owYLBvOAvGoyWJvKDMs8coDub1UaqRDICcbR+8Bg5cO8TEf3SfN1tOrPnpvBhI96IcFmylabEIj2F+TjB3JnQCHVt/S8l7rm1zWVjAOs69q6c/MZaUBI5ZIWWkaw7oDWJUoMMmxWrm+LsKFsNaB1B4/A31WAkJffMiN86i1xsq9fxUW9ofRyMF6LX24zPz22/hanAYDE0XBhj0XA+tlaKANq/TUP6hxTVuVBXNs0QGtmOJxF7D5LlndMzWa/G2m996oS6YyvucdSvpg6PP+8Um9Sv4MXrV/FTaWcDZ8VaE/f50/rb8pzxnoLE58Ymup2RdXvxN++1yt0utkp9/54ulmnA3K8mQ9HAa4SHmQaA6voUkSaWnBLT7ShgsHlWtKY6YeLn/bVcRf+QIuE+pYGF6qAms4hoLVHWeyh2hh0xI+ianxEGnJ4LwW33hCj+bbJZMjMLMxuYuYVhhleO0o3UhBo8DLF810Wdu7YEnD9pfJOnt3ksyGAjL2XhlJaEgEHuciyzF97Q8IMGExxe3UlNIVdVusC8m2zI6UsI5Yt9sTcTz3BA9lJ3994zBhbw8s4pYTXH+Rw95g5ISJo3lEMLotyYdcWBb9X9hdBdeVSBqCafgstJb1USRVQVMkly7qgtrzksCDGB7G9+/t3rZ+jl2PZn1fbJxa5Uv8Br2chrBMw+kUJ1fr96pH8+ZlFDBpmCYgfZs5jGnRGGrJT8i+4p+W5j/n0yIv6oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(31696002)(86362001)(83380400001)(38100700002)(66476007)(8676002)(66556008)(66946007)(316002)(4326008)(54906003)(36756003)(8936002)(6512007)(6506007)(26005)(6666004)(53546011)(2906002)(5660300002)(110136005)(2616005)(41300700001)(186003)(31686004)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vk5hcXdwWDYvWFE3SlRXbFBEaWowVVpWdzRjVG41K3lDUU1hQzB4bmJPcTBm?=
 =?utf-8?B?Q3ZtbXVwWndleTJsVDBCTStPdWVQWW9zVmRrZVhLODVoakFzUjlWaUJCZGoy?=
 =?utf-8?B?SXorTS9ocUxYYkFEaC9wckx5RVc5eFZUWnkwekZ2Tk8ySUN4NDRXa0VWMUR4?=
 =?utf-8?B?bGxubFN0L0dKNVUzMEZVUmFMME1idVBwdkVkUFBrb1VCYldyOWVkSk42bWRQ?=
 =?utf-8?B?Sk5FdENySEk3bnBxVUU1L0R0NDJ0TEtwRHBPUnNRTTZoWVlVZWpUakJnZytO?=
 =?utf-8?B?alJMazJnTFVZRjdWekNRUkVuSDVpL1RYUEN4dnFhOW5IaUlObkFOdEdHalZU?=
 =?utf-8?B?dCtmZ1JqQUsrZTQxTnh0WVVlN3dWSHY5bXpSZjdNRzRha1BPWWppaUNlSTRB?=
 =?utf-8?B?Z1pIZjd2aTRuSjhTWG9GcTFjK3FsU21EUEM2TGhsZlcxMUJNUk1MV2dhNnJF?=
 =?utf-8?B?SUIzcWFtcDNHNzY5NlRabncxMFhZa1VDU2VES09IYlBpWFdQVmdQWXhocVEx?=
 =?utf-8?B?V2Z3S0NhRFRiZVUxNTIzSGJhK0RqckllRWw1TVAwbGd1V3p4elR4RWRNcFA4?=
 =?utf-8?B?SzhTVWhCSm1uU2Q1dUlxYTYzTlAzL3l4VTE3SmJjb1djUythSkRmSFVIVy9X?=
 =?utf-8?B?M2U3dm1LNkoyYjdGMzM2YlozcmxGVmFOVkY0Zlh1YnlKM1pGYkJ5bHp2d0N4?=
 =?utf-8?B?bE1rNWtacm8xV2RXY3Zyc0VzZzY5Y0xkbGRwUjNLdHFhV3lPd3gvZ2JVb1lW?=
 =?utf-8?B?aENaYVBpREEweFFxMHVyalNpMm1ob3k1WlAyUkFndnVjSXdVY3NJUmFCKzFs?=
 =?utf-8?B?N3ZMdk9oQ3RSNjBtcCtrRjVMZm01aHFpSEVSNzc2SXd2allyZDA4dFA2bVha?=
 =?utf-8?B?NnQwd3BpamlnRXlTVDNpQUFPYXluQUMyTVZNY1YrVzlYT3pxTDl4MWw2eEly?=
 =?utf-8?B?VDFIcFgzUWhzdjB0VndrTXJPZjI1VnNqa0grOWZudm4rU29HK2FNa1F4ajNS?=
 =?utf-8?B?SStScnRVdXNtOU1OUGFZVnFrd2RCQ3VpMGlxSkdZZlppamU3ak0xVnlrcGlP?=
 =?utf-8?B?ZmMrZEhrRmpDM1FWTDVnV3FJSUd0MWFKclVBbG1OVVA1SC9oOEF5Q2hNRHF4?=
 =?utf-8?B?QnRnMitlaUZlWjhjS3BuUndRMDM3RDVUVC93RXdrRExoSll0clNDTWpGcHFW?=
 =?utf-8?B?T2FzNE51NzN3aUYwWGE2WFk3SmJ1alhWYkJHVzJTejRZZzBucW1EckVndEVW?=
 =?utf-8?B?QVo4QWM1dkRNVW1VZHpuOU1OeVIyc3dOKzlrMUZRbEtXSCtVWGNzTk9LcUVp?=
 =?utf-8?B?K3B5QmpHMk1WU3NMdFd5QkR0TWhYOWk4YVF4bnlrK09mb3plUklnQUN3SHVk?=
 =?utf-8?B?VlNWb20wVkJMMTlGRmNVSGZlTSt3bDRnaWswQmRxRXNnTElLV3RTM2p2QlFZ?=
 =?utf-8?B?Ukc1VzRSdFBQVklqZmhWKy9GRUx1alRUbnk3ZFI5dFFxSWIyZ0E5cUlPb0VT?=
 =?utf-8?B?NW1CVVQxN2JDZ0U0Umx0cThvMVVSV2FZNkU5Ymtpd0tCWTJwcmZ2LzlsRlVr?=
 =?utf-8?B?RkFCNUJiRUprUkRwYTFtOVBDN2NzWUpHVW52WUpzc05ubVM0dlpBRkdtTkIr?=
 =?utf-8?B?NnJLeVNzdGRobTE1ME4xdW8vRk9zWlcwQXM2U3pUeUxZTzFDU28yNzNwK040?=
 =?utf-8?B?eU9LcllLeVltbDdrbjk3MmtHeEVrQ0NDbVVWTk9ZL3BQV08yVkp4cUtaSkxa?=
 =?utf-8?B?VXZhbDdUcnhYQitabnlySmQySDJSbmx6QmRoQXNtOU1DWkQxcUFOaW1lYTZl?=
 =?utf-8?B?MzE3cjhRWEVnSFEvcGZ4Vm91VHdBSE5SbnE0T2hVQ3ZXMERKZ1BycDhuNHNq?=
 =?utf-8?B?UVAzRXdMQ2MrQ0dHamxSOE5zby9kYk15MW5GN3p6b3NKMFlPVkZQU1dZSkcx?=
 =?utf-8?B?dlZJY2piTEMrWnlTQUVQUld6TlNaU1BNL0R4b0ZYYUhQM0U1UmFCdEpQbXhv?=
 =?utf-8?B?bFQrRFV1NDliNU9Rd0d2TWZFOTRpYzBWaklHU1JHQnMvMkQ4Z2JUaERIZm1M?=
 =?utf-8?B?SFVVNW1vRGcwbWJYd0tMUEk1UVcwVlpVWHlYS0FRY0pKTFpyOW9BblFpeVFv?=
 =?utf-8?Q?FMeKCzVfzc8X5o32bteTubEFY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c4e5b6-b91e-4cf3-1d7d-08da6afc4bf6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 09:35:06.8976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtgnbNOKlvpRra/AcMdcFXFW3UMpdiJR+Pdsd+WSArbbmCBw+GJpD995hYJtlmsBqlxXALDsLpCwkuMvmQJUig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2895
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/10/2022 9:45 PM, Maxim Levitsky wrote:
> On Sat, 2022-07-09 at 19:12 +0530, Santosh Shukla wrote:
>> VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
>> NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
>> read-only in the hypervisor and do not populate set accessors.
>>
>> Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
>> L2.
>>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>> v2:
>> - Added get_vnmi_vmcb API to return vmcb for l1 and l2.
>> - Use get_vnmi_vmcb to get correct vmcb in func -
>>   is_vnmi_enabled/_mask_set()
>> - removed vnmi check from is_vnmi_enabled() func.
>>
>>  arch/x86/kvm/svm/svm.c | 12 ++++++++++--
>>  arch/x86/kvm/svm/svm.h | 32 ++++++++++++++++++++++++++++++++
>>  2 files changed, 42 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index baaf35be36e5..3574e804d757 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -198,7 +198,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
>>  bool intercept_smi = true;
>>  module_param(intercept_smi, bool, 0444);
>>  
>> -static bool vnmi;
>> +bool vnmi = true;
>>  module_param(vnmi, bool, 0444);
>>  
>>  static bool svm_gp_erratum_intercept = true;
>> @@ -3503,13 +3503,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>>  
>>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>>  {
>> -	return !!(vcpu->arch.hflags & HF_NMI_MASK);
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +	if (is_vnmi_enabled(svm))
>> +		return is_vnmi_mask_set(svm);
>> +	else
>> +		return !!(vcpu->arch.hflags & HF_NMI_MASK);
>>  }
>>  
>>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>  
>> +	if (is_vnmi_enabled(svm))
>> +		return;
>> +
>>  	if (masked) {
>>  		vcpu->arch.hflags |= HF_NMI_MASK;
>>  		if (!sev_es_guest(vcpu->kvm))
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 9223ac100ef5..f36e30df6202 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>>  extern bool npt_enabled;
>>  extern int vgif;
>>  extern bool intercept_smi;
>> +extern bool vnmi;
>>  
>>  /*
>>   * Clean bits in VMCB.
>> @@ -509,6 +510,37 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>>  	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
>>  }
>>  
>> +static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
>> +{
>> +	if (!vnmi)
>> +		return NULL;
>> +
>> +	if (is_guest_mode(&svm->vcpu))
>> +		return svm->nested.vmcb02.ptr;
>> +	else
>> +		return svm->vmcb01.ptr;
>> +}
> 
> This is better but still not enough to support nesting:
> 
> 
> Let me explain the cases that we need to cover:
> 
> 
> 1. non nested case, vmcb01 has all the VNMI settings,
> and I think it should work, but need to review the patches again.
> 
> 
> 
> 2. L1 uses vNMI, L2 doesn't use vNMI (nested_vnmi_enabled() == false).
> 
>   In this case, vNMI settings just need to be copied from vmcb01 to vmcb02
>   and vise versa during nested entry and exit.
> 
> 
>   This means that nested_vmcb02_prepare_control in this case should copy
>   all 3 bits from vmcb01 to vmcb02, and vise versa nested_svm_vmexit
>   should copy them back.
> 
>   Currently I see no indication of this being done in this patch series.
> 

Yes, Thanks for pointing out, in v3 series.

>   vmcb02 should indeed be used to read vnmi bits (like done above).
> 
> 
> 3. L1 uses vNMI, L2 uses vNMI:
> 
>   - First of all in this case all 3 vNMI bits should be copied from vmcb12
>     to vmcb02 on nested entry and back on nested VM exit.
> 
>     I *think* this is done correctly in the patch 6, but I need to check again.
> 
>  
>   - Second issue, depends on vNMI spec which we still don't have, and it
>     relates to the fact on what to do if NMIs are not intercepted by
>     the (nested) hypervisor, and L0 wants to inject an NMI
> 
>     (from L1 point of view it means that a 'real' NMI is about to be
>     received while L2 is running).
> 
> 
>     - If VNMI is not allowed to be enabled when NMIs are not intercepted,
>       (vast majority of nested hypervisors will want to intercept real NMIs)
>       then everything is fine -
> 
>       this means that if nested vNMI is enabled, then L1 will have
>       to intercept 'real' NMIs, and thus L0 would be able to always
>       inject 'real' NMIs while L2 is running by doing a VM exit to L1 without
>       touching any vNMI state.
> 
Yes. Enabling NMI virtualization requires the NMI intercept bit to be set.

>     - If the vNMI spec states that if vNMI is enabled, real NMIs
>       are not intercepted and a real NMI is arriving, then the CPU
>       will use vNMI state to handle it (that is it will set the 'pending'
>       bit, then check if 'masked' bit is set, and if not, move pending to masked
>       and deliver NMI to L2, in this case, it is indeed right to use vmcb02
>       and keep on using VNMI for NMIs that are directed to L1,
>       but I highly doubt that this is the case.
> 
> 
No.

>     - Most likely case - vNMI is allowed without NMI intercept,
>       and real NMI does't consult the vNMI bits, but rather uses 'hosts'
>       NMI masking. IRET doesn't affect host's NMI' masking as well.
> 
>

No.

Thanks,
Santosh
 
>       In this case, when L0 wants to inject NMI to a nested guest
>       that has vNMI enabled, and doesn't intercept NMIs, it
>       has to:
> 
>       - still consult the vNMI pending/masked bits of *vmcb01*,
>         to know if it can inject a NMI
> 
>       - if it can inject it, it should update *manually* the pending/masked bits
>         of vmcb01 as well, so that L1's vNMI the state remains consistent.
> 
>       - inject the NMI to L2, in the old fashioned way with EVENTINJ,
> 	or open NMI window by intercepting IRET if NMI is masked.
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> 
> 
>> +
>> +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
>> +{
>> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
>> +
>> +	if (vmcb)
>> +		return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
>> +	else
>> +		return false;
>> +}
>> +
>> +static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
>> +{
>> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
>> +
>> +	if (vmcb)
>> +		return !!(vmcb->control.int_ctl & V_NMI_MASK);
>> +	else
>> +		return false;
>> +}
>> +
>>  /* svm.c */
>>  #define MSR_INVALID				0xffffffffU
>>  
> 
> 
