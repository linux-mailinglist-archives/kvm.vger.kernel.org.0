Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CDF518117
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 11:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiECJjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 05:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiECJjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 05:39:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE73C1FA5D
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 02:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651570540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vm1AHL4rFcbvCeBzsVIadvhZvmSkslM9GulbqwY1CBg=;
        b=UfkTvNB2IICuDXZeilzskYiElhG5TgrtFxGg8w2AxM4zV7wPde3i6U78EJiDOTi31NgOOi
        c/5wXpyUflXL3mG7JE1Zco7TbuB4YlkOwXEl+prstd4xegGjrFT5E+Mo2HiWjI2WMXgWpe
        fNCKRcnO2L/lDfscaUE57L7Z5Wd9utA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-rGjhIcJWNz-dL19pZL1kpw-1; Tue, 03 May 2022 05:35:38 -0400
X-MC-Unique: rGjhIcJWNz-dL19pZL1kpw-1
Received: by mail-wr1-f71.google.com with SMTP id s8-20020adf9788000000b0020adb01dc25so6140391wrb.20
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 02:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Vm1AHL4rFcbvCeBzsVIadvhZvmSkslM9GulbqwY1CBg=;
        b=SmPE4kV2cG2Xc9yfjUq5PIIyRd0pG32BqLLzAOoq4frMR4Y1cvp1x/Tyho0C/GIzG6
         gntCwFV2pdFB6IRPUq9Adj53OfSZ5N8GYzHV01K7RSRh7sjpXbnW25kgPR3fbFchkX7R
         W4Fpx9Fm1rTFEF/TuUgvQimuWQYLuDctksL9VK4aJe3GznchCUUTKYwKAVSdBq467BeQ
         nGsCaDI8TcT71V0lh+n8uACq9AoVTfTpRRgk5A7l5xLkhHQPGXfTXTYGIVzCrT0Dl9Gf
         c1HXlPekC1m8iUmYQVEa2DmAaT1QQAWvR9rMPlL1KsSf0lUIVOw/PZEicuP1j3u22+xg
         OVnQ==
X-Gm-Message-State: AOAM531wb3O2SSOtrj/cU0DvXiYss927kP0lFqKpEmNqIdJGWB7a6oMJ
        He58T1lWFBWyoZBhm+Web0ikBACIN7R2EIsxccz954ziErKQl45aw4zM8RWINjpS8g51CU1puoD
        vHj0o6VPtz4KW
X-Received: by 2002:adf:ded2:0:b0:20c:55cc:ab3e with SMTP id i18-20020adfded2000000b0020c55ccab3emr10945408wrn.376.1651570537661;
        Tue, 03 May 2022 02:35:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEmAquiSRy6OLItqDdXhrnPrw1k3bDoBoXFwZLlG+mHYAvbLpPmkSc5lN9GYwzWwQxdGRIwg==
X-Received: by 2002:adf:ded2:0:b0:20c:55cc:ab3e with SMTP id i18-20020adfded2000000b0020c55ccab3emr10945390wrn.376.1651570537412;
        Tue, 03 May 2022 02:35:37 -0700 (PDT)
Received: from [10.32.181.74] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id d15-20020adf9b8f000000b0020c5253d8c9sm8701504wrc.21.2022.05.03.02.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 02:35:36 -0700 (PDT)
Message-ID: <ae806798-b98e-c2d8-1926-32fa982a0a50@redhat.com>
Date:   Tue, 3 May 2022 11:35:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: VMX: Exit to userspace if vCPU has injected
 exception and invalid state
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com
References: <20220502221850.131873-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220502221850.131873-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/22 00:18, Sean Christopherson wrote:
> Exit to userspace with an emulation error if KVM encounters an injected
> exception with invalid guest state, in addition to the existing check of
> bailing if there's a pending exception (KVM doesn't support emulating
> exceptions except when emulating real mode via vm86).
> 
> In theory, KVM should never get to such a situation as KVM is supposed to
> exit to userspace before injecting an exception with invalid guest state.
> But in practice, userspace can intervene and manually inject an exception
> and/or stuff registers to force invalid guest state while a previously
> injected exception is awaiting reinjection.
> 
> Fixes: fc4fad79fc3d ("KVM: VMX: Reject KVM_RUN if emulation is required with pending exception")
> Reported-by: syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cf8581978bce..c41f0ac700c7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5465,7 +5465,7 @@ static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   
>   	return vmx->emulation_required && !vmx->rmode.vm86_active &&
> -	       vcpu->arch.exception.pending;
> +	       (vcpu->arch.exception.pending || vcpu->arch.exception.injected);
>   }
>   
>   static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
> 
> base-commit: 84e5ffd045f33e4fa32370135436d987478d0bf7

Queued, thanks.

Paolo

