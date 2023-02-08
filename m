Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057AD68EAB4
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 10:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjBHJNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 04:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjBHJMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 04:12:49 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288BA3B0FC
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 01:11:57 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ml19so49728802ejb.0
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 01:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+A8183XUA8PZFOwimwpnD2XLFUcEiRzbVAWXofVMp1E=;
        b=liiW805wnW4yLww0NGNCQksQg9c0MjuIun+utxlq6Bg9U8nndQRxxuyomVRWthdvjP
         PgiEBxUkbTg1vytRY0lJqMgjN4tRZA1MEWW7MVK3Yw7yyuwWT+q0IkP3mbvP9rodmyAz
         +fWY5dioBIkG2qxN2ApJ/W7qgyiaafsWvWXdgbmRHDQ9ahKXwcVSK1fVWR2R2uuzHu+y
         2fVjUgO3QXgy1Kj75Dy15pjlHc3ATN+C5TlG8s6FboiuZESQYLePw3Xom7LDq/vJdiAP
         cfuHqGfoyGufoOtS7uzqjNB4U1MNx6z+R4V2XqYot9Wm7HNibJ3MOmk0wAJxDdDgRt7M
         DutA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+A8183XUA8PZFOwimwpnD2XLFUcEiRzbVAWXofVMp1E=;
        b=Zg2KBJAoUwmGeHaffxMibIQBKBGby6DiTENH7SvLraWXMWN4g9NHGEX5Acs0OGF9WA
         rcKAPB5TSKx+JOtDa/D7Yt1BDRK0XIKe1HMn13KrTZhfZZKgGfKsI7cibdOqd4uA10hK
         qkdnI1BZTvS4NvOIvxb0cCKmnt+KCI15jzi6BaoR3OV+81bjZbHkmxWhXe7ZOwzSWPs+
         lRYaItnhGDfNgSC3Nzs+gn2Dd0vEhtS/ljoUgyPOlOhptnvcitq3pN07DLIxySffZSUJ
         3QVCqn9ybmgTXOuOKD5tGekSmgxy3WUBOac+SYuLspelgFDyakuJ4CehCXjx7GBlF1tS
         1mow==
X-Gm-Message-State: AO0yUKW4sDeCyU4dBbeSlWFkcx3DLLPyrFdPmcpjMMppBu+TuyOHwLHd
        ZJ5gGZfUiQ5jqAMbkDWG8rydqA==
X-Google-Smtp-Source: AK7set+jq2sq1D4uDVEB6rKIf3ExMrO7TAqoPlYPkYrPvv1pCZAiKVSoW+WIjkh2BsttZaFO30WG5A==
X-Received: by 2002:a17:906:6a1b:b0:8af:b63:b4bf with SMTP id qw27-20020a1709066a1b00b008af0b63b4bfmr76463ejc.27.1675847491984;
        Wed, 08 Feb 2023 01:11:31 -0800 (PST)
Received: from ?IPV6:2003:f6:af31:7800:129e:49db:f7a0:83dc? (p200300f6af317800129e49dbf7a083dc.dip0.t-ipconnect.de. [2003:f6:af31:7800:129e:49db:f7a0:83dc])
        by smtp.gmail.com with ESMTPSA id cd11-20020a170906b34b00b008720c458bd4sm7997913ejb.3.2023.02.08.01.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 01:11:31 -0800 (PST)
Message-ID: <4b4f845e-b92e-778c-db69-4d6fa9d64811@grsecurity.net>
Date:   Wed, 8 Feb 2023 10:11:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 4/6] KVM: x86: Make use of kvm_read_cr*_bits() when
 testing bits
Content-Language: en-US, de-DE
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230201194604.11135-1-minipli@grsecurity.net>
 <20230201194604.11135-5-minipli@grsecurity.net>
 <20230207150535.00004453@gmail.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230207150535.00004453@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.02.23 14:05, Zhi Wang wrote:
> On Wed,  1 Feb 2023 20:46:02 +0100
> Mathias Krause <minipli@grsecurity.net> wrote:
> 
>> Make use of the kvm_read_cr{0,4}_bits() helper functions when we only
>> want to know the state of certain bits instead of the whole register.
>>
>> This not only makes the intend cleaner, it also avoids a VMREAD in case
                           ~~~~~~
Oh, this should have been "intent". Will fix in v4, if there's a need for.

>> the tested bits aren't guest owned.
>                     ^
> The patch comment is a little confusing. Not sure if I misunderstood here:

Sorry, lets try to clarify.

> Check the code of kvm_read_cr0_bits
> 
> static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
> {
>         ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
>         if ((tmask & vcpu->arch.cr0_guest_owned_bits) &&
>             !kvm_register_is_available(vcpu, VCPU_EXREG_CR0))
>                 static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR0);
>         return vcpu->arch.cr0 & mask;
> }
> 
> I suppose the conditions that can avoids a VMREAD is to avoid the vmread in
> static_call(kvm_x86_cache_reg):

