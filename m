Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A421E5DCA
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 13:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388330AbgE1LEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 07:04:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51445 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388287AbgE1LEE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 07:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590663842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GRy14437cp9ISBnrfn3ilvupk4pbMx6RaKs8fLuEpHw=;
        b=QcsHYAND3p9wFQX3CDpqbc0Zy8I5NDKkmDzC0LMciQxjgTyd2AigNs1IULRIyfDz8ELZ5a
        MFz+N96VJ5TqQnCdsIZOBlqrG2daL+pjsnGY1osKYEso9ZauDgshX9izh+O2cRbjfG2jAx
        iHLPeEF31pyE0sZERUdVpQ6KWRGJ9AY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-FrfeOd5GOOGmj6uI0Gf_1A-1; Thu, 28 May 2020 07:04:00 -0400
X-MC-Unique: FrfeOd5GOOGmj6uI0Gf_1A-1
Received: by mail-ed1-f69.google.com with SMTP id dh6so3571801edb.1
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 04:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GRy14437cp9ISBnrfn3ilvupk4pbMx6RaKs8fLuEpHw=;
        b=iNodniF+5kf+WySLZysNizvR27ofVpN2axKFAg0LrDyXt2BOZ6Kz7emmhREhdayvVn
         F7svM3mTB96bhCN4MSID00AZ9tS08EekPAzExXSLrsv+RA+6UD31ilUZJGLn7tPbGMTn
         nPVR0vO+FbfFPeb9VM5tDumgm+1nu7oMT5U1KLvi8DpwoVfK9yMIt6YqOic1KvAuMOrE
         BASuZ4CsbvrCxVEYQwWaPzWRCLJ9aaX0FFUdTzte1a3aKYO2gTXcQMJkVJWnUxdMYS04
         hps/OdS2c0A6Zggurl3Lw1PfOcqzV0C9s2wcqh2O5M/yx9BFA5mB8Nln0JuXhgzO4IaA
         KASA==
X-Gm-Message-State: AOAM531+md//DVGPXS04k+09WxqWWuWIwdJzMvW5zkErTUMqjeuFh9ly
        1yq9D4maRSAzf1dNg8R72DDoKJ5ly1ex7N1ybV0eExlnkGY8DObEPmzVBik1MpHPvPq53zEZtLl
        YpYZcSKzz8vGP
X-Received: by 2002:a17:906:724f:: with SMTP id n15mr2442442ejk.266.1590663838261;
        Thu, 28 May 2020 04:03:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYjufK12BvJR8qFq0FJAIpZTPeIKs/85s7ALp7zqg/3rTBngQe/zbGulKmNchd11Z7/mf95g==
X-Received: by 2002:a17:906:724f:: with SMTP id n15mr2442419ejk.266.1590663837977;
        Thu, 28 May 2020 04:03:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id 93sm4588248edy.49.2020.05.28.04.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 04:03:57 -0700 (PDT)
Subject: Re: [PATCH v2 10/10] KVM: x86: deprecate KVM_ASYNC_PF_SEND_ALWAYS
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-11-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <551b75f7-b022-313d-fac4-8b3dd83fe76c@redhat.com>
Date:   Thu, 28 May 2020 13:03:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200525144125.143875-11-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/20 16:41, Vitaly Kuznetsov wrote:
> Concerns were expressed around APF events delivery when CPU is not
> in user mode (KVM_ASYNC_PF_SEND_ALWAYS), e.g.
> https://lore.kernel.org/kvm/ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org/
> 
> 'Page ready' events are already free from '#PF abuse' but 'page not ready'
> notifications still go through #PF (to be changed in the future). Make the
> probability of running into issues when APF collides with regular #PF lower
> by deprecating KVM_ASYNC_PF_SEND_ALWAYS. The feature doesn't seem to be
> important enough for any particular workload to notice the difference.

This has been disabled already in guest code, but I don't see a
particular reason to deprecate it in the host too.  Supporting it on the
host is just one line of code; if it's a problem *for the guest*, you
just don't use KVM_ASYNC_PF_SEND_ALWAYS.

Also, note that #VE will always be delivered to the guest even at CPL0;
the decision on whether to do sync or async page fault at CPL0 will move
to the guest, but enabling #VE will probably _require_ the
KVM_ASYNC_PF_SEND_ALWAYS bit to be set (and KVM_ASYNC_PF_DELIVERY_AS_INT
as well).

Thanks,

Paolo

> Suggested-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h      |  1 -
>  arch/x86/include/uapi/asm/kvm_para.h |  2 +-
>  arch/x86/kernel/kvm.c                |  3 ---
>  arch/x86/kvm/x86.c                   | 13 +++++++++----
>  4 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 356c02bfa587..f491214b7667 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -769,7 +769,6 @@ struct kvm_vcpu_arch {
>  		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
>  		u16 vec;
>  		u32 id;
> -		bool send_user_only;
>  		u32 host_apf_flags;
>  		unsigned long nested_apf_token;
>  		bool delivery_as_pf_vmexit;
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 812e9b4c1114..3cae0faac2b8 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -82,7 +82,7 @@ struct kvm_clock_pairing {
>  #define KVM_MAX_MMU_OP_BATCH           32
>  
>  #define KVM_ASYNC_PF_ENABLED			(1 << 0)
> -#define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
> +#define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1) /* deprecated */
>  #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
>  #define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
>  
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 79730eaef1e1..add123302122 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -324,9 +324,6 @@ static void kvm_guest_cpu_init(void)
>  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
>  		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
>  
> -#ifdef CONFIG_PREEMPTION
> -		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
> -#endif
>  		pa |= KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
>  
>  		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cc1bf6cfc5e0..8222133bf5be 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2648,7 +2648,10 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	gpa_t gpa = data & ~0x3f;
>  
> -	/* Bits 4:5 are reserved, Should be zero */
> +	/*
> +	 * Bits 4:5 are reserved and should be zero. Bit 1
> +	 * (KVM_ASYNC_PF_SEND_ALWAYS) was deprecated and is being ignored.
> +	 */
>  	if (data & 0x30)
>  		return 1;
>  
> @@ -2664,7 +2667,6 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  					sizeof(u64)))
>  		return 1;
>  
> -	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
>  	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
>  
>  	kvm_async_pf_wakeup_all(vcpu);
> @@ -10433,8 +10435,11 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
>  		return false;
>  
> -	if (!kvm_pv_async_pf_enabled(vcpu) ||
> -	    (vcpu->arch.apf.send_user_only && kvm_x86_ops.get_cpl(vcpu) == 0))
> +	/*
> +	 * 'Page not present' APF events are only delivered when CPU is in
> +	 * user mode and APF mechanism is enabled.
> +	 */
> +	if (!kvm_pv_async_pf_enabled(vcpu) || kvm_x86_ops.get_cpl(vcpu) == 0)
>  		return false;
>  
>  	return true;
> 

