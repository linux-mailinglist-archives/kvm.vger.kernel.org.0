Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB7F1DB9B2
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 18:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgETQge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 12:36:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45390 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726545AbgETQgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 12:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589992591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XqYJ7uIrOlC74lzjdNx8dKV0aihb2Jm3KW9U6dMtg04=;
        b=bZHwRfYPPdOdAx/X+YbAUqhDqyRTYoNRq1xzYcgkaWyRZJeGEBUpSwJEnUu3xHzxikfHaM
        G3tdfCxTjyWsyNgsrr+XyhcxN7ca2BCRPI6vqa/gUcUs86Wjrs7fQMYHnbe2yzryIC+ebq
        uGh67YI/6K1HrLw6WpVrwWlrrKd+Orw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-pkiNeCewM6-OvML0nwO8Wg-1; Wed, 20 May 2020 12:36:27 -0400
X-MC-Unique: pkiNeCewM6-OvML0nwO8Wg-1
Received: by mail-ej1-f72.google.com with SMTP id gl5so1583435ejb.5
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 09:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XqYJ7uIrOlC74lzjdNx8dKV0aihb2Jm3KW9U6dMtg04=;
        b=tMxU0crTuyMyuUl6bUfUw/7amaAHaexLVZvOktdEB0UJ0bzQW6ZUytzD4ymiLGVOBz
         WJV05zHZnKmuFgL3KEVJragr/LM2hcLRaxIoimMBpkE86KoMps40O4qO455ePnFx6JrW
         YCdN+SooHcuiMogNicsZMh8zzzzN5mh+k8y1fBzFTcVJG3zeGOKeyfgrTsz3u+uq+eJp
         cj77JM28vtCl3QNPD4aRT2F9zCXRIK7u2JIaqBnc06yz3B49VodIjy9d7tGbq/GjUGrx
         uyd9kmZ7FZ30R/yAEiQksiwfPpaTL6awCC0YUBU3Mw1b08F6lt41fPPlAJ4bylx0jdep
         6QFg==
X-Gm-Message-State: AOAM530dqlpcekdaXKL68SYRBCQfrhdXzQ5w/sqYB8uCWYeWusjcDdiJ
        PvGebJZnLIohe9y+3jmbdIFYxeoIqK6dQNXVvRIGSq/QU4UuQjxxbiajK10uT1aYNW8wXuvdv56
        TinmOhqW2vUfn
X-Received: by 2002:a05:6402:b2c:: with SMTP id bo12mr4351603edb.274.1589992586282;
        Wed, 20 May 2020 09:36:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzTlJNPnR4mbBk6k3pUd+KxeZ1wVjVSLPLcjUKURZtkun7XyhyGpaFHeuQWElBl88fdngySQ==
X-Received: by 2002:a05:6402:b2c:: with SMTP id bo12mr4351587edb.274.1589992586118;
        Wed, 20 May 2020 09:36:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u20sm2215506edy.80.2020.05.20.09.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 09:36:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     oupton@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: allow KVM_STATE_NESTED_MTF_PENDING in kvm_state flags
In-Reply-To: <20200519180743.89974-1-pbonzini@redhat.com>
References: <20200519180743.89974-1-pbonzini@redhat.com>
Date:   Wed, 20 May 2020 18:36:24 +0200
Message-ID: <871rnetvg7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> The migration functionality was left incomplete in commit 5ef8acbdd687
> ("KVM: nVMX: Emulate MTF when performing instruction emulation", 2020-02-23),
> fix it.
>
> Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4f55a44951c3..0001b2addc66 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4626,7 +4626,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  
>  		if (kvm_state.flags &
>  		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
> -		      | KVM_STATE_NESTED_EVMCS))
> +		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_MTF_PENDING))
>  			break;
>  
>  		/* nested_run_pending implies guest_mode.  */

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

