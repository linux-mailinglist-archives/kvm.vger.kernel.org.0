Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6417888E0
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243456AbjHYNpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239827AbjHYNpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:45:00 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524561FDE;
        Fri, 25 Aug 2023 06:44:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXbf3a644kmWPYKEC/Qc8pbknb+yFBRTOhicL2Vn9pcHBLKjF+mTbC12RyvUV2nGxXKlAKGZ6VU4dSfaXYiXwLxxWg1Xs9U1Z+IHsquJ5XwjDDJsnrL1R/G5A5/o1n8vcOpn3KNpYpeajvgo1byk68//s63waICVgw1mnEtF5UbvaQz1bTY/bqtnWZo+oTAArU0D1vAFRjJkHW5dqqsaPMmKe8qvckwpvAtnwJVive0tjBHplNd3rtyUzFtG4AEHKWxX52F1Ms2SDnm+yH87fd9fM9r4KXMQugWhI9svxrF/bc/+HM5Sk60VntsPqXqgFEPJpSko9gl689EOAajU1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNvi0zsJxcBO2i2CK7g1na2298Ec3a5O9OmvrIhEhJU=;
 b=NUg2Twbx9SghcQ8aXrqztSqLDoSoMBMbkP1J/7sFH94k2lEUE4dCoEmVOCt7HzBxw0LZDDtS4JJj44MoNjiAq+AC1Z/6zVFUGdhZ6zd8++MKHA0v7+4YuTW4t7iZ7OZEeaoKcEkqBoo1wZeYBwaXRJqw2M0M5udp+5vyzTrRzXnuMmZEpy5E97ThcBAZQLNei/w36dP4jZ66xP2Lirncocj3KFnRLOfa6UjSbnzN3lmaQLHY/uWv50mXYEFDgRLQaby2oj034UquET2/sOmxGMV+31QC7UkA3IOxpzOfYUz1yWiOzHCfHLaXefdYWNV2raJA4YdDRCNZE9lZpnV1OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNvi0zsJxcBO2i2CK7g1na2298Ec3a5O9OmvrIhEhJU=;
 b=WWIwV6SkJn3pQcLTRzMihR57jeK1ZR4ItwXk/ZRoNiwdwVecXN9LK5l4Thh8FRVOhDHFZ6UmbAvRiLTNobRp2h66Iym/9onr9Jm3d8fAzVTkoIVJy/W6PcpeDVwDC35hqg6nSahvFHtDEcNqvpXWiAhqUSn7/4NJQ6HeAtTr+Aw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 13:43:54 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 13:43:54 +0000
