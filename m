Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C5A502C31
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354731AbiDOPB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348301AbiDOPBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:01:55 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC044AE45;
        Fri, 15 Apr 2022 07:59:26 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id i20so10911855wrb.13;
        Fri, 15 Apr 2022 07:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g/wSdHDkq8uDZqXJCuDnsUgEtrwhs/V3/zsJrtzdwaw=;
        b=NAQTBgeyMqHensHz/+qUUUki9TFmU1R4oCPA/nUSSoibmUodDQIWq9Tn5fVSZdhGvN
         BZYxxab8kZ2wTtiIQt4Xs+4pLie8+V0rlmvWI8BoABSPSJVHU3aKGaZDAHvhZc9JHIl3
         Xj8u9ahGKJU+nPJHXQ0+HslNi9cbPhvJ8FRCEjP4fUdjn1K0XeKOoYEPZ2aC1Et3jYMF
         s7si48TutC+iMbRYM2y1wyNV9JGsQePnGWEbDZx4o69qqbHAUUPVAvs1Xe7yhRGKpsGo
         fHQqVI4ziUFhUOKW5bcYFEleiW5gG43zaKNYPPv8P9FCGPyIWFAGw4kD8ZRHDPXbhzIg
         Vraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g/wSdHDkq8uDZqXJCuDnsUgEtrwhs/V3/zsJrtzdwaw=;
        b=mnM1wUpBFOB4dLhe4t3YkD7fenLYKhWpO+ygHq3zUuOKGBQo0SPL3pKHD9fhs3Wkxb
         pFwX16FYLI677sVmUmdOgIm0xDghGylRbRezs825RPWNTl9FuJTXNr716tmvCX3XBJV6
         Ri8RK8DMVr959/iogb0pbNrX1/oEAXSToEQs5wN5iA1u8Qil6s0V7Zw/qWdCzV4IOH3J
         F/le/45/mHPdTZzbmcqBawLIT2jJKEQ5ghz5u/1qOZravjcv1N1Dsk/jSVfzAwUOQJZk
         W3KVPrHKQm6fwZ3CCavpZfO6Z7sh+zJCD8TwWfSeI77vvT2M+BWYHus4RdiMgTZK8qkN
         YtUQ==
X-Gm-Message-State: AOAM530MVOnPLtTgERXb6XoS3tD5ywptLlr0iEFeucIWrorz0kvHCnr4
        pLsY6VJWTJoM4Dw9oQWZ9/s=
X-Google-Smtp-Source: ABdhPJz5jyHAEbdXBNUKWBqY/qPm7lI3XJTsLFih24cL6WYbRFAY6nNH3MBddMjwu940UTwd/rRIKQ==
X-Received: by 2002:adf:e410:0:b0:207:9a14:b76e with SMTP id g16-20020adfe410000000b002079a14b76emr5668314wrm.392.1650034764984;
        Fri, 15 Apr 2022 07:59:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id az20-20020a05600c601400b0038ffb253bb3sm4484862wmb.36.2022.04.15.07.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:59:24 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <06d4f85b-b6c1-1952-b736-9cfd9aea17c2@redhat.com>
Date:   Fri, 15 Apr 2022 16:59:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 093/104] KVM: TDX: Handle TDX PV port io hypercall
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <a3c8c71d6d02896754632cf741c38efb60978215.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <a3c8c71d6d02896754632cf741c38efb60978215.1646422845.git.isaku.yamahata@intel.com>
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
> Wire up TDX PV port IO hypercall to the KVM backend function.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 55 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 55 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b0dcc2421649..c900347d0bc7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -959,6 +959,59 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
>   	return kvm_emulate_halt_noskip(vcpu);
>   }
>   
> +static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +	unsigned long val = 0;
> +	int ret;
> +
> +	WARN_ON(vcpu->arch.pio.count != 1);
> +
> +	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
> +					 vcpu->arch.pio.port, &val, 1);
> +	WARN_ON(!ret);
> +
> +	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +	tdvmcall_set_return_val(vcpu, val);
> +
> +	return 1;
> +}
> +
> +static int tdx_emulate_io(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +	unsigned long val = 0;
> +	unsigned int port;
> +	int size, ret;
> +
> +	++vcpu->stat.io_exits;
> +
> +	size = tdvmcall_p1_read(vcpu);
> +	port = tdvmcall_p3_read(vcpu);
> +
> +	if (size != 1 && size != 2 && size != 4) {
> +		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> +		return 1;
> +	}
> +
> +	if (!tdvmcall_p2_read(vcpu)) {
> +		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
> +		if (!ret)
> +			vcpu->arch.complete_userspace_io = tdx_complete_pio_in;
> +		else
> +			tdvmcall_set_return_val(vcpu, val);
> +	} else {
> +		val = tdvmcall_p4_read(vcpu);
> +		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
> +
> +		/* No need for a complete_userspace_io callback. */
> +		vcpu->arch.pio.count = 0;
> +	}
> +	if (ret)
> +		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +	return ret;
> +}
> +
>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -974,6 +1027,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   		return tdx_emulate_cpuid(vcpu);
>   	case EXIT_REASON_HLT:
>   		return tdx_emulate_hlt(vcpu);
> +	case EXIT_REASON_IO_INSTRUCTION:
> +		return tdx_emulate_io(vcpu);
>   	default:
>   		break;
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
