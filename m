Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A712177ACC
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbgCCPn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:43:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40538 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729751AbgCCPn5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 10:43:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583250236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yAMnWRJ5vnc6TKSkmN2sROwH3cHSL3g+RIjwXJW2VbU=;
        b=MvZ5JgeN4A8UFyeVGzFYOge8afjin5hpU51Ua8TGcGJb90JK6T36rrMrlqkGcvu4ukzquX
        +ZMiiwhaRpOzf6TosWZGyCezTLqG8R8mp+milt6TWZm/zeXaf8wvQvuawLuCqZl58DfKa1
        yW02J5XzZ9qHI53lH0MDmgXwXO0rTrM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-gBHX7-LMPGGHJoAYaWPjjg-1; Tue, 03 Mar 2020 10:43:54 -0500
X-MC-Unique: gBHX7-LMPGGHJoAYaWPjjg-1
Received: by mail-wr1-f71.google.com with SMTP id m13so1402126wrw.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 07:43:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yAMnWRJ5vnc6TKSkmN2sROwH3cHSL3g+RIjwXJW2VbU=;
        b=DNdBPSBu5EIB3wIWnG5wc7svJr88nQO6TEKdb0+7NLQc4Q7CFO+X82JePyRhHkJ0LQ
         o5R+Arj6PhzBg0cdKLtouARye1BMi2ts3HG36OK3c6rLyOspgoK4YjUaHqH5R8uqVcAe
         EhVXm5upwcih5SQOB0XBh8FERW6tZydRdTvgoQqz1qkFVCB39IE9GtXNXAJn9GPa9kKe
         eEcqp5rLn1PWvRo/XZMKy/H6JISLqGjl13ijrK/dNcnsBURsdz+e4dryg/j8owGoIGX3
         DWfChvkdR7iAF9RBvVUNNTijhRnX+3hv+Yi0U4oSks/6/296vYEV1ksKDL27TBEhTHFM
         boZA==
X-Gm-Message-State: ANhLgQ0uSd8xWavzoX6XxytjzLbf/ljNKssarSRJ4XfsR/MxiysZKYT1
        JVCPtbzcbSfLg/68OkapxGIDYuO9gk7rLsW8QvsVolm2naJNHA5EmUsMhJNzkr2w+IpqmNObq+U
        juGe+9MJgHt/9
X-Received: by 2002:a5d:6604:: with SMTP id n4mr5757440wru.136.1583250233022;
        Tue, 03 Mar 2020 07:43:53 -0800 (PST)
X-Google-Smtp-Source: ADFU+vumqsR5rnOG00c9GaGZ2ofh5YCbObsW6EeH/JregSBt8pHYDCYHTiSCjQ5QkNnLlKN2Hw9ffg==
X-Received: by 2002:a5d:6604:: with SMTP id n4mr5757420wru.136.1583250232749;
        Tue, 03 Mar 2020 07:43:52 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j20sm4826677wmj.46.2020.03.03.07.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 07:43:52 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 26/66] KVM: x86: Replace bare "unsigned" with "unsigned int" in cpuid helpers
In-Reply-To: <20200302235709.27467-27-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com> <20200302235709.27467-27-sean.j.christopherson@intel.com>
Date:   Tue, 03 Mar 2020 16:43:51 +0100
Message-ID: <87lfohfnpk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Replace "unsigned" with "unsigned int" to make checkpatch and people
> everywhere a little bit happier, and to avoid propagating the filth when
> future patches add more cpuid helpers that work with unsigned (ints).
>
> No functional change intended.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.h | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 72a79bdfed6b..46b4b61b6cf8 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -63,7 +63,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
>   * and can't be used by KVM to query/control guest capabilities.  And obviously
>   * the leaf being queried must have an entry in the lookup table.
>   */
> -static __always_inline void reverse_cpuid_check(unsigned x86_leaf)
> +static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
>  {
>  	BUILD_BUG_ON(x86_leaf == CPUID_LNX_1);
>  	BUILD_BUG_ON(x86_leaf == CPUID_LNX_2);
> @@ -87,15 +87,16 @@ static __always_inline u32 __feature_bit(int x86_feature)
>  
>  #define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
>  
> -static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
> +static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_feature)
>  {
> -	unsigned x86_leaf = x86_feature / 32;
> +	unsigned int x86_leaf = x86_feature / 32;
>  
>  	reverse_cpuid_check(x86_leaf);
>  	return reverse_cpuid[x86_leaf];
>  }
>  
> -static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
> +static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
> +						     unsigned int x86_feature)
>  {
>  	struct kvm_cpuid_entry2 *entry;
>  	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> @@ -119,7 +120,8 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
>  	}
>  }
>  
> -static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_feature)
> +static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
> +					    unsigned int x86_feature)
>  {
>  	u32 *reg;
>  
> @@ -130,7 +132,8 @@ static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_
>  	return *reg & __feature_bit(x86_feature);
>  }
>  
> -static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x86_feature)
> +static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu,
> +					      unsigned int x86_feature)
>  {
>  	u32 *reg;

I am a little bit happier indeed, thank you! We still have 170+ bare
unsigned-s in arch/x86/kvm but let's at least not add more.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

