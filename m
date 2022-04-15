Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801B4502BE9
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354477AbiDOOde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354471AbiDOOca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:32:30 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4615897280;
        Fri, 15 Apr 2022 07:30:01 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id t1so10866825wra.4;
        Fri, 15 Apr 2022 07:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uVfCWCbLEsyc4fQxNjV8GRAXgFs5f66Tx5Il3NAbRbw=;
        b=KBHHGID0eGEA5K9lHa9WsQPxaTFtjUGuNTXXdvqBBKzcsHeBNb2/nN842A5OHMpopq
         q50OPz+GJEpvqaKyBI1ar8C91zsMylVwRc0AZItwG/cfWKmvk/JFfoIopeEB7bYp3lh4
         v7T8GlQeRxBiOFzA53qx36W6QFY49Kn6W6JTko/4uqgWZoVM1g33zy7i07blKyMK5NBs
         yldjWLSCizXmTFjVR32gtCcRV/+Zit4AZGUNm4UGmyaJUOz8AE5MQk7XFqhm2b1A+lFp
         x+kwRx64t56ZOEl46VnznhXVmPNdKBxmRiSk6EUp39OkaSTEM47WKB+m+JahjSVLJzeX
         fvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uVfCWCbLEsyc4fQxNjV8GRAXgFs5f66Tx5Il3NAbRbw=;
        b=16Mf5CzdClE7OTCS66wo67ymbIhhSMVdxeEFVoC3KOmJtZl62LeTww35EVdx/j4Y7B
         JNU9Hbk6BSjybFTOV/BVobmmZlkeoyAfgM9yEdAfU+DmHbW+nf1bJTpH7xEilHB9vPN+
         CDTMPi7oFZWt9N5hoFbzWUjdP2p08FuLrCbBGOvuoiRkuXPc0Dcx5SBnJwidNyGVLrnL
         +gdpBIkQEfBSERamJRF63Y2w32RA8pvrvfMVdILx43jBJBEX/xTfAnCbPWntKZJ4vdzv
         rvpb8uAjExHYLBU6CUoicRygs31lUD1W9ABIez5KKjYX53Cw/i8e4tzT2GA7nOvI465z
         oaXw==
X-Gm-Message-State: AOAM532/B6nBNj7bFDvSWgKZ+4h3awL8u311OfxYD41XFyNbSGA4/6wb
        BGJ7/QPzCuczNgT3DwWeQZM=
X-Google-Smtp-Source: ABdhPJxGkuBxcqGJI7Rb9HNVx2vZ1yYneb14bMcbhmZHmGcADMVnBbogDVVaLWd+x1ucZFvxW8RmaQ==
X-Received: by 2002:a05:6000:188b:b0:204:109a:fbed with SMTP id a11-20020a056000188b00b00204109afbedmr5800411wri.569.1650032999796;
        Fri, 15 Apr 2022 07:29:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id q128-20020a1c4386000000b003915e19d47asm2301976wma.32.2022.04.15.07.29.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:29:59 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fdd40873-4a36-18c4-9e86-4601ee234d07@redhat.com>
Date:   Fri, 15 Apr 2022 16:29:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 085/104] KVM: TDX: handle EXIT_REASON_OTHER_SMI
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <ea42891d7b9b378242bc027976415d8d81e21310.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ea42891d7b9b378242bc027976415d8d81e21310.1646422845.git.isaku.yamahata@intel.com>
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
> If the control reaches EXIT_REASON_OTHER_SMI, #SMI is delivered and
> handled right after returning from the TDX module to KVM nothing needs to
> be done in KVM.  Continue TDX vcpu execution.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/uapi/asm/vmx.h | 1 +
>   arch/x86/kvm/vmx/tdx.c          | 7 +++++++
>   2 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index 946d761adbd3..3d9b4598e166 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -34,6 +34,7 @@
>   #define EXIT_REASON_TRIPLE_FAULT        2
>   #define EXIT_REASON_INIT_SIGNAL			3
>   #define EXIT_REASON_SIPI_SIGNAL         4
> +#define EXIT_REASON_OTHER_SMI           6
>   
>   #define EXIT_REASON_INTERRUPT_WINDOW    7
>   #define EXIT_REASON_NMI_WINDOW          8
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 155208a8d768..6fbe89bcfe1e 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1097,6 +1097,13 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>   	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
>   
>   	switch (exit_reason.basic) {
> +	case EXIT_REASON_OTHER_SMI:
> +		/*
> +		 * If reach here, it's not a MSMI.

Please expand MSMI.  Otherwise,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> +		 * #SMI is delivered and handled right after SEAMRET, nothing
> +		 * needs to be done in KVM.
> +		 */
> +		return 1;
>   	default:
>   		break;
>   	}

