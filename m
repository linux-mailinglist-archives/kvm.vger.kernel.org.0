Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C2D68860
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 13:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfGOLzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 07:55:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33748 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729802AbfGOLzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 07:55:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so16832795wru.0
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 04:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MT8e1cyvm40khAU3BWxt6sY48mhIMavsPPDqaVWfXiU=;
        b=RDPfT1GOeZaXRAgyjPyYmF/gvRnufSU3bnIDtJpRoC8LYctQo5PTEWkdFZU5pqiUZL
         shU2jSQvIeysnSWXkkOh1JNTic1PnYxa6oHTYywjRvo2ePGup6g+dPv1bQqlR9XI0zi2
         kExwK7m6n1ZYM0nJRUpPxZB1Fj3WHdPwW9toPVrwF67z8ErKB07yWc7YkxucjHX7IPPn
         B3NbQBII86qb+5UCDsDhZoFUpuBxEocqcP6ghkw9SaSftVwjKRgoOMArNe5A92ClF3mj
         y85Xi2iv2Yt/ONKGqIo9mESI7Sxg8HdrE9KtwPw5AlOyfkUsm4eQmsPmqYapMZD8Hnh7
         LCMQ==
X-Gm-Message-State: APjAAAWFq160vvs1bgPGjQwk2etCbYzq1HnWZM4l+lM1f2cqUBTwbQyN
        YvdQTyFVOrDAJKrQQeM2ZV0lnQ==
X-Google-Smtp-Source: APXvYqxC9YiUwr5hsEC2BB/KlyWT6kwb5KhcaQw+5zzusx7rjcV4TeWdEoHli/nfGYhXiSqdu/Y+Aw==
X-Received: by 2002:adf:8183:: with SMTP id 3mr29119354wra.181.1563191747594;
        Mon, 15 Jul 2019 04:55:47 -0700 (PDT)
Received: from [192.168.178.40] ([151.20.129.151])
        by smtp.gmail.com with ESMTPSA id b5sm13437570wru.69.2019.07.15.04.55.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 04:55:46 -0700 (PDT)
Subject: Re: [PATCH] kvm: vmx: fix coccinelle warnings
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn
References: <1563165317-5996-1-git-send-email-wang.yi59@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a29ec5f9-2f35-5d85-a321-002315591c66@redhat.com>
Date:   Mon, 15 Jul 2019 13:55:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1563165317-5996-1-git-send-email-wang.yi59@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/19 06:35, Yi Wang wrote:
> This fixes the following coccinelle warning:
> 
> WARNING: return of 0/1 in function 'vmx_need_emulation_on_page_fault'
> with return type bool
> 
> Return false instead of 0.
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d98eac3..8b5f352 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7418,7 +7418,7 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)
>  
>  static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>  {
> -	return 0;
> +	return false;
>  }
>  
>  static __init int hardware_setup(void)
> 

Queued, thanks.

Paolo
