Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27D5502C5E
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354847AbiDOPK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350436AbiDOPKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:10:54 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97D3CF480;
        Fri, 15 Apr 2022 08:08:25 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l3-20020a05600c1d0300b0038ff89c938bso1617091wms.0;
        Fri, 15 Apr 2022 08:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ErStW3rPOBKQARnIVZygQKZdzKxAEYlPsIaEFV3oKuQ=;
        b=Zbldi1K2j3XC4xBsoSkaktwQvWO620FEFB+iiNBHyOLIEjACS/0GERXSy2lwNFPiXR
         qTRxM2/rsg3EpPFI90bFFqjet4K5d7lDD19/NhR2JXETQvxBR7JBzgRyX/3cHzlx7pG9
         nqxOhwS7KCgOyeZ6ABHyUMlYKxVkMUdVi0OCGDjw+qxdo0HG+CwUAQ5E/xzkruxMg8Qa
         B9P/unGS9dZZb27aIBi9Q2HI26iG6D37HBFuLj8/mqaRaog4zZ4oyZQxEUZE4YRNJSti
         Yfm9+sguMPFhpYQ8OQ6vN22S3xpKBbaAMwkBv+hARBrdGfjGqKBeG82FQJqueNpFYYJo
         d8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ErStW3rPOBKQARnIVZygQKZdzKxAEYlPsIaEFV3oKuQ=;
        b=tBt2cXNFA2vghBZkIqgytHMUbmc14wUXuShjgZ6/W64nHgln27ionkRk9d+AXWu0la
         s54lbGy7Bq8NN6BT1pDhlPxm2ZymA6pgEQ8T2fM0DcN/Aw9mTXtOsht+207uPwbGtuuh
         Y4e3QeHV2EBwq9R5gXL7Zn08PuhFky61H1bEywj2bLDCdOerNKZY+EJFwbJcmQlY3LUc
         NgX7NAIp7Wdd/kamIao/CvBMCE/jjEbjlvEj+vuGKKZTSaKAXqz+jO1N6WeDAtLTEHho
         9vWYcw9eQU59BYiTKh96qQTaiSKLQIknEOHy1KLtf0uZL2SS5sc3xkQEPajlxdgYBRTr
         dgxQ==
X-Gm-Message-State: AOAM5315RW3MQYyrWivpNboCIIcwmZavc1JmN+2P16yHfR6+t5xldJFu
        jpRbuKr4NBOoGWubJw8/Zzg=
X-Google-Smtp-Source: ABdhPJxWrXcOoZ2hRBlIKf9Xl736VnNNYhhKCadEhBE45FqAjKq/+xORnk2Qa4GCEBd8VfBYwIIMFw==
X-Received: by 2002:a05:600c:35c5:b0:390:9982:73ec with SMTP id r5-20020a05600c35c500b00390998273ecmr3724293wmq.196.1650035304472;
        Fri, 15 Apr 2022 08:08:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id l126-20020a1c2584000000b00387d4f35651sm8886451wml.10.2022.04.15.08.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 08:08:24 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <c7f75e03-2b9e-698f-0f2e-04c6c7bae892@redhat.com>
Date:   Fri, 15 Apr 2022 17:08:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 096/104] KVM: TDX: Handle TDX PV rdmsr hypercall
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <684d96c4e2d7cfcc49c5cb482e54f582af50e09e.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <684d96c4e2d7cfcc49c5cb482e54f582af50e09e.1646422845.git.isaku.yamahata@intel.com>
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
> Wire up TDX PV rdmsr hypercall to the KVM backend function.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index cec2660206bd..dd7aaa28bf3a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1124,6 +1124,23 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
> +{
> +	u32 index = tdvmcall_p1_read(vcpu);
> +	u64 data;
> +
> +	if (kvm_get_msr(vcpu, index, &data)) {
> +		trace_kvm_msr_read_ex(index);
> +		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> +		return 1;
> +	}
> +	trace_kvm_msr_read(index, data);
> +
> +	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +	tdvmcall_set_return_val(vcpu, data);
> +	return 1;
> +}
> +
>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -1143,6 +1160,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   		return tdx_emulate_io(vcpu);
>   	case EXIT_REASON_EPT_VIOLATION:
>   		return tdx_emulate_mmio(vcpu);
> +	case EXIT_REASON_MSR_READ:
> +		return tdx_emulate_rdmsr(vcpu);
>   	default:
>   		break;
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

and feel free to squash with the wrmsr one.

Paolo