Message-ID: <9dddb2ef-e021-087d-f0ea-9e0e3d8843b9@amd.com>
Date:   Fri, 25 Aug 2023 08:43:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 4/4] KVM: SVM: Treat all "skip" emulation for SEV
 guests as outright failures
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
References: <20230825013621.2845700-1-seanjc@google.com>
 <20230825013621.2845700-5-seanjc@google.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230825013621.2845700-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::10) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: 55eda339-747d-42c9-62b7-08dba57152af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yOJBlxgwrCWVJa542xxp6wiT4Hvv+fTUvcAus8Nu1aH13ZsFWWElAK67TSeFhhkf4YeRJAFqH32sxBX0w4NCMA3xdEse60c6H30SdLVlDUc2yaOtzsuHcbEAvYUrRj3NymK9zV2u5ySCfAezgQTEsFcnpT5YbfUHEdnWpMWDkXHwmb0mACvA53Rx+e/17Q33TVAAe8u0x/Plw6eae6qYsJwkPHckHbLX3ZCKQNQB/OFigOQYuaRD1/1NzSxb9n0OrwVWvZvhs+MaPGx8dSplcWbBPGhbQP0cTsLoAOAduutWgtQZHH2wK59pbUqRDvCs9AYfMTz2iZus8o64BBYlk9+NR5WBmkIb8ZmuhAEfVPijft0GTNlibriPgNxoPKKWCb13Rvbsd4yvFlu8K4Yz9xrwYZ7hZQq1yARYXCm2ZSYqBNGitspLh++rMptKQUdlSzAPxEGqNSwHj7l72rUl92oE6SJJyzX75SQ/kQXgrbRMA1MJzlP5kZ/8XWLdDXzMWaMZEjsDNRxa8FYgFBwSYQ92IgWQGcWFUBYAdRaBPijTlv0B21pkh/849aYQJLzlkZBrbHcQ0rE+9nGHooYER7kdrVqL3yMgNeLHS6aORuUEKitho8g+WezeTuaIapS12HoJK5ggdJNt1wC4uSxH9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(346002)(136003)(396003)(186009)(451199024)(1800799009)(66476007)(66946007)(66556008)(316002)(478600001)(110136005)(26005)(38100700002)(6666004)(41300700001)(53546011)(6506007)(6486002)(31696002)(86362001)(2906002)(6512007)(31686004)(83380400001)(8676002)(8936002)(2616005)(4326008)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXNJZlpjN0ZvN0ZnaXFwdEFZeWZFY1FTcnRWNC9BQy9iSlkyeGVmblhiMXdR?=
 =?utf-8?B?eWQ0Z056cGJVOVY0NDZFcUpVRmFlNlBYY1JtdmJWdG1OKzEyNCtFQlRsYVJV?=
 =?utf-8?B?elk4aWtaOGxBNzFVZGZmaXR0TVhhL2lUMmdJcFBtS0VwcDdhQ2Z2TitrZWVt?=
 =?utf-8?B?NUpTakVmTUp3NUYvY1VtQ0w3cXFpWnJ3blF4elNGOEpoZnVNa0JpYXgrclVQ?=
 =?utf-8?B?Y2wxdmxHRWl1NXU5UEgrait2OU50TXFmS296SjJpZG1XeTFyLzRsN2U4dTM5?=
 =?utf-8?B?THNqRlNuNzNCY2RKSVVlbzc4RHZHNzVrY2x3RHh0V2FOREVpdUNyU0lTZlR2?=
 =?utf-8?B?MGNHQldiOHRuVGRTZkdnbmV1UEJpYTREUVhsR1NmRC9EeFk3Y2hnVEt6aXEv?=
 =?utf-8?B?RnlSb3dsQzU3VGxCYnl2b0FSeHQ1eGVscWorc1hsVFRNemJGS0FvTTdJS1ho?=
 =?utf-8?B?K0U2NFJkV1RNU2QwdnQ0cEduamZ3ZmJQWk9NalpDbFJjNTZFMm4vWGJKMnFX?=
 =?utf-8?B?UFFSWmVTT1pyTU1VTFc0Y08rWDFEbGdDRktxZys2S24xZHVoQk5hMllpWlRo?=
 =?utf-8?B?TzhSZEJLUkwrV1Joc2lHdEQ4ZzMxVHZqNk5iWmRWY0FHN2doSUczOXcyT3BL?=
 =?utf-8?B?a1V4dCtPcFJiVTBvL01IUWwveEJuSGJ1UVlZamxwSzl6emI4cnNBZG5jVEs1?=
 =?utf-8?B?WmRJaGRtWWhKTEM1ZzA1cWxxMEFxekthR2tIakNMSElVd1JyaTNMZUJ5emQw?=
 =?utf-8?B?Q0RtUTAvV3pBZnVMMzlXUHIxczNwZHRqMUNUR25xNHJHOGhtdHQwRkFZY0Mr?=
 =?utf-8?B?NHlIeTBCMUdxeitqVXhPVFFUZ242ZU9JaDdzZEpFU09hRFhkV0Mybk8zMkpm?=
 =?utf-8?B?MlYrWmppSFloakc1bXFlbTY2anFIOXo3NEpnQjR5WkpNVDFzb0xxQVZ4NVV3?=
 =?utf-8?B?ZTE2MTNCaEI4QmN2bTNUd2JKczB4MVBoSGdmZ0Y2dDV2YU9VTmgxaFBVKytE?=
 =?utf-8?B?azVTLzdhTFg2eGZwalJ1ZUU0ZmlFcXhiUzdvTGt6YWlGajNCZ1dWaW1EWmJX?=
 =?utf-8?B?c1dIaG1TckdDUktLeDczUlBjNVRSdFJCMk1JYW55UG1kUFdwMXN3aG1WSzg3?=
 =?utf-8?B?NUZBNVRjOTRSWVJ5YU5LTUsyQmRHM3JRVHJ5THhqQ0o5a3ZSK1JjUWdPUzNT?=
 =?utf-8?B?M01Sb3NSamJna2NNcGFyNjVnR05HcFlBVk94Ni9NanAvTkNmWDlCK09BUWJ4?=
 =?utf-8?B?c3VpRW00TzUwdDBDTUJoQWpsS1Qva3ZtQ1ZwNE5PVUo5QlRlZ2VuR3luQzVB?=
 =?utf-8?B?Um1qaHByOHhsd0RUK0FwSkZZaThMZXlCM2s1ZUZxVGszOWo1eHZRQnhTb21Q?=
 =?utf-8?B?RFVzdys3ZXhnZVdtTWxDanNUKzBHek9GSWFJWTVXNEVReHhKaXhKMm5WR2Fm?=
 =?utf-8?B?TWMxOWxMdkJUbUZmL0hBOFE2TGxoQkx3UXBuZkpKT3pwdHdMaCtESUdDSFhF?=
 =?utf-8?B?dlI2MEp2TlU5UHA5eVB2Nk9Od0xrTnlsV2lzSCt2UDlKS1A2L1YyQ0J1SFZv?=
 =?utf-8?B?MTdlOHpnb0xBV3FrSjVMajFXQkFQRkovU3lFVDgzbXNTSDJ1LzRXd3MyMG95?=
 =?utf-8?B?dlVpeDBBNG1YVU9CN0x2WmE5ZDZhYnpvbVdTRHRyQ25seDZBbFp0aXZNWG5K?=
 =?utf-8?B?V3BLOWxuL2ZWWjlVSzlqSGFjT3ZOUGtjWjlTQ3J5VmV6b05aQ0k0S0lxS0lF?=
 =?utf-8?B?Umw1Wi9VOCt5NzRCdWdGNzF0YVF4Qmd6NWV2VE9OSW5LSUl0WDVQRkNpTlFH?=
 =?utf-8?B?bnhjaEVRQXpGdEk1L2Q1N2ZUVlNBMS9lOW8zV29vNWdlYjc5L0NiVy9WazJE?=
 =?utf-8?B?NDhjc1R2MkltaEk5T0dDd1dnaWYzTGhvWDFQZ2pmOXgwVytmVDRUbWFicjh2?=
 =?utf-8?B?MmhoUnBUdCtXZDJZT0syd1lCRlYxY1E3WTJRYkJvUUU2eG5CMmsrekZ4OWMz?=
 =?utf-8?B?V0p3UktFUzFmb2h4b3lHRFJXeE1MY3RNck01dHdtbmVXOTdyYURTOWJ1S2JS?=
 =?utf-8?B?WjRnTzlJT2M5UUFDVTlzeG9BTW1NVTBWQk45V0prYTFGeERZZE5mUWFEbDlQ?=
 =?utf-8?Q?flQ/btbrzCCt6XB2IvYMjHeHP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55eda339-747d-42c9-62b7-08dba57152af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 13:43:54.1242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3I4MEY6xwlTV/YJB0Sr2iq+XFtWqukA40LV3lQJqIEjvmr5iPjCCigAFRuEZs1daxywn73n6TxJoUPCrzyt/ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/23 20:36, Sean Christopherson wrote:
