Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2934AC65C
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbiBGQoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387762AbiBGQdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 11:33:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54A07C0401DC
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 08:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644251603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=brX4GU+L1j81sGgh31BbcVQhnZMFjPf1oHc47AX/rUA=;
        b=BRPULVVCkXMgOpBERBOaxks6RmGi6E9f/KD/OtEQVM2afrHFEq0Ug4X14CODqJtysxqudh
        WM35kP+yv3UHdxxE4gxQwtVY/AVAayEY+mqccNiFLaOkbPx2CEMgV1W17/93hVzLW8mFYd
        Kzj6cMCX95RUIZAPXWEP5MWL22r7D5U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-2rZ33CIuMsKx-lK6Vt3anQ-1; Mon, 07 Feb 2022 11:33:22 -0500
X-MC-Unique: 2rZ33CIuMsKx-lK6Vt3anQ-1
Received: by mail-ed1-f71.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so4567101edb.2
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 08:33:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=brX4GU+L1j81sGgh31BbcVQhnZMFjPf1oHc47AX/rUA=;
        b=nY7rwewnzd8AGGGmkNbe11ecLWYbcEkImaNFMktqulXEwDkyZYxbnQD7b/4R+JWgMQ
         KcXR/eb+QVDRja8l9xlj2XinFhwvycbO/xDy1XR0hx4r32MFj/EPDvHBWMrrMNpdKTEL
         c/MmLsf+/k3KZgsmH7BrpYnhZQW+lSVFhXJOYmsDhK47NKy+30cTR/mmLxqwNErQDenU
         mPpAzFhOL72VCwNfIEu6XoJjgdTKVhqsqrzT1o4xMxsFXJnq7U4ujwoVJGEtfpbau7K5
         +peVO7EZ2cCtxgyvlz22jKDzaMTXkjAVcOlfNdTpj6Y+fLXXj9jyzq0gJlk8jY9oa5CZ
         J4YQ==
X-Gm-Message-State: AOAM531eJ9IQiYbZSSGmrgz4oGfqNCjBql8VSXpefx8GKpv6uMkChOJb
        2BlZ6XyizBY35epH6nUkm6gQ8kvtvFqqR9eUZr3uE7hVNegvaAJC/mAka4bovoTq3kdsj3cwQtr
        SSc12r3QeQMaw
X-Received: by 2002:a17:907:9694:: with SMTP id hd20mr392182ejc.447.1644251600674;
        Mon, 07 Feb 2022 08:33:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpJHeCGnmoiA+qPX2DbaRLqVYlmNdkTa1d7PbcO18dLqojD/hxPQPnb9EtNBsGdHKu+RDs5A==
X-Received: by 2002:a17:907:9694:: with SMTP id hd20mr392174ejc.447.1644251600413;
        Mon, 07 Feb 2022 08:33:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id er16sm1298735edb.86.2022.02.07.08.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 08:33:19 -0800 (PST)
Message-ID: <86c3b9d8-e9b7-250a-bb86-b99da294c1db@redhat.com>
Date:   Mon, 7 Feb 2022 17:33:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 2/7] KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL
 ctrl bits across MSR write
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-3-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220204204705.3538240-3-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 21:47, Oliver Upton wrote:
> Since commit 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
> VM-{Entry,Exit} control"), KVM has taken ownership of the "load
> IA32_PERF_GLOBAL_CTRL" VMX entry/exit control bits. The ABI is that
> these bits will be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs if
> the guest's CPUID exposes a vPMU that supports the IA32_PERF_GLOBAL_CTRL
> MSR (CPUID.0AH:EAX[7:0] > 1), and clear otherwise.
> 
> However, KVM will only do so if userspace sets the CPUID before writing
> to the corresponding MSRs. Of course, there are no ordering requirements
> between these ioctls. Uphold the ABI regardless of ordering by
> reapplying KVMs tweaks to the VMX control MSRs after userspace has
> written to them.

Ok, this makes more sense.  Here you have KVM_SET_MSR before 
KVM_SET_CPUID2, so KVM_SET_CPUID2 does to PERF_GLOBAL_CTRL controls what 
it's already doing with BNDCFGS controls.  Is this correct?

Paolo

> Note that older kernels without commit c44d9b34701d ("KVM: x86: Invoke
> vendor's vcpu_after_set_cpuid() after all common updates") still require
> that the entry/exit controls be updated from kvm_pmu_refresh(). Leave
> the benign call in place to allow for cleaner backporting and punt the
> cleanup to a later change.
> 
> Fixes: 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control")
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d63d6dfbadbf..54ac382a0b73 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7242,6 +7242,8 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>   			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
>   		}
>   	}
> +
> +	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
>   }
>   
>   static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)

