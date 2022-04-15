Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903B3502B4E
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 15:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354163AbiDONyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 09:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354157AbiDONyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 09:54:49 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8442DBC856;
        Fri, 15 Apr 2022 06:52:20 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id i27so15466357ejd.9;
        Fri, 15 Apr 2022 06:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y9bMKIoMA4ZWyNr76PabwIny+psaRVtbI7l3QYKzBGY=;
        b=WrfxT9w7Xdhji7RtpZX1oY7/s8uJg2kgLfnL3b6m8oCjCAI71ddOuNXAYx/YQpt+46
         QSVQhfHGmfh+BJRtMzLFXhE+23lJfpf3/8mE59bikRDPbUzYp37yynqVA0cOsnduKfkf
         Vdj4BHMWS6MkLiuSI8AUTwQfdzZInroEwhfSXmmMmMSda4JTUzanJDWfhIm1JrqzTlo0
         GWMMjDbG9su97cr30EVxDw7rQCtt0/9ay4l6NOLMHRf14mp5Tw5bOzyYHnbqSj3Tp3sm
         oksZnGQVbzJ7UVNJ11e/UAImQelQf+B6GuimWIea5h7geVMl7k/bvrAzQq8JWCLKRYlM
         HqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y9bMKIoMA4ZWyNr76PabwIny+psaRVtbI7l3QYKzBGY=;
        b=ausbNNtMRk22RAOkdpaWcQ2+UljbUlQ1TzaRpKfZ1z0evpHLyVkcmP+T7h/t3HNt17
         Mvjx0BjwAz7fOTHt9Od7LtB3KAze9Vgnx2ZjSpJ1YdtRmFdLCch5Qe026QWQw7mmbzl2
         gNf1OPx7T+FboXEQA9ZhPwq1+pR0F+M2aNjR0aqiorLUh10rc0IyO4zTG4nJ7714TLH2
         v9LwGWlwfIdRqnMRa9k9qxAg6AzQ3/GmzLpopFD3phg78duYIpfiKZGMybPNX4zW6wbZ
         3SiJT/wfr8o8/qVlEKVeXDn+J9FgaRNgUG40lbc3ArcsPdf1/EOIqpV5zdv3WZN8Ep3w
         Bo/w==
X-Gm-Message-State: AOAM531UTUCe/b0Iq8EXHOuFRsCZ5pABPMrFBV/RZx+n+FSNnDoL8d3Z
        EginXjVkgmcaeRNfqOsA9oBieUlrjZQpEQ==
X-Google-Smtp-Source: ABdhPJz0gleb4vbgpmjhsEr/g1gMmnuJZmdWwUakwBghvIs9O1+imICeQyCPgXNy4WFhjB+yVOJ2rw==
X-Received: by 2002:a17:907:3da5:b0:6e8:c2c8:1f18 with SMTP id he37-20020a1709073da500b006e8c2c81f18mr6298391ejc.728.1650030738952;
        Fri, 15 Apr 2022 06:52:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id r29-20020a50c01d000000b00415fb0dc793sm2781482edb.47.2022.04.15.06.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 06:52:18 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d95791fc-a278-9002-2f12-6aeaa1d1e47f@redhat.com>
Date:   Fri, 15 Apr 2022 15:52:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 061/104] KVM: TDX: Finalize VM initialization
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <83768bf0f786d24f49d9b698a45ba65441ef5ef0.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <83768bf0f786d24f49d9b698a45ba65441ef5ef0.1646422845.git.isaku.yamahata@intel.com>
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
> To protect the initial contents of the guest TD, the TDX module measures
> the guest TD during the build process as SHA-384 measurement.  The
> measurement of the guest TD contents needs to be completed to make the
> guest TD ready to run.
> 
> Add a new subcommand, KVM_TDX_FINALIZE_VM, for VM-scoped
> KVM_MEMORY_ENCRYPT_OP to finalize the measurement and mark the TDX VM ready
> to run.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/uapi/asm/kvm.h       |  1 +
>   arch/x86/kvm/vmx/tdx.c                | 21 +++++++++++++++++++++
>   tools/arch/x86/include/uapi/asm/kvm.h |  1 +
>   3 files changed, 23 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 77f46260d868..943219a08fcd 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -534,6 +534,7 @@ enum kvm_tdx_cmd_id {
>   	KVM_TDX_INIT_VM,
>   	KVM_TDX_INIT_VCPU,
>   	KVM_TDX_INIT_MEM_REGION,
> +	KVM_TDX_FINALIZE_VM,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index cd726c41d362..85d5f961d97e 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1103,6 +1103,24 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>   	return ret;
>   }
>   
> +static int tdx_td_finalizemr(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err;
> +
> +	if (!is_td_initialized(kvm) || is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +
> +	err = tdh_mr_finalize(kvm_tdx->tdr.pa);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MR_FINALIZE, err, NULL);
> +		return -EIO;
> +	}
> +
> +	kvm_tdx->finalized = true;
> +	return 0;
> +}
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_tdx_cmd tdx_cmd;
> @@ -1123,6 +1141,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   	case KVM_TDX_INIT_MEM_REGION:
>   		r = tdx_init_mem_region(kvm, &tdx_cmd);
>   		break;
> +	case KVM_TDX_FINALIZE_VM:
> +		r = tdx_td_finalizemr(kvm);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 77f46260d868..943219a08fcd 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -534,6 +534,7 @@ enum kvm_tdx_cmd_id {
>   	KVM_TDX_INIT_VM,
>   	KVM_TDX_INIT_VCPU,
>   	KVM_TDX_INIT_MEM_REGION,
> +	KVM_TDX_FINALIZE_VM,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Note however that errors should be passed back in the struct.

Paolo
