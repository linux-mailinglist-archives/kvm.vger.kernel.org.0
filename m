Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678C1502C27
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354699AbiDOOwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244467AbiDOOwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:52:53 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005D7888DD;
        Fri, 15 Apr 2022 07:50:24 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k22so10929261wrd.2;
        Fri, 15 Apr 2022 07:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E/WvmRtY2FKT2/QfdYrbbMfOZ74SQ0m5FP58OjOgVFQ=;
        b=ICpTu2Y8SuJjkZKC8C+Guf/72FgPGOfTGSaH5ked0Ftu0fsUUMB5bFN4atuBnxe0Rb
         Lfd5H7kCUxUDzK6qnav/ikeIZ4SXHplI7GaXajJNEwy/H4vycgWaM8j8I/+PpzXt+9vt
         +uHcPojxDnbIWuGmU8fKLo/PIKh91vQvAa2TVp+nX6EU/PYsLRRoeQo97purt9itfp6a
         pou+bwmp8iIcsO7mxiXRJJZ2gFAI/sP+DGlfJD50XcyKSuuK0z3XTKBHxEzna1kmMP4m
         XmHEJu02mfYiMUWrhrujsOjHa3oE8zcIxqQyvE5uaOe2xZoCd3ILtv9pRbt4RC3Jwm1Z
         CyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E/WvmRtY2FKT2/QfdYrbbMfOZ74SQ0m5FP58OjOgVFQ=;
        b=y9w3GkeO507assuKWd+THyF1GFIkqv3Ldj7XDciznn5Q/Rd5oiqDUZvkn0R4G9nij4
         GgfLcdF/fbflvKzjtM2jLvPgZ6LzEe0Fk+H9QT4ajz1pAWOFCDL/YIAUxigyQG3sLr4/
         QHibfU0b8DbVDEGUxdYU9RoEi1laV5xeVIKBGY2KmA0mNiMCi2gTVJB0Em6EDg6WPgpD
         qdt8KLj57T1zVAgAnSJAAidy8g+zibIvU+inmZqp43fY9V92bsTvoVn0EuPbya8M3nmq
         QgUnXPdNf6rvI8hGYlrOmV0KDW5N884Mlwqs0mlXAFVd9/ZzER9+hZ5j0ZH5rFbKsvqb
         uCdQ==
X-Gm-Message-State: AOAM532TvAbiQGJeBfNH9JOh5Fy0pcbSwdX6PSjjP5DEjMsKgsZe21bb
        6mvNXA/u6ajcK2SAa0DOnJ4=
X-Google-Smtp-Source: ABdhPJyw7pjvYW+v7EVxO2WOTb4S5ulG/VKxpWHnMwfNNTnzXDxC6xv9V+OAhDjg1a2tlZubkpu18Q==
X-Received: by 2002:adf:f7cd:0:b0:207:a25c:24c4 with SMTP id a13-20020adff7cd000000b00207a25c24c4mr5792154wrq.528.1650034223562;
        Fri, 15 Apr 2022 07:50:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id u5-20020a5d6ac5000000b00207e90b2869sm4239569wrw.91.2022.04.15.07.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:50:23 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <cfa48bfe-f786-d318-bcd1-6013d0241fb1@redhat.com>
Date:   Fri, 15 Apr 2022 16:50:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 088/104] KVM: TDX: Add TDG.VP.VMCALL accessors to
 access guest vcpu registers
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <e490d6b5d26bc431684110dcca068a8b759b97aa.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e490d6b5d26bc431684110dcca068a8b759b97aa.1646422845.git.isaku.yamahata@intel.com>
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
> TDX defines ABI for the TDX guest to call hypercall with TDG.VP.VMCALL API.
> To get hypercall arguments and to set return values, add accessors to guest
> vcpu registers.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 35 +++++++++++++++++++++++++++++++++++
>   1 file changed, 35 insertions(+)

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index dc83414cb72a..8695836ce796 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -88,6 +88,41 @@ static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
>   	return kvm_r9_read(vcpu);
>   }
>   
> +#define BUILD_TDVMCALL_ACCESSORS(param, gpr)					\
> +static __always_inline								\
> +unsigned long tdvmcall_##param##_read(struct kvm_vcpu *vcpu)			\
> +{										\
> +	return kvm_##gpr##_read(vcpu);						\
> +}										\
> +static __always_inline void tdvmcall_##param##_write(struct kvm_vcpu *vcpu,	\
> +						     unsigned long val)		\
> +{										\
> +	kvm_##gpr##_write(vcpu, val);						\
> +}
> +BUILD_TDVMCALL_ACCESSORS(p1, r12);
> +BUILD_TDVMCALL_ACCESSORS(p2, r13);
> +BUILD_TDVMCALL_ACCESSORS(p3, r14);
> +BUILD_TDVMCALL_ACCESSORS(p4, r15);
> +
> +static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_r10_read(vcpu);
> +}
> +static __always_inline unsigned long tdvmcall_exit_reason(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_r11_read(vcpu);
> +}
> +static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
> +						     long val)
> +{
> +	kvm_r10_write(vcpu, val);
> +}
> +static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
> +						    unsigned long val)
> +{
> +	kvm_r11_write(vcpu, val);
> +}
> +
>   static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
>   {
>   	return tdx->tdvpr.added;

