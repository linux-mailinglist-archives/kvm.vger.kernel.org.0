Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C211502B7A
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354273AbiDOOKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354266AbiDOOJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:09:59 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FFFC0566;
        Fri, 15 Apr 2022 07:07:31 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b19so10763137wrh.11;
        Fri, 15 Apr 2022 07:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IHPs//C0shonchMCxgLiEnaw6JPTZ4t8j0LIPcOqzO0=;
        b=KjSgNHZk3aMchIG8k0JgH6Zo74CGstkV+S8K2GceIDd2lepHVPJpFFH2HU2DamdTOR
         HHEkcEu1o5I23HdlqRXMdBb7lSnYIMX1Ja3dhT5Dw0Wqe6JkARhcZMeCzGEujHr+NtAH
         Yf6L0Ea3/dkeh3JWo9qMAscjb9ncspAOMKLg9oIZZZSObWHeXEjejZkzvwoSzY32zo90
         ffUBQClQTztHIE7v+PuafYGtfi/b3YmbtiPdg8Si3N3zbHcs//VUc27TNYH7vVNrgcpK
         V0Fj7YF9DxBB2bdXa1/Ue6f2L4I7DmV2Ku016ENU8YgVr6orz4gUqSGx6rPwqDG739yl
         U7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IHPs//C0shonchMCxgLiEnaw6JPTZ4t8j0LIPcOqzO0=;
        b=A5E9NdjmuBBfS/Yx7Qo6dfHjn/zj6H5WcqU+wy9NZWVW9Xdnz3eurETgoXTS3j9e3p
         jHLzkuOE/xAjughVkDNbX1aPCYrGPz1oLFOj8niU+LparPLEvGUJ3sbRSeeKRo1WLPtw
         UEjlhHuIJiOud4Hc2AaQ0R1xkowheAQOQkj/AYGUowZPtcT9lqDOl9fQgbC/3H3yIt5I
         6pjHdP3Wh0KghCxTQfZW7JihLYpYQJQBDVQjdv6tUbn1KH0sHIxULWuzquF/XYj8XW3W
         EJrXeudLop/8EftlJyE1qjcbYqtmNk4dpSaUCTOw0a+ci/UcvhyEdcdr2ba6e3/KryLv
         U51w==
X-Gm-Message-State: AOAM532SLWg75T7bcs0oO9ynzkwUGQUxllpjQgTLFxP1Pv2YT0hTLnFS
        HUIg9umBGbYJXVwhaHsi89k=
X-Google-Smtp-Source: ABdhPJzJyvw9HvlbuXBg0TeLdFpC1BTOp+XWq05ADo2EUeZ6Mdcd7QS7qWrIm5og/sJkMqdS/nienA==
X-Received: by 2002:adf:b51a:0:b0:20a:8180:532c with SMTP id a26-20020adfb51a000000b0020a8180532cmr1116524wrd.660.1650031649963;
        Fri, 15 Apr 2022 07:07:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id l6-20020a1c2506000000b0038e6fe8e8d8sm6114568wml.5.2022.04.15.07.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:07:29 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8bab46e6-f7d3-17a7-40cd-7a5dfabc61c0@redhat.com>
Date:   Fri, 15 Apr 2022 16:07:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 070/104] KVM: TDX: complete interrupts after tdexit
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <45507ecee0a0d23229e9e7f8bb74077034a40bcd.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <45507ecee0a0d23229e9e7f8bb74077034a40bcd.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This corresponds to VMX __vmx_complete_interrupts().  Because TDX
> virtualize vAPIC, KVM only needs to care NMI injection.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c1366aac7d96..3cb2fbd1c12c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -550,6 +550,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	vcpu->kvm->vm_bugged = true;
>   }
>   
> +static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
> +{
> +	/* Avoid costly SEAMCALL if no nmi was injected */
> +	if (vcpu->arch.nmi_injected)
> +		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
> +							      TD_VCPU_PEND_NMI);
> +}
> +
>   struct tdx_uret_msr {
>   	u32 msr;
>   	unsigned int slot;
> @@ -618,6 +626,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>   
> +	tdx_complete_interrupts(vcpu);
> +
>   	if (tdx->exit_reason.error || tdx->exit_reason.non_recoverable)
>   		return EXIT_FASTPATH_NONE;
>   	return EXIT_FASTPATH_NONE;

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
