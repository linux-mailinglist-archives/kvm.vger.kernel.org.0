Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF30502C25
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354691AbiDOOvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347186AbiDOOvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:51:36 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB64114;
        Fri, 15 Apr 2022 07:49:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so5167754wmn.1;
        Fri, 15 Apr 2022 07:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hb07vEgf4l07RAm1DJJM+HsIb4pT8MG1CaZsYZrDsSA=;
        b=nIzYN3sOQLvYBDmplKeZG6lOQPg75cSPccmQvqPC0Lj0AkAfw3HRh2XaetblQGeT5F
         coRPD/1EUcMEFH9DP9e8QPcAFWVmld4nBQtiPjrthSYsNWx3eAFkuNEw4VhHnhRASw8A
         puV3Dw3BjumEz3BoowWwFogTLQtMYqVJMNtjxGnAYIqqfT2WpheGB1fdj72erRi0MQxJ
         P0+/iEq0P6o1xauUYiiYuVoL+6PEfEpf7ntYLhZ47fjWdnGPqhT7KQnyCf5T5WNEWCn9
         6HGu8BDAmrF9TJ/OF4vPJ1mU46OUJTpWkIgJOz1c6dWwl2sepr967GlLDIPR6l6YGLJV
         7How==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hb07vEgf4l07RAm1DJJM+HsIb4pT8MG1CaZsYZrDsSA=;
        b=pqN0OYUaf5ybmciMqpThU6aG5EE71yM0/EFCEXgFDQAPKYKig/1lSCceSVBA93eqlS
         DVbtGjWeiONs3hqLTYVuweQcLPZU9a5+D2o3ZiMEkNE3TDsA9O3Y/fzA1ElRmCRdq2Nf
         5dHkiTkq2WbB6evfxgpqvIt69/bNjSaA79uExfYn7VWXiJS1qFEdfRUhtXwYKwRwNNHL
         mEMtTEJf0ii+hd8vO7lpMGsggMnhe0dKgBXQtONnIwPfv5kllJh6R/eE9hV5DGC4GOgC
         Hc8QE6O3nwCOCnB1UEJplYefPAfRCbEV7HNJXHqB2X5VPzoXGPbDv+8Jvu0qxzgze6pV
         hk3A==
X-Gm-Message-State: AOAM532A583Gb8X7uIY5l+xoOY50muk26FTPtEorGcNors7DeqcjuVrx
        ubLjsgnYuvJDd0tlYo/ynKA=
X-Google-Smtp-Source: ABdhPJwgql21/2ToFawk3Mcd/uhv+lwETfA67kzyaIPs0r0gA0sq/rn8XqE5GAmJ7sHDeNDEuRidtw==
X-Received: by 2002:a05:600c:3d18:b0:38e:bf5f:1957 with SMTP id bh24-20020a05600c3d1800b0038ebf5f1957mr3605575wmb.181.1650034145952;
        Fri, 15 Apr 2022 07:49:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id a16-20020a056000051000b00207b5d9f51fsm4223887wrf.41.2022.04.15.07.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:49:05 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fb162200-f361-27bf-0bcd-f716ec7a6768@redhat.com>
Date:   Fri, 15 Apr 2022 16:49:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 087/104] KVM: TDX: handle EXCEPTION_NMI and
 EXTERNAL_INTERRUPT
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <8a5ef99bde7333335ea3545a3040efb5c4804541.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8a5ef99bde7333335ea3545a3040efb5c4804541.1646422845.git.isaku.yamahata@intel.com>
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
> Because guest TD state is protected, exceptions in guest TDs can't be
> intercepted.  TDX VMM doesn't need to handle exceptions.
> tdx_handle_exit_irqoff() handles NMI and machine check.  Ignore NMI and
> machine check and continue guest TD execution.
> 
> For external interrupt, increment stats same to the VMX case.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2c35dcad077e..dc83414cb72a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -800,6 +800,23 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   						     tdexit_intr_info(vcpu));
>   }
>   
> +static int tdx_handle_exception(struct kvm_vcpu *vcpu)
> +{
> +	u32 intr_info = tdexit_intr_info(vcpu);
> +
> +	if (is_nmi(intr_info) || is_machine_check(intr_info))
> +		return 1;
> +
> +	kvm_pr_unimpl("unexpected exception 0x%x\n", intr_info);
> +	return -EFAULT;
> +}
> +
> +static int tdx_handle_external_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	++vcpu->stat.irq_exits;
> +	return 1;
> +}
> +
>   static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
>   {
>   	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> @@ -1131,6 +1148,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>   	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
>   
>   	switch (exit_reason.basic) {
> +	case EXIT_REASON_EXCEPTION_NMI:
> +		return tdx_handle_exception(vcpu);
> +	case EXIT_REASON_EXTERNAL_INTERRUPT:
> +		return tdx_handle_external_interrupt(vcpu);
>   	case EXIT_REASON_EPT_VIOLATION:
>   		return tdx_handle_ept_violation(vcpu);
>   	case EXIT_REASON_EPT_MISCONFIG:

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
