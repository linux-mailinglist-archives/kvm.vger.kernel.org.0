Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F19969609D
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 11:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjBNKXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 05:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBNKXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 05:23:03 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8009383CE;
        Tue, 14 Feb 2023 02:23:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MapLZFyBKmgBUhpuxInoj1GcvOcTKQaIkta4vxB4xEjsDcXP+GrsR+uVzc1hW+JLlNYwiswC/oy0abHqwz0zVXsZ+kUR3o+nQGSsT6ktzBCuBMxiVGYo65Od8xSSg+3qme2vFt/PTwNbMI1j6H5QzSJuoBP5mcH0JlYvbUqLcSvtUGm6hTbiiLSfKusccM2+4RRw8tslSAPXgew1Qokafe5dR4CZh/gD7T4s+cJJSJ/7U7jrMp1EbGpZRJWLXd2vra4miAXipPMSiKCRF2AmgfTpEghG+O3RS5JRy1/IBG4JTKKbxi7pqcaBGganjqDhOqi/Jv1tu7Br8xtJS1/cUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOp6LBbO5XRXmuNCFmpd/K5GcZ6jTcYCsOHktQAfcAA=;
 b=M7SYOxItxvoJ7XqcZ+/1WzcXyFUgmyrJrZXyJ7nOkaMW81pkNWdxDeJH1BbryBW+ZADZUDRchsFLo/aBlIVc9F0nxk2YuMMa79tqXud87UpgALMGStNciaY37FexPSZHoGDpgMhr1g7xYbbEpU5+lm6afOSURyawHGDQUNPKmq1lkw5vs+FAKVkFTFKvZ1V3Olu9m8IWlrtfkfQiiqIWPEzt8sE3L9SH4wiMjrM3/Zveplbg3fyIsz8tJG1j4gIrpaaC40aiGyK0kB8yQ/BJ39OcZa676/CRt2glDOuWrrVVBqcOvWyjZDBT8ysjkq7QgY3zna3fHs+tSGdHMC8FwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOp6LBbO5XRXmuNCFmpd/K5GcZ6jTcYCsOHktQAfcAA=;
 b=mAfGpK45vTHh4DrrzUCl3Kt/eF3KPxaEHKef1RUYIkXZLeIHlZ/dgZH9sRzfO2Ai2RXaVwV+pXGzHmuSNrkgwFstcygc3DkfE/K3cSjLDIEarG0vwxPVTzV9LAZJgeXdBqVBqPwXVtkK2OJ+BZglh6ICo/eIa0a5gfl8u8rIB2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 10:22:55 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 10:22:54 +0000
Message-ID: <2b5994e2-15ba-dd57-285c-fb33827a5275@amd.com>
Date:   Tue, 14 Feb 2023 15:52:38 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com> <Y9mWFlGdzoa8ZDW7@google.com>
 <a59505b3-5405-0409-bbf1-34466932c2c1@amd.com> <Y+PIdJZtCsGH2Sw3@google.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y+PIdJZtCsGH2Sw3@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0202.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::10) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|BL1PR12MB5080:EE_
