Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06021AAC16
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414833AbgDOPmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 11:42:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38912 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1414823AbgDOPmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 11:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586965321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0G4S1PaQKYa3ePwXaiTKMbfVRHeiEwaKWgbj3Tl9LwM=;
        b=E1oOo0hsxaMEHBOp393nQ4irSE4EHTSmWGIIHda4j5m+zgBKmzBnkbPASgyXa3+XmCwVgF
        xPUI+RrnB/QtMldNtQzfOfLswQOBhDWcmSKDENPyt9k5kTNh54AW4TPD+fR9OWsPDMqo6v
        05jffkE/GiyCkTPLk6oJozISNCK9B0g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-Of1_Za4jOJWvVazPaEMA9g-1; Wed, 15 Apr 2020 11:41:59 -0400
X-MC-Unique: Of1_Za4jOJWvVazPaEMA9g-1
Received: by mail-wr1-f72.google.com with SMTP id t8so87771wrq.22
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 08:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0G4S1PaQKYa3ePwXaiTKMbfVRHeiEwaKWgbj3Tl9LwM=;
        b=cg67rKywU8Lk8CymVngz3JJSSgbtI550Zrox/Go8Pmd2fk3uFsvetWDpTnUVrnZDX6
         SDq2Y0bkGZLCTrdx8uYw3Vk/hAGCr1w6uF+ZzxS2fJKwW3G/PmbTRtOLugwtAZ7iEcTi
         k7mhsjRQVAbxdzJUTVZcZXA+2YPY5wz078N5wr0OyHIOCxmLHaHW/GObVnXYhVwaW09G
         EASJaKB5TjGoOfcCW+XKO+dFTVmyoD2KBMKe9wGuBfX/vHjOT8mJ6XQtBb5Sg4TBJyWf
         wU4NcyDHS/VI8/7QE9XJIF4bO9n/6QABzixM3LPEPYB/s1CcwDBr62vYpFySmWDCte1E
         Xk8w==
X-Gm-Message-State: AGi0PuakAaC2jYRELeDk0k45EJKyBDl+GLrI+IJDLD/FPTYAUTwt9pnT
        Ker25v7O9neHbWS9truz70ghvnvlNf/V4HMW+j/Gt5bqArT/DPipb2is7abNOc44vNZ3ge9dvio
        uJee5pTkhUMNM
X-Received: by 2002:adf:82cf:: with SMTP id 73mr29226814wrc.411.1586965318304;
        Wed, 15 Apr 2020 08:41:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypJu8NyHHzqFA9/k30Axnxg4wxxQih8x0nEvy4xZ95n170HB1WfjTk4hnYJokbYaLGrwouIYYg==
X-Received: by 2002:adf:82cf:: with SMTP id 73mr29226802wrc.411.1586965318082;
        Wed, 15 Apr 2020 08:41:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id f83sm23426087wmf.42.2020.04.15.08.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 08:41:57 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Do not setup frame pointer in __svm_vcpu_run
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
References: <20200409120440.1427215-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fed42ef5-71aa-1d2f-9599-de3d8ff44ae6@redhat.com>
Date:   Wed, 15 Apr 2020 17:41:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200409120440.1427215-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 14:04, Uros Bizjak wrote:
> __svm_vcpu_run is a leaf function and does not need
> a frame pointer.  %rbp is also destroyed a few instructions
> later when guest registers are loaded.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/svm/vmenter.S | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index fa1af90067e9..c87119a7a0c9 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -35,7 +35,6 @@
>   */
>  SYM_FUNC_START(__svm_vcpu_run)
>  	push %_ASM_BP
> -	mov  %_ASM_SP, %_ASM_BP
>  #ifdef CONFIG_X86_64
>  	push %r15
>  	push %r14
> 

Queued, thanks.

Paolo

