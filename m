Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440D0316C40
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 18:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhBJRNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 12:13:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232364AbhBJRNV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 12:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612977115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Etz/ew60GPwy2k7GqdR6uZwKVLAFOVbH1sSkPcRoHNo=;
        b=diOCq2UHWwYrNvdrTRmDrGy8SMH4D69XUTpWqJM8aXBi6Hguo1/um8g26rfdWvtKWeLTnM
        FXMRCYd7zLHHmnwskc5ZRGy71Wfws+q+CY9cgouM9afaOR/OxZH0/wXD7CK9c7uldApSak
        5Ou4DWz7oxwIxaIt75T+0FvoG5tOwoY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-ifINjoHLNHCZa7_kw6Kl3w-1; Wed, 10 Feb 2021 12:11:54 -0500
X-MC-Unique: ifINjoHLNHCZa7_kw6Kl3w-1
Received: by mail-wm1-f69.google.com with SMTP id i4so4504148wmb.0
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 09:11:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Etz/ew60GPwy2k7GqdR6uZwKVLAFOVbH1sSkPcRoHNo=;
        b=Drh0SgBlHtTJJcln54fgQocmMXUzd/mVUsX9mr2GRg2VV7H0m/DbLxB1fZi4+ukDjt
         rHvPDghvpXz2yOdVr891nS9NIKhYtcpaJPYtntT5upsS+tzCGmBXdqbaLAFROMZ6lsmL
         1LjNvn58orfcYVLGPrJ7N268JHHMx6buXQW/CG0VA+QvpBeOC6XZc9DIR0qP8v4rS2SC
         XZuswoijIBJ1LD0viaWWUIxUReA6cVB8cr5jHL4QuEzRahVa/PYn5RfkFfHfSDeDZ2+Z
         6DKu8BkRVYBY4CWO7JU1+q/vBkw8V9Tww9X6MU4Zdeol8i5Ii5nt+/BJML8HgSemKPN7
         rFDQ==
X-Gm-Message-State: AOAM531pnKxgpJMTq6tyT/IZrqWOt6Tg2E7wgE3rtcqyu1EPNgSq8ZeH
        QnlodzVRXX8K+T19o0SVAFyo6D+AwoKeM08okB4dIRyFnZoGDvq55GSzUdQk4T4KnDDDbamE/fb
        SW6n82N9oiFnj
X-Received: by 2002:adf:d20c:: with SMTP id j12mr4744394wrh.407.1612977111782;
        Wed, 10 Feb 2021 09:11:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJ6zqlGddcf5MmHINTE1mlN2XKzyLgTjW7eMJGi3eFyz+2EcjiIW/wHUCWC45PeUQraVSeAg==
X-Received: by 2002:adf:d20c:: with SMTP id j12mr4744337wrh.407.1612977110988;
        Wed, 10 Feb 2021 09:11:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u14sm2884236wmq.45.2021.02.10.09.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 09:11:50 -0800 (PST)
Subject: Re: [PATCH -next] KVM: SVM: Make symbol 'svm_gp_erratum_intercept'
 static
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Bandan Das <bsd@redhat.com>, Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org
References: <20210210075958.1096317-1-weiyongjun1@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d7bbf827-5c90-4694-77f7-c2be9eac819c@redhat.com>
Date:   Wed, 10 Feb 2021 18:11:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210210075958.1096317-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/21 08:59, Wei Yongjun wrote:
> The sparse tool complains as follows:
> 
> arch/x86/kvm/svm/svm.c:204:6: warning:
>   symbol 'svm_gp_erratum_intercept' was not declared. Should it be static?
> 
> This symbol is not used outside of svm.c, so this
> commit marks it static.
> 
> Fixes: 82a11e9c6fa2b ("KVM: SVM: Add emulation support for #GP triggered by SVM instructions")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   arch/x86/kvm/svm/svm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4141caea857a..4a41d11aabfe 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -201,7 +201,7 @@ module_param(sev_es, int, 0444);
>   bool __read_mostly dump_invalid_vmcb;
>   module_param(dump_invalid_vmcb, bool, 0644);
>   
> -bool svm_gp_erratum_intercept = true;
> +static bool svm_gp_erratum_intercept = true;
>   
>   static u8 rsm_ins_bytes[] = "\x0f\xaa";
>   
> 

Queued, thanks.

Paolo