X-MS-Office365-Filtering-Correlation-Id: 38a91372-6414-4458-a765-08db0e756f76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RLfIRzqzPkJdc6Y6wsKN8JsZYh1CanCnlLRwOk0l+eo9W6rAjegAvvq+n7doIVm1kVdRCfZ0kJYCmesUsE7L3w87GAyJ4A0qx7OXtG2uCcEID+C27WsuvEm1vJkuEEEPIQaSa3MySoezLgRoks3wVGmoi9aMCtBjV+ggFx82qNrKiFgPU7im+/MZKa5BK/6BW27yy1OLXxaVDCnBY3ug5l5H5Lw2BgIY0oM19VAK8cE1UOUIAcT+spk7E9e8yoweydjvMIgXbSYU/PrBt0TNG/IfGT0NY3WMPN7y2/t5g5z6Vg5sjtfke6joXY2oMg/Nkmtzd9s+nB18jj5mnygcPfQkvWUdMnSYiCQUMVQJ+Ama68e99J2zXZKPY71/+h4F8AzBDLPRYc/YoMqEEVKvm3kILvtdbM2s5Ojz3A+q631zyZw8oVgXNszB3mHld18PeCtfcS6P4B72EH4sCciFSu8cyEztu6LvtO3dqkiO87TCTeK31qLEXssdatFFWWOXpAkPbE6/a0JdW4O0L8q4y7Oe5t1BBda0zZaO75bNKZqT0n6LM9NUPBi4XkPqS9TTlWHj/q1BPjObYtrN4gp8GsDSNfnhDQYiIyqKijpjkz517zZk2mcG5TjHuKo9uPywtiHa/cMK4XjYiP8aDmpaoze6bUaDYAVZA8gbejf+cvLXmoxAuEs+bvQAXOgP8lZgLtSUZ2q7H2UWL06b0OiRzFbDtSe+ZL5fjgUK/qmm8pg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(396003)(39860400002)(346002)(136003)(451199018)(478600001)(2616005)(83380400001)(53546011)(6512007)(6506007)(26005)(6666004)(186003)(2906002)(36756003)(54906003)(316002)(6486002)(966005)(41300700001)(6916009)(44832011)(7416002)(8936002)(5660300002)(66946007)(4326008)(8676002)(66476007)(66556008)(38100700002)(31696002)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVpqTHlFcktlQnZyV2ttS1hLMDhrWUVrUHp2Sk0wNTlqZmJmZ1drdlkrZmRq?=
 =?utf-8?B?MHlYcEFjaVAzKzB3aGFBYWJpNkxRaGU4c1JBN1RJK1o5bVBSZktqYnQ4cWs2?=
 =?utf-8?B?cHVadU1pV1pJK3JXYjBOajk4MkhwVVJPbVBvQWlPU0V2clpsdG8yV1lCMG4v?=
 =?utf-8?B?djR6OG55aDkzRXlBYjk5cWhPZVUrSGhvOVB3U1N6Q3ZCTWoyT3hKRUtrUmg3?=
 =?utf-8?B?YWhubCtFcHFzbWFwQmc2Njg3ZUJFcVFGSUhkcW1jMWNmMi9rb1phT28wWlNZ?=
 =?utf-8?B?c3ZNM25lSVc4RzFrQWtTaEZaUDQrTVdHUlBmb2FhSy9GOWlQbWQ3bEZkWVFl?=
 =?utf-8?B?YUxZOEVYemhDR05ocFJCU0JIVkV6dmdNUDdaQVBsNGQ0aU5qTEtKYVZWa1dB?=
 =?utf-8?B?am1LWW1lYm1HSDNxSDJ5eUlmZ0VGOGkxU2xYT1dLbjQ0eUU4RkhSVlMwdkZp?=
 =?utf-8?B?Rk1GNHJ2ZWN3aC9jMmtMTkh6L3IzaUtXZ3VhN3Fqa001dEducE1mWTVVOUdp?=
 =?utf-8?B?WXdRb2Y0SWFZaGgzZzBVRm1yeFp1dHk0WVZ3Um14L3RHTy84Q05xMjFDM3Uw?=
 =?utf-8?B?c0RGOU82eWw1UFdGRkQ2NkQrSThjUWoyaTBNUUxsc2c1R0JiRXZWOXQxTlUx?=
 =?utf-8?B?eEJwN3BqTWk1YytwS3hjYUI4dTh0TGU1TERuY2hDckJtY2Z1N1dTKzZrU2NQ?=
 =?utf-8?B?KzREMFJPbXp5bXpGNzZnWE1qenUzU0s0TnRTQXFkZ0pSdzFtY3B5VWFkTnhZ?=
 =?utf-8?B?eHNMV3c3M0lwRGpidG9DTDl4b21iK3NHL292UEphS1o4UThaeWVreUl2UlVW?=
 =?utf-8?B?VEhzWW8vVExwSnZVVlVsSklhT2ptSDFGcTdkKzFoa0pPcXlGU0pDdXRoRm1x?=
 =?utf-8?B?aHBWMG1YQ09rRFpoWTRqek1BVXlNcFlUTE1aRS9YM3M5aU92YktrMG15S1Ry?=
 =?utf-8?B?NHM3S1RkeXlua1ZYaWd2WVF0SEZWbG1wQjdFSEhLalJtbHovK2wvbFhRWms3?=
 =?utf-8?B?aWpmL0ptMUZhWjh3aitYaXNSWUdCbXh6aFlOSnZ5MEZhMCtGYWRDVXRIK1dN?=
 =?utf-8?B?YjFxaGUwN2FKSDV2bG54V3AzUk9TU1RDVVlneVNtQ1pWNUh5MVZ5L1pIWVpJ?=
 =?utf-8?B?Q1Njc29YZVV4ZGZaWFI3MS9GeXE2MHh3aXBDVE1BUVFXMXZrcmRUc2l0U1cw?=
 =?utf-8?B?cnlsQXhJUzJFcHZPczdURUNvTEU1TnE2aStWaUFQdmpkNTgvRmZCVEFBUGRN?=
 =?utf-8?B?NFRtMG5WYWdnV2hwQW9ER29nVWtWVTBnM1FkY1FmYUpVZUkzRTZiM0VKaFlu?=
 =?utf-8?B?RGE0dFRzbU1lelhpRlhVblkwVlUrWURtclU1MTZ5ZjQ2eUhEM2cyZzY4MzJq?=
 =?utf-8?B?M2VCMEdSbUtOTFAwc3IxZUhtcDdNVG9zS3BNakRzeEMzOG45ZlVOamJFUXFV?=
 =?utf-8?B?WTRaRmxtdTl5NWxUWGszT21jV0gvL3ZQUWphYzM3OWhDTHkzYyt3Y1pybnR2?=
 =?utf-8?B?SzB2VEs1R3FUblJDWVRHVXJRUGlHczlPZ0hzemFSWmpyYnhiYTREcmNNNW5B?=
 =?utf-8?B?SDFpQ2NUUXJCci83NG4wZk5qTHVrbWpIRzR4NzZndnE0U3A0Rm9pd3pLMTRS?=
 =?utf-8?B?N1ptNEZieGRtekdnelkwOC8waU5YQVJkRGdObndqRmdNWERrb2Zua3dOd3NN?=
 =?utf-8?B?L3E5WStkR0ExbW5uM1E5b041aGdUbjNYaWg1Q3d6OW5xVThHYnNBVGNITXoy?=
 =?utf-8?B?bjE1ak5VQklRdUhGc2NncFlmb1hqTnZqWjNYbnA2aGU4SE96N1lhWGNZRFFr?=
 =?utf-8?B?SmNuWWRVdEx1QWhCME9PWGNNVEdBdDI4Y3BoNGMyZmVGbDllRGt4Q0U4V3JK?=
 =?utf-8?B?aWVkbit4dTBGdWRTYSs4UFRYMVRBWFNFVWJlNXkyaHFnbEEvMWc2L3hXYkl5?=
 =?utf-8?B?NHdLUWM1aHVndnd5WG1uVnc5WW1xZVk1OHpraFY1VG9MTEhjMXpxSzdZSkVq?=
 =?utf-8?B?aEhWUjBWMStySHFGTjVqVXJGL3ZKU3hZOHEyci8yVGdPYmVPaDJ2Qkk2eWdX?=
 =?utf-8?B?dUF0ZE5WOHJRYUNDWDJ4QWw2Ykh1dTBCWWtIRWl1ZWhiWm1jUFk0TG92cGtW?=
 =?utf-8?Q?L18PIv7Q49c8OePehcQZnBJoV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a91372-6414-4458-a765-08db0e756f76
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 10:22:54.8628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nh2Uvu8EvKjp1ZeH/FeupNPo048en5Wrnv/l0jckze5AbovoOZMwjoj2X9qGDtjw5A3INV6SZDUbhiMG+tHSLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/2023 9:36 PM, Sean Christopherson wrote:
> On Wed, Feb 08, 2023, Santosh Shukla wrote:
>> On 2/1/2023 3:58 AM, Sean Christopherson wrote:
>>> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
>>>> @@ -5191,9 +5191,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>>>  
>>>>  	vcpu->arch.nmi_injected = events->nmi.injected;
>>>>  	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
>>>> -		vcpu->arch.nmi_pending = events->nmi.pending;
>>>> +		atomic_add(events->nmi.pending, &vcpu->arch.nmi_queued);
>>>> +
>>>>  	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
>>>>  
>>>> +	process_nmi(vcpu);
>>>
>>> Argh, having two process_nmi() calls is ugly (not blaming your code, it's KVM's
>>> ABI that's ugly).  E.g. if we collapse this down, it becomes:
>>>
>>> 	process_nmi(vcpu);
>>>
>>> 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
>>> 		<blah blah blah>
>>> 	}
>>> 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
>>>
>>> 	process_nmi(vcpu);
>>>
>>> And the second mess is that V_NMI needs to be cleared.
>>>
>>
>> Can you please elaborate on "V_NMI cleared" scenario? Are you mentioning
>> about V_NMI_MASK or svm->nmi_masked?
> 
> V_NMI_MASK.  KVM needs to purge any pending virtual NMIs when userspace sets
> vCPU event state and KVM_VCPUEVENT_VALID_NMI_PENDING is set.
> 

