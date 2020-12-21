Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD152DFFD0
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgLUScI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:32:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55372 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgLUScI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Dec 2020 13:32:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608575442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6aof73yWrybwGG51AadR/+S6Y7ScgNPoSw+eELySBE=;
        b=K0Kd+FuIqPSL8tQtnfsfwhx+MdJQGwHXRLHG/xtWqdQBP1v5wgWFsNSqSFVy7PsrQEKSi1
        oPsAYPnhhHbe1Ik7Y+EcoCy2LTyfvW3T1pFc8qjJH+tST+azCUPE0qBRKZuaKKU6dXTT3b
        c/cVD0HO+2CDt/HMInqV7JVKilfLem4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-Onb7b_ZmPIOIpZ45lO10RA-1; Mon, 21 Dec 2020 13:30:40 -0500
X-MC-Unique: Onb7b_ZmPIOIpZ45lO10RA-1
Received: by mail-wm1-f71.google.com with SMTP id r1so8143048wmn.8
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:30:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u6aof73yWrybwGG51AadR/+S6Y7ScgNPoSw+eELySBE=;
        b=h3Z7H3kSOOMPf92m5CocZtm8ojvXPFy6SeNKdWi61kwcj8tPeHmAYYdUMYHXeuXOoT
         0b9mk+1Jc2620pfOecb1m39W23BZeupWxHhOlPSvmuD48uZAwKodrdi/xSJ9d0f4khIu
         4C2SBbdJHIBDjOAff5zHAzYai+j3Z0ob4h/Zbj3cCOrRAUObP+vQdxCHez9LcgbsFEXR
         FsY9rea3YVfCrFFboRaFX5qrYUlU6aCFtsxNeBELtsTGQxiQpHP+ypYxzrFNh6Iz625p
         ZkVE/oaD9OwEE31ulupW4xuOt+/QiNhIweKRuaHktAxvYNy+BEvD9CdQ6Ycb59WnY/Xn
         aBwQ==
X-Gm-Message-State: AOAM532d+qFJKmRBTI5urzkDgf+MF7pgvp7qqliD79vrGzYZFu5i34Ry
        IXgjWR2CdYXNJXSmCHqDxDNqg4dF7SU3UgRQGMsdzLTJUEb05C98gXSY/PavaJXPnocGTQlqqtx
        clFVfD0iQNprA
X-Received: by 2002:a05:6000:1290:: with SMTP id f16mr20405397wrx.298.1608575439410;
        Mon, 21 Dec 2020 10:30:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkUMftZ4r7w6EsobFo3hiS67k++nqGU3UWtRZFFfSZL36Z97x51VJVsFQ8GVT4G3fc3H17eg==
X-Received: by 2002:a05:6000:1290:: with SMTP id f16mr20405384wrx.298.1608575439250;
        Mon, 21 Dec 2020 10:30:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j59sm28954198wrj.13.2020.12.21.10.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 10:30:38 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: change in pv_eoi_get_pending() to make code
 more readable
To:     Stephen Zhang <stephenzhangzsd@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1608277897-1932-1-git-send-email-stephenzhangzsd@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a22baa12-7f37-054d-646b-b6ca393e01f7@redhat.com>
Date:   Mon, 21 Dec 2020 19:30:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1608277897-1932-1-git-send-email-stephenzhangzsd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/12/20 08:51, Stephen Zhang wrote:
> Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
> ---
>   arch/x86/kvm/lapic.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3136e05..7882322 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -674,7 +674,7 @@ static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
>   			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
>   		return false;
>   	}
> -	return val & 0x1;
> +	return val & KVM_PV_EOI_ENABLED;
>   }
>   
>   static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
> 

Queued, thanks.

Paolo

