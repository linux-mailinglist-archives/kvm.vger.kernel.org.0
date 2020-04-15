Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D252D1AAB1B
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371195AbgDOO45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:56:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29083 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S371184AbgDOO4w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 10:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586962611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4LhKDhow9t4woo07RzJCC9BA6orwImyFYcMaIKVNQYo=;
        b=TzqRs97VvVnPF1S/AUh13ioMLeQ+2iWNapgWA/qMtVTQogIHTWlYRMayXL1P/Azjqrc+z9
        bkLB6JVbNaFo7UEdw7jpC9/n071MGzLyBd6/4FwsOhf186JuOlQ9AAUv34oDfvvehTTE0k
        b/UvUI3cmZWVbpRHPbDoRA+RwaawNZI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-z2JEMy0tP_OgzcxcSlsrcA-1; Wed, 15 Apr 2020 10:56:49 -0400
X-MC-Unique: z2JEMy0tP_OgzcxcSlsrcA-1
Received: by mail-wr1-f72.google.com with SMTP id m15so52259wrb.0
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:56:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4LhKDhow9t4woo07RzJCC9BA6orwImyFYcMaIKVNQYo=;
        b=tCg4xGEkPHl9kAYjaGAo8Yxhg/dVSoqwx99vud/RwtYJclk+/9N+THYFdy2nsIWiXL
         LKHARsCBRDAeevS1QkguThEj/0fdpFuXK8RGNSkgFggmb5Fq0f8hK6VO0fZTVTC0n0K1
         83esSMww7GaWobmI3dnIC7vQgngubhCNZ7guGGl2zwtbjFGh1AYyWO9ZR3BtQku9MobJ
         oaytzA/5lCRkKBt0jIGva07IYsOQrPErJAt7uMywVKX+AXhGU2eHA/FHShUim5XIQtVU
         u7pKsc4t08t8W/tb06Lh7OG/GCE31FFSnhGX7b+lOfI+Pf72f5ItU6S2i9DzzNjq1nyn
         jLLA==
X-Gm-Message-State: AGi0Pubiu0K40A2w5QeQKl0bdLeyVAVQ8I20yeF2OjHbkBPl7vfWQQIS
        BS/mTZpdTir4uH2o7vkJeXrHBS4CLe1iqZzbFZ0lgsvkh1IHmy62N2ePAnzyzH3jzS2xnC0qIAz
        1wDuYjrFAFq5u
X-Received: by 2002:a1c:3281:: with SMTP id y123mr5590631wmy.30.1586962608040;
        Wed, 15 Apr 2020 07:56:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypJjilpHVeNKifN5eFrDuYwLsxn/vAfdpiQUm+CsSSmPNw/ELDy1FSOfPgEWE/zxFxJRvEgZQg==
X-Received: by 2002:a1c:3281:: with SMTP id y123mr5590604wmy.30.1586962607784;
        Wed, 15 Apr 2020 07:56:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id n124sm23657617wma.11.2020.04.15.07.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:56:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: remove redundant assignment to variable r
To:     Colin King <colin.king@canonical.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200410113526.13822-1-colin.king@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6d66cb24-b517-1bc3-15c3-9b302215febf@redhat.com>
Date:   Wed, 15 Apr 2020 16:56:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200410113526.13822-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/04/20 13:35, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable r is being assigned  with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  virt/kvm/kvm_main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 74bdb7bf3295..03571f6acaa8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3160,7 +3160,6 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  	case KVM_SET_REGS: {
>  		struct kvm_regs *kvm_regs;
>  
> -		r = -ENOMEM;
>  		kvm_regs = memdup_user(argp, sizeof(*kvm_regs));
>  		if (IS_ERR(kvm_regs)) {
>  			r = PTR_ERR(kvm_regs);
> 

Queued, thanks.

Paolo