> Treat EMULTYPE_SKIP failures on SEV guests as unhandleable emulation
> instead of simply resuming the guest, and drop the hack-a-fix which
> effects that behavior for the INT3/INTO injection path.  If KVM can't
> skip an instruction for which KVM has already done partial emulation,
> resuming the guest is undesirable as doing so may corrupt guest state.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 12 +-----------
>   arch/x86/kvm/x86.c     |  9 +++++++--
>   2 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 39ce680013c4..fc2cd5585349 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -364,8 +364,6 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
>   		svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
>   
>   }
> -static int svm_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
> -					 void *insn, int insn_len);
>   
>   static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
>   					   bool commit_side_effects)
> @@ -386,14 +384,6 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
>   	}
>   
>   	if (!svm->next_rip) {
> -		/*
> -		 * FIXME: Drop this when kvm_emulate_instruction() does the
> -		 * right thing and treats "can't emulate" as outright failure
> -		 * for EMULTYPE_SKIP.
> -		 */
> -		if (svm_check_emulate_instruction(vcpu, EMULTYPE_SKIP, NULL, 0) != X86EMUL_CONTINUE)
> -			return 0;
> -
>   		if (unlikely(!commit_side_effects))
>   			old_rflags = svm->vmcb->save.rflags;
>   
> @@ -4752,7 +4742,7 @@ static int svm_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>   	 */
>   	if (unlikely(!insn)) {
>   		if (emul_type & EMULTYPE_SKIP)
> -			return X86EMUL_RETRY_INSTR;
> +			return X86EMUL_UNHANDLEABLE;

Trying to follow this, bear with me...

This results in an "emulation failure" which fills out all the KVM 
userspace exit information in prepare_emulation_failure_exit(). But 
because of the return 0 in handle_emulation_failure(), in the end this 
ends up just acting like the first patch because we exit out 
svm_update_soft_interrupt_rip() early and the instruction just gets retried?

Thanks,
Tom

>   
>   		kvm_queue_exception(vcpu, UD_VECTOR);
>   		return X86EMUL_PROPAGATE_FAULT;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f897d582d560..1f4a8fbc5390 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8858,8 +8858,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   	bool writeback = true;
>   
>   	r = kvm_check_emulate_insn(vcpu, emulation_type, insn, insn_len);
> -	if (r != X86EMUL_CONTINUE)
> -		return 1;
> +	if (r != X86EMUL_CONTINUE) {
> +		if (r == X86EMUL_RETRY_INSTR || r == X86EMUL_PROPAGATE_FAULT)
> +			return 1;
> +
> +		WARN_ON_ONCE(r != X86EMUL_UNHANDLEABLE);
> +		return handle_emulation_failure(vcpu, emulation_type);
> +	}
>   
>   	vcpu->arch.l1tf_flush_l1d = true;
>   