As per the APM: V_NMI_MASK is managed by the processor
"
V_NMI_MASK: Indicates whether virtual NMIs are masked. The processor will set V_NMI_MASK
once it takes the virtual NMI. V_NMI_MASK is cleared when the guest successfully completes an
IRET instruction or #VMEXIT occurs while delivering the virtual NMI
"

In my initial implementation I had changed V_NMI_MASK for the SMM scenario [1],
This is also not required as HW will save the V_NMI/V_NMI_MASK on 
SMM entry and restore them on RSM.

That said the svm_{get,set}_nmi_mask will look something like:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a9e9bfbffd72..08911a33cf1e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3635,13 +3635,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)

 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
 {
-       return to_svm(vcpu)->nmi_masked;
+       struct vcpu_svm *svm = to_svm(vcpu);
+
+       if (is_vnmi_enabled(svm))
+               return svm->vmcb->control.int_ctl & V_NMI_MASK;
+       else
+               return svm->nmi_masked;
 }

 static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 {
        struct vcpu_svm *svm = to_svm(vcpu);

+       if (is_vnmi_enabled(svm))
+               return;
+
        if (masked) {
                svm->nmi_masked = true;
                svm_set_iret_intercept(svm);

is there any inputs on above approach?

[1] https://lore.kernel.org/all/20220810061226.1286-4-santosh.shukla@amd.com/

>>> The first process_nmi() effectively exists to (a) purge nmi_queued and (b) keep
>>> nmi_pending if KVM_VCPUEVENT_VALID_NMI_PENDING is not set.  I think we can just
>>> replace that with an set of nmi_queued, i.e.
>>>
>>> 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
>>> 		vcpu->arch-nmi_pending = 0;	
>>> 		atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
>>> 		process_nmi();
>>>
>> You mean replace above process_nmi() with kvm_make_request(KVM_REQ_NMI, vcpu), right?
>> I'll try with above proposal.
> 
> Yep, if that works.  Actually, that might be a requirement.  There's a
> 
>   static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> 
> lurking below this.  Invoking process_nmi() before NMI blocking is updated could
> result in KVM incorrectly dropping/keeping NMIs.  I don't think it would be a
> problem in practice since KVM save only one NMI, but userspace could stuff NMIs.
> 
> Huh.  The the existing code is buggy.  events->nmi.pending is a u8, and
> arch.nmi_pending is an unsigned int.  KVM doesn't cap the incoming value, so
> userspace could set up to 255 pending NMIs.  The extra weird part is that the extra
> NMIs will get dropped the next time KVM stumbles through process_nmi().
> 
> Amusingly, KVM only saves one pending NMI, i.e. in a true migration scenario KVM
> may drop an NMI.
> 
>   events->nmi.pending = vcpu->arch.nmi_pending != 0;
> 
> The really amusing part is that that code was added by 7460fb4a3400 ("KVM: Fix
> simultaneous NMIs").  The only thing I can figure is that KVM_GET_VCPU_EVENTS was
> somewhat blindly updated without much thought about what should actually happen.
> 
> So, can you slide the below in early in the series?  Then in this series, convert
> to the above suggested flow (zero nmi_pending, stuff nmi_queued) in another patch?
> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 8 Feb 2023 07:44:16 -0800
> Subject: [PATCH] KVM: x86: Save/restore all NMIs when multiple NMIs are
>  pending
> 
> Save all pending NMIs in KVM_GET_VCPU_EVENTS, and queue KVM_REQ_NMI if one
> or more NMIs are pending after KVM_SET_VCPU_EVENTS in order to re-evaluate
> pending NMIs with respect to NMI blocking.
> 
> KVM allows multiple NMIs to be pending in order to faithfully emulate bare
> metal handling of simultaneous NMIs (on bare metal, truly simultaneous
> NMIs are impossible, i.e. one will always arrive first and be consumed).
> Support for simultaneous NMIs botched the save/restore though.  KVM only
> saves one pending NMI, but allows userspace to restore 255 pending NMIs
> as kvm_vcpu_events.nmi.pending is a u8, and KVM's internal state is stored
> in an unsigned int.
> 
> 7460fb4a3400 ("KVM: Fix simultaneous NMIs")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 508074e47bc0..e9339acbf82a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5115,7 +5115,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>  	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>  
>  	events->nmi.injected = vcpu->arch.nmi_injected;
> -	events->nmi.pending = vcpu->arch.nmi_pending != 0;
> +	events->nmi.pending = vcpu->arch.nmi_pending;
>  	events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
>  
>  	/* events->sipi_vector is never valid when reporting to user space */
> @@ -5202,8 +5202,11 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  						events->interrupt.shadow);
>  
>  	vcpu->arch.nmi_injected = events->nmi.injected;
> -	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
> +	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
>  		vcpu->arch.nmi_pending = events->nmi.pending;
> +		if (vcpu->arch.nmi_pending)
> +			kvm_make_request(KVM_REQ_NMI, vcpu);
> +	}
>  	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
>  
>  	if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&
> 

Ok.

On top of the above, I am including your suggested change as below...

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0855599df65..437a6cea3bc7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5201,9 +5201,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,

        vcpu->arch.nmi_injected = events->nmi.injected;
        if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
-               vcpu->arch.nmi_pending = events->nmi.pending;
-               if (vcpu->arch.nmi_pending)
-                       kvm_make_request(KVM_REQ_NMI, vcpu);
+               vcpu->arch.nmi_pending = 0;
+               atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
+               kvm_make_request(KVM_REQ_NMI, vcpu);
        }
        static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);

does that make sense?

> base-commit: 6c77ae716d546d71b21f0c9ee7d405314a3f3f9e