Correct, that's what this patch is trying to do: It tries to avoid the
static_call(kvm_x86_cache_reg)(...) by making the compiler aware of the
actually used bits in 'mask'. If those don't intersect with the guest
owned bits, the first part of the condition wont be true and we simply
can make use of 'vcpu->arch.cr0'.

Maybe it gets clearer when looking at kvm_read_cr0() too which is just this:

static inline ulong kvm_read_cr0(struct kvm_vcpu *vcpu)
{
    return kvm_read_cr0_bits(vcpu, ~0UL);
}

So the 'mask' passed to kvm_read_cr0_bits() will always include all
(possible) guest owned bits (KVM_POSSIBLE_CR0_GUEST_BITS & ~0UL ==
KVM_POSSIBLE_CR0_GUEST_BITS) and the compiler cannot do the optimization
mentioned above.

If we, however, use kvm_read_cr0_bits(..., MASK) directly instead of
using kvm_read_cr0() & MASK, it can, like for all bits not in
KVM_POSSIBLE_CR0_GUEST_BITS & vcpu->arch.cr0_guest_owned_bits.

> Conditions are not triggering vmread:
> 
> 1) The test bits are guest_owned_bits and cache register is available.
> 2) The test bits are *not* guest_owned bits.

For case 1 the patch would make only a minor difference, by concluding
earlier that it can simply make use of vcpu->arch.cr0. But it's case 2
I'm after.

If you look up KVM_POSSIBLE_CR0_GUEST_BITS, which is the upper bound for
guest owned CR0 bits, you'll find before patch 6:

#define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS

and after patch 6:

#define KVM_LAZY_CR0_GUEST_BITS     X86_CR0_WP
#define KVM_POSSIBLE_CR0_GUEST_BITS (X86_CR0_TS|KVM_LAZY_CR0_GUEST_BITS)

So the upper bound would be 'X86_CR0_TS|X86_CR0_WP'. Every bit outside
that set can directly be read from the 'vcpu' cached register value and
that's (mostly) the case for the users this patch is changing, see below.

> I agree that this makes the intend cleaner, but not sure the later statement
> is true in the patch comment. If the test bits are not guest owned, it will
> not reach static_call(kvm_x86_cache_reg).

Correct, but that's no different from what I'm saying. My description
just set 'static_call(kvm_x86_cache_reg)' mentally equivalent to VMREAD,
which abstracts the static_call quite well, IMHO. But maybe I should
clarify that 'tested bits' means the bits used by the changed call side?
Though, I think that's rather obvious from the change itself. I can
factor in the caching aspect, though.

Maybe something like this?:

    This not only makes the intent cleaner, it also avoids a potential
    VMREAD in case the tested bits aren't guest owned.

I've added "potential" but left the remainder as is.

>>
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>>  arch/x86/kvm/pmu.c     | 4 ++--
>>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index d939d3b84e6f..d9922277df67 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -439,9 +439,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>>  	if (!pmc)
>>  		return 1;
>>  
>> -	if (!(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
>> +	if (!(kvm_read_cr4_bits(vcpu, X86_CR4_PCE)) &&

X86_CR4_PCE & KVM_POSSIBLE_CR4_GUEST_BITS == X86_CR4_PCE, therefore can
only be optimized if X86_CR4_PCE would be dropped from
'vcpu->arch.cr4_guest_owned_bits' as well. But AFAICS we don't do that.
So here you're right that this only clears up the intent, not the actual
behavior at runtime.

>>  	    (static_call(kvm_x86_get_cpl)(vcpu) != 0) &&
>> -	    (kvm_read_cr0(vcpu) & X86_CR0_PE))
>> +	    (kvm_read_cr0_bits(vcpu, X86_CR0_PE)))

X86_CR0_PE & KVM_POSSIBLE_CR0_GUEST_BITS == 0, therefore this can be
optimized.

>>  		return 1;
>>  
>>  	*data = pmc_read_counter(pmc) & mask;
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c8198c8a9b55..d3b49e0b6c32 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5487,7 +5487,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
>>  		break;
>>  	case 3: /* lmsw */
>>  		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
>> -		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
>> +		trace_kvm_cr_write(0, (kvm_read_cr0_bits(vcpu, ~0xful) | val));

~0xful & KVM_POSSIBLE_CR0_GUEST_BITS is 0 prior to patch 6 and
X86_CR0_WP afterwards, therefore this might be optimized, depending on
the runtime setting of 'enable_lazy_cr0', possibly capping the guest
owned CR0 bits to exclude X86_CR0_WP again.

>>  		kvm_lmsw(vcpu, val);
>>  
>>  		return kvm_skip_emulated_instruction(vcpu);
>> @@ -7547,7 +7547,7 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>>  	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
>>  		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>>  
>> -	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
>> +	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {

X86_CR0_CD & KVM_POSSIBLE_CR0_GUEST_BITS == 0, therefore this can be
optimized as well.

>>  		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>>  			cache = MTRR_TYPE_WRBACK;
>>  		else
> 

Thanks,
Mathias
