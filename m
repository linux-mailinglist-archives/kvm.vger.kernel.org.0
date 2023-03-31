Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB96D2235
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 16:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjCaOSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 10:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbjCaOSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 10:18:49 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D592D1B376
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 07:18:46 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x3so90129683edb.10
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 07:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680272325;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SKX0xZvJ3KweVndRGbW+19gRbjdiQ083K01tIXxIEx8=;
        b=c2cF+oVD62JdamBW1Qfb/8TYHnZHTp2vqRXddJZMtmOmkaceMpDIHvpQSyFRdGsBnq
         gmccpLlhUF6ZzMWPW+bf9bkWnmgkQ5L51f6YtWBCHnffZ2kRP0XirL7fpqweqkQUg7F3
         MiTv5u/0yMSrHazYmR3dx/1diJDt1X5YBy7bjGJK8YCpFnHG0xmvkRmKcIQgCQgYp6oM
         eojav5+GiVVZycUs1UQyGi8aZ4j1E004inPe+Vtqj9aXVVEQF/zEdAzMP+sk4nAtCmV9
         jcOuVmz9zPYUtj5p/Be7zIYXbrOwxEvNmkYFNLJKw75F/Vr4V0ccDYFXHOdB0sTRXG2/
         iJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680272325;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SKX0xZvJ3KweVndRGbW+19gRbjdiQ083K01tIXxIEx8=;
        b=uBm/j1EKkgAeT+er4/TeNIuMwpA1xwJRKnxRLKqWKBVeeCSt5d1PxrorjysknFzHeS
         29+VVEhkan7P7bWavbRjjRFBpO0aGDiIAKl06bwIzatT6o8sGkyvhNDmbZwECo4pmHe4
         g77PAU6RGQjZq/6VU4DPsym9BNxdpN9PZJPRBsIku/YQpY0h09/u55CtIL/vdFa4TMjn
         NamMu4cK3FOV+jgMsxDUdtOvG5yfIjgWi76TZ4YzOGd/BD3yLYp4UxWb4DwOZkUJl91E
         OMjXhP2rCbgkikAql9Qciy0zOOwFzSUtyim9FKRRJ7Hb1eJzgv/IK0y6hBjF696FekUo
         8yvw==
X-Gm-Message-State: AAQBX9filOG4w3ymNnGZjEqPX+UVNHPu/rr2kvRk+K22LZoPlsRnBgc/
        29++b9NbCTclLVkolb7MwIRwtg==
X-Google-Smtp-Source: AKy350Z6HUPtHiodz8G88aUHL0aKMu/XkGve+8B/Z22AOMQIG8acVKwUSx4LIRmicLi3EcNJ1QkORg==
X-Received: by 2002:a17:907:320c:b0:947:5acb:920c with SMTP id xg12-20020a170907320c00b009475acb920cmr6423507ejb.34.1680272325182;
        Fri, 31 Mar 2023 07:18:45 -0700 (PDT)
Received: from ?IPV6:2003:f6:af1a:5100:d774:c595:6e3b:4e1e? (p200300f6af1a5100d774c5956e3b4e1e.dip0.t-ipconnect.de. [2003:f6:af1a:5100:d774:c595:6e3b:4e1e])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906010b00b0093344ef3764sm1018167eje.57.2023.03.31.07.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 07:18:44 -0700 (PDT)
Message-ID: <1d19de68-a308-c4e4-79ee-e37aee226347@grsecurity.net>
Date:   Fri, 31 Mar 2023 16:18:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
Content-Language: en-US, de-DE
From:   Mathias Krause <minipli@grsecurity.net>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net>
 <677169b4-051f-fcae-756b-9a3e1bb9f8fe@grsecurity.net>
 <ZCXDAiUOnsL3fRBj@google.com> <ZCXyAcTd8NX4Lteq@google.com>
 <9a51bd67-13cf-909a-8740-2a2f08fb42b8@grsecurity.net>
In-Reply-To: <9a51bd67-13cf-909a-8740-2a2f08fb42b8@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.03.23 22:55, Mathias Krause wrote:
> On 30.03.23 22:33, Sean Christopherson wrote:
>> I believe this will remedy the issue.  If it does, I'll post a proper patch
>> (likely won't be until next week).  Compile tested only.
>>
>> ---
>>  arch/x86/kvm/mmu.h     |  8 +++++++-
>>  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++++
>>  2 files changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 89f532516a45..4a303aa735dd 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -113,6 +113,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>>  bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
>>  int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>>  				u64 fault_address, char *insn, int insn_len);
>> +void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu);
>>  
>>  int kvm_mmu_load(struct kvm_vcpu *vcpu);
>>  void kvm_mmu_unload(struct kvm_vcpu *vcpu);
>> @@ -184,8 +185,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>>  	u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
>>  	bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
>>  	int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
>> -	bool fault = (mmu->permissions[index] >> pte_access) & 1;
>>  	u32 errcode = PFERR_PRESENT_MASK;
>> +	bool fault;
>> +
>> +	if (tdp_enabled)
>> +		kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
>> +
>> +	fault = (mmu->permissions[index] >> pte_access) & 1;
>>  
>>  	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
>>  	if (unlikely(mmu->pkru_mask)) {
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 4c874d4ec68f..2a63b5725f36 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -5186,6 +5186,20 @@ static union kvm_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
>>  	return role;
>>  }
>>  
>> +void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>> +{
>> +	const bool cr0_wp = kvm_is_cr0_bit_set(vcpu, X86_CR0_WP);
>> +
>> +	BUILD_BUG_ON((KVM_MMU_CR0_ROLE_BITS & KVM_POSSIBLE_CR0_GUEST_BITS) != X86_CR0_WP);
>> +	BUILD_BUG_ON((KVM_MMU_CR4_ROLE_BITS & KVM_POSSIBLE_CR4_GUEST_BITS));
>> +
>> +	if (is_cr0_wp(mmu) == cr0_wp)
>> +		return;
>> +
>> +	mmu->cpu_role.base.cr0_wp = cr0_wp;
>> +	reset_guest_paging_metadata(vcpu, mmu);
>> +}
>> +
>>  static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>>  {
>>  	/* tdp_root_level is architecture forced level, use it if nonzero */
>>
>> base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393
> 
> I tested a backported version of this patch on v6.1 as that's what I was
> testing with and it worked fine. :)
> 
> I'll do more thorough tests tomorrow and actually on kvm-x86/next's HEAD.

I extended the KUT CR0.WP tests and could confirm that (a) commit
fb509f76acc8 ("KVM: VMX: Make CR0.WP a guest owned bit") without the
above change triggers errors both ways in the emulator (denies access
while it should be allowed when CR0.WP=0; allows access while it should
trigger a page fault when CR0.WP=1) and (b) the above patch fixes these.

The tests are available here:
https://lore.kernel.org/kvm/20230331135709.132713-1-minipli@grsecurity.net/

Thanks,
Mathias
