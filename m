Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422E21AAC15
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414825AbgDOPls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 11:41:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43811 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1414823AbgDOPlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 11:41:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586965301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3B1ruDDXVDDi/ji3IEtUd9Ix/gIz7gwdh8lMNuynw3Q=;
        b=Wee9MkHaYDjU98azQXsjd25y5iE3JMP5lcy0MITgBo89l6Py+cgE2Vp2TLdVDzbgLnbZvM
        eODHXDELGNT1jXOyUr227KGc0mM6Z4KZZzi2SH4AB9Vj92tlVjY730hlpRUct9N+Moxh86
        JrDh5fXLXgoc5yvz3M/E96RXAVht704=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-xhWiIjkVNzKLLQYWUMRNQw-1; Wed, 15 Apr 2020 11:41:38 -0400
X-MC-Unique: xhWiIjkVNzKLLQYWUMRNQw-1
Received: by mail-wm1-f69.google.com with SMTP id h184so11368wmf.5
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 08:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3B1ruDDXVDDi/ji3IEtUd9Ix/gIz7gwdh8lMNuynw3Q=;
        b=PQNYjvwvSzWhJv/UMbsDlLPBjzRRQyHZbBAvEZyhygs/9n+EbHzpues9aM9Uu4xC8N
         BDFERyJuIYznJ9NlhNaC8bFCf384BwkCYTEUTBlcsL/03kxKUQvF7hxjX+WahfbHDF+O
         dSEK1dOPXePYSDzF2ZriwJZy9ZXAE89uwNq+C/m18L8pxSPdW50xD1lfw0BGvhAgtUAN
         gc5qJ3bUOm7tsxFToaab+rbqJH6KW01PCQ6VD6emGz9+c2Qf+5TrRMCvt4P+Dteca+nV
         2PfRkmJS78oQuVfjHVgIanUA4SiMItq5pLor3hz3ZZkTn5ZHRuL7awFAfgKDs/WZmZIY
         ppvA==
X-Gm-Message-State: AGi0Pub8ZadvoQ7g5MW06k2muwdUSYUkj9IJt/trtmNo4r4H7xpJLhGe
        75idr52/yj9cE4KzAQzKoS9y9CCs6wHkOVBee3Lwr9tsvTPeTVc6XXXRqWCmPYX2uJ6X5Hu3eSH
        FZnBYkcQieVRm
X-Received: by 2002:a1c:9aca:: with SMTP id c193mr5635893wme.38.1586965297355;
        Wed, 15 Apr 2020 08:41:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypL9riVxSoisEQbAahN5V9H3HK8llrDgxYcKIozN20ra2PpaVi3ncyaZ0lIUP+nnMFsBpx4YdQ==
X-Received: by 2002:a1c:9aca:: with SMTP id c193mr5635871wme.38.1586965297127;
        Wed, 15 Apr 2020 08:41:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id o28sm9239255wra.84.2020.04.15.08.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 08:41:36 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Fix __svm_vcpu_run declaration.
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
References: <20200409114926.1407442-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <67ffabb6-0b29-0a18-1c9e-6296b4da1629@redhat.com>
Date:   Wed, 15 Apr 2020 17:41:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200409114926.1407442-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 13:49, Uros Bizjak wrote:
> The function returns no value.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: 199cd1d7b534 ("KVM: SVM: Split svm_vcpu_run inline assembly to separate file")
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2be5bbae3a40..061d19e69c73 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3276,7 +3276,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  	svm_complete_interrupts(svm);
>  }
>  
> -bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
> +void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
>  
>  static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  {
> 

Queued, thanks.

Paolo

