Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5ECD1AAADD
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 16:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370997AbgDOOv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:51:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25917 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S371005AbgDOOvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 10:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586962282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=leZSjE43uAL/Ie9a6Mr56ke5RJoF9DAfX4lyVbbPA7o=;
        b=GXaY8z+Y5mVKVlXaS1OWOZQVuW7O1HBQlHXNUYzDjjyVy93r4lGQHaMaZS+F6iP1v3pO30
        muXBx3ZPSmLztTGJfFzs5ZfKuW7Pacfgs9s+guF7P6MYGBGJm6J6LKg25L3M6c6pB3P37A
        3ty0jqYcsY6CkryknguoaZ0Ym8qzW1M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-SOC3e4duNEC5RNNANoQXiQ-1; Wed, 15 Apr 2020 10:51:20 -0400
X-MC-Unique: SOC3e4duNEC5RNNANoQXiQ-1
Received: by mail-wr1-f70.google.com with SMTP id s11so35258wru.6
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:51:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=leZSjE43uAL/Ie9a6Mr56ke5RJoF9DAfX4lyVbbPA7o=;
        b=o0Tf7AKZQSGXKWhcGSYLJWvSnDS6TW2aU5pHWOepGS9MCWVolZ5wqa6c0FryvcJgTm
         232nfrJWFlQyL2o907fW/adDz6YVsdXQMEHrQT3jAu4jrVupeuYEdvyZKBFNEbnoR+er
         u6OkPBu1hbjkPUByTirHAo4ZZqlyHgaIqtQfdsABRCIbITAaRnG6LSUP8IP1s3UYByNK
         0/wRwttBLmdIXDtBkBszc6EqZhGaCnpcs1bmDRcR9n3nvsV/WZ6cLrfqO5w+lQrIHKr2
         XSOGEHnxHzEGLdr7kqOlK3XxGThZ9mBHYb1bM/B8MsroudQ3Qui3jh2KbVq0aTR3uWcJ
         T/Eg==
X-Gm-Message-State: AGi0PuaCwwxXcavpQYC39XXwB1Emf1m5n8NzKXg7mFg6zNiSEhs9VIx4
        sW93r1dc2eohCxDbZoByrYK+FZ6zozVIBFt9EofNICsP/MigP2ZGJU+U/lcXyOOiEVOOjTeJYXS
        +ejJZvhMGPB92
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr5809362wml.151.1586962279613;
        Wed, 15 Apr 2020 07:51:19 -0700 (PDT)
X-Google-Smtp-Source: APiQypLqi6exgMIjPz9xAvUDGG95jM80TJKbHiIMU+SVZ5FaaWnrTlZ0fNKxib6hxZ4HXThXRokDwA==
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr5809344wml.151.1586962279391;
        Wed, 15 Apr 2020 07:51:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id r2sm23461261wmg.2.2020.04.15.07.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:51:19 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Do not mark svm_vcpu_run with
 STACK_FRAME_NON_STANDARD
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
References: <20200414113612.104501-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1e91fe27-bdf9-2fd6-3136-3f276d4a3c21@redhat.com>
Date:   Wed, 15 Apr 2020 16:51:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200414113612.104501-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/20 13:36, Uros Bizjak wrote:
> svm_vcpu_run does not change stack or frame pointer anymore.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/svm/svm.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cd773f6261e3..200962c83b82 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3427,7 +3427,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	mark_all_clean(svm->vmcb);
>  }
> -STACK_FRAME_NON_STANDARD(svm_vcpu_run);
>  
>  static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
>  {
> 

Queued, thanks.

Paolo

