Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6824D3080
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbiCINvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbiCINvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:51:53 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E6D1637EE;
        Wed,  9 Mar 2022 05:50:48 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id bg31-20020a05600c3c9f00b00381590dbb33so1501412wmb.3;
        Wed, 09 Mar 2022 05:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t36AjXfGdpizP8k4vNw4tUmA5qCcB85SL95no+CKwL4=;
        b=p7IsLRlIaH0BJaVFy8cb1OpdHYPaV0pVTmTT9yx8ZUM5QZLAPnKbf0s/AiTURwVNry
         pTnCYOU+OifDD7UDvESPqv+O4Dt2ngS5Ov2+lBOO84v0JNns7/EJl7cDJl5avXQih/7V
         0csgKcUWjxOxNDE99ugIvhQGiv9/Npq7XeFayJoTOjkiOgG0w3vr3RwnRm2EKwfNfKwg
         nl3G30X1w2ZdImOMHCb6xh/qQozmKXIoO0z0xny8cjThGgsXLXUJPXuuowSELbedNLAG
         EblPOm+P+jmU9T5eVMkww9Aw48pdGj07169YzxMHr7O/oOfZAzcHfw92bjpoWc6gvznO
         zG1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t36AjXfGdpizP8k4vNw4tUmA5qCcB85SL95no+CKwL4=;
        b=JL8X7OIRk8uPJzq/Fo4c0/nvUgOuNPPBF/NNc5bpqDfgViZ+vT6/DvDJWsODAKScfi
         VEkYmdGby2oWQ242TNlpXG85c8T7RdryqnJDjy/de97+KVQYDWx93+X1DfOF0ooEtjeE
         H+4ZTru5lZLbeahQkvjZvFTCd1pA6EaPziNzbq7SGPLtDl31Dknavo/S7ULbecsja+3r
         yFRc8XBriiUiA2jizI6M12n4RuKKDO9hYWe54jl+J5t61eAg96SQIHuVBs2TyjlaAhmd
         whf3pQdQbBDqIE/rOCQdf81U8ZVK1CMklrIraRZoEzrCSEoUqkq92MnBsqAFzpotGnl9
         Ul+g==
X-Gm-Message-State: AOAM530ZHsDSNxV0qV2xvTKjH/QtdLX9NSnTiKZoXGRFXCoMec4y3oXG
        JjWSBlrKSaBZd0iImalixcM=
X-Google-Smtp-Source: ABdhPJyK+WypfRN4CaAxoOi/2/rku7wS3h7Lb70KqzVu+/Y2SFv8Ty71vvCb+jZSBoyALsYbctxueQ==
X-Received: by 2002:a7b:c2f7:0:b0:389:860c:6d3d with SMTP id e23-20020a7bc2f7000000b00389860c6d3dmr3445296wmk.116.1646833846960;
        Wed, 09 Mar 2022 05:50:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id v188-20020a1cacc5000000b00384b71a50d5sm1827211wme.24.2022.03.09.05.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 05:50:46 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bdb527f3-9281-1f25-c6c7-a8538455bfa3@redhat.com>
Date:   Wed, 9 Mar 2022 14:50:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 7/7] KVM: x86: SVM: allow AVIC to co-exist with a
 nested guest running
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
 <20220301143650.143749-8-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301143650.143749-8-mlevitsk@redhat.com>
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

On 3/1/22 15:36, Maxim Levitsky wrote:
>   	bool activate;
> @@ -9690,7 +9695,9 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>   
>   	down_read(&vcpu->kvm->arch.apicv_update_lock);
>   
> -	activate = kvm_apicv_activated(vcpu->kvm);
> +	activate = kvm_apicv_activated(vcpu->kvm) &&
> +		   !vcpu_has_apicv_inhibit_condition(vcpu);
> +
>   	if (vcpu->arch.apicv_active == activate)
>   		goto out;
>   

Perhaps the callback could be named vcpu_apicv_inhibit_reasons, and it would
return APICV_INHIBIT_REASON_NESTED?  Then instead of the new function
vcpu_has_apicv_inhibit_condition(), you would have

bool kvm_vcpu_apicv_activated(struct vcpu_kvm *kvm)
{
	ulong vm_reasons = READ_ONCE(vcpu->kvm->arch.apicv_inhibit_reasons);
	ulong vcpu_reasons = static_call(kvm_x86_vcpu_apicv_inhibit_reasons)(vcpu);
         return (vm_reasons | vcpu_reasons) == 0;
}
EXPORT_SYMBOL_GPL(kvm_cpu_apicv_activated);

It's mostly aesthetics, but it would also be a bit more self explanatory I think.

Paolo
