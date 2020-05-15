Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7191C1D5844
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 19:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgEORt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 13:49:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21875 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726219AbgEORt0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 13:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589564965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhm8fRfZ2lIuqL2yMAeF7apIj6q7LdiQQRMHj/hm40s=;
        b=FYD4EHD0JQVwjXshqpmAqAGOtYXjHtKqvHHZLfdbtjA8hKNXQ3Xw+1ZcuJHWvuWNGzxt3X
        X+x7MIuK376CdQqg1npuUEySF9kFNn2AbP/SaetXhAu/crcUS10u5/71XWYvsql+flIMr4
        PN/nhXUo+fgKyOiEsCByu1elJcaFUdk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-HCHeV-F-OXesnt7xKH5wow-1; Fri, 15 May 2020 13:49:23 -0400
X-MC-Unique: HCHeV-F-OXesnt7xKH5wow-1
Received: by mail-wm1-f72.google.com with SMTP id n124so1300028wma.1
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 10:49:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dhm8fRfZ2lIuqL2yMAeF7apIj6q7LdiQQRMHj/hm40s=;
        b=uQwVVpfzdCwGta2ym+yuseSreb/CJ7FFH5G+J3YOE18CSZ+Wr091R23nJxPE/KxPOG
         2qqYiQU2oyX3vIrqrMAOFOZtLmit5GIm+YhJM3ExCKwYADQiF3RL1lWjEleEMiNf4fQu
         tG4gjS6U0Ow1F07gsy2p24r3IHwKZJwdk1S0GX4zpSza6KeVe7zeNvTzim5EMu1IBHas
         kRHF1yetbIXuJQsSq9uyMZr0OHg6IltpoJiyeIH27SHkYproGr/qsNckGkTV0dYO4gl7
         262dR3QDtc9rpcAVyqB+McxazrLmtcgFY/dSV0aacfDotyuM9KO10nIiez7MkB9bT0HR
         Fi6w==
X-Gm-Message-State: AOAM531hGN1nOBU8t09jksXti5RMPw8if4zTADSmf+VULLBlXjvKQ2BW
        2dlSXSim8kevQdA/PNZE4aVZfcCrgYZGZAAt634wbZ1eitAGXkC9xFIcdA/UNW2qHUL1rKJk/5e
        GlCPIwxp+z+8/
X-Received: by 2002:a1c:6884:: with SMTP id d126mr5126931wmc.179.1589564962107;
        Fri, 15 May 2020 10:49:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw461EkcJuJODz1t0kEi9oGXWOqkSmRqrVuv4/X03bgU7/w0ii4PWaHzFjaTbacPcFLz9LPOA==
X-Received: by 2002:a1c:6884:: with SMTP id d126mr5126908wmc.179.1589564961788;
        Fri, 15 May 2020 10:49:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:60bb:f5bd:83ff:ec47? ([2001:b07:6468:f312:60bb:f5bd:83ff:ec47])
        by smtp.gmail.com with ESMTPSA id h20sm4479572wma.6.2020.05.15.10.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 10:49:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Fix off-by-one error in
 kvm_vcpu_ioctl_x86_setup_mce
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Jue Wang <juew@google.com>, Peter Shier <pshier@google.com>
References: <20200511225616.19557-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e9f74b78-e689-99fe-c469-1de161895e3c@redhat.com>
Date:   Fri, 15 May 2020 19:49:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200511225616.19557-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/20 00:56, Jim Mattson wrote:
> Bank_num is a one-based count of banks, not a zero-based index. It
> overflows the allocated space only when strictly greater than
> KVM_MAX_MCE_BANKS.
> 
> Fixes: a9e38c3e01ad ("KVM: x86: Catch potential overrun in MCE setup")
> Signed-off-by: Jue Wang <juew@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d786c7d27ce5..5bf45c9aa8e5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3751,7 +3751,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>  	unsigned bank_num = mcg_cap & 0xff, bank;
>  
>  	r = -EINVAL;
> -	if (!bank_num || bank_num >= KVM_MAX_MCE_BANKS)
> +	if (!bank_num || bank_num > KVM_MAX_MCE_BANKS)
>  		goto out;
>  	if (mcg_cap & ~(kvm_mce_cap_supported | 0xff | 0xff0000))
>  		goto out;
> 

Queued, thanks.

Paolo

