Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9BC4D75B5
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiCMOKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiCMOKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:10:02 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3808E7650;
        Sun, 13 Mar 2022 07:08:51 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j17so20114594wrc.0;
        Sun, 13 Mar 2022 07:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dVbQ2Ts/AgC6xKRX1dcxhipDpyG7lF5+cr2c6TUglIQ=;
        b=UfY5ul31t4TXhuJqAlDuiyi3HLTkuKKfdBUjGm4UCCnyo52666qL/O+IDxXTldWLaY
         qStKwT+Cz/M5BnrsY9eu3oTrZDKfT9oTxHKLeNu+cCXzX3GLyIeY0I0E7ix77uazTDu2
         Bukj9jUmpJuQjYSZ6d1bl1q8EZM6qBUWpeFNhB3AH8l4bXqGz3BFZJc9lGXwcoNLI5fe
         pmuXzEJDzEeoI5xrBjSjAWunrP77Fuu2hfxcUf0tOmZn2MVDNyN5U/4Rlr4P5P2jnBlB
         aieGCg5oU4b0DYPn0DFzS6eHf1YF6gaRaeAAY651Nzqe5x3eMj3fzFXp1z4NNvThtHhb
         zxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dVbQ2Ts/AgC6xKRX1dcxhipDpyG7lF5+cr2c6TUglIQ=;
        b=YMV/RZMQSzYe8mQGD7xcp6Kx4CjZhJoF7qlXKdPZix/dEm2F+zxdLy8YVDcaLK1v8C
         wamUocIpKqoTg52ZubUsvoxPzNGD7O5HiG3BZVJBTGCcVEYSSZKvs5iX0NaaVt4+/8tV
         HfomvfcTTB0wD9JqBukg0rgTlazrOEbNQNXuy8j+bao/oaeTQ8sai9ughdYhnTwJ2rAo
         MkFgUMEY4ni0v1v7PO1cRHelbcUmYojfyDYCn+GTSAYL/Nz+3ytYLmvaxmIsgzx4pYWk
         mP6zHAtV7idjJGOlnaF24vTeXR+cRfEEvF2iAfEYf8u+WtLLsc+2lTEHTm/7IEAIe5ly
         RhVw==
X-Gm-Message-State: AOAM532PNtBHUS25iLHZ/mhA2cotc2cyCDNBs2co3tCoyrOI3oecFBM/
        AeKB/KH+INLDR6OrpR3uoYs=
X-Google-Smtp-Source: ABdhPJwGOCG4u6rzVkoxBIGzO2I21e0gJrDAML42ULljFtt2CP+B/z+9A1cHuWrWh/aj7bSfuf8BFQ==
X-Received: by 2002:a05:6000:1e07:b0:1f1:d782:2863 with SMTP id bj7-20020a0560001e0700b001f1d7822863mr13963050wrb.406.1647180529798;
        Sun, 13 Mar 2022 07:08:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id o7-20020a5d6707000000b001f067c7b47fsm18845127wru.27.2022.03.13.07.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 07:08:49 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <2e317833-2f43-d8b2-1b0a-cd4cacf79695@redhat.com>
Date:   Sun, 13 Mar 2022 15:08:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 013/104] KVM: TDX: Add TDX "architectural" error
 codes
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <822868fa815a08894030fe7e97c55cd99d42e59d.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <822868fa815a08894030fe7e97c55cd99d42e59d.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add error codes for the TDX SEAMCALLs both for TDX VMM side for TDH
> SEAMCALL and TDX guest side for TDG.VP.VMCALL.  KVM issues the TDX
> SEAMCALLs and checks its error code.  KVM handles hypercall from the TDX
> guest and may return an error.  So error code for the TDX guest is also
> needed.
> 
> TDX SEAMCALL uses bits 31:0 to return more information, so these error
> codes will only exactly match RAX[63:32].  Error codes for TDG.VP.VMCALL is
> defined by TDX Guest-Host-Communication interface spec.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>


> ---
>   arch/x86/kvm/vmx/tdx_errno.h | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
> 
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> new file mode 100644
> index 000000000000..5c878488795d
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* architectural status code for SEAMCALL */
> +
> +#ifndef __KVM_X86_TDX_ERRNO_H
> +#define __KVM_X86_TDX_ERRNO_H
> +
> +#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
> +
> +/*
> + * TDX SEAMCALL Status Codes (returned in RAX)
> + */
> +#define TDX_SUCCESS				0x0000000000000000ULL
> +#define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
> +#define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
> +#define TDX_LIFECYCLE_STATE_INCORRECT		0xC000060700000000ULL
> +#define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
> +#define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
> +#define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
> +#define TDX_KEY_CONFIGURED			0x0000081500000000ULL
> +#define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
> +
> +/*
> + * TDG.VP.VMCALL Status Codes (returned in R10)
> + */
> +#define TDG_VP_VMCALL_SUCCESS			0x0000000000000000ULL
> +#define TDG_VP_VMCALL_INVALID_OPERAND		0x8000000000000000ULL
> +#define TDG_VP_VMCALL_TDREPORT_FAILED		0x8000000000000001ULL
> +
> +#endif /* __KVM_X86_TDX_ERRNO_H */

