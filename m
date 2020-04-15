Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7341AAADB
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 16:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370986AbgDOOuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:50:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38883 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S370969AbgDOOut (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 10:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586962248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CfwnmYMAxkw+iuYFdVJw7VR5RUUAeLW4OT5nezamaG4=;
        b=jLv1mHc4Fy306hfpvsVmWtzjbj98ZcCYaBkjwaQ2YMSVl91LlF0BMQbZd66ZUPw9zl/zzy
        nXN5wePL+zqkz3VwI3GnBQzUDYbnWsp+khCBtdMW34aLOSseK18cPGLAlZUUhP69z/CQME
        BOemE19yJCiQv1p5AdxmaLPgGymUN+M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-dbLWtQGUPwaFeLlWv88BXg-1; Wed, 15 Apr 2020 10:50:46 -0400
X-MC-Unique: dbLWtQGUPwaFeLlWv88BXg-1
Received: by mail-wm1-f71.google.com with SMTP id o26so5055505wmh.1
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:50:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CfwnmYMAxkw+iuYFdVJw7VR5RUUAeLW4OT5nezamaG4=;
        b=tiSix89GWC1p8RdAZuI0/FZAZOQqxExxrzEI6o/lfh4xB0wcBRC98nVlZv75sOQeuw
         YQ0wA5Jr9LRCtMQKtliLVjS0vbAZrb4TgNO/lr+1yU7/wrH7NoLTnzeqKfFUte0WQyB7
         UYGPa6bIeZ6QO0QEXAk0GeSiJnA7KV6VCSWkegSVX680CJ9Z3xlgfUaRbfadoQh9YIMi
         Tw3kMaEx5s/rBbYrtrAhxL2DGqilLfur4GSN2K9zB3bMjly6KjbQPxshR2lHVC0aSQ/X
         IwWBTfJslwCJaZuDe+Bmzqy+Kw81qwKZC3qaeKMj6awdcyVpDhEnx4X+zhBAHJe5W/ZV
         aT8A==
X-Gm-Message-State: AGi0PuYB5xKDawULoyKKbQXjCIGpSsLhqFbjgVugaAwF2QL6dC1GRw64
        M29NVMZ5ow2yZsYsa7+6pFP64DoD26zakS6fLECCUSp/rvYroc/NT4AIvxIGE3y2wEOiI5PGqMO
        vUOC8/BMT+amZ
X-Received: by 2002:adf:fe45:: with SMTP id m5mr22009056wrs.124.1586962245485;
        Wed, 15 Apr 2020 07:50:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypLhQzuCWazAs6mIGiC2s+Dl6hNNJt7KyyH3w6YOkolQg6Vkyis/lFpNj02WU/berwThyTIAIw==
X-Received: by 2002:adf:fe45:: with SMTP id m5mr22009040wrs.124.1586962245265;
        Wed, 15 Apr 2020 07:50:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id c20sm24342426wmd.36.2020.04.15.07.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:50:44 -0700 (PDT)
Subject: Re: [PATCH] kvm: nVMX: match comment with return type for
 nested_vmx_exit_reflected
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
References: <20200414221241.134103-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <733cd06d-2e16-4f95-3ba9-776b5f0cf28d@redhat.com>
Date:   Wed, 15 Apr 2020 16:50:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200414221241.134103-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 00:12, Oliver Upton wrote:
> nested_vmx_exit_reflected() returns a bool, not int. As such, refer to
> the return values as true/false in the comment instead of 1/0.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cbc9ea2de28f9..2ca53dc362731 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5534,7 +5534,7 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
>  }
>  
>  /*
> - * Return 1 if we should exit from L2 to L1 to handle an exit, or 0 if we
> + * Return true if we should exit from L2 to L1 to handle an exit, or false if we
>   * should handle it ourselves in L0 (and then continue L2). Only call this
>   * when in is_guest_mode (L2).
>   */
> 

Queued, thanks.

Paolo

